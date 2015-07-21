#!/usr/bin/env bash

/bin/cp /redis/conf/session.conf /etc/redis/session.conf
/bin/cp /redis/conf/cache.conf /etc/redis/cache.conf
/bin/cp /redis/conf/fpc.conf /etc/redis/fpc.conf

/bin/mkdir -p /var/redis/session
/bin/mkdir -p /var/redis/cache
/bin/mkdir -p /var/redis/fpc

/usr/bin/redis-server /etc/redis/session.conf
/usr/bin/redis-server /etc/redis/cache.conf
/usr/bin/redis-server /etc/redis/fpc.conf
