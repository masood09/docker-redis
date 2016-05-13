# Use phusion/baseimage as base image.
FROM phusion/baseimage:0.9.18

MAINTAINER Masood Ahmed masood.ahmed09@gmail.com

# Set correct environment variables.
ENV HOME /root

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Regenerate SSH host keys. baseimage-docker does not contain any, so we
# have to do that yourself.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Gerenare the locales
RUN locale-gen en_US.UTF-8
RUN export LANG=en_US.UTF-8

# Add the required repositories
RUN apt-add-repository -y ppa:chris-lea/redis-server

# Update & upgrade the repositories
RUN apt-get update
RUN apt-get -y --force-yes upgrade

# Install Redis (3.0.7)
RUN apt-get install -y --force-yes redis-server

# Copy the init files for Redis
ADD build/99_redis.sh /etc/my_init.d/99_redis.sh
RUN chmod +x /etc/my_init.d/99_redis.sh

# Make the port 8302 and 8402 available to outside world
EXPOSE 8302
EXPOSE 8402
EXPOSE 8502

# Deleting the man pages and documentation
RUN find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true
RUN find /usr/share/doc -empty|xargs rmdir || true
RUN rm -rf /usr/share/man /usr/share/groff /usr/share/info /usr/share/lintian > /usr/share/linda /var/cache/man

# Clean up APT when done.
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
