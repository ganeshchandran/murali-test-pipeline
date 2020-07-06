FROM tomcat:8.0
COPY target/*.war /usr/local/tomcat/webapps/myapp.war
EXPOSE 8080
