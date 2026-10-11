import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { ResManager } from "../common/ResManager"
import { ErlangParser } from "../util/ErlangParser"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { enum_OutWardType, OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { CycleimpActlistItem } from "./CycleimpActlistItem"
import { TimeUtil } from "../util/TimeUtil"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RoleModel } from "../commonModel/RoleModel"
import { ColorUtil, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { CommonManager } from "../common/CommonManager"
import { Message } from "../sysInfo/SysInfoController"



export class CycleimpActlistView extends BaseItem1 {
    InitEvent
    InitView
    LoadSuccess
    Local_DeleteMe
    SetReward
    UpdateItems
    _Viewport1
    _act_info
    _model: CycleimpActlistModel
    _reward_data
    createChildren
    needRefresh
    parent_mask_corner
    story_obj_list
    time_title_color
    rank_list_item
    stage_reward_item
    SetBtn
    UpdateShowInfo
    CustomMehod
    is_show_now_cycle
    update_timer_id
    time_info
    ShowRewardMessage

    public constructor(parent?) {
        super(parent)

        this._act_info = null
        this._model = CycleimpActlistModel.GetInstance()
        let res_manager = ResManager.GetInstance()
        let local_global = GlobalEventSystem
        let local_ename = EventName
        this.base_file = "cycleimpActlist"
        this.layout_file = "CycleimpActlistView"
        this.layer_value = Enum_UILayer.UI
        let local_Event = CycleimpActlistEvent
        this.rank_list_item = null
        let type = this._model.type
        let subtype = this._model.subtype
        this._reward_data = null
        this.stage_reward_item = []
        this.preload_server_config = {
            "config_cycle_rank_reach_reward": false,
            "config_cycle_rank_reward": false
        }

        this.load_callback = () => {
            SetHtmlStyle(this.lb_desc, { c: "#ffffff", f: 20, ww: false, w: 600 })

            let color = Enum_ColorUtil_Light.GREEN
            this.lb_desc.innerHTML = `活动说明：活动期间内每消耗${HtmlColorTxt("一个经验石", color)}道具增加${HtmlColorTxt("10分", color)}。每晚${HtmlColorTxt("22时", color)}结算。`
            this._model.is_first_login = false
            CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.UPDATE_TAB_RED, "331_cycle", this._model.CheckActData())
            this._model.Fire(CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIT_RED)
            this.LoadSuccess()
            this.SetReward()
            this.UpdateShowInfo()
        }


        this.Local_DeleteMe = () => {
            if (this.rank_list_item) {
                this.rank_list_item.DeleteMe()
                this.rank_list_item = null
            }
            if (this.stage_reward_item) {
                for (let key in this.stage_reward_item) {
                    this.stage_reward_item[key].DeleteMe()
                    this.stage_reward_item[key] = null
                }
                this.stage_reward_item = []
            }
            this.CancelTimer()
        }


        this.SetReward = () => {
            if (this.is_show_now_cycle) {
                let stage = this._model.GetStage() || 0
                let cfg = res_manager.GetGameConfigFromCache(this, "config_cycle_rank_reach_reward", false)
                this._reward_data = cfg[type + "@" + subtype + "@" + stage]
                if (!this._reward_data || !this._reward_data.rewards) {
                    return
                }
                let rewards = ErlangParser.GetInstance().Parse(this._reward_data.rewards)
                if (this.stage_reward_item) {
                    for (let key in this.stage_reward_item) {
                        this.stage_reward_item[key].DeleteMe()
                        this.stage_reward_item[key] = null
                    }
                    this.stage_reward_item = []
                }
                for (let key in rewards) {
                    let v = rewards[key]
                    let item = new EquipmentItem(this._reward_item_gp)
                    item.SetItemSize(78, 78)
                    item.Load()
                    let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
                    let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                    if (goods_vo) {
                        item.SetData(goods_vo.type_id, v[2], lock)
                    }
                    this.stage_reward_item.push(item)
                }
            }
        }

        this.InitEvent = () => {
            let RefView = () => {
                this.SetBtn()
                this.SetReward()
                this.UpdateItems()
                this.UpdateShowInfo()
                this.StartTimer()
            }
            this.BindEvent(this._model, local_Event.UPDATE_CYCLEIMPACTLIST_VIEW, RefView)

            this.BindEvent(this._model, local_Event.GET_REWARD, (reward_id) => {
                if (reward_id) {
                    let cfg = res_manager.GetGameConfigFromCache(this, "config_cycle_rank_reach_reward", false)
                    if (cfg) {
                        let rewards = cfg[type + "@" + subtype + "@" + reward_id]
                        if (rewards && this._reward_data?.rewards) {
                            rewards = ErlangParser.GetInstance().Parse(this._reward_data.rewards);
                            local_global.Fire(local_ename.REWARD_FLY, rewards, this.btn_gp.localToGlobal(new Laya.Point(0, 0)))
                            this.ShowRewardMessage(rewards)
                            // new CongratulationObtainView(rewards, 10).Open();
                        }
                    }
                }
            }
            )

            Util.AddClickEvent(this.btn_gp, () => {
                if (this._model.GetStatuse() == 1) {
                    this._model.Fire(CycleimpActlistEvent.REQUEST_PROTO, 22704, "hhh", this._model.type, this._model.subtype, this._model.GetStage())
                } else {
                    OutWardBaseModel.GetInstance().Choose_Tab = 2
                    if (this._model.type == 1) {
                        GlobalEventSystem.Fire(EventName.SWITCH_MOUNT_PET_VIEW, 0, null, 331110)
                    } else if (this._model.type == 2) {
                        GlobalEventSystem.Fire(EventName.SWITCH_MOUNT_PET_VIEW, 1, null, 331110)
                    } else if (this._model.type == 3) {
                        GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].Wings, 331110)
                    } else if (this._model.type == 4) {
                        GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].Artifact, 331110)
                    } else if (this._model.type == 5) {
                        GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].HolyDevice, 331110)
                    } else if (this._model.type == 6) {
                        if(CommonManager.GetInstance().CheckFuncOpenState("BackOrnamentComponentView")){
                            if(CommonManager.GetInstance().CheckFuncOpenState("BackOrnamentLvSystem")){
                                GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, window["MainFunc"].Role, window["RoleViewIndex"].BackOrnament, 331110)
                            }
                        }
                    } else if (this._model.type == 7) {

                    }
                }
            }, this, true)

            this.BindEvent(this._model, local_Event.UPDATE_CYCLEIMPACTLIT_RED, () => {
                let red: boolean = this._model.CheckActData();
                this.btn_red.visible = red;
                if (red) {
                    CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.UPDATE_TAB_RED, "331_cycle", red);
                }
            })
        }

        this.LoadSuccess = () => {
            this._model.Fire(CycleimpActlistEvent.REQUEST_PROTO, 22700)
            this.InitView()
            this.InitEvent()
            this.SetBtn()
            this.StartTimer()
        }

        this.InitView = () => {
            if (!this.is_show_now_cycle) { // 是否为昨日
                this.self_info_bg.y = 865
                this.self_info_bg.height = 49
                this.other_rank.visible = false
                this.other_score.visible = false
                this.my_rank.y = 880
                this.my_score.y = 880
                this._reward_item_gp.visible = false
                this.next_des.visible = false
                this.btn_gp.visible = false
                this.progres.visible = false
                this.lb_4.visible = true
                this.bg.height = 553
                this._group_item.height = 497
                this._img_tile_21.visible = false
                this._img_title_2.visible = false
                this._img_title_3.visible = true
                this._img_time_bg.visible = false
                this.lb_time.visible = false
                this.time_des.visible = false
                res_manager.SetImageSprite(this, this._img_title_1, "cycleimpActlist", "ui_" + this._model.GetYesterdayInfo().type)
            } else {
                this.bg.height = 494
                res_manager.SetImageSprite(this, this._img_title_1, "cycleimpActlist", "ui_" + this._model.type)
                res_manager.SetImageSprite(this, this._img_title_2, "cycleimpActlist", this._model.type)
            }
            res_manager.SetTexture(this, this._img_bg, GameResPath.GetIcon("cycleimpActlist", "ui_activity_bg5"))
            res_manager.SetTexture(this, this.img_title_bg, GameResPath.GetIcon("cycleimpActlist", "ui_activity_bg6"))
            res_manager.SetTexture(this, this.self_info_bg, GameResPath.GetIcon("cycleimpActlist", "ui_activity_08"))
        }

        this.ShowRewardMessage = (rewards) =>{
            for (let key in rewards) {
                let v = rewards[key]
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(v[0], v[1])
                let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
                let str = `获得<font color=${ColorUtil.GetColorLight(goods_vo.color)}>${goods_vo.goods_name}x${v[2]}</font>`
                Message.show(str)
            }
        }

        this.UpdateItems = () => {
            if (this.is_show_now_cycle) {
                let list = this._model.GetNowRankList()
                let config_rank_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_cycle_rank_reward", false)
                let max_num = 0
                for (let key in config_rank_) {
                    if (config_rank_[key].type == type && config_rank_[key].sub_type == subtype) {
                        if (config_rank_[key].rank_max > max_num) {
                            max_num = config_rank_[key].rank_max
                        }
                    }
                }
                let is_have_role = false
                let i = 1
                do {
                    is_have_role = false
                    for (let key in list) {
                        if (list[key].rank == i) {
                            is_have_role = true
                            list[key].type = type
                            list[key].subtype = subtype
                            break
                        }
                    }
                    if (!is_have_role) {
                        let temp = { rank: i, type: type, subtype: subtype }
                        table.insert(list, temp)
                    }
                    i++
                } while (i <= max_num)
                table.sort(list, (a?, b?) => {
                    if (a.rank != b.rank) {
                        return a.rank < b.rank
                    }
                    return false
                })
                if (!this.rank_list_item) {
                    this.rank_list_item = new LoopScrowViewMgr()
                    this.rank_list_item.SetData(this._group_item, CycleimpActlistItem, list, LoopScrCon.Vertical)
                } else {
                    this.rank_list_item.replaceAll(list)
                }
            } else {
                let info = this._model.GetYesterdayInfo()
                let list = info.rank_list
                let config_rank_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_cycle_rank_reward", false)
                let max_num = 0
                for (let key in config_rank_) {
                    if (config_rank_[key].type == info.type && config_rank_[key].sub_type == info.subtype) {
                        if (config_rank_[key].rank_max > max_num) {
                            max_num = config_rank_[key].rank_max
                        }
                    }
                }
                let is_have_role = false
                let i = 1
                do {
                    is_have_role = false
                    for (let key in list) {
                        if (list[key].rank == i) {
                            is_have_role = true
                            list[key].type = info.type
                            list[key].subtype = info.subtype
                            break
                        }
                    }
                    if (!is_have_role) {
                        let temp = { rank: i, type: info.type, subtype: info.subtype }
                        table.insert(list, temp)
                    }
                    i++
                } while (i <= max_num)
                table.sort(list, (a?, b?) => {
                    if (a.rank != b.rank) {
                        return a.rank < b.rank
                    }
                    return false
                })
                if (!this.rank_list_item) {
                    this.rank_list_item = new LoopScrowViewMgr()
                    this.rank_list_item.SetData(this._group_item, CycleimpActlistItem, info.rank_list, LoopScrCon.Vertical)
                } else {
                    this.rank_list_item.replaceAll(info.rank_list)
                }
            }
        }

        this.SetBtn = () => {
            if (this.is_show_now_cycle) {
                if (this._model.GetStatuse() == 1) {
                    this.lb_btn.text = "领取"
                } else {
                    this.lb_btn.text = "继续提升"
                }
                let type_id = this._model.GetOutWardType()
                let red
                if (type_id) {
                    red = OutWardBaseModel.GetInstance().LvsystemCanLvUp(type_id) || this._model.GetStatuse() == 1
                } 
                this.btn_red.visible = red;
                if (red) {
                    CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.UPDATE_TAB_RED, "331_cycle", red);
                }
            }
        }

        this.UpdateShowInfo = () => {
            if (this.is_show_now_cycle) {
                if (!this._reward_data || !this._reward_data.rewards) {
                    return
                }
                let next_stage_score = 0
                let other_role_rank
                let rank_stage = this._model.GetRankStage() || 0
                let rank_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_cycle_rank_reward", false)
                if (rank_stage == 0) {
                    for (let key in rank_cfg) {
                        if (rank_cfg[key].type == type && rank_cfg[key].sub_type == subtype && rank_cfg[key].reward_id >= rank_stage) {
                            rank_stage = rank_cfg[key].reward_id + 1
                        }
                    }
                }
                let next_rank_stage_info = rank_cfg[type + "@" + subtype + "@" + (rank_stage - 1)]
                if (next_rank_stage_info) {
                    next_stage_score = next_rank_stage_info.limit_val
                }
                let list = this._model.GetNowRankList() || []
                if (next_rank_stage_info) {
                    for (let key in list) {
                        if (list[key].rank == next_rank_stage_info.rank_max && list[key].role_id) {
                            next_stage_score = list[key].role_score
                            other_role_rank = list[key]
                            break
                        }
                    }
                }
                this.other_rank.visible = true
                this.other_score.visible = true
                this._lb_number1.visible = false
                this.my_score.visible = true;
                if (other_role_rank) {
                    this.other_rank.innerHTML = "第<font color='#0a953e'>" + other_role_rank.rank + "</font>名：" + other_role_rank.role_name
                    this.other_score.innerHTML = "冲榜积分：<font color='#d15e00'>" + other_role_rank.role_score + "分</font>"
                } else if (next_rank_stage_info) {
                    this.other_rank.innerHTML = "第" + next_rank_stage_info.rank_max + "名：暂无"
                    this.other_score.innerHTML = "冲榜积分：<font color='#d15e00'>" + next_rank_stage_info.limit_val + "分可上榜</font>"
                } else {
                    this.other_rank.visible = false
                    this.other_score.visible = false
                    this._lb_number1.visible = true
                }
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_cycle_rank_reach_reward", false)
                let stage_info = cfg[type + "@" + subtype + "@" + this._model.GetStage()]
                if (stage_info) {
                    this.des.text = stage_info.need + "分可领取"
                }
                if (this._model.GetMyRank() == 0) {
                    this.my_rank.innerHTML = "我的排名：未上榜"
                } else {
                    this.my_rank.innerHTML = "我的排名：<font color='#0a953e'>" + this._model.GetMyRank() + "</font>名"
                }

                let isShop: boolean = (this.time_info.upon_end_time - TimeUtil.getServerTime() <= 0)
                let str: string = isShop ? '结算中停止计算' : this._model.GetMyScore() + '分';

                this.my_score.innerHTML = "冲榜积分：<font color='#d15e00'>" + str + "</font>"
                if (this._model.GetStatuse() == 1) { // 可领取
                    this.lb_btn.text = "领取"
                    this.progres.innerHTML = "<font color='#0a953e'>" + this._model.GetMyScore() + "/" + this._reward_data.need + "</font>"
                } else if (this._model.GetStatuse() == 3) { // 提升
                    this.lb_btn.text = "前往提升"
                    this.progres.innerHTML = "<font color='#ff0000'>" + this._model.GetMyScore() + "/" + this._reward_data.need + "</font>"
                } else { // 已领完
                    this.btn_gp.visible = true;
                    this.progres.visible = false
                    this.none_next_stage.visible = true
                    this.next_des.visible = false;
                }
                this.progres.x = 153 / 2 - this.progres.contextWidth / 2
                this.progres.y = 26 / 2 - this.progres.contextHeight / 2
            } else {
                let info = this._model.GetYesterdayInfo()
                this.my_rank.innerHTML = info.rank != 0 ? "我的排名：" + info.rank + "名" : "我的排名：未上榜"
                this.my_score.innerHTML = "冲榜积分：" + info.score + "分";

                this.my_score.visible = info.rank != 0;
                this.my_rank.x = info.rank != 0 ? 114 : 284;

            }
        }

        this.CustomMehod = (index?, is_now_cycle?) => {
            this.is_show_now_cycle = is_now_cycle
        }

    }
    StartTimer() {
        if (this.is_show_now_cycle) {
            this.lb_time.visible = true
            this.CancelTimer();
            this.time_info = this._model.GetActTime()
            this.update_timer_id = GlobalTimerQuest.AddPeriodQuest(
                () => {
                    this.OnTimer();
                }, 1, -1);
            this.OnTimer();
        } else {
            this.lb_time.visible = false
        }
    }

    CancelTimer() {
        if (this.update_timer_id) {
            GlobalTimerQuest.CancelQuest(this.update_timer_id);
            this.update_timer_id = null;
        }
    }
    public OnTimer() {
        if ((this.time_info.upon_end_time - TimeUtil.getServerTime() > 0)) {
            this.lb_time.text = TimeUtil.timeConvert(this.time_info.upon_end_time - TimeUtil.getServerTime(), "hh-mm-ss")
        } else {
            this.lb_time.text = "今日竞榜结算中"
            this.CancelTimer()
        }
    }
    public Open(is_show_now_cycle) {
        this.is_show_now_cycle = is_show_now_cycle
    }

    public DeleteMe() {

        this.Local_DeleteMe()
        super.DeleteMe()
    }


    _img_bg: Laya.Image
    _img_time_bg: Laya.Image
    _img_title_1: Laya.Image
    _img_tile_21: Laya.Image
    _img_title_2: Laya.Image
    _img_title_3: Laya.Image
    bg: Laya.Image
    lb_desc: Laya.HTMLDivElement
    time_des: Laya.Label
    lb_time: Laya.Label
    img_title_bg: Laya.Image
    lb_1: Laya.Label
    lb_2: Laya.Label
    lb_3: Laya.Label
    time_bg: Laya.Image
    _group_item: Laya.List
    self_info_bg: Laya.Image
    other_rank: Laya.HTMLDivElement
    my_rank: Laya.HTMLDivElement
    other_score: Laya.HTMLDivElement
    my_score: Laya.HTMLDivElement
    _reward_item_gp: Laya.HBox
    none_next_stage: Laya.Image
    btn_gp: Laya.Box
    img_btn: Laya.Image
    lb_btn: Laya.Label
    btn_red: Laya.Image
    progres: Laya.HTMLDivElement
    lb_4: Laya.Label
    next_des: Laya.Box
    des: Laya.Label
    _lb_number1: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._img_time_bg,
            this._img_title_1,
            this._img_tile_21,
            this._img_title_2,
            this._img_title_3,
            this.bg,
            this.lb_desc,
            this.time_des,
            this.lb_time,
            this.img_title_bg,
            this.lb_1,
            this.lb_2,
            this.lb_3,
            this.time_bg,
            this._group_item,
            this.self_info_bg,
            this.other_rank,
            this.my_rank,
            this.other_score,
            this.my_score,
            this._reward_item_gp,
            this.none_next_stage,
            this.btn_gp,
            this.img_btn,
            this.lb_btn,
            this.btn_red,
            this.progres,
            this.lb_4,
            this.next_des,
            this.des,
            this._lb_number1,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_time_bg",
                "_img_title_1",
                "_img_tile_21",
                "_img_title_2",
                "_img_title_3",
                "bg",
                "lb_desc",
                "time_des",
                "lb_time",
                "img_title_bg",
                "lb_1",
                "lb_2",
                "lb_3",
                "time_bg",
                "_group_item",
                "self_info_bg",
                "other_rank",
                "my_rank",
                "other_score",
                "my_score",
                "_reward_item_gp",
                "none_next_stage",
                "btn_gp",
                "img_btn",
                "lb_btn",
                "btn_red",
                "progres",
                "lb_4",
                "next_des",
                "des",
                "_lb_number1",
            ])
        this.my_rank.style.fontSize = 20
        this.my_rank.style.color = "#663915"
        this.my_rank.style.wordWrap = false
        this.other_rank.style.fontSize = 20
        this.other_rank.style.color = "#663915"
        this.other_rank.style.wordWrap = false
        this.my_score.style.fontSize = 20
        this.my_score.style.color = "#663915"
        this.my_score.style.wordWrap = false
        this.other_score.style.fontSize = 20
        this.other_score.style.color = "#663915"
        this.other_score.style.wordWrap = false
        this.progres.style.fontSize = 20
        this.progres.style.wordWrap = false
    }
}
window["CycleimpActlistView"] = CycleimpActlistView