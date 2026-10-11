///@描述:item
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-08-16 16:22

import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { SvipMainModel } from "../commonModel/SvipMainModel"

export class SvipMainItem extends BaseItem1 {
    /*----这里定义变量-----*/
    image_privilege_bg: Laya.Image
    image_privilege: Laya.Image
    image_line: Laya.Image
    html_content: Laya.HTMLDivElement
    InitEvent
    SetDate
    model
    index
    data
    /*---------------------*/
    public constructor(parent) {
        super(parent)
        this.base_file = "svip"
        this.layout_file = "SvipMainItem"
        this.model = SvipMainModel.GetInstance()
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_privilege_bg, GameResPath.GetIcon("svip", "ui_svip_basal_10"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_line, GameResPath.GetIcon("svip", "ui_svip_basal_11"), true)
            this.InitEvent()
        }

        this.InitEvent = () => {

        }

        this.SetDate = (index?, data?) => {
            this.index = index
            this.data = data
            if(this.is_loaded){
                let privilege_name = `ui_svip_privilege_${index + 1}`
                ResManager.GetInstance().SetOutsideImageSprite(this, this.image_privilege, GameResPath.GetIcon("svip", privilege_name), true)
                this.html_content.innerHTML = this.data.content
            }
        }
    }
    
    
    public DeleteMe() {
       
        super.DeleteMe()
    }
    
    public GetComponents() {
        [
            this.image_privilege_bg,
            this.image_privilege,
            this.html_content,
            this.image_line
        ]
        = this.GetChildrenByNames([
            "image_privilege_bg",
            "image_privilege",
            "html_content",
            "image_line"
        ])
        this.html_content.style.fontSize = 18
		this.html_content.style.color="#ffffff"
		this.html_content.style.wordWrap = true
    }
}
window["SvipMainItem"] = SvipMainItem