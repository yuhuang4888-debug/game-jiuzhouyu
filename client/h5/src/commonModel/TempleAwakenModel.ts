import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { ColorUtil } from "../util/ColorUtil"
import { GoodsModel } from "./GoodsModel"
import { Message } from "../sysInfo/SysInfoController"

//let TempleAwakenModel = []
export let TempleAwakenEvent = {
	REQUEST_PROTO: "TempleAwakenEvent.REQUEST_PROTO",
	UPDATE_VIEW: "TempleAwakenEvent.UPDATE_VIEW",
	UPDATE_WEAR_STAGE: "TempleAwakenEvent.UPDATE_WEAR_STAGE",
	UPDATE_TASK_ITEM: "TempleAwakenEvent.UPDATE_TASK_ITEM"
}
export let enum_Key_TempleAwaken = [
	5,
	3,
	2,
	4
]

window["TempleAwakenEvent"] = TempleAwakenEvent
window["enum_Key_TempleAwaken"] = enum_Key_TempleAwaken
export class TempleAwakenModel extends EventDispatcher {
	GetFrontTaskComplete
	GetLastChapter
	GetMainChapterInfo
	GetNowChapter
	GetNowSubChapter
	GetNowTask
	GetOpenLv
	GetPos
	GetRed
	GetSubChapterInfo
	GetSubChapterTaskInfo
	GetTaskComplete
	GetWearInfo
	IsWearAwaken
	ReceiveNowChapterAll
	ReceiveNowSubChapterAll
	SaveUnlockInfo
	SetFrontTaskComplete
	SetLastChapter
	SetPos
	SetTaskComplete
	SetWearInfo
	ShowReward
	UpdateMainChapterInfo
	UpdateSubChapterInfo
	UpdateSubChapterTaskInfo
	UpdateTaskInfo
	UpdateUnlockInfo
	SendPopMsg

	//配置
	InitCfg

	//是否正在动画中
	is_moving=false

	public constructor() {
		super()


		let main_chapter_info = {}
		let sub_chapter_info = []
		let sub_chapter_task_info = []
		let last_chapter = 0
		let wear_info = []
		let task_complete = 0
		let front_task_complete = false

		let pos = []
		//let erlang_parse = ErlangParser.GetInstance()

		this.UpdateUnlockInfo = (v?) => {
			let main_chapter = v.chapter
			main_chapter_info[main_chapter] = v
			if (v.sub_list && v.sub_list.length > 0) {
				for (let _ in v.sub_list) {
					var v1 = v.sub_list[_]
					let sub_chapter = v1.sub_chapter
					sub_chapter_info[main_chapter] = sub_chapter_info[main_chapter] || {}
					sub_chapter_info[main_chapter][sub_chapter] = v1
					if (v1.stage_list && v1.stage_list.length > 0) {
						for (let _ in v1.stage_list) {
							var v2 = v1.stage_list[_]
							sub_chapter_task_info[main_chapter] = sub_chapter_task_info[main_chapter] || {}
							sub_chapter_task_info[main_chapter][sub_chapter] = sub_chapter_task_info[main_chapter][sub_chapter] || {}
							sub_chapter_task_info[main_chapter][sub_chapter][v2.stage] = v2
						}
					}
				}
			}
		}
		this.GetMainChapterInfo = () => {
			return main_chapter_info
		}
		this.GetSubChapterInfo = () => {
			return sub_chapter_info
		}
		this.GetSubChapterTaskInfo = () => {
			return sub_chapter_task_info
		}

		this.SetTaskComplete = (complete?) => {
			task_complete = complete
		}

		this.GetTaskComplete = (complete?) => {
			return task_complete && task_complete != 0
		}

		this.GetFrontTaskComplete = () => {
			//return front_task_complete && front_task_complete != 0
			return front_task_complete
		}

		this.SetFrontTaskComplete = (complete?) => {
			front_task_complete = complete
		}
		this.GetPos = () => {
			return pos
		}

		this.SetPos = (p?) => {
			pos = p
		}


		this.IsWearAwaken = (type?) => {
			return wear_info[enum_Key_TempleAwaken[type]] == 1
			//return wear_info[enum_Key_TempleAwaken[type * / == 1
		}

		this.GetRed = () => {
			let bool = false
			let now_chapter = this.GetNowChapter()
			let sub_chapter = this.GetNowSubChapter()
			if (sub_chapter_task_info && sub_chapter_task_info[now_chapter] && sub_chapter_task_info[now_chapter][sub_chapter] && Util.TableSize(sub_chapter_task_info[now_chapter][sub_chapter]) > 0) {
				for (let _ in sub_chapter_task_info[now_chapter][sub_chapter]) {
					var v = sub_chapter_task_info[now_chapter][sub_chapter][_]
					if (v.status == 2) {
						bool = true
					}
				}
				return bool
			}
		}


		this.SaveUnlockInfo = (list?) => {
			if (list && list.length > 0) {
				for (let _ in list) {
					var v = list[_]
					let main_chapter = v.chapter
					main_chapter_info[main_chapter] = v
					wear_info[main_chapter] = v.is_wear
					if (v.sub_list && v.sub_list.length > 0) {
						for (let _ in v.sub_list) {
							var v1 = v.sub_list[_]
							let sub_chapter = v1.sub_chapter
							sub_chapter_info[main_chapter] = sub_chapter_info[main_chapter] || {}
							sub_chapter_info[main_chapter][sub_chapter] = v1
							if (v1.stage_list && v1.stage_list.length > 0) {
								for (let _ in v1.stage_list) {
									var v2 = v1.stage_list[_]
									sub_chapter_task_info[main_chapter] = sub_chapter_task_info[main_chapter] || {}
									sub_chapter_task_info[main_chapter][sub_chapter] = sub_chapter_task_info[main_chapter][sub_chapter] || {}
									sub_chapter_task_info[main_chapter][sub_chapter][v2.stage] = v2
								}
							}
						}
					}
				}
			}
		}

		this.UpdateTaskInfo = (chapter?, sub_chapter?, stage?) => {
			sub_chapter_task_info[chapter][sub_chapter][stage].status = 3
		}

		this.SetWearInfo = (chapter?, wear?) => {
			wear_info[chapter] = wear
		}
		this.GetWearInfo = (chapter?) => {
			return wear_info[chapter]
		}

		this.UpdateMainChapterInfo = (info?) => {
			let chapter = info.chapter
			main_chapter_info[chapter] = main_chapter_info[chapter] && main_chapter_info[chapter] || {}
			main_chapter_info[chapter].status = info.status
			main_chapter_info[chapter].chapter = info.chapter
			main_chapter_info[chapter].is_wear = main_chapter_info[chapter].is_wear && main_chapter_info[chapter].is_wear || 0
		}
		this.UpdateSubChapterInfo = (info?) => {
			let chapter = info.chapter
			let sub_chapter = info.sub_chapter
			sub_chapter_info[chapter] = sub_chapter_info[chapter] || {}
			sub_chapter_info[chapter][sub_chapter] = sub_chapter_info[chapter][sub_chapter] || {}
			sub_chapter_info[chapter][sub_chapter].sub_status = info.sub_status
			sub_chapter_info[chapter][sub_chapter].sub_chapter = info.sub_chapter
		}
		this.UpdateSubChapterTaskInfo = (info?) => {
			let chapter = info.chapter
			let sub_chapter = info.sub_chapter
			let stage = info.stage
			sub_chapter_task_info[chapter] = sub_chapter_task_info[chapter] || {}
			sub_chapter_task_info[chapter][sub_chapter] = sub_chapter_task_info[chapter][sub_chapter] || {}
			sub_chapter_task_info[chapter][sub_chapter][stage] = sub_chapter_task_info[chapter][sub_chapter][stage] || {}
			sub_chapter_task_info[chapter][sub_chapter][stage].process = info.process
			sub_chapter_task_info[chapter][sub_chapter][stage].status = info.stage_status
			sub_chapter_task_info[chapter][sub_chapter][stage].stage = info.stage
		}
		this.GetOpenLv = () => {
			let cfg_kv = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv//Config.Templeawakenkv
			let open =JSON.parse(cfg_kv[6].value)[1][2]
			return open
		}

		this.GetNowTask = (now_chapter) => {
			if(!now_chapter){
				now_chapter = this.GetNowChapter()
			}
			let task_info 
			task_info= {}
			let career = RoleManager.GetInstance().GetMainRoleCareer()
			if (career == 0 || !career) { return }
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_stage//Config.Templeawakenstage
			let chapter_cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken//Config.Templeawaken
			//let now_chapter = this.GetNowChapter()
			let sub_num = chapter_cfg[now_chapter].sub_chapter_num
			let task_num = chapter_cfg[now_chapter].sub_chapter_stage_num
			let main_role_lv = RoleManager.GetInstance().GetMainRoleLevel()
			let sub_chapter = this.GetNowSubChapter()
			let cfg_kv = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv//Config.Templeawakenkv
			let open =ErlangParser.GetInstance().Parse(cfg_kv[6].value)[0][1]
			let last_chapter = this.GetLastChapter()
			let is_complete_all = (last_chapter == now_chapter && this.ReceiveNowChapterAll(now_chapter))
			if (is_complete_all) {
				task_info = {is_complete : true}
				return task_info
			} else {
				if (main_role_lv >= Number(open) && !this.ReceiveNowChapterAll(now_chapter) && !this.ReceiveNowSubChapterAll(now_chapter, sub_chapter) && sub_chapter_task_info[now_chapter] && sub_chapter_task_info[now_chapter][sub_chapter]) {
					let cfg_list = []
					for (let _ in cfg) {
						var v0 = cfg[_]
						table.insert(cfg_list, v0)
					}
					table.sort(cfg_list, (a?, b?) => {
						if (a.chapter_id == b.chapter_id) {
							if (a.sub_chapter == b.sub_chapter) {
								return a.stage < b.stage
							} else {
								return a.sub_chapter < b.sub_chapter
							}
						} else {
							return a.chapter_id < b.chapter_id
						}
					})



					let is_doing = false
					let can_receive = false
					let all_stage = sub_num * task_num
					let task_info_now = sub_chapter_task_info[now_chapter]

					//if (task_info_now && task_info_now[sub_chapter] && task_info_now[sub_chapter].length > 0) {
					if (task_info_now && task_info_now[sub_chapter]) {
						let stage_list = sub_chapter_task_info[now_chapter][sub_chapter]
						let stage_list_ = []
						for (let _ in stage_list) {
							var vo1 = stage_list[_]
							table.insert(stage_list_, vo1)
						}
						table.sort(stage_list_, (a?, b?) => {
							return a.stage < b.stage
						})
						let doing_num = 0
						for (let _ in stage_list_) {
							var value = stage_list_[_]
							let goods_name = chapter_cfg[now_chapter] && chapter_cfg[now_chapter].chapter_name
							let show_goods_id =ErlangParser.GetInstance().Parse(chapter_cfg[now_chapter].show_goods_id)[career-1]
							let goods_id = chapter_cfg[now_chapter] && show_goods_id && show_goods_id[1]
							let now_stage = 1
							if (value.status == 1) {
								doing_num = doing_num + 1
								if (!is_doing && !can_receive) {
									is_doing = true
									task_info = {isactive : true, goods_name : now_chapter, goods_id : goods_id, now_stage : 1, all_stage : all_stage, stage_name : cfg[now_chapter + "@" + sub_chapter + "@" + value.stage].stage_name}
								}
							}
							if (value.status == 2) {
								can_receive = true
								doing_num = doing_num + 1
								task_info = {isactive : true, goods_name : now_chapter, goods_id : goods_id, now_stage : 1, all_stage : all_stage, stage_name : "可领取奖励", can_receive : can_receive}
							}

						}
						task_info.now_stage = task_num * (sub_chapter - 1) + (task_num - doing_num) + 1
					}
					return task_info
				} else {
					let now = (main_role_lv >= Number(open) && this.ReceiveNowChapterAll(now_chapter)) && now_chapter + 1 || now_chapter
					let sub = (main_role_lv >= Number(open) && !this.ReceiveNowChapterAll(now_chapter) && this.ReceiveNowSubChapterAll(now_chapter, sub_chapter)) && sub_chapter + 1 || sub_chapter
					if (!cfg[now + "@" + sub + "@1"]) { return }
					let open_sub = now == now_chapter && sub || 1
					let open_con =ErlangParser.GetInstance().Parse(cfg[now + "@" + open_sub + "@1"].open_con)
					if (main_role_lv < Number(open)) {
						task_info = {isactive : false, title : "觉醒之路", open_lv : open, is_lock_task : false}
					} else {
						task_info = {isactive : false, title : "觉醒之路", open_lv : open_con[0][1], is_lock_task : true}
					}
					return task_info
				}
			}
		}

		this.ReceiveNowChapterAll = (chapter?) => {
			//let cfg = Config.Templeawakenstage
			//for (let _ in cfg) {
			//var v = cfg[_]
			//if (v.chapter_id == chapter && sub_chapter_task_info[chapter] && ((sub_chapter_task_info[chapter][v.sub_chapter] && sub_chapter_task_info[chapter][v.sub_chapter][v.stage] && sub_chapter_task_info[chapter][v.sub_chapter][v.stage].status != 3) || (! sub_chapter_task_info[chapter][v.sub_chapter])) ) {
			//return false
			//}
			//}
			return main_chapter_info[chapter] && main_chapter_info[chapter].status == 3
		}

		this.ReceiveNowSubChapterAll = (chapter?, sub_chapter?) => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_stage//Config.Templeawakenstage
			for (let _ in cfg) {
				var v = cfg[_]
				if (v.chapter_id == chapter && sub_chapter == v.sub_chapter && ((!sub_chapter_task_info[chapter] || !sub_chapter_task_info[chapter][v.sub_chapter] || !sub_chapter_task_info[chapter][v.sub_chapter][v.stage]) || (sub_chapter_task_info[chapter] && sub_chapter_task_info[chapter][v.sub_chapter] && sub_chapter_task_info[chapter][v.sub_chapter][v.stage] && sub_chapter_task_info[chapter][v.sub_chapter][v.stage].status != 3))) {
					return false
				}
			}
			return true
		}

		/**获取当前的大章节 */
		this.GetNowChapter = () => {
			let chapter = null
			let chapter_cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken//Config.Templeawaken
			let list = []
			let main_role_lv = RoleManager.GetInstance().GetMainRoleLevel()
			for (let _ in chapter_cfg) {
				var v = chapter_cfg[_]
				table.insert(list, v)
			}
			table.sort(list, (a?, b?) => {
				return a.chapter_id < b.chapter_id
			})
			for (let i = 1; i <= list.length; i++) {
				chapter = list[i].chapter_id
				break
			}
			list = []
			for (let _ in main_chapter_info) {
				var v = main_chapter_info[_]
				table.insert(list, v)
			}
			table.sort(list, (a?, b?) => {
				return a.chapter < b.chapter
			})
			if (list && Util.TableSize(list) > 0) {
				for (let _ in list) {
					var v1 = list[_]
					let open_condition =ErlangParser.GetInstance().Parse(chapter_cfg[v1.chapter].condition)[0][1]
					if (Number(open_condition) <= main_role_lv) {
						chapter = v1.chapter
						if (v1.status == 1) {
							break
						}
					}
				}
			}
			return chapter
		}

		/**获取当前的子章节 */
		this.GetNowSubChapter = (now_chapter?, show_new_task?) => {
			let sub_chapter = null
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_stage
			let main_role_lv = RoleManager.GetInstance().GetMainRoleLevel()
			now_chapter = now_chapter && now_chapter || this.GetNowChapter()

			let list = []
			for (let _ in cfg) {
				var v = cfg[_]
				table.insert(list, v)
			}
			table.sort(list, (a?, b?) => {
				if (a.chapter_id == b.chapter_id) {
					if (a.sub_chapter == b.sub_chapter) {
						return a.stage < b.stage
					} else {
						return a.sub_chapter < b.sub_chapter
					}
				} else {
					return a.chapter_id < b.chapter_id
				}
			})

			for (let i = 1; i <= list.length; i++) {
				if (now_chapter == list[i].chapter_id) {
					sub_chapter = list[i].sub_chapter
					break
				}
			}

			if (sub_chapter_info && sub_chapter_info[now_chapter] && Util.TableSize(sub_chapter_info[now_chapter]) > 0) {
				for (let _ in sub_chapter_info[now_chapter]) {
					var v1 = sub_chapter_info[now_chapter][_]
					if (v1.sub_chapter && now_chapter && cfg[now_chapter + "@" + v1.sub_chapter + "@1"]) {
						let open_con = ErlangParser.GetInstance().Parse(cfg[now_chapter + "@" + v1.sub_chapter + "@1"].open_con)
						if (Number(main_role_lv) >= Number(open_con[0][1])) {
							sub_chapter = v1.sub_chapter
							if (v1.sub_status == 1) {
								break
							}
						}
					}
				}
			}
			return sub_chapter
		}

		this.SetLastChapter = () => {
			let id = 0
			let chapter_cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken
			let list = []
			for (let _ in chapter_cfg) {
				var v = chapter_cfg[_]
				table.insert(list, v)
				id = v.chapter_id
			}
			table.sort(list, (a?, b?) => {
				return a.chapter_id < b.chapter_id

			})
			for (let _ in list) {
				var v1 = list[_]
				id = v1.chapter_id
			}
			last_chapter = id

		}

		this.GetLastChapter = () => {
			return last_chapter
		}

		this.ShowReward = (chapter?, sub_chapter?, stage?) => {
			//按需求隐藏恭喜获得界面
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_stage//Config.Templeawakenstage
			let show_goods =ErlangParser.GetInstance().Parse(cfg[chapter + "@" + sub_chapter + "@" + stage].reward)
			// let cov = new CongratulationObtainView(show_goods)
			// cov.Open()
			let goodsModel = GoodsModel.GetInstance()
			for (let _tmpi in show_goods) {
				var v = show_goods[_tmpi]
				let [typeId, lock] = goodsModel.GetMappingTypeId(v[0], v[1])
				let basic = goodsModel.GetGoodsBasicByTypeId(typeId)
				if (basic && basic.max_overlap == 0) {
					for (let i = 0; i < v[2]; i++) {
						Message.show("获得<font color='" + ColorUtil.GetColorLight(basic.color, false) + "'>" + basic.goods_name + "x1</font>")
					}
				} else {
					let num = 0
					num = v[2] ? v[2] : v[1];
					Message.show("获得<font color='" + ColorUtil.GetColorLight(basic.color, false) + "'>" + basic.goods_name + "x" + num + "</font>")
				}
			}

			if (chapter == 1001 && sub_chapter == 1 && stage == 1) {
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "TempleAwakenBaseView")
			}
		}

		this.InitCfg=()=>{
			// if (!this.awaken_stage_cfg) {
			// 	ResManager.GetInstance().LoadGameConfig(this, "config_temple_awaken_stage", false, null, (cfgs?) => {
			// 		this.awaken_stage_cfg = cfgs
			// 		ResManager.GetInstance().DestoryGameConfig(this, "config_temple_awaken_stage")
			// 	})
			// }

			// if (!this.awaken_cfg) {
			// 	ResManager.GetInstance().LoadGameConfig(this, "config_temple_awaken", false, null, (cfgs?) => {
			// 		this.awaken_cfg = cfgs
			// 		ResManager.GetInstance().DestoryGameConfig(this, "config_temple_awaken")
			// 	})
			// }

			// if(!Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv){
			// 	ResManager.GetInstance().LoadGameConfig(this, "config_temple_awaken_kv", false, null, (cfgs?) => {
			// 		Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_kv = cfgs
			// 		ResManager.GetInstance().DestoryGameConfig(this, "config_temple_awaken_kv")
			// 	})
			// }
		}

		this.SendPopMsg=()=>{
			this.Fire(TempleAwakenEvent.REQUEST_PROTO, 10211)
		}
		this.InitCfg()

	}


	static Instance
	public static GetInstance() {

		if (!TempleAwakenModel.Instance) {
			TempleAwakenModel.Instance = new TempleAwakenModel()
		}
		return TempleAwakenModel.Instance
	}

}
window["TempleAwakenModel"] = TempleAwakenModel