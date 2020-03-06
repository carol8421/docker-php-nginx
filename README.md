# Base PHP + Nginx Docker image [![Build Status](https://travis-ci.com/ems-project/docker-php-nginx.svg?branch=master)](https://travis-ci.com/ems-project/docker-php-nginx)

Docker base image is the basic image on which you add layers (which are basically filesystem changes) and create a final image containing your App.  

## Features

Use [Supervisord] as manager for Apache **and** PHP-FPM.  Supervisord is therefore process 1.  
Installation of [Nginx](https://pkgs.alpinelinux.org/package/v3.11/main/x86_64/nginx).  
