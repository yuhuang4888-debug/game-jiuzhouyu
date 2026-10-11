import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { MainRoleVo } from "../sharedata/MainRoleVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "./EquipTreasureMainView"
import "./ExtremeTreasureMainView"
import "./PeakTreasureMainView"
import "./RuneTreasureMainView"

export class RuneTreasureBaseView extends BaseWindowComponent {

	InitImage
	CheckRedDot
	Local_OpenFunc
	public constructor() {
		super()
		let treaModel = RuneTreasureModel
		let model = treaModel.GetInstance()
		let local_eventName = EventName
		let local_ins = InstructionType
		let lcoal_taskType = TaskTipType
		let local_global = GlobalEventSystem
		let local_redMgr = RedDotManager.GetInstance()
		this.dependent_res = ["runeTreasure"]
		this.tabStrList = [
			{ label: "装备夺宝", icon_up_source: "", icon_down_source: "", image: { y: 0 } },
			{ label: "御魂召唤", icon_up_source: "", icon_down_source: "" },
			{ label: "巅峰夺宝", icon_up_source: "", icon_down_source: "", open_lv: treaModel.PEAK_TREASURE_OPEN_LV, image: { y: 0 } },
			{ label: "至尊夺宝", icon_up_source: "", icon_down_source: "", open_lv: treaModel.EXTREME_TREASURE_OPEN_LV, image: { y: 0 } }
		];
		this.viewClassList = ["EquipTreasureMainView", "RuneTreasureMainView", "PeakTreasureMainView", "ExtremeTreasureMainView"]
		this.bg_list = { "0": "uizbxb_002a_720x1222.jpg", "1": "uizbxb_002d.jpg", "2": "uizbxb_002b_720x1222.jpg", "3": "uizbxb_002c_720x1222.jpg" }
		this.titleList = [
			"runeTreasure.rt_icon_title",
			"runeTreasure.uizbxb_021",
			"runeTreasure.rt_icon_title",
			"runeTreasure.rt_icon_title"
		]
		this.window_load_back = function () {
			this.InitImage()
		}

		if (Util.IsDebug()
			|| CommonManager.GetInstance().GetInstructionState(416)) {
			this.instruction_list = [local_ins.EquipTreasure, local_ins.RuneTreasure, local_ins.PeakTreasure, local_ins.ExtremeTreasure]
		}

		this.window_open_back = function () {
			this.CheckRedDot()
			if (this.task_model.IsCurrMainLineTaskTipType(lcoal_taskType.Rune_treasure)) {
				this._story_bar2.x = 300
			}
		}

		this.tab_new_cond = {
			// 1: () => {
			// 	// let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
			//     // let level=main_role_vo.level
			// 	return level<RuneTreasureModel.RUNE_TREASURE_OPEN_LV
			// }
			0: () => {
				return true	//限购
			},
			1: () => {
				// let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
				// let level=main_role_vo.level
				// return level>Number(RuneTreasureModel.RUNE_TREASURE_OPEN_LV)
				return true
			},
		}

		this.InitImage = () => {
			for (let i = 1; i < 4; i++) {
				let [status, index, resName] = model.GetImageStatus(i)
				local_global.Fire(local_eventName.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, "RuneTreasureBaseView", index, status, resName)
			}
		}


		this.CheckRedDot = () => {
			let iconred = false
			model.ShowRedDot()
			let CheckRed1 = () => {
				let red11 = local_redMgr.CheckRedStatus(ModuleType.EQUIP_TREASURE_RED)
				iconred = iconred || red11
				local_global.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RuneTreasureBaseView", 0, red11)
			}
			let CheckRed2 = () => {
				let red22 = local_redMgr.CheckRedStatus(ModuleType.PEAK_TREASURE_RED)
				iconred = iconred || red22
				local_global.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RuneTreasureBaseView", 2, red22)
			}

			let CheckRed3 = () => {
				let red33 = local_redMgr.CheckRedStatus(ModuleType.EXTREME_TREASURE_RED)
				iconred = iconred || red33
				local_global.Fire(local_eventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "RuneTreasureBaseView", 3, red33)
			}

			this.BindEvent(model, RuneTreasureEvent.UPDATE_RED, () => {
				iconred = false
				CheckRed1()
				CheckRed2()
				CheckRed3()
				local_global.Fire(local_eventName.REFRESH_ACTIVITY_ICON_RED_DOT, 416, iconred)
			}, true)
		}
		this.Local_OpenFunc = (parms) => {
			if (parms[0] && parms[0][0] && parms[0][0][`back_id`])
				this.SetBackId(parms[0][0][`back_id`]);
			else if (parms[0])
				this.SetDefaultIndex(parms[0])
			super.Open()
		}
	}

	public BaseWindowCloseFunc() {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Rune_treasure)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		super.BaseWindowCloseFunc()
	}

	public Open(...parms) {
		this.Local_OpenFunc(parms)
	}
}

window["RuneTreasureBaseView"] = RuneTreasureBaseView
