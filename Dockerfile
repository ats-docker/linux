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
ARG ATS_VERSION="2.9.7"

ENV ATS_VERSION=$ATS_VERSION
ENV JASPER_HOME=${ATS_TOOLS}jasper
ENV ATS_HOME=${ATS_USER_HOME}ats/cache/$ATS_VERSION

#Get Maven dependencies used by ATS projects
RUN echo "<settings><localRepository>${MAVEN_LOCAL_REPO}</localRepository></settings>" > /opt/maven/settings.xml
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=com.actiontestscript:ats-automated-testing:$ATS_VERSION
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.codehaus.mojo:exec-maven-plugin:3.1.0
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.codehaus.mojo:properties-maven-plugin:1.1.0
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.plugins:maven-resources-plugin:3.3.1
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.plugins:maven-compiler-plugin:3.11.0
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=commons-io:commons-io:2.6
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.plugins:maven-surefire-plugin:3.1.2
RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=org.apache.maven.surefire:surefire-testng:3.1.2

RUN echo "<settings><offline>true</offline><localRepository>${MAVEN_LOCAL_REPO}</localRepository></settings>" > /opt/maven/settings.xml

#Install Ats Components
RUN mkdir -p ${ATS_CACHE}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers \
  && wget -O /tmp/ld.tgz ${DOWNLOAD_WEB}${PATH_DRIVERS}$(wget -qO- "${DOWNLOAD_WEB}${PATH_DRIVERS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1).tgz \
  && tar -xzvf /tmp/ld.tgz -C ${ATS_CACHE}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers \
  && rm -rf /tmp/* 

RUN mkdir -p ${ATS_CACHE}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/libs \
  && wget -O /tmp/atslibs.zip ${DOWNLOAD_WEB}${PATH_LIBS}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1).zip \
  && unzip /tmp/atslibs.zip -d ${ATS_CACHE}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/libs \
  && rm -rf /tmp/* 

RUN mkdir -p ${ATS_TOOLS}jasper-$(wget -qO- "${DOWNLOAD_WEB}${PATH_TOOLS_JASPER}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1) \
  && wget -O /tmp/jasper.zip ${DOWNLOAD_WEB}${PATH_TOOLS_JASPER}$(wget -qO- "${DOWNLOAD_WEB}${PATH_TOOLS_JASPER}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1).zip \
  && unzip /tmp/jasper.zip -d ${ATS_TOOLS}jasper \
  && rm -rf /tmp/* 

RUN ln -s ${JAVA_HOME} ${ATS_TOOLS}/jdk

RUN export ATS_VERSION=$(wget -qO- "${DOWNLOAD_WEB}${PATH_DRIVERS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)

RUN mkdir -p ${ATS_PROFILES} && mkdir -p ${ATS_PROJECTS} && mkdir -p ${ATS_OUTPUTS}
RUN chown -R 1000:1000 ${ATS_USER_HOME}
  
USER ats-user
#RUN echo "export ATS_VERSION=$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)" >> ${ATS_USER_HOME}.bashrc

RUN cd ${ATS_CACHE}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers && ./linuxdriver --allWebDriver=true

RUN rm -r -f ${MAVEN_LOCAL_REPO}/dom4j
RUN rm -r -f ${MAVEN_LOCAL_REPO}/org/apache/maven/shared/maven-shared-utils/3.1.0

WORKDIR ${ATS_PROJECTS}