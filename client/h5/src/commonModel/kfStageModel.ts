import { EventDispatcher } from "../util/EventDispatcher"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { CommonManager } from "../common/CommonManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ViewPopLevelModel } from "./ViewPopLevelModel"
import { Mathf } from "../util/Mathf"

export class kfStageModel extends EventDispatcher {
	public static Instance:kfStageModel
	public static OPEN_VIEW = "OPEN_VIEW"
	public static CLOSE_VIEW = "CLOSE_VIEW"
	public static UPDATE_VIEW = "UPDATE_VIEW"

	public static FUNC_135 = 135 //九魂妖塔
	public static FUNC_218 = 218 //尊神战场
	public static FUNC_284 = 284 //跨服异域
	public static FUNC_402 = 402 //结社神兽
	public static FUNC_506 = 506 //最强结社
	public static FUNC_204 = 204 //时空圣痕
	public static FUNC_241 = 241 //众生之门
	public static FUNC_133 = 133 //斩妖榜单
	public static FUNC_189 = 189 //璀璨之海
	public static FUNC_206 = 206 //百鬼夜行
	server_mod = [1, 2, 4, 8]	// 跨服模式
	open_day = 0				// 开服天数
	func_list = {}				// 功能列表
	old_mod = {}				// 功能之前的跨服模式
	server_info=[]              //服务器信息
	receive_count = 0
	receive_max = 3
	wait_loginloading = true
	public constructor() {
		super()
		if (kfStageModel.Instance) {
			return
		}
		kfStageModel.Instance = this
	}

	public SetData(data) {
		if (!data) {
			return
		}
		this.open_day = data.open_day
		this.server_info = data.server_info
		this.SetServerData(data.list)
	}
	public GetServerInfoBySid(server_id){
		if(!this.server_info)return null
		for(let i=0;i<this.server_info.length;i++){
			if(this.server_info[i].server_id==server_id){
				return this.server_info[i]
			}
		}
		return null
	}

	public SetServerData(list) {
		if (!list) {
			return
		}
		for (let i in list) {
			let vo = list[i]
			this.func_list[vo.module_id] = vo
		}
		this.receive_count = this.receive_count + 1
		this.CheckKFStage()
		this.Fire(kfStageModel.UPDATE_VIEW)
	}

	// // 最强结社50622协议
	// public SetGuildData(data) {
	// 	if (!data) {
	// 		return
	// 	}
	// 	let list = []
	// 	for (let i in data.server_list) {
	// 		let vo = data.server_list[i]
	// 		table.insert(list, {
	// 			server_id: vo.server_id,
	// 			server_num: vo.server_num,
	// 			server_name: vo.server_name,
	// 			world_lv: vo.wlv
	// 		})
	// 	}
	// 	let guild = {
	// 		mod: data.mode_num,
	// 		module_id: 506,
	// 		server_ids: list,
	// 		avg_lv: data.avg_wlv
	// 	}
	// 	this.func_list[guild.module_id] = guild
	// 	this.receive_count = this.receive_count + 1
	// 	this.CheckKFStage()
	// 	this.Fire(kfStageModel.UPDATE_VIEW)
	// }

	// 圣灵战场21801协议
	public SetHolyBattleData(data) {
		if (!data) {
			return
		}
		//计算一下平均等级
		let wlv = 0
		for (let _tmpi in data.server_list) {
			var vo = data.server_list[_tmpi]
			wlv = wlv + vo.lv
		}
		let avg_wlv = Mathf.Floor(wlv / data.server_list.length)
		let list = []
		for (let i in data.server_list) {
			let vo = data.server_list[i]
			table.insert(list, {
				server_id: vo.server_id,
				server_num: vo.server_num,
				server_name: vo.server_name,
				world_lv: vo.lv
			})
		}
		let holy = {
			mod: data.mod,
			module_id: 218,
			server_ids: list,
			next_server_ids:[],
			avg_lv: avg_wlv
		}
		this.func_list[holy.module_id] = holy
		this.receive_count = this.receive_count + 1
		this.CheckKFStage()
		this.Fire(kfStageModel.UPDATE_VIEW)
	}

	/**百鬼夜行 */
	// public SetGhostWalkData(data: ProtoRecvVObj<20601>) {
	// 	if (!data) {
	// 		return
	// 	}
	// 	let list = []
	// 	for (let vo of data.ser_list) {
	// 		table.insert(list, {
	// 			server_id: vo.ser_id,
	// 			server_num: vo.ser_num,
	// 			server_name: vo.ser_name,
	// 			world_lv: vo.world_lv
	// 		})
	// 	}
	// 	let holy = {
	// 		mod: data.ser_mod,
	// 		module_id: kfStageModel.FUNC_206,
	// 		server_ids: list,
	// 		avg_lv: data.avg_wlv
	// 	}
	// 	this.func_list[holy.module_id] = holy
	// 	this.receive_count = this.receive_count + 1
	// 	this.CheckKFStage()
	// 	this.Fire(kfStageModel.UPDATE_VIEW)
	// }
	// 获取服务器跨服数据
	public GetFuncData() {
		let list = []
		for (let i in this.func_list) {
			let vo = this.func_list[i]
			table.insert(list, vo)
		}
		return list
	}

	// 获取前一跨服
	public GetFrontMod(cur_mod) {
		for (let i in this.server_mod) {
			let mod = this.server_mod[i]
			if (mod == cur_mod) {
				let front = Number(i) - 1
				if (front < 0) {
					return false
				} else {
					return this.server_mod[front]
				}
			}
		}
		return false
	}

	// 获取下一跨服
	public GetNextMod(cur_mod) {
		for (let i in this.server_mod) {
			let mod = this.server_mod[i]
			if (mod == cur_mod) {
				let next = Number(i) + 1
				if (next >= this.server_mod.length) {
					return false
				} else {
					return this.server_mod[next]
				}
			}
		}
		return false
	}

	// 检查是否有开启跨服
	public CheckKFStage() {
		// 必须在三个协议更新完后才能检查
		if (this.receive_count < this.receive_max || this.wait_loginloading) {
			return
		}
		this.receive_count = 0
		for (let i in this.func_list) {
			let vo = this.func_list[i]
			let old = this.old_mod[vo.module_id] || 1
			if (vo.mod > old) {
				let open = CommonManager.GetInstance().CheckFuncOpenState("DailyTaskView", true)
				if (open) {
					/* this.Fire(kfStageModel.OPEN_VIEW, "kfStageOpenView") */
					// 为了统一管理
					/* GlobalEventSystem.Fire(EventName.OPEN_VIEW, "kfStageOpenView"); */
					ViewPopLevelModel.GetInstance().SetView('kfStageOpenView')
				}
				return
			}
		}
	}

	// 初始化Cookie
	public InitCookieData() {
		let config = Config.PRELOAD_CLIENT_CONFIG.ConfigKFuncIcon
		for (let i in config) {
			let vo = config[i]
			let mod = CookieWrapper.GetInstance().GetCookie(vo.func, true)
			if(!mod){
				mod = "1"
			}
			this.old_mod[vo.func] = Number(mod)
		}
	}

	// 存储新的跨服
	public SaveCookie() {
		for(let i in this.func_list){
			let vo = this.func_list[i]
			this.old_mod[vo.module_id] = vo.mod
			CookieWrapper.GetInstance().SaveCookie(vo.module_id, vo.mod, true)
		}
	}

	/***根据模块 */
	public OpenKfStageView(mod_id){
		if(!this.func_list)return
		let data = this.func_list[mod_id]
		if(data){
			this.Fire(kfStageModel.OPEN_VIEW, "kfStageStartView", data)
		}
	}
	public static GetInstance() {
		if (!kfStageModel.Instance) {
			kfStageModel.Instance = new kfStageModel()
		}
		return kfStageModel.Instance
	}
}
window["kfStageModel"] = kfStageModel