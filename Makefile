build:
	javac -cp /usr/share/java/junit-3.8.2.jar:. ./src/counter.java ./src/CounterTest.java
	sudo cp ./src/counter.class /lib/systemd/system/
	sudo mv ./src/counter.class ./src/CounterTest.class ./bin

test: build
	java -cp /usr/share/java/junit-3.8.2.jar:./bin CounterTest

clean:
	sh ./deb_builder/prerm
	sh ./deb_builder/postrm	

run:
	java -cp ./bin counter

build-deb: build
	sh ./deb_builder/preinst
	sh ./deb_builder/debBuild.sh
	sh ./deb_builder/postinst

lint-deb: build-deb
	-lintian counter-v2.0.0.deb

docker-image: build-deb
	rm -f Dockerfile
	touch Dockerfile
	echo "FROM ubuntu:latest" >> Dockerfile
	echo "WORKDIR /home" >> Dockerfile
	echo "ADD deb_builder /home/deb_builder" >> Dockerfile
	echo "ADD bin /home/bin" >> Dockerfile
	echo "ADD src /home/src" >> Dockerfile
	echo "COPY ./counter.service /home" >> Dockerfile
	echo "COPY ./Makefile /home" >> Dockerfile
	echo "RUN apt-get update" >> Dockerfile
	echo "RUN apt-get --no-install-recommends -y install default-jre default-jdk junit lintian make systemd" >> Dockerfile
	echo "RUN make build-deb-in-container" >> Dockerfile
	echo "CMD [\"java\",\"-cp\",\"./bin\",\"counter\"]" >> Dockerfile
	docker build -t counter:latest .

build-deb-in-container:
	javac -cp /usr/share/java/junit-3.8.2.jar:. ./src/counter.java ./src/CounterTest.java
	cp ./src/counter.class /lib/systemd/system/
	mv ./src/counter.class ./src/CounterTest.class ./bin
	cp ./bin/counter.class /etc/
	cp counter.service /lib/systemd/system/
	cp ./bin/counter.class /usr/local/bin
	sh ./deb_builder/debBuild.sh
	dpkg -i counter-v2.0.0.deb

lint-deb-in-container:
	-lintian counter-v2.0.0.deb

test-in-container: build-deb-in-container
	java -cp /usr/share/java/junit-3.8.2.jar:./bin CounterTest

docker-run:
	docker run --rm --mount type=bind,source=/tmp,target=/tmp counter:latest