import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { TaskModel, TaskType, TaskTipType, TaskTypeColor } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PoseState } from "../util/StateMachineManager"
import { Status } from "../util/Status"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetLocalScale, Trim, SetAnchoredPositionX } from "../util/Util"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { MainUITaskItem } from "./MainUITaskItem"

export class MainUITaskMainLineItem extends MainUITaskItem {
	private finger_cache
	private force
	private step_cfg
	needSetLayer = false;

	public constructor(parent?) {
		super(parent)
		this.load_callback = () => {
			this.InitEvents()
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public InitEvents() {
		this.BindEvent(AutoBrushModel.GetInstance(), AutoBrushModel.SHOW_MAIN_TASK_ARROW, () => {
			let step_cfg = { direction: 4, text: "继续推进<font color='#0a9f42'>主线</font>" }
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_finger_con, this.layer_value, null, null, false, false, step_cfg, true)
		})
		super.InitEvent();
	}


	protected OnClick(): void {
		if (!this.task_model.last_click_main_ui_task_time || Status.NowTime - this.task_model.last_click_main_ui_task_time > 0.8) {
			if (this.task) {
				let main_role = Scene.GetInstance().GetMainRole()
				if (main_role && main_role.IsInState(PoseState.FLY_SHOE_EFFECT)) {
					return
				}
				this.HideMainLineArrow()
				if (this.task.task_type == TaskType.DAILY) {
					this.task_model.has_show_daily_task_finger = true
				} else {
					this.task_model.has_show_daily_task_finger = false
				}

				this.task_model.Fire(TaskModel.CLICK_DO_TASK, this.task.task_id, this.task.task_type)
				let finish = this.task_model.IsAllStepFinish(this.task.task_id)
				let dun_type = SceneManager.GetInstance().GetDunType(SceneManager.GetInstance().GetCurrDunId())
				if (finish && !this.task_model.IsFindNpcTask(this.task.task_tips_type)) {
					if (this.task_model.ThisTaskTypeCanShowView(this.task)) {
						this.task_model.Fire(TaskModel.TASK_OPEN_VIEW, "TaskFinishView", this.task)
					}
					else if (this.task.task_tips_type == TaskTipType.FinDunType && this.task.id == DUN_TYPE.Exp && dun_type == DUN_TYPE.Exp) {
						Message.show("副本还在继续哦~")
						return
					}
					else {
						TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.task.task_id)
					}
				} else {
					this.task_model.DoTask(this.task, null, null, true, true)
				}
				if (this.task_model.IsMainTask(this.task.task_id) && this.task.task_tips_type == TaskTipType.LV) {
					this.task_model.click_lv_arrow_time = TimeUtil.getServerTime()
				}
			}
			this.task_model.last_click_main_ui_task_time = Status.NowTime
		}
	}

	protected UpdateFunc(task_id?: any, task_tips_list?: any): void {
		if (!this.task_model.IsAllStepFinish(task_id)) {
			if (((this.data && this.task) && this.task.task_id == task_id) && task_tips_list) {
				this.data.tips_list = task_tips_list
				if (this.data.tips_list[0]) {
					this.task = this.FindUnFinishTask(this.data.tips_list)
					this.SetTipsMsg(this.task)
				}
			}
		}
	}

	public FirstTaskGo() {
		if (this.task_model.IsFirstTask()) {
			let step_cfg = { direction: 4, text: "点击此处完成任务吧" }
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_finger_con, this.layer_value, null, null, false, false, step_cfg, true)
		}
	}

	public SetData(data?) {

		this.data = data
		if (this.is_loaded && this.data.tips_list) {
			let task = this.FindUnFinishTask(this.data.tips_list)
			if (task) {
				// this.FirstTaskGo()
				this.task = task
				this.SetTaskData(task)
				if (this.finger_cache) {
					this.ShowMainLineArrow(this.step_cfg, this.force)
					this.finger_cache = false
				}
			}
		} else {
			this.need_refresh_data = true
		}
	}

	public ShowMainLineArrow(step_cfg?, force?) {
		if (this.is_loaded) { 
			// let step_cfg = null
			if(this.task_model.MainLineTaskNeedShowArrow()){
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_finger_con, "Main", null, null, true, null, step_cfg, force)
				this._box_finger_con.visible = true;
			}
		} else {
			this.finger_cache = true
			this.step_cfg = step_cfg
			this.force = force
		}
	}
}

window["MainUITaskMainLineItem"] = MainUITaskMainLineItem