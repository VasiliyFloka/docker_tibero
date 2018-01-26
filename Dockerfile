FROM centos
MAINTAINER Vasiliy Floka <Vasiliy@Floka.ru>
RUN yum install -y gcc.x86_64 gcc-c++.x86_64 compat-libstdc++-33.x86_64 libaio-devel.x86_64
RUN groupadd dba && \
	useradd -g dba tibero && \
	echo tibero soft nproc 2047 >> /etc/security/limits.conf && \
	echo tibero hard nproc 16384 >> /etc/security/limits.conf && \
	echo tibero soft nofile 1024 >> /etc/security/limits.conf && \
	echo tibero hard nofile 65536 >> /etc/security/limits.conf
ENV TB_HOME=/home/tibero/tibero6 \
	TB_SID=tibero
EXPOSE 8629
ADD Tibero.tar.gz /home/tibero
COPY license.xml $TB_HOME/license
COPY create_database.sql $TB_HOME/scripts
COPY bash_profile.add /home/tibero
RUN chown -R tibero:dba /home/tibero && \
	chmod -R 775 /home/tibero && \
	cat /home/tibero/bash_profile.add >> /home/tibero/.bash_profile
COPY jdk.rpm /tmp
RUN rpm -ivh /tmp/jdk.rpm
