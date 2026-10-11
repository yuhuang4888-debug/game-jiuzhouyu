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
                if (file.lastIndexOf(".ts") == file.length - 3) {
                    let class_content = fs.readFileSync(filePath, { encoding: "utf8" });
                    let match_result = class_content.match(/export\s+\w+\s+(\w+)/g)
                    // console.log(match_result)
                    if(match_result)
                    {
                        let g_name
                        for(let i = 0; i < match_result.length; i ++)
                        {
                            g_name = match_result[i].split(" ").pop()
                            if(class_content.indexOf("window[\"" + g_name + "\"]") < 0)
                            {
                                class_content += "\nwindow[\"" + g_name + "\"] = " + g_name
                                fs.writeFileSync(filePath, class_content);
                            }
                        }
                    }
                }
            }
        }
    })
}
chechAllDirectory(config.cwd + "src");

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