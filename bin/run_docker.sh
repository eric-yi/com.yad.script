#!/bin/sh

###################################
## start docker shell on mac
## 2015-06-06 yi_xiaobin@163.com
###################################

curdir=$(cd "$(dirname "$0")"; pwd)
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=$HOME/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
boot2docker up
$curdir/auto_ssh.sh ssh 192.168.59.103 22 docker tcuser
