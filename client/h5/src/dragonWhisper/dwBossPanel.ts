import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { ColorType, ColorUtil, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { SYTweenLite } from "../util/SYTweenLite"
import { GoodsModel } from "../commonModel/GoodsModel"
import { DragonWhisperModel, DrWsEvent } from "../commonModel/DragonWhisperModel"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { dwMonItem } from "./dwMonItem"

import "./dwAddTimesView"
import "./dwAttrAlertView"

export class dwBossPanel extends BaseItem1 {
	// AddBossDamage
	BossTouchHandler
	// GetDamageList
	InitEvent
	LoadSuccess
	LocalDeleteMe
	// RemoveDamage
	SelectRadioBtn
	SetBossID
	SetBossList
	SetSelectIndex
	StartTipTimer
	// UpdateBossDamage
	UpdateBossItems
	// UpdateDamageItems
	UpdateTipTimer

	boss_loop_mgr
	changePanel
	damage_loop_mgr
	selectBtn
	showpanel
	_cur_index

	public constructor(parent?) {
		super(parent)
		this.base_file = "dragonWhisper"
		this.layout_file = "dwBossPanel"

		this._cur_index = -1
		let _model = DragonWhisperModel.GetInstance()
		let local_DrWsTimer = DragonWhisperModel.DrWsTimer
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Enum_ColorUtil_Light = Enum_ColorUtil_Light
		let local_TimeUtil = TimeUtil
		let boss_damage_dic_ = null
		let boss_ins_id_ = null
		let _boss_list_ = null
		let panel_touch_ = false
		let panel_state_ = true
		let _end_time_ = 0
		let select_index = 0
		this.selectBtn = 1

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.LocalDeleteMe = () => {
			if (this.boss_loop_mgr) {
				this.boss_loop_mgr.DeleteMe()
			}

			if (this.damage_loop_mgr) {
				this.damage_loop_mgr.DeleteMe()
			}

			boss_damage_dic_ = null
			_model.ClearTimer(local_DrWsTimer.TIPS.key)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._panel_btn, () => {
				this.showpanel(!panel_state_)
			}, this)

			Util.AddClickEvent(this._btn_add, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwAddTimesView")
			}, this, true)

			// this.BindEvent(local_GlobalEventSystem, local_EventName.UPDATE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			// 	this.UpdateBossDamage(monster_id, list)
			// })
			// this.BindEvent(local_GlobalEventSystem, local_EventName.ADD_BOSS_DAMAGE_DATA, (vo?) => {
			// 	this.AddBossDamage(vo)
			// })
			// this.BindEvent(local_GlobalEventSystem, local_EventName.REMOVE_BOSS_DAMAGE_DATA, (monster_id?, list?) => {
			// 	this.RemoveDamage(monster_id, list)
			// })

			this.BindEvent(_model, DrWsEvent.UPDATE_SCENE, (scmd?) => {
				this.StartTipTimer()
			})
			
			this.BindEvent(_model, DrWsEvent.SELECT_FIGHT_ITEM, (index) => {
				this.BossTouchHandler(index)
				this.boss_loop_mgr.SetSelectIndex(index)
			})

			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_LONGLANG_EQUIP, () => {
				this.UpdateBossItems(_boss_list_)
			})

			// Util.AddClickEvent(this._btn_boss, () => {
			// 	this.selectBtn = 1
			// 	this.SelectRadioBtn()
			// }, this)

			// Util.AddClickEvent(this._btn_damage, () => {
			// 	this.selectBtn = 2
			// 	this.SelectRadioBtn()
			// }, this)
		}

		this.LoadSuccess = () => {
			let einfo = _model.GetEnterInfo()
			let mon_id = einfo && einfo.mon_id || null
			this.SetSelectIndex(mon_id)
			this.SelectRadioBtn()
			boss_damage_dic_ = []
			this.UpdateBossItems(_boss_list_)
			this.StartTipTimer()
		}

		this.SelectRadioBtn = () => {
			let index = this.selectBtn
			if (this._cur_index == index) {
				return
			}
			this._cur_index = index
			this._scroll_boss.visible = index == 1
			// this._scroll_damage.visible = index == 2
			// if (index == 2) {
			// 	this.UpdateDamageItems()
			// }
		}

		// this.UpdateBossDamage = (monster_id?, list?) => {
		// 	let dic = []
		// 	for (let _tmpi in list) {
		// 		let vo = list[_tmpi]
		// 		dic[vo.player_id] = vo
		// 	}
		// 	boss_damage_dic_[monster_id] = dic
		// 	this.UpdateDamageItems()
		// }

		// this.AddBossDamage = (vo?) => {
		// 	let dic = boss_damage_dic_ && boss_damage_dic_[vo.monster_id]
		// 	if (dic) {
		// 		let data = dic[vo.player_id]
		// 		if (data) {
		// 			data.damage = data.damage + vo.damage
		// 		} else {
		// 			dic[vo.player_id] = vo
		// 		}
		// 		this.UpdateDamageItems()
		// 	}
		// }

		// this.RemoveDamage = (monster_id?, list?, all?) => {
		// 	if (all == null) {
		// 		all = false
		// 	}
		// 	let dic = boss_damage_dic_ && boss_damage_dic_[monster_id]
		// 	if (dic) {
		// 		if (all) {
		// 			boss_damage_dic_[monster_id] = null
		// 		} else {
		// 			for (let _tmpi in list) {
		// 				let data = list[_tmpi]
		// 				if (dic[data.player_id]) {
		// 					dic[data.player_id] = null
		// 				}
		// 			}
		// 		}
		// 		this.UpdateDamageItems()
		// 	}
		// }

		// this.GetDamageList = () => {
		// 	let list = []
		// 	if (!boss_ins_id_) {
		// 		return list
		// 	}
		// 	if (boss_damage_dic_ && boss_damage_dic_[boss_ins_id_]) {
		// 		let dic = boss_damage_dic_[boss_ins_id_]
		// 		let total_damage = 0
		// 		for (let key in dic) {
		// 			let vo = dic[key]
		// 			total_damage = total_damage + vo.damage
		// 			table.insert(list, vo)
		// 		}
		// 		list.sort((a?, b?) => {
		// 			return b.damage - a.damage
		// 		}
		// 		)
		// 		for (let _tmpi in list) {
		// 			let vo = list[_tmpi]
		// 			if (!vo.damage) {
		// 				vo.modulus = 0
		// 			} else {
		// 				vo.modulus = (vo.damage * 100 / total_damage): toFixed(2)
		// 			}
		// 		}
		// 	}
		// 	return list
		// }

		// this.UpdateDamageItems = () => {
		// 	if (this._cur_index != 2) {
		// 		return
		// 	}
		// 	let list = this.GetDamageList()
		// 	if (!this.damage_loop_mgr) {
		// 		this.damage_loop_mgr = new LoopScrowViewMgr()
		// 		this.damage_loop_mgr.SetData(this.Content, dwMonItem, dwDamageItem, this._scroll_damage)
		// 	} else {
		// 		this.damage_loop_mgr.replaceAll(list)
		// 	}
		// }

		this.UpdateBossItems = (list?) => {
			if (!this.boss_loop_mgr) {
				this.boss_loop_mgr = new LoopScrowViewMgr()
				this.boss_loop_mgr.SetData(this._scroll_boss, dwMonItem, list, LoopScrCon.Vertical)
				// this.boss_loop_mgr.FirstOnChild(select_index)
				this.boss_loop_mgr.SetSelectIndex(select_index)
				this.BossTouchHandler(select_index)
			} else {
				this.boss_loop_mgr.replaceAll(list)
			}
		}

		this.BossTouchHandler = (index) => {
			let data = _boss_list_[index]
			if(!data){
				return
			}
			let func = () => {
				DragonWhisperModel.GetInstance().FindWay(data.x, data.y)
				select_index = index
				// this.boss_loop_mgr.SetSelectIndex(select_index, false)
			}

			if (data.can_fight) {
				func()
			} else {
				let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
				let list = JSON.parse(mon_cfg[Number(data.mon_id)].attr_list)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "dwAttrAlertView", list, func)
				// this.boss_loop_mgr.SetSelectIndex(select_index, false)
			}
		}

		this.showpanel = (bool?) => {
			// if (bool && this._panel_btn.scaleX == 1) {
			// 	SetLocalScaleX(this._panel_btn, 1)
			// } else if (!bool && this._panel_btn.scaleX == -1) {
			// 	SetLocalScaleX(this._panel_btn, -1)
			// } else {
			// 	return
			// }
			if (panel_touch_) {
				return
			}
			this.changePanel(false)
			if (this._panel_btn.scaleX == 1) {
				panel_state_ = false
				SYTweenLite.to(this, this._panel_btn, SYTweenLite.UiAnimationType.POSX, 20, 0.2, () => {
					// SetLocalScaleX(this._panel_btn, -this._panel_btn.localScale.x)
					this._panel_btn.scaleX = -1
				})

				// SYTweenLite.to(this, this._panel_img, SYTweenLite.UiAnimationType.WIDTH, 40, 0.2)
				// SYTweenLite.to(this, this._panel_gpCanvas, SYTweenLite.UiAnimationType.ALPHA, 0, 0.2)
				SYTweenLite.to(this, this._Group4, SYTweenLite.UiAnimationType.POSX, -this._Group4.width - 8, 0.2, () => {
					this.changePanel(true)
				})
			} else {
				panel_state_ = true

				SYTweenLite.to(this, this._panel_btn, SYTweenLite.UiAnimationType.POSX, 250, 0.2, () => {
					// SetLocalScaleX(this._panel_btn, -this._panel_btn.localScale.x)
					this._panel_btn.scaleX = 1
				})

				// SYTweenLite.to(this, this._panel_img, SYTweenLite.UiAnimationType.WIDTH, 235, 0.2)
				// SYTweenLite.to(this, this._panel_gpCanvas, SYTweenLite.UiAnimationType.ALPHA, 1, 0.2)
				SYTweenLite.to(this, this._Group4, SYTweenLite.UiAnimationType.POSX, 0, 0.2, () => {
					this.changePanel(true)
				})
			}
		}

		this.changePanel = (bool?) => {
			if (bool) {
				panel_touch_ = false
			} else {
				panel_touch_ = true
			}
		}

		this.SetBossID = (id?) => {
			boss_ins_id_ = id
		}

		this.SetBossList = (list?, b?) => {
			_boss_list_ = list
			let mon_cfg = Config.PRELOAD_SERVER_CONFIG.config_dragon_language_boss_mon
			for(let i in _boss_list_){
				let vo = _boss_list_[i]
				vo.can_fight = _model.CheckAttrByMonID(mon_cfg, Number(vo.mon_id))
			}
			
			if (b && this.is_loaded) {
				this.UpdateBossItems(list)
			}
		}

		this.StartTipTimer = () => {
			let sinfo = _model.GetSceneInfo()
			if (!sinfo) {
				return
			}
			_end_time_ = sinfo.time
			_model.StartTimer(local_DrWsTimer.TIPS.key, 1, () => {
				this.UpdateTipTimer()
			})
			this._lb_time.color = ColorUtil.GetColorDark(ColorType.GREEN, false)
			this.UpdateTipTimer()
		}

		this.UpdateTipTimer = () => {
			let rtime = _end_time_ - local_TimeUtil.getServerTime()
			if (rtime >= 0) {
				this._lb_time.text = local_TimeUtil.timeConvert(rtime, "mm:ss")
				if (rtime <= 60) {
					this._lb_time.color = ColorUtil.GetColorDark(ColorType.RED, false)
				}
			} else {
				_model.ClearTimer(local_DrWsTimer.TIPS.key)
			}
		}

		this.SetSelectIndex = (mon_id?) => {
			if (!mon_id) {
				return
			}
			let index = 0
			for (let _tmpi in _boss_list_) {
				let vo = _boss_list_[_tmpi]
				if (Number(vo.mon_id) == mon_id) {
					select_index = index
					break
				}
				index = index + 1
			}
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_Group4: Laya.Box
	_img_bg: Laya.Image
	_img_line: Laya.Image
	_panel_img: Laya.Image
	_lb_title: Laya.Label
	_scroll_boss: Laya.List
	_panel_btn: Laya.Image
	_lb_tips: Laya.Label
	_lb_time: Laya.Label
	_btn_add: Laya.Image
	public GetComponents() {
		[
			this._Group4,
			this._img_bg,
			this._img_line,
			this._panel_img,
			this._lb_title,
			this._scroll_boss,
			this._panel_btn,
			this._lb_tips,
			this._lb_time,
			this._btn_add,
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_img_bg",
				"_img_line",
				"_panel_img",
				"_lb_title",
				"_scroll_boss",
				"_panel_btn",
				"_lb_tips",
				"_lb_time",
				"_btn_add",
			])
	}
}
window["dwBossPanel"] = dwBossPanel