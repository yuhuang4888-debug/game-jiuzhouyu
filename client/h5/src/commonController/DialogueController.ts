

import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DialogueModel, DialogueTypeConst } from "../commonModel/DialogueModel"
import { TaskModel } from "../commonModel/TaskModel"
import { DialogueView } from "../dialogue/DialogueView"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { TaskVo } from "../sharedata/TaskVo"
import { NpcDialogVo } from "../dialogue/NpcDialogVo"


/**
 * 对话模块
 */
export class DialogueController extends BaseController {
	dialogue_view: DialogueView
	user_msg_adapter: UserMsgAdapter = UserMsgAdapter.GetInstance()
	dialogue_model: DialogueModel = DialogueModel.GetInstance()
	task_model: TaskModel = TaskModel.GetInstance()
	public constructor() {
		super()
		this.RegisterAllProtocals()
		this.InitEvents()
	}

	RegisterAllProtocals() {

		let On12101 = () => {
			if (this.dialogue_model.scmd_12101_send) {
				this.dialogue_model.scmd_12101_send = false
				let scmd = this.user_msg_adapter.GetSCMD("12101")
				//@ts-ignore
				scmd.task_id = 0
				this.ShowNpcTalk(scmd)
			}

		}

		let On12102 = () => {
			let scmd = this.user_msg_adapter.GetSCMD("12102")
			if (this.dialogue_model.change_scene_close == true) {
				return
			}
			console.log("On12102:", scmd.npc_id, scmd.task_id, scmd.talk_id)

			let npc_dialog_vo = new NpcDialogVo()
			npc_dialog_vo.Set12102Scmd(scmd)
			this.dialogue_model.npc_dialog_vo = npc_dialog_vo

			//奖励这里获取
			let task_tips_list = this.task_model.GetAllTaskList(npc_dialog_vo.task_id)
			if (task_tips_list && task_tips_list[0]) {
				let award_list = []
				let task_vo: TaskVo = task_tips_list[0]
				if (task_vo.special_goods_list) {
					let list = ErlangParser.GetInstance().Parse(task_vo.special_goods_list)
					if (list) {
						for (let _tmpi in list) {
							var vo = list[_tmpi]
							if (Number(vo[0]) == RoleManager.GetInstance().GetMainRoleCareer()) {
								award_list.push([0, Number(vo[2]), Number(vo[3])])
							}
						}
					}
				}
				let list2 = ErlangParser.GetInstance().Parse(task_vo.award_list)
				if (list2) {
					for (let _tmpi in list2) {
						var vo = list2[_tmpi]
						award_list.push(vo)
					}
				}
				npc_dialog_vo.SetAward(award_list)
			}

			let content_count = npc_dialog_vo.GetTalkContentCount()
			if (content_count > 0) {
				let contents = npc_dialog_vo.GetTalkContent()
				for (let i = 1; i <= content_count; i++) {
					var v1 = contents[i]
					var list_count = npc_dialog_vo.GetTalkContentListCount(i)
					if (list_count > 0) {
						for (let j = 1; j <= list_count; j++) {
							var v2 = v1.list[j]
							if (v2.type == 0 && (v2.text).trim() == "") {
								//对话内容为空字符串，直接接受任务
								let data = this.task_model.GetCanTaskList(npc_dialog_vo.task_id)
								if (data && data[0]) {
									this.AcceptTask(npc_dialog_vo.task_id)
								}

								//对话内容为空字符串，直接完成任务
								data = this.task_model.GetHasReceiveTaskList(npc_dialog_vo.task_id)
								if (data && data[0]) {
									this.FinishTask(npc_dialog_vo.task_id)
								}
								return
							}
						}
					}
				}
			}
			this.ShowDialog(npc_dialog_vo)
		}
		this.RegisterProtocal(12101, On12101) //npc关联任务
		this.RegisterProtocal(12102, On12102) //获取任务对话
	}

	ShowDialog(npc_dialog_vo) {
		if (!npc_dialog_vo) return
		if (!this.dialogue_view) {
			this.dialogue_view = new DialogueView()
		}
		this.dialogue_view.Open(npc_dialog_vo)
	}

	CloseDialoueView() {
		if (this.dialogue_view && this.dialogue_view.HasOpen()) {
			this.dialogue_view.Close()
		}
	}

	InitEvents() {
		this.Bind(DialogueModel.SELECT_TASK, (npc_id, task_id, state) => {
			this.SelectTask(npc_id, task_id, state)
		})

		this.Bind(DialogueModel.CLICK_ANSWER, (dialog_vo, dialog_node_vo) => {
			this.ClickAnswerHandler(dialog_vo, dialog_node_vo)
		})

		this.Bind(SceneEventType.SHOW_TASK, (id) => {
			this.dialogue_model.change_scene_close = false
			this.dialogue_model.is_auto = false   //发事件过来的要重置一下auto状态
			this.ShowTask(id)
		})

		// this.Bind(EventName.SEND_TASK_ACCEPT, (id) => {
		// 	this.dialogue_model.change_scene_close = false
		// 	this.AcceptTask(id)
		// })

		// this.Bind(EventName.SEND_TASK_FINISH, (id, arr) => {
		// 	this.dialogue_model.change_scene_close = false
		// 	this.FinishTask(id)
		// })

		GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
			this.CloseDialoueView()
			this.dialogue_model.change_scene_close = true
		})

		GlobalEventSystem.Bind(SceneEventType.CLOSE_DIALOGUE_VIEW, () => {
			this.CloseDialoueView()
		})
	}

	ShowTask(id?) {
		this.dialogue_model.scmd_12101_send = true
		this.SendFmtToGame(12101, "i", id)
	}

	/**
	* 显示对话
	* @param npc_id NPCID
	* @param task_id 任务ID
	* @param state 任务状态
	*
	*/
	SelectTask(npc_id, task_id, state) {
		this.SendFmtToGame(12102, "ii", npc_id, task_id)
		this.dialogue_model.is_auto = false
	}

	/**
	 * 接受任务
	 * @param task_id 
	 */
	AcceptTask(task_id) {
		task_id = Number(task_id)
		this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30003, task_id)
		this.dialogue_model.is_auto = true
	}

	/**
	 * 完成任务
	 * @param task_id 
	 */
	FinishTask(task_id) {
		this.dialogue_model.is_auto = true
		this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, task_id)
	}

	/**
	 * 任务对话事件
	 * @param npc_id NPCID
	 * @param task_id 任务ID
	 */
	TalkToNPC(npc_id?, task_id?) {
		this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30007, npc_id)
		this.dialogue_model.is_auto = true;
	}

	/**
	 * 
	 * @param scmd12101 
	 * @returns 
	 */
	ShowNpcTalk(scmd: ProtoRecvVObj<12101>) {
		let npc_dialog_vo = new NpcDialogVo()
		npc_dialog_vo.Set12101Scmd(scmd)
		this.dialogue_model.npc_dialog_vo = npc_dialog_vo

		let task_list: any[] = npc_dialog_vo.GetTaskList()
		let talk_count = task_list.length

		/**
			同个npc下面可能同时会有主线和支线任务，12101协议任务数据可能会有2条，
			这样客户端就不知道应该选择哪个任务来触发相关操作， 所以在开始任务前，客户端先记下当前任务id，
			这里判断12101协议里面的任务数据是不是存在当前客户端保存的当前任务id，存在的话就把非当前任务的数据删掉
		*/
		if (this.task_model.now_select_task_id && task_list.length > 1) {
			let find = false
			for (let i = 0; i < task_list.length; i++) {
				var v = task_list[i]
				if (v.task_id == this.task_model.now_select_task_id) {
					find = true
					break
				}
			}
			if (find) {
				let delete_index = []
				for (let i = 0; i < task_list.length; i++) {
					var v = task_list[i]
					if (v.task_id != this.task_model.now_select_task_id) {
						delete_index.push(i)
					}
				}
				let del_num = delete_index.length

				for (let i = del_num - 1; i < 0; i--) {
					task_list.splice(i, 1)
				}
				talk_count = 1
			}
		}


		// 跳过空对话
		if (this.dialogue_model.is_auto == true && talk_count == 0) {
			this.dialogue_model.is_auto = false
			return
		}

		// task_state  0.无 1.可接 2.接了未完成 3.完成可提交 4.有任务对话
		if (npc_dialog_vo.GetTalkContentCount() == 1
			&& npc_dialog_vo.GetTalkContentListCount(1) == 1
			&& talk_count == 1
			&& task_list[0].task_state != 2) {
			this.SelectTask(npc_dialog_vo.npc_id, task_list[0].task_id, task_list[0].task_state)
		} else {
			if (npc_dialog_vo.npc_id == 0 && npc_dialog_vo.IsDefaultTalk()) { //当npc_id 是0 ，而且是默认对话的时候，对话框就不显示出来了
				return
			}
			if (this.dialogue_model.is_auto == false) {
				this.ShowDialog(npc_dialog_vo)
			} else if (talk_count > 0) {
				let is_show = false
				for (let _ in task_list) {
					var taskNodeVo = task_list[_]
					if (taskNodeVo.task_state != 2) {
						is_show = true
					}
				}
				if (is_show && npc_dialog_vo.talk_id) {
					this.ShowDialog(npc_dialog_vo)
				}
			}
		}
		this.dialogue_model.is_auto = false
	}

	/**
	 * 点击NPC对话框确定按钮
	 * @param dialogueVo 
	 * @param dialogueNodeVo 
	 * @param selected 
	 * @param double 
	 */
	ClickAnswerHandler(dialogueVo, dialogueNodeVo) {
		if (dialogueNodeVo.type == DialogueTypeConst.FINISH_AND_TRIGGER) {
			this.FinishTask(dialogueVo.task_id);
		} else if (dialogueNodeVo.type == DialogueTypeConst.TRIGGER) {
			this.AcceptTask(dialogueVo.task_id);
		} else if (dialogueNodeVo.type == DialogueTypeConst.FINISH) {
			this.FinishTask(dialogueVo.task_id);
		} else if (dialogueNodeVo.type == DialogueTypeConst.TRIGGER_AND_FINISH) {

		} else if (dialogueNodeVo.type == DialogueTypeConst.TALK_EVENT) {
			this.TalkToNPC(dialogueVo.npc_id, dialogueVo.task_id)
		}
	}
}
window["DialogueController"] = DialogueController