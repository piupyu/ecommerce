FROM maven:3.8.3-jdk-11-slim AS build

WORKDIR /project

COPY pom.xml .
RUN mvn dependency:go-offline

COPY . .
RUN mvn clean package

FROM adoptopenjdk:11-jre-hotspot

ENV PROFILE=dev

WORKDIR /app

COPY --from=build /project/target/app.war /app/app.war
RUN chmod +x /app/app.war

EXPOSE 8080

CMD ["java", "-jar", "app.jar"]
