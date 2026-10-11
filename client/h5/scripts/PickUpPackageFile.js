var fileUtils = require("./libs/fileUtils.js");
var fs = require('fs');
var config = {
    "cwd": process.cwd() + "/../laya/assets/",
    "username": "username",
    "password": "password"
};
var _replace_msg_list = [
    // "resource/game/",特殊处理了
     "resource/config/",
     "resource/object/",
     "resource/effect/",
     "resource/font/"
 ]
var packages_list = JSON.parse(fs.readFileSync(config.cwd + "resource/config/client/ConfigPreloadResList.json", { encoding: "utf8" }));
var resVersionData = JSON.parse(fs.readFileSync(config.cwd + "resource/resource_version.json", { encoding: "utf8" }));
var game_manul_version = JSON.parse(fs.readFileSync(config.cwd + "resource/game_manul_version.json", { encoding: "utf8" }));

var _version_cache = {}
var _random_value = "no_version"
//封装某个url资源 添加版本号
var ParseUrlByVersion = (url) => {
    var version = "";
    var version_cache = _version_cache;
    version = version_cache[url];
    if (version)
        return version;
    var resVersion = resVersionData;
    if(!resVersion)
    {
        version_cache[url] = _random_value;
        return _random_value;
    }
    let version_url = url;
    let start_index = url.indexOf("resource/")
    if(start_index >= 0 && resVersion)
    {
        version_url = url.substring(start_index)
        version = resVersion[version_url];
        if(!version)
        {   
            let str = version_url.match(/resource\/\w+\/+/)
            if(str && version_url.indexOf("resource/game/") < 0)
            {
                let tem_url = str.toString()
                if(_replace_msg_list.indexOf(tem_url) >= 0)
                {
                    tem_url = version_url.replace(tem_url, "")
                    version = resVersion[tem_url];
                    if(version)
                    {
                        version_cache[url] = version;
                        return version;
                    }
                }
            }else
            {
                let base_url = "resource/game/"
                let list = version_url.replace(base_url, "").split("/");
                if (list && list.length > 0) {
                    let len = list.length;
                    let check_url = "";
                    for (let i = 0; i < len; i++) {
                        check_url += list[i];
                        version = resVersion[check_url];
                        if (version) {
                            break;
                        }
                        check_url += '/';
                    }
                }
            }
        }
    }
    if (!version) {
        version = _random_value;
    }
    version_cache[url] = version;
    return version;
};

function copyFile(filePath, base_dir, version) {
    // console.log("filePath" + filePath)
    let data
    if (filePath.lastIndexOf(".json") == filePath.length - 5) {
        try{
            data = fs.readFileSync(filePath, { encoding: "utf8" })
        }catch(e)
        {
            console.log(filePath + " file is not exit, try to load pages file")
            data = fs.readFileSync(filePath.replace("/assets/", "/pages/").replace(".json", ".scene"), { encoding: "utf8" })
        }
    } else {
        if (filePath.lastIndexOf(".png") == filePath.length - 4 || filePath.lastIndexOf(".jpg") == filePath.length - 4 || filePath.lastIndexOf(".mp3") == filePath.length - 4) {//png jpg mp3暂不支持包内资源
            return
        }
        try
        {
            data = fs.readFileSync(filePath)
        }catch(e)
        {
            console.log(filePath + " file is not exit")
            return
        }
    }
    let new_path
    new_path = filePath.replace("/" + base_dir + "/", "/" + base_dir + "2/")
    let dir = new_path.replace(config.cwd + base_dir + "2", "")
    let index = dir.lastIndexOf("/")
    let sub_dir = dir.substr(1, index - 1)
    let list = sub_dir.split("/")
    let curr_dir = config.cwd + base_dir + "2"
    if (list && list.length > 0) {
        for (let i = 0; i < list.length; i++) {
            if (list[i]) {
                curr_dir += "/" + list[i]
                // console.log("curr_dir" + curr_dir)
                if (!fs.existsSync(curr_dir)) {
                    fs.mkdirSync(curr_dir)
                    // console.log(curr_dir + '文件夹-创建成功！');
                }
            }
        }
    }
    // console.log("new_path" + new_path)
    fileUtils.save(new_path + "_v=" + version, data)
}

var root_dir = config.cwd + "js2/"
if (!fs.existsSync(root_dir)) {
    fs.mkdirSync(root_dir)
}
root_dir = config.cwd + "resource2/"
if (!fs.existsSync(root_dir)) {
    fs.mkdirSync(root_dir)
}
var version
version = game_manul_version.js_version
function copyJs(base_path, filePath, version) 
{
    let data = fs.readFileSync(base_path + filePath)
    let new_path = config.cwd + "js2/" + filePath
    fileUtils.save(new_path + "_v=" + version, data)
}
copyJs(config.cwd + "../../release/web/js/", "bundle.js", version)
copyJs(config.cwd + "../../release/web/js/" , "subPackage.js", version)

let total_list = packages_list.package_common_res
for (var i = 0, len = total_list.length; i < len; i++) {
    var info = total_list[i]
    var version
    if(info.indexOf("resource/resource_version.zip") >= 0)
    {
        version = game_manul_version.resource_version
    }else if(info.indexOf("resource/UIConfig.zip") >= 0)
    {
        version = game_manul_version.uiconfig_version
    }else
    {
        version = ParseUrlByVersion(info)
    }
    // console.log(info + " version is = ", version)
    if(version && version != _random_value)
    {
        copyFile(config.cwd + info, "resource", version)
    }
}