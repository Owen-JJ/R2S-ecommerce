FROM openjdk:17
WORKDIR /app
COPY target/MartfuryShop-1.0.jar /app/MartfuryShop-1.0.jar
ENTRYPOINT ["java", "-jar", "MartfuryShop-1.0.jar"]