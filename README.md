# JMX Exporter Sample

exporter agent와 함께 java실행
JVM -> jmx mbeans <-> jmx exporter -> expose metrics <- scrape <-> prometheus

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
# Run
### mvnw
```aidl
mvnw spring-boot:run
```
### war
```aidl
java -jar <WARFILE>.war
```
# Build
```aidl
mvnw package
```
# Java Command
Compile -> .class
```aidl
javac <JAVAFILE>.java
```
Excuting Class
```aidl
java <ClassName>
```
Excuting JAR or WAR
```aidl
java -jar <FILENAME>.jar or <FILENAME>.war 
```
# Azure DevOps Pipeline
```
PR -> Approve or Deny -> Merge -> Trigger Pipeline -> (Main branch)Maven Build & Test -> Artifact(WAR) -> Trigger Release -> Approve or Deny -> Deploy Webapp(dev Slot) -> Approve or Deny -> Swap Production 
```
### Maven Build
1. POM.xml
Maven Build시 WAR 파일 이름 규칙
```
<finalName>ROOT</finalName>
```
### Reference
[Spring GetStarted](https://spring.io/guides/gs/serving-web-content/)
 