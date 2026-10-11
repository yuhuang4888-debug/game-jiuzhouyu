var fs = require('fs');
const path = require("path");
var SVN = require("node.svn");
var EventEmitter = require('events').EventEmitter;
var fileUtils = require("./libs/fileUtils.js");

var filterConfig = [
    "laya/assets/resource/resource_version.json"
];
var config = {
    "cwd" : process.cwd()+"/../",
    "username" : "username",
    "password" : "password"
};

var exportFile = config.cwd + "laya/assets/resource/resource_version.json";
var main_version_file = config.cwd + "laya/assets/resource/game_manul_version.json";
var singleExportNum = 1000;

var svn = new SVN(config);
var ee = new EventEmitter();
var replace_msg_list = [
    "resource/game/",
    "resource/config/",
    "resource/object/",
    "resource/effect/",
    "resource/font/"
]

var allFiles = [];
var pagesFiles = []
var obj = {};
var dirNum = 0;
var dirNum_complate = 0;
var getFileVersion_start_time = 0
var all_version_count = 0
function foreachAllResourceFiles(root, save_as_directory) {
    // console.log(root)
    dirNum++;
    fs.readdir(root, function(err, files){
        if(err || files.length == 0){
            ee.emit("fileForeachComplate");
            return;
        }

        for(var i = 0, len = files.length; i<len; i++){
            var file = files[i];
            var filePath = root + "/" + file;
            var exportFilePath = filePath.replace(config.cwd, "");

            if(fileFilter(exportFilePath) == false){
                if(!fileUtils.isDirectory(filePath)) {
                    allFiles.push(filePath);
                }else{
                    // if(exportFilePath != "laya/assets/resource/assets")// && exportFilePath != "laya/assets/resource/config")
                    // {
                        if(save_as_directory == true
                        && exportFilePath != "laya/assets/resource/game/goodsIcon" 
                        && exportFilePath != "laya/assets/resource/game/dsgtIcon" 
                        && exportFilePath != "laya/assets/resource/game/skillIcon" 
                        && exportFilePath != "laya/assets/resource/game/monsterHead" 
                        && exportFilePath != "laya/assets/resource/game/bigBg")
                        {
                            if(exportFilePath.indexOf("laya/assets/resource/game/scene") == -1)
                            {
                                allFiles.push(filePath);
                                if(filePath.indexOf("laya/assets/resource/game") >= 0)
                                {
                                    pagesFiles.push(filePath.replace("/assets/", "/pages/")); //解决同一帧处理assets和pages返回相同版本号问题
                                }
                            }else
                            {
                                if(exportFilePath == "laya/assets/resource/game/scene"
                                    || exportFilePath == "laya/assets/resource/game/scene/map"
                                    || exportFilePath == "laya/assets/resource/game/scene/dragonBones"
                                    )
                                {
                                    foreachAllResourceFiles(filePath, true);
                                }else
                                {
                                    allFiles.push(filePath);
                                }
                            }
                        }else
                        {
                            if(exportFilePath == "laya/assets/resource/game")
                            {
                                foreachAllResourceFiles(filePath, true);
                            }else
                            {
                                foreachAllResourceFiles(filePath, false);
                            }
                        }
                    // }
                }
            }

            if(i == len-1){
                ee.emit("fileForeachComplate");
            }
        }
    });
}


function fileFilter(path){
     filterConfig.forEach(function(filePath){
        if(filePath.indexOf(path) != -1)
        {
            return true
        }
    });
     return false
}

var is_first_getfile_version = true
var getfile_version_completed = false
var start_get_svn_version_count = 0
var end_get_svn_version_count = 0
function getFileVersion(){
    let count = 1
    if(is_first_getfile_version)
    {
        count = singleExportNum
        is_first_getfile_version = false
    }
    for(var i = 0; i < count; i ++)
    {
        let filePath = allFiles.shift()
        if(filePath)
        {
            ++ start_get_svn_version_count
            svn.info(filePath, function (err, info) {
                ++ end_get_svn_version_count
                if(err == null){
                    let path = filePath.replace(config.cwd, "");
                    let check_str = "resource/"
                    let start_index = path.indexOf(check_str)
                    if(start_index >= 0)
                    {
                        path = path.substring(start_index)
                    }
                    check_str = path.match(/resource\/\w+\/+/)
                    if(check_str)
                    {
                        check_str = check_str.toString()
                        if(replace_msg_list.indexOf(check_str) >= 0)
                        {
                            path = path.substring(check_str.length)
                        }
                    }
                    let curr_value = obj[path]
                    if(path.indexOf("uiComponent") >= 0 || path.indexOf("vipGift") >= 0)
                        console.log(filePath, path, !curr_value, curr_value, info.lastchangedrev, 1 * info.lastchangedrev > curr_value);
                    if(!curr_value || 1 * info.lastchangedrev > curr_value)
                    {
                        curr_value = 1 * info.lastchangedrev
                    }
                    
                    obj[path] = curr_value;
                }else{
                    console.log(filePath, "get svn error");
                }
                if(all_version_count == end_get_svn_version_count)
                {
                    saveConfigFile();
                    return
                }
                getFileVersion()
                return
            });
        }else
        {
            return
        }
    }
}

function saveConfigFile(){
    if(getfile_version_completed) return
    getfile_version_completed = true
    console.log("---getFileVersion end time =", new Date().getTime() - getFileVersion_start_time)
    fileUtils.save(exportFile, JSON.stringify(obj));
    console.log("生成成功：", exportFile);
}
let version_obj = JSON.parse(fs.readFileSync(main_version_file, { encoding: "utf8" }));
svn.info(config.cwd +"laya", function (err, info) {
    if(err == null){
        version_obj["global_version"] = info.lastchangedrev * 100 + 23
        console.log("最新资源版本号:", info.lastchangedrev);
        version_obj["gameRes_version"] = info.lastchangedrev * 100 + 23
        svn.info(config.cwd +"src", function (err, info) {
            version_obj["js_version"] = info.lastchangedrev * 100 + 23
            console.log("最新code版本号:", info.lastchangedrev);
            // svn.info(config.cwd +"laya/assets/resource/game", function (err, info) {
                fileUtils.save(main_version_file, JSON.stringify(version_obj));
                // console.log("最新laya/assets/resource/game版本号:", info.lastchangedrev);
            // })
        })
    }else{
        //console.log(err);
    }
});

ee.on("fileForeachComplate", function() {
    dirNum_complate++;
    if(dirNum_complate >= dirNum){
        allFiles = allFiles.concat(pagesFiles)
        all_version_count = allFiles.length
        getFileVersion_start_time = new Date().getTime()
        console.log("---getFileVersion start time =", getFileVersion_start_time, all_version_count)
        getFileVersion();
    }
});

foreachAllResourceFiles(config.cwd + "laya/assets/resource", false);

// function foreachAllModuleJSFiles(root) {
//     dirNum++;
//     fs.readdir(root, function(err, files){
//         for(var i = 0, len = files.length; i<len; i++){
//             var file = files[i];
//             var filePath = root + "/" + file;
//             if(fileUtils.isDirectory(filePath)) {
//                 allFiles.push(filePath);
//             }else{
//             }
//         }
//         ee.emit("fileForeachComplate");
//     })
// }

// foreachAllModuleJSFiles(config.cwd + "src");
console.log("生成中，请稍等。。。");



