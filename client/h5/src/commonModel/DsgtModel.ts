import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"

export class DsgtModel extends EventDispatcher {
	GetActivateUpdate
	GetAdronDsgtID
	GetDsgtAttrs
	GetDsgtCfgByActiveGoods
	GetDsgtGoodsDic
	GetDsgtGoodsNumDic
	GetDsgtInfoVo
	GetDsgtList
	GetDsgtNeedNumByTypeID
	GetDsgtOrderByTypeID
	GetDsgtOrdrtList
	GetGoodInfo
	GetPriSelDsgt
	GetRedDic
	JsonAttrList
	LoadConfig
	Plat_ShowDsgt
	RefreshAllRed
	RefreshGoodsNum
	RefreshOneRed
	SetAdronDsgtID
	SetDsgtInfo
	ShowRedIcon
	SortList
	UpdataView
	UpdateDsgtListSort
	cur_select_dsgt
	getDsgtCfgByID
	GetDsgtOrderCfg

	public static SCMD_REQUEST = "SCMD_REQUEST";
	public static DSGT_INSTANCE_LIST = "DSGT_INSTANCE_LIST";
	public static DSGT_UPDATE_POWER = "DSGT_UPDATE_POWER";
	public static DSGT_ORDER = "DSGT_ORDER";
	public static DSGT_ADORN_BUT = "DSGT_ADORN_BUT";
	public static DSGT_UPDATE_VIEW = "DSGT_UPDATE_VIEW";
	public static DSGT_OPEN_VIEW = "DSGT_OPEN_VIEW";
	public static DSGT_RED = "DSGT_RED";
	static Instance: DsgtModel
	public constructor() {
		super()

		if (DsgtModel.Instance) {
			return
		}
		let config_preload_server = Config
		let local_DsgtModel = DsgtModel
		let local_Number = Number
		let goods_model = GoodsModel.GetInstance()
		let dsgt_info_list_ = []
		let dsgt_activate_array_ = []
		let dsgt_sort_info_list_ = []
		let dsgt_goods_dic_ = {}
		let dsgt_goods_num_dic_ = {}
		let dsgt_full_order_list_ = null
		let dsgt_attr_config_list_ = null
		let red_dic_ = {}
		let adorn_dsgt_id_ = null
		let is_updata_ = false
		let location_list = []  // 根据位置排序好的列表，只用来确定称号顺序

		this.LoadConfig = () => {
			dsgt_info_list_ = Config.PRELOAD_SERVER_CONFIG.config_dsgt
			this.JsonAttrList(dsgt_info_list_, "attr_list")
			this.JsonAttrList(dsgt_info_list_, "goods_consume")
			dsgt_full_order_list_ = Config.PRELOAD_SERVER_CONFIG.config_dsgt_order
			dsgt_attr_config_list_ = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr
			let list = []
			for (let k in dsgt_info_list_) {
				var v = dsgt_info_list_[k]
				table.insert(location_list, v)
			}
			let sort_fun = (a?, b?) => {
				return a.location < b.location
			}
			table.sort(location_list, sort_fun)
			/*
			ResManager.GetInstance().LoadGameConfig(this, "config_dsgt", false, null, (cfg) => {
				dsgt_info_list_ = cfg
				// ResManager.GetInstance().DestoryGameConfig(this, "config_dsgt", false);
				this.JsonAttrList(dsgt_info_list_, "attr_list")
				this.JsonAttrList(dsgt_info_list_, "goods_consume")

				ResManager.GetInstance().LoadGameConfig(this, "config_dsgt_order", false, null, (cfg) => {
					dsgt_full_order_list_ = cfg
					// ResManager.GetInstance().DestoryGameConfig(this, "config_dsgt_order", false);
				});
				// dsgt_full_order_list_=ResManager.GetInstance().GetGameConfigFromCache(this,"config_dsgt_order")
				//this:JsonAttrList(dsgt_full_order_list_, "attr_list")
				//this:JsonAttrList(dsgt_full_order_list_, "consume")
				dsgt_attr_config_list_ = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr

				let list = []
				for (let k in dsgt_info_list_) {
					var v = dsgt_info_list_[k]
					table.insert(location_list, v)
				}
				let sort_fun = (a?, b?) => {
					return a.location < b.location
				}
				table.sort(location_list, sort_fun)
			});
			*/
			// this.JsonAttrList(dsgt_info_list_, "attr_list")
			// this.JsonAttrList(dsgt_info_list_, "goods_consume")

			// // ResManager.GetInstance().LoadGameConfig(this, "config_dsgt_order", false, null, (cfg) => {
			// // 	dsgt_full_order_list_ = cfg
			// // 	// ResManager.GetInstance().DestoryGameConfig(this, "config_dsgt_order", false);
			// // });
			// dsgt_full_order_list_=ResManager.GetInstance().GetGameConfigFromCache(this,"config_dsgt_order")
			// //this:JsonAttrList(dsgt_full_order_list_, "attr_list")
			// //this:JsonAttrList(dsgt_full_order_list_, "consume")
			// dsgt_attr_config_list_ = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr

			// let list = []
			// for (let k in dsgt_info_list_) {
			// 	var v = dsgt_info_list_[k]
			// 	table.insert(location_list, v)
			// }
			// let sort_fun = (a?, b?) => {
			// 	return a.location < b.location
			// }
			// table.sort(location_list, sort_fun)
		}

		this.GetDsgtOrderCfg = () => {
			return dsgt_full_order_list_
		}

		this.JsonAttrList = (config_list?, name?) => {
			for (let index in config_list) {
				config_list[index][name] = JSON.parse(config_list[index][name])
			}
		}
		this.UpdataView = (type?) => {
			if (!is_updata_) {
				is_updata_ = true
				let id = null
				let time_out = () => {
					is_updata_ = false
					this.RefreshAllRed()
					this.Fire(local_DsgtModel.DSGT_UPDATE_VIEW, type)
					clearTimeout(id)
				}
				id = setTimeout(time_out, 0.08)
			}
		}

		this.GetActivateUpdate = (dsgt_id?, status?, order?, end_time?, is_active?) => {
			for (let index in dsgt_info_list_) {

				if (dsgt_info_list_[index].id == dsgt_id) {
					dsgt_info_list_[index].order = order
					if (order == 0) {
						dsgt_info_list_[index].order = null
					}

					dsgt_info_list_[index].end_time = (end_time && (end_time) || (dsgt_info_list_[index].end_time))
					dsgt_info_list_[index].status = status
					// adorn_dsgt_id_ = ((is_active && adorn_dsgt_id_ == 0) && order == 1 && (dsgt_id) || ((status == 0 && adorn_dsgt_id_ == dsgt_id && (0) || { adorn_dsgt_id_ })))[1]
					if (dsgt_goods_dic_[dsgt_id]) {
						if (dsgt_info_list_[dsgt_id].order && dsgt_info_list_[dsgt_id].order < dsgt_info_list_[dsgt_id].order_limit) {
							let dsgt_full_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dsgt_order.name, dsgt_id + "@" + dsgt_info_list_[dsgt_id].order, false)
							if (dsgt_full_cfg) {
								let consume = JSON.parse(dsgt_full_cfg.consume)
								dsgt_goods_dic_[dsgt_id] = [[consume[0][0], consume[0][1], consume[0][2]]]
							}
						} else {
							dsgt_goods_num_dic_[dsgt_goods_dic_[dsgt_id][0][1]] = null
							dsgt_goods_dic_[dsgt_id] = null
							delete red_dic_[dsgt_id]
						}
					}
					if (status == 0) {
						this.GetGoodInfo()
					}
					if (is_active) {

					}
				}
			}
			this.UpdateDsgtListSort()
			this.UpdataView(order)
		}

		this.UpdateDsgtListSort = () => {
			dsgt_activate_array_ = []
			dsgt_sort_info_list_ = []
			let unActivate_list = []
			for (let key in location_list) {

				if (location_list[key].status && location_list[key].status > 1) {
					table.insert(dsgt_sort_info_list_, location_list[key])
				} else {
					table.insert(unActivate_list, location_list[key])
				}
			}
			if (unActivate_list.length > 0) {
				for (let _tmpi in unActivate_list) {
					var info = unActivate_list[_tmpi]
					if (this.Plat_ShowDsgt(info.dsgt_args)) {
						table.insert(dsgt_sort_info_list_, info)
					}
				}
			}
		}

		this.SetAdronDsgtID = (id?) => {
			adorn_dsgt_id_ = id
		}

		this.ShowRedIcon = () => {
			return CommonManager.GetInstance().CheckFuncOpenState("DsgtWindowView", true) && !Util.IsTableEmpty(red_dic_)
		}

		this.GetPriSelDsgt = (type?, current_selected_index?, current_selected_id?) => {
			if (this.cur_select_dsgt) {
				for (let index in dsgt_sort_info_list_) {

					if (dsgt_sort_info_list_[index].goods_consume && dsgt_sort_info_list_[index].goods_consume[0][1] == this.cur_select_dsgt) {
						this.cur_select_dsgt = 0
						return [local_Number(index), dsgt_sort_info_list_[index].id]
					}
				}
			}
			if (current_selected_index == 0 && current_selected_id > 0) {
				for (let index in dsgt_sort_info_list_) {

					if (dsgt_sort_info_list_[index].id == current_selected_id) {
						return [local_Number(index), current_selected_id]
					}
				}
			}
			for (let index in dsgt_sort_info_list_) {

				if (dsgt_sort_info_list_[index].status == 1) {
					return [local_Number(index), dsgt_sort_info_list_[index].id]
				}
			}
			for (let index in dsgt_sort_info_list_) {

				if (dsgt_sort_info_list_[index].status == 3) {
					return [local_Number(index), dsgt_sort_info_list_[index].id]
				}
			}
			if (type == 1 || (current_selected_id && current_selected_id > 0)) {
				return [current_selected_index, current_selected_id]
			}
			let id = dsgt_sort_info_list_[0] && dsgt_sort_info_list_[0].id || 0
			return [0, id]
		}

		this.RefreshOneRed = (dsgt_id?, good_typeid?) => {
			let cur_info = dsgt_info_list_[dsgt_id]
			if (!cur_info) {
				return
			}
			let order = (cur_info.order && (cur_info.order) || (0))
			if (!this.Plat_ShowDsgt(cur_info.dsgt_args) && order == 0) {
				return
			}
			let have_num = dsgt_goods_num_dic_[good_typeid]
			let need_num = 0
			if (cur_info.order_limit > order) {
				let full_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dsgt_order.name, dsgt_id + "@" + order, false)
				let consume = full_info && JSON.parse(full_info.consume)
				let goods_consume = cur_info.goods_consume
				// [ts2lua]lua中0和空字符串也是true，此处order != 0需要确认
				need_num = order != 0 ? (consume && consume[0] && consume[0][2]) : (goods_consume && goods_consume[0] && goods_consume[0][2])
				need_num = Number(need_num)
			}
			let bool = have_num && need_num && need_num > 0 && have_num >= need_num
			if (bool) {
				red_dic_[dsgt_id] = bool
				dsgt_info_list_[dsgt_id].status = cur_info.status == 0 ? 1 : (cur_info.status == 2 ? 3 : cur_info.status)
			} else if (red_dic_[dsgt_id] != null) {
				delete red_dic_[dsgt_id]
				dsgt_info_list_[dsgt_id].status = cur_info.status == 1 ? 0 : (cur_info.status == 3 ? 2 : cur_info.status)
			}
		}

		this.RefreshAllRed = () => {
			for (let key in dsgt_goods_dic_) {

				let order = dsgt_info_list_[key].order
				let good_typeid = ((order && order >= dsgt_info_list_[key].order_limit) ? (null) : (dsgt_goods_dic_[key][0][1]))
				this.RefreshOneRed(key, good_typeid)
			}
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
			this.Fire(local_DsgtModel.DSGT_RED)
		}

		this.RefreshGoodsNum = (goods_list?) => {
			let value = 0
			for (let _tmpi in goods_list) {
				var good = goods_list[_tmpi]
				if (dsgt_goods_num_dic_[good.type_id] != undefined) {
					value = value + 1
					// [ts2lua]dsgt_goods_num_dic_下标访问可能不正确
					dsgt_goods_num_dic_[good.type_id] = goods_model.GetTypeGoodsNum(good.type_id)
				}
			}
			if (value > 0) {
				this.UpdataView()
			}
		}

		this.GetGoodInfo = () => {
			for (let key in dsgt_info_list_) {

				let consume = null
				dsgt_info_list_[key].status = dsgt_info_list_[key].status || 0
				if ((dsgt_info_list_[key].main_type == 3 && dsgt_info_list_[key].status >= 2) && dsgt_info_list_[key].order < dsgt_info_list_[key].order_limit) {
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dsgt_order.name, dsgt_info_list_[key].id + "@" + dsgt_info_list_[key].order, false)
					if (c) {
						consume = JSON.parse(c.consume)
					}
				} else if (dsgt_info_list_[key].status < 2 && dsgt_info_list_[key].goods_consume != "0") {//goods_consume改动
					consume = dsgt_info_list_[key].goods_consume
				}
				if (consume) {
					dsgt_goods_dic_[dsgt_info_list_[key].id] = [[consume[0][0], consume[0][1], consume[0][2]]]
					let id = consume[0][1]
					dsgt_goods_num_dic_[id] = goods_model.GetTypeGoodsNum(id)
					this.RefreshOneRed(dsgt_info_list_[key].id, id)
				}
			}
		}

		this.SortList = (list?) => {
			let sortFunc = (a?, b?) => {
				if (a && b && dsgt_info_list_[a.id] && dsgt_info_list_[b.id]) {
					return dsgt_info_list_[a.id].location < dsgt_info_list_[b.id].location
				}
			}
			table.sort(list, sortFunc)
			return list
		}

		this.SetDsgtInfo = (scmd?) => {
			adorn_dsgt_id_ = scmd.currentused
			dsgt_sort_info_list_ = []
			dsgt_activate_array_ = []
			this.SortList(scmd.dsgt_list)
			for (let _tmpi in scmd.dsgt_list) {
				var info = scmd.dsgt_list[_tmpi]
				if (dsgt_info_list_[info.id]) {
					dsgt_info_list_[info.id].order = info.order
					dsgt_info_list_[info.id].end_time = info.end_time
					dsgt_info_list_[info.id].status = 2
					table.insert(dsgt_activate_array_, info.id)
					table.insert(dsgt_sort_info_list_, dsgt_info_list_[info.id])
				}
			}
			if (dsgt_activate_array_.length < Util.TableSize(location_list)) {
				let index = 0
				for (let key in location_list) {
					var v = location_list[key]
					if (table.find(dsgt_activate_array_, Number(v.id)) == -1) {
						index = index + 1
						v.status = 0
						if (this.Plat_ShowDsgt(v.dsgt_args)) {
							table.insert(dsgt_sort_info_list_, v)
						}
						if (index >= Util.TableSize(location_list) - dsgt_activate_array_.length) {
							return
						}

					}
				}
			}
		}

		this.getDsgtCfgByID = (dsgt_id?) => {
			return dsgt_info_list_[dsgt_id]
		}

		this.GetDsgtInfoVo = () => {
			return dsgt_info_list_
		}

		this.GetDsgtList = () => {
			return dsgt_sort_info_list_
		}

		this.GetDsgtOrdrtList = () => {
			return dsgt_full_order_list_
		}

		this.GetDsgtAttrs = () => {
			return dsgt_attr_config_list_
		}

		this.GetDsgtGoodsDic = () => {
			return dsgt_goods_dic_
		}

		this.GetDsgtGoodsNumDic = () => {
			return dsgt_goods_num_dic_
		}

		this.GetDsgtNeedNumByTypeID = (type_id?) => {
			let need_num = null
			for (let index in dsgt_goods_dic_) {

				// [ts2lua]dsgt_goods_dic_下标访问可能不正确
				if (dsgt_goods_dic_[index] != null) {
					if (dsgt_goods_dic_[index][0][1] == type_id) {
						// [ts2lua]dsgt_goods_dic_下标访问可能不正确
						need_num = dsgt_goods_dic_[index][0][2]
					}
				}
			}
			return need_num
		}

		this.GetDsgtOrderByTypeID = (type_id?) => {
			let dsgt_id = null
			let order = null
			for (let index in dsgt_goods_dic_) {

				// [ts2lua]dsgt_goods_dic_下标访问可能不正确
				if (dsgt_goods_dic_[index] != null) {
					if (dsgt_goods_dic_[index][0][1] == type_id) {
						dsgt_id = index
					}
				}
			}
			if (dsgt_id) {
				for (let index in dsgt_info_list_) {

					let info = dsgt_info_list_[index]
					if (info.id == local_Number(dsgt_id)) {
						order = (info.order && (info.order) || (0))
						return order
					}
				}
			}
			return null
		}

		this.GetRedDic = () => {
			return Util.IsTableEmpty(red_dic_) || red_dic_
		}

		this.GetAdronDsgtID = () => { // 当前佩戴的称号
			return adorn_dsgt_id_
		}

		this.GetDsgtCfgByActiveGoods = (type_id?) => {
			let dsgt_cfg = null
			let cfg = null
			let goods_list = null
			for (let key in dsgt_info_list_) {

				cfg = dsgt_info_list_[key]
				if (cfg.goods_consume != "0") {
					if (cfg.goods_consume[0] && local_Number(cfg.goods_consume[0][1]) == local_Number(type_id)) {
						dsgt_cfg = cfg
						break
					}
				}
			}
			return dsgt_cfg
		}

		this.Plat_ShowDsgt = (limit_plats?) => {
			let bool = false
			let plat_name = ClientConfig.plat_name
			let _limit_plats = ErlangParser.GetInstance().Parse(limit_plats)
			if (!_limit_plats || Util.IsTableEmpty(_limit_plats) || !plat_name) {
				bool = true
			} else {
				for (let k in _limit_plats) {
					var v = _limit_plats[k]
					if (v == plat_name) {//||  plat_name.find(plat_name, v, 1)) {
						bool = true
						break
					}
				}
			}
			return bool
		}
	}

	public static GetInstance() {

		if (!DsgtModel.Instance) {
			DsgtModel.Instance = new DsgtModel()
		}
		return DsgtModel.Instance
	}
}

window["DsgtModel"] = DsgtModel