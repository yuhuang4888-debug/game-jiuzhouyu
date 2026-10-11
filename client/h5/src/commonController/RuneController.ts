import { Alert, Alert_Type } from "../alert/Alert"
import { BaseController } from "../common/BaseController"
import { BaseViewInterface } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { MaterialsTool } from "../common/MaterialsTool"
import { OpenFun } from "../common/OpenFun"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneEvent, RuneModel } from "../commonModel/RuneModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PlayBigEffect, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import "../rune/SecretTreasureMainView"
import "../rune/RuneDecMainView"
import "../rune/RunePropertyView"
import "../rune/RuneBagView"
import "../rune/RuneConvertView"
import "../rune/RuneAwakenView"
import "../rune/RuneSkillView"
import { CompositeModel } from "../commonModel/CompositeModel"

export class RuneController extends BaseController {
	InitEvent
	InitInfo
	static Instance: any

	public constructor() {
		super()

		let goods_model = GoodsModel.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let model = RuneModel.GetInstance()
		let view_dic_ = []
		this.InitEvent = () => {
			GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_RUNE_BAG_LIST, (add?) => {
				if (!add) {
					return
				}
				let dic = goods_model.GetRuneBagDic()
				if (!dic || Util.TableSize(dic, true) <= 0) {
					return
				}
				let num = Util.TableSize(dic, true)
				if (num >= model.max_bag_goods_num) {
					Alert.Show("御魂背包空间不足,请尽快前往整理背包.", Alert_Type.One, () => {
						OpenFun.OpenFunHandler(110)
						model.Fire(RuneEvent.OPEN_VIEW, "RuneDecMainView")
					}, null, "前往分解")
				}
			})

			model.Bind(RuneEvent.RUNE_REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			})

			model.Bind(RuneEvent.REQUEST_RESOLVE_PREVIEW, (list?) => {
				if (list) {
					this.WriteBegin(16706)
					this.WriteFMT("h", list.length)
					for (let _tmpi in list) {
						var id = list[_tmpi]
						this.WriteFMT("l", id)
					}
					this.SendToGame()
				}
			})

			model.Bind(RuneEvent.GET_COMPOSE_PREVIEW, (list?) => {
				if (list) {
					this.WriteBegin(16705)
					this.WriteFMT("l", list.rule_id)
					this.WriteFMT("h", list.regular_glist.length)
					for (let _tmpi in list.regular_glist) {
						var id = list.regular_glist[_tmpi]
						this.WriteFMT("l", id)
					}
					this.SendToGame()
				}
			})

			model.Bind(RuneEvent.OPEN_VIEW, (view_class_name, ...new_args) => {
				let view = view_dic_[view_class_name]
				if (!view) {
					let view_class: any = window[view_class_name]
					view = new view_class()
					view_dic_[view_class_name] = view
				}
				if (view) {
					if (view.HasOpen()) {
						view.Close()
					} else {
						view.Open(...new_args)
					}
				}
			})

			GlobalEventSystem.Bind(EventName.GAME_START, async () => {
				await model.InitConfig()
				model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16700)
				model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16704)
			}
			)
			model.Bind(RuneEvent.RUNE_AWAKEN, (goods_id?, attr_id?, list?) => {
				this.WriteBegin(16707)
				this.WriteFMT("l", goods_id)
				this.WriteFMT("h", attr_id)
				this.WriteFMT("h", list.length)
				for (let _tmpi in list) {
					var good_id = list[_tmpi]
					this.WriteFMT("l", good_id)
				}
				this.SendToGame()
			}
			)
			model.Bind(RuneEvent.RUNE_RESOLUTION, (list?) => {
				if (list) {
					this.WriteBegin(16708)
					this.WriteFMT("h", list.length)
					for (let _tmpi in list) {
						var good_id = list[_tmpi]
						this.WriteFMT("l", good_id)
					}
					this.SendToGame()
				}
			}
			)
			model.Bind(RuneEvent.RESOLUTION_PREVIEW, (list?) => {
				if (list) {
					this.WriteBegin(16709)
					this.WriteFMT("h", list.length)
					for (let _tmpi in list) {
						var good_id = list[_tmpi]
						this.WriteFMT("l", good_id)
					}
					this.SendToGame()
				}
			}
			)
			model.Bind(RuneEvent.UPDATE_RUNE_SKILL, () => {
				this.SendFmtToGame(16710)
			}
			)
			let skillFunc = () => {
				let obj = Config.PRELOAD_SERVER_CONFIG.config_rune_awake_skill
				let info = model.rune_info
				if (info) {
					model.CanActiveSkill(obj)
				}
			}

			let dot_fun = () => {
				model.CanInsert()
				model.CanUpgrade()
				model.CanResolve()
				model.CanExchange()
				model.WaitCompositeBack()
			}

			model.Bind(RuneEvent.UPDATE_RUNE_DATA, () => {
				skillFunc()
				dot_fun()
			}
			)
			goods_model.Bind(GoodsModel.CHANGE_RUNELIST, dot_fun)
			goods_model.Bind(GoodsModel.CHANGE_RUNE_BAG_LIST, dot_fun)
			model.Bind(RuneEvent.UPDTE_RUNE_CONVERT_VIEW, dot_fun)
		}

		this.InitInfo = () => {
			let Handler16700 = () => {
				let scmd = user_msg_adapter.GetSCMD(16700)
				model.SetRuneInfo(scmd)
			}

			let Handler16701 = () => {
				let scmd = user_msg_adapter.GetSCMD(16701)
				if (scmd.code == 1) {
					Message.show("操作成功")
					model.Fire(RuneEvent.INSERT_SUCCESS)
					model.Fire(RuneEvent.CLOSE_BAG_VIEW)
					model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16700)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16702 = () => {
				let scmd = user_msg_adapter.GetSCMD(16702)
				if (scmd.code == 1) {
					Message.show("升级成功")
					model.Fire(RuneEvent.UPGRADE_SUCCESS)
					model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16700)
				} else {
					Util.ErrorCodeShow(scmd.code)
					// if (scmd.code == 1670009) {
					// 	let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods
					// 	if (cfg && cfg[10]){
					// 		MaterialsTool.GetInstance().materialsTips(cfg[10].goods_id)
					// 	}
					// }
				}
			}

			let Handler16703 = () => {
				let scmd = user_msg_adapter.GetSCMD(16703)
				if (scmd.code == 1) {
					Message.show("兑换成功")
					if (model.rune_info) {
						model.rune_info.rune_chip = scmd.rune_chip
					}
					model.Fire(RuneEvent.UPDTE_RUNE_CONVERT_VIEW)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16704 = () => {
				let scmd = user_msg_adapter.GetSCMD(16704)
				model.rune_tower_floor = scmd.rune_dungeon_level
				CompositeModel.GetInstance().RuneComposeRedDot()
				model.Fire(RuneEvent.UPDTE_RUNE_CONVERT_VIEW)
			}

			let Handler16705 = () => {
				let scmd = user_msg_adapter.GetSCMD(16705)
				if (scmd.code == 1) {
					model.Fire(RuneEvent.COMPOSE_PREVIEW_RETURN, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16706 = () => {
				let scmd = user_msg_adapter.GetSCMD(16706)
				if (scmd.code == 1) {
					model.Fire(RuneEvent.RESOLVE_PREVIEW, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16707 = () => {
				let scmd = user_msg_adapter.GetSCMD(16707)
				if (scmd.code == 1) {
					PlayBigEffect("ui_juexingtexiao")
					//Message.show("觉醒成功")
					let changeLv = model.ChangeRuneData(scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16708 = () => {
				let scmd = user_msg_adapter.GetSCMD(16708)
				if (scmd.code == 1) {
					PlayBigEffect("ui_chaifenchenggong")
					//Message.show("拆解成功")
					model.Fire(RuneEvent.RUNE_RESOLUTION_RETURN, scmd)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16709 = () => {
				let scmd = user_msg_adapter.GetSCMD(16709)
				if (scmd.code == 1) {
					model.Fire(RuneEvent.RESOLUTION_PREVIEW_RETURN, scmd.result_list)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16710 = () => {
				let scmd = user_msg_adapter.GetSCMD(16710)
				if (scmd.code == 1) {
					if (model.rune_info) {
						// [ts2lua]model.rune_info下标访问可能不正确
						model.rune_info["skill_lv"] = scmd.lv
						model.Fire(RuneEvent.SKILL_LV_UP)
						model.Fire(RuneEvent.UPDATE_RUNE_DATA)
						PlayBigEffect("ui_ZiTi_Jihuo")
					}
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler16711 = () => {
				let scmd = user_msg_adapter.GetSCMD(16711)
				console.warn("测试@16711",scmd)
				if (scmd.code == 1) {
					// Message.show("卸下成功")
					model.Fire(RuneEvent.RUNE_REQUEST_PROTO, 16700)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
			this.RegisterProtocal(16700, Handler16700)
			this.RegisterProtocal(16701, Handler16701)
			this.RegisterProtocal(16702, Handler16702)
			this.RegisterProtocal(16703, Handler16703)
			this.RegisterProtocal(16704, Handler16704)
			this.RegisterProtocal(16705, Handler16705)
			this.RegisterProtocal(16706, Handler16706)
			this.RegisterProtocal(16707, Handler16707)
			this.RegisterProtocal(16708, Handler16708)
			this.RegisterProtocal(16709, Handler16709)
			this.RegisterProtocal(16710, Handler16710)
			this.RegisterProtocal(16711, Handler16711)
		}

		this.InitInfo()
		this.InitEvent()
	}

	public static GetInstance() {
		if (!RuneController.Instance) {
			RuneController.Instance = new RuneController()
		}
		return RuneController.Instance
	}

}


window["RuneController"] = RuneController