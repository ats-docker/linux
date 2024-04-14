# Dockerfile
# syntax=docker/dockerfile:1
FROM actiontestscript/linux-browsers

ARG DOWNLOAD_WEB=https://actiontestscript.com/
ARG ATS_USER_HOME=/home/ats-user/
ARG ATS_PROJECTS=${ATS_USER_HOME}projects/
ARG ATS_OUTPUTS=${ATS_USER_HOME}outputs/
ARG ATS_CACHE=${ATS_USER_HOME}ats/cache/
ARG ATS_TOOLS=${ATS_USER_HOME}ats/tools/
ARG ATS_PROFILES=${ATS_USER_HOME}ats/profiles/
ARG MAVEN_LOCAL_REPO=${ATS_USER_HOME}.m2/repository

ARG PATH_DRIVERS=releases/ats-drivers/linux/system/
ARG PATH_LIBS=releases/ats-libs/
ARG PATH_TOOLS_LIBS=tools/jdk/linux/
ARG PATH_TOOLS_JASPER=tools/jasper/

#Get Maven dependencies used by ATS projects
RUN echo "<settings><localRepository>${MAVEN_LOCAL_REPO}</localRepository></settings>" > /opt/maven/settings.xml
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.codehaus.mojo:exec-maven-plugin:3.1.0
  RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.codehaus.mojo:properties-maven-plugin:1.1.0
    #RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.codehaus.mojo:properties-maven-plugin:1.2.0
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.plugins:maven-resources-plugin:3.3.1
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.plugins:maven-compiler-plugin:3.11.0
  #RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=commons-io:commons-io:2.6
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=commons-io:commons-io:2.13.0
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.plugins:maven-surefire-plugin:3.1.2
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.surefire:surefire-testng:3.1.2

ARG ATS_VERSION="3.2.2"

ENV ATS_VERSION=$ATS_VERSION
ENV JASPER_HOME=${ATS_TOOLS}jasper-6.19.1
ENV ATS_HOME=${ATS_USER_HOME}ats/cache/$ATS_VERSION

RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=com.actiontestscript:ats-automated-testing:$ATS_VERSION

RUN echo "<settings><offline>true</offline><localRepository>${MAVEN_LOCAL_REPO}</localRepository></settings>" > /opt/maven/settings.xml

RUN rm -rf ${MAVEN_LOCAL_REPO}/dom4j 
RUN rm -rf ${MAVEN_LOCAL_REPO}/org/apache/maven/shared/maven-shared-utils/3.1.0

#Install Ats Components
RUN mkdir -p ${ATS_CACHE}$(curl -s "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers \
  && curl -L -o /tmp/ld.tgz ${DOWNLOAD_WEB}${PATH_DRIVERS}$(curl -s "${DOWNLOAD_WEB}${PATH_DRIVERS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1).tgz \
  && tar -xzvf /tmp/ld.tgz -C ${ATS_CACHE}$(curl -s "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers \
  && rm -rf /tmp/* 

RUN mkdir -p ${ATS_CACHE}$(curl -s "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/libs \
  && curl -L -o /tmp/atslibs.zip ${DOWNLOAD_WEB}${PATH_LIBS}$(curl -s "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1).zip \
  && unzip /tmp/atslibs.zip -d ${ATS_CACHE}$(curl -s "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/libs \
  && rm -rf /tmp/* 

RUN mkdir -p ${ATS_TOOLS}jasper-6.19.1 \
  && curl -L -o /tmp/jasper.zip ${DOWNLOAD_WEB}${PATH_TOOLS_JASPER}$(curl -s "${DOWNLOAD_WEB}${PATH_TOOLS_JASPER}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1).zip \
  && unzip /tmp/jasper.zip -d ${ATS_TOOLS} \
  && rm -rf /tmp/* 

RUN ln -s ${JAVA_HOME} ${ATS_TOOLS}jdk-21.0.1

RUN apt-get update \
&& apt-get install -y wget \
&& apt-get remove -y  \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN chown -R ats-user:ats-user ${ATS_USER_HOME} 

USER ats-user
RUN cd ${ATS_CACHE}$(curl -s "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers  \
&& ./linuxdriver --allWebDriver=true 
 
RUN mkdir -p ${ATS_PROFILES} && mkdir -p ${ATS_PROJECTS} && mkdir -p ${ATS_OUTPUTS} 

WORKDIR ${ATS_PROJECTS}
