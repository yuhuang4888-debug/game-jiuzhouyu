import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import { TaskModel } from "../commonModel/TaskModel"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { TimeUtil } from "../util/TimeUtil"
import { Color, GlobalTimerQuest, Util } from "../util/Util"

export class OnHookAdditionItem extends BaseItemRenderer {
    WIDTH = 494
    HEIGT = 100
    progress_width = 0
    reward
    model
    time_id
    str
    public constructor() {
        super()

        this.base_file = "onHook"
        this.layout_file = "OnHookAdditionItem"
        this.model = OnHookModel.GetInstance()
        this.load_callback = () => {
            this.InitEvent()
            this.progress_width = this._img_pro.width
            if (!this.reward) {
                this.reward = new EquipmentItem(this._gp_item)
                this.reward.Load()
                this.reward.SetItemSize(77, 77)
            }
        }

        this.Load()
    }


    public InitEvent() {
        Util.AddClickEvent(this.btn, () => {
            if (this.data.type == 450) {
                OpenFun.OpenFunHandler(this.data.jump_id)
                this.model.Fire(OnHookModel.CLOSE_ALL_VIEW)
            } else if (this.data.type == 150) {
                this.model.Fire(OnHookModel.OPEN_VIEW, "OnHookAdditionTips")
            } else if (this.data.type == 216) {
                GuardModel.GetInstance().Fire(GuardModel.OPEN_VIEW, 1)
                this.model.Fire(OnHookModel.CLOSE_ALL_VIEW)
            } else if (this.data.type == 412) {
                OpenFun.OpenFunHandler(this.data.jump_id)
                this.model.Fire(OnHookModel.CLOSE_ALL_VIEW)
            }
        }, this, true)
    }

    public dataChanged() {
        if (!super.dataChanged() || !this.data) {
            return
        }
        if (this.data) {
            this.reward.SetData(this.data.item_id)
        }

        if (this.data.type == 450) {
           this.str = "VIP"
        } else if (this.data.type == 150) {
            this.str = "经验符"
            if(this.data.real_numb <= 10000){
                this.data.max_number = 100
            }else{
                this.data.max_number = 200
            }
        } else if (this.data.type == 216) {
            this.str = "经验喵"
        } else if (this.data.type == 412) {
            this.str = "侍魂幻化"
        }
        this._img_pro.width = (this.data.real_numb / (this.data.max_number * 100) )*this.progress_width
        this._lb_progress.innerHTML = (this.data.real_numb/100) + "%/" +  this.data.max_number + "%"
        this.have_time.innerHTML = this.str +"：<font color = '#0a953e'>" + TimeUtil.timeConvert(this.data.end_time - TimeUtil.getServerTime(),"hh-mm-ss") + "</font>"
        if (this.data.real_numb == this.data.max_number * 100) {
            this.btn.visible = false
            this.perfect.visible = true
        }
        if(this.data.real_numb == 0){
            this.have_time.innerHTML = this.str + "：<font color = '#fe1a1a'>未激活</font>"
        }else{
            this.starTime()
        }
    }

    public starTime() {
        if(this.time_id){
            GlobalTimerQuest.CancelQuest(this.time_id)
            this.time_id = null
        }
        let left_time = this.data.end_time - TimeUtil.getServerTime()
        let D = Math.floor(left_time / 60 / 60 / 24)
        if(D >= 365 || this.data.end_time == 0){
            this.have_time.innerHTML = this.str +"：<font color= '#0a953e'>永久</font>"
        }else{
            this.time_id = GlobalTimerQuest.AddDelayQuest(() =>{
                this.have_time.innerHTML = this.str +"：<font color ='#0a953e'>" + TimeUtil.timeConvert(this.data.end_time - TimeUtil.getServerTime(),"hh-mm-ss") + "</font>"
            },1)
        }
    }

    public DeleteMe() {
        if (this.reward) {
            this.reward.DeleteMe()
            this.reward = null
        }
        if(this.time_id){
            GlobalTimerQuest.CancelQuest(this.time_id)
            this.time_id = null
        }
        super.DeleteMe()
    }


    bg: Laya.Image
    _gp_item: Laya.Image
    _img_pro_bg: Laya.Image
    _img_pro: Laya.Image
    _lb_progress: Laya.HTMLDivElement
    btn: Laya.Box
    perfect: Laya.Image
    have_time:Laya.HTMLDivElement
    public GetComponents() {
        [
            this.bg,
            this._gp_item,
            this._img_pro_bg,
            this._img_pro,
            this._lb_progress,
            this.btn,
            this.perfect,
            this.have_time
        ]
            = this.GetChildrenByNames([

                "bg",
                "_gp_item",
                "_img_pro_bg",
                "_img_pro",
                "_lb_progress",
                "btn",
                "perfect",
                "have_time"
            ])
        this.have_time.style.fontSize = 22
        this.have_time.style.color = "#663915"
        this.have_time.style.wordWrap = false
        this._lb_progress.style.fontSize = 16
        this._lb_progress.style.wordWrap =false
        this._lb_progress.style.color = "#663915"

    }
}
window["OnHookAdditionItem"] = OnHookAdditionItem