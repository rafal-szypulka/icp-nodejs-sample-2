#!/bin/bash -ex

# Licensed Materials - Property of IBM
# (C) Copyright IBM Corp. 2017. All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

#if ! [ $# -eq 5 ] ;  then
#  echo "Requires five parameters: the image name you want, the tag you want, the ca domain name, the username to push it as, and the Dockerfile location"
#  echo "E.g. ./BuildAndPushPrivate.sh icp-nodejs-sample-amd64 1.0.0 mycluster.icp admin docker-6/Dockerfile"
#  exit;
#fi

echo "Make sure you've copied the ca.crt contents from your ICP instance to be available on your machine this script is being called from!"

image_name="icp-nodejs-sample-apm-2"
image_tag="1.0.0"
ca_domain="bluedemocluster.icp"
docker_user="admin"
docker_file="docker-6/Dockerfile"

echo "Image name will be: ${image_name}"
echo "Image tag will be: ${image_tag}"
echo "CA domain will be: ${ca_domain}"
echo "Docker user: ${docker_user}"
echo "File to use: ${file_to_use}"

docker login -u ${docker_user} ${ca_domain}:8500

if [ $? -ne 0 ]; then
  echo "Didn't login successfully, bailing"; exit;
fi

echo "Building the Docker image"
docker build -t ${image_name}:${image_tag} .
if [ $? -ne 0 ]; then
  echo "Didn't build your application successfully, bailing"; exit;
fi

echo "Docker tagging..."
docker tag ${image_name}:${image_tag} ${ca_domain}:8500/default/${image_name}:${image_tag}
if [ $? -ne 0 ]; then
  echo "Didn't tag your image successfully, bailing"; exit;
fi

echo "Docker pushing..."
docker push ${ca_domain}:8500/default/${image_name}:${image_tag}
if [ $? -ne 0 ]; then
  echo "Didn't push your image successfully, bailing"; exit;
fi
echo "Done!"
