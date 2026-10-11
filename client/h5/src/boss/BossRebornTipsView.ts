import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { CrossServerViewIndex } from "../commonController/BossController"
import { BossModel } from "../commonModel/BossModel"
import { HolyTerritoryModel } from "../commonModel/HolyTerritoryModel"
import { Kf1vnEvent, Kf1vnModel } from "../commonModel/Kf1vnModel"
import { PlatformManager } from "../PlatformManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class BossRebornTipsView extends BaseView1 {



	reborn_info
	holy_territory_model
	kf1vn_model
	is_anim = false
	anim_y = 244
	anim_time = 0.3	// 秒
	anim_pos_id = null
	anim_alpha_id = null
	public constructor() {
		super()

		this.base_file = "boss"
		this.layout_file = "BossRebornTipsView"
		this.layer_value = Enum_UILayer.Top
		this.change_scene_close = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.back_login_toClose = true
		// this.holy_territory_model = HolyTerritoryModel.GetInstance()
		this.kf1vn_model = Kf1vnModel.GetInstance()
		this.preload_server_config = {
			"config_boss_cfg": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this._gp_con.alpha = 0
			this._gp_con.y = this.anim_y
			this.UpdateView()
		}

		this.close_callback = () => {
			if (this.reborn_info && this.reborn_info.boss_type == BossModel.BossType.holyterritory) {

			} else {
				let openDay = ServerTimeModel.GetInstance().GetOpenServerDay()
				if (openDay <= 3) {
					// Message.show("可在大妖界面取消关注")
				}
			}
			if (this.anim_pos_id) {
				SYTweenLite.Stop(this.anim_pos_id)
				this.anim_pos_id = null
			}
			if (this.anim_alpha_id) {
				SYTweenLite.Stop(this.anim_alpha_id)
				this.anim_alpha_id = null
			}
		}
	}

	SetRebornInfo = (reborn_info?) => {
		this.reborn_info = reborn_info
	}

	LoadSuccess = () => {
		this.display_obj.centerX = 185
		this.display_obj.bottom = 255

	}

	InitEvent = () => {
		Util.AddClickEvent(this._btn_go, () => {
			if (this.reborn_info && this.reborn_info.boss_type == BossModel.BossType.holyterritory) {
				let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
				HolyTerritoryModel.GetInstance().GoHT(this.reborn_info.sanctuary_id, this.reborn_info.boss_id, cfgs)
			} else {
				let func = () => {
					let index = BossModel.Index.Field_Boss
					if (this.reborn_info) {
						if (this.reborn_info.boss_type == BossModel.BossType.field||this.reborn_info.boss_type == BossModel.BossType.field_infinite) {
							index = BossModel.Index.Field_Boss
						} else if (this.reborn_info.boss_type == BossModel.BossType.fieldspecial) {
							index = BossModel.Index.Field_Boss
						} else if (this.reborn_info.boss_type == BossModel.BossType.secret) {
							index = BossModel.Index.Secret_Boss
						} else if (this.reborn_info.boss_type == BossModel.BossType.abyss) {
							index = BossModel.Index.Abyss_Boss
						} else if (this.reborn_info.boss_type == BossModel.BossType.suit) {
							index = BossModel.Index.Suit_Boss
						} else if (this.reborn_info.boss_type == BossModel.BossType.mystery) {
							// index = CrossServerViewIndex.Mystery_Boss
							OpenFun.OpenFunHandler(27,this.reborn_info.boss_id)
							return  //走跨服的页面
						} else if (this.reborn_info.boss_type == BossModel.BossType.eudaemon || this.reborn_info.boss_type == BossModel.BossType.holy) {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss, this.reborn_info.boss_id)
							return
						} else if (this.reborn_info.boss_type == BossModel.BossType.domain) {
							OpenFun.OpenFunHandler(157,this.reborn_info.boss_id)
							return
						} else if (this.reborn_info.boss_type == BossModel.BossType.holy_wuxian) {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CrossServerEnterView", CrossServerViewIndex.Eudaemon_Ridge_Boss, this.reborn_info.boss_id)
							return
						}
					}
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossEnterView", index, this.reborn_info.boss_id)
				}
				if (SceneManager.GetInstance().IsFieldBossScene()||SceneManager.GetInstance().IsFieldInfiniteBossScene()  || SceneManager.GetInstance().IsCrossWuxianBossScene() || SceneManager.GetInstance().IsHolyBossScene()) {
					let curr_scene_id = SceneManager.GetInstance().curr_scene_id
					let type = BossModel.GetInstance().GetBossType()
					let layer = (curr_scene_id != 34090 && curr_scene_id != 12004&&curr_scene_id!=BossModel.BOSS_FIELD_INFINITE) ? curr_scene_id - BossModel.BaseBossSceneId[type] : 0
					let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
					let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.reborn_info.boss_id, false, cfgs)
					let boss_layer = curr_scene_id != 12004 ? (bossVo && bossVo.layers) : 0
					if (boss_layer == layer)
						BossModel.GetInstance().Fire(BossModel.CHANGE_BOSS_TARGET, null, this.reborn_info.boss_id)
					else
						func()
				}
				else {
					func()
				}

			}
			BossModel.GetInstance().Fire(BossModel.CLOSE_REBORN_TIPS_VIEW)
		}
			, this, true)

		Util.AddClickEvent(this._img_close, () => {
			BossModel.GetInstance().Fire(BossModel.CLOSE_REBORN_TIPS_VIEW)
		}
			, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		Util.AddClickEvent(this._btn_ht, () => {
			if (this.reborn_info && this.reborn_info.boss_type == BossModel.BossType.holyterritory) {
				// let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
				// let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.reborn_info.boss_id, false, cfgs)
				// holy_territory_model.GoHT(this.reborn_info.sanctuary_id, this.reborn_info.boss_id, cfg)
			}
		}
			, this, true)
		this.BindEvent(BossModel.GetInstance(), BossModel.KILL_BOSS, (scmd?) => {
			if (scmd.boss_id == this.reborn_info.boss_id) {
				BossModel.GetInstance().Fire(BossModel.CLOSE_REBORN_TIPS_VIEW)
			}
		}
		)
	}

	UpdateView = () => {
		let source = null
		if (this.reborn_info) {

			let case1 = () => {

			}

			switch (this.reborn_info.boss_type) {
				case BossModel.BossType.field:
				case BossModel.BossType.field_infinite:
				case BossModel.BossType.fieldspecial:
				case BossModel.BossType.holy:
				case BossModel.BossType.holyterritory:
				case BossModel.BossType.domain:
					source = GameResPath.GetIcon("boss", "uiboss_058")
					break
				case BossModel.BossType.abyss:
					source = GameResPath.GetIcon("boss", "uiboss_056")
					break
				case BossModel.BossType.suit:
					source = GameResPath.GetIcon("boss", "uiboss_057")
					break
			}
		}

		if (source) {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, source)
		}

		let tips = ""
		let bool = false
		if (this.reborn_info.boss_type == BossModel.BossType.field||this.reborn_info.boss_type == BossModel.BossType.field_infinite) {
			tips = "世界大妖"
			bool = true
		} else if (this.reborn_info.boss_type == BossModel.BossType.fieldspecial) {
			tips = "世界大妖"
		} else if (this.reborn_info.boss_type == BossModel.BossType.secret) {
			tips = "秘境大妖"
		} else if (this.reborn_info.boss_type == BossModel.BossType.abyss) {
			tips = "大妖之境"
			bool = true
		} else if (this.reborn_info.boss_type == BossModel.BossType.suit) {
			tips = "蛮荒大妖"
			bool = true
		} else if (this.reborn_info.boss_type == BossModel.BossType.eudaemon || this.reborn_info.boss_type == BossModel.BossType.holy || this.reborn_info.boss_type == BossModel.BossType.holy_wuxian) {
			tips = "蜃气楼"
		} else if (this.reborn_info.boss_type == BossModel.BossType.holyterritory) {
			tips = "异域"
		} else if (this.reborn_info.boss_type == BossModel.BossType.domain) {
			tips = "灵饰大妖"
		} else if (this.reborn_info.boss_type == BossModel.BossType.mystery) {
			tips = "秘境领域"
			bool = true
		}
		this._lb_boss_type.text = tips
		this.grade.visible = bool
		let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.reborn_info.boss_id, false)
		let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_boss_cfg", false)
		let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_boss_cfg.name, this.reborn_info.boss_id, false, cfgs)
		if (config && bool) {
			this.grade_text.text = `${config.image}阶`
		}
		if (mon_cfg) {

			let str = `${mon_cfg.name}<font color='#d15e00'> Lv.${mon_cfg.lv}</font>`
			// if (PlatformManager.IsEyouIdnPlatform()) {
			// 	str = "Lv." + mon_cfg.lv + mon_cfg.name
			// }
			this._lb_boss_msg.style.fontSize = 18
			this._lb_boss_msg.style.valign = "center"
			this._lb_boss_msg.style.color = "#663915"
			this._lb_boss_msg.style.wordWrap = false
			this._lb_boss_msg.style.bold = true
			this._lb_boss_msg.innerHTML = str
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_head, GameResPath.GetMonsterHeadPath(mon_cfg.icon))
		}
		if (this.reborn_info.tips) {
			// this._lb_tips.color = "#ff4f50"
			// this._lb_tips.text = this.reborn_info.tips
			this._btn_go.visible = false
			this._btn_ht.visible = true
		} else {
			//this._lb_tips.color = "#82AB20"
			this._btn_go.visible = true
			this._btn_ht.visible = false
			//this._lb_tips.text = "已复活"
		}
		this._gp_con.visible = true
		this.is_anim = true
		this.anim_pos_id = SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.POSY, 0, this.anim_time, () => {
			if (this.anim_pos_id) {
				SYTweenLite.Stop(this.anim_pos_id)
				this.anim_pos_id = null
			}
			this.is_anim = false
		}, SYTweenFunc.EASE_OUT)
		this.anim_alpha_id = SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.ALPHA, 1, this.anim_time, () => {
			if (this.anim_alpha_id) {
				SYTweenLite.Stop(this.anim_alpha_id)
				this.anim_alpha_id = null
			}
		}, SYTweenFunc.EASE_OUT)
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_close: Laya.Image
	_lb_title: Laya.Label
	_lb_boss_msg: Laya.HTMLDivElement
	_btn_go: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_btn_ht: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	_img_bg4: Laya.Image
	_img_bg5: Laya.Image
	_img_head: Laya.Image
	_lb_boss_type: Laya.Label
	_lb_tips: Laya.Label
	_gp_con: Laya.Box
	grade: Laya.Image
	grade_text: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_close,
			this._lb_title,
			this._lb_boss_msg,
			this._btn_go,
			this._Image1,
			this.labelDisplay,
			this._btn_ht,
			this._Image11,
			this.labelDisplay1,
			this._img_bg4,
			this._img_bg5,
			this._img_head,
			this._lb_boss_type,
			this._lb_tips,
			this._gp_con,
			this.grade,
			this.grade_text
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_close",
				"_lb_title",
				"_lb_boss_msg",
				"_btn_go",
				"_Image1",
				"labelDisplay",
				"_btn_ht",
				"_Image11",
				"labelDisplay1",
				"_img_bg4",
				"_img_bg5",
				"_img_head",
				"_lb_boss_type",
				"_lb_tips",
				"_gp_con",
				"grade",
				"grade_text"
			])
	}

}
window["BossRebornTipsView"] = BossRebornTipsView