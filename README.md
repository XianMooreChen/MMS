<img src="http://logos-download.com/wp-content/uploads/2016/09/Docker_logo.png" alt="logo" width="140" height="140" align="right">

# MMS & NOC Dashboard For Docker

通过docker安装部署MMS及相关服务

## 安装前需准备

- Linux VM
- docker
- docker compose
- git

## MMS & NOC Dashboard 服务列表

### 端口映射参考

| docker镜像服务    | 宿主机端口 | docker容器端口 |
| :-------------------- | :----------- | :----------- |
| xianmoorechen/mms-tomcat | 8888 | 8080 |
| xianmoorechen/mms-mysql     | 3306 | 3306 |
| xianmoorechen/nocdashboard-tomcat   | 8889 | 8080 |
| xianmoorechen/nocdashboard-postgresql   | 5432 | 5432 |
| xianmoorechen/swbatch | - | - |
| xianmoorechen/switching-psql   | 5433 | 5432 |

### 数据库默认预设账密

| docker镜像服务    | 数据库名称 | 账号 | 密码 |
| :-------------------- | :----------- | :----------- | :----------- |
| xianmoorechen/mms-mysql     | mms | mms | mms |
| xianmoorechen/nocdashboard-postgresql   | swbatchdb | swbatch | swbatch |
| xianmoorechen/switching-psql   | mswdb | msw | mswmsw |

## 运行



### ✳step 1 clone所有文件

```
$ git clone https://github.com/XianMooreChen/MMS.git
```

> 完成后，结构如下：

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
├── postgres-data
├── swbatch
│   ├── batchswdb.conf
│   └── Dockerfile
└── switching-data
```


### ✳step 2 修改相关文件

#### 修改mms/system.config文件，mysql链接IP

```
$ vim mms/system.config
```

```javascript

[MMS_DATABASE]
url=jdbc:mysql://[IP]:3307/mms?useUnicode=true&characterEncoding=UTF-8&useOldAliasMetadataBehavior=true
```
> **[IP]**修改为docker所在宿主机的IP


#### 修改nocdashboard/constant.properties文件

```
$ vim nocdashboard/constant.properties
```

```javascript

WEB_SOCKET_IP=[IP]
WEB_SOCKET_HOST_PORT=8889

#postgresql
POST_DATABASE_SERVER_IP=[IP]
POST_DATABASE_HOST_PORT=5432


#mms
MMS_DATABASE_SERVER_IP=[IP]
MMS_DATABASE_HOST_PORT=3307

```

> **[IP]**，docker所在宿主机的IP
> 

#### 修改swbatch/batchswdb.conf文件

```
$ vim swbatch/constant.properties
```

```javascript
;[switching]
MswdbHostname = [IP]
MswdbPort = 5433

;[swbatch]
TransdbHostname = [IP]
TransdbPort = 5432

```

> **[IP]**，docker所在宿主机的IP
> 

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

## 访问服务

#### MMS访问链接

```
http://[IP]:8888/cyber-iatoms-web/logon.do
```

#### NOC Dashboard访问链接

```
http://[IP]:8889/cyber-iatoms-web/logon.do
```

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