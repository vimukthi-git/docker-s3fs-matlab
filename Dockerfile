FROM ubuntu:14.04

RUN apt-get update && \
	apt-get install -y curl wget unzip xorg automake autotools-dev \
			fuse g++ libcurl4-gnutls-dev libfuse-dev \
			libssl-dev libxml2-dev make pkg-config
COPY s3fs-fuse /build

WORKDIR /build

RUN ./autogen.sh

RUN ./configure

# fix some random make problem
RUN find . -exec touch {} \;

RUN make

ADD matlab.txt /mcr-install/matlab.txt

# Install MATLAB runtime
RUN \
        cd /mcr-install && \
        wget -nv http://de.mathworks.com/supportfiles/downloads/R2015b/deployment_files/R2015b/installers/glnxa64/MCR_R2015b_glnxa64_installer.zip && \
        unzip MCR_R2015b_glnxa64_installer.zip && \
        mkdir /opt/mcr && \
        ./install -inputFile matlab.txt && \
	rm -rf mcr-install

RUN cp /build/src/s3fs /bin/

CMD ["sh"]
