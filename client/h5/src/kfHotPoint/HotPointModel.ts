import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"

export class HotPointModel extends EventDispatcher {
	GetActData
	GetActInfo
	GetActInfoByShowId
	GetActReward
	GetOpenSatuts
	GetRedByShowId
	RefRed
	SetActData
	SetActInfo
	SetActReward
	SetResult
	UpdataActData
	public static Instance
	public static REQUEST_SCMD = "HotPointModel.REQUEST_SCMD"
	public hide_red_dic

	public constructor() {
		super()
		this.hide_red_dic=[]
		if (HotPointModel.Instance) {
			return
		}
		HotPointModel.Instance = this

		let data_list = []
		let info_list = null
		let reward_list = []
		let red_list = []

		let custom_activity_model = CustomActivityModel.GetInstance()

		let getShowId = (base_type?, sub_type?) => {
			if (!info_list || info_list.length == 0) {
				return null
			}
			for (let _tmpi in info_list) {
				var v = info_list[_tmpi]
				if (v.base_type == base_type && v.sub_type == sub_type) {
					return v.show_id
				}
			}
		}

		this.SetActInfo = (scmd?) => {
			info_list = scmd.list
			custom_activity_model.AddActInfo({})
		}

		this.GetActInfo = (base_type?, show_id?) => {
			base_type = Number(base_type)
			show_id = Number(show_id)
			if (!info_list || info_list.length == 0) {
				return null
			}
			for (let _tmpi in info_list) {
				var v = info_list[_tmpi]
				if (v.base_type == base_type && v.show_id == show_id) {
					return v
				}
			}
			return null
		}

		this.SetActData = (scmd?) => {
			let b = scmd.base_type
			let s = scmd.sub_type
			data_list[b] = data_list[b] || {}
			data_list[b][s] = scmd
		}

		this.GetActData = (base_type?, sub_type?) => {
			return data_list[base_type] && data_list[base_type][sub_type]
		}

		this.SetActReward = (scmd?) => {
			let b = scmd.base_type
			let s = scmd.sub_type
			reward_list[b] = reward_list[b] || {}
			reward_list[b][s] = scmd
			this.RefRed(b, s)
			custom_activity_model.RefreshIconRed(b, getShowId(b, s))
		}

		this.GetActReward = (base_type?, sub_type?, grade?) => {
			let reward = reward_list[base_type] && reward_list[base_type][sub_type]
			if (!reward) {
				return null
			}
			if (grade == null) {
				return reward
			} else {
				for (let _tmpi in reward) {
					var v = reward[_tmpi]
					if (v.grade == grade) {
						return v
					}
				}
			}
		}

		this.RefRed = (base_type?, sub_type?) => {
			let reward = this.GetActReward(base_type, sub_type)
			let is_finish = true
			if (reward) {
				let value = 0
				let reward_list = reward.reward_list
				if (!reward_list || reward_list.length == 0) {
					return
				}
				for (let _tmpi in reward_list) {
					var v = reward_list[_tmpi]
					if(v.status != 2 && is_finish){
						is_finish = false
					}
					if (v.status == 1) {
						value = value + 1
					}
				}
				if(CustomActivityModel.GetInstance().CheckFirstRed(base_type,sub_type) && !(this.hide_red_dic[`${base_type}@${sub_type}`])){
					value=value+1
				}
				red_list[base_type] = red_list[base_type] || {}
				red_list[base_type][sub_type] = is_finish ? 0 : value
			}
		}

		this.GetActInfoByShowId = (base_type?, show_id?) => {
			base_type = Number(base_type)
			show_id = Number(show_id)
			if (!info_list || info_list.length == 0) {
				return null
			}
			for (let _tmpi in info_list) {
				var v = info_list[_tmpi]
				if (v.base_type == base_type && v.show_id == show_id) {
					return v
				}
			}
			return null
		}

		this.GetOpenSatuts = (base_type?, show_id?) => {
			let w_com = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.windowscomponent
			let lv = RoleManager.GetInstance().mainRoleInfo.level
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if (info_list && info_list.length > 0 && w_com) {
				for (let v in w_com) {

					let w = w_com[v][base_type + "@" + show_id]
					if (w && (!w.open_lv || lv >= w.open_lv)
						&& (!w.open_day || open_day >= w.open_day)) {
						for (let _tmpi in info_list) {
							var info = info_list[_tmpi]
							if (info.base_type == Number(base_type) && info.show_id == Number(show_id)) {
								return true
							}
						}
					}
				}
			}
			return false
		}

		this.GetRedByShowId = (base_type?, show_id?) => {
			base_type = Number(base_type)
			show_id = Number(show_id)
			if (!info_list || info_list.length == 0) {
				return null
			}
			for (let _tmpi in info_list) {
				var v = info_list[_tmpi]
				if (v.base_type == base_type && v.show_id == show_id) {
					return red_list[base_type] && red_list[base_type][v.sub_type]
				}
			}
			return 0
		}

		this.SetResult = (scmd?) => {
			if (!scmd) {
				return
			}
			let b = scmd.base_type
			let s = scmd.sub_type
			let reward = reward_list[b] && reward_list[b][s]
			if (reward) {
				let list = reward.reward_list
				let grade_info = null
				for (let _tmpi in list) {
					var v = list[_tmpi]
					if (v.grade == scmd.grade) {
						v.status = 2
						if (red_list && red_list[b] && red_list[b][s]) {
							red_list[b][s] = red_list[b][s] - 1
						}
						custom_activity_model.RefreshIconRed(b, getShowId(b, s))
						custom_activity_model.Fire(CustomActivityDefine.EVENT.ANSWER_TARGET, scmd.base_type, scmd.sub_type, 33303)
						if (v.reward) {
							let view = new CongratulationObtainView(v.reward, 10)
							view.Open()
						}
						break
					}
				}
			}
		}

		this.UpdataActData = (scmd?) => {
			if (!scmd) {
				return
			}
			let b = scmd.base_type
			let s = scmd.sub_type
			let data = this.GetActData(b, s)
			if (!data) {
				return
			}
			let mod_list = data.mod_list
			data.sum_points = scmd.sum_points
			for (let _tmpi in mod_list) {
				var v = mod_list[_tmpi]
				for (let _tmpj in scmd.mod_list) {
					var v0 = scmd.mod_list[_tmpj]
					if (v.mod_id == v0.mod_id
						&& v.sub_id == v0.sub_id
						&& v.condition_type == v0.condition_type
						&& v.dec == v0.name) {
						v.pro_value = v0.pro_value
						v.is_com = v0.is_com
					}
				}
			}
		}


	}

	public static GetInstance() {

		if (!HotPointModel.Instance) {
			HotPointModel.Instance = new HotPointModel()
		}
		return HotPointModel.Instance
	}
}
window["HotPointModel"]=HotPointModel
