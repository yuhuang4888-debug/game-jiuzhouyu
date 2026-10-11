var fs = require('fs');
var SVN = require("node.svn");
var fileUtils = require("./libs/fileUtils.js");
var config = {
    "cwd": process.cwd() + "/../",
    "username": "username",
    "password": "password"
};
console.log(1);
var filePath = config.cwd + "laya/assets/resource/object/role/objs/model_clothe_1300.lh";
console.log(2);
var file_content = JSON.parse(fs.readFileSync(filePath, { encoding: "utf8" }));
var children = file_content.data.child;
var bones;
var root;
var child
for(var i = 0; i < children.length; i ++)
{
    // child = children[i]
    if(children[i].props.bones)
    {
        bones = children[i].props.bones;
    }
    if(children[i].props.name == "root")
    {
        root = children[i];
    }
    if(root && bones)
    {
        break;
    }
}

var new_children = [];
var position = [0,0,0]
var rotation = [0,0,0,0]
var scale = [1,1,1]
function FilterChild (parent, position, rotation, scale)
{
    let children = parent.child;
    for(var i = 0; i < children.length; i ++)
    {
        // child = children[i]
        position[0] = children[i].props.position[0] += position[0]
        position[1] = children[i].props.position[1] += position[1]
        position[2] = children[i].props.position[2] += position[2]

        rotation[0] = children[i].props.rotation[0] += rotation[0]
        rotation[1] = children[i].props.rotation[1] += rotation[1]
        rotation[2] = children[i].props.rotation[2] += rotation[2]
        rotation[3] = children[i].props.rotation[3] += rotation[3]

        scale[0] = children[i].props.scale[0] *= scale[0]
        scale[1] = children[i].props.scale[1] *= scale[1]
        scale[2] = children[i].props.scale[2] *= scale[2]
        if(bones.indexOf(children[i].instanceID) >= 0)
        {
            new_children.push(children[i]);
        }
        FilterChild(children[i], position, rotation, scale);
        children[i].child.length = 0
    }
    return
}

FilterChild(root, position, rotation, scale);
console.log(bones)
console.log(new_children.length)
root.child = new_children;

fs.writeFileSync(filePath, JSON.stringify(file_content), "utf-8");
