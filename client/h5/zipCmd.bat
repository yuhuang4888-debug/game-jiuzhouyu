@echo off
Del laya\assets\resource\config.zip
echo 合并压缩config...
cd scripts && node mergeConfig.js
cd ..
svn ci laya/assets/resource/config.json -m "【提交配置】config.json"
"C:\Program Files\WinRAR\WinRAR.exe" a -k -r -ep1 -o+ -s -ibck laya\assets\resource\config.zip laya\assets\resource\config.json
svn ci laya/assets/resource/config.zip -m "【提交配置】config.zip"
"C:\Program Files\WinRAR\WinRAR.exe" a -k -r -ep1 -o+ -s -ibck laya\assets\resource\config\client\ClientProtocol.zip laya\assets\resource\config\client\ClientProtocol.json
svn ci laya/assets/resource/config/client/ClientProtocol.zip -m "【提交配置】ClientProtocol.zip"
