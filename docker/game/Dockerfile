# 游戏服运行环境：CentOS7（el7 glibc，匹配 OTP19 与 compat 库）
FROM centos:7

# CentOS7 已 EOL：源切到 vault；EPEL 切到归档地址（libfaketime 在 EPEL）
RUN set -eux; \
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo; \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*.repo; \
    yum install -y epel-release; \
    printf '[epel]\nname=EPEL 7\nbaseurl=https://archives.fedoraproject.org/pub/archive/epel/7/$basearch\nenabled=1\ngpgcheck=0\n' > /etc/yum.repos.d/epel.repo; \
    yum install -y libfaketime which procps-ng net-tools hostname; \
    ln -sf /usr/lib64/faketime/libfaketime.so.1 /usr/lib64/libfaketime.so.1; \
    yum clean all

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9180 9030
ENTRYPOINT ["/entrypoint.sh"]
