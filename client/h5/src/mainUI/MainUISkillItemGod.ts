import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { Runner } from "../util/Runner"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "../common/ResManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { SettingModel } from "../commonModel/SettingModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GodBefallModel, GodBefallEvent } from "../commonModel/GodBefallModel"
import { GameResPath } from "../util/GameResPath"
import { kfSingleRankModel } from "../commonModel/kfSingleRankModel"

export class MainUISkillItemGod extends BaseItem1 {
	AddEffect
	ChangeCDMask
	ChangeKeepMask
	CheckAutoGod
	CheckGodTime
	ClearKeepTimer
	ClearTimer
	InitEvent
	LoadSuccess
	RemoveUpdate
	SendProtoAuto
	StartCD
	StartKeepTimer
	StartTimer
	Update
	UpdateKeepTimer
	UpdateTimer

	_cd_end_time
	_cd_timer
	_keep_timer
	_cd_total_sec
	_kShape
	_keep_end_time
	_keep_time_id
	_keep_total_sec
	_model
	_send_time
	circle_mask1: Laya.Sprite
	circle_mask2: Laya.Sprite

	public constructor(parent?) {
		super(parent)
		this.base_file = "mainUI"
		this.layout_file = "MainUISkillItemGod"

		this._model = GodBefallModel.GetInstance()
		this._keep_end_time = 0
		this._keep_total_sec = 0
		this._send_time = 0

		//let local_laya = Laya
		let local_TimeUtil = TimeUtil
		let local_Runner = Runner
		//let local_Math = Math
		let local_GodBefallEvent = GodBefallEvent
		let local_Message = Message
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Scene = Scene.GetInstance()
		let local_SettingModel = SettingModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let scene_mgr = SceneManager.GetInstance()
		//let scene = Scene.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.circle_mask1 = new Laya.Sprite()
			this.circle_mask1.x = this._img_mask.width / 2
			this.circle_mask1.y = this._img_mask.height / 2
			this._img_mask.mask = this.circle_mask1

			this.circle_mask2 = new Laya.Sprite()
			this.circle_mask2.x = this._img_keep.width / 2
			this.circle_mask2.y = this._img_keep.height / 2
			this._img_keep.mask = this.circle_mask2

			if (this._model._cur_battle_id) {
				let gdata = this._model.GetGodData(this._model._cur_battle_id)
				ResManager.GetInstance().SetImageSprite(this, this.icon, "godBefallIcon", gdata.icon_id)

			}
			this._img_mask.visible = false
			this.CheckGodTime()
		}

		this.InitEvent = () => {
			//super.InitEvent()
			Util.AddClickEvent(this.con, () => {
				let show_worker = role_mgr.GetMainRoleVo().brick_id > 0 && scene_mgr.IsSeaAsserScene()
				if (show_worker) {
					local_Message.show("搬砖中不能变身")
					return
				}

				if (this._keep_timer) {
					local_Message.show("变身中")
					return
				}
				if (this._cd_timer) {
					local_Message.show("冷却中")
					return
				}
				this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44011)
			}, this, true)

			this.BindEvent(this._model, local_GodBefallEvent.KEEP_TIME, (scmd?) => {
				this.CheckGodTime()
			})

			this.BindEvent(this._model, local_GodBefallEvent.UPDATE_BATTLE_ID, (god_id?) => {
				let gdata = this._model.GetGodData(god_id)
				if (gdata) {
					ResManager.GetInstance().SetImageSpriteTrans(this, this.icon, GameResPath.GetIcon("godBefallIcon", gdata.icon_id))
				}
			})

			this.BindEvent(local_GlobalEventSystem, local_EventName.MAIN_ROLE_FIGHT, () => {
				this.SendProtoAuto()
			})

			// this.BindEvent(local_SettingModel, SettingModel.BLOCK_SETTING_CHANGE, (subtype?, is_open?) => {
			// 	if (subtype == 201 && is_open == 1) {
			// 		// this.SendProtoAuto()
			// 	}
			// })
		}

		this.Update = (now_time?, elapse_time?) => {
			if(this.use_delete_method) return
			let rtime = this._cd_end_time - local_TimeUtil.getServerTime()
			if (rtime < 0) {
				this.ClearTimer()
				this.RemoveUpdate()
				this._lb_cd.changeText("")
				this._img_mask.visible = false
				this.AddEffect()
			} else {
				let angle = rtime / this._cd_total_sec
				this.ChangeCDMask(angle)
			}
		}

		this.ChangeCDMask = (angle?) => {
			//this._img_mask.fillAmount = angle
			angle = 1 - angle
			this.circle_mask1.graphics.clear();
			this.circle_mask1.graphics.drawPie(0, 0, 50, angle * 360 - 90, 360 - 90, 0x000000)
		}

		this.StartCD = () => {
			if (!this._cd_timer) {
				this.StartTimer()
				local_Runner.GetInstance().AddRunObj(this)
				this._img_mask.visible = true
			}
		}

		this.RemoveUpdate = () => {
			local_Runner.GetInstance().RemoveRunObj(this.hashCode)
		}

		this.StartTimer = () => {
			this.ClearTimer()
			this.UpdateTimer()
			this._cd_timer = GlobalTimerQuest.AddPeriodQuest(() => {
				this.UpdateTimer()
			}, 1)
		}

		this.ClearTimer = () => {
			if (this._cd_timer) {
				GlobalTimerQuest.CancelQuest(this._cd_timer)
				this._cd_timer = null
			}
		}

		this.UpdateTimer = () => {
			let rtime = this._cd_end_time - local_TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_cd.changeText(String(rtime))
			}
		}

		this.ChangeKeepMask = (angle?) => {
			//this._kShape.graphics.clear()
			//this._kShape.graphics.beginFill("#00ffff", 1)
			//this._kShape.graphics.moveTo(0, 0)
			//this._kShape.graphics.lineTo(this.width / 2, 0)
			//this._kShape.graphics.drawArc(0, 0, this.width / 2, -local_Math.PI / 2, angle * local_Math.PI / 180 - local_Math.PI / 2, true)
			//this._kShape.graphics.lineTo(0, 0)
			//this._kShape.graphics.endFill()

			//this._img_keep.fillAmount = angle
			angle = 1 - angle
			this.circle_mask2.graphics.clear();
			this.circle_mask2.graphics.drawPie(0, 0, 50, angle * 360 - 90, 360 - 90, 0x000000)
		}

		this.StartKeepTimer = () => {
			this._img_keep.visible = true
			this.ClearKeepTimer()
			this.UpdateKeepTimer()
			this._keep_time_id =
				GlobalTimerQuest.AddPeriodQuest(() => {
					this.UpdateKeepTimer()
				}, 0.1)
		}

		this.ClearKeepTimer = () => {
			if (this._keep_time_id) {
				this.ChangeKeepMask(0)
				GlobalTimerQuest.CancelQuest(this._keep_time_id)
				this._keep_time_id = null
			}
		}

		this.UpdateKeepTimer = () => {
			if(this.use_delete_method) return
			let rtime = this._keep_end_time - local_TimeUtil.getServerTimeMs()
			if (rtime > 0) {
				let angle = rtime / this._keep_total_sec
				this.ChangeKeepMask(angle)
			} else {
				this.StartCD()
				this.ClearKeepTimer()
				this.ClearUIEffect(this._gp_eff)
				this._img_keep.visible = false
			}
		}

		this.CheckGodTime = () => {
			let scmd = this._model.GetGodTime()
			if (!scmd) {
				return
			}
			let data = this._model.GetGodData(this._model._cur_battle_id)
			if (!data) {
				return
			}
			this._keep_end_time = scmd.end_time * 1000
			this._keep_total_sec = data.trans_form_time * 1000
			this._cd_total_sec = data.cd
			this._cd_end_time = scmd.switch_cd
			let cur_time = local_TimeUtil.getServerTime()
			if (this._keep_end_time > cur_time * 1000) {
				this.ClearUIEffect(this._gp_eff)
				this.StartKeepTimer()
			} else {
				this.ClearKeepTimer()
				//this._img_keep.visible = false 
				if (!this._cd_end_time) {
					return
				}
				if (this._cd_end_time > cur_time) {
					this.ClearUIEffect(this._gp_eff)
					this.StartCD()
				} else {
					this.AddEffect()
				}
			}
		}

		this.CheckAutoGod = () => {
			if (!this._model._cur_battle_id) {
				return false
			}
			let is_open = local_SettingModel.GetBlockProperty(SettingModel.SettingType.SysSetting, "godbefall")
			let frobid = scene_mgr.IsForbidGodScene()
			let mainrole = local_Scene.GetMainRole()
			let time_can = TimeUtil.getServerTime() - this._send_time > 1
			let can = is_open == 1 && !frobid && mainrole && mainrole.vo.is_start_to_fight && mainrole.vo.god_id <= 0 && !mainrole.IsDead()
			if (can && time_can) {
				this._send_time = TimeUtil.getServerTime()
			}
			return can && time_can
		}

		this.SendProtoAuto = () => {
			let cur_time = local_TimeUtil.getServerTime()
			if (this._keep_end_time && this._keep_end_time > cur_time * 1000) {
				return
			}
			if (this._cd_end_time && this._cd_end_time > cur_time) {
				return
			}
			if (!this.CheckAutoGod()) {
				return
			}
			this._model.Fire(local_GodBefallEvent.REQUEST_PROTO, 44011)
		}

		this.AddEffect = () => {
			if (this._gp_eff.numChildren < 1) {
				this.AddUIEffect("UI_2049", this._gp_eff, null, 5, true)
			}
		}
	}

	public DeleteMe() {
		this.RemoveUpdate()
		this.ClearKeepTimer()
		this.ClearTimer()
		if (this._img_keep) {
			this._img_keep.visible = false
		}
		
		super.DeleteMe()
	}

	con: Laya.Box
	bg: Laya.Image
	icon: Laya.Image
	_Image1: Laya.Image
	_img_keep: Laya.Image
	_img_mask: Laya.Image
	_lb_cd: Laya.Label
	_gp_eff: Laya.Box
	public GetComponents() {
		[
			this.con,
			this.bg,
			this.icon,
			this._Image1,
			this._img_keep,
			this._img_mask,
			this._lb_cd,
			this._gp_eff,
		]
			= this.GetChildrenByNames([
				"con",
				"bg",
				"icon",
				"_Image1",
				"_img_keep",
				"_img_mask",
				"_lb_cd",
				"_gp_eff",
			])
	}
}
window["MainUISkillItemGod"] = MainUISkillItemGod