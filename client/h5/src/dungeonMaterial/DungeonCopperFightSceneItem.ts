import { BaseItem1 } from "../common/BaseItem1"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { SceneManager } from "../scene/SceneManager"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { Util, SetAnchoredPosition, HtmlColorTxt } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { RewardPreView } from "../common/RewardPreView"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest } from "../util/Util"
import { MainUIManager } from "../common/MainUIManager"

export class DungeonCopperFightSceneItem extends BaseItem1 {
	_gp_wave_tips: Laya.HBox
	_Image1: Laya.Image
	_Group1: Laya.HBox
	_lb_now_wave: Laya.Label
	_lb_total_wave: Laya.Label
	_gp_copper_tips: Laya.Box
	_img_copper_tips_bg: Laya.Image
	_img_copper_tips: Laya.Image
	_gp_copper: Laya.Box
	_Image2: Laya.Image
	_Image3: Laya.Image
	_lb_copper_tips: Laya.HTMLDivElement
	_img_copper_lv: Laya.Image
	_img_box: Laya.Image
	_gp_effect: Laya.Box
	CancelCopperTime
	GetRefreshTime
	LoadSuccess
	OnTime
	SetCopperTipsState
	StartCopperTime
	UpdateView
	_dungeon_grade_list_
	copper_time_id_
	time_id_
	mainui_mgr

	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonCopperFightSceneItem"
		let base_model = BaseDungeonModel.GetInstance()
		let scene_mgr = SceneManager.GetInstance()
		this.mainui_mgr = MainUIManager.GetInstance()
		let has_default_value = Config.ConfigHasDefaultValue
		let local_Config = Config
		let erlang_parser = ErlangParser.GetInstance()
		let local_BaseDungeonModel = BaseDungeonModel
		let local_laya = Laya
		let local_TimeUtil = TimeUtil
		this.copper_time_id_ = null
		this.time_id_ = null
		let _start_time_ = null
		this._dungeon_grade_list_ = null
		let _cfg_ = null
		let _level_ = null
		let _reward_list_ = null
		let _refresh_time_ = null
		this.preload_server_config = {
			"config_dungeon": false,
			"config_dungeon_score": false
		}
		this.load_callback = () => {

			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_copper_tips.size  = 18
			// }
			// if (PlatformMgr.GetInstance().IsEyouPlatform() ) {
			// 	this._lb_copper_tips.lineSpacing = 1
			// }
		}

		this.LoadSuccess = () => {
			this.display_obj.left = this.display_obj.right = this.display_obj.top = this.display_obj.bottom = 0
			this.mainui_mgr.AddMoveComponent(this, this._gp_wave_tips, false, MainUIManager.MOVE_TYPE.Top)
			this.mainui_mgr.AddMoveComponent(this, this._gp_copper, false, MainUIManager.MOVE_TYPE.Buttom)
			let view = new RewardPreView()
			Util.AddClickEvent(this._img_box, () => {
				if (_reward_list_ && _reward_list_.length > 0) {
					view.Open(_reward_list_)
				}
			}
				, this, true)
			// this.AddUIEffect2("ui_chest_glow", this._gp_effect, null, null, true)
			let cur_dun_id = scene_mgr.GetCurrDunId()
			let cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon", false)
			let cfg = local_Config.GetConfigVo(has_default_value.config_dungeon.name, cur_dun_id, false, cfgs)
			if (cfg) {
				// let list = erlang_parser.Parse(cfg.mon_event)
				// this._lb_total_wave.text = "/" + list[0][1].length

				let v = cfg.mon_event
				let a = erlang_parser.parse(v)
				let list = a[0][1]
				this._lb_total_wave.text = "/" + list.length
				this.BindEvent(base_model, local_BaseDungeonModel.NEXT_WAVE_TIME_INFO, (wave_num?, left_time?) => {
					this._gp_wave_tips.visible = true
					this._lb_now_wave.text = wave_num
					//this._gp_wave_tips.refresh()
				}
				)
				this.UpdateView()
				this.BindVar(base_model, "dungeon_scene_msg", (event_name?, vo?) => {
					this.UpdateView()
				}
				)
				base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61030)
				//LayoutRebuilder(this._Group1)
			}
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("dungeonMaterial", "uitb_007"))

			SetAnchoredPosition(this, 0, 0)
		}

		this.UpdateView = () => {
			let vo = base_model.GetDungeonSceneMsg()
			if (vo) {
				_start_time_ = vo.start_time * 1000
				this.StartCopperTime()
			}
		}

		this.SetCopperTipsState = (bool?) => {
			if (bool) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_copper_tips_bg, GameResPath.GetIcon("dungeonCommon", "common_15"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_copper_tips, GameResPath.GetIcon("dungeonMaterial", "uitb_002"), true)
			}
			if (bool) {
				// local_laya.Tween.removeTweens(this._gp_copper_tips)
				// this._gp_copper_tips.y = 500 - 96
				// this._gp_copper_tips.alpha = 0
				// this._gp_copper_tips.visible = true
				// local_laya.Tween.get(this._gp_copper_tips).to({y=500, alpha=1}, 300)

				this._gp_copper_tips.visible = true
			} else {
				// local_laya.Tween.removeTweens(this._gp_copper_tips)
				// this._gp_copper_tips.y = 500
				// this._gp_copper_tips.alpha = 1
				// local_laya.Tween.get(this._gp_copper_tips):to({y=500 + 96, alpha=0}, 300).call(() => {
				// 		this._gp_copper_tips.visible = false
				// 	}
				// )
				this._gp_copper_tips.visible = false
			}
		}

		this.StartCopperTime = () => {
			this.CancelCopperTime()
			this._gp_copper.visible = true
			let cur_dun_id = scene_mgr.GetCurrDunId()
			let dungeon_score = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_score", false)
			// [ts2lua]dungeon_score下标访问可能不正确
			let score_cfg = dungeon_score[cur_dun_id]
			let dungeon_grade_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
			if (score_cfg) {
				_cfg_ = JSON.parse(score_cfg.time_score_list)
			}
			let dungeon_grade_list = []
			for (let key in dungeon_grade_cfg) {

				let vo = local_Config.GetConfigVo(has_default_value.config_dungeon_grade.name, key, false, dungeon_grade_cfg)
				if (vo.dun_id == cur_dun_id) {
					table.insert(dungeon_grade_list, vo)
				}
			}
			this._dungeon_grade_list_ = dungeon_grade_list
			_refresh_time_ = this.GetRefreshTime() + _start_time_
			// this.copper_time_id_ = local_laya. new Timer(1000, 0)
			// this.copper_time_id_.addEventListener(local_laya.TimerEvent.TIMER, this.OnTime, this)
			// this.copper_time_id_.start()
			if (!this.copper_time_id_) {
				this.copper_time_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
					this.OnTime()
				}, 0.02, -1)
			}
			this.OnTime()
			//test_time_id =  this.copper_time_id_
		}

		this.GetRefreshTime = () => {
			let grade = 0
			let level = ""
			let start_time = _start_time_
			let score = 0
			let end_time = 0
			// let time = local_TimeUtil.getServerTime() - start_time
			let time = local_TimeUtil.getServerTime() - start_time / 1000
			if (_cfg_) {
				for (let _tmpi in _cfg_) {
					var vo = _cfg_[_tmpi]
					if (Number(vo[0]) <= time && Number(vo[1]) >= time) {
						score = Number(vo[2])
						end_time = Number(vo[1])
						break
					}
				}
			}
			if (!end_time) {
				this.CancelCopperTime()
				return
			}
			for (let _tmpi in this._dungeon_grade_list_) {
				var v = this._dungeon_grade_list_[_tmpi]
				if (v.min_score <= score && v.max_score >= score) {
					grade = v.grade
					_reward_list_ = erlang_parser.Parse(v.reward)
					break
				}
			}
			if (grade != null) {
				if (3 == grade) {
					level = "S"
				} else if (2 == grade) {
					level = "A"
				} else if (1 == grade) {
					level = "B"
				} else if (0 == grade) {
					level = "C"
				}
				_level_ = level
				base_model.copperGrade = grade
				base_model.copperLeve = level
				ResManager.GetInstance().SetImageSprite(this, this._img_copper_lv, "dungeonMaterial_asset", level + "")
				ResManager.GetInstance().SetImageSprite(this, this._img_box, "dungeonMaterial_asset", "box_" + grade + "")
			}
			// return end_time
			return end_time * 1000
		}

		this.OnTime = () => {
			let server_time = local_TimeUtil.getServerTimeMs()
			let left_time = _refresh_time_ - server_time
			if (left_time < 0) {
				_refresh_time_ = this.GetRefreshTime() + _start_time_
				if (_refresh_time_ > local_TimeUtil.getServerTimeMs()) {
					this.OnTime()
				}
				return
			}
			// let content = HtmlColorTxt(local_TimeUtil.convertTime(left_time), "#b3ff48") + "内消灭所有敌人可以获得" + HtmlColorTxt(_level_ + "级奖励", "#ff9015")
			let content = "当前评级:" + HtmlColorTxt(_level_ + "级奖励", "'#ffdf71'") + HtmlColorTxt(local_TimeUtil.timeConversionWithMillisecond(left_time, "mm:ss.ms"), "'#00fa64'") + "秒内消灭所有波次怪物可保级"
			this._lb_copper_tips.style.fontSize = 22
			this._lb_copper_tips.style.valign = "center"
			this._lb_copper_tips.style.color = "#ffffff"
			this._lb_copper_tips.style.wordWrap = true
			this._lb_copper_tips.width = 300
			this._lb_copper_tips.innerHTML = Util.StrToHTML(content)
			let a = <Laya.HBox>this._lb_copper_tips.parent
			if (a)
				a.refresh()

			// this._lb_copper_tips.textFlow = Util.StrToHTML(left_time)
			// this._lb_copper_tips.textFlow = Util.StrToHTML(Time.frameCount)
		}

		this.CancelCopperTime = () => {
			// if (this.copper_time_id_ ) {
			// 	this.copper_time_id_.stop()
			// 	this.copper_time_id_.removeEventListener(local_laya.TimerEvent.TIMER, this.OnTime, this)
			// 	this.copper_time_id_ = null
			// }
			if (this.copper_time_id_) {
				GlobalTimerQuest.CancelQuest(this.copper_time_id_)
				this.copper_time_id_ = null
			}
		}
	}

	public DeleteMe() {

		this.CancelCopperTime()
		// if (this._gp_copper_tips ) {
		// 	local_laya.Tween.removeTweens(this._gp_copper_tips)
		// }
		if (this.time_id_) {
			GlobalTimerQuest.CancelQuest(this.time_id_)
			this.time_id_ = null
		}
		this._dungeon_grade_list_ = null
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._gp_wave_tips,
			this._Image1,
			this._Group1,
			this._lb_now_wave,
			this._lb_total_wave,
			this._gp_copper_tips,
			this._img_copper_tips_bg,
			this._img_copper_tips,
			this._gp_copper,
			this._Image2,
			this._Image3,
			this._lb_copper_tips,
			this._img_copper_lv,
			this._img_box,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_gp_wave_tips",
				"_Image1",
				"_Group1",
				"_lb_now_wave",
				"_lb_total_wave",
				"_gp_copper_tips",
				"_img_copper_tips_bg",
				"_img_copper_tips",
				"_gp_copper",
				"_Image2",
				"_Image3",
				"_lb_copper_tips",
				"_img_copper_lv",
				"_img_box",
				"_gp_effect",
			])
	}
}
window["DungeonCopperFightSceneItem"] = DungeonCopperFightSceneItem
