
//let SkillSubViewKeys = {
//defaultIndex = 0,
//nowSelectIndex = 1,
//viewClassList = 2,
//viewList = 3
//}

import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import "../innateSkill/InnateSkillView"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import  "../role/SkillInitiativeSubItem"
import  "../role/SkillPassiveSubItem"

export class SkillSubView extends BaseWindowComponent {
	bg_list
	instruction_list
	money_list
	preload_client_config
	select_index
	tabStrList
	tab_new_cond
	titleList
	titleStr
	viewClassList
	viewClassModuleDic
	window_load_back


	public constructor() {
		super()

		this.dependent_res = ["role"]
		this.tabStrList = [{ label: "主动技能" },
		{ label: "被动技能" },
		{ label: "天赋" },
			//{label:"远古奥术", image:{y:-10}]
		]
		this.viewClassList = [
			"SkillInitiativeSubItem",
			"SkillPassiveSubItem",
			"InnateSkillView",
			//ForbiddenSkillView
		]
		this.titleStr = "role_json.title_name_png"
		//this.viewClassModuleDic = [{module_name="innateSkill", class_name="InnateSkillView"]}
		this.instruction_list = [
			null,
			null,
			null,
			//InstructionType.ForbiddenSkill
		]
		this.tab_new_cond = {
			2: () => {
				return SkillUIModel.GetInstance().GetInnateOpenStatus()
			}
		}
		this.money_list = [2, 1, 0]
		this.titleList = [
			"role.title_name",
			"role.title_name",
			"role.title_name",
			//"role_asset.uisgjs_015"
		]
		this.bg_list = [
			"uitfjn_001.jpg",
			"uisgjs_001_720x1222.jpg"
		]
		this.window_load_back = () => {
			this.InitSubEvent()
			this.CheckRed()
			this.InitImage()
		}

		//this.preload_client_config = [ConfigSkillUI=false]


	}

	public InitImage() {

		if (CommonManager.GetInstance().CheckFuncOpenState("ForbiddenSkillView", true)) {
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, "SkillSubView", 4, true, "role_asset.beta_icon")
		}
	}

	public InitSubEvent() {


		this.BindEvent(GlobalEventSystem, EventName.UPDATE_REDDOT, (mType?, key?) => {
			if (mType != ModuleType.SKILL_STREN) {
				return
			}
			let status = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 0, status)
		}
		)
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_RED_DOT, () => {
			let status = SkillUIModel.GetInstance().GetSkillRedDot()
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 1, status)
		}
		)
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_SKILL_VIEW_RED, (viewClass?) => {
			if (viewClass == "InnateSkillView") {
				let status = SkillUIModel.GetInstance().GetInnateRed()
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 2, status)
			}
		}
		)
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.FORBIDDEN_SKILL_UPDATE_RED_DOT, () => {
			let status = SkillUIModel.GetInstance().GetForbiddenSkillRedDot()
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 3, status)
		}
		)
	}

	public CheckRed() {

		let status = RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 0, status)
		status = SkillUIModel.GetInstance().GetSkillRedDot()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 1, status)
		status = SkillUIModel.GetInstance().GetInnateRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 2, status)
		status = SkillUIModel.GetInstance().GetForbiddenSkillRedDot()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SkillSubView", 3, status)
	}

	public SetIndex(index?) {

		this.select_index = index
		if (index == 3 && !SkillUIModel.GetInstance().GetInnateOpenStatus()) {
			this.select_index = 0
			Message.show("【4转开启】")
		}
	}

	public BaseWindowCloseFunc() {

		super.BaseWindowCloseFunc()
		GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Role)
	}
}
window["SkillSubView"]=SkillSubView

