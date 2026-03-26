# Stage 1: Build the Maven application
FROM maven:3.8.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY app/pom.xml .
# Copy source first to allow a single-pass build
COPY app/src ./src
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/portfolio-app-1.0.0.jar portfolio-app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "portfolio-app.jar"]
