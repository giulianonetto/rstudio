FROM rocker/tidyverse:4.2.0

MAINTAINER Giuliano Netto Flores Cruz

LABEL version="0.0.2"

# libxt-dev for Cairo
# libv8-dev for Stan
# libglpk for brms (I guess)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    libxt-dev \
    libv8-dev \
    libglpk-dev \
    libfftw3-dev \
    python3-pip \
    libcurl4-openssl-dev \
    libbz2-dev

# install CRAN packages

RUN R -e "devtools::install_version('ggpubr', version = '0.4.0', dependencies = T)"
RUN R -e "devtools::install_version('GGally', version = '2.1.2', dependencies = T)"
RUN R -e "devtools::install_version('ggbeeswarm', version = '0.6.0', dependencies = T)"
RUN R -e "devtools::install_version('latex2exp', version = '0.9.4', dependencies = T)"
RUN R -e "devtools::install_version('docstring', version = '1.0.0', dependencies = T)"
RUN R -e "devtools::install_version('lme4', version = '1.1.29', dependencies = T)"
RUN R -e "devtools::install_version('lmerTest', version = '3.1.3', dependencies = T)"
RUN R -e "devtools::install_version('rstatix', version = '0.7.0', dependencies = T)"
RUN R -e "devtools::install_version('plotly', version = '4.10.0', dependencies = T)"
RUN R -e "devtools::install_version('brms', version = '2.17')"
RUN R -e "devtools::install_version('tidybayes', version = '3.0.2')"
RUN R -e "devtools::install_version('projpred', version = '2.1.1')"
RUN R -e "install.packages('cmdstanr', repos = c('https://mc-stan.org/r-packages/', getOption('repos')))"
RUN R -e "cmdstanr::install_cmdstan(cores = 4)"
RUN R -e "devtools::install_version('StanHeaders', version = '2.21.0.7')"
RUN R -e "devtools::install_version('rstan', version = '2.21.5')"
RUN R -e "devtools::install_version('ggeffects', version = '1.1.2', dependencies = T)"
RUN R -e "devtools::install_version('patchwork', version = '1.1.1', dependencies = T)"
RUN R -e "devtools::install_version('binom', version = '1.1.1', dependencies = T)"
RUN R -e "devtools::install_version('pheatmap', version = '1.0.12', dependencies = T)"
RUN R -e "devtools::install_version('glmnet', version = '4.1.4', dependencies = T)"
RUN R -e "devtools::install_version('selectiveInference', version = '1.2.5', dependencies = T)"
RUN R -e "devtools::install_version('simstudy', version = '0.4.0', dependencies = T)"
RUN R -e "devtools::install_version('margins', version = '0.3.26', dependencies = T)"


# install Bioconductor packages

RUN R -e "BiocManager::install('limma', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('DESeq2', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('phyloseq', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('PCAtools', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('ComplexHeatmap', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('tximport', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('tximportData', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('BaseSpaceR', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('dmrseq', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('RTCGA', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('GEOquery', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('Cardinal', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('MSnbase', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('EBImage', version='3.15', update = FALSE)"

# temporary

RUN apt-get install -y --no-install-recommends liblzma-dev

RUN R -e "BiocManager::install('MEDIPS', version='3.15', update = FALSE)"

# install additional random packages
RUN R -e "devtools::install_version('xaringan', version = '0.24', dependencies = T)"
RUN R -e "devtools::install_version('rmda', version = '1.6', dependencies = T)"
RUN R -e "devtools::install_version('dcurves', version = '0.2.0', dependencies = T)"
RUN R -e "devtools::install_version('xaringanthemer', version = '0.4.1', dependencies = T)"
RUN R -e "devtools::install_github('ML4LHS/runway')"
RUN R -e "devtools::install_version('pmsampsize', version = '1.1.2', dependencies = T)"
RUN R -e "devtools::install_version('doParallel', version = '1.0.17', dependencies = T)"
RUN R -e "remotes::install_github('mitchelloharawild/icons')"
RUN R -e "remotes::install_github('GiuseppeTT/structured')"
RUN R -e "devtools::install_version('corncob', version = '0.2.0', dependencies = T)"
RUN R -e "devtools::install_version('paletteer', version = '1.4.0', dependencies = T)"
RUN R -e "devtools::install_version('furrr', version = '0.3.0', dependencies = T)"
RUN R -e "devtools::install_github('amirmasoudabdol/preferably')"
RUN R -e "devtools::install_version('blogdown', version = '1.10', dependencies = T)"
RUN R -e "blogdown::install_hugo()"
RUN R -e "devtools::install_github('BlakeRMills/MetBrewer')"
RUN R -e "devtools::install_version('docopt', version = '0.7.1', dependencies = T)"
RUN R -e "devtools::install_version('logger', version = '0.2.2', dependencies = T)"
RUN R -e "devtools::install_version('yaml', version = '2.3.5', dependencies = T)"
RUN R -e "devtools::install_version('sjPlot', version = '2.8.10', dependencies = T)"
RUN R -e "devtools::install_version('MALDIquant', version = '1.21', dependencies = T)"
RUN R -e "devtools::install_version('MALDIquantForeign', version = '0.13', dependencies = T)"
RUN R -e "BiocManager::install('BSgenome.Hsapiens.UCSC.hg19', version='3.15', update = FALSE)"
RUN R -e "BiocManager::install('annotatr', version = '3.15', update = FALSE)"
RUN R -e "devtools::install_version('Morpho', version = '2.9', dependencies = T)"
RUN R -e "devtools::install_version('ggdendro', version = '0.1.23', dependencies = T)"
RUN R -e "devtools::install_version('ggfortify', version = '0.4.14', dependencies = T)"

RUN pip3 install pandas

# alias to launch rstudio server
RUN echo "alias rstudio='/init'" >> ~/.bashrc

ENV BASEDIR=/home/rstudio
WORKDIR /home/rstudio

#RUN mkdir -p ~/basic_rfiles/

COPY rstudio-prefs.json /etc/rstudio/rstudio-prefs.json
COPY run_job.R /usr/bin/run_job.R
CMD ["/bin/bash"]
