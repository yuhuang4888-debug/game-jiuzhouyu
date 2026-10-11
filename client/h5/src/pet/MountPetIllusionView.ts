import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { MainFunc } from "../commonModel/MainUIModel"
import { enum_OutWardType, OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "./Horse/HorseIllusionView"
import "./partner/PartnerIllusionView"

export class MountPetIllusionView extends BaseWindowComponent {
	private is_open = false
	private switch_mainui
	private select_index
	public tabs_list = [enum_OutWardType.Horse, enum_OutWardType.Partner, enum_OutWardType.Sprite, enum_OutWardType.Pet]

	CheckHoresIlluRed
	CheckPartnerIlluRed
	_SelectView 
	_Remove 
	_CloseFunc
	public constructor() {
		super()
		this.dependent_res = ["pet"]

		let local_outwardType = enum_OutWardType
		let local_globalE = GlobalEventSystem
		let local_eventName = EventName
		let local_outwardModel = OutWardBaseModel
		let local_outwardModelIns = local_outwardModel.GetInstance()
		this.tabStrList = [
			{ label: "坐骑" },//, icon_up_source: "pet_json.uiwg_009_r1_c2_png", icon_down_source: "pet_json.uiwg_009_r1_c1_png" 
			{ label: "侍魂" }//, icon_up_source: "pet_json.uiwg_009_r2_c2_png", icon_down_source: "pet_json.uiwg_009_r2_c1_png" 
		];
		this.viewClassList = ["HorseIllusionView", "PartnerIllusionView"]
		this.titleStr = "pet.uiwg_001"
		this.bg_list = { "0": "uiwg_0082.jpg", "1": "uiwg_0082.jpg" }

		this.instruction_list = [InstructionType.Horse, InstructionType.Sprite]

		let OnSwitchMainUiMount = (view_id) => {
			if (view_id == local_outwardType.Pet) {
				local_globalE.Fire(local_eventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Pet)
			}
			super.Close()
		}
		this.switch_mainui = local_globalE.Bind(local_eventName.SWITCH_MAIN_FUNC_VIEW, OnSwitchMainUiMount)

		this.window_load_back = function () {
			this.CheckHoresIlluRed()
			this.CheckPartnerIlluRed()
		}

		this._SelectView = (index: number) => {
			this.select_index = this.GetComponentValue("_list_tab_con", "selectedIndex")
		}

		this._Remove = () => {
			local_globalE.UnBind(this.switch_mainui)
		}

		this._CloseFunc = () => {
			local_globalE.Fire(local_eventName.SWITCH_MOUNT_PET_VIEW, this.select_index)
		}

		this.CheckHoresIlluRed = () => {
			let horse_red = local_outwardModelIns.ShowIlluRed(local_outwardType.Horse)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetIllusionView", 0, horse_red)

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_ILLUSION_RED, (type_id, red) => {
				if (type_id == local_outwardType.Horse) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetIllusionView", 0, red)
				}
			})
		}
		this.CheckPartnerIlluRed = () => {
			let partner_red = local_outwardModelIns.ShowIlluRed(local_outwardType.Partner)
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetIllusionView", 1, partner_red)

			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_ILLUSION_RED, (type_id, red) => {
				if (type_id == local_outwardType.Partner) {
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetIllusionView", 1, red)
				}
			})
		}

	}

	public Open(...parms) {
		if (parms) {
			this.SetIndexParameter(parms[0], parms[1])
		}
		super.Open()
	}

	public SelectView(index: number) {
		super.SelectView(index)
		this._SelectView(index)
	}

	public Remove() {
		this._Remove()
		super.Remove()
	}

	public BaseWindowCloseFunc() {
		this._CloseFunc()
		super.BaseWindowCloseFunc()
	}
}
window["MountPetIllusionView"]=MountPetIllusionView