# Triển khai springboot application với mysql trên docker 

## DATABASE

Kéo cơ sở dữ liệu mysql từ docker
``` terminal
$ docker pull mysql
```

Tạo container mysql
``` terminal
$ docker run -p 3307:3306 --name mysqldb -e MYSQL_ROOT_PASSWORD=your_pass_word -e MYSQL_DATABASE=test -d mysql
```
- Với mysqldb là tên container 
- 3307:3306 là ánh xạ của cổng 3306 của mysql lên cổng 3307
- Nhớ thay đổi tên cơ sở dữ liệu và mật khẩu; mật khẩu này là mật khẩu mới, chứ không phải mật khẩu cho cổng 3306


## Config springboot application
Vào application.properties 
``` Java
spring.datasource.url=jdbc:mysql://${MYSQL_HOST:localhost}:${MYSQL_PORT:3306}/${MYSQL_DB_NAME:test}
spring.datasource.username=${MYSQL_USER:root}
spring.datasource.password=${MYSQL_PASSWORD: your_pass_word}
```

## Network
Khi đẩy lên docker, ứng dụng sẽ không hiểu được việc lấy cổng localhost nên chúng ta phải sử dụng network để kết nối chúng lại với nhau 

Tạo network
``` terminal
docker network create netmysql
```
- netmysql là tên network 

Kết nối network với mysql container
``` terminal
docker network connect netmysql mysqldb
```

## File .jar và dockerfile
### File .jar
- Dùng lệnh ```mvn clean package``` hoặc bấm vào biểu tượng Maven ở bên phải khung hình sau đó chọn clean và package
- Khi đó ứng dụng sẽ tiến hành thực hiện tạo file .jar
- Sau khi chạy xong thì file .jar sẽ nằm trong folder test; ngoài file .jar, chúng ta sẽ có thêm file .jar.original

### Dockerfile
Tạo dockerfile có cùng cấp với file pom.xml, không cần đuôi file

``` Dockerfile
FROM openjdk:11
WORKDIR /app
COPY target/*.jar /app/*.jar
ENTRYPOINT ["java", "-jar", "*.jar"]
```
- Ghi chú: thay dấu ‘*’ thành tên của bạn

## Đẩy springboot application lên docker 
Tạo images
``` terminal
docker build -t spring-app .
```
- spring-app là tên images

Tạo container và chạy 
``` Terminal
docker run -p 8081:8080 --name testing --net netmysql -e MYSQL_HOST=mysqldb -e MYSQL_PORT=3306 -e MYSQL_DB_NAME=test -e MYSQL_USER=root -e MYSQL_PASSWORD=your_ pass_word spring-app
```
- 8081:8080 là ánh xạ cổng 8080 của springboot 

#### Khi này, ứng dụng của các bạn đã chạy được trên docker và kết nối được với cơ sở dữ liệu 