# start with a base image
FROM openjdk:21-jdk-slim as base

# Install necessary packages
RUN apt-get update && \
    apt-get install -y mysql-server supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure MySQL and set root password
RUN service mysql start && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';" && \
    mysql -u root -p1234 -e "FLUSH PRIVILEGES;"

# Add the application JARs
COPY --from=kira2308/service1 /target/*.jar /app/service1.jar
COPY --from=kira2308/service2 /target/*.jar /app/service2.jar

# Expose the ports
EXPOSE 8081 8082 3306
# Copy supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Start supervisor to manage both Java services and MySQL
CMD ["/usr/bin/supervisord"]
