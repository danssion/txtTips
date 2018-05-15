# version: 0.0.1

FROM centos:7.3.1611
MAINTAINER Danssion Duan "danssion@qq.com"
RUN ["rpm","-Uvh","http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm"]
RUN ["yum","install","-y","nginx"]
#RUN echo 'Hi, I am in your container' \
#  > /user/share/nginx/html/index.html  

ENV REFRESHED_AT 2017-10-24 18:41
RUN ["rm","-rf","/etc/nginx/vhost"]
COPY nginx/nginx.conf /etc/nginx/nginx.conf 
COPY nginx/fastcgi.conf /etc/nginx/fastcgi.conf
RUN ["mkdir","/etc/nginx/vhost"]
COPY nginx/vhost /etc/nginx/vhost

ENTRYPOINT ["/usr/sbin/nginx"]
CMD ["-g","daemon off;"]
EXPOSE 80
