import { Config } from "../common/Config"
import { table } from "../common/table"
import { EventDispatcher } from "../util/EventDispatcher"
import { RoleManager } from "./RoleManager"


export var FirstBloodEvent = {
	REQUEST_PROTO : "FirstBloodEvent.REQUEST_PROTO",
	OPEN_View : "FirstBloodEvent.OPEN_View",
	UPDATE_VIEW : "FirstBloodEvent.UPDATE_VIEW",
	UPDATE_RUNE_DATA : "FirstBloodEvent.UPDATE_RUNE_DATA",
	UPDATE_RUNE_RED : "FirstBloodEvent.UPDATE_RUNE_RED",
	ADD_FIRST_BLOOD_ICON : "FirstBloodEvent.ADD_FIRST_BLOOD_ICON",
	GET_FIRST_KILL_REWARD : "FirstBloodEvent.GET_FIRST_KILL_REWARD",
	UPDATE_KILL_RED :"FirstBloodEvent.UPDATE_KILL_RED",
	OPEN_FIRST_ICON:"FirstBloodEvent.OPEN_FIRST_ICON"
}
window["FirstBloodEvent"] = FirstBloodEvent
export class FirstBloodModel extends EventDispatcher {
	first_open
	kill_info
	rune_first_blood
	rune_first_blood_red
	show_first_blood
	shared_reward_state_list

	view_mon_list
	limitLv:number = 130

	public static Instance
	public constructor(){
	super() 
		
		this.kill_info = []
		this.show_first_blood = []
		this.rune_first_blood = []
		this.rune_first_blood_red = []
		this.shared_reward_state_list=[]
		this.first_open = 1
	}
	public SetKillInfo(info?){ 
		
		// this.kill_info = info
		this.kill_info[info.type] = this.kill_info[info.type] || {}
		this.kill_info[info.type][info.subtype] = info
	}
	public GetKillInfo(type?, subtype?){ 
		
		return this.kill_info && this.kill_info[type] && this.kill_info[type][subtype]
	}
	public GetRed(subtype?){ 
		let red1=0
		let red2=0
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		if (level >= this.limitLv) {
			let info = this.kill_info && this.kill_info[96] && this.kill_info[96][subtype]
			if (info && info.first_blood_list && info.first_blood_list.length > 0 ) {
				for (let _ in info.first_blood_list) {
					var v = info.first_blood_list[_]
					if (v.reward_state == 0 ) {
						red1=1
					}
				}
			}

			let shared_reward_state_list = FirstBloodModel.GetInstance().shared_reward_state_list
			let info1 = null
			if (shared_reward_state_list) {
				for (let k in shared_reward_state_list) {
					var v = shared_reward_state_list[k]
					if(v.shared_status==0){
						red2=1
					}
				}
			}
		}

		if(red1==1 || red2==1){
			return 1
		}else{
			return 0
		}
	}
	public ReceiveAll(subtype){ 
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_first_blood_plus_boss
		if(!cfg) return 
		subtype = Number(subtype)
		let boss_num = 0
		let receive_all = false
		for (let _ in cfg) {
			var v = cfg[_]
			if (v.type == 96 && v.sub_type == subtype ) {
				boss_num = boss_num + 1
			}
		}
		let info = this.kill_info && this.kill_info[96] && this.kill_info[96][subtype] && this.kill_info[96][subtype].first_blood_list
		if (info && info.length > 0 && info.length == boss_num ) {
			for (let _ in info) {
				var v = info[_]
				if (v.reward_state != 1 ) {
					return receive_all
				}
			}
			receive_all = true
		}
		return receive_all
	}


	public SetShowFirstBlood(subtype?){ 
		
		let info = this.kill_info && this.kill_info[96] && this.kill_info[96][subtype]
		if (info ) {
			let first_blood_list = info.first_blood_list
			if (first_blood_list && first_blood_list.length > 0 ) {
				for (let _ in first_blood_list) {
					var v = first_blood_list[_]
					this.show_first_blood[v.boss_id] = []
					//this.show_first_blood[v.boss_id].merge = v.is_merge
					this.show_first_blood[v.boss_id].name = v.first_blood_role_name
				}
			}
		}
	}

	public GetShowFirstBlood(boss_id?){ 
		
		return this.show_first_blood[boss_id]
	}

	public SetRuneFirstData(data?){ 
		
		this.rune_first_blood[data.type + "@" + data.subtype + "@" + data.dun_id] = data
		this.Fire(FirstBloodEvent.UPDATE_RUNE_DATA,data.type,data.subtype,data.dun_id)
	}

	public GetRuneFirstData(type?,subtype?,dun_id?){ 
		
		let data = this.rune_first_blood[type + "@" + subtype + "@" + dun_id]
		return data
	}

	public RuneFirstRed(){ 
		
		for (let i in this.rune_first_blood_red) {
			var data = this.rune_first_blood_red[i]
			if (data.show_point == 1 ) {
				return true
			}
		}
		return false
	}

	public GetRuneFirstRed(dun_id?){ 
		
		let flag = false
		for (let i in this.rune_first_blood_red) {
			var data = this.rune_first_blood_red[i]
			if (data.dun_id == dun_id && data.show_point == 1 ) {
				flag = true
				break
			}
		}
		return flag
	}

	public GetRuneFirstHave(dun_id?){ 
		
		let flag = false
		for (let i in this.rune_first_blood_red) {
			var data = this.rune_first_blood_red[i]
			if (data.dun_id == dun_id  && data.show_point == 2 ) {
				flag = true
				break
			}
		}
		return flag
	}

	public static GetInstance(){ 
		
		if (! FirstBloodModel.Instance ) {
			FirstBloodModel.Instance =  new FirstBloodModel()
		}
		return FirstBloodModel.Instance
	}

	public setSharedRewardStateList(info){
		let have_info=false
		for(let key in this.shared_reward_state_list){
			let v2=this.shared_reward_state_list[key]
			if(v2.boss_id==info.boss_id){
				this.shared_reward_state_list[key].shared_status=info.shared_status
				have_info=true
			}
		}
		if(!have_info){
			table.insert(this.shared_reward_state_list,info);
		}
	}
}

window["FirstBloodModel"] = FirstBloodModel