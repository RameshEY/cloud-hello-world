FROM openjdk:8u131-jre
MAINTAINER Marcus Barcelos <mvlbarcelos@gmail.com>

VOLUME /tmp
ADD target/helloworld.jar /tmp/helloworld.jar

EXPOSE 8080

CMD java -jar -Dspring.profiles.active=$ENV /tmp/helloworld.jar