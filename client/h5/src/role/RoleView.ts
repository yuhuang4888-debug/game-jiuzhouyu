import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { TaskTipType, TaskModel } from "../commonModel/TaskModel"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { attributePotionModel } from "../commonModel/attributePotionModel"
import { RoleViewIndex } from "../commonModel/RoleModel"
import { enum_OutWardType, OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { MedalModel } from "../commonModel/MedalModel"

import "./EquipmentView"
import "../pet/wings/WingsComponentView"
import "../pet/artifact/ArtifactComponentView"
import "../pet/holydevice/HolyDeviceComponentView"
import "../pet/BackOrnament/BackOrnamentComponentView"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { DsgtModel } from "../commonModel/DsgtModel"
import { achvModel } from "../commonModel/achvModel"
import { FashionModel } from "../commonModel/FashionModel"
import { DressModel } from "../commonModel/DressModel"
import { SuitModel, SuitModelEvent } from "../commonModel/SuitModel"
import { FairyWishEvent, FairyWishModel } from "../commonModel/FairyWishModel"
import { SetLocalPositionX } from "../util/Util"
import { StoryModel } from "../commonModel/StoryModel"
import { CommonManager } from "../common/CommonManager"


export class RoleView extends BaseWindowComponent {
	outwardmodel
	fairymodel
	destroy_imm
	tabStrList
	money_list
	viewClassModuleDic
	instruction_list
	titleStr
	bg_list
	titleList
	window_open_back
	viewClassList
	window_load_back
	select_index
	_Local_Open
	public constructor() {
		super()

		this.outwardmodel = OutWardBaseModel.GetInstance()
		this.fairymodel = FairyWishModel.GetInstance()
		this.dependent_res = ["role"]//, "pet"]
		this.tabStrList = [
			{ label: "人物" },//, icon_up_source: "role_json.uisj_003_r1_c2_png", icon_down_source: "role_json.uisj_003_r1_c1_png" 
			{ label: "羽翼" },//, icon_up_source: "pet_json.uiwg_009_r7_c2_png", icon_down_source: "pet_json.uiwg_009_r7_c1_png" 
			{ label: "御守" },//, icon_up_source: "pet_json.uiwg_009_r5_c2_png", icon_down_source: "pet_json.uiwg_009_r5_c1_png" 
			{ label: "神兵" },//, icon_up_source: "pet_json.uiwg_009_r6_c2_png", icon_down_source: "pet_json.uiwg_009_r6_c1_png" 
			{ label: "背饰" }
		]

		this.viewClassList = [
			"EquipmentView",
			"WingsComponentView",
			"ArtifactComponentView",
			"HolyDeviceComponentView",
			"BackOrnamentComponentView"
		]
		this.titleStr = "role_json.title_name_png"

		this.bg_list = [
			"ui_role_new_bg_1.jpg",
			"uiwg_008a.jpg",
			"uiwg_008a.jpg",
			"uiwg_008a.jpg",
			"uiwg_008a.jpg",
		]
		this.money_list = [2, 1, 0]
		this.titleList = [
			"role.title_name",
			"pet.ui_yuyi",
			"pet.ui_yushou",
			"pet.ui_shenbin",
			"pet.ui_beishi",
		]
		this.instruction_list = [
			null,
			InstructionType.Wings,
			InstructionType.HolyDevice,
			InstructionType.Artifact,
			InstructionType.BackOrnament
		]
		this.window_load_back = () => {
			this.InitSubEvent()

			this.UpdateEquipViewRed()
			this.CheckWingsRed()
			this.CheckHolyDeviceRed()
			this.CheckArtifactRed()
			this.CheckBackOrnamentRed()

			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainWing)) {
				this.destroy_imm = true
				this._story_bar2.x = 230//第二个选项卡位置
				this.story_model.story_index = 1 //引导当前指向的tab index
			} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ArtifactLevel)) {
				this.destroy_imm = true
				this._story_bar2.x = 380//第三个选项卡位置
				this.story_model.story_index = 2 //引导当前指向的tab index
			} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainArtifact)) {
				this.destroy_imm = true
				this._story_bar2.x = 530//第四个选项卡位置
				this.story_model.story_index = 3 //引导当前指向的tab index
			} else if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
				let task_vo = this.task_model.GetMainLineTaskVo()
				if (task_vo.id > 2) {
					this.story_model.RegisterFinishTaskFinger(TaskTipType.MountLevel)
					// 1坐骑 2侍魂  在式神界面
					this.destroy_imm = true
					let index = 0
					if (task_vo.id == 3) {
						//羽翼
						index = 1
					} else if (task_vo.id == 4) {
						//御守
						index = CommonManager.GetInstance().CheckFuncOpenState("WingsComponentView", true) ? 2 : 1
					} if (task_vo.id == 5) {
						//神兵
						if (CommonManager.GetInstance().CheckFuncOpenState("WingsComponentView", true)) {
							index += 1
						}
						if (CommonManager.GetInstance().CheckFuncOpenState("ArtifactComponentView", true)) {
							index += 1
						}
						index += 1
					}
					//let index = task_vo&&task_vo.id-2
					this._story_bar2.x = 80 + index * 150
					this.story_model.story_index = index //引导当前指向的tab index
				}

			}


			//完成后返回主线指引
			this.story_model.RegisterFinishTaskFinger(TaskTipType.ArtifactLevel)
			this.story_model.RegisterFinishTaskFinger(TaskTipType.TrainWing)
			this.story_model.RegisterFinishTaskFinger(TaskTipType.TrainArtifact)

			this.story_model.story_obj = this
		}

		this.window_open_back = () => {
			// RoleModel.GetInstance().role_view_is_show = true   


		}

		this._Local_Open = (parms?) => {
			if (parms && parms.length != 0) {
				let main_line_vo = this.task_model.GetMainLineTaskVo()
				let task_ids = [101406,101695,101788]
				if (main_line_vo &&task_ids.indexOf(main_line_vo.task_id)!=-1&&this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
					this.SetDefaultIndex(main_line_vo.id - 2,true)
				} else {
					this.SetDefaultIndex(parms[0])
				}
				this.SetBackId(parms[1])
			}

		}

	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.TrainWing] = [this._story_bar2]
		this.story_obj_list[TaskTipType.ArtifactLevel] = [this._story_bar2]
		this.story_obj_list[TaskTipType.TrainArtifact] = [this._story_bar2]
		this.story_obj_list[TaskTipType.MountLevel] = []
		this.story_obj_list[TaskTipType.MountLevel][3] = [this._story_bar2]
		this.story_obj_list[TaskTipType.MountLevel][4] = [this._story_bar2]
		this.story_obj_list[TaskTipType.MountLevel][5] = [this._story_bar2]
		super.createChildren()
	}

	public Close() {

		// RoleModel.GetInstance().role_view_is_show = false  
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveDesignation)
			|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainWing)
			|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ArtifactLevel)
			|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.TrainArtifact)
			|| this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}

		this.story_model.DeleteTaskStep(TaskTipType.MountLevel)
		super.Close()
	}

	public SelectView(index?, is_real_index?) {
		if (is_real_index == null) {
			is_real_index = false
		}
		OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.CHANGE_VIEW)
		super.SelectView(index, is_real_index)
	}

	public InitSubEvent() {

		this.BindEvent(EquipModel.GetInstance(), EquipEvent.UPDATE_SUIT_COND, () => {
			this.UpdateEquipViewRed()
		}
		)

		this.BindEvent(FashionModel.GetInstance(), FashionModel.SUIT_REFRESH_RED_FLAG, () =>{
			this.UpdateEquipViewRed()
		})

		this.BindEvent(attributePotionModel.GetInstance(), attributePotionModel.TIME_DATA_RETURN, () => {
			this.UpdateEquipViewRed()
		}
		)

		this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_OUTWARD_RED, () => {
			this.UpdateEquipViewRed()
		}
		)

		this.BindEvent(FashionModel.GetInstance(), FashionModel.UPDATEVIEW, () => {
			this.UpdateEquipViewRed()
		}
		)

		this.BindEvent(achvModel.GetInstance(), achvModel.U_AC_REDDOT, () => {
			this.UpdateEquipViewRed()
		}
		)

		this.BindEvent(achvModel.GetInstance(), achvModel.U_AC_V, () => {
			this.UpdateEquipViewRed()
		})

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType?, key?) => {
			if (mType == ModuleType.MEDAL || mType == ModuleType.MEDAL_STRENGTHEN) {
				this.UpdateEquipViewRed()
			}
		})

		this.BindEvent(MedalModel.GetInstance(), MedalModel.UPDATE_TITLE_RED, () => {
			this.UpdateEquipViewRed()
		}
		)

		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.FORBIDDEN_SKILL_UPDATE_RED_DOT, () => {
			this.UpdateEquipViewRed()
		}
		)
		this.BindEvent(DsgtModel.GetInstance(), DsgtModel.DSGT_RED, () => {
			this.UpdateEquipViewRed()
		})

		// 共鸣红点
		this.BindEvent(SuitModel.GetInstance(), SuitModelEvent.UP_SUIT_RED, () => {
			this.UpdateEquipViewRed()
		})

		this.BindEvent(this.fairymodel, FairyWishEvent.UPDATE_NODE, () => {
			this.CheckWingsRed()
			this.CheckArtifactRed()
			this.CheckHolyDeviceRed()
		})


		this.BindEvent(this.story_model, StoryModel.EventName.UPDATE_TASK_STEP, () => {
			this.UpdateTaskStep()
		})


		this.BindEvent(this.outwardmodel, OutWardBaseModel.UPDATE_CULTURE_RED, (type_id?, red?) => {
			if (type_id == enum_OutWardType.Wings) {
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Wings, red)
			}else if (type_id == enum_OutWardType.HolyDevice) {
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.HolyDevice, red)
			}else if (type_id == enum_OutWardType.Artifact) {
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Artifact, red)
			}else if (type_id == enum_OutWardType.BackOrnament) {
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.BackOrnament, red)
			}
		})
	}

	public UpdateTaskStep() {
		let step = this.story_model.GetTaskStep(TaskTipType.MountLevel)
		if (step == 3) {
			let step1 = { "direction": 6, "text": "返回继续主线", "effect_scaleX": 0.35, "effect_scaleY": 1 }
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null, step1, true)
		}
	}

	public UpdateEquipViewRed() {

		let dot0 =
			// EquipModel.GetInstance().GetAllRedStatusPower()
			SuitModel.GetInstance().GetSuitTotlaRed()
			|| FashionModel.GetInstance().IsShowRed()
			|| FashionModel.GetInstance().GetSuitRedState()
			|| DressModel.GetInstance().DressCanShowRedDot()
			//or RedDotManager.GetInstance().CheckRedStatus(ModuleType.CONSTELLATION) 
			|| attributePotionModel.GetInstance().GetattributePotionRed()
			|| achvModel.GetInstance().ShowRed
			|| DsgtModel.GetInstance().ShowRedIcon()
			|| MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL, 1)
			|| MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1)
			|| SkillUIModel.GetInstance().GetInnateRed()
			|| SkillUIModel.GetInstance().GetSkillRedDot()
			|| RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)
			|| SkillUIModel.GetInstance().GetForbiddenSkillRedDot()
			// ||starEquipModel.GetInstance().GetRedDot() 
			|| MedalModel.GetInstance().CheckTitleRedDot()
			
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Role, dot0)
	}

	public CheckWingsRed() {
		let wings_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.Wings)
			|| this.outwardmodel.ShowIlluRed(enum_OutWardType.Wings)
			|| this.fairymodel.ShowFairyRed(enum_OutWardType.Wings)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Wings, wings_red)
		
	}

	public CheckHolyDeviceRed() {
		let holydevice_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.HolyDevice)
			|| this.outwardmodel.ShowIlluRed(enum_OutWardType.HolyDevice)
			|| this.fairymodel.ShowFairyRed(enum_OutWardType.HolyDevice)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.HolyDevice, holydevice_red)
	}

	public CheckArtifactRed() {
		let artifact_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.Artifact) 
			|| this.outwardmodel.ShowIlluRed(enum_OutWardType.Artifact)
			|| this.fairymodel.ShowFairyRed(enum_OutWardType.Artifact)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.Artifact, artifact_red)
	}

	public CheckBackOrnamentRed() {
		let back_ornament_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.BackOrnament)
			|| this.outwardmodel.ShowIlluRed(enum_OutWardType.BackOrnament)
			|| this.fairymodel.ShowFairyRed(enum_OutWardType.BackOrnament)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RoleView", RoleViewIndex.BackOrnament, back_ornament_red)
	}

	public Open(...new_args): void {
		let parms = new_args
		this._Local_Open(parms)
		super.Open()
	}



}

window["RoleView"] = RoleView