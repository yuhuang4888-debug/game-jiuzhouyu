import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { CompositeModel } from "../commonModel/CompositeModel"
import { CommonManager } from "../common/CommonManager"
import { ResManager } from "../common/ResManager"

import "./CompositeGoodsView"
import "./CompositeRuneView"
import "./CompositeHolySealView"
import "./GodBeastCompositeView"
import "./CompositeUnrealView"
import "./CompositeRevelationView"
import "./CompositeGuardView"
import "./RuneSelectMatView"
import "./SelectGodBeastView"
import "./SelectUnrealMatView"
import "./GodBefallCompositeView"
import "../godCourt/GodCourtComView"
import "./CompositeLonglangView"

export class CompositeView extends BaseWindowComponent {
	CheckUnrealRedDot
	_Local_Close
	_Local_Open
	money_list
	tabStrList
	tab_new_cond
	titleList
	viewClassList
	viewClassModuleDic
	cfg_menu
	cfg_menu_id
	res_mgr

	public constructor() {
		super()
		this.preload_server_config = {
			"config_compose_menu": false,
			"config_compose_menu_id": false
		}

		this.res_mgr = ResManager.GetInstance()
		let compositemodel = CompositeModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let composite_index = CompositeModel.Index
		let local_CompositeModel = CompositeModel

		this.dependent_res = ["composite", "redequip", "newgameui"]
		this.tabStrList = [
			{ label: "道具合成" },
			{ label: "御魂合成" },
			{ label: "影装合成" },
			//{label : "源力合成"},
			{ label: "蜃装合成" },
			{ label: "灵饰合成" },
			{ label: "神器合成" },
			//{label : "宝具合成"},
			{ label: "天启合成" },
			{ label: "守护合成" },
			{ label: "神社合成" },
			{ label: "神祭合成" }
		]

		this.viewClassList = [
			"CompositeGoodsView",
			"CompositeRuneView",
			"CompositeHolySealView",
			//CompositeSoulView,
			"GodBeastCompositeView",
			"CompositeUnrealView",
			"GodBefallCompositeView",
			//window["BabyCompositeView"],
			"CompositeRevelationView",
			"CompositeGuardView",
			"GodCourtComView",
			"CompositeLonglangView"
		]
		this.titleStr = "composite.ui_title_merge"
		this.bg_list = [
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg"
		]
		this.money_list = [2, 1, 0]
		this.tab_new_cond = {
			[10]: () => {
				return CommonManager.GetInstance().CheckFuncOpenState("CompositeGuardView", true)
			}
		}
		this.viewClassModuleDic = {
			//[7] = [module_name = "baby", class_name = "BabyCompositeView"]
		}

		this.window_load_back = () => {
			this.cfg_menu_id = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu_id", false)
			this.cfg_menu = this.res_mgr.GetGameConfigFromCache(this, "config_compose_menu", false)
		}

		this.window_open_back = () => {
			let rune_red = compositemodel.RuneComposeRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Rune, rune_red)

			this.BindVar(
				compositemodel,
				"rune_red_dot", (event_name?, now_value?) => {
					local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Rune, now_value)
				}
			)

			this.CheckUnrealRedDot()

			let godbeast_red = compositemodel.GodBeastReddot(this.cfg_menu, this.cfg_menu_id)
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.GodBeast, godbeast_red)
			this.BindVar(compositemodel, "godbeast_red_dot", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.GodBeast, now_value)
			}
			)
			//let soul_red = compositemodel.RefreshSoulRedDot()
			//local_GlobalEventSystem:Fire(update_window_red_event, "CompositeView", composite_index.Soul, soul_red)
			//this:BindVar(compositemodel, "soul_red_dot",(event_name?, now_value?) => {
			//local_GlobalEventSystem:Fire(update_window_red_event, "CompositeView", composite_index.Soul, now_value)
			//}
			//)

			let holy_seal_red = compositemodel.GetHolySealRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.HolySeal, holy_seal_red)

			this.BindVar(compositemodel, "holy_seal_red_dot", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.HolySeal, now_value)
			})

			let goods_red = compositemodel.RefreshGoodsRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Goods, goods_red)
			this.BindVar(
				compositemodel,
				"goods_red_dot", (event_name?, now_value?) => {
					local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Goods, now_value)
				}
			)

			let god_red = compositemodel.GodReddot(this.cfg_menu, this.cfg_menu_id)
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.God, god_red)
			this.BindVar(compositemodel, "god_red_dot", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.God, now_value)
			})

			//let baby_red = compositemodel.babyComRed
			//local_GlobalEventSystem:Fire(update_window_red_event, "CompositeView", composite_index.Baby, baby_red)
			//this:BindVar(compositemodel, "babyComRed",(event_name?, now_value?) => {
			//local_GlobalEventSystem:Fire(update_window_red_event, "CompositeView", composite_index.Baby, now_value)
			//}
			//)
			let revelationRed = compositemodel.GetRevelationRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Revelation, revelationRed)
			this.BindVar(compositemodel, "revelation_red_dot", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Revelation, now_value)
			}
			)
			let guardRed = compositemodel.GetGuardRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Guard, guardRed)
			this.BindVar(compositemodel, "guard_red_dot", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Guard, now_value)
			}
			)

			let longlang_red = compositemodel.GetLonglangRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Longlang, longlang_red)
			this.BindVar(compositemodel, "longlang_red_dot", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Longlang, now_value)
			}
			)
			let gocCourtRed = compositemodel.godCourtComRed
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.GodCourt, gocCourtRed)
			this.BindVar(compositemodel, "godCourtComRed", (event_name?, now_value?) => {
				local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.GodCourt, now_value)
			}
			)

			//this.AddPreLoadList("newgameui", { "UIVerTabBar", "UIVerTabBtn", "UIVerTabSubBtn"})
		}

		this._Local_Open = (parms?) => {
			let index = parms
			if (index != null) {
				this.SetDefaultIndex(index)
			}
			super.Open()
		}

		this._Local_Close = () => {
			super.Close()
			compositemodel.Fire(local_CompositeModel.COLSE_CHOSE_EQUIPMENT_VIEW)
			compositemodel.Fire(local_CompositeModel.CLOSE_CHOSE_GODBEAST_VIEW)
			compositemodel.Fire(local_CompositeModel.CLOSE_CHOSE_GOD_VIEW)
		}

		this.CheckUnrealRedDot = () => {
			let unreal_red = compositemodel.GetUnrealRedDot()
			local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Unreal, unreal_red)

			this.BindVar(
				compositemodel,
				"unreal_red_dot", (event_name?, now_value?) => {
					local_GlobalEventSystem.Fire(update_window_red_event, "CompositeView", composite_index.Unreal, now_value)
				}
			)
		}
	}

	public Open(...new_args) {
		this._Local_Open(...new_args)
	}

	public Close() {
		this._Local_Close()
	}
}
window["CompositeView"] = CompositeView