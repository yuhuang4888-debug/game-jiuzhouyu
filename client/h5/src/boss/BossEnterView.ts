import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { BossModel } from "../commonModel/BossModel"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { DragonWhisperModel } from "../commonModel/DragonWhisperModel"

import "../bossField/BossAbyssEnterView"
import "../bossPersonal/BossPersonalEnterView"
import "../bossSuit/BossSuitEnterView"
import "../bossMystery/BossMysteryEnterView"
import "../dragonWhisper/dwMainView"

export class BossEnterView extends BaseWindowComponent {
	bg_list
	change_scene_close
	instruction_list
	money_list
	tabStrList
	tab_item_renderer
	tab_new_cond
	titleList
	viewClassList
	window_load_back
	window_open_back
	CheckBossAbyssRed
	public constructor() {
		super()

		this.dependent_res = ["boss"]
		this.tabStrList = [
			{ label: "世界大妖" },
			{ label: "大妖之境" },
			{ label: "专属大妖" },
			{ label: "蛮荒大妖" },
			{ label: "神祭大妖" },
		]

		this.viewClassList = [
			"BossFieldEnterView",
			"BossAbyssEnterView",
			"BossPersonalEnterView",
			"BossSuitEnterView",
			"dwMainView"
		]

		this.titleStr = "common4.ui_chief_title"
		this.money_list = [2, 1, 0]

		this.instruction_list = [
			InstructionType.BossField,
			InstructionType.BossAbyss,
			InstructionType.BossVipPersonal,
			InstructionType.BossSuit,
			InstructionType.DRAGON_WHISPER
		]

		this.bg_list = [
			"ui_chief_bg1.jpg",
			"ui_chief_bg2.jpg",
			"ui_chief_bg3.jpg",
			"ui_chief_bg4.jpg",
			"ui_chief_bg6.jpg"
		]

		this.change_scene_close = false

		this.window_open_back = () => {
		}

		this.tab_new_cond = []

		this.CheckBossAbyssRed = () => {
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Abyss_Boss,
				BossModel.GetInstance().GetBossAbyssRed()
			)
		}

		this.window_load_back = () => {
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Field_Boss,
				BossModel.GetInstance().GetFieldBossRedState()
			)

			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Vip_Person_Boss,
				BaseDungeonModel.GetInstance().GetVipPersonRed()
			)
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Suit_Boss,
				BossModel.GetInstance().GetSuitRed()
			)
			GlobalEventSystem.Fire(
				EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE,
				"BossEnterView",
				BossModel.Index.Dragon_Boss,
				DragonWhisperModel.GetInstance().GetRedStatus()
			)

			this.CheckBossAbyssRed()


			this.BindEvent(BossModel.GetInstance(), BossModel.CHANGE_WINDOW_BG, (res?) => {
				// this.SetBg(res)
			})

			
			this.BindEvent(BossModel.GetInstance(), BossModel.UPDATE_ABYSS_BOSS_RED, () => {
				this.CheckBossAbyssRed()
			})
		}
	}

	public Open(index?, boss_id?) {
		let task_vo = TaskModel.GetInstance().GetMainLineTaskVo()
		if (task_vo
			&& (task_vo.task_id == 101481
				|| task_vo.task_id == 101701
				|| task_vo.task_id == 101485
				|| task_vo.task_id == 101705)
			&& !index
			&& !boss_id) {
			index = BossModel.Index.Field_Boss
			boss_id = task_vo.id
		}
		this.SetIndexParameter(index, boss_id)
		if (index != null) {
			this.SetDefaultIndex(index)
		}
		super.Open()
	}

	public Close() {
		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Kill_boss_id)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		super.Close()
	}

	public SetDefaultIndex(open_index?, is_real_index?) {
		if (open_index == null) {
		}
		super.SetDefaultIndex(open_index, is_real_index)
	}
}
window["BossEnterView"] = BossEnterView