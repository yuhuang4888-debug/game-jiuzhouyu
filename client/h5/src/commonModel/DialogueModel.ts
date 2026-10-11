import { Config } from "../common/Config"
import { NpcDialogVo } from "../dialogue/NpcDialogVo"
import { EventDispatcher } from "../util/EventDispatcher"


export enum DialogueTypeConst {
	//NPC对话内容<br>NPC=0
	NPC = 0,						// NPC对话内容
	//角色对话内容<br>ROLE=1
	ROLE = 1,						// 角色对话内容
	//确定<br>YES=2
	YES = 2,						// 确定
	//取消<br>NO=3
	NO = 3,						// 取消
	//发生战斗<br>FIGHT=4
	FIGHT = 4,					// 发生战斗
	//触发任务，附加参数，ARRAY(任务ID)<br>TRIGGER=5
	TRIGGER = 5,					// 触发任务，附加参数，ARRAY(任务ID)
	//完成任务，附加参数，ARRAY(任务ID)<br>FINISH=6
	FINISH = 6,					// 完成任务，附加参数，ARRAY(任务ID)
	//触发并完成任务<br>TRIGGER_AND_FINISH=7
	TRIGGER_AND_FINISH = 7,		// 触发并完成任务
	//触发对话事件<br>TALK_EVENT=8
	TALK_EVENT = 8,				// 触发对话事件
	//任务奖励<br>TASK_AWARD=38
	TASK_AWARD = 38,				// 任务奖励
	//进入副本<br>ENTER_DUNGEON = 41
	ENTER_DUNGEON = 41,			// 进入副本
	//离开副本<br>LEAVE_DUNGEON = 42
	LEAVE_DUNGEON = 42,			// 离开副本
	//回答错误<br>ANSWER_NO=43
	ANSWER_NO = 43,               // 回答错误
	//完成并触发新任务
	FINISH_AND_TRIGGER = 82,
	//婚宴仪式
	BANQUET = 172,
}
window["DialogueTypeConst"] = DialogueTypeConst

export class DialogueModel extends EventDispatcher {
	static SELECT_TASK = "SELECT_TASK"
	static CLICK_ANSWER = "CLICK_ANSWER"

	/**
	 * 默认对话
	 */
	static DEFAULT_TALK = {
		id: 1,
		total_content: 1,
		content: {
			"1": {
				total_list: 1,
				id: 10002,
				list: [
					{
						type: 0,
						text: ["听说这里而有好多好多的神话", "other"]
					}
				]
			}
		}
	}
	static Instance: DialogueModel

	public static GetInstance() {
		if (DialogueModel.Instance == null) {
			new DialogueModel()
		}
		return DialogueModel.Instance
	}


	/**
	 * 大于0就隐藏对话框
	 */
	hide_view = 0
	/**
	 * 对话框界面是否显示
	 */
	dialog_is_open = false

	is_auto = false
	dialog_view
	npc_dialog_vo: NpcDialogVo
	change_scene_close
	scmd_12101_send

	public constructor() {
		super()
		if (DialogueModel.Instance) {
			return
		}
		DialogueModel.Instance = this
	}

	GetDialogueId(npc_id?) {
		let npc_config = Config.GetConfigVo("config_npc", npc_id, false)
		let dialogueId
		if (npc_config) {
			dialogueId = Number(npc_config.talk)//npc默认对话
		}
		return dialogueId
	}

	GetNpcCfg(npc_id) {
		return Config.GetConfigVo("config_npc", npc_id, false)
	}

	/**
	 * 
	 * @param talk_id 
	 * @returns 
	 * {
		"id": "对话id",
		"total_content": 内容数量,
		"content": {
			"1": {
			"total_list": 对话数量,
			"list": {
				"1": {
					"type": 对话类型:DialogueTypeConst,
					"text": "对话内容",
					"other": "暂时未用到"
				},
				"id": 对应的npc_id暂时未用到
			}
		}
	 */
	GetTalkCfg(talk_id) {
		return Config.GetConfigVo("config_talk", talk_id, false)
	}

}
window["DialogueModel"] = DialogueModel