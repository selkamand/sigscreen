FROM rhub/r-minimal:4.4.1

# Install Arrow
RUN mkdir -p ~/.R && echo "LDFLAGS+=-fPIC" >> ~/.R/Makevars

# The most recent 15.0.1 version of the arrow package does not compile
# on Alpine, so we install the previous version. If you had success with
# newer versions, please let us know! Thanks!

RUN installr -d \
    -t "make openssl-dev cmake linux-headers apache-arrow-dev openssl libarrow_dataset libarrow" arrow@14.0.2.1


# Install sigverse
RUN installr -c -a "gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev" selkamand/sigshared

# selkamand/sigstash  \
# selkamand/sigstats  \
# selkamand/sigvis    \
# selkamand/sigsim    \
# selkamand/sigstory 

RUN installr -d -t "gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev" \
    selkamand/sigstart 

# install sigminerUtils
RUN installr -d -t "gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev"  \
    selkamand/sigminerUtils

# Install Optparse for CLI
RUN installr optparse





#remotes::install_github("cran/arrow@14.0.0.1")

# RUN installr -d -t "gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev apache-arrow-dev" \
#     selkamand/sigminerUtils

# RUN installr -d -t "gfortran fontconfig-dev cmake curl-dev libxml2-dev bzip2-dev apache-arrow-dev" \
#     ShixiangWang/copynumber@2e31d59 \
#     ShixiangWang/sigminer@9455b46 

# Install system dependencies
# RUN apt-get update && apt-get install -y \
#     libcurl4-openssl-dev \
#     libssl-dev \
#     libxml2-dev

# Install R packages from specific GitHub commits
# RUN R -e "install.packages('remotes')"
# RUN R -e "remotes::install_github('selkamand/sigstart', upgrade = 'never')"
# RUN R -e "remotes::install_github('selkamand/sigminerUtils', upgrade = 'never')"
# RUN R -e "remotes::install_github('', upgrade = 'never')"
# RUN R -e "remotes::install_github('', upgrade = 'never')"
# RUN R -e "install.packages('optparse')"

# Copy your R scripts
COPY scripts/* /app/

WORKDIR /app