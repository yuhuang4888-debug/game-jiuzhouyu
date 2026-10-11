import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { RoleManager } from "./RoleManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { HtmlColorTxt } from "../util/Util"
import { DragonBallModel } from "./DragonBallModel"
import { EquipDefine, EquipModel } from "./EquipModel"
import { GoodsModel } from "./GoodsModel"
import { GuardModel } from "./GuardModel"

export class BagModel extends EventDispatcher {
	CreateBagFullList
	show_exp_tips_view
	GetStageDropData
	smelt_list
	fragment_list
	smeltNum
	dropStage
	isShowRed
	SelectSmeltGoods
	CurExp
	BagOneKeyRed
	GetSmeltList
	typeList
	GetOneKeyUseList
	bag_full_list
	smelt_number
	smeltSelectList
	bagViewOpen
	oneStar
	InitCfg
	smelt_level
	smelt_exp
	ware_full_list
	ShowBagRed
	config_goods_exchange_rule
	ClearSmletSelect
	protect_max_count
	CreateWarehouseList

	use_select_dic
	dropColor
	autoSmelt
	devour_number
	can_fragment_exchange
	SelectTab
	GetColorDropData
	ShowFullView
	has_show_red
	devour_list
	notShowTwoStarTips
	smeltMax
	CeateSmeltList

	oneKeyUseList = []

	public static SMELTING_SUCCESS = "SMELTING_SUCCESS";
	public static UPDATE_SELECE_GIFT = "UPDATE_SELECE_GIFT";
	public static SET_SELECT_GIFT_NUM = "SET_SELECT_GIFT_NUM";
	public static OPEN_VIEW = "OPEN_VIEW";
	public static ONE_KEY_TAB = "BE1";
	public static UPDATE_SMELT_DROP = "BE2";
	public static REQUEST_PROTO = "BE3";
	public static CONTRAST_EQUIP = "BE4";
	public static CLOSE_CONTRAST = "BE5";
	public static FULL_BAG = "BE6";
	public static UPDATE_ONE_KEY_RED = "BE7"
	public static fragment_type = 5;
	public static expandGoods = 38250026;
	public static expandNeed = 2;
	public static IlluType = { "16": 3, "17": 3, "18": 3, "19": 3, "20": 3, "21": 3, "22": 3, "12": 1, "38": 6, "68": 0, "69": 1, "73": 2, "25": 3 };
	public static Index = { Goods: 0, Warehouse: 1, HolySeal: 2, Revelation: 3, Longlang: 4 };
	static Instance: BagModel
	useRed: any
	smeltRed: any
	onekeyUseRed: any
	show_fly_pos: any
	public constructor() {
		super()

		if (BagModel.Instance) {
			return
		}
		this.bag_full_list = [];
		this.ware_full_list = [];
		this.devour_list = [];
		this.smelt_list = [];
		this.devour_number = 0;
		this.smelt_number = 0;
		this.smelt_level = 0;
		this.smelt_exp = 0;
		this.protect_max_count = 30;
		this.show_exp_tips_view = true;
		this.fragment_list = [];
		this.can_fragment_exchange = false;
		this.has_show_red = [];
		this.use_select_dic = {};
		this.oneStar = true;
		this.smeltSelectList = {};
		this.smeltNum = 0;
		this.smeltMax = 50;
		this.CurExp = 0;
		this.typeList = [{ name: "礼包", type: 32, sub_type: 0 }, { name: "经验书", type: 37, sub_type: 0 }, { name: "其他", type: -1, sub_type: 0 }];
		this.dropColor = 4;
		this.dropStage = 99;
		this.ShowFullView = { "4": true, "45": true };
		this.bagViewOpen = [];
		this.notShowTwoStarTips = false;


		let goods_model = GoodsModel.GetInstance()
		let equip_model = EquipModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_Config = Config
		let local_BagModel = BagModel
		let guard_model = GuardModel.GetInstance()
		let dragonbll_model = DragonBallModel.GetInstance()
		let lock_count_ = 18
		let SmeltEspGoods_ = 38250022
		this.CreateBagFullList = () => {
			goods_model.SortBagGoodsList()
			if (!this.bag_full_list) {
				this.bag_full_list = []
			}
			for (let i = 0; i < goods_model.bag_goods_list.length; i++) {
				this.bag_full_list[i] = goods_model.bag_goods_list[i]
			}
			for (let index = goods_model.bag_goods_list.length; index < goods_model.bag_goods_max_cell; index++) {
				this.bag_full_list[index] = { color: 0 }
			}
			let lockNum = lock_count_ - goods_model.bag_goods_max_cell % 6
			for (let index = 0; index < lockNum; index++) {
				this.bag_full_list[goods_model.bag_goods_max_cell + index] = { color: -1, index: index + 1 }
			}
		}

		this.GetSmeltList = (stage?, color?, equip_attr_cfg?, equip_fusion_cfg?) => {
			if (equip_attr_cfg && equip_fusion_cfg) {
				let list = this.smelt_list
				this.smeltSelectList = {}
				this.smeltNum = 0
				let exp = 0

				//吞噬精华
				let goodsList = goods_model.GetTypeGoods(SmeltEspGoods_)
				for (let key in goodsList) {
					let Vo = goodsList[key]
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_fusion.name, Vo.type_id, false, equip_fusion_cfg)
					if (c) {
						exp = exp + c.fusion_exp * Vo.goods_num
						this.smeltNum = this.smeltNum + 1
						this.smeltSelectList[Vo.goods_id] = Vo.goods_num
					}
				}


				//装备
				for (let _tmpi in list) {
					var vo = list[_tmpi]

					let equip_attr = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, vo.type_id, false, equip_attr_cfg)
					if (equip_attr) {

						let wear_equip_info = equip_model.GetWearEquipInfo(vo.equip_type)
						let boo1 = !this.smeltSelectList[vo.goods_id]
						let boo2 = (equip_attr.star <= 1 && vo.equip_type != 7) && vo.equip_type != 9
						let boo3 = (vo.career_id != 0 && vo.career_id != role_mgr.GetMainRoleVo().career || vo.sex != 0 && vo.sex != role_mgr.GetMainRoleVo().sex)
							|| wear_equip_info && wear_equip_info.rating >= vo.rating
						let boo4 = equip_attr.stage <= stage && vo.color <= color


						if (boo2 && boo3 && boo4 && boo1) {
							if (equip_attr.star == 0 || (this.oneStar && equip_attr.star == 1)) {
								this.smeltSelectList[vo.goods_id] = vo.goods_num
								let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_fusion.name, vo.type_id, false, equip_fusion_cfg)
								exp = exp + c.fusion_exp
								this.smeltNum = this.smeltNum + 1
								if (this.smeltNum >= this.smeltMax) {
									break
								}
							}
						}
					}
				}
				this.ChangeVar("CurExp", exp)
				this.Fire(local_BagModel.UPDATE_SMELT_DROP)
			}
		}

		this.InitCfg = () => {
			this.config_goods_exchange_rule = local_Config.PRELOAD_SERVER_CONFIG.config_goods_exchange_rule
			let obj = CookieWrapper.GetInstance().GetCookie(CookieWrapper.BAG_SMELT_STATE, true)
			if (obj) {
				let info = ErlangParser.GetInstance().parse(obj)
				//this.autoSmelt = info.autoSmelt || false
				this.oneStar = info.oneStar || true
				this.dropColor = info.drop_color || 4
				this.dropStage = info.drop_stage || 99
			}
		}

		this.isShowRed = () => {
			return ((this.useRed || this.smeltRed) || (role_mgr.mainRoleInfo.level < EquipDefine.NOT_SHOW_OND_KEY_WEAR_DOT_LV && equip_model.GetStrongEquipsRed()))
				|| guard_model.GetGuardRed(1) || guard_model.GetGuardRed(2) || guard_model.GetGuardRed(3) || guard_model.GetGuardRed(4) || dragonbll_model.GetRedState()
		}

		this.ShowBagRed = () => {
			let role_lv = role_mgr.GetMainRoleVo().level
			let changeUesRed = false
			let ChangeOnekeyRed = false
			let ChangeSmeltRed = false
			let checkSmelt = false
			let color = null
			let goodsList = goods_model.bag_goods_list
			if (goods_model.bag_goods_max_cell - goodsList.length <= 30) {
				checkSmelt = true
			}
			for (let _tmpi in goodsList) {
				var vo = goodsList[_tmpi]
				let GoodsVo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, vo.type_id, false)
				if (GoodsVo) {
					if (GoodsVo.type == 35) {
						let flag = goods_model.coolingGoodsCanUse(vo.goods_id) && !this.has_show_red[vo.goods_id]
						if (flag && !changeUesRed) {
							this.ChangeVar("useRed", true)
							changeUesRed = true
						} else {
							break
						}
					}
					if (GoodsVo.use_one_key != 0 && role_lv >= GoodsVo.level) {
						changeUesRed = true
						ChangeOnekeyRed = true
						this.ChangeVar("useRed", true)
						this.ChangeVar("onekeyUseRed", true)
					}
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, GoodsVo.type_id, false)
					if (((checkSmelt && !ChangeSmeltRed) && c) && GoodsVo.color <= this.dropColor) {
						let equip = c
						let wear_equip_info = equip_model.GetWearEquipInfo(vo.equip_type)
						if ((((equip && (equip.star == 0 || equip.star == 0 && this.oneStar)) && equip.stage <= this.dropStage) && vo.equip_type != 7) && vo.equip_type != 9) {
							if (wear_equip_info) {
								if (wear_equip_info.rating >= vo.rating) {
									this.ChangeVar("smeltRed", true)
									ChangeSmeltRed = true
									checkSmelt = false
								}
							} else {
								this.ChangeVar("smeltRed", true)
								ChangeSmeltRed = true
								checkSmelt = false
							}
						}
					}
					if ((changeUesRed && ChangeOnekeyRed) && ChangeSmeltRed) {
						return true
					}
				}
			}
			if (!ChangeOnekeyRed) {
				this.ChangeVar("onekeyUseRed", false)
			}
			if (!changeUesRed) {
				this.ChangeVar("useRed", false)
			}
			if (!ChangeSmeltRed) {
				this.ChangeVar("smeltRed", false)
			}
			return this.useRed || this.smeltRed
		}

		this.BagOneKeyRed = () => {
			let role_lv = role_mgr.GetMainRoleVo().level
			for (let _tmpi in goods_model.bag_goods_list) {
				var vo = goods_model.bag_goods_list[_tmpi]
				let GoodsVo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, vo.type_id, false)
				if (!GoodsVo) {
					break
				}
				if (GoodsVo.use_one_key != 0 && role_lv >= GoodsVo.level) {
					return true
				}
			}
			return false
		}

		this.GetOneKeyUseList = (goods_cfg?, selectAll?) => {
			if (selectAll) {
				this.use_select_dic = []
			}
			this.oneKeyUseList.length = 0
			let role_lv = role_mgr.GetMainRoleVo().level
			for (let _tmpi in goods_model.bag_goods_list) {
				var vo = goods_model.bag_goods_list[_tmpi]
				let goods_vo = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_goods.name, vo.type_id, false, goods_cfg)
				if (goods_vo) {
					if (goods_vo.use_one_key != 0 && role_lv >= goods_vo.level) {
						this.oneKeyUseList.push(vo)
						if (selectAll) {
							this.use_select_dic[vo.goods_id] = true
						}
					}
				}
			}
			return this.oneKeyUseList
		}

		this.SelectTab = (bool?, type_id?, sub_type?) => {
			let list = this.oneKeyUseList
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				let sameType = false
				if (type_id == -1) {
					sameType = true
					for (let _tmpi in this.typeList) {
						var TypeInfo = this.typeList[_tmpi]
						if ((TypeInfo.type != -1 && vo.type == TypeInfo.type) && (TypeInfo.sub_type == 0 || TypeInfo.sub_type == vo.subtype)) {
							sameType = false
							break
						}
					}
				} else if (type_id == vo.type && (sub_type == 0 || sub_type == vo.subtype)) {
					sameType = true
				}
				if (sameType) {
					if (bool) {
						if (!this.use_select_dic[vo.goods_id]) {
							this.use_select_dic[vo.goods_id] = true
						}
					} else {
						if (this.use_select_dic[vo.goods_id]) {
							delete this.use_select_dic[vo.goods_id]
						}
					}
				}
			}
		}

		this.CreateWarehouseList = () => {
			if (!this.ware_full_list) {
				this.ware_full_list = {}
			}
			for (let index = 0; index < goods_model.warehouse_goods_list.length; index++) {
				this.ware_full_list[index] = goods_model.warehouse_goods_list[index]
			}
			for (let index = goods_model.warehouse_goods_list.length; index < goods_model.warehouse_max_cell; index++) {
				this.ware_full_list[index] = { color: 0 }
			}
			for (let index = 0; index < (lock_count_ - goods_model.warehouse_max_cell % 6); index++) {
				this.ware_full_list[goods_model.warehouse_max_cell + index] = { color: -1, index: index + 1 }
			}
		}

		this.CeateSmeltList = (equip_fusion_cfg?) => {
			this.smelt_list = []
			let baglist = goods_model.bag_goods_list
			for (let i = 0; i < baglist.length; i++) {
				let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_fusion.name, baglist[i].type_id, false, equip_fusion_cfg)
				if (cfg) {
					table.insert(this.smelt_list, baglist[i])
				}
			}
		}

		this.ClearSmletSelect = () => {
			this.smeltSelectList = {}
			this.smeltNum = 0
			this.ChangeVar("CurExp", 0)
			this.Fire(local_BagModel.UPDATE_SMELT_DROP)
		}

		this.SelectSmeltGoods = (id?, type_id?, bool?, equip_fusion_cfgs?, goods_num?) => {
			if (goods_num == null) {
				goods_num = 1
			}
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_fusion.name, type_id, false, equip_fusion_cfgs)
			if (cfg) {
				if (bool) {
					this.ChangeVar("CurExp", this.CurExp + cfg.fusion_exp * goods_num)
					this.smeltSelectList[id] = goods_num
					this.smeltNum = this.smeltNum + 1
				} else if (this.smeltSelectList[id]) {
					this.ChangeVar("CurExp", this.CurExp - cfg.fusion_exp * this.smeltSelectList[id])
					delete this.smeltSelectList[id]
					this.smeltNum = this.smeltNum - 1
				}
			}
		}

		this.GetStageDropData = () => {
			let drop = []
			table.insert(drop, { id: 0, content: "任意阶数", cond: 99 })
			table.insert(drop, { id: 0, content: "清空选择" })
			let i = 4
			if (i <= 15) {
				do {
					table.insert(drop, { id: i, content: WordManager.ConvertNum(i) + "阶及以下", cond: i })
					i = i + 1
				} while (i <= 15)
			}
			return drop
		}

		this.GetColorDropData = () => {
			let drop = []
			table.insert(drop, { id: 0, content: "任意品质", cond: 99 })
			table.insert(drop, { id: 0, content: "清空选择" })
			let i = 0
			do {
				let color = i + 2
				// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {
				// 	table.insert(drop, { id=i, content="อุปกรณ์" + ColorUtil.GetColorName(color), cond=color })
				// } else {
				table.insert(drop, { id: i, content: HtmlColorTxt(ColorUtil.GetColorName(color) + "装备", ColorUtil.GetColorDark(color)), cond: color })
				// }

				i = i + 1
			} while (i < 4)
			return drop
		}


	}

	public static GetInstance() {

		if (!BagModel.Instance) {
			BagModel.Instance = new BagModel()
		}
		return BagModel.Instance
	}

}
window["BagModel"] = BagModel