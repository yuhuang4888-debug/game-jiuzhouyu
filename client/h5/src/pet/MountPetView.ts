import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { RedDotManager } from "../common/RedDotManager"
import { enum_OutWardType, OutWardBaseModel, MountPetViewIndex } from "../commonModel/OutWardBaseModel"
import { PartnerModel } from "../commonModel/PartnerModel"
import { PetEquipEvent, PetEquipType, PetHorseRedList, PetPartnerRedList } from "../commonModel/PetEquipDefine"
import { PetEquipModel } from "../commonModel/PetEquipModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel"
import { PartnerAwakeEvent } from "../commonModel/PartnerAwakeEvent"
import "./Horse/HorseComponentView"
import "./partner/PartnerComponentView"
import "../partner/PartnerBaseView"
import "../partnerAwake/PartnerAwakeMainView"
import "../demon/DemonMainView"
import { DemonModel } from "../commonModel/DemonModel"
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel"



export class MountPetView extends BaseWindowComponent {
	private is_open = false
	private select_index = null
	public tabs_list = [enum_OutWardType.Horse, enum_OutWardType.Partner, enum_OutWardType.Sprite, enum_OutWardType.Pet]

	public partner_awake = false

	CheckDemonRed
	CheckPartnerRed
	CheckHoresRed
	InitSubEvent
	GetPartnerRed
	GetHorseRed
	CheckNewPartnerRed
	CheckPartnerAwakeRed

	_SelectView
	_Open
	_Close
	_CloseFunc

	//Feiqi=3,
	public constructor() {
		super()

		this.dependent_res = ["pet", "petEquip"]
		let local_outwardModel = OutWardBaseModel
		let local_fairywishModel = FairyWishModel.GetInstance()
		let local_outwardModelIns = local_outwardModel.GetInstance()
		let local_redMgr = RedDotManager.GetInstance()
		let local_globalE = GlobalEventSystem
		let local_eventName = EventName
		let local_outwardType = enum_OutWardType
		this.destroy_imm=true
		let list = [TaskTipType.TrainPartner, TaskTipType.TrainMount]
		//原伙伴改名精灵
		this.tabStrList = [
			{ label: "坐骑" },//, icon_up_source: "pet_json.uiwg_009_r1_c2_png", icon_down_source: "pet_json.uiwg_009_r1_c1_png" 
			{ label: "侍魂" },//, icon_up_source: "pet_json.uiwg_009_r3_c2_png", icon_down_source: "pet_json.uiwg_009_r3_c1_png" 
			{ label: "神巫" },//, icon_up_source: "pet_json.uiwg_009_r2_c2_png", icon_down_source: "pet_json.uiwg_009_r2_c1_png" 
			{ label: "妖灵" }//, icon_up_source: "pet_json.uism_033_02_png", icon_down_source: "pet_json.uism_033_01_png" 
		]

		this.viewClassList = [
			"HorseComponentView",
			"PartnerComponentView",
			"PartnerBaseView",
			"DemonMainView"
		]

		this.viewClassModuleDic = {
			"2": { module_name: "partner", class_name: "PartnerBaseView" },
			"3": { module_name: "demon", class_name: "DemonMainView" }
		}

		this.titleStr = "pet.uiwg_001"
		this.titleList = [
			null,
			"pet.ui_shihun",
			"pet.uiqlhx_007",
			"pet.uism_001"
		]
		this.money_list = [2, 1, 0]
		this.instruction_list = [
			InstructionType.Horse,
			InstructionType.Sprite,
			InstructionType.Partner,
			InstructionType.Demon1
		]
		this.bg_list = {
			0: "uiwg_008a.jpg",
			1: "uiwg_008a.jpg",
			2: null,
			3: "uism_002_720x122222.jpg"
		}
		this.tab_new_cond = {
			0: () => {
				return CommonManager.GetInstance().CheckFuncOpenState("HorseComponentView", true)
			},
			1: () => {
				return CommonManager.GetInstance().CheckFuncOpenState("PartnerComponentView", true)
			},
			2: () => {
				return CommonManager.GetInstance().CheckFuncOpenState("PartnerBaseView", true)
			},
			3: () => {
				return CommonManager.GetInstance().CheckFuncOpenState("DemonMainView", true)
			}
		}

		this.partner_awake = false
		if (this.task_model.HavePartnerAwakeTask()) {	//器灵唤醒
			this.partner_awake = true
			this.tabStrList[2] = { label: "唤醒" }//, icon_up_source: "pet_json.uiwg_009_r2_c2_png", icon_down_source: "pet_json.uiwg_009_r2_c1_png" 
			this.viewClassList[2] = "PartnerAwakeMainView"
			this.viewClassModuleDic[2] = { module_name: "partnerAwake", class_name: "PartnerAwakeMainView" }
			this.titleList[2] = "pet.uiqlhx_006"
			this.bg_list[2] = "ui_witch_bg.jpg"
			this.tab_new_cond[2] = () => {
				let bool = PartnerAwakeModel.GetInstance().CanOpenPartnerAwakeView()
				return bool
			}
			this.instruction_list[2] = null
		}

		this.window_load_back = () => {
			this.CheckHoresRed()
			this.CheckPartnerRed()
			this.CheckNewPartnerRed()
			this.CheckDemonRed()
			this.CheckPartnerAwakeRed()
			this.InitSubEvent()
		}

		this.window_open_back = () => {
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainMount)) {
				this.destroy_imm = true
				this._story_bar2.x = 80
				this.story_model.story_index = 0
			} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner)) {
				this.destroy_imm = true
				this._story_bar2.x = 230
				this.story_model.story_index = 1
				let index = 0
				index = CommonManager.GetInstance().CheckFuncOpenState("HorseComponentView", true) ? 1 : 0
				this._story_bar2.x = 80 + index * 150
				this.story_model.story_index = index //引导当前指向的tab index
			} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
				let task_vo = this.task_model.GetMainLineTaskVo()
				if (task_vo.id <= 2) {
					this.story_model.RegisterFinishTaskFinger(TaskTipType.MountLevel)
					this.destroy_imm = true
					let index = 0
					if (task_vo.id == 1) {
						index = 0
					} else {
						index = CommonManager.GetInstance().CheckFuncOpenState("HorseComponentView", true) ? 1 : 0
					}
					this._story_bar2.x = 80 + index * 150
					this.story_model.story_index = index //引导当前指向的tab index
				}
			}
			for (let i = 0; i < list.length; i++) {
				if (this.task_model.IsCurrMainLineTaskTipType(list[i])
					&& !this.task_model.IsCurrMainTaskHasFinish()) {
					this.story_model.task_supplement_list[list[i]] = 1
					break
				}
			}
			//完成后返回主线指引
			this.story_model.RegisterFinishTaskFinger(TaskTipType.TrainMount)
			this.story_model.RegisterFinishTaskFinger(TaskTipType.TrainPartner)
			this.story_model.story_obj = this
		}
		this._SelectView = (index?, is_real_index?) => {
			if (is_real_index == null) {
				is_real_index = false
			}
			local_outwardModelIns.Fire(local_outwardModel.CHANGE_VIEW)
			super.SelectView(index, is_real_index)
			this.select_index = this.GetComponentValue("_list_tab_con", "selectedIndex")
		}

		this._Close = (...parms) => {
			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner)
				|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainMount)
				|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
				if (this.story_model.curr_view_story_step > 0) {
					this.story_model.curr_view_story_step = 0
				}
			}
			for (let i = 0; i < list.length; i++) {
				delete this.story_model.task_supplement_list[list[i]]
			}
			this.story_model.DeleteTaskStep(TaskTipType.MountLevel)
			local_outwardModelIns.Fire(local_outwardModel.CHANGE_VIEW)
		}

		this.GetHorseRed = () => {
			return local_outwardModelIns.ShowCultureRed(local_outwardType.Horse)
				|| local_outwardModelIns.ShowIlluRed(local_outwardType.Horse)
				|| local_fairywishModel.ShowFairyRed(local_outwardType.Horse)
				|| local_redMgr.CheckRedStatusMultModule(PetHorseRedList)
		}

		this.GetPartnerRed = () => {
			return local_outwardModelIns.ShowCultureRed(local_outwardType.Partner)
				|| local_outwardModelIns.ShowIlluRed(local_outwardType.Partner)
				|| local_fairywishModel.ShowFairyRed(local_outwardType.Partner)
				|| local_redMgr.CheckRedStatusMultModule(PetPartnerRedList)
		}

		this.InitSubEvent = () => {
			let local_petType = PetEquipType
			this.BindEvent(PetEquipModel.GetInstance(), PetEquipEvent.UPDATE_RED_STATUS, (type?) => {
				if (type == local_petType.HORSE) {
					let horse_red = this.GetHorseRed()
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 0, horse_red)
				} else if (type == local_petType.PARTNER) {
					let partner_red = this.GetPartnerRed()
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 1, partner_red)
				}
			})
			this.BindEvent(local_fairywishModel, FairyWishEvent.UPDATE_NODE, () => {
				this.CheckHoresRed()
				this.CheckPartnerRed()
			})


			this.BindEvent(local_fairywishModel, FairyWishEvent.UPDATE_NODE, () => {
				this.CheckHoresRed()
				this.CheckPartnerRed()
			})
			this.BindEvent(local_outwardModelIns, local_outwardModel.UPDATE_CULTURE_RED, (type_id?, red?) => {
				if (type_id == local_outwardType.Horse) {
					let horse_red = this.GetHorseRed()
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 0, horse_red)
				}else if (type_id == local_outwardType.Partner) {
					let partner_red = this.GetPartnerRed()
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 1, partner_red)
				}
			})
			this.BindEvent(PartnerModel.GetInstance(), PartnerModel.UPDATE_BIOG_RED, () => {
				this.CheckNewPartnerRed()
			})
		}

		this.CheckHoresRed = () => {
			let horse_red = this.GetHorseRed()
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 0, horse_red)
		}
		this.CheckPartnerRed = () => { // H5伙伴改名为精灵
			let partner_red = this.GetPartnerRed()
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 1, partner_red)

		}


		this.CheckNewPartnerRed = () => { //新版伙伴
			let red = PartnerModel.GetInstance().GetRed()||PartnerModel.GetInstance().CheckAllCompanionRed()
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 2, red)
			
		}



		this.CheckDemonRed = () => { //使魔
			let red = DemonModel.GetInstance().GetRedState()
			local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 3, red)
		}



		this.CheckPartnerAwakeRed = () => { //伙伴唤醒红点
			if (this.partner_awake) {
				let update_fun = () => {
					let red = PartnerAwakeModel.GetInstance().red_dot_state
					local_globalE.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "MountPetView", 2, red)
				}	
				update_fun()
				this.BindEvent(PartnerAwakeModel.GetInstance(), PartnerAwakeEvent.PARTNER_AWAKE_UPDATE_RED_DOT, update_fun)
			}
		}

		this._Open = (...parms) => {
			let main_line_vo = this.task_model.GetMainLineTaskVo()
			let task_ids = [101575]
			if (main_line_vo && task_ids.indexOf(main_line_vo.task_id) != -1 && this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainPartner)) {
				this.SetDefaultIndex(1, true)
			}
			if (parms) {
				this.SetIndexParameter(...parms)
			}
		}

		this._CloseFunc = () => {
			if (this.select_index == 0 || this.select_index == 1) {
				let data = local_outwardModelIns.outward_data_list[this.select_index + 1]
				if (data && data.etime > 0) {
					local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "PetBlessView", data)
					return
				}
			}
		}
	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.TrainMount] = [this._story_bar2]
		this.story_obj_list[TaskTipType.TrainPartner] = [this._story_bar2]
		this.story_obj_list[TaskTipType.MountLevel] = []
		this.story_obj_list[TaskTipType.MountLevel][1] = [this._story_bar2]
		this.story_obj_list[TaskTipType.MountLevel][2] = [this._story_bar2]
		super.createChildren()
	}
	public Open(...parms) {
		this._Open(...parms)
		super.Open()
	}

	public BaseWindowCloseFunc(...parms) {
		this._CloseFunc(...parms)
		super.BaseWindowCloseFunc()
	}

	public Close(...parms) {
		this._Close(...parms)
		super.Close()
	}

	public SelectView(...parms) {
		this._SelectView(...parms)
	}
}
window["MountPetView"]=MountPetView