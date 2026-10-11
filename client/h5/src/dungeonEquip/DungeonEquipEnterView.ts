
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel, GuildEvent, GuildAssistType } from "../commonModel/GuildModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPositionY, SetSizeDeltaX, HtmlColorTxt, GlobalTimerQuest, SetHtmlCenter } from "../util/Util"
import { DungeonEquipDefine } from "./DungeonEquipDefine"
import { DungeonEquipRoleItem } from "./DungeonEquipRoleItem"
import { DungeonEquipTabItem } from "./DungeonEquipTabItem"
import { DungeonEquipTeamItem } from "./DungeonEquipTeamItem"
import "../dungeonEquip/DungeonEquipClumpApplyItem"
import "../dungeonEquip/DungeonEquipClumpInviteItem"
import "../dungeonEquip/DungeonEquipClumpView"
import "../dungeonEquip/DungeonEquipDefine"
import "../dungeonEquip/DungeonEquipFightSceneItem"
import "../dungeonEquip/DungeonEquipNoneView"
import "../dungeonEquip/DungeonEquipRoleItem"
import "../dungeonEquip/DungeonEquipTabItem"
import "../dungeonEquip/DungeonEquipTeamHeadItem"
import "../dungeonEquip/DungeonEquipTeamItem"
import { GameResPath } from "../util/GameResPath"
import { Config } from "../common/Config"
import { SceneManager } from "../scene/SceneManager"
import { HaloModel, HaloPrivilegeType } from "../commonModel/HaloModel"
import { AdModuleId, WelfareEvent, WelfareModel } from "../commonModel/WelfareModel"

export class DungeonEquipEnterView extends BaseItem1 {
    BuildTeam
    CancelCountTime
    CheckInitTabLoopMgr
    Dispose
    Emp_gp_enter
    Emp_gp_match
    EnterFunc
    InitEvent
    InitTeamEvent
    LoadSuccess
    MatchFunc
    PopItem
    RefreshApplyRed
    RefreshTab
    Scr_Scroller1
    Scr_Scroller2
    Scr_Scroller3
    
    StartCountTime
    SwitchTab
    TabEventFunc
    UpdateAutoAddState
    UpdateBtn
    UpdateHallData
    UpdateHelpData
    UpdateHelpState
    UpdateMatchState
    UpdateTeamInfo
    UpdateTeamState
    UpdateView
    ScrollToIndex
    GetImgResouce
    InitHalo
    UpdateHalo
    UpdateMergeCheckBox
    InitAd
	UpdateAd


    merge_check
    roomcon_loop_mgr
    story_obj_list
    tabcon_loop_mgr

    public static ShowType = { hall: 0, room: 1 }
    public static RolePos = [[244, 102], [33, 191], [450, 191]]
    public static EQUIP_TYPE = 5
    public constructor(parent?) {
        super(parent)

        this.base_file = "dungeonEquip"
        this.layout_file = "DungeonEquipEnterView"
        let model = BaseDungeonModel.GetInstance()
        let team_model = TeamModel.GetInstance()
        let role_mgr = RoleManager.GetInstance()
        let local_BaseDungeonModel = BaseDungeonModel
        let local_DungeonEquipDefine = DungeonEquipDefine
        let local_TeamEvent = TeamEvent
        let local_DungeonEquipEnterView = DungeonEquipEnterView
        let local_Util = Util
        let local_Number = Number
        let goods_model = GoodsModel.GetInstance()
        let REQUEST_PROTO = TeamEvent.TEAM_REQUEST_PROTO
        let local_Message = Message
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        let FinDunType = TaskTipType.FinDunType
        let local_DUN_TYPE = DUN_TYPE
        let show_type_ = null
        let tabcon_list = null
        let roomcon_list = null
        let default_index_ = null
        let now_index_ = null
        let now_dun_id_ = null
        let now_dun_data_ = null
        let reward_item_list_ = null
        let role_item_list_ = null
        let click_time_ = null
        let time_id_ = null
        let request_dunid = 0

        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image7, GameResPath.GetIcon("dungeonEquip", "ui_copy_24"))
            this._Scroller1.hScrollBarSkin = ""
            this.PreHtml2()
            this.PreHtml1()
            this.LoadSuccess()
        }

        this.createChildren = () => {
            if (this["GetComponents"]) {
                this["GetComponents"]()
                this.is_get = true
            }
            this.story_obj_list = this.story_obj_list || {}
            this.story_obj_list[FinDunType] = this.story_obj_list[FinDunType] || {}
            this.story_obj_list[FinDunType][local_DUN_TYPE.Equip] = [this._gp_match]
            super.createChildren()
        }

        this.CheckInitTabLoopMgr = (tab_list?) => {
            tabcon_list = tab_list || []
            if (!this.tabcon_loop_mgr) {
                this.tabcon_loop_mgr = new LoopScrowViewMgr()

                var SelectFunc = (item) => {
                    if (this.TabEventFunc) {
                        this.TabEventFunc(item)
                    }
                }
                this.tabcon_loop_mgr.SetData(this.Content1, DungeonEquipTabItem, tabcon_list, LoopScrCon.Vertical, 1, SelectFunc)
            } else {
                this.tabcon_loop_mgr.replaceAll(tabcon_list)
            }


            this.ScrollToIndex()

        }

        this.ScrollToIndex = () => {
            //默认滑动到开启的标签
            let defaultIndex = 0;
            let len = tabcon_list.length
            for (let i = 0; i < len; i++) {
                if (tabcon_list[i].state) {
                    defaultIndex = i
                }
            }
            this.tabcon_loop_mgr.SetSelectIndex(defaultIndex)
            defaultIndex = defaultIndex <= 6 ? 0 : 6
            this.Content1.scrollTo(defaultIndex)
        }

        this.LoadSuccess = () => {
            request_dunid = 0
            let main_role_level = role_mgr.GetMainRoleVo().level
            this.RefreshTab()
            this.UpdateTeamState()
            this.UpdateMatchState()
            this.RefreshApplyRed()
            this.InitEvent()
            model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61011, local_DungeonEquipDefine.HelpDunId)
            this.StartCountTime(() => {
                if (now_index_ != null) {
                    let sub_type = now_index_ + 1
                    team_model.Fire(REQUEST_PROTO, 24012, "cci", local_DungeonEquipDefine.TeamType, sub_type, 0)
                }
            },
                local_DungeonEquipDefine.RefreshRoomInterval
            )

            this._btn_help.visible = GuildModel.GetInstance().IsCanOpenAssist()


            this.InitHalo()
            this.InitAd()
        }

        this.InitHalo = () => {
            //光环
            this.UpdateHalo()
            Util.AddClickEvent(this._lb_halo_tips, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
            }, this, false)

            Util.AddClickEvent(this._img_merge_count, () => {
                if(!HaloModel.GetInstance().CheckPrivilegeOpenState(HaloPrivilegeType.DungeonSweep)){
                    return
                }
                let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.DungeonSweep, DUN_TYPE.Equip)
                if (!state) {
                    let str = "勾选后,本次副本将合并所有次数进入.<br>是否确认勾选?"
                    let content = Util.StrToHTML(str)
                    Alert.Show(
                        content,
                        Alert_Type.Two, () => {
                            HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.DungeonSweep, DUN_TYPE.Equip, 1)
                        }
                    )
                } else {
                    HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.DungeonSweep, DUN_TYPE.Equip, 0)
                }
            }, this, true)

            this.BindEvent(HaloModel.GetInstance(), HaloModel.RecvFmt51302, (id, type) => {
                    if(id == HaloPrivilegeType.DungeonSweep && DUN_TYPE.Equip == type){
                        this.UpdateMergeCheckBox()
                    }
                }
            )
            this.UpdateMergeCheckBox()
        }

        this.UpdateHalo = () => {
            if (HaloModel.GetInstance().GetOpenState()) {
                this._box_halo.visible = true
                if (HaloModel.GetInstance().GetHaloOpenState()) {
                    this._img_merge_count.visible = true
                    this._lb_halo_tips.visible = false
                }
                else {
                    this._img_merge_count.visible = false
                    this._lb_halo_tips.visible = true
                }
            }
            else {
                this._box_halo.visible = false
            }
        }

        this.UpdateMergeCheckBox = () => {
            let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.DungeonSweep, DUN_TYPE.Equip)
            this._img_merge_count.skin = GameResPath.GetIcon("common", state && "com_ui_gx1" || "com_ui_gx")
        }

        this.InitAd = () =>{
			if (!WelfareModel.GetInstance().GetAdOpenState()) {
				return
			}
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_ad, GameResPath.GetIcon("advertising", "ui_fllb_08"))
			Util.AddClickEvent(this._img_ad, () => {
				let ad_cfg = WelfareModel.GetInstance().GetAdCfg(AdModuleId.DungeonEquip)
				if(ad_cfg){
					WelfareModel.GetInstance().PlayAdAlert(ad_cfg, "观看完影片可再获得一次免费次数！")
				}
			}, this, true)

			this.BindEvent(WelfareModel.GetInstance(), WelfareEvent.UPDATE_AD_STATE, () => {
				this.UpdateAd()
			})
			this.UpdateAd()
		}

		this.UpdateAd = () =>{
			this._img_ad.visible = !WelfareModel.GetInstance().GetAdLookStateByMoudleId(AdModuleId.DungeonEquip)
		}

        this.RefreshTab = () => {
            let role_lv = role_mgr.GetMainRoleVo().level
            let list = []
            let teamui_cfg = Config.PRELOAD_SERVER_CONFIG.config_team_ui

            //不清楚多少个副本 99个目测够用 
            for (let i = 1; i < 100; i++) {
                let key = `${local_DungeonEquipEnterView.EQUIP_TYPE}@${i}`
                let data_cfg = teamui_cfg[key]

                //{ dun_id: 5013, img_source: "ui_copy_31", teamui_key: "5@13", lv: 700 }
                if (data_cfg) {
                    let obj = {
                        dun_id: data_cfg.dun_id,
                        img_source: this.GetImgResouce(i),
                        lv: data_cfg.default_lv_min,
                        state: role_lv >= data_cfg.default_lv_min
                    }
                    table.insert(list, obj)
                } else {
                    break
                }
            }
            tabcon_list = list
            this.CheckInitTabLoopMgr(tabcon_list)
        }


        this.GetImgResouce = (index) => {
            let img_resouce = ""
            switch (index) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                    img_resouce = "ui_copy_27"
                    break;
                case 6:
                case 7:
                    img_resouce = "ui_copy_28"
                    break;
                case 8:
                case 9:
                    img_resouce = "ui_copy_29"
                    break;
                case 10:
                case 11:
                    img_resouce = "ui_copy_30"
                    break;
                case 12:
                case 13:
                    img_resouce = "ui_copy_31"
                    break;
                default:
                    img_resouce = "ui_copy_31"
                    break;
            }
            return img_resouce
        }

        this.PopItem = () => {
            this._gp_hall.visible = show_type_ == local_DungeonEquipEnterView.ShowType.hall
            this._gp_room.visible = show_type_ == local_DungeonEquipEnterView.ShowType.room
        }

        this.UpdateView = () => {
            let equip_data = model.GetDungeonInfo(DUN_TYPE.Equip)
            if (equip_data) {
                let data = null
                for (let _tmpi in equip_data) {
                    var vo = equip_data[_tmpi]
                    if (vo.dun_id == now_dun_id_) {
                        data = vo
                        break
                    }
                }
                now_dun_data_ = data
                if (data) {
                    this._lb_fighting.width = 450
                    this._lb_times.width = 450

                    let color1 = "'#d85d03'"
                    let sp_name = local_DungeonEquipDefine.LevelTips[now_dun_id_]
                    this._txt_title1.text = `寻装觅刃（${sp_name}）`

                    let my_fighting = role_mgr.GetMainRoleVo().fighting
                    let recommend_power = data.recommend_power
                    let desc = "单刷战力:"
                    desc = desc + HtmlColorTxt(recommend_power, (my_fighting >= recommend_power && (ColorUtil.GetColorDark(ColorType.GREEN)) || (ColorUtil.GetColorDark(ColorType.RED))))
                    desc = desc + HtmlColorTxt(`(我的战力:${my_fighting})`, color1)
                    this._lb_fighting.innerHTML = Util.StrToHTML(desc)
                    let total_count = local_Number(data.count_cond) + data.add_count + data.vip_count
                    let left_times = total_count - data.daily_count
                    let desc0 = "挑战次数:"
                    desc0 = desc0 + HtmlColorTxt(left_times, (left_times > 0 && (color1) || (ColorUtil.GetColorDark(ColorType.RED))))
                    desc0 = desc0 + HtmlColorTxt("/" + total_count, color1)
                    this._lb_times.innerHTML = Util.StrToHTML(desc0)
                    let reward_list = []
                    if (data.reward) {
                        reward_list = JSON.parse(data.reward)

                        if (reward_list) {
                            let main_role = RoleManager.GetInstance().GetMainRoleVo()
                            let career = main_role.career

                            let tmp_reward_list = null
                            for (let key in reward_list) {
                                var reward = reward_list[key]
                                if (reward[0] && Number(reward[0]) == career) {
                                    tmp_reward_list = reward[1]
                                    break
                                }
                            }
                            if (tmp_reward_list) {
                                reward_list = tmp_reward_list
                            }
                        }

                    }
                    if (!reward_item_list_) {
                        reward_item_list_ = []
                    }
                    for (let _ = 0; _ < reward_item_list_.length; _++) {
                        var reward_item = reward_item_list_[_]
                        reward_item.includeInLayout = false
                        reward_item.SetVisible(reward_item.includeInLayout)
                    }
                    let index = 0

                    for (let key in reward_list) {
                        let vo = reward_list[key]
                        let type_id, lock
                        [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
                        let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
                        if (goods_vo) {
                            let item = reward_item_list_[index]
                            if (!item) {
                                item = new EquipmentItem(this.Content11, null, this.layer_value)
                                reward_item_list_[index] = item
                                item.SetItemSize(89, 89)
                                item.SetUseMask(true)
                                item.Load()
                            }
                            item.SetData(goods_vo.type_id, vo[2], lock)
                            item.SetVisible(true)
                            index = index + 1
                        }
                    }
                }
            }
            team_model.Fire(REQUEST_PROTO, 24049, "i", now_dun_id_)
        }

        this.SwitchTab = (index?) => {
            if (now_index_ == index) {
                return
            }
            let data = tabcon_list[index]
            if (data && !data.state) {
                let lv = (data.lv > 370 && (`神创${(data.lv - 370)}`) || (data.lv))
                let str = `${lv}级开启`
                local_Message.show(str)
                this.tabcon_loop_mgr.SetSelectIndex(now_index_)
                return
            }
            now_index_ = index
            if (tabcon_list[index]) {
                now_dun_id_ = tabcon_list[index].dun_id
                team_model.Fire(REQUEST_PROTO, 24012, "cci", local_DungeonEquipDefine.TeamType, index, 0)
            }
            this.UpdateView()
        }

        this.InitEvent = () => {

            this.BindEvent(GuildModel.GetInstance(), GuildEvent.CHANGED_CONDS_ASSIST, () => {
                this._btn_help.visible = GuildModel.GetInstance().IsCanOpenAssist()
            })


            this.BindEvent(
                model,
                local_BaseDungeonModel.UPDATE_HELP_DATA, (dun_id?) => {
                    if (dun_id == local_DungeonEquipDefine.HelpDunId) {
                        this.UpdateHelpData()
                    }
                }
            )
            Util.AddClickEvent(
                this._gp_enter, () => {
                    if (SceneManager.GetInstance().IsSuitBossScene()) {
                        Message.show("当前场景不能进入")
                        return
                    }
                    this.EnterFunc()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._gp_match, () => {
                    if (SceneManager.GetInstance().IsSuitBossScene()) {
                        Message.show("当前场景不能匹配")
                        return
                    }
                    this.MatchFunc()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._img_clump, () => {
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEquipClumpView", now_dun_id_)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._img_help, () => {
                    // [ts2lua]team_model.help_data下标访问可能不正确
                    let state = team_model.help_data && team_model.help_data[now_dun_id_]
                    if (state == 2) {
                        Message.show("协助状态无法助战")
                    }
                    else if (state == 1) {
                        team_model.Fire(REQUEST_PROTO, 24033, "ic", now_dun_id_, 0)
                    } else {
                        let rdata = GuildModel.GetInstance().GetReqData()
                        if (rdata) {
                            Message.show("协助状态无法助战")
                        } else {
                            team_model.Fire(REQUEST_PROTO, 24033, "ic", now_dun_id_, 1)
                        }
                    }
                },
                this,
                true
            )

            this._lb_create_team.text = `点击创建队伍`
            Util.AddClickEvent(
                this._lb_create_team, () => {
                    if (team_model.GetAutoMatch()) {
                        local_Message.show("正在匹配中～")
                        return
                    }
                    this.BuildTeam()
                },
                this,
                true
            )
            //this._lb_honer.text = Util.StrToHTML("<font color='#4A3A32'>荣耀</font>")
            //AddUnderlineText(this._lb_honer, this._lb_honer, "#4A3A32", 6, 7)
            Util.AddClickEvent(
                this._lb_honer, () => {
                    UIToolTipMgr.GetInstance().DefaultAppendTips(local_DungeonEquipDefine.HonerId, 0)
                },
                this,
                true
            )
            Util.AddClickEvent(
                this._img_gx, () => {
                    let team_info = team_model.team_info
                    if (team_info) {
                        // [ts2lua]lua中0和空字符串也是true，此处team_info.join_type == 1需要确认
                        let index = (team_info.join_type == 1 && (2) || (1))
                        team_model.Fire(REQUEST_PROTO, 24018, "c", index)
                    }
                },
                this,
                true
            )
            this.InitTeamEvent()
            Util.AddClickEvent(
                this._btn_help, () => {

                    let is_open = GuildModel.GetInstance().IsOpenAssist(GuildAssistType.TYPE_DUNGEON_EQUIP)
                    if (!is_open) {
                        Message.show(`${GuildModel.GetInstance().GetAssistOpenDesc(GuildAssistType.TYPE_DUNGEON_EQUIP)}`)
                        return
                    }


                    if (!now_dun_id_) {
                        return
                    }
                    if (show_type_ != DungeonEquipEnterView.ShowType.room) {
                        request_dunid = now_dun_id_
                        if (team_model.GetAutoMatch()) {
                            local_Message.show("正在匹配中～")
                            return
                        }
                        this.BuildTeam()
                    } else {
                        GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 2, DUN_TYPE.Equip, now_dun_id_, 0)
                    }

                },
                this,
                true
            )

            let update_view = (dun_type?) => {
                if (dun_type == DUN_TYPE.Equip) {
                    this.UpdateView()
                }
            }
            this.BindEvent(model, BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, update_view)
        }



        this.UpdateMatchState = () => {
            let team_info = team_model.team_info
            if (team_info && team_info.activity_id == local_DungeonEquipDefine.TeamType) {
                // [ts2lua]lua中0和空字符串也是true，此处team_model:GetAutoMatch()需要确认
                this._lb_match.text = team_model.GetAutoMatch() && "取消匹配" || "自动匹配"
            } else {
                this._lb_match.text = "自动匹配"
            }
        }

        this.MatchFunc = () => {
            let team_info = team_model.team_info
            if (team_info) {
                if (team_info.activity_id != local_DungeonEquipDefine.TeamType) {
                    let call_back = () => {
                        team_model.quit_team_match = local_DungeonEquipDefine.TeamType
                        team_model.Fire(REQUEST_PROTO, 24005)
                    }

                    Alert.Show("当前队伍目标不是寻装觅刃<br>是否退出队伍匹配", Alert_Type.Two, call_back, null, "毅然前往", "我再想想", null, null, null, null, null, null, null, null, null, null, false)
                    return
                }
                let auto_match = team_model.GetAutoMatch()
                if (auto_match) {
                    team_model.Fire(REQUEST_PROTO, 24048, "c", 0)
                } else {
                    if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
                        if (team_info.team_member_list.length == local_DungeonEquipDefine.MaxNum) {
                            let sub_type = now_index_ + 1
                            team_model.Fire(REQUEST_PROTO, 24020, "ic", local_DungeonEquipDefine.TeamType, sub_type)
                        } else {
                            team_model.Fire(REQUEST_PROTO, 24048, "c", 1)
                        }
                    } else {
                        local_Message.show("你不是队长，没有此权限")
                    }
                }
            } else {
                let auto_match = team_model.GetAutoMatch()
                if (auto_match) {
                    team_model.Fire(REQUEST_PROTO, 24048, "c", 0)
                } else {
                    team_model.SetCancelMatchText("匹配失败")
                    let sub_type = now_index_ + 1
                    team_model.Fire(REQUEST_PROTO, 24023, "cc", local_DungeonEquipDefine.TeamType, sub_type)

                }
            }
        }

        this.EnterFunc = () => {
            let team_info = team_model.team_info
            if (team_info) {
                if (team_info.activity_id != local_DungeonEquipDefine.TeamType) {
                    let call_back = () => {
                        team_model.quit_team_enter = local_DungeonEquipDefine.TeamType
                        team_model.Fire(REQUEST_PROTO, 24005)
                    }

                    Alert.Show("当前队伍目标不是寻装觅刃<br>是否退出队伍前往", Alert_Type.Two, call_back, null, "毅然前往", "我再想想", null, null, null, null, null, null, null, null, null, null, false)
                    return
                }
                if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
                    let call_back = () => {
                        let sub_type = now_index_ + 1
                        team_model.Fire(REQUEST_PROTO, 24020, "ic", local_DungeonEquipDefine.TeamType, sub_type)
                    }

                    if (team_info.team_member_list.length == 1) {
                        Alert.Show("当前队伍只有一人,是否继续前往？", Alert_Type.Two, call_back, null, "毅然前往", "我再想想", null, null, null, null, null, null, null, null, null, null, false)
                    } else {
                        call_back()
                    }
                } else {
                    if (!click_time_ || TimeUtil.getServerTime() > click_time_) {
                        click_time_ = TimeUtil.getServerTime() + 5
                        team_model.Fire(REQUEST_PROTO, 24062)
                    } else {
                        local_Message.show("催促太频繁了!请稍候再试")
                    }
                }
            } else {
                if (now_dun_data_) {
                    let data = now_dun_data_
                    let total_count = data.add_count + data.vip_count + local_Number(data.count_cond)
                    if (data && total_count == data.daily_count) {
                        local_Message.show("副本挑战次数不足")
                        return
                    }

                    //助战状态下，单人无法开启副本
                    let state = team_model.help_data && team_model.help_data[now_dun_id_]
                    if (state == 1) {
                        local_Message.show("全员均助战，无法进入副本")
                        return
                    }

                    let ok_func = () => {
                        team_model.single_match_state = local_DungeonEquipDefine.TeamType
                        this.BuildTeam()
                    }

                    let fighting = role_mgr.GetMainRoleVo().fighting
                    if (fighting >= now_dun_data_.recommend_power) {
                        Alert.Show("该玩法难度较高，建议组队前往<br>是否确认孤身挑战？", Alert_Type.Two, ok_func, null, "毅然前往", "我再想想")
                    } else {
                        Alert.Show("当前单人进入可能无法获得最高通关奖励<br>是否继续？", Alert_Type.Two, ok_func, null, "毅然前往", "我再想想")
                    }
                }
            }
        }

        this.InitTeamEvent = () => {
            this.BindEvent(
                team_model,
                local_TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                    this.UpdateTeamState()
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, () => {
                    this.UpdateTeamState()
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.QUIT_TEAM_SUCCESS, () => {
                    if (team_model.quit_team_match == local_DungeonEquipDefine.TeamType) {
                        this.MatchFunc()
                        team_model.quit_team_match = false
                    }
                    if (team_model.quit_team_enter == local_DungeonEquipDefine.TeamType) {
                        this.EnterFunc()
                        team_model.quit_team_enter = false
                    }
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.TEAM_UPDATE_TERAM_HALL, (activity_id?, subtype?) => {
                    if (activity_id == local_DungeonEquipDefine.TeamType && subtype == (now_index_ + 1)) {
                        this.UpdateHallData()
                    }
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.TEAM_BUILD_SUCCESS, () => {
                    if (team_model.single_match_state == local_DungeonEquipDefine.TeamType) {
                        let sub_type = now_index_ + 1
                        team_model.Fire(REQUEST_PROTO, 24020, "ic", local_DungeonEquipDefine.TeamType, sub_type)
                        team_model.single_match_state = false
                    }
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.UPDATE_MATCH_STATE, () => {
                    this.UpdateMatchState()
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.UPDATE_HELP_STATE, (dun_id?) => {
                    this.UpdateHelpState()
                }
            )
            this.BindEvent(
                local_GlobalEventSystem,
                local_EventName.UPDATE_REDDOT, (rType?, key?) => {
                    if (rType != ModuleType.TEAM_APPLY) {
                        return
                    }
                    this.RefreshApplyRed()
                }
            )
            this.BindEvent(
                team_model,
                local_TeamEvent.TEAM_CHANGE_JOIN_TYPE, () => {
                    this.UpdateAutoAddState()
                }
            )
        }

        this.UpdateHallData = () => {
            let team_hall = team_model.team_hall
            if (team_hall) {
                let list = []
                for (let _tmpi in team_hall) {
                    var vo = team_hall[_tmpi]
                    if (vo.num != local_DungeonEquipDefine.MaxNum) {
                        table.insert(list, { vo: vo, sub_type: now_index_ + 1 })
                    }
                }
                this._gp_none.visible = list.length == 0
                if (list.length > 0) {
                    table.insert(list, { none: true, sub_type: now_index_ + 1 })
                }
                roomcon_list = list

                if (!this.roomcon_loop_mgr) {
                    this.roomcon_loop_mgr = new LoopScrowViewMgr()
                    this.roomcon_loop_mgr.SetData(this.Content, DungeonEquipTeamItem, roomcon_list, LoopScrCon.Vertical)
                } else {
                    this.roomcon_loop_mgr.replaceAll(roomcon_list)
                }


                //array_room_.source = list
                //array_room_:refresh()
            }
        }

        this.UpdateTeamState = () => {
            let team_info = team_model.team_info
            if (team_info && team_info.activity_id == local_DungeonEquipDefine.TeamType) {
                show_type_ = local_DungeonEquipEnterView.ShowType.room
                now_index_ = team_info.subtype - 1
                now_dun_id_ = tabcon_list[now_index_].dun_id
                this.UpdateTeamInfo()
                this.UpdateView()
                this.UpdateAutoAddState()
            } else {
                show_type_ = local_DungeonEquipEnterView.ShowType.hall
                let index = (now_index_ == null && (default_index_) || (now_index_))
                this.SwitchTab(index)
            }
            this.UpdateBtn()
            this.PopItem()
        }

        this.UpdateBtn = () => {
            let team_info = team_model.team_info
            if (team_info && team_info.activity_id == local_DungeonEquipDefine.TeamType) {
                if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
                    this._lb_enter.text = "队伍进入"
                } else {
                    this._lb_enter.text = "催促开车"
                }
            } else {
                this._lb_enter.text = "单人进入"
            }

            if (request_dunid > 0) {
                GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 2, DUN_TYPE.Equip, request_dunid, 0)
                request_dunid = 0
            }
        }

        this.UpdateTeamInfo = () => {
            let team_info = team_model.team_info
            let list = []
            let i = 0
            do {
                let vo = team_info && team_info.team_member_list[i]
                if (vo) {
                    table.insert(list, vo)
                } else {
                    table.insert(list, { none: true })
                }
                i = i + 1
            } while ((i < 3))
            if (!role_item_list_) {
                role_item_list_ = []
            }
            let item = null
            let vo = null

            let cfg = team_model.GetTaegetCfgById(team_info.activity_id, team_info.subtype)
            if (cfg) {
                now_dun_id_ = cfg.dun_id
            }


            for (let key in list) {

                item = role_item_list_[key]
                vo = list[key]
                if (!item) {
                    item = new DungeonEquipRoleItem(this._gp_role_con)
                    role_item_list_[key] = item
                    item.Load()
                    item.SetPosition(local_DungeonEquipEnterView.RolePos[key][0], local_DungeonEquipEnterView.RolePos[key][1])
                }
                item.SetData(vo, team_info.activity_id, now_dun_id_)
            }

        }

        this.TabEventFunc = (index?) => {
            this.SwitchTab(index)
        }

        this.BuildTeam = () => {
            let sub_type = now_index_ + 1
            let cfg = team_model.GetTaegetCfgById(local_DungeonEquipDefine.TeamType, sub_type)
            if (cfg) {
                team_model.Fire(REQUEST_PROTO, 24000, "ccihhi", local_DungeonEquipDefine.TeamType, sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
            }
        }

        this.UpdateHelpData = () => {
            let data = model.GetdDungeonHelpData(local_DungeonEquipDefine.HelpDunId)
            // [ts2lua]lua中0和空字符串也是true，此处data需要确认
            let left_times = (data && (data.left_help_count) || (0))
            let desc = "助战进入:"
            // [ts2lua]lua中0和空字符串也是true，此处left_times == 0需要确认
            desc = desc + HtmlColorTxt(left_times + "次", (left_times == 0 && (ColorUtil.GetColorDark(ColorType.RED)) || (ColorUtil.GetColorDark(ColorType.GREEN))))

            this._lb_help_times.width = 200
            this._lb_help_times.innerHTML = Util.StrToHTML(desc)
            this._Group2.x = this._lb_help_times.x + this._lb_help_times.contextWidth + 2
            this._Group2.refresh()
            this._Group2.visible = true
        }

        this.UpdateHelpState = () => {
            // [ts2lua]team_model.help_data下标访问可能不正确
            let state = team_model.help_data && team_model.help_data[now_dun_id_]
            // [ts2lua]lua中0和空字符串也是true，此处state == 1需要确认
            //this._img_help.source = (state == 1 && ( "common_asset.com_ui_gx1" ) || ( "common_asset.com_ui_gx" ) )
            let sprite_name = (state == 1) && "com_ui_gx1" || "com_ui_gx"
            ResManager.GetInstance().SetImageSprite(this, this._img_help, "common_asset", sprite_name, true)
        }

        this.RefreshApplyRed = () => {
            this._img_clump_red.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.TEAM_APPLY)
        }

        this.UpdateAutoAddState = () => {
            if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
                this._gp_auto_add.visible = true
                let team_info = team_model.team_info
                if (team_info) {
                    // [ts2lua]lua中0和空字符串也是true，此处team_info.join_type == 1需要确认
                    let sprite_name = (team_info.join_type == 1) && "com_ui_gx" || "com_ui_gx1"
                    ResManager.GetInstance().SetImageSprite(this, this._img_gx, "common_asset", sprite_name, true)
                }
            } else {
                this._gp_auto_add.visible = false
            }
        }

        this.Dispose = () => {
            //if (this._list_tab_con ) {
            //    this._list_tab_con.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TabEventFunc, this)
            //}
            if (this.tabcon_loop_mgr) {
                this.tabcon_loop_mgr.DeleteMe()
                this.tabcon_loop_mgr = null
            }

            if (this.roomcon_loop_mgr) {
                this.roomcon_loop_mgr.DeleteMe()
                this.roomcon_loop_mgr = null
            }
            if (reward_item_list_) {
                for (let _tmpi in reward_item_list_) {
                    var v = reward_item_list_[_tmpi]
                    v.DeleteMe()
                }
                reward_item_list_ = null
            }
            if (role_item_list_) {
                for (let _tmpi in role_item_list_) {
                    var v = role_item_list_[_tmpi]
                    v.DeleteMe()
                }
                role_item_list_ = null
            }
            this.CancelCountTime()
            click_time_ = null
        }

        this.StartCountTime = (func?, time?) => {
            this.CancelCountTime()
            time_id_ = GlobalTimerQuest.AddPeriodQuest(func, time)
            func()
        }

        this.CancelCountTime = () => {
            if (time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_)
                time_id_ = null
            }
        }
    }

    PreHtml1() {
        this._lb_fighting.style.fontSize = 20
        this._lb_fighting.style.color = "#663915"
        this._lb_fighting.width = 450

        this._lb_times.style.fontSize = 20
        this._lb_times.style.color = "#663915"
        this._lb_times.width = 450
    }

    PreHtml2() {
        this._lb_help_times.style.fontSize = 20
        this._lb_help_times.style.color = "#663915"
        this._lb_help_times.width = 450
    }


    public DeleteMe() {

        this.Dispose()
        super.DeleteMe()
    }


    _Image1: Laya.Image
    _Group1: Laya.Box
    _img_jiejie_b: Laya.Image
    _txt_title1: Laya.Text
    _Label1: Laya.Label
    _lb_fighting: Laya.HTMLDivElement
    _lb_times: Laya.HTMLDivElement
    _lb_help_times: Laya.HTMLDivElement
    _Group2: Laya.HBox
    _Label2: Laya.Label
    _lb_honer: Laya.Label
    _Label3: Laya.Label
    _gp_enter: Laya.Box
    _Image5: Laya.Image
    _lb_enter: Laya.Label
    _gp_match: Laya.Box
    _Image6: Laya.Image
    _lb_match: Laya.Label
    _img_help: Laya.Image
    _Scroller1: Laya.Panel
    Content11: Laya.HBox
    _gp_hall: Laya.Box
    _Image7: Laya.Image
    _Image8: Laya.Image
    _Image81: Laya.Image
    _Image9: Laya.Image
    _Image91: Laya.Image
    Content1: Laya.List
    Content: Laya.List
    _gp_none: Laya.Box
    _Image10: Laya.Image
    _Image11: Laya.Image
    _Label4: Laya.Label
    _lb_create_team: Laya.Label
    _gp_room: Laya.Box
    _Image12: Laya.Image
    _Image13: Laya.Image
    _Image14: Laya.Image
    _Image15: Laya.Image
    _img_clump: Laya.Image
    _img_clump_red: Laya.Image
    _gp_role_con: Laya.Box
    _gp_auto_add: Laya.Box
    _Label5: Laya.Label
    _img_gx: Laya.Image
    _btn_help: Laya.Image
    _box_halo: Laya.Box
    _img_merge_count: Laya.Image
    _lb_halo_tips: Laya.Label
    _img_ad:Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this._img_jiejie_b,
            this._txt_title1,
            this._Label1,
            this._lb_fighting,
            this._lb_times,
            this._lb_help_times,
            this._Group2,
            this._Label2,
            this._lb_honer,
            this._Label3,
            this._gp_enter,
            this._Image5,
            this._lb_enter,
            this._gp_match,
            this._Image6,
            this._lb_match,
            this._img_help,
            this._Scroller1,
            this.Content11,
            this._gp_hall,
            this._Image7,
            this._Image8,
            this._Image81,
            this._Image9,
            this._Image91,
            this.Content1,
            this.Content,
            this._gp_none,
            this._Image10,
            this._Image11,
            this._Label4,
            this._lb_create_team,
            this._gp_room,
            this._Image12,
            this._Image13,
            this._Image14,
            this._Image15,
            this._img_clump,
            this._img_clump_red,
            this._gp_role_con,
            this._gp_auto_add,
            this._Label5,
            this._img_gx,
            this._btn_help,
            this._box_halo,
            this._img_merge_count,
            this._lb_halo_tips,
            this._img_ad,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Group1",
                "_img_jiejie_b",
                "_txt_title1",
                "_Label1",
                "_lb_fighting",
                "_lb_times",
                "_lb_help_times",
                "_Group2",
                "_Label2",
                "_lb_honer",
                "_Label3",
                "_gp_enter",
                "_Image5",
                "_lb_enter",
                "_gp_match",
                "_Image6",
                "_lb_match",
                "_img_help",
                "_Scroller1",
                "Content11",
                "_gp_hall",
                "_Image7",
                "_Image8",
                "_Image81",
                "_Image9",
                "_Image91",
                "Content1",
                "Content",
                "_gp_none",
                "_Image10",
                "_Image11",
                "_Label4",
                "_lb_create_team",
                "_gp_room",
                "_Image12",
                "_Image13",
                "_Image14",
                "_Image15",
                "_img_clump",
                "_img_clump_red",
                "_gp_role_con",
                "_gp_auto_add",
                "_Label5",
                "_img_gx",
                "_btn_help",
                "_box_halo",
                "_img_merge_count",
                "_lb_halo_tips",
                "_img_ad",
            ])
    }
}
window["DungeonEquipEnterView"] = DungeonEquipEnterView