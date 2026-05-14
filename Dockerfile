# Stage 1: Build the Maven application
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
# Copy source first to allow a single-pass build
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/portfolio-0.0.1-SNAPSHOT.jar portfolio-app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "portfolio-app.jar"]
