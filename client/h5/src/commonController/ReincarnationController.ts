

import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { ReincarnationEnterView } from "../reincarnation/ReincarnationEnterView"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDelta, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"


import "../reincarnation/ReincarnationSkillTipsView";
import "../reincarnation/ReincarnationSuccessView";
import "../reincarnation/ReincarnationEffectView";
import "../reincarnation/ReincarnationFourView";
import "../reincarnation/ReincarnationFiveView";
import "../reincarnation/ReincarnationSixView";
import "../reincarnation/ReincarnationSevenView";
import "../reincarnation/ReincarnationLigthedView";
import "../reincarnation/ReincarnationLightUpView";
import "../reincarnation/ReincarnationPoint";




export class ReincarnationController extends BaseController {
	InitInfo
	not_do_task_id

	public constructor() {
		super()

		let rebirthModel = ReincarnationModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let layer_mgr = LayerManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_ReincarnationModel = ReincarnationModel
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let reincarnation_enter_view
		let task_model = TaskModel.GetInstance()
		let view_dic_ = []
		this.InitInfo = () => {
			let On13040 = () => {
				let scmd = null
				scmd = []
				scmd.career = this.ReadFmt("c"); scmd.sex = this.ReadFmt("c"); scmd.turn = this.ReadFmt("c"); scmd.stage = this.ReadFmt("c")
				let roleinfo = role_mgr.mainRoleInfo
				if (scmd.turn > roleinfo.turn) {
					GlobalEventSystem.Fire(EventName.CLOSE_REINCARNATION_ENTER_VIEW)
					// let top_layer: Laya.Node = layer_mgr.GetUILayer(Enum_UILayer.Top)
					// if (top_layer) {
					// 	let _background = new Laya.Image()	 //UiFactory.CreateChild(top_layer, UIType.Image)
					// 	top_layer.addChild(_background)
					// 	top_layer.setChildIndex(_background, 0)
					// 	ResManager.GetInstance().SetImageSprite(this, _background, "common_asset", "com_sub_bg_9")
					// 	SetSizeDelta(_background, layer_mgr.stageWidth + 10, layer_mgr.stageHeight + 10)
					// 	let resouceStr = null
					// 	if (roleinfo.career == 1) {
					// 		resouceStr = "ui_1107_1"
					// 	} else if (roleinfo.career == 2) {
					// 		resouceStr = "ui_1108_1"
					// 	} else if (roleinfo.career == 3) {
					// 		resouceStr = "ui_1107"
					// 	} else if (roleinfo.career == 4) {
					// 		resouceStr = "ui_1108"
					// 	}
					// 	rebirthModel.is_show_effect = true
					// 	TaskModel.GetInstance().not_dotask = true
					// 	let effect_group = new Laya.Box	// 	UiFactory.CreateChild(top_layer, UIType.EmptyUI)
					// 	// effect_group.transform.SetSiblingIndex(1)
					// 	top_layer.setChildIndex(effect_group, 1)
					// 	// ResManager.GetInstance().SetUIEffect(this, resouceStr, "Top", effect_group.transform, new Vector3(0, 50, 0), null, false, {
					// 	// call_back_func =() => {

					// 	if (_background) {
					// 		top_layer.removeChildren(0)
					// 		_background = null
					// 	}
					// 	if (effect_group) {
					// 		top_layer.removeChildren(1)
					// 		// destroy(effect_group, true)
					// 		effect_group = null
					// 	}
					// 	rebirthModel.Fire(local_ReincarnationModel.REBIRTH_OPEN_VIEW, "ReincarnationSuccessView")
					// 	rebirthModel.is_show_effect = false
					// 	TaskModel.GetInstance().not_dotask = false
					// 	if (this.not_do_task_id) {
					// 		clearTimeout(this.not_do_task_id)
					// 		this.not_do_task_id = null
					// 	}
					// }
					// // })
					// this.not_do_task_id = setTimeout(() => {
					// 	TaskModel.GetInstance().not_dotask = false
					// }, 10)

					// }



					//effect:AddUIEffect(resouceStr, effect_group, null, null, null, null,() => {
					//if (_background ) {
					//effect:ClearUIEffect(effect)
					//_background.parent.removeChild(_background)
					//}
					//if (effect ) {
					//effect:DeleteMe()
					//effect = null
					//}
					//if (effect_group ) {
					//effect_group.parent.removeChild(effect_group)
					//effect_group = null
					//}
					//}
					//,() => {
					//_background.visible = true
					//_background.includeInLayout = true
					//let index = top_layer.getChildIndex(effect_group)
					//top_layer:addChildAt(_background, index - 1)
					//local_GlobalEventSystem:Fire(local_EventName.HIDE_WAITFOR_OPENVIEW_LOADING, effect_group.hashCode)
					//}
					//)
					//}
				}
				roleinfo.ChangeVar("turn", scmd.turn)
				roleinfo.ChangeVar("turn_stage", scmd.stage)
				if (scmd.turn >= 7) {
					GlobalEventSystem.Fire(EventName.CLOSE_REINCARNATION_ENTER_VIEW)
				}
				rebirthModel.Fire(local_ReincarnationModel.UPDATE_FINISH_REIN, scmd)
				rebirthModel.Fire(local_ReincarnationModel.REBIRTH_OPEN_VIEW, "ReincarnationEffectView")
			}

			let On13041 = () => {
				let turn_stage = this.ReadFmt("c")
				let roleinfo = role_mgr.mainRoleInfo
				rebirthModel.SetCurStage(turn_stage)
				roleinfo.ChangeVar("turn_stage", turn_stage)
			}

			let On16400 = () => {
				let scmd = user_msg_adapter.GetSCMD(16400)
				rebirthModel.SetAwkenActiveList(scmd)
			}

			let On16401 = () => {
				let scmd = user_msg_adapter.GetSCMD(16401)
				if (scmd.code == 1) {
					Message.show("成功点亮命格")
					this.SendFmtToGame(16400)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			this.RegisterProtocal(13040, On13040)
			this.RegisterProtocal(13041, On13041)
			this.RegisterProtocal(16400, On16400)
			this.RegisterProtocal(16401, On16401)
			//let onInitCurRein = () => {
			//rebirthModel:InitCurRein()
			//rebirthModel:LoadCfg()
			//}

			//local_GlobalEventSystem:Bind(local_EventName.INIT_CONFIG, onInitCurRein)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, async () => {
				rebirthModel.LoadCfg()
				rebirthModel.InitCurRein()
				this.SendFmtToGame(16400)
			}
			)

			let update_red_time_id
			let onRedChange = () => {
				if (update_red_time_id) {
					return
				}
				update_red_time_id = setTimeout(() => {
					update_red_time_id = undefined
					rebirthModel.UpdateRedDot()
				}, 500);
			}

			let onChangeMainRoleLevelHandler = () => {
				if (role_mgr.mainRoleInfo.level >= rebirthModel.turn_level_list[4] && !rebirthModel.last_awaken_id) {
					this.SendFmtToGame(16400)
				}
				rebirthModel.Fire(local_ReincarnationModel.UPDATE_AWAKEN_CELL)
				let is_max = rebirthModel.IsMaxStage()
				rebirthModel.Fire(local_ReincarnationModel.UPDATE_MAINUI_MAX_STAGE, is_max)

			}

			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, onChangeMainRoleLevelHandler)
			role_mgr.GetMainRoleVo().BindOne("turn", onChangeMainRoleLevelHandler)

			let onFinishRein = (data?) => {
				if (data) {
					rebirthModel.SetCurTurn(data.turn + 1)
					rebirthModel.SetCurStage(data.stage)
					rebirthModel.Fire(local_ReincarnationModel.UPDATE_TURN_VIEW)
					onRedChange()
				}
			}

			rebirthModel.Bind(local_ReincarnationModel.UPDATE_FINISH_REIN, onFinishRein)
			rebirthModel.Bind(local_ReincarnationModel.REBIRTH_OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = view_dic_[view_name]
				if (!view) {
					let view_class = window[view_name]
					view = new view_class()
					view_dic_[view_name] = view
				}
				if (view) {
					if (view.HasOpen()) {
						view.Close()
					} else {
						view.Open(...new_args)
					}
				}
			}
			)
			let OpenTipsView = (vo?) => {
				if (vo) {
					if (vo.state == 2) {
						rebirthModel.Fire(local_ReincarnationModel.REBIRTH_OPEN_VIEW, "ReincarnationLigthedView", vo)
					} else if (vo.state == 0 || vo.state == 1) {
						rebirthModel.Fire(local_ReincarnationModel.REBIRTH_OPEN_VIEW, "ReincarnationLightUpView", vo)
					}
				}
			}

			rebirthModel.Bind(local_ReincarnationModel.OPEN_TIPS_VIEW, OpenTipsView)
			let onSendAwakenCell = (id?) => {
				this.SendFmtToGame(16401, "i", id)
			}

			rebirthModel.Bind(local_ReincarnationModel.SEND_AWAKEN_CEll, onSendAwakenCell)


			role_mgr.GetMainRoleVo().BindOne("turn", onRedChange)
			role_mgr.GetMainRoleVo().BindOne("fighting", onRedChange)
			task_model.Bind(TaskModel.UPDATE_REINCARNATION_TASK_LIST, onRedChange)
			// let ChangeGood = (List?) => {
			// 	if (List) {
			// 		for (let _tmpi in List) {
			// 			var vo = List[_tmpi]
			// 			if (vo.type == 38 && vo.subtype == 11) {
			// 				rebirthModel.UpdateRedDot()
			// 				break
			// 			}
			// 		}
			// 	}
			// }

			GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, onRedChange)
			let StarRein = () => {
				let taskVo = task_model.GetReincarnationTaskList()
				if (taskVo && taskVo.length > 0) {
					let task_id = taskVo[0].task_id
					let taskInfo = taskVo[0]
					if ((taskInfo.task_tips_type == TaskTipType.CollectMaterial && taskInfo.now_num >= taskInfo.need_num) && !rebirthModel.CollectRealFinish) {
						this.SendFmtToGame(30006, "iii", taskInfo.task_id, taskInfo.id, taskInfo.need_num)
					}
					this.SendFmtToGame(30004, "i", task_id);
				}
			}

			rebirthModel.Bind(local_ReincarnationModel.STAR_REIN, StarRein)
			let Request16400 = () => {
				this.SendFmtToGame(16400)
			}

			rebirthModel.Bind(local_ReincarnationModel.UPDATE_CUR_REIN, Request16400)

			let open_reincarnation_view = (index?) => {
				//if (reincarnation_enter_view && ! reincarnation_enter_view.HasOpen() ) {
				//reincarnation_enter_view:DeleteMe()
				//reincarnation_enter_view = null
				//}
				if (!reincarnation_enter_view) {
					let view_class = window["ReincarnationEnterView"]
					reincarnation_enter_view = new view_class()
				}
				if (!reincarnation_enter_view.HasOpen()) {
					//if (index != null ) {
					//reincarnation_enter_view:SetDefaultIndex(index)
					//}
					reincarnation_enter_view.Open()
					//}else{
					//reincarnation_enter_view:SetSelectIndex(index || 1)
				}
			}
			local_GlobalEventSystem.Bind(EventName.OPEN_REINCARNATION_ENTER_VIEW, open_reincarnation_view)

			let close_medal_view = () => {
				if (reincarnation_enter_view && reincarnation_enter_view.HasOpen()) {
					reincarnation_enter_view.Close()
				}
			}
			local_GlobalEventSystem.Bind(EventName.CLOSE_REINCARNATION_ENTER_VIEW, close_medal_view)

			let scene_changed_func = () => {
				if (!SceneManager.GetInstance().IsReincarnationDungeon() && SceneManager.GetInstance().IsReincarnationDungeon(SceneManager.GetInstance().GetLastDunId())) {
					if (!reincarnation_enter_view) {
						reincarnation_enter_view = new ReincarnationEnterView()
					}
					if (!reincarnation_enter_view.HasOpen()) {
						reincarnation_enter_view.Open()
					}
				}
			}
			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
		}

		this.InitInfo()
	}

}


window["ReincarnationController"] = ReincarnationController