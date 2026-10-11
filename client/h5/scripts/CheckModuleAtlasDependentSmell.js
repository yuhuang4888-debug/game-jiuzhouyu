var fs = require('fs');
var fileUtils = require("./libs/fileUtils.js");
var config = {
    "cwd": process.cwd() + "/../",
    "username": "username",
    "password": "password"
};
var ChectAtlas_json_content = {};
var start_load_count = 0;
var load_complete_count = 0;
var common_modules = ["common", "common2", "common4", "sysInfo", "uiComponent", "icon", "mainUI", "emoji", "alert", "dungeonCommon"]
function chechAllDirectory(root) {
    ++ start_load_count
    fs.readdir(root, function (err, files) {
        ++ load_complete_count
        for (var i = 0, len = files.length; i < len; i++) {
            var file = files[i];
            var filePath = root + "/" + file;
            if (fileUtils.isDirectory(filePath)) {
                chechAllDirectory(filePath)
            } else {
                var is_scene = filePath.lastIndexOf(".scene") == filePath.length - 6;
                var file_content = "";
                if(is_scene)
                {
                    var last_index = filePath.lastIndexOf("/");
                    var curr_module_name = filePath.substring(filePath.lastIndexOf("/", last_index - 1) + 1, last_index);
                    // console.log("curr_module_name", curr_module_name);
                    
                    file_content = fs.readFileSync(filePath, { encoding: "utf8" });
                    let match_result = file_content.match(/resource\/game\/.+png/g)
                    // console.log(match_result)
                    if(match_result)
                    {
                        let match_str
                        for(let i = 0; i < match_result.length; i ++)
                        {
                            match_str = match_result[i];
                            index = match_str.indexOf("resource/game/") + 14;
                            var module_name = match_str.substring(index, match_str.indexOf("/", index + 1));
                            if(common_modules.indexOf(module_name) < 0 && curr_module_name != module_name)
                            {
                                ChectAtlas_json_content[curr_module_name] = ChectAtlas_json_content[curr_module_name] || []
                                let obj = {}
                                obj[file] = match_str
                                ChectAtlas_json_content[curr_module_name].push(obj)
                            }
                        }
                        // console.log("match_result[i]", match_str, module_name);
                    }
                }
            }
        }
        if(start_load_count == load_complete_count)
        {
            fileUtils.save(config.cwd + "CheckModuleAtlasDependentSmell.json", JSON.stringify(ChectAtlas_json_content).replace(/],/gim, "],\n"));
        }
    })
}
chechAllDirectory(config.cwd + "laya/pages/resource/game");

