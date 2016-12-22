docker run --privileged -e "container=docker" --name centos7 -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add=SYS_ADMIN yongtao/centos7
