workflow scFlow {
  call prep_zeisel
}

task prep_zeisel {
    File inputFile
    File outputFile
    command {
        split_celltypes.R ... -paramName ${paramValue}
    }
    output {
        File outputResultFile = "someFile"
    }
}


