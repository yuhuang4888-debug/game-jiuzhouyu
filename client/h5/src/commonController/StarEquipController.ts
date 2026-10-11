import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CommonManager } from "../common/CommonManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { Alert, Alert_Type } from "../alert/Alert"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { chcModel } from "../commonModel/chcModel"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { StarEquipToolTip } from "../common/StarEquipToolTip"

import "../starEquip/StarEquipMainView"
import "../starEquip/StarEquipUpMasterView"
import { LayerManager } from "../common/LayerManager"

export class StarEquipController extends BaseController {
	view_dic

	public constructor() {
		super()
		this.view_dic = []
		let local_starEquipModel = StarEquipModel
		let model = local_starEquipModel.GetInstance()
		let UMSG = UserMsgAdapter.GetInstance()
		let comparedView1 = null
		let comparedView2 = null
		let global_sys = GlobalEventSystem
		let local_eventName = EventName

		model.Bind(local_starEquipModel.OPEN_VIEW, (view_name: string, ...new_args) => {
			let view = this.view_dic[view_name]
			if (!view) {
				let view_class = window[view_name]
				view = new view_class()
				this.view_dic[view_name] = view
			}
			if (view && !view.HasOpen()) {
				view.Open(...new_args)
			}
		})

		model.Bind(local_starEquipModel.CLOSE_VIEW, (view_name?) => {
			let view = this.view_dic[view_name]
			if (view) {
				view.Close()
			}
		})

		model.Bind(local_starEquipModel.SEND_PROTO, (id, fmt, ...new_args) => {
			this.SendFmtToGame(id, fmt, ...new_args)
		})

		model.Bind(local_starEquipModel.REQUEST_DEVOUR, () => {
			let count = Util.TableSize(model.devourSelect)
			this.WriteBegin(23209)
			this.WriteFMT("h", count)
			for (let key in model.devourSelect) {
				this.WriteFMT("l", key)
			}
			this.SendToGame()
		})

		model.Bind(local_starEquipModel.COM_REQUEST, (ruleId?, list1?, list2?, list3?) => {
			this.WriteBegin(23252)
			this.WriteFMT("i", ruleId)
			this.WriteFMT("h", list1.length)
			for (let _tmpi in list1) {
				let vo = list1[_tmpi]
				this.WriteFMT("l", vo)
			}
			this.WriteFMT("h", list2.length)
			for (let _tmpi in list2) {
				let vo = list2[_tmpi]
				this.WriteFMT("l", vo)
			}
			this.WriteFMT("h", list3.length)
			for (let _tmpi in list3) {
				let vo = list3[_tmpi]
				this.WriteFMT("l", vo)
			}
			this.SendToGame()
		})

		model.Bind(local_starEquipModel.COMPARED_EQUIP, (data?) => {
			if (data) {
				//let layer_mgr = LayerManager.GetInstance()
				//let liuhai = GetLiuhaiHeight() || 0
				//let gap = (layer_mgr.stageWidth > 720 && (layer_mgr.stageWidth - 720 / 2) || (0))
				let wearEquip = local_starEquipModel.GetInstance().GetWearEquip(data.page, data.subtype)
				//LayerManager.
				if (wearEquip) {
					if (!comparedView2) {
						comparedView2 = new StarEquipToolTip()
					}
					comparedView2.SetData(wearEquip.type_id, wearEquip, null, [StarEquipToolTip.Btn.close], -150, -100)
					comparedView2.Open()
					if (!comparedView1) {
						comparedView1 = new StarEquipToolTip()
						comparedView1.use_background = false
					}
					comparedView1.replaceClose = true
					comparedView1.SetData(data.type_id, data, null, [StarEquipToolTip.Btn.close, StarEquipToolTip.Btn.replace], 150, 100)
					comparedView1.Open()
				} else {
					UIToolTipMgr.GetInstance().AppendStarEquipToolTips(data.type_id, data, null, [StarEquipToolTip.Btn.inEquip])
				}
			}
		})

		model.Bind(local_starEquipModel.CLOSE_COMPARED, () => {
			if (comparedView1 && comparedView1.isPop) {
				comparedView1.Close()
			}
			if (comparedView2 && comparedView2.isPop) {
				comparedView2.Close()
			}
		})

		GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_GOODS_NUM, () => {
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_compose", (cfg) => {
				if (!cfg) {
					return
				}
				model.UpdateComRed(cfg)
			}, false)
		})

		let On23200 = () => {
			let scmd = UMSG.GetSCMD(23200)
			if (scmd) {
				if (scmd.error_code == 1500081) {
					model.Fire(StarEquipModel.COM_FAIL, scmd)
				} else {
					Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
				}
			}
		}

		let On23201 = () => {
			let scmd = UMSG.GetSCMD(23201)
			if (scmd) {
				if (model.totalStar != scmd.total_star) {
					this.SendFmtToGame(23205)
				}
				model.totalStar = scmd.total_star

				let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_compose", (cfg2) => {
					if (!cfg2) {
						return
					}
					model.SetStarPageInfo(cfg1, cfg2, scmd.item_list)
					chcModel.GetInstance().UpdateMasterRed()
				}, false)

				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_page", (cfg) => {
					if (!cfg) {
						return
					}
					model.UpdatePageUnLockRed(cfg)
				}, false)
				model.Fire(local_starEquipModel.UPDATE_STAR_INFO)
			}
		}

		let On23202 = () => {
			let scmd = UMSG.GetSCMD(23202)
			if (scmd) {
				let cfg0, cfg1, cfg3, cfg4
				cfg0 = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
				let ok_back = () => {
					if (cfg0 && cfg1 && cfg3 && cfg4) {
						chcModel.GetInstance().UpdateEquipHandle(cfg0, cfg1, cfg3, cfg4, scmd, false)
					}
				}

				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_strength", (cfg) => {
					if (!cfg) {
						return
					}
					cfg1 = cfg
					ok_back()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_enchantment", (cfg) => {
					if (!cfg) {
						return
					}
					cfg3 = cfg
					ok_back()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg) => {
					if (!cfg) {
						return
					}
					cfg4 = cfg
					ok_back()
				}, false)
			}
		}

		let On23203 = () => {
			let scmd = UMSG.GetSCMD(23203)
			if (scmd) {
				let cfg0, cfg1, cfg3, cfg4
				cfg0 = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
				let ok_back = () => {
					if (cfg0 && cfg1 && cfg3 && cfg4) {
						chcModel.GetInstance().UpdateEquipHandle(cfg0, cfg1, cfg3, cfg4, scmd, false)
					}
				}

				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_strength", (cfg) => {
					if (!cfg) {
						return
					}
					cfg1 = cfg
					ok_back()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_enchantment", (cfg) => {
					if (!cfg) {
						return
					}
					cfg3 = cfg
					ok_back()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg) => {
					if (!cfg) {
						return
					}
					cfg4 = cfg
					ok_back()
				}, false)
			}
		}

		let On23204 = () => {
			let scmd = UMSG.GetSCMD(23204)
			if (scmd) {
				model.SetOnePageInfo(scmd)
				model.Fire(local_starEquipModel.UPDATE_STAR_INFO)
			}
		}

		let On23205 = () => {
			let scmd = UMSG.GetSCMD(23205)
			if (scmd) {
				let show = model.activeStar != null
				model.activeStar = scmd.level
				model.totalStar = scmd.star
				model.starPower = scmd.power
				model.oldMaxStar = scmd.max_level
				if (CommonManager.GetInstance().CheckFuncOpenState("StarEquipView", true)) {
					model.masterRed = scmd.star > scmd.level
					RedDotController.ins.up(RedKey.STAR_EQUIP_MASTER, scmd.star > scmd.level ? 1 : 0)
					model.Fire(StarEquipModel.REFRESH_RED, 4)
					global_sys.Fire(local_eventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
				}
				if (show && scmd.star > scmd.level) {
					if (!StarEquipModel.waitShowMaster) {
						model.Fire(local_starEquipModel.OPEN_VIEW, "StarEquipUpMasterView", [scmd.star, model.totalStar])
					} else {
						StarEquipModel.waitShowMasterInfo = [scmd.star, model.totalStar]
					}
				}
				model.Fire(local_starEquipModel.STAR_MASTER_INFO, scmd)
			}
		}

		let On23206 = () => {
			let scmd = UMSG.GetSCMD(23206)
			if (scmd) {
				if (scmd.code == 1) {
					model.activeStar = scmd.level
					model.starPower = scmd.power
					model.oldMaxStar = scmd.level
					if (CommonManager.GetInstance().CheckFuncOpenState("StarEquipView", true)) {
						model.masterRed = model.totalStar > scmd.level
						RedDotController.ins.up(RedKey.STAR_EQUIP_MASTER, model.totalStar > scmd.level ? 1 : 0)
						model.Fire(StarEquipModel.REFRESH_RED, 4)
						global_sys.Fire(local_eventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
					}
					model.Fire(local_starEquipModel.MASTR_UP)
					model.Fire(local_starEquipModel.STAR_MASTER_INFO, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		}

		let On23207 = () => {
			let scmd = UMSG.GetSCMD(23207)
			if (scmd) {
				model.devourLv = scmd.level
				model.devourExp = scmd.exp
				model.devourPower = scmd.power
				model.devColor = scmd.color
				model.devSingle = scmd.star
				model.Fire(StarEquipModel.UPDATE_DEVOUR_DATA, scmd)
			}
		}

		let On23208 = () => {
			let scmd = UMSG.GetSCMD(23208)
			if (scmd) {
				if (scmd.code == 1) {
					model.devColor = scmd.color
					model.devSingle = scmd.star
					model.Fire(StarEquipModel.UPDATE_DEVOUR_TAB, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		}

		let On23209 = () => {
			let scmd = UMSG.GetSCMD(23209)
			if (scmd) {
				model.devourLv = scmd.level
				model.devourExp = scmd.exp
				model.devourPower = scmd.power
				model.Fire(StarEquipModel.UPDATE_DEVOUR_DATA, scmd)
				model.Fire(StarEquipModel.DEVOUR_SUCCESS)
			}
		}

		let On23250 = () => {
			let scmd = UMSG.GetSCMD(23250)
			if (scmd) {
				model.Fire(StarEquipModel.PREVIEW_TOOLTIPS, scmd)
			}
		}

		let On23251 = () => {
			let scmd = UMSG.GetSCMD(23251)
			if (scmd) {
				if (scmd.star < model.totalStar) {
					Alert.Show("当前装备总星级下降,部分星级大师属性将失效.\n请及时穿戴最强装备恢复实力!", Alert_Type.One, null, null, "我知道了")
				}
				model.activeStar = scmd.level
				model.starPower = scmd.power
				model.totalStar = scmd.star
				model.oldMaxStar = scmd.max_level
				if (CommonManager.GetInstance().CheckFuncOpenState("StarEquipView", true)) {
					model.masterRed = scmd.star > model.activeStar
					RedDotController.ins.up(RedKey.STAR_EQUIP_MASTER, scmd.star > model.activeStar ? 1 : 0)
					model.Fire(StarEquipModel.REFRESH_RED, 4)
					global_sys.Fire(local_eventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
				}
				if (scmd.star > model.activeStar) {
					if (!StarEquipModel.waitShowMaster) {
						model.Fire(local_starEquipModel.OPEN_VIEW, "StarEquipUpMasterView", [scmd.star, model.totalStar])
					} else {
						StarEquipModel.waitShowMasterInfo = [scmd.star, model.totalStar]
					}
				}
				model.Fire(local_starEquipModel.STAR_MASTER_INFO)
			}
		}

		let On23252 = () => {
			let scmd = UMSG.GetSCMD(23252)
			if (scmd) {
				if (scmd.code == 1 || scmd.code == 1500080) {
					model.Fire(StarEquipModel.COM_SUCCESS, scmd.rule_id, scmd.send_list)
				} else if (scmd.code == 1500081) {
					model.Fire(StarEquipModel.COM_FAIL, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		}

		let On23253 = () => {
			let scmd = UMSG.GetSCMD(23253)
			if (scmd) {
				if (scmd.code == 1) {
					let cfg1 = Config.PRELOAD_SERVER_CONFIG.config_compose_menu
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_compose", (cfg2) => {
						if (!cfg2) {
							return
						}
						let list = model.pageInfo[scmd.page]
						if (list) {
							list.is_active = 1
						}
						model.UpdateEquipRed()
						model.InitComList(cfg1, cfg2)
						model.UpdateComRed(cfg2)
						model.Fire(local_starEquipModel.ACTIVE_PAGE)
						this.SendFmtToGame(23201)
					}, false)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
		}

		let On23254 = () => {
			let scmd = UMSG.GetSCMD(23254)
			if (scmd) {
				scmd.goods_id = 23254
				model.transfromCache = scmd
				model.Fire(StarEquipModel.TRANSFROM_PREVIEW, scmd)
			}
		}

		let On23255 = () => {
			let scmd = UMSG.GetSCMD(23255)
			if (scmd) {
				model.typePreviewCache[scmd.goods_id] = scmd
				model.Fire(StarEquipModel.TRANSFROM_PREVIEW, scmd)
			}
		}

		let On23256 = () => {
			let scmd = UMSG.GetSCMD(23256)
			if (scmd) {
				model.comSpNumList[scmd.compose_id] = scmd
				model.Fire(StarEquipModel.UPDATE_COM_TIME, scmd)
			}
		}

		let On23257 = () => {
			let scmd = UMSG.GetSCMD(23257)
			if (scmd) {
				if (scmd.res == 1) {

				}
			}
		}

		this.RegisterProtocal(23200, On23200)
		this.RegisterProtocal(23201, On23201)
		this.RegisterProtocal(23202, On23202)
		this.RegisterProtocal(23203, On23203)
		this.RegisterProtocal(23204, On23204)
		this.RegisterProtocal(23205, On23205)
		this.RegisterProtocal(23206, On23206)
		this.RegisterProtocal(23207, On23207)
		this.RegisterProtocal(23208, On23208)
		this.RegisterProtocal(23209, On23209)
		this.RegisterProtocal(23250, On23250)
		this.RegisterProtocal(23251, On23251)
		this.RegisterProtocal(23252, On23252)
		this.RegisterProtocal(23253, On23253)
		this.RegisterProtocal(23254, On23254)
		this.RegisterProtocal(23255, On23255)
		this.RegisterProtocal(23256, On23256)
		this.RegisterProtocal(23257, On23257)

		RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
			if (model.OpenLv == level) {
				this.SendFmtToGame(23201)
				this.SendFmtToGame(23205)
				this.SendFmtToGame(23207)
			}
		})

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			model.pageInfo = {}
			model.oldMaxStar = 0
			this.SendFmtToGame(23201)
			this.SendFmtToGame(23207)
			let OpenCfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
			if (OpenCfg && OpenCfg["StarEquipView"]) {
				model.OpenLv = OpenCfg["StarEquipView"].open_lv
			}
		})
	}
}
window["StarEquipController"] = StarEquipController