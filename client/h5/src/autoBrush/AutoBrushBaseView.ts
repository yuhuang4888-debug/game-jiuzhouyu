import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import "./AutoBrushMainView"
import { MonsterModel, MonsterModelEvent } from './../commonModel/MonsterModel';
import './../guBao/MonsterMainView';
import { AutoBrushModel } from "../commonModel/AutoBrushModel";
import { SetLocalPositionX, Util } from "../util/Util";
import { StoryModel } from "../commonModel/StoryModel";
import { TaskModel, TaskTipType } from "../commonModel/TaskModel";

export enum EnumAutoBrushTabType {
	/**自动推关 */
	eAutoBrush,
	/**古宝 */
	eSoap,

}

export class AutoBrushBaseView extends BaseWindowComponent {
	public static readonly _layout_file: string = 'AutoBrushBaseView';

	private get monsterModel() {
		return MonsterModel.GetInstance();
	}

	public constructor() {
		super()
		this.destroy_imm = true
		this.change_scene_close = true
		this.tabStrList = [
			{ label: "斩妖" },
			{ label: "法器" }
		]
		this.viewClassList = [
			"AutoBrushMainView",
			"MonsterMainView",
		]
		this.titleStr = "autoBrush.ui_zy_title";
		// 页签对应的背景图
		this.bg_list = [
			"ui_zy_bg1.jpg",
			"ui_zy_bg2.jpg",
		]
		//this.money_list = [2, 1, 0]
		this.instruction_list = [

		]
		// this.preload_server_config = {config_dungeon:false, config_dungeon_ui_content:false}
		this.window_load_back = () => {
			this.UpdateSoapTabRedDot();
			this.UpdateAutoBrushRedDot();
		}

		this.window_open_back = () => {
			this.BindEvent(AutoBrushModel.GetInstance(), AutoBrushModel.NEXT_STEP_ARROW, (step) => {
				let task_id = TaskModel.GetInstance().GetMainLineTaskVo() && TaskModel.GetInstance().GetMainLineTaskVo().task_id
				if (task_id && AutoBrushModel.GetInstance().IsSpeTaskId(task_id) && step == 3) {
					SetLocalPositionX(this._story_bar2, 230) //第二个选项卡位置
					StoryModel.GetInstance().story_index = 1
					StoryModel.GetInstance().story_obj = this
					this._story_bar2.mouseEnabled = true
					this._story_bar2.mouseThrough = false
					AutoBrushModel.GetInstance().CreatArrow(this, this._story_bar2, 3)
				}
				if (AutoBrushModel.GetInstance().IsSpeTaskId(task_id) && step == 6) {
					AutoBrushModel.GetInstance().Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13322, "c", 6)
					AutoBrushModel.GetInstance().SetStep(6)
					let step1 = { "direction": 6, "text": "点击返回主界面", "effect_scaleX": 0.35, "effect_scaleY": 1 }
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, null, null, step1, true)
					//GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
				}
			})



			let step = AutoBrushModel.GetInstance().GetStep()
			if (step >= 2 && step < 5) {
				SetLocalPositionX(this._story_bar2, 230) //第二个选项卡位置
				StoryModel.GetInstance().story_index = 1
				StoryModel.GetInstance().story_obj = this
				this._story_bar2.mouseEnabled = true
				this._story_bar2.mouseThrough = false
				let step1 = { "direction": 2, "text": "点击这里可以查看获取的<font color='#0a9f42'>法器</font>线索", "effect_scaleX": 0.65, "effect_scaleY": 0.9 }
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._story_bar2, "UI", null, null, null, null, step1, true)
			}


			//this.SetSelectIndex(1, null, true)
			Util.AddClickEvent(this._story_bar2, () => {
				this.SetSelectIndex(1, null, true)
			}, false)


			if (this.task_model.IsSpecialBrushTask()) {
				this.destroy_imm = true
				SetLocalPositionX(this._story_bar2, 230) //第二个选项卡位置
				StoryModel.GetInstance().story_index = 1
				this.story_model.RegisterFinishTaskFinger(TaskTipType.ActiveSoap)
			}

			StoryModel.GetInstance().story_obj = this
		}

	}



	public SetSelectIndex(index, is_real_index?, delete_arrow?) {
		if (delete_arrow)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._story_bar2);
		super.SetSelectIndex(index, is_real_index)
	}
	public Open(...new_args) {

		if (new_args.length == 1) {
			if (this.HasOpen()) {
				this.LocalSetSelectIndex(new_args[0]);
				return;
			}
		}

		if (new_args) {
			this.SetDefaultIndex(new_args[0])
			this.SetBackId(new_args[1])
		}
		super.Open();
	}

	public Close() {
		let step = AutoBrushModel.GetInstance().GetStep()
		if (step != 6)
			AutoBrushModel.GetInstance().SetStep(step - 1)

		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap)) {
			if (this.story_model.curr_view_story_step > 0) {
				this.story_model.curr_view_story_step = 0
			}
		}
		StoryModel.GetInstance().story_obj = null
		// if (step == 7)
		// 	AutoBrushModel.GetInstance().Fire(AutoBrushModel.NEXT_STEP_ARROW, 7)
		super.Close();
	}

	/**
	 * 古宝红点
	 */
	private UpdateSoapTabRedDot() {
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eSoap, this.monsterModel.GetSoapRedDotAll());
		this.BindEvent(this.monsterModel, MonsterModelEvent.UPDATE_RED_DOT, () => {
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eSoap, this.monsterModel.GetSoapRedDotAll());
		});
	}

	/**
	 * 斩妖红点
	 */
	UpdateAutoBrushRedDot() {
		let red_state = AutoBrushModel.GetInstance().GetRedState()
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eAutoBrush, red_state)

	}


	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}

		if (this.task_model.IsSpecialBrushTask()) {
			if (AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_1)
				&& AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_2)) {
				this.story_model.curr_view_story_step = 2
			}

			this.story_obj_list[TaskTipType.ActiveSoap] = [
				null,
				null,
				this._story_bar2,
				null,
				null]
		}


		super.createChildren()
	}


}
window["AutoBrushBaseView"] = AutoBrushBaseView