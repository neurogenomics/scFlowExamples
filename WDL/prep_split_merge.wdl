workflow scFlow {
  call prep_zeisel,
  call split_celltypes,
  call merge_zeisal
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
task split_celltypes {
    File inputFile
    File outputFile
    command {
        split_celltypes.R ... -paramName ${paramValue}
    }
    output {
        File outputResultFile = "someFile"
    }
}
task merge_zeisal {
    File inputFile
    File outputFile
    command {
        split_celltypes.R ... -paramName ${paramValue}
    }
    output {
        File outputResultFile = "someFile"
    }
}

