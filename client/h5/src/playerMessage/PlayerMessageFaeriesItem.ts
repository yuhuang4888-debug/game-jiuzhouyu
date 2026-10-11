///@描述:item
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-08-25 15:36

import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"

export class PlayerMessageFaeriesItem extends BaseItem1 {
    /*----这里定义变量-----*/
    InitEvent
    SetDate
    index
    data
    /*---------------------*/
    public constructor(parent) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageFaeriesItem"
        this.load_callback = () => {
            this.InitEvent()
        }

        this.InitEvent = () => {

        }

        this.SetDate = (index?, data?) => {
            this.index = index
            this.data = data
            if(this.is_loaded){
                let image_name = `ui_rwxx_xl_${data.type}`
                ResManager.GetInstance().SetImageSprite(this, this.image_icon, "playerMessage_asset", image_name, false)
                let lock_bool = false
                if(data.is_active == 1){
                    lock_bool = false
                }else if(data.is_active == 0){
                    lock_bool = true
                }
                Util.SetImageGray(this.image_icon, lock_bool)
                this.image_lock.visible = lock_bool
            }
        }
    }
    
    public DeleteMe() {
       
        super.DeleteMe()
    }
    
    image_select: Laya.Image
    image_icon: Laya.Image
    image_lock: Laya.Image

    public GetComponents() {
        [
            this.image_select,
            this.image_icon,
            this.image_lock
        ]
        = this.GetChildrenByNames([
            "image_select",
            "image_icon",
            "image_lock",
        ])
    }
}
window["PlayerMessageFaeriesItem"] = PlayerMessageFaeriesItem