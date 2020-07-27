# Pull the mariadb latest image
FROM mariadb:10.5.2-bionic
# List all the packages that we want to install
ENV PACKAGES vim ccze net-tools
# Install Packages
RUN apt-get update && apt-get install -y $PACKAGES
#
