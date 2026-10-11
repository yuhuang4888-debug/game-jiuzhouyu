import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { WelfareModel, WelfareEvent } from "../commonModel/WelfareModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { OnlineItem } from "./OnlineItem"

export class OnlineView extends BaseItem1 {
    _img_bg: Laya.Image
    _img_slogan: Laya.Image
    _img_loli: Laya.Image
    _gp_pos1: Laya.Box
    _gp_pos2: Laya.Box
    _gp_pos3: Laya.Box
    _gp_pos4: Laya.Box
    _gp_pos5: Laya.Box
    _gp_pos6: Laya.Box
    _group_item: Laya.VBox
    _Image1: Laya.Image
    _lb_time: Laya.Label
    _btn_draw_all: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    _img_red: Laya.Image

    LoadSuccess
    FireEvent
    InitEvent
    InitView
    UpdateView
    ClearTimer
    StartTimer
    SetTimeText
    public constructor(parent) {
        super(parent)
        this.base_file = "online"
        this.layout_file = "OnlineView"
        let model = WelfareModel.GetInstance(),
            local_WelfareEvent = WelfareEvent,
            local_TimeUtil = TimeUtil,
            local_Message = Message,
            res_mgr = ResManager.GetInstance(),
            lcoal_laya = Laya,
            timer_id_,
            ac_item_ = {},
            online_data_

        this.load_callback = function () {
            model.online_is_first_login = false
            this.LoadSuccess()
        }

        this.DeleteMe = () => {
            if(ac_item_){
                for(let key in ac_item_){
                    if(ac_item_[key]){
                        ac_item_[key].DeleteMe()
                    }
                }
                ac_item_= {}
            }
            this.ClearTimer()
            super.DeleteMe()
        }

        this.LoadSuccess = () => {
            this.InitView()
            this.InitEvent()
            this.FireEvent()
        }

        this.FireEvent = () => {
            model.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41715)
        }

        this.InitEvent = () => {
            this.BindVar(model, "online_data", () => {
                online_data_ = model.GetOnlineData()
                this.UpdateView(online_data_.list)
                this.StartTimer()
                this.SetTimeText()
            })

            Util.AddClickEvent(this._btn_draw_all, () => {
                let list = online_data_ && online_data_.list
                if (list) {
                    let state_0 = 0
                    let state_2 = 0
                    for (let v of list) {
                        let cfg = model.GetOnlineCfg(v.id)
                        if (!cfg) return
                        let time = model.GetOnlineData().time
                        let _etime = cfg.online_time - time + local_TimeUtil.getServerTime()
                        let rtime = _etime - local_TimeUtil.getServerTime()
                        if (rtime <= 0 && v.state == 0) {
                            model.Fire(local_WelfareEvent.WELFARE_REQUEST_PROTO, 41716, "i", 0)
                            return
                        } else if (rtime > 0 && v.state == 0) {
                            state_0++
                        } else if (v.state == 2) {
                            state_2++
                        }
                    }
                    if (state_2 == list.length) {
                        local_Message.show("已领取全部奖励")
                    } else {
                        local_Message.show("未达到条件")
                    }

                }
            }, this, true)
            
            this.BindEvent(model,WelfareEvent.UPDATE_ONLINE_VIEW_RED,(index?,state?)=>{
                if(index ==1 && this.is_loaded){
                    this._img_red.visible =  state
                }
            })
        }

        this.InitView = () => {
            res_mgr.SetTexture(this, this._img_slogan, "resource/game/online/texture/uizx_002.png")
            // res_mgr.SetTexture(this, this._img_loli, "resource/game/online/texture/uizx_003.png")
            this._img_red.visible = model.CheckOnlineReddot()

        }

        this.UpdateView = (list?) => {
            model.online_mark = null
            for (let key in list) {
                let item = ac_item_[key]
                if(!item){
                    this["_gp_pos"+(Number(key)+1)].visible = true
                    item = new OnlineItem(this["_gp_pos"+(Number(key)+1)])
                    ac_item_[key] = item
                    item.Load()
                }
                item.SetData(list[key])
            }
        }

        this.ClearTimer = () => {
            if (timer_id_) {
                GlobalTimerQuest.CancelQuest(timer_id_)
                timer_id_ = null
            }
        }

        this.StartTimer = () => {
            this.ClearTimer()
            timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                this.SetTimeText()
            }, 1, -1)
            this.SetTimeText()
        }

        this.SetTimeText = () => {
            let time = online_data_.time + local_TimeUtil.getServerTime() - online_data_.cur_time
            time = Math.floor(time / 60)
            this._lb_time.text = `${time}分钟`
        }
    }

    public GetComponents() {
        [
            this._img_bg,
            this._img_slogan,
            this._img_loli,
            this._gp_pos1,
            this._gp_pos2,
            this._gp_pos3,
            this._gp_pos4,
            this._gp_pos5,
            this._gp_pos6,
            this._group_item,
            this._Image1,
            this._lb_time,
            this._btn_draw_all,
            this._Image11,
            this.labelDisplay,
            this._img_red
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_slogan",
                "_img_loli",
                "_gp_pos1",
                "_gp_pos2",
                "_gp_pos3",
                "_gp_pos4",
                "_gp_pos5",
                "_gp_pos6",
                "_group_item",
                "_Image1",
                "_lb_time",
                "_btn_draw_all",
                "_Image11",
                "labelDisplay",
                "_img_red"
            ])
    }
}
window["OnlineView"] = OnlineView