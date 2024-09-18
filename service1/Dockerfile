FROM jelastic/maven:3.9.5-openjdk-21 as build
COPY . .
RUN mvn clean package -DskipTests

FROM openjdk:21-jdk-slim
COPY --from=build /target/*.jar app.jar
EXPOSE 8081
CMD ["java", "-jar", "app.jar"]
