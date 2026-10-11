import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { ResManager } from "../common/ResManager"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { GuildModel } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { RoleVo } from "../sharedata/RoleVo"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, HtmlColorTxt, SetHtmlCenter, SetHtmlStyle } from "../util/Util"
import { Config } from "../common/Config"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { kfStageModel } from "../commonModel/kfStageModel"
import { PlatformManager } from "../PlatformManager"

export class GuildFightView extends BaseItem1 {
    CancelStarEndTimer
    CancelTimer
    ClearModel
    CreatDefaultModel
    CreateModel
    Dispose
    EmpkfBtn
    Empreceived_btn
    Empstar_btn
    GetNextTime
    InitEvent
    InitStarBtn
    InitView
    LoadSuccess
    ReOpen_callback
    Scrreward_scroller
    SetModelInfo
    SetNextTimeText
    SetRewardData
    UpdateFigure
    tmp_figure
    SetStarEndTimeText
    model_scale = 0.75
    UpdateHtmlPos
    OpenDayLessTheFourthDay
    cfg_open_week

    SetAcState
    SetResize
    TimerFunc
    StartTimer
    CancelTimer1
    public constructor(parent?) {
        super(parent)

        this.base_file = "guildFight"
        this.layout_file = "GuildFightView"
        let num_2_week = ["日", "一", "二", "三", "四", "五", "六", "日"]
        let model = GuildFightModel.GetInstance()
        let local_event = GuildFightEvent
        let local_goodsmodel = GoodsModel.GetInstance()
        let roleVo = RoleManager.GetInstance().GetMainRoleVo()
        // let local_uimodelType = UI_MODEL_TYPE
        let local_timeUtil = TimeUtil
        let local_dailyModel = DailyModel.GetInstance()
        let local_openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
        let local_math = Math
        let star_end_time_ = null
        let star_end_timer_id_ = null
        let model_str_ = null
        //let role_model_ = null
        let second_item_ = null
        let first_item_ = null
        let reward_cfg_ = null
        let guild_kv_config_ = null
        let reward_list_ = null
        let next_star_time_ = null
        let star_timer_id_ = null

        let warState_ = 0
        let tipsTime_ = 0
        let tipsTimer_ = null

        this.load_callback = () => {
            this.reward_scroller.hScrollBarSkin = ""
            this.LoadSuccess()
            this.InitEvent()
        }

        this.ReOpen_callback = () => {
            if (this.tmp_figure) {
                this.CreateModel(this.tmp_figure)
            }
        }





        this.LoadSuccess = () => {
            //tip提示
            let kvCfg = Config.PRELOAD_SERVER_CONFIG.config_territory_war_kv[1]   //Config.Territorywarkv[1]
            if (kvCfg) {
                let List = JSON.parse(kvCfg.values)
                if (List && List[0]) {
                    this.cfg_open_week = Number(List[0][0])
                }
            }
            this.SetAcState()

            reward_cfg_ = Config.PRELOAD_SERVER_CONFIG.config_terri_war_win_reward
            guild_kv_config_ = Config.PRELOAD_SERVER_CONFIG.config_territory_kv
            if (reward_cfg_ && guild_kv_config_) {
                this.SetRewardData()
                this.InitView()
            }

        }

        this.OpenDayLessTheFourthDay = () => {
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            return open_day <= 4
        }


        this.InitView = () => {
            let data = model.GetWinData()
            this.name_label1.text = `【最强结社】`
            this.name_label1.color = "#ff4f50"
            if (!data) {
                Util.SetImageGray(this._Image1111, true)
                this.received_red.visible = false
                this.labelDisplay11.text = "不可领取"
                this.wintime_label.text = "0次"

                this.PreHtml()
                this.name_label.innerHTML = Util.StrToHTML("虚位以待")
                this.UpdateHtmlPos()
                return
            }
            if (data.winner != 0) {
                this.empty_tag.visible = false
                model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 13014, "hlh", data.server_id, data.winner, 506)
            } else {
                this.PreHtml()
                this.name_label.innerHTML = Util.StrToHTML("虚位以待")
                this.empty_tag.visible = true
                //ResManager.GetInstance().SetOutsideImageSprite(this, this.empty_tag, GameResPath.GetIcon("kf1vn", "uikf1vn_003"), true)
            }

            this.UpdateHtmlPos()
            // SetHtmlCenter(this.name_label, { x: 190, w: 340 })
            this.wintime_label.text = data.win_num || 0 + "次"

            let sx = (this.display_obj.width - (this.wintime_label.textField.textWidth + this.wintime_label2.width)) / 2
            this.wintime_label2.x = sx
            this.wintime_label.x = this.wintime_label2.width + 5 + sx

            this.labelDisplay11.stroke = data.type != 1 ? 0 : 2
            if (data.type == 1) {
                this.received_red.visible = true
                //this.received_btn.enabled = true
                Util.SetImageGray(this._Image1111, false)
                this.labelDisplay11.text = "领取奖励"
            } else {
                Util.SetImageGray(this._Image1111, true)
                this.received_red.visible = false
                //this.received_btn.enabled = false
                if (data.type == 3) {
                    this.labelDisplay11.text = "已领取"
                } else {
                    this.labelDisplay11.text = "不可领取"
                }
            }
            if (((GuildModel.IsHasGuild() && roleVo.guild_id == data.winner) && !(data.reward_owner != 0)) && roleVo.position == 1) {
                if (data.reward_type == 1) {
                    // [ts2lua]lua中0和空字符串也是true，此处data.win_num > 1需要确认
                    this.wining_red.visible = (data.win_num > 1 && (true || (false)))
                }
                else if (data.reward_type == 2) {
                    // [ts2lua]lua中0和空字符串也是true，此处data.win_num > 0需要确认
                    this.end_win_red.visible = (data.win_num > 0 && (true || (false)))
                }
            } else {
                this.end_win_red.visible = false
                this.wining_red.visible = false
            }
            this.SetModelInfo()
            this.CreatDefaultModel()
        }


        this.SetResize = () => {
            if(PlatformManager.IsEyouPlatform()){
                this.tipsLb.style.wordWrap = true
                this.tipsLb.style.leading = 0.1
                this.tipsLb.style.width = 700
            }
            let allW = 20 + this.tipsLb.contextWidth + 5
            let sx = (this.display_obj.width - allW) / 2
            this._Image6.x = sx
            this.tipsLb.x = sx + 25
        }

        this.TimerFunc = () => {
            if (this.tipsLb && !this.use_delete_method) {
                if (tipsTime_ && tipsTime_ >= local_timeUtil.getServerTime()) {
                    if (warState_ == 3) {
                        this.tipsLb.innerHTML = Util.StrToHTML("本轮领地争夺战正在进行中,当前剩余时间<font color=\"#00b11d\">(" + (tipsTime_ - local_timeUtil.getServerTime()) + ")秒</font>")
                    }
                    else if (warState_ == 2) {
                        this.tipsLb.innerHTML = Util.StrToHTML("<font color=\"#00b11d\">" + (tipsTime_ - local_timeUtil.getServerTime()) + "秒</font>后开始领地争夺，参战结社请准时入场")
                    }
                    else if (warState_ == 1) {
                        if (model.selectModel) {
                            this.tipsLb.innerHTML = Util.StrToHTML("点击选中领地确认后即可进行宣战 剩余时间:<font color=\"#00b11d\">" + (local_timeUtil.convertTime(tipsTime_ - local_timeUtil.getServerTime())) + "</font>")
                        } else {
                            let countCfg = Config.PRELOAD_SERVER_CONFIG.config_territory_mode[model.serInfo.mode_num]//Config.Territorymode[model.serInfo.mode_num]
                            if (countCfg) {
                                let guild_num = countCfg.guild_num
                                this.tipsLb.innerHTML =
                                    Util.StrToHTML(
                                        "排行<font color=\"#00b11d\">前" + guild_num + "的</font>结社可进行宣战 剩余时间:<font color=\"#00b11d\">" + (local_timeUtil.convertTime(tipsTime_ - local_timeUtil.getServerTime())) + "</font>"
                                    )
                            }
                        }
                    }
                    else if (warState_ == 4) {
                        this.tipsLb.innerHTML = Util.StrToHTML("<font color=\"#00b11d\">" + (tipsTime_ - local_timeUtil.getServerTime()) + "秒</font>后开启下一轮领地的争夺,参战结社请准时入场")
                    }
                } else {
                    this.CancelTimer1()
                }
            }


        }


        this.UpdateHtmlPos = () => {
            let gap = 2
            let w1 = this.name_label1.textField.textWidth
            let w = w1 + gap + this.name_label.contextWidth
            let c = (this.display_obj.width - w) / 2
            this.name_label1.x = c
            this.name_label.x = c + w1 + gap
        }


        this.SetAcState = () => {
            this.PreHtml3()
            let week_str = "周六"
            if (this.cfg_open_week) {

                week_str = "周" + num_2_week[this.cfg_open_week]
            }

            // 第一场为开服第4天
            if (this.OpenDayLessTheFourthDay()) {
                let week_num = TimeUtil.GetWeekStrByOpenDay(4)
                if (week_num) {
                    week_num = Number(week_num)
                    week_str = `周${num_2_week[week_num]}`
                }
            }
            this.CancelTimer1()
            this.tipsLb.innerHTML = Util.StrToHTML("每<font color=\"#00b11d\">" + week_str + "04:00</font>公布领地战资格,<font color=\"#00b11d\">点击领地</font>查看奖励")
            warState_ = model.stateInfo.war_state
            if (warState_ == 3) {
                tipsTime_ = model.roundInfo.round_end_time
                let myGuild = roleVo.guild_id
                if (!model.selectInfo.qualification || model.selectInfo.qualification == 0) {
                    let fail = 0
                    for (let key in model.terInfo) {

                        // [ts2lua]model.terInfo下标访问可能不正确
                        let Vo = model.terInfo[key]
                        if (Vo.a_guild == myGuild || Vo.b_guild == myGuild) {
                            fail = 1
                            break
                        }
                    }
                    if (fail == 1 && model.roundInfo.round_end_time && model.roundInfo.round_end_time > local_timeUtil.getServerTime() || !fail) {
                        warState_ = 4
                        this.tipsLb.innerHTML = Util.StrToHTML("您的结社本轮暂无参战资格")
                        this.SetResize()
                        return
                    }
                } else {
                    for (let key in model.terInfo) {
                        let Vo = model.terInfo[key]
                        if ((Vo.a_guild == myGuild || Vo.b_guild == myGuild) && (!Vo.winner || Vo.winner == 0)) {
                            let TerCfg = Config.PRELOAD_SERVER_CONFIG.config_territory[Vo.territory_id]
                            let round = TerCfg && ((model.serInfo.mode_num == 1 && (TerCfg.round - 1) || (TerCfg.round)))
                            if (round != model.roundInfo.round) {
                                warState_ = 4
                                tipsTime_ = (model.roundInfo.round_end_time || 0) + 60
                            }
                        }
                    }
                }
                if (!tipsTime_) {
                    warState_ = 4
                    tipsTime_ = model.roundInfo.round_start_time
                }
                this.StartTimer()
            }
            else if (warState_ == 2) {
                tipsTime_ = model.stateInfo.start_time
                this.StartTimer()
            }
            else if (warState_ == 1) {
                tipsTime_ = model.stateInfo.ready_time
                this.StartTimer()
            } else {
                this.tipsLb.innerHTML = Util.StrToHTML("每<font color=\"#00b11d\">" + week_str + "04:00</font>公布领地战资格,<font color=\"#00b11d\">点击领地</font>查看奖励")
            }

            this.SetResize()
        }

        this.StartTimer = () => {

            this.CancelTimer()
            tipsTimer_ = GlobalTimerQuest.AddPeriodQuest(() => {
                this.TimerFunc()
            }, 1)
            this.TimerFunc()
        }

        this.CancelTimer1 = () => {
            if (tipsTimer_) {
                GlobalTimerQuest.CancelQuest(tipsTimer_)
                tipsTimer_ = null
            }
        }





        this.InitEvent = () => {
            this.BindEvent(
                model,
                local_event.UPDATE_ROUND, () => {
                    this.SetAcState()
                }
            )

            this.BindEvent(
                model,
                local_event.UPDATE_AC_STATE, () => {
                    this.SetAcState()
                }
            )


            Util.AddClickEvent(
                this.wining_img, () => {
                    model.Fire(local_event.GUILDFIGHT_OPEN_VIEW, "GuildFightWiningRewardView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.end_win_img, () => {
                    model.Fire(local_event.GUILDFIGHT_OPEN_VIEW, "GuildFightEndRewardView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.star_btn, () => {
                    model.Fire(local_event.GUILDFIGHT_OPEN_VIEW, "GuildFightMapView")
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.received_btn, () => {
                    if (model.GetWinData() && model.GetWinData().type == 1) {
                        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50602)
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.kfBtn, () => {
                    //GuildFightSchedule
                    kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_506)
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.UPDATE_GUILD_FIGHT_VIEW, () => {
                    this.InitView()
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_AC_STATE, () => {
                    this.star_red.visible = (model.ac_state && model.ac_state_login) || (model.select_red && model.select_red_login)
                    //this.star_red.visible = !(not model.ac_state || !(not model.select_red))
                })
            this.BindEvent(
                model,
                local_event.UPDATE_REQUEST_FIGURE, (scmd?) => {
                    this.UpdateFigure(scmd)
                }
            )
            this.star_red.visible = (model.ac_state && model.ac_state_login) || (model.select_red && model.select_red_login)
            //this.star_red.visible = !(not model.ac_state || !(not model.select_red))
            this.BindEvent(
                model,
                local_event.UPDATE_SERVER_INFO, () => {
                    this.SetModelInfo()
                }
            )
        }

        this.SetRewardData = () => {
            let world_lv = roleVo.worldLv || 1
            for (let index in reward_cfg_) {

                // [ts2lua]reward_cfg_下标访问可能不正确
                // [ts2lua]reward_cfg_下标访问可能不正确
                if (reward_cfg_[index].min_wlv <= world_lv && world_lv <= reward_cfg_[index].max_wlv) {
                    // [ts2lua]reward_cfg_下标访问可能不正确
                    let battle_reward = JSON.parse(reward_cfg_[index].battle_reward)
                    if (battle_reward) {
                        let second_item = second_item_
                        if (!second_item) {
                            second_item = new BaseAwardItem(this.second_group)
                            second_item.Load()
                            second_item_ = second_item
                        }
                        let type_id, lock

                        [type_id, lock] = local_goodsmodel.GetMappingTypeId(battle_reward[1][0], battle_reward[1][1])
                        let sec_goods_vo = local_goodsmodel.GetGoodsBasicByTypeId(type_id)
                        if (sec_goods_vo) {
                            second_item.SetData(sec_goods_vo.type_id, battle_reward[1][2], lock)
                            second_item.ChangeCountVisible(false)
                        }
                        let fir_item = first_item_
                        if (!fir_item) {
                            fir_item = new BaseAwardItem(this.first_group)
                            fir_item.Load()
                            second_item_ = fir_item
                        }
                        [type_id, lock] = local_goodsmodel.GetMappingTypeId(battle_reward[0][0], battle_reward[0][1])
                        let fir_goods_vo = local_goodsmodel.GetGoodsBasicByTypeId(type_id)
                        if (fir_goods_vo) {
                            fir_item.SetData(fir_goods_vo.type_id, battle_reward[0][2], lock)
                            fir_item.ChangeCountVisible(false)
                        }
                    }
                    // [ts2lua]reward_cfg_下标访问可能不正确
                    let daily_reward = JSON.parse(reward_cfg_[index].daily_reward)
                    if (daily_reward) {
                        if (!reward_list_) {
                            reward_list_ = []
                        }
                        let i = 0
                        do {
                            let item = reward_list_[i]
                            if (!item) {
                                item = new BaseAwardItem(this.Content)
                                item.Load()
                                item.SetScale(0.65)
                                reward_list_[i] = item
                            }
                            let type_id, lock
                            [type_id, lock] = local_goodsmodel.GetMappingTypeId(daily_reward[i][0], daily_reward[i][1])
                            let goods_vo = local_goodsmodel.GetGoodsBasicByTypeId(type_id)
                            if (goods_vo) {
                                item.SetData(goods_vo.type_id, daily_reward[i][2], lock)
                            }
                            i = i + 1
                        } while ((i < daily_reward.length))
                    }
                }
            }
        }


        this.CreatDefaultModel = () => {
            this.ClearModel()

            let boo = true
            this._img_add.visible = boo
            if(boo){
                ResManager.GetInstance().SetOutsideImageSprite(this,this._img_add,GameResPath.GetIcon("dungeonEquip","ui_copy_35"))
            }
            this.model_group.visible = !boo

            // let mainVo = RoleManager.GetInstance().GetMainRoleVo()
            // let model_id, texture_id = mainVo.GetRoleClotheTextureId()
            // let weapon_model_id = mainVo.GetWeaponClotheId()
            // let head_model_id = mainVo.GetRoleHeadId()
            // let data = {
            //     career: mainVo.career,
            //     sex: mainVo.sex,
            //     clothe_res_id: mainVo.GetRoleClotheId(),
            //     weapon_res_id: weapon_model_id,
            //     weapon_clothe_id: 0,
            //     type: UI_MODEL_TYPE.MAINROLE,
            //     scale: this.model_scale,
            //     fashion_model_id: model_id,
            //     texture_id: texture_id,
            //     wing_id: Util.GetWingClotheId(mainVo),
            //     head_wear_id: head_model_id,
            //     head_clothe_id: 0,
            //     hair_id: 0
            // }
            // ResManager.GetInstance().SetRoleModel(this, this.model_group, data)


        }



        this.CreateModel = (role_vo?) => {

            let boo = false
            this._img_add.visible = boo
            if(boo){
                ResManager.GetInstance().SetOutsideImageSprite(this,this._img_add,GameResPath.GetIcon("dungeonEquip","ui_copy_35"))
            }
            
            this.model_group.visible = !boo

            //this.mainVo = RoleManager.GetInstance().GetMainRoleVo()
            let [model_id, texture_id] = Util.GetRoleClotheId(role_vo)
            let weapon_model_id = Util.GetWeaponClotheId(role_vo)
            let [head_id, head_texture_id] = Util.GetRoleHeadId(role_vo)
            // let head_model_id = Util.GetRoleHeadId(role_vo)
            let hair_id = 0//GetRoleHairId(role_vo.fashion_model_list)

            this.ClearModel()
            let call_back = () => {
                //this:CoverMode(this.model_group)
            }

            let data = {
                career: role_vo.career,
                sex: role_vo.sex,
                clothe_res_id: model_id,
                fashion_model_id: model_id,
                type: UI_MODEL_TYPE.MAINROLE,
                weapon_res_id: weapon_model_id,
                weapon_clothe_id: 0,//weapon_texture_id,
                layer_value: this.layer_value,
                scale: this.model_scale,
                texture_id: texture_id,
                wing_id: Util.GetWingClotheId(role_vo),//role_vo.GetFigureId(role_vo, FigureProtoVo.FigureType.Wing),
                // liveness_id: role_vo.liveness_id,
                head_wear_id: head_id,
                head_clothe_id: head_texture_id,//head_clothe_id,
                hair_id: hair_id,
                back_ornament_id: Util.GetBackOrnamentId(role_vo),
                load_call_back: call_back
            }
            ResManager.GetInstance().SetRoleModel(this, this.model_group, data)
        }

        this.ClearModel = () => {

            // if (!role_model_) {
            //     return
            // }
            // role_model_.DeleteMe()
            // role_model_ = null
        }

        this.InitStarBtn = (war_state?) => {
            if (war_state) {
                Util.SetImageGray(this.star_btn, false)
                let data = new Date(local_timeUtil.getServerTime() * 1000)
                let index = data.getDay()
                let i = 1
                do {
                    let ac_cfg = local_dailyModel.GetAcCfg(505, 0, i)
                    if (ac_cfg) {
                        let open_day_cfg = JSON.parse(ac_cfg.open_day)
                        if (open_day_cfg.length > 0) {
                            if (open_day_cfg[0][0] > local_openDay || local_openDay > open_day_cfg[0][1]) {
                                break
                            }
                        }
                        let week_cfg = JSON.parse(ac_cfg.week)
                        let active_time_list = JSON.parse(ac_cfg.time_region)
                        if (week_cfg && week_cfg.length > 0) {
                            for (let _tmpi in week_cfg) {
                                var week_vo = week_cfg[_tmpi]
                                if (index == week_vo) {
                                    let i = 0
                                    do {
                                        let vo = active_time_list[i]
                                        let start_hour = vo[0][0]
                                        let start_min = vo[0][1]
                                        let end_hour = vo[1][0]
                                        let end_min = vo[1][1]
                                        if ((end_hour > data.getHours() || (end_hour == data.getHours() && end_min >= data.getMinutes()) && start_hour < data.getHours()) ||
                                            start_hour == data.getHours() && start_min <= data.getMinutes()
                                        ) {
                                            this.CancelTimer()
                                            star_end_time_ = end_hour - data.getHours() * 3600 + end_min - data.getMinutes() * 60 - data.getSeconds() + local_timeUtil.getServerTime()
                                            star_end_timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                                                this.SetStarEndTimeText()
                                            }, 1)
                                            this.SetStarEndTimeText()
                                            break
                                        }
                                        i = i + 1
                                    } while ((i < active_time_list.length))
                                }
                            }
                        } else {
                            let i = 0
                            do {
                                let vo = active_time_list[i]
                                let start_hour = vo[0][0]
                                let start_min = vo[0][1]
                                let end_hour = vo[1][0]
                                let end_min = vo[1][1]
                                if (end_hour > data.getHours() ||
                                    (end_hour == data.getHours() && end_min >= data.getMinutes()) &&
                                    (start_hour < data.getHours() || start_hour == data.getHours() && start_min <= data.getMinutes())
                                ) {
                                    this.CancelTimer()
                                    star_end_time_ = end_hour - data.getHours() * 3600 + end_min - data.getMinutes() * 60 - data.getSeconds() + local_timeUtil.getServerTime()
                                    star_end_timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                                        this.SetStarEndTimeText()
                                    }, 1)
                                    this.SetStarEndTimeText()
                                    break
                                }
                                i = i + 1
                            } while ((i < active_time_list.length))
                        }
                    } else {
                        break
                    }
                    i = i + 1
                } while (true)
                this.star_red.visible = true
            } else {
                this.CancelStarEndTimer()
                this.CancelTimer()
                Util.SetImageGray(this.star_btn, true)
                this.star_red.visible = false
                this.GetNextTime()
            }
        }

        this.GetNextTime = () => {
            let data = new Date(local_timeUtil.getServerTime() * 1000)
            let today = data.getDay()
            let min_day_time = null
            let min_region_time = null
            let next_day_time = null
            let next_region_time = null
            let next_data = null
            let i = 1
            do {
                let ac_cfg = local_dailyModel.GetAcCfg(505, 0, i)
                if (ac_cfg) {
                    let open_day_cfg = JSON.parse(ac_cfg.open_day)
                    if (open_day_cfg.length > 0 && local_openDay > Number(open_day_cfg[0][1])) {
                        break
                    }
                    let week_cfg = JSON.parse(ac_cfg.week)
                    let active_time_list = JSON.parse(ac_cfg.time_region)
                    if (week_cfg.length > 0) {
                        let index = 0
                        do {
                            // [ts2lua]week_cfg下标访问可能不正确
                            if (week_cfg[index] > today) {
                                // [ts2lua]week_cfg下标访问可能不正确
                                // [ts2lua]week_cfg下标访问可能不正确
                                next_day_time = week_cfg[index] - today
                                if (next_day_time + local_openDay > open_day_cfg[0][1]) {
                                    break
                                }
                                if (active_time_list.length > 0) {
                                    let start_hour = active_time_list[0][0][0]
                                    let start_min = active_time_list[0][0][1]
                                    next_star_time_ = local_timeUtil.getServerTime() + next_day_time * 86400 + start_hour - data.getHours() * 3600 + start_min - data.getMinutes() * 60 - data.getSeconds()
                                    break
                                }
                            }
                            else if (today == week_cfg[index]) {
                                // [ts2lua]week_cfg下标访问可能不正确
                                let open_time = null
                                let start_hour = null
                                let start_min = null
                                let find = false
                                let i = 0
                                do {
                                    open_time = active_time_list[i]
                                    start_hour = open_time[0][0]
                                    start_min = open_time[0][1]
                                    if (start_hour > data.getHours() || start_hour == data.getHours() && start_min >= data.getMinutes()) {
                                        // [ts2lua]week_cfg下标访问可能不正确
                                        next_day_time = week_cfg[index]
                                        next_region_time = start_min
                                        next_star_time_ = local_timeUtil.getServerTime() + start_hour - data.getHours() * 3600 + start_min - data.getMinutes() * 60 - data.getSeconds()
                                        find = true
                                        break
                                    }
                                    i = i + 1
                                } while ((i < active_time_list.length))
                                if (find) {
                                    break
                                }
                                start_hour = active_time_list[0][0][0]
                                start_min = active_time_list[0][0][1]
                                if (index == week_cfg.length - 1) {
                                    next_day_time = 7 + week_cfg[0] - today
                                    if (next_day_time + local_openDay > open_day_cfg[0][1]) {
                                        break
                                    }
                                    next_star_time_ = local_timeUtil.getServerTime() + next_day_time * 86400 + start_hour - data.getHours() * 3600 + start_min - data.getMinutes() * 60 - data.getSeconds()
                                    break
                                }
                            }
                            else if (today > week_cfg[index] && index == week_cfg.length - 1) {
                                next_day_time = 7 + week_cfg[0] - today
                                let start_hour = active_time_list[0][0][0]
                                let start_min = active_time_list[0][0][1]
                                next_star_time_ = local_timeUtil.getServerTime() + next_day_time * 86400 + start_hour - data.getHours() * 3600 + start_min - data.getMinutes() * 60 - data.getSeconds()
                            }
                            index = index + 1
                        } while ((index < week_cfg.length))
                    } else {
                        if (active_time_list.length > 0) {
                            let start_hour = null
                            let start_min = null
                            let i = 0
                            do {
                                start_hour = active_time_list[i][0][0]
                                start_min = active_time_list[i][0][1]
                                if (start_hour > data.getHours() || start_hour == data.getHours() && start_min >= data.getMinutes()) {
                                    next_day_time = today + 1
                                    next_region_time = start_min
                                    next_star_time_ = local_timeUtil.getServerTime() + start_hour - data.getHours() * 3600 + start_min - data.getMinutes() * 60 - data.getSeconds()
                                    break
                                }
                                i = i + 1
                            } while ((i < active_time_list.length))
                            if (local_openDay + 1 <= open_day_cfg[0][1]) {
                                next_star_time_ =
                                    local_timeUtil.getServerTime() + open_day_cfg[0][0] - local_openDay * 86400 + active_time_list[0][0][0] - data.getHours() * 3600 +
                                    active_time_list[0][0][1] -
                                    data.getMinutes() * 60 -
                                    data.getSeconds()
                            }
                        }
                    }
                    if (next_star_time_ > local_timeUtil.getServerTime()) {
                        star_timer_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
                            this.SetNextTimeText()
                        }, 1)
                        this.SetNextTimeText()
                        return
                    }
                } else {
                    break
                }
                i = i + 1
            } while (true)
        }

        this.SetNextTimeText = () => {
            let time = next_star_time_ - local_timeUtil.getServerTime()
            if (time < 0) {
                this.CancelTimer()
                if (this.ac_state_label) {
                    this.ac_state_label.text = ""
                }
                return
            }
            let tem = 0
            let day = local_math.floor(time / 3600 * 24)
            tem = time % 3600 * 24
            let hours = local_math.floor(tem / 3600)
            tem = tem % 3600
            let min = local_math.floor(tem / 60)
            let s = tem % 60
            let str = null
            if (day > 0) {
                str = `${day}天${hours}小时后开启`//day + "天" + hours + "小时后开启"
            }
            else if (hours > 0) {
                str = `${hours}小时${min}分钟后开启`// hours + "小时" + min + "分钟后开启"
            }
            else if (min > 0) {
                str = `${min}分钟${s}秒后开启`//min + "分钟" + s.. "秒后开启"
            } else {
                str = `${s}秒后开启`// s + "秒后开启"
            }
            if (this.ac_state_label) {
                this.ac_state_label.text = str
            }
        }

        this.CancelTimer = () => {
            if (star_timer_id_) {
                GlobalTimerQuest.CancelQuest(star_timer_id_)
                star_timer_id_ = null
            }
        }

        this.CancelStarEndTimer = () => {
            if (star_end_timer_id_) {
                GlobalTimerQuest.CancelQuest(star_end_timer_id_)
                star_end_timer_id_ = null
            }
        }



        this.UpdateFigure = (scmd?) => {
            if (scmd && scmd.figure) {
                let figure = scmd.figure
                this.PreHtml()
                this.name_label1.text = `【${figure.guild_name}】`
                this.name_label1.color = ColorUtil.GetReplaceChar(ColorUtil.GetColorDark(ColorType.ORANGE))
                this.name_label.innerHTML = figure.name// Util.StrToHTML(HtmlColorTxt("【" + figure.guild_name + "】", ColorUtil.GetColorDark(ColorType.ORANGE)) + figure.name)
                this.tmp_figure = figure
                this.CreateModel(figure)

                this.UpdateHtmlPos()
                //SetHtmlCenter(this.name_label, { x: 190, w: 340 })
            } else {
                this.CreatDefaultModel()
            }
        }

        this.SetModelInfo = () => {
            let ser_num = model.serInfo.mode_num
            if (ser_num != null && this.is_loaded) {
                this.PreHtml2()
                this._html_kf_mode.innerHTML = `当前模式：<font color='#d15e00'>${(ser_num == 1 && ("本") || (ser_num))}服模式</font>`
            }
        }

        this.Dispose = () => {
            this.tmp_figure = null
            if (second_item_) {
                second_item_.DeleteMe()
                second_item_ = null
            }
            if (reward_list_) {
                for (let index in reward_list_) {

                    // [ts2lua]reward_list_下标访问可能不正确
                    reward_list_[index].DeleteMe()
                    // [ts2lua]reward_list_下标访问可能不正确
                    reward_list_[index] = null
                }
            }
            reward_list_ = null
            this.CancelStarEndTimer()
            this.CancelTimer()
            this.CancelTimer1()
            this.ClearModel()
        }

        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50600)
        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50601)
        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50622)
        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50624)
    }

    public DeleteMe() {
        ResManager.GetInstance().ClearRoleMode(this.hashCode)
        this.Dispose()
        super.DeleteMe()
    }


    PreHtml() {
        SetHtmlStyle(this.name_label,{c:"#ffffff",f:20,ww:false,w:220,st:2,stc:"#b85513"})
    }
    PreHtml2() {
        SetHtmlStyle(this._html_kf_mode, { f: 20, c: "#663915", ww: false})
    }


    PreHtml3() {
        SetHtmlStyle(this.tipsLb,{c:"#9b572f",f:20,ww:false,w:720})
    }


_Image1:Laya.Image
_Image_dz:Laya.Image
model_group:Laya.Box
_img_add:Laya.Image
_box_kf:Laya.Box
kfBtn:Laya.Box
_img_kf:Laya.Image
_lb_kf:Laya.Label
_img_bg2:Laya.Image
_html_kf_mode:Laya.HTMLDivElement
_box_wz:Laya.Box
_reward_ls:Laya.Image
_reward_bg:Laya.Image
_img_wz_bg:Laya.Image
_txt_wz:Laya.Text
_reward_bg2:Laya.Image
empty_tag:Laya.Image
wining_img:Laya.Image
end_win_img:Laya.Image
_img_title_bg:Laya.Image
_lb_guildname:Laya.Label
_box_bg:Laya.Box
_img_title_bg2:Laya.Image
_lb_title:Laya.Label
_img_title_bg1:Laya.Image
_lb_title1:Laya.Label
first_group:Laya.Box
second_group:Laya.Box
star_btn:Laya.Box
_Image11111:Laya.Image
labelDisplay:Laya.Label
received_btn:Laya.Box
_Image1111:Laya.Image
labelDisplay11:Laya.Label
star_red:Laya.Image
received_red:Laya.Image
wining_red:Laya.Image
end_win_red:Laya.Image
reward_scroller:Laya.Panel
Content:Laya.HBox
name_label:Laya.HTMLDivElement
name_label1:Laya.Label
wintime_label:Laya.Label
wintime_label2:Laya.Label
ac_state_label:Laya.Label
tipsLb:Laya.HTMLDivElement
_Image6:Laya.Image
public GetComponents() {
[
this._Image1,
this._Image_dz,
this.model_group,
this._img_add,
this._box_kf,
this.kfBtn,
this._img_kf,
this._lb_kf,
this._img_bg2,
this._html_kf_mode,
this._box_wz,
this._reward_ls,
this._reward_bg,
this._img_wz_bg,
this._txt_wz,
this._reward_bg2,
this.empty_tag,
this.wining_img,
this.end_win_img,
this._img_title_bg,
this._lb_guildname,
this._box_bg,
this._img_title_bg2,
this._lb_title,
this._img_title_bg1,
this._lb_title1,
this.first_group,
this.second_group,
this.star_btn,
this._Image11111,
this.labelDisplay,
this.received_btn,
this._Image1111,
this.labelDisplay11,
this.star_red,
this.received_red,
this.wining_red,
this.end_win_red,
this.reward_scroller,
this.Content,
this.name_label,
this.name_label1,
this.wintime_label,
this.wintime_label2,
this.ac_state_label,
this.tipsLb,
this._Image6,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image_dz",
"model_group",
"_img_add",
"_box_kf",
"kfBtn",
"_img_kf",
"_lb_kf",
"_img_bg2",
"_html_kf_mode",
"_box_wz",
"_reward_ls",
"_reward_bg",
"_img_wz_bg",
"_txt_wz",
"_reward_bg2",
"empty_tag",
"wining_img",
"end_win_img",
"_img_title_bg",
"_lb_guildname",
"_box_bg",
"_img_title_bg2",
"_lb_title",
"_img_title_bg1",
"_lb_title1",
"first_group",
"second_group",
"star_btn",
"_Image11111",
"labelDisplay",
"received_btn",
"_Image1111",
"labelDisplay11",
"star_red",
"received_red",
"wining_red",
"end_win_red",
"reward_scroller",
"Content",
"name_label",
"name_label1",
"wintime_label",
"wintime_label2",
"ac_state_label",
"tipsLb",
"_Image6",
])
}
}
 window["GuildFightView"]= GuildFightView