import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Config } from "../common/Config";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BabyRecordItem } from "./BabyRecordItem"
import { BabyTreasureTaskItem } from "./BabyTreasureTaskItem"
import { EquipTreasureItem } from "./EquipTreasureItem"



export class BabyTreasureView extends BaseItem1 {
    public Round
    public Round1
    public Round2
    public record_bg
    public luckImg
    public luckBG
    bg1
    public round_group
    public mid_group0
    public mid_group1
    public mid_group2
    public record_scroller
    public record_group
    public totalBtn
    public personBtn
    public mask_img
    allBtn
    public oneBtn
    public free_conta
    public cost_conta
    public one_text
    public one_cost
    public one_icon
    public red_dot
    nothingLb
    public tenBtn
    public ten_text
    public ten_cost
    public ten_icon
    public _img_discount
    _Image1: Laya.Image
    _Image2: Laya.Image

    labelDisplay: Laya.Label
    _Image3: Laya.Image
    _Group1: Laya.Box
    _Image4: Laya.Image
    _task_scroller: Laya.Panel
    Content: Laya.Box
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Image7: Laya.Image
    _Image8: Laya.Image
    _Image9: Laya.Image
    _Image10: Laya.Image
    _Group2: Laya.Box
    oneBtnBg: Laya.Image

    one_txt: Laya.Label

    _Group3: Laya.Box
    tenBtnBg: Laya.Image
    ten_txt: Laya.Label
    tenRed: Laya.Image
    Content1: Laya.Box
    //显示界面的类型
    public type
    totalImg
    totalLb
    personImg
    personLb
    taskGp
    // public model = local_treModel.GetInstance()

    LoadSuccess
    InitView
    InitEvent
    SetGoodsIcon
    enterFrameHandler
    SetRecord
    SetTask
    CancelAniTimer
    StarAni
    PlayAni
    StarAniTimer
    StarStopTimer
    CancelStopTimer
    BtnClickFun
    SetBtnState
    public constructor(parent) {
        super(parent)
        this.base_file = "runeTreasure"
        this.layout_file = "BabyTreasureView"
        // let local_eui = eui
        let rt_event = RuneTreasureEvent
        let resMgr = ResManager.GetInstance()
        let local_treModel = RuneTreasureModel
        let goodsM = GoodsModel
        let g_model = goodsM.GetInstance()
        let local_util = Util
        let local_egret = Laya
        let local_global = GlobalEventSystem
        let roleMgr = RoleManager.GetInstance()
        let trea_model = local_treModel.GetInstance(),
            one_item_: BaseAwardItem,
            ten_item_: BaseAwardItem,
            treasure_type_ = RuneTreasureModel.BABY_TREASURE_TYPE,
            treasure_ticket_ = RuneTreasureModel.BABY_TREASURE_TICKET,
            treasure_show_alert_ = RuneTreasureModel.show_baby_cost_alert,
            array_collection_: LoopScrowViewMgr,
            taskCol_: LoopScrowViewMgr,
            //1为全服 2为个人
            select_record_type_ = 1,
            //动画
            centerX_: number = 300,
            centerY_: number = 300,
            radius_: number = 225,
            degree_: number = 0,
            goods_count_ = 12,
            fragment_list_ = {},
            type_id_array_ = [],
            reward_config_,
            item_list_ = {},
            spe_item_list_ = {},
            play_ani_,
            lastClickTime_,
            jin_event_id_,
            ani_timer_,
            stop_ani_timer_,
            data_,
            ani_list_ = [],
            stop_time_ = 3,
            stop_timer_id_
        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.preload_server_config = {
            "config_treasure_hunt_reward": false
        }

        this.LoadSuccess = () => {
            reward_config_ = this.preload_server_config.config_treasure_hunt_reward
            array_collection_ = new LoopScrowViewMgr()
            array_collection_.SetData(this.record_group, BabyRecordItem, [], LoopScrCon.Horizontal, 1)

            taskCol_ = new LoopScrowViewMgr()
            taskCol_.SetData(this.taskGp, BabyTreasureTaskItem, [], LoopScrCon.Horizontal, 1)

            this.totalImg = <Laya.Image>this.totalBtn.getChildAt(0)
            this.totalLb = <Laya.Label>this.totalBtn.getChildAt(1)

            this.personImg = <Laya.Image>this.personBtn.getChildAt(0)
            this.personLb = <Laya.Label>this.personBtn.getChildAt(1)
            let item_list = []
            if (reward_config_) {
                this.InitView()
                this.InitEvent()
            }
            trea_model.Fire(rt_event.RUNE_TREASURE_REQUEST_PROTO, 41608, "cc", treasure_type_, 2)
            trea_model.Fire(rt_event.RUNE_TREASURE_REQUEST_PROTO, 41620, "c", treasure_type_)
            resMgr.SetTexture(this, this.bg1, `resource/game/runeTreasure/texture/uidjtz_005.png`)
           // resMgr.SetTexture(this, this._img_discount, `resource/game/common2/texture/sh_discount_9.png`)
            resMgr.SetImageSprite(this, this._img_discount,"common2","sh_discount_9")
        }

        this.InitView = () => {
            resMgr.SetTexture(this, this.mask_img, `resource/game/runeTreasure/texture/babyround.png`)
            this.round_group.mask = this.mask_img
            this.SetGoodsIcon()
            this.SetRecord(1)
            this.SetTask()
            if (trea_model.record_data_list && trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`]) {
                this.SetBtnState(trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`])
            }
        }

        this.InitEvent = () => {
            local_util.AddClickEvent(this.oneBtn, () => {
                this.BtnClickFun(1)
            }, this, true)

            local_util.AddClickEvent(this.tenBtn, () => {
                this.BtnClickFun(10)
            }, this, true)

            this.BindEvent(trea_model, rt_event.UPDATE_EQUIP_RECORD_DATA, (data) => {
                if (data) {
                    if (data.htype == treasure_type_ && select_record_type_ == data.rtype) {
                        this.SetBtnState(data)
                    }
                }
                this.SetRecord()
            })

            local_util.AddClickEvent(this.totalBtn, () => {
                if (select_record_type_ != 1) {
                    this.totalImg.source = "runeTreasure_json.uilt_008a_png"
                    this.personImg.source = "runeTreasure_json.uilt_009_png"
                    this.totalLb.textColor = 0xffffff
                    this.personLb.textColor = 0xa16d53
                    this.SetRecord(1)
                }
            }, this, false)

            local_util.AddClickEvent(this.personBtn, () => {
                if (select_record_type_ != 2) {
                    this.totalImg.source = "runeTreasure_json.uilt_009_png"
                    this.personImg.source = "runeTreasure_json.uilt_008a_png"
                    this.totalLb.textColor = 0xa16d53
                    this.personLb.textColor = 0xffffff
                    this.SetRecord(2)
                }
            }, this, false)

            let change_fun = () => {
                if (this.use_delete_method) return
                if (trea_model.record_data_list && trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`]) {
                    this.SetBtnState(trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`])
                }
            }
            this.BindEvent(g_model, goodsM.CHANGE_BAG_LIST, change_fun)

            let onGroupTouchHandler = (e) => {
                this.CancelStopTimer()
                this.CancelAniTimer()
            }
            // this.record_group.addEventListener(local_egret.TouchEvent.TOUCH_BEGIN, onGroupTouchHandler, this)

            let OnTouchEndHandler = (e) => {
                this.StarStopTimer()
            }
            // this.record_group.addEventListener(local_egret.TouchEvent.TOUCH_RELEASE_OUTSIDE, OnTouchEndHandler, this)
            // this.record_group.addEventListener(local_egret.TouchEvent.TOUCH_TAP, OnTouchEndHandler, this)
            let egret_event = Laya.Event;
            this.record_group.on(egret_event.MOUSE_DOWN, this, onGroupTouchHandler);
            this.record_group.on(egret_event.MOUSE_UP, this, OnTouchEndHandler);
            local_util.AddClickEvent(this.allBtn, () => {
                trea_model.Fire(rt_event.RUNE_TREASURE_OPEN_VIEW, "EquipTreaseRewardView", treasure_type_)
            }, this, true)

            this.BindEvent(trea_model, rt_event.TASK_UPDATE, (scmd) => {
                if (scmd.htype == treasure_type_) {
                    this.SetTask()
                }
            })
        }

        this.SetGoodsIcon = () => {

            let round_goods_data_list = []
            let special_data_list = []

            if (reward_config_) {
                for (let key in reward_config_) {
                    if (reward_config_[key].htype == treasure_type_
                        && reward_config_[key].is_rare == 0 && round_goods_data_list.length <= local_treModel.showCount
                        && reward_config_[key].min_rlv <= roleMgr.GetMainRoleVo().level
                        && reward_config_[key].max_rlv >= roleMgr.GetMainRoleVo().level) {
                        round_goods_data_list.push(reward_config_[key])
                        type_id_array_.push(reward_config_[key].goods_id)
                    }
                    if (reward_config_[key].htype == treasure_type_
                        && reward_config_[key].is_rare == 1
                        && reward_config_[key].min_rlv <= roleMgr.GetMainRoleVo().level
                        && reward_config_[key].max_rlv >= roleMgr.GetMainRoleVo().level) {
                        if (trea_model.drawWeaponlist[treasure_type_]) {
                            if (reward_config_[key].stype == 240) {
                                continue
                            } else if (reward_config_[key].stype == 241) {
                                special_data_list.unshift(reward_config_[key])
                                continue
                            }
                        }
                        special_data_list.push(reward_config_[key])
                    }
                }
            }
            // this.addEventListener(local_egret.Event.ENTER_FRAME, this.enterFrameHandler, this)

            let count = goods_count_ < round_goods_data_list.length ? goods_count_ : round_goods_data_list.length
            for (let i = 0; i < count; i++) {
                fragment_list_[i] = i / count * 360

                let item = item_list_[i]
                if (!item) {
                    item = new EquipTreasureItem(this.round_group)
                    item_list_[i] = item
                    item.Load()
                    item.SetScale(0.84)
                }
                if (round_goods_data_list[i]) {
                    let goods_id = type_id_array_.shift()
                    let goods_vo = g_model.GetGoodsBasicByTypeId(goods_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id)
                    }
                }
            }
            for (let i = 0; i < 3 && i < special_data_list.length; i++) {
                let group = this[`mid_group${i}`]
                let item = spe_item_list_[i]
                if (!item) {
                    item = new EquipTreasureItem(group)
                    spe_item_list_[i] = item
                    item.Load()
                }
                if (special_data_list[i]) {
                    let goods_vo = g_model.GetGoodsBasicByTypeId(special_data_list[i].goods_id)
                    if (goods_vo) {
                        item.ExcuteCallback(() => {
                            item.AddExpImg(`c`)
                            item.SetData(goods_vo.type_id)
                            item.SetUIEffect(3)
                            item.treasureType = treasure_type_
                            // if (special_data_list[i].stype == 241 && RedDotManager.GetInstance().CheckRedStatus(trea_model.TypeToModule(treasure_type_), 4)) {
                            //     item.reddot.visible = true
                            // } else {
                            //     item.reddot.visible = false
                            // }
                        })
                    }
                }
            }
        }

        this.enterFrameHandler = (e) => {

            let pt: Laya.Point
            if (item_list_) {
                for (let i = 0; i < goods_count_; i++) {
                    // pt = local_egret.Point.polar(radius_, (fragment_list_[i] + degree_) * Math.PI / 180);
                    let angle = (fragment_list_[i] + degree_) * Math.PI / 180
                    pt = new Laya.Point(radius_ * Math.cos(angle), radius_ * Math.sin(angle))
                    let item: EquipTreasureItem = item_list_[i]
                    if (item) {
                        item.SetX(pt.x)
                        item.SetY(pt.y)
                        if (!item.changed && item.GetX() <= 130 && item.GetX() >= 80 && item.GetY() > 200) {
                            type_id_array_.push(item.type_id)
                            item.SetData(type_id_array_.shift())
                            item.changed = true
                        } else if (item.changed && item.GetX() > radius_ - 10) {
                            item.changed = false
                        }
                    }
                }
            }
            degree_ += 0.13
        }

        this.SetRecord = (select?) => {

            this.CancelAniTimer()
            if (select) {
                select_record_type_ = select
            }
            if (trea_model.record_data_list && trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`]) {
                let list = trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`].list
                // array_collection_.source = trea_model.record_data_list[`${treasure_type_}@${select_record_type_}`].list
                array_collection_.replaceAll(list)
                this.nothingLb.visible = list.length == 0
            } else {
                this.nothingLb.visible = true
            }
            this.StarStopTimer()
        }

        this.SetTask = () => {
            let list = trea_model.taskList[treasure_type_]
            if (list) {
                let sortFunc = (a, b) => {
                    if (b.state != a.state) {
                        if (b.state == 1 || a.state == 2) {
                            return 1
                        } else if (a.state == 1 || b.state == 2) {
                            return -1
                        }
                    } else {
                        return -1
                    }
                }
                list.sort(sortFunc)
                taskCol_.replaceAll(list)
            }
        }

        this.CancelAniTimer = () => {

            if (ani_timer_) {
                // ani_timer_.stop()
                // ani_timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.PlayAni, this)
                // ani_timer_ = null
                Laya.timer.clear(this, this.PlayAni)
            }
        }
        this.StarAni = () => {

            this.CancelAniTimer()
            if (!this.record_group) return
            let count = this.record_group.numElements
            this.record_scroller.viewport.scrollV = 0
            if (count > 6) {
                // ani_timer_ = new local_egret.Timer(1000, 0)
                // ani_timer_.addEventListener(local_egret.TimerEvent.TIMER, this.PlayAni, this)
                // ani_timer_.start()
                Laya.timer.loop(1000, this, this.StarAniTimer)
            }
        }

        this.PlayAni = () => {

            // let item = array_collection_.removeItemAt(0)
            // array_collection_.addItem(item)\
            array_collection_.RemoveAndAddFirst()
        }

        this.StarAniTimer = () => {
            if (this.use_delete_method) return
            this.StarAni()
            this.CancelStopTimer()
        }

        this.StarStopTimer = () => {

            this.CancelAniTimer()
            this.CancelStopTimer()
            // stop_ani_timer_ = new local_egret.Timer(2000, 1)
            // stop_ani_timer_.addEventListener(local_egret.TimerEvent.TIMER, this.StarAniTimer, this)
            // stop_ani_timer_.start()
            Laya.timer.once(2000, this, this.StarAniTimer)
        }

        this.CancelStopTimer = () => {

            // if (stop_ani_timer_) {
            //     stop_ani_timer_.stop()
            //     stop_ani_timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.StarAniTimer, this)
            //     stop_ani_timer_ = null
            // }
            Laya.timer.clear(this, this.StarAniTimer)
        }

        //按钮点击操作
        this.BtnClickFun = (num) => {

            let my_have = g_model.GetTypeGoodsNum(treasure_ticket_)
            let basic = g_model.GetGoodsBasicByTypeId(treasure_ticket_)
            if (!basic) {
                return
            }
            let request_fun = (buy_type) => {
                // if (buy_type == 1) {//|| !this.lastClickTime || this.lastClickTime - TimeUtil.getClientTime() >= 0.4
                trea_model.Fire(rt_event.RUNE_TREASURE_REQUEST_PROTO, 41604, "ccc", treasure_type_, num, buy_type)
                // this.lastClickTime = TimeUtil.getClientTime()
                // } else {
                //     Message.show("夺宝中！")
                // }
            }
            let check_func = (bool: boolean) => {
                local_treModel.show_baby_cost_alert = bool
            }
            let ok_func = () => {
                request_fun(1)
            }
            let need = num - my_have
            if (num == 10) {
                need -= 1
            }
            let goods_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[treasure_ticket_]
            let goods_price = goods_info ? goods_info.price : 1
            goods_price = goods_price * need
            if (need > 0) {		//不够券
                let money_enough = roleMgr.mainRoleInfo.jin >= goods_price
                let gap = need - roleMgr.mainRoleInfo.jin
                if (money_enough) {
                    let show = local_treModel.show_baby_cost_alert
                    if (!show) {
                        let str = `是否消耗<font color=0x639c12>${goods_price}勾玉</font>购买<font color=0x639c12>${need}</font>个<font color=0x639c12>${basic.goods_name}</font>`
                        let content = local_util.StrToHTML(str)
                        Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                    } else {
                        ok_func()
                    }
                } else {
                    let charge_fun = () => {
                        OpenFun.OpenFunHandler(21)
                    }
                    let str = `您的勾玉不足${goods_price}，是否前往充值`
                    Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
                }
            } else {
                request_fun(0)
            }
        }

        this.SetBtnState = (data) => {
            if (data) {
                this.free_conta.visible = false
                this.one_cost.visible = true
                this.one_icon.visible = true
                this.cost_conta.visible = true
                // this.red_dot.visible = false

                let my_have = g_model.GetTypeGoodsNum(treasure_ticket_)
                if (!one_item_) {
                    one_item_ = new BaseAwardItem(this.one_icon)
                    one_item_.Load()
                    one_item_.SetItemSize(40, 40)
                    one_item_.Load()
                    one_item_.SetItembgVisible(false)
                    one_item_.SetData(treasure_ticket_, 1)
                    one_item_.SetShowTips(false)
                }
                this.one_cost.text = `${my_have}/1`
                if (my_have < 1) {
                    this.one_cost.textFlow = local_util.StrToHTML(`${my_have}/1`)
                }
                if (!ten_item_) {
                    ten_item_ = new BaseAwardItem(this.ten_icon)
                    ten_item_.Load()
                    ten_item_.SetItemSize(40, 40)
                    ten_item_.Load()
                    ten_item_.SetItembgVisible(false)
                    ten_item_.SetData(treasure_ticket_, 1)
                    ten_item_.SetShowTips(false)
                }
                this.ten_cost.text = `${my_have}/9`
                if (my_have < 10) {
                    this.ten_cost.textFlow = local_util.StrToHTML(`${my_have}/9`)
                }
            }
        }

        this.DeleteMe = () => {

            // this.removeEventListener(local_egret.Event.ENTER_FRAME, this.enterFrameHandler, this)
            if (item_list_) {
                for (let key in item_list_) {
                    item_list_[key].DeleteMe()
                    delete item_list_[key]
                }
                item_list_ = {}
            }
            if (spe_item_list_) {
                for (let key in spe_item_list_) {
                    spe_item_list_[key].DeleteMe()
                    delete spe_item_list_[key]
                }
                spe_item_list_ = {}
            }
            if (one_item_) {
                one_item_.DeleteMe()
                one_item_ = null
            }
            if (ten_item_) {
                ten_item_.DeleteMe()
                ten_item_ = null
            }
            this.CancelAniTimer()
            this.CancelStopTimer()
            super.DeleteMe()
        }
    }

    public GetComponents() {
        [
            this.allBtn,
            this.bg1,
            this._Image1,
            this._Image2,
            this.mask_img,
            this.round_group,
            this.totalBtn,
            this.totalImg,
            this.totalLb,
            this.personBtn,
            this.personLb,
            this.labelDisplay,
            this._Image3,
            this._Group1,
            this._Image4,
            this._task_scroller,
            this.Content,
            this._Image5,
            this._Image6,
            this._Image7,
            this._Image8,
            this._Image9,
            this._Image10,
            this.mid_group0,
            this.mid_group1,
            this.mid_group2,
            this._Group2,
            this.oneBtn,
            this.oneBtnBg,
            this.free_conta,
            this.cost_conta,
            this.one_txt,
            this.one_icon,
            this.one_cost,
            this._Group3,
            this.tenBtn,
            this.tenBtnBg,
            this.ten_txt,
            this.ten_cost,
            this.ten_icon,
            this.tenRed,
            this._img_discount,
            this.record_scroller,
            this.Content1,
            this.nothingLb,
        ]
            = this.GetChildrenByNames([

                "allBtn",
                "bg1",
                "_Image1",
                "_Image2",
                "mask_img",
                "round_group",
                "totalBtn",
                "totalImg",
                "totalLb",
                "personBtn",
                "personLb",
                "labelDisplay",
                "_Image3",
                "_Group1",
                "_Image4",
                "_task_scroller",
                "Content",
                "_Image5",
                "_Image6",
                "_Image7",
                "_Image8",
                "_Image9",
                "_Image10",
                "mid_group0",
                "mid_group1",
                "mid_group2",
                "_Group2",
                "oneBtn",
                "oneBtnBg",
                "free_conta",
                "cost_conta",
                "one_txt",
                "one_icon",
                "one_cost",
                "_Group3",
                "tenBtn",
                "tenBtnBg",
                "ten_txt",
                "ten_cost",
                "ten_icon",
                "tenRed",
                "_img_discount",
                "record_scroller",
                "Content1",
                "nothingLb",
            ])
    }
}

window["BabyTreasureView"] = BabyTreasureView