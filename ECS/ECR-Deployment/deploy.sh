#!/bin/bash

ACCOUNT=$1
FILE=./Dockerfile
IMAGE=my-demo

if [[ -f $FILE ]]; then
	echo -e "[OK]: Dockerfile exists in the current execution path"
	## // check input  //
	if [[ "$#" -ne 1 ]]
	then
        	echo
        	echo -e "[ERROR]: Please check the input arguments"
        	echo -e "[COMMAND]: script.sh <AWS ACCOUNT ID>"
        	echo -e "[EXAMPLE]: status.sh  90172905123"
        	exit
	else
		docker build -t ${IMAGE} .
		docker tag ${IMAGE}:latest ${ACCOUNT}.dkr.ecr.us-east-2.amazonaws.com/${IMAGE}:latest
		aws ecr get-login-password \
		--region us-east-2 | docker login \
		--username AWS --password-stdin ${ACCOUNT}.dkr.ecr.us-east-2.amazonaws.com
		docker push ${ACCOUNT}.dkr.ecr.us-east-2.amazonaws.com/${IMAGE}:latest
	fi
else
	echo -e "[ERROR]: Dockerfile doesn't exists in the current execution path"
	exit
fi
