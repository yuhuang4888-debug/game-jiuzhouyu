import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { MaterialsTool } from "../common/MaterialsTool";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { ViewManager } from "../common/ViewManager";
import { FunctionOpenAutoView } from "../funcOpen/FunctionOpenAutoView";
import { FunctionOpenIcon } from "../funcOpen/FunctionOpenIcon";
import { RoleManager } from "./RoleManager";
import { SecretTreasureMainView } from "../rune/SecretTreasureMainView";
import { SceneManager } from "../scene/SceneManager";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventDispatcher } from "../util/EventDispatcher";
import { Util } from "../util/Util";
import { GuildEvent, GuildModel, GuildDefine } from "./GuildModel";
import { SecretTreasureMainViewIndex } from "./LungModel";

export const FunctionOpenEvent = {
	FUNCTIONOPEN_REQUEST_PROTO: "FUNCTIONOPEN_REQUEST_PROTO",
	FUNCTIONOPEN_OPEN_VIEW: "FUNCTIONOPEN_OPEN_VIEW",
	FUNCTIONOPEN_CLOSE_VIEW: "FUNCTIONCLOSE_OPEN_VIEW",
	FUNCTIONOPEN_UPDATE_FUNC_DATA: "FUNCTIONOPEN_UPDATE_FUNC_DATA",
	FUNCTIONOPEN_ICON_FLY: "FUNCTIONOPEN_ICON_FLY",
	FUNCTIONOPEN_CLOSE_ICON_VIEW: "FUNCTIONOPEN_CLOSE_ICON_VIEW",
	FUNCTIONOPEN_GET_REWARD_SUCCESS: "FUNCTIONOPEN_GET_REWARD_SUCCESS",
	FUNCTIONOPEN_START_TEXT_STEP_ARROW: "FUNCTIONOPEN_START_TEXT_STEP_ARROW",
}

//功能开放id
export enum FuncOpenId {
	Guild = 0,							//结社8
	MonBook = 11, 						//图鉴
	//TaoZhuang = 0, 						//套装22
	//FeiQi = 0, 							//伙伴飞骑23
	EquipWash = 15, 					//装备洗炼
	//YuanLi = 0, 						//源力
	HuanLing = 20, 						//蜃妖
	//Genstone = 0, 						//宝石雕刻
	XingZuo = 34 						//星座
}

window["FunctionOpenEvent"] = FunctionOpenEvent;
window["FuncOpenId"] = FuncOpenId;

export class FunctionOpenModel extends EventDispatcher {
	
	static Instance: FunctionOpenModel
	public static GetInstance() {
		if (!FunctionOpenModel.Instance) {
			FunctionOpenModel.Instance = new FunctionOpenModel()
		}
		return FunctionOpenModel.Instance
	}


	finish_fun_data
	real_show_open_list
	need_show_open_fun_data_cache
	need_show_open_fun_icon_cache
	now_step = 1						//当前第几步
	now_be_story_func_data			//当前被引导的功能的数据
	auto_time = 10					//自动下一步时间
	sort_list
	role_mgr:RoleManager = RoleManager.GetInstance()
	scene_mgr:SceneManager = SceneManager.GetInstance()
	auto_next_timer_id
	arrow_listner = {}
	func_open_cfg
	now_show_id = 0					//当前正在展示的功能id
	module_open_list
	public constructor() {
		super()
		 	
	}
	
	InitConfig() {
		this.func_open_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenArrow
	}

	SetFinishFunData(list){
		this.finish_fun_data = list
		let call_func = () => {
			if (this.finish_fun_data) {
				if (!this.module_open_list) {
					this.module_open_list = []
					this.real_show_open_list = []
					let not_open_list = []
					let config_module_open = Config.PRELOAD_SERVER_CONFIG.config_module_open
					for (let key in config_module_open) {
						let vo = config_module_open[key]
						vo.reward_list = JSON.parse(vo.reward)
						this.module_open_list.push(vo)
						if (vo.is_hide == 0) {
							if (this.GetMyFinishFunc(vo.id)) {
								this.real_show_open_list.push(vo)
							} else {
								not_open_list.push(vo)
							}
						}
					}
					let sort_fun = (a, b) => {
						return a.sort_no - b.sort_no
					}
					this.module_open_list.sort(sort_fun)
					this.real_show_open_list.sort(sort_fun)
					not_open_list.sort(sort_fun)
					this.real_show_open_list = this.real_show_open_list.concat(not_open_list)
				}
				if (this.module_open_list) {
					if (!this.need_show_open_fun_data_cache) {
						for (let vo of this.module_open_list) {
							let find = false
							for (let tmp of this.finish_fun_data) {
								if (tmp.id == vo.id && tmp.state == 0) {
									find = true
									if (vo.is_show == 1) {
										if (this.scene_mgr.IsFieldScene() && ViewManager.GetInstance().NoBackGroupViewInShow() && Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
											this.Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenAutoView", vo)
										} else {
											this.need_show_open_fun_data_cache = vo
										}
									} else {
										this.Fire(FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, 13801, "hc", vo.id, 1)
										this.StartFunctionOpenStory(vo.id)
									}
									break
								}
							}
							if (find) {
								break
							}
						}
					}
				}

			}

			let role_lv = this.role_mgr.mainRoleInfo.level
			let now_show_data = this.NeedShowFunctionOpenIcon()
			if (now_show_data && role_lv >= now_show_data.show_lv) {
				if (this.IsShowFunctionScene()) {
					this.Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenIcon", now_show_data)
				}
			} else {
				this.Fire(FunctionOpenEvent.FUNCTIONOPEN_CLOSE_ICON_VIEW)
			}
		}
		call_func()

	}

	//更新领取状态
	UpdateFinishFunState(scmd){
		if (this.finish_fun_data) {
			for (let vo of this.finish_fun_data) {
				if (vo.id == scmd.id) {
					vo.state = scmd.state
				}
			}
			this.SetFinishFunData(this.finish_fun_data)
		}
	}

	//是否要显示功能开放图标
	NeedShowFunctionOpenIcon(){
		let cfg
		let data

		if (this.sort_list == null) {
			this.sort_list = this.real_show_open_list ? this.real_show_open_list.slice() : null
			if (this.sort_list) this.sort_list.sort(this.SortFuncOpen)
		}
		//已完成列表 转格式
		let obj_temp = {}
		if (this.finish_fun_data) {
			for (let p = 0; p < this.finish_fun_data.length; p++) {
				obj_temp[this.finish_fun_data[p].id] = 1
			}
		}
		let role_lv = this.role_mgr.mainRoleInfo.level
		if (this.sort_list) {
			for (let i = 0; i < this.sort_list.length; i++) {
				if (obj_temp[this.sort_list[i].id]) continue //过滤已经完成的任务
				let conds = JSON.parse(this.sort_list[i].condition)
				let is_break = false
				for (let k = 0; k < conds.length; k++) {
					if (conds[k][0] == "lv" && conds[k][1] <= role_lv) {
						is_break = true
						break
					}
				}
				if (is_break) continue
				data = this.sort_list[i]
				break
			}
		}
		return data
	}
	/**排序函数 */
	SortFuncOpen(a, b) {
		if(a.sort_no!=b.sort_no){
			return a.sort_no- b.sort_no
		}
				let trans_format = (cond) => {
					let obj = {
						task: 100000000,
						lv: 0,
						open_day: 0
					}
					for (let i = 0; i < cond.length; i++) {
						if (cond[i][0] == "task") {
							obj.task = cond[i][1]
						} else if (cond[i][0] == "lv") {
							obj.lv = cond[i][1]
						} else if (cond[i][0] == "open_day") {
							obj.open_day = cond[i][1]
						}
					}
					return obj
				}



				//task>lv>open_day
				let a_cond = trans_format(JSON.parse(a.condition))
				let b_cond = trans_format(JSON.parse(b.condition))
				if (a_cond.task != b_cond.task) {
					return a_cond.task - b_cond.task
				}

				if (a_cond.lv != b_cond.lv) {
					return a_cond.lv - b_cond.lv
				}

				if (a_cond.open_day != b_cond.open_day) {
					return a_cond.open_day - b_cond.open_day
				}

				return a.id - b.id
			}

	//获取到两个即将开放的图标
	ShowFuncOpenIcons() {
		let data
		let num = 2
		let icons = []
		if (this.sort_list == null) {
			this.sort_list = this.real_show_open_list ? this.real_show_open_list.slice() : null
			if (this.sort_list) this.sort_list.sort(this.SortFuncOpen)
		}


		//已完成列表 转格式
		let obj_temp = {}
		if (this.finish_fun_data) {
			for (let p = 0; p < this.finish_fun_data.length; p++) {
				obj_temp[this.finish_fun_data[p].id] = 1
			}
		}

		//找一个最大值 高配
		let min_index = this.sort_list.length-1
		let max_data = null
		for (let i = this.sort_list.length-1; i >= 0; i--) {
			if (obj_temp[this.sort_list[i].id]) break //过滤已经完成的任务
			if (this.sort_list[i].id == 99) continue //过滤敬请期待
			if (i < min_index) {
				min_index = i
				max_data = this.sort_list[i]
			}
		}
		//低配
		let role_lv = this.role_mgr.mainRoleInfo.level
		if(this.sort_list){
			for (let i = 0; i < this.sort_list.length; i++) {
				if (obj_temp[this.sort_list[i].id]) continue //过滤已经完成的任务
				let conds= JSON.parse(this.sort_list[i].condition)

				let is_break=false
				for(let k=0;k<conds.length;k++){
					if(conds[k][0]=="lv"&&conds[k][1]<=role_lv){
						is_break=true
						break
					}
				}
				if(is_break)continue
				if (this.sort_list[i].id == 99) continue //过滤敬请期待

				data = this.sort_list[i]
				icons.push(data)
				if(max_data&&max_data.id!=data.id){
					icons.push(max_data)
				}
				if (icons.length >= num) {
				break
				}
			}
		}


		return icons
	}

	GetOpenModuleCfg(id){
		return Config.PRELOAD_SERVER_CONFIG.config_module_open && Config.PRELOAD_SERVER_CONFIG.config_module_open[id]
	}

	GetRealShowModuleCfg(id){
		let cfg
		if (this.real_show_open_list) {
			for (let vo of this.real_show_open_list) {
				if (vo.id == id) {
					cfg = vo
					break
				}
			}
		}
		return cfg
	}

	//功能数据
	GetMyFinishFunc(id){
		let my_data
		if (this.finish_fun_data) {
			for (let vo of this.finish_fun_data) {
				if (vo.id == id) {
					my_data = vo
					break
				}
			}
		}
		return my_data
	}

	//是否有奖励可领取
	HaveRewardCanGet(id?){
		let can_get = false
		let cfg
		if (this.finish_fun_data) {
			for (let vo of this.finish_fun_data) {
				if (vo.state == 0 || vo.state == 1) {
					if ((id && id == vo.id) || !id) {
						cfg = this.GetRealShowModuleCfg(vo.id)
						if (cfg && cfg.reward_list && cfg.reward_list.length > 0) {
							can_get = true
							break
						}
					}
				}
			}
		}
		return can_get
	}

	IsShowFunctionScene(scene_id?){
		return this.scene_mgr.IsDungeonScene(scene_id)
			|| this.scene_mgr.IsBossScene(scene_id)
			|| this.scene_mgr.IsNineSkyFightScene(scene_id)
			|| this.scene_mgr.IsFieldScene(scene_id)
	}

	//是否是当前功能开放引导
	IsInShowingStory(id){
		return this.now_show_id == id
		// return true
	}

	ClearNowStory(id?){
		if (!id || (id && id == this.now_show_id)) {
			this.now_show_id = 0
			this.now_step = 1
		}
	}

	//功能开放的引导
	StartFunctionOpenStory(id){
		if (this.now_show_id != id) {
			this.now_step = 1
		}
		this.now_show_id = id
		if (id == FuncOpenId.Guild) { //结社
			let gmodel = GuildModel.GetInstance()
			if (GuildModel.IsHasGuild()) {
				gmodel.Fire(GuildEvent.OPEN_VIEW, "GuildMainBaseView")
			}
			else {
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (open_day <= GuildDefine.LIST_OPEN_DAY_MAX && open_day >= GuildDefine.LIST_OPEN_DAY_MIN) {
					gmodel.Fire(GuildEvent.OPEN_VIEW, "GuildListView")
				} else {
					gmodel.Fire(GuildEvent.OPEN_VIEW, "GuildJoinBaseView")
				}
			}
		} else if (id == FuncOpenId.MonBook) {//图鉴
			if (this.now_step == 1) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.MonBook)
			} else if (this.now_step == 2) {
				this.ShowMonTip()
			}
			// } else if (id == FuncOpenId.TaoZhuang) {//套装
			// 	if (this.now_step == 1) {
			// 		OpenFun.OpenFunHandler(24)
			// 	}
			// } else if (id == FuncOpenId.FeiQi) {//伙伴飞骑
			// 	if (this.now_step == 1) {
			// 		OpenFun.OpenFunHandler(40)
			// 	}
		} else if (id == FuncOpenId.EquipWash) {//装备洗炼
			if (this.now_step == 1) {
				OpenFun.OpenFunHandler(45)
			} else if (this.now_step == 2) {
				GlobalEventSystem.Fire(FunctionOpenEvent.FUNCTIONOPEN_START_TEXT_STEP_ARROW, id, this.now_step)
			}
			// } else if (id == FuncOpenId.YuanLi) {//源力
			// 	if (this.now_step == 1) {
			// 		// GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.Soul)
			// 	}
		} else if (id == FuncOpenId.HuanLing) {//蜃妖
			if (this.now_step == 1) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SecretTreasureMainView", SecretTreasureMainViewIndex.GodBeast)
			}
		} else if (id == FuncOpenId.XingZuo) {//星座
			if (this.now_step == 1) {
				OpenFun.OpenFunHandler(97)
			}
			// } else if (id == FuncOpenId.Genstone) {//宝石雕刻
			// 	if (this.now_step == 1) {
			// 		OpenFun.OpenFunHandler(11)
			// 	} else if (this.now_step == 2) {
			// 		//自己界面逻辑有打开界面操作

			// 	}
		}
	}

	//显示箭头
	ShowFuncOpenArrow(ref, id, obj: Laya.UIComponent){
		let arrow_cfg = this.func_open_cfg[id]
		if (arrow_cfg) {
			let step_cfg = arrow_cfg.step[this.now_step - 1]
			if (step_cfg) {
				let onTouchBtn = () => {
					if (this.arrow_listner[id]) {
						this.arrow_listner[id] = false
						this.ClearAutoNextTimer()
						GlobalEventSystem.Fire(EventName.HIDE_FINGER, obj)
						++this.now_step
						this.StartFunctionOpenStory(id)
					}
				}
				if (!this.arrow_listner[id]) {
					this.ClearAutoNextTimer()
					this.arrow_listner[id] = true
					obj.on(Laya.Event.CLICK, this, onTouchBtn)
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, ref, obj, undefined, undefined, undefined, undefined, step_cfg, true)
					if (id != FuncOpenId.EquipWash) {
						this.CreateAutoNextTimer(onTouchBtn)
					}
				}
			}
		}
	}

	ClearAutoNextTimer(){
		if (this.auto_next_timer_id) {
			clearTimeout(this.auto_next_timer_id)
			this.auto_next_timer_id = null
		}
		if (this.arrow_listner) {
			for (let key in this.arrow_listner) {
				this.arrow_listner[key] = false
			}
		}
	}

	//自动下一步定时器
	CreateAutoNextTimer(call_back){
		if (!this.auto_next_timer_id) {
			this.auto_next_timer_id = setTimeout(() => {
				call_back()
			}, 10000)
		}
	}

	ShowMonTip(){
		if (this.now_be_story_func_data) {
			// let config = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_lv[this.now_be_story_func_data.id + "@" + 1]
			// if (config) {
			// 	let list = JSON.parse(config.cost)
			// 	if (list && list.length) {
			// 		MaterialsTool.GetInstance().materialsTips(Number(list[0][1]))
			// 	}
			// }
		}
	}
}


window["FunctionOpenModel"] = FunctionOpenModel