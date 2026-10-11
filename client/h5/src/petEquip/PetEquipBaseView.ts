import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { PetEquipEvent, PetEquipType } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

import "./PetEquipBagView"
import "./PetEquipStrenView"
import "./PetEquipStarView"


export class PetEquipBaseView extends BaseWindowComponent {
	InitSubEvent
	UpdateRedStatus
	_Local_Open
	_Local_SelectView

	select_index

	public constructor() {
		super()

		let pet_equip_model = PetEquipModel.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
			_type_: PetEquipType

		this.destroy_imm = true
		this.append_to_ctl_queue = true
		this.dependent_res = ["petEquip"]
		this.viewClassList = ["PetEquipBagView", "PetEquipStrenView", "PetEquipStarView"]
		this.titleStr = "petEquip.uiwg_001"
		this.bg_list = ["uiwg_008a.jpg",  "ui_role_bg5.jpg", "ui_role_bg5.jpg" ]
		this.money_list = [2, 1, 0]
		this.tabStrList = [
			{ label: "背包" },//, icon_up_source: "petEquip_json.uiwg_009_04_png", icon_down_source: "petEquip_json.uiwg_009_03_png" 
			{ label: "强化" },//, icon_up_source: "petEquip_json.uiwg_009_10_png", icon_down_source: "petEquip_json.uiwg_009_09_png" 
			{ label: "打造" }//, icon_up_source: "petEquip_json.uiwg_009_16_png", icon_down_source: "petEquip_json.uiwg_009_15_png" 
		]

		this.window_load_back = () => {
			this.UpdateRedStatus()
			this.InitSubEvent()
		}

		this.tab_open_cond = {
			"1": () => {
				let list = pet_equip_model.GetWearEquipInfos(_type_)
				let bool = list.length > 0
				if (!bool) {
					Message.show("需要至少穿戴1件装备")
				}
				return bool
			},
			"2": () => {
				let list = pet_equip_model.GetWearEquipInfos(_type_)
				let bool = list.length > 0
				if (!bool) {
					Message.show("需要至少穿戴1件装备")
				}
				return bool
			}
		}

		this.preload_client_config = {
			"ClientOutWardModel": false,
			"ClientOutWardPos": false
		}

		this.preload_server_config = {
            "config_pet_equip_pos_lv": false
        }

		this.InitSubEvent = () => {
			this.BindEvent(pet_equip_model, PetEquipEvent.UPDATE_RED_STATUS, (type?) => {
				if (_type_ != type) {
					return
				}
				this.UpdateRedStatus()
			})
		}

		this.UpdateRedStatus = () => {
			let mType = pet_equip_model.GetRedIDByType(_type_, 1)
			let red = pet_equip_model.GetRedStatus(mType)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "PetEquipBaseView", 0, red)

			mType = pet_equip_model.GetRedIDByType(_type_, 2)
			red = pet_equip_model.GetRedStatus(mType)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "PetEquipBaseView", 1, red)

			mType = pet_equip_model.GetRedIDByType(_type_, 3)
			red = pet_equip_model.GetRedStatus(mType)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "PetEquipBaseView", 2, red)

		}

		this._Local_Open = (...parms) => {
			_type_ = parms[0]
			if(parms[1]==0){
				this.SetDefaultIndex(parms[1])
			}
			this.SetIndexParameter(0, _type_)
			this.SetIndexParameter(1, _type_)
			this.SetIndexParameter(2, _type_)
			super.Open()
			
		}

		this._Local_SelectView = (index?, is_real_index?) => {
			super.SelectView(index, is_real_index)
			this.select_index = index
		}

		this.BaseWindowCloseFunc = () => {
			GlobalEventSystem.Fire(EventName.SWITCH_MOUNT_PET_VIEW, _type_ - 1)
			_type_ = null
			super.BaseWindowCloseFunc()
		}

	}

	public Open(...parms) {
		this._Local_Open(...parms)
	}

	public SelectView(...parms) {
		this._Local_SelectView(...parms)
	}
}
window["PetEquipBaseView"]=PetEquipBaseView
