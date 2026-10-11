
//require("game.firstBlood.FirstBloodModel")
//require("game.proto.188.Require188")
//require("game.customActivity.CommonActivityView")
//boss首杀
//require("game.firstBlood.FirstBloodMainView")
//require("game.firstBlood.FirstBloodMainViewTwo")
//require("game.firstBlood.FirstBloodItem")

import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { FirstBloodEvent, FirstBloodModel } from "../commonModel/FirstBloodModel"
import  "../firstBlood/FirstBloodMainView"
import  "../firstBlood/FirstBloodRewardView"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

//require("game.firstBlood.FirstBloodRewardView")
export class FirstBloodController extends BaseController {
	InitEvent
	InitInfo

	type
	subtype
	public constructor() {
		super()

		let model = FirstBloodModel.GetInstance()
		let local_FirstBloodModel = FirstBloodModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let view_dic_ = []
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		this.InitEvent = () => {
			let game_start = () => {
				this.SendFmtToGame(18801, "cc", 96, 1)
				// this.SendFmtToGame(18801, "cc", 96, 2)
				// this.SendFmtToGame(18803, "cc", 96, 2)
				this.SendFmtToGame(18801, "cc", 97, 1)
				this.SendFmtToGame(18805, "cc", 105, 1)
			}
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, game_start)
			model.Bind(FirstBloodEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)


			RoleManager.GetInstance().GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, () => {
				let level = RoleManager.GetInstance().GetMainRoleVo().level
				if (level == model.limitLv) {
					this.SendFmtToGame(18801, "cc", 96, 1)
					// this.SendFmtToGame(18801, "cc", 96, 2)
				}
			})


			model.Bind(FirstBloodEvent.OPEN_FIRST_ICON,()=>{
				if(this.type==96 && this.subtype==1){
					let show = model.GetRed(1)
					if (!show || show == 0) {
						model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, false)
					}else{
						model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, true,model.shared_reward_state_list)
					}
				}
			})

			model.Bind(FirstBloodEvent.OPEN_View, (view_name, ...new_args) => {
				let view = view_dic_[view_name]
				if (!view) {
					view_dic_[view_name] = true
					if (view_dic_[view_name] == true) {
						let view_class: any = window[view_name]
						view = new view_class()
						view_dic_[view_name] = view
					}
				}
				if (view && view != true) {
					if (!view.HasOpen()) {
						view.Open(...new_args)
					}
				}
			}
			)
			this.InitInfo()
		}

		this.InitInfo = () => {
			let On18800 = () => {
				let scmd = user_msg_adapter.GetSCMD(18800)
				Util.ErrorCodeShow(scmd.code)
			}
			this.RegisterProtocal(18800, On18800)
			let On18801 = () => {
				let scmd = user_msg_adapter.GetSCMD(18801)
				model.SetKillInfo(scmd)
				if (scmd.type == 96) {
					this.type=96
					this.subtype=scmd.subtype
					model.SetShowFirstBlood(scmd.subtype)
					CustomActivityModel.GetInstance().SetActRedDot(96, scmd.subtype)
					CustomActivityModel.GetInstance().RefreshIconRed(96, scmd.subtype)
					if (scmd.subtype == 2) {
						let show = model.GetRed(2)
						if (!show || show == 0) {
							model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, false)
						}
					}
					model.Fire(FirstBloodEvent.UPDATE_VIEW)
					if (scmd.subtype == 1) {
						let show = model.GetRed(1)
						if (!show || show == 0) {
							model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, false,scmd)
						}else{
							model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, true,scmd)

						}
					}
					//判断删除开服活动图标
					let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					if (open_day <= 7) {
						CustomActivityModel.GetInstance().CheckSpecialIcon("331@3_1")
					} else {
						CustomActivityModel.GetInstance().CheckSpecialIcon("331@3")
					}
					//查询Boss首杀全服归属奖励状态
					for(let key in scmd.first_blood_list){
						let info=scmd.first_blood_list[key]
						this.SendFmtToGame(18806, "cci",scmd.type,scmd.subtype,info.boss_id);
					}
				} else if (scmd.type == 97 && scmd.subtype == 1) {
					DungeonPartnerModel.GetInstance().CheckFirstKillRedPoint(scmd)
				}
			}
			this.RegisterProtocal(18801, On18801)
			let On18802 = () => {
				let scmd = user_msg_adapter.GetSCMD(18802)
				if (scmd.code == 1) {
					if (scmd.type == 96) {
						this.SendFmtToGame(18801, "cc", 96, scmd.subtype)
						let reward_list=scmd.reward_list
						let rewards=[]
						for (let key in reward_list) {
							if (reward_list[key]) {
								// [ts2lua]reward下标访问可能不正确
								let info = reward_list[key]
								table.insert(rewards, { "0": info.style, "1": info.typeId, "2": info.count })
							}
						}
						let cov = new CongratulationObtainView(rewards,10)
						cov.Open()
					} else if (scmd.type == 97 && scmd.subtype == 1) {
						this.SendFmtToGame(18801, "cc", 97, 1)
						Util.ShowCongratulationView(scmd.reward_list)
					} else if (scmd.type == 105 && scmd.subtype == 1) {
						for (let i in model.rune_first_blood_red) {
							var red = model.rune_first_blood_red[i]
							if (red.dun_id == scmd.boss_id) {
								red.show_point = 2
								break
							}
						}

						let fdata = model.GetRuneFirstData(scmd.type, scmd.subtype, scmd.boss_id)
						if (fdata) {
							fdata.reward_state = 1
							model.Fire(FirstBloodEvent.UPDATE_RUNE_DATA, scmd.type, scmd.subtype, scmd.boss_id)
						}
						Util.ShowCongratulationView(scmd.reward_list)
						BaseDungeonModel.GetInstance().RefreshRuneRed()
						model.Fire(FirstBloodEvent.UPDATE_RUNE_RED)
					}
					model.Fire(FirstBloodEvent.GET_FIRST_KILL_REWARD, scmd)
				}
				else{
					Util.ErrorCodeShow(scmd.code)
				}
			}
			this.RegisterProtocal(18802, On18802)

			let On18803 = () => {
				let scmd = user_msg_adapter.GetSCMD(18803)
				let level = RoleManager.GetInstance().GetMainRoleVo().level
				if (level >= model.limitLv) {
					model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, true, scmd)
				}
			}
			this.RegisterProtocal(18803, On18803)

			let On18804 = () => {
				let scmd = user_msg_adapter.GetSCMD(18804)
				model.SetRuneFirstData(scmd)
			}
			this.RegisterProtocal(18804, On18804)


			let On18805 = () => {
				let scmd = user_msg_adapter.GetSCMD(18805)
				model.rune_first_blood_red = scmd.red_point_list
				BaseDungeonModel.GetInstance().RefreshRuneRed()
				model.Fire(FirstBloodEvent.UPDATE_RUNE_RED)
				CustomActivityModel.GetInstance().RefreshIconRed(96, scmd.subtype)
			}
			this.RegisterProtocal(18805, On18805)

			let On18806 = () => {
				let scmd = user_msg_adapter.GetSCMD(18806)
				model.setSharedRewardStateList(scmd)
				CustomActivityModel.GetInstance().SetActRedDot(scmd.type, scmd.subtype)
				CustomActivityModel.GetInstance().RefreshIconRed(96, scmd.subtype)
				FirstBloodModel.GetInstance().Fire(FirstBloodEvent.UPDATE_KILL_RED)
				if (scmd.subtype == 1) {
					let show = model.GetRed(1)
					if (!show || show == 0) {
						model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, false,scmd)
					}else{
						model.Fire(FirstBloodEvent.ADD_FIRST_BLOOD_ICON, true,scmd)

					}
				}
			}
			this.RegisterProtocal(18806, On18806)

			let On18807 = () => {
				let scmd = user_msg_adapter.GetSCMD(18807)
				let reward_list=scmd.reward_list
				let rewards=[]
				FirstBloodModel.GetInstance().Fire(FirstBloodEvent.UPDATE_KILL_RED)
				CustomActivityModel.GetInstance().SetActRedDot(scmd.type, scmd.subtype)
				CustomActivityModel.GetInstance().RefreshIconRed(96, scmd.subtype)
				for (let key in reward_list) {
					if (reward_list[key]) {
						// [ts2lua]reward下标访问可能不正确
						let info = reward_list[key]
						table.insert(rewards, { "0": info.style, "1": info.typeId, "2": info.count })
					}
				}
				if(reward_list.length>0){
					let cov = new CongratulationObtainView(rewards,10)
					cov.Open()
				}
			}
			this.RegisterProtocal(18807, On18807)
		}

		this.InitEvent()
	}

}


window["FirstBloodController"] = FirstBloodController