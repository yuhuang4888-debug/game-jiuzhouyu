///@描述:VipSubFlagItem
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-08-04 10:00
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Split, Util } from "../util/Util"


export class VipSubFlagItem extends BaseItemRenderer {
    /*----这里定义变量-----*/
    image_flag: Laya.Image
    html_lable_flag: Laya.HTMLDivElement
    SetData
    CutConfigClientString
 
    /*---------------------*/
    public constructor(parent?) {
        super()
        this.WIDTH = 265
        this.HEIGT = 50
        this.base_file = "vip"
        this.layout_file = "VipSubFlagItem"
        this.Load()
    }

    public dataChanged(){
        if(!super.dataChanged()) return 
        if(PlatformManager.IsEyouPlatform()){
            this.html_lable_flag.style.wordWrap = true
            this.html_lable_flag.style.width = 209
            this.html_lable_flag.style.leading = 0.1
        }
        if (this.data) {
            let str_array = Split(this.data,"@")
            let image_name = str_array[0]
            let lable_content = str_array[1]
            ResManager.GetInstance().SetOutsideImageSprite(this, this.image_flag, GameResPath.GetIcon("vip", image_name), false)
            this.html_lable_flag.innerHTML = Util.StrToHTML(lable_content)
            if(PlatformManager.IsEyouPlatform()){
                this.html_lable_flag.y=   (50-this.html_lable_flag.contextHeight)/2
            }
		}
    }
    
    public DeleteMe() {
        super.DeleteMe()
    }
    
    public GetComponents() {
        [
           this.image_flag,
           this.html_lable_flag
        ]
        = this.GetChildrenByNames([
           "image_flag",
           "html_lable_flag"
        ])
        this.html_lable_flag.style.fontSize = 20
        this.html_lable_flag.style.color = "#ffffff"
        this.html_lable_flag.style.wordWrap = false
    }
}
window["VipSubFlagItem"] = VipSubFlagItem