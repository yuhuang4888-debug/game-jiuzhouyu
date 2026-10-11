import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "./RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { SecretTreasureMainViewIndex } from "./LungModel"
import { MainFunc } from "./MainUIModel"
import { CompositeModel } from "./CompositeModel"

export class UnrealModel extends EventDispatcher {
	static REQUEST_CCMD_EVENT = "UnrealModel.REQUEST_CCMD_EVENT"
	static SELECT_BREAK_DOWN_ITEM = "UnrealModel.SELECT_BREAK_DOWN_ITEM"
	static UPDATE_EQUIP_STREN_DATA = "UnrealModel.UPDATE_EQUIP_STREN_DATA"
	static REFRESH_RED_ICON = "UnrealModel.REFRESH_RED_ICON"
	static STREN_SUCCESS = "UnrealModel.STREN_SUCCESS"
	static STAGE_SUCCESS = "UnrealModel.STAGE_SUCCESS"
	static STAGE_PREVIEW = "UnrealModel.STAGE_PREVIEW"
	static DECOMPOSE_PREVIEW = "UnrealModel.DECOMPOSE_PREVIEW"
	static UPDATE_CELL_UN_LOCK_STATE = "UnrealModel.UPDATE_CELL_UN_LOCK_STATE"
	static equip_count = 6
	static goods_type = 55
	static drop_base_color = 2

	static Instance: UnrealModel
	static EMPTY_BAG_DATA = { type_id: 0 };
	static DISMANTLE_STAGE = 2

	equip_stren_data

	bind_cost_goods = {
		"38040018": true,//紫晶
		"38040019": true,//迷幻结晶
		"38040028": true,//迷幻源晶

	}

	static RedType = {
		Decompose: 0,
		Stren: 1,
		Strong: 2
	}

	InitCfg
	GetPosDropData
	GetColorDropData
	GetBagsByPosAndColor
	GetWearEquipByPos
	GetEquipList
	GetWearEquipInfo
	GetEquipPosName
	GetBagByColors
	SetStrenData
	GetStrenData
	RefreshRed
	GetIconRedDot
	GetBagRedDot
	RefreshDecomposeRed
	GetDecomposeRedDot
	RefreshStrenRed
	GetStrenRedDot
	RefreshUnrealWearRed
	GetWearRedDot
	GetEquipCanUp
	GetUnrealData
	GetKeyValue
	GetUnrealStrenMax
	GetUnrealStrenValue
	GetUnrealStageValue
	GetUnrealMaxStage
	SetDecomposePreviewData
	GetDecomposePreviewData
	SetStagePreviewData
	GetStagePreviewData
	SetUnLockCellList
	CheckCellUnLockState
	RefreshDismantleRed
	UnrealDismantleRedState
	GetBaseRatingScore
	CalAttrPower
	CheckUnrealQuality
	RefreshUnrealWearRedSingle

	lock_cell_dic = []
	dismantle_red
	alert_decompose = false
	public constructor() {
		super()
		// this.InitCfg()
		let local_UnrealModel = UnrealModel,
			local_Config = Config,
			goods_model = GoodsModel.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
			role_mgr = RoleManager.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_JSON = JSON,
			//_bag_red_ = false,
			_decompose_red_ = false,
			_stren_red_ = false,
			_wear_red_,
			decompose_preview_data_,
			stage_preview_data_
		this.InitCfg = () => {
			// if (!this._cfg_dic)
			// 	this._cfg_dic = {}
			// ResManager.GetInstance().LockLoadModuleConfig("UnrealModel")
			// ResManager.GetInstance().UnlockLoadModuleConfig("UnrealModel")
		}

		this.GetPosDropData = () => {
			let drop = []
			drop.push({ "id": 0, content: "不筛选" })
			for (let i = 1; i <= local_UnrealModel.equip_count; i++) {
				let key = `${local_UnrealModel.goods_type}@${i}`
				let cfg = local_Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key]
				if (cfg)
					drop.push({ "id": i, content: cfg.subtype_name, cond: cfg.subtype })
			}
			return drop
		}

		this.GetColorDropData = () => {
			let drop = []
			drop.push({ "id": 0, content: "不筛选" })
			for (let i = 0; i < 4; i++) {
				let color = i + local_UnrealModel.drop_base_color
				drop.push({ "id": i, content: `${ColorUtil.GetColorName(color)}以上`, cond: color })
			}
			return drop
		}

		this.GetBagsByPosAndColor = (pos, color) => {
			let bag_list = goods_model.unrealbag_goods_list
			let list = []
			for (let info of bag_list) {
				if (pos && info.subtype != pos) continue
				if (color && info.color < color) continue
				list.push(info)
			}
			list.sort((a, b) => { return b.rating - a.rating })
			return list
		}


		this.GetWearEquipByPos = (pos) => {
			if (pos != undefined) {
				let wear_unreal_list = goods_model.wear_unreal_list
				return wear_unreal_list && wear_unreal_list[pos - 1]
			}
		}

		this.GetEquipList = () => {
			let equip_list = {}
			let wear_unreal_list = goods_model.wear_unreal_list
			for (let equip of wear_unreal_list) {
				equip_list[equip.subtype - 1] = equip
			}
			return equip_list
		}

		this.GetWearEquipInfo = (goods_id) => {
			return goods_model.wear_unreal_dic[goods_id]
		}

		this.GetEquipPosName = (pos: number) => {
			let key = `${local_UnrealModel.goods_type}@${pos}`
			let cfg = local_Config.PRELOAD_SERVER_CONFIG.GoodsSubtype[key]
			return cfg ? cfg.subtype_name : ""
		}

		this.GetBagByColors = (colors_list) => {
			let bag_list = goods_model.unrealbag_goods_list
			let list = []
			for (let info of bag_list) {
				for (let color of colors_list) {
					if (info.color == color)
						list.push(info)
				}
			}
			list.sort((a, b) => { return b.rating - a.rating })
			return list
		}


		this.SetStrenData = (data) => {
			if (!this.equip_stren_data)
				this.equip_stren_data = {}
			let bool = false
			if (!this.equip_stren_data[data.cell]) {
				bool = true
			}
			this.equip_stren_data[data.cell] = data
			if (bool) {
				this.RefreshStrenRed()
			}
		}

		this.GetStrenData = (cell) => {
			if (!this.equip_stren_data)
				this.equip_stren_data = {}
			return this.equip_stren_data[cell]
		}


		this.RefreshRed = (refresh = true) => {
			let unreal_red = CompositeModel.GetInstance().GetUnrealRedDot() //灵饰合成红点
			let bool = this.GetDecomposeRedDot() || this.GetWearRedDot() || this.GetStrenRedDot()||unreal_red

			local_GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Treasure)
			local_GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Unreal, bool)
		}

		this.GetIconRedDot = () => {
			return this.GetBagRedDot() || this.GetStrenRedDot()
		}

		this.GetBagRedDot = () => {
			return this.GetWearRedDot() || this.GetDecomposeRedDot()
		}


		//灵饰背包中,装备数量大于容量的90%时,在主界面助战选项卡--灵饰页签--分解功能按钮的右上角标小红点

		this.RefreshDecomposeRed = () => {
			let unrealbag_goods_list = goods_model.unrealbag_goods_list
			if (!unrealbag_goods_list) return false

			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_decoration_kv
			let count = unrealbag_goods_list.length
			let max_count = Number(this.GetKeyValue(1, cfgs))
			let bool = count / max_count >= 0.9
			if (_decompose_red_ != bool) {
				_decompose_red_ = bool
				this.Fire(local_UnrealModel.REFRESH_RED_ICON, local_UnrealModel.RedType.Decompose)
				local_GlobalEventSystem.Fire(update_window_red_event, "UnrealEnterView", 0, this.GetBagRedDot())
				this.RefreshRed()
			}
		}

		this.GetDecomposeRedDot = () => {
			return _decompose_red_
		}

		//满足佩戴着的任意一件装备强化或进阶消耗时.在主界面人物选项卡--灵饰图标--对应装备的部位图标--强化/进阶按钮的右上角标小红点

		this.RefreshStrenRed = (refresh = true) => {
			let wear_unreal_list = goods_model.wear_unreal_list
			if (!wear_unreal_list) return false

			let decoration_attr_cfg, decoration_level_max_cfg, decoration_level_cfg, decoration_stage_cfg, decoration_stage_max_cfg
			decoration_attr_cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_attr
			decoration_level_max_cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_level_max
			decoration_level_cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_level
			decoration_stage_cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_stage
			decoration_stage_max_cfg = Config.PRELOAD_SERVER_CONFIG.config_decoration_stage_max

			if (decoration_attr_cfg && decoration_level_max_cfg && decoration_level_cfg && decoration_stage_cfg && decoration_stage_max_cfg) {
				let bool = false
				for (let equip_info of wear_unreal_list) {
					let can_up = this.GetEquipCanUp(equip_info, decoration_attr_cfg, decoration_level_max_cfg, decoration_level_cfg, decoration_stage_cfg, decoration_stage_max_cfg)
					if (can_up) {
						bool = true
						break
					}
				}
				if (bool != _stren_red_) {
					_stren_red_ = bool
					local_GlobalEventSystem.Fire(update_window_red_event, "UnrealEnterView", 1, bool)
					this.RefreshRed()
				}
			}
		}

		this.GetStrenRedDot = () => {
			return _stren_red_
		}

		//若灵饰背包中存在评分比当前正在穿戴高的装备(部位相同),则在主界面人物--灵饰图标--灵饰背包页签的右上角显示小红点

		this.RefreshUnrealWearRed = () => {
			let bool = false
			let unrealbag_goods_list = goods_model.unrealbag_goods_list
			let wear_unreal_list = goods_model.wear_unreal_list
			if (unrealbag_goods_list && wear_unreal_list) {
				let role_lv = role_mgr.GetMainRoleVo().level
				for (let equip_info of unrealbag_goods_list) {
					if (role_lv >= equip_info.level) {
						let wear_type_equip = wear_unreal_list[equip_info.equip_type - 1]
						let unlock = this.CheckCellUnLockState(equip_info.equip_type)
						if (unlock && (!wear_type_equip || equip_info.rating > wear_type_equip.rating)) {
							bool = true
							break
						}
					}
				}
			}
			if (bool != _wear_red_) {
				_wear_red_ = bool
				this.Fire(local_UnrealModel.REFRESH_RED_ICON, local_UnrealModel.RedType.Decompose)
				local_GlobalEventSystem.Fire(update_window_red_event, "UnrealEnterView", 0, this.GetBagRedDot())
				this.RefreshRed()
			}
		}

		this.RefreshUnrealWearRedSingle = (equip_type) => {
			if(!this.CheckCellUnLockState(equip_type)){
				return false
			}
			let bool = false
			let unrealbag_goods_list = goods_model.unrealbag_goods_list
			let wear_unreal_list = goods_model.wear_unreal_list
			if (unrealbag_goods_list && wear_unreal_list) {
				let role_lv = role_mgr.GetMainRoleVo().level
				for (let equip_info of unrealbag_goods_list) {
					if (role_lv >= equip_info.level && equip_info.equip_type == equip_type) {
						let wear_type_equip = wear_unreal_list[equip_type - 1]
						if (!wear_type_equip || equip_info.rating > wear_type_equip.rating) {
							bool = true
							break
						}
					}
				}
			}
			return bool
		}

		this.GetWearRedDot = () => {
			return _wear_red_
		}


		this.GetEquipCanUp = (equip_info, decoration_attr_cfg, decoration_level_max_cfg, decoration_level_cfg, decoration_stage_cfg, decoration_stage_max_cfg) => {
			if (!equip_info) return false
			let attr_cfg = this.GetUnrealData(equip_info.type_id, decoration_attr_cfg)
			let stage = 0
			if (attr_cfg) {
				stage = attr_cfg.stage
			}
			let max_key = `${equip_info.equip_type}@${stage}@${equip_info.color}`
			let max_cfg = this.GetUnrealStrenMax(max_key, decoration_level_max_cfg)
			if (!max_cfg || !max_cfg.limit_level) {
				return false
			}
			let cost
			let stren_data = this.GetStrenData(equip_info.cell)
			let now_stren = stren_data ? stren_data.level : 0
			if (max_cfg.limit_level <= now_stren) {
				let stage_cfg = this.GetUnrealStageValue(equip_info.type_id, decoration_stage_cfg)
				let max_stage = this.GetUnrealMaxStage(decoration_stage_max_cfg)
				if (stage_cfg && stage_cfg.new_goods_id && max_stage > stage)
					cost = local_JSON.parse(stage_cfg.cost)
			}
			else {
				let stren_key = `${equip_info.equip_type}@${now_stren}`
				let stren_cfg = this.GetUnrealStrenValue(stren_key, decoration_level_cfg)
				if (stren_cfg)
					cost = local_JSON.parse(stren_cfg.cost)
			}
			if (cost) {

				let bool = true
				for (let vo of cost) {
					let [type_id, lock] = goods_model.GetMappingTypeId(vo[0], vo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						let my_count = goods_model.GetTypeGoodsNum(type_id)
						let cost_count = vo[2]
						if (my_count < cost_count) {
							bool = false
							break
						}
					}
				}
				return bool

			}
			return false
		}

		this.GetUnrealData = (type_id, decoration_attr_cfg) => {
			return decoration_attr_cfg[type_id]
		}

		this.GetKeyValue = (key, decoration_kv_cfg) => {
			return decoration_kv_cfg[key].value
		}

		this.GetUnrealStrenMax = (key, decoration_level_max_cfg) => {
			return decoration_level_max_cfg[key]
		}

		this.GetUnrealStrenValue = (key, decoration_level_cfg) => {
			return local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_decoration_level.name, key, false, decoration_level_cfg)
		}

		this.GetUnrealStageValue = (key, decoration_stage_cfg) => {
			return decoration_stage_cfg[key]
		}

		this.GetUnrealMaxStage = (decoration_stage_max_cfg) => {
			let limit_stage = 0
			let role_lv = role_mgr.GetMainRoleVo().level
			for (let key in decoration_stage_max_cfg) {
				let cfg = decoration_stage_max_cfg[key]
				if (cfg.player_level > role_lv) {
					break
				}
				limit_stage = cfg.limit_stage
			}

			return limit_stage
		}

		this.SetDecomposePreviewData = (data) => {
			decompose_preview_data_ = data
			this.Fire(local_UnrealModel.DECOMPOSE_PREVIEW, data.goods_id)
		}


		this.GetDecomposePreviewData = () => {
			return decompose_preview_data_
		}


		this.SetStagePreviewData = (data) => {
			stage_preview_data_ = data
			this.Fire(local_UnrealModel.STAGE_PREVIEW, data.goods_id)
		}

		this.GetStagePreviewData = () => {
			return stage_preview_data_
		}

		this.SetUnLockCellList = (scmd?) => {
			this.lock_cell_dic = []
			for (let _ = 0; _ < scmd.cell_list.length; _++) {
				var vo = scmd.cell_list[_]
				this.lock_cell_dic[vo.cell] = true
			}
			this.RefreshUnrealWearRed()
			this.RefreshStrenRed()
			this.Fire(UnrealModel.UPDATE_CELL_UN_LOCK_STATE)
		}

		this.CheckCellUnLockState = (cell?) => {
			let bool = false
			if (this.lock_cell_dic && this.lock_cell_dic[cell]) {
				bool = true
			}
			return bool
		}

		this.RefreshDismantleRed = () => {
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_decoration_attr
			let bool = false
			let unrealbag_goods_list = goods_model.unrealbag_goods_list
			let wear_unreal_list = goods_model.wear_unreal_list
			if (unrealbag_goods_list && wear_unreal_list) {
				for (let _tmpi in unrealbag_goods_list) {
					var equip_info = unrealbag_goods_list[_tmpi]
					if (this.UnrealDismantleRedState(equip_info, cfgs)) {
						bool = true
						break
					}
				}
			}
			this.dismantle_red = bool
		}

		this.UnrealDismantleRedState = (bag_equip, cfgs) => {
			if (!bag_equip || !bag_equip.equip_type) {
				return false
			}
			let wear_equip = goods_model.wear_unreal_list[bag_equip.equip_type]
			if (!wear_equip) {
				return false
			}
			let bag_equip_cfg = this.GetUnrealData(bag_equip.type_id, cfgs)
			if (!bag_equip_cfg || bag_equip_cfg.stage <= 1) {
				return false
			}
			let wear_equip_cfg = this.GetUnrealData(wear_equip.type_id, cfgs)
			if (!wear_equip_cfg) {
				return false
			}
			if (bag_equip.color >= wear_equip.color && bag_equip_cfg.star >= wear_equip_cfg.star) {
				return false
			}
			return true
		}

		this.GetBaseRatingScore = (color_attr?, stage?) => {
			if (!color_attr) {
				return 0
			}
			if (typeof (color_attr) == "string") {
				color_attr = ErlangParser.GetInstance().Parse(color_attr)
			}

			let score = 0
			let total_score = 0
			let len
			let attr
			for (let _ in color_attr) {
				var data = color_attr[_]
				len = data[2].length
				score = 0
				for (let _ in data[2]) {
					var data1 = data[2][_]
					attr = data1[1]
					score = score + this.CalAttrPower([[attr[1], attr[2]]], stage)
				}

				total_score = total_score + Math.round(score / len) * data[1]
			}
			return total_score
		}

		this.CalAttrPower = (attr_list?, stage?) => {
			let base_arr_coes = [
				10,
				0.5,
				10,
				10,
				10,
				10,
				10,
				10,
			]
			let special_arr_coes = {
				"11": 8,
				"12": 8,
				"13": 8,
				"14": 8,
				"19": 4.8,
				"20": 4.8,
				"21": 2.4,
				"22": 2.4,
				"23": 1.2,
				"24": 1.2,
				"25": 1.2,
				"26": 1.2,
				"27": 2.8,
				"28": 2.8,
			}
			let stage_coes = {
				"1": 1,
				"2": 1,
				"3": 1,
				"5": 1,
				"7": 1,
				"9": 1,
				"18": 1,
				"10": 22,
				"11": 26,
				"12": 30,
				"13": 36,
				"14": 42,
				"15": 48,
				"16": 54,
			}
			let CalSpecialAttrPower = (val?) => {
				let value = 0
				let special_coe = special_arr_coes[Number(val[0])]
				let stage_coe = stage_coes[10]
				if (special_coe && stage_coe) {
					value = special_coe * Number(val[1]) * stage_coe
				}
				return value
			}

			let coe
			let power = 0
			for (let _tmpi in attr_list) {
				var val = attr_list[_tmpi]
				coe = base_arr_coes[Number(val[0])]
				if (coe) {
					power = power + coe * Number(val[1])
				} else {
					power = power + CalSpecialAttrPower(val)
				}
			}
			return Math.round(power)
		}
		this.CheckUnrealQuality = (atype_id?, btype_id?, attr_cfg?) => {
			let cfga = this.GetUnrealData(atype_id, attr_cfg)
			let cfgb = this.GetUnrealData(btype_id, attr_cfg)
			if (cfga && cfgb) {
				return cfga.star > cfgb.star
			}
			return false
		}
	}



	public static GetInstance() {
		if (!UnrealModel.Instance) {
			UnrealModel.Instance = new UnrealModel()
		}
		return UnrealModel.Instance
	}



}
window["UnrealModel"] = UnrealModel