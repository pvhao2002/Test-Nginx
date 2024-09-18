# Base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and MySQL
RUN apt-get update && \
    apt-get install -y wget lsb-release gnupg && \
    wget https://dev.mysql.com/get/mysql-apt-config_0.8.17-1_all.deb && \
    dpkg -i mysql-apt-config_0.8.17-1_all.deb && \
    apt-get update && \
    apt-get install -y mysql-server supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Start MySQL and set root password to '1234'
RUN service mysql start && \
    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '1234';" && \
    mysql -u root -p1234 -e "FLUSH PRIVILEGES;"

FROM openjdk:21-jdk-slim
# Add the application JARs
COPY --from=kira2308/service1 /target/*.jar /app/service1.jar
COPY --from=kira2308/service2 /target/*.jar /app/service2.jar
# Expose the ports
EXPOSE 8081 8082 3306
# Copy supervisord configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# Start supervisor to manage both Java services and MySQL
CMD ["/usr/bin/supervisord"]
