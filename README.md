<img src="http://logos-download.com/wp-content/uploads/2016/09/Docker_logo.png" alt="logo" width="140" height="140" align="right">

# MMS & NOC Dashboard For Docker

通过docker安装部署MMS及相关服务

## 安装前需准备

- Linux VM
- docker
- docker compose

## MMS & NOC Dashboard 服务列表

### 端口映射参考

| docker镜像服务    | 宿主机端口 | docker容器端口 |
| :-------------------- | :----------- | :----------- |
| xianmoorechen/mms-tomcat | 8888 | 8080 |
| xianmoorechen/mms-mysql     | 3306 | 3306 |
| xianmoorechen/nocdashboard-tomcat   | 8889 | 8080 |
| xianmoorechen/nocdashboard-postgresql   | 5432 | 5432 |
| xianmoorechen/swbatch | - | - |


### 默认配置账密

| docker镜像服务    | 账号 | 密码 |
| :-------------------- | :----------- | :----------- |
| xianmoorechen/mms-tomcat | admin | 1qaz2wsx |
| xianmoorechen/mms-mysql     | mms | mms |
| xianmoorechen/nocdashboard-tomcat   | - | - |
| xianmoorechen/nocdashboard-postgresql   | swbatch | swbatch |
| xianmoorechen/swbatch | - | - |

## 运行



### ✳step 1 新建文件夹

新建mms文件夹，用于放system.config配置文件

```
$ mkdir mms
```

新建mysql-data文件夹，用于mysql数据库Data volume （数据卷）

```
$ mkdir mysql-data
```

新建nocdashboard文件夹，用于放自定义constant.properties配置文件

```
$ mkdir nocdashboard
```

新建postgres-data文件夹，用于postgres数据库Data volume （数据卷）

```
$ mkdir postgres-data
```

> 此步骤建立MMS相关文件路径 
>
> 全部新建后，结构如下：

```
.
├── mms
├── mysql-data
├── nocdashboard
└── postgres-data
```

### ✳step 2 新建相关文件

#### 新建docker-compose.yml文件

```
$ vim docker-compose.yml
```

```javascript

version: "2"

networks:
  mms-nocdashboard:

services:
  mms-app:
    build: mms
    networks:
      - mms-nocdashboard
    depends_on:
      - mmsdb
    ports:
      - "8888:8080"
  mmsdb:
    image: "xianmoorechen/mms-mysql:latest"
    container_name: "mms-mysql-container"
    networks:
      - mms-nocdashboard
    environment:
      MYSQL_ROOT_PASSWORD: mysqlroot
    volumes:
      - $PWD/mysql-data:/var/lib/mysql
    ports:
      - "3307:3306"
  nocdashboard-app:
    build: nocdashboard
    networks:
      - mms-nocdashboard
    depends_on:
      - mmsdb
      - swbatchdb
    ports:
      - "8889:8080"
  swbatchdb:
    image: "xianmoorechen/nocdashboard-psql:latest"
    container_name: "nocdashboard-postgres-container"
    networks:
      - mms-nocdashboard
    volumes:
      - $PWD/postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
```

| 服务    | 宿主机端口 |
| :------ | :------------------------------- |
| mms-tomcat | 8888 |
| mms-mysql     | 3307 |
| nocdashboard-tomcat   | 8889 |
| nocdashboard-postgresql   | 5432 |
| swbatch |  |

#### 新建mms/Dockerfile文件

```
$ vim mms/Dockerfile
```

```javascript

FROM xianmoorechen/mms-tomcat

MAINTAINER MMS XXXX@gmail.com

COPY ./system.config /usr/local/tomcat/webapps/cyber-iatoms-web/WEB-INF/classes
```

#### 新建mms/system.config文件

```
$ vim mms/system.config
```

```javascript

[MMS_DATABASE]
url=jdbc:mysql://[vm IP]:[mysqlPort]/mms?useUnicode=true&characterEncoding=UTF-8&useOldAliasMetadataBehavior=true
user=cl7IBrG/bce0J+1OKem+AwgDlklQKsRivwIrnDHnFRY=
pwd=cl7IBrG/bce0J+1OKem+AwgDlklQKsRivwIrnDHnFRY=
```

#### 新建mms/Dockerfile文件

```
$ vim nocdashboard/Dockerfile
```

```javascript

FROM xianmoorechen/nocdashboard-tomcat

MAINTAINER MMS XXXX@gmail.com

COPY ./constant.properties /usr/local/tomcat/webapps/banktrans/WEB-INF/classes/me/gacl/websocket
```

新建nocdashboard/constant.properties文件

```
$ vim nocdashboard/constant.properties
```

```javascript

WEB_SOCKET_IP=192.168.93.68
WEB_SOCKET_HOST_PORT=8889
SWITCHING_IP=127.0.0.1
SWITCHING_PORT=2000

#postgresql
POST_DATABASE_SERVER_IP=192.168.93.68
POST_DATABASE_HOST_PORT=5432
POST_DATABASE_NAME=swbatchdb
POST_USERNAME=swbatch
POST_PASSWORD=swbatch
POST_SERVER_ID = 2

#mms
MMS_DATABASE_SERVER_IP=192.168.93.68
MMS_DATABASE_HOST_PORT=3307
MMS_DATABASE_NAME=mms
MMS_USERNAME=mms
MMS_PASSWORD=mms
```

> **vm IP**，docker所在宿主机的IP
> 
> **mysqlPort**，mms-mysql将映射至宿主机之端口，此处建议3306
> 
> 全部新建后，结构如下：

```
.
├── docker-compose.yml
├── mms
│   ├── Dockerfile
│   └── system.config
├── mysql-data
├── nocdashboard
│   ├── constant.properties
│   └── Dockerfile
└── postgres-data
```


### ✳step 3 运行

运行

```
$ docker-compose up -d
```

控制台打印如下讯息：

```javascript
Creating network "mms_mms-nocdashboard" with the default driver
Building mms-app
Step 1/3 : FROM xianmoorechen/mms-tomcat
 ---> 2edbc4a88052
Step 2/3 : MAINTAINER MooreChen chen68573397@126.com
 ---> Running in 191d3bd6c0ce
Removing intermediate container 191d3bd6c0ce
 ---> 8edbaa581373
Step 3/3 : COPY ./system.config /usr/local/tomcat/webapps/cyber-iatoms-web/WEB-INF/classes
 ---> 13f47c5cc8f5
Successfully built 13f47c5cc8f5
Successfully tagged mms_mms-app:latest
Building nocdashboard-app
Step 1/3 : FROM xianmoorechen/nocdashboard-tomcat
 ---> b45ffbafbaf7
Step 2/3 : MAINTAINER MooreChen chen68573397@126.com
 ---> Running in 545fdc56df92
Removing intermediate container 545fdc56df92
 ---> 25a08994b101
Step 3/3 : COPY ./constant.properties /usr/local/tomcat/webapps/banktrans/WEB-INF/classes/me/gacl/websocket
 ---> 044bc3be4493
Successfully built 044bc3be4493
Successfully tagged mms_nocdashboard-app:latest
Creating mms-mysql-container ... 
Creating nocdashboard-postgres-container ... 
Creating nocdashboard-postgres-container
Creating mms-mysql-container ... done
Creating mms_mms-app_1 ... 
Creating nocdashboard-postgres-container ... done
Creating mms_nocdashboard-app_1 ... 
Creating mms_mms-app_1 ... done

```

## 初始化

#### MMS初始化设定

#### NOC Dashboard初始化设定


## MMS效果

#### Web

<img src="https://user-images.githubusercontent.com/33479569/60001724-a7bf3700-9699-11e9-8b08-1e84cc9082a2.png" width="100%">

#### Android APP

<img src="https://user-images.githubusercontent.com/33479569/60001876-0d132800-969a-11e9-86e3-0f891a57a013.png" width="50%">

## NOC Dashboard 效果

#### PC/Mac Web

<img src="https://user-images.githubusercontent.com/33479569/60002532-67f94f00-969b-11e9-854b-5f21ed7cdb80.png" width="100%">

#### Phone Web

<img src="https://user-images.githubusercontent.com/33479569/60002454-40a28200-969b-11e9-91b3-08db2011e907.png" width="100%">

## 相关参考

视频类

[Docker入门](https://www.imooc.com/learn/867)

[第一个docker化的java应用](https://www.imooc.com/learn/824)

网站

[Linux Ubuntu 16.04 安装Docker](https://blog.csdn.net/u012002805/article/details/80767814)

[ubuntu16.04安装最新版docker、docker-compose](https://www.cnblogs.com/tianhei/p/7802064.html)

## 许可

The MIT License