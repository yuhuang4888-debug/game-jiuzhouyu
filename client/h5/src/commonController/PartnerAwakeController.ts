import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName, SceneEventType } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { PartnerAwakeEvent } from "../commonModel/PartnerAwakeEvent"
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel"
import { PartnerModel } from "../commonModel/PartnerModel"
import { TaskModel } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

import "../partnerAwake/PartnerAwakeProView"
import "../partnerAwake/PartnerAwakeShowView"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"

export class PartnerAwakeController extends BaseController {
	InitEvent
	InitInfo

	model
	task_model
	view_dic


	public constructor() {
		super()

		this.model = PartnerAwakeModel.GetInstance();
		this.task_model = TaskModel.GetInstance()
		this.view_dic = {};
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let pre_client_cfg = Config.PRELOAD_CLIENT_CONFIG

		this.InitEvent = () => {

			this.model.Bind(PartnerAwakeEvent.AWAKE_REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			})

			this.model.Bind(PartnerAwakeEvent.AWAKE_OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					view = new window[view_name]
					this.view_dic[view_name] = view
				}

				if (view) {
					view.Open(...new_args)
				}
			})

			this.model.Bind(PartnerAwakeEvent.AWAKE_CLOSE_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name]
				if (view && view.HasOpen()) {
					view.Close()
				}
				this.view_dic[view_name] = null
			})


			GlobalEventSystem.Bind(EventName.GAME_START, () => {

			})

			//通过任务来刷新图标
			let all_task_fun = () => {
				if(!pre_client_cfg.ConfigPartnerAwake) return
				if (pre_client_cfg.ConfigPartnerAwake.TaskView) {
					let task_list = this.task_model.GetHasReceiveTaskList(pre_client_cfg.ConfigPartnerAwake.TaskView.root_task_id)
					if (task_list && PartnerAwakeModel.GetInstance().CanOpenPartnerAwakeView()) {
						PartnerModel.GetInstance().Fire(PartnerModel.REF_PARTNERSKILL)
						if (this.model.first_show == null || this.model.first_show == undefined) {
							this.model.first_show = true
							this.model.TaskUnLock()
						}
					} else {

					}
					this.model.RedDotFun()
				}
			}
			this.task_model.Bind(TaskModel.UPDATE_ALL_TASK_FROM_30000, all_task_fun)


			let task_fun = (new_finish_task_id?) => {
				//显示伙伴npc对话
				if (new_finish_task_id) {
					if (pre_client_cfg.ConfigPartnerAwake.ParnterTalkLastTaskId == new_finish_task_id) {
						GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
						GlobalEventSystem.Fire(SceneEventType.SHOW_TASK, pre_client_cfg.ConfigPartnerAwake.NpcId)
						//} else if (Config.ConfigPartnerAwake.ExpDungeonTaskId == new_finish_task_id ) { 
						//GlobalEventSystem:Fire(EventName.CLOSE_MOUNTPET_VIEW)
						//GlobalEventSystem:Fire(SceneEventType.SHOW_TASK, Config.ConfigPartnerAwake.NpcId2)			//npc对话
					}
				}
			}
			GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID_NOT_DELAY, task_fun)

			let update_red = () => {
				if(!pre_client_cfg.ConfigPartnerAwake) return
				PartnerAwakeModel.GetInstance().RedDotFun()
			}
			GoodsModel.GetInstance().Bind(GoodsModel.MOVE_GOODS_POS, update_red)
			//打完经验副本回来后要打开契灵唤醒界面
			let scene_complete_func = () => {
				let [has, task_vo] = this.task_model.HavePartnerAwakeDungeonTask()
				if (SceneManager.GetInstance().IsExpDungeon(SceneManager.GetInstance().GetLastDunId())
					&& has) {
					all_task_fun()
					GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
					GlobalEventSystem.Fire(SceneEventType.SHOW_TASK, pre_client_cfg.ConfigPartnerAwake.NpcId2)			//npc对话
				}
			}
			GlobalEventSystem.Bind(SceneManager.START, scene_complete_func)

			let dialogue_close = (npc_id?) => {
				if (npc_id == pre_client_cfg.ConfigPartnerAwake.NpcId2) {
					// this.model.Fire(PartnerAwakeEvent.AWAKE_OPEN_VIEW, "PartnerAwakeShowView")
					ViewPopLevelModel.GetInstance().SetView('PartnerAwakeShowView');
					this.model.show_return_finger = true
				}
			}
			GlobalEventSystem.Bind(SceneEventType.DIALOGUE_VIEW_IS_CLOSE, dialogue_close)

			//①发送完成任务协议，契灵唤醒的主任务,两个阶段的主任务
			let task_success_fun1 = (task_id?, task_tips_list?) => {
				if(!pre_client_cfg.ConfigPartnerAwake) return
				this.task_model.FinishPartnerAwake(task_id)
				this.model.RedDotFun()
			}
			this.task_model.Bind(TaskModel.UPDATE_ONE_TASK, task_success_fun1)

			//②打开契灵（新伙伴）功能开放
			let task_success_fun2 = (task_id?) => {
				if (pre_client_cfg.ConfigPartnerAwake.TaskView && task_id && pre_client_cfg.ConfigPartnerAwake.TaskView.root_task_id == task_id) {
					let delay_fun = () => {
						GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
						let cfgs = Config.PRELOAD_SERVER_CONFIG.config_module_open
						let vo = cfgs[pre_client_cfg.ConfigPartnerAwake.ParnterFunctionOpenId]
						//临时。原本还有个功能开启图标流程。即下面注释的FunctionOpenModel
						PartnerModel.GetInstance().Fire(PartnerModel.REQUSET_SCMD, 14204, pre_client_cfg.ConfigPartnerAwake.TaskView.partner_id)
						/*FunctionOpenModel.GetInstance().Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenAutoView", vo)*/
					}
					setTimeout(delay_fun, 0.7)
				}
				this.model.UnlockNewStep(task_id)

				if (pre_client_cfg.ConfigPartnerAwake.ExpDungeonTaskId == task_id) { 	//暂停任务
					//this.task_model.PauseAutoDoTask(true)
				}
			}
			this.task_model.Bind(TaskModel.FINISH_TASK, task_success_fun2)

			//③请求激活契灵（新伙伴）
			/*
			let fun_open = (id?) => {
				if (id && pre_client_cfg.ConfigPartnerAwake.ParnterFunctionOpenId == id) {
					PartnerModel.GetInstance().Fire(PartnerModel.REQUSET_SCMD, 14204, pre_client_cfg.ConfigPartnerAwake.TaskView.partner_id)
				}
			}
			FunctionOpenModel.GetInstance().Bind(FunctionOpenEvent.FUNCTIONOPEN_AUTO_VIEW_IS_CLOSE, fun_open)
			*/

			//④打开契灵（新伙伴）界面
			let close_fun = (id?, _type?) => {
				if (id && pre_client_cfg.ConfigPartnerAwake.TaskView.partner_id == id && _type && _type == 142) {
					OpenFun.OpenFunHandler(16)
				}
			}
			OutWardBaseModel.GetInstance().Bind(OutWardBaseModel.OUTWARD_CHANGE_VIEW_CLOSE, close_fun)

		}

		this.InitInfo = () => {
			// let Handler15700 = () => {
			// 	let scmd = user_msg_adapter.GetSCMD(15700)
			// 	Util.ErrorCodeShow(scmd.errcode)
			// }

			// this.RegisterProtocal(15700, Handler15700)
		}

		this.InitInfo()
		this.InitEvent()
	}
}
window["PartnerAwakeController"] = PartnerAwakeController