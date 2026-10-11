import { CommonManager } from "../common/CommonManager"
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { ResManager } from "../common/ResManager";
import { ServerTimeModel } from "../serverTime/ServerTimeModel";
import { ErlangParser } from "../util/ErlangParser";
import { EventDispatcher } from "../util/EventDispatcher"
import { TimeUtil } from "../util/TimeUtil";
import { Config } from "../common/Config"
import { TaskModel } from "./TaskModel";
import { RoleManager } from "./RoleManager";
import { table } from "../common/table";
import { Util } from "../util/Util";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { CookieWrapper } from "../common/CookieWrapper";
import { MainUIModel } from "./MainUIModel";
import { Message } from "../sysInfo/SysInfoController";
import { PlatformManager } from "../PlatformManager";

export interface IHaloData {
	end_time: number;
	rewards: { id: number, state: number }[];
}

export enum HaloPrivilegeType {
	/**主角光环称号 */
	HaloDsgt = 1,
	/**掉落拾取速度提升 */
	DropPickUpSpeed = 2,
	/**开放竞技场一键扫荡 */
	ArenaSweep = 3,
	/**璀璨之海免费升级次数+1 */
	BrightSeaFreeLevelUpTimes = 4,
	/**副本合并挑战 */
	DungeonSweep = 5,
	/**开启蜃妖装备一键合成 */
	GodBeastComposite = 6,
	/**怨灵封印pvp伤害减免+10% */
	BossDomainPvp = 7,
	/**遗迹探宝免费重置1次 */
	AdventureFreeTimes = 8,
	/**极地试炼中伤害提升+20% */
	DungeonPolarDamagerUp = 9,
}

export class HaloModel extends EventDispatcher {
	static REQUEST_SCMD = 'HaloModel.REQUEST_SCMD'
	static UPDATE_ITEM = 'HaloModel.UPDATE_ITEM'
	static UPDATE_TIME = 'HaloModel.UPDATE_TIME'
	/**特权设置 */
	static RecvFmt51302 = 'HaloModel.RecvFmt51302'

	static ModuleId = 513

	static RedFlag = {

	}

	halo_data: IHaloData
	setting_data_dic
	reward_open_list
	reward_not_open_list
	new_reward_state_list
	is_new_reward
	local_GlobalEventSystem
	local_EventName
	config
	local_cookie_manager

	static Instance: HaloModel
	public static GetInstance() {
		if (!HaloModel.Instance) {
			HaloModel.Instance = new HaloModel()
		}
		return HaloModel.Instance
	}

	public constructor() {
		super()
		this.local_GlobalEventSystem = GlobalEventSystem
		this.local_EventName = EventName
		this.config = Util.DeepCopy(Config.PRELOAD_SERVER_CONFIG.config_hero_halo)
		this.local_cookie_manager = CookieWrapper.GetInstance()
		if (HaloModel.Instance) {
			return
		}
	}

	public ResetData() {
		if (this.halo_data) {
			this.halo_data.end_time = 0
			this.halo_data.rewards.length = 0
		}

		this.setting_data_dic = null
		this.reward_open_list = null
		this.new_reward_state_list = null
		this.is_new_reward = false
		
	}

	public GetOpenState() {
		return CommonManager.GetInstance().CheckFuncOpenState("HaloMainView", true) && !PlatformManager.GetInstance().is_wx_alpha
		// return true
	}

	public SetHaloData(scmd: ProtoRecvVObj<51400>) {
		if (this.halo_data) {
			this.halo_data.end_time = scmd.end_time
			this.halo_data.rewards = scmd.rewards
		}
		else {
			this.halo_data = scmd
		}
		this.Fire(HaloModel.UPDATE_ITEM)
		this.Fire(HaloModel.UPDATE_TIME)
	}

	
	/**
	 * 初始化奖励解锁的状态数据
	 */
	public SetOpenRewardCanGetState (){
		let bool
		this.reward_open_list = []
		this.reward_not_open_list = []
		// let config = Util.DeepCopy(Config.PRELOAD_SERVER_CONFIG.config_hero_halo)
		for (let key in this.config) {
			let data = this.config[key]
			bool = this.RewardOpenState(data)
			//只有满足开启条件，存入open_reward_dic
			if(bool){
				table.insert(this.reward_open_list, data)
				let func_sort = (a, b)=> {
					return a.weight > b.weight
				}
				table.sort(this.reward_open_list, func_sort)
			}else{
				table.insert(this.reward_not_open_list, data)
				let func_sort = (a, b)=> {
					return a.weight > b.weight
				}
				table.sort(this.reward_not_open_list, func_sort)
			}
		}
	}

	public SetHaloIconRed(){
		let cookie_red_state = this.local_cookie_manager.GetCookie(CookieWrapper.HALO_RED_OPEN_STATE)
		if(cookie_red_state && cookie_red_state == "1"){
			return
		}
		if(this.halo_data){
			let time = this.halo_data.end_time
			let halo_red_state = false
			if(time > 0){
				if(this.halo_data.rewards.length <= 0){
					halo_red_state = true
				}else{
					let reward_dic = {}
					for (let _key in this.halo_data.rewards) {
						let vo = this.halo_data.rewards[_key]
						reward_dic[vo.id] = vo
					}

					for (let key in this.config) {
						let vo = this.config[key]
						let bool = this.RewardOpenState(vo)
						if(bool){
							if(!reward_dic[vo.id]){
								halo_red_state = true
								break
							}
						}
					}
				}
			}
			MainUIModel.GetInstance().hale_red_show = halo_red_state
			this.local_GlobalEventSystem.Fire(this.local_EventName.UPDATE_TOP_HALO_ICON_RED_STATE, halo_red_state)
		}
	}


	/**
	 * 添加新的解锁奖励
	 */
	 public AddNewReward (){
		this.new_reward_state_list = []
		for (let key in this.config) {
			let vo = this.config[key]
			//已经存在于初始的奖励开启列表中，不处理
			if(!this.reward_open_list[Number(key) - 1]){
				if(this.RewardOpenState(vo)){
					//存入新增的奖励列表中
					this.is_new_reward = true
					vo.flag = true
					table.insert(this.new_reward_state_list, vo)
					//删除对应未激活奖励列表中的奖励数据
					this.DeleteArryElement(this.reward_not_open_list, vo.id)
				}else{
					vo.flag = false
				}
			}else{
				vo.flag = false
			}
		}
		if(this.new_reward_state_list && this.new_reward_state_list.length > 1){
			//新添加的奖励更具权重从大到小排序
			let func_sort = (a, b)=> {
				return a.weight > b.weight
			}
			table.sort(this.new_reward_state_list, func_sort)
		}
		this.SetHaloIconRed()
	}

	public DeleteArryElement(list?, id?) {
		let index = 0
		for (let key in list) {
			let vo = list[key]
			let idx = Number(key)
			if(vo.id == id){
				index = idx
				table.remove(list, index)
				break
			}
		}
	}

	/**
	 * 整合数据
	 */
	public ConsolidateData (){
		let list = []
		list = list.concat(this.new_reward_state_list)
		list = list.concat(this.reward_open_list)
		list = list.concat(this.reward_not_open_list)
		return list
	}

	/**
	 * 判断条件，是否满足奖励领取，满足为true，不满足为false
	 * @param data 
	 * @returns 
	 */
	public RewardOpenState (data?) {
        let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
		let bool 
		let condition = ErlangParser.GetInstance().Parse(data.condition)
		let cond_lv = Number(condition[0][1])
		let cond_str = condition[0][0]
		if(cond_str == "lv"){
			if(role_lv >= cond_lv){
				bool = true 
			}else {
				bool = false 
			}
		}else if(cond_str == "task"){
			let finish = TaskModel.GetInstance().IsAllStepFinish(cond_lv)
			if(finish){
				bool = true 
			}else{
				bool = true 
			}
		}
		return bool
	}

	public ShowHaloReward(_id?, _state?){
		if(!this.halo_data){
			return
		}
		let list = {id: _id, state: _state}
		let rewards_list = this.halo_data.rewards
		if(rewards_list.length <= 0){
			table.insert(this.halo_data.rewards, list)
		}else{
			for (let idx in rewards_list) {
				let data = rewards_list[idx]
				if(_id != data.id){
					table.insert(this.halo_data.rewards, list)
					break
				}else{
					data.state = _state
				}
			}
		}
		let config = Config.PRELOAD_SERVER_CONFIG.config_hero_halo
		let reward_dic = ErlangParser.GetInstance().Parse(config[_id].reward)
		let view = new CongratulationObtainView(reward_dic , 10)
		view.Open()
		this.Fire(HaloModel.UPDATE_ITEM)
		this.SetHaloIconRed()
	}

	public GetHaloData() {
		return this.halo_data
	}

	public GetHaloOpenState() {
		if(this.GetOpenState() && this.halo_data){
			return this.halo_data.end_time > TimeUtil.getServerTime()
		}
		return false

		// return true
	}

	public SetSettingData(scmd: ProtoRecvVObj<51402>) {
		if (this.setting_data_dic == null) {
			this.setting_data_dic = {}
		}
		if (this.setting_data_dic[scmd.id] == null) {
			this.setting_data_dic[scmd.id] = {}
		}
		this.setting_data_dic[scmd.id][scmd.type] = scmd.state
	}

	public GetSettingData(id, type) {
		return this.setting_data_dic && this.setting_data_dic[id] && this.setting_data_dic[id][type]
	}
	public DayChange (){
		if(this.GetOpenState()){
			this.Fire(HaloModel.REQUEST_SCMD, 51400)
		}
	}

	/**
	 * 判断条件，是否满足奖励领取，满足为true，不满足为false
	 * @param data 
	 * @returns 
	 */
	 public CheckPrivilegeOpenState(privilege_id, not_alert?: boolean) {
		if(!Config.PRELOAD_SERVER_CONFIG.config_hero_halo) return 
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_hero_halo[privilege_id]
		if(!cfg) return
		
        let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
		let condition = ErlangParser.GetInstance().Parse(cfg.condition)
		
		let alert_str = "", bool = true, v
		for(let k in condition){
			v = condition[k]
			if(v[0] == "lv"){
				if(role_lv < v[1]){
					bool = false
					alert_str += `角色到达【${v[1]}】级`
				}
			}else if(v[0] == "task"){
				if(TaskModel.GetInstance().newest_finish_task_id < v[1]){
					bool = false
					alert_str += `完成主线任务【${v[1]}】`
				}
			}
		}

		if(!bool && !not_alert){
			alert_str += "开启"
			Message.show(alert_str)
		}

		return bool
	}
}
window["HaloModel"] = HaloModel