# Terra Workflow Dev Env Quick Start

## Dev Machine
- install Java SDK
- install Docker Tools
- download required Terra .jar files
    - cromwell-XY.jar - execution of WDL scripts 
        - use cromwell run mode
        - `XY` is cromwell version, i.e. 47, etc..
    - womtool.jar - WDL script linter
    - wdltool.jar - generates `inputs.json` files from WDL scripts
- start Docker daemon

## Development
- create WDL script 
- create parameters file `input.json` from WDL
    - `java -jar wdltool.jar inputs myWorkflow.wdl > myWorkflow_inputs.json`
- execute WDL script with cromwell, i.e. 
    - `java -jar cromwell-XY.jar run myWorkflow.wdl --inputs myWorkflow_inputs.json`

