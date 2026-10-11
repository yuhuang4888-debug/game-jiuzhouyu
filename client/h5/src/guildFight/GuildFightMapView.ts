import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetLocalPositionX, SetLocalPositionY, GlobalTimerQuest, SetSizeDeltaY, SetHtmlCenter } from "../util/Util"
import { GuildFightMapItem } from "./GuildFightMapItem"

export class GuildFightMapView extends BaseView1 {

    InitView
    DesFunc
    UpdateItem
    SetKingState
    UpateBtn
    SetAcState
    UpdateSelectState
    //CancelTimer
    cfg_open_week
    OpenDayLessTheFourthDay
    StartTimer
    TimerFunc
    SetlineVisible
    SetResize
    //AddImgToHtml
    public constructor() {
        super()

        this.base_file = "guildFight"
        this.layout_file = "GuildFightMapView"
        this.layer_value = Enum_UILayer.Activity
        this.click_bg_toClose = true
        this.is_center = this.click_bg_toClose
        this.use_background = this.is_center
        this.destroy_imm = true
        this.change_scene_close = true
        this.preload_server_config = { "config_territory": false, "config_territory_mode": false, "config_territory_war_kv": false }
        let gfModel = GuildFightModel
        let model = gfModel.GetInstance()
        let local_event = GuildFightEvent
        let msg = Message
        let roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let local_time = TimeUtil
        let tipsTimer_ = null
        let posList_ = [[-31, 157], [419, 129], [200, 563], [414, 469], [198, 71], [-13, 496]]
        let mapList_ = []
        let tipsTime_ = null
        let selectTer_ = null
        let warState_ = 0
        let canFight_ = false
        let num_2_week = ["日", "一", "二", "三", "四", "五", "六", "日"]
        let num_3_week = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"]
        this.load_callback = () => {
            this.InitView()
            if (model.stateInfo.war_state == 1) {
                gfModel.GetInstance().SetSelectRed(false)
            } else {
                gfModel.GetInstance().SetAcRed(false)
            }
        }

        this.destroy_callback = () => {
            this.DesFunc()
        }

        //this.preload_server_config = [config_territory = false, config_territory_war_kv = false, config_territory_mode = false]
        this.InitView = () => {
            Util.AddClickEvent(
                this.ruleBtn, () => {
                    GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.KFGuildFight)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.fightBtn, () => {
                    if (SceneManager.GetInstance().IsGuildFightScene()) {
                        msg.show("您已经在当前玩法场景")
                    } else {
                        model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50603, "c", 1)
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.enterBtn, () => {
                    let Cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory", false)
                    if (selectTer_) {
                        let name = null
                        // [ts2lua]Cfg下标访问可能不正确
                        let TerCfg = Cfg && Cfg[selectTer_]
                        if (TerCfg) {
                            name = TerCfg.territory_name
                        }
                        Alert.Show(
                            Util.StrToHTML("是否对<font color='#00b11d'>" + name + "</font>进行宣战，宣战一旦确认后不可更改"),
                            Alert_Type.Two, () => {
                                model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50623, "i", selectTer_)
                            }
                        )
                    } else {
                        msg.show("点击领地即可宣战")
                    }
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.cancelBtn, () => {
                    model.selectModel = false
                    this.UpdateSelectState()
                    model.Fire(local_event.UPDATE_SELECT)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.selectBtn, () => {
                    if (model.selectInfo.qualification == 1) {
                        if (roleVo.position == 1) {
                            if (model.selectInfo.is_choose_terri_id == 1) {
                                msg.show("您已经宣战过了")
                            } else {
                                model.selectModel = true
                                this.UpdateSelectState()
                                model.Fire(local_event.UPDATE_SELECT)
                            }
                        } else {
                            msg.show("只有会长可以宣战")
                        }
                    } else {
                        // [ts2lua]this.preload_server_config.config_territory_mode下标访问可能不正确
                        let countCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory_mode", false)[model.serInfo.mode_num]//Config.Territorymode[model.serInfo.mode_num]
                        if (countCfg) {
                            let guild_num = countCfg.guild_num
                            msg.show("本服排名前" + guild_num + "结社才可宣战")
                        } else {
                            msg.show("没有宣战资格")
                        }
                    }
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.UPDATE_TER_INFO, () => {
                    let i = 0
                    do {
                        let item = mapList_[i]
                        if (item) {
                            this.UpdateItem(item, i)
                        }
                        i = i + 1
                    } while ((i < mapList_.length))
                    this.SetKingState()
                    this.UpateBtn()
                }
            )
            this.BindEvent(
                model,
                local_event.SELECT_TER, (id?) => {
                    if (gfModel.kingTerId == id) {
                        this.selectKing.visible = true
                    }
                    else if (this.selectKing.visible) {
                        this.selectKing.visible = false
                    }
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_AC_STATE, () => {
                    this.UpdateSelectState()
                    this.SetAcState()
                }
            )
            this.BindEvent(
                model,
                local_event.UPDATE_ROUND, () => {
                    this.SetAcState()
                }
            )
            Util.AddClickEvent(
                this.towerGp, () => {
                    if (model.selectModel) {
                        if (model.startRound == 3) {
                            model.Fire(local_event.SELECT_TER, gfModel.kingTerId)
                        } else {
                            msg.show("当前领地不可进行宣战")
                        }
                    } else {
                        model.Fire(local_event.GUILDFIGHT_OPEN_VIEW, "GuildFightRewardView", gfModel.kingTerId)
                    }
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.UPDATE_SELECT_STATE, () => {
                    model.selectModel = false
                    this.UpdateSelectState()
                }
            )
            this.BindEvent(
                model,
                local_event.REFRESH_PROTO, () => {
                    model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50624)
                    model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50621)
                }
            )
            model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50621)
            model.Fire(local_event.GUILDFIGHT_REQUEST_PROTO, 50600)
            this.SetAcState()
            // UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this._Group1)
            let i = 0
            do {

                let item = new GuildFightMapItem(this.itemGp)
                item.SetIndex(i + 1)
                item.Load()
                item.ExcuteCallback(() => {
                    let index = item.GetIndex()
                    let inum = index - 1
                    SetLocalPositionX(item.display_obj, posList_[inum][0])
                    SetLocalPositionY(item.display_obj, posList_[inum][1])
                    this.UpdateItem(item, item.GetIndex() - 1)
                })
                //this:UpdateItem(item, i)
                mapList_[i] = item
                i = i + 1
            } while ((i < posList_.length))
            this.UpdateSelectState()
            this.SetKingState()
            this.BindEvent(
                model,
                local_event.SELECT_TER, (terId?) => {
                    selectTer_ = terId
                }
            )
            this.UpateBtn()
            ResManager.GetInstance().SetOutsideImageSprite(this, this.mapBG, GameResPath.GetBigBgPath("ui_Guild_Wars_bg_1.jpg"), true)
            let kvCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory_war_kv", false)[1]   //Config.Territorywarkv[1]
            if (kvCfg) {
                let List = JSON.parse(kvCfg.values)
                if (List && List[0]) {
                    this.cfg_open_week = Number(List[0][0])
                    // if (this.cfg_open_week) {
                    //     this.cfg_open_week = Number(this.cfg_open_week)
                    // }
                }
            }
        }

        this.OpenDayLessTheFourthDay = () => {
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            return open_day <= 4
        }

        this.SetAcState = () => {
            this.PreHtml()
            this.tipsLb.innerHTML = Util.StrToHTML("获得领地战第一名的结社可获得巅峰王城的掌控权")
            this.SetResize()

            
            // let week_str = "周六"
            // if (this.cfg_open_week) {
            //     // if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
            //     //     week_str = TimeUtil.KrDayName(this.cfg_open_week)
            //     // } else if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
            //     //     week_str = "" + num_3_week[this.cfg_open_week]
            //     // } else {
            //     //     week_str = "周" + num_2_week[this.cfg_open_week]
            //     // }

            //     week_str = "周" + num_2_week[this.cfg_open_week]
            // }

            // // 第一场为开服第4天
            // if (this.OpenDayLessTheFourthDay()) {
            //     let week_num = TimeUtil.GetWeekStrByOpenDay(4)
            //     if (week_num) {
            //         week_num = Number(week_num)
            //         // if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
            //         //     week_str = TimeUtil.KrDayName(week_num)
            //         // } else if (PlatformMgr.GetInstance().IsEyouJpPlatform()) {
            //         //     week_str = "" + num_3_week[week_num]
            //         // } else {
            //         //     week_str = `周${num_2_week[week_num]}`
            //         // }
            //         week_str = `周${num_2_week[week_num]}`
            //     }
            // }
            this.ClearUIEffect(this.btnEffectGp)
           // this.CancelTimer()
            //this.tipsLb.innerHTML = Util.StrToHTML("获得领地战第一名的结社可获得巅峰王城的掌控权")
            //this.tipsLb.innerHTML = Util.StrToHTML("每<font color=\"#00b11d\">" + week_str + "04:00</font>公布领地战资格,<font color=\"#00b11d\">点击领地</font>查看奖励")
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
                    if (fail == 1 && model.roundInfo.round_end_time && model.roundInfo.round_end_time > local_time.getServerTime() || !fail) {
                        warState_ = 4
                        //this.tipsLb.innerHTML = Util.StrToHTML("您的结社本轮暂无参战资格")
                        //this.SetResize()
                        return
                    }
                } else {
                    for (let key in model.terInfo) {

                        // [ts2lua]model.terInfo下标访问可能不正确
                        let Vo = model.terInfo[key]
                        if ((Vo.a_guild == myGuild || Vo.b_guild == myGuild) && (!Vo.winner || Vo.winner == 0)) {
                            // [ts2lua]this.preload_server_config.config_territory下标访问可能不正确
                            let TerCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory", false)[Vo.territory_id] // Config.Territory[Vo.territory_id]
                            // [ts2lua]lua中0和空字符串也是true，此处model.serInfo.mode_num == 1需要确认
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
                //this.StartTimer()
            }
            else if (warState_ == 2) {
                tipsTime_ = model.stateInfo.start_time
                //this.StartTimer()
            }
            else if (warState_ == 1) {
                tipsTime_ = model.stateInfo.ready_time
               // this.StartTimer()
            } else {
                //this.tipsLb.innerHTML = Util.StrToHTML("每<font color=\"#00b11d\">" + week_str + "04:00</font>公布领地战资格,<font color=\"#00b11d\">点击领地</font>查看奖励")
            }
            this.UpateBtn()

            //this.tipsLb.innerHTML=this.AddImgToHtml("resource/game/common/texture/com_tips_3.png")

            //this.SetResize()
        }

        this.SetResize = () => {
            let allW = 20 + this.tipsLb.contextWidth + 5
            let sx = (this.display_obj.width - allW) / 2
            this._Image6.x = sx
            this.tipsLb.x = sx + 25
        }

        // this.TimerFunc = () => {
        //     if (this.tipsLb && !this.use_delete_method) {
        //         if (tipsTime_ && tipsTime_ >= local_time.getServerTime()) {
        //             if (warState_ == 3) {
        //                 this.tipsLb.innerHTML = Util.StrToHTML("本轮领地争夺战正在进行中,当前剩余时间<font color=\"#00b11d\">(" + (tipsTime_ - local_time.getServerTime()) + ")秒</font>")
        //             }
        //             else if (warState_ == 2) {
        //                 this.tipsLb.innerHTML = Util.StrToHTML("<font color=\"#00b11d\">" + (tipsTime_ - local_time.getServerTime()) + "秒</font>后开始领地争夺，参战结社请准时入场")
        //             }
        //             else if (warState_ == 1) {
        //                 if (model.selectModel) {
        //                     this.tipsLb.innerHTML = Util.StrToHTML("点击选中领地确认后即可进行宣战 剩余时间:<font color=\"#00b11d\">" + (local_time.convertTime(tipsTime_ - local_time.getServerTime())) + "</font>")
        //                 } else {
        //                     // [ts2lua]this.preload_server_config.config_territory_mode下标访问可能不正确
        //                     let countCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory_mode", false)[model.serInfo.mode_num]//Config.Territorymode[model.serInfo.mode_num]
        //                     if (countCfg) {
        //                         let guild_num = countCfg.guild_num
        //                         this.tipsLb.innerHTML =
        //                             Util.StrToHTML(
        //                                 "排行<font color=\"#00b11d\">前" + guild_num + "的</font>结社可进行宣战 剩余时间:<font color=\"#00b11d\">" + (local_time.convertTime(tipsTime_ - local_time.getServerTime())) + "</font>"
        //                             )
        //                     }
        //                 }
        //             }
        //             else if (warState_ == 4) {
        //                 this.tipsLb.innerHTML = Util.StrToHTML("<font color=\"#00b11d\">" + (tipsTime_ - local_time.getServerTime()) + "秒</font>后开启下一轮领地的争夺,参战结社请准时入场")
        //             }
        //         } else {
        //             this.CancelTimer()
        //         }
        //     }


        // }


        // this.StartTimer = () => {

        //     this.CancelTimer()
        //     tipsTimer_ = GlobalTimerQuest.AddPeriodQuest(() => {
        //         this.TimerFunc()
        //     }, 1)
        //     this.TimerFunc()
        // }

        // this.CancelTimer = () => {
        //     if (tipsTimer_) {
        //         GlobalTimerQuest.CancelQuest(tipsTimer_)
        //         tipsTimer_ = null
        //     }
        // }

        this.SetKingState = () => {
            this.ClearUIEffect(this.effectGp)
            let data= model.terInfo[gfModel.kingTerId]

            //测试数据
            // let myGuild = 110//roleVo.guild_id
            // let data
            // data = {}
            // data.winner = 110
            // data.a_guild = 110
            // data.a_guild_name = "AAAA"
            // data.b_guild = 119
            // data.b_guild_name = "BBBB"
            // data.a_server_num = 110
            // data.b_server_num = 120

            if (data) {
                this._lb_qua.text = ""
                this.PreHtml()
                this.king2Lb.visible = true
                this.king1Lb.visible = true
                // this.rightKBG.visible = true
                this.leftKBG.visible = true


                let twofight = data.winner == 0 && (data.a_guild && data.a_guild != 0) && (data.b_guild && data.b_guild != 0)
                //!(data.winner != 0) && !(not(data.a_guild && data.a_guild != 0 && data.b_guild && data.b_guild != 0))

                this.vsImg.visible = twofight
                let height = (twofight && (61) || (29))
                SetSizeDeltaY(this.leftKBG, height)
                this.selectKing.visible = (!twofight && (data.a_guild != null || data.a_guild != 0 || data.b_guild != null || data.b_guild != 0) && false)
                //let win = null
                let myGuild = roleVo.guild_id
                if (data.winner != null && data.winner != 0) {
                    if (data.winner == data.a_guild) {
                        this._lb_qua.text = `占领:S${data.a_server_num}.${data.a_guild_name}`
                        //win = "占领:S" + data.a_server_num + "." + data.a_guild_name
                    }
                    else if (data.winner == data.b_guild) {
                        this._lb_qua.text = `占领:S${data.b_server_num}.${data.b_guild_name}`
                        //win = "占领:S" + data.b_server_num + "." + data.b_guild_name
                    }

                    this.king1Lb.innerHTML = ``
                    this.king2Lb.innerHTML = ``
                    this.leftKBG.visible = false
                } else {
                    //因为王城不用手动宣战了，所以直接空字符
                    if (twofight) {
                        this.king1Lb.innerHTML = data.a_guild ? `S${data.a_server_num}.${data.a_guild_name}` : ""
                        this.king2Lb.innerHTML = data.b_guild ? `S${data.b_server_num}.${data.b_guild_name}` : ""
                    } else {
                        if (data.a_guild) this.king1Lb.innerHTML = `S${data.a_server_num}.${data.a_guild_name}`
                        if (data.b_guild) this.king1Lb.innerHTML = `S${data.b_server_num}.${data.b_guild_name}`
                        this.king2Lb.innerHTML = ""
                    }

                }



                this.lockImg.visible = false
                this.kingShaow.visible = false
                // [ts2lua]lua中0和空字符串也是true，此处model.serInfo.mode_num == 1需要确认
                if ((((model.stateInfo.war_state == 3 && (data.a_guild == myGuild || data.b_guild == myGuild)) && !data.winner) && model.roundInfo.round_end_time > local_time.getServerTime() + 2) &&
                    model.roundInfo.round == (model.serInfo.mode_num == 1 && (2) || (3))
                ) {
                    this.AddUIEffect("ui_swordglow", this.effectGp, null, null, true)
                    //this.AddUIEffect("UI_2017", this.layer_value, this.effectGp, null, null, true, { custom_sorting_order = this.cur_sorting_order })
                }
            } else {
                this.king2Lb.visible = false
                this.king1Lb.visible = false
                this.vsImg.visible = false
                // this.rightKBG.visible = false
                this.leftKBG.visible = false
                this.lockImg.visible = true
                this.kingShaow.visible = true
                this._lb_qua.text = ""
            }


            SetHtmlCenter(this.king2Lb, { x: 89, w: 161 })
            SetHtmlCenter(this.king1Lb, { x: 89, w: 161 })
        }

        this.SetlineVisible = (line?, show?) => {
            this["line" + (line + 7)].visible = show
            //this["line" + (line + 1)].visible = show
        }

        this.UpdateItem = (item?, i?) => {
            // [ts2lua]model.terInfo下标访问可能不正确
            let TerData = model.terInfo[1001 + i]
            // [ts2lua]this.preload_server_config.config_territory下标访问可能不正确
            let Cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory", false)[1001 + i]//Config.Territory[1001 + i]
            if (TerData) {
                let canPick = (Cfg.round == model.startRound && !(TerData.a_guild && TerData.a_guild != 0 && TerData.b_guild && TerData.b_guild != 0)) && !(TerData.winner != 0)
                // [ts2lua]TerData下标访问可能不正确
                TerData["canPick"] = canPick
                item.SetState(TerData)
                this.SetlineVisible(i, true)
            } else {
                if (Cfg.round < model.startRound) {
                    item.SetState({})
                    item.SetVisible(false)
                    this.SetlineVisible(i, false)
                } else {
                    if (Cfg.round == model.startRound) {
                        item.SetState({ territory_id: Cfg.territory_id, canPick: true })
                    } else {
                        item.SetState({ canPick: false })
                    }
                    item.SetVisible(true)
                    this.SetlineVisible(i, true)
                }
            }
        }

        this.UpdateSelectState = () => {
            let selectBool = model.selectModel
            if (model.stateInfo.war_state == 1) {
                this.fightBtn.visible = false
                this.enterBtn.visible = selectBool
                this.cancelBtn.visible = selectBool
                this.ruleBtn.visible = !selectBool
                this.selectBtn.visible = !selectBool
            } else {
                this.cancelBtn.visible = false
                this.enterBtn.visible = false
                this.selectBtn.visible = false
                this.ruleBtn.visible = true
                this.fightBtn.visible = true
            }
            this.selectRed.visible = (model.select_red&&model.select_red_login) && !selectBool
            if (model.stateInfo.war_state == 1) {
                let selectInfo = model.selectInfo
                if (selectInfo.qualification == 1 && selectInfo.is_choose_terri_id == 1) {
                    Util.SetImageGray(this._Image11, true)
                    this.labelDisplay11.text = "已宣战"
                    this.labelDisplay11.stroke = 0
                } else {
                    Util.SetImageGray(this._Image11, false)
                    this.labelDisplay11.text = "宣战"
                    this.labelDisplay11.stroke = 2
                }
            }
        }

        this.UpateBtn = () => {
            let myGuild = roleVo.guild_id
            let show = false
            let info = model.terInfo
            for (let key in info) {

                // [ts2lua]info下标访问可能不正确
                // [ts2lua]info下标访问可能不正确
                // [ts2lua]info下标访问可能不正确
                if ((!show && (info[key].a_guild == myGuild || info[key].b_guild == myGuild)) && !info[key].winner) {
                    show = true
                }
            }
            canFight_ = show
            if (show && warState_ == 3) {
                this.AddUIEffect("ui_awaken_buttonglow", this.btnEffectGp, null, { x: 1.7, y: 1.5 }, true)
            }
        }

        this.DesFunc = () => {
            if (mapList_) {
                for (let _tmpi in mapList_) {
                    var vo = mapList_[_tmpi]
                    vo.DeleteMe()
                }
                mapList_ = []
            }
            model.selectModel = false
            selectTer_ = null
            //this.CancelTimer()
            this.ClearUIEffect(this.btnEffectGp)
            this.ClearUIEffect(this.effectGp)
        }
    }

    PreHtml() {
        this.tipsLb.style.color = "#9b572f"
        this.tipsLb.style.fontSize = 20
        this.tipsLb.width = 620

        this.king1Lb.style.color = "#ffec13"
        this.king1Lb.style.fontSize = 16
        this.king1Lb.width = 200

        this.king2Lb.style.color = "#ffec13"
        this.king2Lb.style.fontSize = 16
        this.king2Lb.width = 200
    }


    public DeleteMe() {

        super.DeleteMe()
    }



    _Image1: Laya.Image
    _Image2_title: Laya.Image
    _lb_win_name: Laya.Label
    mapBG: Laya.Image
    line12: Laya.Image
    line11: Laya.Image
    line10: Laya.Image
    line9: Laya.Image
    line8: Laya.Image
    line7: Laya.Image
    line1: Laya.Image
    line2: Laya.Image
    line3: Laya.Image
    line4: Laya.Image
    line5: Laya.Image
    line6: Laya.Image
    itemGp: Laya.Box
    closeBtn: Laya.Image
    towerGp: Laya.Box
    kingTower: Laya.Image
    selectKing: Laya.Image
    kingShaow: Laya.Image
    leftKBG: Laya.Image
    vsImg: Laya.Image
    _nameImg: Laya.Image
    _lb_name: Laya.Label
    lockImg: Laya.Image
    effectGp: Laya.Box
    king1Lb: Laya.HTMLDivElement
    king2Lb: Laya.HTMLDivElement
    _lb_qua: Laya.Label
    ruleBtn: Laya.Box
    _Image111111: Laya.Image
    labelDisplay1: Laya.Label
    cancelBtn: Laya.Box
    _Image11111: Laya.Image
    labelDisplay111: Laya.Label
    fightBtn: Laya.Box
    _Image1111: Laya.Image
    labelDisplay: Laya.Label
    selectBtn: Laya.Box
    _Image11: Laya.Image
    labelDisplay11: Laya.Label
    enterBtn: Laya.Box
    _Image111: Laya.Image
    labelDisplay1111: Laya.Label
    btnEffectGp: Laya.Box
    selectRed: Laya.Image
    _Image6: Laya.Image
    tipsLb: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._Image1,
            this._Image2_title,
            this._lb_win_name,
            this.mapBG,
            this.line12,
            this.line11,
            this.line10,
            this.line9,
            this.line8,
            this.line7,
            this.line1,
            this.line2,
            this.line3,
            this.line4,
            this.line5,
            this.line6,
            this.itemGp,
            this.closeBtn,
            this.towerGp,
            this.kingTower,
            this.selectKing,
            this.kingShaow,
            this.leftKBG,
            this.vsImg,
            this._nameImg,
            this._lb_name,
            this.lockImg,
            this.effectGp,
            this.king1Lb,
            this.king2Lb,
            this._lb_qua,
            this.ruleBtn,
            this._Image111111,
            this.labelDisplay1,
            this.cancelBtn,
            this._Image11111,
            this.labelDisplay111,
            this.fightBtn,
            this._Image1111,
            this.labelDisplay,
            this.selectBtn,
            this._Image11,
            this.labelDisplay11,
            this.enterBtn,
            this._Image111,
            this.labelDisplay1111,
            this.btnEffectGp,
            this.selectRed,
            this._Image6,
            this.tipsLb,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2_title",
                "_lb_win_name",
                "mapBG",
                "line12",
                "line11",
                "line10",
                "line9",
                "line8",
                "line7",
                "line1",
                "line2",
                "line3",
                "line4",
                "line5",
                "line6",
                "itemGp",
                "closeBtn",
                "towerGp",
                "kingTower",
                "selectKing",
                "kingShaow",
                "leftKBG",
                "vsImg",
                "_nameImg",
                "_lb_name",
                "lockImg",
                "effectGp",
                "king1Lb",
                "king2Lb",
                "_lb_qua",
                "ruleBtn",
                "_Image111111",
                "labelDisplay1",
                "cancelBtn",
                "_Image11111",
                "labelDisplay111",
                "fightBtn",
                "_Image1111",
                "labelDisplay",
                "selectBtn",
                "_Image11",
                "labelDisplay11",
                "enterBtn",
                "_Image111",
                "labelDisplay1111",
                "btnEffectGp",
                "selectRed",
                "_Image6",
                "tipsLb",
            ])
    }
}
window["GuildFightMapView"] = GuildFightMapView