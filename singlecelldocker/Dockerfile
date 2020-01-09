#LABEL maintainer="Combiz Khozoie, Ph.D. c.khozoie@imperial.ac.uk"

FROM rocker/rstudio

RUN apt-get update

# install packages 
RUN apt-get update && apt-get install \
  -y --no-install-recommends python3 python3-virtualenv curl
RUN apt-get -y install libcurl4-openssl-dev
RUN apt-get -y install libjpeg62-turbo-dev
RUN apt-get -y install libpng-dev
RUN apt-get -y install libgsl-dev
RUN apt-get -y install libx11-dev libglu1-mesa-dev libfreetype6-dev
RUN apt-get -y install libssl-dev
RUN apt-get -y install python3-pip
RUN apt-get -y install openmpi-bin
RUN apt-get -y install libhdf5-dev
RUN apt-get -y install libcairo2-dev libxt-dev
RUN apt-get -y install libudunits2-dev
RUN apt-get -y install libgdal-dev
RUN apt-get -y install --fix-missing gdb libxml2-dev libmariadb-client-lgpl-dev

#RUN apt-get -y install build-dep r-cran-rmpi

#RUN R CMD INSTALL Rmpi --configure-args=--with-mpi=/usr/lib/openmpi

# needed for UMAP
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m virtualenv --python=/usr/bin/python3 $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# install miniconda

RUN mkdir ~/.conda

RUN curl -o ~/miniconda.sh -O  https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh  && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
    /opt/conda/bin/conda install conda-build

ENV PATH=$PATH:/opt/conda/bin:$PATH
ENV USER singlecell

# create environment
COPY environment.yml environment.yml
RUN conda env create -f environment.yml
RUN conda clean -ya

ENV PATH=$PATH:/opt/conda/envs/singlecell/bin:$PATH

# activate source
CMD conda activate singlecell
CMD source activate singlecell

# quick fix for environment.yml issues
CMD echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

# Install R packages
# do this manually instead of in bulk to generate multiple layers
COPY ./requirements.R /tmp/requirements.R 
COPY ./rpackages.yml /tmp/
RUN Rscript /tmp/requirements.R CRAN
RUN Rscript /tmp/requirements.R Bioconductor
RUN Rscript /tmp/requirements.R Github

# create an R user
ENV USER rstudio

## uncomment to include shiny server
RUN export ADD=shiny && bash /etc/cont-init.d/add

#cleanup
RUN rm -rf /tmp/downloaded_packages/ /tmp/*.rds


EXPOSE 8787


CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0", "--server-app-armor-enabled=0"]
