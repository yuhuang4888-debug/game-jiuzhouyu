import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Runner } from "../util/Runner"
import { Scene } from "../scene/Scene"
import { RoleManager } from "../commonModel/RoleManager"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SceneManager } from "../scene/SceneManager"
import { KfHolyAreaDefine } from "../kfHolyArea/KfHolyAreaDefine"
import { TimeUtil } from "../util/TimeUtil"
import { SYTweenLite } from "../util/SYTweenLite"
import { HtmlColorTxt } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { GameMath } from "../util/GameMath"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DragonWhisperModel, DrWsEvent } from "../commonModel/DragonWhisperModel"
import { BossTargetPanel } from "../boss/BossTargetPanel"
import { dwBossPanel } from "./dwBossPanel"

import "./dwDropBagView"
import "./dwTimeTipsView"

export class dwSceneView extends BaseView1 {
	AddRunner
	CheckTargetPanel
	Clear
	FindWay
	GetMonList
	GetRoleVoList
	InitEvent
	LoadSuccess
	RemoveRunner
	SetTagetPanelHide
	StartTimer
	Update
	UpdateTimer
	UpdateView

	public constructor() {
		super()
		this.base_file = "dragonWhisper"
		this.layout_file = "dwSceneView"
		this.layer_value = Enum_UILayer.UI
		this.destroy_imm = true

		let _model = DragonWhisperModel.GetInstance()
		let local_DrWsTimer = DragonWhisperModel.DrWsTimer
		// let local_Util = Util
		let local_DrWsEvent = DrWsEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel

		let runner = Runner.GetInstance()
		let local_KfHolyAreaDefine = KfHolyAreaDefine
		let scene = Scene.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_TimeUtil = TimeUtil
		let _taget_panel_ = null
		let _boss_panel_ = null
		let _icon_state_ = false
		let _update_id_ = null
		let _damage_mark_ = null
		let _boss_data_ = null
		let _end_time_ = 0
		let _mon_list_ = null

		this.load_callback = () => {
			this.display_obj.left = this.display_obj.right = this.display_obj.bottom = 0
			this.display_obj.top = Util.GetLiuhaiHeight()
			// this.form.anchorMin = Vector2(0, 0)
			// this.form.anchorMax = Vector2(1, 1)
			// let liu_hai_height = GetLiuhaiHeight()
			// if (liu_hai_height) {
			// 	this.form.anchoredPosition = Vector2(0, -liu_hai_height / 2)
			// 	this.form.sizeDelta = Vector2(0, -liu_hai_height)
			// } else {
			// 	this.form.anchoredPosition = Vector2(0, 0)
			// 	this.form.sizeDelta = Vector2(0, 0)
			// }
			ResManager.GetInstance().LoadFont(this, "scene_damage_mainrole", this._lb_time, 20)
			this.InitEvent()
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.Clear = () => {
			if (_taget_panel_) {
				_taget_panel_.DeleteMe()
				_taget_panel_ = null
			}
			if (_boss_panel_) {
				_boss_panel_.DeleteMe()
				_boss_panel_ = null
			}
			_model.ClearTimer(local_DrWsTimer.SCENE.key)
			this.RemoveRunner()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_exit, () => {
				let str = HtmlColorTxt("不会返回进入消耗", Enum_ColorUtil_Dark.GREEN)
				Alert.Show("是否确认离开当前场景？<br>" + str, Alert_Type.Two, () => {
					_model.Fire(local_DrWsEvent.PROTO, 65103)
				}
				)
			}, this, true)

			Util.AddClickEvent(this._btn_bag, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwDropBagView")
			}, this, true)

			this.BindEvent(mainUI_model, local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
				if (this.use_delete_method) {
					return
				}
				if (bool) {
					SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.POSX, -this._gp_con.width, 0.3)
					SYTweenLite.to(this, this._btn_exit, SYTweenLite.UiAnimationType.POSX, -this._btn_exit.width, 0.3)
					SYTweenLite.to(this, this._gp_target, SYTweenLite.UiAnimationType.ALPHA, 0, 0.3)
					SYTweenLite.to(this, this._gp_time, SYTweenLite.UiAnimationType.ALPHA, 0, 0.3)
				} else {
					SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.POSX, 6, 0.3)
					SYTweenLite.to(this, this._btn_exit, SYTweenLite.UiAnimationType.POSX, 10, 0.3)
					SYTweenLite.to(this, this._gp_target, SYTweenLite.UiAnimationType.ALPHA, 1, 0.3)
					SYTweenLite.to(this, this._gp_time, SYTweenLite.UiAnimationType.ALPHA, 1, 0.3)
				}
			})

			this.BindEvent(_model, local_DrWsEvent.UPDATE_SCENE, (scmd?) => {
				this.UpdateView()
			})

			this.BindEvent(_model, local_DrWsEvent.UPDATE_ENTER, (scmd?) => {
				if (_boss_panel_) {
					_boss_panel_.SetBossList(_mon_list_, true)
					this.FindWay(scmd.mon_id)
				}
			})
		}

		this.LoadSuccess = () => {
			let einfo = _model.GetEnterInfo()
			let map_id = einfo && einfo.map_id || null
			let mon_id = einfo && einfo.mon_id || null
			_mon_list_ = this.GetMonList(map_id)
			this.FindWay(mon_id)
			_taget_panel_ = new BossTargetPanel(this._gp_target)
			_taget_panel_.Load()
			_taget_panel_.ExcuteCallback(() => {
				this.SetTagetPanelHide(false)
			})
			_boss_panel_ = new dwBossPanel(this._gp_con)
			_boss_panel_.SetBossList(_mon_list_, false)
			_boss_panel_.Load()
			_model.Fire(local_DrWsEvent.PROTO, 65105)
		}

		this.GetMonList = (map_id?) => {
			let list = []
			if (!map_id) {
				return list
			}
			let map_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_map
			let mdata = map_cfg[map_id]
			let mon_list = JSON.parse(mdata.show_mon_list)
			for (let _tmpi in mon_list) {
				let vo = mon_list[_tmpi]
				table.insert(list, { mon_id: vo[0], x: vo[1], y: vo[2] })
			}
			_boss_data_ = mon_list[1]
			return list
		}

		this.AddRunner = () => {
			if (!_update_id_) {
				_update_id_ = runner.AddRunObj(this, 21)
			}
		}

		this.RemoveRunner = () => {
			if (_update_id_) {
				runner.RemoveRunObj(_update_id_)
				_update_id_ = null
			}
		}

		this.Update = () => {
			if (!_boss_data_) {
				return
			}
			let main_role = scene.main_role
			let dis = GameMath.GetDistance(main_role.x, main_role.y, _boss_data_.x, _boss_data_.y)
			if (dis <= local_KfHolyAreaDefine.Examination_Range * local_KfHolyAreaDefine.Examination_Range) {
				if (!_damage_mark_) {
					let mon_list, mon_count = scene.FindTargets(Scene.FIND_TARGET_TYPE.monster, 1, null, null, null, null, null)
					let monster = mon_list[1]
					let monster_vo = monster && monster.GetVo() || null
					if (monster_vo && monster_vo.type_id == _boss_data_.type_id) {
						_damage_mark_ = true
						UserMsgAdapter.GetInstance().SendAllFmtToGame(12025, "i", [monster_vo.instance_id])
					}
					this.CheckTargetPanel(_boss_data_.type_id)
				}
			} else {
				if (_damage_mark_) {
					_damage_mark_ = null
				}
			}
		}

		this.SetTagetPanelHide = (bool?) => {
			if (_taget_panel_ && _taget_panel_.display_obj.visible != bool) {
				_taget_panel_.SetVisible(bool)
				// _taget_panel_.visible = bool
			}
		}

		this.GetRoleVoList = () => {
			let main_role_vo = role_mgr.GetMainRoleVo()
			let main_role_id = role_mgr.GetMainRoleId()
			let list = []
			let role_vo_list = SceneManager.GetInstance().GetAllRoleVos()
			if (main_role_vo.boss_flag == 1) {
				table.insert(list, main_role_vo)
			}
			for (let role_id in role_vo_list) {

				let role_vo = role_vo_list[role_id]
				if (role_vo.hp == 0 && role_vo.boss_flag != 1) {
					break
				}
				if (role_id != String(main_role_id)) {
					table.insert(list, role_vo)
				}
			}
			return list
		}

		this.CheckTargetPanel = (mon_id?) => {
			let obj_vo_list = []
			let role_vo_list = this.GetRoleVoList()
			if (mon_id) {
				let monster = scene.GetMonsterByTypeId(mon_id)
				if (monster) {
					table.insert(obj_vo_list, monster.GetVo())
					if (!_icon_state_ && mainUI_model.activity_icon_in_show) {
						mainUI_model.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
					}
					if (!mainUI_model.big_blood_in_show) {
						let config = Config.GetConfigVo("Mon", monster.GetVo().type_id, false)
						local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, monster.GetVo(), config.hp_num, false)
					}
				} else {
					local_GlobalEventSystem.Fire(local_EventName.SHOW_HITER_BIG_BLOOD_VIEW, false)
					let vo = _model.GetSceneMonData(mon_id)
					if (vo && vo.reborn_time > local_TimeUtil.getServerTime()) {
						vo.bossid = vo.mon_id
						table.insert(obj_vo_list, vo)
					}
				}
			}
			obj_vo_list = obj_vo_list.concat(role_vo_list)
			if (obj_vo_list.length > 0) {
				_icon_state_ = true
				_taget_panel_.setData(obj_vo_list)
				this.SetTagetPanelHide(true)
			} else {
				_icon_state_ = false
				this.SetTagetPanelHide(false)
			}
		}

		this.UpdateView = () => {
			let sinfo = _model.GetSceneInfo()
			if (!sinfo) {
				return
			}
			_end_time_ = sinfo.time
			this.StartTimer()
			let list = this.GetMonList(sinfo.map_id)
			for (let _tmpi in sinfo.mon_list) {
				let vo1 = sinfo.mon_list[_tmpi]
				for (let _tmpi in list) {
					let vo2 = list[_tmpi]
					if (vo1.mon_id == vo2.mon_id) {
						vo2.reborn_time = vo1.reborn_time
						break
					}
				}
			}
			_boss_panel_.SetBossList(list, true)
		}

		this.StartTimer = () => {
			_model.StartTimer(local_DrWsTimer.SCENE.key, 1, () => {
				this.UpdateTimer()
			})
			this.UpdateTimer()
		}

		this.UpdateTimer = () => {
			let rtime = _end_time_ - local_TimeUtil.getServerTime()
			if (rtime > 0) {
				this._lb_time.text = String(rtime)
			} else {
				this._gp_time.visible = false
				this._lb_time.text = "已结束"
				_model.ClearTimer(local_DrWsTimer.SCENE.key)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwTimeTipsView")
			}
		}

		this.FindWay = (mon_id?) => {
			if (!mon_id) {
				return
			}
			for (let _tmpi in _mon_list_) {
				let vo = _mon_list_[_tmpi]
				if (Number(vo.mon_id) == mon_id) {
					_model.FindWay(vo.x, vo.y)
					break
				}
			}
		}
	}

	_gp_time: Laya.Box
	_img_bg: Laya.Image
	_img_fight: Laya.Image
	_lb_time: Laya.Label
	_gp_con: Laya.Box
	_btn_bag: Laya.Image
	_gp_target: Laya.Box
	_btn_exit: Laya.Image
	public GetComponents() {
		[
			this._gp_time,
			this._img_bg,
			this._img_fight,
			this._lb_time,
			this._gp_con,
			this._btn_bag,
			this._gp_target,
			this._btn_exit,
		]
			= this.GetChildrenByNames([

				"_gp_time",
				"_img_bg",
				"_img_fight",
				"_lb_time",
				"_gp_con",
				"_btn_bag",
				"_gp_target",
				"_btn_exit",
			])
	}
}
window["dwSceneView"] = dwSceneView