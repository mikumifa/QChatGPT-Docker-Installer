#! /bin/sh
git clone https://gitee.com/mikumifa/QChatGPT
mv QChatGPT bot
wget -O mcl.zip https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip
unzip -o -d  ./mirai mcl.zip 
rm mcl.zip
