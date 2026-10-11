var fs = require('fs');
var SVN = require("node.svn");
var EventEmitter = require('events').EventEmitter;
var fileUtils = require("./libs/fileUtils.js");
var config = {
    "cwd" : process.cwd()+"/../",
    "username" : "username",
    "password" : "password"
};
var subpackage_module_list = []
var mainpackage_import_str = ""
var subpackage_import_str = ""
var start_load_count = 0
var complete_load_count = 0
//主包包含的模块
var main_package_modules = ["alert", "autofight", "common", "commonController", "commonModel", "login",
 "newgameui", "operation", "particalEffect", "scene", "serverTime", "sharedata", "skill", "sysInfo", 
 "ui", "uiComponent", "util","elim"]

 //分包包含的模块
var sub_package_modules = []
let root = config.cwd + "src"
fs.readdir(root, function(err, files){
        for(let i = 0, len = files.length; i<len; i++){
            let file = files[i];
            let filePath = root + "/" + file;
            if(fileUtils.isDirectory(filePath) && main_package_modules.indexOf(file) < 0)
            {
                sub_package_modules.push(file)
            }
        }
 })

function foreachAllFiles(base_path) {
    start_load_count ++
    fs.readdir(base_path, function(err, files){
        complete_load_count ++
        for(let i = 0, len = files.length; i<len; i++){
            let file = files[i];
            let filePath = base_path + "/" + file;
            // console.log("filePath = ", filePath)
            if(fileUtils.isDirectory(filePath))
            {
                foreachAllFiles(filePath)
            }else
            {
                if(file.lastIndexOf(".ts") == file.length - 3)
                {
                    let back_path = filePath.replace(root, "")
                    let path_list = back_path.split('/')
                    // console.log("path = ", root, filePath, back_path)
                    let is_main_package_file = false
                    let module_name
                    if(path_list) 
                     {
                         if(path_list.length < 3)//没有放在文件夹下的main.ts这些也属于主包
                         {
                            is_main_package_file = true
                         }else
                         {
                             module_name = path_list[1]
                             if(module_name && main_package_modules.indexOf(module_name) >= 0)
                             {
                                 is_main_package_file = true
                             }
                         }
                    }
                    let c_content = fs.readFileSync(filePath, { encoding: "utf8" })
                    let match_result = c_content.match(/export\s+\w+\s+\w+/g)
                    // console.log(match_result)
                    if(match_result)
                    {
                        let export_name
                        let match_list
                        for(let i = 0; i < match_result.length; i ++)
                        {
                            match_list = match_result[i].split(" ")
                            if(match_list && match_list[1] != "interface" && match_list[1] != "default" && match_list[1] != "abstract") 
                            {
                                export_name = match_list.pop()
                                if(c_content.indexOf("window[\"" + export_name + "\"]") < 0)
                                {
                                    c_content += "\nwindow[\"" + export_name + "\"] = " + export_name + ";"
                                }
								if(match_list[1] == "class" && c_content.indexOf(export_name +"[\"class_name\"]") < 0)
                                {
                                    c_content +=  "\n" + export_name +"[\"class_name\"] = \"" + export_name + "\";"
                                }
                            }
                        }
                    }
                    match_result = c_content.match(/import\s+.+/g)
                    if(is_main_package_file)
                    {
                        if(match_result)
                        {
                            for(let i = 0; i < match_result.length; i ++)
                            {
                                for(let j = 0; j < sub_package_modules.length; j ++)
                                {
                                    if(match_result[i].indexOf("/" + sub_package_modules[j] + "/") >= 0)
                                    {
                                        c_content = c_content.replace(match_result[i], "")
                                        break
                                    }
                                }
                            }
                        }
                        fs.writeFileSync(filePath, c_content);
                        if(file != "Main.ts" && file != "GameConfig.ts" && file != "layaMaxUI.ts")
                        {
                            match_result = 'import ".' + back_path.substring(0, back_path.length - 3) + '"'
                            mainpackage_import_str += match_result + "\n"
                        }
                    }else
                    {
                        if(match_result)
                        {
                            for(let i = 0; i < match_result.length; i ++)
                            {
                                c_content = c_content.replace(match_result[i], "")
                            }
                        }
                        fs.writeFileSync(filePath, c_content);
                        match_result = 'import "..' + back_path.substring(0, back_path.length - 3) + '"'
                        subpackage_import_str += match_result + "\n"
                    }
                }
            }
        }
         if(complete_load_count == start_load_count)
        {
            fileUtils.save(config.cwd + "src/AutoRequireMainSubPackage.ts", mainpackage_import_str);
            fileUtils.save(config.cwd + "src/subPackage/SubPackage.ts", subpackage_import_str);
        }
    })
}
foreachAllFiles(root);


// function foreachAllFiles(root, file_dir) {
//     fs.readdir(root, function(err, files){
//         for(let i = 0, len = files.length; i<len; i++){
//             let file = files[i];
//             let filePath = root + "/" + file;
//             // if(fileUtils.isDirectory(filePath))
//             // {
//             //     foreachAllFiles(filePath, file_dir)
//             // }else
//             // {
//                 if(file.lastIndexOf(".ts") == file.length - 3)
//                 {
//                     let module_name = file.substring(0, file.indexOf("Controller"))
//                     module_name = module_name.substring(0,1).toLowerCase() + module_name.substring(1)
//                     console.log("module_name = ", module_name)
//                     if(module_name)// && (filePath.indexOf("ArenaController") > 0 || filePath.indexOf("achvController")))
//                     {     
//                         let c_content = fs.readFileSync(filePath, { encoding: "utf8" })
//                         let match_result = c_content.match(/import\s+\".+\"/g)
//                         // console.log(match_result)
//                         if(match_result)
//                         {
//                             for(let i = 0; i < match_result.length; i ++)
//                             {
//                                 if(match_result[i].indexOf("/" + module_name + "/") >= 0)
//                                 {
//                                     c_content = c_content.replace(match_result[i], "")
//                                 }
//                             }
//                         }
//                         fs.writeFileSync(filePath, c_content);
//                         subpackage_module_list.push(module_name)
//                     }
//                 }
//             // }
//         }

//         let modules_len = subpackage_module_list.length
//         if(modules_len > 0)
//         {
//             let base_path = config.cwd + "src/"
//             for(let j = 0; j < modules_len; j ++)
//             {
//                 let root = base_path + subpackage_module_list[j]
//                 if(!fileUtils.exists(root)) continue
//                 start_load_count ++
//                 fs.readdir(root, function(err, files){
//                // console.log("read scr modulepath = ", root, err)
//                     complete_load_count ++
//                     if(!files) return
//                     for(let k = 0, len = files.length; k < len; k++){
//                         let file = files[k];
//                         let filePath = root + "/" + file
//                         if(file.lastIndexOf(".ts") == file.length - 3)
//                         {
//                             console.log(filePath)
//                             let c_content = fs.readFileSync(filePath, { encoding: "utf8" })
//                             let match_result = c_content.match(/import\s+.+/g)
//                             if(match_result)
//                             {
//                                 for(let i = 0; i < match_result.length; i ++)
//                                 {
//                                     c_content = c_content.replace(match_result[i], "")
//                                 }
//                             }
//                             fs.writeFileSync(filePath, c_content);
//                             match_result = 'import "../' + subpackage_module_list[j] + '/' + file.substring(0, file.length - 3) + '"'
//                             subpackage_import_str += match_result + "\n"
//                         }
//                     }
//                     if(complete_load_count == start_load_count)
//                     {
//                         fileUtils.save(config.cwd + "src/subPackage/SubPackage.ts", subpackage_import_str);
//                     }
//                 }
//                 )
//             }
//         }
//     })
// }
// foreachAllFiles(config.cwd + "src/commonController");