var fs = require('fs');
var SVN = require("node.svn");
var EventEmitter = require('events').EventEmitter;
var fileUtils = require("./libs/fileUtils.js");

var config = {
    "cwd": process.cwd() + "/../",
    "username": "username",
    "password": "password"
};
// let curr_readdir_count = 0
// let total_readdir_count = 3
// function deleteConfigDir(root) {
//     curr_readdir_count++
//     fs.readdir(root, function (err, files) {
//         for (var i = 0, len = files.length; i < len; i++) {
//             var file = files[i];
//             var filePath = root + "/" + file;
//             if (fileUtils.isDirectory(filePath)) {
//                 deleteConfigDir(filePath)
//             } else {
//                 fileUtils.remove(filePath)
//             }
//         }
//         if (curr_readdir_count == total_readdir_count) {
            var svn = new SVN(config);
            var allFiles = {};
            let configJSONContent = fs.readFileSync(config.cwd + "src/common/Config.ts", { encoding: "utf8" });
            let match_str = "static PRELOAD_CLIENT_CONFIG = {"
            let index_start = configJSONContent.indexOf(match_str) + match_str.length
            let index_end = configJSONContent.indexOf("}", index_start)
            // console.log(configJSONContent.substring(index_start, index_end))
            let obj = JSON.parse("{" + configJSONContent.substring(index_start, index_end) + "}")
            // console.log(obj)
            let config_json_content = "{"
            let first_add = true
            let file_content
            for (let config_name in obj) {
                file_content = fs.readFileSync(config.cwd + "laya/assets/resource/config/client/" + config_name + ".json", { encoding: "utf8" })
                if (first_add) {
                    first_add = false
                    config_json_content += `"${config_name}"` + ":" + file_content
                } else {
                    config_json_content += "," + `"${config_name}"` + ":" + file_content
                }
                // fs.writeFileSync(config.cwd + "laya/assets/resource/preload_config/client/" + config_name + ".json", file_content);
            }
            match_str = "static PRELOAD_SERVER_CONFIG = {"
            index_start = configJSONContent.indexOf(match_str) + match_str.length
            index_end = configJSONContent.indexOf("}", index_start)
            // console.log(configJSONContent.substring(index_start, index_end))
            obj = JSON.parse("{" + configJSONContent.substring(index_start, index_end) + "}")
            // console.log(obj)
            for (let config_name in obj) {
                file_content = fs.readFileSync(config.cwd + "laya/assets/resource/config/server/" + config_name + ".json", { encoding: "utf8" })
                config_json_content += "," + `"${config_name}"` + ":" + file_content
                // fs.writeFileSync(config.cwd + "laya/assets/resource/preload_config/server/" + config_name + ".json", file_content);
            }
            config_json_content += "}"
            fs.writeFileSync(config.cwd + "laya/assets/resource/config.json", config_json_content, null);
        // }
    // })
// }
// deleteConfigDir(config.cwd + "resource/preload_config");



