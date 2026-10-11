echo off
set Pan=.\tools\compile-tools\node_modules
set File=.\tools\compile-tools\package.json
if exist %Pan% (
    echo clear node_modules
    cd .\tools\compile-tools
    if exist %File% (
        ren package.json package.json-bak
    )
    echo {} > package.json
    call npm prune
    del package.json
    if exist %File% (
        ren package.json-bak package.json
    )
    cd ..\..
)
echo clear root node_modules
ren package.json package.json-bak
echo {} > package.json
call npm prune
del package.json
ren package.json-bak package.json
call npm install --registry=https://registry.npm.taobao.org && copy /Y .\tools\compile-tools\egf.config.js.temp .\egf.config.js
svn propset svn:ignore ./egf.config.js .
svn propset svn:ignore .assetscache.json .
svn propset svn:ignore '*' node_modules/
