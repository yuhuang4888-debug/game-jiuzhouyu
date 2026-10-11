import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"

export class GodCourtController extends BaseController {
	public constructor() {
		super()
		let view_dic = {}
		let local_GodCourtModel = GodCourtModel
		let model = local_GodCourtModel.GetInstance()
		let USMG = UserMsgAdapter.GetInstance()
		
		model.Bind(local_GodCourtModel.OPEN_VIEW, (view_name:string, ...new_args) => {
			let view = view_dic[view_name]
			if (!view) {
				//if (view_dic[view_name] == true ) {
				let view_class = window[view_name]
				view = new view_class()
				view_dic[view_name] = view
				//}
			}
			if ((view && view.HasOpen) && !view.HasOpen()) {
				view.Open(...new_args)
			}
		}
		)

		model.Bind(local_GodCourtModel.CLOSE_VIEW, (view_name?) => {
			let view = view_dic[view_name]
			if (view && view != true) {
				view.Close()
			}
		}
		)

		model.Bind(local_GodCourtModel.SEND_SCMD, (id, fmt, ...new_args) => {
			this.SendFmtToGame(id, fmt, ...new_args)
		}
		)

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.SendFmtToGame(23301)
			this.SendFmtToGame(23306)
		}
		)

		model.Bind(local_GodCourtModel.DEVOUR, () => {
			let list = model.devourSelect
			let count = Util.TableSize(list)
			this.WriteBegin(15019)
			this.WriteFMT("h", count)
			for (let key in list) {
				var vo = list[key]
				this.WriteFMT("l", key)
				this.WriteFMT("i", vo)
			}
			this.SendToGame()
		}
		)

		let On23300 = () => {
			let scmd = USMG.GetSCMD(23300)
			if (scmd) {
				Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
			}
		}

		let On23301 = () => {
			let scmd = USMG.GetSCMD(23301)
			if (scmd) {
				model.SetGodCourtData(scmd.item_list)
				let onlyOne = scmd.item_list.length == 1 && scmd.item_list[1]
				model.Fire(local_GodCourtModel.UPDATE_GODCOURT, onlyOne)
			}
		}

		let On23302 = () => {
			let scmd = USMG.GetSCMD(23302)
			if (scmd && scmd.error_code == 1) {
				let godCourtData = model.GetData(scmd.court_id)
				if (godCourtData) {
					godCourtData.is_active = scmd.is_active
				}
				if (scmd.court_id >= model.maxClickGodCourt) {
					model.maxClickGodCourt = scmd.court_id + 1
				}
				model.CheckUnlockRed()
				model.CheckStrenRed()
				model.CheckStageRed()
				model.CheckEquipReddot()
				model.Fire(local_GodCourtModel.UNLOCK, scmd)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}

		let On23303 = () => {
			let scmd = USMG.GetSCMD(23303)
			if (scmd && scmd.error_code == 1) {
				model.Fire(local_GodCourtModel.UPDATE_EQUIP, scmd)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}

		let On23304 = () => {
			let scmd = USMG.GetSCMD(23304)
			if (scmd && scmd.error_code == 1) {
				model.Fire(local_GodCourtModel.UPDATE_STAGE, scmd)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}

		let On23305 = () => {
			let scmd = USMG.GetSCMD(23305)
			if (scmd && scmd.error_code == 1) {
				let godCourtData = model.GetData(scmd.court_id)
				if (godCourtData) {
					godCourtData.court_lv = scmd.court_lv
				}
				model.CheckStrenRed()
				model.Fire(local_GodCourtModel.UPDATE_STREN_DATA, scmd)
			} else {
				Util.ErrorCodeShow(scmd.error_code)
			}
		}

		let On23306 = () => {
			let scmd = USMG.GetSCMD(23306)
			if (scmd) {
				model.SetGodHouseData(scmd)
				model.CheckUnlockRed()
				model.CheckHouseRed()
				model.Fire(GodCourtModel.UPDATE_HOUSE)
			}
		}

		let On23307 = () => {
			let scmd = USMG.GetSCMD(23307)
			if (scmd) {
				if (scmd.error_code == 1) {
					model.UpdateCryColor(scmd)
					model.CheckHouseRed()
					model.Fire(GodCourtModel.UPDATE_COLOR)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}
		}

		let On23308 = () => {
			let scmd = USMG.GetSCMD(23308)
			if (scmd) {
				if (scmd.error_code == 1) {
					model.SetHouseLvData(scmd)
					let rewardList = []
					for (let _tmpi in scmd.reward_list) {
						var vo = scmd.reward_list[_tmpi]
						table.insert(rewardList, [vo.goods_type, vo.goods_id, vo.goods_num])
					}
					Util.ShowCongratulationView(rewardList)
					model.CheckUnlockRed()
					model.CheckHouseRed()
					model.Fire(GodCourtModel.UPDATE_LVDATA, "23308")
					model.Fire(GodCourtModel.UPDATE_COLOR)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}
		}

		let On23309 = () => {
			let scmd = USMG.GetSCMD(23309)
			if (scmd) {
				if (scmd.error_code == 1) {
					let rewardList = []
					for (let _tmpi in scmd.reward_list) {
						var vo = scmd.reward_list[_tmpi]
						table.insert(rewardList, [vo.goods_type, vo.goods_id, vo.goods_num])
					}
					model.CheckHouseRed()
					Util.ShowCongratulationView(rewardList)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}
		}

		let On23310 = () => {
			let scmd = USMG.GetSCMD(23310)
			if (scmd) {
				table.sort(scmd.equip_list, (a?, b?) => {
					return a.pos < b.pos
				})
				let canEquipCore = true
				for (let _tmpi in scmd.equip_list) {
					var equip = scmd.equip_list[_tmpi]
					let con
					if (equip.pos < 9) {
						if (equip) {
							let goodsVo = GoodsModel.GetInstance().GetGoodsVoByGoodsId(equip.equip_id)
							if (goodsVo && goodsVo.color >= 4) {
								con = true
							}
						}
						if (!con) {
							canEquipCore = false
							break
						}
					}
				}
				scmd.canEquipCore = canEquipCore
				model.godcourtData[scmd.court_id] = scmd
				model.CheckStrenRed()
				model.CheckStageRed()
				model.CheckEquipReddot()
				model.Fire(local_GodCourtModel.UPDATE_EQUIP, scmd)
				model.Fire(local_GodCourtModel.UPDATE_GODCOURT, scmd)
			}
		}

		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, () => {
			model.CheckHouseRed()
			model.CheckStageRed()
		})
		
		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_GODCOURT, () => {
			model.UpdateEquipState()
			model.CheckDevourRed()
			model.CheckEquipReddot()
		})
		
		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_GODCOURT_BAG, () => {
			model.CheckDevourRed()
			model.CheckEquipReddot()
		})
		
		GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_SPECIAL_SCORE, () => {
			model.CheckStrenRed()
		})
		
		GoodsModel.GetInstance().Bind(GoodsModel.CREATE_SPECIAL_SCORE_FINISH, () => {
			model.CheckStrenRed()
		})

		RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
			if (490 == level) {
				this.SendFmtToGame(23301)
				this.SendFmtToGame(23306)
			}
		})
		
		this.RegisterProtocal(23300, On23300)
		this.RegisterProtocal(23301, On23301)
		this.RegisterProtocal(23302, On23302)
		this.RegisterProtocal(23303, On23303)
		this.RegisterProtocal(23304, On23304)
		this.RegisterProtocal(23305, On23305)
		this.RegisterProtocal(23306, On23306)
		this.RegisterProtocal(23307, On23307)
		this.RegisterProtocal(23308, On23308)
		this.RegisterProtocal(23309, On23309)
		this.RegisterProtocal(23310, On23310)
	}
}