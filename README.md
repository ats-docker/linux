## ActionTestScript with linux image
---
ATS Linux image ready to launch ATS tests suite execution

## Quick Start

Open a PowerShell console and run the following command :

```
docker run --rm -it -v ${PWD}\target-docker:/home/ats-results actiontestscript/linux:latest sh -c "git clone https://gitlab.com/actiontestscript/ats-test.git . && java AtsLauncher.java output=/home/ats-results/ats-output outbound=false atsreport=3 suiteXmlFiles=demo"
```
> Reports and result files will be created in **_target-docker/ats-output_** folder

## Run in an ATS project

Open a PowerShell console and run the following command :

```
cd <ATS_PROJECT_PATH>
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux:latest sh -c "cd /home/ats-user/ats-project && java AtsLauncher.java outbound=false atsreport=3 suiteXmlFiles=demo"
```
> Reports and result files will be created in ***target/ats-output*** folder

## Run in an ATS project with Maven

Open a PowerShell console and run the following command :

```
cd <ATS_PROJECT_PATH>
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux:latest sh -c "cd /home/ats-user/ats-project && mvn clean test -Doutbound=false -Dats-report=3 -Dsurefire.suiteXmlFiles=src/exec/demo.xml"
```
> Reports and result files will be created in ***target/surefire-reports*** folder
