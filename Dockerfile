FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

ENV ZONE_ID="Your-Account-ZONE_ID"
ENV API_TOKEN="Your-API-TOKEN"

RUN apt-get update && apt-get install -y sudo tzdata wget curl unzip git vim jq &&\
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

WORKDIR /app

ADD dnstools-zh.sh /app
RUN sudo chmod +x  /app/dnstools-zh.sh

CMD ["/app/dnstools-zh.sh"]
