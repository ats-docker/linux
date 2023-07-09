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
ARG PATH_DRIVERS=releases/ats-drivers/linux/system/
ARG PATH_LIBS=releases/ats-libs/
ARG PATH_TOOLS_LIBS=tools/jdk/linux/
ARG PATH_TOOLS_JASPER=tools/jasper/
ARG ATS_VERSION=""
ENV ATS_VERSION=$ATS_VERSION

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
  && unzip /tmp/jasper.zip -d ${ATS_TOOLS}jasper-$(wget -qO- "${DOWNLOAD_WEB}${PATH_TOOLS_JASPER}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1) \
  && rm -rf /tmp/* 

RUN ln -s ${JAVA_HOME} ${ATS_TOOLS}/jdk

RUN export ATS_VERSION=$(wget -qO- "${DOWNLOAD_WEB}${PATH_DRIVERS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)

RUN mkdir -p ${ATS_PROFILES} && mkdir -p ${ATS_PROJECTS} && mkdir -p ${ATS_OUTPUTS}
RUN chown -R 1000:1000 ${ATS_USER_HOME}
  
USER ats-user
#RUN echo "export ATS_VERSION=$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)" >> ${ATS_USER_HOME}.bashrc

RUN cd ${ATS_CACHE}$(wget -qO- "${DOWNLOAD_WEB}${PATH_LIBS}" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -V | tail -n 1)/drivers && ./linuxdriver --allWebDriver=true

WORKDIR ${ATS_PROJECTS}