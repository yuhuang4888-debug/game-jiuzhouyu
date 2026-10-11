import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { SetHtmlStyle,GlobalTimerQuest, Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { Enum_UILayer } from "../common/LayerManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Mathf } from "../util/Mathf"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { Alert, Alert_Type } from "../alert/Alert"
import { WordManager } from "../common/WordManager"
import { EnumViewOrder, ViewOrderModel } from "../commonModel/ViewOrderModel"
import { OnHookItem } from "./OnHookItem"
import { OnHookModel } from "../commonModel/OnHookModel"
import { OutLineTipsView } from "../outline/OutLineTipsView"
import { BagModel } from "../commonModel/BagModel"
import { MaterialsTool } from "../common/MaterialsTool"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TaskTipType } from "../commonModel/TaskModel"
import { EventName } from "../common/EventName"
import { ErlangParser } from "../util/ErlangParser"
import { StoryModel } from "../commonModel/StoryModel"
import { ShopEvent, ShopModel, ShopType } from "../commonModel/ShopModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { PlatformManager } from "../PlatformManager"

export class OnHookMainView extends BaseView1 {
    CloseFunc
    InitEvent
    InitView
    SetRedemptionData
    UpdateExpGoodsNum
    UpDateView
    loop_mgr
    Loadsuccess
    ShowAfkReceiveTimesFinger

    //在页面打开的时候 显示倒计时
    local_had_afk_time = 0
    Update
    StopTimer
    StartTimer
    OnTime
    timer
    count_time = 0

    RefreshData
    public constructor() {
        super()
        this.base_file = "onHook"
        this.layout_file = "OnHookMainView"
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.append_to_ctl_queue = true;


        let model = OnHookModel.GetInstance()
        let goods_model = GoodsModel.GetInstance()
        let local_OnHookModel = OnHookModel
        let local_GoodsModel = GoodsModel
        let role_mgr = RoleManager.GetInstance()

        let progress = 0
        let expItem_ = null
        let hasShowTips_ = false
        this.preload_server_config = {
            "config_afk_kv": false
        }

        this.load_callback = () => {
            this.lb_1.style.fontSize = 22
            this.lb_1.style.color = "#663915"
            this.lb_1.style.wordWrap = false
            this._gp_item.vScrollBarSkin = ""

            model.show_view = true
            progress = this._img_pro.width
            this.Loadsuccess()
            this.InitEvent()
            //打开界面时不显示引导
			StoryModel.ShowFingerLock[this.hashCode] = true
        }

        this.destroy_callback = () => {
            hasShowTips_ = false
            this.CloseFunc()
            //打开界面时不显示引导
			delete StoryModel.ShowFingerLock[this.hashCode]
        }

        this.close_callback = () => {
            hasShowTips_ = false
            model.show_view = false
            if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.AfkReceiveTimes)) {
                if (this.story_model.curr_view_story_step > 0) {
                    this.story_model.curr_view_story_step = 0
                    GlobalEventSystem.Fire(EventName.UPDATE_VIEW_STORY_STEP)
                }
            }
        }

        this.Loadsuccess = () => {
            ResManager.GetInstance().SetTexture(this, this._img_title_bg, GameResPath.GetIcon("onHook", "ui_gift_02"))
            ResManager.GetInstance().SetTexture(this, this.icon_1, GameResPath.GetGoodsIconPath("22"))
            ResManager.GetInstance().SetTexture(this, this.icon_2, GameResPath.GetGoodsIconPath("37020001"))
            ResManager.GetInstance().SetTexture(this, this.get_gold_1, GameResPath.GetGoodsIconPath("21"))
            ResManager.GetInstance().SetTexture(this, this.get_exp_1, GameResPath.GetGoodsIconPath("22"))

            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_afk_kv", false)
            let smelt_lv = cfg && cfg[15] && cfg[15].value ? Number(cfg[15].value) : 370
            let lv = role_mgr.GetMainRoleLevel()
            let y = lv > smelt_lv ? 361 : 376
            this._gp_get_btn.y = y
            this.tips.visible = lv > smelt_lv


            GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.AfkReceiveBtn, false)
        }

        this.InitEvent = () => {
            let update = () => {
                this.SetRedemptionData()
                this.RefreshData()
                this.UpDateView(model.ol_award_dic["had_afk_time"], true)
            }
            this.BindEvent(model, OnHookModel.UPDATE_ONHOOK_VIEW, update)

            this.BindEvent(model, OnHookModel.CLOSE_ALL_VIEW, () => {
                this.Close()
            })

            this.BindEvent(model, OnHookModel.CLOSE_ONHOOK_TIPS, () => {
                this.Close()
            })

            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)

            Util.AddClickEvent(this.add_btn_1, () => {
                // for (let key in model.goods_type) {
                let goods_id = goods_model.GetOneGoodsByTypeId(model.cost_goods_type)
                if (goods_id > 0) {
                    let goods_vo = goods_model.GetGoodsVoByGoodsId(goods_id)
                    if (goods_vo) {
                        let outline_time = model.GetOnhookTime()
                        let recommend_num = Math.floor((model.max_outline_time - outline_time) / model.add_time[goods_vo.type_id])
                        if (goods_vo && goods_vo.goods_num) {
                            recommend_num = goods_vo.goods_num > recommend_num && recommend_num || goods_vo.goods_num

                        }
                        let min_num = recommend_num <= 0 && 0 || 1
                        recommend_num = recommend_num <= 0 && 1 || recommend_num
                        BagModel.GetInstance().Fire(BagModel.OPEN_VIEW, "BatchUseView", goods_vo, min_num, recommend_num, goods_vo.goods_num)
                    }
                } else {
                    let shop_data = ShopModel.GetInstance().GetShopDataByType(ShopType.Bind_Diamond) || []
                    let vo_data
                    for (let i = 0; i < shop_data.length; i++) {
                        vo_data = shop_data[i]
                        if (vo_data && vo_data.goods_id == model.cost_goods_type) {
                            break
                        }
                    }
                    if (vo_data) {
                        vo_data["scmd"] = 15302
                        let hook_sec = 20 * 3600 - model.GetOnhookTime()
                        if (hook_sec != 0) {
                            vo_data["cur_num"] = Math.floor(hook_sec / (3600 * 5))
                            vo_data["quick_use"] = 1
                            vo_data["quota_num"] = Math.floor(hook_sec / (3600 * 5))
                            ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "ShopBulkPurchaseView", vo_data)
                        } else {
                            Message.show("离线挂机时长已满")
                        }

                    }
                    // MaterialsTool.GetInstance().materialsTips(model.cost_goods_type)
                }
                // }
            }, this, true)

            Util.AddClickEvent(this.add_btn_2, () => {
                model.Fire(OnHookModel.OPEN_VIEW, "OnHookAdditionView")
            }, this, true)

            Util.AddClickEvent(this._gp_get_btn, () => {
                if (model.GetOnhookTime() >= (2 * 3600) && model.ol_award_dic.back_exp <= 0) {
                    let boo = ViewPopLevelModel.GetInstance().RemoveOneView("OnHookMainView")
                    this.Close()
                    ViewPopLevelModel.GetInstance().SetLockView("CongratulationObtainView")
                }
                model.Fire(OnHookModel.REQUEST_PROTO, 13216)
            }, this, true)

            let Retrieve = (count?) => {
                if (model.ol_award_dic && model.ol_award_dic.back_count > 0) {
                    let needBuyCount = count - goods_model.GetTypeGoodsNum(model.exp_goods_type)
                    if (needBuyCount <= 0) {
                        model.Fire(OnHookModel.REQUEST_PROTO, 13213, "i", count)
                    } else {
                        let priceCfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price[model.exp_goods_type]
                        if (priceCfg) {
                            let view = new OutLineTipsView(Util.StrToHTML("需要消耗" + local_GoodsModel.GetGoodsNameWithColorDark(model.exp_goods_type) + "*" + needBuyCount + "<br>可消耗" + needBuyCount * priceCfg.price + "勾玉或绑定勾玉补齐，优先消耗绑定勾玉。"), Alert_Type.Two, () => {
                                let jin_lock = role_mgr.GetMainRoleVo().jinLock
                                let jin = role_mgr.GetMainRoleVo().jin
                                let cost_count = needBuyCount * priceCfg.price
                                if (jin + jin_lock < cost_count) {
                                    Alert.Show("勾玉数量不足，是否进行充值？", Alert_Type.Two, () => {
                                        OpenFun.OpenFunHandler(21)
                                    })
                                } else {
                                    model.Fire(OnHookModel.REQUEST_PROTO, 13213, "i", count)
                                }
                            }, null, null, null, null, null, null, null, null, null, null, null, model.exp_goods_type)
                            view.Open()
                        }
                    }
                }
            }
            Util.AddClickEvent(this._btn_one, () => {
                Retrieve(1)
            }, this, true)
            Util.AddClickEvent(this.retrieve_btn, () => {
                if (model.ol_award_dic.back_count && model.ol_award_dic.back_count > 0) {
                    Retrieve(model.ol_award_dic.back_count)
                }
            }, this, true)

            this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
                if (type_id == 38070001 || type_id == 38070002) {
                    model.Fire(OnHookModel.REQUEST_PROTO, 13212)
                }
            })

            this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_BAG_LIST, (goods_list) => {
                if (this.use_delete_method) {
                    return
                }
                if (!goods_list) {
                    return
                }
                for (let v of goods_list) {
                    if (37020001 == v.type_id) {
                        model.Fire(OnHookModel.REQUEST_PROTO, 13212)
                        break
                    }
                }
            })

            this.BindEvent(model, OnHookModel.GETGOLDANI, (reward?, type?) => {
                let pos = this.get_gold.localToGlobal(new Laya.Point(80, 20))
                GlobalEventSystem.Fire(EventName.REWARD_FLY, [reward], pos)
            })

            this.BindEvent(model, OnHookModel.UPDATE_REDEMPTION_INFO, () => {
                model.Fire(OnHookModel.REQUEST_PROTO, 13212)
            })

            model.Fire(OnHookModel.REQUEST_PROTO, 13212)
        }

        this.UpDateView = (had_afk_time, is_update_time) => {
    
            this.time.text = TimeUtil.timeConvert(had_afk_time, "hh-mm-ss")
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_afk_kv", false)
            let max_afk_time = cfg[13].value
            this._img_pro.width = Math.min(1, (had_afk_time / (max_afk_time))) * 304
            let hook_sec = model.GetOnhookTime()
            this.residue_time.text = TimeUtil.timeConvert(hook_sec, "dd-hh/hh-mm/mm-ss")
            this.efficiency.text = WordManager.ConvertNum(model.ol_award_dic["exp_effect"], true) + "经验/分"

            this.redImg.visible = hook_sec <= (15 * 3600)

            model.ol_award_dic["exp"] = 0
            model.ol_award_dic["coin"] = 0
            for (let k in model.ol_award_dic.goods_list) {
                var v = model.ol_award_dic.goods_list[k]
                let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(v.type, v.goods_id)
                if (type == 32) {
                    model.ol_award_dic["exp"] = WordManager.ConvertNum(v.num)
                } else if (type == 31) {
                    model.ol_award_dic["coin"] = WordManager.ConvertNum(v.num)
                }
            }
            this.get_exp_number.text = model.ol_award_dic["exp"] != 0 ? String(model.ol_award_dic["exp"]) : "0"
            this.get_gold_number.text = model.ol_award_dic["coin"] != 0 ? String(model.ol_award_dic["coin"]) : "0"
            this._gp_get_btn.gray = model.ol_award_dic["exp"] == 0 && model.ol_award_dic["coin"] == 0
            this._gp_get_btn.mouseEnabled = model.ol_award_dic["exp"] != 0 || model.ol_award_dic["coin"] != 0

            if (is_update_time) {
                this.count_time = 0
                this.local_had_afk_time = TimeUtil.getServerTime()
                this.StopTimer()
                this.StartTimer()
            }

        }

        this.RefreshData=()=>{
            let originalData = model.ol_award_dic["goods_list"]
            let data = []
            let equip_data = []
            let total_data = []
            let i = 0
            if (i < originalData.length) {
                do {
                    if (originalData[i].goods_id == 0) {
                        i = i + 1
                        continue
                    }
                    let [type_id, lock] = goods_model.GetMappingTypeId(originalData[i].type, originalData[i].goods_id)
                    let goodInfo = goods_model.GetGoodsBasicByTypeId(type_id)
                    if (goodInfo && goodInfo.type == 10) {
                        let j = 0
                        if (j < originalData[i].num) {
                            do {
                                table.insert(equip_data, { type: originalData[i].type, goods_id: originalData[i].goods_id, num: 1, color: goodInfo.color })
                                j = j + 1
                            } while ((j < originalData[i].num))
                        }
                    } else if ((originalData[i].type == 5)) {
                        originalData[i].index = 1
                        table.unshift(total_data, originalData[i])
                    } else if (goodInfo && goodInfo.type == 36 && goodInfo.subtype == 2) {
                        originalData[i].index = 2
                        table.insert(total_data, originalData[i])
                    } else if ((originalData[i].type == 3 || originalData[i].type == 2)) {
                        originalData[i].index = 3
                        table.insert(total_data, originalData[i])
                    } else if (goodInfo) {
                        originalData[i].color = goodInfo.color
                        table.insert(data, originalData[i])
                    }
                    i = i + 1
                } while ((i < originalData.length))
            }
            table.sort(total_data, (a, b) => {
                if(a.index!=b.index){
                    return a.index < b.index
                }
                return a.goods_id < b.goods_id
            })
            table.sort(equip_data, (v2?, v1?) => {
                if(v1.color!=v2.color){
                    return v1.color < v2.color
                }
                return v1.goods_id < v2.goods_id
            })
            table.sort(data, (v2?, v1?) => {
                if(v1.color!=v2.color){
                    return v1.color < v2.color
                }
                return v1.goods_id < v2.goods_id
            })
            total_data = total_data.concat(data.concat(equip_data))
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this._gp_item, OnHookItem, total_data, LoopScrCon.Vertical, 1)
            } else {
                this.loop_mgr.replaceAll(total_data)
            }
            this.noLabel.visible = total_data.length == 0
        }

        this.StartTimer = (refresh_time?) => {
            this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
                this.OnTime()
            }, 1, -1)
            // this.OnTime()
        }

        this.OnTime = () => {
            let akt_time = model.ol_award_dic["had_afk_time"]

            //打开界面的时间
            let open_time = TimeUtil.getServerTime() - this.local_had_afk_time

            let now_time = akt_time + open_time
            this.UpDateView(now_time, false)

            if(now_time>=(25*3600)){
                this.StopTimer()
                return
            }

            //定时请求下协议
            this.count_time++
            if (this.count_time >= 10) {
                this.count_time = 0
                model.Fire(OnHookModel.REQUEST_PROTO, 13212)
            }
        }


        this.StopTimer = () => {
            if (this.timer) {
                GlobalTimerQuest.CancelQuest(this.timer)
                this.timer = null
            }
        }


        this.UpdateExpGoodsNum = () => {
            if (model.ol_award_dic) {
                let goodsNum = goods_model.GetTypeGoodsNum(model.exp_goods_type)
                if (model.ol_award_dic.back_count > 0) {
                    if (goodsNum >= model.ol_award_dic.back_count) {
                        this.number.color = "#0A953E"
                    } else {
                        this.number.color = "#fe1a1a"
                    }
                    this.number.text = goodsNum + "/" + model.ol_award_dic.back_count
                } else {
                    this.number.text = ""
                }
            }
        }

        this.SetRedemptionData = () => {

            if (model.ol_award_dic && (model.ol_award_dic.back_count > 0 || model.ol_award_dic.back_count == 0 && hasShowTips_)) {
                ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("onHook", "ui_gj_03"))
                this.display_obj.height = 866
                this._gp_down.y = 404
                this.gp_middle.visible = true
                this.lb_1.innerHTML = Util.StrToHTML("当前有<font color='#0a953e'>" + model.ol_award_dic.back_count + "</font>小时挂机额外经验可进行找回")
                let exp1 = "已全部找回"
   if(PlatformManager.IsEyouPlatform()){
                    this.lb_1.style.width = 430
                }
                this._btn_one.visible = model.ol_award_dic.back_exp > 0
                this.retrieve_btn.visible = model.ol_award_dic.back_exp > 0
                if (model.ol_award_dic.back_exp > 0) {
                    exp1 = model.ol_award_dic.back_exp
                }
                this.exp.text = exp1
                // let outline = model.GetOutlineFindData()
                // let exp = 0
                // if (outline && outline.get_exp) {
                //     exp = outline.get_exp
                // }
                // this.exp.text =  exp.toString()
                // if (!expItem_) {
                //     expItem_ = new BaseAwardItem(this._gp_cost)
                //     expItem_.Load()
                //     expItem_.SetItemSize(80, 80)
                //     expItem_.SetData(model.exp_goods_type)
                // }
                this.UpdateExpGoodsNum()
                hasShowTips_ = true
                if (model.ol_award_dic.back_count == 0) {
                }

            } else if (!hasShowTips_) {
                ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("onHook", "ui_gj_02"))
                this.gp_middle.visible = false
                this._gp_down.y = 270
                this.display_obj.height = 726

            }
        }

        this.CloseFunc = () => {

            this.StopTimer()

            if (model.ol_award_dic["had_afk_time"] >= (5 * 60)) {
                ViewPopLevelModel.GetInstance().SetLockView("CongratulationObtainView")
                model.Fire(OnHookModel.REQUEST_PROTO, 13216)
            }

            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }

        }

        //引导
        this.ShowAfkReceiveTimesFinger = () => {
            // let task_vo
            // if(!task_vo){
            //     task_vo = this.task_model.GetMainLineTaskVo()
            // }
            // if (task_vo && this.task_model.IsCurrMainLineTaskTipType(TaskTipType.AfkReceiveTimes) && !this.task_model.IsCurrMainTaskHasFinish()) {
            // 	this.story_model.curr_view_story_step = 1

            // }
        }

        //第一次添加到舞台的时候调用
        this.createChildren = () => {
            if (this["GetComponents"]) {
                this["GetComponents"]()
                this.is_get = true
            }
            this.story_obj_list = this.story_obj_list || {}
            this.story_obj_list[TaskTipType.AfkReceiveTimes] = [this._gp_get_btn, this._img_close]
            super.createChildren()
        }
    }


    bg: Laya.Image
    _img_title_bg: Laya.Image
    _img_title: Laya.Image
    _img_close: Laya.Image
    _img_pro_bg: Laya.Image
    _img_pro: Laya.Image
    time: Laya.Label
    residue_time: Laya.Label
    efficiency: Laya.Label
    add_btn_1: Laya.Image
    redImg: Laya.Image
    add_btn_2: Laya.Image
    gp_middle: Laya.Box
    lb_1: Laya.HTMLDivElement
    _gp_hbox_1: Laya.HBox
    icon_1: Laya.Image
    exp: Laya.Label
    _gp_hbox_2: Laya.HBox
    icon_2: Laya.Image
    number: Laya.Label
    retrieve_btn: Laya.Box
    _btn_one: Laya.Box
    _img_one: Laya.Image
    _lb_one: Laya.Label
    _gp_down: Laya.Box
    get_gold: Laya.Box
    get_gold_1: Laya.Image
    get_gold_number: Laya.Label
    get_exp: Laya.Box
    get_exp_1: Laya.Image
    get_exp_number: Laya.Label
    noLabel: Laya.Label
    _gp_get_btn: Laya.Box
    _gp_get_btn_bg: Laya.Image
    _gp_item: Laya.List
    tips: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this._img_title_bg,
            this._img_title,
            this._img_close,
            this._img_pro_bg,
            this._img_pro,
            this.time,
            this.residue_time,
            this.efficiency,
            this.add_btn_1,
            this.redImg,
            this.add_btn_2,
            this.gp_middle,
            this.lb_1,
            this._gp_hbox_1,
            this.icon_1,
            this.exp,
            this._gp_hbox_2,
            this.icon_2,
            this.number,
            this.retrieve_btn,
            this._btn_one,
            this._img_one,
            this._lb_one,
            this._gp_down,
            this.get_gold,
            this.get_gold_1,
            this.get_gold_number,
            this.get_exp,
            this.get_exp_1,
            this.get_exp_number,
            this.noLabel,
            this._gp_get_btn,
            this._gp_get_btn_bg,
            this._gp_item,
            this.tips,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_img_title_bg",
                "_img_title",
                "_img_close",
                "_img_pro_bg",
                "_img_pro",
                "time",
                "residue_time",
                "efficiency",
                "add_btn_1",
                "redImg",
                "add_btn_2",
                "gp_middle",
                "lb_1",
                "_gp_hbox_1",
                "icon_1",
                "exp",
                "_gp_hbox_2",
                "icon_2",
                "number",
                "retrieve_btn",
                "_btn_one",
                "_img_one",
                "_lb_one",
                "_gp_down",
                "get_gold",
                "get_gold_1",
                "get_gold_number",
                "get_exp",
                "get_exp_1",
                "get_exp_number",
                "noLabel",
                "_gp_get_btn",
                "_gp_get_btn_bg",
                "_gp_item",
                "tips",
            ])
    }
}
window["OnHookMainView"] = OnHookMainView