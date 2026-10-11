import { Alert, Alert_Type } from "../alert/Alert"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest, Util, Trim, LoadLuaClassAB, SetAnchoredPositionY, SetLocalScale, SetAnchoredPosition, CommonCrossFadeAnim, RefBoxChildsLayout, RefGridLayout, SetAnchoredPositionX } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { MainUIModel } from "../commonModel/MainUIModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ActivityIcon } from "./ActivityIcon"
import { SYTweenLite } from "../util/SYTweenLite"
import { MainUIManager } from "../common/MainUIManager"
import { Mathf } from "../util/Mathf"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { GodBefallEvent, GodBefallModel } from "../commonModel/GodBefallModel"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { RedPacketEvent, RedPacketModel } from "../commonModel/RedPacketModel"
import { WelfareEvent, WelfareModel } from "../commonModel/WelfareModel"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { FirstBloodModel, FirstBloodEvent } from "../commonModel/FirstBloodModel"
import { MainUISkillItemGod } from "./MainUISkillItemGod"
import { FriendEvent, FriendModel, FRIEND_TYPE } from "../commonModel/FriendModel"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { BrightSeaEvent, BrightSeaModel } from "../commonModel/BrightSeaModel"
import { OutLineModel } from "../commonModel/OutLineModel"
import { WordManager } from "../common/WordManager"
import { PlatformManager } from "../PlatformManager"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { FuncBoardView } from "./FuncBoardView"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { DailyModel } from "../commonModel/DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { OnHookModel } from "../commonModel/OnHookModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { FirstRechargeNewTipsView } from "../recharge/FirstRechargeNewTipsView"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { StoryModel } from "../commonModel/StoryModel"
import { OperateManager, SourceOperateType } from "../operation/OperateManager"
import { ItemInfoItem } from "../common/ItemInfoItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TimeUtil } from "../util/TimeUtil"
import { GameResPath } from "../util/GameResPath"
// import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
// import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"

let local_Util = Util
export class MainUISecondaryView extends BaseView1 {

	public static BossIcon = "4601"
	public static DungeonIcon = "610"

	notice_shake_list
	hgap = 5
	vgap = 5
	left_hide_pos = { x: -20, y: 0 }
	right_hide_pos = { x: -50, y: -40 }
	notice_hide_pos = { x: -50, y: 315 }
	strengthen_icon_pos = { x: -249, y: 6 } //我要变强图标位置
	exp_ani_time_line: Laya.TimeLine
	red_packet_rain_ani
	auto_state_effect_name
	state_effect_time_id

	is_starting_record
	//主动暂停
	is_initiative_to_stop
	//录屏完成	
	record_finish
	//已录制好的视频资源
	record_res
	record_start_time
	record_end_time
	recorder
	//抖音客服
	tt_kefu_btn

	LoadSuccess
	InitEvent
	Remove
	AddNotificationTween
	ClearMarriForeTween
	ClearTeamTween
	ClearTimer
	ClearTween
	CreateForeShowIcon
	CreateGodItem
	CreateLeftActivityIcon
	CreateRightActivityIcon
	CreateNoticeActivityIcon
	GetIconPos
	InitActivityIcon
	IsActiveGuildHelp
	IsActiveNotification
	PlayHide
	PlayNotificationAnimation
	Tween_1
	Tween_2
	PlayOpen
	RefOutlineExp
	RefreshGroupPos
	RefreshIcon
	RefreshIconPos
	SetAutoFightBtn
	SetGroupVisible
	SetHasGuideIconAtLast
	SetRightConPos
	ShowAnimation
	ShowExpAnimation
	SortFun
	StopNotificationTweenByType
	TryRefreshAllIcon
	UpdateRightConPos
	UpdateSeaBtnStatus
	UpdateTeamEffect
	UpdateChatEffect
	UpdateEmailEffect
	UpdateHelpEffect
	UpdatePleaseEffect
	UpdateRedPacketEffect
	UpdateRedGiftPushEffect
	UpdateNotificationMoveState
	UpdateAutoStateEffectPos
	UpdateNotification
	UpdateAutoStateEffect
	TryUpdateAutoStateEffect
	IsHaveChatInfo
	GetLineMaxIconNum
	UpdateDailyResFindEffect
	GetFirstChargeIcon
	first_tips_item
	AddOutlineEffect
	DeleteOutlineEffect
	CheckIsStrengthenIcon
	updateRPREffect
	UpdateLevelRewardEffect
	InitTT
	TTRecordFun
	TTStopRecord
	TTShowRecord
	ShowTTKeFuBtn
	HideTTKeFuBtn
	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "MainUISecondaryView"
		this.layer_value = Enum_UILayer.Main
		this.is_delay_callback = false

		let local_MainUIModel_Instance = MainUIModel.GetInstance(),
			local_MainUIModel = MainUIModel,
			local_GlobalEventSystem = GlobalEventSystem,
			local_EventName = EventName,
			local_ActivityIconManager = ActivityIconManager,
			local_Message = Message,
			local_OpenFun = OpenFun,
			local_SceneEventType = SceneEventType,
			local_AutoFightManager_Instance = AutoFightManager.GetInstance(),
			local_CommonManager_Instance = CommonManager.GetInstance(),
			local_ActivityIcon = ActivityIcon,
			local_Scene_Instance = Scene.GetInstance(),
			local_Mathf = Mathf,
			local_FriendEvent = FriendEvent,
			local_ChatModelEvent = ChatModelEvent,
			local_TaskModel_Instance = TaskModel.GetInstance(),
			local_TaskModel = TaskModel,
			local_TeamModel_Instance = TeamModel.GetInstance(),
			local_TeamEvent = TeamEvent,
			local_GodBefallModel_Instance = GodBefallModel.GetInstance(),
			local_SceneManager_Instance = SceneManager.GetInstance(),
			local_SeaHegemonyModel_Instance = SeaHegemonyModel.GetInstance(),
			brightSea_model = BrightSeaModel.GetInstance(),
			first_blood_model = FirstBloodModel.GetInstance(),
			rm_map_model = TreasureMapModel,
			tm_model = rm_map_model.GetInstance(),

			click_tips_cache_ = null,
			time_id_ = null,
			is_show_ = true,
			is_moving_ = false,
			tween_event_list_ = [],
			delay_refresh_time_id_,
			ani_end_need_refresh_icon_ = false,
			notification_tween_dic_ = [],
			notification_type = {
				Mail: 1,
				Chat: 2,
				RedPacket: 3,
				BrightSea: 4,
				FirsetBlood: 5,
				Team: 6,
				GuildHelp: 7,
				DailyFind: 8,
				GiftPush: 9,
				LevelReward:10
			},
			god_item,
			please_id,
			first_info,
			first_tween,
			fore_tween_id,
			group_visible_cache,
			right_con_pos_state,
			shop_tween,
			show_first,
			team_timer_id,
			team_tween_ids,
			left_icon_dic_ = {},
			right_icon_dic_ = {},
			notice_icon_dic_ = {},
			marri_foreshow,
			timer_id,
			add_effect

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.destroy_callback = () => {
			this.Remove()
		}

		this.Remove = () => {
			if (notification_tween_dic_) {
				for (let _ in notification_tween_dic_) {
					var tween_tb = notification_tween_dic_[_]
					for (let _ in tween_tb) {
						var tween_id = tween_tb[_]
						SYTweenLite.Stop(tween_id)
					}
				}
				notification_tween_dic_ = []
			}

			if (team_timer_id) {
				GlobalTimerQuest.CancelQuest(team_timer_id)
			}
			if (this.red_packet_rain_ani) {
				SYTweenLite.Stop(this.red_packet_rain_ani)
				this.red_packet_rain_ani = null
			}
			this.DeleteOutlineEffect()
			this.ClearTeamTween()
			this.ClearTween()
			this.ClearTimer()
			this.ClearMarriForeTween()
			MainUIManager.GetInstance().RemoveMoveComponent(this)
		}

		this.LoadSuccess = () => {

			this._lb_outline_exp.style.fontSize = 18
			this._lb_outline_exp.style.color = "#ffffff"
			this._lb_outline_exp.style.wordWrap = false


			local_MainUIModel_Instance.SetMainuiLoadedFlag(this.layout_file, true, this)

			this.display_obj.left = 0
			this.display_obj.right = 0
			this.display_obj.bottom = 290
			// 首充图标的气泡层级需要比上面的ActivityIcon高
			// this.display_obj.zOrder = 1;

			this._box_outline_exp.y = -180

			click_tips_cache_ = is_show_

			this._box_god.visible = false

			this.CreateGodItem()

			// 璀璨之海状态
			this.UpdateSeaBtnStatus()

			this._box_notification_bar.visible = this.IsActiveNotification()
			this._box_help.visible = this.IsActiveGuildHelp()

			this.InitEvent()
			this.RefOutlineExp()

			if (MarriageModel.GetInstance().show_icon) {
				this.CreateForeShowIcon(MarriageModel.GetInstance().show_icon)
				MarriageModel.GetInstance().show_icon = null
			}

			if (group_visible_cache != null) {
				this.SetGroupVisible(group_visible_cache)
			}

			if (right_con_pos_state != null) {
				this.SetRightConPos(right_con_pos_state)
			}

			MainUIManager.GetInstance().AddMoveComponent(this, this._box_left, true, MainUIManager.MOVE_TYPE.Stay)


			//检查红包状态
			RedPacketModel.GetInstance().CheckRedStatus()

			this.InitActivityIcon()
			this.UpdateDailyResFindEffect()
			this.UpdateLevelRewardEffect()
			this.UpdateRedGiftPushEffect()
			this.UpdateNotificationMoveState()
			this.UpdateAutoStateEffect()
			this.UpdateAutoStateEffectPos()

			this.InitTT()
		}

		//第一次添加到舞台的时候调用
		this.createChildren = () => {
			if (this["GetComponents"]) {
				this["GetComponents"]()
				this.is_get = true
			}
			// this.story_obj_list = this.story_obj_list || {}
			// this.story_obj_list[TaskTipType.AfkReceiveTimes] = [this._box_exp_btn]

			this.story_target_name_dic = {}
			this.story_target_name_dic[StoryModel.StoryTargetName.AfkReceiveBtn] = this._box_exp_btn
			super.createChildren()
		}

		this.UpdateNotificationMoveState = () => {
			let show_state = local_SceneManager_Instance.IsGhostWalkScene()
			if (show_state) {
				MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_notification_bar, true)
			}
			else{
				this._box_notification_bar.visible = true
				this._box_notification_bar.alpha = 1
				MainUIManager.GetInstance().AddMoveComponent(this, this._box_notification_bar, true, MainUIManager.MOVE_TYPE.Stay)
			}
			
		}

		this.UpdateAutoStateEffectPos = () => {
			let field_scene = local_SceneManager_Instance.IsFieldScene()
			if(field_scene){
				MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_auto_effect, true)
				this._box_auto_effect.visible = true
				this._box_auto_effect.y = -350
			}
			else{
				let ghost_walk_scene = local_SceneManager_Instance.IsGhostWalkScene()
				if(ghost_walk_scene){
					MainUIManager.GetInstance().RemoveMoveOneComponent(this, this._box_auto_effect, true)
					this._box_auto_effect.visible = false
				}
				else{
					this._box_auto_effect.visible = true
					this._box_auto_effect.alpha = 1
					this._box_auto_effect.y = -250
					MainUIManager.GetInstance().AddMoveComponent(this, this._box_auto_effect, false, MainUIManager.MOVE_TYPE.Stay)
				}
			}
			
		}

		this.InitEvent = () => {
			Util.AddClickEvent(
				this._img_turn, () => {
					click_tips_cache_ = this.ShowAnimation(!click_tips_cache_)
				},
				this,
				true
			)

			//藏宝图寻路中
			this.BindEvent(tm_model, rm_map_model.TM_FINDING_WAY, (bool) => {
				this._gp_t_map.visible = bool
				if (bool) {
					this.AddUIEffect("ui_2114_01", this._gp_t_map, { x: 0, y: 0 }, 18, true);
				}
				else {
					this.ClearUIEffect(this._gp_t_map)
				}
			})

			this.BindEvent(GlobalEventSystem, SceneManager.START, ()=>{
				this.UpdateNotificationMoveState()
				this.UpdateAutoStateEffectPos()
			})
			
			/* 	this.BindEvent(tm_model, rm_map_model.TM_ROTARY_NUM, (scmd?) => {
					let list = tm_model.BossGetListByType(BossBaseModel.BossType.field)
					let bool = list && list.length
					this._gp_fieldTreasure.visible = this._gp_fieldTreasure.includeInLayout = bool
					if (bool)
						this._lb_field_num.text = `${list.length}`
					list = tm_model.BossGetListByType(BossBaseModel.BossType.mystery)
					bool = list && list.length
					this._gp_mysteryTreasure.visible = this._gp_mysteryTreasure.includeInLayout = bool
					if (bool)
						this._lb_mystery_num.text = `${list.length}`
					this._gp_con_0.validateNow()
					tm_model.Fire(rm_map_model.TM_ROTARY_UPDATA)
					if (scmd) {
						tm_model.BossTtOpenEnterView(scmd)
					}
				}) */

			// Util.AddClickEvent(
			// 	this._gp_pkrecord, () => {
			// 		local_BossBaseModel_Instance.Fire(local_BossBaseModel.OPEN_KILL_RECORD_VIEW)
			// 		this.ShowPkrecord(false)
			// 	},
			// 	this,
			// 	true
			// )

			Util.AddClickEvent(
				this._img_team, () => {
					if (local_SceneManager_Instance.ShowTeamScene()) {
						local_TeamModel_Instance.Fire(local_TeamEvent.TEAM_OPEN_VIEW, "TeamBeInvitedView")
					} else {
						local_Message.show("本场景不允许组队作战")
					}
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._img_email, () => {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_FRIEND_VIEW, { index: 2 })
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._box_gift_push, () => {
					PushGiftModel.GetInstance().Fire(
						PushGiftModel.OPEN_VIEW,
						'PushGiftEntView'
					);
				},
				this,
				true
			)
		
			Util.AddClickEvent(
				this._img_chat, () => {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_FRIEND_VIEW, { index: 1 })
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._box_please, () => {
					let str = "Ta在您耳边温柔的说：\n亲爱滴，帮我买个礼包好不好！"
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageGiftTipsView", str)
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._img_red_packet, () => {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "RedPacketMainView")
					this.UpdateRedPacketEffect(false)
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._img_help, () => {
					this.UpdateHelpEffect(false)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GuildHelpView")
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._img_daily_find, () => {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DailyView", 3)
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._img_level_rew, () => {
					OpenFun.OpenFunHandler(200)
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._box_firstblood, () => {
					first_info = first_blood_model.shared_reward_state_list
					table.sort(first_info, (a?, b?) => {
						return a.boss_id < b.boss_id
					})
					let vo2 = null
					for (let key in first_info) {
						let vo = first_info[key]
						if (vo.shared_status == 0) {
							vo2 = vo
							break
						}
					}
					if (vo2) {
						let info1
						let kill_info = first_blood_model.GetKillInfo(96, 1)
						if (kill_info && kill_info.first_blood_list) {
							for (let k in kill_info.first_blood_list) {
								var v = kill_info.first_blood_list[k]
								if (vo2.boss_id == v.boss_id) {
									info1 = v
								}
							}
						}
						let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, info1.boss_id, false)
						Alert.Show("<font color='#639c12'>" + Trim(info1.first_blood_role_name) + "</font>击败<font color='#FF4F50'>" + Trim(cfg.name) + "</font>获得全服首杀，<br/>赠予全服玩家礼物", Alert_Type.One, () => {
							OpenFun.OpenFunHandler(188)
						}
							, null, "前往领取")
					} else {
						//没有全服归属奖励可领的话
						Alert.Show("大妖开荒达成个人奖励", Alert_Type.One, () => {
							OpenFun.OpenFunHandler(188)
						}, null, "前往领取")
					}
				},
				this,
				false
			)

			Util.AddClickEvent(
				this._box_sea, () => {
					brightSea_model.ShowNotification()
				},
				this,
				true
			)
			Util.AddClickEvent(this._img_rpr, () => {
				// this.updateRPREffect(false)
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.WAVE_RED_PACKET, false)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "RPRShowView");
			}, this, true)

			this.BindEvent(
				brightSea_model,
				BrightSeaEvent.UPDATE_NOTIFICATION_ADD, (bool?) => {
					this.UpdateSeaBtnStatus()
				}
			)

			this.BindEvent(
				local_SeaHegemonyModel_Instance,
				SeaHegemonyModel.ASSERT_BRICK_ID_CHANGE, () => {
					if (this._box_notification_bar) {
						this._box_notification_bar.visible = this.IsActiveNotification()
					}
				}
			)
			CustomActivityModel.GetInstance().Bind(CustomActivityDefine.EVENT.WAVE_RED_PACKET, (is_show) => {
				this.updateRPREffect(is_show)
			})

			this.BindEvent(
				local_MainUIModel_Instance,
				local_MainUIModel.CHANGE_ACTIVITY_STATE, (bool?) => {
					click_tips_cache_ = this.ShowAnimation(bool)
				}
			)

			this.BindEvent(
				local_GlobalEventSystem,
				local_ActivityIconManager.ADD_ICON, (icon_type, location_type) => {
					if (location_type == ActivityIconManager.LocationType.Left) {
						this.CreateLeftActivityIcon(icon_type)
					} else if (location_type == ActivityIconManager.LocationType.Right) {
						this.CreateRightActivityIcon(icon_type)
					} else if (location_type == ActivityIconManager.LocationType.Notice) {
						this.CreateNoticeActivityIcon(icon_type)
					}
				}
			)

			this.BindEvent(
				local_GlobalEventSystem,
				local_ActivityIconManager.DELETE_ICON, (icon_type?) => {
					let item = left_icon_dic_[icon_type]
					if (item) {
						item.to_delete = true
						this.TryRefreshAllIcon()
						return
					}
					item = right_icon_dic_[icon_type]
					if (item) {
						item.to_delete = true
						this.TryRefreshAllIcon()
					}
					item = notice_icon_dic_[icon_type]
					if (item) {
						item.to_delete = true
						this.TryRefreshAllIcon()
					}
				}
			)


			let chnage_fun = () => {
				this.SetAutoFightBtn()
			}
			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.SCENE_CHANGED, chnage_fun)


			this.BindEvent(FriendModel.GetInstance(), local_FriendEvent.EMAIL_ICON_UPDATE, () => {
				this.UpdateEmailEffect()
			})

			this.BindEvent(FriendModel.GetInstance(), local_FriendEvent.EMAIL_VIEW_OPEN, () => {
				this.UpdateEmailEffect()
			})

			this.BindEvent(FriendModel.GetInstance(), local_FriendEvent.EMAIL_DATA_UPDATE, () => {
				this.UpdateEmailEffect()
			})

			this.BindEvent(FriendModel.GetInstance(), local_FriendEvent.NEWAPPLY_CHANGE, () => {
				this.UpdateChatEffect()
			})

			this.BindEvent(FriendModel.GetInstance(), local_FriendEvent.FRIEND_REDDOT_UPDATE, () => {
				this.UpdateChatEffect()
			})

			this.BindEvent(local_GlobalEventSystem, local_EventName.OPEN_FRIEND_VIEW, (obj?) => {
				if (obj.index == 0) {
					this.UpdateChatEffect(true)
				}
			})

			this.BindEvent(ChatModel.GetInstance(), local_ChatModelEvent.CHAT_MSG_NUM_UPDATE, () => {
				this.UpdateChatEffect()
			})

			this.BindEvent(ChatModel.GetInstance(), local_ChatModelEvent.CHAT_MSG_UPDATE, () => {
				this.UpdateChatEffect()
			})
			this.BindEvent(MainUIModel.GetInstance(), MainUIModel.REFRESH_FRIEND_AND_MAIL_RED, () => {
				this.UpdateEmailEffect()
				this.UpdateChatEffect()
			})
			FriendModel.GetInstance().Fire(FriendEvent.EMAIL_REWARD_UPDATE)
			FriendModel.GetInstance().Fire(FriendEvent.FRIEND_REDDOT_UPDATE)
			this.BindEvent(MarriageModel.GetInstance(), MarriageEvent.UPDATE_PLEASE_STATE, (is_show?) => {
				this.UpdatePleaseEffect(is_show)
			})

			this.BindEvent(RedPacketModel.GetInstance(), RedPacketEvent.RED_TIPS, (is_show?) => {
				this.UpdateRedPacketEffect(is_show)
				RedPacketModel.GetInstance().SetFristMark(false)
			})

			this.BindEvent(WelfareModel.GetInstance(), WelfareEvent.UPDATE_LEVEL_REWARD_VIEW, () => {
				console.warn("消失")
				this.UpdateLevelRewardEffect()
			})

			this.BindEvent(GuildModel.GetInstance(), GuildEvent.HAVE_HELP, (is_show?) => {
				this.UpdateHelpEffect(is_show)
			})

			this.BindEvent(DailyModel.GetInstance(), DailyEvent.UPDATE_RES_FIND_DATA, () => {
				this.UpdateDailyResFindEffect()
			})

			this.BindEvent(
				PushGiftModel.GetInstance(),
				PushGiftModel.UPDATE_MAIN_ICON,
				(icon_type?, bool?) => {
					if (icon_type == 191) { // 限时特惠
						this.UpdateRedGiftPushEffect();
					}
				}
			);

			// this.BindEvent(local_BossBaseModel_Instance, local_BossBaseModel.OPEN_REBORN_TIPS_VIEW, (reborn_info?, icon?) => {
			// 	LoadLuaClassAB("BossRebornTipsView", () => {
			// 		if (!boss_field_reborn_tips_) {
			// 			boss_field_reborn_tips_ = window["BossRebornTipsView"].New()
			// 		}
			// 		boss_field_reborn_tips_.SetRebornInfo(reborn_info)
			// 		boss_field_reborn_tips_.Open()
			// 	})
			// })

			if (god_item) {
				god_item.SetVisible(!local_SceneManager_Instance.IsForbidGodScene())
				this._box_god.visible = !is_show_ && !local_SceneManager_Instance.IsForbidGodScene() && local_GodBefallModel_Instance._cur_battle_id
			}

			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.SCENE_CHANGED, () => {
				if (this._box_help) {
					this._box_help.visible = this.IsActiveGuildHelp()
				}

				if (this._box_notification_bar) {
					this._box_notification_bar.visible = this.IsActiveNotification()
				}


				if (marri_foreshow && marri_foreshow.HasOpen()) {
					marri_foreshow.SetVisible(local_SceneManager_Instance.IsShowMarriageScene())
				}
			})

			//天数变化时会影响的东西
			this.BindEvent(local_GlobalEventSystem, ServerTimeModel.DAY_CHANGE, () => {
				if (this._box_help) {
					this._box_help.visible = this.IsActiveGuildHelp()
				}
			})

			//初始化服务器时间信息后才执行的操作
			let sever_time_id = local_GlobalEventSystem.Bind(ServerTimeModel.REFRESH_SERVER_TIME, () => {
				local_GlobalEventSystem.UnBind(sever_time_id)
				if (this._box_help) {
					this._box_help.visible = this.IsActiveGuildHelp()
				}
			}
			)

			this.BindEvent(local_TaskModel_Instance, local_TaskModel.UPDATE_ALL_TASK_FROM_30000, () => {
				this.RefreshGroupPos()
			})
			this.BindEvent(first_blood_model, FirstBloodEvent.ADD_FIRST_BLOOD_ICON, (show?, scmd?) => {
				this._box_firstblood.visible = show
				if (show && scmd) {
					first_info = scmd
					show_first = true
					// this._box_firstblood.left
					this.PlayNotificationAnimation(this._box_firstblood, notification_type.FirsetBlood)
				}
				if (!show) {
					first_info = null
					show_first = false
					// this.StopNotificationTweenByType(notification_type.FirsetBlood
					this.StopNotificationTweenByType(this._box_firstblood)
					// SetRotate(this._box_firstblood, 0, 0, 0)
				}
			})
			first_blood_model.Fire(FirstBloodEvent.OPEN_FIRST_ICON)

			this.BindEvent(local_GlobalEventSystem, local_EventName.HIDE_GOD_ICON, () => {
				if (this._box_god) {
					this._box_god.visible = false
				}
			}
			)

			this.BindEvent(local_TeamModel_Instance, local_TeamEvent.TEAM_UPDATE_BE_INVITED_LIST, () => {
				this.UpdateTeamEffect()
			})


			this.BindEvent(local_GodBefallModel_Instance, GodBefallEvent.ACTIVE_SUCCESS, () => {
				this.CreateGodItem()
			})

			this.BindEvent(local_GodBefallModel_Instance, GodBefallEvent.UPDATE_BATTLE_ID, () => {
				this.CreateGodItem()
			})

			this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "guild_id", () => {
				this._box_help.visible = this.IsActiveGuildHelp()
			})

			this.BindEvent(OnHookModel.GetInstance(), OnHookModel.REFRESH_EXP_EFFECT, () => {
				this.RefOutlineExp()
			})

			this.BindEvent(OnHookModel.GetInstance(), OnHookModel.UPDATE_MAINUI_VIEW_RED, () => {
				this.RefOutlineExp()
			})

			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_BUFF_DATA, () => {
				this.RefOutlineExp()
			})

			let guide_icon_fun = () => {
				this.SetHasGuideIconAtLast()
			}
			this.BindEvent(GlobalEventSystem, EventName.ACTIVITY_ICON_EFFECT, guide_icon_fun)
			this.BindEvent(GlobalEventSystem, EventName.CREATE_FINGER_SUCCESS, guide_icon_fun)
			this.BindEvent(GlobalEventSystem, EventName.SELECT_STORY_TARGET, guide_icon_fun)

			this.BindEvent(MarriageModel.GetInstance(), MarriageEvent.REF_FORESHOW, (icon?, bool?) => {
				this.CreateForeShowIcon(icon, bool)
			})


			this.BindEvent(GlobalEventSystem, local_EventName.CHANGE_ROLE, () => {
				this._box_firstblood.visible = false;
				this._box_gift_push.visible = false;
			})
			this.BindEvent(GlobalEventSystem, local_EventName.CHANGE_ACCOUNT, () => {
				this._box_firstblood.visible = false;
				this._box_gift_push.visible = false;
			})

			Util.AddClickEvent(this._box_exp_btn, () => {
				OnHookModel.GetInstance().Fire(OnHookModel.OPEN_VIEW, "OnHookMainView")
			}, this, true)

			Util.AddClickEvent(this._img_outline_exp_bg1, () => {
				OnHookModel.GetInstance().Fire(OnHookModel.OPEN_VIEW, "OnHookMainView")
			}, this, false)

			Util.AddClickEvent(this.add_btn, () => {
				OnHookModel.GetInstance().Fire(OnHookModel.OPEN_VIEW, "OnHookAdditionView")
			}, this, true)

			this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.ADD_FIRST_RECHARGE_NEW_TIPS_ITEM, (is_bubble) => {
				if (is_bubble == null) {
					if (!this.first_tips_item) {
						this.first_tips_item = new FirstRechargeNewTipsView(this._box_left)
					}
					this.first_tips_item.Load()
				}
			})

			this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.REMOVE_FIRST_RECHARGE_NEW_TIPS_ITEM, () => {
				if (this.first_tips_item) {
					this.first_tips_item.display_obj.visible = false
					this.first_tips_item.DeleteMe()
					this.first_tips_item = null
				}
			})

			this.BindEvent(GlobalEventSystem, EventName.UPDATE_NEWEST_TASK_ID, () => {
				let newest_finish_task_id = this.task_model.newest_finish_task_id
				if (newest_finish_task_id == TaskModel.AfkReceiveTimesTaskId) {
					this.RefOutlineExp()
				}
			})

			this.BindEvent(GlobalEventSystem, EventName.UPDATE_AUTO_FIGHT_STATE, () => {
				this.TryUpdateAutoStateEffect()
			})

			this.BindEvent(GlobalEventSystem, SceneEventType.MAIN_ROLE_PATH_START, () => {
				this.TryUpdateAutoStateEffect()
			})

			this.BindEvent(GlobalEventSystem, SceneEventType.MAIN_ROLE_PATH_FINISHED, () => {
				this.TryUpdateAutoStateEffect()
			})
		}

		this.IsActiveGuildHelp = () => {
			return GuildModel.GetInstance().IsCanOpenAssist() && !local_SceneManager_Instance.NotShowHelpScene()
		}

		this.IsActiveNotification = () => {
			let is_active = !local_SceneManager_Instance.NotShowNotificationScene()
			if (local_Scene_Instance.main_role) {
				is_active = is_active && local_Scene_Instance.main_role.vo.brick_id <= 0
			}
			return is_active
		}

		this.UpdateSeaBtnStatus = () => {
			let num = brightSea_model.CheckCruiseNotification()
			if (num > 1) {
				this._lb_sea_red_num.text = num
			} else {
				this._lb_sea_red_num.text = ""
			}
			this._box_sea.visible = num > 0
			this._box_sea_red.visible = num > 1
			if (num > 0) {
				this.PlayNotificationAnimation(this._box_sea, notification_type.BrightSea)
			} else {
				this.StopNotificationTweenByType(notification_type.BrightSea)
			}
		}

		this.AddNotificationTween = (ntype?, tween_id?) => {
			notification_tween_dic_[ntype] = notification_tween_dic_[ntype] || {}
			table.insert(notification_tween_dic_[ntype], tween_id)
		}

		this.StopNotificationTweenByType = (trans?) => {
			if (this.notice_shake_list && this.notice_shake_list[trans.name]) {
				delete this.notice_shake_list[trans.name]
			}

			//判断是否还有元素需要抖动
			let is_has = false
			for (let key in this.notice_shake_list) {
				is_has = true
				break
			}
			if (!is_has) {
				if (tween_update) {
					tween_update.recover()
					tween_update = null
				}

				if (tween_complete) {
					tween_complete.recover()
					tween_complete = null
				}
			}

			this.UpdateNotification()
		}
		this.updateRPREffect = (is_show): void => {
			this._img_rpr.visible = is_show
			if (this.red_packet_rain_ani && !is_show) {
				SYTweenLite.Stop(this.red_packet_rain_ani)
				this.red_packet_rain_ani = null
			}
			
			if (this._img_rpr.visible && is_show && !this.red_packet_rain_ani) {
				this._img_rpr.scaleX = this._img_rpr.scaleY = 1
				//this.red_packet_rain_ani = SYTweenLite.to(this, this._box_please, SYTweenLite.UiAnimationType.SCALE, { x: 0.8, y: 0.8, z: 0.8 }, 1.5, null, SYTweenFunc.PINGPONG, true)
				this.red_packet_rain_ani = SYTweenLite.to(this, this._img_rpr, SYTweenLite.UiAnimationType.SCALE, { x: 0.8, y: 0.8, z: 0.8 }, 0.5, null, SYTweenFunc.PINGPONG, true)
			}


		}

		let tween_update
		let tween_complete
		let origin
		let state
		let shake_rot = 20
		let shake_ease = Laya.Ease.sineInOut

		this.PlayNotificationAnimation = (trans?, ntype?) => {
			//布局
			this.UpdateNotification()

			let box_name = trans.name

			if (!this.notice_shake_list) {
				this.notice_shake_list = {}
			}

			//已经在抖动列表 进行回滚
			if (this.notice_shake_list[box_name]) {
				return
			}


			//全部暂停
			if (origin) {
				Laya.Tween.clearAll(origin)
			}

			//添加新成员
			this.notice_shake_list[box_name] = trans

			//属性
			origin = { rotation: 0 };
			let target: any = { rotation: shake_rot };

			if (!tween_update) {
				tween_update = Laya.Handler.create(this, (value?) => {
					for (let key in this.notice_shake_list) {
						this.notice_shake_list[key].rotation = origin.rotation
					}

				}, null, false)
			}


			if (!tween_complete) {
				tween_complete = Laya.Handler.create(this, () => {
					Laya.Tween.clearAll(origin)
					if (state == 1) {
						this.Tween_1()
					} else {
						this.Tween_2()
					}

				}, null, false)
			}

			state = 1
			Laya.Tween.to(origin, target, 1000, shake_ease, tween_complete).update = tween_update


		}

		//按钮晃动动画
		this.Tween_1 = () => {
			state = 2
			Laya.Tween.to(origin, { rotation: -shake_rot }, 1000, shake_ease, tween_complete).update = tween_update
		}
		this.Tween_2 = () => {
			state = 1
			Laya.Tween.to(origin, { rotation: shake_rot }, 1000, shake_ease, tween_complete).update = tween_update
		}

		this.ClearTimer = () => {
			if (time_id_) {
				clearTimeout(time_id_)
			}
		}

		this.ClearTween = () => {
			if (tween_event_list_) {
				for (let _ in tween_event_list_) {
					var key = tween_event_list_[_]
					SYTweenLite.Stop(key)
				}
				tween_event_list_ = []
			}
			SYTweenLite.Stop(shop_tween)
			SYTweenLite.Stop(first_tween)
		}

		this.UpdatePleaseEffect = (is_show?) => {
			this._box_please.visible = is_show
			if (please_id) {
				SYTweenLite.Stop(please_id)
			}
			if (this._box_please.visible) {
				please_id = SYTweenLite.to(this, this._box_please, SYTweenLite.UiAnimationType.SCALE, { x: 0.8, y: 0.8, z: 0.8 }, 1.5, null, SYTweenFunc.PINGPONG, true)
			}
		}

		this.UpdateRedPacketEffect = (is_show?) => {
			this._img_red_packet.visible = is_show
			this._box_red_packet.visible = is_show
			if (is_show) {

				this.PlayNotificationAnimation(this._box_red_packet, notification_type.RedPacket)
			} else {
				// this.StopNotificationTweenByType(notification_type.RedPacket)
				this.StopNotificationTweenByType(this._box_red_packet)
			}
		}

		this.UpdateLevelRewardEffect = () => {
			let is_show = WelfareModel.GetInstance().GetLevelRewardRed()
			this._img_level_rew.visible = is_show
			this._box_level_rew.visible = is_show
			if (is_show) {
				this.PlayNotificationAnimation(this._box_level_rew, notification_type.LevelReward)
			} else {
				this.StopNotificationTweenByType(this._box_level_rew)
			}
		}

		this.UpdateNotification = () => {
			RefBoxChildsLayout(this._box_notification_bar, 2, 55, true)
		}

		this.UpdateHelpEffect = (is_show?) => {
			this._box_help_tips.visible = is_show
			if (is_show) {
				//this.PlayNotificationAnimation(this._box_help, notification_type.GuildHelp)
			} else {
				//this.StopNotificationTweenByType(this._box_help)
			}
		}

		this.UpdateEmailEffect = () => {
			let flag = FriendModel.GetInstance().GetemailRedDot()
			let last_flag = this._img_email.visible
			this._img_email.visible = flag
			this._box_email.visible = flag

			if (flag) {
				this.PlayNotificationAnimation(this._box_email, notification_type.Mail)
			} else {
				this.StopNotificationTweenByType(this._box_email)
			}
		}

		this.UpdateChatEffect = (close?) => {
			if (close == null) {
				close = false
			}
			let flag = (close && (false) || (FriendModel.GetInstance().GethaveNewApply() || this.IsHaveChatInfo()))
			let last_flag = this._img_chat.visible
			this._box_chat.visible = flag
			this._img_chat.visible = flag
			if (flag) {
				this.PlayNotificationAnimation(this._box_chat, notification_type.Chat)
			} else {
				this.StopNotificationTweenByType(this._box_chat)
			}

		}

		this.UpdateDailyResFindEffect = () => {
			let flag = DailyModel.GetInstance().ResNormalCanFind() //&& DailyModel.GetInstance().res_find_dot_not_show == false

			this._img_daily_find.visible = flag
			this._box_daily_find.visible = flag

			if (flag) {
				this.PlayNotificationAnimation(this._box_daily_find, notification_type.DailyFind)
			} else {
				this.StopNotificationTweenByType(this._box_daily_find)
			}
		}

		this.UpdateRedGiftPushEffect = () => {
			let bool: boolean = PushGiftModel.GetInstance().GetGiftRed();
			this._box_gift_push.visible = bool;
			if (bool) {
				this.PlayNotificationAnimation(this._box_gift_push, notification_type.GiftPush)
			} else {
				this.StopNotificationTweenByType(this._box_gift_push)
			}
		}


		this.IsHaveChatInfo = () => {
			let list = FriendModel.GetInstance().getFriendData(FRIEND_TYPE.FRIEND)//判断是否有未读消息
			let num = 0
			for (let key in list) {
				let vo = list[key]
				let obj = ChatModel.GetInstance().getChannelChat(CHAT_TYPE.PRIVATE_CHAT)
				let sendId = vo.role_id
				if (obj[sendId] && sendId != FriendModel.GetInstance().openChatId) {
					num = obj[sendId][1]
				}
				if (num > 0) {
					return true
				}
			}
			return false
		}

		this.InitActivityIcon = () => {
			for (let key in ActivityIconManager.GetInstance().icon_info_dic) {
				let iconInfo = local_CommonManager_Instance.GetFunctionIconCfg(key)
				if (iconInfo) {
					if (PlatformManager.GetInstance().is_alpha && iconInfo.need_hide_in_alpha) continue
					if (iconInfo.location_type == ActivityIconManager.LocationType.Left) {
						this.CreateLeftActivityIcon(key)
					} else if (iconInfo.location_type == ActivityIconManager.LocationType.Right) {
						this.CreateRightActivityIcon(key)
					} else if (iconInfo.location_type == ActivityIconManager.LocationType.Notice) {
						this.CreateNoticeActivityIcon(key)
					}
				}
			}
		}

		this.TryRefreshAllIcon = () => {

			if (is_moving_) {
				ani_end_need_refresh_icon_ = true
				return
			}

			if (delay_refresh_time_id_) {
				return
			}

			delay_refresh_time_id_ = setTimeout(() => {
				delay_refresh_time_id_ = false
				this.RefreshIcon(left_icon_dic_, ActivityIconManager.LocationType.Left)
				this.RefreshIcon(right_icon_dic_, ActivityIconManager.LocationType.Right)
				this.RefreshIcon(notice_icon_dic_, ActivityIconManager.LocationType.Notice)
			}, 500)
		}

		this.CreateLeftActivityIcon = (icon_type?) => {
			let item = left_icon_dic_[icon_type]
			if (!item) {
				item = new local_ActivityIcon(this._box_left)
				item.SetVisible(false)
				item.SetIconType(icon_type)
				item.Load()
				left_icon_dic_[icon_type] = item
				item.ExcuteCallback(() => {
					this.TryRefreshAllIcon()
				}
				)
			}
			this.SetHasGuideIconAtLast()
		}

		this.CreateRightActivityIcon = (icon_type?) => {
			let item = right_icon_dic_[icon_type]
			if (!item) {
				item = new local_ActivityIcon(this._box_right)
				item.SetIconType(icon_type)

				item.Load()
				item.SetVisible(false)
				right_icon_dic_[icon_type] = item
				item.ExcuteCallback(() => {
					this.TryRefreshAllIcon()
				})
			}
			this.SetHasGuideIconAtLast()
		}

		this.CreateNoticeActivityIcon = (icon_type?) => {
			let item = notice_icon_dic_[icon_type]
			if (!item) {
				item = new local_ActivityIcon(this._box_notice)
				item.SetIconType(icon_type)

				item.Load()
				item.SetVisible(false)
				notice_icon_dic_[icon_type] = item
				item.ExcuteCallback(() => {
					this.TryRefreshAllIcon()
				}
				)
			} else {
				item.SetIconImg()
				item.RefTimer()
				item.SetCountTimer()
			}
			this.SetHasGuideIconAtLast()
		}

		this.SetHasGuideIconAtLast = () => {
			// if (this.story_model.now_story_target_name && (this.story_model.now_story_target_name == StoryModel.StoryTargetName.SingleDungeon
			// 	|| this.story_model.now_story_target_name == StoryModel.StoryTargetName.BossDungeon)) {
			// 	let icon = right_icon_dic_[MainUISecondaryView.BossIcon]
			// 	if (icon) {
			// 		icon.SetAsLastSibling(true)
			// 	}
			// 	icon = right_icon_dic_[MainUISecondaryView.DungeonIcon]
			// 	if (icon) {
			// 		icon.SetAsLastSibling(true)
			// 	}
			// }
		}

		this.SortFun = (list) => {
			let sort_fun = (a?, b?) => {
				if (a && b) {
					let iconInfoA = local_CommonManager_Instance.GetFunctionIconCfg(a.icon_type)
					let iconInfoB = local_CommonManager_Instance.GetFunctionIconCfg(b.icon_type)
					if (iconInfoA && iconInfoB) {
						return iconInfoA.pos_index < iconInfoB.pos_index
					}
				}
			}

			if (list) {
				table.sort(list, sort_fun)
			}
			return list
		}

		this.RefreshIcon = (list, location_type) => {
			if (!list) return
			for (let key in list) {
				if (list[key] && list[key].to_delete) {
					list[key].DeleteMe()
					list[key] = null
				}
			}
			let icon_arr = []
			for (let key in list) {
				table.insert(icon_arr, list[key])
			}
			this.SortFun(icon_arr)
			let icon = null
			let index = 1
			for (let i = icon_arr.length - 1; i >= 0; i--) {
				icon = icon_arr[i]
				if (icon) {
					if (location_type == ActivityIconManager.LocationType.Left) {
						if (this._box_left.numChildren > 0) {
							icon.display_obj.parent.addChildAt(icon.display_obj, this._box_left.numChildren - index)
						}
					} else if (location_type == ActivityIconManager.LocationType.Right) {
						if (this._box_right.numChildren > 0) {
							icon.display_obj.parent.addChildAt(icon.display_obj, this._box_right.numChildren - index)
						}
					} else if (location_type == ActivityIconManager.LocationType.Notice) {
						if (this._box_notice.numChildren > 0) {
							icon.display_obj.parent.addChildAt(icon.display_obj, this._box_notice.numChildren - index)
						}
					}
				}
				index = index + 1
			}

			this.RefreshIconPos(icon_arr, location_type)

		}

		this.RefreshIconPos = (list: Array<ActivityIcon>, location_type) => {
			if (list) {
				let line_num = this.GetLineMaxIconNum(location_type)
				let item, x, y
				let index_temp = 0
				for (let index in list) {
					item = list[index]
					if (item) {
						if (is_show_) {
							if (location_type == ActivityIconManager.LocationType.Left) {
								x = local_Mathf.Floor(Number(index_temp) / line_num) * (local_ActivityIcon.WIDTH + this.hgap)
								y = - Number(index_temp) % line_num * (local_ActivityIcon.HEIGHT + this.vgap) - local_ActivityIcon.HEIGHT
							} else if (location_type == ActivityIconManager.LocationType.Right) {
								if (this.CheckIsStrengthenIcon(item.icon_type)) {
									x = this.strengthen_icon_pos.x
									y = this.strengthen_icon_pos.y
								} else {
									x = -local_Mathf.Floor(Number(index_temp) / line_num) * (local_ActivityIcon.WIDTH + this.hgap) - local_ActivityIcon.WIDTH
									y = -Number(index_temp) % line_num * (local_ActivityIcon.HEIGHT + this.vgap) - local_ActivityIcon.HEIGHT
								}
							} else if (location_type == ActivityIconManager.LocationType.Notice) {
								x = -local_Mathf.Floor(Number(index_temp) / line_num) * (local_ActivityIcon.WIDTH + this.hgap) - local_ActivityIcon.WIDTH
								y = -Number(index_temp) % line_num * (local_ActivityIcon.HEIGHT + this.vgap) - local_ActivityIcon.HEIGHT
							}
							//我要变强按钮跳过排列
							if (!this.CheckIsStrengthenIcon(item.icon_type)) {
								index_temp++
							}

							SetAnchoredPosition(item.display_obj, x, y)
							SetLocalScale(item.display_obj, 1)
							item.SetAlpha(1)
							item.SetVisible(true)
						} else {
							if (location_type == ActivityIconManager.LocationType.Left) {
								x = this.left_hide_pos.x
								y = this.left_hide_pos.y
							} else if (location_type == ActivityIconManager.LocationType.Right) {
								x = this.right_hide_pos.x
								y = this.right_hide_pos.y
							} else if (location_type == ActivityIconManager.LocationType.Notice) {
								x = this.notice_hide_pos.x
								y = this.notice_hide_pos.y
							}

							SetAnchoredPosition(item.display_obj, x, y)
							SetLocalScale(item.display_obj, 0.5)
							item.SetAlpha(0)
							item.SetVisible(false)
						}
					}
					local_MainUIModel_Instance.Fire(local_MainUIModel.UPDATE_SECONDARY_ICON, location_type)
				}
			}
		}
		//是否是我要变强按钮
		this.CheckIsStrengthenIcon = (icon_type) => {
			return icon_type == "158"
		}

		this.GetIconPos = (icon_type?, centor_offset?, pivot_offset?) => {
			let offset_x, offset_y
			if (!centor_offset) {
				offset_x = offset_y = 0
			} else {
				offset_x = centor_offset.x
				offset_y = centor_offset.y
			}

			let item = left_icon_dic_[icon_type]
			if (!item) {
				item = right_icon_dic_[icon_type]
			}

			if (item && item.is_loaded) {
				return item.display_obj.localToGlobal(new Laya.Point(offset_x, offset_y))
			}
		}

		this.ShowAnimation = (bool?) => {
			if (is_show_ == bool) {
				return is_show_
			}
			this.ClearTween()
			this.ClearTimer()
			if (bool) {
				this.PlayOpen(left_icon_dic_, ActivityIconManager.LocationType.Left)
				this.PlayOpen(right_icon_dic_, ActivityIconManager.LocationType.Right)
				this.PlayOpen(notice_icon_dic_, ActivityIconManager.LocationType.Notice)
				if (god_item) {
					this._box_god.visible = false
				}
				if (show_first) {
					this.PlayNotificationAnimation(this._box_firstblood, notification_type.FirsetBlood)
				}
				this.ShowTTKeFuBtn()
			} else {
				this.PlayHide()
				if (god_item) {
					if (!local_SceneManager_Instance.IsForbidGodScene() && local_GodBefallModel_Instance._cur_battle_id) {
						this._box_god.visible = true
					} else {
						this._box_god.visible = false
					}
				}
				this.HideTTKeFuBtn()
			}
			local_MainUIModel_Instance.activity_icon_in_show = bool
			local_MainUIModel_Instance.Fire(local_MainUIModel.UPDATE_ACTIVITY_STATE, bool)
			MainUIManager.GetInstance().Fire(MainUIManager.UPDATE_MOVE_STATE)
			this._img_turn.rotation = bool ? 0 : 45

			is_show_ = bool

			this.SetAutoFightBtn()

			is_moving_ = true


			if (delay_refresh_time_id_) {
				clearTimeout(delay_refresh_time_id_)
				ani_end_need_refresh_icon_ = true
				delay_refresh_time_id_ = false
			}

			time_id_ =
				setTimeout(() => {
					is_moving_ = false
					if (ani_end_need_refresh_icon_) {
						ani_end_need_refresh_icon_ = false
						this.TryRefreshAllIcon()
					}
				},
					(local_MainUIModel.Move_Time_Interval + 0.2) * 1000
				)
			return is_show_
		}

		this.PlayOpen = (list, location_type) => {
			if (!list) return
			let icon_arr = []
			for (let key in list) {
				table.insert(icon_arr, list[key])
			}
			this.SortFun(icon_arr)

			let line_num = this.GetLineMaxIconNum(location_type)
			let x, y, item: ActivityIcon
			let index_temp = 0
			for (let index in icon_arr) {
				item = icon_arr[index]
				if (item) {
					if (item.to_add) {
						item.SetVisible(true)
						item.to_add = false
					}

					if (location_type == ActivityIconManager.LocationType.Left) {
						x = local_Mathf.Floor(Number(index_temp) / line_num) * (local_ActivityIcon.WIDTH + this.hgap)
						y = - Number(index_temp) % line_num * (local_ActivityIcon.HEIGHT + this.vgap) - local_ActivityIcon.HEIGHT
					} else if (location_type == ActivityIconManager.LocationType.Right) {
						if (this.CheckIsStrengthenIcon(item.icon_type)) {
							x = this.strengthen_icon_pos.x
							y = this.strengthen_icon_pos.y
						} else {
							x = -local_Mathf.Floor(Number(index_temp) / line_num) * (local_ActivityIcon.WIDTH + this.hgap) - local_ActivityIcon.WIDTH
							y = -Number(index_temp) % line_num * (local_ActivityIcon.HEIGHT + this.vgap) - local_ActivityIcon.HEIGHT
						}
					} else if (location_type == ActivityIconManager.LocationType.Notice) {
						x = -local_Mathf.Floor(Number(index_temp) / line_num) * (local_ActivityIcon.WIDTH + this.hgap) - local_ActivityIcon.WIDTH
						y = -Number(index_temp) % line_num * (local_ActivityIcon.HEIGHT + this.vgap) - local_ActivityIcon.HEIGHT
					}
					if (!this.CheckIsStrengthenIcon(item.icon_type)) {
						index_temp++
					}

					item.SetVisible(true)
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(x, y), local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.SCALE, Vector3.one, local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ALPHA, 1, local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))

				}
			}

		}

		this.PlayHide = () => {
			for (let key in left_icon_dic_) {
				let item = left_icon_dic_[key]
				if (item && item.is_loaded) {
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(this.left_hide_pos.x, this.left_hide_pos.y), local_MainUIModel.Move_Time_Interval, () => { item.SetVisible(false) }, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.SCALE, new Vector3(0.5, 0.5, 0.5), local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))

				}
			}

			for (let key in right_icon_dic_) {
				let item = right_icon_dic_[key]
				if (item && item.is_loaded) {
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(this.right_hide_pos.x, this.right_hide_pos.y), local_MainUIModel.Move_Time_Interval, () => { item.SetVisible(false) }, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.SCALE, new Vector3(0.5, 0.5, 0.5), local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
				}
			}

			for (let key in notice_icon_dic_) {
				let item = notice_icon_dic_[key]
				if (item && item.is_loaded) {
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, new Vector2(this.notice_hide_pos.x, this.notice_hide_pos.y), local_MainUIModel.Move_Time_Interval, () => { item.SetVisible(false) }, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.SCALE, new Vector3(0.5, 0.5, 0.5), local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
					table.insert(tween_event_list_, SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ALPHA, 0, local_MainUIModel.Move_Time_Interval, null, SYTweenFunc.LINEAR))
				}
			}
		}

		this.SetGroupVisible = (bool?) => {
			if (this.is_loaded) {
				this.RefreshGroupPos()
			} else {
				group_visible_cache = bool
			}
		}

		this.RefreshGroupPos = () => {
			this.UpdateRightConPos()
		}

		this.SetAutoFightBtn = () => {
			this.RefOutlineExp()
		}

		this.ClearTeamTween = () => {
			if (team_tween_ids) {
				for (let _ in team_tween_ids) {
					var key = team_tween_ids[_]
					SYTweenLite.Stop(key)
				}
			}
			team_tween_ids = []
		}

		this.UpdateTeamEffect = () => {
			if (!TeamModel.GetInstance().IsOpenTeam()) return
			let flag = local_TeamModel_Instance.be_invited_list && local_TeamModel_Instance.be_invited_list.length > 0
			let last_flag = this._img_team.visible
			this._box_team.visible = flag
			this._img_team.visible = flag

			if (flag) {
				this.PlayNotificationAnimation(this._box_team, notification_type.Team)
			} else {
				// this.StopNotificationTweenByType(notification_type.Team)
				this.StopNotificationTweenByType(this._box_team)
			}
		}

		this.CreateGodItem = () => {
			if (!god_item && local_GodBefallModel_Instance._cur_battle_id) {
				god_item = new MainUISkillItemGod(this._box_god)
				god_item.Load()
				god_item.SetVisible(!local_SceneManager_Instance.IsForbidGodScene())
				this._box_god.visible = !is_show_ && !local_SceneManager_Instance.IsForbidGodScene()
			}
		}

		this.AddOutlineEffect = (type, source?) => {
			if (type == 1 && !add_effect) {
				this.DeleteOutlineEffect(type)
				add_effect = this.AddUIEffect("UI_tisheng", this.add, null, 35, true)
			}
			else if (type == 2 && source) {
				this.AddUIEffect(source, this.exp_show, null, 16, true)
			}
		}

		this.DeleteOutlineEffect = (type) => {
			if (type == 1) {
				this.ClearUIEffect(this.add)
				add_effect = null
			}
			else if (type == 2) {
				this.ClearUIEffect(this.exp_show)
			} else {
				this.ClearUIEffect(this.add)
				add_effect = null
				this.ClearUIEffect(this.exp_show)

			}
		}

		this.RefOutlineExp = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOnHookInfo")
			let data = cfg.addition
			let all_add = 0
			let real_add = OnHookModel.GetInstance().exp_add_effct
			for (let key in data) {
				all_add += data[key].max_number
			}
			if ((all_add * 10000) == real_add) {
				this.add_btn.scaleX = 0
				this.DeleteOutlineEffect(1)
			} else {
				this.add_btn.scaleX = 1
				let buff_list = GoodsModel.GetInstance().goods_buff_list
				let has_effect = true
				if(buff_list && buff_list.length > 0){
					for(let item of buff_list){
						if(item.buff_type && item.buff_type == 1){
							has_effect = false
							break
						}
					}
				}
				this._img_add.visible = !has_effect
				if(has_effect){
					this.AddOutlineEffect(1)
				}else{
					this.DeleteOutlineEffect(1)
				}
			}

			let exp = OnHookModel.GetInstance().exp_effect
			let show = (Number(exp) > 0)
			let bool = local_SceneManager_Instance.IsFieldScene() && show

			if (bool) {
				//是否完成了领取离线经验的任务
				let out_line_task_has_done = this.task_model.newest_finish_task_id >= TaskModel.AfkReceiveTimesTaskId
				if (out_line_task_has_done) {
					this._box_old_outline_exp.visible = false
					this._box_outline_exp.visible = true

					let outline_time = OnHookModel.GetInstance().GetOnhookTotalTime()
					let time_out = false
					if (outline_time && outline_time / 60 >= 10)
						time_out = true
					let hours = Math.floor(outline_time / 3600)
					// if (hours < 1) {
					if (time_out) {
						// if (timer_id) {
						// 	GlobalTimerQuest.CancelQuest(timer_id)
						// 	timer_id = null
						// }
						// }else {
						// 	if(!timer_id && timer_id >=1){
						// timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
						// 	this.ShowExpAnimation()
						// }, 2, -1)
						this.ShowExpAnimation()
					}
					else {
						this.exp_btn.rotation = 0
						// Laya.Tween.clearAll(this.exp_btn)
						// if (timer_id) {
						// 	GlobalTimerQuest.CancelQuest(timer_id)
						// 	timer_id = null
						// }
						if (this.exp_ani_time_line) {
							this.exp_ani_time_line.pause()
						}
					}

					this.exp_show.visible = hours >= 2
					this._img_outline_exp_bg1.visible = hours < 0.5
					this._img_outline_exp_bg.visible = hours >= 0.5
					this._box_exp_btn.visible = hours >= 0.5
					if (hours >= 0.5) {
						let source = ""
						if (hours >= 0.5 && hours < 2) {

						} else if (hours >= 2 && hours < 4) {
							source = "UI_guajijiangli_3"
						} else if (hours >= 4 && hours < 6) {
							source = "UI_guajijiangli_2"
						} else if (hours >= 6) {
							source = "UI_guajijiangli_1"
						}
						this.AddOutlineEffect(2, source)
					}
					else
						this.DeleteOutlineEffect(2)


					this._lb_outline_exp.innerHTML = "<font color= '#00fa64'>" + WordManager.ConvertNum(exp, true) + "</font>经验/分"
					let parent: Laya.HBox = <Laya.HBox>this._lb_outline_exp.parent
					if (parent) {
						parent.refresh()
					}
					this.exp_btn.width = 66
					this.exp_btn.height = 70
				}
				else {
					this._box_old_outline_exp.visible = true
					this._box_outline_exp.visible = false
					this._lb_old_outline_exp.text = WordManager.ConvertNum(exp, true) + "经验/分"
					this.exp_btn.rotation = 0
					if (this.exp_ani_time_line) {
						this.exp_ani_time_line.pause()
					}
				}
			}
			else {
				this._box_outline_exp.visible = this._box_old_outline_exp.visible = false
				this.DeleteOutlineEffect()
				this.exp_btn.rotation = 0
				if (this.exp_ani_time_line) {
					this.exp_ani_time_line.pause()
				}
			}
		}

		this.ShowExpAnimation = () => {
			// Laya.Tween.to(this.exp_btn, { rotation: -20 }, 250, null, Laya.Handler.create(this, () => {
			// 	Laya.Tween.clearAll(this.exp_btn)
			// 	Tween_2()
			// }))
			// let Tween_2 = () => {
			// 	Laya.Tween.to(this.exp_btn, { rotation: 20 }, 500, null, Laya.Handler.create(this, () => {
			// 		Laya.Tween.clearAll(this.exp_btn)
			// 		Laya.Tween.to(this.exp_btn, { rotation: 0 }, 250, null, Laya.Handler.create(this, () => {
			// 			Laya.Tween.clearAll(this.exp_btn)
			// 		}))
			// 	}))
			// }

			if (!this.exp_ani_time_line) {
				this.exp_ani_time_line = new Laya.TimeLine()
				this.exp_ani_time_line.addLabel("ShowExpAnimation1", 0).to(this.exp_btn, { rotation: -20 }, 250, null, 1000)
				this.exp_ani_time_line.addLabel("ShowExpAnimation2", 0).to(this.exp_btn, { rotation: 20 }, 500, null, 0)
				this.exp_ani_time_line.addLabel("ShowExpAnimation3", 0).to(this.exp_btn, { rotation: 0 }, 250, null, 0)
				this.exp_ani_time_line.play(0, true)
			}
			else {
				this.exp_ani_time_line.resume()
			}
		}

		this.SetRightConPos = (bool?) => {
			right_con_pos_state = bool
			if (this.is_loaded) {
				if (bool) {
					this._img_turn.y = -29
				} else {
					this._img_turn.y = -149
				}

				this.UpdateRightConPos()
			}

		}

		this.UpdateRightConPos = () => {

			let right_offset_y = -68

			if (right_con_pos_state == false) {
				right_offset_y = right_offset_y - 122
			}

			this._box_right.y = right_offset_y
			this._box_notice.y = right_offset_y - 342 - 72
		}


		this.CreateForeShowIcon = (icon?, bool?) => {
			if (icon) {
				if (!marri_foreshow) {
					let view_class = window["MainUIMarriageItem"]
					marri_foreshow = new view_class()
				}

				if (!marri_foreshow.HasOpen()) {
					marri_foreshow.Open(icon)
				} else {
					marri_foreshow.SetIcon(icon)
				}


			} else {
				if (marri_foreshow) {
					if (marri_foreshow && marri_foreshow.HasOpen()) {
						marri_foreshow.Close()
						marri_foreshow = null
					}
				}
			}
		}

		this.ClearMarriForeTween = () => {
			if (fore_tween_id) {
				SYTweenLite.Stop(fore_tween_id)
				fore_tween_id = null
			}
		}

		this.GetLineMaxIconNum = (location_type) => {
			if (location_type == ActivityIconManager.LocationType.Left) {
				return 1
			} else if (location_type == ActivityIconManager.LocationType.Right) {
				return 5
			} else if (location_type == ActivityIconManager.LocationType.Notice) {
				return 1
			}

		}


		this.GetFirstChargeIcon = () => {
			let item = left_icon_dic_[159]
			if (item && item.is_loaded) {
				return item.display_obj
			}
		}

		this.UpdateAutoStateEffect = () =>{
			//海外服都屏蔽
			if(PlatformManager.IsEyouPlatform()){
				this.ClearUIEffect(this._box_auto_effect)
				return
			}
			let auto_state_effect_name
			let source_oper = OperateManager.GetInstance().GetNowSrcOper()
			let offset 
			//如果同时存在寻路和挂机 优先显示寻路
			if(source_oper && source_oper.type == SourceOperateType.Move && !source_oper.IsFinish()){
				auto_state_effect_name = "ui_zidongxunluzhong"
				offset = {x:6.8, y:-4}
			}

			if(!auto_state_effect_name && AutoFightManager.GetInstance().GetAutoFightState()){
				auto_state_effect_name = "ui_zidongzhandouzhong"
				offset = {x:6.8, y:-4}
			}

			if(this.auto_state_effect_name != auto_state_effect_name){
				this.auto_state_effect_name = auto_state_effect_name
				this.ClearUIEffect(this._box_auto_effect)
				if(this.auto_state_effect_name){
					this.AddUIEffect(this.auto_state_effect_name, this._box_auto_effect, offset, 6.4)
				}
			}
		}


		this.TryUpdateAutoStateEffect = () =>{
			if(this.state_effect_time_id) return
			this.state_effect_time_id = setTimeout(() => {
				this.state_effect_time_id = undefined
				this.UpdateAutoStateEffect()
			}, Scene.Instance.auto_find_and_attack_interval * 1100);
		}

		this.InitTT = () =>{
			if (local_Util.IsTTGame()) {
				this._img_tt_record.visible = true
				this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "start_record")
				MainUIManager.GetInstance().AddMoveComponent(this, this._img_tt_record, true, MainUIManager.MOVE_TYPE.Stay)

				let record_fun = () => {
					if (!this.is_starting_record) {
						this.TTRecordFun()
					} else if (this.record_finish) {
						this.TTShowRecord()
					} else {
						this.TTStopRecord()
					}
				}
				local_Util.AddClickEvent(this._img_tt_record, record_fun, this, true)

				this.BindEvent(local_GlobalEventSystem, local_EventName.BASEVIEW_OPEN_OR_CLOSE, (is_open, base_file, layer_value, layout_file) => {
					if (layer_value != "Main" && base_file != Enum_UILayer.Main && layout_file != "ItemUseView" && layout_file != "FightingUpView") {
						if (local_MainUIModel_Instance.activity_icon_in_show) {
							if (is_open) {
								this.HideTTKeFuBtn()
							} else {
								this.ShowTTKeFuBtn()
							}
						}
					}
				});

				this.ShowTTKeFuBtn()
			}
		}

		//录屏处理
		this.TTRecordFun = () => {
			this.is_initiative_to_stop = false
			if (local_Util.IsTTGame() && window["tt"]) {
				if (!this.recorder) {
					this.recorder = window["tt"].getGameRecorderManager();
					this.recorder.onStart(res => {
						console.warn('录屏开始---------------', res);
						this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "stop_record")
						this.is_starting_record = true
						this.record_start_time = TimeUtil.getServerTime()
					})
					this.recorder.onError(res => {
						console.warn('录屏出错---------------', res);
						this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "start_record")
						this.is_starting_record = false
						local_Message.show("录屏失败，请重新录制")
						this.record_start_time = 0
					})

					this.recorder.onStop((res) => {
						this.record_res = res
						this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "finish_record")

						this.record_end_time = TimeUtil.getServerTime()
						console.warn("onstop----------------------:", res)
						if (this.record_start_time) {
							if (this.record_end_time - this.record_start_time >= 3) {
								this.record_finish = true
								if (this.is_initiative_to_stop) {

								} else {
									Message.show("录屏时间超过上限300秒,请点击录屏按钮分享视频")
								}
							} else {
								local_Message.show("录屏时间少于3秒")
								this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "start_record")
								this.is_starting_record = false
							}
						} else {
							local_Message.show("录屏失败，请重新录制")
							this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "start_record")
							this.is_starting_record = false
						}
					})
				}
				if (!this.recorder) {
					return
				}
				this.recorder.start({
					duration: 300,
				})
			}
		}
		//停止录屏
		this.TTStopRecord = () => {
			if (local_Util.IsTTGame() && window["tt"]) {
				if (!this.recorder) {
					return
				}
				this.is_initiative_to_stop = true
				this.recorder.stop()
			}
		}

		this.TTShowRecord = () => {
			if (local_Util.IsTTGame() && window["tt"]) {
				if (this.record_finish) {
					this._img_tt_record.skin = GameResPath.GetIcon("mainUI", "start_record")
					window["tt"].shareAppMessage({
						channel: 'video',
						extra: {
							videoPath: this.record_res.videoPath, // 可替换成录屏得到的视频地址
							videoTopics: ['九州谕', '九州']
						},
						success() {
							console.warn('分享视频成功');
						},
						fail(e) {
							console.warn('分享视频失败');
						}
					})
					this.record_finish = false
					this.is_starting_record = false
				}
			}
		}
		//创建客服按钮
		this.ShowTTKeFuBtn = () => {
			if (local_Util.IsTTGame() && !ClientConfig.not_show_tt_kefu && window["tt"] && window["tt"].createContactButton) {
				if (!this.tt_kefu_btn) {
					let stage_width = LayerManager.GetInstance().stageWidth
					let stage_height = LayerManager.GetInstance().stageHeight
					let y = Util.GetLiuhaiHeight() + 77
					let x = stage_width / 2 + 170
					let sysInfo = window["tt"].getSystemInfoSync();
					let screenW = sysInfo.screenWidth;
					let screenH = sysInfo.screenHeight;
					let real_y = y * screenH / stage_height
					let real_x = x * screenW / stage_width
					let size = screenH / stage_height * 64
					var button = window["tt"].createContactButton({
						type: "image",
						image: "./assets/newkefu.png",
						style: {
							left: real_x,
							top: real_y,
							width: size,
							height: size,
							lineHeight: 40,
							backgroundColor: "#ffffff",
							textAlign: "center",
							fontSize: 16,
							borderRadius: 4,
							borderColor: "#ffffff",
							borderWidth: 1,
							textColor: "#ffffff"
						},
						success(res) {
							console.log("create success", res);
						},
						fail(res) {
							console.log("create fail", res);
						},
						complete(res) {
							console.log("create complete", res);
						}
					});
					this.tt_kefu_btn = button
					// 点击事件
					var handleClick = function () {
						console.warn("点击客服按钮");
					}
					button.onTap(handleClick); // 兼听点击事件
					// 错误处理
					var handleError = function (res) {
						console.warn(res.errMsg);
					}
					button.onError(handleError); // 监听错误
					button.offError(handleError); //取消监听错误
				}
				this.tt_kefu_btn.show(); // 显示按钮
			}
		}
		this.HideTTKeFuBtn = () => {
			if (local_Util.IsTTGame() && window["tt"] && window["tt"].createContactButton) {
				if (this.tt_kefu_btn) {
					this.tt_kefu_btn.hide()
				}
			}
		}
	}

	_box_left: Laya.Box
	_box_help: Laya.Box
	_img_help: Laya.Image
	_box_help_tips: Laya.Box
	_img_help_tips: Laya.Image
	_lb_help: Laya.Label
	_box_notification_bar: Laya.Box
	_box_sea: Laya.Box
	_img_sea: Laya.Image
	_box_sea_red: Laya.Box
	_img_sea_red: Laya.Image
	_lb_sea_red_num: Laya.Label
	_box_firstblood: Laya.Box
	_img_first: Laya.Image
	_img_first_blood_red: Laya.Image
	_box_team: Laya.Box
	_img_team: Laya.Image
	_box_red_packet: Laya.Box
	_img_red_packet: Laya.Image
	_box_email: Laya.Box
	_img_email: Laya.Image
	_box_chat: Laya.Box
	_img_chat: Laya.Image
	_box_daily_find: Laya.Box
	_img_daily_find: Laya.Image
	_box_level_rew: Laya.Box
	_img_level_rew: Laya.Image
	_box_gift_push: Laya.Box
	_img_gift_push: Laya.Image
	_box_auto_effect: Laya.Box
	_box_outline_exp: Laya.Box
	_img_outline_exp_bg1: Laya.Image
	_img_outline_exp_bg: Laya.Image
	exp_show: Laya.Box
	_lb_outline_exp: Laya.HTMLDivElement
	add_btn: Laya.Box
	add: Laya.Box
	_img_add: Laya.Image
	_box_exp_btn: Laya.Box
	exp_btn: Laya.Image
	_box_old_outline_exp: Laya.Box
	_img_old_outline_exp_bg: Laya.Image
	_lb_old_outline_exp: Laya.Label
	_box_right: Laya.Box
	_box_notice: Laya.Box
	_box_god: Laya.Box
	_img_turn: Laya.Image
	_box_please: Laya.Box
	_img_please: Laya.Image
	_gp_t_map: Laya.Box
	_gp_pro: Laya.Box
	_img_rpr: Laya.Image
	_img_tt_record: Laya.Image
	public GetComponents() {
		[
			this._box_left,
			this._box_help,
			this._img_help,
			this._box_help_tips,
			this._img_help_tips,
			this._lb_help,
			this._box_notification_bar,
			this._box_sea,
			this._img_sea,
			this._box_sea_red,
			this._img_sea_red,
			this._lb_sea_red_num,
			this._box_firstblood,
			this._img_first,
			this._img_first_blood_red,
			this._box_team,
			this._img_team,
			this._box_red_packet,
			this._img_red_packet,
			this._box_email,
			this._img_email,
			this._box_chat,
			this._img_chat,
			this._box_daily_find,
			this._img_daily_find,
			this._box_level_rew,
			this._img_level_rew,
			this._box_gift_push,
			this._img_gift_push,
			this._box_auto_effect,
			this._box_outline_exp,
			this._img_outline_exp_bg1,
			this._img_outline_exp_bg,
			this.exp_show,
			this._lb_outline_exp,
			this.add_btn,
			this.add,
			this._img_add,
			this._box_exp_btn,
			this.exp_btn,
			this._box_old_outline_exp,
			this._img_old_outline_exp_bg,
			this._lb_old_outline_exp,
			this._box_right,
			this._box_notice,
			this._box_god,
			this._img_turn,
			this._box_please,
			this._img_please,
			this._gp_t_map,
			this._gp_pro,
			this._img_rpr,
			this._img_tt_record,
		]
			= this.GetChildrenByNames([

				"_box_left",
				"_box_help",
				"_img_help",
				"_box_help_tips",
				"_img_help_tips",
				"_lb_help",
				"_box_notification_bar",
				"_box_sea",
				"_img_sea",
				"_box_sea_red",
				"_img_sea_red",
				"_lb_sea_red_num",
				"_box_firstblood",
				"_img_first",
				"_img_first_blood_red",
				"_box_team",
				"_img_team",
				"_box_red_packet",
				"_img_red_packet",
				"_box_email",
				"_img_email",
				"_box_chat",
				"_img_chat",
				"_box_daily_find",
				"_img_daily_find",
				"_box_level_rew",
				"_img_level_rew",
				"_box_gift_push",
				"_img_gift_push",
				"_box_auto_effect",
				"_box_outline_exp",
				"_img_outline_exp_bg1",
				"_img_outline_exp_bg",
				"exp_show",
				"_lb_outline_exp",
				"add_btn",
				"add",
				"_img_add",
				"_box_exp_btn",
				"exp_btn",
				"_box_old_outline_exp",
				"_img_old_outline_exp_bg",
				"_lb_old_outline_exp",
				"_box_right",
				"_box_notice",
				"_box_god",
				"_img_turn",
				"_box_please",
				"_img_please",
				"_gp_t_map",
				"_gp_pro",
				"_img_rpr",
				"_img_tt_record",
			])
	}
}
window["MainUISecondaryView"] = MainUISecondaryView