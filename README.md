# R Geospatial (RGEO) environment

### Requirements

To build and run this container, you need to have [Docker](https://www.docker.com/) installed in your machine

### 1. Build RGEO docker image
```
$ docker build --no-cache \
               --build-arg APSIMX_VERSION=7504 \
               -t rgeo \
               . 
```

### 2. Run RGEO container:

##### 2.1. Linux
```
$ docker run -d \
             -p 8787:8787 \
             --name rgeo \
             --restart always \
             --volume /home/luana/rgeo_shared_folder:/home/rstudio/rgeo_shared_folder \
             rgeo
```

##### 2.2. Windows
```
$ docker run -d \
             -p 8787:8787 \
             --name geo \
             --restart always \
             --volume C:\rgeo_shared_folder:/home/rstudio/rgeo_shared_folder \
             rgeo
```

### 3. Run container on VSCODE

To code using this container:

- 3.1: Acess `Remote Explorer` >> `Dev container` feature of vscode
- 3.2: Install jupyter extension on vscode
- 3.3: Open vscode terminal and run `R -e "IRkernel::installspec()`
- 3.4: Reload vscode window using `Ctrl + Shift + P` >> `Reload Window`