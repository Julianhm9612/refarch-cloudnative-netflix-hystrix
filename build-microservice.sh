#!/bin/bash

IMAGE_NAME=netflix-hystrix
MAVEN_BUILD_TARGET=target/hystrix-dashboard-0.0.1-SNAPSHOT.jar
GRADLE_BUILD_TARGET=build/libs/hystrix-dashboard-0.0.1-SNAPSHOT.jar

while getopts "md" ARG; do
  case ${ARG} in
    m)
      USE_MAVEN='yes'
      ;;
    d)
      DO_DOCKER='yes'
      ;;
  esac
done

if [[ ${USE_MAVEN} == 'yes' ]]; then
  mvn clean package
  if [[ ${DO_DOCKER} == 'yes' ]]; then
    cp ${MAVEN_BUILD_TARGET} docker/app.jar
  fi
else
  ./gradlew clean build
  if [[ ${DO_DOCKER} == 'yes' ]]; then
	cp ${GRADLE_BUILD_TARGET} src/main/docker/app.jar
  fi
fi

if [[ ${DO_DOCKER} == 'yes' ]]; then
  cd src/main/docker/
  docker build -t ${IMAGE_NAME} .
fi
