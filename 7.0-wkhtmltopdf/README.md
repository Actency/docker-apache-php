# About this image

This image is not part of the automated build because of the limitations on docker hub.
The compilation time of wkhtmltopdf takes more than 2 hours on docker hub, and results in a timeout.

This Dockerfile is used to build the image locally, and then push it to [Docker Hub](https://hub.docker.com/r/actency/docker-apache-php7-wkhtmltopdf/).

The image contains:

- Everything in the 7.0-dev tag
- wkhtmltopdf and wkhtmltoimage installed from sources
