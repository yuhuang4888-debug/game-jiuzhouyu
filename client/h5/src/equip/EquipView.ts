import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { EquipModel, EquipEvent, EquipViewToIndex } from "../commonModel/EquipModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { InstructionType } from "../common/InstructionType"
import { ArmorModel } from "../commonModel/ArmorModel"

export class EquipView extends BaseWindowComponent {
	CheckArmorReddot
	CheckJewelReddot
	CheckRefiReddot
	CheckSmeltReddot
	CheckStrenReddot
	CheckWashReddot
	InitSubEvent
	Local_SelectView
	_Local_Open
	_local_Close

	bg_list
	destroy_imm
	instruction_list
	money_list
	preload_server_config
	tabStrList
	titleStr
	viewClassList
	viewClassModuleDic
	window_load_back

	public constructor() {
		super()
		this.destroy_imm = true

		let local_TaskTipType = TaskTipType
		let model = EquipModel.GetInstance()
		let local_EquipEvent = EquipEvent
		let red_dot_mgr = RedDotManager.GetInstance()
		let local_ModuleType = ModuleType
		let local_GlobalEventSystem = GlobalEventSystem

		let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		this.dependent_res = ["equip", "equipCom", "jewel"]

		this.tabStrList = [
			{ label: "强化" },//, icon_up_source: "equip_asset.uidz_006_r1_c2", icon_down_source: "equip_asset.uidz_006_r1_c1"
			{ label: "精炼" },//, icon_up_source: "equip_asset.uidz_006_r2_c2", icon_down_source: "equip_asset.uidz_006_r2_c1"
			{ label: "宝石" },//, icon_up_source: "equip_asset.uidz_006_r3_c2", icon_down_source: "equip_asset.uidz_006_r3_c1" 
			{ label: "洗炼" },//, icon_up_source: "equip_asset.uidz_006_r4_c2", icon_down_source: "equip_asset.uidz_006_r4_c1" 
			{ label: "神炼" },//, icon_up_source: "equip_asset.uisl_019_02", icon_down_source: "equip_asset.uisl_019_01" 
			{ label: "战甲" },//, icon_up_source: "equip_asset.uibb_005_02", icon_down_source: "equip_asset.uibb_005_01" 
		]
		this.viewClassList = [
			"EquipStrenView",
			"EquipSmeltView",
			"EquipJewelView",
			"EquipWashView",
			"EquipRefinementView",
			"EquipArmorView"
		]

		this.viewClassModuleDic = {
			"0": { module_name: "equip", class_name: "EquipStrenView" },
			"1": { module_name: "equip", class_name: "EquipSmeltView" },
			"2": { module_name: "jewel", class_name: "EquipJewelView" },
		}

		//this.instruction_list = [null, null, null, InstructionType.EquipWash, InstructionType.EquipRefi]
		this.titleStr = "equip.uidz_001"
		this.bg_list = [
			"ui_role_bg5.jpg",
			"ui_role_bg5.jpg",
			"ui_forge_bg.jpg",
			"ui_forge_bg2.jpg",
			"ui_forge_bg1.jpg",
			"ui_role_bg5.jpg"
		]
		this.money_list = [2, 1, 0]

		this.window_load_back = () => {
			this.CheckStrenReddot()
			this.CheckSmeltReddot()
			this.CheckJewelReddot()
			this.CheckWashReddot()
			this.CheckRefiReddot()
			this.CheckArmorReddot()
			this.InitSubEvent()

			if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.StrenEquip)
				|| this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.StrenSum)
				|| this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.RefineEquip)
				|| this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.EquipStoneNum)) {
				this.destroy_imm=true
			}
			this.story_model.RegisterFinishTaskFinger(local_TaskTipType.StrenSum)
			this.story_model.RegisterFinishTaskFinger(TaskTipType.EquipStoneNum)
			this.story_model.story_obj = this
		}

		this.Local_SelectView = (index?, is_real_index?) => {
			super.SelectView(index, is_real_index)
		}

		this._local_Close = () => {
			if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.StrenEquip)
				|| this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.StrenSum)
				|| this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.RefineEquip)
				|| this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.EquipStoneNum)) {
				if (this.story_model.curr_view_story_step > 0) {
					this.story_model.curr_view_story_step = 0
				}
			}
			this.story_model.story_obj=null
			super.Close()
		}

		this._Local_Open = (parms?) => {
			if (this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.EquipStoneNum)) {
				this.SetDefaultIndex(2,true)
			}else if(this.task_model.IsCurrMainLineTaskTipType(local_TaskTipType.StrenSum)){
				this.SetDefaultIndex(0,true)
			}else{
				let index = parms
				this.SetDefaultIndex(index)
			}

			super.Open()
		}

		this.InitSubEvent = () => {
			this.BindEvent(model, local_EquipEvent.UPDATE_JEWEL_RED, this.CheckJewelReddot)
			this.BindEvent(model, local_EquipEvent.UPDATE_JEWEL_CARVE_RED, this.CheckJewelReddot)
			this.BindEvent(model, local_EquipEvent.UPDATE_WASH_RED, this.CheckWashReddot)
			this.BindEvent(model, local_EquipEvent.UPDATE_REFI_RED, this.CheckRefiReddot)
			this.BindEvent(ArmorModel.GetInstance(), ArmorModel.UPDATE_RED, this.CheckArmorReddot)
		}

		this.CheckStrenReddot = () => {
			let status = red_dot_mgr.GetRedStatus(local_ModuleType.EQUIP_STREN)
			if (status == null) {
				model.CheckStrenRedDotAll()
			}
			let stren_dot = red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_STREN) || model.CheckMasterRed(1)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Strength, stren_dot)
		}

		this.CheckSmeltReddot = () => {
			let status = red_dot_mgr.GetRedStatus(local_ModuleType.EQUIP_SMELT)
			if (status == null) {
				model.CheckSmeltRedDotAll()
			}
			let smelt_dot = red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_SMELT)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Smlet, smelt_dot)
		}

		this.CheckJewelReddot = () => {
			let jewel_dot = red_dot_mgr.CheckRedStatus(local_ModuleType.EQUIP_JEWEL) || model.CheckMasterRed(3)
			let crave_red = red_dot_mgr.CheckRedStatus(local_ModuleType.JEWEL_CRAVE_RED)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Jewel, jewel_dot || crave_red)
		}

		this.CheckWashReddot = () => {
			let wash_dot = model.GetEquipWashAllRed()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Wash, wash_dot)
		}

		this.CheckRefiReddot = () => {
			let refi_dot = red_dot_mgr.CheckRedStatus(ModuleType.REFINEMENT_RED)
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Refinement, refi_dot)
		}

		this.CheckArmorReddot = () => {
			let red = ArmorModel.GetInstance().GetRedDot()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "EquipView", EquipViewToIndex.Armor, red)
		}
	}

	
	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.EquipStoneNum] = [null,null,this._img_return]
		super.createChildren()
	}


	public Open(...new_args) {
		this._Local_Open(...new_args)
	}

	public Close() {
		this._local_Close()
	}

	public SelectView(index?, is_real_index?) {
		this.Local_SelectView(index, is_real_index)
	}
}
window["EquipView"] = EquipView