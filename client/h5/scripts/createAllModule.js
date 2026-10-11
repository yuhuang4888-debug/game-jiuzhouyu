var fs = require('fs');
var SVN = require("node.svn");
var EventEmitter = require('events').EventEmitter;
var fileUtils = require("./libs/fileUtils.js");

var importFile = process.cwd()+"/../" + "tsconfig.json";

const gameJSONPath = importFile;
let gameJSONContent = JSON.parse(fs.readFileSync(gameJSONPath, { encoding: "utf8" }));
gameJSONContent.sourceMap = false
gameJSONContent.exclude = []
fs.writeFileSync(importFile, JSON.stringify(gameJSONContent, null, "\t"));
console.log("createAllModule生成tsconfig.json中，请稍等。。。");



