<img src="http://logos-download.com/wp-content/uploads/2016/09/Docker_logo.png" alt="logo" width="140" height="140" align="right">

# MMS & Noc Dashboard For Docker

通过docker安装部署MMS及相关服务

## 安装前需准备

- Linux VM
- docker
- docker compose

## 运行

新建mms文件夹

```
$ mkdir mms
```

新建mms/mms文件夹，用于放system.config配置文件

```
$ mkdir mms/mms
```

新建mms/mms文件夹，用于MMS-mysql数据库Data volume （数据卷）

```
$ mkdir mms/data
```

进入mms文件夹

```
$ cd mms/
```



### 配置参数

```
$ node app.js -h
usage: unblockneteasemusic [-v] [-p port] [-u url] [-f host]
                           [-o source [source ...]] [-t token] [-e url] [-s]
                           [-h]

optional arguments:
  -v, --version               output the version number
  -p port, --port port        specify server port
  -u url, --proxy-url url     request through upstream proxy
  -f host, --force-host host  force the netease server ip
  -o source [source ...], --match-order source [source ...]
                              set priority of sources
  -t token, --token token     set up http basic authentication
  -e url, --endpoint url      replace virtual endpoint with public host
  -s, --strict                enable proxy limitation
  -h, --help                  output usage information
```

## 使用

**警告：本项目不提供线上 demo，请不要轻易信任使用他人提供的公开代理服务，以免发生安全问题**

**若将服务部署到公网，强烈建议使用严格模式 (此模式下仅放行网易云音乐所属域名的请求) `-s`  限制代理范围 (需使用 PAC 或 hosts)，~~或启用 Proxy Authentication `-t <name>:<password>` 设置代理用户名密码~~ (目前密码认证在 Windows 客户端设置和 macOS 系统设置都无法生效，请不要使用)，以防代理被他人滥用**

支持 Windows 客户端，UWP 客户端，Linux 客户端 (1.2 版本以上需要自签证书 MITM，启动客户端需要增加 `--ignore-certificate-errors` 参数)，macOS 客户端 (726 版本以上需要自签证书)，iOS 客户端 (配置 https endpoint 或使用自签证书)，Android 客户端和网页版 (需要自签证书，需要脚本配合)

目前除 UWP 外其它客户端均优先请求 HTTPS 接口，默认配置下本代理对网易云所有 HTTPS API 连接返回空数据，促使客户端降级使用 HTTP 接口 (新版 Linux 客户端和 macOS 客户端已无法降级)

因 UWP 应用存在网络隔离，限制流量发送到本机，若使用的代理在 localhost，或修改的 hosts 指向 localhost，需为 "网易云音乐 UWP" 手动开启 loopback 才能使用，请以**管理员身份**执行命令

```powershell
checknetisolation loopbackexempt -a -n="1F8B0F94.122165AE053F_j2p0p5q0044a6"
```

### step 1 新建文件夹

新建mms文件夹

```
$ mkdir mms
```

新建mms/mms文件夹，用于放system.config配置文件

```
$ mkdir mms/mms
```

新建mms/mms文件夹，用于MMS-mysql数据库Data volume （数据卷）

```
$ mkdir mms/data
```

进入mms文件夹

```
$ cd mms/
```

> 此步骤建立MMS相关文件路径 
>


### step 2 新建相关文件

新建docker-compose.yml文件

```
$ vim docker-compose.yml
```

```javascript

version: "2"

networks:
  mms:

services:
  mms-app:
    build: mms
    networks:
      - mms
    depends_on:
      - db
    ports:
      - "8888:8080"
  db:
    image: "xianmoorechen/mms-mysql:latest"
    networks:
      - mms
    volumes:
      - $PWD/data:/var/lib/mysql
    ports:
      - "3306:3306"
```

| 服务    | 宿主机端口 |
| :------ | :------------------------------- |
| mms-tomcat | 8888 |
| mms-mysql     | 3306 |
| nocdashboard-tomcat   | 8889 |
| nocdashboard-postgresql   | 5432 |
| swbatch | WLAN > 修改网络 > 高级选项 > 代理 |

新建Dockerfile文件

```
$ vim mms/Dockerfile
```

```javascript

FROM xianmoorechen/mms-tomcat

MAINTAINER MMS XXXX@gmail.com

COPY ./system.config /usr/local/tomcat/webapps/cyber-iatoms-web/WEB-INF/classes
```

新建system.config文件

```
$ vim mms/system.config
```

```javascript

[MMS_DATABASE]
url=jdbc:mysql://[your vm IP]:[mysqlPort]/mms?useUnicode=true&characterEncoding=UTF-8&useOldAliasMetadataBehavior=true
user=cl7IBrG/bce0J+1OKem+AwgDlklQKsRivwIrnDHnFRY=
pwd=cl7IBrG/bce0J+1OKem+AwgDlklQKsRivwIrnDHnFRY=
```

> your vm IP docker所在宿主机的IP
> **mysqlPort**，mms-mysql将映射至宿主机之端口，此处建议3306
> 全部新建后，结构如下：
> ├── data
> ├── docker-compose.yml
> └── mms
>     ├── Dockerfile
>     └── system.config
> 

### ✳step 3 运行

运行

```
$ docker-compose up -d
```

```javascript
const match = require('unblockneteasemusic')

/** 
 * Set proxy or hosts if needed
 */
global.proxy = require('url').parse('http://127.0.0.1:1080')
global.hosts = {'i.y.qq.com': '59.37.96.220'}

/**
 * Find matching song from other platforms
 * @param {Number} id netease song id
 * @param {Array<String>||undefined} source support netease, qq, xiami, baidu, kugou, kuwo, migu, joox
 * @return {Promise<Object>}
 */
match(418602084, ['netease', 'qq', 'xiami', 'baidu']).then(song => console.log(song))
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