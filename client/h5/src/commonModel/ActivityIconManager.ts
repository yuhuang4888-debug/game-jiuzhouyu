import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "./RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Status } from "../util/Status"
import { PlatformManager } from "../PlatformManager"
import { VipModel } from "./VipModel"
import { ErlangParser } from "../util/ErlangParser"
import { CustomActivityModel } from "./CustomActivityModel"
import { LoginModel } from "../login/LoginModel"
import { ResManager } from "../common/ResManager"

export class ActivityIconManager extends EventDispatcher {

	public static UPDATE_SINGLE_ICON = "UPDATE_SINGLE_ICON"
	public static ADD_ICON = "ADD_ICON"
	public static DELETE_ICON = "DELETE_ICON"
	public static UPDATE_ALL_ICON = "UPDATE_ALL_ICON"
	public static SET_ICON_TEXT = "SET_ICON_TEXT"
	public static UPDATE_EFFECT = "UPDATE_EFFECT"
	public static ADD_RECHARGE_ICON = "ADD_RECHARGE_ICON"
	static Instance: ActivityIconManager

	static LocationType = {
		ActivityOne: 1,
		ActivityTwo: 2,
		ActivityOther: 3,
		Left: 4,
		Right: 5,
		Notice: 6,
	}

	role_mgr: RoleManager
	server_time_model: ServerTimeModel
	common_mgr: CommonManager
	task_model: TaskModel


	icon_box_info_dic = {}
	icon_red_dot_dic = {}
	icon_info_dic = {}

	//判断渠道[0]--base_type,[2]--0是GetActInfo,1是GetActByShowId
	juage_play_act = {
		"331@77@0":[77,1,0],
		"331@14":[82,1,1],
		"331@81@12":[81,12,1],
		"331@81@13":[81,13,1],	
	}
	public constructor() {
		super()

		if (ActivityIconManager.Instance) {
			return
		}
		ActivityIconManager.Instance = this

		this.role_mgr = RoleManager.GetInstance()
		this.server_time_model = ServerTimeModel.GetInstance()
		this.common_mgr = CommonManager.GetInstance()
		this.task_model = TaskModel.GetInstance()
		this.AddEvents()
		this.LevelChangeCheckIconOpen()
	}


	AddEvents() {
		let delay_timer_id = null
		let level_change = (lv?) => {
			if (delay_timer_id) {
				clearTimeout(delay_timer_id)
				delay_timer_id = null
			}
			if (!delay_timer_id) {
				delay_timer_id =
					setTimeout(() => {
						this.LevelChangeCheckIconOpen()
					}, 60)
			}
		}

		this.role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, level_change)
		GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, level_change)
		GlobalEventSystem.Bind(ServerTimeModel.REFRESH_SERVER_TIME, level_change)

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.LevelChangeCheckIconOpen()
		})

		let box_fun = (iconType?, bool?) => {
			let force = false
			let box_icon_cfg = this.common_mgr.GetBoxIconCfg(iconType)
			if (bool != null) {
				this.SetIconRedDot(iconType, bool)
			}
			if (box_icon_cfg) {
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, box_icon_cfg.attach_icon_type)
			}
		}

		GlobalEventSystem.Bind(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, box_fun)
		let alpha_state_change = () => {
			this.DeleteAllIcon()
			this.LevelChangeCheckIconOpen()
		}

		GlobalEventSystem.Bind(EventName.ALPHA_STATE_CHANGE, alpha_state_change)
	}

	SetIconRedDot(iconType?, bool?) {
		this.icon_red_dot_dic[String(iconType)] = bool
	}

	GetIconRedDot(iconType?) {
		return this.icon_red_dot_dic[String(iconType)]
	}

	getIconInfo(iconType?) {
		return this.icon_info_dic[String(iconType)]
	}

	getBoxIconInfo(iconType?) {
		return this.icon_box_info_dic[String(iconType)]
	}

	addIcon(iconType?, time?, iconInfo?, icon_txt?, icon_img?) {
		iconType = String(iconType)
		// if (iconType == "283" && ! HolyTerritoryModel.GetInstance().RealTimeOpen()  ) {
		// 	this.deleteIcon(iconType)
		// 	return
		// }
		//优化渠道判断
		if (this.juage_play_act[iconType]) {
			let [b,s,t] = this.juage_play_act[iconType]
			let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
			let is_can_add = false
			let act 
			if(t == 0){
				act = CustomActivityModel.GetInstance().GetActInfo(b, s);
			}else if(t == 1){
				act = CustomActivityModel.GetInstance().GetActInfoByShowID(b, s);
			}
			if (act) {
				let reward_show_list = ErlangParser.GetInstance().Parse(act.condition);
				for (let key in reward_show_list) {
					if (reward_show_list[key][0] == "source_list") {
						for (let _ in reward_show_list[key][1]) {
							if (play_name == reward_show_list[key][1][_]) {
								is_can_add = true
								break
							}
						}
						if (!is_can_add) {
							return
						}
					}
				}
			}
		}
		// if (iconType == "331@77@0") {
		// 	let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
		// 	let is_can_add = false
		// 	let act = CustomActivityModel.GetInstance().GetActInfo(77, 1);
		// 	if (act) {
		// 		let reward_show_list = ErlangParser.GetInstance().Parse(act.condition);
		// 		for (let key in reward_show_list) {
		// 			if (reward_show_list[key][0] == "source_list") {
		// 				for (let _ in reward_show_list[key][1]) {
		// 					if (play_name == reward_show_list[key][1][_]) {
		// 						is_can_add = true
		// 						break
		// 					}
		// 				}
		// 				if (!is_can_add) {
		// 					return
		// 				}
		// 			}
		// 		}
		// 	}
		// }

		// if (iconType == "331@14") {
		// 	let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
		// 	let is_can_add = false
		// 	let act = CustomActivityModel.GetInstance().GetActInfoByShowID(82, 1);
		// 	if (act) {
		// 		let reward_show_list = ErlangParser.GetInstance().Parse(act.condition);
		// 		for (let key in reward_show_list) {
		// 			if (reward_show_list[key][0] == "source_list") {
		// 				for (let _ in reward_show_list[key][1]) {
		// 					if (play_name == reward_show_list[key][1][_]) {
		// 						is_can_add = true
		// 						break
		// 					}
		// 				}
		// 				if (!is_can_add) {
		// 					return
		// 				}
		// 			}
		// 		}
		// 		if (!is_can_add) {
		// 			return
		// 		}
		// 	}
		// }

		// //@huoyijian整理！  活跃抽奖
		// if (iconType == "331@81@12" || iconType == "331@81@13") {
		// 	let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
		// 	let is_can_add = false
		// 	let _iconList = iconType.split("@")
		// 	let act = CustomActivityModel.GetInstance().GetActInfoByShowID(81, Number(_iconList[2]));
		// 	if (act) {
		// 		let reward_show_list = ErlangParser.GetInstance().Parse(act.condition);
		// 		for (let key in reward_show_list) {
		// 			if (reward_show_list[key][0] == "source_list") {
		// 				for (let _ in reward_show_list[key][1]) {
		// 					if (play_name == reward_show_list[key][1][_]) {
		// 						is_can_add = true
		// 						break
		// 					}
		// 				}
		// 				if (!is_can_add) {
		// 					return
		// 				}
		// 			}
		// 		}
		// 		if (!is_can_add) {
		// 			return
		// 		}
		// 	}
		// }



		let roleVo = this.role_mgr.GetMainRoleVo()
		if (!roleVo) {
			return
		}
		let cfg = this.common_mgr.GetFunctionIconCfg(iconType)
		if (cfg) {
			if (PlatformManager.GetInstance().is_alpha && cfg.need_hide_in_alpha) {	//审核服下，图标不显示
				return
			}
			let openDay = this.server_time_model.GetOpenServerDay()
			if (iconType == "114") {
				let add_vip = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientAddVipService", true)
				let play_name = LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
				if (add_vip) {
					for (let key in add_vip) {
						if (add_vip[key].tem && add_vip[key].icon_info && add_vip[key].tem.indexOf(play_name) > -1) {
							cfg.icon_name = add_vip[key].icon_info.icon_name
							cfg.open_lv = add_vip[key].icon_info.open_lv
							cfg.open_day = add_vip[key].icon_info.open_day
						}
					}
				}
			}
			if ((iconType == "2820" && openDay > 15)) {
				if (roleVo.level < 160) {
					this.deleteIcon(cfg.icon_type)
					return
				}

			} else {
				if ((
					roleVo.level < cfg.open_lv
					|| openDay < cfg.open_day
					|| ((cfg.max_open_day && cfg.max_open_day != 0) && openDay > cfg.max_open_day)
					|| (cfg.open_task_id && this.task_model.newest_finish_task_id < cfg.open_task_id)

				)
					//and (iconType == "2820" && openDay > 15 && roleVo.level < 160)
				) {

					this.deleteIcon(cfg.icon_type)
					return
				}
			}
		} else {
			return
		}

		let count_down_time = time
		let vo = this.getIconInfo(iconType)
		let box_icon_cfg = this.common_mgr.GetBoxIconCfg(iconType)

		if (box_icon_cfg) {
			if (!this.CheckBoxOpenState(box_icon_cfg.attach_icon_type)) {
				this.RestoreIconFromBox()
			} else if (this.NeedInputBox(box_icon_cfg)) {
				this.deleteIcon(cfg.icon_type)
				let info = null
				info = []
				info.id = iconType
				info.time = count_down_time
				info.add_time = Status.NowTime
				info.icon_txt = icon_txt || ""
				info.icon_img = icon_img
				info.data = iconInfo || this.common_mgr.GetFunctionIconCfg(iconType)
				this.icon_box_info_dic[iconType] = info
				if (!this.getIconInfo(box_icon_cfg.attach_icon_type)) {
					this.addIcon(box_icon_cfg.attach_icon_type)
				}
				return
			}
		}
		if (vo) {
			if (count_down_time != null) {
				vo.time = count_down_time
			}
			vo.icon_img = icon_img
			GlobalEventSystem.Fire(ActivityIconManager.UPDATE_SINGLE_ICON, iconType)
		} else {
			if (this.FunIsOpenByIconType(iconType)) {
				let info = null
				info = []
				info.id = iconType
				info.time = count_down_time || 0
				info.add_time = Status.NowTime
				info.icon_txt = icon_txt || ""
				info.data = iconInfo || this.common_mgr.GetFunctionIconCfg(iconType)
				info.icon_img = icon_img
				this.icon_info_dic[iconType] = info
				if (info.data) {
					GlobalEventSystem.Fire(ActivityIconManager.ADD_ICON, iconType, info.data.location_type)
				}
			}
		}
		if (cfg.is_box) {
			this.DeleteIconAndIntoBox(iconType)
		}
	}

	deleteIcon(iconType?) {
		iconType = String(iconType)
		if (this.icon_info_dic[iconType] || this.icon_box_info_dic[iconType]) {
			GlobalEventSystem.Fire(ActivityIconManager.DELETE_ICON, iconType)
			delete this.icon_info_dic[iconType]
			delete this.icon_box_info_dic[iconType]
		}
	}

	DeleteAllIcon() {
		for (let iconType in this.icon_info_dic) {

			this.deleteIcon(iconType)
		}
		for (let iconType in this.icon_box_info_dic) {

			this.deleteIcon(iconType)
		}
	}

	LevelChangeCheckIconOpen() {
		let roleVo = this.role_mgr.GetMainRoleVo()
		if (!roleVo || roleVo.role_id == 0) {
			return
		}
		let openDay = this.server_time_model.GetOpenServerDay()
		let cfg = null
		let sub_cfg = null
		for (let area in Config.PRELOAD_CLIENT_CONFIG.ConfigFunctionIcon) {

			cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFunctionIcon[area]
			if (cfg) {
				for (let key in cfg) {

					if (key == "33216") {
						sub_cfg = cfg[key]
					}
					sub_cfg = cfg[key]
					if (sub_cfg) {
						if (!sub_cfg.controll_by_own_fun) {
							this.addIcon(sub_cfg.icon_type)
						}
					}
				}
			}
		}
	}

	FunIsOpenByIconType(icon_type?) {
		let open = true
		if (icon_type == 10) {
		} else if (icon_type == 11) {
		}
		return open
	}

	CheckBoxOpenState(iconType?) {
		let cfg = this.common_mgr.GetFunctionIconCfg(iconType)
		let roleVo = this.role_mgr.GetMainRoleVo()
		if (((cfg && cfg.is_box) && roleVo) && !cfg.controll_by_own_fun) {
			let openDay = this.server_time_model.GetOpenServerDay()
			if (roleVo.level < cfg.open_lv || openDay < cfg.open_day || (cfg.max_open_day != 0 && openDay > cfg.max_open_day)
				|| cfg.open_task_id && this.task_model.newest_finish_task_id < cfg.open_task_id
			) {
				return false
			}
		}
		return true
	}

	NeedInputBox(icon_cfg?) {
		if (icon_cfg) {
			let openDay = this.server_time_model.GetOpenServerDay()
			let roleVo = this.role_mgr.GetMainRoleVo()
			// if (icon_cfg.icon_type == "1112" && KaifuActivityModel && ! KaifuActivityModel.GetInstance().canShowIcon() ) {
			// 	return false
			// }
			// if (icon_cfg.icon_type == "424" || icon_cfg.icon_type == "424@1" ) {
			// 	let type = Config.ConfigCustomActivity.SPECIAL_ID["BOOKOFCONTRACT"]
			// 	return CustomActivityModel.GetInstance().GetSpecialOpenState(type)
			// }
			if (((roleVo.level < icon_cfg.attach_open_lv || openDay < icon_cfg.attach_open_day) ||
				icon_cfg.attach_max_open_day != 0 && openDay > icon_cfg.attach_max_open_day)
				|| icon_cfg.attach_open_task_id && this.task_model.newest_finish_task_id < icon_cfg.attach_open_task_id
				|| (icon_cfg.attach_vip_lv && icon_cfg.attach_vip_lv <= VipModel.GetInstance().GetVipLevel())
			) {
				return false
			}
			return true
		}
	}

	RestoreIconFromBox() {
		let box_icon_cfg = null
		let icon_info = null
		for (let icon_type in this.icon_box_info_dic) {

			box_icon_cfg = this.common_mgr.GetBoxIconCfg(icon_type)
			icon_info = this.icon_box_info_dic[icon_type]
			if ((icon_info && box_icon_cfg) && !this.CheckBoxOpenState(box_icon_cfg.attach_icon_type)) {
				let box_icon = box_icon_cfg.attach_icon_type
				this.icon_box_info_dic[icon_type] = null
				let is_delete = true
				for (let _type in this.icon_box_info_dic) {

					let box_cfg = this.common_mgr.GetBoxIconCfg(_type)
					if (box_cfg && box_cfg.attach_icon_type == box_icon) {
						is_delete = false
					}
				}
				if (is_delete && this.getBoxIconInfo(box_icon)) {
					this.deleteIcon(box_icon)
				}
				this.addIcon(icon_type, icon_info.time, null, icon_info.icon_txt, icon_info.icon_img)
			}
		}
	}

	DeleteIconAndIntoBox(iconType?) {
		let cfg = null
		let info = null
		for (let key in Config.PRELOAD_CLIENT_CONFIG.ConfigBoxIcon) {

			cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigBoxIcon[key]
			if (cfg.attach_icon_type == iconType) {
				info = this.getIconInfo(cfg.icon_type)
				if (info) {
					this.addIcon(cfg.icon_type, info.time, null, info.icon_txt, info.icon_img)
				}
			}
		}
	}

	public static GetInstance() {

		if (!ActivityIconManager.Instance) {
			new ActivityIconManager()
		}
		return ActivityIconManager.Instance
	}
}
window["ActivityIconManager"] = ActivityIconManager