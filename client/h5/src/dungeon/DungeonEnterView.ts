import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { ModuleType } from "../common/RedDotManager"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"

import "../dungeonRune/DungeonRuneEnterView"
import "../dungeonMaterial/DungeonMaterialNewEnterView"
import "../dungeonMaterial/DungeonMaterialNewHeigherView"
import "../dungeonMaterial/DungeonMaterialNewPreviewView"
import "../dungeonMaterial/DungeonMaterialNewEnterItem"
import "../dungeonExp/DungeonExpEnterView"
import "../dungeonEquip/DungeonEquipEnterView"
import "../dungeonPartner/DungeonPartnerView"
import "../dungeonDragon/DungeonDragonEnterView"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"
import { GetSizeDeltaY, SetAnchoredPositionY, SetLocalPositionX, SetSizeDeltaX } from "../util/Util"
import { StoryModel } from "../commonModel/StoryModel"
import { OpenMode } from "../common/BaseView1"
import { TaskTipType } from "../commonModel/TaskModel"
export class DungeonEnterView extends BaseWindowComponent {
	CheckAdExpReddot
	CheckDragonReddot
	CheckDungeonPartnerReddot
	CheckEquipReddot
	CheckExpReddot
	CheckMaterialReddot
	CheckPetReddot
	CheckReddot
	CheckRuneReddot
	CheckSRReddot
	CheckSoulReddot
	InitSubEvent
	Local_SelectView
	_Local_Close
	_Local_Open
	bg_list
	change_scene_close
	destroy_imm
	instruction_list
	money_list
	preload_server_config
	ShowEffect
	tabStrList
	titleStr
	viewClassList
	viewClassModuleDic
	window_load_back
	window_open_back
	mat_new_list//任务引导用
	public static Index = { Rune: 0, Material: 1, Exp: 2, Equip: 3, Dragon: 4, DungeonPartner: 5, SingleRank: 6 }
	
	public constructor() {
		super()

		let local_InstructionType = InstructionType
		let dungeon_model = BaseDungeonModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let UPDATE_WINDOW_RED_EVENT = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let local_DungeonEnterView = DungeonEnterView
		let local_BaseDungeonModel = BaseDungeonModel
		let local_EventName = EventName
		let custom_model = CustomActivityModel.GetInstance()
		let local_ModuleType = ModuleType
		this.destroy_imm = true
		let story_model = StoryModel.GetInstance()
		this.open_mode = OpenMode.OpenOnly
		this.change_scene_close = false


		this.tabStrList = [
			{ label: "御魂塔" },
			{ label: "资源副本", effect: { source: "ui_activity" }, image: { x: 100, y: -10 } },
			{ label: "恶灵退治", effect: { source: "ui_activity" }, image: { x: 100, y: -10 } },
			{ label: "寻装觅刃", },
			{ label: "神纹烙印", },
			{ label: "神巫副本", effect: { source: "ui_activity" }, image: { x: 100, y: -10 } },
			{ label: "天境试炼", },
		]
		this.viewClassModuleDic =
		{
			"0": { module_name: "dungeonRune", class_name: "DungeonRuneEnterView" },
			"1": { module_name: "dungeonMaterial", class_name: "DungeonMaterialNewEnterView" },
			"2": { module_name: "dungeonExp", class_name: "DungeonExpEnterView" },
			"3": { module_name: "dungeonEquip", class_name: "DungeonEquipEnterView" },
			"4": { module_name: "dungeonDragon", class_name: "DungeonDragonEnterView" },
			"5": { module_name: "dungeonPartner", class_name: "DungeonPartnerView" },
			"6": { module_name: "kfSingleRank", class_name: "kfSRMainView" },
		}
		this.viewClassList = [
			"DungeonRuneEnterView",
			"DungeonMaterialNewEnterView",
			"DungeonExpEnterView",
			"DungeonEquipEnterView",
			"DungeonDragonEnterView",
			"DungeonPartnerView",
			"kfSRMainView",
		]
		this.titleStr = "common.ui_copy_title"
		this.bg_list = [
			"ui_copy_bg.jpg",
			null,
			"ui_copy_bg1.jpg",
			"ui_copy_bg2.jpg",
			"ui_copy_bg3.jpg",
			"ui_copy_bg4.jpg",
			"ui_copy_bg5.jpg",
		]
		//this.money_list = [2, 1, 0]
		this.instruction_list = [
			local_InstructionType.DungeonRune,
			local_InstructionType.DungeonMaterial,
			local_InstructionType.DungeonExp,
			null,
			local_InstructionType.DungeonDragon,
			null,
			null,
		]

		this.window_load_back = () => {
			this.CheckReddot()
			this.ShowEffect()
			this.InitSubEvent()
		}

		this.window_open_back = () => {
			if (this.task_model.MainTaskIsEquipDungeonTaskType()) {
				this.destroy_imm = true
				SetLocalPositionX(this._story_bar2, 530) //第4个选项卡位置
				story_model.story_index = 3
			} else if (this.task_model.MainTaskIsExpDungeonTaskType()) {
				this.destroy_imm = true
				SetLocalPositionX(this._story_bar2, 380) //第三个选项卡位置
				story_model.story_index = 2
			} else if (this.task_model.MainTaskIsTowerDungeonTaskType()) {
				this.destroy_imm = true
				SetLocalPositionX(this._story_bar2, 225) //第二个选项卡位置
				story_model.story_index = 1
			} else if (this.task_model.MainTaskIsRuneDungeonTaskType()) {
				this.destroy_imm = true
				SetLocalPositionX(this._story_bar2, 75) //第1个选项卡位置
				story_model.story_index = 0
			}


			//资源副本任务引导
			if (this.IsMatTask()) {
				this.destroy_imm = true
				SetLocalPositionX(this._story_bar2, 225) //第二个选项卡位置
				story_model.story_index = 1
			}


			story_model.story_obj = this
		}

		this._Local_Close = () => {
			if (this.task_model.MainTaskIsRuneDungeonTaskType()
				|| this.task_model.MainTaskIsEquipDungeonTaskType()
				|| this.task_model.MainTaskIsExpDungeonTaskType()
				|| this.task_model.MainTaskIsTowerDungeonTaskType()) {
				if (this.story_model.curr_view_story_step > 0) {
					this.story_model.curr_view_story_step = 0
				}
			}

			//资源副本任务引导
			if (this.IsMatTask()) {
				if (this.story_model.curr_view_story_step > 0) {
					this.story_model.curr_view_story_step = 0
				}
			}
			story_model.story_obj = undefined
			super.Close()
		}

		this._Local_Open = (parms?) => {
			if (parms) {

				let main_line_vo = this.task_model.GetMainLineTaskVo()
				if (main_line_vo
					&&this.task_model.IsCurrMainLineTaskTipType(TaskTipType.FinDunType)
					&&this.IsMatTask()) {
					if(main_line_vo.task_id == 101215){
						this.SetDefaultIndex(0)
					}else{
						this.SetDefaultIndex(DungeonEnterView.Index.Material)
					}
				}else{
					this.SetDefaultIndex(parms[0])
				}
				this.SetBackId(parms[1])
			}

		}

		this.Local_SelectView = (index?, is_real_index?) => {
			super.SelectView(index, is_real_index)
		}

		this.CheckReddot = () => {
			this.CheckMaterialReddot()
			this.CheckRuneReddot()
			this.CheckExpReddot()
			this.CheckEquipReddot()
			this.CheckDragonReddot()
			this.CheckDungeonPartnerReddot()
			this.CheckSRReddot()
		}

		this.CheckExpReddot = () => {
			let exp_red = dungeon_model.GetExpRedState()
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.Exp, exp_red)
		}

		this.CheckMaterialReddot = () => {
			let red_state = dungeon_model.CheckNewMatrialRed(0)
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.Material, red_state)
		}

		this.CheckRuneReddot = () => {
			let red_state = dungeon_model.GetRuneRedState()
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.Rune, red_state)
		}

		this.CheckEquipReddot = () => {
			let red_state = dungeon_model.GetEquipRedState()
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.Equip, red_state)
		}

		this.CheckDragonReddot = () => {
			let red_state = dungeon_model.GetDragonRedState()
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.Dragon, red_state)
		}

		//伙伴副本
		this.CheckDungeonPartnerReddot = () => {
			let red_state = DungeonPartnerModel.GetInstance().GetRedState()
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.DungeonPartner, red_state)
		}

		this.CheckSRReddot = () => {
			let red_state = kfSingleRankModel.GetInstance().GetRedStatus(local_ModuleType.SINGLE_RANK)
			local_GlobalEventSystem.Fire(UPDATE_WINDOW_RED_EVENT, "DungeonEnterView", local_DungeonEnterView.Index.SingleRank, red_state)
		}

		this.ShowEffect = () => {
			let effect = () => {
				let state = CommonManager.GetInstance().CheckFuncOpenState("DungeonExpEnterView", true) && (dungeon_model.showEffect(local_BaseDungeonModel.DOUBLE_ACTIVITY) || custom_model.GetActivenessStatus("331@56" + local_DungeonEnterView.Index.Exp))
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, "DungeonEnterView", local_DungeonEnterView.Index.Exp, state, "double", true)
				let [metiral_flag, partner_flag] = dungeon_model.showDoubleEffect(local_BaseDungeonModel.MORE_ACTIVITY)

				state = metiral_flag || custom_model.GetActivenessStatus("331@56" + local_DungeonEnterView.Index.Material) || custom_model.GetActivenessStatus(CustomActivityModel.MATIAL_ICON_115)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, "DungeonEnterView", local_DungeonEnterView.Index.Material, state, "double", true)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, "DungeonEnterView", local_DungeonEnterView.Index.DungeonPartner, partner_flag, "double", true)
			}

			this.BindEvent(dungeon_model, local_BaseDungeonModel.UPDATE_ACTIVITY, effect)
			effect()
		}

		this.InitSubEvent = () => {
			this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_REDDOT, (rType?, key?) => {
				if (rType != local_ModuleType.SINGLE_RANK) {
					return
				}
				this.CheckSRReddot()
			}
			)

			this.BindEvent(BaseDungeonModel.GetInstance(), BaseDungeonModel.NEW_DUNGEON_UPDATE_NUM, () => {
				this.CheckMaterialReddot()
			}
			)
		}


	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		if (this.IsMatTask()) this.story_obj_list[TaskTipType.FinDunType] = [this._story_bar2]
		this.story_obj_list[TaskTipType.Dungeon_level] = [this._story_bar2]
		super.createChildren()
	}

	public Open(...new_args) {
		let parms = new_args
		this._Local_Open(parms)
		super.Open()
	}

	public Close() {

		this._Local_Close()
	}

	public SelectView(index?, is_real_index?) {
		this.Local_SelectView(index, is_real_index)
	}


	public IsMatTask() {
		//资源副本任务引导
		let boo = false
		if(!this.mat_new_list){
			this.mat_new_list = BaseDungeonModel.GetInstance().mat_new_list
		}

		for (let i = 0; i < this.mat_new_list.length; i++) {
			if (this.task_model.MainTaskIsNewMaterialDunTaskType(this.mat_new_list[i])) {
				boo = true
			}
		}
		return boo
	}

}
window["DungeonEnterView"] = DungeonEnterView