#!/bin/bash

git clone git@github.com:microting/eform-debian-service.git
git clone git@github.com:microting/eform-service-backendconfiguration-plugin.git
git clone git@github.com:microting/eform-service-items-planning-plugin.git
git clone git@github.com:microting/eform-service-timeplanning-plugin.git
git clone git@github.com:microting/eform-service-workflow-plugin.git

mv Dockerfile Dockerfile-main
mv Dockerfile-service Dockerfile

docker build . --build-arg GITVERSION=1.0.0 --build-arg PLUGINVERSION=1.0.0 --build-arg PLUGIN2VERSION=1.0.0 --build-arg PLUGIN3VERSION=1.0.0 --build-arg PLUGIN4VERSION=1.0.0 --build-arg PLUGIN5VERSION=1.0.0 --build-arg PLUGIN6VERSION=1.0.0 -t microtingas/work-items-planning-service-container:latest

mv Dockerfile Dockerfile-service
mv Dockerfile-main Dockerfile

rm -fR eform-debian-service
rm -fR eform-service-backendconfiguration-plugin
rm -fR eform-service-items-planning-plugin
rm -fR eform-service-timeplanning-plugin
rm -fR eform-service-workflow-plugin
