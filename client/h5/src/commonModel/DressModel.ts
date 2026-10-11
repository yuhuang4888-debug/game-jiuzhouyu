import { CommonManager } from "../common/CommonManager"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { RoleManager } from "./RoleManager"


export const DressType = {
	Bubble: 1,
	Photo: 2,
	Foot: 3,
	Head: 5
}
window["DressType"] = DressType
export const DressEvent = {
	DRESS_REQUEST_PROTO: "DRESS_REQUEST_PROTO",
	DRESS_OPEN_VIEW: "DRESS_OPEN_VIEW",
	DRESS_CLICK_DRESS_ITEM: "DRESS_CLICK_DRESS_ITEM",
	DRESS_UPDATE_DRESS_DATA: "DRESS_UPDATE_DRESS_DATA",
	DRESS_ACTIVE_SUCCESS: "DRESS_ACTIVE_SUCCESS",
	DRESS_UPDATE_RED_DOT: "DRESS_UPDATE_RED_DOT",
	REINCARNATION_SUCCESS_VIEW_CLOSE : "REINCARNATION_SUCCESS_VIEW_CLOSE",
	DRESS_ACTIVE_POWER_DATA : "DRESS_ACTIVE_POWER_DATA"
}
window["DressEvent"] = DressEvent
export class DressModel extends EventDispatcher {
	DressCanActive
	DressCanShowRedDot
	DressCanUplevel
	GetDressAllCfgByType
	GetDressAllLvCfg
	GetDressByType
	GetDressByTypes: (dress_type: number) => any;
	GetDressCfgByTypeAndIdAndLv
	GetDressSkillCfg
	GetFootEffect
	GetMyDressDataByTypeAndId
	GetNowUseId
	GetProList
	InitConfig
	SetDressData
	UpdateDressData
	UpdateNowUseDress
	my_dress_data
	getNextActId
	getHeadICon
	getDressIdByTurn
	un_act_dress_power_map

	InitUnActDressMap
	SetUnActDressData
	getUnActDressData
	
	static Instance

	public constructor() {
		super()

		if (DressModel.Instance) {
			return
		}
		this.my_dress_data = [];
		let local_DressEvent = DressEvent
		let local_Erlang = ErlangParser.GetInstance()
		let local_Number = Number
		let goods_model = GoodsModel.GetInstance()
		let config_dress_up_cfg_ = null
		let dress_cfg_ = []
		let dress_lv_cfg_ = []
		let dress_skill_cfg_ = []
		this.un_act_dress_power_map = {}
		this.InitConfig = () => {

		}
		ResManager.GetInstance().LoadGameConfig(this, "config_dress_up_cfg", false, null, (cfg) => {
			config_dress_up_cfg_ = cfg
			ResManager.GetInstance().DestoryGameConfig(this, "config_dress_up_cfg")
		})

		this.SetDressData = (scmd?) => {
			if (!this.my_dress_data[scmd.dress_type]) {
				this.my_dress_data[scmd.dress_type] = []
			}
			this.my_dress_data[scmd.dress_type] = scmd
		}


		this.UpdateDressData = (_type?, id?, lv?, cur_power?, next_power?, is_new?) => {
			if (this.my_dress_data[_type] && this.my_dress_data[_type].enable_list) {
				if (is_new) {
					let obj = { dress_id: id, dress_lv: lv, cur_power: cur_power, next_power: next_power }
					table.insert(this.my_dress_data[_type].enable_list, obj)
					this.GetDressAllCfgByType(_type, true)
				} else {
					for (let _tmpi in this.my_dress_data[_type].enable_list) {
						var vo = this.my_dress_data[_type].enable_list[_tmpi]
						if (vo.dress_id == id) {
							vo.dress_lv = lv
							vo.cur_power = cur_power
							vo.next_power = next_power
							break
						}
					}
				}
				this.Fire(local_DressEvent.DRESS_UPDATE_DRESS_DATA, id)
			}
		}

		this.UpdateNowUseDress = (_type?, id?, wear_in?) => {
			if (this.my_dress_data[_type]) {
				this.my_dress_data[_type].use_dress_id = (wear_in && (id) || (0))
				this.Fire(local_DressEvent.DRESS_UPDATE_DRESS_DATA, id)
			}
		}

		this.GetDressAllCfgByType = (_type?, isAfreshGet?) => {
			if (!dress_cfg_[_type] && config_dress_up_cfg_ || isAfreshGet) {
				if (!dress_cfg_[_type]) {
					dress_cfg_[_type] = []
				}
				let find_same = null
				for (let key in config_dress_up_cfg_) {
					let cfg = Config.GetConfigVo(config_dress_up_cfg_.name, key, false, config_dress_up_cfg_)
					if (_type == cfg.type && cfg.level == 1) {
						find_same = false
						for (let _tmpi in dress_cfg_[_type]) {
							var dress = dress_cfg_[_type][_tmpi]
							if (dress.id == cfg.id) {
								find_same = true
								break
							}
						}
						if (!find_same) {
							table.insert(dress_cfg_[_type], cfg)
						}
					}
				}
				// let sort_fun = (a?, b?) => {
				// 	return a.id < b.id
				// }
				let sort_fun = (a?, b?) => {
					return a.id < b.id
				}
				// 头像特殊排序
				let sort_fun2 = (a?, b?) => {
					// 第一个显示下一个转生头像
					let nextId:number = this.getNextActId(this.GetDressAllCfgByType(_type));
					let aIsNextId: boolean = a.id == nextId;
					let bIsNextId: boolean = b.id == nextId;
					if(aIsNextId != bIsNextId){//下一转激活
						return aIsNextId ? true : false
					}
					//已激活>未激活
					let aIsAct = this.GetMyDressDataByTypeAndId(a.type, a.id) != null;
					let bIsAct = this.GetMyDressDataByTypeAndId(b.type, b.id) != null;
					if(aIsAct != bIsAct){
						return aIsAct ? true : false
					}
					// 是否是转生头像
					let aCondition = JSON.parse(a.condition);
					let bCondition = JSON.parse(b.condition);
					let aIsTurnHead: boolean = aCondition.length;
					let bIsTurnHead: boolean = bCondition.length;
					if(aIsTurnHead != bIsTurnHead){
						return aIsTurnHead ? false : true
					}
					// 未激活转生头像按转生等级排序
					if(aIsTurnHead && bIsTurnHead){
						return bCondition[0][1] < bCondition[0][1]
					}
					return a.id < b.id
				}
				if(_type == DressType.Head){
					table.sort(dress_cfg_[_type], sort_fun2)
				}else{
					table.sort(dress_cfg_[_type], sort_fun)
				}
			}
			return dress_cfg_[_type]
		}

		//获取下一个激活的转生头像
		this.getNextActId = (data) => {
			if(data && data.length){
				let my_turn = RoleManager.GetInstance().GetMainRoleTurn()
				let _list = [];
				for (let j = 0, len = data.length; j < len; j++) {
					let condition = JSON.parse(data[j].condition);
					if(condition && condition.length && condition[0][0] == "turn" && condition[0][1] > my_turn){
						_list.push(data[j])
					}
				}
				if(_list.length > 0){
					let sort_fun = (a?, b?) => {
						let aCondition = JSON.parse(a.condition);
						let bCondition = JSON.parse(b.condition);
						return aCondition[0][1] < bCondition[0][1]
					}
					table.sort(_list, sort_fun)
					return _list[0].id
				}
			}
			return -1
		}

		this.GetDressCfgByTypeAndIdAndLv = (_type?, id?, lv?) => {
			return config_dress_up_cfg_ && Config.GetConfigVo(config_dress_up_cfg_.name, _type + "@" + id + "@" + lv, false, config_dress_up_cfg_)
		}

		this.GetMyDressDataByTypeAndId = (_type?, id?) => {
			let my_dress = null
			if (this.my_dress_data[_type]) {
				let list = this.my_dress_data[_type].enable_list
				if (list) {
					for (let _tmpi in list) {
						var dress = list[_tmpi]
						if (dress.dress_id == id) {
							my_dress = dress
							break
						}
					}
				}
			}
			return my_dress
		}

		this.GetProList = (_type?, id?, lv?) => {
			let now_cfg = this.GetDressCfgByTypeAndIdAndLv(_type, id, lv)
			let next_cfg = this.GetDressCfgByTypeAndIdAndLv(_type, id, lv + 1)
			let now_pro = []
			let next_pro = []
			if (now_cfg) {
				now_pro = JSON.parse(now_cfg.attr)
			}
			if (next_cfg) {
				next_pro = JSON.parse(next_cfg.attr)
			}
			return [now_pro, next_pro]
		}

		this.GetNowUseId = (_type?) => {
			let now_use_id = 0
			let my_dress = this.my_dress_data[_type]
			if (my_dress) {
				if (my_dress.use_dress_id) {
					now_use_id = my_dress.use_dress_id
				}
			}
			return now_use_id
		}

		this.GetDressAllLvCfg = (_type?, id?) => {
			let key = _type + "@" + id
			if (!dress_lv_cfg_[key]) {
				dress_lv_cfg_[key] = []
				let cfg = null
				for (let k in config_dress_up_cfg_) {

					cfg = Config.GetConfigVo(config_dress_up_cfg_.name, k, false, config_dress_up_cfg_)
					if (_type == cfg.type && cfg.id == id) {
						table.insert(dress_lv_cfg_[key], cfg)
					}
				}
				let sort_fun = (a?, b?) => {
					return a.level < b.level
				}
				table.sort(dress_lv_cfg_[key], sort_fun)

			}
			return dress_lv_cfg_[key]
		}

		this.GetDressSkillCfg = (_type?, id?) => {
			let key = _type + "@" + id
			// [ts2lua]dress_skill_cfg_下标访问可能不正确
			if (!dress_skill_cfg_[key]) {
				// [ts2lua]dress_skill_cfg_下标访问可能不正确
				dress_skill_cfg_[key] = []
				let all_cfg = this.GetDressAllLvCfg(_type, id)
				let cfg = null
				if (all_cfg) {
					let find = null
					for (let _tmpi in all_cfg) {
						var vo = all_cfg[_tmpi]
						if (vo.skill != 0) {
							find = false
							// [ts2lua]dress_skill_cfg_下标访问可能不正确
							for (let _tmpi in dress_skill_cfg_[key]) {
								var tmp = dress_skill_cfg_[key][_tmpi]
								if (tmp.skill == vo.skill) {
									find = true
									break
								}
							}
							if (!find) {
								table.insert(dress_skill_cfg_[key], vo)
							}
						}
					}
				}
				let sort_fun = (a?, b?) => {
					return a.level < b.level
				}
				table.sort(dress_skill_cfg_[key], sort_fun)
			}
			return dress_skill_cfg_[key]
		}

		this.GetDressByType = (dress_list: any, dress_type?) => {
			let dress_id = null
			if (dress_list) {
				for (let _tmpi in dress_list) {
					var dress = dress_list[_tmpi]
					if (dress.dress_type == dress_type) {
						dress_id = dress.dress_id
						break
					}
				}
			}
			return dress_id
		}

		this.GetDressByTypes = (dress_type?) => {
			if (this.my_dress_data) {
				return this.my_dress_data[dress_type];
			}
			return null;
		}

		this.GetFootEffect = (id?, dir?) => {
			let res = null
			let cfg = this.GetDressCfgByTypeAndIdAndLv(DressType.Foot, id, 1)
			if (cfg) {
				res = "footprint_" + id
				if (local_Number(cfg.vector) == 1) {
					res = res + "_" + dir + "_0"
				}
			}
			return res
		}

		this.DressCanShowRedDot = () => {
			if (CommonManager.GetInstance().CheckFuncOpenState("FashionBaseView", true)) {
				return  this.DressCanUplevel(DressType.Bubble) || 
						this.DressCanUplevel(DressType.Photo) ||
						this.DressCanUplevel(DressType.Foot) ||
						this.DressCanUplevel(DressType.Head) ||
						this.DressCanActive(DressType.Bubble) || 
						this.DressCanActive(DressType.Photo) ||
						this.DressCanActive(DressType.Foot) ||
						this.DressCanActive(DressType.Head) 
				}
			else {
				return false
			}
		}

		this.DressCanUplevel = (_type?, id?) => {
			let can_up_level = false
			// [ts2lua]this.my_dress_data下标访问可能不正确
			if (this.my_dress_data && this.my_dress_data[_type]) {
				if (id) {
					let cfg = null
					let cost_list = null
					let my_have = 0
					// [ts2lua]this.my_dress_data下标访问可能不正确
					for (let _tmpi in this.my_dress_data[_type].enable_list) {
						var vo = this.my_dress_data[_type].enable_list[_tmpi]
						if (vo.dress_id == id) {
							cfg = this.GetDressCfgByTypeAndIdAndLv(_type, id, vo.dress_lv + 1)
							if (cfg) {
								cost_list = JSON.parse(cfg.cost)
								if (cost_list && cost_list[0]) {
									my_have = goods_model.GetTypeGoodsNum(cost_list[0][1])
									if (my_have >= local_Number(cost_list[0][2])) {
										can_up_level = true
										break
									}
								}
							}
						}
					}
				} else {
					// [ts2lua]this.my_dress_data下标访问可能不正确
					for (let _tmpi in this.my_dress_data[_type].enable_list) {
						var vo = this.my_dress_data[_type].enable_list[_tmpi]
						can_up_level = this.DressCanUplevel(_type, vo.dress_id)
						if (can_up_level) {
							break
						}
					}
				}
			}
			return can_up_level
		}

		this.DressCanActive = (_type?, id?) => {
			let can_active = false
			let cfg_list = this.GetDressAllCfgByType(_type)
			if (cfg_list) {
				if (id) {
					let cfg = null
					let cost_list = null
					let my_have = 0
					let my_data = this.GetMyDressDataByTypeAndId(_type, id)
					if (!my_data) {
						for (let _tmpi in cfg_list) {
							var vo = cfg_list[_tmpi]
							if (vo.id == id) {
								cfg = this.GetDressCfgByTypeAndIdAndLv(_type, id, 1)
								if (cfg) {
									cost_list = JSON.parse(cfg.cost)
									if (cost_list && cost_list[0]) {
										my_have = goods_model.GetTypeGoodsNum(cost_list[0][1])
										if (my_have >= local_Number(cost_list[0][2])) {
											can_active = true
											break
										}
									}
								}
							}
						}
					}
				} else {
					for (let _tmpi in cfg_list) {
						var vo = cfg_list[_tmpi]
						can_active = this.DressCanActive(_type, vo.id)
						if (can_active) {
							break
						}
					}
				}
			}
			return can_active
		}

		this.getHeadICon = (dressId, career) =>{
			let myCareer = career ? career : RoleManager.GetInstance().GetMainRoleCareer();
			let iconStr:string = "";
			let cfg = this.GetDressCfgByTypeAndIdAndLv(DressType.Head ,dressId, 1);
			if(cfg && cfg.screen){ 
				let _headList = JSON.parse(cfg.screen);
				for (let i = 0; i < _headList.length; i++) {
					if(_headList[i][0] == myCareer){
						iconStr = _headList[i][1]
					}
				}
			}
			return iconStr
		}

		this.getDressIdByTurn = (turn: number = 0) =>{
			let dressId: number = 90;
			let cfgList = this.GetDressAllCfgByType(5)
			if(cfgList && cfgList.length){ 
				for (let i = 0, len = cfgList.length; i < len; i++) {
					if(cfgList[i].condition == "[]") continue;
					let condition = JSON.parse(cfgList[i].condition );
					if(condition[0][0] == "turn" && condition[0][1] == turn){
						dressId = cfgList[i].id;
						break
					}
				}
			}
			return dressId
		}

		this.InitUnActDressMap = () => {
			if(config_dress_up_cfg_){
				for (let key in config_dress_up_cfg_) {
					let cfg = Config.GetConfigVo(config_dress_up_cfg_.name, key, false, config_dress_up_cfg_)
					if (cfg.level == 1) {
						if(this.un_act_dress_power_map[cfg.type] == undefined){
							this.un_act_dress_power_map[cfg.type] = {}
						}
						this.un_act_dress_power_map[cfg.type][cfg.id] = { dres_id: cfg.id, dress_lv: 0, cur_power: 0, next_power: 0}
					}
				}
			}
		}

		this.getUnActDressData = (dress_type, dres_id) =>{
			return this.un_act_dress_power_map[dress_type][dres_id]
		}

		this.SetUnActDressData = (dress_type, dress_id, active_power) => {
			let data = this.un_act_dress_power_map[dress_type][dress_id];
			data.next_power = active_power;

		}
	}

	public static GetInstance() {

		if (!DressModel.Instance) {
			DressModel.Instance = new DressModel()
		}
		return DressModel.Instance
	}

}
window["DressModel"] = DressModel