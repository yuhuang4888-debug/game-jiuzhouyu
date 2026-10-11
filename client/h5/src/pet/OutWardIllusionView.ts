import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { OpenFun } from "../common/OpenFun"
import { OutWardController } from "../commonController/OutWardController"
import { enum_OutWardType, OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

import "./wings/WingsIllusionView"
import "./artifact/ArtifactIllusionView"
import "./holydevice/HolyDeviceIllusionView"
import "./backOrnament/BackOrnamentIllusionView"

export class OutWardIllusionView extends BaseWindowComponent {
	private is_open = false
	private switch_mainui
	public tabs_list = [enum_OutWardType.Wings, enum_OutWardType.HolyDevice, enum_OutWardType.Artifact, enum_OutWardType.BackOrnament]
	private select_index

	CheckWingsIlluRed
	CheckHolyDeviceIlluRed
	ChecArtifactIlluRed
	ChecMagicArrIlluRed
	checkBackOrnamentRed

	_Open
	_CloseFunc

	public constructor() {
		super()

		this.dependent_res = ["pet"]
		let viewToIndex = OutWardController.View2Index
		let local_outwardModelIns = OutWardBaseModel.GetInstance()
		let local_globalE = GlobalEventSystem
		let local_eventName = EventName
		let local_OpenFunc = OpenFun
		let local_outwardType = enum_OutWardType

		this.tabStrList = [
			{ label: "羽翼" },//, icon_up_source: "pet_asset.uiwg_009_r7_c2", icon_down_source: "pet_asset.uiwg_009_r7_c1" 
			{ label: "御守" },//, icon_up_source: "pet_asset.uiwg_009_r5_c2", icon_down_source: "pet_asset.uiwg_009_r5_c1" 
			{ label: "神兵" },//, icon_up_source: "pet_asset.uiwg_009_r6_c2", icon_down_source: "pet_asset.uiwg_009_r6_c1" 
			{ label: "背饰" }
		]
		//{label:"法阵", icon_up_source:"pet_asset.uiwg_009_r6_c2", icon_down_source:"pet_asset.uiwg_009_r6_c1"}

		this.instruction_list = [
			InstructionType.Wings,
			InstructionType.HolyDevice,
			InstructionType.Artifact,
			// InstructionType.MagicArr
		]
		this.viewClassList = [
			"WingsIllusionView",
			"ArtifactIllusionView",
			"HolyDeviceIllusionView",
			"BackOrnamentIllusionView"
			// "MagicArrIllusionView" 
		]
		this.titleStr = "pet.ui_waiguan"
		this.bg_list = {
			"0": "uiwg_0082.jpg",
			"1": "uiwg_0082.jpg",
			"2": "uiwg_0082.jpg",
			"3":"uiwg_0082.jpg"
		}
		this.money_list = [2, 1, 0]
		this.window_load_back = () => {
			this.CheckWingsIlluRed()
			this.CheckHolyDeviceIlluRed()
			this.ChecArtifactIlluRed()
			// this.ChecMagicArrIlluRed()
			this.checkBackOrnamentRed()
		}

		this._CloseFunc = () => {
			if (this.nowSelectIndex == viewToIndex.Wings) {
				local_OpenFunc.OpenFunHandler(3)
			} else if (this.nowSelectIndex == viewToIndex.HolyDevice) {
				local_OpenFunc.OpenFunHandler(14)
			} else if (this.nowSelectIndex == viewToIndex.Artifact) {
				local_OpenFunc.OpenFunHandler(13)
			} else if (this.nowSelectIndex == viewToIndex.MagicArr) {
				local_OpenFunc.OpenFunHandler(123)
			} else if (this.nowSelectIndex == viewToIndex.BackOrnament) {
				local_OpenFunc.OpenFunHandler(243)
			}
		}

		this.CheckWingsIlluRed = () => {
			let wings_red = local_outwardModelIns.ShowIlluRed(local_outwardType.Wings)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.Wings, wings_red)

			this.BindEvent(local_outwardModelIns, OutWardBaseModel.UPDATE_ILLUSION_RED, (type_id?, red?) => {
				if (type_id == local_outwardType.Wings) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.Wings, red)
				}
			})
		}

		this.CheckHolyDeviceIlluRed = () => {
			let holydevice_red = local_outwardModelIns.ShowIlluRed(local_outwardType.HolyDevice)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.HolyDevice, holydevice_red)

			this.BindEvent(local_outwardModelIns, OutWardBaseModel.UPDATE_ILLUSION_RED, (type_id?, red?) => {
				if (type_id == local_outwardType.HolyDevice) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.HolyDevice, red)
				}
			})
		}

		this.ChecArtifactIlluRed = () => {
			let artifact_red = local_outwardModelIns.ShowIlluRed(local_outwardType.Artifact)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.Artifact, artifact_red)

			this.BindEvent(local_outwardModelIns, OutWardBaseModel.UPDATE_ILLUSION_RED, (type_id?, red?) => {
				if (type_id == local_outwardType.Artifact) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.Artifact, red)
				}
			})
		}

		this.ChecMagicArrIlluRed = () => {
			let magicArr_red = local_outwardModelIns.ShowIlluRed(local_outwardType.MagicArr)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.MagicArr, magicArr_red)

			this.BindEvent(local_outwardModelIns, OutWardBaseModel.UPDATE_ILLUSION_RED, (type_id?, red?) => {
				if (type_id == local_outwardType.MagicArr) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.MagicArr, red)
				}
			})
		}

		this.checkBackOrnamentRed = () =>{
			let backOrnamentRed = local_outwardModelIns.ShowIlluRed(local_outwardType.BackOrnament)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.BackOrnament, backOrnamentRed)

			this.BindEvent(local_outwardModelIns, OutWardBaseModel.UPDATE_ILLUSION_RED, (type_id?, red?) => {
				if (type_id == local_outwardType.BackOrnament) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "OutWardIllusionView", viewToIndex.MagicArr, red)
				}
			})
		}

		this._Open = (...parms) => {
			if (parms) {
				this.SetIndexParameter(...parms)
			}
		}


	}

	public Open(...parms) {
		this._Open(...parms)
		super.Open()
	}

	public BaseWindowCloseFunc(){
		this._CloseFunc()
		super.BaseWindowCloseFunc()
	}
}
window["OutWardIllusionView"]=OutWardIllusionView