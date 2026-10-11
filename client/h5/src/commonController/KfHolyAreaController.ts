
//require("game.proto.284.Require284")
//require("game.kfHolyArea.KfHolyAreaModel")
//require("game.kfHolyArea.RequireKfHolyArea")
import { BaseController } from "../common/BaseController"
import { RoleManager } from "../commonModel/RoleManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { SceneManager } from "../scene/SceneManager"
import { EventName } from "../common/EventName"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { TimeUtil } from "../util/TimeUtil"
import { MainUIModel } from "../commonModel/MainUIModel"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { KfHolyAreaDefine } from "../kfHolyArea/KfHolyAreaDefine"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { MainUIController } from "./MainUIController"
import { Config } from "../common/Config"
import "../kfHolyArea/KfHolyAreaEnterView"
import "../kfHolyArea/KfHolyAreaBuildMsgView"
import "../kfHolyArea/KfHolyAreaSceneView"
import "../kfHolyArea/KfHolyAreaRebornTipsView"
import "../kfHolyArea/KfHolyAreaOwnerView"
import "../kfHolyArea/KfHolyAreaRankView"
import "../kfHolyArea/KfHolyAreaJumpView"
import { ReliveModel } from "../commonModel/ReliveModel"
import { TaskModel, TaskType } from "../commonModel/TaskModel"

export class KfHolyAreaController extends BaseController {
	kf_holy_area_model
	userMsgAdapter
	view_dic

	public constructor() {
		super()
		this.userMsgAdapter = UserMsgAdapter.GetInstance()
		this.kf_holy_area_model = KfHolyAreaModel.GetInstance()
		this.view_dic = []
		this.InitEvent()
		this.RegisterAllProtocals()
		//this.EnableCheckoutClear()
	}

	public RemoveCheckOutEvent() {

		if (this.view_dic) {
			for (let _ in this.view_dic) {
				var view = this.view_dic[_]
				view.DeleteMe()
			}
			this.view_dic = []
		}
	}

	public InitEvent() {


		GlobalEventSystem.Bind(EventName.INIT_CONFIG, () => {
			this.kf_holy_area_model.InitCfg()
		})

		GlobalEventSystem.Bind(EventName.GAME_START, async () => {
			
			await this.kf_holy_area_model.InitCfg();
			let delay_fun = () => {
				if (this.kf_holy_area_model.GetOpenState()) {
					this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28410)
					//this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28420)
				}
				this.kf_holy_area_model.RefreshIcon()
				this.kf_holy_area_model.initSceneTypeMap();
			}
			setTimeout(delay_fun, 3)

		})

		GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
			if (this.kf_holy_area_model.GetOpenState()) {
				this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28410)
			}
			this.kf_holy_area_model.RefreshIcon()
		})

		GlobalEventSystem.Bind(SceneManager.START, () => {
			this.ChangeScene()
		})

		this.kf_holy_area_model.Bind(KfHolyAreaModel.REQUEST_CCMD_EVENT, (cmd, ...new_args) => {
			let args = new_args
			let case1 = () => {
				this.SendFmtToGame(cmd, "i", args[0])
			}

			let case2 = () => {
				this.SendFmtToGame(cmd, "ii", args[0], args[1])
			}
			switch (cmd) {
				case 28401:
					case1()
					break;
				case 28403:
					case2()
					break;
				case 28409:
					case1()
					break;
				case 28404:
					case1()
					break;
				case 28408:
					case1()
					break;
				case 28412:
					case2()
					break;
				case 28422:
					this.SendFmtToGame(cmd, "h", args[0])
					break;
				default:
					this.SendFmtToGame(cmd)
					break;
			}



		})

		this.kf_holy_area_model.Bind(KfHolyAreaModel.OPEN_VIEW, (view_name: string, ...new_args) => {
			if (view_name == "KfHolyAreaEnterView") {
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				// if (open_day == KfHolyAreaDefine.NoticeIconShowDay) {
				// 	Message.show("活动暂未开启")
				// 	return
				// }
				let map_data = this.kf_holy_area_model.map_data
				if (!map_data) {
					Message.show("跨服服务器正在分配中，请耐心等待")
					return
				}
				if (!this.kf_holy_area_model.GetOpenState()) {
					Message.show("活动暂未开启")
					return
				}
				let time_data = this.kf_holy_area_model.time_data
				if (!time_data) {
					Message.show("活动暂未开启")
					return
				}
				let now_time = TimeUtil.getServerTime()
				if (now_time > time_data.act_end || now_time < time_data.act_start) {
					Message.show("9:00-次日2点开放跨服异域")
					return
				}
			}

			let view = this.view_dic[view_name]
			if (!view) {
				view = new window[view_name]
				this.view_dic[view_name] = view
			}
			if (!view.HasOpen()) {
				view.Open(...new_args)
			}
		})

		this.kf_holy_area_model.Bind(KfHolyAreaModel.CLOSE_VIEW, (view_name?) => {
			let view = this.view_dic[view_name]
			if (view && view.HasOpen()) {
				view.Close()
				this.view_dic[view_name] = null
			}
		})

		RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?) => {
			let open_lv = this.kf_holy_area_model.GetKeyValue("open_lv")
			if (open_lv && level == open_lv) {
				this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28410)
			}
		})

	}

	public RegisterAllProtocals() {

		//界面协议
		this.RegisterProtocal(28400, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28400)
			if (scmd.san_type == 0) {
				this.kf_holy_area_model.Fire(KfHolyAreaModel.CLOSE_VIEW, "KfHolyAreaEnterView")
				this.kf_holy_area_model.ChangeVar("map_data", null)
				return
			} else {
				table.sort(scmd.server_ids, (a?, b?) => {
					return a.camp < b.camp
				})
				this.kf_holy_area_model.RefreshSceneList(scmd)
				this.kf_holy_area_model.ChangeVar("map_data", scmd)
				this.kf_holy_area_model.build_data = null
				this.kf_holy_area_model.RefreshSceneData()
				this.kf_holy_area_model.RefreshAllCanMoveSceneList()
			}
		})

		//建筑信息
		this.RegisterProtocal(28401, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28401)
			this.kf_holy_area_model.SetSceneData(scmd.scene, scmd)
			this.kf_holy_area_model.FeastIconTimeShow()
		})

		//对应bossid的伤害排名
		this.RegisterProtocal(28403, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28403)
			this.kf_holy_area_model.ChangeVar("damage_data", scmd)
		})


		//进入
		this.RegisterProtocal(28404, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28404)
			if(scmd.is_task == 0){
				TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30011, TaskType.KFHOLYAREA_TASK)
			}
			Util.ErrorCodeShow(scmd.code)
		})

		//获取个人积分
		this.RegisterProtocal(28405, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28405)
			ResManager.GetInstance().GetGameConfigWithAutoDestory("config_c_sanctuary_score", (cfg?) => {
				let dic = {}
				for (let key in cfg) {

					let vo = cfg[key]
					dic[vo.score] = { score_cfg: vo.score, state: 0 }
				}
				for (let _tmpi in scmd.score_reward) {
					var vo = scmd.score_reward[_tmpi]
					dic[vo.score_cfg] = vo
				}
				let list = []
				for (let key in dic) {

					let vo = dic[key]
					table.insert(list, vo)
				}
				table.sort(list, (a?, b?) => {
					return a.score_cfg < b.score_cfg
				})
				scmd.score_reward = list
				this.kf_holy_area_model.ChangeVar("score_data", scmd)
				this.kf_holy_area_model.RefreshScoreRed()
			}, false)

		})

		//解锁个人积分奖励
		this.RegisterProtocal(28406, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28406)
			if (scmd.code == 1) {
				Message.show("解锁成功~")
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//退出
		this.RegisterProtocal(28407, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28407)
			Util.ErrorCodeShow(scmd.code)
		})

		//领取归属奖励
		this.RegisterProtocal(28408, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28408)
			if (scmd.code == 1) {
				let scene_data = this.kf_holy_area_model.GetSceneData(scmd.scene)
				if (scene_data) {
					scene_data.bl_reward_recieve = 2
					this.kf_holy_area_model.SetSceneData(scmd.scene, scene_data)
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//领取个人积分阶段奖励
		this.RegisterProtocal(28409, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28409)
			if (scmd.code == 1) {
				let score_data = this.kf_holy_area_model.score_data
				if (score_data) {
					for (let _tmpi in score_data.score_reward) {
						var vo = score_data.score_reward[_tmpi]
						if (vo.score_cfg == scmd.score) {
							vo.state = 2
							break
						}
					}
					this.kf_holy_area_model.ChangeVar("score_data", score_data, false, true)
					this.kf_holy_area_model.RefreshScoreRed()
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		})

		//活动状态变化通知客户端
		this.RegisterProtocal(28410, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28410)
			this.kf_holy_area_model.time_data = scmd
			this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28400)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28405)
			this.kf_holy_area_model.RefreshIcon()
			this.kf_holy_area_model.Fire(KfHolyAreaModel.CLOSE_VIEW, "KfHolyAreaEnterView")
		})

		//占领建筑后推送
		this.RegisterProtocal(28411, () => {
			// let scmd = this.userMsgAdapter.GetSCMD(28411)
			// let scene_data = this.kf_holy_area_model.GetSceneData(scmd.scene)
			// if (scene_data) {
			// 	scene_data.bl_reward_recieve = 1
			// 	this.kf_holy_area_model.SetSceneData(scmd.scene, scene_data)
			// }
			this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28400)
			// if (scmd.con_type == 2) {
			// 	this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaOwnerView", scmd)
			// }
		})

		//击杀记录
		this.RegisterProtocal(28412, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28412)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.KILL_DATA, scmd)
		})

		//boss 刷新推送
		this.RegisterProtocal(28413, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28413)
			if (!SceneManager.GetInstance().IsKfHolyAreaScene() && this.kf_holy_area_model.GetOpenState()
				&& !SceneManager.GetInstance().IsPolarDungeon()
				&& !SceneManager.GetInstance().IsKFPolarDungeon()) {
				this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaRebornTipsView")
				//this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28420)
			}
		})

		//错误返回
		this.RegisterProtocal(28414, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28414)
			Util.ErrorCodeShow(scmd.code)
		})

		//死亡疲劳
		this.RegisterProtocal(28415, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28415)
			ReliveModel.GetInstance().SetReliveTimeData(scmd, ReliveModel.BossSpecialReliveType.KfHolyArea)
		})

		//boss 死亡通知
		this.RegisterProtocal(28416, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28416)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.KILL_BOSS, scmd)
			BossModel.GetInstance().TryToCreatGrave()
		})

		//玩家踢出倒计时
		this.RegisterProtocal(28417, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28417)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.EXIT_COUNT_DOWN, scmd)
		})

		//获得拍卖品时推送
		this.RegisterProtocal(28418, () => {
			// let scmd = this.userMsgAdapter.GetSCMD(28418)
			// this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaFortressView", scmd)
			// AuctionModel.GetInstance().SetRedStatus(true)
			// AuctionModel.GetInstance().SetEffectState(true)
		})

		//排行
		this.RegisterProtocal(28419, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28419)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaAuctionRankView", scmd)
		})

		//拍卖结束时间戳
		this.RegisterProtocal(28420, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28420)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.UPDATE_REFRESH_BOSS_TIME, scmd.end_time)
		})

		//排行
		this.RegisterProtocal(28421, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28421);
			this.kf_holy_area_model.updateRankData(scmd);
			this.kf_holy_area_model.is_jump_tips = true;
			this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaRankView", scmd.scene_id)
			// if(scmd.scene_id){
			// 	let scene_type = this.kf_holy_area_model.scene_id_type_map[scmd.scene_id];
			// 	if(scene_type != 1){
			// 		this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaRankView", scmd.scene_id)
			// 	}else{
			// 		setTimeout(() => {
			// 			this.kf_holy_area_model.jumpSceneId(scmd.scene_id)
			// 		}, 1000);
			// 	}
			// }
			
		})

		//个人排行
		this.RegisterProtocal(28422, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28422)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.UPDATE_REFRESH_INDIVIDUAL_SCORE, scmd)
		})

		//个人排行
		this.RegisterProtocal(28423, () => {
			let scmd = this.userMsgAdapter.GetSCMD(28423)
			console.log("个人排行", scmd);
			
			if(scmd && scmd.scene_id){
				this.kf_holy_area_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28401, scmd.scene_id)
			}
		})
	}


	public ChangeScene() {

		let scene_mgr = SceneManager.Instance
		//setTimeout(() => {
		if (scene_mgr.IsKfHolyAreaScene() && !scene_mgr.IsKfHolyAreaScene(scene_mgr.GetLastSceneId())) {
			this.SetMainUIVisible(false)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaSceneView")
			//GlobalEventSystem:Fire(SceneEventType.REQUEST_PICK_UP_DROP_LIST)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
		} else if (!scene_mgr.IsKfHolyAreaScene() && scene_mgr.IsKfHolyAreaScene(scene_mgr.GetLastSceneId())) {
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, true)
			this.kf_holy_area_model.Fire(KfHolyAreaModel.CLOSE_VIEW, "KfHolyAreaSceneView")
			if (!SceneManager.GetInstance().IsDungeonScene() && !SceneManager.GetInstance().IsBossScene()) {
				this.SetMainUIVisible(true)
			}
		}
		//}, 1)

	}

	public SetMainUIVisible(bool?) {

		MainUIController.GetInstance().SetMainUIViewVisible(10, bool)
		MainUIController.GetInstance().SetMainUIViewVisible(13, bool)
		//MainUIController:GetInstance():SetMainUIViewVisible(12, bool)
	}
}
window["KfHolyAreaController"] = KfHolyAreaController