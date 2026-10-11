import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { RewardPreView } from "../common/RewardPreView"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopIndex } from "../commonModel/ShopModel"
import { TopPkDefine, TopPkModel } from "../commonModel/TopPkModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, RefBoxChildsLayout, SetHtmlStyle, Util } from "../util/Util"
import { TopPkEnterRankItem } from "./TopPkEnterRankItem"

export class TopPkEnterView extends BaseItem1 {

    CancelAllCountTime
    CancelCountTime
    InitEvent
    InitView
    LoadSuccess
    Local_DeleteMe
    Scr_Scroller1
    StartCountTime
    UpdateActState
    UpdateAutoMatchState
    UpdateBoxs
    UpdateDailyCountData
    UpdateLevelData
    UpdateRank
    UpdateRewardShowRed
    UpdateSeasonData
    UpdateSpecialScore
    ShowReward
    _list_rank_con
    loop_mgr

    public static COUNT_DOWN_TYPE = { ACT: 1, SEASON: 2 };
    public static LEVEL_PROGRESS_WIDTH = 219;
    public static MATCH_COUNT_PROGRESS_WIDTH = 367;
    public constructor(parent?) {
        super(parent)


        this.base_file = "topPk"
        this.layout_file = "TopPkEnterView"
        let model = TopPkModel.GetInstance()

        let local_TopPkDefine = TopPkDefine
        let local_TopPkModel = TopPkModel
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        let goods_model = GoodsModel.GetInstance()
        let local_Message = Message
        let role_mgr = RoleManager.GetInstance()
        let local_TopPkEnterView = TopPkEnterView
        let local_TimeUtil = TimeUtil
        let array_rank_ = null
        let time_id_ = null
        let time_func_ = null
        let start_time = null

        this.load_callback = () => {
            SetHtmlStyle(this._lb_match_times,{c:"#ffffff",f:18,w:100,ww:false})
            this.LoadSuccess()
        }

        this.LoadSuccess = () => {
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
            //     this._Label9.size = 16
            //     this._lb_act_tips.size = 20
            //     this._lb_act_count_down.size = 20
            // }
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image4, GameResPath.GetIcon("topPk", "uidfjj_007"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image7, GameResPath.GetIcon("topPk", "uidfjj_008"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._img_level_progress, GameResPath.GetIcon("topPk", "uidfjj_009"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._Image11, GameResPath.GetIcon("topPk", "uidfjj_017"))
            ResManager.GetInstance().SetImageSpriteTrans(this, this._img_match_count_progress, GameResPath.GetIcon("topPk", "uidfjj_018"))
            //ResManager.GetInstance().SetOutsideImageSprite(this, this._Image15, GameResPath.GetIcon("topPk", "uidfjj_015"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("topPk", "uidfjj_0166"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.rank_title, GameResPath.GetIcon("topPk", "ui_phb_12"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this.rank_title2, GameResPath.GetIcon("topPk", "ui_task_05a"), true)

            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, GameResPath.GetIcon("topPk", "uidfjj_016"), true)
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_money_icon, GameResPath.GetGoodsIconPath(local_TopPkDefine.MONEY_ICON_ID))
            model.SetRedFlag(local_TopPkModel.RedFlag.Act_Open, false)
            model.Fire(local_TopPkModel.REQUEST_SCMD, 28115)
            this.InitView()
            this.InitEvent()
        }

        this.InitEvent = () => {
            this.BindVar(model, "rank_data", () => {
                this.UpdateRank()
            }
            )
            this.BindVar(model, "level_data", () => {
                this.UpdateLevelData()
            }
            )
            this.BindVar(model, "daily_count_data", () => {
                this.UpdateDailyCountData()
            }
            )
            this.BindVar(model, "season_data", () => {
                this.UpdateSeasonData()
            }
            )
            this.BindVar(model, "act_state_data", () => {
                this.UpdateActState()
            }
            )
            this.BindVar(model, "auto_match_state", () => {
                this.UpdateAutoMatchState()
            }
            )
            this.BindEvent(model, local_TopPkModel.GET_DAILY_COUNT_REWARD, (scmd?) => {
                let obj = null
                let index = 0
                if (1 == scmd.count) {
                    index = 0
                } else if (5 == scmd.count) {
                    index = 1
                } else if (10 == scmd.count) {
                    index = 2
                }
                // [ts2lua]this下标访问可能不正确
                obj = this["_gp_box" + index]
                if (obj) {
                    let pos = obj.localToGlobal(new Laya.Point(0, 0), true)
                    local_GlobalEventSystem.Fire(local_EventName.REWARD_FLY, scmd.reward_obj_list, pos, null, null, -40, 300, 700)//
                }
                this.ShowReward(scmd)
            }
            )
            this.BindEvent(goods_model, GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
                if (vo.currency_id == local_TopPkDefine.MONEY_TYPE) {
                    this.UpdateSpecialScore()
                }
            }
            )
            this.BindEvent(model, local_TopPkModel.REFRESH_RED_FLAG, (flag?) => {
                if (flag == local_TopPkModel.RedFlag.Level_Reward || flag == local_TopPkModel.RedFlag.Daily_Reward) {
                    this.UpdateRewardShowRed()
                }
            }
            )
            let click_func = (...new_args) => {
                let count = 0
                let args = new_args
                let e = args[0]
                // [ts2lua]this下标访问可能不正确
                if (e.target.name == "_gp_box0") {
                    count = 1
                    // [ts2lua]this下标访问可能不正确
                } else if (e.target.name == "_gp_box1") {
                    count = 5
                    // [ts2lua]this下标访问可能不正确
                } else if (e.target.name == "_gp_box2") {
                    count = 10
                }
                let state = 1
                let boxs_data = model.daily_count_data && model.daily_count_data.daily_reward_counts
                if (boxs_data) {
                    for (let _tmpi in boxs_data) {
                        var value = boxs_data[_tmpi]
                        if (value.count == count) {
                            state = value.state
                            break
                        }
                    }
                }
                if (0 == state) {
                    local_Message.show("该奖励已领取")
                } else if (1 == state) {
                    let top_pk_day_participate_reward_cfg = Config.PRELOAD_SERVER_CONFIG.config_top_pk_day_participate_reward
                    // [ts2lua]top_pk_day_participate_reward_cfg下标访问可能不正确
                    let reward_cfg = top_pk_day_participate_reward_cfg[count]
                    if (reward_cfg) {
                        let view = new RewardPreView()
                        view.Open(JSON.parse(reward_cfg.reward))
                    }
                } else if (2 == state) {
                    model.Fire(local_TopPkModel.REQUEST_SCMD, 28103, count)
                }
            }

            let i = 0
            do {
                // [ts2lua]this下标访问可能不正确
                Util.AddClickEvent(this["_gp_box" + i], click_func, this, true)
                i = i + 1
            } while ((i < 3))
            Util.AddClickEvent(this._gp_match, () => {
                if (start_time && TimeUtil.getServerTime() - start_time < 3) { return }
                start_time = TimeUtil.getServerTime()
                let act_state_data = model.act_state_data
                if (act_state_data && act_state_data.state == 1) {
                    model.Fire(local_TopPkModel.REQUEST_SCMD, 28110)
                } else {
                    local_Message.show("活动未开启")
                }
            }
                , this, true)
            Util.AddClickEvent(this._img_add_times, () => {
                if (!model.GetOpenState()) {
                    local_Message.show("活动未开启")
                    return
                }
                let act_state_data = model.act_state_data
                if (!act_state_data || act_state_data.state != 1) {
                    local_Message.show("活动未开启")
                    return
                }
                model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkBuyCountView")
            }
                , this, true)
            Util.AddClickEvent(this._img_auto_match, () => {
                if (start_time && TimeUtil.getServerTime() - start_time < 3) { return }
                start_time = TimeUtil.getServerTime()
                let auto_match_state = model.auto_match_state
                if (auto_match_state) {
                    model.ChangeVar("auto_match_state", false)
                } else {
                    if (!model.GetOpenState()) {
                        local_Message.show("活动未开启")
                        return
                    }
                    let act_state_data = model.act_state_data
                    if (!act_state_data || act_state_data.state != 1) {
                        local_Message.show("活动未开启")
                        return
                    }
                    let daily_count_data = model.daily_count_data
                    if (!daily_count_data || daily_count_data.daily_count < TopPkDefine.OPEN_AUTO_MATCH_COND) {
                        // if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
                        //     local_Message.show("累計" + model.OPEN_AUTO_MATCH_COND + "回参加後自動マッチング機能を利用可能")
                        // } else {
                        local_Message.show("参战" + TopPkDefine.OPEN_AUTO_MATCH_COND + "场开启自动匹配")
                        //}
                        return
                    }
                    let left_time = daily_count_data.daily_buy_count + TopPkDefine.DAILY_MATCH_COUNT - daily_count_data.daily_count
                    if (!left_time) {
                        local_Message.show("剩余挑战次数不足")
                        return
                    }
                    model.ChangeVar("auto_match_state", true)
                }
            }
                , false)//, "操作过快，请1秒后重试~"
            Util.AddClickEvent(this._gp_reward_show, () => {
                model.Fire(local_TopPkModel.OPEN_VIEW, "TopPkRewardView")
            }
                , this, true)
            Util.AddClickEvent(this._img_shop, () => {
                local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.Honer, false, 76)
            }
                , this, true)
        }

        this.InitView = () => {
            this.UpdateRank()
            this.UpdateSeasonData()
            this.UpdateDailyCountData()
            this.UpdateLevelData()
            this.UpdateActState()
            this.UpdateAutoMatchState()
            this.UpdateRewardShowRed()
            this.UpdateSpecialScore()
        }

        this.UpdateRank = () => {
            let rank_data = model.rank_data
            let list = []
            if (rank_data) {
                list = rank_data.rank_list
            }
            this._lb_none.visible = list.length == 0
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.Content, TopPkEnterRankItem, list, LoopScrCon.Vertical)
            } else {
                this.loop_mgr.replaceAll(list)

            }
            let bool = false
            let top_pk_rank_reward_cfg = Config.PRELOAD_SERVER_CONFIG.config_top_pk_rank_reward
            for (let key in list) {

                // [ts2lua]list下标访问可能不正确
                let value = list[key]
                if (value && value.role_id == role_mgr.GetMainRoleId()) {
                    bool = true
                    this._lb_my_rank.text = String(Number(key) + 1)
                    this._lb_my_name.text = value.role_name
                    this._lb_my_point.text = model.GetLevelTotalPoint(value.rank_lv, top_pk_rank_reward_cfg) + value.point
                    let cfg = model.GetLevelCfg(value.rank_lv, top_pk_rank_reward_cfg)
                    if (cfg) {
                        this._lb_my_level_name.text = cfg.rank_name
                    }
                    break
                }
            }
            if (!bool) {
                this._lb_my_rank.text = "未上榜"
                this._lb_my_name.text = role_mgr.GetMainRoleVo().name
            }
        }

        this.UpdateSeasonData = () => {
            let season_data = model.season_data
            this._Image4.visible = true
            this._lb_season_count_down.x = 125

            if (season_data) {
                let season_end_time = season_data.season_end_time
                this.StartCountTime(local_TopPkEnterView.COUNT_DOWN_TYPE.SEASON, () => {
                    let left_time = season_end_time - local_TimeUtil.getServerTime()
                    if (left_time < 0) {
                        this.CancelCountTime(local_TopPkEnterView.COUNT_DOWN_TYPE.SEASON)
                        model.Fire(local_TopPkModel.REQUEST_SCMD, 28115)
                        this._lb_season_count_down.text = "赛季已结束"
                        this._Image4.visible = false
                        this._lb_season_count_down.centerX = 0
                    }
                    this._lb_season_count_down.text = "" + local_TimeUtil.timeConvert(left_time, "hh-mm-ss")
                }
                )
            }
        }

        this.UpdateDailyCountData = () => {
            let daily_count_data = model.daily_count_data
            if (daily_count_data) {
                let total_match_times = daily_count_data.daily_buy_count + TopPkDefine.DAILY_MATCH_COUNT
                let left_match_times = total_match_times - daily_count_data.daily_count


                this._lb_match_times.innerHTML = "<font color='#00fa64'>" + left_match_times + "</font>" + "/" + total_match_times
                this.UpdateBoxs()
            }
            RefBoxChildsLayout(this._Group12,10,null,true,"left")
        }

        this.UpdateLevelData = () => {
            let level_data = model.level_data
            if (level_data) {
                let top_pk_rank_reward_cfg = Config.PRELOAD_SERVER_CONFIG.config_top_pk_rank_reward
                let level_cfg = model.GetLevelCfg(level_data.rank_lv, top_pk_rank_reward_cfg)
                if (level_cfg) {
                    ResManager.GetInstance().SetOutsideImageSprite(this, this._img_level_icon, GameResPath.GetIcon("topPk", level_cfg.big_rank), true)
                    model.SetLevelIcon(this, this._img_level_label, level_cfg.big_rank, level_cfg.rank_lv)
                    this._lb_now_level.text = level_cfg.rank_name
                    let str: String = level_cfg.rank_name
                    let a = str.substr(0, 2)
                    this.level.text = a
                    let level_progress_desc = null
                    let next = null
                    let next_level_desc = null
                    let progress_value = null
                    let next_level_cfg = model.GetLevelCfg(level_data.rank_lv + 1, top_pk_rank_reward_cfg)
                    if (next_level_cfg) {
                        level_progress_desc = level_data.point
                        progress_value = level_data.point / level_cfg.point
                        next_level_desc = next_level_cfg.rank_name
                        next = level_cfg.point
                    } else {
                        level_progress_desc = ""
                        next = ""
                        next_level_desc = "最高"
                        progress_value = 1
                    }
                    this._lb_level_progress.text = level_progress_desc
                    this._lb_level_next.text = next
                    this._lb_next_level.text = next_level_desc
                    this._img_level_progress.width = progress_value * 181
                    this._lb_my_point.text = String(model.GetLevelTotalPoint(level_data.rank_lv, top_pk_rank_reward_cfg) + level_data.point)
                    this._lb_my_level_name.text = level_cfg.rank_name
                }
            }
            //LayoutRebuilder(this._Group6)
        }

        this.UpdateBoxs = () => {
            let daily_count_data = model.daily_count_data
            let boxs_data = daily_count_data && daily_count_data.daily_reward_counts
            if (boxs_data) {
                let daily_count = daily_count_data.daily_count
                for (let k in boxs_data) {

                    let key = Number(k)
                    // [ts2lua]boxs_data下标访问可能不正确
                    let value = boxs_data[k]
                    // [ts2lua]this下标访问可能不正确
                    let a = this["_img_box" + key]
                    Util.SetImageGray(this["_img_box" + key], value.state == 0)
                    // [ts2lua]this下标访问可能不正确
                    this["_img_box_received" + key].visible = value.state == 0
                    // [ts2lua]this下标访问可能不正确
                    this["_img_box_red" + key].visible = value.state == 2
                    //let url = value.state == 2 ? "ui_sm_024" : "ui_sm_025"
                    // ResManager.GetInstance().SetImageSprite(this, this["box_bg" + key], " ", url, true)
                    this["receive_box" + key].visible = (value.state == 2)
                    this["box_bg" + key].visible = (value.state != 2)
                    this.ClearUIEffect(this["effect_con" + key])
                    if (value.state == 2)
                        this.AddUIEffect("UI_1303c", this["effect_con" + key], null, 5, true)
                }
                this._img_match_count_progress.width = Math.min(daily_count_data.daily_count / TopPkDefine.DAILY_MATCH_COUNT, 1) * 421
            }
        }

        this.UpdateActState = () => {
            let act_state_data = model.act_state_data
            this.CancelCountTime(local_TopPkEnterView.COUNT_DOWN_TYPE.ACT)
            if (act_state_data && act_state_data.state == 1) {
                this._lb_act_tips.text = "活动倒计时："
                let end_time = act_state_data.end_time
                this.StartCountTime(local_TopPkEnterView.COUNT_DOWN_TYPE.ACT, () => {
                    let left_time = end_time - local_TimeUtil.getServerTime()
                    if (left_time < 0) {
                        this.CancelCountTime(local_TopPkEnterView.COUNT_DOWN_TYPE.ACT)
                        this._lb_act_count_down.text = "已结束"
                        return
                    }
                    this._lb_act_count_down.text = local_TimeUtil.timeConvert(left_time, "hh-mm-ss2")
                }
                )
            } else {
                this._lb_act_tips.text = "活动日期：\n活动时间："
                let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
                //if (open_day < 4 ) {
                //this._lb_act_count_down.text = "周二、四\n21:00~21:20"
                if (open_day == 4) {
                    this._lb_act_count_down.text = "开服第4天休战\n21:00~21:20"

                }
                else if (open_day >= 1 && open_day <= 3) {
                    this._lb_act_count_down.text = "每天\n21:00~21:20"
                }
                else {
                    this._lb_act_count_down.text = "每周三、周日\n21:00~21:20"
                }
            }
            //LayoutRebuilder(this._Group13)
        }

        this.StartCountTime = (type?, func?) => {
            if (!time_id_) {
                time_id_ = {}
            }
            if (!time_func_) {
                time_func_ = {}
            }
            this.CancelCountTime(type)

            time_id_[type] = GlobalTimerQuest.AddPeriodQuest(func, 1)


            func()
        }

        this.CancelCountTime = (type?) => {
            // [ts2lua]time_id_下标访问可能不正确
            if (!time_id_ || !time_id_[type]) {
                return
            }
            if (time_id_[type]) {
                GlobalTimerQuest.CancelQuest(time_id_[type])
            }
            delete time_id_[type]
            // [ts2lua]time_func_下标访问可能不正确
            delete time_func_[type]
        }

        this.CancelAllCountTime = () => {
            if (!time_id_) {
                return
            }
            for (let key in time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_[key])
            }
            time_id_ = null
            time_func_ = null
        }

        this.UpdateAutoMatchState = () => {
            // [ts2lua]lua中0和空字符串也是true，此处model.auto_match_state需要确认
            let source = model.auto_match_state && "com_ui_gx1" || "com_ui_gx"

            ResManager.GetInstance().SetImageSprite(this, this._img_auto_match, "common_asset", source)

            if (model.auto_match_state) {
                model.Fire(local_TopPkModel.REQUEST_SCMD, 28110)
            }
        }

        this.UpdateRewardShowRed = () => {
            this._img_reward_show_red.visible = model.HasRedFlag(local_TopPkModel.RedFlag.Level_Reward) || model.HasRedFlag(local_TopPkModel.RedFlag.Daily_Reward)
        }

        this.UpdateSpecialScore = () => {
            this._lb_money_count.text = String(goods_model.GetSpecialScore(local_TopPkDefine.MONEY_TYPE))
            // LayoutRebuilder(this._Group8)
        }

        this.Local_DeleteMe = () => {
            this.CancelAllCountTime()
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
            for (let index = 0; index < 3; index++) {
                if (this["effect_con" + index])
                    this.ClearUIEffect(this["effect_con" + index])

            }


        }

        this.ShowReward = (scmd?) => {
            let data = []
            for (let _tmpi in scmd.reward_obj_list) {
                var reward = scmd.reward_obj_list[_tmpi]
                let vo = []
                vo[0] = reward.style
                vo[1] = reward.typeId
                vo[2] = reward.count
                table.insert(data, vo)
            }
            if (data.length > 0) {
                let view = new CongratulationObtainView(data, 10)
                view.Open()

            }
        }


    }


    public DeleteMe() {

        this.Local_DeleteMe()
        super.DeleteMe()
    }



_Group4:Laya.Box
_img_bg0:Laya.Image
rank_title:Laya.Image
rank_title2:Laya.Image
_Group1:Laya.Box
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Group2:Laya.Box
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
_Group3:Laya.Box
_lb_my_rank:Laya.Label
_lb_my_name:Laya.Label
_lb_my_level_name:Laya.Label
_lb_my_point:Laya.Label
Content:Laya.List
_lb_none:Laya.Label
_Group5:Laya.Box
_Image4:Laya.Image
_lb_season_count_down:Laya.Label
_img_level_icon:Laya.Image
_img_level_label:Laya.Image
_Group6:Laya.HBox
_lb_now_level:Laya.Label
_lb_next_level:Laya.Label
_Group7:Laya.Box
_Image7:Laya.Image
_img_level_progress:Laya.Image
_lb_level_progress:Laya.Label
_lb_level_next:Laya.Label
_gp_reward_show:Laya.Box
_Image8:Laya.Image
_img_reward_show_red:Laya.Image
_img_shop:Laya.Image
_Group9:Laya.Box
_Image9:Laya.Image
_Group8:Laya.HBox
_Label5:Laya.Label
_img_money_icon:Laya.Image
_lb_money_count:Laya.Label
_Group14:Laya.Box
_img_bg1:Laya.Image
_Image11:Laya.Image
_img_match_count_progress:Laya.Image
_Group10:Laya.Box
_gp_box0:Laya.Box
box_bg0:Laya.Image
receive_box0:Laya.Image
effect_con0:Laya.Box
_img_box0:Laya.Image
_img_box_red0:Laya.Image
_img_box_received0:Laya.Image
_gp_box1:Laya.Box
box_bg1:Laya.Image
receive_box1:Laya.Image
effect_con1:Laya.Box
_img_box1:Laya.Image
_img_box_red1:Laya.Image
_img_box_received1:Laya.Image
_gp_box2:Laya.Box
box_bg2:Laya.Image
receive_box2:Laya.Image
effect_con2:Laya.Box
_img_box2:Laya.Image
_img_box_red2:Laya.Image
_img_box_received2:Laya.Image
_Image12:Laya.Image
_Image13:Laya.Image
_Image14:Laya.Image
_Group12:Laya.Box
_Label6:Laya.Label
_lb_match_times:Laya.HTMLDivElement
_Group11:Laya.Box
_img_add_times:Laya.Image
_Image15:Laya.Image
_Group13:Laya.HBox
_lb_act_tips:Laya.Label
_lb_act_count_down:Laya.Label
_gp_match:Laya.Box
_Image16:Laya.Image
_Label7:Laya.Label
img:Laya.Image
_img_auto_match:Laya.Image
_Label8:Laya.Label
label:Laya.Label
_Label9:Laya.Label
Group15:Laya.Box
level:Laya.Label
    public GetComponents() {
        [
            this._Group4,
            this._img_bg0,
            this.rank_title,
            this.rank_title2,
            this._Group1,
            this._Image1,
            this._Image2,
            this._Image3,
            this._Group2,
            this._Label1,
            this._Label2,
            this._Label3,
            this._Label4,
            this._Group3,
            this._lb_my_rank,
            this._lb_my_name,
            this._lb_my_level_name,
            this._lb_my_point,
            this.Content,
            this._lb_none,
            this._Group5,
            this._Image4,
            this._lb_season_count_down,
            this._img_level_icon,
            this._img_level_label,
            this._Group6,
            this._lb_now_level,
            this._lb_next_level,
            this._Group7,
            this._Image7,
            this._img_level_progress,
            this._lb_level_progress,
            this._lb_level_next,
            this._gp_reward_show,
            this._Image8,
            this._img_reward_show_red,
            this._img_shop,
            this._Group9,
            this._Image9,
            this._Group8,
            this._Label5,
            this._img_money_icon,
            this._lb_money_count,
            this._Group14,
            this._img_bg1,
            this._Image11,
            this._img_match_count_progress,
            this._Group10,
            this._gp_box0,
            this.box_bg0,
this.receive_box0,
this.effect_con0,
            this._img_box0,
            this._img_box_red0,
            this._img_box_received0,
            this._gp_box1,
            this.box_bg1,
this.receive_box1,
this.effect_con1,
            this._img_box1,
            this._img_box_red1,
            this._img_box_received1,
            this._gp_box2,
            this.box_bg2,
this.receive_box2,
this.effect_con2,
            this._img_box2,
            this._img_box_red2,
            this._img_box_received2,
            this._Image12,
            this._Image13,
            this._Image14,
            this._Group12,
            this._Label6,
            this._lb_match_times,
            this._Group11,
            this._img_add_times,
            this._Image15,
            this._Group13,
            this._lb_act_tips,
            this._lb_act_count_down,
            this._gp_match,
            this._Image16,
            this._Label7,
            this.img,
            this._img_auto_match,
            this._Label8,
this.label,
            this._Label9,
            this.Group15,
            this.level,
        ]
            = this.GetChildrenByNames([

                "_Group4",
                "_img_bg0",
                "rank_title",
                "rank_title2",
                "_Group1",
                "_Image1",
                "_Image2",
                "_Image3",
                "_Group2",
                "_Label1",
                "_Label2",
                "_Label3",
                "_Label4",
                "_Group3",
                "_lb_my_rank",
                "_lb_my_name",
                "_lb_my_level_name",
                "_lb_my_point",
                "Content",
                "_lb_none",
                "_Group5",
                "_Image4",
                "_lb_season_count_down",
                "_img_level_icon",
                "_img_level_label",
                "_Group6",
                "_lb_now_level",
                "_lb_next_level",
                "_Group7",
                "_Image7",
                "_img_level_progress",
                "_lb_level_progress",
                "_lb_level_next",
                "_gp_reward_show",
                "_Image8",
                "_img_reward_show_red",
                "_img_shop",
                "_Group9",
                "_Image9",
                "_Group8",
                "_Label5",
                "_img_money_icon",
                "_lb_money_count",
                "_Group14",
                "_img_bg1",
                "_Image11",
                "_img_match_count_progress",
                "_Group10",
                "_gp_box0",
                "box_bg0",
"receive_box0",
"effect_con0",
                "_img_box0",
                "_img_box_red0",
                "_img_box_received0",
                "_gp_box1",
                "box_bg1",
"receive_box1",
"effect_con1",
                "_img_box1",
                "_img_box_red1",
                "_img_box_received1",
                "_gp_box2",
                "box_bg2",
"receive_box2",
"effect_con2",
                "_img_box2",
                "_img_box_red2",
                "_img_box_received2",
                "_Image12",
                "_Image13",
                "_Image14",
                "_Group12",
                "_Label6",
                "_lb_match_times",
                "_Group11",
                "_img_add_times",
                "_Image15",
                "_Group13",
                "_lb_act_tips",
                "_lb_act_count_down",
                "_gp_match",
                "_Image16",
                "_Label7",
                "img",
                "_img_auto_match",
                "_Label8",
"label",
                "_Label9",
                "Group15",
                "level",
            ])
    }
}
window["TopPkEnterView"] = TopPkEnterView