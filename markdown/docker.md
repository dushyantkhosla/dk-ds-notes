[TOC]

# Introduction

## Virtual Machines

- Used to *emulate computing environments*. (Windows on MacOS? Linux on Windows?)
  For example, you could run Linux in a virtual machine on a laptop that runs Windows, without having to actually install it on your machine. 
- VMs use *images* to boot up. These are just snapshots of a desired filesystem, and *contain* all the files needed to create a the environment. 
- To run Ubuntu on a VM, you need an Ubuntu image. 
  You can run the same Ubuntu image on as many servers as you like.

### Disadvantages of VMs 

- Take a long time to boot up
- Consume significant system resources

## Docker

Docker introduced OS-level virtualization for running multiple isolated Linux systems on a  host using a single Linux kernel - the guests share resources. Think of Docker containers as lightweight virtual machines that contain everything you need to run an software application - code, frameworks, and libraries.

### Benefits of Docker

- Lightweight and Fast (get up and running in seconds with all the packages and libraries  needed for a particular analysis - no time wasted in setting up.)
- Easy (create and destroy containers at will)
- Reproducible (your code is guaranteed to run)
- Portable (works on all OSs)
- Scan-able for Compliance (Dockerfiles have the recipe for all that's inside a container)
- `root` access! (eg. freedom to issue `pip` and  `yum` commands)



# Images and `Dockerfile`

A Docker Image is

- A blueprint or recipe for what you want to build. 
  Ex: *Ubuntu + TensorFlow with Nvidia Drivers and a running Jupyter Server*.
- A snapshot of a running container. 
  Ex. *A CentOS container configured by you for a specific purpose.*
- An image can be used to create any number of containers (clones!)
  - You can have multiple copies of the same image running. 

## Pulling Images

You can use the `docker pull` command to fetch images from the configured registry.

```bash
docker pull image-url
```

To list images available on your machine

```bash
docker images
```

## Creating Images

- A `Dockerfile` contains the recipe for creating an image. 
  It contains a list of all packages, libraries and tools that will be installed in an image. 
- By modifying Dockerfiles, you can change which packages and tools come with the image by default.	

## `Dockerfile` Statements

- **FROM**: specify the source image
- **MAINTAINER**: name and email of the maintainer
- **COPY**: copy files needed during installation (eg. config files, startup scripts, proxy settings) 
- **ENV**: set environment variables
- **WORKDIR**: change the directory
- **RUN**: execute commands like `yum install`
- **EXPOSE**: open ports to communicate with the container
- **CMD**: bash command to run when you start a new container

## Creating Images with `Dockerfile`

```bash
docker build -t IMAGE-TAG -f path/to/Dockerfile
```

- Use slashes within `tags` to organize your images into folders.
  Create a Dockerfile at the root of your project directory and run the following -

```bash
docker build -t myProject/image-01 .
```

## Sample `Dockerfile`

```bash
FROM centos:latest
MAINTAINER Dushyant Khosla <dushyant.khosla@yahoo.com>

COPY environment.yml /root/environment.yml
COPY start.sh /etc/profile.d/

ENV PATH="/miniconda/bin:${PATH}"

WORKDIR /root
RUN yum -y install bzip2 \
                   tmux \
                   wget \
&& wget --quiet https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh -O miniconda.sh \
	&& bash miniconda.sh  -b -p /miniconda \
	&& conda config --append channels conda-forge \
	&& conda env create -f environment.yml \
	&& conda clean -i -l -t -y \
	&& rm miniconda.sh

WORKDIR /home/
EXPOSE 8080
CMD /usr/bin/bash
```

## Caution!

> All software packages used in the containers should come from the '**Allowed'** list according to the [Open Source Governance SOP](https://jam2.sapjam.com/groups/nbAxlUnUtFqgqWaoSwUeoD/documents/tCRYcPFJCvrWg4gmEOVMlY/slide_viewer).  Only if there is no possible alternative, a software from the '**Restricted'** list can be used.



## Image Registry

- Think of these as cloud databases of images. 
- *Docker Hub* contains thousands of community-contributed images that can be downloaded for free. Check it out!
- Chances are there exist an image containing all the tools needed for your needs! 
  With a `docker pull` and `docker run` you can go from zero to an analysis ready environment.
- We have our own PMI Docker Registry 
  - We write and test Dockerfiles to create containers (locally)
  - We `docker push` these to the Registry (from local)
  - On a DS-Prod Lab, we `docker pull` these to start working.



# Running Containers

##  `docker run`

- Interactive mode with `-i`
- Mirroring directories with  `-v` 
- Mirroring ports with `-p`
- Naming containers with `--name`

*Syntax*:

```bash
docker run -it \
			-v path/on/host:path/on/guest \
			-p host:guest \
			PROJECT_NAME/IMAGE_NAME:TAG_NAME
```

##  `docker attach` 

A container is not destroyed unless you manually remove it

```bash
docker rm -f CONTAINER_ID
```

If you exited a container simply by typing `exit` at the command-line, 
you can get back into it with:

```bash
# check available container_ids
docker ps -a

# attach to the one you want
docker attach CONTAINER_ID

# you might have to start
```



# Dockerized Data Science Workflow 

1. Log in to `OpenVPN`
2. In the Terminal, `ssh` into the remote instance

```bash
ssh USER@dopfracalmina01.node.pmids.ocean
```

3. The following only need to be done **once**

- Set an alias in your `~/.bashrc` file to use docker without `sudo`

```bash
alias docker='sudo docker'
```

- Configure a proxy for `git`

```bash
git config --global http.proxy http://squid.service.pmicicd.ocean:3128
```

- Log in to the PMI Docker Registry

```bash
docker login docker.ocean.pmicloud.biz
```

4. Pull the docker image you need using the syntax:
   *Syntax*: `docker pull docker.ocean.pmicloud.biz/<PROJECT>/<TAG>`

```bash
docker pull docker.ocean.pmicloud.biz/eadlab/ds-py3-venv
```

5. Pull the code for your project

```bash
git clone https://dpothine@source.app.pconnect.biz/scm/~nsingh/iris-dev.git
```

6. Pull the data into `data/raw/` from your MacBook, or from `HDFS`
   *Syntax*: `scp -r path/on/source path/on/ds-lab`

```bash
scp -r iris-data/ USER@dopfracalmina01.node.pmids.ocean:/home/dkhosla/data/raw/
```

5. Run the container

```bash
docker run -it \
			-v /home/dkhosla/:/home/mount \
			-p 8888:8888 \
			-p 5000:5000 \
			docker.ocean.pmicloud.biz/eadlab/ds-py3-venv
```

6. Check out the startup messages, complete the `git config` 
7. Start a Jupyter Server inside the container

```bash
jupyter lab --allow-root --no-browser --ip 0.0.0.0 --port 8888
```

7. Access the Notebook on your Macbook at 
   http://dopfracalmina01.node.pmids.ocean:8888
8. Create a branch and code away! 
   [Reference Doc. on Confluence](https://wiki.app.pconnect.biz/pages/viewpage.action?spaceKey=EAD&title=Git+workflow+%7C+Pull+Requests)
   ​



# Bonus: Useful Docker Commands

- To execute commands or run scripts on an already running container, use `docker exec`
  *Syntax*: `docker exec -it CONTAINER-NAME COMMAND`

```bash
docker exec -it c320df1sc2 bash
```

- Save the state of your container as a new image.

```bash
docker commit CONTAINER-NAME PROJECT_NAME/NEW_IMAGE_NAME:TAG
```



