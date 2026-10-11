import { BaseItem1 } from "../common/BaseItem1"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { SettingModel } from "../commonModel/SettingModel"
import { table } from "../common/table"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
export class SettingSubscriptionItem extends BaseItem1 {


    type //1标题  2订阅item
    data //0-N
    need_fresh = false
    InitEvent
    model
    cur_cfg
    public constructor(parent?) {
        super(parent)

        this.base_file = "setting"
        this.layout_file = "SettingSubscriptionItem"
        this.model = SettingModel.GetInstance()
        this.load_callback = () => {
            this.InitEvent()
            if (this.need_fresh) {
                this.need_fresh = false
                this.SetData(this.type, this.data)
            }

           
        }


        this.InitEvent = () => {
            Util.AddClickEvent(this._btn, () => {
                if (this.type != 2 || !this.data) return
                if(!this.model.CheckSubsOpen())return
                if(this.model.CheckWxSubsState(this.data[0].id))return
                if (this.data.length > 0) {
                    Message.show("更新订阅")
                    PlatformManager.GetInstance().WeChatSubscriptionSH(this.data[0].id)
                }
            }, this, true)


            this.BindEvent(GlobalEventSystem, SettingModel.UPDATE_SUBSCRIPTION, () => {
                this.UpdateBtn()
            })


        }

    }


    public SetData(type, data) {
        this.type = type
        this.data = data
        if (!this.is_loaded) {
            this.need_fresh = true
            return
        }
        this._box_title.visible = this.type == 1
        this._box_desc.visible = this.type == 2
        switch (this.type) {
            case 1:
                this._Label3.text = this.GetTitle()
                break
            case 2:
                this._Label6.text = this.GetDesc()
                break
        }
       // this.RequestInfo()
       this.UpdateBtn()
    }
    public UpdateBtn() {
        if (this.type != 2 || !this.data) return
        if (this.data.length > 0) {
            let is_subscription = this.model.CheckWxSubsState(this.data[0].pos)
            this._btn.visible = !is_subscription
            this._Label4.visible = is_subscription
        }
    }


    // public RequestInfo() {
    //     if (this.type != 2 || !this.data) return
    //     if (this.data.length > 0) {
    //         this.model.RequestWxSubsPro(this.data[0].pos)
    //     }

    // }


    public GetTitle() {
        let str = ""
        switch (this.data) {
            case 0:
                str = "活动开启提醒"
                break
            case 1:
                str = "挂机提醒"
                break
        }
        return str
    }

    public GetDesc(){
        let str=""
        for(let i=0;i<this.data.length;i++){
            str+=this.data[i].desc
            if(i<this.data.length-1){
                str+="、"
            }
        }
        return str
    }


    public DeleteMe() {
        super.DeleteMe()
    }



    _box_title: Laya.Box
    _Image61: Laya.Image
    _Label3: Laya.Label
    _box_desc: Laya.Box
    _Label6: Laya.Label
    _btn: Laya.Box
    _Image6: Laya.Image
    _Label41: Laya.Label
    _Label4: Laya.Label
    public GetComponents() {
        [
            this._box_title,
            this._Image61,
            this._Label3,
            this._box_desc,
            this._Label6,
            this._btn,
            this._Image6,
            this._Label41,
            this._Label4,
        ]
            = this.GetChildrenByNames([

                "_box_title",
                "_Image61",
                "_Label3",
                "_box_desc",
                "_Label6",
                "_btn",
                "_Image6",
                "_Label41",
                "_Label4",
            ])
    }
}
window["SettingSubscriptionItem"] = SettingSubscriptionItem