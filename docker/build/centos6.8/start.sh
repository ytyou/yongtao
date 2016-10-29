#!/bin/bash

service sshd start
service supervisord start

# wait forever
sleep 100d
