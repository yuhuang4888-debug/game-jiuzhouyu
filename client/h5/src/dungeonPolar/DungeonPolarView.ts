import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { DownDropBtn } from "../common/DownDropBtn"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { DungeonEquipDefine } from "../dungeonEquip/DungeonEquipDefine"
import { DungeonEquipEnterView } from "../dungeonEquip/DungeonEquipEnterView"
import { DungeonEquipRoleItem } from "../dungeonEquip/DungeonEquipRoleItem"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, SetHtmlStyle, HtmlColorTxt } from "../util/Util"
import { DungeonPolarTab } from "./DungeonPolarTab"
import { DungeonPolarTeamItem } from "./DungeonPolarTeamItem"
import { Config } from "../common/Config"

export class DungeonPolarView extends BaseItem1 {
	BuildTeam
	CancelCountTime
	EnterFunc
	InitEvent
	LoadSuccess
	StartCountTime
	UpdateAutoAddState
	UpdateBtn
	UpdateHallData
	UpdateTeamInfo
	UpdateTeamState
	OnPanelChange
	initTab
	item_touch
	role_item_list
	room_loop_mgr
	select_index
	sendMenu
	single_reward_list
	tab_loop_mgr:LoopScrowViewMgr
	team_reward_list
	updateBg
	updateMenu
	updateReward
	updateView
	menu_item
	TabMove
	tab_list_data

	public static ShowType = { null: 0, hall: 1, room: 2 }
	public static Team_Menu_Type = { normal: 1, perfect: 2, epic: 3 }
	public static menu_dic = {
		"0": { id: 1, content: "普通" },
		"1": { id: 2, content: "完美" },
		"2": { id: 3, content: "史诗" }
	}
	public constructor(parent?) {
		super(parent)
		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarView"

		this.single_reward_list = []
		this.team_reward_list = []
		this.role_item_list = []
		let _select_tab = 1
		let _select_item = null
		let _showType = DungeonPolarView.ShowType.null
		let team_model = TeamModel.GetInstance()
		let _model = BaseDungeonModel.GetInstance()
		let time_id = null
		let time_func = null
		let click_time = null
		let local_BaseDungeonModel = BaseDungeonModel
		let local_DungeonPolarView = DungeonPolarView
		let local_TeamModel = TeamModel
		let local_EventName = EventName
		let local_TeamEvent = TeamEvent
		let local_RoleManager = RoleManager.GetInstance()
		let local_DungeonEquipDefine = DungeonEquipDefine
		let local_GoodsModel = GoodsModel.GetInstance()
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_con_bg1,GameResPath.GetIconOtherPath("dungeonPolar","uijdsh_bg"))
			SetHtmlStyle(this._lb_desc,{c:"#763320",f:18,w:625,lh:23})
			this._scroll_con2.hScrollBarSkin=""
			this._scroll_con3.hScrollBarSkin=""
			this._Scroller1.vScrollBarSkin=""
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_myself, () => {
				if (_select_item) {
					_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61001, _select_item.single_dun_id)
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_team, () => {
				let dunInfo = _model.getPolarInfo(_select_item.dun_id)
				if (dunInfo && dunInfo.dun_score <= 0) {
					Message.show("请先通过单人试炼再进行组队挑战")
					return
				}
				let team_info = team_model.team_info
				if ((team_info && team_model.activity_id == local_TeamModel.POLAR_DUN) && team_model.activity_sub_id == _select_tab) {
					_showType = local_DungeonPolarView.ShowType.room
				} else {
					_showType = local_DungeonPolarView.ShowType.hall
				}
				this.updateView()
			}
				, this, true)
			Util.AddClickEvent(this._rank, () => {
				GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonPolarRankView", _select_item.team_dun_id)
			}
				, this, true)
			Util.AddClickEvent(this._reward, () => {
				GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonPolarRewardView", _select_item.dun_id)
			}
				, this, true)
			Util.AddClickEvent(this._gp_none, () => {
				let auto_match = team_model.GetAutoMatch();
				if (auto_match) {
					Message.show("正在匹配中～")
					return
				}
				this.BuildTeam()
			}
				, this, true)
			this.BindEvent(team_model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
				this.UpdateTeamState()
			}
			)
			this.BindEvent(team_model, local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, () => {
				this.UpdateTeamState()
			}
			)
			this.BindEvent(team_model, local_TeamEvent.QUIT_TEAM_SUCCESS, () => {
				if (team_model.quit_team_enter == local_TeamModel.POLAR_DUN) {
					this.EnterFunc()
					team_model.quit_team_enter = false
				}
			}
			)
			this.BindEvent(team_model, local_TeamEvent.TEAM_UPDATE_TERAM_HALL, (activity_id?, subtype?) => {
				if (activity_id == local_TeamModel.POLAR_DUN && subtype == _select_tab) {
					this.UpdateHallData()
				}
			}
			)
			//this._tab_scroller.addEventListener(Laya.UIEvent.CHANGE, this.hid_arrow, this)
			Util.AddClickEvent(this._box_left, () => {
				this.TabMove(0)
			}, this, true)

			Util.AddClickEvent(this._box_right, () => {
				this.TabMove(1)
			}, this, true)


			Util.AddClickEvent(this._img_gx, () => {
				if (team_model.IsLeaderInTeam(local_RoleManager.GetMainRoleId())) {
					let team_info = team_model.team_info
					if (team_info) {
						let index = team_info.join_type == 1 && 2 || 1
						team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24018, "c", index)
					}
				} else {
					Message.show("你不是队长")
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_recruit, () => {
				GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEquipClumpView", _select_item.team_dun_id)
			}
				, this, true)
			Util.AddClickEvent(this._btn_team_go, () => {
				this.EnterFunc()
			}
				, this, true)
			this.BindEvent(team_model, local_TeamEvent.TEAM_CHANGE_JOIN_TYPE, () => {
				this.UpdateAutoAddState()
			}
			)
			this.BindEvent(_model, local_BaseDungeonModel.POLAR_DATA_RETURN, () => {
				this.updateView()
			}
			)
		}




		this.LoadSuccess = () => {
			this.StartCountTime(() => {
				if (_showType == local_DungeonPolarView.ShowType.hall && _select_tab != null) {
					let sub_type = _select_tab
					team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24012, "cci", local_TeamModel.POLAR_DUN, sub_type, 0)
				}
			}
				, local_DungeonEquipDefine.RefreshRoomInterval)
			// this._lb_create_team.text = "点击创建队伍"
			// this._lb_create_team.color = ColorUtil.TryParseHtmlString("#458C00")
			//this._lb_create_team.text = [{text:"点击创建队伍", style:{size:24, textColor:"#458C00", underline:true}]}
			this.initTab()
			this.UpdateTeamState()
			_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 50801)
		}


		this.TabMove=(type)=>{
			if(!this.tab_con.scrollBar)return
			Laya.Tween.clearAll(this.tab_con.scrollBar)
			let page=3//每页多少个
			let gap = page*176+(page-1)*this.tab_con.spaceX
			let c_value=this.tab_con.scrollBar.value
			let max=this.tab_con.scrollBar.max
			let posx
			if(type==1){
				//向左边
				posx=c_value+gap
				posx=posx>=max?max:posx
				Laya.Tween.to(this.tab_con.scrollBar,{value:posx},250,Laya.Ease.sineInOut)
			}else{
				//向右边
				posx=c_value-gap
				posx=posx<=0?0:posx
				Laya.Tween.to(this.tab_con.scrollBar,{value:c_value-gap},250,Laya.Ease.sineInOut)
			}
		}

		this.initTab = () => {
			let week_dungeon_cfg =Config.PRELOAD_SERVER_CONFIG.config_week_dungeon
			let client_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientDunWeekendMsg
			let list = []
			for (let key in week_dungeon_cfg) {

				let info = week_dungeon_cfg[key]
				let cfg = client_cfg[info.single_dun_id]
				let lv = local_RoleManager.GetMainRoleVo().level
				let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (cfg && (lv >= cfg.open_lv && openDay >= cfg.open_day)) {
					table.insert(list, info)
				}
			}
			table.sort(list, (a?, b?) => {
				return a.dun_id < b.dun_id
			})

			this.tab_list_data=list
			if (!this.tab_loop_mgr) {
				this.tab_loop_mgr = new LoopScrowViewMgr()
				this.tab_loop_mgr.SetData(this.tab_con, DungeonPolarTab, this.tab_list_data, LoopScrCon.Horizontal, 1, (item?) => {
					this.item_touch(item)
				})
				this.tab_loop_mgr.SetSelectIndex(_select_tab-1)
				_select_item = this.tab_list_data[_select_tab-1]
				this.tab_loop_mgr.SetOnValueChanged(this.OnPanelChange)
			} else {
				this.tab_loop_mgr.replaceAll(this.tab_list_data)
			}
			this.OnPanelChange()
			//this.updateBg()
		}

		this.updateView = () => {
			this._gp_null.visible = _showType == local_DungeonPolarView.ShowType.null
			this._gp_hall.visible = _showType == local_DungeonPolarView.ShowType.hall
			this._gp_room.visible = _showType == local_DungeonPolarView.ShowType.room
			this._reward.visible = _showType != local_DungeonPolarView.ShowType.hall
			if (this._gp_null.visible) {
				this.updateReward()
			} else if (this._gp_hall.visible) {
				this.UpdateHallData()
				team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24012, "cci", local_TeamModel.POLAR_DUN, _select_tab, 0)
			} else if (this._gp_room.visible) {
				this.UpdateTeamInfo()
				this._txt_title1.text=_select_item.dun_id==1?"极寒之地":"埋骨之地"
			}
		}

		this.updateBg = () => {
			if(!_select_item)return
			ResManager.GetInstance().SetOutsideImageSprite(this,this._img_bg,GameResPath.GetBigBgPath(_select_item.single_dun_id+".jpg"))
			if(_select_item.dun_id==1){
				//极寒
				ResManager.GetInstance().SetImageSprite(this,this._img_title_bg1,"common4","com_title_bg_4")
				ResManager.GetInstance().SetImageSprite(this,this._img_title_bg3,"dungeonPolar","uijdfb_036c")
				ResManager.GetInstance().SetImageSprite(this,this._img_title_bg2,"dungeonPolar","uijdfb_036c")
			}else{
				//埋骨
				ResManager.GetInstance().SetImageSprite(this,this._img_title_bg1,"dungeonPolar","uijdfb_036")
				ResManager.GetInstance().SetImageSprite(this,this._img_title_bg3,"dungeonPolar","uijdfb_036a1")
				ResManager.GetInstance().SetImageSprite(this,this._img_title_bg2,"dungeonPolar","uijdfb_036a1")
			}

			let big_title_url=_select_item.dun_id==1?"uijdfb_034c":"uijdfb_034d"
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_big_title,GameResPath.GetIcon("dungeonPolar",big_title_url))
		}

		this.item_touch = (item?) => {
			_select_item = this.tab_list_data[item]
			_select_tab = item+1
			this.tab_loop_mgr.SetSelectIndex(item)
			_showType = local_DungeonPolarView.ShowType.null
			this.UpdateTeamState()
			this.updateBg()
		}

		this.BuildTeam = () => {
			let sub_type = _select_tab
			let cfg = team_model.GetTaegetCfgById(local_TeamModel.POLAR_DUN, sub_type)
			if (cfg) {
				team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", local_TeamModel.POLAR_DUN, sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
			}
		}

		this.UpdateHallData = () => {
			let team_hall = team_model.team_hall
			if (team_hall) {
				let list = []
				for (let _tmpi in team_hall) {
					var vo = team_hall[_tmpi]
					if (vo.num != local_DungeonEquipDefine.MaxNum) {
						table.insert(list, { vo:vo, sub_type:_select_tab, activity_id:local_TeamModel.POLAR_DUN })
					}
				}
				this._gp_none.visible = list.length == 0
				if (list.length > 0) {
					table.insert(list, { none:true, sub_type:_select_tab })
				}

				if (!this.room_loop_mgr) {
					this.room_loop_mgr = new LoopScrowViewMgr()
					this.room_loop_mgr.SetData(this.room_con, DungeonPolarTeamItem, list,LoopScrCon.Vertical)
				} else {
					this.room_loop_mgr.replaceAll(list)
				}
			}
		}


		this.OnPanelChange = () => {
			let value =this.tab_con.scrollBar.value
			if(this.tab_list_data&&this.tab_list_data.length>3){
				if (value >= this.tab_con.scrollBar.max) {
					this._box_left.visible = true
					this._box_right.visible = false
				} else if (value <= 0) {
					this._box_left.visible = false
					this._box_right.visible = true
				} else {
					this._box_left.visible = true
					this._box_right.visible = true
				}
			}else{
				this._box_left.visible = false
				this._box_right.visible = false
			}
			
		}



		this.updateReward = () => {
			if (_select_item) {
				let reward_cfg = Config.PRELOAD_SERVER_CONFIG.config_week_dungeon_reward_view

				//试炼通关奖励
				let reward = reward_cfg[_select_item.single_dun_id]
				let singleList = []
				if (reward) {
					singleList =JSON.parse(reward.rewards)
				}

				let i = 0
				if(this.single_reward_list&&this.single_reward_list.length>0){
					for(i=0;i<this.single_reward_list.length;i++){
						this.single_reward_list[i].SetVisible(false)
					}
				}
			
				i = 0
				do {
					let vo = singleList[i]
					let item:BaseAwardItem = this.single_reward_list[i]
					if (!item) {
						item = new BaseAwardItem(this.con2)
						item.SetItemSize(89,89)
						item.SetUseMask(true)
						item.Load()
						table.insert(this.single_reward_list, item)
					}
					item.SetVisible(true)
					item.ExcuteCallback(() => {
						let [type_id, lock ]= local_GoodsModel.GetMappingTypeId(vo[0], vo[1])
						let goods_vo = local_GoodsModel.GetGoodsBasicByTypeId(type_id)
						if (goods_vo) {
							item.SetData(goods_vo.type_id, vo[2], lock)
						}
					}
					)
					i = i + 1
				} while ((i < singleList.length)
				)



				//组队首通奖励
				let team_data = reward_cfg[_select_item.team_dun_id]
				let teamList = []
				if (reward) {
					teamList = JSON.parse(team_data.rewards)
				}

				i = 0
				if(this.team_reward_list&&this.team_reward_list.length>0){
					for(i=0;i<this.team_reward_list.length;i++){
						this.team_reward_list[i].SetVisible(false)
					}
				}


				i = 0
				if ((i <= teamList.length)) {
					do {
						let vo = teamList[i]
						let item:BaseAwardItem = this.team_reward_list[i]
						if (!item) {
							item = new BaseAwardItem(this.con3)
							item.SetItemSize(89,89)
							item.SetUseMask(true)
							item.Load()
							table.insert(this.team_reward_list, item)
						}
						item.ExcuteCallback(() => {
							item.SetVisible(true)
							let [type_id, lock ]= local_GoodsModel.GetMappingTypeId(vo[0], vo[1])
							let goods_vo = local_GoodsModel.GetGoodsBasicByTypeId(type_id)
							if (goods_vo) {
								item.SetData(goods_vo.type_id, vo[2], lock)
							}
						}
						)
						i = i + 1
					} while ((i < teamList.length)
					)
				}

				//介绍
				let dunInfo = _model.getPolarInfo(_select_item.dun_id)
				if (dunInfo) {
					this._gp_join.visible = dunInfo.dun_score > 0
					if (this._gp_join.visible) {
						this._lb_join.text = team_model.joinName(local_TeamModel.POLAR_DUN, dunInfo.dun_score)
						ResManager.GetInstance().SetImageSprite(this, this._img_join, "dungeonPolar_asset", team_model.joinImage(local_TeamModel.POLAR_DUN, dunInfo.dun_score))
					}
					this._gp_pass.visible = dunInfo.team_succ != 1
					this._gp_pass2.visible = dunInfo.team_succ == 1
					if (this._gp_pass2.visible) {
						this._lb_pass_num.text = dunInfo.help_times + "/" + _select_item.help_count
					}
				}
				let msg_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientDunWeekendMsg
				let msg_info = msg_cfg[_select_item.single_dun_id]
				if (msg_info) {
					let color1="'#598c01'"
					let str1=`等级推荐：${HtmlColorTxt(msg_info.level,color1)}
					<br>战力推荐：${HtmlColorTxt(msg_info.fight,color1)}
					<br>组队人数推荐：${HtmlColorTxt(msg_info.team_max,color1)}<br>`

					this._lb_desc.innerHTML = str1+Util.StrToHTML(msg_info.desc)
					this._lb_desc.style.width=625
				}
				// LayoutRebuilder(this._lb_desc)
				// SetSizeDeltaY(this.Content, Math.abs(this._lb_desc.anchoredPosition.y) + this._lb_desc.sizeDelta.y)

			}
		}

		this.UpdateTeamInfo = () => {
			let team_info = team_model.team_info
			let list = []
			let i = 0
			let vo
			do {
				vo = team_info && team_info.team_member_list[i]
				if (vo) {
					table.insert(list, vo)
				} else {
					table.insert(list, { none:true })
				}
				i = i + 1
			} while ((i < 3)
			)
			if (!this.role_item_list) {
				this.role_item_list = []
			}
			let item = null
			vo = null
			let index = 0
			for (let key in list) {
				vo = list[key]
				item = this.role_item_list[index]
				if (!item) {
					item = new DungeonEquipRoleItem(this._gp_role_con)
					table.insert(this.role_item_list, item)
					item.Load()
				}
				let RolePos = DungeonEquipEnterView.RolePos[key]
				let x = RolePos[0]
				let y = RolePos[1]
				item.SetPosition(x, y)
				//item:ExcuteCallback(() => {
				item.SetData(vo, team_info.activity_id, _select_item.team_dun_id)
				//})
				index = index + 1
			}
			index = (team_model.join_con_value && team_model.join_con_value) > 0 && team_model.join_con_value || 1
			let default_con = DungeonPolarView.menu_dic[index-1]
			let is_leader = team_model.IsLeaderInTeam(local_RoleManager.GetMainRoleId())
			let alert_con = "你不是队长"
			let touch_data = {notTouch : !is_leader, alert_con : alert_con}
			if (!this.menu_item) {
				this.menu_item = new DownDropBtn(this._menu)
				this.menu_item.Init(DungeonPolarView.menu_dic, this.sendMenu, default_con.content, "content", null, 3, null, null, null, touch_data)
				this.menu_item.Load()
			}
			this.menu_item.SetTouchData(touch_data)
			this.UpdateBtn()
		}

		this.UpdateTeamState = () => {
			let team_info = team_model.team_info
			if ((team_info && team_model.activity_id == local_TeamModel.POLAR_DUN) && team_model.activity_sub_id == _select_tab) {
				_showType = local_DungeonPolarView.ShowType.room
				this.UpdateAutoAddState()
				//this:updateMenu()
			} else {
				if (_showType == local_DungeonPolarView.ShowType.room) {
					_showType = local_DungeonPolarView.ShowType.hall
				} else {
					_showType = local_DungeonPolarView.ShowType.null
				}
			}
			this.updateView()
		}

		this.EnterFunc = () => {
			let team_info = team_model.team_info
			if (team_info) {
				if (team_info.activity_id != local_TeamModel.POLAR_DUN) {
					let call_back = () => {
						team_model.quit_team_enter = local_TeamModel.POLAR_DUN
						team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24005)
					}

					Alert.Show("当前队伍目标不是极限试炼\n是否退出队伍前往", Alert_Type.Two, call_back, null, "毅然前往", "我再想想")
					return
				}
				if (team_model.IsLeaderInTeam(local_RoleManager.GetMainRoleId())) {
					let call_back = () => {
						let sub_type = _select_tab
						team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24020, "ic", local_TeamModel.POLAR_DUN, sub_type)
					}

					if (team_info.team_member_list.length < 3) {
						Alert.Show("当前队伍人数少于3人,是否直接进入副本？", Alert_Type.Two, call_back, null, "毅然前往", "我再想想")
					} else {
						call_back()
					}
				} else {
					if (!click_time || TimeUtil.getServerTime() > click_time) {
						click_time = TimeUtil.getServerTime() + 5
						team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24062)
					} else {
						Message.show("催促太频繁了!请稍候再试")
					}
				}
			}
		}

		this.UpdateAutoAddState = () => {
			let team_info = team_model.team_info
			if (team_info) {
				ResManager.GetInstance().SetImageSprite(this, this._img_gx, "common_asset", team_info.join_type == 1 && "com_ui_gx" || "com_ui_gx1")
			}
		}

		this.sendMenu = (index?, data?) => {
			if (_showType != local_DungeonPolarView.ShowType.room) {
				return
			}
			let sub_type = _select_tab
			let cfg = team_model.GetTaegetCfgById(local_TeamModel.POLAR_DUN, sub_type)
			if (cfg) {
				team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24017, "ccihhi", local_TeamModel.POLAR_DUN, sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, data.id)
			}
		}

		//this.updateMenu = () => {
		//let team_info = team_model.team_info
		//if (team_info ) {
		//let str = ""
		//

		//if (local_DungeonPolarView.Team_Menu_Type.normal == team_model.join_con_value ) {
		//str = "普通"
		//},
		//if (local_DungeonPolarView.Team_Menu_Type.perfect == team_model.join_con_value ) {
		//str = "完美"
		//},
		//if (local_DungeonPolarView.Team_Menu_Type.epic == team_model.join_con_value ) {
		//str = "史诗"
		//}
		//}
		//
		////this._lb_menu.text = team_model.join_con_value
		//}
		//}

		this.CancelCountTime = () => {
			if (time_id) {
				GlobalTimerQuest.CancelQuest(time_id)
				time_id = null
			}
		}

		this.StartCountTime = (func?, time?) => {
			this.CancelCountTime()
			time_func = func
			time_id = GlobalTimerQuest.AddPeriodQuest(func, time)
			func()
		}

		this.UpdateBtn = () => {
			let team_info = team_model.team_info
			if (team_info && team_info.activity_id == local_TeamModel.POLAR_DUN) {
				if (team_model.IsLeaderInTeam(local_RoleManager.GetMainRoleId())) {
					this.lb_team_go.text = "队伍进入"
				} else {
					this.lb_team_go.text = "催促开车"
				}
			} else {
				this.lb_team_go.text = "单人进入"
			}
		}
	}

	public DeleteMe() {

		if(this.tab_loop_mgr){
			this.tab_loop_mgr.DeleteMe()
			this.tab_loop_mgr=null
		}

		if (this.room_loop_mgr) {
			this.room_loop_mgr.DeleteMe()
			this.room_loop_mgr = null
		}

		if (this.select_index) {
			this.select_index.DeleteMe()
			this.select_index = null
		}

		if (this.menu_item) {
			this.menu_item.DeleteMe()
			this.menu_item = null
		}

		for (let key in this.single_reward_list) {

			let item = this.single_reward_list[key]
			item.DeleteMe()
		}
		this.single_reward_list = []
		for (let key in this.team_reward_list) {

			let item = this.team_reward_list[key]
			item.DeleteMe()
		}
		this.team_reward_list = []
		for (let _tmpi in this.role_item_list) {
			var v = this.role_item_list[_tmpi]
			v.DeleteMe()
		}
		this.role_item_list = []
		this.CancelCountTime()

		super.DeleteMe()
	}




_img_bg:Laya.Image
_gp_room:Laya.Box
_Image11111:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_gp_role_con:Laya.Box
_Image4:Laya.Image
_Image5:Laya.Image
_Image6:Laya.Image
_gp_auto_add:Laya.Box
_Label1:Laya.Label
_img_gx:Laya.Image
_Image7:Laya.Image
_txt_title1:Laya.Text
_Label2:Laya.Label
_Image11:Laya.Image
_Label3:Laya.Label
_btn_recruit:Laya.Box
_Image111:Laya.Image
labelDisplay1:Laya.Label
_btn_team_go:Laya.Box
_Image111111:Laya.Image
lb_team_go:Laya.Label
_menu:Laya.Box
_box_left:Laya.Box
_img_left1:Laya.Image
_box_right:Laya.Box
_img_right1:Laya.Image
tab_con:Laya.List
_gp_null:Laya.Box
_img_big_title:Laya.Image
_img_con_bg1:Laya.Image
_img_con_bg21:Laya.Image
_img_con_bg22:Laya.Image
_img_title_bg1:Laya.Image
_Label4:Laya.Label
_Scroller1:Laya.Panel
_lb_desc:Laya.HTMLDivElement
_img_con_bg2:Laya.Image
_img_title_bg2:Laya.Image
_Label8:Laya.Label
_scroll_con2:Laya.Panel
con2:Laya.HBox
_img_con_bg3:Laya.Image
_img_title_bg3:Laya.Image
_Label9:Laya.Label
_scroll_con3:Laya.Panel
con3:Laya.HBox
_gp_join:Laya.Box
_Label10:Laya.Label
_img_join:Laya.Image
_lb_join:Laya.Label
_gp_pass:Laya.Box
_Label11:Laya.Label
_Image12:Laya.Image
_gp_pass2:Laya.Box
_Label12:Laya.Label
_Image13:Laya.Image
_lb_pass_num:Laya.Label
_btn_myself:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
_btn_team:Laya.Box
_Image1111:Laya.Image
labelDisplay11:Laya.Label
_rank:Laya.Image
_reward:Laya.Image
_gp_hall:Laya.Box
_Image14:Laya.Image
_Image15:Laya.Image
_Image16:Laya.Image
room_con:Laya.List
_gp_none:Laya.Box
_Image18:Laya.Image
_Image19:Laya.Image
_Label13:Laya.Label
_lb_create_team:Laya.Label
public GetComponents() {
[
this._img_bg,
this._gp_room,
this._Image11111,
this._Image2,
this._Image3,
this._gp_role_con,
this._Image4,
this._Image5,
this._Image6,
this._gp_auto_add,
this._Label1,
this._img_gx,
this._Image7,
this._txt_title1,
this._Label2,
this._Image11,
this._Label3,
this._btn_recruit,
this._Image111,
this.labelDisplay1,
this._btn_team_go,
this._Image111111,
this.lb_team_go,
this._menu,
this._box_left,
this._img_left1,
this._box_right,
this._img_right1,
this.tab_con,
this._gp_null,
this._img_big_title,
this._img_con_bg1,
this._img_con_bg21,
this._img_con_bg22,
this._img_title_bg1,
this._Label4,
this._Scroller1,
this._lb_desc,
this._img_con_bg2,
this._img_title_bg2,
this._Label8,
this._scroll_con2,
this.con2,
this._img_con_bg3,
this._img_title_bg3,
this._Label9,
this._scroll_con3,
this.con3,
this._gp_join,
this._Label10,
this._img_join,
this._lb_join,
this._gp_pass,
this._Label11,
this._Image12,
this._gp_pass2,
this._Label12,
this._Image13,
this._lb_pass_num,
this._btn_myself,
this._Image1,
this.labelDisplay,
this._btn_team,
this._Image1111,
this.labelDisplay11,
this._rank,
this._reward,
this._gp_hall,
this._Image14,
this._Image15,
this._Image16,
this.room_con,
this._gp_none,
this._Image18,
this._Image19,
this._Label13,
this._lb_create_team,
]
 = this.GetChildrenByNames([

"_img_bg",
"_gp_room",
"_Image11111",
"_Image2",
"_Image3",
"_gp_role_con",
"_Image4",
"_Image5",
"_Image6",
"_gp_auto_add",
"_Label1",
"_img_gx",
"_Image7",
"_txt_title1",
"_Label2",
"_Image11",
"_Label3",
"_btn_recruit",
"_Image111",
"labelDisplay1",
"_btn_team_go",
"_Image111111",
"lb_team_go",
"_menu",
"_box_left",
"_img_left1",
"_box_right",
"_img_right1",
"tab_con",
"_gp_null",
"_img_big_title",
"_img_con_bg1",
"_img_con_bg21",
"_img_con_bg22",
"_img_title_bg1",
"_Label4",
"_Scroller1",
"_lb_desc",
"_img_con_bg2",
"_img_title_bg2",
"_Label8",
"_scroll_con2",
"con2",
"_img_con_bg3",
"_img_title_bg3",
"_Label9",
"_scroll_con3",
"con3",
"_gp_join",
"_Label10",
"_img_join",
"_lb_join",
"_gp_pass",
"_Label11",
"_Image12",
"_gp_pass2",
"_Label12",
"_Image13",
"_lb_pass_num",
"_btn_myself",
"_Image1",
"labelDisplay",
"_btn_team",
"_Image1111",
"labelDisplay11",
"_rank",
"_reward",
"_gp_hall",
"_Image14",
"_Image15",
"_Image16",
"room_con",
"_gp_none",
"_Image18",
"_Image19",
"_Label13",
"_lb_create_team",
])
}
}
 window["DungeonPolarView"]= DungeonPolarView