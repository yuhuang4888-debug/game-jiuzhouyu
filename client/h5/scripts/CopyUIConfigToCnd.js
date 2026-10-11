var fs = require('fs');
var SVN = require("node.svn");
var fileUtils = require("./libs/fileUtils.js");
var config = {
    "cwd": process.cwd() + "/../",
    "username": "username",
    "password": "password"
};
let filePath = config.cwd + "laya/assets/resource/UIConfig.json"
let file_content = fs.readFileSync(filePath, { encoding: "utf8" });
filePath = filePath.replace("laya/assets/", "../cdn/")
fs.writeFileSync(filePath, file_content, "utf-8");

filePath = config.cwd + "laya/assets/resource/UIConfig.zip"
file_content = fs.readFileSync(filePath);
filePath = filePath.replace("laya/assets/", "../cdn/")
fs.writeFileSync(filePath, file_content);

var main_version_file = config.cwd + "laya/assets/resource/game_manul_version.json";
var main_version_cdn_file = config.cwd + "../cdn/resource/game_manul_version.json";

var svn = new SVN(config);
let version_obj = JSON.parse(fs.readFileSync(main_version_file, { encoding: "utf8" }));
svn.info(config.cwd +"src", function (err, info) {
    version_obj["js_version"] = info.lastchangedrev * 100 + 23
    console.log("最新code版本号:", info.lastchangedrev);
    svn.info(config.cwd +"laya/assets/resource/resource_version.zip", function (err, info) {
        version_obj["resource_version"] = info.lastchangedrev * 100 + 23
        console.log("最新resource_version版本号:", info.lastchangedrev);
        svn.info(config.cwd +"laya/assets/resource/UIConfig.zip", function (err, info) {
            version_obj["uiconfig_version"] = info.lastchangedrev * 100 + 23
            console.log("最新uiconfig_version版本号:", info.lastchangedrev);
            fileUtils.save(main_version_file, JSON.stringify(version_obj));
            fileUtils.save(main_version_cdn_file, JSON.stringify(version_obj));
        })
    })
})
console.log("生成中，请稍等。。。");

