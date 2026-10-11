import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PlayBigEffect, Util } from "../util/Util"
import { Config } from "../common/Config"

import "../godBeast/GodBeastView";
import "../godBeast/GodBeastBagView";
import "../godBeast/GodBeastComView";
import "../godBeast/GodBeastTipsView";
import "../godBeast/GodBeastSelectView";
import "../godBeast/GodBeastSkillView";
import "../godBeast/GodBeastStrView";


export class GodBeastController extends BaseController {
	InitEvent
	InitInfo
	static Instance: any

	public constructor() {
		super()

		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_GodBeastEvent = GodBeastEvent
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Util = Util
		let model:GodBeastModel = GodBeastModel.GetInstance()
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {
				model.InitCfg()
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.Reset()
				setTimeout(() => {
					this.SendFmtToGame(17301)
				}, 0.2)
			}
			)
			model.Bind(local_GodBeastEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			model.Bind(local_GodBeastEvent.BEAST_EQUIP_STREN, (goods_id?, is_double?, goods_list?) => {
				if ((!goods_id || !goods_list) || goods_list.length <= 0) {
					return
				}
				this.WriteBegin(17307)
				this.WriteFMT("l", goods_id)
				this.WriteFMT("c", is_double)
				this.WriteFMT("h", goods_list.length)
				for (let _tmpi in goods_list) {
					let id = goods_list[_tmpi]
					this.WriteFMT("l", id)
				}
				this.SendToGame()
			}
			)
			model.Bind(local_GodBeastEvent.SEND_STREN_PREVIEW, (goods_id?, is_double?, goods_list?) => {
				if ((!goods_id || !goods_list) || goods_list.length <= 0) {
					return
				}
				this.WriteBegin(17308)
				this.WriteFMT("l", goods_id)
				this.WriteFMT("c", is_double)
				this.WriteFMT("h", goods_list.length)
				for (let _tmpi in goods_list) {
					let id = goods_list[_tmpi]
					this.WriteFMT("l", id)
				}
				this.SendToGame()
			}
			)
			model.Bind(local_GodBeastEvent.GET_ATTR_POWER, (module_id?, sub_module_id?, attr_list?) => {
				if (module_id == null || sub_module_id == null) {
					return
				}
				if (!attr_list || attr_list.length <= 0) {
					return
				}
				this.WriteBegin(17309)
				this.WriteFMT("h", module_id)
				this.WriteFMT("c", sub_module_id)
				this.WriteFMT("h", attr_list.length)
				for (let _tmpi in attr_list) {
					let attr = attr_list[_tmpi]
					this.WriteFMT("h", attr[0] || attr.attr_id)
					this.WriteFMT("i", attr[1] || attr.attr_value)
				}
				this.SendToGame()
			}
			)
			GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BEAST_BAG_LIST, () => {
				model.CheckAllRedStatus()
			}
			)
			model.Bind(local_GodBeastEvent.COM_EQUIP, (id?, list?) => {
				this.WriteBegin(17310)
				this.WriteFMT("i", id)
				this.WriteFMT("h", Util.TableSize(list))
				for (let key in list) {

					this.WriteFMT("l", Number(key))
				}
				this.SendToGame()
			}
			)
			model.Bind(local_GodBeastEvent.QUICK_EQUIP, (id?, replace?, list?) => {
				if (!list || list.length < 1) {
					return
				}
				this.WriteBegin(17312)
				this.WriteFMT("h", list.length)
				for (let _tmpi in list) {
					let goods_id = list[_tmpi]
					this.WriteFMT("l", goods_id)
				}
				this.WriteFMT("c", replace)
				this.WriteFMT("i", id)
				this.SendToGame()
			}
			)
		}

		this.InitInfo = () => {
			let on17300 = () => {
				let scmd = user_msg_adapter.GetSCMD(17300)
				Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
			}

			let on17301 = () => {
				let scmd = user_msg_adapter.GetSCMD(17301)
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_eudemons_item
				scmd.eudemons_list.sort((a?, b?) => {
					let a_cfg = model.GetBeastData(a.id, cfgs)
					let b_cfg = model.GetBeastData(b.id, cfgs)
					if (a_cfg && b_cfg) {
						let aid = a_cfg.sort_id
						let bid = b_cfg.sort_id
						if (aid && bid && aid != bid) {
							return aid - bid
						}
					}
					return -1
				})
				for (let _tmpi in scmd.eudemons_list) {
					let info = scmd.eudemons_list[_tmpi]
					if (info.equip_list.length > 0) {
						info["equip_dic"] = []
					}
					for (let _tmpi in info.equip_list) {
						let equip = info.equip_list[_tmpi]
						let data = model.GetWearEquipInfo(equip.goods_id)
						if (data) {
							data.exp = equip.exp
						}
						info["equip_dic"][equip.pos] = equip
					}
				}
				model.SetBeastInfo(scmd)
			}

			let on17302 = () => {
				let scmd = user_msg_adapter.GetSCMD(17302)
				if (scmd.equip_list.length > 0) {
					scmd["equip_dic"] = []
				}
				for (let _tmpi in scmd.equip_list) {
					let equip = scmd.equip_list[_tmpi]
					let data = model.GetWearEquipInfo(equip.goods_id)
					if (data) {
						data.exp = equip.exp
					}
					scmd["equip_dic"][equip.pos] = equip
				}
				if (scmd.state == 1) {
					let beast_info = model.GetBeastInfo()
					if (!beast_info) {
						return
					}
					for (let _tmpi in beast_info.eudemons_list) {
						let info = beast_info.eudemons_list[_tmpi]
						if (scmd.id != info.id) {
							break
						}
						if (info.state == 0) {
							model.Fire(local_GodBeastEvent.BEAST_ACTIVE)
						}
						break
					}
				}
				model.SetBeastInfoOne(scmd)
			}

			let on17303 = () => {
				let scmd = user_msg_adapter.GetSCMD(17303)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "GodBeastSelectView")
			}

			let on17304 = () => {
				let scmd = user_msg_adapter.GetSCMD(17304)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "GodBeastSelectView")
			}

			let on17305 = () => {
				let scmd = user_msg_adapter.GetSCMD(17305)
				if (scmd.state == 2) {
					PlayBigEffect("ui_ZiTi_Jihuo")
				}
				model.SetBeastStatus(scmd)
			}

			let on17306 = () => {
				let scmd = user_msg_adapter.GetSCMD(17306)
				model.SetBeastPosCount(scmd)
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "GodBeastTipsView")
				Message.show("扩充成功")
			}

			let on17307 = () => {
				let scmd = user_msg_adapter.GetSCMD(17307)
				let data1 = model.GetWearEquipInfo(scmd.goods_id)
				let data2 = model.GetWearEquipInfoFromBeastInfo(scmd.goods_id)
				if (data2 && data2.stren < scmd.stren) {
					model.Fire(local_GodBeastEvent.STREN_UPGRADE)
				}
				if (data1) {
					model.SetStrenInfoToData(data1, scmd)
				}
				if (data2) {
					model.SetStrenInfoToData(data2, scmd)
				}
				model.CheckAllRedStatus()
				model.Fire(local_GodBeastEvent.STREN_SUCCESS, scmd)
			}

			let on17308 = () => {
				let scmd = user_msg_adapter.GetSCMD(17308)
				model.Fire(local_GodBeastEvent.RECTIVE_STREN_PREVIEW, scmd)
			}

			let on17309 = () => {
				let scmd = user_msg_adapter.GetSCMD(17309)
				model.Fire(local_GodBeastEvent.UPDATE_ATTR_POWER, scmd)
			}

			let on17310 = () => {
				let scmd = user_msg_adapter.GetSCMD(17310)
				if (scmd.code == 1 || scmd.code == 1500080) {
					let list = []
					for (let vo of scmd.send_list) {
						list.push([0, vo.goods_type_id, 1, vo.goods_id])
					}

					if(model.auto_composite_state){
						model.Fire(local_GodBeastEvent.COM_SUCCESS, list)
					}
					else{
						let view = new CongratulationObtainView(list, 10)
						view.Open()
						model.Fire(local_GodBeastEvent.COM_SUCCESS)
					}

					
					
					
					

				} else {
					local_Util.ErrorCodeShow(scmd.code)
				}
			}

			let on17311 = () => {
				PlayBigEffect("ui_qianghuachenggong")
				Message.show("强化成功")
				let scmd = user_msg_adapter.GetSCMD(17311)
				let data1 = model.GetWearEquipInfo(scmd.goods_id)
				let data2 = model.GetWearEquipInfoFromBeastInfo(scmd.goods_id)
				let notUp = scmd.stren <= data2.stren
				if (data2 && data2.stren < scmd.stren) {
					model.Fire(local_GodBeastEvent.STREN_UPGRADE)
				}
				if (data1) {
					model.SetStrenInfoToData(data1, scmd)
				}
				if (data2) {
					model.SetStrenInfoToData(data2, scmd)
				}
				model.Fire(local_GodBeastEvent.STREN_SUCCESS, data2, notUp)
				model.CheckAllRedStatus()
			}

			let on17312 = () => {
				let scmd = user_msg_adapter.GetSCMD(17312)
			}

			this.RegisterProtocal(17300, on17300)
			this.RegisterProtocal(17301, on17301)
			this.RegisterProtocal(17302, on17302)
			this.RegisterProtocal(17303, on17303)
			this.RegisterProtocal(17304, on17304)
			this.RegisterProtocal(17305, on17305)
			this.RegisterProtocal(17306, on17306)
			this.RegisterProtocal(17307, on17307)
			this.RegisterProtocal(17308, on17308)
			this.RegisterProtocal(17309, on17309)
			this.RegisterProtocal(17310, on17310)
			this.RegisterProtocal(17311, on17311)
			this.RegisterProtocal(17312, on17312)
		}

		this.InitInfo()
		this.InitEvent()
	}

	public static GetInstance() {

		if (!GodBeastController.Instance) {
			GodBeastController.Instance = new GodBeastController()
		}
		return GodBeastController.Instance
	}
}


window["GodBeastController"] = GodBeastController