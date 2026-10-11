
//require("game.noonParty.NoonPartyModel")
//require("game.noonParty.NoonPartySceneView")

import { Alert, Alert_Type } from "../alert/Alert";
import { BaseController } from "../common/BaseController";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MainUIModel } from "../commonModel/MainUIModel";
import { NoonPartyModel, NoonPEvent } from "../commonModel/NoonPartyModel";
import { RoleManager } from "../commonModel/RoleManager";
import { SceneManager } from "../scene/SceneManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { MainUIController } from "./MainUIController";
import { EventName, SceneEventType } from "../common/EventName";
import "../noonParty/NoonPartySceneView"
export class NoonPartyController extends BaseController {
	InitInfo

	view_dic = {}
	enter_scene_event_list
	public constructor() {
		super()
		this.InitInfo = () => {
			let noon_model:NoonPartyModel = NoonPartyModel.GetInstance(),
				user_msg_adapter = UserMsgAdapter.GetInstance(),
				local_NoonPEvent = NoonPEvent,
				local_GlobalEventSystem = GlobalEventSystem,
				goods_model = GoodsModel.GetInstance(),
				scene_mgr = SceneManager.GetInstance(),
				mainUI_controller = MainUIController.GetInstance(),
				mainUI_model = MainUIModel.GetInstance()

			let On28500 = () => {
				let scmd = user_msg_adapter.GetSCMD(28500)
				Util.ErrorCodeShow(scmd.code)
			}

			let On28503 = () => {
				let scmd = user_msg_adapter.GetSCMD(28503)
				noon_model.ExpInfo = scmd.exp
				noon_model.Fire(local_NoonPEvent.UPDATE_EXP)
			}

			let On28504 = () => {
				let scmd = user_msg_adapter.GetSCMD(28504)
				noon_model.box_info = scmd
				noon_model.Fire(local_NoonPEvent.UPDATE_BOX)
			}

			let On28505 = () => {
				let scmd = user_msg_adapter.GetSCMD(28505)
				noon_model.Fire(local_NoonPEvent.BOSS_RELIVE_TIME, scmd.time)
			}

			let On28506 = () => {
				let scmd = user_msg_adapter.GetSCMD(28506)
				noon_model.Fire(local_NoonPEvent.UPDATE_END_TIME, scmd.time)
			}

			this.RegisterProtocal(28500, On28500)
			this.RegisterProtocal(28503, On28503)
			this.RegisterProtocal(28504, On28504)
			this.RegisterProtocal(28505, On28505)
			this.RegisterProtocal(28506, On28506)


			noon_model.Bind(local_NoonPEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

			let OpenView = (view_name: string, ...new_args) => {
				let view = this.view_dic[view_name]
				if (!view) {
					this.view_dic[view_name] = true

					let view_class = window[view_name]
					view = new view_class()
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic[view_name] = view
				}
				if (view && view != true) {
					if (view.HasOpen()) {
						view.Close()
					} else {
						view.Open(...new_args)
					}
				}
			}
			noon_model.Bind(local_NoonPEvent.OPEN_VIEW, OpenView)

			let monster_del = (ins_id) =>{
				noon_model.DeleteNotCollectMon(ins_id)
			}

			let server_cancal_call = (flag, type_id, ins_id) => {
				if(flag == 13 || flag == 7){
					noon_model.AddCanNotCollectMon(ins_id)
				}
			}

			let stop_auto_fun = (auto_fight_state) =>{
				if(!auto_fight_state){
					//每次取消自动挂机,清理不可采集目标列表
					noon_model.ClearNotCollectMon()
				}	
			}

			let ChangeScene = () => {
				let local_MainUIModel = MainUIModel
				if (scene_mgr.IsNoonPartyScene()) {
					mainUI_controller.SetMainUIViewVisible(10, false)
					mainUI_model.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
					OpenView("NoonPartySceneView")
					if(!this.enter_scene_event_list || this.enter_scene_event_list.length == 0){
						if(!this.enter_scene_event_list){
							this.enter_scene_event_list = []
						}
						this.enter_scene_event_list.push(GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_REMOVE, monster_del))
						this.enter_scene_event_list.push(GlobalEventSystem.Bind(EventName.SERVER_CANCEL_TO_COLLECT, server_cancal_call))
						this.enter_scene_event_list.push(GlobalEventSystem.Bind(EventName.UPDATE_AUTO_FIGHT_STATE, stop_auto_fun))
					}
				} else if (scene_mgr.IsNoonPartyScene(scene_mgr.last_scene_id)) {
					noon_model.ClearNotCollectMon()
					mainUI_controller.SetMainUIViewVisible(10, true)
					mainUI_model.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, true)
					let view = this.view_dic["NoonPartySceneView"]
					if (view && view.Close) {
						view.Close()
					}
					if(this.enter_scene_event_list && this.enter_scene_event_list.length > 0){
						for(let id of this.enter_scene_event_list){
							GlobalEventSystem.UnBind(id)
						}
						this.enter_scene_event_list.length = 0
					}
				}
			}

			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				ChangeScene()
			}
			)

			noon_model.Bind(local_NoonPEvent.ENTER_SCENE, () => {
				ResManager.GetInstance().GetGameConfigWithAutoDestory("config_midday_party_key_value", (cfgs?) => {
					if (goods_model.bag_goods_list.length > goods_model.bag_goods_max_cell - 2) {
						Alert.Show("当前背包空闲位置<2\n为了保证您在活动中的奖励拾取,请先整理背包!", Alert_Type.Two, () => {
							OpenFun.OpenFunHandler(105)
						}
						)
					} else {
						let lv_limit = cfgs[17].value || 100
						if (RoleManager.GetInstance().GetMainRoleVo().level >= lv_limit) {
							this.SendFmtToGame(28501)
						} else {
							Message.show(lv_limit + "级以上可参与午间派对")
						}
					}
				}, false)
			}
			)

			local_GlobalEventSystem.Bind(EventName.GAME_START, () => {
                noon_model.InitInfo()
				if(this.enter_scene_event_list && this.enter_scene_event_list.length > 0){
					for(let id of this.enter_scene_event_list){
						GlobalEventSystem.UnBind(id)
					}
					this.enter_scene_event_list.length = 0
				}
            })

		}

		this.InitInfo()
	}

}
window["NoonPartyController"] = NoonPartyController