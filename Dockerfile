
FROM maven:3.8.1-openjdk-11 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src


RUN mvn clean package -DskipTests

# Tomcat Stage
FROM tomcat:9.0-alpine



COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/


# Configure Tomcat Manager access dynamically using build arguments
RUN echo '<tomcat-users xmlns="http://tomcat.apache.org/xml" \
    version="1.0"> \
    <role rolename="manager-gui"/> \
    <role rolename="admin-gui"/> \
    <user username="admin" password="pass" roles="manager-gui,admin-gui"/> \
</tomcat-users>' > /usr/local/tomcat/conf/tomcat-users.xml

COPY context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
# Expose Tomcat's default HTTP port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
