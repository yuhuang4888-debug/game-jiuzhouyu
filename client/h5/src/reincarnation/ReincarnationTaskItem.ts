import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { OpenFun } from "../common/OpenFun";
import { ReincarnationModel } from "../commonModel/ReincarnationModel";
import { RoleManager } from "../commonModel/RoleManager";
import { TaskModel, TaskTipType, TaskType } from "../commonModel/TaskModel";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";

export class ReincarnationTaskItem extends BaseItem1 {
	reinmodel
	need_refresh
	taskVo
	public constructor(parent?) {
		super(parent)


		this.reinmodel = ReincarnationModel.GetInstance();
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationTaskItem"
		this.load_callback = () => {

			if (this.need_refresh) {
				this.SetData(this.taskVo)
			}
			this.go_label.text = ""
			this.InitEvent()
		}
	}

	public InitEvent() {


		let local_taskModel = TaskModel
		let local_taskModelIns = local_taskModel.GetInstance()
		Util.AddClickEvent(this.finishBtn, () => {
			let taskVo = this.taskVo
			if (taskVo && taskVo.task_tips_type == 61) {
				if (taskVo.now_num < taskVo.need_num) {
					let goodsPriceCfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price
					if (goodsPriceCfg && goodsPriceCfg[taskVo.id]) {
						let needMoney = (taskVo.need_num - taskVo.now_num) * goodsPriceCfg[taskVo.id].price
						let content = ""
						content = "当前拥有" + taskVo.now_num + "个材料"
						Alert.Show("是否消耗<font color='#0a953e'>" + needMoney + "勾玉</font>", Alert_Type.Three, () => {
							local_taskModelIns.Fire(local_taskModel.REQUEST_CCMD_EVENT, 30006, taskVo.task_id, taskVo.id, taskVo.need_num)
						}
							, null, null, null, null, null, null, null, null, "resource/game/common/texture/com_diamond.png", "补足材料完成任务？", null, content)
					}
				}
			}
		}, this, true)
		Util.AddClickEvent(this.wayBtn, () => {
			local_taskModelIns.now_do_task_type = TaskType.REINCARNATION
			OpenFun.OpenFunHandler(77)
		}, this, true)

		Util.AddClickEvent(this.submitBtn, () => {
			let taskVo = this.taskVo
			if (taskVo && taskVo.task_tips_type == 61) {
				local_taskModelIns.Fire(local_taskModel.REQUEST_CCMD_EVENT, 30006, taskVo.task_id, taskVo.id, taskVo.need_num)
			}
		}
			, this, true)
		Util.AddClickEvent(this.click_group, () => {
			GlobalEventSystem.Fire(EventName.CLOSE_REINCARNATION_ENTER_VIEW)
			local_taskModelIns.now_do_task_type = TaskType.REINCARNATION
			local_taskModelIns.DoTask(this.taskVo, true)
		}
			, this, true)
	}

	public SetData(taskVo?) {
		this.taskVo = taskVo
		if (this.is_loaded) {
			this.need_refresh = false
			this.line.visible = this.reinmodel.GetCurTurn() < 4 ? false : true
			this.btnGroup.visible = taskVo.task_tips_type == 61 && taskVo.has_finish == 0
			this.click_group.visible = taskVo.task_tips_type != 61 && taskVo.has_finish == 0
			this.task_label.style.fontSize = 24
			this.task_label.style.color = "#663915"
			this.task_label.style.wordWrap = false


			if (taskVo.has_finish > 0) {
				this.task_label.innerHTML = taskVo.task_tips_msg + "<font color='#639c12'>" + "(" + taskVo.now_num + "/" + taskVo.need_num + ")" + "</font>"
			} else {
				this.task_label.innerHTML = taskVo.task_tips_msg + "(<font color='#D15E00'>" + taskVo.now_num + "/" + taskVo.need_num + ")" + "</font>"
			}
			if (taskVo.task_tips_type == TaskTipType.CollectMaterial) {
				// this.finishBtn.visible = taskVo.now_num < taskVo.need_num
				// this.wayBtn.visible = taskVo.now_num < taskVo.need_num
				// this.submitBtn.visible = taskVo.now_num >= taskVo.need_num
				// this.subRed.visible = taskVo.now_num >= taskVo.need_num
			}

			let goRedState = false
			if (taskVo.task_tips_type == TaskTipType.CollectMaterial) {
				goRedState = true
			} else if (taskVo.task_tips_type == TaskTipType.FinDungeon) {
				let cfg1 = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, taskVo.id, false)
				if (cfg1 && cfg1.recommend_power) {
					goRedState = cfg1.recommend_power <= RoleManager.GetInstance().GetMainRoleVo().fighting
				}
			}
			this.goRed.visible = goRedState
			this.finishImage.visible = taskVo.has_finish > 0
			if (taskVo.has_finish > 0) {
				this.finishImage.x = this.task_label.contextWidth + 20
			}
			let reinmodel = ReincarnationModel.GetInstance()
			// this.new_go_gp.visible = this.reinmodel.GetCurTurn() < 4 ? true : false
			// this.old_go_gp.visible = this.reinmodel.GetCurTurn() < 4 ? false : true
		} else {
			this.need_refresh = true
		}
	}


	_Group1: Laya.Box
	task_label: Laya.HTMLDivElement
	finishImage: Laya.Image
	line: Laya.Image
	click_group: Laya.Box
	old_go_gp: Laya.Box
	go_label: Laya.Label
	_Image11: Laya.Image
	new_go_gp: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	goRed: Laya.Image
	btnGroup: Laya.Box
	finishBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay: Laya.Label
	wayBtn: Laya.Box
	_Image1111: Laya.Image
	labelDisplay1: Laya.Label
	submitBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay11: Laya.Label
	subRed: Laya.Image
	public GetComponents() {
		[
			this._Group1,
			this.task_label,
			this.finishImage,
			this.line,
			this.click_group,
			this.old_go_gp,
			this.go_label,
			this._Image11,
			this.new_go_gp,
			this._Image2,
			this._Label1,
			this.goRed,
			this.btnGroup,
			this.finishBtn,
			this._Image111,
			this.labelDisplay,
			this.wayBtn,
			this._Image1111,
			this.labelDisplay1,
			this.submitBtn,
			this._Image1,
			this.labelDisplay11,
			this.subRed,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"task_label",
				"finishImage",
				"line",
				"click_group",
				"old_go_gp",
				"go_label",
				"_Image11",
				"new_go_gp",
				"_Image2",
				"_Label1",
				"goRed",
				"btnGroup",
				"finishBtn",
				"_Image111",
				"labelDisplay",
				"wayBtn",
				"_Image1111",
				"labelDisplay1",
				"submitBtn",
				"_Image1",
				"labelDisplay11",
				"subRed",
			])
	}
}
window["ReincarnationTaskItem"] = ReincarnationTaskItem