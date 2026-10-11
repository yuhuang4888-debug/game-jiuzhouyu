import { Alert, Alert_Type } from "../alert/Alert"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GameResPath } from "../util/GameResPath"
import { Status } from "../util/Status"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, LoadLuaConfigAB, NotEnougnDiamond, Trim, Util } from "../util/Util"
import { BagModel } from "./BagModel"
import { EquipModel, EquipEvent } from "./EquipModel"
import { HolySealModel } from "./HolySealModel"
import { LungModel } from "./LungModel"
import { MonBookModel } from "./MonBookModel"
import { RevelationModel } from "./RevelationModel"
import { StarEquipModel } from "./StarEquipModel"
import { OutLineModel } from "./OutLineModel"
import { DailyModel } from "./DailyModel"
import { longlangModel } from "./longlangModel"
import { OnHookModel } from "./OnHookModel"
import { ViewPopLevelModel } from "./ViewPopLevelModel"
import { ShopEvent, ShopModel, ShopMoneyType } from "./ShopModel"
import { BossModel } from "./BossModel"
import { BaseDungeonModel } from "./BaseDungeonModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GodBeastModel } from "./GodBeastModel"
export enum GoodsType {
	goods = 0,
	diamond = 1,
	bind_diamond = 2,
	coin = 3,
	guild_coin = 4,
	exp = 5,
	Gem = 14
}
window["GoodsType"] = GoodsType
export class GoodsModel extends EventDispatcher {
	SortStarEquipBagList
	CreateUnrealBagList
	CreateGodCourtList
	ResetWarehouseData
	starEquipBagList
	DeleteBeastEquipGoods
	CheckCoinEnough
	IsTreasureBagGoods
	ResetStarEquipList
	CreateReveEquipList
	godCourtBagMaxCell
	bag_goods_list: IGoods[]
	DeleteEquipGoods
	wear_lung_list
	CreateGodEquipList
	ReSetDynamic
	ResetBeastBagData
	CreateSpecialScoreList
	ResetBabyBagData
	UpdateSoulEquipGoods
	warehouse_max_cell
	GetDynamic
	baby_equip_dic
	UpdateDemonTalentGoods
	godCourtDic
	_isPlayerMessage
	DeleteSoulEquipGoods
	UpdateStarEquipList
	CreateStarEquipBagList
	partner_bag_goods_list
	lungbag_goods_list
	UpdateUnrealEquipGoods
	wear_rune_list
	GetStarEquipBuyPagePos
	wear_holy_seal_list
	UpdateLungEquipGoods
	SortPartnerBagList
	GetGoodsExchangeData
	UpdateLonglangGoods
	CreateEquipList
	GetGoodsBagCount
	guildRuneDic
	GetGiftBagCfg
	GetGiftBagCondLevel
	wear_soul_dic
	beastbag_goods_dic
	CreateDemonTalentBagList
	wear_holy_seal_dic
	SortLonglangBag
	holy_seal_bag_goods_list
	wear_partner_list
	GetRoleSpecGoodsNum
	CheckEquipNum
	getGoodCoolingData
	beastbag_type_dic
	coolingGoodsCanUse
	GetWearEquipByType
	ResetGodCourtList
	wear_beast_list
	starEquipDic
	needSortGodCourt
	partner_bag_type_dic
	GetBindGoodsVoFirstByTypeId
	treasure_goods_list
	UpdatePartnerBagGoods
	CreateLungEquipList
	GetMonBookList
	warehouse_goods_list
	GetGiftBagDynamic
	UpdateGodCourtList
	baby_bag_list
	hasSort
	SetBaseInfo
	UpdateTreasureBagGoods
	getSpiritEquipList
	bag_goods_max_cell
	SetEquipBaseInfo
	UpdateHorseBagGoods
	UpdateBeastBagGoods
	UpdateBagGoods
	UpdateHolySealBagGoods
	soulbag_type_dic
	rune_type_dic
	CreateRuneBagList
	resetReveEquipData
	SortHorseBagList
	AddGoodsToBag
	soulbag_goods_list
	RefreshIconRedDot
	onCoolingTimer
	CreateHorseEquipList
	starEquipBagMaxCell
	godCourtBagList
	cleanCoolingTimer
	UpdateLungBagGoods
	CreateGodCourtBagList
	revelation_bag_list
	wear_beast_dic
	GetRuneBagCount
	UpdateUnrealBagGoods
	IsEquip
	ResetPartnerBagData
	ResetStarEquipBagList
	setGoodCoolingData
	DeleteRuneEquipGoods
	wear_unreal_dic
	beastbag_goods_list
	GetBagGoodsNum
	UpdateRuneBagGoods
	ResetGodBagData
	unrealbag_goods_dic
	wear_rune_dic
	CreateStarEquipList
	DeleteLungEquipGoods
	GetGoodsVoByGoodsId
	SortWarehouseList
	GetGodBefullGoodsNum
	ResetUnrealBagData
	CreateGuildRuneList
	UpdateStarEquipBagList
	ResetRuneBagData
	baby_bag_dic
	CreateBeastBagList
	revelation_equip_list
	DeleteUnrealEquipGoods
	GetTypeGoodsNum
	MarketPlzGetTypeGoodsNum
	CreateHolySealEquipList
	CreateBabyBagList
	longlang_equip_dic
	god_bag_list
	GetUnBindGoodsVoFirstByTypeId
	UpdateHorseEquipGoods
	soulTypeGoodsNum
	longlang_bag_list
	ResetDemonTalentBagData
	SortHolySealBagList
	CreateRuneEquipList
	DeleteDynamic
	CreateUnrealEquipList
	wear_horse_list
	GetRuneBagDic
	runebag_goods_list
	ResetLungBagData
	GetTypeGoods
	soulTypeGoodsList
	GetStarEquipPageNum
	ResetlonglangBagData
	resetReveBagData
	delSpiritEquipList
	CreateTreasureList
	CreateLonglangEquipList
	CopyGoodsVo
	wear_god_dic
	RefreshtGoods
	SortBagGoodsList
	horse_bag_goods_dic
	UpdateGodBagGoods
	gift_bag_dynamic_call_back
	wear_soul_list
	changeSpiritEquipList
	CreateGodBagList
	DeleteHorseEquipGoods
	SortBabyList
	GetStarEquipListBuyPage
	UpdatePartnerEquipGoods
	GetEquipList
	wear_equip_list
	ResetHorseBagData
	UpdateBabyBagGoods
	wear_lung_dic
	CreateWarehouseList
	UpdateRuneEquipGoods
	ResetTreasureBagData
	refresh_CoolingGoods_RedDot
	CreateSoulBagList
	starEquipList
	CreateBagList
	UpdateEquipGoods
	UpdateSoulBagGoods
	SetGoodsExchangeData
	demontalent_bag_type_dic
	revelation_equip_dic
	UpdateRevelationEquip
	guildRuneList
	UpdateGodCourtBagList
	horse_bag_goods_list
	DeletePartnerEquipGoods
	UpdateGuildRuneList
	UpdateSpecialScore
	AddGoodsToWarehouse
	goods_use_dic
	UpdateWarehouseGoods
	CreatePartnerEquipList
	UpdateGodEquipGoods
	CreateBabyEquipList
	CreateReveBagList
	UpdateRevelationBag
	AddDynamic
	wear_soul_type_dic
	revelation_bag_dic
	ResetHolySealBagData
	GetSpecialScore
	ResetGuildRuneList
	revelation_type_dic
	partner_bag_goods_dic
	UpdateLonglangEquip
	SortTreasureBagList
	GetOneGoodsByTypeId
	CreateSoulEquipList
	SortGodCourtBagList
	longlang_equip_list
	demontalent_bag_list
	ResetBagData
	ResetGodCourtBagList
	CreateSpiritEquipList
	GetSoulBagDic
	CreateLonglangBagList
	CreateExtraAttr
	godCourtList
	CreateHolySealBagList
	UpdateBeastEquipGoods
	ResetSoulBagData
	wear_unreal_list
	GetMappingTypeId: (_type?, type_id?) => [type_id: number, is_lock: number]
	DeleteGoods
	unrealbag_goods_list
	CreatePartnerBagList
	DeleteGodEquipGoods
	GetBagGoodsDic
	goods_buff_list
	CreateBeastEquipList
	cleanCoolingDataById
	god_bag_type_dic
	GetGoodsBasicByTypeId
	horse_bag_type_dic
	UpdateHolySealEquipGoods
	CreateLungBagList
	UpdateBabyEquip
	GetEquipById
	CreateHorseBagList
	DeleteBabyEquip
	HaveHightExpBuff
	soulbag_goods_max_cell
	runebag_goods_max_cell
	horse_bag_goods_max_cell
	partner_bag_goods_max_cell

	private _expBookTips: boolean = false;

	public get expBookTips() {
		return this._expBookTips;
	}

	public set expBookTips(bool: boolean) {
		this._expBookTips = bool;
	}


	public static GOODS_POS_TYPE = {
		equip: 1,
		bag: 4,
		warehouse: 5,
		equipbag: 7,
		artifactbag: 8,
		treasurebag: 10,
		rune_bag: 11,
		rune: 12,
		spirit: 13,
		soul: 14,
		soul_bag: 15,
		beast: 16,
		beast_bag: 17,
		horse: 22,
		horse_bag: 32,
		partner: 23,
		partner_bag: 33,
		unreal: 28,
		unreal_bag: 29,
		holy_seal_bag: 30,
		holy_seal: 31,
		lung_equip: 34,
		lung_bag: 35,
		baby_equip: 36,
		baby_bag: 37,
		god_equip: 38,
		god_bag: 39,
		revelation_equip: 40,
		revelation_bag: 41,
		demon_talent_bag: 42,
		longlangbag: 43,
		longlangequip: 44,
		starEquipBag: 45,
		starEquip: 46,
		godCourtBag: 47,
		godCourt: 48,
		guildRune: 49
	}
	public static REQUEST_CCMD_EVENT = "REQUEST_CCMD_EVENT"
	public static FIGURE_ASK_EQUIPGOODS = "FIGURE_ASK_EQUIPGOODS"
	public static FIGURE_ASK_BAGGOODS = "FIGURE_ASK_BAGGOODS"
	public static FIGURE_ASK_EQUIPBAG = "FIGURE_ASK_EQUIPBAG"
	public static FIGURE_ASK_ARTIFACTBAG = "FIGURE_ASK_ARTIFACTBAG"
	public static FIGURE_ASK_ARTPROTECTBAG = "FIGURE_ASK_ARTPROTECTBAG"
	public static FIGURE_ASK_LUNGEQUIP = "FIGURE_ASK_LUNGEQUIP"
	public static CHANGE_EQUIPLIST = "CHANGE_EQUIPLIST"
	public static CHANGE_RUNELIST = "CHANGE_RUNELIST"
	public static CHANGE_RUNE_BAG_LIST = "CHANGE_RUNE_BAG_LIST"
	public static CHANGE_SPIRIT_LIST = "CHANGE_SPIRIT_LIST"
	public static CHANGE_TREASURE_BAG_LIST = "CHANGE_TREASURE_BAG_LIST"
	public static CHANGE_SOUL_BAG_LIST = "CHANGE_SOUL_BAG_LIST"
	public static CHANGE_SOUL_LIST = "CHANGE_SOUL_LIST"
	public static CHANGE_BEAST_BAG_LIST = "CHANGE_BEAST_BAG_LIST"
	public static CHANGE_BEAST_LIST = "CHANGE_BEAST_LIST"
	public static CHANGE_UNREAL_BAG_LIST = "CHANGE_UNREAL_BAG_LIST"
	public static CHANGE_UNREAL_LIST = "CHANGE_UNREAL_LIST"
	public static CHANGE_HOLY_SEAL_BAG_LIST = "CHANGE_HOLY_SEAL_BAG_LIST"
	public static CHANGE_HOLY_SEAL_LIST = "CHANGE_HOLY_SEAL_LIST"
	public static CHANGE_HORSE_BAG_LIST = "CHANGE_HORSE_BAG_LIST"
	public static CHANGE_HORSE_LIST = "CHANGE_HORSE_LIST"
	public static CHANGE_PARTNER_BAG_LIST = "CHANGE_PARTNER_BAG_LIST"
	public static CHANGE_PARTNER_LIST = "CHANGE_PARTNER_LIST"
	public static CHANGE_LUNG_LIST = "CHANGE_LUNG_LIST"
	public static CHANGE_LUNG_BAG_LIST = "CHANGE_LUNG_BAG_LIST"
	public static CHANGE_GOD_BAG_LIST = "CHANGE_GOD_BAG_LIST"
	public static CHANGE_GOD_LIST = "CHANGE_GOD_LIST"
	public static CHANGE_DEMON_TALENT_LIST = "CHANGE_DEMON_TALENT_LIST"
	public static CHANGE_GUILD_RUNE_LIST = "CHANGE_GUILD_RUNE_LIST"
	public static CREATE_BAG_LIST_FINISH = "CREATE_BAG_LIST_FINISH"
	public static USE_BAG_GOODS = "USE_BAG_GOODS"
	public static USE_BAG_GOODS_SUCCESS = "USE_BAG_GOODS_SUCCESS"
	public static CHANGE_GOODS_SUB_POS = "CHANGE_GOODS_SUB_POS"
	public static ASK_EXPAND_BAG = "ASK_EXPAND_BAG"
	public static CHANGE_BAG_LIST = "CHANGE_BAG_LIST"
	public static ON_SMELTING_EXP = "ON_SMELTING_EXP"
	public static DEVOUR_EQUIPMENT = "DEVOUR_EQUIPMENT"
	public static SMELTING_ARTIFACT = "SMELTING_ARTIFACT"
	public static REQUEST_GOODS_DYNAMIC = "REQUEST_GOODS_DYNAMIC"
	public static UPDATE_GOODS_NUM = "UPDATE_GOODS_NUM"
	public static SELL_GOODS = "SELL_GOODS"
	public static CHANGE_GOODS_DYNAMIC = "CHANGE_GOODS_DYNAMIC"
	public static UPDATE_SPECIAL_SCORE = "UPDATE_SPECIAL_SCORE"
	public static RESOLVE_GOODS = "RESOLVE_GOODS"
	public static UPDATE_GOODS_BUFF_DATA = "UPDATE_GOODS_BUFF_DATA"
	public static GET_GOODS_BUFF_LIST = "GET_GOODS_BUFF_LIST"
	public static GOODS_DECOMPOSE_SUCCESS = "GOODS_DECOMPOSE_SUCCESS"
	public static EQUIP_DYNAMIC_FINISH = "EQUIP_DYNAMIC_FINISH"
	public static MOVE_GOODS_POS = "MOVE_GOODS_POS"
	public static UPDATE_GOODS_EXCHANGE_DATA = "UPDATE_GOODS_EXCHANGE_DATA"
	public static BUY_SUCCESS = "BUY_SUCCESS"
	public static CHANGE_BAG_MAX_CELL = "CHANGE_BAG_MAX_CELL"
	public static RECEIVED_OPTIONAL_GIFT = "RECEIVED_OPTIONAL_GIFT"
	public static REQUEST_EXCHANGE_GOODS = "REQUEST_EXCHANGE_GOODS"
	public static EXCHANGE_GOODS = "EXCHANGE_GOODS"
	public static REQUEST_GIFT_BAG_MSG = "REQUEST_GIFT_BAG_MSG"
	public static REQUEST_GIFT_BAG_MSG_SUCCESS = "REQUEST_GIFT_BAG_MSG_SUCCESS"
	public static REQUEST_GOODS_COOLING = "REQUEST_GOODS_COOLING"
	public static REFRESH_COOLING_REDDOT = "REFRESH_COOLING_REDDOT"
	public static CHANGE_WAREHOUSE_LIST = "BE1"
	public static CREATE_WAREHOUSE_FINISH = "BE2"
	public static CHANGE_WAREHOUSE_MAX_CELL = "BE3"
	public static CHANGE_BABY_BAG = "BE4"
	public static CHANGE_BABY_EQUIP_LIST = "BE5"
	public static EXPECT_POWER = "BE6"
	public static CHANGE_REVE_EQUIP_LIST = "BE7"
	public static CHANGE_REVE_BAG_LIST = "BE8"
	public static CHANGE_LONGLANG_BAG = "BE9"
	public static CHANGE_LONGLANG_EQUIP = "BE10"
	public static CHANGE_STAREQUIP_BAG = "BE11"
	public static CHANGE_STAREQUIP = "BE12"
	public static GIFT_TYPE = 32
	public static CHANGE_GODCOURT_BAG = "BE13"
	public static CHANGE_GODCOURT = "BE14"
	public static CREATE_SPECIAL_SCORE_FINISH = "BE15"
	public static TRY_SHOW_ITEM_USE_VIEW = "BE16"
	static Instance: GoodsModel
	public static GetInstance() {

		if (!GoodsModel.Instance) {
			GoodsModel.Instance = new GoodsModel()
		}
		return GoodsModel.Instance


	}

	//function GoodsModel.__getters.isPlayerMessage()
	//return this._isPlayerMessage
	//}

	//function GoodsModel.__setters.isPlayerMessage(bool)
	//this._isPlayerMessage = bool
	//}

	public static GetGoodsIcon(type_id) {
		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, type_id, false)
		return cfg && cfg.goods_icon || 0
	}

	public static GetGoodsName(type_id) {
		let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, type_id, false)
		return goods && Trim(goods.goods_name) || ""
	}

	public static GetGoodsNameWithColorDark(type_id) {
		let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, type_id, false)
		return goods ? HtmlColorTxt(Trim(goods.goods_name), ColorUtil.GetColorDark(goods.color)) : ""
	}

	public static GetGoodsNameWithColorLight(type_id) {
		let goods = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, type_id, false)
		return goods ? HtmlColorTxt(Trim(goods.goods_name), ColorUtil.GetColorLight(goods.color)) : ""
	}

	public static GetGoodsPath(type_id) {
		let goods_icon = GoodsModel.GetGoodsIcon(type_id)
		return GameResPath.GetGoodsIconPath(goods_icon)
	}

	public static RewardKeyToNumber(reward_list) {
		for (let _tmpi in reward_list) {
			let info = reward_list[_tmpi]
			info[0] = info["style"]
			if (info["typeId"] != undefined) {
				info[1] = info["typeId"]
			} else if (info["reward"] != undefined) {
				info[1] = info["reward"]
			}
			info[2] = info["count"]
		}
		return reward_list
	}

	public constructor() {
		super()

		if (GoodsModel.Instance) {
			return
		}
		this.wear_equip_list = {}
		this.bag_goods_list = []
		this.warehouse_goods_list = []
		this.wear_rune_list = []
		this.wear_rune_dic = {}
		this.runebag_goods_list = []
		this.rune_type_dic = {}
		this.treasure_goods_list = []
		this.wear_soul_list = []
		this.wear_soul_dic = {}
		this.wear_soul_type_dic = {}
		this.soulbag_goods_list = []
		this.soulbag_type_dic = {}
		this.beastbag_goods_list = []
		this.beastbag_goods_dic = {}
		this.beastbag_type_dic = {}
		this.wear_beast_list = []
		this.wear_beast_dic = {}
		this.unrealbag_goods_list = []
		this.unrealbag_goods_dic = {}
		this.wear_unreal_list = []
		this.wear_unreal_dic = {}
		this.holy_seal_bag_goods_list = []
		this.wear_holy_seal_list = []
		this.wear_holy_seal_dic = {}
		this.horse_bag_goods_list = []
		this.horse_bag_goods_dic = {}
		this.horse_bag_type_dic = {}
		this.wear_horse_list = []
		this.partner_bag_goods_list = []
		this.partner_bag_goods_dic = {}
		this.partner_bag_type_dic = {}
		this.wear_partner_list = []
		this.wear_lung_list = []
		this.wear_lung_dic = {}
		this.lungbag_goods_list = []
		this.baby_bag_list = []
		this.baby_bag_dic = {}
		this.baby_equip_dic = {}
		this.god_bag_list = []
		this.god_bag_type_dic = {}
		this.wear_god_dic = {}
		this.revelation_bag_list = []
		this.revelation_bag_dic = {}
		this.revelation_equip_list = []
		this.revelation_equip_dic = {}
		this.revelation_type_dic = {}
		this.longlang_bag_list = []
		this.longlang_equip_list = []
		this.longlang_equip_dic = {}
		this.demontalent_bag_type_dic = {}
		this.demontalent_bag_list = []
		this.goods_buff_list = []
		this.goods_use_dic = {}
		this.starEquipBagList = []
		this.starEquipList = []
		this.starEquipDic = {}
		this.starEquipBagMaxCell = 100
		this.hasSort = false
		this._isPlayerMessage = false
		this.godCourtBagList = []
		this.godCourtList = []
		this.godCourtDic = {}
		this.godCourtBagMaxCell = 200
		this.bag_goods_max_cell = 100
		this.warehouse_max_cell = 100
		//结社铭文
		this.guildRuneList = []
		this.guildRuneDic = {}

		this.needSortGodCourt = true
		let local_GoodsModel = GoodsModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Config = Config
		let role_mgr = RoleManager.GetInstance()
		let wear_equip_dic_ = {}
		let bag_goods_dic_ = {}
		let warehouse_goods_dic_ = {}
		let runebag_goods_dic_ = {}
		let treasure_goods_dic_ = {}
		let soulbag_goods_dic_ = {}
		let unrealbag_type_dic_ = {}
		let holy_seal_bag_goods_dic_ = {}
		let wear_horse_dic_ = {}
		let wear_partner_dic_ = {}
		let lungbag_goods_dic_ = {}
		let baby_equip_list_ = []
		let god_bag_dic_ = {}
		let longlang_bag_dic_ = {}
		let demontalent_bag_dic_ = {}
		let dynamic_goods_dic_ = {}
		let request_dynamic_callback_list_ = []
		let bag_goodsType_dic_ = {}
		let first_dynamic_equip_ = false
		let special_score_dic_ = {}
		let spirte_dic_ = []
		let goods_exchange_dic_ = {}
		let coolingTimer_ = null
		let request_cooling_callback_ = {}
		let _CoolingGoodData_ = {}
		let cooling_time_dic_ = {}
		let starEquipBagDic = {}
		let godCourtBagDic = {}
		this.ResetBagData = () => {
			this.bag_goods_list = []
			bag_goods_dic_ = {}
			bag_goodsType_dic_ = {}
			this.goods_use_dic = {}
		}

		this.ResetWarehouseData = () => {
			warehouse_goods_dic_ = {}
			this.warehouse_goods_list = []
		}

		this.ResetRuneBagData = () => {
			this.runebag_goods_list = []
			runebag_goods_dic_ = {}
			this.rune_type_dic = {}
		}

		this.ResetTreasureBagData = () => {
			this.treasure_goods_list = []
			treasure_goods_dic_ = {}
		}

		this.ResetSoulBagData = () => {
			this.soulbag_goods_list = []
			soulbag_goods_dic_ = {}
			this.soulbag_type_dic = {}
		}

		this.ResetBeastBagData = () => {
			this.beastbag_goods_list = []
			this.beastbag_goods_dic = {}
			this.beastbag_type_dic = {}
		}

		this.ResetUnrealBagData = () => {
			this.unrealbag_goods_list = []
			this.unrealbag_goods_dic = {}
			unrealbag_type_dic_ = {}
		}

		this.ResetHolySealBagData = () => {
			this.holy_seal_bag_goods_list = []
			holy_seal_bag_goods_dic_ = {}
		}

		this.ResetHorseBagData = () => {
			this.horse_bag_goods_list = []
			this.horse_bag_goods_dic = {}
			this.horse_bag_type_dic = {}
		}

		this.ResetPartnerBagData = () => {
			this.partner_bag_goods_list = []
			this.partner_bag_goods_dic = {}
			this.partner_bag_type_dic = {}
		}

		this.ResetLungBagData = () => {
			this.lungbag_goods_list = []
			lungbag_goods_dic_ = {}
		}

		this.ResetBabyBagData = () => {
			this.baby_bag_dic = {}
			this.baby_bag_list = []
		}

		this.ResetGodBagData = () => {
			god_bag_dic_ = {}
			this.god_bag_type_dic = {}
			this.god_bag_list = []
		}

		this.ResetDemonTalentBagData = () => {
			demontalent_bag_dic_ = {}
			this.demontalent_bag_type_dic = {}
			this.demontalent_bag_list = []
		}

		this.ResetlonglangBagData = () => {
			longlang_bag_dic_ = {}
			this.longlang_bag_list = []
		}

		this.ResetStarEquipBagList = () => {
			starEquipBagDic = {}
			this.starEquipBagList = []
		}

		this.ResetStarEquipList = () => {
			this.starEquipDic = {}
			this.starEquipList = []
		}

		this.ResetGodCourtBagList = () => {
			godCourtBagDic = {}
			this.godCourtBagList = []
		}

		this.ResetGodCourtList = () => {
			this.godCourtList = []
			this.godCourtDic = {}
		}

		this.ResetGuildRuneList = () => {
			this.guildRuneList = []
			this.guildRuneDic = {}
		}

		this.CopyGoodsVo = (vo1?, vo2?) => {
			for (let index in vo2) {

				vo1[index] = vo2[index]
			}
		}

		this.CreateBagList = (list?) => {
			this.ResetBagData()

			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CREATE_BAG_LIST_FINISH)
			this.DelayFire(local_GoodsModel.CHANGE_BAG_LIST, list)
		}

		this.CreateWarehouseList = (list?) => {
			this.ResetWarehouseData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateWarehouseGoods(vo)
			}
			this.SortWarehouseList()
			this.Fire(local_GoodsModel.CREATE_WAREHOUSE_FINISH)
		}

		this.CreateRuneBagList = (list?) => {
			this.ResetRuneBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateRuneBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_RUNE_BAG_LIST, true)
		}

		this.CreateSoulBagList = (list?) => {
			this.ResetSoulBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateSoulBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_SOUL_BAG_LIST, true)
		}

		this.CreateBeastBagList = (list?) => {
			this.ResetBeastBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateBeastBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_BEAST_BAG_LIST)
		}

		this.CreateUnrealBagList = (list?) => {
			this.ResetUnrealBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateUnrealBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_UNREAL_BAG_LIST)
		}

		this.CreateHolySealBagList = (list?) => {
			this.ResetHolySealBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateHolySealBagGoods(vo)
			}
			this.SortHolySealBagList()
		}

		this.CreateLonglangBagList = (list?) => {
			this.ResetlonglangBagData()
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_draconic_equip
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateLonglangGoods(vo, cfgs)
			}
			this.SortLonglangBag()
			longlangModel.GetInstance().BetterEquipRed()
			longlangModel.GetInstance().RefreshDecRed(list)
			this.Fire(local_GoodsModel.CHANGE_LONGLANG_BAG, true)
		}

		this.CreateStarEquipBagList = (config_constellation_equip, list?) => {
			this.ResetStarEquipBagList()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateStarEquipBagList(vo, config_constellation_equip)
			}
			this.SortStarEquipBagList()
			StarEquipModel.GetInstance().UpdateEquipRed()
			StarEquipModel.GetInstance().CheckDevourRed(config_constellation_equip)
			this.Fire(local_GoodsModel.CHANGE_STAREQUIP_BAG)
		}

		this.CreateStarEquipList = (config_constellation_equip, list?) => {
			this.ResetStarEquipList()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateStarEquipList(vo, config_constellation_equip)
			}
			StarEquipModel.GetInstance().UpdateEquipRed()
			StarEquipModel.GetInstance().CheckDevourRed(config_constellation_equip)
			this.Fire(local_GoodsModel.CHANGE_STAREQUIP, list, true)
		}

		this.CreateGodCourtBagList = (list?) => {
			this.ResetGodCourtBagList()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateGodCourtBagList(vo)
			}
			if (this.needSortGodCourt) {
				this.SortGodCourtBagList()
			}
			this.Fire(local_GoodsModel.CHANGE_GODCOURT_BAG)
		}

		this.CreateGodCourtList = (list?) => {
			this.ResetGodCourtList()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateGodCourtList(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_GODCOURT)
		}

		this.CreateGuildRuneList = (list?) => {
			this.ResetGuildRuneList()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateGuildRuneList(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_GUILD_RUNE_LIST)
		}

		this.CreateHorseBagList = (list?) => {
			this.ResetHorseBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateHorseBagGoods(vo)
			}
			this.SortHorseBagList()
			this.Fire(local_GoodsModel.CHANGE_HORSE_BAG_LIST)
		}

		this.CreatePartnerBagList = (list?) => {
			this.ResetPartnerBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdatePartnerBagGoods(vo)
			}
			this.SortPartnerBagList()
			this.Fire(local_GoodsModel.CHANGE_PARTNER_BAG_LIST)
		}

		this.CreateLungBagList = (list?) => {
			this.ResetLungBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateLungBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_LUNG_BAG_LIST)
		}

		this.CreateBabyBagList = (list?) => {
			this.ResetBabyBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateBabyBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_BABY_BAG)
		}

		this.CreateBabyEquipList = (list?) => {
			baby_equip_list_ = []
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.baby_equip_dic[vo.goods_id] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_BABY_EQUIP_LIST)
		}

		this.UpdateBabyEquip = (vo?) => {
			let goodsVo = this.baby_equip_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteBabyEquip(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(baby_equip_list_, vo)
					this.baby_equip_dic[vo.goods_id] = vo
				}
			}
		}

		this.DeleteBabyEquip = (vo?) => {
			for (let index = 0; index < baby_equip_list_.length; index++) {
				if (baby_equip_list_[index] && Number(baby_equip_list_[index].goods_id) == Number(vo.goods_id)) {
					table.remove(baby_equip_list_, index)
					break
				}
			}
			delete this.baby_equip_dic[vo.goods_id]
		}

		this.CreateGodBagList = (list?) => {
			this.ResetGodBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateGodBagGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_GOD_BAG_LIST)
		}

		this.CreateDemonTalentBagList = (list?) => {
			this.ResetDemonTalentBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateDemonTalentGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_DEMON_TALENT_LIST)
		}

		this.CreateEquipList = (list?) => {
			let equip_mgr = EquipModel.GetInstance()
			this.wear_equip_list = {}
			wear_equip_dic_ = {}
			let vo = null
			let dynamic_count = 0
			if (list.length > 0) {
				for (let i = 0; i < list.length; i++) {
					vo = list[i]
					if (vo) {
						this.SetBaseInfo(vo)
						this.SetEquipBaseInfo(vo)
						wear_equip_dic_[vo.goods_id] = vo
						this.wear_equip_list[vo.equip_type] = vo
						if (!first_dynamic_equip_) {
							this.GetDynamic(
								vo.goods_id, () => {
									dynamic_count = dynamic_count + 1
									if (dynamic_count == list.length) {
										this.Fire(local_GoodsModel.EQUIP_DYNAMIC_FINISH)
										//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
										//local_GlobalEventSystem:Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Equip)
									}
								}
							)
							equip_mgr.Fire(EquipEvent.REQUEST_PROTO, 15250, "c", vo.equip_type)
							equip_mgr.Fire(EquipEvent.REQUEST_PROTO, 15204, "c", vo.equip_type)
							if (i == list.length - 1) {
								first_dynamic_equip_ = true
							}
						}
					}
				}
			}
			this.Fire(local_GoodsModel.CHANGE_EQUIPLIST)
		}

		this.GetEquipById = (goods_id?) => {
			return wear_equip_dic_[goods_id]
		}

		this.CreateRuneEquipList = (list?) => {
			this.wear_rune_list = []
			this.wear_rune_dic = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.wear_rune_dic[vo.goods_id] = vo
				this.wear_rune_list[vo.cell - 1] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_RUNELIST)
		}

		this.CreateSoulEquipList = (list?) => {
			this.wear_soul_list = []
			this.wear_soul_type_dic = {}
			this.wear_soul_dic = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.wear_soul_dic[vo.goods_id] = vo
				this.wear_soul_list[vo.cell - 1] = vo
				this.wear_soul_type_dic[vo.subtype] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_SOUL_LIST)
		}

		this.CreateBeastEquipList = (list?) => {
			this.wear_beast_list = []
			this.wear_beast_dic = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.wear_beast_dic[vo.goods_id] = vo
				this.wear_beast_list[vo.cell - 1] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_BEAST_LIST)
		}

		this.CreateUnrealEquipList = (list?) => {
			this.wear_unreal_list = []
			this.wear_unreal_dic = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.wear_unreal_dic[vo.goods_id] = vo
				this.wear_unreal_list[vo.cell - 1] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_UNREAL_LIST)
		}

		this.CreateHolySealEquipList = (list?) => {
			this.wear_holy_seal_list = []
			this.wear_holy_seal_dic = {}
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateHolySealEquipGoods(vo)
			}
			this.Fire(local_GoodsModel.CHANGE_HOLY_SEAL_LIST)
		}

		this.CreateLonglangEquipList = (list?) => {
			this.longlang_equip_list = []
			this.longlang_equip_dic = {}
			let cfgs = Config.PRELOAD_SERVER_CONFIG.config_draconic_equip
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateLonglangEquip(vo, cfgs)
			}
			longlangModel.GetInstance().RefreshDecRed()
			longlangModel.GetInstance().BetterEquipRed()
			this.Fire(local_GoodsModel.CHANGE_LONGLANG_EQUIP)
		}

		this.CreateHorseEquipList = (list?) => {
			this.wear_horse_list = []
			wear_horse_dic_ = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				wear_horse_dic_[vo.goods_id] = vo
				this.wear_horse_list[vo.cell - 1] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_HORSE_LIST)
		}

		this.CreatePartnerEquipList = (list?) => {
			this.wear_partner_list = []
			wear_partner_dic_ = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				wear_partner_dic_[vo.goods_id] = vo
				this.wear_partner_list[vo.cell - 1] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_PARTNER_LIST)
		}

		this.CreateLungEquipList = (list?) => {
			this.wear_lung_list = []
			this.wear_lung_dic = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.wear_lung_dic[vo.goods_id] = vo
				this.wear_lung_list[vo.cell - 1] = vo
			}

			LungModel.GetInstance().SetLungTotalLevel()
			this.Fire(local_GoodsModel.CHANGE_LUNG_LIST)
		}

		this.CreateGodEquipList = (list?) => {
			this.wear_god_dic = {}
			let vo = null
			for (let i = 0; i < list.length; i++) {
				vo = list[i]
				this.SetBaseInfo(vo)
				this.wear_god_dic[vo.goods_id] = vo
			}
			this.Fire(local_GoodsModel.CHANGE_GOD_LIST)
		}

		this.CreateReveEquipList = (list?) => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory(
				"config_revelation_equip_attr",
				(cfgs) => {
					this.resetReveEquipData()
					for (let _tmpi in list) {
						let vo = list[_tmpi]
						this.UpdateRevelationEquip(vo, cfgs)
					}
					this.Fire(local_GoodsModel.CHANGE_REVE_EQUIP_LIST)
				}
				, false)
		}

		this.resetReveEquipData = () => {
			this.revelation_equip_dic = {}
			this.revelation_equip_list = []
		}

		this.resetReveBagData = () => {
			this.revelation_bag_dic = {}
			this.revelation_bag_list = []
			this.revelation_type_dic = {}
		}

		this.CreateReveBagList = (list?) => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory(
				"config_revelation_equip_attr",
				(cfgs) => {
					this.resetReveBagData()
					for (let _tmpi in list) {
						let vo = list[_tmpi]
						this.UpdateRevelationBag(vo, cfgs)
					}
					this.Fire(local_GoodsModel.CHANGE_REVE_BAG_LIST)
				},
				false
			)
		}

		this.UpdateRevelationEquip = (vo?, cfgs?) => {
			let goodsVo = this.revelation_equip_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					if (vo.type == RevelationModel.GOODS_TYPE) {
						vo.star = cfgs[vo.type_id] && cfgs[vo.type_id].star || 0
					} else {
						vo.star = 0
					}
					this.revelation_equip_dic[vo.goods_id] = vo
					this.revelation_equip_list[vo.cell - 1] = vo
					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateRevelationBag = (vo?, cfgs?) => {
			let goodsVo = this.revelation_bag_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					if (vo.type == RevelationModel.GOODS_TYPE) {
						vo.star = cfgs[vo.type_id] &&
							cfgs[vo.type_id].star ||
							0
					} else {
						vo.star = 0
					}
					this.revelation_bag_dic[vo.goods_id] = vo

					table.insert(this.revelation_bag_list, vo)
					if (this.revelation_type_dic[vo.equip_type] == null) {
						this.revelation_type_dic[vo.equip_type] = []
					}
					table.insert(this.revelation_type_dic[vo.equip_type], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateRuneEquipGoods = (vo?) => {
			let goodsVo = this.wear_rune_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteRuneEquipGoods(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.wear_rune_list[vo.cell - 1] = vo
					this.wear_rune_dic[vo.goods_id] = vo
				}
			}
		}

		this.UpdateSoulEquipGoods = (vo?) => {
			let goodsVo = this.wear_soul_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteSoulEquipGoods(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.wear_soul_list[vo.cell - 1] = vo
					this.wear_soul_dic[vo.goods_id] = vo
					this.wear_soul_type_dic[vo.subtype] = vo
				}
			}
		}

		this.UpdateBeastEquipGoods = (vo?) => {
			let goodsVo = this.wear_beast_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteBeastEquipGoods(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.wear_beast_list[vo.cell - 1] = vo
					this.wear_beast_dic[vo.goods_id] = vo
				}
			}
		}

		this.UpdateUnrealEquipGoods = (vo?) => {
			let goodsVo = this.wear_unreal_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteUnrealEquipGoods(vo)
				} else {
					if (goodsVo.type_id != vo.type_id) {
						let basic = this.GetGoodsBasicByTypeId(vo.type_id)
						for (let index in basic) {
							if ((index == "equip_extra_attr" || index == "is_lock") || index == "rating") {
							} else {
								goodsVo[index] = basic[index]
							}
						}
					}
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					let last_vo = this.wear_unreal_list[vo.cell - 1]
					if (last_vo) {
						delete this.wear_unreal_dic[last_vo.goods_id]
					}
					this.wear_unreal_list[vo.cell - 1] = vo
					this.wear_unreal_dic[vo.goods_id] = vo
				}
			}
		}

		this.UpdateHolySealEquipGoods = (vo?) => {
			let goodsVo = this.wear_holy_seal_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(vo)
				} else {
					if (goodsVo.type_id != vo.type_id) {
						let basic = this.GetGoodsBasicByTypeId(vo.type_id)
						for (let index in basic) {

							goodsVo[index] = basic[index]
						}
					}
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					let last_vo = this.wear_holy_seal_list[vo.cell - 1]
					if (last_vo) {
						delete this.wear_holy_seal_dic[last_vo.goods_id]
					}
					this.wear_holy_seal_list[vo.cell - 1] = vo
					this.wear_holy_seal_dic[vo.goods_id] = vo

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateHorseEquipGoods = (vo?) => {
			let goodsVo = wear_horse_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteHorseEquipGoods(vo)
				} else {
					if (goodsVo.type_id != vo.type_id) {
						let basic = this.GetGoodsBasicByTypeId(vo.type_id)
						for (let index in basic) {
							goodsVo[index] = basic[index]
						}
					}
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					let last_vo = this.wear_horse_list[vo.cell - 1]
					if (last_vo) {
						delete wear_horse_dic_[last_vo.goods_id]
					}
					this.wear_horse_list[vo.cell - 1] = vo
					wear_horse_dic_[vo.goods_id] = vo
				}
			}
		}

		this.UpdatePartnerEquipGoods = (vo?) => {
			let goodsVo = wear_partner_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeletePartnerEquipGoods(vo)
				} else {
					if (goodsVo.type_id != vo.type_id) {
						let basic = this.GetGoodsBasicByTypeId(vo.type_id)
						for (let index in basic) {
							goodsVo[index] = basic[index]
						}
					}
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					let last_vo = this.wear_partner_list[vo.cell - 1]
					if (last_vo) {
						delete wear_partner_dic_[last_vo.goods_id]
					}
					this.wear_partner_list[vo.cell - 1] = vo
					wear_partner_dic_[vo.goods_id] = vo
				}
			}
		}

		this.UpdateLungEquipGoods = (vo?) => {
			let goodsVo = this.wear_lung_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteLungEquipGoods(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.wear_lung_list[vo.cell - 1] = vo
					this.wear_lung_dic[vo.goods_id] = vo
				}
			}
			LungModel.GetInstance().SetLungTotalLevel()
		}

		this.UpdateEquipGoods = (vo?) => {
			let goodsVo = wear_equip_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteEquipGoods(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.SetEquipBaseInfo(vo)
					this.wear_equip_list[vo.cell] = vo
					wear_equip_dic_[vo.goods_id] = vo
					if (vo.color >= ColorType.RED) {
						if (((vo.cell == 5 || vo.cell == 7) || vo.cell == 9) || vo.cell == 3) {
							return
						}
						// RedEquipModel.GetInstance().checkRedEquipActivate(vo, wear_equip_dic_)
					}
				}
			}
		}

		this.UpdateGodEquipGoods = (vo?) => {
			let goodsVo = this.wear_god_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGodEquipGoods(vo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.wear_god_dic[vo.goods_id] = vo
				}
			}
		}

		this.CreateSpiritEquipList = (list?) => {
			let spirte_equip_dic = null
			let vo = null
			for (let i = 0; i < list.length; i++) {
				spirte_equip_dic = {}
				vo = list[i]
				this.SetBaseInfo(vo)
				if (spirte_dic_[vo.sub_pos]) { // :hasOwnProperty(vo.sub_pos.toString())
					spirte_equip_dic = spirte_dic_[vo.sub_pos]
				}
				spirte_equip_dic[vo.cell] = vo
				spirte_dic_[vo.sub_pos] = spirte_equip_dic
			}
			this.Fire(local_GoodsModel.CHANGE_SPIRIT_LIST)
		}

		this.getSpiritEquipList = (id?) => {
			return spirte_dic_[id]
		}

		this.changeSpiritEquipList = (id?, pos?, goods_type?) => {
			let spirte_equip_dic = {}
			let vo = null
			if (spirte_dic_[id]) { // spirte_dic_.hasOwnProperty(id.toString())
				spirte_equip_dic = spirte_dic_[id]
			}
			vo = []
			vo.type_id = goods_type
			this.SetBaseInfo(vo)
			spirte_equip_dic[pos] = vo
			spirte_dic_[id] = spirte_equip_dic
			this.Fire(local_GoodsModel.CHANGE_SPIRIT_LIST)
		}

		this.delSpiritEquipList = (id?, pos?) => {
			let spirte_equip_dic = {}
			let vo = null
			if (spirte_dic_[id]) { // :hasOwnProperty(id.toString())
				spirte_equip_dic = spirte_dic_[id]
				spirte_equip_dic[pos] = null
			}
			this.Fire(local_GoodsModel.CHANGE_SPIRIT_LIST)
		}

		this.DeleteRuneEquipGoods = (vo?) => {
			for (let index = 0; index < this.wear_rune_list.length; index++) {
				if (this.wear_rune_list[index] && Number(this.wear_rune_list[index].goods_id) == Number(vo.goods_id)) {
					this.wear_rune_list[index] = null
					break
				}
			}
			delete this.wear_rune_dic[vo.goods_id]
		}

		this.DeleteSoulEquipGoods = (vo?) => {
			for (let index = 0; index < this.wear_soul_list.length; index++) {
				if (Number(this.wear_soul_list[index].goods_id) == Number(vo.goods_id)) {
					this.wear_soul_list[index] = null
					break
				}
			}
			let basic = this.GetGoodsBasicByTypeId(vo.type_id)
			delete this.wear_soul_type_dic[basic.subtype]
			delete this.wear_soul_dic[vo.goods_id]
		}

		this.DeleteBeastEquipGoods = (vo?) => {
			let goods
			for (let index = 0; index < this.wear_beast_list.length; index++) {
				goods = this.wear_beast_list[index]
				if (goods && Number(this.wear_beast_list[index].goods_id) == Number(vo.goods_id)) {
					this.wear_beast_list[index] = null
					break
				}
			}
			delete this.wear_beast_dic[vo.goods_id]
		}

		this.DeleteUnrealEquipGoods = (vo?) => {
			this.wear_unreal_list[vo.cell - 1] = null
			delete this.wear_unreal_dic[vo.goods_id]
		}

		this.DeleteHorseEquipGoods = (vo?) => {
			this.wear_horse_list[vo.cell - 1] = null
			delete wear_horse_dic_[vo.goods_id]
		}

		this.DeletePartnerEquipGoods = (vo?) => {
			this.wear_partner_list[vo.cell - 1] = null
			delete wear_partner_dic_[vo.goods_id]
		}

		this.DeleteLungEquipGoods = (vo?) => {
			for (let index = 0; index < this.wear_lung_list.length; index++) {
				if (this.wear_lung_list[index] && Number(this.wear_lung_list[index].goods_id) == Number(vo.goods_id)) {
					this.wear_lung_list[index] = null
					break
				}
			}
			delete this.wear_lung_dic[vo.goods_id]
		}

		this.DeleteEquipGoods = (vo?) => {
			for(let index in this.wear_equip_list){
				if (Number(this.wear_equip_list[index].goods_id) == Number(vo.goods_id)) {
					delete this.wear_equip_list[index]
					break
				}
			}
			delete wear_equip_dic_[vo.goods_id]
		}

		this.DeleteGodEquipGoods = (vo?) => {
			delete this.wear_god_dic[vo.goods_id]
		}

		this.CreateTreasureList = (list?) => {
			this.ResetTreasureBagData()
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				this.UpdateTreasureBagGoods(vo)
			}
			this.SortTreasureBagList()
			this.Fire(local_GoodsModel.CHANGE_TREASURE_BAG_LIST)
		}

		this.UpdateBagGoods = (vo?, force_sort?) => {
			let goodsVo = bag_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.AddGoodsToBag(vo)
				}
			}
			if (force_sort) {
				this.SortBagGoodsList()
			}
		}

		this.UpdateWarehouseGoods = (vo?, force_sort?) => {
			let goodsVo = warehouse_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.AddGoodsToWarehouse(vo)
				}
			}
			if (force_sort) {
				this.SortWarehouseList()
			}
		}

		this.UpdateRuneBagGoods = (vo?) => {
			let goodsVo = runebag_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.runebag_goods_list, vo)
					runebag_goods_dic_[vo.goods_id] = vo

					if (this.rune_type_dic[vo.subtype] == null) {
						this.rune_type_dic[vo.subtype] = []
					}
					table.insert(this.rune_type_dic[vo.subtype], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateTreasureBagGoods = (vo?) => {
			let goodsVo = treasure_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					treasure_goods_dic_[vo.goods_id] = vo
					table.insert(this.treasure_goods_list, vo)
				}
			}
		}

		this.GetSoulBagDic = () => {
			return soulbag_goods_dic_
		}

		this.UpdateSoulBagGoods = (vo?) => {
			let goodsVo = soulbag_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)

					table.insert(this.soulbag_goods_list, vo)
					soulbag_goods_dic_[vo.goods_id] = vo
					
					if (this.soulbag_type_dic[vo.subtype] == null) {
						this.soulbag_type_dic[vo.subtype] = []
					}
					table.insert(this.soulbag_type_dic[vo.subtype], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateBeastBagGoods = (vo?) => {
			let goodsVo = this.beastbag_goods_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.beastbag_goods_list, vo)
					this.beastbag_goods_dic[vo.goods_id] = vo
					
					if (this.beastbag_type_dic[vo.equip_type] == null) {
						this.beastbag_type_dic[vo.equip_type] = []
					}
					table.insert(this.beastbag_type_dic[vo.equip_type], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateUnrealBagGoods = (vo?) => {
			let goodsVo = this.unrealbag_goods_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.unrealbag_goods_list, vo)
					this.unrealbag_goods_dic[vo.goods_id] = vo
					
					if (unrealbag_type_dic_[vo.equip_type] == null) {
						unrealbag_type_dic_[vo.equip_type] = []
					}
					table.insert(unrealbag_type_dic_[vo.equip_type], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateHolySealBagGoods = (vo?) => {
			let goodsVo = holy_seal_bag_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)

					table.insert(this.holy_seal_bag_goods_list, vo)
					holy_seal_bag_goods_dic_[vo.goods_id] = vo

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateHorseBagGoods = (vo?) => {
			let goodsVo = this.horse_bag_goods_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.horse_bag_goods_list, vo)
					this.horse_bag_goods_dic[vo.goods_id] = vo
					
					if (this.horse_bag_type_dic[vo.equip_type] == null) {
						this.horse_bag_type_dic[vo.equip_type] = []
					}
					table.insert(this.horse_bag_type_dic[vo.equip_type], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdatePartnerBagGoods = (vo?) => {
			let goodsVo = this.partner_bag_goods_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.partner_bag_goods_list, vo)
					this.partner_bag_goods_dic[vo.goods_id] = vo
					
					if (this.partner_bag_type_dic[vo.equip_type] == null) {
						this.partner_bag_type_dic[vo.equip_type] = []
					}
					table.insert(this.partner_bag_type_dic[vo.equip_type], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.SortHolySealBagList = () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_seal_equip
			let sort_func = (b?, a?) => {
				if (a.type == HolySealModel.GOODS_TYPE && b.type == HolySealModel.GOODS_TYPE) {
					if (a.color == b.color) {
						let a_equip_date = HolySealModel.GetInstance().GetHolySealData(a.type_id, cfg)
						let b_equip_date = HolySealModel.GetInstance().GetHolySealData(b.type_id, cfg)
						if (a_equip_date.stage == b_equip_date.stage) {
							return b.subtype > a.subtype
						} else {
							return b_equip_date.stage > a_equip_date.stage
						}
					} else {
						return b.color > a.color
					}
				}
				return a.type > b.type
			}
			table.sort(this.holy_seal_bag_goods_list, sort_func)
			this.Fire(local_GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST)
		}

		this.SortHorseBagList = () => {
			if (this.horse_bag_goods_list.length < 2) {
				return
			}
			let sort_func = (b?, a?) => {
				if (b.color == a.color) {
					return b.rating > a.rating
				} else {
					return b.color > a.color
				}
			}
			table.sort(this.horse_bag_goods_list, sort_func)
		}

		this.SortPartnerBagList = () => {
			if (this.partner_bag_goods_list.length < 2) {
				return
			}
			let sort_func = (b?, a?) => {
				if (b.color == a.color) {
					return b.rating > a.rating
				} else {
					return b.color > a.color
				}
			}

			table.sort(this.partner_bag_goods_list, sort_func)
		}

		this.UpdateLungBagGoods = (vo?) => {
			let goodsVo = lungbag_goods_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.lungbag_goods_list, vo)
					lungbag_goods_dic_[vo.goods_id] = vo

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateBabyBagGoods = (vo?) => {
			let goodsVo = this.baby_bag_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					this.baby_bag_dic[vo.goods_id] = vo
					table.insert(this.baby_bag_list, vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateGodBagGoods = (vo?) => {
			let goodsVo = god_bag_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					god_bag_dic_[vo.goods_id] = vo
					table.insert(this.god_bag_list, vo)

					if (this.god_bag_type_dic[vo.subtype] == null) {
						this.god_bag_type_dic[vo.subtype] = []
					}
					table.insert(this.god_bag_type_dic[vo.subtype], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateDemonTalentGoods = (vo?) => {
			let goodsVo = demontalent_bag_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					demontalent_bag_dic_[vo.goods_id] = vo
					table.insert(this.demontalent_bag_list, vo)

					if (this.demontalent_bag_type_dic[vo.type_id] == null) {
						this.demontalent_bag_type_dic[vo.type_id] = []
					}
					table.insert(this.demontalent_bag_type_dic[vo.type_id], vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateLonglangGoods = (vo?, cfgs?) => {
			let goodsVo = longlang_bag_dic_[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					if (cfgs && cfgs[vo.type_id]) {
						vo.stage = cfgs[vo.type_id].stage
						vo.max_strong = cfgs[vo.type_id].strong
					}
					longlang_bag_dic_[vo.goods_id] = vo
					table.insert(this.longlang_bag_list, vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateStarEquipList = (vo?, cfgs?) => {
			let goodsVo = this.starEquipDic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					let star = 0
					for (let _tmpi in vo.addition_attrlist) {
						let starAttr = vo.addition_attrlist[_tmpi]
						if (starAttr.combat_power == 1) {
							star = star + 1
						}
					}
					vo.star = star
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					let cfg = cfgs[vo.type_id]
					if (cfg) {
						vo.page = cfg.page
						vo.is_suit = cfg.is_suit != 0
					}
					let star = 0
					for (let _tmpi in vo.addition_attrlist) {
						let starAttr = vo.addition_attrlist[_tmpi]
						if (starAttr.combat_power == 1) {
							star = star + 1
						}
					}
					vo.star = star
					this.starEquipDic[vo.goods_id] = vo
					let pageList = this.starEquipList[vo.page]
					if (!pageList) {
						pageList = []
					}
					pageList[vo.subtype] = vo
					this.starEquipList[vo.page] = pageList
					if (vo.subtype != 10) {
						if (bag_goodsType_dic_[vo.type_id] == null) {
							bag_goodsType_dic_[vo.type_id] = []
						}
						table.insert(bag_goodsType_dic_[vo.type_id], vo)
					}
				}
			}
		}

		this.UpdateStarEquipBagList = (vo?, cfgs?) => {
			let goodsVo = starEquipBagDic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					let star = 0
					for (let _tmpi in vo.addition_attrlist) {
						let starAttr = vo.addition_attrlist[_tmpi]
						if (starAttr.combat_power == 1) {
							star = star + 1
						}
					}
					vo.star = star
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					let cfg = cfgs[vo.type_id]
					if (cfg) {
						vo.page = cfg.page
						vo.is_suit = cfg.is_suit
					}
					let star = 0
					for (let _tmpi in vo.addition_attrlist) {
						let starAttr = vo.addition_attrlist[_tmpi]
						if (starAttr.combat_power == 1) {
							star = star + 1
						}
					}
					vo.star = star
					starEquipBagDic[vo.goods_id] = vo
					table.insert(this.starEquipBagList, vo)

					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateGodCourtList = (vo?) => {
			let goodsVo = this.godCourtDic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else if (vo.goods_num > 0) {
				this.SetBaseInfo(vo)
				this.godCourtDic[vo.goods_id] = vo
				let pageList = this.godCourtList[vo.skill_id - 1000]
				if (vo.subtype >= 9 && vo.subtype < 17) {
					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.unshift(bag_goodsType_dic_[vo.type_id], vo)
				}
				if (!pageList) {
					pageList = [vo]
					this.godCourtList[vo.skill_id - 1000] = pageList
				} else {
					table.insert(pageList, vo)
				}
			}
		}

		this.UpdateGuildRuneList = (vo?, cfgs?) => {
			let goodsVo = this.guildRuneDic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					table.insert(this.guildRuneList, vo)
					this.guildRuneDic[vo.goods_id] = vo
					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateGodCourtBagList = (vo?) => {
			let goodsVo = godCourtBagDic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(goodsVo)
				} else {
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else if (vo.goods_num > 0) {
				this.SetBaseInfo(vo)
				godCourtBagDic[vo.goods_id] = vo
				table.insert(this.godCourtBagList, vo)
				if (bag_goodsType_dic_[vo.type_id] == null) {
					bag_goodsType_dic_[vo.type_id] = [vo]
				} else {
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.UpdateLonglangEquip = (vo?, cfgs?) => {
			let goodsVo = this.longlang_equip_dic[vo.goods_id]
			if (goodsVo) {
				if (vo.goods_num <= 0) {
					this.DeleteGoods(vo)
				} else {
					if (goodsVo.type_id != vo.type_id) {
						let basic = this.GetGoodsBasicByTypeId(vo.type_id)
						for (let index in basic) {
							goodsVo[index] = basic[index]
						}
					}
					this.CopyGoodsVo(goodsVo, vo)
				}
			} else {
				if (vo.goods_num > 0) {
					this.SetBaseInfo(vo)
					if (cfgs && cfgs[vo.type_id]) {
						vo.stage = cfgs[vo.type_id].stage
						vo.max_strong = cfgs[vo.type_id].strong
					}
					let last_vo = this.longlang_equip_list[vo.cell]
					if (last_vo) {
						delete this.longlang_equip_dic[last_vo.goods_id]
					}
					this.longlang_equip_list[vo.cell] = vo
					this.longlang_equip_dic[vo.goods_id] = vo
					
					if (bag_goodsType_dic_[vo.type_id] == null) {
						bag_goodsType_dic_[vo.type_id] = []
					}
					table.insert(bag_goodsType_dic_[vo.type_id], vo)
				}
			}
		}

		this.SortBagGoodsList = () => {
			if (this.hasSort) {
				return
			}
			let role_sex = RoleManager.GetInstance().GetMainRoleSex()
			let sortfunc = (v2?, v1?) => {
				if (v2.type != 10 && v1.type == 10) {
					return false
				} else if (v2.type == 10 && v1.type != 10) {
					return true
				} else if (v1.type == 10 && v2.type == 10) {
					if (v1.color > v2.color) {
						return false
					} else if (v1.color < v2.color) {
						return true
					}
					if (v1.stage && v2.stage) {
						if (v1.stage > v2.stage) {
							return false
						} else if (v1.stage < v2.stage) {
							return true
						}
					} else {
						return true
					}
					if (v1.star > v2.star) {
						return false
					} else if (v1.star < v2.star) {
						return true
					}
					if (v1.sex != v2.sex) {
						if (v1.sex == 0) {
							return true
						} else if (v2.sex == 0) {
							return false
						} else {
							return v1.sex != role_sex
						}
					}
					if (v1.equip_type > v2.equip_type) {
						return false
					} else if (v1.equip_type < v2.equip_type) {
						return true
					}
				} else if (v1.type_id > v2.type_id) {
					return true
				} else if (v1.type_id < v2.type_id) {
					return false
				}
				if (v1.goods_num > v2.goods_num) {
					return false
				} else if (v1.goods_num < v2.goods_num) {
					return true
				}
			}

			table.sort(this.bag_goods_list, sortfunc)
			this.hasSort = true
		}

		this.SortWarehouseList = () => {
			let sortfunc = (v2?, v1?) => {
				if (v2.type != 10 && v1.type == 10) {
					return false
				} else if (v2.type == 10 && v1.type != 10) {
					return true
				} else if (v1.type == 10 && v2.type == 10) {
					if (v1.color > v2.color) {
						return false
					} else if (v1.color < v2.color) {
						return true
					}
					if (v1.stage > v2.stage) {
						return false
					} else if (v1.stage < v2.stage) {
						return true
					}
					if (v1.star > v2.star) {
						return false
					} else if (v1.star < v2.star) {
						return true
					}
					if (v1.equip_type > v2.equip_type) {
						return false
					} else if (v1.equip_type < v2.equip_type) {
						return true
					}
				} else if (v1.type_id > v2.type_id) {
					return true
				} else if (v1.type_id < v2.type_id) {
					return false
				}
				if (v1.goods_num > v2.goods_num) {
					return false
				} else if (v1.goods_num < v2.goods_num) {
					return true
				}
			}
			table.sort(this.warehouse_goods_list, sortfunc)
			this.Fire(local_GoodsModel.CHANGE_WAREHOUSE_LIST)
		}

		this.SortBabyList = () => {
			let sortfunc = (v2?, v1?) => {
				if (v1.color > v2.color) {
					return false
				} else if (v1.color < v2.color) {
					return true
				}
				if (v1.stage > v2.stage) {
					return false
				} else if (v1.stage < v2.stage) {
					return true
				}
				if (v1.star > v2.star) {
					return false
				} else if (v1.star < v2.star) {
					return true
				}
				if (v1.equip_type > v2.equip_type) {
					return false
				} else if (v1.equip_type < v2.equip_type) {
					return true
				}
			}
			table.sort(this.baby_bag_list, sortfunc)
		}

		this.SortTreasureBagList = () => {
			let sortfunc = (v2?, v1?) => {
				if (v1.color > v2.color) {
					return false
				} else if (v1.color < v2.color) {
					return true
				}
				if (v1.type_id > v2.type_id) {
					return false
				} else if (v1.type_id < v2.type_id) {
					return true
				}
			}
			table.sort(this.treasure_goods_list, sortfunc)
		}

		this.SortLonglangBag = () => {
			let sortFunc = (b?, a?) => {
				if (a.type_id == 0 || b.type_id == 0) {
					return a.type_id < b.type_id
				} else {
					if (a.type == b.type && b.type == longlangModel.GOODS_TYPE) {
						if (a.color == b.color) {
							if (!a.stage || !b.stage || a.stage == b.stage) {
								return b.subtype > a.subtype
							} else {
								return b.stage > a.stage
							}
						} else {
							return b.color > a.color
						}
					}
					return a.type > b.type
				}
			}
			table.sort(this.longlang_bag_list, sortFunc)
		}

		this.SortStarEquipBagList = () => {
			let sortFunc = (b?, a?) => {
				if (a.type == b.type && b.type == 79) {
					if (a.color == b.color) {
						if (a.page == b.page) {
							if (b.rating == a.rating) {
								if (b.star == a.star) {
									return false
								} else {
									return b.star > a.star
								}
							} else {
								return b.rating > a.rating
							}
						} else {
							return b.page > a.page
						}
					} else {
						return b.color > a.color
					}
				}
				return a.type > b.type
			}
			table.sort(this.starEquipBagList, sortFunc)
		}

		this.SortGodCourtBagList = () => {
			let sortFunc = (b?, a?) => {
				if (a.type == b.type && b.type == 80) {
					if (a.color == b.color) {
						return a.subtype > b.subtype
					} else {
						return b.color > a.color
					}
				}
				return a.type > b.type
			}
			table.sort(this.godCourtBagList, sortFunc)
		}

		this.DeleteGoods = (goodsVo?) => {
			delete dynamic_goods_dic_[goodsVo.goods_id]

			if (bag_goodsType_dic_[goodsVo.type_id]) {
				let list = bag_goodsType_dic_[goodsVo.type_id]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (bag_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.bag_goods_list.length; index++) {
					if (this.bag_goods_list[index].goods_id == goodsVo.goods_id) {
						table.remove(this.bag_goods_list, index)
						break
					}
				}
				delete bag_goods_dic_[goodsVo.goods_id]
			}

			if (warehouse_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.warehouse_goods_list.length; index++) {
					if (Number(this.warehouse_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.warehouse_goods_list, index)
						break
					}
				}
				delete warehouse_goods_dic_[goodsVo.goods_id]
			}
			
			if (runebag_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.runebag_goods_list.length; index++) {
					if (Number(this.runebag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.runebag_goods_list, index)
						break
					}
				}
				delete runebag_goods_dic_[goodsVo.goods_id]
			}

			if (this.rune_type_dic[goodsVo.subtype]) {
				let list = this.rune_type_dic[goodsVo.subtype]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (treasure_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.treasure_goods_list.length; index++) {
					if (Number(this.treasure_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.treasure_goods_list, index)
						break
					}
				}
				delete treasure_goods_dic_[goodsVo.goods_id]
			}

			if (soulbag_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.soulbag_goods_list.length; index++) {
					if (Number(this.soulbag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.soulbag_goods_list, index)
						break
					}
				}
				delete soulbag_goods_dic_[goodsVo.goods_id]
			}

			if (this.soulbag_type_dic[goodsVo.subtype]) {
				let list = this.soulbag_type_dic[goodsVo.subtype]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (this.beastbag_goods_dic[goodsVo.goods_id]) {
				for (let index = 0; index < this.beastbag_goods_list.length; index++) {
					if (Number(this.beastbag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.beastbag_goods_list, index)
						break
					}
				}

				delete this.beastbag_goods_dic[goodsVo.goods_id]
			}

			if (this.beastbag_type_dic[goodsVo.equip_type]) {
				let list = this.beastbag_type_dic[goodsVo.equip_type]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (this.unrealbag_goods_dic[goodsVo.goods_id]) {
				for (let index = 0; index < this.unrealbag_goods_list.length; index++) {
					if (Number(this.unrealbag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.unrealbag_goods_list, index)
						break
					}
				}
				delete this.unrealbag_goods_dic[goodsVo.goods_id]
			}

			if (unrealbag_type_dic_[goodsVo.equip_type]) {
				let list = unrealbag_type_dic_[goodsVo.equip_type]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (holy_seal_bag_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.holy_seal_bag_goods_list.length; index++) {
					if (this.holy_seal_bag_goods_list[index] && this.holy_seal_bag_goods_list[index].goods_id == goodsVo.goods_id) {
						table.remove(this.holy_seal_bag_goods_list, index)
						break
					}
				}
				delete holy_seal_bag_goods_dic_[goodsVo.goods_id]
			}

			if (this.wear_holy_seal_dic[goodsVo.goods_id]) {
				let index = goodsVo.cell - 1
				if (this.wear_holy_seal_list[index] && this.wear_holy_seal_list[index].goods_id == goodsVo.goods_id) {
					table.remove(this.wear_holy_seal_list, index)
				}
				delete this.wear_holy_seal_dic[goodsVo.goods_id]
			}

			if (this.horse_bag_goods_dic[goodsVo.goods_id]) {
				for (let index = 0; index < this.horse_bag_goods_list.length; index++) {
					if (Number(this.horse_bag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.horse_bag_goods_list, index)
						break
					}
				}
				delete this.horse_bag_goods_dic[goodsVo.goods_id]
			}

			if (this.horse_bag_type_dic[goodsVo.equip_type]) {
				let list = this.horse_bag_type_dic[goodsVo.equip_type]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (this.partner_bag_goods_dic[goodsVo.goods_id]) {
				for (let index = 0; index < this.partner_bag_goods_list.length; index++) {
					if (Number(this.partner_bag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.partner_bag_goods_list, index)
						break
					}
				}
				delete this.partner_bag_goods_dic[goodsVo.goods_id]
			}

			if (this.partner_bag_type_dic[goodsVo.equip_type]) {
				let list = this.partner_bag_type_dic[goodsVo.equip_type]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (lungbag_goods_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.lungbag_goods_list.length; index++) {
					if (Number(this.lungbag_goods_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.lungbag_goods_list, index)
						break
					}
				}
				delete lungbag_goods_dic_[goodsVo.goods_id]
			}

			if (this.baby_bag_dic[goodsVo.goods_id]) {
				for (let index = 0; index < this.baby_bag_list.length; index++) {
					if (Number(this.baby_bag_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.baby_bag_list, index)
						break
					}
				}
				delete this.baby_bag_dic[goodsVo.goods_id]
			}

			if (god_bag_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.god_bag_list.length; index++) {
					if (Number(this.god_bag_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.god_bag_list, index)
						break
					}
				}
				delete god_bag_dic_[goodsVo.goods_id]
			}

			if (this.god_bag_type_dic[goodsVo.subtype]) {
				let list = this.god_bag_type_dic[goodsVo.subtype]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (this.baby_equip_dic[goodsVo.goods_id]) {
				for (let index = 0; index < baby_equip_list_.length; index++) {
					if (Number(baby_equip_list_[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(baby_equip_list_, index)
						break
					}
				}
				delete this.baby_equip_dic[goodsVo.goods_id]
			}

			if (this.revelation_bag_dic[goodsVo.goods_id]) {
				for (let index = 0; index < this.revelation_bag_list.length; index++) {
					if (this.revelation_bag_list[index].goods_id == goodsVo.goods_id) {
						table.remove(this.revelation_bag_list, index)
						break
					}
				}
				delete this.revelation_bag_dic[goodsVo.goods_id]

				let list = this.revelation_type_dic[goodsVo.equip_type]
				if (list) {
					for (let index = 0; index < list.length; index++) {
						if (list[index].goods_id == goodsVo.goods_id) {
							table.remove(list, index)
							break
						}
					}

					if (list.length == 0) {
						delete this.revelation_type_dic[goodsVo.equip_type]
					}
				}
			}

			if (this.revelation_equip_dic[goodsVo.goods_id]) {
				let index = goodsVo.cell - 1
				if (this.revelation_equip_list[index] && this.revelation_equip_list[index].goods_id == goodsVo.goods_id) {
					this.revelation_equip_list[index] = null
				}
				delete this.revelation_equip_dic[goodsVo.goods_id]
			}

			if (demontalent_bag_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.demontalent_bag_list.length; index++) {
					if (Number(this.demontalent_bag_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.demontalent_bag_list, index)
						break
					}
				}
				delete demontalent_bag_dic_[goodsVo.goods_id]
			}

			if (this.demontalent_bag_type_dic[goodsVo.type_id]) {
				let list = this.demontalent_bag_type_dic[goodsVo.type_id]
				for (let index = 0; index < list.length; index++) {
					if (Number(list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(list, index)
						break
					}
				}
			}

			if (longlang_bag_dic_[goodsVo.goods_id]) {
				for (let index = 0; index < this.longlang_bag_list.length; index++) {
					if (Number(this.longlang_bag_list[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.longlang_bag_list, index)
						break
					}
				}
				delete longlang_bag_dic_[goodsVo.goods_id]
			}

			if (this.longlang_equip_dic[goodsVo.goods_id]) {
				let oldEquip = this.longlang_equip_dic[goodsVo.goods_id]
				if (this.longlang_equip_list[oldEquip.cell] &&this.longlang_equip_list[oldEquip.cell].goods_id == goodsVo.goods_id) {
					this.longlang_equip_list[oldEquip.cell] = null
				}
				delete this.longlang_equip_dic[goodsVo.goods_id]
			}

			if (starEquipBagDic[goodsVo.goods_id]) {
				for (let i = 0; i < this.starEquipBagList.length; i++) {
					if (Number(this.starEquipBagList[i].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.starEquipBagList, i)
						break
					}
				}
				delete starEquipBagDic[goodsVo.goods_id]
			}

			if (this.starEquipDic[goodsVo.goods_id]) {
				let list = this.starEquipList[goodsVo.page]
				if (list) {
					if (list[goodsVo.subtype] && Number(list[goodsVo.subtype].goods_id) == Number(goodsVo.goods_id)) {
						list[goodsVo.subtype] = null
					}
				}
				delete this.starEquipDic[goodsVo.goods_id]

			}
			if (godCourtBagDic[goodsVo.goods_id]) {
				for (let i = 0; i < this.godCourtBagList.length; i++) {
					if (Number(this.godCourtBagList[i].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.godCourtBagList, i)
						break
					}
				}
				delete godCourtBagDic[goodsVo.goods_id]
			} else if (this.godCourtDic[goodsVo.goods_id]) {
				let list = this.godCourtList[goodsVo.skill_id - 1000]
				if (list) {
					for (let i = 0; i < list.length; i++) {
						if (Number(list[i].goods_id) == Number(goodsVo.goods_id)) {
							table.remove(list, i)
							break
						}
					}
				}
				delete this.godCourtDic[goodsVo.goods_id]
			}

			if (this.guildRuneDic[goodsVo.goods_id]) {
				for (let index = 0; index < this.guildRuneList.length; index++) {
					if (Number(this.guildRuneList[index].goods_id) == Number(goodsVo.goods_id)) {
						table.remove(this.guildRuneList, index)
						break
					}
				}
				delete this.guildRuneDic[goodsVo.goods_id]
			}
		}

		this.AddGoodsToBag = (goodsVo?) => {
			this.SetBaseInfo(goodsVo)
			if (goodsVo.type == 10) {
				this.SetEquipBaseInfo(goodsVo)
			}
			table.insert(this.bag_goods_list, goodsVo)
			bag_goods_dic_[goodsVo.goods_id] = goodsVo
			if (bag_goodsType_dic_[goodsVo.type_id] == null) {
				bag_goodsType_dic_[goodsVo.type_id] = []
			}
			table.insert(bag_goodsType_dic_[goodsVo.type_id], goodsVo)
		}

		this.AddGoodsToWarehouse = (goodsVo?) => {
			this.SetBaseInfo(goodsVo)
			if (goodsVo.type == 10) {
				this.SetEquipBaseInfo(goodsVo)
			}
			table.insert(this.warehouse_goods_list, goodsVo)
			warehouse_goods_dic_[goodsVo.goods_id] = goodsVo
		}

		this.SetBaseInfo = (goodsVo?) => {
			if (goodsVo) {
				let goodsBaseInfo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, goodsVo.type_id, false)
				if (goodsBaseInfo) {
					goodsVo.goods_name = (goodsVo.goods_name != null && goodsVo.goods_name || goodsBaseInfo.goods_name)
					goodsVo.type = (goodsVo.type != null && goodsVo.type || goodsBaseInfo.type)
					goodsVo.subtype = (goodsVo.subtype != null && goodsVo.subtype || goodsBaseInfo.subtype)
					goodsVo.level = (goodsVo.level != null && goodsVo.level || goodsBaseInfo.level)
					goodsVo.goods_icon = (goodsVo.goods_icon != null && goodsVo.goods_icon || goodsBaseInfo.goods_icon)
					goodsVo.career_id = (goodsVo.career_id != null && goodsVo.career_id || goodsBaseInfo.career_id)
					goodsVo.equip_type = (goodsVo.equip_type != null && goodsVo.equip_type || goodsBaseInfo.equip_type)
					goodsVo.use = (goodsVo.use != null && goodsVo.use || goodsBaseInfo.use)
					goodsVo.sell = (goodsVo.sell != null && goodsVo.sell || goodsBaseInfo.sell)
					goodsVo.compose = (goodsVo.compose != null && goodsVo.compose || goodsBaseInfo.compose)
					goodsVo.identify = (goodsVo.identify != null && goodsVo.identify || goodsBaseInfo.identify)
					goodsVo.intro = (goodsVo.intro != null && goodsVo.intro || goodsBaseInfo.intro)
					goodsVo.price_type = (goodsVo.price_type != null && goodsVo.price_type || goodsBaseInfo.price_type)
					goodsVo.sell_price = (goodsVo.sell_price != null && goodsVo.sell_price || goodsBaseInfo.sell_price)
					goodsVo.sex = (goodsVo.sex != null && goodsVo.sex || goodsBaseInfo.sex)
					goodsVo.turn = (goodsVo.turn != null && goodsVo.turn || goodsBaseInfo.turn)
					goodsVo.color = (goodsVo.color != null && goodsVo.color || goodsBaseInfo.color)
					goodsVo.base_attrlist = (goodsVo.base_attrlist != null && goodsVo.base_attrlist || goodsBaseInfo.base_attrlist)
				}
			}
		}

		this.SetEquipBaseInfo = (GoodsVo?) => {
			if (GoodsVo) {
				let equip_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, GoodsVo.type_id, false)
				if (equip_cfg) {
					GoodsVo.stage = equip_cfg.stage
					GoodsVo.star = equip_cfg.star
					GoodsVo.base_rating = equip_cfg.base_rating
					GoodsVo.bad_type = equip_cfg.class_type
				}
			}
		}

		this.AddDynamic = (vo?, no_need_fire_event?) => {
			if (vo) {
				if (vo.goods_id == 0 && vo.type_id == 0) {
					Message.show("无此物品")
					return
				}
				//洗炼评分特殊处理
				vo.wash_rating = vo.wash_rating || 0

				dynamic_goods_dic_[vo.goods_id] = vo
				if (!no_need_fire_event) {
					local_GlobalEventSystem.Fire(local_GoodsModel.CHANGE_GOODS_DYNAMIC, vo.goods_id)
				}
				if (request_dynamic_callback_list_.length > 0) {
					for (let i = request_dynamic_callback_list_.length - 1; i >= 0; i--) {
						if (request_dynamic_callback_list_[i].goods_id == vo.goods_id) {
							if (request_dynamic_callback_list_[i].callback) {
								request_dynamic_callback_list_[i].callback(vo)
							}
							table.remove(request_dynamic_callback_list_, i)
						}
					}
				}
			}
		}

		this.GetDynamic = (goods_id?, callback?, needRequest?, notRequest?) => {
			let vo = dynamic_goods_dic_[goods_id]
			if (notRequest) {
				return vo
			}
			if (vo && needRequest != true) {
				if (callback) {
					callback(vo)
				}
			} else {
				let goods = wear_equip_dic_[goods_id]
				if (goods) {
					table.insert(request_dynamic_callback_list_, { goods_id: goods_id, callback: callback })
					if ((goods.last_request_time == null || Status.NowTime - goods.last_request_time >= 3) || needRequest) {
						goods.last_request_time = Status.NowTime
						this.Fire(local_GoodsModel.REQUEST_GOODS_DYNAMIC, goods_id)
					}
				}
			}
			return vo
		}

		this.DeleteDynamic = (id?) => {
			delete dynamic_goods_dic_[id]
		}

		this.GetGoodsBasicByTypeId = (type_id?) => {
			return local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, Number(type_id), false)
		}

		this.GetGoodsBagCount = () => {
			return this.bag_goods_list.length
		}

		this.GetRuneBagCount = () => {
			return this.runebag_goods_list.length
		}

		this.GetGoodsVoByGoodsId = (goods_id?) => {
			return bag_goods_dic_[goods_id]  
				|| this.wear_rune_dic[goods_id] 
				|| runebag_goods_dic_[goods_id] 
				|| treasure_goods_dic_[goods_id] 
				|| this.wear_soul_dic[goods_id] 
				|| soulbag_goods_dic_[goods_id] 
				|| this.wear_beast_dic[goods_id] 
				|| this.beastbag_goods_dic[goods_id] 
				|| this.wear_unreal_dic[goods_id] 
				|| this.unrealbag_goods_dic[goods_id] 
				|| this.wear_holy_seal_dic[goods_id] 
				|| holy_seal_bag_goods_dic_[goods_id] 
				|| wear_horse_dic_[goods_id] 
				|| this.horse_bag_goods_dic[goods_id] 
				|| wear_partner_dic_[goods_id] 
				|| this.partner_bag_goods_dic[goods_id] 
				|| this.wear_lung_dic[goods_id] 
				|| lungbag_goods_dic_[goods_id] 
				|| god_bag_dic_[goods_id] 
				|| this.baby_bag_dic[goods_id] 
				|| this.revelation_bag_dic[goods_id] 
				|| longlang_bag_dic_[goods_id]
				|| this.longlang_equip_dic[goods_id] 
				|| starEquipBagDic[goods_id] 
				|| this.starEquipDic[goods_id] 
				|| godCourtBagDic[goods_id] 
				|| this.godCourtDic[goods_id] 
				|| wear_equip_dic_[goods_id] 
				|| demontalent_bag_dic_[goods_id] 
				|| this.demontalent_bag_type_dic[goods_id]
		}

		this.GetTypeGoods = (typeId?) => {
			return bag_goodsType_dic_[typeId] || []
		}

		this.GetOneGoodsByTypeId = (typeId?) => {
			let goods_list = this.GetTypeGoods(typeId)
			if (goods_list && goods_list.length > 0) {
				let goods = goods_list[0]
				return goods.goods_id
			}
			return 0
		}

		this.GetBindGoodsVoFirstByTypeId = (typeId?) => {
			let goods_list = this.GetTypeGoods(typeId)
			if (goods_list && goods_list.length > 0) {
				for (let _tmpi in goods_list) {
					let goods_vo = goods_list[_tmpi]
					if (goods_vo.bind == 1) {
						return goods_vo
					}
				}
				return goods_list[0]
			}
		}

		this.GetUnBindGoodsVoFirstByTypeId = (typeId?) => {
			let goods_list = this.GetTypeGoods(typeId)
			if (goods_list && goods_list.length > 0) {
				for (let _tmpi in goods_list) {
					let goods_vo = goods_list[_tmpi]
					if (goods_vo.bind == 0) {
						return goods_vo
					}
				}
				return goods_list[0]
			}
		}

		this.GetTypeGoodsNum = (typeId?) => {
			let id = Number(typeId)
			let theNum = 0
			if (!id || id < 1) {
				return 0
			}
			let list = this.GetTypeGoods(id)
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (vo.expire_time == 0 || vo.expire_time - TimeUtil.getServerTime() > 0) {
					theNum = theNum + vo.goods_num
				}
			}
			return theNum
		}

		this.MarketPlzGetTypeGoodsNum = (typeId?) => {
			let id = Number(typeId)
			let theNum = 0
			if (!id || id < 1) {
				return 0
			}
			let list = this.GetTypeGoods(id)
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				if (vo.expire_time == 0 || vo.expire_time - TimeUtil.getServerTime() > 0) {
					if (vo.type == 39) {
						if (!GodBeastModel.GetInstance().GetWearEquipInfo(vo.goods_id)) {
							theNum = theNum + vo.goods_num
						}
					} else if (vo.type == HolySealModel.GOODS_TYPE) {
						if (!HolySealModel.GetInstance().GetWearEquipInfo(vo.goods_id)) {
							theNum = theNum + vo.goods_num
						}
					} else {
						theNum = theNum + vo.goods_num
					}
				}
			}
			return theNum
		}

		this.GetMappingTypeId = (_type?, type_id?) => {
			let goods_id = Number(type_id)
			let lock = 0
			if (Number(_type) == 0) {
				lock = 0
			} else if (Number(_type) == 100) {
				lock = 1
			} else if (Number(_type) == -1 || Number(_type == 255)) {
				lock = 0
				if (local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[Number(type_id)]) {
					goods_id = local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[Number(type_id)].goods_id
				}
			} else {
				lock = 0
				if (local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[Number(_type)]) {
					goods_id = local_Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[Number(_type)].goods_id
				}
			}
			return [goods_id, lock]
		}

		this.CreateSpecialScoreList = (list?) => {
			special_score_dic_ = {}
			for (let i = 0; i < list.length; i++) {

				this.UpdateSpecialScore(list[i])
			}
		}

		this.UpdateSpecialScore = (vo?) => {
			special_score_dic_[vo.currency_id] = vo.num
		}

		this.GetSpecialScore = (id?) => {
			return special_score_dic_[id] || 0
		}

		this.GetRoleSpecGoodsNum = (type?, type_id?) => {
			type = Number(type)
			type_id = Number(type_id)
			if (type == GoodsType.goods) {
				return (type_id != null && (this.GetTypeGoodsNum(type_id)) || (0))
			} else if (type == GoodsType.diamond) {
				return role_mgr.GetMainRoleVo().jin
			} else if (type == GoodsType.bind_diamond) {
				return role_mgr.GetMainRoleVo().jinLock
			} else if (type == GoodsType.coin) {
				return role_mgr.GetMainRoleVo().tong
			} else if (type == GoodsType.guild_coin) {
				return role_mgr.GetMainRoleVo().guild_coin
			} else if (type == GoodsType.exp) {
				return role_mgr.GetMainRoleVo().exp
			} else {
				// let cfg = local_Config.ConfigNotNormalGoods[type]
			
				// return (cfg && (this.GetSpecialScore(cfg.goods_id)) || (0))
			}
		}

		this.CheckEquipNum = (equip_count?, artifact_count?, ok_call?) => {
			if (this.bag_goods_max_cell - this.GetGoodsBagCount() < equip_count) {
				let ok = () => {
					OpenFun.OpenFunHandler(105)
				}

				Alert.Show("背包空间不足，是否前往整理？", Alert_Type.Two, ok, null, "前往整理", "取消")
				return false
			}
			if (ok_call) {
				ok_call()
			}
			return true
		}

		this.RefreshIconRedDot = (list?) => {
			let goods_basic = null
			for (let _tmpi in list) {
				let data = list[_tmpi]
				goods_basic = this.GetGoodsBasicByTypeId(data.type_id)
				if (goods_basic) {
					if (goods_basic.type == 53) {
						MonBookModel.GetInstance().UpdateTabDot()
						MonBookModel.GetInstance().Fire(MonBookModel.SCMD_REQUEST, 44205)
						break
					} else if (goods_basic.type == 38) {
						MonBookModel.GetInstance().UpdateTabDot()
						break
						// } else if (goods_basic.type == 54 && goods_basic.subtype == 1) {
						// 	SkillUIModel.GetInstance().UpdateTabDot()
						// 	break
					} else if (goods_basic.type == 55) {
						break
					} else if (goods_basic.type_id == 38030003) {
						//BaseDungeonModel:GetInstance():RefreshVipPersonRed()
					}
				}
			}
		}

		this.SetGoodsExchangeData = (type?, exchange_list?) => {
			goods_exchange_dic_[type] = exchange_list
		}

		this.GetGoodsExchangeData = (type?) => {
			return goods_exchange_dic_[type]
		}

		this.GetBagGoodsDic = () => {
			return bag_goods_dic_
		}

		this.CreateExtraAttr = (best_str?) => {
			let list = ErlangParser.GetInstance().Parse(best_str)
			let tlist = []
			let vo = []
			for (let _tmpi in list) {
				let info = list[_tmpi]
				table.insert(
					tlist,
					{
						color: Number(info[0]),
						type_id: Number(info[1]),
						attr_id: Number(info[2]),
						attr_val: Number(info[3]),
						plus_interval: Number(info[4]),
						plus_unit: Number(info[5])
					}
				)
			}
			return tlist
		}

		this.setGoodCoolingData = (data?) => {
		
			// let newData = !_CoolingGoodData_[data.goods_id]
		
			// _CoolingGoodData_[data.goods_id] = data
			// if (newData) {
			// 	let goodsVo = this.GetGoodsVoByGoodsId(data.goods_id)
			// 	if (goodsVo) {
			// 		ItemUseModel.GetInstance().UpdateBagGoodsCooling(goodsVo)
			// 		this.DelayFire(local_GoodsModel.UPDATE_GOODS_NUM, { goodsVo })
			// 	}
			// }
		
			// _CoolingGoodData_[data.goods_id] = data
			// if (data.freeze_endtime > TimeUtil.getServerTime()) {
		
			// 	cooling_time_dic_[data.goods_id] = data
			// }
		
			// let callback = request_cooling_callback_[data.goods_id]
			// if (callback) {
			// 	callback(data)
		
			// 	request_cooling_callback_[data.goods_id] = null
			// }
			// this.refresh_CoolingGoods_RedDot()
		}

		this.getGoodCoolingData = (goods_id?, callback?, needRequest?, notRequest?) => {
			let vo = _CoolingGoodData_[goods_id]
			if (notRequest) {
				return vo
			}
			if (vo && !needRequest) {
				if (callback) {
					callback(vo)
				}
			} else {
				request_cooling_callback_[goods_id] = callback
				this.Fire(local_GoodsModel.REQUEST_GOODS_COOLING, goods_id)
			}
		}

		this.cleanCoolingDataById = (goods_id?) => {
			let data = _CoolingGoodData_[goods_id]
			if (data) {
				delete _CoolingGoodData_[goods_id]
			}
		}

		this.refresh_CoolingGoods_RedDot = () => {
			if (Util.TableSize(cooling_time_dic_) > 0) {
				if (!coolingTimer_) {
					coolingTimer_ = GlobalTimerQuest.AddDelayQuest(this.onCoolingTimer, 1) // egret. new Timer(1000, 0)
					//coolingTimer_:addEventListener(egret.TimerEvent.TIMER, this.onCoolingTimer, this)
				}
				//if (! coolingTimer_.running ) {
				//coolingTimer_:start()
				//this:onCoolingTimer()
				//}
			}
		}

		this.onCoolingTimer = () => {
			for (let key in cooling_time_dic_) {

				if (cooling_time_dic_[key]) { // :hasOwnProperty(key)
					let goods = cooling_time_dic_[key]
					if (TimeUtil.getServerTime() >= goods.freeze_endtime && !BagModel.GetInstance().has_show_red[goods.goods_id]) {
						delete cooling_time_dic_[goods.goods_id]
						this.Fire(local_GoodsModel.REFRESH_COOLING_REDDOT, goods.goods_id)
					}
				}
			}
			if (Util.TableSize(cooling_time_dic_) <= 0) {
				this.cleanCoolingTimer()
			}
		}

		this.cleanCoolingTimer = () => {
			if (coolingTimer_) {
				//if (coolingTimer_.running ) {
				//coolingTimer_:stop()
				//}
				//coolingTimer_:removeEventListener(egret.TimerEvent.TIMER, this.onCoolingTimer, this)
				//coolingTimer_ = null
				GlobalTimerQuest.CancelQuest(coolingTimer_)
				coolingTimer_ = null
			}
		}

		this.coolingGoodsCanUse = (goods_id?) => {
			let flag = false
			let data = this.getGoodCoolingData(goods_id, null, false, true)
			if (data) {
				flag = TimeUtil.getServerTime() >= data.freeze_endtime
			}
			return flag
		}

		this.GetEquipList = () => {
			let list = []
			for (let _tmpi in this.bag_goods_list) {
				let vo = this.bag_goods_list[_tmpi]
				if (vo.type == 10) {
					table.insert(list, vo)
				}
			}
			return list
		}

		this.GetMonBookList = () => {
			let list = []
			for (let _tmpi in this.bag_goods_list) {
				let vo = this.bag_goods_list[_tmpi]
				if (vo.type == 53) {
					table.insert(list, vo)
				}
			}
			return list
		}

		this.GetBagGoodsNum = (type_id?) => {
			type_id = Number(type_id)
			let num = 0
			for (let _tmpi in this.bag_goods_list) {
				let vo = this.bag_goods_list[_tmpi]
				if (vo.type_id == type_id) {
					num = num + vo.goods_num
				}
			}
			return num
		}

		this.IsEquip = (goods_vo?) => {
			if (goods_vo) {
				return goods_vo.type == 10
			}
		}

		this.IsTreasureBagGoods = (goods_id?) => {
			return treasure_goods_dic_[goods_id]
		}

		this.CheckCoinEnough = (type?, need?, is_alert?, enough_func?, not_show_msg?, not_use_diamond?) => {
			let is_enough = false
			let gap = 0
			if (type == GoodsType.diamond) {
				let jin = role_mgr.GetMainRoleVo().jin
				is_enough = jin >= need
				if (!is_enough) {
					gap = need - jin
				}
				if (!is_enough && is_alert) {
					if (!not_show_msg) {
						Message.show("勾玉不足")
					}
					let call_fun = () => {
						let id =
							setTimeout(() => {
								clearTimeout(id)
								OpenFun.OpenFunHandler(21)
							},
								0.28
							)
					}

					NotEnougnDiamond(null, call_fun)
				}
			} else if (type == GoodsType.bind_diamond) {
				let jinLock = role_mgr.GetMainRoleVo().jinLock
				let jin = role_mgr.GetMainRoleVo().jin
				if (jinLock >= need) {
					is_enough = true
				} else {
					if (not_use_diamond) {
						is_enough = jinLock >= need
					} else {
						is_enough = jin + jinLock >= need
					}
					if (!is_enough) {
						if (not_use_diamond) {
							gap = need - jinLock
						} else {
							gap = need - (jin + jinLock)
						}
					}
					if (!is_enough && is_alert) {
						if (!not_show_msg) {
							Message.show("绑玉不足")
						}
						let call_fun = () => {
							let id =
								setTimeout(() => {
									clearTimeout(id)
									OpenFun.OpenFunHandler(21)
								},
									0.280
								)
						}

						let str = "当前绑玉不足，是否前往充值"
						NotEnougnDiamond(str, call_fun)
					} else if (is_enough && is_alert) {
						let str = HtmlColorTxt(need - jinLock, Enum_ColorUtil_Dark.GREEN)
						Alert.Show(Util.StrToHTML("当前绑玉不足，是否消耗" + str + "勾玉代替"), Alert_Type.Two, enough_func)
						Alert.SetIsCharge(true)
						return is_enough
					}
				}
			} else if (type == GoodsType.coin) {
				let tong = role_mgr.GetMainRoleVo().tong
				is_enough = tong >= need
				if (!is_enough) {
					gap = need - tong
				}
				if (!is_enough && is_alert) {
					if (!not_show_msg) {
						Message.show("铜币不足")
					}
					// let ndata = local_Config.ConfigNotNormalGoods[3]
					// MaterialsTool.GetInstance().materialsTips(ndata.goods_id)
				}
			}
			if (is_enough && enough_func) {
				enough_func(true)
			}
			return [is_enough, gap]
		}

		this.RefreshtGoods = (basic?, GoodsVo?) => {
			this.SetBaseInfo(GoodsVo)
			if (basic.type == 35) { // 冷却礼包
				this.getGoodCoolingData(
					GoodsVo.goods_id, () => {
						// local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
					}
				)
			}
			if (basic.type == 38 && basic.subtype == 7) { // 离线卡
				let time =
					OnHookModel.GetInstance().max_outline_time -
					Number(DailyModel.GetInstance().outline_info || OnHookModel.GetInstance().GetOnhookTime())
				let need_num = null
				if (time > 0) {
					for (let _tmpi in OnHookModel.GetInstance().goods_type) {
						let type = OnHookModel.GetInstance().goods_type[_tmpi]
						if (type == GoodsVo.type_id) {
							need_num = Math.floor(time / OnHookModel.GetInstance().add_time[type])
						}
					}
				}
				if (need_num && need_num > 0) {
					//let have_num = GoodsVo.goods_num
					//GoodsVo.goods_num = have_num >= need_num && need_num || have_num
					local_GlobalEventSystem.Fire(local_EventName.OPEN_ITEM_USE_VIEW, GoodsVo)
				}
			}
		}

		this.soulTypeGoodsNum = (goods_id?, type_id?) => {
			let num = 0
			for (let _tmpi in this.soulbag_goods_list) {
				let vo = this.soulbag_goods_list[_tmpi]
				if (vo.goods_id == goods_id) {
					break
				}
				let awake = false
				for (let key in vo.awake_list) {

					let info = vo.awake_list[key]
					if (info.awake_lv > 0) {
						awake = true
						break
					}
				}
				if (awake) {
					break
				}
				if (vo.type_id == type_id) {
					num = num + 1
				}
			}
			return num
		}

		this.soulTypeGoodsList = (goods_id?, type_id?, needNum?) => {
			let list = []
			let num = 0
			for (let _tmpi in this.soulbag_goods_list) {
				let vo = this.soulbag_goods_list[_tmpi]
				if (vo.goods_id == goods_id) {
					break
				}
				let awake = false
				for (let key in vo.awake_list) {

					let info = vo.awake_list[key]
					if (info.awake_lv > 0) {
						awake = true
						break
					}
				}
				if (awake) {
					break
				}
				if (vo.type_id == type_id) {
					table.insert(list, vo.goods_id)
					num = num + 1
				}
				if (num >= needNum) {
					break
				}
			}
			return list
		}

		this.GetStarEquipListBuyPage = (page?) => {
			return this.starEquipList[page] || []
		}

		this.GetStarEquipBuyPagePos = (page?, pos?) => {
			let pageList = this.starEquipList[page]
			return pageList && pageList[pos] || null
		}

		this.GetStarEquipPageNum = (page?, need_is_suit?) => {
			let num = 0
			let list = this.starEquipList[page]
			if (list) {
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					if (need_is_suit) {
						if (vo && vo.is_suit) {
							num = num + 1
						}
					} else {
						num = num + 1
					}
				}
			}
			return num
		}

		this.ResetBagData()
		this.ResetRuneBagData()
		this.GetGiftBagCfg = (type_id?, cond_level?) => {
			let cfg = null
			let gift_cfg = Config.PRELOAD_SERVER_CONFIG.config_gift_reward
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let info = null
			for (let key in gift_cfg) {
				info = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_gift_reward.name, key, false, gift_cfg)
				if(info.goods_id == type_id && (info.sex == 0 || info.sex == role_vo.sex) && (info.career == 0 || info.career == role_vo.career)){
					if (!cond_level) {
						cfg = info;
						break
					} else{
						if (info.slv <= cond_level && info.elv >= cond_level) {
							cfg = info
							break
						}
					}
				}
			}
			return cfg
		}



		this.GetGiftBagCondLevel = (type_id?, cfg?) =>{
			if(!type_id && !cfg)
			if(!cfg){
				cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, type_id, false);
			}
			let cond = cfg.filter
			if(cond != "[]"){
				cond = ErlangParser.GetInstance().Parse(cond)
				for(let k in cond){
					let v = cond[k]
					switch(v){
						case 'mod_level':
							return BossModel.GetInstance().GetHuntingLevel()
						case 'lv':
							return RoleManager.GetInstance().GetMainRoleLevel()
						case 'rune':
							return BaseDungeonModel.GetInstance().GetRuneCurFloor()
						case 'open_day':
							return ServerTimeModel.GetInstance().GetOpenServerDay()
					}
				}
			}
		}

		this.GetGiftBagDynamic = (goods_id?, _type_id?, call_fun?) => {
			this.gift_bag_dynamic_call_back = call_fun
			this.Fire(local_GoodsModel.REQUEST_GIFT_BAG_MSG, goods_id, _type_id)
		}

		this.GetGodBefullGoodsNum = (type_id?) => {
			let list = this.god_bag_list
			if (!list || list.length <= 0) {
				return
			}
			let goods_num = 0
			for (let i = 0; i < list.length; i++) {
				if (list[i].type_id == type_id) {
					goods_num = goods_num + 1
				}
			}
			return goods_num
		}

		this.GetRuneBagDic = () => {
			return runebag_goods_dic_
		}

		this.ReSetDynamic = () => {
			first_dynamic_equip_ = null
		}

		this.GetWearEquipByType = (type?) => {
			if (type) {
				return this.wear_equip_list[Number(type)]
			}
		}

		this.HaveHightExpBuff = (now, use) => {
			let exp_buff_dic = {
				37020001: 1.5,
				37020002: 2,
				37020003: 3,
				37020004: 4,
				37020005: 2.5
			}
			let now_val = exp_buff_dic[now]
			let use_val = exp_buff_dic[use]
			if (now_val && use_val) {
				if (now_val > use_val) {
					return 2
				} else if (now_val < use_val) {
					return 1
				}
			}
			return 0
		}
	}

	/**
	 * 获取指定道具类型以及道具子类型的所有道具
	 * @param type 道具类型
	 * @param subType 道具子类型 不填写的话只会检索大类型
	 */
	public GetItemsByTypeOrSubType(type: number, subType?: number) {
		let list = []
		for (let _tmpi in this.bag_goods_list) {
			let vo = this.bag_goods_list[_tmpi]
			if (vo.type == type && (subType ? subType == vo.subtype : true)) {
				table.insert(list, vo)
			}
		}
		return list
	}

	/**
	 * 是否需要提示经验书
	 */
	public IsExpBoolTips(type: number = 37, subType: number = 9) {
		let effect_cfgs = Config.PRELOAD_SERVER_CONFIG.config_goods_effect
		let goods = this.GetItemsByTypeOrSubType(type, subType) // 人物直升书
		let roleLv: number = RoleManager.GetInstance().GetMainRoleVo().level;
		let tipsStr: string = '已达最佳使用等级,抓紧使用';

		goods = goods.filter((item) => {
			let conf = effect_cfgs[item.type_id];
			if (!conf) {
				return false;
			}
			let useLevel: number = JSON.parse(conf.effect_list)[0][1][0];
			return roleLv >= (useLevel - item.goods_num)
		});



		if (goods.length > 0) {
			goods.sort((a, b) => {
				return b.color - a.color;
			});
			ViewPopLevelModel.GetInstance().SetView('GoodsExpiredView', goods, tipsStr, 1);
			this.expBookTips = true;
		}

	}
	/** 自选礼包配置映射map*/ 
	optional_gift_Map
	/**
	 * 初始化自选礼礼包配置数据
	 */
	public inintOptionalGiftMap(){
		this.optional_gift_Map = {};
		let optional_gift_cfgs = Config.PRELOAD_SERVER_CONFIG.config_optional_gift
		for (const key in optional_gift_cfgs) {
			let temp = optional_gift_cfgs[key];
			let mapKey: string = `${temp.goods_id}@${temp.career}`;
			if(this.optional_gift_Map[mapKey] == null){
				this.optional_gift_Map[mapKey] = [];
			}
			table.insert(this.optional_gift_Map[mapKey], temp)
		}
		
		for (const girt_key in this.optional_gift_Map) {
			if(this.optional_gift_Map[girt_key] && this.optional_gift_Map[girt_key].length > 1){
				table.sort(this.optional_gift_Map[girt_key], (a, b) => {
					return a.slv == b.slv ? a.sopen_day < b.sopen_day : a.slv < b.slv
				})
			}
		}
	}
	/**
	 * 获取自选礼包配置
	 * @param typeId 道具id\礼包id
	 * @param career 职业
	 */ 
	public getOpGiftVoByTypeIdAndCareer(typeId:number | string, career?:number | string){
		if(career == null){
			career = 0
		}
		let _list:any[] = this.optional_gift_Map[`${typeId}@${career}`];
		if(!_list || _list.length == 0) return null;
		let _level: number = RoleManager.GetInstance().GetMainRoleVo().level;
		let _open_day: number = ServerTimeModel.GetInstance().GetOpenServerDay();
		let vo;
		for (let i = 0, len = _list.length; i < len; i++) {
			let temp = _list[i]
			let _vo_s_level = temp.slv || 1;
			let _vo_e_level = temp.elv || 99999;
			let _vo_s_day = temp.sopen_day || 1;
			let _vo_e_day = temp.eopen_day || 99999;
			if(_level >=  _vo_s_level && _level <= _vo_e_level && _open_day >=  _vo_s_day && _open_day <= _vo_e_day){
				vo = temp;
				break
			}
		}
		if(!vo){
			vo = _list[0]
		}
		return vo
	}

}
window["GoodsModel"] = GoodsModel