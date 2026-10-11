import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EquipModel } from "../commonModel/EquipModel"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { TimeUtil } from "../util/TimeUtil"
import { VipModel } from "./VipModel"
import { RoleManager } from "./RoleManager"
//import { VipModel } from "../vip/VipModel"

export const MarketBagType = {
	GOODS : 2,
	GOD : 1
}
export const MarketViewType = {
	LIST : 0,
	CTRL : 1
}
export const MarketEvent = { 
	REQUEST_PROTO:"MarketEvent.REQUEST_PROTO", 
	OPEN_VIEW:"MarketEvent.OPEN_VIEW", 
	CLOSE_VIEW:"MarketEvent.CLOSE_VIEW", 
	SET_TYPE_DIC:"MarketEvent.SET_TYPE_DIC", 
	SET_SELL_TYPE_DIC:"MarketEvent.SET_SELL_TYPE_DIC", 
	UPDATE_BUY_TIMES:"MarketEvent.UPDATE_BUY_TIMES", 
	UPDATE_RECORD:"MarketEvent.UPDATE_RECORD", 
	UPDATE_PLZ_ALL:"MarketEvent.UPDATE_PLZ_ALL", 
	UPDATE_PLZ_ONE:"MarketEvent.UPDATE_PLZ_ONE", 
	SWTICH_BUY_SUBVIEW:"MarketEvent.SWTICH_BUY_SUBVIEW", 
	SWTICH_PLZ_SUBVIEW:"MarketEvent.SWTICH_PLZ_SUBVIEW", 
	SWTICH_PLZ_SELECT:"MarketEvent.SWTICH_PLZ_SELECT",
	OUT_SHELF_SUCCESS:"MarketEvent.OUT_SHELF_SUCCESS", 
	UP_SHELF_SUCCESS:"MarketEvent.UP_SHELF_SUCCESS", 
	BUY_SUCCESS:"MarketEvent.BUY_SUCCESS", 
	DELETE_GOODS:"MarketEvent.DELETE_GOODS", 
	PLZ_GROUP_VISIBLE:"MarketEvent.PLZ_GROUP_VISIBLE", 
	PLZ_SORT_GOODS:"MarketEvent.PLZ_SORT_GOODS", 
	PLZ_SUCCESS:"MarketEvent.PLZ_SUCCESS", 
	CLICK_PLZ_TYPE_ITEM:"MarketEvent.CLICK_PLZ_TYPE_ITEM", 
	NEED_UPDATE_BAG:"MarketEvent.NEED_UPDATE_BAG",
	UPDATE_ICON:"MarketEvent.UPDATE_ICON"
}
window["MarketBagType"] = MarketBagType
window["MarketViewType"] = MarketViewType
window["MarketEvent"] = MarketEvent
export class MarketModel extends EventDispatcher {
	AddlzGoodInfoAll
	AddlzGoodInfoMine
	CantWearEquip
	GetBagGoods
	GetGoodsDic
	GetGoodsList
	GetGoodsNum
	GetKVCfg
	GetMarketLimitPrice
	GetMarketLimitPriceFree
	GetMarketVipRatio
	GetPlzGoods
	GetPlzGoodsByCond
	GetSeekAllInfo
	GetSeekMineInfo
	GetSellGoodsByCond
	GetSellGoodsInfo
	GetShelfGoodsInfo
	GetTypeCfg
	GetTypeCfgAll
	GetTypeCfgList
	InitConfig
	InitPlzGoods
	IsEquipPowerOver
	RemovePlzGoodInfoAll
	RemovePlzGoodInfoMine
	RemoveSellGoodInfo
	RemoveShelfGoodInfo
	Reset
	ReturnPlzGoods
	SetGoodsDic
	SetSeekAllInfo
	SetSeekMineInfo
	SetSellGoodsInfo
	SetShelfGoodsInfo
	checkKfOpen
	kf_open
	kf_open_time
	seek_info_all
	seek_info_mine
	shelf_goods_info
	showIcon
	type_cfg
	static Instance: any
	public constructor() {
		super()


		this.kf_open_time = 0;
		this.kf_open = false;
		let local_MarketEvent = MarketEvent
		let ConfigHasDefaultValue = Config.ConfigHasDefaultValue
		let local_Config = Config
		let erlang_parser = ErlangParser.GetInstance()
		let local_Number = Number
		let goods_model = GoodsModel.GetInstance()
		let local_MarketBagType = MarketBagType
		let equip_model = EquipModel.GetInstance()
		let goods_type_dic_ = []
		let sell_goods_dic_ = []
		let plz_goods_dic_ = null
		this.Reset = () => {
			this.seek_info_all = null
			this.seek_info_mine = null
			this.shelf_goods_info = null
			goods_type_dic_ = []
			sell_goods_dic_ = []
			plz_goods_dic_ = null
		}

		this.SetSeekMineInfo = (info?) => {
			this.ChangeVar("seek_info_mine", info, false, true)
		}

		this.GetSeekMineInfo = () => {
			return this.seek_info_mine
		}

		this.SetSeekAllInfo = (info?) => {
			this.ChangeVar("seek_info_all", info, false, true)
		}

		this.GetSeekAllInfo = () => {
			return this.seek_info_all
		}

		this.SetSellGoodsInfo = (type?, subtype?, info?) => {
			sell_goods_dic_ = []
			// [ts2lua]sell_goods_dic_下标访问可能不正确
			sell_goods_dic_[type * 10000 + subtype] = info
			this.Fire(local_MarketEvent.SET_SELL_TYPE_DIC, type, subtype)
		}

		this.GetSellGoodsInfo = (type?, subtype?) => {
			// [ts2lua]sell_goods_dic_下标访问可能不正确
			return sell_goods_dic_[type * 10000 + subtype]
		}

		this.SetShelfGoodsInfo = (info?) => {
			this.ChangeVar("shelf_goods_info", info, false, true)
		}

		this.GetShelfGoodsInfo = () => {
			return this.shelf_goods_info
		}

		this.SetGoodsDic = (type?, info?) => {
			// [ts2lua]goods_type_dic_下标访问可能不正确
			goods_type_dic_[type] = info
			this.Fire(local_MarketEvent.SET_TYPE_DIC, type)
		}

		this.GetGoodsDic = (type?) => {
			// [ts2lua]goods_type_dic_下标访问可能不正确
			return goods_type_dic_[type]
		}

		this.InitConfig = () => {
			this.type_cfg = Config.PRELOAD_SERVER_CONFIG.config_goods_sell_subtype
		}

		this.GetKVCfg = (cfg?, index?) => {
			// [ts2lua]cfg下标访问可能不正确
			// [ts2lua]cfg[index]下标访问可能不正确
			return cfg[index]["value"]
		}

		this.GetTypeCfg = (type?, subtype?) => {
			// [ts2lua]this.type_cfg下标访问可能不正确
			
				let cfg_type = this.type_cfg[type + "@" + subtype]
				
				return cfg_type

		}

		this.GetTypeCfgAll = (config?, type?, start_index?) => {
				if (start_index == null) {
					start_index = 1
				}
				let list = []
				let count = 0
				let kvlist = this.GetKVCfg(config, 14)
				kvlist = erlang_parser.Parse(kvlist)
				for (let _tmpi in kvlist) {
					var vo = kvlist[_tmpi]
					if (Number(vo[0]) == type) {
						count = Number(vo[1])
						break
					}
				}
				let index = 0
				let i = start_index
				do {
					// [ts2lua]this.type_cfg下标访问可能不正确
					let _cfg = this.type_cfg[type + "@" + (i - 1)]
					if (_cfg) {
						list[index] = _cfg
					}
					i = i + 1
					index = index + 1
				} while ((i <= count + 1))

				return list


		}

		this.GetTypeCfgList = () => {

				let list = []
				for (let key in this.type_cfg) {

					// [ts2lua]this.type_cfg下标访问可能不正确
					let info = this.type_cfg[key]
					if (table.find(list, info.type) < 0) {
						table.insert(list, info.type)
					}
				}
				return list

		}

		this.GetMarketLimitPrice = (type_id?) => {
			let price = 1
			let num_limit = 1
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			let basic = local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, type_id, false)
			let price_list = erlang_parser.Parse(basic.trade_price)


			for (let i = price_list.length - 1; i >= 0; i -= 1) {
				let info = price_list[i]
				if (!(open_day < local_Number(info[0]))) {
					price = local_Number(info[1])
					num_limit = local_Number(info[2])
					break
				}
			}
			return [price, num_limit]
		}

		this.GetMarketLimitPriceFree = (if_custom_price?) => {
			let price_list = erlang_parser.Parse(if_custom_price)
			let min_price = local_Number(price_list[0])
			let max_price = local_Number(price_list[1])
			let num_limit = local_Number(price_list[2])
			return [min_price, max_price, num_limit]
		}

		this.GetMarketVipRatio = (cfg1,cfg2) => {
			let card = VipModel.GetInstance().GetNobleCardState()
			let vip = RoleManager.GetInstance().GetMainRoleVo().vip_flag
			let cfg = cfg1
			// [ts2lua]cfg下标访问可能不正确
			cfg = cfg["151@1@" + card + "@" + vip]
			if (cfg) {
				return cfg.num
			}
			cfg = cfg2
			// [ts2lua]cfg下标访问可能不正确
			cfg = cfg["151@1"]
			let num = cfg && cfg.num || 0
			return num
		}

		this.GetBagGoods = (type?) => {
			let list = []
			let basic = null
			if (local_MarketBagType.GOODS == type) {
				for (let _tmpi in goods_model.bag_goods_list) {
					var info = goods_model.bag_goods_list[_tmpi]
					if (!(info.type == 10) && !(info.trade == 0) && !(info.bind == 1)) {
						basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
						if (basic.if_custom_price != "0" || basic.trade_price != "[]") {
							info.isMarket = true
							table.insert(list, info)
						}
					}

				}
				for (let _tmpi in goods_model.holy_seal_bag_goods_list) {
					var info = goods_model.holy_seal_bag_goods_list[_tmpi]
					if (!(info.trade == 0) && !(info.bind == 1)) {
						basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
						if (basic.if_custom_price != "0" || basic.trade_price != "[]") {
							info.isMarket = true
							table.insert(list, info)
						}
					}

				}
				for (let _tmpi in goods_model.revelation_bag_list) {
					var info = goods_model.revelation_bag_list[_tmpi]
					if (!(info.trade == 0) && !(info.bind == 1)) {
						basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
						if (basic.if_custom_price != "0" || basic.trade_price != "[]") {
							info.isMarket = true
							table.insert(list, info)
						}
					}

				}
				for (let _tmpi in goods_model.demontalent_bag_list) {
					var info = goods_model.demontalent_bag_list[_tmpi]
					if (!(info.trade == 0) && !(info.bind == 1)) {
						basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
						if (basic.if_custom_price != "0" || basic.trade_price != "[]") {
							info.isMarket = true
							table.insert(list, info)
						}
					}

				}
			} else if (local_MarketBagType.GOD == type) {
				for (let _tmpi in goods_model.bag_goods_list) {
					var info = goods_model.bag_goods_list[_tmpi]
					if (!(info.type != 10) && !(info.trade == 0) && !(info.bind == 1)) {
						basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
						if (basic.if_custom_price != "0" || basic.trade_price != "[]") {
							info.isMarket = true
							table.insert(list, info)
						}
					}

				}
				for (let _tmpi in goods_model.god_bag_list) {
					var info = goods_model.god_bag_list[_tmpi]
					if (!(info.trade == 0) && !(info.bind == 1)) {
						basic = goods_model.GetGoodsBasicByTypeId(info.type_id)
						if (basic.if_custom_price != "0" || basic.trade_price != "[]") {
							info.isMarket = true
							table.insert(list, info)
						}
					}

				}
			}
			return list
		}

		this.GetGoodsList = () => {
			return goods_model.bag_goods_list.concat(goods_model.holy_seal_bag_goods_list)
		}

		this.GetSellGoodsByCond = (type?, subtype?, color?, stage?, star?, equip_attr_cfg?) => {
			let list = []
			let goods_info = this.GetSellGoodsInfo(type, subtype)
			if (!goods_info) {
				return list
			}
			let cfg = null
			for (let _tmpi in goods_info.goods_list) {
				var info = goods_info.goods_list[_tmpi]
				cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, info.type_id, false)
				if (!(color != 99 && color != cfg.color) && !(stage != 99 && stage != equip_model.GetStageByTypeId(info.type_id, equip_attr_cfg)) && !(star != 99 && star != equip_model.GetStarByTypeId(info.type_id, equip_attr_cfg))) {
					table.insert(list, info)
				}

			}
			return list
		}

		this.GetPlzGoodsByCond = (type?, subtype?, color?, stage?, star?, equip_attr_cfg?) => {
			let list = []
			let all_list = this.GetPlzGoods(type, subtype)
			let cfg = null
			for (let _tmpi in all_list) {
				var info = all_list[_tmpi]
				cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, info.type_id, false)
				if (!(color != 99 && color != cfg.color) && !(stage != 99 && stage != equip_model.GetStageByTypeId(info.type_id, equip_attr_cfg)) && !(star != 99 && star != equip_model.GetStarByTypeId(info.type_id, equip_attr_cfg))) {
					table.insert(list, info)
				}

			}
			return list
		}

		this.RemoveSellGoodInfo = (scmd?) => {
			let info = this.GetSellGoodsInfo(scmd.type, scmd.subtype)
			if (!info) {
				info = this.GetSellGoodsInfo(scmd.type, 0)
			}
			if (!info) {
				return
			}
			if (info.goods_list && info.goods_list.length > 0) {
				let i = 0
				do {
					let data = info.goods_list[i]
					if (data.id == scmd.id) {
						table.remove(info.goods_list, i)
						break
					}
					i = i + 1
				} while ((i < info.goods_list.length))
			}

			this.SetSellGoodsInfo(info.type, info.subtype, info)
		}

		this.RemoveShelfGoodInfo = (scmd?) => {
			let sg_info = this.GetShelfGoodsInfo()
			if (!sg_info) {
				return
			}
			let i = 1
			do {
				let data = sg_info.goods_list[i]
				if (data && data.id == scmd.id) {
					table.splice(sg_info.goods_list, i, 1)
					break
				}
				i = i + 1
			} while ((i <= sg_info.goods_list.length))
			this.SetShelfGoodsInfo(sg_info)
		}

		this.RemovePlzGoodInfoAll = (scmd?) => {
			let info = this.GetSeekAllInfo()
			if (!info) {
				return
			}
			let i = 0
			do {
				let vo = info.seek_list[i]
				if (vo && vo.id == scmd.id) {
					table.splice(info.seek_list, i, 1)
					break
				}
				i = i + 1
			} while ((i < info.seek_list.length))
			this.SetSeekAllInfo(info)
		}

		this.RemovePlzGoodInfoMine = (scmd?) => {
			let info = this.GetSeekMineInfo()
			if (!info) {
				return
			}
			let i = 1
			do {
				let data = info.seek_list[i]
				if (data && data.id == scmd.id) {
					table.splice(info.seek_list, i, 1)
					break
				}
				i = i + 1
			} while ((i <= info.seek_list.length))
			this.SetSeekMineInfo(info)
		}

		this.AddlzGoodInfoAll = (scmd?) => {
			let info = this.GetSeekAllInfo()
			if (!info) {
				return
			}
			table.unshift(info.seek_list, scmd)
			this.SetSeekAllInfo(info)
		}

		this.AddlzGoodInfoMine = (scmd?) => {
			let info = this.GetSeekMineInfo()
			if (!info) {
				return
			}
			table.unshift(info.seek_list, scmd)
			this.SetSeekMineInfo(info)
		}

		this.GetPlzGoods = (type?, subtype?) => {
			if (!plz_goods_dic_) {
				this.InitPlzGoods()
			}
			return this.ReturnPlzGoods(type, subtype)
		}

		this.ReturnPlzGoods = (type?, subtype?) => {
			// [ts2lua]plz_goods_dic_下标访问可能不正确
			if (!plz_goods_dic_[type]) {
				return {}
			}
			// [ts2lua]plz_goods_dic_下标访问可能不正确
			// [ts2lua]plz_goods_dic_[type]下标访问可能不正确
			if (!plz_goods_dic_[type][subtype]) {
				return {}
			}
			// [ts2lua]plz_goods_dic_下标访问可能不正确
			// [ts2lua]plz_goods_dic_[type]下标访问可能不正确
			return plz_goods_dic_[type][subtype]
		}

		this.InitPlzGoods = () => {
			plz_goods_dic_ = []
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods", false)
			let basic = null
			let trade_price = null
			let if_custom_price = null
			let type_list = null
			let subtype_list = null

			for (let key in cfg) {

				// [ts2lua]cfg下标访问可能不正确
				let key_ = Number(key)
				let _continue = false
				basic = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, key_,false, cfg)
				// [ts2lua]basic下标访问可能不正确
				if (basic.trade == 0) {
					_continue = true
				}
				// [ts2lua]basic下标访问可能不正确
				if (basic.bind == 1) {
					_continue = true
				}
				// [ts2lua]basic下标访问可能不正确
				if (_continue == false) {
					if_custom_price = basic.if_custom_price == 0
					// [ts2lua]basic下标访问可能不正确
					trade_price = basic.trade_price == "[]"
					if (if_custom_price && trade_price) {
						_continue = true
					}
					// [ts2lua]basic下标访问可能不正确
					if (basic.sell_category == 0) {
						_continue = true
					}
					// [ts2lua]basic下标访问可能不正确
					if (basic.sell_subcategory == 0) {
						_continue = true
					}
					if (_continue == false) {
						basic = local_Config.GetConfigVo(ConfigHasDefaultValue.config_goods.name, key, false)
						// [ts2lua]plz_goods_dic_下标访问可能不正确
						type_list = plz_goods_dic_[basic.sell_category]
						if (!type_list) {
							// [ts2lua]plz_goods_dic_下标访问可能不正确
							plz_goods_dic_[basic.sell_category] = []
						}
						// [ts2lua]plz_goods_dic_下标访问可能不正确
						// [ts2lua]plz_goods_dic_[basic.sell_category]下标访问可能不正确
						subtype_list = plz_goods_dic_[basic.sell_category][basic.sell_subcategory]
						if (!subtype_list) {
							// [ts2lua]plz_goods_dic_下标访问可能不正确
							// [ts2lua]plz_goods_dic_[basic.sell_category]下标访问可能不正确
							plz_goods_dic_[basic.sell_category][basic.sell_subcategory] = []
						}
						// [ts2lua]plz_goods_dic_下标访问可能不正确
						// [ts2lua]plz_goods_dic_[basic.sell_category]下标访问可能不正确
						table.insert(plz_goods_dic_[basic.sell_category][basic.sell_subcategory], basic)
					}

				}

			}
		}

		this.IsEquipPowerOver = (basic?, rating?) => {
			let wear = null
			if (basic.type == 10) {
				wear = equip_model.GetWearEquipInfo(basic.equip_type)
			} else if (basic.type == HolySealModel.GOODS_TYPE) {
				wear = HolySealModel.GetInstance().GetWearEquipByPos(basic.subtype)
			}
			let up = !wear || wear.rating < rating
			let down = !(!wear) && wear.rating > rating
			return [up, down]
		}

		this.CantWearEquip = (basic?, cfgs?) => {
			if (basic.type == 10) {
				return equip_model.CantWearEquip(basic.type_id, cfgs)
			} else {
				return false
			}
		}

		this.GetGoodsNum = (type_id?) => {
			let id = local_Number(type_id)
			let theNum = 0
			let list = goods_model.GetTypeGoods(id)
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (vo.expire_time == 0 && vo.bind == 0) {
					theNum = theNum + vo.goods_num
				}
			}
			return theNum
		}

		this.checkKfOpen = (cfg_kv?) => {
			let dayCount = 0
			let severTime = TimeUtil.getServerTime()
			if (this.kf_open_time <= 0 || severTime >= this.kf_open_time) {
				return dayCount
			}
			let time = this.kf_open_time - severTime
			dayCount = Math.ceil(time / (24 * 60 * 60))
			// [ts2lua]lua中0和空字符串也是true，此处dayCount > 0需要确认
			dayCount = dayCount > 0 && dayCount || 0
			return dayCount
		}

		this.showIcon = (is_kf?) => {
			let icon_mgr = ActivityIconManager.GetInstance()
			// [ts2lua]lua中0和空字符串也是true，此处is_kf需要确认
			let show_icon = is_kf && "151@1" || "151"
			// [ts2lua]lua中0和空字符串也是true，此处is_kf需要确认
			let del_icon = is_kf && "151" || "151@1"
			let icon = icon_mgr.getIconInfo(del_icon)
			if (icon) {
				icon_mgr.deleteIcon(del_icon)
			}
			icon_mgr.addIcon(show_icon)
		}


	}

	public static GetInstance() {

		if (!MarketModel.Instance) {
			MarketModel.Instance = new MarketModel()
		}
		return MarketModel.Instance
	}

}
window["MarketModel"] = MarketModel