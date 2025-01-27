# ========================================================
# -----> BUILD RGEO DOCKER IMAGE:
#     $ docker build --no-cache --build-arg APSIMX_VERSION=7504 -t rgeo . 
# -----> RUN RGEO ON LINUX:
#     $ docker run -d -p 8787:8787 --name rgeo --restart always --volume /home/luana/rgeo_shared_folder:/home/rstudio/rgeo_shared_folder rgeo
# -----> RUN RGEO ON WINDOWS:
#     $ docker run -d -p 8787:8787 --name geo --restart always --volume C:\rgeo_shared_folder:/home/rstudio/rgeo_shared_folder rgeo
# ========================================================

# To code using this container, use the Remote Explorer >> Dev container feature of vscode

# ========================================================
# AFTER BUILD, CONFIGURE JUPYTER KERNEL:
# 1. Open vscode on container using dev container
# 2. Install jupyter extension on vscode
# 3. Install IRKernel spec on terminal --> R -e "IRkernel::installspec()"
# 3. Reload vscode window --> (Ctrl + Shift + P) >> Reload Window 
# ========================================================

ARG BASE_IMAGE=rocker/geospatial
FROM ${BASE_IMAGE}

USER root

RUN apt-get -y update && \
    apt install -y \
                --no-install-recommends \
                --reinstall ca-certificates \
                cmake \
                dotnet-runtime-6.0 \
                dpkg \
                # If you want to build and run ApsimX repo, you'll need "dotnet-sdk-6.0"
                gtk-sharp3 \
                libgtksourceview-4-0 \
                libsqlite3-dev \
                libxslt1-dev \
                micro \
                nano \
                zenity

# Install CroptimizR dependencies
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'plotly')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'mvtnorm')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'BayesianTools')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'doParallel')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'lhs')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'nloptr')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'tictoc')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'SticsRFiles')"

# Install CroptimizR and apsim packages
RUN R -e "options(warn=2); remotes::install_github('SticsRPacks/CroptimizR@*release')"
RUN R -e "options(warn=2); remotes::install_github('SticsRPacks/CroPlotR@*release')"
RUN R -e "options(warn=2); remotes::install_github('hol430/ApsimOnR')"

RUN R -e "options(warn=2); remotes::install_version('apsimx', version='2.7.7');"
RUN R -e "options(warn=2); remotes::install_version('nasapower', version='4.2.1');"
RUN R -e "options(warn=2); remotes::install_version('rapsimng', version='0.4.4');"

# Install other important packages
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'future')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'future.apply')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'reticulate')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'rjson')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'hydroGOF')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'ggpubr')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'patchwork')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'signal')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'imputeTS')"
RUN R -e "options(warn=2); install.packages(repos='https://cran.r-project.org/', 'geojsonio')"

# By default, install APSIMX 7504
ARG APSIMX_VERSION=7504
RUN wget https://builds.apsim.info/api/nextgen/download/${APSIMX_VERSION}/Linux -o /opt/install/apsim_${APSIMX_VERSION}.deb
RUN dpkg -i /opt/install/apsim_${APSIMX_VERSION}.deb

# Install Python pip and salib
RUN apt install -y --no-install-recommends python3-pip
RUN pip install salib

# Install jupyter client
RUN apt install -y --no-install-recommends --reinstall python3-pip
RUN pip3 install jupyter
# Install IRkernel to link jupyter to R kernel
RUN R -e "options(warn=2); remotes::install_github('IRkernel/IRkernel'); IRkernel::installspec()"
#=========================================

USER rstudio