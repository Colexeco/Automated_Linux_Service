FROM ubuntu:latest
WORKDIR /home
ADD deb_builder /home/deb_builder
ADD bin /home/bin
ADD src /home/src
COPY ./counter.service /home
COPY ./Makefile /home
RUN apt-get update
RUN apt-get --no-install-recommends -y install default-jre default-jdk junit lintian make systemd
RUN make build-deb-in-container
CMD ["java","-cp","./bin","counter"]
