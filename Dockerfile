# ---------- Build Stage ----------
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

COPY . .

RUN chmod +x mvnw && ./mvnw clean package -DskipTests

# ---------- Runtime Stage ----------
FROM eclipse-temurin:17-jre-jammy

# Non-root 사용자 생성 (UID/GID 1000 고정)
RUN groupadd -g 1000 spring && \
    useradd -u 1000 -g spring -m spring

WORKDIR /app

COPY --from=builder /app/target/*.jar app.jar

# 파일 권한 변경 (root 권한으로 수행)
RUN chown spring:spring app.jar

# 마지막에 일반 사용자로 변경
USER spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
