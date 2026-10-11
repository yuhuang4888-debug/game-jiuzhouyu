import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { PetEquipType, PetEquipEvent, PetEquipDefine } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

import "../petEquip/PetEquipBaseView"
import "../petEquip/PetEquipStrenMasterView"
import "../petEquip/PetEquipStarMasterView"
import "../petEquip/PetEquipStageMasterView"

export class PetEquipController extends BaseController {

	InitEvent
	InitInfo
	public constructor() {
		super()

		let model = PetEquipModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_PetEquipType = PetEquipType
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Util = Util
		let local_PetEquipEvent = PetEquipEvent

		this.InitEvent = () => {

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.Reset()
				model.InitCfg()
				this.SendFmtToGame(16014, "c", local_PetEquipType.HORSE)
				this.SendFmtToGame(16014, "c", local_PetEquipType.PARTNER)
			})

			model.Bind(local_PetEquipEvent.REQUEST_PROTO, (id, fmt, ...parms) => {
				this.SendFmtToGame(id, fmt, ...parms)
			})

			model.Bind(local_PetEquipEvent.REQUEST_STREN, (type_id, goods_id, cost_list) => {
				if (!type_id || !goods_id || !cost_list) {
					return
				}
				this.WriteBegin(16016)
				this.WriteFMT("c", type_id)
				this.WriteFMT("l", goods_id)
				this.WriteFMT("h", cost_list.length)
				for (let id of cost_list) {
					this.WriteFMT("l", id)
				}
				this.SendToGame()
			})

			goods_model.Bind(local_GoodsModel.CHANGE_HORSE_LIST, () => {
				model.CheckRedStatus(local_PetEquipType.HORSE)
			})

			goods_model.Bind(local_GoodsModel.CHANGE_HORSE_BAG_LIST, () => {
				model.CheckRedStatus(local_PetEquipType.HORSE)
			})

			goods_model.Bind(local_GoodsModel.CHANGE_PARTNER_LIST, () => {
				model.CheckRedStatus(local_PetEquipType.PARTNER)
			})

			goods_model.Bind(local_GoodsModel.CHANGE_PARTNER_BAG_LIST, () => {
				model.CheckRedStatus(local_PetEquipType.PARTNER)
			})

			OutWardBaseModel.GetInstance().Bind(OutWardBaseModel.UPDATE_OUTWARD_DATA, (data?) => {
				if (data.type_id != local_PetEquipType.HORSE && data.type_id != local_PetEquipType.PARTNER) {
					return
				}
				model.CheckRedStatus(data.type_id)
			})

			let delay_timer_id
			RoleManager.GetInstance().GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level) => {
				if (delay_timer_id) {
					Laya.timer.clear(this,delay_timer_id)
					delay_timer_id = null
				}
				if (!delay_timer_id) {
					 setTimeout(delay_timer_id =() => {
						if (level == PetEquipDefine.HORSE_OPEN_LV) {
							this.SendFmtToGame(16014, "c", local_PetEquipType.HORSE)
						} else if (level == PetEquipDefine.PARTNER_OPEN_LV) {
							this.SendFmtToGame(16014, "c", local_PetEquipType.PARTNER)
						}
						model.CheckRedStatus(local_PetEquipType.HORSE)
						model.CheckRedStatus(local_PetEquipType.PARTNER)
					}, 70)
				}
			})
		}

		this.InitInfo = () => {
			let on16014 = () => {
				let scmd = user_msg_adapter.GetSCMD(16014)
				if (scmd.errcode == 1) {
					model.SetPetEquipInfo(scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on16015 = () => {
				let scmd = user_msg_adapter.GetSCMD(16015)
				if (scmd.code == 1) {
					this.SendFmtToGame(16014, "c", scmd.type_id)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on16016 = () => {
				let scmd = user_msg_adapter.GetSCMD(16016)
				if (scmd.code == 1) {
					let pinfo = model.GetPetEquipInfo(scmd.type_id)
					if (!pinfo) {
						return
					}
					pinfo.combat_power = scmd.combat_power
					for (let equip of pinfo.pet_equip_list) {
						if (equip.goods_id == scmd.goods_id) {
							if (equip.pos_lv != scmd.level) {
								model.Fire(local_PetEquipEvent.UPGRADE_SUCCESS)
							}
							equip.pos_point = scmd.exp
							equip.pos_lv = scmd.level
							// let wear = model.GetWearEquipInfo(scmd.type_id, equip.pos_id)
							// if (wear) {
							// 	wear.overall_rating = scmd.combat_power
							// }
							break
						}
					}
					model.SetPetEquipInfo(pinfo)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on16017 = () => {
				let scmd = user_msg_adapter.GetSCMD(16017)
				if (scmd.code == 1) {
					let pinfo = model.GetPetEquipInfo(scmd.type_id)
					if (!pinfo) {
						return
					}
					pinfo.combat_power = scmd.combat_power
					for (let equip of pinfo.pet_equip_list) {
						if (equip.goods_id == scmd.goods_id) {
							equip.star = scmd.star
							equip.stage = scmd.stage
							equip.pos_point = scmd.exp
							equip.pos_lv = scmd.level
							let wear = model.GetWearEquipInfo(scmd.type_id, equip.pos_id)
							if (wear) {
								wear.equipStar = scmd.star
								wear.equipStage = scmd.stage
								wear.overall_rating = scmd.combat_power
								let gdata = model.GetGoodsData(wear.type_id)
								let power = model.GetGoodsPower(gdata.type_id, equip)
								wear.rating = power
							}
							break
						}
					}
					model.SetPetEquipInfo(pinfo)
					model.Fire(local_PetEquipEvent.STAR_SUCCESS)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(16014, on16014)	//打开坐骑、伙伴装备
			this.RegisterProtocal(16015, on16015)	//装备镶嵌
			this.RegisterProtocal(16016, on16016)	//装备强化
			this.RegisterProtocal(16017, on16017)	//装备打磨
		}

		this.InitInfo()
		this.InitEvent()
	}
}

window["PetEquipController"] = PetEquipController