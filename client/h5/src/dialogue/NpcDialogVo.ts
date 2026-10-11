import { DialogueModel } from "../commonModel/DialogueModel"
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util"

export class NpcDialogVo extends EventDispatcher {
	/**
	 * 对话id
	 */
	talk_id
	/**
	 * npcId
	 */
	npc_id = 0
	/**
	 * 当前任务的id
	 */
	task_id = 0
	/**
	 * 任务列表
	 */
	task_list = []
	/**
	 * 对话配置
	 */
	talk_cfg
	/**
	 * 是否隐藏
	 */
	is_hide = false
	/**
	 * 当前任务奖励
	 */
	award_list
	/**
	 * 是否使用默认对话
	 */
	use_default_talk = false

	dialogue_model:DialogueModel = DialogueModel.GetInstance()
	public constructor() {
		super()
	}

	InitVo(){
		//对话id
		let talk_id = this.dialogue_model.GetDialogueId(this.npc_id)
		this.talk_id = talk_id

		//对话配置
		let talk_cfg = this.dialogue_model.GetTalkCfg(this.talk_id)
		if (talk_cfg){
			talk_cfg = Util.DeepCopy(talk_cfg)
			talk_cfg.content = JSON.parse(talk_cfg.content)
			this.talk_cfg = talk_cfg
		}
		
		//默认对话
		if (!this.talk_cfg) {
			console.log("里面找不到该对话id, 显示默认对话:", talk_id)
			this.talk_cfg = Util.DeepCopy(DialogueModel.DEFAULT_TALK)
			this.use_default_talk = true
		}
	}

	InitVo2(){
		//对话配置
		let talk_cfg = this.dialogue_model.GetTalkCfg(this.talk_id)
		if (talk_cfg){
			talk_cfg = Util.DeepCopy(talk_cfg)
			talk_cfg.content = JSON.parse(talk_cfg.content)
			this.talk_cfg = talk_cfg
		}
		//默认对话
		if (!this.talk_cfg) {
			console.log("里面找不到该对话id, 显示默认对话:", this.talk_id)
		}
	}

	GetTalkContentCount(){
		if(this.talk_cfg){
			return this.talk_cfg.total_content
		}
		return 0
	}

	GetTalkContentByIndex(index){
		if(this.talk_cfg && this.talk_cfg.content){
			return this.talk_cfg.content[index]
		}
	}

	GetTalkContentListCount(content_index){
		if(this.talk_cfg && this.talk_cfg.content[content_index]){
			return this.talk_cfg.content[content_index].total_list
		}
		return 0
	}

	GetTalkContent(){
		if(this.talk_cfg){
			return this.talk_cfg.content
		}
	}

	GetTaskList(){
		return this.task_list
	}

	GetTaskByIndex(index){
		return this.task_list && this.task_list[index]
	}

	IsDefaultTalk(){
		return this.use_default_talk
	}

	Set12101Scmd(scmd:ProtoRecvVObj<12101>){
		this.npc_id = scmd.npc_id
		this.task_list = scmd.task_list
		this.InitVo()
	}

	Set12102Scmd(scmd:ProtoRecvVObj<12102>){
		this.npc_id = scmd.npc_id
		this.task_id = scmd.task_id
		this.talk_id = scmd.talk_id
		this.InitVo2()
	}

	SetAward(award_list){
		this.award_list = award_list
	}

	GetAwardList(){
		return this.award_list
	}
}

window["NpcDialogVo"] = NpcDialogVo