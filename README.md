# Java App with JMX Exporter

> JVM -> jmx mbeans <-> jmx exporter -> expose metrics <- scrape <-> prometheus

## JMX Exporter Usage
### Run Java App with JMX Exporter
1. Download JMX Exporter

    https://prometheus.github.io/jmx_exporter/1.2.0/java-agent/

2. Run Java App
    ```bash
    java -javaagent:jmx_prometheus_javaagent-1.2.0.jar=12345:exporter.yaml -jar <YOUR_APPLICATION.JAR>
    ```
### Make Docker Image
1. Download JMX Exporter

    https://prometheus.github.io/jmx_exporter/1.2.0/java-agent/

2. Create exporter.yaml
    ```yaml
    # default values
    rules:

    - pattern: ".*"
    ```
3. Build Docker Image
    ```Dockerfile
    FROM openjdk:11-slim

    COPY target/ROOT.war /app/app.war
    # Java Agent 및 Exporter 설정파일 추가
    COPY jmx_prometheus_javaagent-1.2.0.jar /app/
    COPY exporter.yaml /app/
    WORKDIR /app

    # 앱 구동시 -javaagent 옵션으로 jmx 에이전트 추가
    CMD ["java", "-Xms128m","-Xmx512m","-javaagent:jmx_prometheus_javaagent-1.2.0.jar=9090:exporter.yaml","-jar", "app.war"]
    ```

4. Deploy Kubernetes Deployment
    ```yaml
    # 메트릭 포트 지정 (포트 이름 metrics 로 표시(권장))
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: sample-java-app
    spec:
    selector:
        matchLabels:
        app: sample-java-app
    template:
        metadata:
        labels:
            app: sample-java-app
        spec:
        containers:
        - name: sample-java-app
            image: hyukjun/jmx-exporter-sample:0.3
            resources:
            limits:
                memory: "256Mi"
                cpu: "500m"
            ports:
            # JMX 익스포터 포트 (메트릭 노출 엔드포인트)
            - containerPort: 9090
            name: metrics
            - containerPort: 80
            name: http
    ```

5. Deploy PodMonitor
    ```yaml
    # 프로메테우스 서비스디스커버리
    apiVersion: monitoring.coreos.com/v1
    kind: PodMonitor
    metadata:
    name: sample-java-app-podmonitor
    spec:
    selector:
        matchLabels:
        app: sample-java-app
    podMetricsEndpoints:
        - port: metrics # 파드 메트릭 포트
        path: /metrics # URL 엔드포인트
        interval: 15s
    ```

6. Check Metrics on Prometheus, Grafana 

## Application Setup
```markdown
# Spring Initailizer
- Maven Project
- Java Version: 8 (OpenJDK 1.8)
- Spring Boot: 2.4.5
- Packaging: War
- Dependancies   
    - Spring Web
    - Thymeleaf
    - Spring Boot DevTools
# Server side
- Tomcat 9.0
```

## Build and Run Java App
```markdown
# Run
mvnw spring-boot:run
java -jar <WARFILE>.war

# Build
mvnw package
# pom.xml -> WAR Filename
<finalName>ROOT</finalName>

# Compile (generate .class)
javac <JAVAFILE>.java

# Excuting Class
java <ClassName>

# Excuting JAR or WAR
java -jar <FILENAME>.jar or <FILENAME>.war 
```

## References
[Spring GetStarted](https://spring.io/guides/gs/serving-web-content/)
 