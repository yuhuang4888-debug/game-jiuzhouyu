
//require("game.snatchTreasure.SnatchTreasureModel")
//require("game.snatchTreasure.SnatchTreasureRankView")
//require("game.snatchTreasure.SnatchTreasureSceneView")
//require("game.snatchTreasure.SnatchTreasureView")
//require("game.snatchTreasure.STreasureFortressView")
//require("game.snatchTreasure.SnatchTreasureIntegralItem")
//require("game.snatchTreasure.SnatchTreasureRankItem")
//require("game.snatchTreasure.STreasureSceneRankItem")
//require("game.proto.652.Require652")
//require("game.sacredShop.SacredShopItem")
//require("game.sacredShop.SacredShopView") 

import { BaseController } from "../common/BaseController";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { EventName, SceneEventType } from "../common/EventName";
import { table } from "../common/table";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel";
import { SceneManager } from "../scene/SceneManager";
import { SnatchTreasureSceneView } from "../snatchTreasure/SnatchTreasureSceneView";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { MainUIController } from "./MainUIController";

export class SnatchTreasureController extends BaseController {
	InitInfo

	public constructor() {
		super()


		this.InitInfo = () => {
			let snatch_treasure_scene_view = null
			let success_view = null
			let _model = SnatchTreasureModel.GetInstance()
			_model.Bind(SnatchTreasureModel.SCMD_REQUEST, (cmd, ...new_args) => {
				//

				//if ("default" == cmd ) {
				this.SendFmtToGame(cmd)
				//}
				//}
				//
			}
			)
			//GlobalEventSystem:Bind(EventName.CONGRATULATION_VIEW_CLOSE,(hashCode?) => {
			//if (success_view && success_view.hashCode == hashCode ) {
			//let data = _model._auction_data
			//if (data && data.goods.length > 0 ) {
			//GlobalEventSystem:Fire(EventName.OPEN_VIEW, "STreasureFortressView", data)
			//_model._auction_data = null
			//}
			//}
			//}
			//)
			let On65201 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65201)
				_model.setDunData(scmd)
			}

			let On65202 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65202)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				} else {
					_model.setDunId(scmd.dunid)
					_model._allWave = scmd.total_wave
					_model.SetroundTime(scmd.first_wave_time)
					_model.endtime = scmd.end_time
					_model._mon_num = scmd.num
				}
			}

			let On65203 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65203)
				_model.setSelfHurtData(scmd)
			}

			let On65204 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65204)
				_model.setHurtListData(scmd)
			}

			let On65205 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65205)
				let reward_list = []
				for (let key in scmd.reward) {

					//if (scmd.reward.hasOwnProperty(key) ) {
					// [ts2lua]scmd.reward下标访问可能不正确
					let info = scmd.reward[key]
					table.insert(reward_list, [info.style, info.typeId, info.count])
					//}
				}
				if (reward_list.length > 0) {
					success_view = new CongratulationObtainView(reward_list, 10)
					success_view.Open()
				}
			}

			let On65206 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65206)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On65207 = () => {
				//let scmd = UserMsgAdapter.GetInstance().GetSCMD(65207)
				//if (success_view && success_view.isPop ) {
				//_model._auction_data = scmd
				//}else{
				//GlobalEventSystem:Fire(EventName.OPEN_VIEW, "STreasureFortressView", scmd)
				//}
			}

			let On65208 = () => {
				let scmd = UserMsgAdapter.GetInstance().GetSCMD(65208)
				_model.timeMsgData = scmd
				GlobalEventSystem.Fire(EventName.REFRESH_FORESHOWICON)
			}

			this.RegisterProtocal(65201, On65201)
			this.RegisterProtocal(65202, On65202)
			this.RegisterProtocal(65203, On65203)
			this.RegisterProtocal(65204, On65204)
			this.RegisterProtocal(65205, On65205)
			this.RegisterProtocal(65206, On65206)
			this.RegisterProtocal(65207, On65207)
			this.RegisterProtocal(65208, On65208)
			let SetMainUIVisible = (bool?) => {
				MainUIController.GetInstance().SetMainUIViewVisible(10, bool)
			}

			let ChangeScene = () => {
				let scene_mgr = SceneManager.Instance
				if (scene_mgr.IsBossSnatchTreasure() && !scene_mgr.IsBossSnatchTreasure(scene_mgr.GetLastSceneId())) {
					// [ts2lua]window下标访问可能不正确
					//if (! window["SnatchTreasureSceneView"] ) {
					//if (! ResManager.GetInstance().IsJsLoad("snatchTreasure") ) {

					//}
					//}
					SetMainUIVisible(false)
					if (!snatch_treasure_scene_view) {
						// [ts2lua]window下标访问可能不正确
						snatch_treasure_scene_view = new SnatchTreasureSceneView()
					}
					if (!snatch_treasure_scene_view.HasOpen()) {
						snatch_treasure_scene_view.Open()
					}
				}
				if (scene_mgr.IsBossSnatchTreasure(scene_mgr.GetLastSceneId()) && !scene_mgr.IsBossSnatchTreasure()) {
					SetMainUIVisible(true)
					if (snatch_treasure_scene_view && snatch_treasure_scene_view.HasOpen()) {
						snatch_treasure_scene_view.Close()
						snatch_treasure_scene_view = null
					}
				}
			}

			let scene_changed_func = () => {
				ChangeScene()
			}

			GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
		}
			;
		this.InitInfo()
	}
}
window["SnatchTreasureController"] = SnatchTreasureController
