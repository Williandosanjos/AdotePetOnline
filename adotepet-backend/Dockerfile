#Build stage
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

#Runtime stage
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

#Criar usuário não root para segurança
RUN addgroup -S spring && addser -S spring -G spring
USER spring:spring

COPY --from=build /app/target/*.jar app.jar

#Criar diretórios necessários
RUN mkdir -p /app/uploads /app/losg

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]