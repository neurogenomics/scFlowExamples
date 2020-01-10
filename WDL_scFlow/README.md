To Use scFlow check_inputs.wdl
1. Create a Terra Workflow using check_inputs.wdl 
     - Terra Workflow -> Find a Workflow -> Broad Methods Repository -> Create new Method...)
2. Export your workflow to your Terra Workspace 
     - (Export to Workspace -> Create blank configuration)
3. Upload the data files to Terra Data areas 
    - Terra Data -> Files -> add Files -> blue +
    - Upload `samplesheet.tsv`, `manifest.txt` and `check_inputs.R` files to your workspace
4. Configure the workspace Inputs and SAVE 
    - Terra Workflow -> Inputs... -> click blue 'SAVE'
    - *`inputs.json` provided as a reference - your file paths will be workspace unique
5. Run the workflow 
   - Terra Workflow - > click blue 'Run Analysis'
   - Wait 6 minutes for first run to complete
        - subsequent workflow executions will use `call caching` and complete in < 1 min
6. Results will print in the 'STDOUT' log for the Job 
     - Terra Job Manager -> Job History -> View -> Links -> Execution Directory ->
         - Download 'STDOUT'