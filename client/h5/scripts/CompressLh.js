var fs = require('fs');
var fileUtils = require("./libs/fileUtils.js");

var config = {
    "cwd": process.cwd() + "/../",
    "username": "username",
    "password": "password"
};

function chechAllDirectory(root) {
    fs.readdir(root, function (err, files) {
        for (var i = 0, len = files.length; i < len; i++) {
            var file = files[i];
            var filePath = root + "/" + file;
            if (fileUtils.isDirectory(filePath)) {
                chechAllDirectory(filePath)
            } else {
                if (file.lastIndexOf(".lh") == file.length - 3) {
                    console.log(filePath)
                    let class_content = fs.readFileSync(filePath, { encoding: "utf8" });
                    fs.writeFileSync(filePath, class_content.replace(/\r\n/g, '').replace(/\n/g, '').replace(/\s{2,10000}/g, ''));//匹配连续两个以上的空格
                    // fileUtils.save(filePath, JSON.stringify(class_content).replace(/\r\n/g, '').replace(/\n/g, '').replace(/\s+/g, ''));
                }
            }
        }
    })
}
chechAllDirectory(config.cwd + "laya/assets/resource/object");
chechAllDirectory(config.cwd + "laya/assets/resource/effect");

// let module_name = 'util'
// function chechAllDirectory(root) {
//     let subpackage_import_str = ""
//     fs.readdir(root, function (err, files) {
//         for (var i = 0, len = files.length; i < len; i++) {
//             var file = files[i];
//             var filePath = root + "/" + file;
//             if (fileUtils.isDirectory(filePath)) {
//                 // chechAllDirectory(filePath)
//             } else {
//                 if (file.lastIndexOf(".ts") == file.length - 3) {
//                     let class_name = file.substr(0, file.length - 3)
//                     let str = 'import "./'+ module_name + '/' + class_name + '"\n'
//                     subpackage_import_str += str
//                 }
//             }
//         }
//         fileUtils.save(config.cwd + "src/subPackage/SubPackage.ts", subpackage_import_str);
//     })
// }
// chechAllDirectory(config.cwd + "src/" + module_name);