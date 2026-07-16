# ---------- Build Stage ----------
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

COPY . .

RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:17-jre-jammy

# Non-root 사용자 생성
RUN groupadd -r spring && useradd -r -g spring spring

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

# 애플리케이션 파일 권한 변경
RUN chown spring:spring app.jar

# Non-root 사용자로 실행
USER spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
