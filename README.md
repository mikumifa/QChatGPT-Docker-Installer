# README

### 项目地址[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)

本项目旨在为原项目提供一个简单的 Docker 部署方式，方便大家使用。

下述命令均在项目根目录下执行。

原项目地址：[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)

## 1. 安装 Docker和 Docker Compose

- [获取 Docker 桌面版 (已包含 Compose)](https://docs.docker.com/get-docker/)
- [中文](https://dockerdocs.cn/get-docker/index.html)
- [Linux参考此文章](https://blog.csdn.net/Hilaph/article/details/124295252)

## 2. 下载所需要文件

### i. 克隆仓库

```bash
git clone https://github.com/mikumifa/QChatGPT-Docker-Installer
cd QChatGPT-Docker-Installer
```

### ii. 进行部署

- `linux`系统可以直接使用loadFile.sh (已安装 git 和 wget)
```
chmod +x loadFile.sh && ./loadFile.sh 
```

- `windows`可以下载[ITXTech](https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip)和[RockChinQ/QChatGPT](https://github.com/RockChinQ/QChatGPT)

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

### i. 初始化mirai

```
docker compose run --rm mirai
```
> 上面这一步，windows操作系统的可能会报错`error during connect: This error may indicate that the docker daemon is not running` 
> 解决方式是CMD管理员模式`DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V`
等待安装，并按照提示操作登录。(第一次失败的话就，`Ctrl + C`退出，再重来一次)

### ii. 在mirai上登录QQ

```
login <机器人QQ号> <机器人QQ密码>
```
> 具体见[此教程](https://yiri-mirai.wybxc.cc/tutorials/01/configuration#4-%E7%99%BB%E5%BD%95-qq)

### iii. 配置自动登录

当机器人账号登录成功以后，执行
```
autologin add <机器人QQ号> <机器人密码>
autologin setConfig <机器人QQ号> protocol ANDROID_PAD
```

>出现`mirai登录时提示版本过低：当前QQ版本过低，请升级至最新版本后再登录。点击进入下载页面`报错时候删除`mirai/bots`文件夹里面的数据，见[此issue](https://github.com/RockChinQ/QChatGPT/issues/38)

完成后, `Ctrl + C` 退出。

### iv. 编写配置文件

- 在`bot`目录下创建`config.py`，将`config-template.py`的内容复制进去，编辑`config.py`修改**必需项**
- 在` mirai/config/net.mamoe.mirai-api-http` 文件夹中找到`setting.yml`，这是`mirai-api-http`的配置文件

  - 将这个文件的内容修改为：
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
`verifyKey`要求与`bot`的`config.py`中的`verifyKey`相同
## 4. 启动

### i. 启动mirai容器
```
docker compose run -itd mirai
```
此命令将在后台启动mirai容器

### ii. 启动主程序容器
```
docker compose run -itd setup
```
此命令将在后台启动主程序的容器并完成配置

<details>
<summary>❓如何将容器切到前台查看日志？</summary>

查看容器进程
```
docker ps
```
在输出中查看容器的ID，例如：
```
root@docker-test:~# docker ps
CONTAINER ID   IMAGE                             COMMAND                  CREATED              STATUS              PORTS     NAMES
f633b8c1051c   qchatgpt-docker-installer-setup   "/bin/sh -c 'python …"   About a minute ago   Up About a minute             qchatgpt-docker-installer_setup_run_998f5335ab18
227e44d7d5a2   qchatgpt-docker-installer-mirai   "/bin/sh -c 'java -j…"   2 minutes ago        Up 2 minutes                  qchatgpt-docker-installer_mirai_run_c6c8f60da3aa
```
若要切换到主程序控制台，请查看`IMAGE`名为`qchatgpt-docker-installer-setup`的容器的`CONTAINER ID`，在这里是`f633b8c1051c`，于是使用以下命令将其切到前台：
```
docker attach f633b
```
这是便可以看到主程序的控制台，查看mirai控制台同理  

如需将其切到后台运行，请使用组合键`Ctrl+P+Q`
```
root@docker-test:~# docker attach f633b
[2022-12-18 07:00:27.247] manager.py (173) - [INFO] : [person_1010553892]发送消息:2
[2022-12-18 07:00:27.248] util.py (67) - [INFO] : message='Request to OpenAI API' method=post path=https://api.openai.com/v1/completions
[2022-12-18 07:00:29.629] util.py (67) - [INFO] : message='OpenAI API response' path=https://api.openai.com/v1/completions processing_ms=872 request_id=6d9f172ce9c1b3f315aa59dc09333836 response_code=200
[2022-12-18 07:00:29.631] manager.py (195) - [INFO] : 回复[person_1010553892]消息:我不明白你的意思。输入!help获取帮助
read escape sequence
root@docker-test:~#
```
</details>
