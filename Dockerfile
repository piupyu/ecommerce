FROM maven:3.8.3-jdk-11-slim AS build

RUN mkdir /project

COPY . /project

WORKDIR /project

RUN mvn clean package

FROM adoptopenjdk:11-jre-hotspot

RUN mkdir /app

COPY --from=build /project/target/app.war /app/app.war

ENV PROFILE=prd

WORKDIR /app


EXPOSE 8080

ENTRYPOINT ["java", "-Dspring.profiles.active=${PROFILE}", "-jar", "app.war"]