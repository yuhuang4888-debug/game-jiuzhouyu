import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { GodBefallModel, GodBefallEvent } from "../commonModel/GodBefallModel"
import { InstructionType } from "../common/InstructionType"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { chcModel } from "../commonModel/chcModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"

import "../godBefall/GodBefallMainView"
import "../godCourt/GodCourtView"
import "../starEquip/StarEquipView"

export class StarEquipMainView extends BaseWindowComponent {
	CheckGodRed
	_Local_Open
	bg_list
	instruction_list
	money_list
	tabStrList
	titleList
	viewClassList
	window_open_back

	public static TabIndex = {
		GodBefall : 0,
		GodCourt : 1,
		starEquip : 2
	}
	public constructor() {
		super()
		this.destroy_imm = true
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName

		this.dependent_res = ["starEquip"]
		this.tabStrList = [
			{ label: "降神"},
			{ label: "神社"},
			{ label: "圣衣"}
		]
		this.bg_list = ["ui_shape_bg3.jpg", "ui_role_bg5.jpg","uixzsy_001.jpg"]

		this.viewClassList = [
			"GodBefallMainView",
			"GodCourtView",
			"StarEquipView"
		]
		this.money_list = [2, 1, 0]
		this.titleList = [
			"starEquip.uijs_001",
			"starEquip.ui_title_Divine",
			"starEquip.uixzsy_020"
		]
		this.instruction_list = [
			InstructionType.God,
		]

		this.window_open_back = () => {
			let UpdateStarEquipRed = () => {
				let starEquipRed = StarEquipModel.GetInstance().GetRedDot()
				local_GlobalEventSystem.Fire(
					local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
					"StarEquipMainView",
					StarEquipMainView.TabIndex.starEquip,
					starEquipRed
				)
			}
			this.BindEvent(StarEquipModel.GetInstance(), StarEquipModel.REFRESH_RED, UpdateStarEquipRed, true)
			this.BindEvent(chcModel.GetInstance(), chcModel.UPDATE_RED, UpdateStarEquipRed)

			let godCourtRedDot = () => {
				let show = GodCourtModel.GetInstance().ShowRed()
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "StarEquipMainView", StarEquipMainView.TabIndex.GodCourt, show)
			}
			this.BindEvent(GodCourtModel.GetInstance(), GodCourtModel.REFRESH_RED, godCourtRedDot, true)

			this.CheckGodRed()
		}
		
		this.window_clsoe_back = () => {
			GodBefallModel.GetInstance().Fire(GodBefallEvent.STOP_GOD_SOUND)
		}

		this.CheckGodRed = () => {
			let local_godModelIns = GodBefallModel.GetInstance()
			let local_godEvent = GodBefallEvent
			let local_goodsModel = GoodsModel
			let red = local_godModelIns.GetAllRedStatus()
			local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "StarEquipMainView", StarEquipMainView.TabIndex.GodBefall, red)
			if (red) {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
			}
			let updateRed = () => {
				let red = local_godModelIns.GetAllRedStatus()
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "StarEquipMainView", StarEquipMainView.TabIndex.GodBefall, red)
				if (red) {
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Help)
				}
			}

			this.BindVar(local_godModelIns, "_god_info", updateRed)
			this.BindEvent(local_godModelIns, local_godEvent.UPDATE_GOD_VO, updateRed)
			this.BindEvent(local_godModelIns, local_godEvent.UPDATE_GOODS_RED, updateRed)
			this.BindEvent(local_goodsModel.GetInstance(), local_goodsModel.CHANGE_GOD_LIST, updateRed)
			this.BindEvent(local_goodsModel.GetInstance(), local_goodsModel.CHANGE_GOD_BAG_LIST, updateRed)
		}

		this._Local_Open = (param?) => {
			if (param && param.length > 0) {
				this.SetDefaultIndex(param[0])
			}
			super.Open()
		}
	}

	public Open(...new_args) {
		let params = new_args
		this._Local_Open(params)
	}
}
window["StarEquipMainView"] = StarEquipMainView