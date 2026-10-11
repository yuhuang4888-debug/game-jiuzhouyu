var fs = require('fs');
var SVN = require("node.svn");
var fileUtils = require("./libs/fileUtils.js");

var config = {
    "cwd" : process.cwd()+"/../",
    "username" : "username",
    "password" : "password"
};

var main_version_file = config.cwd + "laya/assets/resource/game_manul_version.json";
var main_version_cdn_file = config.cwd + "../cdn/resource/game_manul_version.json";

var svn = new SVN(config);
let version_obj = JSON.parse(fs.readFileSync(main_version_file, { encoding: "utf8" }));
svn.info(config.cwd +"src", function (err, info) {
    version_obj["js_version"] = info.lastchangedrev * 100 + 23
    console.log("最新code版本号:", info.lastchangedrev);
    fileUtils.save(main_version_file, JSON.stringify(version_obj));
    fileUtils.save(main_version_cdn_file, JSON.stringify(version_obj));
})
console.log("生成中，请稍等。。。");



