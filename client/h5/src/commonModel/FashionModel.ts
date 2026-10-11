import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util, LoadLuaConfigAB } from "../util/Util"
import { GoodsModel } from "./GoodsModel"
import { MainFunc } from "./MainUIModel"
import { CommonManager } from "../common/CommonManager"
import { OutWardBaseModel } from "./OutWardBaseModel"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"

let local_GlobalEventSystem = GlobalEventSystem
let local_EventName = EventName



export interface IFashionPosInfo {
    pos_id:number;
    wear_fashion_id:number;
    pos_lv:number;
	pos_upgrade_num:number;
	fashion_list?:IFashionInfo[]
}

export interface IFashionInfo {
    fashion_id:number;
    fashion_star_lv:number;
    now_color_id:number;
	color_list:{color_id:number, fashion_star_lv:number}[]
}

export class FashionModel extends EventDispatcher {
	public static SCMD_REQUEST = "FashionModel.SCMD_REQUEST";
	public static GETACTIVATEFASHION = "FashionModel.GETACTIVATEFASHION";
	public static UPDATEVIEW = "FashionModel.UPDATEVIEW";
	public static UPDATELEVEL = "FashionModel.UPDATELEVEL";
	public static SUCCESSOPERATE = "FashionModel.SUCCESSOPERATE";
	public static SELECTADD = "FashionModel.SELECTADD";
	public static SELECTCOLOR = "FashionModel.SELECTCOLOR"
	public static UPDATE_FIGHT = "FashionModel.UPDATE_FIGHT"
	public static UPDATE_SUIT_DATA = "FashionModel.UPDATE_SUIT_DATA"
	public static SELECT_SUIT = "FashionModel.SELECT_SUIT"
	public static SUIT_REFRESH_RED_FLAG = "FashionModel.SUIT_REFRESH_RED_FLAG"
	public static SUIT_REFRESH_ACTIVE_RED_FLAG = "FashionModel.SUIT_REFRESH_ACTIVE_RED_FLAG"
	public static SUIT_REFRESH_UPSTAGE_RED_FLAG = "FashionModel.SUIT_REFRESH_UPSTAGE_RED_FLAG"

	/**高级套装激活数量 */
	public static SuitHighActiveCount = 2
	/**完美套装激活数量 */
	public static SuitPerfectActiveCount = 4
	public static Instance:FashionModel

	public static SuitRedFlag = {
		Active: 0x001,//激活
		UpStage: 0x002,//升阶
	}

	public static FashionGoodsType = 12

	/**
	 * 时装类型
	 */
	public static FashionType = {
		/**衣服 */
		Fashion: 1,
		/**武器(弃用) */
		// Weapon: 2,
		/**头发 */
		Head: 3
	}

	goods_model:GoodsModel = GoodsModel.GetInstance()

	type_to_tab_index = { 
		1: 0, 
		3: 1 
	}

	suit_red_flag = 0
	fashion_red_flag = 0

	fashion_info_dic: { [pos_id: number]: IFashionPosInfo }
	fashion_active_dic: { [pos_id: number]: { [fashion_id: number]:IFashionInfo }}
	fashion_wear_list
	fashion_current_user_model_dic
	fashion_color_red_dic
	fashion_base_red_dic
	fashion_level_red_dic
	fashion_id_dic
	// fashion_grade_num_dic
	// fashion_order_num_dic
	// fashion_grade_dic


	config_fashion
	config_fashion_model
	config_fashion_pos
	config_fashion_color
	refresh_red_time_id
	refresh_suit_up_red_time_id

	fashion_suit_cond_cfg
	fashion_suit_skill_cfg
	fashion_suit_attr_cfg
	fashion_suit_star_attr_cfg
	fashion_suit_star_skill_cfg
	fashion_suit_star_cond_cfg
	fashion_suit_star_cost_cfg
	fashion_suit_active_red_dic
	fashion_suit_upstage_red_dic

	fashion_suit_data
	public constructor() {
		super()
		if (FashionModel.Instance) {
			return
		}
	}


	public InitConfig(){
		this.config_fashion = Config.PRELOAD_SERVER_CONFIG.config_fashion
		this.config_fashion_model = Config.PRELOAD_SERVER_CONFIG.config_fashion_model
		this.config_fashion_pos = Config.PRELOAD_SERVER_CONFIG.config_fashion_pos
		this.config_fashion_color = Config.PRELOAD_SERVER_CONFIG.config_fashion_color
	}

	public ResetData(){
		this.fashion_info_dic = null;
		this.fashion_active_dic = null;

		this.fashion_id_dic = null
		this.fashion_base_red_dic = null;
		this.fashion_color_red_dic = null
		this.fashion_level_red_dic = null

		this.fashion_wear_list = null;
		this.fashion_current_user_model_dic = null;
		this.fashion_suit_active_red_dic = null
		this.fashion_suit_upstage_red_dic = null

		
		// this.fashion_order_num_dic = {};
		// this.fashion_grade_dic = {}
		// this.fashion_grade_num_dic = {};
	}

	public CreateActiveList(fashion_pos_info:IFashionPosInfo){
		if (fashion_pos_info) {
			if(!this.fashion_info_dic){
				this.fashion_info_dic = {}
			}
			this.fashion_info_dic[fashion_pos_info.pos_id] = fashion_pos_info


			if(!this.fashion_active_dic){
				this.fashion_active_dic = {}
			}

			if (!this.fashion_active_dic[fashion_pos_info.pos_id]) {
				this.fashion_active_dic[fashion_pos_info.pos_id] = {}
			}

			for (let k in fashion_pos_info.fashion_list) {
				var vo:IFashionInfo = fashion_pos_info.fashion_list[k]
				this.fashion_active_dic[fashion_pos_info.pos_id][vo.fashion_id] = vo
			}
		}
	}

	/**时装基础红点 */
	public RefreshBaseRed(pos_id?){
		let config_fashion = Config.PRELOAD_SERVER_CONFIG.config_fashion
		if(!config_fashion) return

		if(!this.fashion_active_dic){
			return
		}

		if(!this.fashion_base_red_dic){
			this.fashion_base_red_dic = {}
		}

		if(!this.fashion_level_red_dic){
			this.fashion_level_red_dic = {}
		}
		
		for(let key in FashionModel.FashionType){
			var local_pos_id = FashionModel.FashionType[key]
			if(pos_id && local_pos_id != pos_id) continue
			if(!this.fashion_base_red_dic[local_pos_id]){
				this.fashion_base_red_dic[local_pos_id] = {}
			}
			if(!this.fashion_level_red_dic[local_pos_id]){
				this.fashion_level_red_dic[local_pos_id] = {}
			}
			let pos_id_dic = this.fashion_id_dic[local_pos_id]
			if (pos_id_dic) {
				let changed = false
				for (let fashion_id in pos_id_dic) {
					let order = 0
					if (this.fashion_active_dic[local_pos_id] && this.fashion_active_dic[local_pos_id][fashion_id]) {
						order = this.GetDefultOrder(this.fashion_active_dic[local_pos_id][fashion_id])
					}

					let key = local_pos_id + "@" + fashion_id + "@" + (order + 1)
					let cfg = config_fashion[key]
					let red_state = false
					if (cfg) {
						let cost
						if (order == 0) {
							if(cfg.active_cost != "[]"){
								cost = JSON.parse(cfg.active_cost)
							}
						} else {
							if(cfg.star_cost != "[]"){
								cost = JSON.parse(cfg.star_cost)
							}
						}
						if(cost){
							let bool = true
							for(let vo of cost){
								var have_num = GoodsModel.GetInstance().GetTypeGoodsNum(vo[1])
								var need_num = Number(vo[2])
								if(need_num > have_num){
									bool = false
									break
								}
							}
							red_state = bool
						}
						if(this.fashion_base_red_dic[local_pos_id][fashion_id] != red_state){
							changed = true
							this.fashion_base_red_dic[local_pos_id][fashion_id] = red_state
						}
					}
					else{
						//已满阶段
						key = local_pos_id + "@" + fashion_id + "@" + order
						cfg = config_fashion[key]
						if(cfg){
							let cost
							if(cfg.star_cost != "[]"){
								cost = JSON.parse(cfg.star_cost)
							}
							if(cost){
								let bool = false
								for(let vo of cost){
									var have_num = GoodsModel.GetInstance().GetTypeGoodsNum(vo[1])
									if(have_num > 0){
										bool = true
										break
									}
								}
								red_state = bool
							}
						}

						if(this.fashion_base_red_dic[local_pos_id][fashion_id] != false){
							changed = true
							this.fashion_base_red_dic[local_pos_id][fashion_id] = false
						}

						if(!this.fashion_level_red_dic[local_pos_id][fashion_id]){
							this.fashion_level_red_dic[local_pos_id][fashion_id] = {}
						}
						if(this.fashion_level_red_dic[local_pos_id][fashion_id][0] != red_state){
							changed = true
							this.fashion_level_red_dic[local_pos_id][fashion_id][0] = red_state
						}
					}
				}
				if(changed){
					local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", this.type_to_tab_index[local_pos_id], this.IsPosShowRed(local_pos_id))
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
					this.Fire(FashionModel.UPDATEVIEW, local_pos_id)
				}
			}
		}
	}

	public IsShowRed(){
		if (CommonManager.GetInstance().CheckFuncOpenState("FashionBaseView", true)) {
			for (let key in FashionModel.FashionType) {
				var type_id = FashionModel.FashionType[key]
				if (this.IsPosShowRed(type_id)) {
					return true
				}
			}
		}
		return false
	}

	public IsPosShowRed(pos_id?){
		if (
			!this.GetBaseRed(pos_id)
			&& !this.GetColorRed(pos_id)
			&& !this.GetLevelRed(pos_id)) {
			return false
		} else {
			return true
		}
	}

	public UpdateCurrentUserModelList(career, sex){
		this.fashion_current_user_model_dic = {}
		this.fashion_id_dic = {}
		this.fashion_wear_list = {}

		let config_fashion_model = this.config_fashion_model
		for (let fashion in config_fashion_model) {
			let cfg = config_fashion_model[fashion]
			if (cfg.career == career && cfg.sex == sex && cfg.color_id == 0) {
				this.fashion_current_user_model_dic[fashion] = cfg
				if (!this.fashion_id_dic[cfg.pos_id]) {
					this.fashion_id_dic[cfg.pos_id] = {}
				}
				this.fashion_id_dic[cfg.pos_id][cfg.fashion_id] = true 

				if (!this.fashion_wear_list[cfg.pos_id]) {
					this.fashion_wear_list[cfg.pos_id] = []
				}
				table.insert(this.fashion_wear_list[cfg.pos_id], {
					fashion_id: cfg.fashion_id,
					lv: 0,
					pos_id: cfg.pos_id,
				})
			}
		}
		let sort_func = (a, b) => {
			return a.fashion_id < b.fashin_id
		}

		for (let k in this.fashion_wear_list) {
			table.sort(this.fashion_wear_list[k], sort_func)
		}
	}

	public IsActive(pos_id?, fashion_id?){
		if(this.fashion_active_dic && this.fashion_active_dic[pos_id] && this.fashion_active_dic[pos_id][fashion_id]){
			return true
		}
		return false
	}

	//not_color:不判断染色的红点
	public IsRed(pos_id?, fashion_id?, not_color?){
		if (!not_color) {
			let bool = this.GetColorRed(pos_id, fashion_id)
			if (bool) { return bool }
		}
		return this.GetBaseRed(pos_id, fashion_id)
	}

	//时装颜色相关配置
	public GetColorCfg(pos_id?, fashion_id?, color_id?, star_lv?){
		if (!this.config_fashion_model) {
			return
		}
		if (!pos_id || !fashion_id || fashion_id == 0) { return }
		let cfgs = []
		if (star_lv) { // 指定配置
			return this.config_fashion_color[pos_id + "@" + fashion_id + "@" + color_id + "@" + star_lv]// Config.Fashioncolor[pos_id + "@" + fashion_id + "@" + color_id + "@" + star_lv]
		} else if (color_id) { // 指定颜色下的所有配置
			for (let lv = 1; lv <= 1; lv++) {
				let key = pos_id + "@" + fashion_id + "@" + color_id + "@" + lv
				let cfg = this.config_fashion_color[key]//Config.Fashioncolor[key]
				if (!cfg) {
					break
				}
				cfgs[key] = cfg
			}
			return cfgs
		} else { // 指定时装颜色的种类p
			let career = RoleManager.GetInstance().GetMainRoleCareer()
			let sex = RoleManager.GetInstance().GetMainRoleSex()

			for (let color_id = 1; color_id <= 10; color_id += 1) {
				let key = pos_id + "@" + fashion_id + "@" + career + "@" + sex + "@" + color_id
				let cfg = this.config_fashion_model[key]//Config.Fashioncolor[key]
				if (!cfg) {
					return color_id - 1
				}
			}
		}
	}

	//单一时装界面信息(已激活)
	public GetFashionInfo(pos_id?, fashion_id?){
		if (pos_id && fashion_id) {
			return this.fashion_active_dic[pos_id] && this.fashion_active_dic[pos_id][fashion_id]
		}
	}

	//时装颜色红点
	public RefreshColorRed(pos_id?){
		let config_fashion_color = Config.PRELOAD_SERVER_CONFIG.config_fashion_color
		if(!config_fashion_color){
			return
		}
		if(!this.fashion_active_dic){
			return
		}

		if(!this.fashion_color_red_dic){
			this.fashion_color_red_dic = {}
		}
		if(!this.fashion_level_red_dic){
			this.fashion_level_red_dic = {}
		}
		for(let key in FashionModel.FashionType){
			var local_pos_id = FashionModel.FashionType[key]
			if(pos_id && pos_id != local_pos_id) continue
			if(!this.fashion_color_red_dic[local_pos_id]){
				this.fashion_color_red_dic[local_pos_id] = {}
			}
			if(!this.fashion_level_red_dic[local_pos_id]){
				this.fashion_level_red_dic[local_pos_id] = {}
			}
			
			let id_dic = this.fashion_id_dic[local_pos_id]
			let active_dic = this.fashion_active_dic[local_pos_id]
			if (id_dic) {
				let changed = false
				for (let fashion_id in id_dic) {
					if(!this.fashion_color_red_dic[local_pos_id][fashion_id]){
						this.fashion_color_red_dic[local_pos_id][fashion_id] = {}
					}
					if(!this.fashion_level_red_dic[local_pos_id][fashion_id]){
						this.fashion_level_red_dic[local_pos_id][fashion_id] = {}
					}
					let color_type = this.GetColorCfg(local_pos_id, fashion_id)
					for (let color_id = 1; color_id <= color_type; color_id ++) {
						let lv = 0
						let fashion_info:IFashionInfo = active_dic[fashion_id]
						if(fashion_info){
							for (let v1 of fashion_info.color_list) {
								if (v1.color_id == color_id) {
									lv = v1.fashion_star_lv
								}
							}
						}
						let key = local_pos_id + "@" + fashion_id + "@" + color_id + "@" + (lv + 1)
						let cfg = config_fashion_color[key]
						let red_state = false
						if (cfg) {
							let cost
							if (lv == 0) {
								if(cfg.active_cost != "[]"){
									cost = JSON.parse(cfg.active_cost)
								}
							} else {
								if(cfg.star_cost != "[]"){
									cost = JSON.parse(cfg.star_cost)
								}
							}

							if(cost){
								let bool = true
								for(let vo of cost){
									var have_num = GoodsModel.GetInstance().GetTypeGoodsNum(vo[1])
									var need_num = Number(vo[2])
									if(need_num > have_num){
										bool = false
										break
									}
								}
								red_state = bool
							}
							if(this.fashion_color_red_dic[local_pos_id][fashion_id][color_id] != red_state){
								changed = true
								this.fashion_color_red_dic[local_pos_id][fashion_id][color_id] = red_state
							}
						}else{
							//已满阶段
							key = local_pos_id + "@" + fashion_id + "@" + color_id + "@" + lv 
							cfg = config_fashion_color[key]
							if(cfg){
								let cost
								if(cfg.star_cost != "[]"){
									cost = JSON.parse(cfg.star_cost)
								}
								if(cost){
									let bool = false
									for(let vo of cost){
										var have_num = GoodsModel.GetInstance().GetTypeGoodsNum(vo[1])
										if(have_num > 0){
											bool = true
											break
										}
									}
									red_state = bool
								}
							}
							if(this.fashion_color_red_dic[local_pos_id][fashion_id][color_id] != false){
								changed = true
								this.fashion_color_red_dic[local_pos_id][fashion_id][color_id] = false
							}

							if(this.fashion_level_red_dic[local_pos_id][fashion_id][color_id] != red_state){
								changed = true
								this.fashion_level_red_dic[local_pos_id][fashion_id][color_id] = red_state
							}
						}
					}
				}
				if(changed){
					local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", this.type_to_tab_index[local_pos_id], this.IsPosShowRed(local_pos_id))
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
					this.Fire(FashionModel.UPDATEVIEW, local_pos_id)
				}
			}
		}
	}

	public GetBaseRed(pos_id, fashion_id?){
		if(!pos_id) return false
		if (!fashion_id) {
			if (this.fashion_base_red_dic && this.fashion_base_red_dic[pos_id]) {
				for (let fashion_id in this.fashion_base_red_dic[pos_id]) {
					if (this.fashion_base_red_dic[pos_id][fashion_id]) {
						return true
					}
				}
			}
			return false
		}
		if(this.fashion_base_red_dic && this.fashion_base_red_dic[pos_id]){
			return this.fashion_base_red_dic[pos_id][fashion_id]
		}
	}

	public GetLevelRed(pos_id){
		if(!pos_id) return false
		//只有时装可以升级
		if(pos_id != FashionModel.FashionType.Fashion) return
		if (this.fashion_level_red_dic && this.fashion_level_red_dic[pos_id]) {
			for (let fashion_id in this.fashion_level_red_dic[pos_id]) {
				var color_dic = this.fashion_level_red_dic[pos_id][fashion_id]
				for (let color_id in color_dic) {
					if (color_dic[color_id]) {
						return true
					}
				}
			}
		}
		return false
	}

	public GetColorRed(pos_id, fashion_id?, color?){
		if(!pos_id) return false
		if (!fashion_id) {
			if (this.fashion_color_red_dic && this.fashion_color_red_dic[pos_id]) {
				for (let fashion_id in this.fashion_color_red_dic[pos_id]) {
					var color_dic = this.fashion_color_red_dic[pos_id][fashion_id]
					for (let color_id in color_dic) {
						if (color_dic[color_id]) {
							return true
						}
					}
				}
			}
			return false
		}
		if(!color){
			if (this.fashion_color_red_dic && this.fashion_color_red_dic[pos_id] && this.fashion_color_red_dic[pos_id][fashion_id]) {
				var color_dic = this.fashion_color_red_dic[pos_id][fashion_id]
				for (let color_id in color_dic) {
					if (color_dic[color_id]) {
						return true
					}
				}
			}
			return false
		}
		if (this.fashion_color_red_dic && this.fashion_color_red_dic[pos_id] && this.fashion_color_red_dic[pos_id][fashion_id]) {
			return this.fashion_color_red_dic[pos_id][fashion_id][color]
		}
		return false
	}

	//获取默认颜色的阶数
	public GetDefultOrder(info?){
		if (info && info.color_list) {
			for (let k in info.color_list) {
				var v = info.color_list[k]
				if (v.color_id == 0) {
					return v.fashion_star_lv
				}
			}
		}
		return 0
	}

	public SetSuitData(scmd: ProtoRecvVObj<41313>){
		if (!this.fashion_suit_data) {
			this.fashion_suit_data = {}
		}

		for (var vo of scmd.fashion_suit) {
			if (!this.fashion_suit_data[vo.suit_id]) {
				this.fashion_suit_data[vo.suit_id] = {}
			}
			this.fashion_suit_data[vo.suit_id] = vo
		}
	}

	public GetSuitData(suit_id){
		return this.fashion_suit_data && this.fashion_suit_data[suit_id]
	}

	public GetSuitActiveState(suit_id){
		let suit_data = this.GetSuitData(suit_id)
		if(suit_data){
			return suit_data.active_num == FashionModel.SuitPerfectActiveCount
		}
	}

	public GetSuitCond(suit_id){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit) return
		if(!this.fashion_suit_cond_cfg){
			this.fashion_suit_cond_cfg = {}
		}
		if(this.fashion_suit_cond_cfg[suit_id] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit[suit_id]
			if(cfg){
				this.fashion_suit_cond_cfg[suit_id] = JSON.parse(cfg.condition)
			}
		}
		return this.fashion_suit_cond_cfg[suit_id]
	}

	public GetSuitSkill(suit_id){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit) return
		if(!this.fashion_suit_skill_cfg){
			this.fashion_suit_skill_cfg = {}
		}
		if(this.fashion_suit_skill_cfg[suit_id] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit[suit_id]
			if(cfg){
				this.fashion_suit_skill_cfg[suit_id] = JSON.parse(cfg.skill)
			}
		}
		return this.fashion_suit_skill_cfg[suit_id]
	}

	public GetSuitAttr(suit_id){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit) return
		if(!this.fashion_suit_attr_cfg){
			this.fashion_suit_attr_cfg = {}
		}
		if(this.fashion_suit_attr_cfg[suit_id] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit[suit_id]
			if(cfg){
				this.fashion_suit_attr_cfg[suit_id] = JSON.parse(cfg.attr)
			}
		}
		return this.fashion_suit_attr_cfg[suit_id]
	}

	public GetSuitStarAttr(suit_id, lv){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star) return
		if(!this.fashion_suit_star_attr_cfg){
			this.fashion_suit_star_attr_cfg = {}
		}
		if(!this.fashion_suit_star_attr_cfg[suit_id]){
			this.fashion_suit_star_attr_cfg[suit_id] = {}
		}
		if(this.fashion_suit_star_attr_cfg[suit_id][lv] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[`${suit_id}@${lv}`]
			if(cfg){
				this.fashion_suit_star_attr_cfg[suit_id][lv] = JSON.parse(cfg.attr)
			}
		}
		return this.fashion_suit_star_attr_cfg[suit_id][lv]
	}

	public GetSuitStarSkill(suit_id, lv){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star) return
		if(!this.fashion_suit_star_skill_cfg){
			this.fashion_suit_star_skill_cfg = {}
		}
		if(!this.fashion_suit_star_skill_cfg[suit_id]){
			this.fashion_suit_star_skill_cfg[suit_id] = {}
		}
		if(this.fashion_suit_star_skill_cfg[suit_id][lv] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[`${suit_id}@${lv}`]
			if(cfg){
				this.fashion_suit_star_skill_cfg[suit_id][lv] = JSON.parse(cfg.skill)
			}
		}
		return this.fashion_suit_star_skill_cfg[suit_id][lv]
	}

	public GetSuitStarCond(suit_id, lv){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star) return
		if(!this.fashion_suit_star_cond_cfg){
			this.fashion_suit_star_cond_cfg = {}
		}
		if(!this.fashion_suit_star_cond_cfg[suit_id]){
			this.fashion_suit_star_cond_cfg[suit_id] = {}
		}
		if(this.fashion_suit_star_cond_cfg[suit_id][lv] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[`${suit_id}@${lv}`]
			if(cfg){
				this.fashion_suit_star_cond_cfg[suit_id][lv] = JSON.parse(cfg.condition)
			}
		}
		return this.fashion_suit_star_cond_cfg[suit_id][lv]
	}

	public GetSuitStarCost(suit_id, lv){
		if(!Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star) return
		if(!this.fashion_suit_star_cost_cfg){
			this.fashion_suit_star_cost_cfg = {}
		}
		if(!this.fashion_suit_star_cost_cfg[suit_id]){
			this.fashion_suit_star_cost_cfg[suit_id] = {}
		}
		if(this.fashion_suit_star_cost_cfg[suit_id][lv] == null){
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star && Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[`${suit_id}@${lv}`]
			if(cfg){
				this.fashion_suit_star_cost_cfg[suit_id][lv] = JSON.parse(cfg.cost)
			}
		}
		return this.fashion_suit_star_cost_cfg[suit_id][lv]
	}

	public GetSuitPosLv(suit_id, pos){
		let cond = this.GetSuitCond(suit_id)
		for (let vo of cond) {
			/**
			 * vo
			 * {1,{1,1,12010030}}
			 * {格子位置,{类型,子类型,id}}
			 * 类型: 1 时装模块  子类型: 1 时装 3 头饰   id:对应时装id
			 * 类型: 2 培养物的幻化模块  子类型: 1:坐骑 2：精灵 3: 翅膀 4:圣器 5：神兵 12：背饰  id:对应幻化id
			 */
			if(vo[0] == pos){
				return this.GetSuitLvPosByVo(vo[1])
			}
		}

		return -1
	}

	public GetSuitLvPosByVo(vo){
		let type = vo[0],
			sub_type = vo[1],
			id = vo[2]
			
		if(type == 1){/**时装 */
			/**时装id和物品id一致 */
			let sub_fashion_activate_list = FashionModel.GetInstance().fashion_active_dic && FashionModel.GetInstance().fashion_active_dic[sub_type]
			if(sub_fashion_activate_list && sub_fashion_activate_list[id]){
				let color_list = sub_fashion_activate_list[id].color_list
				if (color_list) {
					for (let k in color_list) {
						var v = color_list[k]
						if (v.color_id == 0) {
							return v.fashion_star_lv
						}
					}
				}
			}
		} else if(type == 2){/**培养幻化 */
			let sub_active_illu_list = OutWardBaseModel.GetInstance().active_illu_list[sub_type]
			if(sub_active_illu_list && sub_active_illu_list[id]){
				//坐骑和侍魂 取星数 其余的取阶数
				if(sub_type == 1 || sub_type == 2){
					return sub_active_illu_list[id].star
				} else{
					return sub_active_illu_list[id].stage
				}
			}

		}
		return -1
	}

	public RefreshSuitActiveRed(){
		let bool = false
		if(this.fashion_suit_data){
			if(!this.fashion_suit_active_red_dic){
				this.fashion_suit_active_red_dic = {}
			}
			for(let suit_id in this.fashion_suit_data){
				var data = this.fashion_suit_data[suit_id]
				let local_bool = (data.conform_num >= FashionModel.SuitHighActiveCount && data.active_num < FashionModel.SuitHighActiveCount)
				||(data.conform_num >= FashionModel.SuitPerfectActiveCount && data.active_num < FashionModel.SuitPerfectActiveCount)

				if(local_bool){
					bool = true
				}

				if(this.fashion_suit_active_red_dic[suit_id] != local_bool){
					this.fashion_suit_active_red_dic[suit_id] = local_bool
					this.Fire(FashionModel.SUIT_REFRESH_ACTIVE_RED_FLAG, suit_id)
				}
			}
		} 
		this.SetSuitRedFlag(FashionModel.SuitRedFlag.Active, bool)
	}

	public TryRefreshFashionRed(){
		if(this.refresh_red_time_id) return
		this.refresh_red_time_id = setTimeout(() => {
			this.refresh_red_time_id = null
			this.RefreshColorRed()
			this.RefreshBaseRed()
		}, 500);
	}

	public TryRefreshSuitUpStageRed(){
		if(this.refresh_suit_up_red_time_id) return
		this.refresh_suit_up_red_time_id = setTimeout(() => {
			this.refresh_suit_up_red_time_id = null
			this.RefreshSuitUpStageRed()
		}, 500);
	}

	public RefreshSuitUpStageRed(){
		let bool = false
		if(this.fashion_suit_data){
			if(!this.fashion_suit_upstage_red_dic){
				this.fashion_suit_upstage_red_dic = {}
			}
			
			let config_fashion_suit_star = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star
			for(let suit_id in this.fashion_suit_data){
				var data = this.fashion_suit_data[suit_id]
				let next_key = `${suit_id}@${data.lv + 1}`
				var next_cfg = config_fashion_suit_star[next_key]
				let local_bool = false

				if(this.GetSuitActiveState(suit_id) && next_cfg){
					let cond = this.GetSuitStarCond(suit_id, data.lv + 1)
					let total_count = cond.length
					let now_count = 0
					for (let vo of cond) {
						var count = this.GetSuitPosLv(suit_id, vo[0])
						if(count >= vo[1]){
							now_count++
						}
					}
					let cond_bool = now_count >= total_count
					if(cond_bool){
						let cost = this.GetSuitStarCost(suit_id, data.lv + 1)
						cost = cost[0]
						if (cost) {
							let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
							let my_count = GoodsModel.GetInstance().GetBagGoodsNum(goods_id)
							local_bool = my_count >= cost[2]
						}
						else {
							local_bool = true
						}
					}
				}

				if(local_bool){
					bool = true
				}

				if(this.fashion_suit_upstage_red_dic[suit_id] != local_bool){
					this.fashion_suit_upstage_red_dic[suit_id] = local_bool
					this.Fire(FashionModel.SUIT_REFRESH_UPSTAGE_RED_FLAG, suit_id)
				}

			}
		} 
		this.SetSuitRedFlag(FashionModel.SuitRedFlag.UpStage, bool)
	}

	public SetSuitRedFlag(flag?, state?){
		if (!flag) {
			return
		}
		let now_flag = 0
		if (state) {
			now_flag = this.suit_red_flag | flag
		} else {
			now_flag = this.suit_red_flag & ~flag
		}
		if (now_flag == this.suit_red_flag) {
			return
		}
		this.suit_red_flag = now_flag
		this.Fire(FashionModel.SUIT_REFRESH_RED_FLAG, flag)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "FashionBaseView", 3, this.GetSuitRedState())
		GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
	}

	public HasSuitRedFlag(flag?){
		if (!flag) {
			return false
		}
		return ((this.suit_red_flag & flag) != 0)
	}

	public GetSuitRedState(){
		return CommonManager.GetInstance().CheckFuncOpenState("FashionSuitView", true) && this.suit_red_flag > 0
	}

	public static GetInstance(): FashionModel {

		if (!FashionModel.Instance) {
			FashionModel.Instance = new FashionModel()
		}
		return FashionModel.Instance
	}
}

window["FashionModel"] = FashionModel