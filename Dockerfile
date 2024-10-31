# Dockerfile
# syntax=docker/dockerfile:1
FROM actiontestscript/linux-browsers

ARG DOWNLOAD_WEB=https://actiontestscript.org/

ARG ATS_PROJECTS=${ATS_USER_HOME}projects/
ARG ATS_OUTPUTS=${ATS_USER_HOME}outputs/
ARG ATS_CACHE=${ATS_USER_HOME}ats/cache/
ARG ATS_PROFILES=${ATS_USER_HOME}ats/profiles/

ARG PATH_DRIVERS=releases/ats-drivers/linux/system/
ARG PATH_LIBS=releases/ats-libs/
ARG PATH_TOOLS_LIBS=tools/jdk/linux/

#-------------------------------------------------------------#
#  Ats components versions
#-------------------------------------------------------------#
ARG ATS_LIB_VERSION="3.3.3"
ARG ATS_DRIVER_VERSION="1.8.6"
#-------------------------------------------------------------#

ENV ATS_VERSION=$ATS_LIB_VERSION
ENV ATS_DRIVER_VERSION=$ATS_DRIVER_VERSION
ENV ATS_CACHE=$ATS_CACHE
ENV ATS_TOOLS=${ATS_USER_HOME}ats/tools/
ENV ATS_HOME=${ATS_USER_HOME}ats/cache/$ATS_LIB_VERSION

#RUN mvn dependency:get -Dmaven.repo.local=${MAVEN_LOCAL_REPO} -DremoteRepositories=https://repo1.maven.org/maven2 -Dartifact=com.actiontestscript:ats-automated-testing:$ATS_LIB_VERSION

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

RUN cd ${ATS_CACHE}${ATS_LIB_VERSION}/drivers  \
&& ./linuxdriver --allWebDriver=true 
 
RUN mkdir -p ${ATS_PROFILES} && mkdir -p ${ATS_PROJECTS} && mkdir -p ${ATS_OUTPUTS} 

RUN chown -R ${ATS_USER}:${ATS_GROUP} ${ATS_USER_HOME}

ARG START_MESSAGE="Start ATS-Docker with user: $(whoami)"

ENV ENV=/etc/env.sh

RUN rm -rf /home/${ATS_USER}/.m2
RUN rm -rf /dom4j

RUN echo echo ${START_MESSAGE} >> "${ENV}"
RUN echo echo ${START_MESSAGE} >> .bashrc
RUN echo echo ${START_MESSAGE} >> /home/ats-user/.bashrc

USER ats-user
WORKDIR /home/ats-user/ats-project/
