
# We are basing this container off of the official Docker Hub Java container
From openjdk:8-alpine
RUN apk update && apk add tar bash curl openssl python bzip2

RUN apk upgrade

# Set the Maven Version
ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"

# Download maven and install
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.3.9/apache-maven-3.3.9-bin.tar.gz \
    | tar -xzC /usr/share/maven --strip-components=1 \
&& ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ARG BUILD_NUMBER

# Set the working directory of the container
COPY . /usr/src/springadmindemo
WORKDIR /usr/src/springadmindemo

# Create mvn package
RUN mvn package

RUN cp target/spring-boot-admin-0.0.1-SNAPSHOT.jar target/app.jar

# launch the Spring Boot application
CMD java -Djava.security.egd=file:/dev/./urandom -Xmx512m -jar target/app.jar