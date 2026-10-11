import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { Alert, Alert_Type } from "../alert/Alert"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ModelPartPos } from "../sharedata/RoleVo"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameResPath } from "../util/GameResPath"
import { Trim } from "../util/Util"
import { DressModel, DressType } from "./DressModel"
import { GoodsModel } from "./GoodsModel"
import { Config } from "../common/Config"
import { DailyModel } from "./DailyModel"
import { DailyEvent } from "../daily/DailyEvent"
import { ResManager } from "../common/ResManager"
import { TimeUtil } from "../util/TimeUtil"
import { __values } from "../../node_modules/tslib/tslib"


export let BrightSeaEvent = {
	REQUEST_PROTO: "BrightSeaEvent_1",		// 请求协议
	UPDATE_BRIGHTSEA_VIEW: "BrightSeaEvent_2",		// 刷新界面
	OPEN_VIEW: "BrightSeaEvent_3",		// 打开界面
	CLOSE_VIEW: "BrightSeaEvent_4",		// 关闭界面
	UPDATE_CRUISE_LOG: "BrightSeaEvent_5",		// 更新巡航日志
	UPDATE_CRUISE_RET: "BrightSeaEvent_6", 		// 巡航结果
	UPDATE_NOTIFICATION_ADD: "BrightSeaEvent_7", 		// 巡航通知
	UPDATE_SEND_LIST_ADD: "BrightSeaEvent_8", 		// 新增船只
	CRUISE_CALLBACK: "BrightSeaEvent_9", 		// 巡航回包
	UPDATE_SHIP_INFO: "BrightSeaEvent_10", 		// 刷新船只界面
	UPDATE_LEVELUP_SHIP: "BrightSeaEvent_11", 		// 船只幸运值升级（未满）
	UPDATE_FIGHT_INFO: "BrightSeaEvent_12",		// 更新战斗信息
	LEVELUP_SHIP: "BrightSeaEvent_13",		// 船只幸运值满
	UPDATE_SERVER_INFO: "BrightSeaEvent_14", 		// 跨服信息
	RECEIVE_REWARD: "BrightSeaEvent_15", 		// 收到奖励
	UPDATE_DIAMOND_INFO: "BrightSeaEvent_16", 		// 绑钻信息
	BATTLE_RESULT: "BrightSeaEvent_17"		// 战斗结果
}
window["BrightSeaEvent"] = BrightSeaEvent

export let SortType = {
	ShipId: 1, 	// 船只档次
	Level: 2, 	// 玩家等级
	Fight: 3 	// 玩家战力
}
window["SortType"] = SortType

export let CruiseState = {
	Cruising: 0, 	// 巡航中
	CanReward: 1,	// 巡航完毕未领奖
	Finished: 2, 	// 已领取
	Rest: 4   // 什么也没干（服务器没有这个状态， 客户端根据autoid=0 自定义）
}
window["CruiseState"] = CruiseState

export let SeaNotificationType = {
	Result: 1,		// 巡航结算
	BePlunder: 2,  // 被掠夺
	GuildHelp: 3,  // 结社协助
	TypeEnd: 4
}
window["SeaNotificationType"] = SeaNotificationType

export class BrightSeaModel extends EventDispatcher {

	AddCruiseNotification
	AppendToSendList
	CheckCruiseNotification
	CheckCruiseNum
	GetCanReceiveNum
	GetCfgKeyValue
	GetGuildName
	GetHeadFrame
	GetHeadRes
	GetModelResByShipId
	GetModelShipTextureId
	GetMyShipData
	GetPerfactEmemyShip
	GetRedState
	GetRolesData
	GetSerIdRoleName
	GetShipName
	GetShipSendList
	GetShowShipList
	InCruiseLogList
	InitKeyValue
	IsInNotificationMap
	LaunchBattle
	LoadAndRefreshAwardItem
	LoadAwardItem
	PopCruiseNotification
	PopCruiseNotificationByType
	RemoveNotificationByAutoId
	SetCanReceiveNum
	SetCruiseLog
	SetCruiseResult
	SetMainViewInfo
	SetRedState
	SetRolesData
	SetSendList
	ShowNotification
	SortChipData

	/**巡航红点 */
	bright_sea_red_state
	/**掠夺红点 */
	plunder_red_state

	can_receive_num
	key_dic
	my_ship_data
	notification_map
	send_list
	MAX_SHIP_ON_SEA = 8
	rolesData
	curise_log_list
	config_sea_treasure_reward
	GetTestDataOfShip
	enemy_fight

	main_info_
	GetRobStatus
	SetRobStatus
	UpdateBrightSeaRedAll

	//协助上限
	SetAssitLimt
	GetAssitLimt
	is_help_limit
	InitConfig

	result_info
	combat_power
	serInfo
	startRound
	guide_info

	public static MOUDLE_ID = {
		Arena: 280,
		NineSky: 135,
		DuelArena: 653
	}
	BrightTestData: any
	main_info: any

	public constructor() {
		super()
		if (BrightSeaModel.Instance) {
			return
		}
		BrightSeaModel.Instance = this

		// 璀璨之海
		let local_Config = Config
		let local_ModelPartPos = ModelPartPos
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName


		this.is_help_limit = false
		this.SetAssitLimt = (values?) => {
			this.is_help_limit = values
		}

		this.GetAssitLimt = () => {
			return this.is_help_limit
		}

		this.InitConfig = () => {
			this.main_info_ = null
			this.config_sea_treasure_reward = Config.PRELOAD_SERVER_CONFIG.config_sea_treasure_reward
			//this.InitKeyValue(local_Config.Jjcconfig, { 1, 4, 17})
		}

		/*
			缓存船只列表
		*/
		this.SetSendList = (send_list?) => {
			this.my_ship_data = null
			this.send_list = send_list
		}

		this.AppendToSendList = (data?) => {
			this.send_list = this.send_list || []
			for (let index = 0; index < this.send_list.length; index++) {
				var info = this.send_list[index]
				if (info.auto_id == data.auto_id) {
					this.send_list[index] = data
					return
				}
			}
			table.insert(this.send_list, data)
		}

		this.SetCruiseResult = (scmd?) => {
			this.ChangeVar("curise_result", scmd)
		}

		this.SetMainViewInfo = (scmd?) => {
			this.main_info_ = scmd
			this.ChangeVar("main_info", scmd)
		}

		// 巡航日志
		this.SetCruiseLog = (log_list?) => {
			this.ChangeVar("curise_log_list", log_list)
		}

		this.GetCfgKeyValue = (key?) => {
			return this.key_dic[key]
		}

		this.SetRolesData = (value?) => {
			this.ChangeVar("rolesData", value)
		}

		this.GetRolesData = () => {
			return this.rolesData
		}

		this.InCruiseLogList = (auto_id?) => {
			if (this.curise_log_list) {
				for (let _ in this.curise_log_list) {
					var log_info = this.curise_log_list[_]
					if (log_info.auto_id == auto_id) {
						return true
					}
				}
			}
			return false
		}

		this.SetRedState = (bool?) => {
			this.bright_sea_red_state = bool
		}

		this.GetRedState = () => {
			return this.bright_sea_red_state
		}

		/**掠夺红点 */
		this.GetRobStatus = () => {
			return this.plunder_red_state
		}

		/**检查是否有可掠夺的玩家 */
		this.SetRobStatus = () => {
			this.plunder_red_state = false

			if (this.main_info_ && (this.main_info_.total_rob_times-this.main_info_.rob_times) > 0) {
				let play_list = this.send_list||[]
				let main_vo = RoleManager.GetInstance().GetMainRoleVo()
				let role_fight = main_vo ? (main_vo.fighting * 1.1) : 0
				let role_id = main_vo ? main_vo.role_id : 0
				for (let i = 0; i < play_list.length; i++) {
					let obj = play_list[i]
					if (!obj) continue
					if (obj.role_id == role_id) continue
					if (obj.power <= role_fight) {
						this.plunder_red_state = true
						break
					}
				}
			}

		}

		/**统一更新所有的红点 */
		this.UpdateBrightSeaRedAll = () => {
			let bool  = this.GetRedState()||this.GetRobStatus()
			DailyModel.GetInstance().ShowRedDot()
			local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 157)
			local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DailyView", 2, bool)
			RedDotController.ins.up(RedKey.BRIGHT_SEA_PLUNDER, this.GetRobStatus() ? 1 : 0)
			RedDotController.ins.up(RedKey.BRIGHT_SEA, bool ? 1 : 0)
		}

		this.InitKeyValue = (cfg?, keys?) => {
			this.key_dic = []
			for (let _tmpi in keys) {
				var key = keys[_tmpi]
				if (typeof (cfg[key].value) == "string") {
					this.key_dic[key] = Trim(cfg[key].value)
				} else {
					this.key_dic[key] = cfg[key].value
				}
			}
		}

		this.GetCanReceiveNum = () => {
			return this.can_receive_num
		}

		this.SetCanReceiveNum = (cfg?, scmd?) => {
			this.can_receive_num = 0
			let history_rank = scmd.history_rank
			for (let key in cfg) {

				if (cfg[key].rank >= history_rank && history_rank != 0) {
					this.can_receive_num = this.can_receive_num + 1
				}
			}
		}

		// 璀璨之海
		this.SortChipData = (ship_list?) => {
			if (!ship_list) { return }

			// TODO dxj 如果有船只在巡航，优先级提高
			table.sort(ship_list, (ship1?, ship2?) => {
				if (ship1.quality != ship2.quality) {
					return ship1.quality > ship2.quality
				}
				return false
			})
		}

		this.CheckCruiseNum = (is_show_msg?) => {
			if (is_show_msg == null) {
				is_show_msg = true
			}

			if (this.BrightTestData.cruise_num < 1) {
				if (is_show_msg) {
					Message.show("今日巡航次数已用完")
				}
				return false
			}
			return true
		}

		// 获取自己的船只信息
		this.GetMyShipData = () => {
			let ship_list = this.send_list
			if (!ship_list) { return }

			if (!this.my_ship_data) {
				let main_role_id = RoleManager.GetInstance().GetMainRoleId()
				for (let _ in ship_list) {
					var ship_data = ship_list[_]
					if (ship_data.role_id == main_role_id) {
						this.my_ship_data = ship_data
						return this.my_ship_data
					}
				}
			} else {
				return this.my_ship_data
			}
		}

		/*
			获取头像res
		*/
		this.GetHeadRes = (data?) => {
			let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let picture_source = (data.career || main_role_vo.career) + "001"
			let picture_id = data.picture || data.pic
			if (picture_id && Trim(String(picture_id)) != "") {
				let picture_cfg = Config.PRELOAD_SERVER_CONFIG.config_picture[picture_id]
				if (picture_cfg) {
					picture_source = picture_cfg.resource
				}
			}
			return GameResPath.GetIcon("head", picture_source)
		}

		/*
			获取头像框
		*/
		this.GetHeadFrame = (data?) => {
			let dress_list = data.dress_list
			let frame_id = DressModel.GetInstance().GetDressByType(dress_list, DressType.Photo)
			if (frame_id) {
				return GameResPath.GetIcon("head", "2_" + frame_id)
			}
			return null
		}

		/*
			奖励
			reward_info: 1 type 2 id 3 数量
		*/
		this.LoadAwardItem = (reward_info?, parent?, layer_value?, size?) => {
			layer_value = layer_value || "Activity"
			let type_id, lock = GoodsModel.GetInstance().GetMappingTypeId(reward_info[1], reward_info[2])
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			let item
			if (goods_vo) {
				size = size || 100
				item = new EquipmentItem(parent, null, layer_value)
				item.SetItemSize(size, size)
				item.SetUseMask(true)
				item.Load()
				item.SetData(goods_vo.type_id, reward_info[3], lock)
				item.SetVisible(true)
			}
			return item
		}

		/*
			指定加载或刷新list中的奖励
		*/
		this.LoadAndRefreshAwardItem = (reward_info?, parent?, list?, index?, layer_value?, size?) => {
			let item = list[index]
			if (!item) {
				item = this.LoadAwardItem(reward_info, parent, layer_value, size)
				if (item) {
					list[index] = item
					return true
				}
			} else {
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_info[0], reward_info[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, reward_info[2], lock)
					item.SetVisible(true)
					return true
				}
			}
			return false
		}

		/*
		检查通知栏
	*/
		this.CheckCruiseNotification = () => {
			if (!this.notification_map) {
				return 0
			}

			let n_num = 0
			for (let _ in this.notification_map) {
				var notification_list = this.notification_map[_]
				if (notification_list) {
					n_num = n_num + notification_list.length
				}
			}
			return n_num
		}

		this.AddCruiseNotification = (cruise_type?, cruise_info?) => {
			if (!this.notification_map) {
				this.notification_map = []
				for (let _ in SeaNotificationType) {
					var type = SeaNotificationType[_]
					this.notification_map[type - 1] = []
				}
			}
			if (this.notification_map[cruise_type - 1]) {
				cruise_info.ntype = cruise_type
				if (cruise_info.auto_id && this.IsInNotificationMap(cruise_type, cruise_info.auto_id)) {
					return
				}
				table.insert(this.notification_map[cruise_type - 1], cruise_info)
			}
			this.Fire(BrightSeaEvent.UPDATE_NOTIFICATION_ADD)
		}

		this.IsInNotificationMap = (cruise_type?, auto_id?) => {
			if (this.notification_map[cruise_type - 1] && this.notification_map[cruise_type - 1].length > 0) {
				let notification_info
				for (let i = 0; i < this.notification_map[cruise_type - 1].length; i++) {
					notification_info = this.notification_map[cruise_type - 1][i]
					if (notification_info.auto_id == auto_id) {
						return true
					}
				}
			}
			return false
		}

		this.RemoveNotificationByAutoId = (auto_id?) => {
			if (!this.notification_map) {
				return null
			}
			let notification_info
			for (let type = 1; type < SeaNotificationType.TypeEnd; type++) {
				if (this.notification_map[type - 1] && this.notification_map[type - 1].length > 0) {
					for (let i = 0; i <= this.notification_map[type - 1].length; i++) {
						notification_info = this.notification_map[type - 1][i]
						if (notification_info.auto_id == auto_id) {
							table.remove(this.notification_map[type - 1], i)
							this.Fire(BrightSeaEvent.UPDATE_NOTIFICATION_ADD)
							return
						}
					}
				}
			}
		}

		/*
			根据优先级pop一条通知
		*/
		this.PopCruiseNotification = () => {
			if (!this.notification_map) {
				return null
			}
			let notification
			for (let type = 1; type < SeaNotificationType.TypeEnd; type++) {
				notification = this.PopCruiseNotificationByType(type)
				if (notification) {
					break
				}
			}
			return notification
		}

		/*
			按照类型pop一条通知
		*/
		this.PopCruiseNotificationByType = (type?, last_notice?) => {
			if (!this.notification_map) {
				return null
			}
			let notification
			let arr_noti = this.notification_map[type - 1] || []
			if (arr_noti && arr_noti.length > 0) {
				if (last_notice) {
					notification = table.remove(arr_noti)
				} else {
					notification = table.shift(arr_noti)
				}
				this.Fire(BrightSeaEvent.UPDATE_NOTIFICATION_ADD)
			}
			return notification
		}

		/*
			取一条通知展示
		*/
		this.ShowNotification = () => {
			let num = this.CheckCruiseNotification()
			if (num > 0) {
				let notification = this.PopCruiseNotification()
				let type = notification.ntype
				if (type == SeaNotificationType.Result) {
					this.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaResultView", notification)
				} else if (type == SeaNotificationType.BePlunder) {
					Alert.Show("您在巡航期间惨遭他人掠夺,请赶紧前往查看", Alert_Type.One, () => {
						DailyModel.GetInstance().Fire(DailyEvent.OPEN_VIEW, "DailyView", 2)
						this.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaCruiseLogView")
					}, null, "前往查看")
				} else if (type == SeaNotificationType.GuildHelp) {
					this.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaThanksDialog", notification)
				}
			}
		}

		/*
			获取排序后的船只
		*/
		this.GetShipSendList = (sort_type?, add_order?, not_this?) => {
			if (!this.send_list) {
				return null
			}
			if (add_order == null) {
				add_order = true
			}
			let main_role_id = RoleManager.GetInstance().GetMainRoleId()
			let list = []
			for (let _ = 0; _ < this.send_list.length; _++) {
				var info = this.send_list[_]
				if (not_this) {
					// 2表示已被掠夺
					if (info.rob_times != 2) {
						table.insert(list, info)
					}
				} else {
					if (info.role_id != main_role_id) {
						table.insert(list, info)
					}
				}
			}
			let sort_key = (sort_type == null || sort_type == SortType.ShipId) && "shipping_id" ||
				(sort_type == SortType.Level && "role_lv" || "power")
			table.sort(list, (log1?, log2?) => {
				if (log1[sort_key] != log2[sort_key]) {
					if (add_order) {
						return log1[sort_key] > log2[sort_key]
					} else {
						return log1[sort_key] < log2[sort_key]
					}
				}
				return false
			})
			return list
		}

		/*
			获取最优掠夺船只
		*/
		this.GetPerfactEmemyShip = (list?) => {
			if (!list) {
				return null
			}
			let my_fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
			let greater_ship_id = 1
			let ship_index = 0//1

			for (let index = 0; index < list.length; index++) {
				var info = list[index]
				if (info.power < my_fighting && info.shipping_id > greater_ship_id) {
					greater_ship_id = info.shipping_id
					ship_index = index
				}
			}
			return ship_index//[ship_index, greater_ship_id]
		}

		/*
			发起战斗
			type: 1掠夺 2复仇
		*/
		this.LaunchBattle = (auto_id?, ser_id?, role_id?, type?) => {
			// let Launch = () => {
			// 	this.Fire(BrightSeaEvent.REQUEST_PROTO, 18905, auto_id, ser_id, role_id, type)
			// }
			// let alert1 = () => {
			// 	Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
			// 		Launch()
			// 	}, null, "离开", "取消")
			// }

			// if (SceneManager.GetInstance().IsBossScene()) {
			// 	alert1()
			// } else {
			// 	if (SceneManager.GetInstance().IsFieldScene()) {
			// 		Launch()
			// 	} else {
			// 		Alert.Show("当前场景不能跳转")
			// 	}
			// }

			if (SceneManager.GetInstance().IsFieldScene()) {
				this.Fire(BrightSeaEvent.REQUEST_PROTO, 18905, auto_id, ser_id, role_id, type)
			} else {
				Message.show("当前场景不能跳转")
			}
		}

		/*
			取船只名字
		*/
		this.GetShipName = (ship_id?) => {
			let ship_data = this.config_sea_treasure_reward[ship_id]//Config.Seatreasurereward[ship_id]
			if (ship_data) {
				return ship_data.name
			}
			return null
		}

		/*
			筛选出优先级高的船只展示在海上  is_test是否是测试数据
		*/
		this.GetShowShipList = (list?, is_test?) => {
			if (!list) {
				return null
			}
			let main_role_id = RoleManager.GetInstance().GetMainRoleId()
			let main_info = this.main_info
			let my_ship_data
			let list_len = 0
			for (let key in list) {
				list_len++
			}
			let arr_sort = []
			for (let i = 0; i < list_len; i++) {
				if (!list[i]) {
					console.log(`测试:${i}`)
					continue
				}
				if (list[i].role_id == main_role_id) {
					my_ship_data = list[i]
				} else {
					table.insert(arr_sort, list[i])
				}
			}
			table.sort(arr_sort, (ship1?, ship2?) => {
				if (ship1.shipping_id != ship2.shipping_id) {
					return ship1.shipping_id > ship2.shipping_id
				}
				return false
			})
			let tmp_list = []
			let length = arr_sort.length < this.MAX_SHIP_ON_SEA && arr_sort.length || this.MAX_SHIP_ON_SEA
			let this_in_list = false
			for (let i = 0; i < length; i++) {
				table.insert(tmp_list, arr_sort[i])
				if (arr_sort[i] && arr_sort[i].role_id == main_role_id) {
					this_in_list = true
				}
			}
			if (!this_in_list && my_ship_data && ((main_info && main_info.status == 0) || is_test)) {
				if (tmp_list.length >= this.MAX_SHIP_ON_SEA) {
					table.remove(tmp_list, tmp_list.length)
					table.insert(tmp_list, my_ship_data)
				} else {
					table.insert(tmp_list, my_ship_data)
				}
			}
			return tmp_list
		}

		this.GetGuildName = (guild_name?) => {
			if (!guild_name || guild_name == "") {
				guild_name = "无结社"
			} else {
				guild_name = guild_name
			}
			return guild_name
		}

		let shipId2ModelName = [
			"15010034",
			"15010035",
			"15010036",
			"15010060"
		]
		this.GetModelResByShipId = (ship_id?) => {
			return shipId2ModelName[ship_id - 1] || shipId2ModelName[1]
		}

		let shipId2ModelTextureId = {
			"15010034": 1,
			"15010035": 2,
			"15010036": 3,
			"15010060": null
		}
		this.GetModelShipTextureId = (model_id?) => {
			return shipId2ModelTextureId[model_id]
		}

		//测试数据
		this.GetTestDataOfShip = () => {
			let data

			data = {}
			data.auto_id = 4294995524
			data.reward_times = 1            // 巡航次数
			data.total_reward_times = 2     // 巡航总次数
			data.rob_times = 0             // 掠夺次数
			data.total_rob_times = 3        // 掠夺总次数
			data.status = 2					 // 巡航状态 0: 什么也没干 1：巡航中 2：巡航完毕未领奖
			data.send_list = []
			data.pic = "204"
			data.pic_ver = 0

			for (let i = 1; i <= 1; i++) {
				// let guildName = `结社编号${i}`
				// let role_id = 4294968379//RoleManager.GetInstance().GetMainRoleId() + (i - 1) * 2
				// let playName = `玩家${i}`
				// let time = TimeUtil.getServerTime() + i * 1000

				let temp
				temp = {
					auto_id: 0,
					career: 2,
					end_time: (new Date().getTime() + 100000) / 1000,
					guild_id: 4294967297,
					guild_name: "sdfsd",
					pic: "104",
					pic_ver: 0,
					power: 2435385,
					rob_times: 0,
					role_id: 4294967299,
					role_lv: 520,
					role_name: "奥卡凯特",
					ser_id: 1,
					ser_num: 1,
					sex: 2,
					shipping_id: 2,//i % 2 == 0 ? 2 : 3,        // 船只档次id
					turn: 4
				}
				table.insert(data.send_list, temp)
			}
			return data
		}

		//this.GetSerIdRoleName = (. role_name, ser_id) => {
		//let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
		//main_role_vo.
		//}
	}

	static Instance: BrightSeaModel
	public static GetInstance() {

		if (!this.Instance) {
			this.Instance = new this()
		}
		return this.Instance
	}
}

// 测试数据


//    log_list.array{
// 		type.int8                   // 0掠夺/1被掠夺
// 		ser_id.int32                // 服id
// 		ser_num.int32               // 服数
// 		role_id.int64               // 玩家id
// 		role_name.string            // 玩家名
// 		shipping_id.int8            // 船只档次id
// 		reward.arr_object_list      // 奖励
// 		back_list.arr_object_list   // 追回奖励（掠夺时返回空）
// 		time.int32                  // 时间
// 	}


/*
	log_list = [
		 {
			type = 1,
			ser_id = 1,
			ser_num = 2,
			role_id = 110,
			role_name = "XXX",
			shipping_id = 1,
			reward = {],
			back_list = [],
			time = os.time(),
		},
		[2] = {
			type = 0,
			ser_id = 1,
			ser_num = 2,
			role_id = 110,
			role_name = "XXX2",
			shipping_id = 1,
			reward = [],
			back_list = [],
			time = os.time(),
		},
		[3] = {
			type = 1,
			ser_id = 1,
			ser_num = 2,
			role_id = 110,
			role_name = "XXX3",
			shipping_id = 1,
			reward = [],
			back_list = [],
			time = os.time(),
		},
	}
}
this.BrightTestData = BrightTestData
*///



window["BrightSeaModel"] = BrightSeaModel