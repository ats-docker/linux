## ActionTestScript linux
---
Linux ATS base machine ready to launch ATS test suite execution

## Quick Start

Open a terminal PowerShell and run the following command:

```
docker run --rm -it -v ${PWD}\target-docker:/home/ats-results actiontestscript/linux:latest sh -c "git clone https://gitlab.com/actiontestscript/ats-test.git . && java AtsLauncher.java output=/home/ats-results/ats-output outbound=false atsreport=3 suiteXmlFiles=demo"
```
Reports and results file will be created in ***target-docker/ats-output*** folder

## Run in an ATS project

Open a terminal PowerShell and run the following command:

```
cd <ATS_PROJECT_PATH>
docker run --rm -it -v ${PWD}:/home/ats-user/ats-project actiontestscript/linux:latest sh -c "cd /home/ats-user/ats-project && java AtsLauncher.java outbound=false atsreport=3 suiteXmlFiles=demo"
```
Reports and results file will be created in ***target/ats-output*** folder