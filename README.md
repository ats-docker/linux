# ActionTestScript test execution with Linux image

**For more [Examples and details](https://gitlab.com/actiontestscript/ats-core#docker-integration)**

## Quick Start with ATS Git project

Open a PowerShell console, create a test folder and change to this directory, you can now run the following commands:

#### Using AtsLauncher

```
docker run --rm -it -v ${PWD}\target:/home/ats-user/ats-test actiontestscript/linux sh -c "git clone https://gitlab.com/actiontestscript/ats-test.git . && java AtsLauncher.java output=/home/ats-user/ats-test/ats-output outbound=false atsreport=3 suiteXmlFiles=demo"
```
> Reports and result files will be created in ***target/ats-output*** folder

#### Using Maven

```
docker run --rm -it -v ${PWD}\target:/home/ats-user/outputs actiontestscript/linux sh -c "git clone https://gitlab.com/actiontestscript/ats-test.git /home/ats-user/temp/ && cp -r /home/ats-user/temp/* /home/ats-user/projects && cd /home/ats-user/projects && mvn clean test -Doutbound=false -Dats-report=3 -Dsurefire.suiteXmlFiles=src/exec/demo.xml -Doutput=/home/ats-user/outputs"
```
> Reports and result files will be created in ***target/surefire-reports*** folder

<br>

## Quick Start with local ATS project

Open a PowerShell console and change to an ATS project directory, you can now run the following commands:

#### Using AtsLauncher

```
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux sh -c "java AtsLauncher.java outbound=false atsreport=3 suiteXmlFiles=demo"
```

_(You can run the tests using the CMD console too)_
```
docker run --rm -it -v %cd%:/home/ats-user/ats-project actiontestscript/linux sh -c "java AtsLauncher.java outbound=false atsreport=3 suiteXmlFiles=demo"
```


> Reports and result files will be created in ***target/ats-output*** folder

#### Using Maven

```
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux sh -c "cd /home/ats-user/ats-project && mvn clean test -Doutbound=false -Dats-report=3 -Dsurefire.suiteXmlFiles=src/exec/demo.xml"
```
> Reports and result files will be created in ***target/surefire-reports*** folder

## Docker file :
- [ATS execution](https://github.com/ats-docker/linux.git)  (this image)

#### Others images :
- [linux base](https://github.com/ats-docker/linux-base.git) : ` docker pull actiontestscript/linux-base `
- [linux browsers](https://github.com/ats-docker/linux-browsers.git) : ` docker pull actiontestscript/linux-browsers `
- [ActionTestScript Docker images on Windows](https://hub.docker.com/r/actiontestscript/windows)

## Description
ATS Docker Linux image ready to launch ATS tests suite executions *([ActionTestScript](https://actiontestscript.com) is an open source project)*

It build from actiontestscript/linux-browsers. It contains the following packages:

  - ATS java libs
  - ATS linuxdriver
  - ATS maven dependencies
  - geckodriver
  - chromedriver
  - edgedriver
  - operadriver
  - bravedriver
  - jasper
