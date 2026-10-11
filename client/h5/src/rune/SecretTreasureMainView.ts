import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { MonBookModel } from "../commonModel/MonBookModel"
import { RuneEvent, RuneModel } from "../commonModel/RuneModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

import "../rune/RuneMainUIView";
import "../monBook/MonBookMainView"
import "../lung/LungMainView"
import "../godBeast/GodBeastView"
import "../unreal/UnrealBagView"


import { InstructionType } from "../common/InstructionType"
import { GodBeastModel } from "../commonModel/GodBeastModel"
import { LungEvent, LungModel, SecretTreasureMainViewIndex } from "../commonModel/LungModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { RedDotController } from "../common/RedDotController"
import { RedKey } from "../common/RedDotDefine"
import { CompositeModel } from "../commonModel/CompositeModel"

export class SecretTreasureMainView extends BaseWindowComponent {
	bg_list
	instruction_list
	money_list
	tabStrList
	titleList
	viewClassList
	viewClassModuleDic
	window_open_back

	public constructor() {
		super()

		// this.dependent_res = ["rune"]
		this.tabStrList = [
			// { label: "御魂", icon_up_source: "rune.rune_tab_icon_2", icon_down_source: "rune.rune_tab_icon_1" },
			// { label: "图谱", icon_up_source: "rune.uitj_010_r1_c2", icon_down_source: "rune.uitj_010_r1_c1" },
			// //{label:"源力", icon_up_source:"rune.uijh_005_r1_c2", icon_down_source:"rune.uijh_005_r1_c1"},
			// { label: "神纹", icon_up_source: "rune.uilwmb_012a", icon_down_source: "rune.uilwmb_012" },
			// { label: "蜃妖", icon_up_source: "rune.uiss_020_r2_c2", icon_down_source: "rune.uiss_020_r2_c1" },
			// { label: "灵饰", icon_up_source: "rune.uihs_018_02", icon_down_source: "rune.uihs_018_01" }
			{ label: "御魂" },
			{ label: "图谱" },
			//{label:"源力"},
			{ label: "神纹" },
			{ label: "蜃妖" },
			{ label: "灵饰" }
		]
		this.viewClassList = [
			"RuneMainUIView",
			"MonBookMainView",
			//SoulMainView,
			"LungMainView",
			"GodBeastView",
			"UnrealBagView"
		]
		this.titleList = [
			"rune.rune_title",
			"rune.monBook_001",
			//"rune.uijh_006",
			"rune.lung_title",
			"rune.uiss_001",
			"rune.uihs_001"
		]
		this.bg_list = [
			"ui_rare_bg.jpg",
			"daily_bg.jpg",
			"uilwmb_013a.jpg",
			"ui_rare_bg3.jpg",
			"ui_rare_bg4.jpg"
		]
		this.instruction_list = [
			null,
			null,
			//InstructionType.SOUL,
			InstructionType.LUNG
		]
		this.destroy_imm = true
		this.money_list = [2, 1, 0]
		this.window_open_back = () => {
			this.InitMyEvent()


			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneLvSum)) {
				this.destroy_imm = true
				this._story_bar2.x = 80
				this.story_model.story_index = 0
			} 
			this.story_model.RegisterFinishTaskFinger(TaskTipType.RuneLvSum)

			this.story_model.story_obj = this
		}


	}

	public InitMyEvent() {
		let rune_dot_fun = () => {
			let is_show = RuneModel.GetInstance().ShowRuneRedDot()
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Rune, is_show)
		}
		this.BindEvent(RuneModel.GetInstance(), RuneEvent.UPDATE_RUNE_RED_DOT, rune_dot_fun)

		let is_show = MonBookModel.GetInstance().IsShowIconDot()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.MonBook, is_show)

		//is_show = RedDotManager.GetInstance().CheckRedStatusMultModule(SoulModel.RedTypes)
		//GlobalEventSystem:Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Soul, is_show)

		let dot_fun = function (func?) {
			if (func == MainFunc.Treasure) {
				let show = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT)
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Lung, show)
			}
		}
		let show = RedDotManager.GetInstance().CheckRedStatus(ModuleType.LUNG_DOT)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Lung, show)
		this.BindEvent(GlobalEventSystem, EventName.REFRESH_FUNCTION_ICON_RED_DOT, dot_fun)

		is_show = 
		   RedDotManager.GetInstance().CheckRedStatusMultModule(GodBeastModel.RED_BEAST) 
		|| GodBeastModel.GetInstance().beastComRed
		|| RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_STREN)
		|| RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.BEAST_REPLACE)
		||RedDotController.ins.get(RedKey.GOD_BEAST_MIJUAN)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.GodBeast, is_show)

		//is_show = SecretModel.GetInstance().GetAllRedStatus()
		//GlobalEventSystem:Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Secret, is_show)

		rune_dot_fun()
		LungModel.GetInstance().Fire(LungEvent.LUNG_REQUEST_PROTO, 18100)
		MonBookModel.GetInstance().Fire(MonBookModel.SCMD_REQUEST, 44205)

	
	

		this.BindVar(
			CompositeModel.GetInstance(),
			"unreal_red_dot", (event_name?, now_value?) => {
				this.CheckUnrealRedDot()
			}
		)
		this.CheckUnrealRedDot()
	}

	private CheckUnrealRedDot(){
		let unreal_red = CompositeModel.GetInstance().GetUnrealRedDot()
		let unreal_bool = UnrealModel.GetInstance().GetIconRedDot()||unreal_red
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.Unreal, unreal_bool)
	}

	public Close() {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneNum)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		this.story_model.story_obj = null
		super.Close()
	}

	public SelectView(index?, real_index?) {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.RuneNum)) {
			this.destroy_imm = true
			if (index != 0 && this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		super.SelectView(index, real_index)
	}

	public Open(...new_args) {
		// let parms = new_args
		if (new_args && new_args.length > 0) {
			if (new_args[0]) {
				this.SetDefaultIndex(new_args[0])
			}
			if (new_args[1]) {
				this.SetBackId(new_args[1], new_args[2])
			}
		}
		super.Open()
	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.RuneLvSum] = [this._story_bar2]
		super.createChildren()
	}

}
window["SecretTreasureMainView"] = SecretTreasureMainView