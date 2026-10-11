import { CookieWrapper } from "../common/CookieWrapper"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil"
import { Split } from "../util/Util"
import { ActivityIconManager } from "./ActivityIconManager"

export class LimitLevelShopModel extends EventDispatcher {
	CheckGrade
	GetGiftCond
	GetGiftData
	GetRedState
	GetTypeData
	GetValueByErlang
	IconType2Type
	ReSetModel
	RefreshRedDot
	RefreshRedState
	RefreshState
	RequireGiftData
	SetGiftCond
	SetGiftData
	SetGiftOpenTimes
	GetGiftOpenTimes
	GetOldGiftBuyState
	old_list
	times_dic
	static Instance
	public static OPEN_VIEW = "LimitLevelShopModel.OPEN_VIEW"
	public static SCMD_REQUEST = "LimitLevelShopModel.SCMD_REQUEST"
	public static BUY_SUCCESS = "LimitLevelShopModel.BUY_SUCCESS"

	public static ModuleId = 612
	is_first = true
	// public static Type2Icon = [
	// 	"61201",
	// 	"61202",
	// 	"61203",
	// 	[63] = "61204",
	// 	[66] = "61205"
	// ]

	public constructor() {
		super()

		if (LimitLevelShopModel.Instance) {
			return
		}
		LimitLevelShopModel.Instance = this

		let erlang_parse = ErlangParser.GetInstance()
		let local_Number = Number
		let local_GlobalEventSystem = GlobalEventSystem
		let refresh_icon_red_event = EventName.REFRESH_ACTIVITY_ICON_RED_DOT
		let cache_61200_data_ = null
		let icon_dic_ = []
		let gift_data_ = []
		let gift_cond_ = []
		let last_grade_ = null
		let red_state_dic_ = null
		this.RefreshState = (scmd?) => {
			let delete_list = []
			let icon_mgr = ActivityIconManager.GetInstance()
			let dic = []

			for (let _tmpi in scmd.list) {
				var vo = scmd.list[_tmpi]
				let key = vo.type + "@" + vo.subtype
				dic[key] = vo

				if (!vo.act_condition) {
					return
				}
				this.SetGiftCond(vo)
				let cond = this.GetGiftCond(vo.type, vo.subtype)
				if (!cond) {
					return
				}
				let icon_type = null
				if (cond.pic) {
					icon_type = cond.pic
					icon_dic_[key] = icon_type
				}
				let icon_info = icon_mgr.getIconInfo(icon_type)
				if (!icon_info) {
					icon_mgr.addIcon(icon_type, vo.end_time)
				}
				this.RefreshRedState(vo)
				if (vo.type == 66) {
					let different = this.CheckGrade(last_grade_, vo.grade_state[0].grade)
					if (different && vo.grade_state.length > 0) {
						icon_mgr.addIcon(icon_type, vo.end_time)
						this.RequireGiftData(vo.type, vo.subtype, vo.grade_state[0].grade)
						this.RefreshRedDot(vo.type, vo.subtype, true)
					}
				} else {
					this.RequireGiftData(vo.type, vo.subtype)
				}
			}

			if (cache_61200_data_) {
				for (let _tmpi in cache_61200_data_) {
					var vo = cache_61200_data_[_tmpi]
					if (!dic[vo.type + "@" + vo.subtype]) {
						table.insert(delete_list, vo)
					}
				}
			}

			if (delete_list.length > 0) {
				for (let _tmpi in delete_list) {
					var vo = delete_list[_tmpi]
					let icon_type = icon_dic_[vo.type + "@" + vo.subtype]
					let icon_info = icon_mgr.getIconInfo(icon_type)
					if (icon_info) {
						icon_mgr.deleteIcon(icon_type)
					}
				}
			}
			cache_61200_data_ = scmd.list
		}

		this.CheckGrade = (last_grade?, now_grade?) => {
			let bool = true
			if (last_grade) {
				bool = last_grade == now_grade && false || true
			}
			last_grade_ = now_grade
			return bool
		}

		this.RequireGiftData = (type?, subtype?, grade?) => {
			let the_grade = grade && grade || 0
			this.Fire(LimitLevelShopModel.SCMD_REQUEST, 61203, type, subtype, the_grade)
		}

		this.SetGiftCond = (data?) => {
			if (data && data.act_condition != "[]" && typeof (data.act_condition) == "string") {
				let cond = erlang_parse.Parse(data.act_condition)
				gift_cond_[data.type] = gift_cond_[data.type] || {}
				gift_cond_[data.type][data.subtype] = gift_cond_[data.type][data.subtype] || {}
				for (let i in cond) {

					let c = cond[i]
					gift_cond_[data.type][data.subtype][c[0]] = c[1]
				}
			}
		}

		this.GetGiftCond = (type?, subtype?) => {
			if (gift_cond_[type] && gift_cond_[type][subtype]) {
				return gift_cond_[type][subtype]
			}
			return null
		}

		this.SetGiftData = (data?) => {
			if (!data) {
				return
			}
			gift_data_[data.type] = gift_data_[data.type] || {}
			gift_data_[data.type][data.subtype] = data
		}

		this.GetGiftData = (type?, subtype?, grade?) => {
			let data = gift_data_[type]
			let subtype_data = data && data[subtype]
			if (grade) {
				let grade_list = subtype_data.grade_cfg
				for (let _tmpi in grade_list) {
					var vo = grade_list[_tmpi]
					if (vo.grade == grade) {
						return vo
					}
				}
			}
			return subtype_data
		}

		this.GetTypeData = (type?) => {
			if (cache_61200_data_) {
				for (let _tmpi in cache_61200_data_) {
					var vo = cache_61200_data_[_tmpi]
					if (vo.type == type) {
						return vo
					}
				}
			}
		}

		this.IconType2Type = (icon_type?) => {
			icon_type = String(icon_type)
			for (let key in icon_dic_) {

				let value = icon_dic_[key]
				if (value == icon_type) {
					let list = Split(key, "@")
					let type = list[0]
					return [local_Number(type), local_Number(list[1])]
				}
			}
		}

		this.RefreshRedDot = (type?, subtype?, state?) => {
			if (!red_state_dic_) {
				red_state_dic_ = []
			}
			let key = type + "@" + subtype
			red_state_dic_[key] = state
			let icon_type = local_Number(icon_dic_[key])
			local_GlobalEventSystem.Fire(refresh_icon_red_event, icon_type)
		}

		this.RefreshRedState = (data?) => {
			if (!red_state_dic_) {
				red_state_dic_ = []
			}
			let bool = false
			if (this.is_first) {
				bool = true
				this.is_first = false
			}
			// let last_time_data = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LIMIT_LEVEL_SHOP_RED)
			// let last_time = null
			let key = data.type + "@" + data.subtype
			// if (last_time_data) {
			// 	last_time = local_Number(last_time_data[key])
			// }

			// if (!last_time || TimeUtil.getServerTime() > local_Number(last_time)) {
			// 	bool = true
			// }
			if (red_state_dic_[key] != bool) {
				let is_finish = true
				if (data.type == 75) {
					if (data.grade_state) {
						for (let item of data.grade_state) {
							if (item.state != 1) {
								is_finish = false
								break
							}
						}
					}
				}
				red_state_dic_[key] = is_finish ? !is_finish : bool
				let icon_type = icon_dic_[key]
				local_GlobalEventSystem.Fire(refresh_icon_red_event, icon_type)
			}
		}

		this.GetRedState = (type?, subtype?) => {
			let key = type + "@" + subtype
			return red_state_dic_ && red_state_dic_[key]
		}

		this.GetValueByErlang = (conditions?, key?) => {
			if (conditions) {
				let cond = erlang_parse.Parse(conditions)
				for (let i in cond) {

					let c = cond[i]
					if (c[0] == key) {
						return c
					}
				}
			}
		}


		this.ReSetModel = () => {
			cache_61200_data_ = null
			icon_dic_ = []
			gift_data_ = []
			gift_cond_ = []
			red_state_dic_ = null
			last_grade_ = null
		}

		this.SetGiftOpenTimes =(scmd) => {
			this.times_dic = {}
			this.old_list = {}
			for(let key in scmd.list){
				let vo = scmd.list[key]
				this.times_dic[vo.type] = this.times_dic[vo.type] || {}
				this.old_list[vo.type] = this.old_list[vo.type] || {}
				this.times_dic[vo.type][vo.subtype] = vo.open_times
				this.old_list[vo.type][vo.subtype] = vo.old_grade_state
			}
		}

		this.GetGiftOpenTimes = (type?, subtype?)=>{
			let open_times = this.times_dic[type][subtype]
			return open_times
		}

		this.GetOldGiftBuyState= (type?, subtype?)=>{
			let old_grade_state = this.old_list[type][subtype]
			return old_grade_state
		}
	}

	public static GetInstance() {

		if (!LimitLevelShopModel.Instance) {
			LimitLevelShopModel.Instance = new LimitLevelShopModel()
		}
		return LimitLevelShopModel.Instance
	}
}
window["LimitLevelShopModel"] = LimitLevelShopModel
