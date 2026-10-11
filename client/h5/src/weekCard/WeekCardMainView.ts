import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { KaifuActivityModel, KaifuActivityModelEvent } from "../commonModel/KaifuActivityModel"
import { VipModel } from "../commonModel/VipModel"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, Util, SetSizeDeltaY, GlobalTimerQuest } from "../util/Util"
import { WeekCardItem } from "./WeekCardItem"

export class WeekCardMainView extends BaseItem1 {
    CancelTime
    InitEvent
    InitView
    LoadSuccess
    LocalDeleteMe
    StarTimer
    UpdateView
    UpdatePrograss
    CreatItem
    UpdateGiftNum


    public constructor(parent?) {
        super(parent)


        this.base_file = "weekCard"
        this.layout_file = "WeekCardMainView"
        let timer_ = null
        let item_list_ = []
        let is_max = false
        let model = WeekCardModel.GetInstance()
        this.preload_server_config = {
            "config_weekly_card": false,
            "config_weekly_card_kv": false,
            "config_recharge_product": false
        }
        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()

        }

        this.LocalDeleteMe = () => {
            is_max = false
            if (item_list_ && item_list_.length > 0) {
                for (let _tmpi in item_list_) {
                    let obj = item_list_[_tmpi]
                    obj.DeleteMe()
                }
                item_list_ = null
            }
            this.CancelTime()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("weekCard", "ui_activity_44"))
	      if(PlatformManager.IsEyouPlatform()){
                this.des1.y = 226
                this.des1.style.wordWrap = true
                this.des1.style.leading = 0.1
                this.des1.style.width = 470
            }
            this.des1.innerHTML = "每击败<font color='#0a953e'>1</font>个大妖，可领取<font color='#0a953e'>5</font>个周卡资源礼包"
            this.des3.innerHTML = `每天<font color='#fff002'>凌晨4时</font>可获得10周卡经验`
            this.CreatItem()
            this.UpdateView()
        }

        this.InitView = () => {

        }

        this.InitEvent = () => {
            Util.AddClickEvent(this.box_gp, () => {
                let _cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_weekly_card_kv", false)
                if (_cfg1) {
                    let value = _cfg1.weekly_card_gift_bag && _cfg1.weekly_card_gift_bag.value
                    let reward = ErlangParser.GetInstance().Parse(value)
                    let type_id = reward && reward[0][1]
                    if (type_id)
                        UIToolTipMgr.GetInstance().AppendGoodsTips(type_id)
                }
            }, this, true)


            let pay_fun = () => {
                if (is_max) {
                    Message.show("持续天数超过70天，无法继续续费")
                    return
                }
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
                if(!cfg) return
                let product_info_ = cfg[107]
                let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                if (hasNum >= 8) {
                    VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', 107)
                }
                else {
                    if (product_info_) {

                        PlatformManager.GetInstance().PayRequest(product_info_.money, { id: product_info_.product_id, pay_title: product_info_.product_name }, (ret) => {
                            if (ret == 'SUCCESS') {
                                model.Fire(WeekCardModel.REQUEST_PROTO, 45201)
                            }
                        })
                    }
                }
            }
            Util.AddClickEvent(this.pay, () => {
                pay_fun()

            }, this, true)

            Util.AddClickEvent(this.receive_btn, () => {
                let data = model.GetWeekCardData()
                if (data.is_activity) {
                    let can_receive = data && data.can_receive_gift
                    if (can_receive)
                        model.Fire(WeekCardModel.REQUEST_PROTO, 45202)
                    else {
                        Alert.Show("当前没有可领礼包，是否前往击杀大妖获取？", Alert_Type.Two, () => {
                            OpenFun.OpenFunHandler(26)
                        }, null, "立即前往", "取消")
                        //Message.show("当前没有可领礼包")
                    }

                }
                else {
                    let have_reward = model.GetHaveReward()
                    if (have_reward) {
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'WeekCardTipView')
                    }
                    else {
                        Alert.Show("仅需8元激活周卡便可领取礼包、享受众多特权，是否前往激活？", Alert_Type.Two, () => {
                            pay_fun()
                        }, null, "激活", "取消")
                    }

                }

            }, this, true)

            this.BindEvent(model, WeekCardModel.UPDATE_VIEW, (data) => {
                this.UpdateView()
            })

            this.BindEvent(VipModel.GetInstance(), VipModel.USE_TOKEN_SUCCESS, () => {
                model.Fire(WeekCardModel.REQUEST_PROTO, 45201)
            })
            model.Fire(WeekCardModel.REQUEST_PROTO, 45201)
            model.Fire(WeekCardModel.REQUEST_PROTO, 45203)
        }

        this.UpdateView = () => {
            let data = model.GetWeekCardData()
            if (!data) return
            this.level.text = data && data.lv
            this.can_receive.text = data && data.can_receive_gift
            this.can_receive.color = data && data.can_receive_gift > 0 ? "#0a953e" : "#fe1a1a"
            this.btn_lab.text = data.is_activity ? "8元续费" : "8元激活"

            this.time.visible = data.is_activity
            this.pay.y = data.is_activity ? 22 : 27
            this.UpdatePrograss(data.lv, data.exp)
            this.UpdateGiftNum(data.lv, data.gift_bag_num)
            if (data.is_activity) {
                let left_time = data.expired_time - TimeUtil.getServerTime()
                let D = Math.floor(left_time / 60 / 60 / 24)
                if (D >= 70) {
                    this.btn_lab.text = "已达上限"
                    is_max = true
                }
                this.StarTimer(data.expired_time)

            }
            this.red.visible = model.CanReceive() || WeekCardModel.GetInstance().spacial_red
            KaifuActivityModel.GetInstance().Fire(KaifuActivityModelEvent.UPDATE_TAB_RED, "WeekCardMainView", model.CanReceive() || WeekCardModel.GetInstance().spacial_red)
        }



        this.StarTimer = (time) => {
            this.CancelTime()
            if (!time) return
            timer_ = GlobalTimerQuest.AddPeriodQuest(() => {
                let left_time = time - TimeUtil.getServerTime()
                if (left_time < 0) {
                    this.CancelTime()
                    this.time.text = "已过期"
                    return
                }
                if (this.time) {
                    let D = Math.floor(left_time / 60 / 60 / 24)
                    let h = Math.floor(left_time / 60 / 60) % 24
                    let m = Math.floor(left_time / 60) % 60
                    let s = left_time % 60
                    if (D >= 1) {
                        this.time.text = D + "天" + h + "小时" + m + "分" + s + "秒"
                    } else if (h >= 1) {
                        this.time.text = h + "小时" + m + "分" + s + "秒"
                    } else if (m >= 1) {
                        if (s >= 10) {
                            this.time.text = m + "分" + s + "秒"
                        } else {
                            this.time.text = m + "分0" + s + "秒"
                        }
                    } else {
                        if (s >= 10) {
                            this.time.text = s + "秒"
                        } else {
                            this.time.text = "0" + s + "秒"
                        }
                    }
                }
            }, 1)
        }

        this.CancelTime = () => {
            if (timer_) {
                GlobalTimerQuest.CancelQuest(timer_)
            }
        }

        this.UpdatePrograss = (level, exp) => {
            let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_weekly_card", false)
            if (level && _cfg && _cfg[level]) {
                let cfg = _cfg[level]
                this.progress.width = 519 * (exp / cfg.exp)
                this.prograss_lab.text = `${exp}/${cfg.exp}`
            }
        }

        this.CreatItem = () => {
            for (let i = 0; i < 4; i++) {
                let item = item_list_[i]
                if (!item) {
                    item = new WeekCardItem(this.item_gp)
                    item.Load()
                    table.insert(item_list_, item)
                }
                item.Setdata(i)
            }
        }

        this.UpdateGiftNum = (level, num) => {
            let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_weekly_card", false)
            let _cfg1 = ResManager.GetInstance().GetGameConfigFromCache(this, "config_weekly_card_kv", false)
            if (level && _cfg && _cfg[level]) {
                let cfg = _cfg[level]
                let weekly_card_base_gift_num = _cfg1.weekly_card_base_gift_num && _cfg1.weekly_card_base_gift_num.value
                let weekly_card_lv_add_num = _cfg1.weekly_card_lv_add_num && _cfg1.weekly_card_lv_add_num.value
                let can_receive_num = Number(weekly_card_base_gift_num) + (Number(weekly_card_lv_add_num) * (level - 1))
                let next_level = level + 1
                let next_num_add = _cfg[next_level] && _cfg[next_level].add_num ? _cfg[next_level].add_num : 0
                let str = next_num_add ? `（下级上限+<font color='#0a953e'>${next_num_add}</font>）` : ""
                this.des2.innerHTML = `<font color='#0a953e'>${num}/${can_receive_num}</font>${str}`
            }
        }
    }


    public DeleteMe() {
        this.LocalDeleteMe()
        super.DeleteMe()
    }


    progress: Laya.Image
    bg1: Laya.Image
    pay: Laya.Box
    item_gp: Laya.VBox
    level: Laya.Label
    time: Laya.Label
    prograss_lab: Laya.Label
    des1: Laya.HTMLDivElement
    can_receive: Laya.Label
    des2: Laya.HTMLDivElement
    receive_btn: Laya.Box
    btn_lab: Laya.Label
    red: Laya.Image
    des3: Laya.HTMLDivElement
    box_gp: Laya.Image
    public GetComponents() {
        [
            this.progress,
            this.bg1,
            this.pay,
            this.item_gp,
            this.level,
            this.time,
            this.prograss_lab,
            this.des1,
            this.can_receive,
            this.des2,
            this.receive_btn,
            this.btn_lab,
            this.red,
            this.des3,
            this.box_gp
        ]
            = this.GetChildrenByNames([

                "progress",
                "bg1",
                "pay",
                "item_gp",
                "level",
                "time",
                "prograss_lab",
                "des1",
                "can_receive",
                "des2",
                "receive_btn",
                "btn_lab",
                "red",
                "des3",
                "box_gp"
            ])
        this.des1.style.fontSize = 22
        this.des1.style.color = "#663915"
        this.des1.style.wordWrap = false
        this.des2.style.fontSize = 22
        this.des2.style.color = "#663915"
        this.des2.style.wordWrap = false
        this.des3.style.fontSize = 20
        this.des3.style.color = "#ffffff"
        this.des3.style.wordWrap = false
        this.des3.style.stroke = 2
        this.des3.style.strokeColor = "#712941"
    }
}
window["WeekCardMainView"] = WeekCardMainView