FROM openjdk:17
WORKDIR /app
COPY target/R2Sshop_ECommerce-0.0.1-SNAPSHOT.jar /app/R2Sshop_ECommerce-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "R2Sshop_ECommerce-0.0.1-SNAPSHOT.jar"]