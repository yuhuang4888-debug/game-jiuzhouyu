@echo off
echo.
echo 创建模块tsconfig.json文件中...
cd scripts && node createAllModule.js
cd ..
egret clean