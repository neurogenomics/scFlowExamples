task verify_input { 
   File samplesheet
   File manifest
   File rscript
   File out

   command { 
      Rscript ${rscript} --samplesheet ${samplesheet} --manifest ${manifest}
   }

   output { 
      File output_verification = "${out}"
   }
   
   runtime { 
      docker: "combiz/singlecell-docker:latest"
   }
}

workflow check_input {
   File samplesheet
   File manifest
   File rscript
   File out

   call verify_input   { 
      input: out=out, rscript=rscript, samplesheet=samplesheet, manifest=manifest
   }
}