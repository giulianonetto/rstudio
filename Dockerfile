FROM rocker/tidyverse:4.3.2

MAINTAINER Giuliano Netto Flores Cruz

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
    libbz2-dev \
    liblzma-dev

# python stuff
RUN pip3 install pandas
RUN pip3 install docopt
RUN pip3 install pathlib
RUN pip3 install radian


# install Bioconductor packages

RUN R -e "BiocManager::install('limma', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('DESeq2', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('phyloseq', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('Maaslin2', version = '3.17', update = FALSE)"
RUN R -e "BiocManager::install('ANCOMBC', version = '3.17', update = FALSE)"
RUN R -e "BiocManager::install('PCAtools', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('ComplexHeatmap', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('tximport', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('tximportData', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('BaseSpaceR', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('dmrseq', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('RTCGA', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('GEOquery', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('Cardinal', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('MSnbase', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('EBImage', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('MEDIPS', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('DelayedArray', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('DelayedMatrixStats', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('SummarizedExperiment', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('BSgenome.Hsapiens.UCSC.hg19', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('annotatr', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('minfi', version = '3.18', update = FALSE)"
RUN R -e "BiocManager::install('IlluminaHumanMethylationEPICmanifest', version = '3.18', update = FALSE)"

# Things that matter less

RUN R -e "devtools::install_version('GGally', version = '2.1.2', dependencies = T)"
RUN R -e "devtools::install_version('ggbeeswarm', version = '0.6.0', dependencies = T)"
RUN R -e "devtools::install_version('latex2exp', version = '0.9.6', dependencies = T)"
RUN R -e "devtools::install_version('docstring', version = '1.0.0', dependencies = T)"
RUN R -e "devtools::install_version('binom', version = '1.1.1', dependencies = T)"
RUN R -e "devtools::install_version('ggpubr', version = '0.6.0', dependencies = T)"
RUN R -e "devtools::install_version('rstatix', version = '0.7.2', dependencies = T)"
RUN R -e "devtools::install_version('ggeffects', version = '1.2.2', dependencies = T)"
RUN R -e "devtools::install_version('margins', version = '0.3.26', dependencies = T)"
RUN R -e "devtools::install_version('marginaleffects', version = '0.12.0', dependencies = T)"
RUN R -e "devtools::install_version('pheatmap', version = '1.0.12', dependencies = T)"
RUN R -e "devtools::install_version('glmnet', version = '4.1.7', dependencies = T)"
RUN R -e "devtools::install_version('selectiveInference', version = '1.2.5', dependencies = T)"
RUN R -e "devtools::install_version('xaringan', version = '0.24', dependencies = T)"
RUN R -e "devtools::install_version('rmda', version = '1.6', dependencies = T)"
RUN R -e "devtools::install_version('dcurves', version = '0.4.0', dependencies = T)"
RUN R -e "devtools::install_version('xaringanthemer', version = '0.4.1', dependencies = T)"
RUN R -e "devtools::install_github('ML4LHS/runway')"
RUN R -e "devtools::install_version('pmsampsize', version = '1.1.2', dependencies = T)"
RUN R -e "devtools::install_version('doParallel', version = '1.0.17', dependencies = T)"
RUN R -e "devtools::install_version('paletteer', version = '1.4.0', dependencies = T)"
RUN R -e "devtools::install_version('furrr', version = '0.3.1', dependencies = T)"
RUN R -e "devtools::install_github('amirmasoudabdol/preferably')"
RUN R -e "devtools::install_version('blogdown', version = '1.17', dependencies = T)"
RUN R -e "blogdown::install_hugo()"
RUN R -e "devtools::install_github('BlakeRMills/MetBrewer')"
RUN R -e "devtools::install_version('docopt', version = '0.7.1', dependencies = T)"
RUN R -e "devtools::install_version('logger', version = '0.2.2', dependencies = T)"
RUN R -e "devtools::install_version('yaml', version = '2.3.5', dependencies = T)"
RUN R -e "devtools::install_version('sjPlot', version = '2.8.14', dependencies = T)"
RUN R -e "devtools::install_version('MALDIquant', version = '1.22.1', dependencies = T)"
RUN R -e "devtools::install_version('MALDIquantForeign', version = '0.13', dependencies = T)"
RUN R -e "devtools::install_version('Morpho', version = '2.9', dependencies = T)"
RUN R -e "devtools::install_version('ggdendro', version = '0.1.23', dependencies = T)"
RUN R -e "devtools::install_version('ggfortify', version = '0.4.16', dependencies = T)"
RUN R -e "devtools::install_version('ggpointdensity', version = '0.1.0', dependencies = T)"
RUN R -e "devtools::install_version('ggExtra', version = '0.10.0', dependencies = T)"
RUN R -e "devtools::install_version('irr', version = '0.84.1', dependencies = T)"
RUN R -e "devtools::install_version('lme4', version = '1.1.32', dependencies = T)"
RUN R -e "devtools::install_version('lmerTest', version = '3.1.3', dependencies = T)"
RUN R -e "devtools::install_version('brms', version = '2.19')"
RUN R -e "devtools::install_version('tidybayes', version = '3.0.4')"
RUN R -e "devtools::install_version('projpred', version = '2.5.0')"
RUN R -e "install.packages('cmdstanr', repos = c('https://mc-stan.org/r-packages/', getOption('repos')))"
RUN R -e "cmdstanr::install_cmdstan(cores = 4)"
RUN R -e "devtools::install_version('StanHeaders', version = '2.26.25')"
RUN R -e "devtools::install_version('rstan', version = '2.21.8')"
RUN R -e "devtools::install_version('rstanarm', version = '2.21.4')"
RUN R -e "devtools::install_version('patchwork', version = '1.1.2', dependencies = T)"
RUN R -e "devtools::install_version('simstudy', version = '0.6.0', dependencies = T)"
RUN R -e "remotes::install_github('mitchelloharawild/icons')"
RUN R -e "remotes::install_github('GiuseppeTT/structured')"
RUN R -e "remotes::install_github('nx10/httpgd')"
RUN R -e "devtools::install_version('languageserver', version = '0.3.15')"
RUN R -e "remotes::install_github('hughjonesd/ggmagnify')"
RUN R -e "remotes::install_github('ropensci/stantargets')"
RUN R -e "devtools::install_version('import', version = '1.3.0', dependencies = T)"
RUN R -e "devtools::install_version('targets', version = '1.1.3', dependencies = T)"
RUN R -e "devtools::install_version('tarchetypes', version = '0.7.6', dependencies = T)"
RUN R -e "devtools::install_version('OptimalCutpoints', version = '1.1.5', dependencies = T)"
RUN R -e "devtools::install_version('simsurv', version = '1.0.0', dependencies = FALSE, upgrade_dependencies = FALSE)"
RUN R -e "devtools::install_version('MicrobiomeStat', version = '1.1', dependencies = FALSE, upgrade_dependencies = FALSE)"
RUN R -e "devtools::install_version('ggeasy', version = '0.1.4', dependencies = FALSE, upgrade_dependencies = FALSE)"
RUN R -e "devtools::install_version('predRupdate', version = '0.1.0', dependencies = TRUE, upgrade_dependencies = FALSE)"
RUN R -e "devtools::install_version('ggsurvfit', version = '0.3.0', dependencies = TRUE)"
RUN R -e "devtools::install_version('rms', version = '6.7')"
RUN R -e "devtools::install_version('Hmisc', version = '5.1.0')"
RUN R -e "devtools::install_version('rafalib', version = '1.0.0')"
RUN R -e "devtools::install_version('mvnfast', version = '0.2.8')"
RUN R -e "devtools::install_version('lintr', version = '3.0.2')"
RUN R -e "devtools::install_version('httpgd', version = '1.3.1')"
RUN R -e "devtools::install_version('xkcd', version = '0.0.6')"
RUN R -e "devtools::install_version('sgd', version = '1.1.1')"
RUN R -e "devtools::install_github('statdivlab/corncob@v0.4.1)"
RUN R -e "BiocManager::install('DSS', version = '3.18', update = FALSE)"
RUN R -e "devtools::install_github('mikemc/speedyseq@ceb941fdd482fe4bf9610f80970050e24f369be9')"

# alias to launch rstudio server
RUN echo "alias rstudio='/init'" >> ~/.bashrc

ENV BASEDIR=/home/rstudio
ENV IMGVERSION=0.0.11
LABEL version="${IMGVERSION}"
RUN echo "Docker Image version ${IMGVERSION}" > ~/READMEDOCKER
WORKDIR /home/rstudio

RUN echo "force_color_prompt=yes" >> ~/.bashrc
ENV R_REMOTES_UPGRADE=never
ENV VIRTUAL_ENV_DISABLE_PROMPT=1
RUN echo "PS1='\[\e[1;38;2;231;41;138m\]${VIRTUAL_ENV:+[$(basename -- $VIRTUAL_ENV)] }\[\e[1;38;2;117;112;179m\][[\u]]\[\033[00m\]:\[\e[1;38;2;27;158;119m\]\w/\n\[\e[1;38;2;217;95;2m\]\\$\\$\[\033[00m\] '" >> ~/.bashrc

COPY rstudio-prefs.json /etc/rstudio/rstudio-prefs.json
CMD ["/bin/bash"]
