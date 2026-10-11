# 自研后端运行环境：CentOS7（自带 python2.7）+ OpenJDK8
FROM centos:7

RUN yum install -y java-1.8.0-openjdk-headless which procps-ng nc curl \
 && yum clean all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8896 8897 8898 8899
ENTRYPOINT ["/entrypoint.sh"]
