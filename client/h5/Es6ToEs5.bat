@echo off
echo.
call Es6ToEs5Command.bat
echo 代码转换完成，提交svn中
svn add --force -q ../cdn/js
svn ci ../cdn/js -m "【es6toes5】提交转换代码"
echo end
