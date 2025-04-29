FROM openjdk:11-slim

COPY target/ROOT.war /app/app.war
# Java Agent 및 Exporter 설정파일 추가
COPY jmx_prometheus_javaagent-1.2.0.jar /app/
COPY exporter.yaml /app/
WORKDIR /app

# 앱 구동시 -javaagent 옵션으로 jmx 에이전트 추가
CMD ["java", "-Xms128m","-Xmx512m","-javaagent:jmx_prometheus_javaagent-1.2.0.jar=9090:exporter.yaml","-jar", "app.war"]
