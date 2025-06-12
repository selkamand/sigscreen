# FROM node:22.11.0-alpine3.20
FROM alpine:3.20

RUN apk update
RUN apk upgrade

RUN apk add make gcc g++
# install fonts
RUN apk add font-terminus font-inconsolata font-dejavu font-noto font-noto-cjk font-awesome font-noto-extra
RUN apk add 'R=4.4.0-r0'

# Copy installr accross
COPY installr /usr/local/bin/


# Install Arrow
RUN mkdir -p ~/.R && echo "LDFLAGS+=-fPIC" >> ~/.R/Makevars

# Install Package System Dependencies

RUN apk add libpng-dev libxml2-dev

RUN installr -d -t "R-dev gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev apache-arrow-dev" \
    BSgenome.Hsapiens.UCSC.hg38

RUN installr -d -t "R-dev gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev" \
    quadprog


RUN installr -d \
    -t "R-dev make openssl-dev cmake linux-headers apache-arrow-dev openssl libarrow_dataset libarrow" arrow@16.1.0

# Install Optparse for CLI

# Install sigverse
RUN installr -d -t "R-dev gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev" selkamand/sigshared
RUN installr -d -t "R-dev gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev"  \
    optparse \
    selkamand/sigstart

RUN installr -d -t "R-dev gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev" \
    ShixiangWang/copynumber@2e31d59 \
    ShixiangWang/sigminer@9455b46 

RUN installr -d -t "R-dev gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev apache-arrow-dev" \
    selkamand/sigminerUtils

RUN apk add --no-cache bash

RUN apk add libxml2-dev

# Copy R scripts
COPY scripts/* /app/

# Add scripts path
ENV PATH="$PATH:/app"

WORKDIR /app