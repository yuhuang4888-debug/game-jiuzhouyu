# 自研后端运行环境：CentOS7（自带 python2.7）+ OpenJDK8
FROM centos:7

# CentOS7 已 EOL：源切到 vault
RUN set -eux; \
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo; \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo; \
    yum install -y java-1.8.0-openjdk-headless which procps-ng nc curl; \
    yum clean all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8896 8897 8898 8899
ENTRYPOINT ["/entrypoint.sh"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8896 8897 8898 8899
ENTRYPOINT ["/entrypoint.sh"]
