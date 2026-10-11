@echo off
echo ui资源导出中...
cd scripts && node ExportUIToCdn.js
cd ..
svn ci laya/assets/resource/UIConfig.json -m "【提交配置】UIConfig.json"
"C:\Program Files\WinRAR\WinRAR.exe" a -k -r -ep1 -o+ -s -ibck laya\assets\resource\UIConfig.zip laya\assets\resource\UIConfig.json
svn ci laya/assets/resource/UIConfig.zip -m "【提交配置】UIConfig.zip"
cd scripts && node CopyUIConfigToCnd.js
cd ..
echo ui资源完成
