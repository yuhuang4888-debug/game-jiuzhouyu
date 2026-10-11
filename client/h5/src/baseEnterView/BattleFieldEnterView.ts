import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { ArenaModel } from "../commonModel/ArenaModel"
import { GuildFightModel } from "../commonModel/GuildFightModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { TopPkModel } from "../commonModel/TopPkModel"
import { GuildFightView } from "../guildFight/GuildFightView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetLocalPositionX } from "../util/Util"
import { BaseEnterDefine } from "./BaseEnterDefine"
import { NineSkyModel } from "../commonModel/NineSkyModel"
//import  "../arena/ArenaEnterView"
import  "../nineSky/NineSkyEnterView"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import "../topPk/TopPkEnterView"

export class BattleFieldEnterView extends BaseWindowComponent {
	BattleFieldIndex
	bg_list
	destroy_imm
	instruction_list
	money_list
	showTopView
	tabStrList
	titleStr
	viewClassList
	viewClassModuleDic
	window_load_back
	window_open_back

	public constructor() {
		super()


		this.BattleFieldIndex = BaseEnterDefine.BattleFieldIndex()
		this.showTopView = false


		this.titleStr = "arena.ui_arena_title"
		this.money_list = [2, 1, 0]
		this.window_load_back = () => {
			this.LoadSuccess()
		}

		this.window_open_back = () => {

			if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Fin_glad)) {
				this.destroy_imm =true
				SetLocalPositionX(this._story_bar2, 116) //第4个选项卡位置
			}else if(this.task_model.IsCurrMainLineTaskTipType(TaskTipType.JoinJcc)){
				this.destroy_imm =true
			}


			this.story_model.story_obj = this
		}


	}

	public Close() {

		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Fin_glad)
		||this.task_model.IsCurrMainLineTaskTipType(TaskTipType.JoinJcc)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		this.story_model.story_obj = null
		super.Close()
	}

	public SelectView(index?) {
		super.SelectView(index)
	}

	public LoadSuccess() {

		let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		this.showTopView = open_day < TopPkModel.GetInstance().changeViewDay
		if (this.showTopView) {
			this.tabStrList = [
				{label:"竞技场"},
				{label:"九魂妖塔"},
				{label:"尊神战场"},
				{label:"巅峰竞技"},
				{ label: "最强结社" }]
			this.destroy_imm = true
			this.viewClassList = [
				"ArenaEnterView",
				"NineSkyEnterView",
				"HolyBattleEnterView",
				"TopPkEnterView",
				"GuildFightView"
			]
			this.bg_list = [
				"uijj_001_lashen720x1222.jpg",
				"ui_arena_bg1.jpg",
				"ui_slzc_3.jpg",
				"uidfjj_002.jpg",
				"ui_jjc_3.jpg"
			]
			this.instruction_list = [
				InstructionType.Arena,
				null,
				null,
				InstructionType.TopPk,
				InstructionType.GuildFight
			]
		} else {
			this.tabStrList = [
				{ label: "竞技场" },
				{ label: "九魂妖塔" },
				{ label: "尊神战场" },
				{ label: "最强结社" }
			]
			this.destroy_imm = true
			this.viewClassList = [
				"ArenaEnterView",
				"NineSkyEnterView",
				"HolyBattleEnterView",
				"GuildFightView"
			]
			this.bg_list = [
				"uijj_001_lashen720x1222.jpg",
				"ui_arena_bg1.jpg",
				 "ui_slzc_3.jpg",
				"ui_jjc_3.jpg"
			]
			this.instruction_list = [
				InstructionType.Arena,
				null,
				null,
				InstructionType.GuildFight
			]
		}
		this.CheckRed()
	}
	//super.LoadSuccess(this)



	//红点
	public CheckRed() {
		let red_state

		//竞技场
		red_state= ArenaModel.GetInstance().GetRedState()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", this.BattleFieldIndex.Arena, red_state)

		//最强结社  SetRedDotData方法设置一下
		red_state = GuildFightModel.GetInstance().IsShowRed()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", this.BattleFieldIndex.GuildFight, red_state)

		//九魂妖塔
		red_state = NineSkyModel.GetInstance().GetRedState()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", this.BattleFieldIndex.NineSky, red_state)

		//巅峰竞技
		if (this.showTopView) {
			red_state = TopPkModel.GetInstance().GetRedState()
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", this.BattleFieldIndex.Top_Pk, red_state)
		}

		//尊神战场
		red_state = HolyBattleModel.GetInstance().GetRedState()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", this.BattleFieldIndex.HolyBattle, red_state)
	}

	public Open(...new_args) {
		let parms = new_args
		// if (parms[0]) {
		// 	this.SetDefaultIndex(parms[0])
		// }
		if (parms.length > 0) {
			this.SetDefaultIndex(parms[0])
		}
		super.Open()
	}

	public DeleteMe() {
		super.DeleteMe()
	}

}

window["BattleFieldEnterView"] = BattleFieldEnterView