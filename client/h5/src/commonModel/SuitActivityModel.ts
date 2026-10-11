import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { EventDispatcher } from "../util/EventDispatcher"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RoleManager } from "./RoleManager"
import { CommonManager } from "../common/CommonManager"
import { TaskModel } from "./TaskModel"
import { SuitActivityPanel } from "../suitActivity/SuitActivityPanel"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "./GoodsModel"
import { ResManager } from "../common/ResManager"
import { MainStrongerEvent, MainStrongerModel } from "./MainStrongerModel"

export class SuitActivityModel extends EventDispatcher {
	static instance: any

	public static UPDATE_SUIT_AC = "SAE1"
	public static UPDATE_ONE_SUIT = "SAE2"
	public static ACTIVITY_SUIT = "SAE3"
	public static OPEN_VIEW = "SAE4"
	public static OPEN_SUIT_VIEW = "SAE5"
	public static CLOSE_SUIT_VIEW = "SAE6"
	public static UPDATE_TAB_RED = "SAE7"
	public static UPDATE_EQUIP = "SAE8"
	public static WEAR_FASHION = "SAE9"
	public static UPDATE_WEAR_FASHION = "SAE10"
	public static ShowArrowLv = 100

	finish_list
	next_level
	red_list
	suitPanel
	suit_list
	useFashion
	max_suit = 17	// 最大套装id
	showRed
	public constructor() {
		super()
		SuitActivityModel.instance = this

		this.InitData()
	}

	public static GetInstance() {
		if (SuitActivityModel.instance == null) {
			new SuitActivityModel()
		}
		return SuitActivityModel.instance
	}

	// 初始化套装数据
	public InitData() {
		this.suit_list = []
		// suit_id -> status 1红点显示 0 红点不显示 2 已完成 3
		this.red_list = []
		// suit_id -> status 已经完成了的列表
		this.finish_list = []
		//下一个可以激活新套装的等级 !!!
		this.next_level = 0
		for (let i = 1; i <= this.max_suit; i++) {
			this.suit_list[i] = { suit_id: i, cur_stage: 0, cur_pos_list: [] }
		}
	}

	//15256协议设置所有的数据
	public SetSuitData(data?) {
		//this.suit_list = []
		this.red_list = []
		this.finish_list = []
		this.next_level = 0
		for (let _ in data) {
			let vo = data[_]
			let list = []
			for (let _ in vo.cur_pos_list) {
				let active = vo.cur_pos_list[_]
				table.insert(list, active.equip_type)
			}
			vo.cur_pos_list = list
			this.suit_list[vo.suit_id] = vo
		}
		this.UpdateReddot()
		this.Fire(SuitActivityModel.UPDATE_SUIT_AC)
	}

	//15257协议设置单个数据
	public AddSuitData(data?) {
		let list = []
		for (let _ in data.cur_pos_list) {
			let active = data.cur_pos_list[_]
			table.insert(list, active.equip_type)
		}
		data.cur_pos_list = list
		this.suit_list[data.suit_id] = data
		this.UpdateRedById(data.suit_id)
		this.Fire(SuitActivityModel.UPDATE_ONE_SUIT, data)
	}

	//更新全部红点  开启新的套装 第一次进入游戏 穿戴新装备
	public UpdateReddot() {
		let red = false
		let new_red_list = []
		let suit_cfg = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
		let career = RoleManager.GetInstance().GetMainRoleCareer()
		for (let _ in suit_cfg) {
			let vo = suit_cfg[_]
			//已经完成的就不需要去判断了
			if (!this.finish_list[vo.suit_id] && vo.career == career) {
				let status = this.GetSuitStatus(vo.suit_id)
				new_red_list[vo.suit_id] = status == 1
				this.finish_list[vo.suit_id] = status == 2
				if (status == 1) {
					if (!this.red_list[vo.suit_id]) {
						this.Fire(SuitActivityModel.UPDATE_TAB_RED, vo.suit_id, true)
						RedDotController.ins.add(RedKey.SUIT + vo.suit_id, RedKey.SUIT);
						RedDotController.ins.up(RedKey.SUIT + vo.suit_id, 1);
					}
					red = true
				} else if (this.red_list[vo.suit_id]) {
					this.Fire(SuitActivityModel.UPDATE_TAB_RED, vo.suit_id, false)
					RedDotController.ins.add(RedKey.SUIT + vo.suit_id, RedKey.SUIT);
					RedDotController.ins.up(RedKey.SUIT + vo.suit_id, 0);
				}
			}
		}
		this.red_list = new_red_list
		if(red != this.showRed){
			RedDotController.ins.up(RedKey.SUIT, red ? 1 : 0);
			this.ChangeVar("showRed", red)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1525)
			GlobalEventSystem.Fire(MainStrongerEvent.UPDATE, MainStrongerModel.ins.strongerNum);
		}
	}

	//获取套装完成的状态
	public SuitFinishStatus(suit_id?) {
		return this.finish_list[suit_id]
	}

	//根据套装id 获取套装状态 0 无  1可激活  2已完成
	public GetSuitStatus(suit_id?) {
		let cfg_suit = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
		let suit_vo = this.suit_list[suit_id]
		if (suit_vo && suit_vo.cur_stage == 8) {
			return 2
		}
		let career = RoleManager.GetInstance().GetMainRoleCareer()
		let sex = RoleManager.GetInstance().GetMainRoleSex()
		let turn = RoleManager.GetInstance().GetMainRoleTurn()
		let level = RoleManager.GetInstance().GetMainRoleLevel()
		let suit_cfg = cfg_suit[suit_id + "@" + career]
		let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		let is_single = this.IsSuitSingle(suit_id)
		//已经在界面显示了
		if (suit_vo && suit_cfg && role_vo.turn >= suit_cfg.open_turn) {
			//已经开启了
			if (role_vo.level >= suit_cfg.open_lv) {
				let activedCount = suit_vo.cur_pos_list.length
				if ((!is_single && (Math.floor(activedCount) - 1) > suit_vo.cur_stage)
					|| (is_single && Math.floor(activedCount) > suit_vo.cur_stage)) {
					return 1
				} else {
					// 前4套有自动激活
					if (suit_id <= 4) {
						let can_activeCount = 0
						let equip_list = ErlangParser.GetInstance().Parse(suit_cfg.show_equip)
						for (let i in equip_list) {
							let equip = equip_list[i]
							let active = this.GetEquipActiveStatus(suit_id, equip[0])
							if (!active) {
								// 在背包中查找当前阶以及后面高阶装备
								let item_cfg = cfg_suit[suit_id + "@" + career]
								if (item_cfg) {
									let need_stage = item_cfg.stage
									let need_star = item_cfg.star
									let need_color = item_cfg.color
									let need_type = equip[0]
									let equip_list = GoodsModel.GetInstance().GetEquipList()
									let cfg_equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
									for (let j in equip_list) {
										let equip = equip_list[j]
										let equip_attr = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false, cfg_equip_attr)
										// 残装过滤
										if (equip_attr && equip_attr.class_type != 1) {
											// 先判断是否满足激活
											if (equip.subtype == need_type && equip.stage >= need_stage && equip.star >= need_star && equip.color >= need_color) {
												// 再判断玩家是否能穿戴
												if ((career == equip.career_id || equip.career_id == 0)
													&& (sex == equip.sex || equip.sex == 0)
													&& turn >= equip.turn && level >= equip.level) {
													can_activeCount = can_activeCount + 1
													break
												}
											}
										}
									}
								}
							}
						}
						if ((!is_single && (Math.floor(activedCount + can_activeCount) - 1) > suit_vo.cur_stage)
							|| (is_single && Math.floor(activedCount + can_activeCount) > suit_vo.cur_stage)) {
							return 1
						}
					}
				}
			} else {
				this.next_level = suit_cfg.open_lv <= this.next_level && suit_cfg.open_lv || this.next_level
			}
		}
		return 0
	}

	//判断对应套装是否在主界面sub显示
	public GetSuitOpen(suit_id?) {
		let cfg_suit = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
		let cfg = cfg_suit[suit_id + "@" + RoleManager.GetInstance().GetMainRoleCareer()]
		return cfg && RoleManager.GetInstance().GetMainRoleTurn() >= cfg.open_turn
	}

	//判断套装部位是否激活
	public GetEquipActiveStatus(suit_id?, equip_type?) {
		return this.suit_list[suit_id] && Util.TableContains(this.suit_list[suit_id].cur_pos_list, Number(equip_type))
	}

	//获取套装可激活下一阶段
	public GetNextStage(suit_id?) {
		let next_id
		let is_single = this.IsSuitSingle(suit_id)
		if (is_single) {
			next_id = this.suit_list[suit_id] && (this.suit_list[suit_id].cur_stage + 1) || 1
		} else {
			next_id = this.suit_list[suit_id] && (this.suit_list[suit_id].cur_stage + 2) || 2
		}
		return next_id
	}

	public GetCurentMaxStage(suit_id) {
		let value = 0
		let cfg_suit = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
		let career = RoleManager.GetInstance().GetMainRoleCareer()
		let sex = RoleManager.GetInstance().GetMainRoleSex()
		let turn = RoleManager.GetInstance().GetMainRoleTurn()
		let level = RoleManager.GetInstance().GetMainRoleLevel()
		let suit_cfg = cfg_suit[suit_id + "@" + career]
		if (suit_cfg) {
			let equip_list = ErlangParser.GetInstance().Parse(suit_cfg.show_equip)
			for (let i in equip_list) {
				let equip = equip_list[i]
				let active = this.GetEquipActiveStatus(suit_id, equip[0])
				if (!active && suit_id <= 4) {
					// 在背包中查找当前阶以及后面高阶装备
					let item_cfg = cfg_suit[suit_id + "@" + career]
					if (item_cfg) {
						let need_stage = item_cfg.stage
						let need_star = item_cfg.star
						let need_color = item_cfg.color
						let need_type = equip[0]
						let equip_list = GoodsModel.GetInstance().GetEquipList()
						let cfg_equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false)
						for (let j in equip_list) {
							let equip = equip_list[j]
							let equip_attr = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_equip_attr.name, equip.type_id, false, cfg_equip_attr)
							// 残装过滤
							if (equip_attr && equip_attr.class_type != 1) {
								// 先判断是否满足激活
								if (equip.subtype == need_type && equip.stage >= need_stage && equip.star >= need_star && equip.color >= need_color) {
									// 再判断玩家是否能穿戴
									if ((career == equip.career_id || equip.career_id == 0)
										&& (sex == equip.sex || equip.sex == 0)
										&& turn >= equip.turn && level >= equip.level) {
										value = value + 1
										break
									}
								}
							}
						}
					}
				} else if (active) {
					value = value + 1
				}
			}
		}

		let single = this.IsSuitSingle(suit_id)
		let stage = single ? value : (value - value % 2)
		return stage
	}

	//获取当前套装等级
	public GetCurStage(suit_id?) {
		return this.suit_list[suit_id] && this.suit_list[suit_id].cur_stage || 0
	}

	//更新某一套装的红点
	public UpdateRedById(suit_id?) {
		let status = this.GetSuitStatus(suit_id)
		let red = status == 1
		this.finish_list[suit_id] = status == 2
		if (!red) {
			this.red_list[suit_id] = red
			this.Fire(SuitActivityModel.UPDATE_TAB_RED, suit_id, false)
			RedDotController.ins.add(RedKey.SUIT + suit_id, RedKey.SUIT);
			RedDotController.ins.up(RedKey.SUIT + suit_id, 0);
			let total_false
			for (let _ in this.red_list) {
				let vo = this.red_list[_]
				if (vo) {
					total_false = true
					break
				}
			}
			if (!total_false) {
				if(this.showRed != false){
					RedDotController.ins.up(RedKey.SUIT, 0)
					this.ChangeVar("showRed", false)
					GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 1525)
					GlobalEventSystem.Fire(MainStrongerEvent.UPDATE, MainStrongerModel.ins.strongerNum);
				}
			}
		}
	}

	public AddActiveData(data?) {
		let min
		let activeList = []
		for (let k in data.suit_id_list) {
			let v = data.suit_id_list[k]
			activeList[v.suit_id] = true
		}
		//把旧的删除
		// for (let key in this.suit_list) {
		// 	let value = this.suit_list[key]
		// 	if (value.cur_stage != 8 && !activeList[value.suit_id]) {
		// 		for (let i = (value.cur_pos_list.length - 1); i >= 0; i -= 1) {
		// 			if (value.cur_pos_list[i] == data.equip_type) {
		// 				table.remove(value.cur_pos_list, i)
		// 				this.Fire(SuitActivityModel.UPDATE_EQUIP, { suit_id: value.suit_id, equip_type: data.equip_type })
		// 				break
		// 			}
		// 		}
		// 	}
		// }
		for (let i = 0, len = data.suit_id_list.length; i < len; i++) {
			let suitId = data.suit_id_list[i].suit_id
			let value = this.suit_list[suitId]
			if (value && value.cur_stage != 8 && !activeList[value.suit_id]) {
				for (let i = (value.cur_pos_list.length - 1); i >= 0; i -= 1) {
					if (value.cur_pos_list[i] == data.equip_type) {
						table.remove(value.cur_pos_list, i)
						this.Fire(SuitActivityModel.UPDATE_EQUIP, { suit_id: value.suit_id, equip_type: data.equip_type })
						break
					}
				}
			}
		}

		for (let key in data.suit_id_list) {
			let vo = data.suit_id_list[key]
			let activeData = this.suit_list[vo.suit_id]
			let con
			if (!activeData) {
				this.suit_list[vo.suit_id] = { suit_id: vo.suit_id, cur_stage: 0, cur_pos_list: [data.equip_type] }
				con = true
			} else if (activeData.cur_stage != 8) {
				for (let k in activeData.cur_pos_list) {
					let vo = activeData.cur_pos_list[k]
					if (vo == data.equip_type) {
						con = true
						break
					}
				}
				if (!con) {
					table.insert(this.suit_list[vo.suit_id].cur_pos_list, data.equip_type)
				}
			} else {
				con = true
			}
			if (!con) {
				this.Fire(SuitActivityModel.UPDATE_EQUIP, { suit_id: vo.suit_id, equip_type: data.equip_type })
				if (!min || min > vo.suit_id) {
					min = vo.suit_id
				}
			}
		}

		let cfg = CommonManager.GetInstance().GetFunctionIconCfg("1525")
		let roleVo = RoleManager.GetInstance().GetMainRoleVo()
		let taskId = TaskModel.GetInstance().newest_finish_task_id
		if (cfg && roleVo.level >= cfg.open_lv && taskId >= cfg.open_task_id) {
			//只有套装1 套装2 满足2，4，6，8阶才飘
			if (min && (min == 1 || min == 2)) {
				let suitList = this.suit_list[min]
				if (suitList) {
					if ((Util.TableSize(suitList.cur_pos_list) % 2 == 0)) {
						if (!this.suitPanel) {
							this.suitPanel = new SuitActivityPanel()
						}
						this.suitPanel.Open()
						this.suitPanel.AddEquip({ suit_id: min, equip_type: data.equip_type })
					}
				}
			}
		}
	}

	public SetFashionData(data?) {
		if (data.is_wear > 0) {
			this.useFashion = data.suit_id
		} else {
			this.useFashion = null
		}
	}

	// 判断套装是否是单个激活类型
	public IsSuitSingle(suit_id) {
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_suit_clt_process
		if (cfg) {
			let item = cfg[suit_id + "@1"]
			if (item) {
				return true
			}
		}
		return false
	}
}
window["SuitActivityModel"] = SuitActivityModel