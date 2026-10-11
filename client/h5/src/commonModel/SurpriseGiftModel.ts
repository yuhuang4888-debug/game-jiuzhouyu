import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { ActivityIconManager } from "./ActivityIconManager"
import { CustomActivityModel } from "./CustomActivityModel"
import { RoleManager } from "./RoleManager"
import { Config } from "../common/Config"

export class SurpriseGiftModel extends EventDispatcher {
	CheckFinshAllDraw
	CheckFreeRed
	CheckGradeRed
	CheckOneGiftRedById
	CheckRed
	CheckReturnAll
	CheckReturnRed
	GetAllGrade
	GetViewInfo
	InitDrawCfg
	LoadConfig
	RefRedNum
	SetGradeRed
	SetViewInfo
	UpdataViewInfo
	getCfgDrawByTurn
	getCfgGift
	getCfgGiftKvByValue
	getCfgGiftKvCfgByValue
	getDrawList
	getOpenStatus
	public static SCMD_REQUEST = "SCMD_REQUEST";
	public static OPEN_VIEW = "OPEN_VIEW";
	public static UPDATA_VIEW = "UPDATA_VIEW";
	public static BUY_SUCCESS = "BUY_SUCCESS";
	public static DRAW_SUCCESS = "DRAW_SUCCESS";
	public static GET_SUCCESS = "GET_SUCCESS";
	public static SELECT_VIEW = "SELECT_VIEW";
	public static REF_TAB_RED = "REF_TAB_RED";
	static Instance
	public constructor() {
		super()



		let local_Message = Message
		let config_gift_ = null
		let config_gift_draw_ = null
		let config_gift_kv_ = null
		let view_info_ = null
		let red_num_ = 0
		let free_num_ = 0
		let draw_cfg_ = []
		let draw_list_ = []
		let is_day_first_ = false
		let grade_red_dic_ = []

		this.LoadConfig = () => {
			let game_start = () => {
				//model:LoadConfig()
				if (config_gift_ && config_gift_draw_ && config_gift_kv_) {
					if (this.getOpenStatus()) {
						this.Fire(SurpriseGiftModel.SCMD_REQUEST, 49000)
						ActivityIconManager.GetInstance().addIcon(490)
						this.InitDrawCfg()
					}
				}
			}
			if (config_gift_ == null) {
				config_gift_ = Config.PRELOAD_SERVER_CONFIG.config_surprise_gift
			}
			if (config_gift_draw_ == null) {
				config_gift_draw_ = Config.PRELOAD_SERVER_CONFIG.config_surprise_gift_draw
			}
			if (config_gift_kv_ == null) {
				config_gift_kv_ = Config.PRELOAD_SERVER_CONFIG.config_surprise_gift_kv
			}
			game_start()
		}

		this.InitDrawCfg = () => {
			for (let _ in config_gift_draw_) {
				var vo = config_gift_draw_[_]
				draw_cfg_[vo.turn_id] = draw_cfg_[vo.turn_id] || {}
				draw_cfg_[vo.turn_id][vo.gift_id] = vo
			}
			if (!draw_list_ || Util.TableSize(draw_list_) <= 0) {
				for (let i in draw_cfg_) {

					table.insert(draw_list_, { "turn_id": i })
				}
			}

		}
		//this.LoadConfig()
		this.getOpenStatus = (is_alert?) => {
			let need_vip = this.getCfgGiftKvByValue(1)
			let role = RoleManager.GetInstance().mainRoleInfo
			if (need_vip >= 0 && role.vip_flag >= need_vip) {
				let need_lv = this.getCfgGiftKvByValue(3)
				if (need_lv >= 0 && role.level >= need_lv) {
					let need_day = this.getCfgGiftKvByValue(2)
					let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
					if (need_day >= 0 && openDay >= need_day) {
						return true
					} else if (openDay < need_day && is_alert) {
						local_Message.show("开服" + need_lv + "天开放此活动")
						return false
					}
				} else if (role.level < need_lv && is_alert) {
					// if (PlatformManager.GetInstance().IsEyouThPlatform()) {
					// 	local_Message.show("Lv." + need_lv + "เปิดอีเวนต์นี้")
					// } else {
					local_Message.show(need_lv + "级开放此活动")
					//}
					return false
				}
			} else if (role.vip_flag < need_vip && is_alert) {
				local_Message.show("VIP" + need_vip + "开放此活动")
				return false
			}
			if (view_info_) {
				let bool = this.CheckFinshAllDraw(view_info_) && this.CheckReturnAll(view_info_)
				if (!bool) {
					ActivityIconManager.GetInstance().deleteIcon(490)
				}
				return bool
			}
			return false
		}

		this.CheckReturnAll = (info?) => {
			if (!info) {
				return true
			}
			let cfgs = this.getCfgGift()
			let first_status = CustomActivityModel.GetInstance().GetDayFirstLoginStatus()
			let is_all = true
			for (let i in cfgs) {

				let cfg = cfgs[i]
				let gift_id = cfg.gift_id
				let gift_list = info.gift_list
				for (let _tmpi in gift_list) {
					var v = gift_list[_tmpi]
					if (v.gift_id == gift_id) {
						if ((cfg && cfg.return_day) && v.back_day < cfg.return_day) {
							is_all = false
							break
						}
					}
				}
			}
			return !is_all
		}

		this.CheckRed = () => {
			if ((free_num_ > 0 || red_num_ > 0) || this.GetAllGrade() > 0) {
				return true
			}
			return false
		}

		this.GetAllGrade = () => {
			let num = 0
			for (let i in grade_red_dic_) {

				num = num + grade_red_dic_[i]
			}
			return num
		}

		this.SetGradeRed = (grade?) => {
			// [ts2lua]grade_red_dic_下标访问可能不正确
			if (grade_red_dic_[grade] && grade_red_dic_[grade] > 0) {
				// [ts2lua]grade_red_dic_下标访问可能不正确
				grade_red_dic_[grade] = 0
			}
			this.Fire(SurpriseGiftModel.REF_TAB_RED)
			let state = this.CheckRed()
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 490, state)
		}

		this.CheckGradeRed = (grade?) => {
			let bool = false
			if (0 == grade) {
				// [ts2lua]grade_red_dic_下标访问可能不正确
				bool = (grade_red_dic_[grade] && grade_red_dic_[grade] > 0) || free_num_ + red_num_ > 0
			} else if (5 == grade) {
				// [ts2lua]grade_red_dic_下标访问可能不正确
				bool = (grade_red_dic_[grade] && grade_red_dic_[grade] > 0) || free_num_ > 0
			} else {
				// [ts2lua]grade_red_dic_下标访问可能不正确
				bool = grade_red_dic_[grade] && grade_red_dic_[grade] > 0
			}
			return bool
		}

		this.CheckFreeRed = () => {
			return free_num_ > 0 || (grade_red_dic_[0] && grade_red_dic_[0] - red_num_ > 0)
		}

		this.CheckReturnRed = () => {
			return red_num_ > 0
		}

		this.RefRedNum = () => {
			let info = this.GetViewInfo()
			let red_num = 0
			free_num_ = 0
			for (let i in grade_red_dic_) {

				grade_red_dic_[i] = 0
			}
			if ((info.add_draw_times > 0 || info.free_draw_times > 0) && info.gift_list.length >= 4) {
				free_num_ = 1
			}
			let cfgs = this.getCfgGift()
			let first_status = CustomActivityModel.GetInstance().GetDayFirstLoginStatus()
			for (let i in cfgs) {

				let cfg = cfgs[i]
				let gift_id = cfg.gift_id
				let gift_list = info.gift_list
				let is_buy = false
				for (let _tmpi in gift_list) {
					var v = gift_list[_tmpi]
					if (v.gift_id == gift_id) {
						is_buy = true
						if (((cfg && cfg.return_day) && v.back_day < cfg.return_day) && v.buy_time - v.back_day > 0) {
							red_num = red_num + 1
						}
						break
					}
				}
				if (first_status) {
					// [ts2lua]grade_red_dic_下标访问可能不正确
					if (!is_buy && grade_red_dic_[gift_id - 1] == null) {
						// [ts2lua]grade_red_dic_下标访问可能不正确
						grade_red_dic_[gift_id - 1] = 1
					}
				}
			}
			red_num_ = red_num
			let all_num = red_num_ + free_num_
			if (all_num && all_num != 0) {
				grade_red_dic_[0] = all_num
			}
			if (!free_num_ && first_status) {
				if (grade_red_dic_[0] == null) {
					grade_red_dic_[0] = 1
				}
				if (grade_red_dic_[5] == null && info.draw_times < Util.TableSize(config_gift_draw_)) {
					grade_red_dic_[5] = 1
				}
			} else if (free_num_ && first_status) {
				if (grade_red_dic_[5] == null) {
					grade_red_dic_[5] = 1
				}
			}
		}

		this.CheckOneGiftRedById = (id?) => {
			let info = this.GetViewInfo()
			if (info) {
				let gift_list = info.gift_list
				for (let i in gift_list) {

					let v = gift_list[i]
					if (v && v.gift_id == id) {
						let cfg = this.getCfgGift(id)
						if (((v.buy_time - v.back_day > 0 && cfg) && cfg.return_day) && v.back_day < cfg.return_day) {
							return true
						}
						return false
					}
				}
			}
			return false
		}

		this.getCfgGift = (id?) => {
			if (id) {
				// [ts2lua]config_gift_下标访问可能不正确
				return config_gift_ && config_gift_[id]
			} else {
				return config_gift_
			}
		}

		this.getCfgDrawByTurn = (turn_id?) => {
			if (turn_id) {
				// [ts2lua]draw_cfg_下标访问可能不正确
				return draw_cfg_[turn_id]
			} else {
				return draw_cfg_
			}
		}

		this.getDrawList = () => {
			return draw_list_
		}

		this.getCfgGiftKvByValue = (value?, name?) => {
			if (value) {
				// [ts2lua]config_gift_kv_下标访问可能不正确
				// [ts2lua]config_gift_kv_下标访问可能不正确
				return (config_gift_kv_ && config_gift_kv_[value]) && Number(config_gift_kv_[value].value)
			} else if (name) {
				for (let i in config_gift_kv_) {

					let v = config_gift_kv_[i]
					if (v && v.name == name) {
						return v.value
					}
				}
			}
		}

		this.getCfgGiftKvCfgByValue = (value?, name?) => {
			if (value) {
				// [ts2lua]config_gift_kv_下标访问可能不正确
				return config_gift_kv_ && config_gift_kv_[value]
			} else if (name) {
				for (let i in config_gift_kv_) {

					let v = config_gift_kv_[i]
					if (v && v.name == name) {
						return v
					}
				}
			}
		}

		this.CheckFinshAllDraw = (scmd?) => {
			let turn_id = scmd.turn_id
			let turn_cfg = this.getCfgDrawByTurn()
			if (!turn_cfg) {
				return false
			}
			let turn_length = Util.TableSize(turn_cfg)
			if (turn_id == turn_length) {
				// [ts2lua]turn_cfg下标访问可能不正确
				let cur_turn = turn_cfg[turn_id]
				if (cur_turn) {
					let len = Util.TableSize(cur_turn)
					if (len == scmd.draw_list.length) {
						return false
					}
				}
			}
			return true
		}

		this.SetViewInfo = (scmd?) => {
			if (!scmd) {
				return
			}
			let bool = this.CheckFinshAllDraw(scmd)
			if (bool && scmd.draw_list.length >= 20) {
				scmd.turn_id = scmd.turn_id + 1
				scmd.draw_list = []
			}
			let left_num = scmd.free_draw_times + scmd.add_draw_times - scmd.draw_times
			let left_free_num = scmd.free_draw_times - scmd.use_free_times
			let left_add_num = left_num - left_free_num
			// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
			scmd.free_draw_times = (bool && (left_free_num) || (0))
			// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
			scmd.add_draw_times = (bool && (left_add_num) || (0))
			view_info_ = scmd
		}

		this.GetViewInfo = () => {
			return view_info_
		}

		this.UpdataViewInfo = (scmd?) => {
			if (scmd.turn_id != null && view_info_) {
				if (view_info_.free_draw_times && view_info_.free_draw_times != 0) {
					view_info_.free_draw_times = view_info_.free_draw_times - 1
				} else if (view_info_.add_draw_times && view_info_.add_draw_times != 0) {
					view_info_.add_draw_times = view_info_.add_draw_times - 1
				}
				table.insert(view_info_.draw_list, { "draw_id": scmd.gift_id })
				view_info_.draw_times = view_info_.draw_times + 1
				if (view_info_.turn_id != scmd.turn_id) {
					view_info_.turn_id = scmd.turn_id
					view_info_.draw_list = []
					table.insert(view_info_.draw_list, { "draw_id": scmd.gift_id })
				} else if (view_info_.draw_list.length >= 20) {
					if (this.CheckFinshAllDraw(view_info_)) {
						view_info_.turn_id = scmd.turn_id + 1
						view_info_.draw_list = []
					} else {
						view_info_.free_draw_times = 0
						view_info_.add_draw_times = 0
					}
				}
				return
			}
			if (scmd.gift_id != null && view_info_) {
				if (view_info_.gift_list) {
					for (let _tmpi in view_info_.gift_list) {
						var v = view_info_.gift_list[_tmpi]
						if (v.gift_id == scmd.gift_id || scmd.gift_id == 0) {
							v.back_day = v.buy_time
						}
					}
				}
			}
		}


	}

	public static GetInstance() {

		if (!SurpriseGiftModel.Instance) {
			SurpriseGiftModel.Instance = new SurpriseGiftModel()
		}
		return SurpriseGiftModel.Instance
	}

}