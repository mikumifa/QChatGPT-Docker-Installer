#!/bin/bash
git clone https://github.com/RockChinQ/QChatGPT
mv QChatGPT bot
wget https://github.com/iTXTech/mirai-console-loader/releases/download/v2.1.2/mcl-2.1.2.zip
unzip mcl-2.1.2.zip
mv mcl-2.1.2 mirai
rm -rf mcl-2.1.2.zip
