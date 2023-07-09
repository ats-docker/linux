# ActionTestScript test execution with Linux image

ATS Docker Linux image ready to launch ATS tests suite executions *([ActionTestScript](https://actiontestscript.com) is an open source project)*

## Quick Start with ATS Git project

Open a PowerShell console, create a test folder and change to this directory, you can now run the following commands:

#### Using AtsLauncher

```
docker run --rm -it -v ${PWD}\target:/home/ats-results actiontestscript/linux sh -c "git clone https://gitlab.com/actiontestscript/ats-test.git . && java AtsLauncher.java output=/home/ats-results/ats-output outbound=false atsreport=3 suiteXmlFiles=demo"
```
> Reports and result files will be created in **_target/ats-output_** folder

#### Using Maven

```
docker run --rm -it -v ${PWD}:/home/ats-user/ats-test actiontestscript/linux:latest sh -c "git clone https://gitlab.com/actiontestscript/ats-test.git /home/ats-user/temp/ && cp -r /home/ats-user/temp/* /home/ats-user/ats-test && cd /home/ats-user/ats-test && mvn clean test -Doutbound=false -Dats-report=3 -Dsurefire.suiteXmlFiles=src/exec/demo.xml"
```
> Reports and result files will be created in ***target/surefire-reports*** folder

<br>

## Quick Start with local ATS project

Open a PowerShell console and change to an ATS project directory, you can now run the following commands:

#### Using AtsLauncher

```
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux:latest sh -c "cd /home/ats-user/ats-project && java AtsLauncher.java outbound=false atsreport=3 suiteXmlFiles=demo"
```
> Reports and result files will be created in ***target/ats-output*** folder

#### Using Maven

```
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux:latest sh -c "cd /home/ats-user/ats-project && mvn clean test -Doutbound=false -Dats-report=3 -Dsurefire.suiteXmlFiles=src/exec/demo.xml"
```
> Reports and result files will be created in ***target/surefire-reports*** folder
