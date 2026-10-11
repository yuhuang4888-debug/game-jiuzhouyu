import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BossModel } from "../commonModel/BossModel"
import { HolyBattleModel } from "../commonModel/HolyBattleModel"
import { ReliveModel } from "../commonModel/ReliveModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { BossSceneManager } from "./BossSceneManager"

import "../bossSuit/BossSuitReliveView"
import { Scene } from "../scene/Scene"

//require("game.relive.ReliveModel")
export class ReliveController extends BaseController {

	model: ReliveModel
	scene_mgr: SceneManager
	boss_scene_mgr: BossSceneManager
	user_msg_adapter: UserMsgAdapter
	boss_model: BossModel


	last_view_class = null
	relive_view = null
	request_relive_lase_time = -3

	public constructor() {
		super()

		this.model = ReliveModel.GetInstance()
		this.scene_mgr = SceneManager.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.boss_model = BossModel.GetInstance()

		this.InitEvent()
		this.RegisterAllProtocals()
	}


	InitEvent = () => {
		let onShowReliveWindow = (type?) => {
			this.ShowReliveWindow(type)
		}

		GlobalEventSystem.Bind(EventName.SHOWRELIVEWINDOW, onShowReliveWindow)
		let onReLiveRequest = (relive_mode?, immediately_request?, isRelive?) => {
			this.ReLiveRequest(relive_mode, immediately_request, isRelive)
		}

		GlobalEventSystem.Bind(EventName.RELIVE_BY_TYPE, onReLiveRequest)
	}

	RegisterAllProtocals = () => {

		let handler20009 = () => {
			this.scene_mgr.can_relive = this.user_msg_adapter.ReadFmt("c")
			this.scene_mgr.next_relive_time = this.user_msg_adapter.ReadFmt("i")
			GlobalEventSystem.Fire(EventName.UPDATE_RELIVE_INFO, this.scene_mgr.next_relive_time)
		}

		let handler20004 = () => {
			let [type, flag] = this.ReadFmt("cc")
			if (0 == flag) {
				Message.show("绑定勾玉不足")
			} else if (1 == flag) {
				Message.show("复活成功")
				GlobalEventSystem.Fire(EventName.SHOWRELIVEWINDOW, 1, type)
				if (this.scene_mgr.IsBossScene()) {
					this.boss_scene_mgr.relive_success = true
				}
				if (this.model.isRelive) {
					if (((this.scene_mgr.IsFieldSpecialBossScene() || this.scene_mgr.IsFieldBossScene())||this.scene_mgr.IsFieldInfiniteBossScene() || this.scene_mgr.IsAbyssBossScene()) || this.scene_mgr.IsHolyTerritory()) {
						if (BossModel.GetInstance().JudgeTired(false)) {
							AutoFightManager.GetInstance().SetAutoFight(true)
						}
					}
					this.model.isRelive = false
				}
				//if (this.scene_mgr.IsPickUpDropScene() ) {
				//GlobalEventSystem:Fire(SceneEventType.REQUEST_PICK_UP_DROP_LIST)
				//}
				// if (this.scene_mgr.IsBossSnatchTreasure() ) {
				// 	SnatchTreasureModel.GetInstance().resetAutoFight()
				// } 
				if (this.scene_mgr.IsHolyBattleFightScene()) {
					HolyBattleModel.GetInstance().ResetAutoFight(type)
				}
				if (this.scene_mgr.IsEternityScene()){
					Scene.GetInstance().SetClickTarget(null)
					AutoFightManager.GetInstance().SetAutoFight(true)
				}
			} else if (2 == flag) {
				Message.show("绑定勾玉不足")
			} else if (3 == flag) {
				Message.show("角色未死亡！")
			} else if (4 == flag) {
				Message.show("复活时间未到！")
			} else if (5 == flag) {
				Message.show("复活冷却时间未到")
			} else if (6 == flag) {
				Message.show("铜币不足")
			} else if (7 == flag) {
				Message.show("复活次数已满")
			} else if (8 == flag) {
				Message.show("元宝复活次数已满")
			} else if (9 == flag) {
				Message.show("本副本不能复活")
			} else if (10 == flag) {
				Message.show("复活方式出错")
			} else if (11 == flag) {
				Message.show("物品不足")
			} else if (11 == flag) {
				Message.show("缺失配置")
			} else if (12 == flag) { // 回到安全区
				if (this.scene_mgr.IsBossScene()) {
					this.boss_scene_mgr.return_safe_success = true
				}
			} else if (255 == flag) {
			} else if ("default" == flag) {
				Message.show("复活异常 错误码 " + flag)
			}
		}

		this.RegisterProtocal(20004, handler20004)
		this.RegisterProtocal(20009, handler20009)
	}

	ShowReliveWindow = (type?) => {
		if (type == 0) {
			this.OpenReliveView()
		} else if (type == 1) {
			if (this.relive_view) {
				if (!this.scene_mgr.IsSuitBossScene()) {  //蛮荒boss复活界面内处理
					if (this.relive_view.HasOpen()) {
						this.relive_view.Close()
						this.relive_view = null
					}
				}
			}
		}
	}

	OpenReliveView = () => {
		let relive_class = null
		if (this.scene_mgr.IsDungeonScene() && !this.model.IsServerControl() && !this.scene_mgr.IsPolarDungeon()
			&& !this.scene_mgr.IsKFPolarDungeon() && !this.scene_mgr.IsVipPersonalBossDungeon() || this.scene_mgr.IsTopPkScene()
			|| this.scene_mgr.IsKf1vnFightScene()) {
			return
		}
		if (this.scene_mgr.IsBossScene() || this.scene_mgr.IsSeaHegemonyScene() || this.scene_mgr.IsSeaAsserScene()) {
			if (this.scene_mgr.IsAbyssBossScene()) {
				relive_class = "BossSuitReliveView"
			} else if (this.scene_mgr.IsSuitBossScene()) {
				relive_class = "BossSuitReliveView"
			} else {
				relive_class = "BossFieldReliveView"
			}
		} else if (this.scene_mgr.IsDungeonPartner()) {
			relive_class = "MainUIReliveView"
		} else if (this.scene_mgr.IsKfHolyAreaScene()) {
			relive_class = "BossFieldReliveView"
		} else if (this.scene_mgr.IsNineSkyFightScene()) {
			relive_class = "NineSkyReliveView"
		} else if (this.scene_mgr.IsGuildFightScene()) {
			relive_class = "BossFieldReliveView" //"GuildFightReliveView"
			// } else if (this.scene_mgr.IsEveningScene() || this.scene_mgr.IsFieldScene() || this.scene_mgr.IsDWScene() || this.scene_mgr.IsConvoyScene() ) {
		} else if (this.scene_mgr.IsFieldScene() || this.scene_mgr.IsDWScene() || this.scene_mgr.IsConvoyScene()) {
			relive_class = "BossFieldReliveView"
		} else if (this.scene_mgr.IsPolarDungeon() || this.scene_mgr.IsKFPolarDungeon()) {
			relive_class = "DungeonPolarReliveView"
		} else if (this.scene_mgr.IsEternityScene() ||
			this.scene_mgr.IsHolyBattleFightScene() ||
			this.scene_mgr.IsDiamondFightScene() ||
			this.scene_mgr.IsBrightSeaScene()) {
			return
		}
		else {
			relive_class = "MainUIReliveView"
		}

		if (this.relive_view && relive_class == this.last_view_class) {
			if (!this.relive_view.HasOpen()) {
				this.relive_view.Open()
			}
			return
		}
		let view_class: any = window[relive_class]
		if (!view_class) return
		this.relive_view = new view_class()
		this.relive_view.Open()
		this.last_view_class = relive_class

	}

	ReLiveRequest = (relive_mode?, immediately_request?, isRelive?) => {
		if (immediately_request == null) {

			immediately_request = false
		}
		let now_time = TimeUtil.getServerTime()
		if (isRelive) {
			this.model.isRelive = isRelive
		}
		if (immediately_request || now_time - this.request_relive_lase_time > 1) {
			this.request_relive_lase_time = now_time
			this.SendFmtToGame(20004, "c", relive_mode)
		}
	}
}
window["ReliveController"] = ReliveController