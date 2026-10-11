@echo off

echo.
echo 创建资源版本号文件中...
cd scripts && node createResourceVersion.js
svn ci ../laya/assets/resource/global_version_number.json -m "【版本】提交大版本号文件"
svn ci ../laya/assets/resource/resource_version.json -m "【版本】提交游戏每个资源所对应版本号文件"
cd ..
Del laya\assets\resource\resource_version.zip
"C:\Program Files\WinRAR\WinRAR.exe" a -k -r -ep1 -o+ -s -ibck laya\assets\resource\resource_version.zip laya\assets\resource\resource_version.json
svn ci laya/assets/resource/resource_version.zip -m "【提交配置】resource_version.zip"
echo 创建资源版本号文件【完成】








