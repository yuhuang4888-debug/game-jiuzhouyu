import { Util, PlayBigEffect } from "../util/Util"
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SceneManager } from "../scene/SceneManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Config } from "../common/Config"
import { GuardModel } from "../commonModel/GuardModel"
import { ViewManager } from "../common/ViewManager"
import { EnumViewOrder, ViewOrderModel } from "../commonModel/ViewOrderModel"
import "../guard/GuardMainView"
import "../guard/GuardExperienceView"
import "../guard/GuardActivateView"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"

export class GuardController extends BaseController {
	InitEvent
	InitInfo
	is_game_start
	view_dic

	public constructor() {
		super()
		this.view_dic = []
		let model = GuardModel.GetInstance()
		let local_GuardModel = GuardModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		let scene_mgr = SceneManager.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let user_msg_adapter = UserMsgAdapter.GetInstance()

		this.InitEvent = () => {
			model.Bind(local_GuardModel.REQUEST_SCMD, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			})

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.is_game_start = true
				if (model.experience_cache) {
					model.Fire(local_GuardModel.OPEN_EXPERIENCE_VIEW, "GuardExperienceView", model.experience_cache.lv)
					model.experience_cache = null
				}
				this.SendFmtToGame(21606)
			})

			let open_view = (view_name: string, arg?) => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true
					/*
					if (!window[view_name]) {
						if (!ResManager.GetInstance().IsJsLoad("guard")) {
						}
					}
					*/
					if (this.view_dic[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
					}
				}
				if (view) {
					if ("GuardActivateView" == view_name) {
						if (arg) {
							// let viewMag: ViewManager = ViewManager.GetInstance();
							// if (viewMag.GetView('kfStageOpenView')?.isPop || viewMag.GetView('kfStageShowView')?.isPop || viewMag.GetView('OutLineView')?.isPop) {
							// 	ViewOrderModel.GetInstance().SetTypeByView(EnumViewOrder.eGuardExpired, { viewName: 'GuardActivateView', arg: arg });
							// } else {
							// 	/* view.Open(arg); */
							// 	// 为了统一管理
							// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuardActivateView", arg);
							// }
							// 为了统一管理
							ViewPopLevelModel.GetInstance().SetView('GuardActivateView', arg);
						}
					} else if ("GuardExperienceView" == view_name) {
						if (arg) {
							view.SetGuardType(arg)
							view.Open()
						}
					} else if ("GuardMainView" == view_name) {
						if (arg) {
							view.SetGuardType(arg)
							view.Open()
						}
					}
				}
			}
			model.Bind(local_GuardModel.OPEN_ACTIVATE_VIEW, open_view)
			model.Bind(local_GuardModel.OPEN_EXPERIENCE_VIEW, open_view)

			model.Bind(local_GuardModel.OPEN_VIEW, (lv?) => {
				if (!lv) {
					lv = 1
				}
				open_view("GuardMainView", lv)
			}
			)
			let scene_changed_func = () => {
				if (model.experience_cache && !scene_mgr.IsDungeonScene()) {
					model.Fire(local_GuardModel.OPEN_EXPERIENCE_VIEW, "GuardExperienceView", model.experience_cache.lv)
					model.experience_cache = null
				}
				if (model.unactive_cache.length > 0 && !scene_mgr.IsDungeonScene()) {
					model.Fire(local_GuardModel.OPEN_ACTIVATE_VIEW, "GuardActivateView", model.unactive_cache)
					model.unactive_cache = []
				}
			}

			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (list?) => {
				/*
				model.GetGameConfig("Magiccircle", (cfg?) => {
					if (cfg) {
						for (let i in list) {
							for (let key in cfg) {
								let cost = cfg[key].cost
								if (typeof (cost) == "string") {
									cost = ErlangParser.GetInstance().Parse(cost)
								}
								if (cost) {
									cost = (cost[0] && cost[0][1]) && cost[0][1][0]
								}
								if (cost && Number(cost[1]) == list[i].type_id) {
									model.Fire(local_GuardModel.UPDATA_VIEW)
									model.RefreshRed(cfg[key].magic_circle_lv, cfg)
								}
							}
						}
					}
					model.DestoryGameConfig("Magiccircle")
				}, false)
				*/

				let cfg = Config.PRELOAD_SERVER_CONFIG.config_magic_circle
				if (cfg) {
					for (let i in list) {
						for (let key in cfg) {
							let cost = cfg[key].cost
							if (typeof (cost) == "string") {
								cost = JSON.parse(cost)
							}
							if (cost) {
								cost = (cost[0] && cost[0][1]) && cost[0][1][0]
							}
							if (cost && Number(cost[1]) == list[i].type_id) {
								model.Fire(local_GuardModel.UPDATA_VIEW)
								model.RefreshRed(cfg[key].magic_circle_lv, cfg)
							}
						}
					}
				}
			}
			)
			goods_model.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, () => {
				/*
				model.GetGameConfig("Magiccircle", (cfg?) => {
					if (cfg) {
						for (let key in cfg) {
							model.Fire(local_GuardModel.UPDATA_VIEW)
							model.RefreshRed(cfg[key].magic_circle_lv, cfg)
						}
					}
					model.DestoryGameConfig("Magiccircle")
				}
				)
				*/

				let cfg = Config.PRELOAD_SERVER_CONFIG.config_magic_circle
				if (cfg) {
					for (let key in cfg) {
						model.Fire(local_GuardModel.UPDATA_VIEW)
						model.RefreshRed(cfg[key].magic_circle_lv, cfg)
					}
				}
			}
			)
		}

		this.InitInfo = () => {
			let On21600 = () => {
				let scmd = user_msg_adapter.GetSCMD(21600)
				Util.ErrorCodeShow(scmd.errcode)
			}

			let On21601 = () => {
				let scmd = user_msg_adapter.GetSCMD(21601)
				let magic_circle_cfg = Config.PRELOAD_SERVER_CONFIG.config_magic_circle
				if (magic_circle_cfg) {
					model.SetGuardInfo(scmd.magic_circle, magic_circle_cfg)
					model.is_frist_21601 = false
					model.Fire(local_GuardModel.UPDATA_VIEW)
					//CompositeModel.GetInstance().RefreshGuardRedDot()
				}
			}

			let On21602 = () => {
				let scmd = user_msg_adapter.GetSCMD(21602)
				if (scmd.code == 1) {
					PlayBigEffect("ui_ZiTi_Jihuo", {x:0, y:-1.5})
				}
			}

			let On21603 = () => {
				let scmd = user_msg_adapter.GetSCMD(21603)
				if (scene_mgr.IsDungeonScene() || !this.is_game_start) {
					model.experience_cache = scmd
				} else {
					model.Fire(local_GuardModel.OPEN_EXPERIENCE_VIEW, "GuardExperienceView", scmd.lv)
				}
			}

			let On21604 = () => {
				let scmd = user_msg_adapter.GetSCMD(21604)
				let role_vo = scene_mgr.GetRoleVo(scmd.role_id)
				if (role_vo) {
					role_vo.ChangeVar("fazhen_id", scmd.magic_circle_id)
				}
			}

			let On21606 = () => {
				let scmd = user_msg_adapter.GetSCMD(21606)
				Util.ErrorCodeShow(scmd.errcode)
			}

			this.RegisterProtocal(21600, On21600)
			this.RegisterProtocal(21601, On21601)
			this.RegisterProtocal(21602, On21602)
			this.RegisterProtocal(21603, On21603)
			this.RegisterProtocal(21604, On21604)
			this.RegisterProtocal(21606, On21606)
		}

		this.InitInfo()
		this.InitEvent()
	}
}

window["GuardController"] = GuardController