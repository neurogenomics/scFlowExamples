#### Singularity / Docker Image for Single-cell/nuclei RNA-Sequencing Pipeline on a High-Performance Computing Cluster

This docker image uses rocker/rstudio as a base and installs a range of additional bioinformatics tools for single-cell/nuclei RNA-seq analysis.  The docker-image can be seamlessly converted into a Singularity image for HPC.

Build with: -

```
docker build -t singlecell .
```

Optional: after building, run locally with: -

```
docker run --name ropensci -d singlecell
```

#### Uploading to Docker Hub

Optionally, the Docker image can be hosted on Docker hub by synchronizing a Dockerfile containing Github repo.  If the docker image can be built in under 2 hours, the build can be performed on the docker hub server.  

To upload a locally built image, first tag the image with the Docker hub repository, e.g.: -

```bash
docker tag singlecell combiz/singlecell-docker
```

Then login to docker.io: -

```bash
docker login docker.io
```

And push the built image to the repository: -

```bash
docker push combiz/singlecell-docker
```

#### Singularity image for HPC

To create a Singularity image, first archive the image into a tar file.  Obtain the `IMAGE_ID` with `docker images` then archive with (substituting the IMAGE_ID): -

```
 docker save 409ad1cbd54c -o singlecell.tar
```

On a system running singularity-container (>v3) (e.g. on the HPC cluster), generate the Singularity Image File (SIF) from the local tar file with: -

```
/usr/bin/singularity build singlecell.sif docker-archive://singlecell.tar
```

This `singlecell.sif` Singularity Image File is now ready to use.

#### Running a NextFlow Pipeline with a Singularity Container

To run a nextflow script inside the singularity container, pass the `singlecell.sif` as a parameter when running the script:  -

```
/rds/general/user/ckhozoie/home/opt/nextflow main.nf -with-singularity singlecell.sif 
```

For files generated inside the container to be saved on the HPC / made available to NextFlow, `singularity exec` (called by NF) should be passed the `-B` option to create a user-bind path of the format src:dest, where src and dest are the outside and inside paths.  In NF this can be specified inside a process with, for example,  `containerOptions '-B $PWD:/tmp'` which uses the process working directory (`$PWD`) as the outside path.  This is included in the example below.

A simple `main.nf` to check everything is working: -

```
#!/usr/bin/env nextflow

params.help = ""
params.outdir = "/rds/general/user/ckhozoie/ephemeral/NFOutput"

process test {
    echo true
    containerOptions '-B $PWD:/tmp' // process work dir is mounted to
                                    // the /tmp dir in the container 
    
    publishDir "${params.outdir}"

    output:
    file "test.csv"

    script:
    """
    #!Rscript --vanilla
    library(dplyr)
    library(MAST)
    
    print("Hello world")

    x <- c(1,2,3,4,5)
    df <- data.frame(x,x)
    write.table(df, file = "test.csv")
    
    """
}
```

Save this file as `main.nf` and run with (amending the path the NF as needed): -

 `/rds/general/user/ckhozoie/home/opt/nextflow main.nf -with-singularity singlecell.sif ` 

Note: To run NF on the HPC first `module load java` and `module load singularity`

Note: For actual work submit as a qjob.