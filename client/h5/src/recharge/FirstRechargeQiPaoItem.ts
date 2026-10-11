import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"

import { BaseItem1 } from "../common/BaseItem1"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { PlatformManager } from "../PlatformManager"

export class FirstRechargeQiPaoItem extends BaseItem1 {
    _img_bg: Laya.Image
    _lb_info: Laya.HTMLDivElement
    InitEvent
    LoadCfg
    
    LoadSuccess
    Remove
    change_scene_close
    destroy_callback
    destroy_imm
    is_center
    not_show_main_msg
    open_callback
    show_open_movie
    use_background
    time
    info
    parent_
    public constructor(parent?) {
        super(parent)
        this.parent_ = parent

        this.base_file = "recharge"
        this.layout_file = "FirstRechargeQiPaoItem"
        // this.layer_value = Enum_UILayer.Main
        this.change_scene_close = false
        this.use_background = false
        this.is_center = false
        this.show_open_movie = true
        //this.not_show_main_msg = true
        this.destroy_imm = true
        let model = FirstRechargeModel.GetInstance()
        this.load_callback = () => {
            this.LoadCfg()
            // Laya.timer.once(Config.PRELOAD_CLIENT_CONFIG.ConfigFirstRecharge.tips_show_delay_time*1000,this,()=>{
                this.LoadSuccess()
                this.InitEvent()
            // })

        }

        this.open_callback = () => {
        }

        this.destroy_callback = () => {
            this.Remove()
        }

        this.LoadCfg = () => {

        }

        this.LoadSuccess = () => {
            this.display_obj.x = 50
            this.display_obj.y = -20
            // this.time=FirstRechargeModel.GetInstance().GetFirstRechargeQiPaoInfo().time
            // // Laya.Tween.to(this.display_obj, { x: this.display_obj.x, y: this.display_obj.y, scaleX: 1, scaleY: 1 }, 500, undefined, Laya.Handler.create(this, () => {
            // if (this.time) {
            //     this.time = this.time
            //     Laya.timer.loop(1000, this, () => {
            //         this.time = this.time - 1
            //         if (Number(this.time) <= 0) {
            //             Laya.timer.clearAll(this)
            //             this.DeleteMe()
            //         }
            //     })
            // }
            // }))
            if(FirstRechargeModel.GetInstance().GetFirstRechargeQiPaoInfo().str == null){
                this.DeleteMe()
                return
            }
            if(PlatformManager.IsEyouEnPlatform()){
				this._lb_info.style.fontSize=18
                this._lb_info.y = 23
			}
            this._lb_info.innerHTML=FirstRechargeModel.GetInstance().GetFirstRechargeQiPaoInfo().str
            this._img_bg.width=this._lb_info.contextWidth+50
            this._lb_info.visible=true
            this._img_bg.visible=true
        }

        this.InitEvent = () => {
        }

        this.Remove = () => {

        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this._img_bg,
            this._lb_info,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_info",
            ])
        this._lb_info.style.fontSize=20
        this._lb_info.style.color="#000000"
        this._lb_info.style.wordWrap=false
        this._lb_info.style.bold=true
    }
}
window["FirstRechargeQiPaoItem"]=FirstRechargeQiPaoItem