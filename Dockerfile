# centos7.2.1511+阿里云yum源+常用软件
# 默认密码root123，进入系统可以呀passwd修改密码
# 个人博客：https://4xx.me
FROM hub.c.163.com/library/centos:7.2.1511
MAINTAINER https://4xx.me

RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN yum install wget -y

# 更换阿里源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
RUN wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

# 安装常用软件
RUN yum install -y yum-plugin-ovl || true
RUN yum install -y vim tar wget curl rsync bzip2 iptables tcpdump less telnet net-tools lsof sysstat cronie passwd openssl openssh-server epel-release kde-l10n-Chinese glibc-common

# 安装ssh
RUN yum install passwd openssl openssh-server -y
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N ''
RUN sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN echo "root:root123" | chpasswd

# 中文设置
ENV LANG="zh_CN.UTF-8" 
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8

# 更新yum包 更新最新内核
RUN yum update -y

# 清除yum缓存
RUN yum clean all
RUN rm -rf /var/cache/yum/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]