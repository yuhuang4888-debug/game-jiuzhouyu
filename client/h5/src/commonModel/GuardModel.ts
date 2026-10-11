import { EventDispatcher } from "../util/EventDispatcher"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SceneManager } from "../scene/SceneManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { CommonManager } from "../common/CommonManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { table } from "../common/table"

export class GuardModel extends EventDispatcher {
	CanActivePrimaryGuard
	GetActiveGuardNum
	GetGuardActiveType
	GetGuardCfgByTypeId
	GetGuardRed
	OpenStatus
	RefreshRed
	SetGuardInfo
	SetGuardRed
	activate_list
	unactive_cache
	experice_view_open
	goodsToType
	info
	is_frist_21601
	typeTogoods
	static Instance

	public static REQUEST_SCMD = "REQUEST_SCMD"
	public static OPEN_VIEW = "OPEN_VIEW"
	public static OPEN_EXPERIENCE_VIEW = "OPEN_EXPERIENCE_VIEW"
	public static OPEN_ACTIVATE_VIEW = "OPEN_ACTIVATE_VIEW"
	public static UPDATE_RED_DOT = "UPDATE_RED_DOT"
	public static UPDATA_VIEW = "UPDATA_VIEW"

	public constructor() {
		super()
		if (GuardModel.Instance) {
			return
		}

		this.info = []
		this.activate_list = []
		this.unactive_cache = []
		this.is_frist_21601 = true
		this.experice_view_open = false
		this.typeTogoods = {1:38040013, 2:38040014, 3:38040055, 4:38040059}
		this.goodsToType = { [38040013]: 1, [38040014]: 2, [38040055]: 3, [38040059]: 4 }
		let local_GuardModel = GuardModel
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let is_frist_open_un_activate_ = true

		this.SetGuardInfo = (info?, magic_circle_cfg?) => {
			if (!magic_circle_cfg) {
				return
			}
			if (magic_circle_cfg) {
				if (info) {
					let un_active_list = []
					this.activate_list = []
					for (let i in info) {
						let v = info[i]
						if (v.status == 1) {
							table.insert(this.activate_list, v.lv)
						} else if (v.status == 0 && is_frist_open_un_activate_) {
							table.insert(un_active_list, v.lv)
						} else if ((v.status == 0 && !is_frist_open_un_activate_) && this.info) {
							for (let _tmpi in this.info) {
								var v0 = this.info[_tmpi]
								if (v0.lv == v.lv && v0.status == 1) {
									table.insert(un_active_list, v.lv)
								}
							}
						}
					}
					if (un_active_list.length > 0) {
						is_frist_open_un_activate_ = false
						for (let _tmpi in this.activate_list) {
							var active = this.activate_list[_tmpi]
							for (let i in un_active_list) {
								let lv = un_active_list[i]
								if (lv == 1 && active == 3) {
									table.splice(un_active_list, Number(i), 1)
									//un_active_list:splice(local_Number(i), 1)
									break
								} else if (lv == 2 && active == 4) {
									table.splice(un_active_list, Number(i), 1)
									//un_active_list:splice(local_Number(i), 1)
									break
								}
							}
						}
						if (un_active_list.length > 0) {
							//un_active_list = [ 1, 2]
							let sort_fun = (a?, b?) => {
								return a < b
							}
							table.sort(un_active_list, sort_fun)
							if (SceneManager.GetInstance().IsFieldScene()) {
								this.Fire(local_GuardModel.OPEN_ACTIVATE_VIEW, "GuardActivateView", un_active_list)
							}else{
								this.unactive_cache = un_active_list
							}
						}
					}
					this.info = info
				}
				for (let type in this.typeTogoods) {
					this.RefreshRed(type, magic_circle_cfg)
				}
				for (let _tmpi in this.activate_list) {
					var v = this.activate_list[_tmpi]
				}
			}
		}

		this.SetGuardRed = (type?, status?) => {
			red_dot_mgr.SetRedStatus(local_ModuleType.GUARD_RED, type, status)
		}

		this.GetGuardRed = (type?) => {
			return red_dot_mgr.CheckRedStatus(local_ModuleType.GUARD_RED, type)
		}

		this.RefreshRed = (type?, magic_circle_cfg?) => {
			let bool = this.CanActivePrimaryGuard(type, magic_circle_cfg)
			this.SetGuardRed(type, bool)
			this.Fire(local_GuardModel.UPDATE_RED_DOT, type, bool)
			//GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
			this.Fire(local_GuardModel.UPDATA_VIEW)
		}

		this.OpenStatus = (type?) => {
			return CommonManager.GetInstance().CheckFuncOpenState("GuardMainView", true)
		}

		this.CanActivePrimaryGuard = (_type?, config?) => {
			if (!config || !this.OpenStatus(_type)) {
				return false
			}
			let high_type = null
			if (_type == 1) {
				high_type = 3
			} else if (_type == 2) {
				high_type = 4
			}
			for (let i in this.activate_list) {
				if (this.activate_list[i] == high_type) {
					return false
				}
				if (this.activate_list[i] == _type) {
					return false
				}
			}
			let cfg = config["0@" + _type]
			if (cfg) {
				let cost = (typeof (cfg.cost) == "string" && (JSON.parse(cfg.cost)) || (cfg.cost))
				if (cost.length > 0) {
					let enough = false
					let i = 0
					do {
						let goods_num = GoodsModel.GetInstance().GetTypeGoodsNum(cost[0][1][i][1])
						if (goods_num >= Number(cost[0][1][i][2])) {
							enough = true
						}
						i = i + 1
					} while ((i < cost[0][1].length))
					return enough
				}
			}
			return false
		}

		this.GetGuardCfgByTypeId = (type_id?, cfg?) => {
			if (cfg) {
				for (let key in this.typeTogoods) {
					if (type_id == this.typeTogoods[key]) {
						let _cfg = cfg["0@" + key]
						if (_cfg) {
							let attr = _cfg.attr
							if (attr && typeof (attr) == "string") {
								return JSON.parse(attr)
							}
						}
					}
				}
			}
			return null
		}

		this.GetGuardActiveType = () => {
			let info = this.info
			let guard_type1 = null
			let guard_type2 = null
			if (info) {
				for (let _tmpi in info) {
					var vo = info[_tmpi]
					if (vo.status == 1) {
						if (vo.lv == 1 || vo.lv == 3) {
							guard_type1 = (guard_type1 == 3 && (3) || (vo.lv))
						} else if (vo.lv == 2 || vo.lv == 4) {
							guard_type2 = (guard_type2 == 4 && (4) || (vo.lv))
						}
					}
				}
			}
			return [guard_type1, guard_type2]
		}

		this.GetActiveGuardNum = (type_id?) => {
			let my_count = 0
			type_id = Number(type_id)
			if (this.goodsToType[type_id]) {
				let ans = this.GetGuardActiveType()
				let cur_type = this.goodsToType[type_id]
				if (cur_type == ans[0] || cur_type == ans[1]) {
					my_count = 1
				}
			}
			return my_count
		}
	}

	public static GetInstance() {
		if (!GuardModel.Instance) {
			GuardModel.Instance = new GuardModel()
		}
		return GuardModel.Instance
	}
}

window["GuardModel"] = GuardModel