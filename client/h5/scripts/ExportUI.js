var fs = require('fs');
var fileUtils = require("./libs/fileUtils.js");

var config = {
    "cwd": process.cwd() + "/../",
    "username": "username",
    "password": "password"
};
let DeletePro = function(obj, parent, index)
{
    let new_obj = {}
    for(let pro in obj)
    {
        if(pro == "type" || pro == "props" || pro == "child")
        {
            new_obj[pro] = obj[pro]
        }
    }
    let children = obj.child
    if(children && children.length > 0)
    {
        children.forEach((child, index) => {
            DeletePro(child, children, index)
        });
    }else
    {
        delete new_obj["child"]
    }
    if(parent)
        parent[index] = new_obj
    return new_obj
}
let uiconfig_json_content = "{"
let first_add = true
var start_load_count = 0
var load_complete_count = 0
function chechAllDirectory(root) {
    ++ start_load_count
    fs.readdir(root, function (err, files) {
        ++ load_complete_count
        for (var i = 0, len = files.length; i < len; i++) {
            var file = files[i];
            var filePath = root + "/" + file;
            // console.log("filePath", filePath)
            if (fileUtils.isDirectory(filePath)) {
                let new_path = filePath.replace("laya/assets/", "bin/").replace("laya/pages/", "bin/")
                if (!fs.existsSync(new_path)) {
                    fs.mkdirSync(new_path)
                    console.log(new_path + '文件夹-创建成功！');
                }
                chechAllDirectory(filePath)
            } else {
                let is_atlas = filePath.lastIndexOf(".atlas") == filePath.length - 6
                let is_scene = filePath.lastIndexOf(".scene") == filePath.length - 6
                let file_content = ""
                if(is_atlas || is_scene)
                {
                    file_content = fs.readFileSync(filePath, { encoding: "utf8" });
                    if (is_atlas) {
                        file_content = file_content.replace("\"prefix\":", "\"nouse\":")
                    }else
                    {
                        // console.log(filePath + 'parse format');
                        let test_json = JSON.parse(file_content)
                        let new_test_json = DeletePro(test_json, null, null)
                        file_content = JSON.stringify(new_test_json)
                    }
                }else
                {
                    file_content = fs.readFileSync(filePath);
                }
                filePath = filePath.replace("laya/assets/", "bin/")
                filePath = filePath.replace("laya/pages/", "bin/")
               
                if(is_atlas || is_scene)
                {
                    // file_content = file_content.replace(/\n/g, "")
                    if (is_scene) {
                        fs.writeFileSync(filePath, file_content, "utf-8");
                        filePath = filePath.replace(".scene", ".json")
                    }
                    fs.writeFileSync(filePath, file_content, "utf-8");
                }else
                {
                    // fileUtils.save(filePath, file_content)
                    fs.writeFileSync(filePath, file_content);
                }
                let config_name = filePath.split("resource/game/")[1]
                // console.log("filePath", file, is_atlas, is_scene)
                if (first_add) {
                    first_add = false
                    uiconfig_json_content += `"${config_name}"` + ":" + file_content
                } else {
                    uiconfig_json_content += "," + `"${config_name}"` + ":" + file_content
                }
            }
        }
        if(start_load_count == load_complete_count)
        {
            console.log('parse format complete');
            uiconfig_json_content += "}"
            fs.writeFileSync(config.cwd + "bin/resource/local_UIConfig.json", uiconfig_json_content, null);
        }
    })
}
chechAllDirectory(config.cwd + "laya/assets/resource/game");
chechAllDirectory(config.cwd + "laya/pages/resource/game");