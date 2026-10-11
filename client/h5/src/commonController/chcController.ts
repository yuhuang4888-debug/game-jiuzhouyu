import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { chcModel } from "../commonModel/chcModel"
import { ResManager } from "../common/ResManager"
import { Config } from "../common/Config"

import "../chc/chcBaseView"
import "../chc/chcSuccessView"

export class chcController extends BaseController {
	InitEvent
	InitInfo
	SendDefFmt
	_scmd_mark
	public static Instance

	public constructor() {
		super()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let model = chcModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		this._scmd_mark = true;
		this.InitEvent = () => {
			model.Bind(chcModel.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				if (role_mgr.GetMainRoleVo().level >= chcModel.OPEN_LV) {
					model.DefineConstant()
				}
				this._scmd_mark = true;
			}
			)
			goods_model.Bind(GoodsModel.CHANGE_STAREQUIP, () => {
				if (!this._scmd_mark) {
					return
				}
				this._scmd_mark = false
				this.SendDefFmt()
			}
			)
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
				if (level == chcModel.OPEN_LV) {
					model.DefineConstant()
					this.SendDefFmt()
				}
			}
			)

			model.Bind(chcModel.SEND_EVO_PROTO, (stype?, goods_id?, pos?, list?) => {
				this.WriteBegin(23221)
				this.WriteFMT("c", stype)
				this.WriteFMT("l", goods_id)
				this.WriteFMT("c", pos)
				this.WriteFMT("h", list.length)
				for (let _tmpi in list) {
					let vo = list[_tmpi]
					this.WriteFMT("l", vo.goods_id)
				}
				this.SendToGame()
				StarEquipModel.waitShowMaster = true
			}
			)

			goods_model.Bind(GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				let cfg1, cfg2, cfg3, cfg4
				let ok_func = () => {
					if (cfg1 && cfg2 && cfg3 && cfg4) {
						for (let _tmpi in goods_list) {
							let vo = goods_list[_tmpi]
							let basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
							let type = basic.subtype % 10
							let cfg
							switch (type) {
								case 1:
									cfg = cfg1
									break;
								case 2:
									cfg = cfg2
									break;
								case 3:
									cfg = cfg3
									break;
								case 4:
									cfg = cfg4
									break;
							}
							if (!basic) {
								break
							}
							if (basic.type != 79) {
								break
							}
							if ((basic.subtype == 11 || basic.subtype == 12) || basic.subtype == 13) {
								for (let i = 1; i <= model._stype_count; i++) {
									model.CheckReddot(cfg, basic.subtype % 10, i)
								}
							} else if (basic.subtype == 14) {
								for (let i = 1; i <= model._stype_count; i++) {
									model.CheckReddotSoul(cfg4, i)
								}
							}
						}
					}
				}
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_strength", (cfg) => {
					if (!cfg) {
						return
					}
					cfg1 = cfg
					ok_func()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_evolution", (cfg) => {
					if (!cfg) {
						return
					}
					cfg2 = cfg
					ok_func()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_enchantment", (cfg) => {
					if (!cfg) {
						return
					}
					cfg3 = cfg
					ok_func()
				}, false)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg) => {
					if (!cfg) {
						return
					}
					cfg4 = cfg
					ok_func()
				}, false)
			})

			GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				this.SendDefFmt()
			})

			goods_model.Bind(GoodsModel.CHANGE_STAREQUIP, (goods_list?, is_create?) => {
				if (is_create) {
					return
				}
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_constellation_equip
				for (let _tmpi in goods_list) {
					let vo = goods_list[_tmpi]
					let basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
					if (!basic) {
						break
					}
					if (basic.type != 79) {
						break
					}
					if (basic.subtype > 10) {
						break
					}
					let data = cfg[basic.type_id]
					if (!data) {
						break
					}
					this.SendFmtToGame(23210, "c", data.page)
					this.SendFmtToGame(23220, "c", data.page)
					this.SendFmtToGame(23230, "c", data.page)
					this.SendFmtToGame(23240, "c", data.page)
				}
			}
			)
		}

		this.SendDefFmt = () => {
			let i = 1
			do {
				this.SendFmtToGame(23210, "c", i)
				this.SendFmtToGame(23220, "c", i)
				this.SendFmtToGame(23230, "c", i)
				this.SendFmtToGame(23240, "c", i)
				this.SendFmtToGame(23212, "c", i)
				this.SendFmtToGame(23232, "c", i)
				i = i + 1
			} while ((i <= model._stype_count))
		}

		this.InitInfo = () => {
			let on23210 = () => {
				let scmd = user_msg_adapter.GetSCMD(23210)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg1) => {
					if (!cfg1) {
						return
					}
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_strength", (cfg2) => {
						if (!cfg2) {
							return
						}
						model.SetInfoByType(cfg1, cfg2, chcModel.CHCTYPE.STREN, scmd)
						StarEquipModel.GetInstance().UpdatePageUnLockRed()
					}, false)
				}, false)
			}

			let on23211 = () => {
				let scmd = user_msg_adapter.GetSCMD(23211)
				let type = chcModel.CHCTYPE.STREN
				if (scmd.code == 1) {
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_strength", (cfg) => {
						if (!cfg) {
							return
						}
						let data = model.GetDataByPos(type, scmd.type_id, scmd.pos)
						if (data) {
							data.lv = scmd.lv
							model.CheckReddot(cfg, type, scmd.type_id)
							model.Fire(chcModel.UPDATE_INFO, type, scmd.type_id)
							StarEquipModel.GetInstance().UpdatePageUnLockRed()
						}
					}, false)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
				model.Fire(chcModel.UPDATE_RESULT, type, scmd.code == 1)
			}

			let on23212 = () => {
				let scmd = user_msg_adapter.GetSCMD(23212)

				model.SetMasterByType(chcModel.CHCTYPE.STREN, scmd)
			}

			let on23213 = () => {
				let scmd = user_msg_adapter.GetSCMD(23213)
				if (scmd.code == 1) {
					Message.show("点亮成功")
					let type = chcModel.CHCTYPE.STREN
					let data = model.GetMasterByStype(type, scmd.type_id)
					for (let _tmpi in data.master_list) {
						let vo = data.master_list[_tmpi]
						// [ts2lua]lua中0和空字符串也是true，此处vo.master_lv <= scmd.master_lv需要确认
						vo.status = (vo.master_lv <= scmd.master_lv && (2) || (0))
					}
					model.CheckReddotMaster(type, scmd.type_id)
					model.Fire(chcModel.UPDATE_MASTER, type, scmd.type_id, data)
					model.Fire(chcModel.MASTER_RESULT, type, scmd)
					this.SendFmtToGame(23210, "c", scmd.type_id)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on23220 = () => {
				let scmd = user_msg_adapter.GetSCMD(23220)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg1) => {
					if (!cfg1) {
						return
					}
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_evolution", (cfg2) => {
						if (!cfg2) {
							return
						}
						model.SetInfoByType(cfg1, cfg2, chcModel.CHCTYPE.EVO, scmd)
						StarEquipModel.GetInstance().UpdatePageUnLockRed()
					}, false)
				}, false)
			}

			let on23221 = () => {
				let scmd = user_msg_adapter.GetSCMD(23221)
				let type = chcModel.CHCTYPE.EVO
				if (scmd.code == 1) {
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_evolution", (cfg) => {
						if (!cfg) {
							return
						}
						if (scmd.is_success == 1) {
							let data = model.GetDataByPos(type, scmd.type_id, scmd.pos)
							data.lv = scmd.lv
							model.CheckReddot(cfg, type, scmd.type_id)
							model.Fire(chcModel.UPDATE_INFO, type, scmd.type_id)
							StarEquipModel.GetInstance().UpdatePageUnLockRed()
						}
						model.Fire(chcModel.UPDATE_RESULT, type, scmd.is_success == 1, scmd)
					}, false)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on23230 = () => {
				let scmd = user_msg_adapter.GetSCMD(23230)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg1) => {
					if (!cfg1) {
						return
					}
					ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_enchantment", (cfg2) => {
						if (!cfg2) {
							return
						}
						model.SetInfoByType(cfg1, cfg2, chcModel.CHCTYPE.MAGIC, scmd)
					}, false)
				}, false)
			}

			let on23231 = () => {
				let scmd = user_msg_adapter.GetSCMD(23231)
				let type = chcModel.CHCTYPE.MAGIC
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_enchantment", (cfg) => {
					if (!cfg) {
						return
					}
					if (scmd.code == 1) {
						let data = model.GetDataByPos(type, scmd.type_id, scmd.pos)
						data.lv = scmd.lv
						model.CheckReddot(cfg, type, scmd.type_id)
						model.Fire(chcModel.UPDATE_INFO, type, scmd.type_id)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
					model.Fire(chcModel.UPDATE_RESULT, type, scmd.code == 1)
				}, false)
			}

			let on23232 = () => {
				let scmd = user_msg_adapter.GetSCMD(23232)
				model.SetMasterByType(chcModel.CHCTYPE.MAGIC, scmd)
			}

			let on23233 = () => {
				let scmd = user_msg_adapter.GetSCMD(23233)
				if (scmd.code == 1) {
					Message.show("点亮成功")
					let type = chcModel.CHCTYPE.MAGIC
					let data = model.GetMasterByStype(type, scmd.type_id)
					for (let _tmpi in data.master_list) {
						let vo = data.master_list[_tmpi]
						vo.status = (vo.master_lv <= scmd.master_lv && (2) || (0))
					}
					model.CheckReddotMaster(type, scmd.type_id)
					model.Fire(chcModel.UPDATE_MASTER, type, scmd.type_id, data)
					model.Fire(chcModel.MASTER_RESULT, type, scmd)
					this.SendFmtToGame(23230, "c", scmd.type_id)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on23240 = () => {
				let scmd = user_msg_adapter.GetSCMD(23240)
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg1) => {
					if (!cfg1) {
						return
					}
					model.SetInfoByType(cfg1, cfg1, chcModel.CHCTYPE.SOUL, scmd)
				}, false)
			}

			let on23241 = () => {
				let scmd = user_msg_adapter.GetSCMD(23241)
				let type = chcModel.CHCTYPE.SOUL
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_constellation_spirit", (cfg) => {
					if (!cfg) {
						return
					}
					if (scmd.code == 1) {
						let data = model.GetDataByPos(type, scmd.type_id, scmd.pos)
						data.is_spirit = scmd.is_spirit
						model.CheckReddotSoul(cfg, scmd.type_id)
						model.Fire(chcModel.UPDATE_INFO, type, scmd.type_id)
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "chcSuccessView", scmd)
					} else {
						Util.ErrorCodeShow(scmd.code)
					}
					model.Fire(chcModel.UPDATE_RESULT, type, scmd.code == 1)
				}, false)
			}

			this.RegisterProtocal(23210, on23210)
			this.RegisterProtocal(23211, on23211)
			this.RegisterProtocal(23212, on23212)
			this.RegisterProtocal(23213, on23213)
			this.RegisterProtocal(23220, on23220)
			this.RegisterProtocal(23221, on23221)
			this.RegisterProtocal(23230, on23230)
			this.RegisterProtocal(23231, on23231)
			this.RegisterProtocal(23232, on23232)
			this.RegisterProtocal(23233, on23233)
			this.RegisterProtocal(23240, on23240)
			this.RegisterProtocal(23241, on23241)
		}

		this.InitInfo()
		this.InitEvent()
	}

	public static GetInstance() {
		if (!chcController.Instance) {
			chcController.Instance = new chcController()
		}
		return chcController.Instance
	}
}
window["chcController"] = chcController