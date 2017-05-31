FROM wangkexiong/openstackcli
MAINTAINER wangkexiong<wangkexiong@gmail.com>

ENV TZ "Asia/Shanghai"

COPY trystack   /root/trystack
COPY crontab    /etc/crontabs/root
COPY startup.sh /root/

RUN apk add --no-cache bash wget tzdata && \
    cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    chmod +x /root/trystack/setup.sh && chmod +x /root/startup.sh
EXPOSE 80

CMD ["/bin/sh", "-c", "/root/startup.sh"]
