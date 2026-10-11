@echo off
echo.
echo 创建模块tsconfig.json文件中...
cd scripts && node CheckModuleAtlasDependentSmell.js
cd ..
egret clean