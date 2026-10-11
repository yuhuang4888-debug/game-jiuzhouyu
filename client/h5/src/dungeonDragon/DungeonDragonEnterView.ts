
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { CHAT_TYPE } from "../commonModel/ChatModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel, GuildEvent, GuildAssistType } from "../commonModel/GuildModel"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { DungeonEquipRoleItem } from "../dungeonEquip/DungeonEquipRoleItem"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDeltaX, HtmlColorTxt, SetAnchoredPosition, GlobalTimerQuest } from "../util/Util"
import { DungeonDragonDefine } from "./DungeonDragonDefine"
import { DungeonDragonTabItem } from "./DungeonDragonTabItem"
import { DungeonDragonTeamItem } from "./DungeonDragonTeamItem"
import { Config } from "../common/Config"

import "../dungeonDragon/DungeonDragonAchiItem"
import "../dungeonDragon/DungeonDragonAchiTabItem"
import "../dungeonDragon/DungeonDragonAchiView"
import "../dungeonDragon/DungeonDragonClumpApplyItem"
import "../dungeonDragon/DungeonDragonClumpInviteItem"
import "../dungeonDragon/DungeonDragonClumpView"
import "../dungeonDragon/DungeonDragonDefine"
import "../dungeonDragon/DungeonDragonFightSceneItem"
import "../dungeonDragon/DungeonDragonJumpLevelView"
import "../dungeonDragon/DungeonDragonNoneView"
import "../dungeonDragon/DungeonDragonRecordItem"
import "../dungeonDragon/DungeonDragonRecordView"
import "../dungeonDragon/DungeonDragonReliveView"
import "../dungeonDragon/DungeonDragonResultView"
import "../dungeonDragon/DungeonDragonRewardItem"
import "../dungeonDragon/DungeonDragonRoleItem"
import "../dungeonDragon/DungeonDragonSkillItem"
import "../dungeonDragon/DungeonDragonTabItem"
import "../dungeonDragon/DungeonDragonTeamHeadItem"
import "../dungeonDragon/DungeonDragonTeamItem"
import "../dungeonDragon/DungeonDragonTipsItem"
import "../dungeonDragon/DungeonDragonTowerItem"
import { SceneManager } from "../scene/SceneManager"
import { HaloModel, HaloPrivilegeType } from "../commonModel/HaloModel"



export class DungeonDragonEnterView extends BaseItem1 {
	BuildTeam
	CancelCountTime
	EnterFunc
	InitDefaultIndex
	InitEvent
	InitTeamEvent
	LoadSuccess
	MatchFunc
	PopItem
	RefreshApplyRed
	RefreshTab
	StartCountTime
	SwitchTab
	TabEventFunc
	UpdateAchiRed
	UpdateAutoAddState
	UpdateBtn
	UpdateHallData
	UpdateHelpData
	UpdateHelpState
	UpdateMatchState
	UpdateTeamInfo
	UpdateTeamState
	UpdateView
	UpdateHalo
    InitHalo
	UpdateMergeCheckBox


	array_room_
	array_tab_
	reward_item_list_
	role_item_list_
	click_time_
	merge_check
	public static ShowType = { hall: 0, room: 1 }
	public static RolePos = [[244, 102], [33, 191], [450, 191]]
	public static Tab = [
		{ dun_id: 32001, img_source: "uilwfb_027_02", img_down_source: "uilwfb_027_01" },
		{ dun_id: 32002, img_source: "uilwfb_027_07", img_down_source: "uilwfb_027_06" },
		{ dun_id: 32003, img_source: "uilwfb_027_11", img_down_source: "uilwfb_027_10" },
		{ dun_id: 32004, img_source: "uilwfb_027_15", img_down_source: "uilwfb_027_14" },
		{ dun_id: 32005, img_source: "uilwfb_027_18", img_down_source: "uilwfb_027_19" }
	]
	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonEnterView"
		let model = BaseDungeonModel.GetInstance()
		let team_model = TeamModel.GetInstance()
		let local_Util = Util
		let local_BaseDungeonModel = BaseDungeonModel
		let local_DungeonDragonDefine = DungeonDragonDefine
		let TEAM_REQUEST_PROTO = TeamEvent.TEAM_REQUEST_PROTO
		let local_TeamEvent = TeamEvent
		let role_mgr = RoleManager.GetInstance()
		let local_DungeonDragonEnterView = DungeonDragonEnterView
		let goods_model = GoodsModel.GetInstance()
		let local_Message = Message
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let local_ModuleType = ModuleType
		let local_laya = Laya
		let show_type_ = null
		this.array_tab_ = null
		this.array_room_ = null
		let default_index_ = null
		let now_index_ = null
		let now_dun_id_ = null
		let now_dun_data_ = null
		this.reward_item_list_ = null
		this.role_item_list_ = null
		let click_time_ = null
		let time_id_ = null
		let time_func_ = null
		let request_dunid = 0
		// this.dependent_res = {"dungeonEquip"}
		this.load_callback = () => {
			request_dunid = 0
			this.PreHtml1()
			this.LoadSuccess()

			model.InitDragonReward()
		}



		this.LoadSuccess = () => {
			this._Scroller1.hScrollBarSkin = ""

			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image7, GameResPath.GetIcon("dungeonDragon", "ui_copy_24"))
			this.RefreshTab()
			this.InitDefaultIndex()
			this.UpdateTeamState()
			this.UpdateMatchState()
			this.RefreshApplyRed()
			this.UpdateAchiRed()

			this.InitEvent()
			model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61011, local_DungeonDragonDefine.HelpDunId)
			this.StartCountTime(() => {
				if (now_index_ != null) {
					let sub_type = now_index_ + 1
					team_model.Fire(TEAM_REQUEST_PROTO, 24012, "cci", local_DungeonDragonDefine.TeamType, sub_type, 0)
				}
			}, local_DungeonDragonDefine.RefreshRoomInterval)

			this._btn_help.visible = GuildModel.GetInstance().IsCanOpenAssist()

			this.InitHalo()
		}

		this.InitHalo = () =>{
            //光环
            this.UpdateHalo()
            Util.AddClickEvent(this._lb_halo_tips, () =>{
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
            }, this, false)

            Util.AddClickEvent(this._img_merge_count, () => {
				if(!HaloModel.GetInstance().CheckPrivilegeOpenState(HaloPrivilegeType.DungeonSweep)){
                    return
                }
                let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.DungeonSweep, DUN_TYPE.Dragon)
                if (!state) {
                    let str = "勾选后,本次副本将合并所有次数进入.<br>是否确认勾选?"
                    let content = Util.StrToHTML(str)
                    Alert.Show(
                        content,
                        Alert_Type.Two, () => {
                            HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.DungeonSweep, DUN_TYPE.Dragon, 1)
                        }
                    )
                } else {
                    HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.DungeonSweep, DUN_TYPE.Dragon, 0)
                }
            }, this, true)

			this.BindEvent(HaloModel.GetInstance(), HaloModel.RecvFmt51302, (id, type) => {
					if(id == HaloPrivilegeType.DungeonSweep && DUN_TYPE.Dragon == type){
						this.UpdateMergeCheckBox()
					}
				}
			)
			this.UpdateMergeCheckBox()
        }

        this.UpdateHalo = () =>{
            if(HaloModel.GetInstance().GetOpenState()){
                this._box_halo.visible = true
                if(HaloModel.GetInstance().GetHaloOpenState()){
                    this._img_merge_count.visible = true
                    this._lb_halo_tips.visible = false
                }
                else{
                    this._img_merge_count.visible = false
                    this._lb_halo_tips.visible = true
                }
            }
            else{
                this._box_halo.visible = false
            }
        }

        this.UpdateMergeCheckBox = () => {
			let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.DungeonSweep, DUN_TYPE.Dragon)
            this._img_merge_count.skin = GameResPath.GetIcon("common", state && "com_ui_gx1" || "com_ui_gx")
        }

		this.InitDefaultIndex = () => {
			let index = 0
			for (let key in this.array_tab_.data_list) {

				let vo = this.array_tab_.data_list[key]
				if (vo.state != 2) {
					break
				}
				index = Number(key)
			}
			default_index_ = index
			this.array_tab_.SetSelectIndex(default_index_)
		}

		this.RefreshTab = () => {
			let role_lv = role_mgr.GetMainRoleVo().level
			let list = []
			for (let _tmpi in local_DungeonDragonEnterView.Tab) {
				var vo = local_DungeonDragonEnterView.Tab[_tmpi]
				let state = 0
				let lv = BaseDungeonModel.GetInstance().GetDungeonUnlockLv(vo.dun_id)
				if (role_lv >= lv) {
					state = 1
				}
				if (state == 1) {
					let dun_datas = model.GetDungeonInfo(DUN_TYPE.Dragon)
					if (dun_datas) {
						let dun_data = null
						for (let _tmpi in dun_datas) {
							var v = dun_datas[_tmpi]
							if (v.dun_id == vo.dun_id) {
								dun_data = v
								break
							}
						}
						let finish_dun_id = Number(dun_data.finish_dun_id)
						if (dun_data && (!finish_dun_id || model.IsDragonDunDone(finish_dun_id, Config.ConfigHasDefaultValue.config_dungeon))) {
							state = 2
						}
					}
				}
				// [ts2lua]vo下标访问可能不正确
				vo["state"] = state
				table.insert(list, vo)
			}

			if (!this.array_tab_) {
				this.array_tab_ = new LoopScrowViewMgr()
				this.array_tab_.SetData(this._list_tab, DungeonDragonTabItem, list, LoopScrCon.Vertical, 1, (item?) => {
					this.TabEventFunc(item)
				})

			} else {
				this.array_tab_.replaceAll(list)
			}

		}

		this.PopItem = () => {
			this._gp_hall.visible = show_type_ == local_DungeonDragonEnterView.ShowType.hall
			this._gp_room.visible = show_type_ == local_DungeonDragonEnterView.ShowType.room
		}

		this.UpdateView = () => {
			let dragon_data = model.GetDungeonInfo(DUN_TYPE.Dragon)
			if (dragon_data) {
				let data = null
				for (let _tmpi in dragon_data) {
					var vo = dragon_data[_tmpi]
					if (vo.dun_id == now_dun_id_) {
						data = vo
						break
					}
				}
				now_dun_data_ = data
				if (data) {
					// let tips = local_DungeonDragonDefine.LevelTips[now_dun_id_]
					// if (tips) {
					// 	// this._img_level_tips.source = tips.Small
					// 	//ResManager.GetInstance().SetImageSprite(this, this._img_level_tips, "dungeondragon_asset", tips.Small, true)
					// }
					let sp_name = local_DungeonDragonDefine.LevelTips[now_dun_id_]
					this._txt_title1.text = `神纹烙印（${sp_name}）`

					let total_count = Number(data.count_cond)
					let left_times = total_count - data.daily_count
					let desc0 = "副本剩余次数："
					// [ts2lua]lua中0和空字符串也是true，此处left_times > 0需要确认
					desc0 = desc0 + HtmlColorTxt(left_times, (left_times > 0 && (ColorUtil.GetColorDark(ColorType.GREEN)) || (ColorUtil.GetColorDark(ColorType.RED))))
					desc0 = desc0 + HtmlColorTxt("/" + total_count, ColorUtil.GetColorDark(ColorType.GREEN))
					this._lb_times.innerHTML = Util.StrToHTML(desc0)
					let reward_list = []
					if (data.reward) {
						reward_list = JSON.parse(data.reward)
					}
					if (!this.reward_item_list_) {
						this.reward_item_list_ = []
					}

					for (let i = 0; i < this.reward_item_list_.length; i++) {
						var reward_item = this.reward_item_list_[i]
						reward_item.SetVisible(reward_item.includeInLayout)
					}

					//let index = 0
					let index = 0
					for (let key in reward_list) {

						// [ts2lua]reward_list下标访问可能不正确
						let vo = reward_list[key]
						let type_id, lock
						[type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
						let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
						if (goods_vo) {
							let item = this.reward_item_list_[index]
							if (!item) {
								item = new EquipmentItem(this.content1)
								this.reward_item_list_[index] = item
								item.SetItemSize(70, 70)
								item.Load()
							}
							item.SetData(goods_vo.type_id, vo[2], lock)
							item.SetVisible(true)
							index = index + 1
						}
					}
				}
			}
			team_model.Fire(TEAM_REQUEST_PROTO, 24049, "i", now_dun_id_)
		}

		this.SwitchTab = (index?) => {
			if (now_index_ == index) {
				return
			}
			// [ts2lua]this.array_tab_.source下标访问可能不正确
			let data = this.array_tab_.data_list[index]
			if (data) {
				if (data.state != 2) {
					let dataLv = BaseDungeonModel.GetInstance().GetDungeonUnlockLv(data.dun_id)
					if (data.state == 0) {
						// [ts2lua]lua中0和空字符串也是true，此处data.lv > 370需要确认
						let lv = (dataLv > 370 && ("神创" + (dataLv - 370)) || (dataLv))
						local_Message.show(lv + "级开启")
					} else if (data.state == 1) {
						local_Message.show("需要先通关上一难度副本方可解锁")
					}
					// this._list_tab_con.selectedIndex = now_index_
					this.array_tab_.SetSelectIndex(now_index_)
					return
				}
				now_index_ = index
				// [ts2lua]this.array_tab_.source下标访问可能不正确
				now_dun_id_ = data.dun_id
				team_model.Fire(TEAM_REQUEST_PROTO, 24012, "cci", local_DungeonDragonDefine.TeamType, index + 1, 0)
			}
			this.UpdateView()
		}

		this.InitEvent = () => {

			this.BindEvent(GuildModel.GetInstance(), GuildEvent.CHANGED_CONDS_ASSIST, () => {
				this._btn_help.visible = GuildModel.GetInstance().IsCanOpenAssist()
			})


			// this._list_tab_con.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TabEventFunc, this)
			this.BindEvent(model, local_BaseDungeonModel.UPDATE_HELP_DATA, (dun_id?) => {
				if (dun_id == local_DungeonDragonDefine.HelpDunId) {
					this.UpdateHelpData()
				}
			}
			)
			this.BindEvent(model, local_BaseDungeonModel.UPDATE_RED_STATE, (flag?) => {
				if (flag == local_BaseDungeonModel.DragonRedFlag.RewardState) {
					this.UpdateAchiRed()
				}
			}
			)
			Util.AddClickEvent(this._img_chat, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_CHAT_VIEW, CHAT_TYPE.WORLD)
			}
				, this, true)
			Util.AddClickEvent(this._gp_enter, () => {
				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}
				this.EnterFunc()
			}
				, this, true)
			Util.AddClickEvent(this._gp_match, () => {
				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能匹配")
					return
				}
				this.MatchFunc()
			}
				, this, true)
			Util.AddClickEvent(this._img_clump, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonDragonClumpView", now_dun_id_)
			}
				, this, true)
			Util.AddClickEvent(this._img_help, () => {
				// [ts2lua]team_model.help_data下标访问可能不正确
				let state = team_model.help_data && team_model.help_data[now_dun_id_]
				if (state == 2) {
					Message.show("协助状态无法助战")
				} else if (state == 1) {
					team_model.Fire(TEAM_REQUEST_PROTO, 24033, "ic", now_dun_id_, 0)
				} else {
					let rdata = GuildModel.GetInstance().GetReqData()
					if (rdata) {
						Message.show("协助状态无法助战")
					} else {
						team_model.Fire(TEAM_REQUEST_PROTO, 24033, "ic", now_dun_id_, 1)
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this._img_tips, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_INSTRUCTION_VIEW, InstructionType.DungeonDragon)
			}
				, this, true)
			// this._lb_create_team.text = [{text="点击创建队伍", style={size=24, textColor="#458C00", underline=true}]}
			this._lb_create_team.text = "点击创建队伍"
			//AddUnderlineText(this._lb_create_team, this._lb_create_team, "#458C00", 15, 7)
			Util.AddClickEvent(this._lb_create_team, () => {
				if (team_model.GetAutoMatch()) {
					local_Message.show("正在匹配中～")
					return
				}
				this.BuildTeam()
			}
				, this, true)
			Util.AddClickEvent(this._img_gx, () => {
				let team_info = team_model.team_info
				if (team_info) {
					// [ts2lua]lua中0和空字符串也是true，此处team_info.join_type == 1需要确认
					let index = (team_info.join_type == 1 && (2) || (1))
					team_model.Fire(TEAM_REQUEST_PROTO, 24018, "c", index)
				}
			}
				, this, true)
			Util.AddClickEvent(this._img_achi, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonDragonAchiView")
			}
				, this, true)
			this.InitTeamEvent()
			Util.AddClickEvent(this._btn_help, () => {

				let is_open = GuildModel.GetInstance().IsOpenAssist(GuildAssistType.TYPE_DUNGEON_DRAGON)
				if (!is_open) {
					Message.show(`${GuildModel.GetInstance().GetAssistOpenDesc(GuildAssistType.TYPE_DUNGEON_DRAGON)}`)
					return
				}

				if (!now_dun_id_) {
					return
				}
				if (show_type_ != local_DungeonDragonEnterView.ShowType.room) {
					request_dunid = now_dun_id_
					if (team_model.GetAutoMatch()) {
						local_Message.show("正在匹配中～")
						return
					}
					this.BuildTeam()
				} else {
					GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 2, DUN_TYPE.Dragon, now_dun_id_, 0)
				}
			}, this, true)
		}

		this.UpdateMatchState = () => {
			let team_info = team_model.team_info
			if (team_info && team_info.activity_id == local_DungeonDragonDefine.TeamType) {
				this._lb_match.text = (team_model.GetAutoMatch() && ("取消匹配") || ("自动匹配"))
			} else {
				this._lb_match.text = "自动匹配"
			}
		}

		this.MatchFunc = () => {
			let team_info = team_model.team_info
			if (team_info) {
				if (team_info.activity_id != DungeonDragonDefine.TeamType) {
					let call_back = () => {
						team_model.quit_team_match = local_DungeonDragonDefine.TeamType
						team_model.Fire(TEAM_REQUEST_PROTO, 24005)
					}

					Alert.Show("当前队伍目标不是神纹烙印<br>是否退出队伍匹配", local_Alert_Type.Two, call_back, null, "毅然前往", "我再想想", null, null, null, null, null, null, null, null, null, null, false)
					return
				}
				let auto_match = team_model.GetAutoMatch()
				if (auto_match) {
					team_model.Fire(TEAM_REQUEST_PROTO, 24048, "c", 0)
				} else {
					if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
						if (team_info.team_member_list.length == local_DungeonDragonDefine.MaxNum) {
							let sub_type = now_index_ + 1
							team_model.Fire(TEAM_REQUEST_PROTO, 24020, "ic", local_DungeonDragonDefine.TeamType, sub_type)
						} else {
							team_model.Fire(TEAM_REQUEST_PROTO, 24048, "c", 1)
						}
					} else {
						local_Message.show("你不是队长，没有此权限")
					}
				}
			} else {
				let auto_match = team_model.GetAutoMatch()
				if (auto_match) {
					team_model.Fire(TEAM_REQUEST_PROTO, 24048, "c", 0)
				} else {

					let sub_type = now_index_ + 1
					team_model.Fire(TEAM_REQUEST_PROTO, 24023, "cc", local_DungeonDragonDefine.TeamType, sub_type)
				}
			}
		}

		this.EnterFunc = () => {
			let team_info = team_model.team_info
			if (team_info) {
				if (team_info.activity_id != local_DungeonDragonDefine.TeamType) {
					let call_back = () => {
						team_model.quit_team_enter = local_DungeonDragonDefine.TeamType
						team_model.Fire(TEAM_REQUEST_PROTO, 24005)
					}

					Alert.Show("当前队伍目标不是神纹烙印<br>是否退出队伍前往", local_Alert_Type.Two, call_back, null, "毅然前往", "我再想想", null, null, null, null, null, null, null, null, null, null, false)
					return
				}
				if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
					let call_back = () => {
						let sub_type = now_index_ + 1
						team_model.Fire(TEAM_REQUEST_PROTO, 24020, "ic", local_DungeonDragonDefine.TeamType, sub_type)
					}

					if (team_info.team_member_list.length < 3) {
						Alert.Show("当前队伍人数少于3人,是否直接进入副本？", local_Alert_Type.Two, call_back, null, "毅然前往", "我再想想", null, null, null, null, null, null, null, null, null, null, false)
					} else {
						call_back()
					}
				} else {
					if (!click_time_ || TimeUtil.getServerTime() > click_time_) {
						click_time_ = TimeUtil.getServerTime() + 5
						team_model.Fire(TEAM_REQUEST_PROTO, 24062)
					} else {
						local_Message.show("催促太频繁了!请稍候再试")
					}
				}
			} else {
				if (now_dun_data_) {
					let data = now_dun_data_
					if (data && Number(data.count_cond) == data.daily_count) {
						local_Message.show("副本挑战次数不足")
						return
					}
					let ok_func = () => {
						team_model.single_match_state = local_DungeonDragonDefine.TeamType
						this.BuildTeam()
					}

					let fighting = role_mgr.GetMainRoleVo().fighting
					if (fighting >= now_dun_data_.recommend_power) {
						Alert.Show("该玩法难度较高，建议组队前往<br>是否确认孤身挑战？", local_Alert_Type.Two, ok_func, null, "毅然前往", "我再想想")
					} else {
						Alert.Show("当前单人进入可能无法获得最高通关奖励<br>是否继续？", local_Alert_Type.Two, ok_func, null, "毅然前往", "我再想想")
					}
				}
			}
		}

		this.InitTeamEvent = () => {
			this.BindEvent(team_model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
				this.UpdateTeamState()
			}
			)
			this.BindEvent(team_model, local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, () => {
				this.UpdateTeamState()
			}
			)
			this.BindEvent(team_model, local_TeamEvent.QUIT_TEAM_SUCCESS, () => {
				if (team_model.quit_team_match == local_DungeonDragonDefine.TeamType) {
					this.MatchFunc()
					team_model.quit_team_match = false
				}
				if (team_model.quit_team_enter == local_DungeonDragonDefine.TeamType) {
					this.EnterFunc()
					team_model.quit_team_enter = false
				}
			}
			)
			this.BindEvent(team_model, local_TeamEvent.TEAM_UPDATE_TERAM_HALL, (activity_id?, subtype?) => {
				if (activity_id == local_DungeonDragonDefine.TeamType && subtype == (now_index_ + 1)) {
					this.UpdateHallData()
				}
			}
			)
			this.BindEvent(team_model, local_TeamEvent.TEAM_BUILD_SUCCESS, () => {
				if (team_model.single_match_state == local_DungeonDragonDefine.TeamType) {
					let sub_type = now_index_ + 1
					team_model.Fire(TEAM_REQUEST_PROTO, 24020, "ic", local_DungeonDragonDefine.TeamType, sub_type)
					team_model.single_match_state = false
				}
			}
			)
			this.BindEvent(team_model, local_TeamEvent.UPDATE_MATCH_STATE, () => {
				this.UpdateMatchState()
			}
			)
			this.BindEvent(team_model, local_TeamEvent.UPDATE_HELP_STATE, (dun_id?) => {
				this.UpdateHelpState()
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_REDDOT, (rType?, key?) => {
				if (rType != local_ModuleType.TEAM_APPLY) {
					return
				}
				this.RefreshApplyRed()
			}
			)
			this.BindEvent(team_model, local_TeamEvent.TEAM_CHANGE_JOIN_TYPE, () => {
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
					if (vo.num != local_DungeonDragonDefine.MaxNum) {
						// table.insert(list, {vo=vo, sub_type=now_index_ + 1})
						table.insert(list, { vo: vo, sub_type: now_index_ + 1 })
					}
				}
				this._gp_none.visible = list.length == 0
				if (list.length > 0) {
					// table.insert(list, {none=true, sub_type=now_index_ + 1})
					table.insert(list, { none: true, sub_type: now_index_ + 1 })
				}
				// this.array_room_.source = list
				// this.array_room_.refresh()


				if (!this.array_room_) {
					this.array_room_ = new LoopScrowViewMgr()
					this.array_room_.SetData(this.Content, DungeonDragonTeamItem, [], LoopScrCon.Vertical)
				} else {
					this.array_room_.replaceAll(list)
				}

			}
		}

		this.UpdateTeamState = () => {
			let team_info = team_model.team_info
			if (team_info && team_info.activity_id == local_DungeonDragonDefine.TeamType) {
				show_type_ = local_DungeonDragonEnterView.ShowType.room
				now_index_ = team_info.subtype - 1
				now_dun_id_ = this.array_tab_.data_list[now_index_].dun_id
				this.UpdateTeamInfo()
				this.UpdateView()
				this.UpdateAutoAddState()
			} else {
				show_type_ = local_DungeonDragonEnterView.ShowType.hall
				let index = (now_index_ == null && (default_index_) || (now_index_))
				this.SwitchTab(index)
			}
			this.UpdateBtn()
			this.PopItem()
		}

		this.UpdateBtn = () => {
			let team_info = team_model.team_info
			if (team_info && team_info.activity_id == local_DungeonDragonDefine.TeamType) {
				if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
					this._lb_enter.text = "队伍进入"
				} else {
					this._lb_enter.text = "催促开车"
				}
			} else {
				this._lb_enter.text = "单人进入"
			}

			if (request_dunid > 0) {
				GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40401, "chil", 2, DUN_TYPE.Dragon, request_dunid, 0)
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
			} while ((i < 3)
			)
			if (!this.role_item_list_) {
				this.role_item_list_ = []
			}
			for (let key in list) {

				// [ts2lua]this.role_item_list_下标访问可能不正确
				let item = this.role_item_list_[key]
				// [ts2lua]list下标访问可能不正确
				let vo = list[key]
				if (!item) {
					item = new DungeonEquipRoleItem(this._gp_role_con)
					// [ts2lua]this.role_item_list_下标访问可能不正确
					this.role_item_list_[key] = item
					item.Load()
					item.ExcuteCallback(() => {
						let pos = local_DungeonDragonEnterView.RolePos[key]
						//SetAnchoredPosition(item.transform, pos[1], pos[2])
						item.SetPosition(DungeonDragonEnterView.RolePos[key][0], DungeonDragonEnterView.RolePos[key][1])
					})
				}
				item.SetData(vo, team_info.activity_id, now_dun_id_)
			}
			let cfg = team_model.GetTaegetCfgById(team_info.activity_id, team_info.subtype)
			if (cfg) {
				now_dun_id_ = cfg.dun_id
			}
		}

		this.TabEventFunc = (item?) => {
			// this.SwitchTab(e.itemIndex)
			this.SwitchTab(item)
		}

		this.BuildTeam = () => {
			let sub_type = now_index_ + 1
			let cfg = team_model.GetTaegetCfgById(local_DungeonDragonDefine.TeamType, sub_type)
			if (cfg) {
				team_model.Fire(TEAM_REQUEST_PROTO, 24000, "ccihhi", local_DungeonDragonDefine.TeamType, sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
			}
		}

		this.UpdateHelpData = () => {
			let data = model.GetdDungeonHelpData(local_DungeonDragonDefine.HelpDunId)
			// [ts2lua]lua中0和空字符串也是true，此处data需要确认
			let left_times = (data && (data.left_help_count) || (0))
			let desc = "助战剩余次数："
			// [ts2lua]lua中0和空字符串也是true，此处left_times == 0需要确认
			desc = desc + HtmlColorTxt(left_times + "次", (left_times == 0 && (ColorUtil.GetColorDark(ColorType.RED)) || (ColorUtil.GetColorDark(ColorType.GREEN))))
			this._lb_help_times.innerHTML = Util.StrToHTML(desc)
			this._img_tips.x = this._lb_help_times.x + this._lb_help_times.contextWidth + 3
			//LayoutRebuilder(this.help_con)
		}

		this.UpdateHelpState = () => {
			// [ts2lua]team_model.help_data下标访问可能不正确
			let state = team_model.help_data && team_model.help_data[now_dun_id_]
			// [ts2lua]lua中0和空字符串也是true，此处state == 1需要确认
			ResManager.GetInstance().SetImageSprite(this, this._img_help, "common_asset", (state == 1 && ("com_ui_gx1") || ("com_ui_gx")))
		}

		this.RefreshApplyRed = () => {
			this._img_clump_red.visible = RedDotManager.GetInstance().CheckRedStatus(local_ModuleType.TEAM_APPLY)
		}

		this.UpdateAutoAddState = () => {
			if (team_model.IsLeaderInTeam(role_mgr.GetMainRoleId())) {
				this._gp_auto_add.visible = true
				let team_info = team_model.team_info
				if (team_info) {
					// [ts2lua]lua中0和空字符串也是true，此处team_info.join_type == 1需要确认
					ResManager.GetInstance().SetImageSprite(this, this._img_gx, "common_asset", (team_info.join_type == 1 && ("com_ui_gx") || ("com_ui_gx1")))
				}
			} else {
				this._gp_auto_add.visible = false
			}
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

		this.UpdateAchiRed = () => {
			this._img_achi_red.visible = model.HasDragonRedFlag(local_BaseDungeonModel.DragonRedFlag.RewardState)
		}
	}


	public DeleteMe() {

		// if (this._list_tab_con ) {
		// 	this._list_tab_con.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TabEventFunc, this)
		// }
		if (this.reward_item_list_) {
			for (let _tmpi in this.reward_item_list_) {
				var v = this.reward_item_list_[_tmpi]
				v.DeleteMe()
			}
			this.reward_item_list_ = null
		}
		if (this.role_item_list_) {
			for (let _tmpi in this.role_item_list_) {
				var v = this.role_item_list_[_tmpi]
				v.DeleteMe()
			}
			this.role_item_list_ = null
		}
		this.CancelCountTime()
		if (this.array_tab_) {
			this.array_tab_.DeleteMe()
			this.array_tab_ = null
		}
		if (this.array_room_) {
			this.array_room_.DeleteMe()
			this.array_room_ = null
		}
		super.DeleteMe()
	}

	PreHtml1() {
		this._lb_times.style.fontSize = 20
		this._lb_times.style.color = "#663915"
		this._lb_times.width = 450
		this._lb_times.style.wordWrap = false

		this._lb_help_times.style.fontSize = 20
		this._lb_help_times.style.color = "#663915"
		this._lb_help_times.style.wordWrap = false
		this._lb_help_times.width = 450
	}


	_Image1: Laya.Image
	_Group1: Laya.Box
	_img_jiejie_b: Laya.Image
	_txt_title1: Laya.Text
	_lb_times: Laya.HTMLDivElement
	_lb_help_times: Laya.HTMLDivElement
	_img_tips: Laya.Image
	_gp_enter: Laya.Box
	_Image4: Laya.Image
	_lb_enter: Laya.Label
	_gp_match: Laya.Box
	_Image5: Laya.Image
	_lb_match: Laya.Label
	_img_achi: Laya.Image
	_img_achi_red: Laya.Image
	_img_help: Laya.Image
	_Scroller1: Laya.Panel
	content1: Laya.HBox
	_gp_hall: Laya.Box
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image81: Laya.Image
	_Image9: Laya.Image
	_Image91: Laya.Image
	_list_tab: Laya.List
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
	_Label122: Laya.Label
	_img_chat: Laya.Image
	_box_halo: Laya.Box
    _img_merge_count: Laya.Image
    _lb_halo_tips: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this._img_jiejie_b,
			this._txt_title1,
			this._lb_times,
			this._lb_help_times,
			this._img_tips,
			this._gp_enter,
			this._Image4,
			this._lb_enter,
			this._gp_match,
			this._Image5,
			this._lb_match,
			this._img_achi,
			this._img_achi_red,
			this._img_help,
			this._Scroller1,
			this.content1,
			this._gp_hall,
			this._Image7,
			this._Image8,
			this._Image81,
			this._Image9,
			this._Image91,
			this._list_tab,
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
			this._Label122,
			this._img_chat,
			this._box_halo,
            this._img_merge_count,
            this._lb_halo_tips,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"_img_jiejie_b",
				"_txt_title1",
				"_lb_times",
				"_lb_help_times",
				"_img_tips",
				"_gp_enter",
				"_Image4",
				"_lb_enter",
				"_gp_match",
				"_Image5",
				"_lb_match",
				"_img_achi",
				"_img_achi_red",
				"_img_help",
				"_Scroller1",
				"content1",
				"_gp_hall",
				"_Image7",
				"_Image8",
				"_Image81",
				"_Image9",
				"_Image91",
				"_list_tab",
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
				"_Label122",
				"_img_chat",
				"_box_halo",
                "_img_merge_count",
                "_lb_halo_tips",
			])
	}
}
window["DungeonDragonEnterView"] = DungeonDragonEnterView