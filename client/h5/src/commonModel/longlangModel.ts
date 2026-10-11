import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"

import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { GoodsModel } from "./GoodsModel"

export class longlangModel extends EventDispatcher {
	BetterEquipRed
	CanGetSuit
	DecIndex
	DecViewIndex
	DisIndex
	GetColorDropData
	GetEquipTypeName
	GetLonglangBag
	GetStageDropData
	GetStrData
	GetWearEquipByPos
	InitCfg
	RefreshDecRed
	RefreshStrRed
	UpColorCfg
	UpStageCfg
	alertDec
	auto_decompose_state_
	configDic
	decMaterial
	equipInfo
	equipStageList
	needsort
	rating
	showDecTips

	public static OPEN_VIEW = "LL1";
	public static SEND_PROTO = "LL2";
	public static REFRESH_RED = "LL3";
	public static EQUIP_STR_INFO = "LL4";
	public static PREVIEW_SUIT = "LL5";
	public static SUIT_INOF = "LL6";
	public static SELECT_DEC_ITEM = "LL7";
	public static SELECT_DIS_ITEM = "LL8";
	public static GOODS_TYPE = 77;
	public static EQUIP_COUNT = 11;
	public static MONEY_TYPE = 36255095;
	public static SHOP_MONEY = 36255097;
	public static PropList = [{ "0": 50, "1": "draconic_sacred" }, { "0": 51, "1": "draconic_tspace" }, { "0": 52, "1": "draconic_rule" }];
	public static MAX_DECOMPOSE_COLOR = 5;
	public static AUTO_DECOMPOSE_COLOR = 3;
	public static upStage = 0;
	public static upColor = 1;
	public static Pos = [{ "0": 158, "1": -95 }, { "0": 457, "1": -95 }, { "0": 87, "1": -200 }, { "0": 533, "1": -200 }, { "0": 116, "1": -313 }, { "0": 522, "1": -313 }, { "0": 177, "1": -232 }, { "0": 439, "1": -232 }, { "0": 305, "1": -255 }, { "0": 309, "1": -396 }, { "0": 310, "1": -77 }];
	public static _instance

	public constructor() {
		super()
		this.rating = 0;
		this.needsort = false;
		this.configDic = [];
		this.equipInfo = [];
		this.DecViewIndex = 0;
		this.DecIndex = 0;
		this.DisIndex = 1;
		this.alertDec = true;
		this.equipStageList = [];
		this.decMaterial = false;
		this.UpStageCfg = [];
		this.UpColorCfg = [];
		this.showDecTips = true;
		this.auto_decompose_state_ = false
		let goods_model = GoodsModel.GetInstance()
		let common_mgr = CommonManager.GetInstance()
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_longlangModel = longlangModel

		this.GetLonglangBag = () => {
			//if (this.needsort ) {
			goods_model.SortLonglangBag()
			//}
			let bagList = Util.DeepCopy(goods_model.longlang_bag_list)
			let count = bagList.length
			let list = []
			let num = 24 - count % 6
			while ((num > 0)
			) {
				table.insert(list, { type_id: 0 })
				num = num - 1
			}
			list = bagList.concat(list)
			return list
		}

		this.RefreshStrRed = () => {
			if (!common_mgr.CheckFuncOpenState("longlanguageView", true)) {
				return
			}

			let cfg = Config.PRELOAD_SERVER_CONFIG.config_draconic_strong
			if (cfg) {
				let bool = false
				for (let pos in this.equipInfo) {
					let lv = this.equipInfo[pos]
					let info = this.GetWearEquipByPos(pos)
					if (info) {
						let stren_cfg = cfg[pos + "@" + (lv + 1)]
						if (stren_cfg) {
							let cost_cfg = JSON.parse(stren_cfg.cost)
							let cost = (cost_cfg && cost_cfg[0]) && cost_cfg[0][2]
							let have = goods_model.GetSpecialScore(local_longlangModel.MONEY_TYPE)
							if (Number(have) >= Number(cost)) {
								bool = true
								break
							}
						}
					}
				}
				red_dot_mgr.SetRedStatus(local_ModuleType.LONGLANG, 2, bool)
				this.Fire(local_longlangModel.REFRESH_RED, 2)
				RedDotController.ins.up(RedKey.LONG_LANG_STREN, bool ? 1 : 0)
			}
		}

		this.RefreshDecRed = (list?) => {
			if (!common_mgr.CheckFuncOpenState("longlanguageView", true)) {
				return
			}
			let bagList = goods_model.longlang_bag_list
			let equipList = goods_model.longlang_equip_list
			this.decMaterial = false
			let bool = false
			for (let _tmpi in bagList) {
				let vo = bagList[_tmpi]
				if (vo.type_id != 0 && vo.type != local_longlangModel.GOODS_TYPE) {
					bool = true
					this.decMaterial = true
					break
				} else if (vo.type_id != 0 && vo.color <= 3 && vo.subtype < 7) {
					// [ts2lua]equipList下标访问可能不正确
					let equipInfo = equipList[vo.subtype]
					if (equipInfo && vo.rating <= equipInfo.rating) {
						bool = true
						break
					}
				}
			}
			red_dot_mgr.SetRedStatus(local_ModuleType.LONGLANG, 3, bool)
			this.Fire(local_longlangModel.REFRESH_RED, 3)
			RedDotController.ins.up(RedKey.LONG_LANG_DEV, bool ? 1 : 0)
		}

		this.GetWearEquipByPos = (pos?) => {
			if (pos != null) {
				let longlang_equip_list = goods_model.longlang_equip_list
				return longlang_equip_list && longlang_equip_list[pos]
			}
		}

		this.GetStrData = (equip_type?) => {
			return this.equipInfo[equip_type]
		}

		this.GetEquipTypeName = (sub_type?, cfg?) => {
			return (cfg && cfg[sub_type].name || "")
		}

		this.GetStageDropData = () => {
			let drop = []
			table.insert(drop, { id: 0, content: "不筛选" })
			let i = 4
			do {
				table.insert(drop, { id: i, content: WordManager.ConvertNum(i) + "阶以下", cond: i })
				i = i + 1
			} while ((i <= 15))
			return drop
		}

		this.GetColorDropData = () => {
			let drop = []
			table.insert(drop, { id: 0, content: "不筛选" })
			let i = 0
			do {
				let color = i + 3
				if (color == 6) {
					color = color + 1
				}
				table.insert(drop, { id: i, content: ColorUtil.GetColorName(color) + "以下", cond: color })
				i = i + 1

			} while ((i < 4))
			return drop
		}

		this.BetterEquipRed = (list?) => {
			if (!common_mgr.CheckFuncOpenState("longlanguageView", true)) {
				return
			}
			if (!list) {
				list = goods_model.longlang_bag_list
			}
			let longlang_equip_list = goods_model.longlang_equip_list
			let better = false
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (vo.type_id != 0 && vo.type == longlangModel.GOODS_TYPE) {
					let curEquip = longlang_equip_list[vo.subtype]
					if (!curEquip || (curEquip && vo.rating > curEquip.rating) && this.CanGetSuit(vo)) {
						better = true
						break
					}
				}
			}
			red_dot_mgr.SetRedStatus(local_ModuleType.LONGLANG, 1, better)
			RedDotController.ins.up(RedKey.LONG_LANG_BETTER, better ? 1 : 0)
			this.Fire(local_longlangModel.REFRESH_RED, 1)
		}

		this.CanGetSuit = (data?) => {
			if (data && data.color > 3) {
				let bagList = goods_model.longlang_bag_list
				for (let _tmpi in bagList) {
					let vo = bagList[_tmpi]
					if ((vo.type_id != 0 && ((vo.color > 3 && vo.stage == data.stage) && vo.goods_id != data.goods_id) && (vo.subtype < 7 && data.subtype < 7 || vo.subtype >= 7 && data.subtype >= 7)) && vo.subtype != data.subtype) {
						return true
					}
				}
				let equipList = goods_model.longlang_equip_list
				for (let _tmpi in equipList) {
					let vo = equipList[_tmpi]
					if (vo && vo.stage == data.stage && vo.goods_id != data.goods_id && ((vo.subtype < 7 && data.subtype < 7) || (vo.subtype >= 7 && data.subtype >= 7)) && vo.subtype != data.subtype) {//and vo.color > 3
						return true
					}
				}
			}
		}

		this.InitCfg = (list?) => {
			let curCfg = null
			let gfunc = goods_model
			let efunc = ErlangParser.GetInstance()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				for (let _tmpi in vo) {
					let vo1 = vo[_tmpi]
					for (let _tmpi in vo1) {
						let vo2 = vo1[_tmpi]
						for (let _tmpi in vo2) {
							let id = vo2[_tmpi]
							id = Number(id)
							// let cfgs = Config.PRELOAD_SERVER_CONFIG.config_draconic_strong
							curCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, id, false)
							if (curCfg) {
								let matCfg = curCfg[8] || curCfg.regular_mat
								let needCfg = curCfg[12] || curCfg.goods
								if (matCfg && needCfg) {
									let matlist = efunc.Parse(matCfg)
									let getList = efunc.Parse(needCfg)
									let basic1 = gfunc.GetGoodsBasicByTypeId(matlist[0][0][1])
									let basic2 = gfunc.GetGoodsBasicByTypeId(getList[0][1])
									if (basic1.color == basic2.color) {
										this.UpStageCfg[matlist[0][0][1]] = id
									} else {
										this.UpColorCfg[matlist[0][0][1]] = id
									}
								}
							}
							// curCfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goodscompose.name, id, false)
							// if (curCfg ) {
							// 	let matCfg = curCfg[8] || curCfg.regular_mat
							// 	// [ts2lua]curCfg下标访问可能不正确
							// 	let needCfg = curCfg[12] || curCfg.goods
							// 	if (matCfg && needCfg ) {
							// 		let matlist = efunc.Parse(matCfg)
							// 		let getList = efunc.Parse(needCfg)
							// 		let basic1 = gfunc.GetGoodsBasicByTypeId(matlist[0][0][1])
							// 		let basic2 = gfunc.GetGoodsBasicByTypeId(getList[0][1])
							// 		if (basic1.color == basic2.color ) {
							// 			// [ts2lua]this.UpStageCfg下标访问可能不正确
							// 			this.UpStageCfg[matlist[0][0][1]] = id
							// 		}else{
							// 			// [ts2lua]this.UpColorCfg下标访问可能不正确
							// 			this.UpColorCfg[matlist[0][0][1]] = id
							// 		}
							// 	}
							// }
						}
					}
				}
			}
		}
	}

	public static GetInstance() {
		if (!longlangModel._instance) {
			longlangModel._instance = new longlangModel()
		}
		return longlangModel._instance
	}
}
window["longlangModel"] = longlangModel