#!/bin/bash
git clone https://github.com/RockChinQ/QChatGPT
mv QChatGPT bot
wget -O mcl.zip https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip
unzip -o -d  ./mirai mcl.zip 
rm -rf mcl.zip
