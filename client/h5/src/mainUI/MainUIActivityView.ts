import { MainUISecondaryView } from "./MainUISecondaryView"
import { MainUIController } from "./../commonController/MainUIController"
import { FirstRechargeBubble } from "./../recharge/FirstRechargeBubble"
import { FirstRechargeModel } from "./../commonModel/FirstRechargeModel"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"
import { MainUIModel } from "../commonModel/MainUIModel"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, SetAnchoredPosition, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { ActivityIcon } from "./ActivityIcon"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { TopPlayerTipItem } from "./TopPlayerTipItem"
import { PlatformManager } from "../PlatformManager"
import { CycleimpActlistEvent, CycleimpActlistModel } from "../commonModel/CycleimpActlistModel"
import { Config } from "../common/Config"

export class MainUIActivityView extends BaseView1 {

	topplayer_icon: ActivityIcon
	mainUI_model: MainUIModel
	activity_icon_mgr: ActivityIconManager
	common_mgr: CommonManager
	cycleimpActlistModel
	local_platform_manager
	private close_tip_time
	private tip_item: TopPlayerTipItem
	icon_dic: {
		[key: string]: ActivityIcon
	} = {}
	first_line_icon_list = []
	second_line_icon_list = []
	other_line_icon_list = []
	first_line_not_indent_icon_list = []
	other_line_not_indent_icon_list = []

	is_show = true
	is_moving
	hgap = 5
	vgap = 20
	fir_sen_start_x = 152
	time_id
	delay_refresh_time_id
	ani_end_need_refresh_icon = false
	tween_list = []
	timer
	_end_time
	now_key
	reward: EquipmentItem
	within_30min = false;
	//主界面活动展示道具
	icon_dir = {
		"1_1": 101046074,
		"2_1": 101066074,
		"3_1": 101026074,
		"4_1": 101106074,
		"5_1": 101086074,
		"6_1": 101016074,
		"1_2": 102046074,
		"2_2": 102066074,
		"3_2": 102026074,
		"4_2": 102106074,
		"5_2": 102086074,
		"6_2": 102016074,
		"6_3": 103016074,
		"6_4": 104016074,
		"13_1": 101106074,
		"13_2": 102106074,
		"14_1": 101086074,
		"14_2": 102086074,
	}
	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "MainUIActivityView"
		this.layer_value = Enum_UILayer.Main

		this.mainUI_model = MainUIModel.GetInstance()
		this.activity_icon_mgr = ActivityIconManager.GetInstance()
		this.common_mgr = CommonManager.GetInstance()
		this.local_platform_manager = PlatformManager.GetInstance()
		this.cycleimpActlistModel = CycleimpActlistModel.GetInstance()
		this.load_callback = () => {
			this.effect.width = 720
			this.effect.height = 1280
			this._img_red.x = 120;
			this.LoadSuccess()
		}

		this.close_callback = () => {
			if (this.reward) {
				this.reward.DeleteMe()
				this.reward = null
			}
		}

		this.destroy_callback = () => {
			if (this.reward) {
				this.reward.DeleteMe()
				this.reward = null
			}

			if (this.tip_item) {
				this.tip_item.DeleteMe()
				this.tip_item = null
			}

			this.StopTimer()
			this.ClearUIEffect(this.effect)
			this.ClearTween()
			this.CancelTipTimer();
			this.topplayer_icon = null

		}
	}

	LoadSuccess() {
		if (this.local_platform_manager.is_alpha) {
			this._box_rank.visible = false
			this._box_rank.scale(0, 0)
		}
		this.mainUI_model.SetMainuiLoadedFlag(this.layout_file, true, this)
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("mainUI", "mainui_ui_38"))
		let y = 128
		let liu_hai_height = Util.GetLiuhaiHeight()
		if (liu_hai_height && liu_hai_height > 0) {
			y = y + liu_hai_height
		}
		this.display_obj.x = 10
		this.display_obj.y = y
		// this.display_obj.cacheAs = "bitmap"
		this.display_obj.drawCallOptimize = true
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		// if (open_day >= 8) {
		// 	this.time.visible = false
		// 	this.player_name.visible = false
		// }
		this.InitEvent()
	}

	InitEvent() {
		Util.AddClickEvent(this._box_rank, () => {
			// let type_id = this.icon_dir[this.now_key]
			// let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			// UIToolTipMgr.GetInstance().AppendEquipTips(type_id, null, null, goods_vo, null, null, null)
			if (ServerTimeModel.GetInstance().GetOpenServerDay() > 7) {
				GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, "331@110")
			} else {
				GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, '331@100', '10', '0');
			}
		}, this, false)
		this.BindEvent(GlobalEventSystem,
			ActivityIconManager.ADD_ICON, (icon_type, location_type) => {
				if (location_type == ActivityIconManager.LocationType.ActivityOne
					|| location_type == ActivityIconManager.LocationType.ActivityTwo
					|| location_type == ActivityIconManager.LocationType.ActivityOther) {
					this.CreateActivityIcon(icon_type)
				}
			}
		)

		this.BindEvent(GlobalEventSystem,
			ActivityIconManager.DELETE_ICON, (icon_type?) => {
				let item = this.icon_dic[icon_type]
				if (item) {
					item.to_delete = true
					this.TryRefreshAllIcon()
				}
			}
		)

		this.BindEvent(
			this.mainUI_model,
			MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				this.ShowAnimation(bool)
			}
		)
		this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.ADD_BUBBLE, (bool) => {
			this.within_30min = bool;
			this.TryRefreshAllIcon();
		})
		this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_SECONDARY_ICON, (location_type) => {
			if (location_type == ActivityIconManager.LocationType.Left) {
				this.TryRefreshAllIcon();
			}
		})

		this.BindEvent(
			CustomActivityModel.GetInstance(),
			CustomActivityDefine.EVENT.ADD_TOPPLAYER_TIP, (scmd) => {
				/* 		if (this.icon_type == "331@10@0") {
							
						} */
				let des = CustomActivityModel.GetInstance().GetTopPlayerTip(scmd)
				if (!this.tip_item) {
					this.tip_item = new TopPlayerTipItem(this._box_rank)
					this.tip_item.SetDes(des)
					this.tip_item.Load();
					this.tip_item.ExcuteCallback(() => {
						SetAnchoredPosition(this.tip_item.display_obj, 100, -30)
					}
					)
				}
				if (this.close_tip_time) {
					this.CancelTipTimer();
					this.tip_item.SetDes(des);
				}
				if (!this.close_tip_time) {
					this.close_tip_time = GlobalTimerQuest.AddPeriodQuest(() => {
						if (this.tip_item) {
							this.tip_item.DeleteMe()
							this.tip_item = null
						}
						this.CancelTipTimer()
					}, 20)
				}
			}
		)

		CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33251)

		// this.BindEvent(
		// 	GlobalEventSystem,
		// 	EventName.RESTORE_FINGER,
		//(layout_file?, force?) => {
		// 		if (StoryModel.GetInstance().CanRestoreFinger(layout_file) || force ) {
		// 			this.TaskChange()
		// 		}
		// 	}
		// )
		let guide_icon_fun = () => {
			this.SetHasGuideIconAtLast()
		}
		this.BindEvent(GlobalEventSystem, EventName.SELECT_STORY_TARGET, guide_icon_fun)
		this.BindEvent(GlobalEventSystem, EventName.ACTIVITY_ICON_EFFECT, guide_icon_fun)
		this.BindEvent(GlobalEventSystem, EventName.CREATE_FINGER_SUCCESS, guide_icon_fun)
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_TOP_PLAYER_MAIN_DATA, (data, base_type, sub_type) => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			let lv = RoleManager.GetInstance().GetMainRoleLevel()
			let topplayer_icon = (open_day <= 8 && lv >= 130 && (this.cycleimpActlistModel.type == 0 || this.cycleimpActlistModel.type == null)) ? 1 : 0
			if (topplayer_icon) {
				this.UpdateTopPlayerData(data)
				this.ClearUIEffect(this.effect)
				this.AddUIEffect("ui_cb01", this.effect, { x: 0, y: 0 }, 1.1, true);
			}
			else {
				this.ClearUIEffect(this.effect)
				this.StopTimer()
			}
		})
		this.BindEvent(GlobalEventSystem, EventName.REFRESH_ACTIVITY_ICON_RED_DOT, (type: string, state: boolean) => {
			// if (open_day > 8) {
			// 	return
			// }
			if (CustomActivityModel.GetInstance().GetKaiFuActivityRedDot('331@110') || this.cycleimpActlistModel.CheckActData() || CustomActivityModel.GetInstance().GetKaiFuActivityRedDot('331@10@0')) {
				this._img_red.visible = true
			} else {
				this._img_red.visible = false
			}
		})

		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		let topplayer_icon = (open_day <= 8 && lv >= 130) ? 1 : 0
		if (topplayer_icon) {
			let openTime:number = ServerTimeModel.GetInstance().GetOpenServerTime();
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_rank
			for (let k in cfg) {
				let v = cfg[k]
				if (v.start_day <= open_day && open_day <= v.clear_day && openTime >= v.open_start_time && openTime <= v.open_end_time )
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 22501, Number(k), 1)
			}
		}

		this.BindEvent(CycleimpActlistModel.GetInstance(), CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIST_DATA, () => {
			this.TryRefreshAllIcon()
			this.UpdateCyclelimpActlistData()
			if (CustomActivityModel.GetInstance().GetKaiFuActivityRedDot('331@110') || this.cycleimpActlistModel.CheckActData()) {
				this._img_red.visible = true
			} else {
				this._img_red.visible = false
			}
			if (open_day >= 8) {
				this.time.visible = true
				this.player_name.visible = true
			}
		})

		this.BindEvent(this.cycleimpActlistModel, CycleimpActlistEvent.CLOSE_CYCLEIMPACTLIST, () => {
			ResManager.GetInstance().ClearRoleMode(this.hashCode)
			this.StopTimer()
			this.TryRefreshAllIcon()
		})

		this.BindEvent(this.cycleimpActlistModel, CycleimpActlistEvent.UPDATE_CYCLEIMPACTLIT_RED, () => {
			if (open_day >= 8) {
				this._img_red.visible = CustomActivityModel.GetInstance().GetKaiFuActivityRedDot('331@110') || this.cycleimpActlistModel.CheckActData()
			}
		})
		if (this.cycleimpActlistModel.type && this.cycleimpActlistModel.subtype) {
			this.cycleimpActlistModel.Fire(CycleimpActlistEvent.REQUEST_PROTO, 22702, "hh", this.cycleimpActlistModel.type, this.cycleimpActlistModel.subtype)
		}
		this.InitActivityIcon()
	}

	UpdateTopPlayerData(data) {
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_rank
		this.icon_box.visible = true
		this.model_gp.visible = false
		let rank_type = data.rank_type
		let v = cfg[rank_type]
		if (open_day > 7 || (v && v.start_day <= open_day && open_day < v.clear_day)) {
			if (open_day == 8 && open_day > v.clear_day) {
				return
			}
			let sex = RoleManager.GetInstance().GetMainRoleSex()
			let career = RoleManager.GetInstance().GetMainRoleCareer()
			let rank_name = cfg[rank_type].name
			this.now_key = Number(rank_type) == 6 ? `${rank_type}_${career}` : `${rank_type}_${sex}`
			let type_id = this.icon_dir[this.now_key]
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (!this.reward) {
				this.reward = new EquipmentItem(this.icon_box)
				//this.reward.SetMaskId(1)
				this.reward.SetItemSize(80, 80)
				this.reward.ExcuteCallback(() => {
					//this.reward.grade.alpha = 0
				})
				this.reward.Load()

			}
			this.reward.SetData(goods_vo.type_id, null, null, null, null, null, null, null, null, null, null, null, null, false)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetIcon("mainUI", this.now_key))

			this.name.text = rank_name
			let rank_list = data.rank_list
			if (Util.TableSize(rank_list) > 0) {
				for (let key in rank_list) {
					let role_vo = rank_list[key]
					if (role_vo.rank == 1)
						this.player_name.text = role_vo.name
				}

			}
			else {
				this.player_name.text = "榜单虚位以待"
			}

			if (open_day > 7) {
				this.time.text = '已结束';
				this.time.color = '#ff4715';
				return;
			}

			if (data.end_time > 0) {
				this.StartTimer(data.end_time)
			}
		}

	}
	StartTimer(end_time?) {
		this.StopTimer()
		this._end_time = end_time

		this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
			this.OnTime()
		}, 1, -1)
		this.OnTime()
	}

	OnTime() {
		let left_time = this._end_time - TimeUtil.getServerTime()
		if (left_time <= 0) {
			this.StopTimer()
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if (open_day >= 8) {
				this.time.text = "结算中"
			} else {
				this.time.text = '已结束';
			}
			this.time.color = '#ff4715';
			return
		}
		let time = TimeUtil.timeConvert(left_time, "hh-mm-ss")
		this.time.text = time
		this.time.color = '#88ff43';
	}

	StopTimer() {
		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	//循环冲榜
	UpdateCyclelimpActlistData() {
		this.bg1.height = 40
		this.bg1.y = 139
		this.player_name.y = 140
		this.player_name.fontSize = 20
		this.time.y = 163
		let rank_list = this.cycleimpActlistModel.GetNowRankList()
		let have_first_role = null
		for (let key in rank_list) {
			if (rank_list[key].rank == 1 && rank_list[key].role_id) {
				have_first_role = rank_list[key]
				break
			} else if (rank_list[key].rank == 1) {
				break
			}
		}
		if (have_first_role) {
			this.player_name.text = "S" + have_first_role.server_id + "." + have_first_role.role_name
		} else {
			this.player_name.text = "虚位以待"
		}
		let timer_info = this.cycleimpActlistModel.GetActTime()
		if (timer_info) {
			this.StartTimer(timer_info.upon_end_time)
		}
		if (this.cycleimpActlistModel.type) {
			let str = ""
			if (this.cycleimpActlistModel.type == 1) {
				str = "坐骑竞榜"
			} else if (this.cycleimpActlistModel.type == 2) {
				str = "侍魂竞榜"
			} else if (this.cycleimpActlistModel.type == 3) {
				str = "羽翼 竞榜"
			} else if (this.cycleimpActlistModel.type == 4) {
				str = "御守竞榜"
			} else if (this.cycleimpActlistModel.type == 5) {
				str = "神兵竞榜"
			} else if (this.cycleimpActlistModel.type == 6) {
				str = "背饰竞榜"
			} else if (this.cycleimpActlistModel.type == 7) {
				str = "竞榜"
			}
			this.name.text = str
		}
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_cycle_rank_info
		if (cfg && this.cycleimpActlistModel.type && this.cycleimpActlistModel.subtype) {
			let cycle_rank_info = cfg[this.cycleimpActlistModel.type + "@" + this.cycleimpActlistModel.subtype]
			let view_model_info = Config.PRELOAD_CLIENT_CONFIG.UIModelParameter["MainUIActivityView"]
			let show_id
			if (this.cycleimpActlistModel.type == 5) {
				let career = RoleManager.GetInstance().GetMainRoleCareer()
				let list = JSON.parse(cycle_rank_info.show_id)
				show_id = list && list[career - 1]
			}
			else {
				show_id = cycle_rank_info.show_id
			}
			let model_info = view_model_info[show_id]
			if (!model_info) {
				model_info = view_model_info["defaut"]
			}
			if (cycle_rank_info) {
				this.icon_box.visible = false
				this.model_gp.visible = true
				let data = {
					clothe_res_id: show_id,
					type: cycle_rank_info.show_type,
					can_rotate: true,
					layer_value: this.layer_value,
					scale: model_info.scale,
					position: model_info.position,
					rotate: model_info.rotate,
					texture_size: { x: 567, y: 415 },
					action_name_list: ["idle"],
					action_delta: true,
					layout_file: "MainUIActivityView"

				}
				if (data) {
					ResManager.GetInstance().SetRoleModel(this, this.model_gp, data)
				}
			}

		}
	}

	SetHasGuideIconAtLast() {
		if (this.story_model.now_story_target_name && (this.story_model.now_story_target_name == StoryModel.StoryTargetName.KaiFuBtn
			|| this.story_model.now_story_target_name == StoryModel.StoryTargetName.RuneTreasureBtn)) {
			let icon = this.icon_dic["331@3"] || this.icon_dic["331@3_1"] || this.icon_dic["331@3_8"]
			if (icon) {
				icon.SetAsLastSibling()
			}
			icon = this.icon_dic["416"]
			if (icon) {
				icon.SetAsLastSibling()
			}
		}

	}

	InitActivityIcon() {
		for (let key in this.activity_icon_mgr.icon_info_dic) {
			let iconInfo = this.common_mgr.GetFunctionIconCfg(key)
			if (iconInfo && this.activity_icon_mgr.icon_info_dic[key] &&
				(
					iconInfo.location_type == ActivityIconManager.LocationType.ActivityOne ||
					iconInfo.location_type == ActivityIconManager.LocationType.ActivityTwo ||
					iconInfo.location_type == ActivityIconManager.LocationType.ActivityOther
				)
			) {
				this.CreateActivityIcon(key)
			}
		}
	}

	CreateActivityIcon(icon_type?) {
		let item: ActivityIcon = this.icon_dic[icon_type]
		if (!item) {
			item = new ActivityIcon(this._gp_con)
			item.SetIconType(icon_type)
			item.Load()
			item.SetVisible(false)
			item.to_add = true
			this.icon_dic[icon_type] = item
			item.ExcuteCallback(() => {
				this.TryRefreshAllIcon()
				if (this.topplayer_icon && this.topplayer_icon.is_loaded && this.topplayer_icon.display_obj) {
					let gp: Laya.Box = this._gp_con
					let count = 0
					do {
						count++
					} while (gp.getChildAt(count))
					gp.setChildIndex(this.topplayer_icon.display_obj, count - 1)
				}
			}
			)
		} else {
			item.to_delete = false
			item.SetIconImg()
			item.RefTimer()
			item.SetCountTimer()
		}
		if (icon_type == "331@10@0") {
			this.topplayer_icon = item
			item.SetVisible(false)
			item.SetAlpha(0);
		}
		this.SetHasGuideIconAtLast()
	}

	FormatIconList() {
		let first_arr = []
		let second_arr = []
		let other_arr = []
		let first_not_indent_arr = []
		let other_not_indent_arr = []
		let iconInfo = null
		let top_player_obj

		for (const key in this.icon_dic) {
			if (Object.prototype.hasOwnProperty.call(this.icon_dic, key)) {
				const item = this.icon_dic[key];
				if (item?.cfg?.icon_type == '331@10@0') {
					delete this.icon_dic[key];
					break;
				}
			}
		}


		for (let key in this.icon_dic) {

			let item = this.icon_dic[key]
			iconInfo = this.common_mgr.GetFunctionIconCfg(key)

			if (iconInfo && item && item.is_loaded) {
				if (iconInfo.location_type == ActivityIconManager.LocationType.ActivityOne) {
					if (iconInfo.not_indent) {
						table.insert(first_not_indent_arr, item)
					}
					if (iconInfo.icon_type == "331@10@0") {
						top_player_obj = item
					}
					else
						table.insert(first_arr, item)
				} else if (iconInfo.location_type == ActivityIconManager.LocationType.ActivityTwo) {
					if (iconInfo.not_indent) {
						table.insert(other_not_indent_arr, item)
					}
					table.insert(second_arr, item)
				} else if ((iconInfo.location_type == ActivityIconManager.LocationType.ActivityOther)) {
					if (iconInfo.not_indent) {
						table.insert(other_not_indent_arr, item)
					}
					table.insert(other_arr, item)
				}
			}
		}
		let sort_fun = (a?, b?) => {
			if (a && b) {
				let iconInfoA = this.common_mgr.GetFunctionIconCfg(a.icon_type)
				let iconInfoB = this.common_mgr.GetFunctionIconCfg(b.icon_type)
				if (iconInfoA && iconInfoB) {
					let IndexA = iconInfoA.pos_index
					let IndexB = iconInfoB.pos_index
					let locationTypeA = iconInfoA.location_type
					let locationTypeB = iconInfoB.location_type
					//预告的图标要排到最后
					let InfoA = this.activity_icon_mgr.getIconInfo(a.icon_type)
					if ((InfoA && InfoA.data) && InfoA.data.foreshow_icon) {
						IndexA = IndexA + 200 + InfoA.time
						locationTypeA = 999
					}
					let InfoB = this.activity_icon_mgr.getIconInfo(b.icon_type)
					if ((InfoB && InfoB.data) && InfoB.data.foreshow_icon) {
						IndexB = 200 + InfoB.time
						locationTypeB = 999
					}
					if (locationTypeA == locationTypeB) {
						return IndexA < IndexB
					} else {
						return locationTypeA < locationTypeB
					}
				}
			}
		}
		table.sort(first_arr, sort_fun);
		table.sort(second_arr, sort_fun);
		table.sort(other_arr, sort_fun);
		table.sort(first_not_indent_arr, sort_fun);
		table.sort(other_not_indent_arr, sort_fun);
		let line_max_num = this.GetLineMaxIconNum(1);
		while (first_arr.length > line_max_num) {
			let obj = table.remove(first_arr, line_max_num);
			second_arr = second_arr.concat(obj);
		}

		line_max_num = this.GetLineMaxIconNum(2);
		if (top_player_obj) line_max_num--;
		while (second_arr.length > line_max_num) {
			let obj = table.remove(second_arr, line_max_num);
			other_arr = other_arr.concat(obj);
		}
		//头号玩家固定位置第二排第二个
		if (top_player_obj) {
			let second_first = null;
			second_first = table.remove(second_arr, 0);
			second_arr.unshift(top_player_obj);
			second_arr = second_first.concat(second_arr);
		}


		return [first_arr, second_arr, other_arr, first_not_indent_arr, other_not_indent_arr];
	}

	RefreshIcon() {
		if (this.is_moving) {
			return
		}
		for (let icon_type in this.icon_dic) {

			let item = this.icon_dic[icon_type]
			if (item && item.to_delete) {
				item.DeleteMe()
				delete this.icon_dic[icon_type]
				if (icon_type == "331@10@0")
					this.topplayer_icon = null
			}
		}

		[this.first_line_icon_list,
		this.second_line_icon_list,
		this.other_line_icon_list,
		this.first_line_not_indent_icon_list,
		this.other_line_not_indent_icon_list] = this.FormatIconList()
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		let topplayer_icon = (((open_day <= 8 || this.cycleimpActlistModel.type != 0) && lv >= 130) && this.is_show) ? 1 : 0
		if (this.is_show) {
			this.RefreshIconPos(this.first_line_icon_list, 1)
			this.RefreshIconPos(this.second_line_icon_list, 2, this.first_line_icon_list)
			this.RefreshIconPos(this.other_line_icon_list, 3, this.first_line_icon_list, this.second_line_icon_list)
			if (!this.local_platform_manager.is_alpha) {
				this._box_rank.scaleX = this._box_rank.scaleY = topplayer_icon
				this._box_rank.alpha = topplayer_icon
			}
		} else {
			for (let icon_type in this.icon_dic) {
				let item: ActivityIcon = this.icon_dic[icon_type]
				if (item) {
					item.SetPosition(-95, -7)
					item.SetScale(0.5)
					item.SetAlpha(0)
					item.SetVisible(false)
				}
			}
			if (!this.local_platform_manager.is_alpha) {
				this._box_rank.scaleX = this._box_rank.scaleY = topplayer_icon
				this._box_rank.alpha = topplayer_icon
			}
		}
		this.TaskChange()
	}

	TaskChange() {
		let item = null
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Award_lv_gift) || this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Award_eternal_valley)) {
			item = this.icon_dic["331@3"] || this.icon_dic["331@3_1"]
		} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Rune_treasure)) {
			item = this.icon_dic[416]
		} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Award_daily)) {
			item = this.icon_dic[417]
		}
		if (item) {
			// item.SetIconEffect("aa", false)
			// this._gp_con.setChildIndex(item, 999)
		}
	}
	// 收纳打开的时候会在完全放出之前获取icon.y，暂时用个全局变量存着，反正手机的分辨率也不会变
	iconPosY
	bubblePosY
	GpIconGroupCoverFirstChargeIconHeight(totalLine) {
		let gpPos = this._gp_con.localToGlobal(new Laya.Point(this._gp_con.x, this._gp_con.y))
		if (this.within_30min || FirstRechargeModel.GetInstance().is_bubble) {
			if (!this.bubblePosY) {
				let first_recharge_bubble: FirstRechargeBubble = MainUIController.GetInstance().first_recharge_bubble
				let icon = first_recharge_bubble?.display_obj
				if (!icon) return 0;
				this.bubblePosY = icon.y;
			}
			// let iconPos = icon.localToGlobal(new Laya.Point(icon.x, icon.y))
			return gpPos.y + (totalLine + 2) * (ActivityIcon.HEIGHT + this.vgap) - this.bubblePosY
		} else {
			let main_ui_secondary_view: MainUISecondaryView = MainUIController.GetInstance().main_ui_secondary_view
			if (!this.iconPosY) {
				let icon: Laya.View = main_ui_secondary_view?.GetFirstChargeIcon();
				if (!icon || icon.y == 0) return 0
				let iconPos = icon.localToGlobal(new Laya.Point(icon.x, icon.y))
				this.iconPosY = iconPos.y;
			}
			return gpPos.y + (totalLine + 2) * (ActivityIcon.HEIGHT + this.vgap) - this.iconPosY
		}
	}

	RefreshIconPos(list?, line_no?, firsr_line_list?, second_line_list?) {
		let count = 1;
		let init_y = 0;
		if (line_no != 1) {
			if (line_no == 2) {
				if (firsr_line_list && firsr_line_list.length > 0) {
					init_y = ActivityIcon.HEIGHT + this.vgap
				}
			} else if (line_no == 3) {
				if (firsr_line_list && firsr_line_list.length > 0) {
					init_y = ActivityIcon.HEIGHT + this.vgap
				}
				if (second_line_list && second_line_list.length > 0) {
					init_y = init_y + ActivityIcon.HEIGHT + this.vgap
				}
			}
		}
		if (list) {
			// let have_time_icon_index = 0
			// if (line_no == 3) {
			// 	let vo = null
			// 	let info = null
			// 	for (let i = 0; i < list.length; i++) {
			// 		vo = list[i]
			// 		if (vo) {
			// 			info = this.common_mgr.GetFunctionIconCfg(vo.icon_type)
			// 			if (info && info.location_type == 6) {
			// 				have_time_icon_index = i
			// 				break
			// 			}
			// 		}
			// 	}
			// }
			let line_max_num = this.GetLineMaxIconNum(line_no)
			// let not_second_line_num = Mathf.Floor(have_time_icon_index / line_max_num)
			let totalLine = Math.ceil(Object.keys(list).length / line_max_num)
			// 首冲没完成并且存在遮挡关系
			let coverHeight = 0
			if (line_no == 3) {
				coverHeight = this.GpIconGroupCoverFirstChargeIconHeight(totalLine)
			}
			let now_line_no = null
			let oldLineNum;
			let keyList = Object.keys(list);
			for (let i = 0, len = keyList.length; i < len;) {
				var item: ActivityIcon = list[keyList[i]]
				if (item) {
					if (item.to_add) {
						// item.SetVisible(true)
						item.to_add = false
					}
					let y

					now_line_no = Mathf.Floor((count - 1) / line_max_num)
					if (line_no == 3 && coverHeight > 0 && !FirstRechargeModel.GetInstance().IsDoneAllReward() &&
						oldLineNum != now_line_no) {
						if (this.within_30min || FirstRechargeModel.GetInstance().is_bubble) {
							// 1、创角30分钟内，即首充图标上下浮动状态，第四行、第五行主界面图标自动空出3个图标位置
							// first_charge_gap = 3 % line_max_num * (ActivityIcon.WIDTH + this.hgap)
							if (now_line_no > totalLine - Math.ceil(coverHeight / (ActivityIcon.HEIGHT + this.vgap))) {
								count += 3
								oldLineNum = now_line_no
								continue
							}
						} else {
							// first_charge_gap = 1 % line_max_num * (ActivityIcon.WIDTH + this.hgap)
							if (now_line_no > totalLine - Math.ceil(coverHeight / (ActivityIcon.HEIGHT + this.vgap))) {
								count += 1
								oldLineNum = now_line_no
								continue
							}
						}
					}
					let x = (count - 1) % line_max_num * (ActivityIcon.WIDTH + this.hgap)
					let lv = RoleManager.GetInstance().GetMainRoleLevel()
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					if ((line_no == 1 || line_no == 2) && (open_day <= 8 || this.cycleimpActlistModel.type != 0) && lv >= 130 && !this.local_platform_manager.is_alpha) {
						x += this.fir_sen_start_x
					}
					y = init_y + now_line_no * (ActivityIcon.HEIGHT + this.vgap)
					item.SetPosition(x, y)
					item.SetAlpha(1)
					item.SetScale(1)
					item.SetVisible(true)
					count++
					i++
					if (item.RefreshPos) {
						item.RefreshPos()
					}
				}
			}
		}
	}

	ShowAnimation(bool?) {
		if (this.is_show == bool) {
			return this.is_show
		}

		this.is_show = bool
		this.is_moving = true
		this.ClearTween()
		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		let lv = RoleManager.GetInstance().GetMainRoleLevel()
		let topplayer_icon = (((open_day <= 8 || this.cycleimpActlistModel.type != 0) && lv >= 130)) ? 1 : 0
		if (bool) {
			if (this.first_line_icon_list.length > 0) {
				this.PlayOpen(1, this.first_line_icon_list)
			}
			if (this.second_line_icon_list.length > 0) {
				this.PlayOpen(2, this.second_line_icon_list)
			}
			if (this.other_line_icon_list.length > 0) {
				this.PlayOpen(3, this.other_line_icon_list)
			}
		}
		else {
			this.PlayHide()
		}
		if (topplayer_icon && !this.local_platform_manager.is_alpha) {
			if (bool) {
				table.insert(
					this.tween_list,
					SYTweenLite.to(
						this,
						this._box_rank,
						SYTweenLite.UiAnimationType.SCALE,
						Vector3.one,
						MainUIModel.Move_Time_Interval,
						null,
						SYTweenFunc.LINEAR
					)
				)
				table.insert(
					this.tween_list,
					SYTweenLite.to(
						this,
						this._box_rank,
						SYTweenLite.UiAnimationType.ALPHA,
						1,
						MainUIModel.Move_Time_Interval,
						null,
						SYTweenFunc.LINEAR
					)
				)
			} else if (!this.local_platform_manager.is_alpha) {


				table.insert(
					this.tween_list,
					SYTweenLite.to(
						this,
						this._box_rank,
						SYTweenLite.UiAnimationType.SCALE,
						Vector2.zero,
						MainUIModel.Move_Time_Interval,
						null,
						SYTweenFunc.LINEAR
					)
				)
				table.insert(
					this.tween_list,
					SYTweenLite.to(
						this,
						this._box_rank,
						SYTweenLite.UiAnimationType.ALPHA,
						0,
						MainUIModel.Move_Time_Interval,
						null,
						SYTweenFunc.LINEAR
					)
				)
			}
		}




		if (this.delay_refresh_time_id) {
			clearTimeout(this.delay_refresh_time_id)
			this.delay_refresh_time_id = false
			this.ani_end_need_refresh_icon = true
		}

		if (this.time_id) {
			clearTimeout(this.time_id)
			this.time_id = null
		}

		this.time_id =
			setTimeout(() => {
				this.is_moving = false
				if (this.ani_end_need_refresh_icon) {
					this.ani_end_need_refresh_icon = false
					this.ClearTween()
					this.TryRefreshAllIcon()
				}
			},
				MainUIModel.Move_Time_Interval + 0.2 // 加0.2容错
			)
		return this.is_show
	}

	PlayOpen(line_no?, list?) {
		if (list) {
			let count = 1
			let init_y = 0
			if (line_no == 2) {
				if (this.first_line_icon_list && this.first_line_icon_list.length > 0) {
					init_y = ActivityIcon.HEIGHT + this.vgap
				}
			} else if (line_no == 3) {
				if (this.first_line_icon_list && this.first_line_icon_list.length > 0) {
					init_y = ActivityIcon.HEIGHT + this.vgap
				}
				if (this.second_line_icon_list && this.second_line_icon_list.length > 0) {
					init_y = init_y + ActivityIcon.HEIGHT + this.vgap
				}
			}
			// let have_time_icon_index = 0
			// if (line_no == 3) {
			// 	let vo = null
			// 	let info = null
			// 	for (let i = 0; i < list.length; i++) {
			// 		if (vo) {
			// 			info = this.common_mgr.GetFunctionIconCfg(vo.icon_type)
			// 			if (info && info.location_type == 6) {
			// 				have_time_icon_index = i
			// 				break
			// 			}
			// 		}
			// 	}
			// }
			let line_max_num = this.GetLineMaxIconNum(line_no)
			// let not_second_line_num = Mathf.Floor(have_time_icon_index / line_max_num)
			let totalLine = Math.ceil(Object.keys(list).length / line_max_num)
			// 首冲没完成并且存在遮挡关系
			let coverHeight = 0
			if (line_no == 3) {
				coverHeight = this.GpIconGroupCoverFirstChargeIconHeight(totalLine)
			}
			let now_line_no = null
			let oldLineNum;
			let keyList = Object.keys(list);
			for (let i = 0, len = keyList.length; i < len;) {
				let item = list[keyList[i]];
				if (item && item.SetVisible) {
					if (item.to_add) {
						item.to_add = false
					}

					item.SetVisible(true)
					now_line_no = Mathf.Floor((count - 1) / line_max_num)
					if (line_no == 3 && coverHeight > 0 && !FirstRechargeModel.GetInstance().IsDoneAllReward() &&
						oldLineNum != now_line_no) {
						if (this.within_30min || FirstRechargeModel.GetInstance().is_bubble) {
							// 1、创角30分钟内，即首充图标上下浮动状态，第四行、第五行主界面图标自动空出3个图标位置
							// first_charge_gap = 3 % line_max_num * (ActivityIcon.WIDTH + this.hgap)
							if (now_line_no > totalLine - Math.ceil(coverHeight / (ActivityIcon.HEIGHT + this.vgap))) {
								count += 3
								oldLineNum = now_line_no
								continue
							}
						} else {
							// first_charge_gap = 1 % line_max_num * (ActivityIcon.WIDTH + this.hgap)
							if (now_line_no > totalLine - Math.ceil(coverHeight / (ActivityIcon.HEIGHT + this.vgap))) {
								count += 1
								oldLineNum = now_line_no
								continue
							}
						}
					}
					let x = (count - 1) % line_max_num * (ActivityIcon.WIDTH + this.hgap)
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					let lv = RoleManager.GetInstance().GetMainRoleLevel()
					if ((line_no == 1 || line_no == 2) && (open_day <= 8 || this.cycleimpActlistModel.type != 0) && lv >= 130) {
						x += this.fir_sen_start_x
					}

					let y = null
					// if (not_second_line_num >= now_line_no) {
					y = init_y + now_line_no * (ActivityIcon.HEIGHT + this.vgap)
					// } else {
					// 	y = init_y + not_second_line_num * (ActivityIcon.HEIGHT + this.vgap) + (now_line_no - not_second_line_num) * ActivityIcon.HEIGHT
					// }

					count++;
					i++;
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.POSX,
							x,
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.POSY,
							y,
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.SCALE,
							Vector3.one,
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.ALPHA,
							1,
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
				}
			}
		}
	}

	PlayHide() {
		if (this.icon_dic) {
			if (Util.TableSize(this.icon_dic) == 0) {
				return
			}
			for (let key in this.icon_dic) {

				let item = this.icon_dic[key]
				if (item) {
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.POSX,
							-95,
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.POSY,
							7,
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.SCALE,
							new Vector3(0.5, 0.5, 0.5),
							MainUIModel.Move_Time_Interval,
							null,
							SYTweenFunc.LINEAR
						)
					)
					table.insert(
						this.tween_list,
						SYTweenLite.to(
							this,
							item.display_obj,
							SYTweenLite.UiAnimationType.ALPHA,
							0,
							MainUIModel.Move_Time_Interval, () => { item.SetVisible(false) },
							SYTweenFunc.LINEAR
						)
					)
				}
			}
		}
	}

	GetLineMaxIconNum(line) {
		let max_num = 7
		if (line == 1 || line == 2) {
			max_num = 5
		}
		return max_num
	}

	ClearTween() {
		if (this.tween_list) {
			for (let _ in this.tween_list) {
				var key = this.tween_list[_]
				SYTweenLite.Stop(key)
			}
			this.tween_list = []
		}
	}

	ShowNotIndentIcon() {
		if (this.icon_dic) {
			if (!this.is_show) {
				this.RefreshIconPos(this.first_line_not_indent_icon_list, true)
				this.RefreshIconPos(this.other_line_not_indent_icon_list, false, this.first_line_not_indent_icon_list)
			}
		}
	}

	TryRefreshAllIcon() {

		if (this.is_moving) {
			this.ani_end_need_refresh_icon = true
			return
		}

		if (this.delay_refresh_time_id) {
			return
		}

		this.delay_refresh_time_id = setTimeout(() => {
			this.RefreshIcon()
			this.delay_refresh_time_id = false
		}, 500)
	}

	private CancelTipTimer = () => {

		if (this.close_tip_time) {
			GlobalTimerQuest.CancelQuest(this.close_tip_time)
			this.close_tip_time = null
		}
	}


	_gp_con: Laya.Box
	_box_rank: Laya.Box
	_img_bg: Laya.Image
	effect: Laya.Box
	icon_box: Laya.Box
	icon: Laya.Image
	bg1: Laya.Image
	name: Laya.Label
	player_name: Laya.Label
	time: Laya.Label
	_img_red: Laya.Image
	model_gp: Laya.Box
	public GetComponents() {
		[
			this._gp_con,
			this._box_rank,
			this._img_bg,
			this.effect,
			this.icon_box,
			this.icon,
			this.bg1,
			this.name,
			this.player_name,
			this.time,
			this._img_red,
			this.model_gp
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_box_rank",
				"_img_bg",
				"effect",
				"icon_box",
				"icon",
				"bg1",
				"name",
				"player_name",
				"time",
				"_img_red",
				"model_gp",
			])
		this.player_name.text = ""
	}
}
window["MainUIActivityView"] = MainUIActivityView