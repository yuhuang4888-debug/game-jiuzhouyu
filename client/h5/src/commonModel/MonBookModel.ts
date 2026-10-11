import { RedDotController } from "./../common/RedDotController"
import { RedKey } from "./../common/RedDotDefine"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"

export const MonBookCheckColor = [
	{ quality: 4, name: "橙色及以下", key: "orange" },
	{ quality: 5, name: "红色", key: "red" },
	{ quality: 6, name: "粉色", key: "pink" }
]
window["MonBookCheckColor"] = MonBookCheckColor

export class MonBookModel extends EventDispatcher {
	ClearColorList
	ClearData
	ClearDecomposeList
	GetAllPropertyList
	GetBookComposeList
	GetBookDataByType
	GetBookGroupLevel
	GetBookGroupMaxLevel
	GetBookLevel
	GetBookMaxLevel
	GetDecomposeHarvest
	GetDecomposeList
	GetDecomposeMonBookList
	GetLevelColor
	GetMaxActivatedQuality
	GetMonBookList
	GetMonBookTypeById
	GetTabNameList
	HasGroup
	IsBookUnLock
	IsGroupReachMaxLevel
	IsShowCurrTabDot
	IsShowGroupDot
	IsShowIconDot
	IsShowMonGroupRedDot
	IsShowMonRedDot
	IsShowSingleGroupDot
	LoadMaxLevelConfig
	SendMsgWhenGameStart
	SetBookDataList
	SetCanDecomposeListByQuality
	SetDecomposeMonBookList
	SetMonBookActivatedList
	SetMonGroupRedDot
	SetMonRedDot
	UpdateBookDataList
	UpdateDecomposeItemList
	UpdateGroupDataList
	UpdateTabDot
	MonBookItemRedDot
	can_decompose_list
	decompose_dir
	decompose_list
	is_first_create
	monGroupRedDotBit
	monRedDotBit
	open
	orange_can_decompose_list
	pink_can_decompose_list
	red_can_decompose_list
	book_data_list_
	un_act_book_next_power_map

	SetActBookPower
	GetActBookPower

	public static SCMD_REQUEST = "MonBookModel.SCMD_REQUEST";
	public static REFRESH_BOOK_INFO = "MonBookModel.REFRESH_BOOK_INFO";
	public static REFRESH_TAB_DOT = "MonBookModel.REFRESH_TAB_DOT";
	public static LEVEL_SUCCESS = "MonBookModel.LEVEL_SUCCESS";
	public static PLAY_EFFECT = "MonBookModel.PLAY_EFFECT";
	public static PLAY_STAR_EFFECT = "MonBookModel.PLAY_STAR_EFFECT";
	public static UPDATE_DECOMPOSE_VIEW = "UPDATE_DECOMPOSE_VIEW";
	public static UPDATE_MONBOOK_MESSAGE = "UPDATE_MONBOOK_MESSAGE";
	public static SELECT_ITEM = "SELECT_ITEM";
	public static REFUSE_TAB_RED = "REFUSE_TAB_RED"
	public static REFUSE_DECOMPOSE_CHECK = "REFUSE_DECOMPOSE_CHECK"
	public static CLICK_DECOMPOSE_CHECK = "CLICK_DECOMPOSE_CHECK"
	public static PLAY_ITEM_ANIMATION = "PLAY_ITEM_ANIMATION"//播放动画
	public static REFRESH_NEXT_POWER = "REFRESH_NEXT_POWER"


	InitConfig
	GetMonPicCfg
	GetMonPicLvCfg
	GetMonPicTypeCfg
	GetMonPicGroupCfg
	static Instance: any
	now_select_group_type
	public constructor() {
		super()

		this.monRedDotBit = 0;
		this.monGroupRedDotBit = 0;
		this.can_decompose_list = [];
		this.red_can_decompose_list = [];
		this.orange_can_decompose_list = [];
		this.pink_can_decompose_list = [];
		this.decompose_list = [];
		this.decompose_dir = [];
		this.open = false;
		this.now_select_group_type = 0
		this.book_data_list_ = []
		this.un_act_book_next_power_map = {};
		
		this.is_first_create = true;
		let local_MonBookModel = MonBookModel
		let local_Config = Config
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Erlang = ErlangParser.GetInstance()
		let local_Number = Number
		let goods_model = GoodsModel.GetInstance()
		let res_mgr = ResManager.GetInstance()
		let max_lv_list_ = []
		let group_max_list_ = []
		let group_type_list_ = []
		let is_load_config_ = false
		let activated_list_ = []
		let mon_red_dir = []
		let mon_gp_red_dir = []
		// let config_mon_pic_type
		let config_mon_pic_lv
		let config_mon_pic
		// let config_mon_pic_group
		let config_goods_decompose
		this.InitConfig = () => {
			config_goods_decompose = Config.PRELOAD_SERVER_CONFIG.config_goods_decompose
			config_mon_pic_lv = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_lv
			config_mon_pic = Config.PRELOAD_SERVER_CONFIG.config_mon_pic
		}

		// this.GetMonPicTypeCfg = ()=>{
		// 	return config_mon_pic_type
		// }

		this.GetMonPicCfg = () => {
			return config_mon_pic
		}
		this.GetMonPicLvCfg = () => {
			return config_mon_pic_lv
		}
		// this.GetMonPicGroupCfg = ()=>{
		// 	return config_mon_pic_group
		// }

		this.SetBookDataList = (vo?) => {
			vo.pic_dict = []
			for (let _tmpi in vo.pic_list) {
				var data = vo.pic_list[_tmpi]
				vo.pic_dict[data.pic_id] = data
			}
			vo.group_dict = []
			for (let _tmpi in vo.group_list) {
				var data = vo.group_list[_tmpi]
				vo.group_dict[data.group_id] = data
			}
			this.book_data_list_[vo.type] = vo
			this.UpdateTabDot()
			this.Fire(local_MonBookModel.REFRESH_BOOK_INFO, vo.type)
		}

		this.UpdateTabDot = () => {
			let mon_open = CommonManager.GetInstance().CheckFuncOpenState("MonBookMainView", true)
			if (mon_open) {
				let config_mon_pic_type = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_type
				let config_mon_pic_group = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_group

				if (!config_mon_pic_group || !config_mon_pic_type) {
					return
				}
				for (let key in config_mon_pic_type) {
					let data = config_mon_pic_type[key]
					this.SetMonRedDot(data.type, this.IsShowCurrTabDot(data.type))
					this.SetMonGroupRedDot(data.type, this.IsShowGroupDot(data.type, config_mon_pic_group))
				}
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
				// local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.MonBook, this.IsShowIconDot())
			}
		}

		this.IsShowCurrTabDot = (type?, back_type_id?) => {
			let max_lv = null
			let curr_lv = null
			let type_id = null
			let count = null
			let own = null
			let list = this.GetMonBookList(type)
			for (let key in list) {
				let data = list[key]
				if (this.IsBookUnLock(data.type, data.id)) {
					max_lv = this.GetBookMaxLevel(data.id)
					curr_lv = this.GetBookLevel(data.type, data.id)
					if (curr_lv < max_lv) {
						let cfg = config_mon_pic_lv[data.id + "@" + (curr_lv + 1)]
						if (cfg) {
							let list2 = JSON.parse(cfg.cost)
							if (list2 && list2.length > 0) {
								type_id = local_Number(list2[0][1])
								count = local_Number(list2[0][2])
								own = goods_model.GetTypeGoodsNum(type_id)
								if (own >= count) {
									if (back_type_id) {
										return type_id
									} else {
										return true
									}
								}
							}
						}
					}
				}
			}
			return false
		}

		this.SetMonRedDot = (type?, value?) => {
			let newValue = this.monRedDotBit
			if (value) {
				newValue = this.monRedDotBit | 1 << type
			}
			else {
				newValue = this.monRedDotBit & ~(1 << type)
			}
			this.monRedDotBit = newValue
			RedDotController.ins.up(RedKey.MONBOOK, this.monRedDotBit + this.monGroupRedDotBit > 0 ? 1 : 0)
			this.Fire(local_MonBookModel.REFRESH_TAB_DOT, 0, type)
		}

		this.SetMonGroupRedDot = (type?, value?) => {
			// let newValue = 0
			// mon_gp_red_dir[type] = value
			// for (let k in mon_gp_red_dir) {
			// 	var v = mon_gp_red_dir[k]
			// 	if (v == true) {
			// 		newValue = 1
			// 		break
			// 	}
			// }
			// this.monGroupRedDotBit = newValue
			let newValue = this.monGroupRedDotBit
			if (value) {
				newValue = this.monGroupRedDotBit | 1 << type
			}
			else {
				newValue = this.monGroupRedDotBit & ~(1 << type)
			}
			this.monGroupRedDotBit = newValue
			RedDotController.ins.up(RedKey.MONBOOK, this.monRedDotBit + this.monGroupRedDotBit > 0 ? 1 : 0)
			this.Fire(local_MonBookModel.REFRESH_TAB_DOT, 1, type)
		}

		this.GetMonBookList = (type?, is_sort?) => {
			let list = []
			for (let key in config_mon_pic) {
				let data = config_mon_pic[key]
				if (data.type == type) {
					list.push(data)
				}
			}
			if (is_sort) {
				let sort_func = (vo1?, vo2?) => {
					return vo1.id - vo2.id
				}
				list.sort(sort_func)
			}
			return list
		}

		this.IsBookUnLock = (type?, book_id?) => {
			let cfg = config_mon_pic[book_id]
			if (!cfg) {
				return false
			}
			let playerLv = RoleManager.GetInstance().GetMainRoleVo().level
			if (playerLv < cfg.open_lv) {
				return [false, 1, cfg.open_lv]
			}
			let list = JSON.parse(cfg.open_con)
			if (list.length == 0) {
				return true
			} else {
				let need_id = local_Number(list[0][0])
				let need_lv = local_Number(list[0][1])
				if (!this.book_data_list_[type]) {
					return [false, 2, need_id, need_lv]
				}
				// [ts2lua]book_data_list_下标访问可能不正确
				let pic_dict = this.book_data_list_[type].pic_dict
				// [ts2lua]pic_dict下标访问可能不正确
				let vo = pic_dict[need_id]
				if (vo && vo.lv >= need_lv) {
					return true
				}
				return [false, 2, need_id, need_lv]
			}
		}

		this.GetBookMaxLevel = (book_id?) => {
			// [ts2lua]max_lv_list_下标访问可能不正确
			return max_lv_list_[book_id] || 30
		}

		this.GetBookGroupLevel = (type?, group_id?) => {
			// [ts2lua]book_data_list_下标访问可能不正确
			if (!this.book_data_list_[type]) {
				return 0
			}
			// [ts2lua]book_data_list_下标访问可能不正确
			let group_dict = this.book_data_list_[type].group_dict
			// [ts2lua]group_dict下标访问可能不正确
			if (group_dict[group_id]) {
				// [ts2lua]group_dict下标访问可能不正确
				return group_dict[group_id].lv
			}
			return 0
		}

		this.GetBookLevel = (type?, book_id?) => {
			// [ts2lua]book_data_list_下标访问可能不正确
			if (!this.book_data_list_[type]) {
				return 0
			}
			// [ts2lua]book_data_list_下标访问可能不正确
			let pic_dict = this.book_data_list_[type].pic_dict
			// [ts2lua]pic_dict下标访问可能不正确
			if (pic_dict[book_id]) {
				// [ts2lua]pic_dict下标访问可能不正确
				return pic_dict[book_id].lv
			}
			return 0
		}

		this.IsShowGroupDot = (type?, config_mon_pic_group?) => {
			if (!this.HasGroup(type)) {
				return false
			}
			let dict = []
			if (config_mon_pic_group) {
				for (let key in config_mon_pic_group) {
					let data = config_mon_pic_group[key]
					if ((!dict[data.id] && data.type == type) && this.IsShowSingleGroupDot(type, data.id, config_mon_pic_group)) {
						return true
					} else {
						dict[data.id] = true
					}
				}
			}
			return false
		}

		this.HasGroup = (type?) => {
			return group_type_list_[type]
		}

		this.IsShowSingleGroupDot = (type?, group_id?, config_mon_pic_group?) => {
			let curr_lv = this.GetBookGroupLevel(type, group_id)
			let max_lv = this.GetBookGroupMaxLevel(group_id)
			if (curr_lv >= max_lv) {
				return false
			}
			let cfg = config_mon_pic_group[group_id + "@" + (curr_lv + 1)]
			if (!cfg) {
				return false
			}
			let list = JSON.parse(cfg.need_list)
			if (list && list.length > 0) {
				let count = 0
				let book_id = null
				let need_lv = null
				for (let _tmpi in list) {
					var data = list[_tmpi]
					book_id = local_Number(data[0])
					need_lv = local_Number(data[1])
					let book_cfg = config_mon_pic[book_id]
					if ((book_id && need_lv) && book_cfg) {
						let book_lv = this.GetBookLevel(book_cfg.type, book_id)
						if (book_lv >= need_lv) {
							count = count + 1
						} else {
							break
						}
					}
				}
				if (count >= list.length) {
					return true
				}
			}
			return false
		}

		this.GetBookGroupMaxLevel = (group_id?) => {
			return group_max_list_[group_id] || 30
		}

		this.UpdateBookDataList = (vo?) => {
			let pic_id = vo.pic_id
			let level = vo.lv
			let config = config_mon_pic[pic_id]
			if (!config) {
				return
			}
			let data = this.book_data_list_[config.type]
			if (!data) {
				return
			}
			let find = false
			for (let _tmpi in data.pic_list) {
				var pic_data = data.pic_list[_tmpi]
				if (pic_data.pic_id == pic_id) {
					pic_data.lv = level
					pic_data.cur_power = vo.cur_power
					pic_data.next_power = vo.next_power
					find = true
				}
			}
			if (!find) {
				data.pic_list.push(vo)
			}
			data.pic_dict = []
			for (let _tmpi in data.pic_list) {
				var pic_data = data.pic_list[_tmpi]
				data.pic_dict[pic_data.pic_id] = pic_data
			}
			this.UpdateTabDot()
			this.Fire(local_MonBookModel.LEVEL_SUCCESS, config.type, vo)
		}

		this.UpdateGroupDataList = (vo?, config_mon_pic_group?) => {
			let group_id = vo.group_id
			let level = vo.lv
			let config = config_mon_pic_group[group_id + "@" + level]
			if (!config) {
				return
			}
			let data = this.book_data_list_[config.type]
			if (!data) {
				return
			}
			let find = false
			for (let _tmpi in data.group_list) {
				var pic_data = data.group_list[_tmpi]
				if (pic_data.group_id == group_id) {
					pic_data.lv = level
					find = true
				}
			}
			if (!find) {
				data.group_list.push(vo)
			}
			data.group_dict = []
			for (let _tmpi in data.group_list) {
				var group_data = data.group_list[_tmpi]
				data.group_dict[group_data.group_id] = group_data
			}
			this.UpdateTabDot()
			this.Fire(local_MonBookModel.LEVEL_SUCCESS, config.type, vo)
		}

		this.ClearData = () => {
			this.book_data_list_ = []
			this.monRedDotBit = 0
		}

		this.LoadMaxLevelConfig = () => {
			if (is_load_config_) {
				return
			}
			let config_mon_pic_group = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_group
			is_load_config_ = true
			max_lv_list_ = []
			for (let key in config_mon_pic_lv) {
				let data = config_mon_pic_lv[key]
				if (!max_lv_list_[data.pic_id] || data.lv > max_lv_list_[data.pic_id]) {
					max_lv_list_[data.pic_id] = data.lv
				}
			}
			group_type_list_ = []
			group_max_list_ = []
			for (let key in config_mon_pic_group) {
				let data = config_mon_pic_group[key]
				if (!group_max_list_[data.id] || data.lv > group_max_list_[data.id]) {
					group_max_list_[data.id] = data.lv
				}
				if (!group_type_list_[data.type]) {
					group_type_list_[data.type] = true
				}
			}
		}

		this.SendMsgWhenGameStart = () => {
			let obj = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_type
			for (let key in obj) {
				let data = obj[key]
				this.Fire(local_MonBookModel.SCMD_REQUEST, 44201, data.type)
			}
		}

		this.GetTabNameList = (config_mon_pic_type) => {
			let list = []
			let cfg = config_mon_pic_type
			if (cfg) {
				for (let _ in cfg) {
					// list.push(cfg[_].name.trim())
					list.push(cfg[_])
				}
			}
			list.sort((a?, b?) => {
				return a.type - b.type
			})
			return list
		}

		this.GetBookComposeList = (type?, is_sort?, config_mon_pic_group?) => {
			if (is_sort == null) {
				is_sort = false
			}
			let list = []
			let dict = []
			let curr_lv = null
			let max_lv = null
			let show_lv = null
			let group_data = null
			if (config_mon_pic_group) {
				for (let key in config_mon_pic_group) {
					let data = config_mon_pic_group[key]
					if (!dict[data.id] && data.type == type) {
						curr_lv = this.GetBookGroupLevel(data.type, data.id)
						max_lv = this.GetBookGroupMaxLevel(data.id)
						show_lv = (curr_lv == 0 && (1) || (curr_lv))
						group_data = config_mon_pic_group[data.id + "@" + show_lv]
						if (group_data) {
							list.push(group_data)
						}
						dict[data.id] = true
					}
				}
			}
			if (is_sort) {
				let reachMax1 = null
				let reachMax2 = null
				let is_show_dot1 = null
				let is_show_dot2 = null
				let sort_func = (a?, b?) => {
					reachMax1 = this.IsGroupReachMaxLevel(a.type, a.id)
					reachMax2 = this.IsGroupReachMaxLevel(b.type, b.id)
					if (!reachMax1 && reachMax2) {
						return 1
					}
					if (reachMax1 && !reachMax2) {
						return -1
					}
					is_show_dot1 = this.IsShowSingleGroupDot(a.type, a.id, config_mon_pic_group)
					is_show_dot2 = this.IsShowSingleGroupDot(b.type, b.id, config_mon_pic_group)
					if (is_show_dot1 && !is_show_dot2) {
						return 1
					}
					if (!is_show_dot1 && is_show_dot2) {
						return -1
					}
					return a.id - b.id
				}

				list.sort(sort_func)
			}
			return list
		}

		this.IsGroupReachMaxLevel = (type?, group_id?) => {
			let curr_lv = this.GetBookGroupLevel(type, group_id)
			let max_lv = this.GetBookGroupMaxLevel(group_id)
			if (curr_lv >= max_lv) {
				return true
			}
			return false
		}

		this.GetLevelColor = (level?) => {
			switch (level) {
				case 0:
					return 0x9d8679
				case 1:
					return 0x739d34
				case 2:
					return 0x4981b7
				case 3:
					return 0x6c47a5
				case 4:
					return 0xb26c31
				case 5:
					return 0xb34141
				case 6:
					return 0xad409f
				case -1:
					return 0x767676
			}
		}

		this.GetBookDataByType = (type?) => {
			return this.book_data_list_[type]
		}

		this.GetAllPropertyList = (config_mon_pic_group, config_mon_pic_type) => {
			let dict = []
			let cfg = null
			let list = null
			let prop_id = null
			let prop_value = null
			for (let key in config_mon_pic_type) {
				let data = config_mon_pic_type[key]
				let book_list = this.GetBookDataByType(data.type)
				if (!book_list) {
					break
				}
				let pic_list = book_list.pic_list
				let group_list = book_list.group_list
				for (let key in pic_list) {
					let data = pic_list[key]
					cfg = config_mon_pic_lv[data.pic_id + "@" + data.lv]
					if (cfg) {
						list = JSON.parse(cfg.attr)
						for (let key1 in list) {
							let data1 = list[key1]
							prop_id = local_Number(data1[0])
							prop_value = local_Number(data1[1])
							if (dict[prop_id]) {
								dict[prop_id] = dict[prop_id] + prop_value
							} else {
								dict[prop_id] = prop_value
							}
						}
					}
				}
				if (config_mon_pic_group) {
					for (let key in group_list) {
						let data = group_list[key]
						cfg = config_mon_pic_group[data.group_id + "@" + data.lv]
						if (cfg) {
							list = JSON.parse(cfg.attr)
							for (let key1 in list) {
								let data1 = list[key1]
								prop_id = local_Number(data1[0])
								prop_value = local_Number(data1[1])
								if (dict[prop_id]) {
									dict[prop_id] = dict[prop_id] + prop_value
								} else {
									dict[prop_id] = prop_value
								}
							}
						}
					}
				}
			}
			list = []
			for (let key in dict) {
				let data = dict[key]
				list.push([key, data])
			}
			return list
		}

		this.IsShowIconDot = () => {
			let is_show = this.monRedDotBit + this.monGroupRedDotBit > 0 || this.can_decompose_list?.length > 0
			RedDotController.ins.up(RedKey.MONBOOK, is_show ? 1 : 0)
			return is_show
		}

		this.IsShowMonRedDot = () => {
			return this.monRedDotBit > 0
		}

		/**这是共鸣的红点 */
		this.IsShowMonGroupRedDot = () => {
			return this.monGroupRedDotBit > 0
		}

		this.SetMonBookActivatedList = (list?) => {
			activated_list_ = list
		}

		this.SetDecomposeMonBookList = () => {
			let bag_mon_book_list = []
			bag_mon_book_list = goods_model.GetMonBookList()
			if (bag_mon_book_list && activated_list_ && bag_mon_book_list.length > 0 && activated_list_.length > 0) {
				let i = 0
				do {
					let j = 0
					do {
						if (bag_mon_book_list[i].type_id == activated_list_[j].pic_id) {
							this.can_decompose_list.push(bag_mon_book_list[i])
							break
						}
						j = j + 1
					} while ((j < activated_list_.length))
					i = i + 1
				} while ((i < bag_mon_book_list.length))

				let sort_fun = (a, b) => {
					return a.color < b.color
				}
				table.sort(this.can_decompose_list, sort_fun)
				let a = 1
			}
		}

		this.GetMaxActivatedQuality = () => {
			let max_quality = 4
			if (activated_list_ && activated_list_.length > 0) {
				let i = 0
				do {
					let quality = this.GetMonBookTypeById(activated_list_[i].pic_id)
					if (max_quality < quality) {
						max_quality = quality
					}
					i = i + 1
				} while ((i < activated_list_.length))
			}

			return max_quality
		}

		this.GetMonBookTypeById = (id?) => {
			let type
			let str = id.toString()
			let type_str = str.substring(5, 6)
			type = local_Number(type_str)
			return type
		}

		this.SetCanDecomposeListByQuality = () => {
			if (this.can_decompose_list && this.can_decompose_list.length > 0) {
				let i = 0
				do {
					let goods_vo = this.can_decompose_list[i]
					let goods_id = goods_vo.type_id
					let quality = this.GetMonBookTypeById(goods_id)
					if (quality <= 4) {
						this.orange_can_decompose_list.push(goods_vo)
					} else if (quality == 5) {
						this.red_can_decompose_list.push(goods_vo)
					} else {
						this.pink_can_decompose_list.push(goods_vo)
					}
					i = i + 1
				} while ((i < this.can_decompose_list.length))
			}

		}

		this.GetDecomposeMonBookList = () => {
			return this.can_decompose_list
		}

		this.ClearDecomposeList = () => {
			if (this.decompose_list && this.decompose_list.length > 0) {
				let i = 0
				do {
					this.decompose_list[i] = null
					i = i + 1
				} while ((i < this.decompose_list.length))
				this.decompose_list = []
			}
		}

		this.ClearColorList = () => {
			if (this.orange_can_decompose_list && this.orange_can_decompose_list.length > 0) {
				let i = 0
				do {
					this.orange_can_decompose_list[i] = null
					i = i + 1
				} while ((i < this.orange_can_decompose_list.length))
				this.orange_can_decompose_list = []
			}
			if (this.red_can_decompose_list && this.red_can_decompose_list.length > 0) {
				let i = 0
				do {
					this.red_can_decompose_list[i] = null
					i = i + 1
				} while ((i < this.red_can_decompose_list.length))
				this.red_can_decompose_list = []
			}
			if (this.pink_can_decompose_list && this.pink_can_decompose_list.length > 0) {
				let i = 0
				do {
					this.pink_can_decompose_list[i] = null
					i = i + 1
				} while ((i < this.pink_can_decompose_list.length))
				this.pink_can_decompose_list = []
			}
			if (this.can_decompose_list && this.can_decompose_list.length > 0) {
				let i = 0
				do {
					this.can_decompose_list[i] = null
					i = i + 1
				} while ((i < this.can_decompose_list.length))
				this.can_decompose_list = []
			}
			if (this.decompose_dir) {
				for (let key in this.decompose_dir) {
					this.decompose_dir[key] = null
				}
				this.decompose_dir = []
			}
		}

		this.GetDecomposeList = () => {
			let list = []
			for (let id in this.decompose_dir) {
				let goods_vo = this.decompose_dir[id]
				list.push({ "goods_id": goods_vo.goods_id, "goods_num": goods_vo.goods_num })
			}
			return list
		}

		this.GetDecomposeHarvest = (harvest_list?) => {
			let list = harvest_list
			for (let goods_id in this.decompose_dir) {
				let goods_vo = this.decompose_dir[goods_id]
				let value = Config.GetConfigVo("config_goods_decompose", goods_id, false, config_goods_decompose)
				if (value.goods_id == goods_id) {
					let regular_mat = JSON.parse(value.regular_mat)
					for (let _tmpi in regular_mat) {
						var v = regular_mat[_tmpi]
						let id = v[1]
						let num = v[2] * goods_vo.goods_num
						let i = 0
						do {
							if (Number(id) == list[i].type_id) {
								list[i].goods_num = list[i].goods_num + num
							}
							i = i + 1
						} while ((i < list.length))
					}
				}

			}
			return list
		}

		this.UpdateDecomposeItemList = () => {
			this.SetDecomposeMonBookList()
			this.SetCanDecomposeListByQuality()
		}

		//图鉴item红点，是否可激活，可升级
		this.MonBookItemRedDot = (_type, id) => {
			let bool = false
			if (id != undefined && _type != undefined) {
				let max_lv = this.GetBookMaxLevel(id)
				let curr_lv = this.GetBookLevel(_type, id)
				let real_lv = curr_lv + 1
				if (real_lv >= max_lv)
					real_lv = max_lv
				let mon_pic_lv = this.GetMonPicLvCfg()
				let config = mon_pic_lv ? mon_pic_lv[id + "@" + real_lv] : undefined
				if (config) {
					let list = JSON.parse(config.cost)
					if (list && list.length) {
						let type_id = Number(list[0][1])
						let count = Number(list[0][2])
						let own_count = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
						if (curr_lv >= max_lv) {
							bool = false
						}
						else {
							if ((own_count / count) >= 1) {
								bool = true
							}
							else
								bool = false
						}
					}
				}
			}
			return bool
		}

		this.SetActBookPower = (pic_id, next_power) => {
			this.un_act_book_next_power_map[pic_id] = next_power
		}

		this.GetActBookPower = (pic_id) => {
			return this.un_act_book_next_power_map && this.un_act_book_next_power_map[pic_id]
		}
	}




	/**获取升级或者激活配置 */
	public GetCosts(id,real_lv) {
		let mon_pic_lv = this.GetMonPicLvCfg()
		let config = mon_pic_lv ? mon_pic_lv[id + "@" + real_lv] : undefined
		if (!config)
			return

		let list = JSON.parse(config.cost)
		let goods_id=0
		let cost_count = 0
		if (list && list.length) {
			let type_id = Number(list[0][1])
			let count = Number(list[0][2])
			goods_id = type_id
			cost_count= count
		}
		return [goods_id,cost_count]
	}

	public GetAllBookPower(): number {
		let power: number = 0;
		for (const key in this.book_data_list_) {
			let data = this.book_data_list_[key]
			power = power < data.pic_combat ? data.pic_combat : power;
		}
		return power;
	}

	public static GetInstance(): MonBookModel {
		if (!MonBookModel.Instance) {
			MonBookModel.Instance = new MonBookModel()
		}
		return MonBookModel.Instance
	}
}


window["MonBookModel"] = MonBookModel