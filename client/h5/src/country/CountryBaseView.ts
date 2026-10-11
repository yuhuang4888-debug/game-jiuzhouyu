import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Set3DPosition, SetAnchoredPositionY } from './../util/Util';


export enum SeaTabIndex {
	Info = 0,
	Political = 1,
	Soldier = 2,
	Fight = 3,
	Assert = 4,
	King = 5
}
window["SeaTabIndex"] = SeaTabIndex

export class CountryBaseView extends BaseWindowComponent {
	AssertRed
	InitWindowEvent
	ReFightRed
	ReKingRed
	ReSoldierRed
	RefreshInfoRed
	SelectView
	_Local_Open
	back_login_toClose
	bg_list
	destroy_imm
	instruction_list
	money_list
	tabStrList
	titleStr
	viewClassList
	viewClassModuleDic
	window_load_back

	public constructor() {
		super()
		//let local_InstructionType = InstructionType
		//let local_KfViewIndex = KfViewIndex
		let local_GlobalEventSystem = GlobalEventSystem
		let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		//let eternity_model = EternityModel.GetInstance()
		//let boss_model = BossBaseModel.GetInstance()
		let seahege_model = SeaHegemonyModel.GetInstance()
		let g_seahege_model = SeaHegemonyModel
		//let cacheIndex = null
		this.dependent_res = ["country", "seaHegemony"]
		this.destroy_imm = true
		this.back_login_toClose = true
		this.tabStrList = [
			{ label: "海域信息" },
			{ label: "海域内政" },
			{ label: "海王禁卫" },
			{ label: "海王争夺" },
			{ label: "海域日常" },
			{ label: "海域霸主" }
		]
		this.viewClassList = [
			"CountryInfoView",
			"CountryPoliticalView",
			"SeaSoldierView",
			"CountryFightView",
			"SeaAssertView",
			"CountryKingView"
		]
		this.titleStr = "country.ui_shbz_009"
		this.bg_list = [
			"ui_shzb_001.jpg",
			"ui_shzb_077.jpg",
			"ui_shzb_018_720x1222.jpg",
			"ui_shzb_033.jpg",
			"uisdbz_013.jpg",
			"ui_shzb_010.jpg"
		]

		this.viewClassModuleDic = [
			{ module_name: "country", class_name: "CountryInfoView" },
			{ module_name: "country", class_name: "CountryPoliticalView" },
			{ module_name: "seaHegemony", class_name: "SeaSoldierView" },
			{ module_name: "country", class_name: "CountryFightView" },
			{ module_name: "seaAssert", class_name: "SeaAssertView" },
			{ module_name: "country", class_name: "CountryKingView" }
		]
		this.money_list = [2, 1, 0]
		this.instruction_list = [18602, 18603, 18604, 18605, 18601, 18606]
		this.window_load_back = () => {
			this.InitWindowEvent()
		}

		this.RefreshInfoRed = () => {
			let bool = seahege_model.dailyRewardRed
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CountryBaseView", SeaTabIndex.Info, bool)
		}

		this.ReSoldierRed = () => {
			let bool = seahege_model.isSeaKing && seahege_model.applyRed
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CountryBaseView", SeaTabIndex.Soldier, bool)
		}

		this.ReFightRed = () => {
			let bool = seahege_model.nomalActiveRed
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CountryBaseView", SeaTabIndex.Fight, bool)
		}

		this.AssertRed = () => {
			let bool = seahege_model.GetAssertRed()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CountryBaseView", SeaTabIndex.Assert, bool)
		}

		this.ReKingRed = () => {
			let bool = seahege_model.kingActiveRed
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "CountryBaseView", SeaTabIndex.King, bool)
		}

		this.InitWindowEvent = () => {
			this.RefreshInfoRed()
			this.ReKingRed()
			this.ReSoldierRed()
			this.AssertRed()
			this.ReFightRed()

			let RefreshSeaRed = (type?) => {
				if (type == SeaTabIndex.Info) {
					this.RefreshInfoRed()
				}
				else if (type == SeaTabIndex.Soldier) {
					this.ReSoldierRed()
				}
				else if (type == SeaTabIndex.Fight) {
					this.ReKingRed()
					this.ReFightRed()
				}
				else if (type == SeaTabIndex.Assert) {
					this.AssertRed()
				}
			}
			this.BindEvent(seahege_model, g_seahege_model.REFRESH_RED, RefreshSeaRed)

			this.BindEvent(seahege_model, g_seahege_model.CHANGE_BG, () => {
				if (this.nowSelectIndex == SeaTabIndex.Info) {
					let isToday = seahege_model.StartTime != 0
					let bgUrl = (seahege_model.hasJoinSea && (isToday || seahege_model.hasFight) && ("ui_shzb_001") || ("ui_shzb_033"))
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(bgUrl + ".jpg"))
				}

				else if (this.nowSelectIndex == SeaTabIndex.Fight) {
					let bgUrl = seahege_model.StartTime != 0 ? ("ui_shzb_029") : ("ui_shzb_033")
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(bgUrl + ".jpg"))
				}
			})

			let swtich_fun = (...new_args) => {
				let params = new_args
				if (params && params[1]) {
					this.SetSelectIndex(params[1])
				} else {
					this.SetSelectIndex(0)
				}
			}
			this.BindEvent(seahege_model, g_seahege_model.SWITCH_VIEW, swtich_fun)
		}

		this.SelectView = (index?, is_real_index?) => {
			if (is_real_index == null) {
				is_real_index = false
			}

			SetAnchoredPositionY(this._img_bg, index == SeaTabIndex.Assert ? 65 : 80);

			let isToday = seahege_model.StartTime != 0

			if (!seahege_model.hasJoinSea && index != 0) {
				if (seahege_model.hasFight) {
					Message.show("请先加入海域")
				} else {
					Message.show("海域未开启")
				}
				index = 0
				this.SetSelectIndex(index)
				return
			}

			if (index == SeaTabIndex.Soldier && !seahege_model.isShowPoliticalView) {
				Message.show("敬请期待")
				let tmpIndex = this.nowSelectIndex == 0 ? 0 : this.nowSelectIndex
				this.LocalSelectView(tmpIndex)
				return
			}
			this.LocalSelectView(index, is_real_index)
			if (index == SeaTabIndex.Fight) {
				let bgUrl = isToday ? ("ui_shzb_029") : ("ui_shzb_033")
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(bgUrl + ".jpg"))
			}
			else if (index == SeaTabIndex.Info) {
				let bgUrl = (seahege_model.hasJoinSea && (/*isToday ||*/ seahege_model.hasFight) && ("ui_shzb_001") || ("ui_shzb_033"))
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(bgUrl + ".jpg"))
			}
			// else if (index == SeaTabIndex.Assert) {
			// 	let bgUrl = (seahege_model.hasJoinSea && (/*isToday ||*/ seahege_model.hasFight) && ("ui_shzb_001") || ("ui_shzb_033"))
			// 	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath(bgUrl + ".jpg"))
			// }
		}

		this._Local_Open = (param?) => {
			if (param && param[0] != null) {
				this.SetDefaultIndex(param[0])
			}
			super.Open()
			seahege_model.Fire(g_seahege_model.REQUEST_PROTO, 18654, "hh", 1, 1)
		}
	}

	public Open(...new_args) {
		let params = new_args
		this._Local_Open(params)
	}
}
window["CountryBaseView"] = CountryBaseView