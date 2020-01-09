task verify_input { 
   
   command { 
      Rscript check_input.R --samplesheet /SamplesSheet.tsv --manifest /Manifest.txt
      }

   output { 
      File output_verification = "out.txt"
   }
   
   runtime { 
      docker: "plyteuth/r-tera-test:latest"
   }
}

workflow check_input {
   call verify_input   { 
     
      }
}