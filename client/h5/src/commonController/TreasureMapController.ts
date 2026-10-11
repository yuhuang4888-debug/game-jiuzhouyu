import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import "../treasureMap/TMTUseView"
import "../treasureMap/TMTreasureView"
import { Scene } from "../scene/Scene"

export class TreasureMapController extends BaseController {
	private Init: Function;

	public constructor() {
		super()

		let model = TreasureMapModel.GetInstance();
		let local_GlobalEventSystem = GlobalEventSystem;
		let local_EventName = EventName;
		let local_TreasureMapModel = TreasureMapModel;
		let scene_mgr = SceneManager.GetInstance();
		let local_SceneEventType = SceneEventType;
		let user_msg_adapter = UserMsgAdapter.GetInstance();
		this.Init = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.InitConfig()
			});

			let request = () => {
				// model.Fire(local_TreasureMapModel.TM_REQUEST_SCMD, 51001)
			}

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, request);
			local_GlobalEventSystem.Bind(ServerTimeModel.HOUR_REFRESH, request);
			model.Bind(local_TreasureMapModel.TM_REQUEST_SCMD, (scmd, ...new_args) => {
				let args = new_args
				if (20301 == scmd) {
					this.SendFmtToGame(scmd, "l", args[0])
				} else if (20302 == scmd) {
					this.SendFmtToGame(scmd, "cl", args[0], args[1])
				} else if (51002 == scmd) {
					this.SendFmtToGame(scmd, "i", args[0])
				} else if (51003 == scmd) {
					this.SendFmtToGame(scmd, "i", args[0])
				} else if (51004 == scmd) {
					this.SendFmtToGame(scmd, "i", args[0])
				} else if (51005 == scmd) {
					this.SendFmtToGame(scmd, "i", args[0])
				} else {
					this.SendFmtToGame(scmd)
				}
			}
			)
			model.Bind(local_TreasureMapModel.TM_USE_GOODS, (goods_vo?, is_bag?) => {
				if (is_bag == null) {
					is_bag = true
				}
				let lv = RoleManager.GetInstance().mainRoleInfo.level
				if (lv < model.limit_lv) {
					Message.show(model.limit_lv + "级方可使用")
					return
				}
				if (!scene_mgr.IsFieldScene()) {
					Message.show("当前场景不能使用")
					return
				}
				if (goods_vo) {
					model.use_good_vo = goods_vo
					model.Fire(local_TreasureMapModel.TM_REQUEST_SCMD, 20301, goods_vo.goods_id)
					if (is_bag) {
						local_GlobalEventSystem.Fire(local_EventName.OPEN_BAG_VIEW)
					}
				}
			}
			)
			local_GlobalEventSystem.Bind(SceneManager.START, () => {
				let data = model.scmd20301_data
				if ((data && scene_mgr.curr_scene_id == data.scene) && model.is_change_scene) {
					model.is_change_scene = false
					AutoFightManager.GetInstance().SetAutoFight(false)
					model.TreasureMove(data)
					model.scmd20301_data = null
				} else if (model.findingWay) {
					AutoFightManager.GetInstance().SetAutoFight(true)
					model.SetFindingWayState(false)
					model.Reset()
				} else if (data) {
					model.Reset()
				}
			}
			)
			model.Bind(local_TreasureMapModel.TM_COLLECT, () => {
				let vo = model.use_good_vo
				if (vo) {
					let type = (vo.type_id == model.goods_list[2] && (2) || (1))
					model.Fire(local_TreasureMapModel.TM_REQUEST_SCMD, 20302, type, vo.goods_id)
				}
			})

			model.Bind(local_TreasureMapModel.TM_USE_GOODS_AGAIN, (type?) => {
				let type_id = model.goods_list[type]
				let goods_list = GoodsModel.GetInstance().GetTypeGoods(type_id)
				if (goods_list && goods_list.length > 0) {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "TMTUseView", goods_list[0])
				}
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.CONGRATULATION_VIEW_CLOSE, () => {
				let type = model.is_next_use_type
				if (type) {
					model.Fire(local_TreasureMapModel.TM_USE_GOODS_AGAIN, type)
					model.is_next_use_type = 0
				}
			}
			)
			local_GlobalEventSystem.Bind(local_SceneEventType.CHANGE_FIND_WAY_STATE, (pos?) => {
				if (model.findingWay && !pos) {
					model.SetFindingWayState(false)
					if (!model.collecting) {
						AutoFightManager.GetInstance().SetAutoFight(false)
					}
				}
			}
			)
			let On20300 = () => {
				let scmd = user_msg_adapter.GetSCMD(20300)
				Util.ErrorCodeShow(scmd.code)
				model.Reset()
			}

			let On20301 = () => {
				let scmd = user_msg_adapter.GetSCMD(20301)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					model.Reset()
					return
				}
				let cur_scene_id = scene_mgr.curr_scene_id
				if (cur_scene_id == scmd.scene) {
					AutoFightManager.GetInstance().SetAutoFight(false)
					model.TreasureMove(scmd)
				} else {
					let scene_cfg = Config.PRELOAD_SERVER_CONFIG.config_scene && Config.PRELOAD_SERVER_CONFIG.config_scene[scmd.scene];
					this.Fire(local_SceneEventType.REQUEST_CHANGE_SCENE, scmd.scene, scene_cfg.x, scene_cfg.y);
					model.scmd20301_data = scmd
					model.is_change_scene = true
				}

			}

			let On20302 = () => {
				let scmd = user_msg_adapter.GetSCMD(20302)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					model.Reset()
					return
				}
				AutoFightManager.GetInstance().SetAutoFight(true)
				if (scmd.type == 1) {
					Util.ShowCongratulationView(scmd.reward, 10)
					model.is_next_use_type = 1;
					// 退出采集动作
					Scene.GetInstance().MainRoleQuitCollect();
				} else {
					local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "TMTreasureView", scmd)
				}
				model.Reset()
			}

			let On20303 = () => {
				let scmd = user_msg_adapter.GetSCMD(20303)
				scmd.mod_id = 20303
				model.Fire(local_TreasureMapModel.TM_RECORD_LIST, scmd)
			}

			let On51001 = () => {
				let scmd = user_msg_adapter.GetSCMD(51001)
				model.BossSetData(scmd)
				model.Fire(TreasureMapModel.TM_ROTARY_NUM)
			}

			let On51002 = () => {
				let scmd = user_msg_adapter.GetSCMD(51002);
				model.BossAddData(scmd);
				if (model.rotary_data) {
					model.Fire(TreasureMapModel.TM_ROTARY_NUM, scmd);
				};
			};

			let On51003 = () => {
				let scmd = user_msg_adapter.GetSCMD(51003);
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code);
					return;
				}
				model.BossDeleteData(scmd.rotary_id);
			};

			let On51004 = () => {
				let scmd = user_msg_adapter.GetSCMD(51004)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code);
					model.is_request = false;
					return;
				}
				model.Fire(local_TreasureMapModel.TM_GET_REWARD, scmd, 51004);
			}

			this.RegisterProtocal(20300, On20300)
			this.RegisterProtocal(20301, On20301)
			this.RegisterProtocal(20302, On20302)
			this.RegisterProtocal(20303, On20303)
			this.RegisterProtocal(51001, On51001)
			this.RegisterProtocal(51002, On51002)
			this.RegisterProtocal(51003, On51003)
			this.RegisterProtocal(51004, On51004)
		}

		this.Init()
	}
}
