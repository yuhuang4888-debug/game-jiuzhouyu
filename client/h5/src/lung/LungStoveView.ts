import { Alert, Alert_Type } from "../alert/Alert";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { OpenFun } from "../common/OpenFun";
import { ModuleType, RedDotManager } from "../common/RedDotManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { LungDotSubType, LungEvent, LungModel } from "../commonModel/LungModel";
import { ShopModel } from "../commonModel/ShopModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { TimeUtil } from "../util/TimeUtil";
import { AtlasUrl, GlobalTimerQuest, Util } from "../util/Util";
import { LungStoveStageItem } from "./LungStoveStageItem";

export class LungStoveView extends BaseView1 {

    private cost_list
    private reward_list

    LoadSuccess
    InitEvent
    PlaySuccessEffect
    SetCheckBtn
    SetData
    SetReward
    SetTargetReward
    SetStageReward
    SetCost
    StartTimer
    OnTime
    CancelTimer
    SetBtnStateAndFreeTimes
    StartFreeTimer
    OnFreeTime
    CancelFreeTimer
    ShowFreeTimesDot
    StartAnimTimer
    OnAnimTime
    CanceAnimlTimer
    BtnFun
    public constructor() {
        super();
        this.base_file = "lung";
        this.layout_file = "LungStoveView";
        this.layer_value = Enum_UILayer.Activity;
        this.destroy_imm = true;
        this.is_center = true
        this.use_background = true;
        this.click_bg_toClose = true;
        this.show_open_movie = true;
        let model = LungModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_LungEvent = LungEvent,
            local_Util = Util,
            LUNG_DOT = ModuleType.LUNG_DOT,
            local_LungDotSubType = LungDotSubType,
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            goods_model = GoodsModel.GetInstance(),
            local_Number = Number,
            // local_egret = egret,
            local_TimeUtil = TimeUtil,
            item_list_,
            count_time_id_: Laya.Timer,
            count_free_time_id_: Laya.Timer,
            reward_item_list_,
            reward_item_list1_,
            progress_width_,
            target_item_: EquipmentItem,
            skip_animation_ = false,
            one_cost_enough_ = true,
            ten_cost_enough_ = true,
            is_left_playAnime_ = true,  //是否播放左边奖励循环动画
            is_right_playAnime_ = true,  //是否播放左边奖励循环动画
            count_anim_time_id_,
            one_cost_item_: BaseAwardItem,
            ten_cost_item_: BaseAwardItem,
            one_cost_list_,
            ten_cost_list_

        this.load_callback = function () {
            this.LoadSuccess();
            this.InitEvent();
        }
        this.open_callback = function () {
            this.SetData();
        }

        this.destroy_callback = function () {
            this.CancelTimer()
            this.CancelFreeTimer()
            if (reward_item_list_) {
                for (let obj of reward_item_list_) {
                    obj.DeleteMe()
                }
                reward_item_list_ = null
            }
            if (reward_item_list1_) {
                for (let obj of reward_item_list1_) {
                    obj.DeleteMe()
                }
                reward_item_list1_ = null
            }
            if (item_list_) {
                for (let obj of item_list_) {
                    obj.DeleteMe()
                }
                item_list_ = null
            }
            if (target_item_) {
                target_item_.DeleteMe()
                target_item_ = null
            }
            if (one_cost_item_) {
                one_cost_item_.DeleteMe()
                one_cost_item_ = null
            }
            if (ten_cost_item_) {
                ten_cost_item_.DeleteMe()
                ten_cost_item_ = null
            }
            skip_animation_ = false
            one_cost_enough_ = true
            ten_cost_enough_ = true
            this.is_playAnime = true
            this.CanceAnimlTimer()
            this.ClearUIEffect(this.effect1)
            this.ClearUIEffect(this.left_effect2)
            this.ClearUIEffect(this.right_effect2)
            this.ClearUIEffect(this.dungon_left_fire_effect)
            this.ClearUIEffect(this.dungon_right_fire_effect)
            this.ClearUIEffect(this.left_effect)
            this.ClearUIEffect(this.right_effect)
            this.ClearUIEffect(this.title_effect)
            this.ClearUIEffect(this.left_btn_effect)
            this.ClearUIEffect(this.right_btn_effect)
            this.ClearUIEffect(this.bottom_effect2)
            this.ClearUIEffect(this.bottom_effect3)
        }

        this.preload_server_config = {
            "config_dragon_crucible": false
        }

        this.LoadSuccess = () => {
            res_mgr.SetImageSpriteTrans(this, this.title_img,"lung","uilwrl_002")
            res_mgr.SetTexture(this, this.bg_left_img, `resource/game/lung/texture/uilwrl_001.png`, undefined, this, true)
            res_mgr.SetTexture(this, this.bg_right_img, `resource/game/lung/texture/uilwrl_001.png`, undefined, this, true)
            progress_width_ = 484
            res_mgr.SetImageSprite(this, this._img_discount,"common2","sh_discount_9")
            //res_mgr.SetTexture(this, this._img_discount, `resource/game/common2/texture/sh_discount_9.png`)
            model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
            // this.AddUIEffect("output_07", this.effect1, null, null, true)
            // this.AddUIEffect("output_03", this.left_effect2, null, null, true)
            // this.AddUIEffect("output_03", this.right_effect2, null, null, true)
            // this.AddUIEffect("output_02", this.dungon_left_fire_effect, null, null, true)
            // this.AddUIEffect("output_02", this.dungon_right_fire_effect, null, null, true)
            // this.AddUIEffect("output_06", this.left_effect, null, null, true)
            // this.AddUIEffect("output_06", this.right_effect, null, null, true)
            // this.AddUIEffect("output_01", this.title_effect, null, null, true)
            // this.AddUIEffect("output_05", this.right_btn_effect, null, null, true)
            // this.AddUIEffect("output_08", this.bottom_effect2, null, null, true)
            // this.AddUIEffect("output_09", this.bottom_effect3, null, null, true)
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }
            local_Util.AddClickEvent(this.closeBtn, close_fun, this, true)

            let freeBtn_fun = () => {
                model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18106, "cc", 1, 0)
            }
            local_Util.AddClickEvent(this.freeBtn, freeBtn_fun, this, true)

            let one_fun = () => {
                this.BtnFun(1)
            }
            local_Util.AddClickEvent(this.oneBtn, one_fun, this, true)

            let ten_fun = () => {
                this.BtnFun(10)
            }
            local_Util.AddClickEvent(this.tenBtn, ten_fun, this, true)

            let update_fun = () => {
                this.SetData()
            }
            this.BindVar(model, "stove_data", update_fun)

            local_Util.AddClickEvent(this.checkBtn, () => {
                this.SetCheckBtn(!skip_animation_)
            }, this)

            let success_fun = (goods_list) => {
                this.PlaySuccessEffect(goods_list)
            }
            this.BindEvent(model, local_LungEvent.LUNG_STOVE_SUCCESS, success_fun)

            let dot_fun = (mType, rType) => {
                if (mType == LUNG_DOT) {
                    if (rType == local_LungDotSubType.StoveFreeTimes) {
                        this.ShowFreeTimesDot()
                    }
                }
            }
            this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_REDDOT, dot_fun)

            let close_tips_view = () => {
                is_left_playAnime_ = true
                is_right_playAnime_ = true
            }
            this.BindEvent(local_GlobalEventSystem, local_EventName.CLOSE_TIPS_VIEW, close_tips_view)

            let open_tips_view = () => {
                is_left_playAnime_ = false
                is_right_playAnime_ = false
            }
            this.BindEvent(local_GlobalEventSystem, local_EventName.OPEN_TIPS_VIEW, open_tips_view)
        }

        this.PlaySuccessEffect = (goods_list) => {
            let show_reward = () => {
                if (goods_list) {
                    let list = []
                    for (let vo of goods_list) {
                        let obj = []
                        obj[0] = vo.style
                        obj[1] = vo.typeId
                        obj[2] = vo.count
                        list.push(obj)
                    }
                    let view = new CongratulationObtainView(list, 10)
                    view.Open()
                }
            }
            if (skip_animation_) {
                show_reward()
            } else {
                show_reward()
                //暂时注释
                // this.AddUIEffect("ui_smelter_glow", this.success_effect, null, null, false, undefined, show_reward)
            }
        }

        this.SetCheckBtn = (bool) => {
            skip_animation_ = bool
            if (bool) {
                this.check_img.skin = AtlasUrl("common", "com_ui_gx1")
            } else {
                this.check_img.skin = AtlasUrl("common", "com_ui_gx")
            }
        }


        this.SetData = () => {
            if (!model.stove_data) {
                return
            }
            this.SetCheckBtn(skip_animation_)
            this.SetReward()
            this.StartTimer()
            this.SetBtnStateAndFreeTimes()
        }

        this.SetReward = () => {

            if (!model.stove_data) {
                return
            }
            let dragon_crucible_cfg = res_mgr.GetGameConfigFromCache(this, "config_dragon_crucible", false)
            let cfg = model.GetStoveCfg(model.stove_data.crucible_id, dragon_crucible_cfg)
            if (cfg) {
                let reward_list = JSON.parse(cfg.show_list)
                if (reward_list) {
                    if (!reward_item_list_) {
                        reward_item_list_ = []
                    }
                    let item: EquipmentItem
                    for (let i = 0, length = reward_list.length; i < length; i++) {
                        item = reward_item_list_[i]
                        if (!item) {
                            item = new EquipmentItem(this.reward_scroll)
                            item.Load()
                            item.SetItemSize(80, 80)
                            reward_item_list_[i] = item
                        }
                        item.SetPosition(0, (80 + 6) * i)
                        let [type_id, lock] = goods_model.GetMappingTypeId(reward_list[i][0], reward_list[i][1])
                        item.SetVisible(true)
                        item.SetData(type_id, reward_list[i][2])
                    }
                    if (reward_item_list_.length > reward_list.length) {
                        for (let i = reward_list.length, length = reward_item_list_.length; i < length; i++) {
                            reward_item_list_[i].SetVisible(false)
                        }
                    }
                    if (!reward_item_list1_) {
                        reward_item_list1_ = []
                    }
                    let item1: EquipmentItem
                    for (let i = 0, length = reward_list.length; i < length; i++) {
                        item1 = reward_item_list1_[i]
                        if (!item1) {
                            item1 = new EquipmentItem(this.reward_scroll0)
                            item1.Load()
                            item1.SetItemSize(80, 80)
                            reward_item_list1_[i] = item1
                        }
                        item1.SetPosition(0, this.reward_scroll.height - (80 + 6) * (i + 1))
                        let [type_id, lock] = goods_model.GetMappingTypeId(reward_list[i][0], reward_list[i][1])
                        item1.SetVisible(true)
                        item1.SetData(type_id, reward_list[i][2])
                    }
                    if (reward_item_list1_.length > reward_list.length) {
                        for (let i = reward_list.length, length = reward_item_list1_.length; i < length; i++) {
                            reward_item_list1_[i].SetVisible(false)
                        }
                    }
                    this.StartAnimTimer()

                    this.SetTargetReward(cfg.show)

                    let stage_reward = JSON.parse(cfg.count_award)
                    this.SetStageReward(stage_reward)

                    let cost_list = JSON.parse(cfg.cost_list)
                    this.SetCost(cost_list)
                }
            }
        }

        this.SetTargetReward = (type_id) => {
            if (!target_item_) {
                target_item_ = new EquipmentItem(this.target_con)
                target_item_.Load()
                target_item_.SetItemSize(105, 105)
            }
            target_item_.SetData(type_id, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, 1)
           // res_mgr.SetTexture(this, this.target_name_img, `resource/game/lung/texture/${type_id}.png`)
            res_mgr.SetImageSprite(this, this.target_name_img,"lung",`${type_id}`)
        }

        //设置阶段奖励
        this.SetStageReward = (stage_reward) => {
            if (!stage_reward) {
                return
            }
            if (!item_list_) {
                item_list_ = []
            }
            let vo
            let cfg
            let max = 0
            let con
            let item: LungStoveStageItem
            let goods_list
            let basic
            let now = model.stove_data.count
            for (let i = 0, length = stage_reward.length; i < length; i++) {
                vo = stage_reward[i]
                con = this[`${"stage_con" + i}`]
                if (con) {
                    item = item_list_[i]
                    if (!item) {
                        item = new LungStoveStageItem(con)
                        item.Load()
                        item_list_[i] = item
                    }
                    item.SetData(vo)
                    max = local_Number(vo[0])
                }
            }
            let item_width = 85
            let w = 60
            let width
            if (now >= 60 && now < 120)
                width = 3 * item_width + 2 * w + w / 60 * (now - 60)
            else if (now >= 40 && now < 60)
                width = 2 * item_width + w + w / 20 * (now - 40)
            else if (now >= 0 && now <= 10)
                width = 0
            else if (now >= 10 && now < 40)
                width = item_width + w / 30 * (now - 10)
            if (now >= max)
                width = progress_width_
            this.progress_front.width = width
            this.stove_times.text = String(now)
        }

        //设置消耗
        this.SetCost = (cost_list) => {
            if (cost_list[0] && cost_list[0][1] && cost_list[0][1][0]) {
                one_cost_list_ = cost_list[0][1][0]
                let one = local_Number(one_cost_list_[2])
                let my_have = goods_model.GetTypeGoodsNum(local_Number(one_cost_list_[1]))
                let enough = my_have > one
                let color_str = enough ? "'#0a953e'" : "'#ff4f50'"
                // this.one_cost.textColor = color_str
                this.one_cost.style.fontSize = 24
                this.one_cost.style.color = "#ffffff"
                this.one_cost.width = 120
                this.one_cost.innerHTML = local_Util.StrToHTML(`<font color=${color_str}>${my_have}</font>/${one}`)
                one_cost_enough_ = enough
                if (!one_cost_item_) {
                    one_cost_item_ = new BaseAwardItem(this.one_cost_con)
                    one_cost_item_.Load()
                    one_cost_item_.SetItemSize(40, 40)
                    one_cost_item_.SetItembgVisible(false)
                }
                one_cost_item_.SetData(local_Number(one_cost_list_[1]))
            }

            if (cost_list[1] && cost_list[1][1] && cost_list[1][1][0]) {
                ten_cost_list_ = cost_list[1][1][0]
                let ten = local_Number(ten_cost_list_[2])
                let my_have = goods_model.GetTypeGoodsNum(local_Number(ten_cost_list_[1]))
                let enough = my_have > ten
                let color_str = enough ? "'#0a953e'" : "'#ff4f50'"
                // this.ten_cost.textColor = color_str
                this.ten_cost.style.fontSize = 24
                this.ten_cost.style.color = "#ffffff"
                this.ten_cost.width = 120
                this.ten_cost.innerHTML = local_Util.StrToHTML(`<font color=${color_str}>${my_have}</font>/${ten}`)
                ten_cost_enough_ = enough
                if (!ten_cost_item_) {
                    ten_cost_item_ = new BaseAwardItem(this.ten_cost_con)
                    ten_cost_item_.Load()
                    ten_cost_item_.SetItemSize(40, 40)
                    ten_cost_item_.SetItembgVisible(false)
                }
                ten_cost_item_.SetData(local_Number(ten_cost_list_[1]))
            }
        }

        this.StartTimer = () => {
            this.CancelTimer()
            count_time_id_ = GlobalTimerQuest.AddPeriodQuest(this.OnTime, 1)
			this.OnTime()
            
            // count_time_id_ = new local_egret.Timer(1000, 0)
            // count_time_id_.addEventListener(local_egret.TimerEvent.TIMER, this.OnTime, this)
            // count_time_id_.start()
            // this.OnTime()
        }

        this.OnTime = () => {
            if (model.stove_data && model.stove_data.end_time) {
                let left_time = model.stove_data.end_time - local_TimeUtil.getServerTime()
                if (left_time < 0) {
                    this.CancelTimer()
                    // this.left_time.text = local_Util.StrToHTML("<font color=0xffffff>剩余时间：</font>00:00:00")
                    this.left_time.text = local_Util.StrToHTML("剩余时间：00:00:00")

                    return
                }
                let time_str = local_TimeUtil.convertTime(left_time)
                // let str = "<font color=0xffffff>剩余时间：</font>" + String(time_str)
                let str = "剩余时间：" + String(time_str)
                this.left_time.text = local_Util.StrToHTML(str)
            } else {
                this.CancelTimer()
            }
        }

        this.CancelTimer = () => {
            if (count_time_id_) {
				GlobalTimerQuest.CancelQuest(count_time_id_)
				count_time_id_ = null
			}
            // if (count_time_id_) {
            //     count_time_id_.stop()
            //     count_time_id_.removeEventListener(local_egret.TimerEvent.TIMER, this.OnTime, this)
            //     count_time_id_ = undefined
            // }
        }

        //设置按钮状态
        this.SetBtnStateAndFreeTimes = () => {
            if (model.stove_data) {
                this.free_con.visible = model.stove_data.free_times > 0
                this.one_con.visible = !(model.stove_data.free_times > 0)
                if (model.stove_data.free_times > 0)
                    this.AddUIEffect("output_04", this.left_btn_effect, null, null, true)
                else
                    this.ClearUIEffect(this.left_btn_effect)
                let gap = model.stove_data.next_free_time - local_TimeUtil.getServerTime()
                this.next_free_gp.visible = gap > 0
                if (gap > 0) {
                    this.StartFreeTimer()
                }
                this.ShowFreeTimesDot()
            }
        }

        this.StartFreeTimer = () => {
            this.CancelFreeTimer()
            count_free_time_id_ = GlobalTimerQuest.AddPeriodQuest(this.OnFreeTime, 1)
            this.OnFreeTime()
            // count_free_time_id_ = new local_egret.Timer(1000, 0)
            // count_free_time_id_.addEventListener(local_egret.TimerEvent.TIMER, this.OnFreeTime, this)
            // count_free_time_id_.start()
            // this.OnFreeTime()
        }

        this.OnFreeTime = () => {
            if (model.stove_data && model.stove_data.next_free_time) {
                let left_time = model.stove_data.next_free_time - local_TimeUtil.getServerTime()
                if (left_time < 0) {
                    this.CancelFreeTimer()
                    this.next_free_time.text = ""
                    // model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18105)
                    return
                }
                let time_str = local_TimeUtil.convertTime(left_time)
                this.next_free_time.text = local_Util.StrToHTML(`下次免费${time_str}`)
            } else {
                this.CancelFreeTimer()
            }
        }

        this.CancelFreeTimer = () => {
            if (count_free_time_id_) {
				GlobalTimerQuest.CancelQuest(count_free_time_id_)
				count_free_time_id_ = null
			}

            // if (count_free_time_id_) {
            //     count_free_time_id_.stop()
            //     count_free_time_id_.removeEventListener(local_egret.TimerEvent.TIMER, this.OnFreeTime, this)
            //     count_free_time_id_ = undefined
            // }
        }

        this.ShowFreeTimesDot = () => {
            let show = RedDotManager.GetInstance().CheckRedStatus(LUNG_DOT, local_LungDotSubType.StoveFreeTimes)
            this.free_dot.visible = show
        }


        this.StartAnimTimer = () => {
            this.CanceAnimlTimer()
            count_anim_time_id_ = GlobalTimerQuest.AddPeriodQuest(this.OnAnimTime, 0.05)
            this.OnAnimTime()
            // count_anim_time_id_ = new local_egret.Timer(50, 0)
            // count_anim_time_id_.addEventListener(local_egret.TimerEvent.TIMER, this.OnAnimTime, this)
            // count_anim_time_id_.start()
            // this.OnAnimTime()
        }

        this.OnAnimTime = () => {
            // if (is_left_playAnime_ || is_right_playAnime_) {
            for (let index in reward_item_list_) {
                let item = reward_item_list_[index]
                let item1 = reward_item_list1_[index]
                if (item.display_obj){
                    if (is_left_playAnime_)
                    item.display_obj.y -= 1
                    if (item.display_obj.y < - 80) {
                        let i = local_Number(index) - 1 >= 0 ? local_Number(index) - 1 : reward_item_list_.length - 1
                        item.display_obj.y = this.reward_scroll.getChildAt(i)["display_obj"].y + 80 + 6
                    }
                }
                if (item1.display_obj){
                    if (is_right_playAnime_)
                    item1.display_obj.y += 1
                    if (item1.y > this.reward_scroll0.height + 80) {
                        let i = local_Number(index) - 1 >= 0 ? local_Number(index) - 1 : reward_item_list_.length - 1
                        item1.display_obj.y = this.reward_scroll0.getChildAt(i)["display_obj"].y - 80 - 6
                    }
                }
                
                
                
                
            }
            // }
        }

        this.CanceAnimlTimer = () => {
            if (count_anim_time_id_) {
				GlobalTimerQuest.CancelQuest(count_anim_time_id_)
				count_anim_time_id_ = null
			}
            // if (count_anim_time_id_) {
            //     count_anim_time_id_.stop()
            //     count_anim_time_id_.removeEventListener(local_egret.TimerEvent.TIMER, this.OnAnimTime, this)
            //     count_anim_time_id_ = undefined
            // }
        }

        this.BtnFun = (times) => {
            let call_fun = (auto_buy) => {
                model.Fire(local_LungEvent.LUNG_REQUEST_PROTO, 18106, "cc", times, auto_buy)
            }
            let ok_fun = () => {
                call_fun(1)
            }
            let check_func = (bool) => {
                model.lung_daimond_cost_alert = !bool
            }
            let cost_enough = one_cost_enough_
            let cost_list = one_cost_list_
            if (times == 10) {
                cost_enough = ten_cost_enough_
                cost_list = ten_cost_list_
            }
            if (cost_enough) {
                call_fun(0)
            } else if (cost_list) {
                let my_have = goods_model.GetTypeGoodsNum(local_Number(cost_list[1]))
                let basic = goods_model.GetGoodsBasicByTypeId(local_Number(cost_list[1]))
                let need = local_Number(cost_list[2])
                let ticket_gap = need - my_have
                let price_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[local_Number(cost_list[1])]
                let goods_price = ticket_gap * price_info.price
                if (price_info) {
                    let [enough, gap, my_money, alert_str] = ShopModel.GetInstance().MoneyIsEnough(price_info.price_type, goods_price)
                    if (enough) {
                        if (model.lung_daimond_cost_alert) {
                            let str = `是否消耗<font color=0x0a953e>${goods_price}勾玉</font>购买<font color=0x0a953e>${ticket_gap}</font>个<font color=0x0a953e>${basic.goods_name}</font>`
                            let content = local_Util.StrToHTML(str)
                            Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_fun, undefined, "确定", "取消", undefined, false, check_func, "本次登录不再提示")
                        } else {
                            ok_fun()
                        }
                    } else {
                        let charge_fun = () => {
                            OpenFun.OpenFunHandler(21)
                        }
                        let str = `您的勾玉不足${goods_price}，是否前往充值`
                        Alert.Show(str, Alert_Type.One, charge_fun, undefined, "确定")
                    }
                }
            }
        }
    }


    public Open(...parms) {
        super.Open()
    }
    

    title_img: Laya.Image
    bottom_effect2: Laya.Box
    bottom_effect3: Laya.Box
    closeBtn: Laya.Image
    bg_left_img: Laya.Image
    bg_right_img: Laya.Image
    effect1: Laya.Box
    left_effect2: Laya.Box
    right_effect2: Laya.Box
    dungon_left_fire_effect: Laya.Box
    dungon_right_fire_effect: Laya.Box
    left_effect: Laya.Box
    right_effect: Laya.Box
    title_effect: Laya.Box
    target_con: Laya.Box
    target_name_img: Laya.Image
    checkBtn: Laya.Box
    check_img: Laya.Image
    _Image1: Laya.Image
    check_label: Laya.Label
    _Group3: Laya.Box
    _Group1: Laya.Box
    progress_bg: Laya.Image
    progress_front: Laya.Image
    _Group2: Laya.HBox
    stage_con0: Laya.Box
    stage_con1: Laya.Box
    stage_con2: Laya.Box
    stage_con3: Laya.Box
    _Group4: Laya.Box
    left_btn_effect: Laya.Box
    one_con: Laya.Box
    oneBtn: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    one_cost_con: Laya.Box
    one_cost: Laya.HTMLDivElement
    free_con: Laya.Box
    freeBtn: Laya.Box
    Image: Laya.Image
    _Label2: Laya.Label
    free_dot: Laya.Image
    ten_con: Laya.Box
    tenBtn: Laya.Box
    Image1: Laya.Image
    right_btn_effect: Laya.Box
    _Label3: Laya.Label
    _img_discount: Laya.Image
    ten_cost_con: Laya.Box
    ten_cost: Laya.HTMLDivElement
    success_effect: Laya.Box
    _Image3: Laya.Image
    stove_times: Laya.Label
    next_free_gp: Laya.Box
    _Image4: Laya.Image
    next_free_time: Laya.Label
    _Group5: Laya.Box
    _Image5: Laya.Image
    left_time: Laya.Label
    _Scroller1: Laya.Panel
    reward_scroll: Laya.Box
    right_scroller: Laya.Panel
    reward_scroll0: Laya.Box
    public GetComponents() {
        [
            this.title_img,
            this.bottom_effect2,
            this.bottom_effect3,
            this.closeBtn,
            this.bg_left_img,
            this.bg_right_img,
            this.effect1,
            this.left_effect2,
            this.right_effect2,
            this.dungon_left_fire_effect,
            this.dungon_right_fire_effect,
            this.left_effect,
            this.right_effect,
            this.title_effect,
            this.target_con,
            this.target_name_img,
            this.checkBtn,
            this.check_img,
            this._Image1,
            this.check_label,
            this._Group3,
            this._Group1,
            this.progress_bg,
            this.progress_front,
            this._Group2,
            this.stage_con0,
            this.stage_con1,
            this.stage_con2,
            this.stage_con3,
            this._Group4,
            this.left_btn_effect,
            this.one_con,
            this.oneBtn,
            this._Image2,
            this._Label1,
            this.one_cost_con,
            this.one_cost,
            this.free_con,
            this.freeBtn,
            this.Image,
            this._Label2,
            this.free_dot,
            this.ten_con,
            this.tenBtn,
            this.Image1,
            this.right_btn_effect,
            this._Label3,
            this._img_discount,
            this.ten_cost_con,
            this.ten_cost,
            this.success_effect,
            this._Image3,
            this.stove_times,
            this.next_free_gp,
            this._Image4,
            this.next_free_time,
            this._Group5,
            this._Image5,
            this.left_time,
            this._Scroller1,
            this.reward_scroll,
            this.right_scroller,
            this.reward_scroll0,
        ]
            = this.GetChildrenByNames([

                "title_img",
                "bottom_effect2",
                "bottom_effect3",
                "closeBtn",
                "bg_left_img",
                "bg_right_img",
                "effect1",
                "left_effect2",
                "right_effect2",
                "dungon_left_fire_effect",
                "dungon_right_fire_effect",
                "left_effect",
                "right_effect",
                "title_effect",
                "target_con",
                "target_name_img",
                "checkBtn",
                "check_img",
                "_Image1",
                "check_label",
                "_Group3",
                "_Group1",
                "progress_bg",
                "progress_front",
                "_Group2",
                "stage_con0",
                "stage_con1",
                "stage_con2",
                "stage_con3",
                "_Group4",
                "left_btn_effect",
                "one_con",
                "oneBtn",
                "_Image2",
                "_Label1",
                "one_cost_con",
                "one_cost",
                "free_con",
                "freeBtn",
                "Image",
                "_Label2",
                "free_dot",
                "ten_con",
                "tenBtn",
                "Image1",
                "right_btn_effect",
                "_Label3",
                "_img_discount",
                "ten_cost_con",
                "ten_cost",
                "success_effect",
                "_Image3",
                "stove_times",
                "next_free_gp",
                "_Image4",
                "next_free_time",
                "_Group5",
                "_Image5",
                "left_time",
                "_Scroller1",
                "reward_scroll",
                "right_scroller",
                "reward_scroll0",
            ])
    }
}


window["LungStoveView"] = LungStoveView