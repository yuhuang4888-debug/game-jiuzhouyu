import { EventDispatcher } from "../util/EventDispatcher"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Split } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
export enum Enum_SevenDay {
	SevenDay = 0,
	EightDay = 1,
	merge_SevenDay = 0
}
window["Enum_SevenDay"] = Enum_SevenDay
export class SevenDayModel extends EventDispatcher {
	GetInfoByOpenType
	GetOpenType
	GetRewardList
	GetSevenDayRed
	InitRed
	RefCurDayInfo
	RefIconRed
	SetRed
	SetSevenDayInfo
	UpdateRawardStatus
	limit_day
	public static REF_SEVENDAY_ICON = "REF_SEVENDAY_ICON";
	public static OPEN_SEVENDAY_VIEW = "OPEN_SEVENDAY_VIEW";
	public static CLOSE_SEVENDAY_VIEW = "CLOSE_SEVENDAY_VIEW";
	public static SELECT_DAY = "SELECT_DAY";
	public static UPDATE_VIEW = "UPDATE_VIEW";
	public static REQUEST_SCMD = "REQUEST_SCMD"
	public static act_type = { open: 0, merge: 1 };
	public static icon = { ["0@0"]: "175", ["0@1"]: "175@8", ["1@0"]: "175_1" };
	public static typeToView = { ["0@0"]: "SevenDayView", ["0@1"]: "SevenEightDayView", ["1@0"]: "SevenMergeView" };
	public static iconToType = { ["175"]: "0@0", ["175@8"]: "0@1", ["175_1"]: "1@0" };
	static Instance: any
	public constructor() {
		super()

		if (SevenDayModel.Instance) {
			return
		}
		this.limit_day = 8;
		let local_Math = Math
		let local_Number = Number
		let cfg_rewards_list_ = null
		let seven_day_info_ = null
		let red_dic_ = []
		let open_type_ = []
		let reward_info_lsit_ = []
		this.SetSevenDayInfo = (scmd?) => {
			seven_day_info_ = seven_day_info_ || {}
			seven_day_info_[scmd.type] = []
			seven_day_info_[scmd.type].current_day = scmd.current_day
			if (scmd && scmd.merge_wlv) {
				seven_day_info_[scmd.type].merge_wlv = scmd.merge_wlv
			}
			let seven_rewards = []
			let eight_reward = []
			reward_info_lsit_[scmd.type] = []
			for (let _tmpi in scmd.reward_status) {
				var v = scmd.reward_status[_tmpi]
				let day_type = local_Math.floor(v.day_id / this.limit_day)
				if (!reward_info_lsit_[scmd.type][day_type]) {
					reward_info_lsit_[scmd.type][day_type] = []
				}
				table.insert(reward_info_lsit_[scmd.type][day_type], v)
			}
			this.RefCurDayInfo(scmd.type)
			this.InitRed(scmd.type)
		}

		this.InitRed = (type?) => {
			if (!reward_info_lsit_) {
				return
			}
			let list = reward_info_lsit_[type]
			for (let i in list) {

				let red = 0
				for (let j in list[i]) {

					let v = list[i][j]
					if (v.status == 1) {
						red = red + 1
					}
				}
				red_dic_[type] = red_dic_[type] || {}
				red_dic_[type][i] = red
			}
		}

		this.SetRed = (act_type?, day_type?, value?) => {
			if (red_dic_[act_type] && red_dic_[act_type][day_type] != null) {
				red_dic_[act_type][day_type] = red_dic_[act_type][day_type] + value
			}
		}

		this.RefCurDayInfo = (type?) => {
			if (!reward_info_lsit_) {
				return
			}
			let list = reward_info_lsit_[type]
			for (let i in list) {

				for (let j in list[i]) {

					let v = list[i][j]
					if (v.status < 2) {
						open_type_[type] = type + "@" + i
						return
					}
				}
			}
			open_type_[type] = null
		}

		this.GetOpenType = (type?) => {
			if (type != null) {
				return open_type_[Number(type)]
			}
			return open_type_
		}

		this.GetInfoByOpenType = (act_type?, day_type?) => {
			act_type = Number(act_type)
			day_type = Number(day_type)
			let list = reward_info_lsit_
			if ((list && list[act_type]) && list[act_type][day_type]) {
				seven_day_info_[act_type].reward_status = list[act_type][day_type]
				return seven_day_info_[act_type]
			}
		}

		this.GetRewardList = (scmd?) => {
			let award_data = []
			for (let _tmpi in scmd.reward_list) {
				var award = scmd.reward_list[_tmpi]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(award.good_type, award.good_id)
				let data = []
				data.push(award.good_type)
				//table.insert(data, award.good_type)
				table.insert(data, type_id)
				table.insert(data, award.good_num)
				if (award.good_auto_id) {
					table.insert(data, award.good_auto_id)
				}
				table.insert(award_data, data)
			}
			let view = new CongratulationObtainView(award_data, 6)
			view.Open()
		}

		this.UpdateRawardStatus = (day_id?, act_type?) => {
			let day_type = local_Math.floor(day_id / this.limit_day)
			let list = reward_info_lsit_
			let index = 0
			// [ts2lua]list下标访问可能不正确
			// [ts2lua]list下标访问可能不正确
			// [ts2lua]list[act_type]下标访问可能不正确
			if ((list && list[act_type]) && list[act_type][day_type]) {
				// [ts2lua]list下标访问可能不正确
				// [ts2lua]list[act_type]下标访问可能不正确
				for (let _tmpi in list[act_type][day_type]) {
					var v = list[act_type][day_type][_tmpi]
					if (v.status == 2) {
						index = index + 1
					}
					if (v.day_id == day_id) {
						v.status = 2
						index = index + 1
					}
				}
				this.InitRed(act_type)
				if (index == this.limit_day - 1) {
					this.RefCurDayInfo(act_type)
					this.Fire(SevenDayModel.REF_SEVENDAY_ICON)
				}
			}
		}

		this.GetSevenDayRed = (type?) => {
			if (type != null) {
				let arr = Split(type, "@") //type:split("@")
				let act_type = local_Number(arr[0])
				let day_type = local_Number(arr[1])

				if ((red_dic_ && red_dic_[act_type]) && red_dic_[act_type][day_type]) {

					return red_dic_[act_type][day_type] > 0
				}
			}
			return false
		}

		this.RefIconRed = (act_type?) => {
			let _type = this.GetOpenType(act_type)
			if (typeof (_type) == "string") {
				let icon_type = SevenDayModel.icon[_type]
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, icon_type, this.GetSevenDayRed(_type))
			}
		}


	}

	public static GetInstance() {

		if (!SevenDayModel.Instance) {
			SevenDayModel.Instance = new SevenDayModel()
		}
		return SevenDayModel.Instance
	}
}

window["SevenDayModel"] = SevenDayModel