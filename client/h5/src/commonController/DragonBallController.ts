import { BaseController } from "../common/BaseController"
import { PlayBigEffect, Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { DragonBallModel, IDragonSuitInfo } from "../commonModel/DragonBallModel"

import "../dragonBall/DragonBallView"
import "../dragonBall/DragonBallAttrView"
import "../dragonBall/DragonBallTipsView"

import "../dragonBallGift/DragonBallGiftView"

import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "../commonModel/RoleManager"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Config } from "../common/Config"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { table } from "../common/table"

export class DragonBallController extends BaseController {
	model: DragonBallModel
	user_msg_adapter: UserMsgAdapter
	goods_model: GoodsModel
	is_first_request_14310
	role_mgr: RoleManager
	local_EventName

	public constructor() {
		super()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.model = DragonBallModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.local_EventName = EventName

		this.RegisterAll()
		this.InitEvent()
	}


	public InitEvent() {
		this.Bind(EventName.GAME_START, () => {
			GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DragonBallView")
			RedDotController.ins.up(RedKey.DRAGON_BALL, false);
			this.model.ResetData()
			this.SendFmtToGame(14310)
			this.SendFmtToGame(14303)
			this.SendFmtToGame(14311)
			this.is_first_request_14310 = true
		})

		this.model.Bind(DragonBallModel.REQUEST_SCMD, (...new_args) => {
			let arg = new_args
			if (arg[0] == 14300) {
				this.SendFmtToGame(14300)
			} else if (arg[0] == 14301) {
				this.SendFmtToGame(14301, "i", arg[1])
			} else if (arg[0] == 14302) {
				this.SendFmtToGame(14302, "i", arg[1])
			} else if (arg[0] == 14305) {
				this.SendFmtToGame(14305, "cc", arg[1], arg[2])
			} else if (arg[0] == 14304) {
				this.SendFmtToGame(14304, "cc", arg[1], arg[2])
			} else {
				this.SendFmtToGame(arg[0])
			}
		})

		let refresh_level_up_red_time_id
		this.goods_model.Bind(GoodsModel.CHANGE_BAG_LIST, (goods_list) => {
			let need_update_red = false
			for (let vo of goods_list) {
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(vo.type_id)
				if (basic.type == DragonBallModel.GoodType && basic.subtype == DragonBallModel.SubGoodType) {
					need_update_red = true
					break
				}
			}
			if (need_update_red) {
				if (refresh_level_up_red_time_id) return
				refresh_level_up_red_time_id = setTimeout(() => {
					this.model.RefreshBallLevelUpRed()
					refresh_level_up_red_time_id = false
				}, 200);
			}
		})

		let gift_refresh_level_dic
		this.role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
			if (!Config.PRELOAD_SERVER_CONFIG.config_start_nuclear) return
			if (gift_refresh_level_dic == null) {
				gift_refresh_level_dic = {}
				for (let key in Config.PRELOAD_SERVER_CONFIG.config_start_nuclear) {
					gift_refresh_level_dic[Config.PRELOAD_SERVER_CONFIG.config_start_nuclear[key].open_lv] = true
				}
			}
			if (gift_refresh_level_dic[level]) {
				this.SendFmtToGame(14311)
			}
		})

		FirstRechargeModel.GetInstance().Bind(FirstRechargeModel.UPDATE_FIRST_RECHARGE_VIEW, () => {
			// this.SendFmtToGame(14311)
			this.model.RefreshGiftIcon()
		})

		GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
			this.SendFmtToGame(14311)
		})

	}


	public RegisterAll() {
		// 获取龙珠列表
		let On14300 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14300)
			this.model.SetBallData(scmd)
			this.model.RefreshSuitLevelUpRed()
			this.model.RefreshBallLevelUpRed()
			this.model.Fire(DragonBallModel.RecvFmt14300)
		}

		// 龙珠激活
		let On14301 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14301)
			if (scmd.errcode == 1) {
				PlayBigEffect("ui_ZiTi_Jihuo")
				//后端会主动推14300

				// let data = this.model.GetDrageonData(scmd.dragon_id)
				// if (!data) {
				// 	data = {
				// 		dragon_id: scmd.dragon_id,
				// 		dragon_lv: 1,
				// 		power: scmd.power,
				// 		next_power: scmd.next_power
				// 	}
				// 	this.model.dragon_data_dic[scmd.dragon_id] = data
				// }
				// else {
				// 	data.dragon_lv = 1
				// 	data.power = scmd.power
				// 	data.next_power = scmd.next_power
				// }
				// this.model.Fire(DragonBallModel.RecvFmt14301, scmd.dragon_id)
			} else {
				Util.ErrorCodeShow(scmd.errcode)
			}
		}

		// 龙珠升级
		let On14302 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14302)
			if (scmd.errcode == 1) {
				PlayBigEffect("ui_shengjitexiao")
				//后端会主动推14300

				// let data = this.model.GetDrageonData(scmd.dragon_id)
				// if (!data) {
				// 	data = {
				// 		dragon_id: scmd.dragon_id,
				// 		dragon_lv: scmd.dragon_lv,
				// 		power: scmd.power,
				// 		next_power: scmd.next_power
				// 	}
				// 	this.model.dragon_data_dic[scmd.dragon_id] = data
				// }
				// else {
				// 	data.dragon_lv = scmd.dragon_lv
				// 	data.power = scmd.power
				// 	data.next_power = scmd.next_power
				// }

				// this.model.Fire(DragonBallModel.RecvFmt14302, scmd.dragon_id)
			} else {
				Util.ErrorCodeShow(scmd.errcode)
			}
		}

		// 龙珠套装列表
		let On14303 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14303)
			this.model.wear_type = scmd.wear_type
			this.model.SetSuitData(scmd)
			this.model.RefreshSuitLevelUpRed()
			this.model.Fire(DragonBallModel.RecvFmt14303)
		}

		// 穿戴、脱下龙珠套装
		let On14304 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14304)
			if (scmd.op == 1) {
				this.model.wear_type = scmd.type
			}
			else if (scmd.op == 2) {
				if (this.model.wear_type == scmd.type) {
					this.model.wear_type = 0
				}
			}
			this.model.Fire(DragonBallModel.RecvFmt14304)
		}

		//激活龙珠套装
		let On14305 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14305)
			if (scmd.code == 1) {
				if (scmd.lv == 1) {
					//激活特效
					PlayBigEffect("ui_ZiTi_Jihuo")
					this.model.Fire(DragonBallModel.REQUEST_SCMD, 14304, scmd.type, 1)

					let data = {
						_type: DragonBallModel.ModuleId,
						id: scmd.type,
						lv: scmd.lv
					}
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
				}
				else {
					//升级特效
					PlayBigEffect("ui_shengjitexiao")
				}

				//后端会主动推14303
				// this.model.Fire(DragonBallModel.RecvFmt14302, scmd.dragon_id)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		//龙珠系统总战力
		let On14306 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14306)
			this.model.total_power = scmd.total_power
			this.model.Fire(DragonBallModel.RecvFmt14306)
		}

		//龙珠雕像总览
		let On14310 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14310)
			this.model.pre_power = scmd.power
			if (scmd.status == 1 && this.model.statue_active_status != scmd.status) {
				this.model.statue_active_status = scmd.status
				this.SendFmtToGame(14300)
				this.SendFmtToGame(14306)
				this.SendFmtToGame(14311)
				if (!this.is_first_request_14310) {
					PlayBigEffect("ui_ZiTi_Jihuo")
				}
			}
			this.model.Fire(DragonBallModel.RecvFmt14310)
			if (this.is_first_request_14310) {
				this.is_first_request_14310 = false
			}
		}

		let On14311 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14311)
			this.model.SetDragonBallGiftData(scmd)
			this.model.RefreshGiftIcon()
		}

		let On14312 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14312)
			let reward_list = []
			for (let key in scmd.reward) {
				let data = scmd.reward[key]
				let obj = {}
				obj[0] = data.good_type
				obj[1] = data.good_id
				obj[2] = data.num
				table.insert(reward_list, obj)
			}
			let view = new CongratulationObtainView(reward_list)
			view.Open()

			let view_event_id = GlobalEventSystem.Bind(EventName.CONGRATULATION_VIEW_CLOSE, (hashCode) => {
				if (view && view.hashCode == hashCode) {
					let data = this.model.dragon_gift_data
					if(data.id > 0){
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'DragonBallGiftView');
					}
				}
				GlobalEventSystem.UnBind(view_event_id)
			})
		}

		this.RegisterProtocal(14300, On14300)
		this.RegisterProtocal(14301, On14301)
		this.RegisterProtocal(14302, On14302)
		this.RegisterProtocal(14303, On14303)
		this.RegisterProtocal(14304, On14304)
		this.RegisterProtocal(14305, On14305)
		this.RegisterProtocal(14306, On14306)
		this.RegisterProtocal(14310, On14310)
		this.RegisterProtocal(14311, On14311)
		this.RegisterProtocal(14312, On14312)
	}
}

window["DragonBallController"] = DragonBallController