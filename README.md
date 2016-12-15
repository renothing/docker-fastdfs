----
## Fastdfs Server Dockerfile

### Base Docker Image

* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Build image with own settings 

   (alternatively, you can build an image from Dockerfile: `docker build -t=fastdfs .`)
   default timezone=Asia/Shanghai, please specify it before running
   default group "group1" if you didn't specify, please change it letter

### Usage

#### Run `tracker server`

    docker run -dit --name fdfstracker -p 80:80 -p 22122:22122 fastdfs

#### Run `storage server`

    docker run -dit --name fdfststorage -p 80:80 -p 23000:23000 --link fdfstracker:trackerserver fastdfs trackerserver

#### Check fdfs status

    docker exec -it trackerserver fdfs_monitor /etc/fdfs/client.conf
