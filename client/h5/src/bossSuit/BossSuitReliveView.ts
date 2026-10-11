import { BaseView1 } from "../common/BaseView1"
import { Util, Trim } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { SceneManager } from "../scene/SceneManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest } from "../util/Util"
import { BossSceneManager, BossSceneEvent } from "../commonController/BossSceneManager"
import { GuildModel, GuildEvent, GuildDefine } from "../commonModel/GuildModel"
import { TimeUtil } from "../util/TimeUtil"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { RoleManager } from "../commonModel/RoleManager"
import { BossModel } from "../commonModel/BossModel"
import { LayerManager } from "../common/LayerManager"
import { Message } from "../sysInfo/SysInfoController"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"
import { DressModel } from "../commonModel/DressModel"

export class BossSuitReliveView extends BaseView1 {
	CancelHelpTimer
	CancelTime
	InitEvent
	InitView
	SetSuitBossBg
	SetSuitBossInfo
	StartHelpTimer
	StartTime
	SuitBossReliveView
	UpdateHelpData
	UpdateHelpTimer

	close_one
	close_suit
	close_time
	exit
	help_timer
	is_Owner
	left_time
	onTimer
	timer
	cfg_boss_type_kv
	cfg_picture

	public constructor() {
		super()
		this.base_file = "suitboss"
		this.layout_file = "BossSuitReliveView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.change_scene_close = false
		this.use_background = true
		this.click_bg_toClose = false
		this.back_login_toClose = true
		this.not_close_by_android_back_key = true
		this.preload_server_config = {
			"config_boss_type_key_value": false
			// "config_picture": false
		}

		this.left_time = 2
		this.close_time = 0
		this.is_Owner = false
		this.close_suit = false
		this.close_one = true

		let scene_mgr = SceneManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let boss_mgr = BossSceneManager.GetInstance()
		let guild_model = GuildModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_Message = Message
		let scene = Scene.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let layer_mgr = LayerManager.GetInstance()
		let voice

		this.load_callback = () => {
			this.cfg_boss_type_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_type_key_value", false)
			// this.cfg_picture = ResManager.GetInstance().GetGameConfigFromCache(this, "config_picture", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("boss", "com_up_bg2"))
			voice = CommonManager.GetInstance().PlayFightingVoice(1)
		}

		this.open_callback = () => {
			this.InitView()
			this.InitEvent()
		}

		this.close_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			
			this.is_Owner = false;
			this.CancelTime()
			this.CancelHelpTimer()
		}

		this.InitEvent = () => {
			let Bg_CallBack = () => {
				if (scene_mgr.IsSuitBossScene() || scene_mgr.IsSuitBossScene(scene_mgr.GetLastSceneId())) {
					this.close_suit = true
					this.Close()
				}
				if (scene_mgr.IsMysteryBossScene() || scene_mgr.IsMysteryBossScene(scene_mgr.GetLastSceneId())) {
					this.Close()
				}
			}
			Util.AddClickEvent(this._img_bg, Bg_CallBack, this, false)

			Util.AddClickEvent(this._btn_left, () => {
				local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 15)
			}, this, true)

			Util.AddClickEvent(this._btn_right, () => {
				local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 13)
			}, this, true)

			this.BindEvent(boss_mgr, BossSceneEvent.CLOSE_SUIT_RELIVE_VIEW, () => {
				this.close_suit = true
				this.Close()
			})

			let open_boss_view = () => {
				this.Close()
			}
			this.BindEvent(local_GlobalEventSystem, local_EventName.OPEN_BOSS_ENTER_VIEW, open_boss_view)

			Util.AddClickEvent(this._gp_exit, () => {
				this.exit()
			}, this, true)

			Util.AddClickEvent(this._btn_help, () => {
				let etime = guild_model.boss_etime
				if (etime > local_TimeUtil.getServerTime()) {
					local_Message.show("请求协助冷却中")
				} else {
					guild_model.boss_etime = local_TimeUtil.getServerTime() + GuildDefine.BOSS_HELP_CD
					guild_model.Fire(GuildEvent.REQUEST_PROTO, 40060)
					this.StartHelpTimer()
					local_Message.show("已向结社成员发起求助")
				}
			}, this, true)
		}

		this.InitView = () => {
			if (scene_mgr.IsBossScene()) {
				this.SuitBossReliveView()
			}
			let name = scene_mgr.killerName
			this._lb_content.text = "很遗憾！您被" + name + "所击杀！"
		}

		this.SuitBossReliveView = () => {
			let boss = null
			if (boss_mgr.select_boss_id != 0) {
				boss = scene.GetMonsterByTypeId(boss_mgr.select_boss_id)
			}
			if (role_mgr.GetMainRoleVo().boss_flag == 1) {
				this.is_Owner = true
			}
			let effect_width = 262
			let effect_height = 384
			let width = layer_mgr.stageWidth
			let height = layer_mgr.stageHeight
			let scale_x = width / effect_width
			let scale_y = height / effect_height
			// if (BossModel.GetInstance().is_owner_snatch) {
			// 	this.AddUIEffect2("ui_frame_red", this._gp_effect, null, { x:scale_x, y:scale_y }, true)
			// 	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("fieldBoss", "uiboss_039a"))
			// } else {
			// 	this.AddUIEffect2("ui_frame_white", this._gp_effect, null, { x:scale_x, y:scale_y }, true)
			// 	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("fieldBoss", "uiboss_039b"))
			// }
			this.SetSuitBossBg()
			this.SetSuitBossInfo()
		}

		this.SetSuitBossBg = () => {
			if (this.is_Owner && scene_mgr.killerType == SceneBaseType.Role) {
				//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("suitboss", "uiboss_037a"))
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("boss", "up_title_5"), true)
			} else {
				//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("suitboss", "uiboss_037b"))
				ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("boss", "up_title_5"), true)
			}
		}

		this.SetSuitBossInfo = () => {
			if (scene_mgr.killerType == SceneBaseType.Role) {
				let role_vo = scene_mgr.GetRoleVo(scene_mgr.killerId)
				if (role_vo) {
					let is_mask = (scene_mgr.KillerMaskId != 0 || role_vo.mask_id != 0) && scene_mgr.CanMaskScene()
					let lv = (role_vo.level > 370 && ("神创" + (role_vo.level - 370) + "级") || ("LV." + role_vo.level))
					this._lb_name.text = (is_mask && ("蒙面人") || (scene_mgr.killerName + " " + lv))
					this._bit_fight.visible = true
					this._bit_fight.text = (is_mask && ("") || (role_vo.fighting))
					this._img_fight.visible = true
					let career = role_vo.career && role_vo.career || role_mgr.mainRoleInfo.career
					let picture_source = DressModel.GetInstance().getHeadICon(91, career)
					if (role_vo.picture && Trim(String(role_vo.picture)) != "") {
						picture_source = DressModel.GetInstance().getHeadICon(91,career)
					}

					ResManager.GetInstance().SetImageSprite(this, this._img_head,"head", picture_source)
					//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetHeadPath(picture_source))
				}
			}
			if (scene_mgr.killerType == SceneBaseType.Monster) {
				let mon_vo = scene_mgr.GetMonsterVo(scene_mgr.killerId)
				if (mon_vo) {
					let lv = "Lv." + mon_vo.level
					this._lb_name.text = lv + " " + scene_mgr.killerName
					this._bit_fight.visible = false
					this._img_fight.visible = false
					ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetMonsterHeadPath(mon_vo.cfg_data.icon))
				}
			}
			if (scene_mgr.IsMysteryBossScene()) {
				this._lb_anger.visible = true
				this._lb_hint.visible = true
				this.click_bg_toClose = true
				this._btn_left.visible = false
				this._btn_right.visible = false
				this._lb_time.visible = false
				this._gp_exit.visible = false
				local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 15)
			} else if (scene_mgr.IsAbyssBossScene()) {
				this._lb_anger.visible = false
				this._lb_hint.visible = false
				this.click_bg_toClose = false
				this._btn_left.visible = false
				this._btn_right.visible = false
				this._lb_time.visible = false
				this._gp_exit.visible = true
				this.left_time = 20
				if (this.cfg_boss_type_kv[BossModel.BossType.abyss + "@end_out_time"]) {
					this.left_time = Number(this.cfg_boss_type_kv[BossModel.BossType.abyss + "@end_out_time"].value)
				}
				this.StartTime()
				this.UpdateHelpData()
			} else if (scene_mgr.IsSuitBossScene()) {
				this.left_time = 5
				this.StartTime()
				this._lb_anger.visible = false
				this._lb_hint.visible = true
				this.click_bg_toClose = true
				this._btn_left.visible = false
				this._btn_right.visible = false
				this._lb_time.visible = true
				this._gp_exit.visible = false
				local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 15)
			}
		}

		this.StartTime = () => {
			this.CancelTime()
			this.close_time = this.left_time + local_TimeUtil.getServerTime()
			if (!this.timer) {
				this.timer = GlobalTimerQuest.AddPeriodQuest(this.onTimer, 1)
			}
			this.onTimer()
		}

		this.onTimer = () => {
			let left_time = this.close_time - local_TimeUtil.getServerTime()
			if (this._lb_time.visible) {
				if (scene_mgr.IsSuitBossScene()) {
					this._lb_time.text = left_time + "秒后关闭界面"
				} else {
					this._lb_time.text = left_time + "秒后自动选择普通复活"
				}
			}
			if (this._gp_exit.visible) {
				this._lb_exit.text = "退出场景(" + left_time + "s)"
			}
			if (left_time < 0) {
				if (this.timer) {
					GlobalTimerQuest.CancelQuest(this.timer)
					this.timer = null
				}
				if (this._lb_time.visible) {
					if (scene_mgr.IsSuitBossScene()) { //蛮荒自动复活
					} else {
						local_GlobalEventSystem.Fire(local_EventName.RELIVE_BY_TYPE, 15)
					}
				} else if (this._gp_exit.visible) {
					this.exit()
				}
				this.Close()
				return
			}
		}

		this.exit = () => {
			let boss_type = BossModel.BossType.abyss
			BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46004, boss_type)
			this.Close()
		}

		this.CancelTime = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
		}

		this.UpdateHelpData = () => {
			let has_guild = role_mgr.GetMainRoleVo().guild_id != 0
			let show = scene_mgr.killerType == SceneBaseType.Role && has_guild
			if (show) {
				this.StartHelpTimer()
				this._gp_help.visible = true
			} else {
				this.CancelHelpTimer()
				this._gp_help.visible = false
			}
		}

		this.StartHelpTimer = () => {
			let etime = guild_model.boss_etime
			if (etime > local_TimeUtil.getServerTime()) {
				this.CancelHelpTimer()
				this.help_timer = GlobalTimerQuest.AddPeriodQuest(this.UpdateHelpTimer, 1)
			}
		}

		this.CancelHelpTimer = () => {
			if (this.help_timer) {
				GlobalTimerQuest.CancelQuest(this.help_timer)
				this.help_timer = null
				this.help_timer = null
			}
		}

		this.UpdateHelpTimer = () => {
			let etime = guild_model.boss_etime
			let rtime = etime - local_TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_help_time.text = rtime + "s"
			} else {
				this.CancelHelpTimer()
				this._lb_help_time.text = ""
			}
		}
	}

	_Group4: Laya.Box
	_img_bg: Laya.Image
	_gp_effect: Laya.Box
	_img_title: Laya.Image
	_Group3: Laya.VBox
	_Group2: Laya.Box
	_Group1: Laya.Box
	_Image11: Laya.Image
	_img_head: Laya.Image
	_lb_name: Laya.Label
	_img_fight: Laya.Image
	_bit_fight: Laya.Label
	_lb_content: Laya.Label
	_lb_anger: Laya.Label
	_lb_hint: Laya.Label
	_btn_left: Laya.Box
	_Button1: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	_Label1: Laya.Label
	_btn_right: Laya.Box
	_Button2: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Image2: Laya.Image
	_lb_need: Laya.Label
	_Label2: Laya.Label
	_lb_time: Laya.Label
	_gp_exit: Laya.Box
	_Image3: Laya.Image
	_lb_exit: Laya.Label
	_gp_help: Laya.Box
	_btn_help: Laya.Image
	_lb_help_time: Laya.Label
	public GetComponents() {
		[
			this._Group4,
			this._img_bg,
			this._gp_effect,
			this._img_title,
			this._Group3,
			this._Group2,
			this._Group1,
			this._Image11,
			this._img_head,
			this._lb_name,
			this._img_fight,
			this._bit_fight,
			this._lb_content,
			this._lb_anger,
			this._lb_hint,
			this._btn_left,
			this._Button1,
			this._Image111,
			this.labelDisplay1,
			this._Label1,
			this._btn_right,
			this._Button2,
			this._Image1,
			this.labelDisplay,
			this._Image2,
			this._lb_need,
			this._Label2,
			this._lb_time,
			this._gp_exit,
			this._Image3,
			this._lb_exit,
			this._gp_help,
			this._btn_help,
			this._lb_help_time,
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_img_bg",
				"_gp_effect",
				"_img_title",
				"_Group3",
				"_Group2",
				"_Group1",
				"_Image11",
				"_img_head",
				"_lb_name",
				"_img_fight",
				"_bit_fight",
				"_lb_content",
				"_lb_anger",
				"_lb_hint",
				"_btn_left",
				"_Button1",
				"_Image111",
				"labelDisplay1",
				"_Label1",
				"_btn_right",
				"_Button2",
				"_Image1",
				"labelDisplay",
				"_Image2",
				"_lb_need",
				"_Label2",
				"_lb_time",
				"_gp_exit",
				"_Image3",
				"_lb_exit",
				"_gp_help",
				"_btn_help",
				"_lb_help_time",
			])
	}
}
window["BossSuitReliveView"] = BossSuitReliveView