# version: 0.9.0

FROM docker.io/cptactionhank/atlassian-confluence
MAINTAINER Danssion Duan "danssion@qq.com"

ENV TERM xterm
ENV TZ "Asia/Shanghai"

RUN rm -rf /etc/localtime ;ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime ;
#RUN ["rpm","-Uvh","http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm"]
#RUN ["yum","install","-y","nginx"]
#RUN echo 'Hi, I am in your container' \
#  > /user/share/nginx/html/index.html  
VOLUME ["/data/confluence-data/","/data/backups"]

ENV REFRESHED_AT 2017-10-24 18:41
EXPOSE 8090
