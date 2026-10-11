import { EventDispatcher } from "../util/EventDispatcher"

export class DialogueTaskVo extends EventDispatcher {
	taskState
	taskType
	taskId
	taskName
	public static INDEX_LIST = [0, 1, 3, 0, 2]
	//(0.无 1.有可接任务 2.有未完成的任务 3.有可提交的任务 4.有任务对话)
	public constructor() {
		super()


		this.taskId = 0  //任务id
		this.taskState = 0		//任务状态
		this.taskName = ""  //任务名称
		this.taskType = 0		//任务类型	
	}
	public __delete() {


	}

	public index() {

		return DialogueTaskVo.INDEX_LIST[this.taskState + 1]
	}
}

window["DialogueTaskVo"] = DialogueTaskVo