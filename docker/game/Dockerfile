# 游戏服运行环境：CentOS7（el7 glibc，匹配 OTP19 与 compat 库）
FROM centos:7

RUN yum install -y epel-release \
 && yum install -y libfaketime which procps-ng net-tools hostname \
 && yum clean all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9180 9030
ENTRYPOINT ["/entrypoint.sh"]
