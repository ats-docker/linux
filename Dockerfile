# Dockerfile
# syntax=docker/dockerfile:1
FROM actiontestscript/linux-browsers

ARG DOWNLOAD_WEB=https://actiontestscript.org/
ARG ATS_USER_HOME=/home/ats-user/
ARG ATS_PROJECTS=${ATS_USER_HOME}projects/
ARG ATS_OUTPUTS=${ATS_USER_HOME}outputs/
ARG ATS_CACHE=${ATS_USER_HOME}ats/cache/
ARG ATS_PROFILES=${ATS_USER_HOME}ats/profiles/
ARG MAVEN_LOCAL_REPO=${ATS_USER_HOME}.m2/repository

RUN mkdir -p ${ATS_USER_HOME}
RUN groupadd -r ats-group && useradd --no-log-init -r -g ats-group ats-user

ARG PATH_DRIVERS=releases/ats-drivers/linux/system/
ARG PATH_LIBS=releases/ats-libs/
ARG PATH_TOOLS_LIBS=tools/jdk/linux/

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

#-------------------------------------------------------------#
#  Ats components versions
#-------------------------------------------------------------#
ARG ATS_LIB_VERSION="3.2.3"
ARG ATS_DRIVER_VERSION="1.8.1"
#-------------------------------------------------------------#

ENV ATS_VERSION=$ATS_LIB_VERSION
ENV ATS_TOOLS=${ATS_USER_HOME}ats/tools/
ENV ATS_HOME=${ATS_USER_HOME}ats/cache/$ATS_LIB_VERSION

RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=com.actiontestscript:ats-automated-testing:$ATS_LIB_VERSION

RUN echo "<settings><offline>true</offline><localRepository>${MAVEN_LOCAL_REPO}</localRepository></settings>" > /opt/maven/settings.xml

RUN rm -rf ${MAVEN_LOCAL_REPO}/dom4j 
RUN rm -rf ${MAVEN_LOCAL_REPO}/org/apache/maven/shared/maven-shared-utils/3.1.0

#Install Ats Components
RUN mkdir -p ${ATS_CACHE}${ATS_LIB_VERSION}/drivers \
  && curl -L -o /tmp/ld.tgz ${DOWNLOAD_WEB}${PATH_DRIVERS}${ATS_DRIVER_VERSION}.tgz \
  && tar -xzvf /tmp/ld.tgz -C ${ATS_CACHE}${ATS_LIB_VERSION}/drivers \
  && rm -rf /tmp/* 

RUN mkdir -p ${ATS_CACHE}${ATS_LIB_VERSION}/libs \
  && curl -L -o /tmp/atslibs.zip ${DOWNLOAD_WEB}${PATH_LIBS}${ATS_LIB_VERSION}.zip \
  && unzip /tmp/atslibs.zip -d ${ATS_CACHE}${ATS_LIB_VERSION}/libs \
  && rm -rf /tmp/* 

RUN mkdir -p ${ATS_TOOLS}
RUN ln -s ${JAVA_HOME} ${ATS_TOOLS}

RUN apt-get update \
&& apt-get install -y wget \
&& apt-get remove -y  \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN cd ${ATS_CACHE}${ATS_LIB_VERSION}/drivers  \
&& ./linuxdriver --allWebDriver=true 
 
RUN mkdir -p ${ATS_PROFILES} && mkdir -p ${ATS_PROJECTS} && mkdir -p ${ATS_OUTPUTS} 

RUN chown -R ats-user:ats-group /home/ats-user

ARG START_MESSAGE="Start ATS-Docker with user: $(whoami)"

ENV ENV /etc/env.sh
RUN echo echo ${START_MESSAGE} >> "${ENV}"
RUN echo echo ${START_MESSAGE} >> .bashrc
RUN echo echo ${START_MESSAGE} >> /home/ats-user/.bashrc

USER ats-user
WORKDIR /home/ats-user/ats-project
