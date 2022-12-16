# README

# 项目地址[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)

本项目旨在为原项目提供一个简单的 Docker 部署方式，方便大家使用。

下述命令均在项目根目录下执行。

原项目地址：[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)

## 1. 安装 Docker和 Docker Compose

- [获取 Docker 桌面版 (已包含 Compose)](https://docs.docker.com/get-docker/)
- [中文](https://dockerdocs.cn/get-docker/index.html)

## 2. 下载所需要文件
`linux`系统可以直接使用loadFile.sh (已安装 git 和 wget)
```
chmod +x loadFile.sh && ./loadFile.sh 
```

`windows`可以下载[ITXTech](https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip)和[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)，把`requirements.txt`放入`bot`目录里面

最终效果如下，`bot`目录内是当前的[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)项目里面的内容,`mirai`目录内是[ITXTech](https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip)下载后解压到`mirai`里面

```
.
├── bot
│   ├── config-template.py
│   ├── LICENSE
│   ├── main.py
│   ├── pkg
│   ├── README.md
│   ├── requirements.txt
│   ├── res
│   ├── sensitive.json
│   └── tests
├── docker-compose.yaml
├── loadFile.sh
├── mirai
│   ├── LICENSE
│   ├── mcl
│   ├── mcl.cmd
│   ├── mcl.jar
│   └── README.md
├── _mirai.Dockerfile
└── _setup.Dockerfile
```
## 3. 配置 启动mirai

`docker compose run --rm mirai`
> 上面这一步，windows操作系统的可能会报错`error during connect: This error may indicate that the docker daemon is not running` 
> 解决方式是CMD管理员模式`DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V`
等待安装，并按照提示操作登录。(第一次失败的话就，`Ctrl + C`退出，再重来一次)

具体见[4.登录QQ](https://yiri-mirai.wybxc.cc/tutorials/01/configuration)

当机器人账号登录成功以后，执行

`autologin add <机器人QQ号> <机器人密码>`(必要)

`autologin setConfig <机器人QQ号> protocol ANDROID_PAD`(必要)

成功后, `Ctrl + C` 退出。

之后重新打开目录`bot`，根据`config-template.py`写一个`config.py`文件（`config.py`放在`bot`文件夹里面）
配置详细见[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)的`README`


退出 mirai-console，在` mirai/config/net.mamoe.mirai-api-http` 文件夹中找到` setting.yml`，这是` mirai-api-http `的配置文件。

将这个文件的内容修改为：
```
adapters:
  - ws
debug: true
enableVerify: true
verifyKey: yirimirai
singleMode: false
cacheSize: 4096
adapterSettings:
  ws:
    host: localhost
    port: 8080
    reservedSyncId: -1
```
`verifyKey`随便设置,只要和bot的`config.py`中的`verifyKey`一样即可
## 4. 启动

`docker compose up ` 将在前台启动。

`docker compose up -d` 将在后台启动。

注意，只有在mirai执行成功的后，setup启动才不会出错，如果出错， `Ctrl + C`退出.
先输入`docker compose run -d mirai`执行mirai
再输入 `docker compose run -d setup` 执行机器人(参数`-d`是后台运行的意思)
