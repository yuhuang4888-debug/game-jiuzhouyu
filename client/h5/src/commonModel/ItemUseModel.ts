import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { MainUIController } from "../commonController/MainUIController"
import { RoleManager } from "./RoleManager"
import { GoodsItem } from "../sysInfo/GoodsItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { attributePotionModel } from "./attributePotionModel"
import { BabyModel } from "./BabyModel"
import { DsgtModel } from "./DsgtModel"
import { EquipModel } from "./EquipModel"
import { FashionModel } from "./FashionModel"
import { GoodsModel } from "./GoodsModel"
import { MedalModel } from "./MedalModel"
import { OutWardBaseModel } from "./OutWardBaseModel"
import { HolySealModel } from "./HolySealModel"
import { ViewPopLevelModel } from "./ViewPopLevelModel"
import { table } from "../common/table"
import { OutLineModel } from "./OutLineModel"
import { DailyModel } from "./DailyModel"

export class ItemUseModel extends EventDispatcher {

	public static _instance

	SetVoInGoodsDic
	ClearData
	ContainEquipRecord
	DeleteOneEquipRecord
	UpdateBagGoodsAsSell
	GetItemShowVo
	UpdateBagGoodsCooling
	ClearTypeIdData
	IsMatchCondition
	SaveEquipRecord
	ForceTryShowItemUse
	LoadCfg
	ClearEquipList
	ClearEquipRecord
	GetVoByTypeId
	ContainGoodsId
	GetTypeGoodsNum
	UpdateBagGoodsDic

	//####上线挂机弹窗逻辑优化
	SaveShowList				//自动使用弹窗限制在N秒后才能弹出 在N秒之前的数据都先存放在此
	CheckShowList
	is_wait_time = true      	//上线N秒后播放物品自动使用
	delay_show_list = []
	SaveCacheList				//自动使用弹窗在打开的时候，再次进数据先存放在此
	CheckCacheList
	delay_list_cache = []
	CheckItemUseVoExist           //看看这个物品是否已经被使用 如果已经被使用将不会弹出

	public static DELETE_CUR_ITEM = "DELETE_CUR_ITEM";
	public static UPDATE_EQUIP_DATA = "UPDATE_EQUIP_DATA";
	public constructor() {
		super()

		if (ItemUseModel._instance) {
			return
		}
		let goods_model = GoodsModel.GetInstance()
		let equip_model = EquipModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let ConfigHasDefaultValue = Config.ConfigHasDefaultValue
		let local_Config = Config
		let common_mgr = CommonManager.GetInstance()
		let goods_dic_ = {}
		let equip_list_ = []
		let equip_record_dic_ = []
		this.LoadCfg = () => {

		}

		this.SetVoInGoodsDic = (vo?, is_check_compose?) => {
			let goodsbasic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
			if (goodsbasic) {
				if (this.ContainEquipRecord(vo.type_id)) {
					return
				}
				let wear_equip_info = equip_model.GetWearEquipInfo(goodsbasic.equip_type)
				if (wear_equip_info && wear_equip_info.goods_id == vo.goods_id) {
					return
				}
				let career = role_mgr.GetMainRoleVo().career
				let diff_career = goodsbasic.career_id != 0 && goodsbasic.career_id != career
				let ditt_sex = goodsbasic.sex != 0 && role_mgr.GetMainRoleVo().sex != goodsbasic.sex
				if (diff_career || ditt_sex) {
					return
				}
				if (vo.type == 10) {
					if (wear_equip_info && vo.rating <= wear_equip_info.rating) {
						let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.ClientItemUse.name, vo.type_id, true)
						if (cfg && cfg.compose) {
							if (!is_check_compose) {
								this.ClearTypeIdData(vo.goods_id)
								return
							} else {
								goods_dic_[vo.goods_id] = vo
								return
							}
						}
					}
					let rating_data = equip_list_[goodsbasic.equip_type]
					if (rating_data && vo.rating <= rating_data.rating) {
						return
					} else {
						if (rating_data) {
							this.ClearTypeIdData(rating_data.goods_id)
							this.Fire(ItemUseModel.UPDATE_EQUIP_DATA, vo, rating_data.goods_id)
						}
						equip_list_[goodsbasic.equip_type] = vo
					}
				} else if (vo.type == 38 && vo.subtype == 29) {
					if (is_check_compose) {
						return
					}
				} else if (vo.type_id == 37070001) {
					/*
					if (GuildModel.GetInstance()._prestige_limit_mark) {
						return
					}
					*/
				} else if (vo.type == 12) {
					let model:FashionModel = FashionModel.GetInstance()
					if (model.IsActive(1, vo.type_id) && !model.IsRed(1, vo.type_id, true)) {
						return
					}
				} else if (vo.type == HolySealModel.GOODS_TYPE) { // 影装
					let model: HolySealModel = HolySealModel.GetInstance();
					// 判断是否有比身上穿戴的更加高级
					let equip = model.GetWearEquipByPos(vo.subtype);
					let bool = false;
					let conf = Config.PRELOAD_SERVER_CONFIG.config_seal_equip;
					if (equip && vo.color == 3 && equip.color > 3) {
						let equip_data = model.GetHolySealData(equip.type_id, conf);
						let now_data = model.GetHolySealData(vo.type_id, conf);
						if (equip_data && now_data && now_data.stage - equip_data.stage > 5) {
							bool = true;
						}
					} else {
						if (!equip || vo.rating > equip.rating) {
							bool = true;
						}
					}
					if (!bool) {
						return;

					}

				}
			}
			goods_dic_[vo.goods_id] = vo
		}

		/***物品增加更新*/
		this.UpdateBagGoodsDic = (vo?, is_check_compose?, is_frist?) => {
			if (is_check_compose == null) {
				is_check_compose = false
			}
			if (!vo) {
				return
			}

			if (!Util.IsTableEmpty(BaseView1.NOT_SHOW_ITEM_USE_OPEN_VIEW)) {
				this.DeleteOneEquipRecord(vo.type_id)
			}
			

			let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.ClientItemUse.name, vo.type_id, true)
			if (cfg) {
				if ((is_frist && !cfg.first_show) || (!is_frist && cfg.only_first_show)) {
					return
				}
				let goods_vo = goods_model.GetGoodsVoByGoodsId(vo.goods_id)
				let exist_num = null
				if (goods_vo) {
					exist_num = goods_vo.goods_num
				}
				if (exist_num) {
					let last_num = vo.goods_num
					if (exist_num > last_num) {
						let cur_vo = goods_dic_[vo.goods_id]
						if (cur_vo) {
							cur_vo.goods_num = cur_vo.goods_num - (exist_num - last_num)
							if (cur_vo.goods_num <= 0) {
								delete goods_dic_[vo.goods_id]
							}
						}
					} else {
						let cur_vo = goods_dic_[vo.goods_id]
						if (cur_vo) {
							cur_vo.goods_num = cur_vo.goods_num + (exist_num - last_num)
						} else {
							this.SetVoInGoodsDic(goods_vo, is_check_compose)
						}
					}
				} else {
					if (vo.goods_num > 0) {
						this.SetVoInGoodsDic(vo, is_check_compose)
					}
				}
			}
		}

		this.UpdateBagGoodsAsSell = (vo?) => {
			let goodsVo = goods_model.GetGoodsVoByGoodsId(vo.goods_id)
			let exist_num = null
			if (goodsVo) {
				exist_num = goodsVo.goods_num
			}
			let last_num = vo.goods_num
			if (exist_num && exist_num > last_num) {
				let cur_vo = goods_dic_[vo.goods_id]
				if (cur_vo) {
					cur_vo.goods_num = cur_vo.goods_num - (exist_num - last_num)
					if (cur_vo.goods_num <= 0) {
						delete goods_dic_[vo.goods_id]
					}
				}
			}
		}

		this.UpdateBagGoodsCooling = (goodsVo?) => {
			goods_dic_[goodsVo.goods_id] = goodsVo
		}

		this.GetItemShowVo = (is_check_compose?) => {
			if (is_check_compose == null) {
				is_check_compose = false
			}
			if (!Util.IsTableEmpty(BaseView1.NOT_SHOW_ITEM_USE_OPEN_VIEW)) {
				return
			}
			//由于itemuseview正在打开，被加入队列的vo
			if (this.delay_list_cache.length > 0) {
				let next_vo = this.delay_list_cache.shift()
				if (!this.CheckItemUseVoExist(next_vo)) {
					return this.GetItemShowVo()  //遍历下一个
				}
				return next_vo
			}
			//从背包里面拿一个出来展示
			let play_lv = role_mgr.GetMainRoleVo().level
			for (let key in goods_dic_) {
				let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.ClientItemUse.name, goods_dic_[key].type_id, true)
				if ((cfg && cfg.min_lv <= play_lv) && play_lv <= cfg.max_lv) {
					let match = this.IsMatchCondition(goods_dic_[key], is_check_compose, cfg)
					if (match) {
						return goods_dic_[key]
					}
				}
			}
			return
		}

		this.IsMatchCondition = (vo?, is_check_compose?, cfg?) => {
			if (!vo) {
				return false
			}
			let roleVo = role_mgr.GetMainRoleVo()
			let goods_basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
			if (goods_basic && goods_basic.turn != 0) {
				let can = roleVo.turn >= goods_basic.turn
				if (!can) {
					return false
				}
			}
			if (goods_basic && goods_basic.level > roleVo.level) {
				return false
			}
			if (goods_basic && goods_basic.type == 10) {
				let wear_equip_info = equip_model.GetWearEquipInfo(goods_basic.equip_type)
				if (!wear_equip_info || wear_equip_info.rating < vo.rating) {
					return true
				}
				if (is_check_compose) {
					if (!common_mgr.CheckFuncOpenState("CompositeView", true)) {
						return false
					}
					if (this.ContainEquipRecord(vo.type_id)) {
						this.ClearTypeIdData(vo.type_id)
						return false
					}
					let cfg = local_Config.GetConfigVo(ConfigHasDefaultValue.ClientItemUse.name, vo.type_id, true)
					if (cfg && cfg.compose) {
						return true
					}
				}
				if (is_check_compose) {
					if (!common_mgr.CheckFuncOpenState("CompositeView", true)) {
						return false
					}
					if (this.ContainEquipRecord(vo.type_id)) {
						this.ClearTypeIdData(vo.type_id)
						return false
					}
					if (cfg && cfg.compose) {
						return true
					}
				}
				return false
			} else if ((goods_basic && vo.type == 38) && vo.subtype == 6) {
				let base_view = MainUIController.GetInstance().GetViewByIndex(1)
				if (base_view && base_view.nowSelectIndex == 2) {
					return false
				}
				let have_num = goods_model.GetTypeGoodsNum(vo.type_id)
				let need_num = DsgtModel.GetInstance().GetDsgtNeedNumByTypeID(vo.type_id)
				return need_num && need_num >= 0 && have_num >= need_num
			} else if (goods_basic && vo.type == 56) {
				let _model = attributePotionModel.GetInstance()
				let config = _model.getAttrConfig(goods_basic.type_id)
				if (!config || _model.Getview_Open()) {
					return false
				}
				return _model.itemRedDot(config.lv, goods_basic.type_id)
			} else if (goods_basic && vo.type == 35) {
				return goods_model.coolingGoodsCanUse(vo.goods_id)
			} else if ((goods_basic && vo.type == 38) && vo.subtype == 7) {
				return false
			} else if ((((goods_basic && vo.type <= 22) && vo.type >= 16) && vo.subtype == 3) || (vo.type == 69 && vo.subtype == 1) || (goods_basic && vo.type == 25 && vo.subtype == 3)) {
				return OutWardBaseModel.GetInstance().CanIllusionUP(vo.type_id, cfg.FuncId)
			} else if (goods_basic && vo.type == 68) {
				/*
				let cfg = await ResManager.GetInstance().LoadGameConfig(this, "config_baby_figure", false)
				let cfg2 = await ResManager.GetInstance().LoadGameConfig(this, "config_baby_figure_star", false)
				let can_up = false
				if (common_mgr.CheckFuncOpenState("BabyMainView", true) && baby_model.activeTime > 0) {
					can_up = baby_model.CanLvUp(cfg.FuncId[1], cfg, cfg2)
				}
				ResManager.GetInstance().DestoryGameConfig(this, "config_baby_figure", false)
				ResManager.GetInstance().DestoryGameConfig(this, "config_baby_figure_star", false)
				return can_up
				*/
			} else if (goods_basic && vo.type == 76) {
				let list = MedalModel.GetInstance().title_red_list
				if (list && Util.TableSize(list) > 0) {
					for (let key in list) {
						let info = list[key]
						if (info.goods_id == vo.type_id) {
							return true
						} else {
							return false
						}
					}
				}
			} else if (vo.type == 12) {
				let model:FashionModel = FashionModel.GetInstance()
				if (!model.IsRed(vo.subtype, vo.type_id, true)) {
					return false
				} else {
					return true
				}
			} else if (vo.type == HolySealModel.GOODS_TYPE) { // 影装
				let model: HolySealModel = HolySealModel.GetInstance();
				// 判断是否有比身上穿戴的更加高级
				let equip = model.GetWearEquipByPos(vo.subtype);
				let bool = false;
				let conf = Config.PRELOAD_SERVER_CONFIG.config_seal_equip;
				if (equip && vo.color == 3 && equip.color > 3) {
					let equip_data = model.GetHolySealData(equip.type_id, conf);
					let now_data = model.GetHolySealData(vo.type_id, conf);
					if (equip_data && now_data && now_data.stage - equip_data.stage > 5) {
						bool = true;
					}
				} else {
					if (!equip || vo.rating > equip.rating) {
						bool = true;
					}
				}
				return bool;
			} else {
				return true
			}
		}

		this.ClearTypeIdData = (goods_id?) => {
			if (goods_id) {
				delete goods_dic_[goods_id]
			}
		}

		this.ClearData = () => {
			this.is_wait_time = true
			this.delay_show_list = []
			this.delay_list_cache = []
			goods_dic_ = {}
		}

		this.ContainGoodsId = (goods_id?) => {
			return goods_dic_[goods_id]
		}

		this.GetVoByTypeId = (type_id?) => {
			for (let key in goods_dic_) {
				if (goods_dic_[key].type_id == type_id) {
					return goods_dic_[key]
				}
			}
			return null
		}

		this.GetTypeGoodsNum = (goods_id?) => {
			if (goods_dic_[goods_id]) {
				return goods_dic_[goods_id].goods_num
			}
		}

		this.ClearEquipList = () => {
			equip_list_ = []
		}

		this.SaveEquipRecord = (type_id?) => {
			equip_record_dic_[type_id] = true
		}

		this.ContainEquipRecord = (type_id?) => {
			return equip_record_dic_[type_id]
		}

		this.DeleteOneEquipRecord = (type_id?) => {
			if (equip_record_dic_[type_id]) {
				delete equip_record_dic_[type_id]
			}
		}

		this.ClearEquipRecord = () => {
			equip_record_dic_ = []
		}

		this.ForceTryShowItemUse = () => {

			let vo = this.GetItemShowVo(false)
			if (vo) {
				GlobalEventSystem.Fire(EventName.OPEN_ITEM_USE_VIEW, vo)
			}
		}
		this.SaveShowList = (vo?) => {
			table.insert(this.delay_show_list, vo)
		}
		this.CheckShowList = (vo) => {
			let is_had = false
			if (vo["goods_id"] != null) {
				is_had = this.delay_show_list.some((data) => {
					return data.goods_id == vo.goods_id
				});
			}
			//挂机卡特殊处理  挂机卡道具>假的挂机卡道具(只是提示玩家使用挂机卡)
			if(vo.type_id == DailyModel.GetInstance().cost_goods_type){
				//是否有挂机卡道具 
				let is_had_card = -1
				//是否有假的挂机卡
				let is_had_faker_card = -1
				for(let i = 0;i<this.delay_show_list.length;i++){
					let vo1 = this.delay_show_list[i]
					if(vo1.type_id == DailyModel.GetInstance().cost_goods_type){
						if (vo1["goods_id"] != null){
							is_had_card = i
						}else{
							is_had_faker_card = i
						}
					}
				}
				//当前我是什么卡  true 道具卡  false假卡
				let boo= vo["goods_id"] != null 
				if(boo){
					//移除假卡
					if(is_had_faker_card!=-1){

						table.remove(this.delay_show_list,is_had_faker_card)
					}
				}else{
					if(is_had_card!=-1){
						return true
					}
				}
			}
			if (is_had) {
				return true
			}
			return false
		}
		this.SaveCacheList = (vo) => {
			table.insert(this.delay_list_cache, vo)
		}
		this.CheckCacheList = (vo) => {
			let is_had = false
			//goods_id == null 默认没有存放这东西
			if (vo["goods_id"] != null) {
				is_had = this.delay_list_cache.some((data) => {
					return data.goods_id == vo.goods_id
				});
			}
			if (is_had) {
				return true
			}
			return false
		}
		this.CheckItemUseVoExist = (vo) => {
			if (!vo) return false
			if (vo["goods_id"] != null) {
				if (!GoodsModel.GetInstance().GetBagGoodsNum(vo.type_id)) {
					return false
				}
				//挂机卡处理
				if (vo.type_id == 38070001) {
					let outline_model = OutLineModel.GetInstance()
					let outline_time = outline_model.outline_info || outline_model.GetOnhookTime()
					let hours = Math.floor(outline_time / 3600)
					if (hours >= 15) {
						return false
					}
				}
			} else {
				//挂机卡处理
				if (vo.type_id == 38070001) {
					let outline_model = OutLineModel.GetInstance()
					let outline_time = outline_model.outline_info || outline_model.GetOnhookTime()
					let hours = Math.floor(outline_time / 3600)
					if (hours >=2) {
						return false
					}
				}
			}
			return true
		}

		this.LoadCfg()
	}

	public static GetInstance() {

		if (!ItemUseModel._instance) {
			ItemUseModel._instance = new ItemUseModel()
		}
		return ItemUseModel._instance
	}

}
window["ItemUseModel"] = ItemUseModel