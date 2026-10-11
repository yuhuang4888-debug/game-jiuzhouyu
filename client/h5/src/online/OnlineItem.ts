import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { UIEffect } from "../common/UIEffect";
import { GoodsModel } from "../commonModel/GoodsModel";
import { KaifuActivityModel } from "../commonModel/KaifuActivityModel";
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";

export class OnlineItem extends BaseItem1 {
    _img_bg: Laya.Image
    _Image1: Laya.Image
    _Image2: Laya.Image
    _lb_time: Laya.HTMLDivElement
    _group_eff: Laya.Box
    _group_item: Laya.Box
    _img_icon: Laya.Image
    _img_tips: Laya.Image
    _img_red: Laya.Image
    _img_double: Laya.Image

    private model = WelfareModel.GetInstance();
    private timer_id
    private effect: UIEffect;
    private cfg;
    private _etime: number;
    private _item: BaseAwardItem;
    data
    needfresh
    constructor(parent?) {
        super(parent)
        this.needfresh = false
        this.base_file = "online"
        this.layout_file = "OnlineItem"
        this.load_callback = () => {
            this.InitEvent()
            let open = KaifuActivityModel.GetInstance().CheckHaveMonthCard()
            this._img_double.visible = open
            if (this.needfresh) {
                this.Update()
            }
        }
    }

    public InitEvent() {
        Util.AddClickEvent(this._img_icon, () => {
            let canGet = this._etime - TimeUtil.getServerTime() <= 0
            if (this.data.state == 0 && canGet) {
                this.model.Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41716, "i", this.data.id)
            }
            else {
                this.OpenRewardView()
            }
        }, this, true)
    }

    public Update() {
        if (!this.is_loaded && this.data) return
        //state 0 未达成 2 已领取 
        let can_get = this.data.state == 0
        // this._img_icon.source = can_get ? "online_json.uizx_009_png" : "online_json.uizx_008_png"
        this._img_tips.visible = !can_get
        this._img_red.visible = false

        this.cfg = this.model.GetOnlineCfg(this.data.id)
        if (!this.cfg) return
        let list = ErlangParser.GetInstance().Parse(this.cfg.reward)
        let vo = list[0]
        let [type_id,lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
        if (!this._item) {
            this._item = new BaseAwardItem(this._group_item)
            this._item.Load()
            this._item.SetItemSize(80, 80)
        }
        this._item.SetData(type_id, vo[2])
        this._item.SetClickCallBack(() => {
            let canGet = this._etime - TimeUtil.getServerTime() <= 0
            if (this.data.state == 0 && canGet) {
                this.model.Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41716, "i", this.data.id)
            }
            else {
                this._item.DefaultCallFun()
            }
        })
        // ResManager.getInstance().SetTexture(this, this._img_icon, GoodsModel.GetGoodsPath(type_id))

        this.ClearEffect()
        this.ClearTimer()
        if (can_get) {
            let time = this.model.GetOnlineData().time
            this._etime = this.cfg.online_time - time + TimeUtil.getServerTime()
            let rtime = this._etime - TimeUtil.getServerTime()
            if (rtime <= 0) {
                this.SetGetStatus()
            }
            else {
                this.StartTimer()
            }
        }
        else {
            this._lb_time.innerHTML = "已达成"
            this._lb_time.x= 143/2 - this._lb_time.contextWidth/2
            this._lb_time.y = 24/2 -this._lb_time.contextHeight/2
        }
    }

    public Clear() {
        if (this._item) {
            this._item.DeleteMe()
            this._item = null
        }
        this.ClearEffect()
        this.ClearTimer()
    }

    public ClearTimer() {
        if (this.timer_id) {
            GlobalTimerQuest.CancelQuest(this.timer_id)
            this.timer_id = null
            //第一个item会触发2次dataChanged 要清空mark
            if (this.model.online_mark == this.data.id) {
                this.model.online_mark = undefined
            }
        }
    }

    public StartTimer() {
        if (!this.model.online_mark) {
            this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
                this.SetTimeText()
            }, 1, -1)
            this.model.online_mark = this.data.id
            this.SetTimeText()
        }
        else {
            let minute = this.cfg.online_time / 60
            this._lb_time.innerHTML = "<font color='#19ae4a'>" + `${minute}</font>分钟奖励`
            this._lb_time.x= 143/2 - this._lb_time.contextWidth/2
            this._lb_time.y = 24/2 -this._lb_time.contextHeight/2
        }
    }

    public SetTimeText() {
        let rtime = this._etime - TimeUtil.getServerTime()
        if (rtime <= 0) {
            this.ClearTimer()
            // this.SetGetStatus()
            //刷新时间,用于重新选定倒计时的item
            // let online_data = this.model.GetOnlineData()
            // let pass_time = TimeUtil.getServerTime() - online_data.login_time
            // online_data.time += pass_time
            // online_data.login_time = TimeUtil.getServerTime()
            // this.model.SetOnlineData(online_data)

            this.model.Fire(WelfareEvent.WELFARE_REQUEST_PROTO, 41715)
        }
        else {
            let time = TimeUtil.timeConvert8(rtime)
            this._lb_time.innerHTML = "<font color ='#19ae4a'>" + `${time}</font>后可领取`
            this._lb_time.x= 143/2 - this._lb_time.contextWidth/2
            this._lb_time.y = 24/2 -this._lb_time.contextHeight/2
        }
    }

    public ClearEffect() {
       this.ClearUIEffect(this._group_eff)
    }

    public OpenRewardView() {
        if (!this.cfg) return
        let list = ErlangParser.GetInstance().Parse(this.cfg.reward)
        GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RewardPreView", list)
    }

    public SetGetStatus() {
        this._lb_time.innerHTML = "<font color ='#19ae4a'>可领取</font>"
        this._group_eff.centerY=37
        this.AddUIEffect("UI_1601_03", this._group_eff, null, 5, true)
        this._lb_time.x= 143/2 - this._lb_time.contextWidth/2
        this._lb_time.y = 24/2 -this._lb_time.contextHeight/2
        this._img_red.visible = true
    }

    public SetData(data?) {
        this.data = data
        if (this.is_loaded) {
            this.Update()
        } else {
            this.needfresh = true
        }
    }

    public DeleteMe() {
        this.ClearTimer()
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this._img_bg,
            this._Image1,
            this._Image2,
            this._lb_time,
            this._group_eff,
            this._group_item,
            this._img_icon,
            this._img_tips,
            this._img_red,
            this._img_double
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_Image1",
                "_Image2",
                "_lb_time",
                "_group_eff",
                "_group_item",
                "_img_icon",
                "_img_tips",
                "_img_red",
                "_img_double"
            ])
        this._lb_time.style.fontSize =18
        this._lb_time.style.color = "#663915"
        this._lb_time.style.wordWrap = false
    }
}
window["OnlineItem"] = OnlineItem