FROM kira2308/service1 as service1
FROM kira2308/service2 as service2

COPY --from=service1 /target/*.jar app.jar
COPY --from=service2 /target/*.jar app2.jar

EXPOSE 8081
EXPOSE 8082

CMD ["java", "-jar", "app.jar"]
CMD ["java", "-jar", "app2.jar"]

