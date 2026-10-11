import { EventDispatcher } from "../util/EventDispatcher"
import { table } from "../common/table"
import { Util, GlobalTimerQuest } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { MainFunc } from "./MainUIModel"
import { ErlangParser } from "../util/ErlangParser"
import { ModuleType } from "../common/RedDotManager"
import { WordManager } from "../common/WordManager"
import { RedDotManager } from "../common/RedDotManager"
import { GoodsModel } from "./GoodsModel"
import { StarEquipModel } from "./StarEquipModel"

export class chcModel extends EventDispatcher {
	public static Instance

	CheckEquipReStype
	CheckReddot
	CheckReddotMaster
	CheckReddotSoul
	ClearReddotByStype
	ClearTimer
	DefineConstant
	DicToList
	GetAttrStr
	GetDataByPos
	GetEquipList
	GetFuncLvAll
	GetInfoByStype
	GetInfoByType
	GetMasterByLv
	GetMasterByStype
	GetMasterByType
	GetNameCFG
	GetNormalPosList
	GetReddotAll
	GetReddotByStype
	GetReddotByType
	GetReddotOne
	GetReddotType
	GetReddotTypeMaster
	GetTimerData
	GetTypeStr
	SetInfoByType
	SetMasterByType
	UpdateMasterRed
	StartTimer
	UpdateEquipHandle
	_goods_dic_
	_stype_count

	public static CHCTYPE = { STREN: 1, EVO: 2, MAGIC: 3, SOUL: 4 }
	public static CHCTIMER = { CLOSE_VIEW: "CW" }
	public static RED_LIST = [ModuleType.CHC_STREN, ModuleType.CHC_EVO, ModuleType.CHC_MAGIC, ModuleType.CHC_SOUL, ModuleType.CHC_STREN_M, ModuleType.CHC_MAGIC_M]
	public static REQUEST_PROTO = "chcModel.REQUEST_PROTO";
	public static UPDATE_INFO = "chcModel.UPDATE_INFO";
	public static UPDATE_MASTER = "chcModel.UPDATE_MASTER";
	public static SELECT_ITEM = "chcModel.SELECT_ITEM";
	public static SELECT_TYPE = "chcModel.SELECT_TYPE";
	public static SELECT_MTRL = "chcModel.SELECT_MTRL";
	public static SELECT_MTRL_SS = "chcModel.SELECT_MTRL_SS";
	public static UPDATE_MTRL = "chcModel.UPDATE_MTRL";
	public static SEND_EVO_PROTO = "chcModel.SEND_EVO_PROTO";
	public static UPDATE_RESULT = "chcModel.UPDATE_RESULT";
	public static MASTER_RESULT = "chcModel.MASTER_RESULT";
	public static UPDATE_RED = "chcModel.UPDATE_RED";
	public static SELECT_VIEW = "chcModel.SELECT_VIEW";
	public static OPEN_LV = 560;
	public static MAGIC_RATIO_ATTR_ID = 325;
	public static POS_COUNT = 10;
	public static LinePos = [0, 120, 240, 180, -60, 60]
	public static LinePos2 = [0, 120, 240, 180, 60, -60]

	public constructor() {
		super()
		let local_WordManager = WordManager
		let local_ReddotManger = RedDotManager.GetInstance()
		let local_GoodsModel = GoodsModel.GetInstance()
		let _data_dic_ = []
		let _master_dic_ = []
		let _timer_dic_ = []
		let _evo_color_ = 2
		this._goods_dic_ = [];
		this._stype_count = 5;
		this.DefineConstant = () => {
			//this:GetGameConfig("config_constellation_forge_kv",(cfg?) => {
			// [ts2lua]cfg下标访问可能不正确
			//_evo_color_ = Config.Constellationforgekv[4].value
			//this:DestoryGameConfig("config_constellation_forge_kv")
			//}
			//)
			//this:GetGameConfig("config_constellation_page",(cfg?) => {
			//this._stype_count = Util.TableSize(cfg)
			//this:DestoryGameConfig("config_constellation_page")
			//}
			//)
		}

		this.SetInfoByType = (cfg1, cfg2, type?, data?) => {
			let dic = []
			for (let _tmpi in data.equip_list) {
				let vo = data.equip_list[_tmpi]
				dic[vo.pos] = vo
			}
			data.equip_dic = dic
			if (!_data_dic_[type]) {
				_data_dic_[type] = []
			}
			_data_dic_[type][data.type_id] = data
			if (type == chcModel.CHCTYPE.SOUL) {
				this.CheckReddotSoul(cfg1, data.type_id)
			} else {
				this.CheckReddot(cfg2, type, data.type_id)
			}
			this.Fire(chcModel.UPDATE_INFO, type, data.type_id, data)
		}

		this.GetInfoByType = (type?) => {
			return _data_dic_[type]
		}

		this.GetInfoByStype = (type?, stype?) => {
			if (_data_dic_[type]) {
				return _data_dic_[type][stype]
			}
		}

		this.GetDataByPos = (type?, stype?, pos?) => {
			let data = this.GetInfoByStype(type, stype)
			if (data && data.equip_dic) {
				return data.equip_dic[pos]
			}
		}

		this.SetMasterByType = (type?, data?) => {
			let dic = []
			for (let _tmpi in data.master_list) {
				let vo = data.master_list[_tmpi]
				dic[vo.master_lv] = vo
			}
			data.master_dic = dic
			if (!_master_dic_[type]) {
				_master_dic_[type] = []
			}
			_master_dic_[type][data.type_id] = data
			this.CheckReddotMaster(type, data.type_id)
			this.Fire(chcModel.UPDATE_MASTER, type, data.type_id, data)
		}
		
		this.UpdateMasterRed = () => {
			for (let type in _master_dic_){
				for (let type_id in _master_dic_[type]){
					this.CheckReddotMaster(type, type_id)
				}
			}
		}

		this.GetMasterByType = (type?) => {
			return _master_dic_[type]
		}

		this.GetMasterByStype = (type?, stype?) => {
			if (_master_dic_[type]) {
				return _master_dic_[type][stype]
			}
		}

		this.GetMasterByLv = (type?, stype?, lv?) => {
			let data = this.GetMasterByStype(type, stype)
			if (data && data.master_dic) {
				return data.master_dic[lv]
			}
		}

		this.GetEquipList = (cfg, type?, stype?) => {
			if(!cfg){
				return
			}
			let list = []
			let elist = GoodsModel.GetInstance().GetStarEquipListBuyPage(stype)
			let is_all = type == chcModel.CHCTYPE.STREN
			for (let _tmpi in elist) {
				let vo = elist[_tmpi]
				//if (vo && (is_all || Config.Constellationpos[vo.cell].type == 1)) {
				if (vo && (is_all || cfg[vo.cell].type == 1)) {
					table.insert(list, { type: type, stype: stype, vo: vo })
				}
			}
			return list
		}

		this.GetAttrStr = (attr_list?, color?, spec_str?) => {
			if (spec_str == null) {
				spec_str = "："
			}
			let str = ""
			if (!attr_list) {
				return str
			}
			let i = 0
			do {
				let attr = attr_list[i]
				let line = (i + 1 != attr_list.length) && "<br>" || ""
				let value = local_WordManager.ConvertToPercentValue(attr[0], attr[1])
				let val_str = (color && Util.HtmlColorTxt(value, color) || value)
				str = str + local_WordManager.GetProperties(attr[0]) + spec_str + val_str + line
				i = i + 1
			} while ((i < attr_list.length))
			return str
		}

		this.GetTypeStr = (type?) => {
			if (type == 1) {
				return "强化"
			} else if (type == 2) {
				return "进化"
			} else if (type == 3) {
				return "觉醒"
			} else if (type == 4) {
				return "启灵"
			}
		}

		this.GetReddotType = (type?) => {
			if (type == 1) {
				return ModuleType.CHC_STREN
			} else if (type == 2) {
				return ModuleType.CHC_EVO
			} else if (type == 3) {
				return ModuleType.CHC_MAGIC
			} else if (type == 4) {
				return ModuleType.CHC_SOUL
			}
		}

		this.GetReddotTypeMaster = (type?) => {
			if (type == 1) {
				return ModuleType.CHC_STREN_M
			} else if (type == 3) {
				return ModuleType.CHC_MAGIC_M
			}
		}

		this.GetNameCFG = (type?) => {
			return
			/*
			if (type == 1) {
				return Config.Constellationstrength //"config_constellation_strength"
			} else if (type == 2) {
				return Config.Constellationevolution  //"config_constellation_evolution"
			} else if (type == 3) {
				return Config.Constellationenchantment //"config_constellation_enchantment"
			} else if (type == 4) {
				return Config.Constellationspirit //"config_constellation_spirit"
			}
			*/
		}

		this.GetNormalPosList = (pcfg?) => {
			let list = []
			for (let key in pcfg) {
				// [ts2lua]pcfg下标访问可能不正确
				if (pcfg[key].type == 1) {
					// [ts2lua]pcfg下标访问可能不正确
					table.insert(list, pcfg[key])
				}
			}
			return list
		}

		this.StartTimer = (key?, delta?, func?) => {
			this.ClearTimer(key)
			let timer = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
			let data = [func = func, timer = timer]
			_timer_dic_[key] = data
		}

		this.ClearTimer = (key?) => {
			if (_timer_dic_[key]) {
				let data = _timer_dic_[key]
				if (data && data.timer) {
					GlobalTimerQuest.CancelQuest(data.timer)
				}
				_timer_dic_[key] = null
			}
		}

		this.GetTimerData = (key?) => {
			return _timer_dic_[key]
		}

		this.DicToList = (dic?) => {
			let list = []
			for (let key in dic) {
				table.insert(list, dic[key])
			}
			return list
		}

		this.CheckReddot = (cfgName, type?, stype?) => {
			if (!cfgName){
				return
			}
			let is_act = StarEquipModel.GetInstance().StarEquipIsActive(stype)
			if (!is_act) {
				return
			}
			let rtype = this.GetReddotType(type)
			//let cfgName = this.GetNameCFG(type)
			this.ClearReddotByStype(type, stype)
			let elist = local_GoodsModel.GetStarEquipListBuyPage(stype)
			for (let _tmpi in elist) {
				let vo = elist[_tmpi]
				if (vo) {
					let key = stype * 10000 + vo.cell
					let edata = this.GetDataByPos(type, stype, vo.cell)
					let lv = edata && edata.lv || 0
					let ccfg = cfgName[stype + "@" + vo.cell + "@" + lv]
					if (ccfg) {
						let attr_num = (edata && (edata.attr_num) || (0))
						if (type == chcModel.CHCTYPE.EVO && (vo.color < _evo_color_ || attr_num < 2)) {
						} else {
							let cost_list = JSON.parse(ccfg.cost)
							if (cost_list.length < 1) {
							} else {
								let can = true
								for (let _tmpi in cost_list) {
									let cVo = cost_list[_tmpi]
									let type_id = local_GoodsModel.GetMappingTypeId(cVo[0], cVo[1])[0]
									let own = local_GoodsModel.GetTypeGoodsNum(type_id)
									if (own < Number(cVo[2])) {
										can = false
										break
									}
								}
								local_ReddotManger.SetAnyRedStatus(rtype, key, can)
							}
						}
					}
				}
			}
			this.Fire(chcModel.UPDATE_RED)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
		}

		this.CheckReddotSoul = (cfg, stype?) => {
			if (!cfg) {
				return
			}
			let is_act = StarEquipModel.GetInstance().StarEquipIsActive(stype)
			if (!is_act) {
				return
			}
			let type = chcModel.CHCTYPE.SOUL
			let rtype = this.GetReddotType(type)
			this.ClearReddotByStype(type, stype)
			//let info = this.GetInfoByStype(type, stype)
			let elist = local_GoodsModel.GetStarEquipListBuyPage(stype)
			let can = true
			for (let _tmpi in elist) {
				let vo = elist[_tmpi]
				if (vo) {
					let key = stype * 10000 + vo.cell
					let edata = this.GetDataByPos(type, stype, vo.cell)
					let is_spirit = (edata && (edata.is_spirit == 1) || (false))
					if (!is_spirit) {
						//let ccfg = Config.Constellationspirit[stype + "@" + vo.cell]
						let ccfg = cfg[stype + "@" + vo.cell]
						if (ccfg) {
							let cost_list = JSON.parse(ccfg.cost)
							if (cost_list.length < 1) {
							} else {
								for (let _tmpi in cost_list) {
									let cVo = cost_list[_tmpi]
									let type_id = local_GoodsModel.GetMappingTypeId(cVo[0], cVo[1])[0]
									let own = local_GoodsModel.GetTypeGoodsNum(type_id)
									if (own < Number(cVo[2])) {
										can = false
										break
									}
								}
								local_ReddotManger.SetAnyRedStatus(rtype, key, can)
							}
						}
					}
				}
			}
			this.Fire(chcModel.UPDATE_RED)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
		}

		this.CheckReddotMaster = (type?, stype?) => {
			if (type != chcModel.CHCTYPE.STREN && type != chcModel.CHCTYPE.MAGIC) {
				return
			}
			let is_act = StarEquipModel.GetInstance().StarEquipIsActive(stype)
			if (!is_act) {
				return
			}
			let rtype = this.GetReddotTypeMaster(type)
			local_ReddotManger.SetAnyRedStatus(rtype, stype, false)
			let info = this.GetMasterByStype(type, stype)
			if (!info) {
				return
			}
			let can = false
			for (let _tmpi in info.master_list) {
				let vo = info.master_list[_tmpi]
				if (vo.status == 1) {
					can = true
					break
				}
			}
			local_ReddotManger.SetAnyRedStatus(rtype, stype, can)
			this.Fire(chcModel.UPDATE_RED)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
		}

		this.GetReddotAll = () => {
			return local_ReddotManger.CheckAnyRedStatusMultModule(chcModel.RED_LIST)
		}

		this.GetReddotOne = (type?, stype?, pos?) => {
			let rtype = this.GetReddotType(type)
			return local_ReddotManger.CheckAnyRedStatus(rtype, stype * 10000 + pos)
		}

		this.GetReddotByType = (type?) => {
			//let rtype = this.GetReddotType(type)
			let i = 1
			do {
				if (this.GetReddotByStype(type, i)) {
					return true
				}
				i = i + 1
			} while ((i <= this._stype_count))
			return false
		}

		this.GetReddotByStype = (type?, stype?) => {
			let rtype = this.GetReddotType(type)
			let i = 1
			do {
				if (local_ReddotManger.CheckAnyRedStatus(rtype, stype * 10000 + i)) {
					return true
				}
				i = i + 1
			} while ((i <= chcModel.POS_COUNT))
			if (type == chcModel.CHCTYPE.STREN || type == chcModel.CHCTYPE.MAGIC) {
				rtype = this.GetReddotTypeMaster(type)
				return local_ReddotManger.CheckAnyRedStatus(rtype, stype)
			}
			return false
		}

		this.ClearReddotByStype = (type?, stype?) => {
			let rtype = this.GetReddotType(type)
			let i = 1
			do {
				local_ReddotManger.SetAnyRedStatus(rtype, stype * 10000 + i, null)
				i = i + 1
			} while ((i <= chcModel.POS_COUNT))
		}

		this.GetFuncLvAll = (type?, stype?) => {
			let info = this.GetInfoByStype(type, stype)
			if (!info) {
				return 0
			}
			let lv = 0
			for (let _tmpi in info.equip_list) {
				let vo = info.equip_list[_tmpi]
				lv = lv + vo.lv
			}
			return lv
		}

		this.UpdateEquipHandle = (cfg, cfg1, cfg3, cfg4, scmd?, is_off?) => {
			if (!cfg) {
				return
			}
			//let page = Config.Constellationequip[scmd.goods_type_id].page
			let page = cfg[scmd.goods_type_id].page
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(scmd.goods_type_id)
			let data = chcModel.GetInstance().GetDataByPos(chcModel.CHCTYPE.STREN, page, basic.subtype)
			if (data) {
				data.equip_id = (is_off && (0) || (scmd.goods_id))
			}
			data = chcModel.GetInstance().GetDataByPos(chcModel.CHCTYPE.MAGIC, page, basic.subtype)
			if (data) {
				data.equip_id = (is_off && (0) || (scmd.goods_id))
			}
			data = chcModel.GetInstance().GetDataByPos(chcModel.CHCTYPE.SOUL, page, basic.subtype)
			if (data) {
				data.equip_id = (is_off && (0) || (scmd.goods_id))
			}
			this.CheckReddot(cfg1, chcModel.CHCTYPE.STREN, page)
			this.CheckReddot(cfg3, chcModel.CHCTYPE.MAGIC, page)
			this.CheckReddot(cfg4, chcModel.CHCTYPE.SOUL, page)
			this.Fire(chcModel.REQUEST_PROTO, 23220, "c", page)
		}

		this.CheckEquipReStype = (config_constellation_pos, type?) => {
			let num = this._stype_count
			let i = 1
			do {
				let list = this.GetEquipList(config_constellation_pos, type, i)
				if (list.length > 0) {
					return i
				}
				i = i + 1
			} while ((i <= num))
			return 0
		}
	}

	public static GetInstance() {
		if (!chcModel.Instance) {
			chcModel.Instance = new chcModel()
		}
		return chcModel.Instance
	}
}
window["chcModel"] = chcModel