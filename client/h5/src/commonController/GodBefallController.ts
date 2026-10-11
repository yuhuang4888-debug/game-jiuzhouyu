import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CommonManager } from "../common/CommonManager"
import { SceneManager } from "../scene/SceneManager"
import { LoginStateEvent } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Message } from "../sysInfo/SysInfoController"
import { MainFunc } from "../commonModel/MainUIModel"
import { ErlangParser } from "../util/ErlangParser"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { GodBefallModel, GodBefallEvent, GodBefallDefine } from "../commonModel/GodBefallModel"

import "../starEquip/StarEquipMainView"
import { SkillUIModel } from "../commonModel/SkillUIModel"

export class GodBefallController extends BaseController {
	InitEvent
	InitInfo
	ShowRankBreachReward

	public constructor() {
		super()

		let model = GodBefallModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let role_mgr = RoleManager.GetInstance()
		let local_GodBefallEvent = GodBefallEvent
		let local_GodBefallDefine = GodBefallDefine
		let common_mgr = CommonManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(
				local_EventName.INIT_CONFIG, () => {
					//model:InitCfg()
				}
			)
			local_GlobalEventSystem.Bind(
				local_EventName.GAME_START, () => {
					model.Reset()
					model.InitCfg()
					if (role_mgr.GetMainRoleVo().level >= local_GodBefallDefine.OPEN_LV) {
						this.SendFmtToGame(44000)
						this.SendFmtToGame(44010)
						for (let i = 3; i <= 6; i++) {
							this.SendFmtToGame(44017, "c", i)
						}
					}
				}
			)
			model.Bind(
				local_GodBefallEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
					this.SendFmtToGame(id, fmt, ...new_args)
				}
			)
			model.Bind(
				local_GodBefallEvent.REQUEST_OTHER_PROTO, (id?, list?, type?, div?) => {
					if (id == 44016) {
						this.WriteBegin(44016)
						this.WriteFMT("h", list.length)
						for (let _ in list) {
							var vo = list[_]
							this.WriteFMT("i", vo.rule_id)
							this.WriteFMT("c", vo.count)
						}
						this.SendToGame()
					}
					else if (id == 44018) {
						this.WriteBegin(44018)
						this.WriteFMT("c", type)
						this.WriteFMT("h", list.length)
						for (let _ in list) {
							var vo = list[_]
							this.WriteFMT("i", vo.type_id)
							this.WriteFMT("h", vo.num)
						}
						let div_num = div && 1 || 0
						this.WriteFMT("c", div_num)
						this.SendToGame()
					}
				}
			)
			goods_model.Bind(
				local_GoodsModel.CHANGE_GOD_LIST, () => {
					if (!common_mgr.CheckFuncOpenState("GodBefallMainView", true)) {
						return
					}
					model.CheckLvRedStatus()
					model.CheckStageRedStatus()
					model.CheckActiveRedStatus()
					model.CheckEquipRedStatus()
					model.CheckQuickComRedStatus()
				}
			)
			goods_model.Bind(
				local_GoodsModel.CHANGE_GOD_BAG_LIST, () => {
					if (!common_mgr.CheckFuncOpenState("GodBefallMainView", true)) {
						return
					}
					model.CheckStarRedStatus()
					model.CheckEquipRedStatus()
					model.CheckQuickComRedStatus()
				}
			)
			role_mgr.GetMainRoleVo().Bind(
				local_EventName.CHANGE_LEVEL, () => {
					if (role_mgr.GetMainRoleVo().level == local_GodBefallDefine.OPEN_LV) {
						this.SendFmtToGame(44000)
					}
				}
			)
			goods_model.Bind(
				local_GoodsModel.UPDATE_GOODS_NUM, (list?) => {
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						let basic = goods_model.GetGoodsBasicByTypeId(vo.type_id)
						if (basic) {
							if (basic.type == local_GodBefallDefine.GOOD_TYPE) {
								if (basic.subtype == local_GodBefallDefine.UP_SUBTYPE) {
									model.CheckLvRedStatus()
									model.Fire(local_GodBefallEvent.UPDATE_GOODS_RED)
									local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
									break
								}
								else if (basic.subtype == local_GodBefallDefine.STAGE_SUBTYPE) {
									model.CheckStageRedStatus()
									model.CheckActiveRedStatus()
									model.Fire(local_GodBefallEvent.UPDATE_GOODS_RED)
									local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
									break
								}
								else if (basic.subtype == local_GodBefallDefine.COM_SUBTYPE) {
									model.CheckQuickComRedStatus()
									model.Fire(local_GodBefallEvent.UPDATE_GOODS_RED)
									local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
									break
								}
							}
							else if (basic.type == local_GodBefallDefine.EQUIP_TYPE) {
								model.CheckEquipRedStatus()
								model.CheckQuickComRedStatus()
								model.CheckAutoComposeRed()
								model.CheckShenGeRed()
								model.Fire(local_GodBefallEvent.UPDATE_GOODS_RED)
								local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
								break
							}
						}
					}
				}
			)
			local_GlobalEventSystem.Bind(
				SceneManager.START, () => {
					this.SendFmtToGame(44010)
				}
			)
			/*
			local_GlobalEventSystem.Bind(LoginStateEvent.SHOW_LOGIN_VIEW, () => {
				// 登出就会被踢出
				model.CleanGodInfo()
			})
			*/

			//切换角色
			local_GlobalEventSystem.Bind(EventName.CHANGE_ROLE, () => {
				model.CleanGodInfo()
			})
		}

		this.InitInfo = () => {
			let on44000 = () => {
				let scmd = user_msg_adapter.GetSCMD(44000)
				model.SetGodInfo(scmd)
				model.CheckAutoComposeRed()
				model.CheckShenGeRed()
			}

			let on44001 = () => {
				let scmd = user_msg_adapter.GetSCMD(44001)
				model.SetGodVoInDic(scmd.god_id, scmd)
				SkillUIModel.GetInstance().PreLoadSkillEffectRes(null,scmd.god_id)
			}

			let on44002 = () => {
				let scmd = user_msg_adapter.GetSCMD(44002)
				if (scmd.errcode == 1) {
					model._cur_battle_id = scmd.god_id
					model.Fire(local_GodBefallEvent.ACTIVE_SUCCESS, scmd.god_id)
					let data = model.GetGodData(scmd.god_id)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBefallActiveTipsView", scmd)
					this.SendFmtToGame(44001, "i", scmd.god_id)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on44003 = () => {
				let scmd = user_msg_adapter.GetSCMD(44003)
				if (scmd.errcode == 1) {
					model.Fire(local_GodBefallEvent.UPGRADE_SUCCESS, scmd)
					model.SetGodVoInDic(scmd.god_id, scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
					model.Fire(local_GodBefallEvent.UPGRADE_FAIL, scmd)
				}
			}

			let on44004 = () => {
				let scmd = user_msg_adapter.GetSCMD(44004)
				if (scmd.errcode == 1) {
					model.ClearGodSkillList()
					model.SetGodVoInDic(scmd.god_id, scmd)
					let data = model.GetGodData(scmd.god_id)
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "GodBefallStageTipsView", scmd)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on44005 = () => {
				let scmd = user_msg_adapter.GetSCMD(44005)
				if (scmd.errcode == 1) {
					model.SetGodVoInDic(scmd.god_id, scmd)
					model.Fire(local_GodBefallEvent.STAR_SUCCESS, scmd)
					this.SendFmtToGame(44001, "i", scmd.god_id)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on44006 = () => {
				let scmd = user_msg_adapter.GetSCMD(44006)
				if (scmd.errcode == 1) {
					local_Message.show("出战成功")
					let rinfo = model.GetGodInfo()
					if (rinfo) {
						for (let _tmpi in rinfo.god_list) {
							var vo = rinfo.god_list[_tmpi]
							if (vo.god_id == scmd.god_id) {
								vo.is_battle = 1
							}
							else if (vo.is_battle == 1) {
								vo.is_battle = 0
							}
						}
					}
					model._cur_battle_id = scmd.god_id
					SkillUIModel.GetInstance().PreLoadSkillEffectRes(null,scmd.god_id)
					model.Fire(local_GodBefallEvent.UPDATE_BATTLE_ID, scmd.god_id)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on44010 = () => {
				let scmd = user_msg_adapter.GetSCMD(44010)
				model.SetGodTime(scmd)
				model.Fire(local_GodBefallEvent.KEEP_TIME, scmd)
			}

			let on44011 = () => {
				let scmd = user_msg_adapter.GetSCMD(44011)
				if (scmd.errcode == 1) {
					this.SendFmtToGame(44010)
					SkillUIModel.GetInstance().ReleaseGodBefallSkillTip(scmd.god_id)
				} else {
					Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let on44012 = () => {
				let scmd = user_msg_adapter.GetSCMD(44012)
				if (scmd.code == 1) {
					local_Message.show("穿戴成功")
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on44013 = () => {
				let scmd = user_msg_adapter.GetSCMD(44013)
				if (scmd.code == 1) {
					local_Message.show("卸下成功")
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on44014 = () => {
				let scmd = user_msg_adapter.GetSCMD(44014)
				if (scmd.code == 1) {
					local_Message.show("合成成功")
					model.Fire(local_GodBefallEvent.COM_SUCCESS, scmd)
					let rule_id = scmd.rule_id
					let c = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_compose.name, rule_id, false)
					//let com_cfg = CompositeModel.GetInstance().goods_compose_cfg
					if (c && c.type == local_GodBefallDefine.COM_TYPE_ID) {
						let com_id = ErlangParser.GetInstance().Parse(c.goods)
						let com = [0, com_id[0][1], 1, scmd.goods_id]
						let success_view = new CongratulationObtainView([com], 10)
						success_view.Open()
					}
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on44015 = () => {
				let scmd = user_msg_adapter.GetSCMD(44015)
				model.Fire(local_GodBefallEvent.UPDATE_NO_POWER, scmd)
			}

			let on44016 = () => {
				let scmd = user_msg_adapter.GetSCMD(44016)
				if (scmd.code == 1) {
					model.CheckAutoComposeRed()
					this.ShowRankBreachReward(scmd.goods_list)
					model.Fire(local_GodBefallEvent.UPDATE_AUTO_COMPOSE_VIEW)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let on44017 = () => {
				let scmd = user_msg_adapter.GetSCMD(44017)
				model.SetStrongGodDic(scmd)
				model.CheckShenGeRed()
				model.Fire(local_GodBefallEvent.UPDATE_STRONG_GOD_VIEW, scmd.god_type)
			}

			let on44018 = () => {
				let scmd = user_msg_adapter.GetSCMD(44018)
				if (scmd.code == 1) {
					model.SetStrongGodDic(scmd)
					model.Fire(local_GodBefallEvent.UPDATE_STRONG_GOD_VIEW)
					model.Fire(local_GodBefallEvent.STRONG_SUCCESS, scmd.is_divide)
					model.CheckShenGeRed()
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(44000, on44000)
			this.RegisterProtocal(44001, on44001)
			this.RegisterProtocal(44002, on44002)
			this.RegisterProtocal(44003, on44003)
			this.RegisterProtocal(44004, on44004)
			this.RegisterProtocal(44005, on44005)
			this.RegisterProtocal(44006, on44006)
			this.RegisterProtocal(44010, on44010)
			this.RegisterProtocal(44011, on44011)
			this.RegisterProtocal(44012, on44012)
			this.RegisterProtocal(44013, on44013)
			this.RegisterProtocal(44014, on44014)
			this.RegisterProtocal(44015, on44015)
			this.RegisterProtocal(44016, on44016)
			this.RegisterProtocal(44017, on44017)
			this.RegisterProtocal(44018, on44018)
		}

		this.InitInfo()
		this.InitEvent()
		this.ShowRankBreachReward = (list?) => {
			let data = []
			for (let _tmpi in list) {
				var reward = list[_tmpi]
				let vo = []
				table.insert(vo, reward.goods_type)
				table.insert(vo, reward.goods_type_id)
				table.insert(vo, reward.goods_num)
				table.insert(data, vo)
			}
			if (data.length > 0) {
				let view = new CongratulationObtainView(data, 10)
				view.Open()
			}
		}
	}
}
window["GodBefallController"] = GodBefallController