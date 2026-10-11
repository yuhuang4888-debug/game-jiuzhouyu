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
var subpackage_import_str = ""
var start_load_count = 0
var complete_load_count = 0
function foreachAllFiles(root, file_dir) {
    fs.readdir(root, function(err, files){
        for(let i = 0, len = files.length; i<len; i++){
            let file = files[i];
            let filePath = root + "/" + file;
            // if(fileUtils.isDirectory(filePath))
            // {
            //     foreachAllFiles(filePath, file_dir)
            // }else
            // {
                if(file.lastIndexOf(".ts") == file.length - 3)
                {
                    let module_name = file.substring(0, file.indexOf("Controller"))
                    module_name = module_name.substring(0,1).toLowerCase() + module_name.substring(1)
                    console.log("module_name = ", module_name)
                    if(module_name && filePath.indexOf("ArenaController") > 0)
                    {     
                        let c_content = fs.readFileSync(filePath, { encoding: "utf8" })
                        let match_result = c_content.match(/import\s+\".+\"/g)
                        console.log(match_result)
                        if(match_result)
                        {
                            for(let i = 0; i < match_result.length; i ++)
                            {
                                if(match_result[i].indexOf("/" + module_name + "/") >= 0)
                                {
                                    c_content = c_content.replace(match_result[i], "")
                                }
                            }
                        }
                        fs.writeFileSync(filePath, c_content);
                        subpackage_module_list.push(module_name)
                    }
                }
            // }
        }

        let modules_len = subpackage_module_list.length
        if(modules_len > 0)
        {
            let base_path = config.cwd + "src/"
            for(let j = 0; j < modules_len; j ++)
            {
                let root = base_path + subpackage_module_list[j]
                start_load_count ++
                fs.readdir(root, function(err, files){
                    complete_load_count ++
                    for(let k = 0, len = files.length; k < len; k++){
                        let file = files[k];
                        let filePath = root + "/" + file
                        if(file.lastIndexOf(".ts") == file.length - 3)
                        {
                            let c_content = fs.readFileSync(filePath, { encoding: "utf8" })
                            let match_result = c_content.match(/import\s+.+/g)
                            console.log(match_result)
                            if(match_result)
                            {
                                for(let i = 0; i < match_result.length; i ++)
                                {
                                    c_content = c_content.replace(match_result[i], "")
                                }
                            }
                            fs.writeFileSync(filePath, c_content);
                            match_result = 'import "../' + subpackage_module_list[j] + '/' + file.substring(0, file.length - 3) + '"'
                            subpackage_import_str += match_result + "\n"
                        }
                    }
                    if(complete_load_count == start_load_count)
                    {
                        fileUtils.save(config.cwd + "src/subPackage/SubPackage.ts", subpackage_import_str);
                    }
                }
                )
            }
        }
    })
}
foreachAllFiles(config.cwd + "src/commonController");