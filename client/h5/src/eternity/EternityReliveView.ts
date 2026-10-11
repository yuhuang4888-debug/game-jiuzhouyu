import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { CustomRoleHead } from "../common/CustomRoleHead"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { EternityEvent, EternityModel } from "../commonModel/EternityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPosition, SetAnchoredPositionX, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class EternityReliveView extends BaseView1 {
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_box_effect: Laya.Box
	_lb_desc: Laya.Label
	_lb_count_down: Laya.Label
	_box_relive: Laya.Box
	_img_bg5: Laya.Image
	_lb_relive: Laya.Label
	_box_diamond_now: Laya.Box
	_img_icon: Laya.Image
	_lb_relive_cost: Laya.Label
	_box_relive_and_snatch: Laya.Box
	_img_bg4: Laya.Image
	_lb_relive_stand: Laya.Label
	_box_diamond_stand: Laya.Box
	_Image4: Laya.Image
	_lb_relive_cost0: Laya.Label
	_box_free_relive: Laya.Box
	_img_bg3: Laya.Image
	_lb_free_relive: Laya.Label
	_lb_killer_name: Laya.Label
	_box_killer_msg: Laya.Box
	_lb_fighting: Laya.Label
	_lb_killer_msg: Laya.Label
	_box_role_monster: Laya.Box
	_img_kuang: Laya.Image
	_img_circle: Laya.Image
	_img_mon_head: Laya.Image
	_box_role_head: Laya.Box
	_img_tips: Laya.Image
	_lb_to_safe: Laya.Label
	_box_help: Laya.Box
	_btn_help: Laya.Image
	_lb_help_time: Laya.Label
	_box_check: Laya.Box
	_img_auto_relive: Laya.Image
	_lb_auto_relive_time: Laya.Label
	_box_use_potion: Laya.Box
	_lb_desc2: Laya.Label
	_img_goods_icon: Laya.Image
	_lb_potion_num: Laya.HTMLDivElement
	checkHandler
	CheckMask
	InitEvent
	LoadSuccess
	Remove
	SetReliveBtn
	UpdateHead
	UpdateView
	_head_killer:CustomHeadItem
	initCheck
	onTimer
	selected

	public constructor() {
		super()


		this.base_file = "bossField"
		this.layout_file = "BossFieldReliveView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.background_alpha = 0.8
		//this.change_scene_close = true
		this.back_login_toClose = true
		this.not_close_by_android_back_key = true
		let scene_mgr = SceneManager.GetInstance()
		let _model = EternityModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let RELIVE_BY_TYPE = EventName.RELIVE_BY_TYPE
		let local_Message = Message
		let local_SceneEventType = SceneEventType
		let role_mgr = RoleManager.GetInstance()
		let layer_mgr = LayerManager.GetInstance()
		let local_SceneBaseType = SceneBaseType
		let local_GameResPath = GameResPath
		let local_TimeUtil = TimeUtil
		let left_time_ = 10
		let toSafe_time_ = 0
		let left_time_id_ = null
		let is_free_ = true
		let help_timer_ = null
		let last_time_ = null
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			is_free_ = true
			this.Remove()
		}

		this.LoadSuccess = () => {

		}

		this.InitEvent = () => {
			let relive_state = 1
			let relive_fuc = () => {
				if (1 == relive_state) {
					if (scene_mgr.IsEternityScene()) {
						local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 23)
					} else {
						local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 1, false, true)
					}
				} else if (2 == relive_state) {

					local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 1)
				} else if (3 == relive_state) {
					local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 3)
				}
			}

			

			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.MONSTER_VO_ADD, (instance_id?, monster_vo?) => {
				if (instance_id == scene_mgr.killerId) {
					this.UpdateHead()
				}
			}
			)
			//出现复活协议比20001协议死亡更早的情况
			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.UPDATE_KILLER, () => {
				this.UpdateView()
			}
			)
			Util.AddClickEvent(this._box_relive, () => {
				relive_state = 1
				if (Util.CheckMoney(20, relive_fuc, true, false, false)) {
					relive_fuc()
				}
			}, this, true)
			Util.AddClickEvent(this._box_free_relive, () => {
				if (scene_mgr.IsEternityScene()) {
					if (!this._img_bg3.mouseEnabled) {
						if (toSafe_time_ <= 0) {
							return
						}
						local_Message.show("复活疲劳层数过高")
					} else {
						if (scene_mgr.IsEternityScene()) {
							local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 22)
						} else {
							local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 3)
						}
					}
					return
				}
				if (Util.CheckMoney(20, relive_fuc, true, false, false)) {
					relive_fuc()
				}
			}, this, true)
			Util.AddClickEvent(this._box_relive_and_snatch, () => {
				relive_state = 2
				if (Util.CheckMoney(20, relive_fuc, true, false, false)) {
					relive_fuc()
				}
			}, this, true)

			Util.AddClickEvent(this._img_auto_relive, this.checkHandler, this, true)
			//this.check.addEventListener(Laya.UIEvent.CHANGE, this.checkHandler, this)
		}

		this.initCheck = () => {
			if (this._box_check.visible) {
				if (role_mgr.GetMainRoleVo().jinLock < 20) {
					this.selected = false
					_model._auto_relive = false
				} else {
					this.selected = _model._auto_relive
					ResManager.GetInstance().SetImageSprite(this, this._img_auto_relive, "common", this.selected ? "com_ui_gx1" : "com_ui_gx")
					//this.CheckMask.visible = 
					if (this.selected) {
						last_time_ = left_time_
						left_time_ = 5
					}
				}
			}
		}

		this.checkHandler = (e?) => {
			let select = !this.selected
			let autoRelive = _model._auto_relive
			this.selected = select
			//this.CheckMask.visible = select
			ResManager.GetInstance().SetImageSprite(this, this._img_auto_relive, "common", select ? "com_ui_gx1" : "com_ui_gx")
			if (autoRelive == select) {
				return
			}
			if (role_mgr.GetMainRoleVo().jinLock < 20) {
				this.selected = false
				local_Message.show("绑钻不足")
				return
			}
			_model._auto_relive = select
			if (select) {
				last_time_ = left_time_
				if (left_time_ < 5) {
					left_time_ = 0
				} else {
					left_time_ = 5
				}
			} else {
				if (last_time_ && left_time_) {
					left_time_ = last_time_ - (5 - left_time_)
					left_time_ = left_time_ > 0 && left_time_ || 0
				}
			}
			this._lb_count_down.text = String(left_time_)
		}

		this.UpdateHead = () => {
			let effect_width = 262
			let effect_height = 384
			let width = layer_mgr.stageWidth
			let height = layer_mgr.stageHeight
			let scale_x = width / effect_width
			let scale_y = height / effect_height
			if (this._head_killer) {
				this._head_killer.DeleteMe()
				this._head_killer = null
			}
			if (scene_mgr.killerType == local_SceneBaseType.Role) {
				this._box_role_monster.visible = false
				if (!this._head_killer) {
					this._head_killer = new CustomHeadItem(this.display_obj)
					this._head_killer.Load()
					this._head_killer.ExcuteCallback(() => {
						// this._head_killer.transform.pivot = Vector2(0.5, 0.5)
						// this._head_killer.transform.anchorMax = Vector2(0.5, 0.5)
						// this._head_killer.transform.anchorMin = Vector2(0.5, 0.5)
						// this._head_killer.SetPosition(-99.5,175)
						SetAnchoredPosition(this._head_killer.display_obj,316,498)
					})
				}
				let role_vo = scene_mgr.GetRoleVo(scene_mgr.killerId)
				let role_fight = 0
				if (role_vo) {
					this._lb_fighting.text = role_vo.fighting
					this._head_killer.SetRoleVoData(role_vo)
				} else {
					this._head_killer.SetData(null, 1)
				}
				//this._box_killer_msg.visible = true
				//this:AddUIEffect("ui_frame_white", this._gp_effect, null, {x=scale_x, y=scale_y}, true)
				//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIcon("bossField", "uiboss_038b"), true)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("boss", "com_up_bg2"))
			} else if (scene_mgr.killerType == local_SceneBaseType.Monster) {

				// if (!this._head_killer) {
				// 	this._head_killer = new CustomHeadItem(this.display_obj)
				// 	this._head_killer.Load()
				// 	this._head_killer.ExcuteCallback(() => {
				// 		// this._head_killer.transform.pivot = Vector2(0.5, 0.5)
				// 		// this._head_killer.transform.anchorMax = Vector2(0.5, 0.5)
				// 		// this._head_killer.transform.anchorMin = Vector2(0.5, 0.5)
				// 		// this._head_killer.SetPosition(0,175)
				// 	})
				// }
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("boss", "com_up_bg2"))
				let monster_vo = scene_mgr.GetMonsterVo(scene_mgr.killerId)
				this._box_killer_msg.visible = false
				if (monster_vo) {
					if (monster_vo && monster_vo.cfg_data)
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mon_head, GameResPath.GetMonsterHeadPath(monster_vo.cfg_data.icon))
				}
				// else {
				// 	this._head_killer.setData(null, 1, null, true, local_GameResPath.GetMonsterHeadPath("0"))
				// }
				//this:AddUIEffect("ui_frame_white", this._gp_effect, null, {x=scale_x, y=scale_y}, true)
				//ResManager.GetInstance().SetImageSprite(this, this._img_tips, "bossField_asset", "uiboss_038c", true)
			}
			this._lb_killer_name.text = "很遗憾！你被" + scene_mgr.killerName + "击杀！"
			this._lb_killer_msg.text = scene_mgr.killerName
		}

		this.UpdateView = () => {
			this.UpdateHead()
			if (scene_mgr.IsEternityScene()) {
				let rdata = _model.GetReliveData()
				if (!rdata) {
					_model.Fire(EternityEvent.REQUEST_PROTO, 27906)
					return
				}
				if (rdata.relive_time <= local_TimeUtil.getServerTime()) {
					return
				}
				let dieTimes = rdata.die_times
				let curtime = local_TimeUtil.getServerTime()
				left_time_ = rdata.relive_time - curtime
				if (rdata.safe_time > 0) {
					toSafe_time_ = rdata.safe_time - local_TimeUtil.getServerTime()
				}
				let relive_time = rdata.time - local_TimeUtil.getServerTime()
				Util.SetImageGray(this._img_bg3, dieTimes > rdata.min_times && relive_time > 0)
				this._img_bg3.mouseEnabled = !(dieTimes > rdata.min_times && relive_time > 0)
				this._lb_free_relive.stroke = !(dieTimes > rdata.min_times && relive_time > 0) ? 2 : 0
				this._lb_to_safe.visible = toSafe_time_ > 0
			}
			this.SetReliveBtn()
			this.initCheck()
			if (!left_time_id_) {
				let func = () => {
					this.onTimer()
				}
				left_time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
			}
			this.onTimer()
		}

		this.onTimer = () => {
			let rdata = _model.GetReliveData()
			if (!rdata) {
				return
			}
			let curtime = local_TimeUtil.getServerTime()
			if (this.selected) {
			} else {
				left_time_ = rdata.relive_time - curtime
			}
			if (rdata.safe_time > 0) {
				toSafe_time_ = rdata.safe_time - curtime
			}
			if (this._lb_to_safe.visible) {
				this._lb_to_safe.text = toSafe_time_ + "秒后将传送回安全区"
				if (toSafe_time_ <= 0) {
					this._lb_to_safe.visible = false
					if (scene_mgr.IsEternityScene()) {
						local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 21)
					} else {
						local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 20)
					}
				}
				//toSafe_time_=toSafe_time_-1
			}
			let role = RoleManager.GetInstance().GetMainRoleVo()
			if (left_time_ <= 0 && role.hp == 0) {
				if (this.selected) {
					local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 1, false, true)
				} else {
					if (scene_mgr.IsEternityScene()) {
						local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 22)
					} else {
						local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 3)
					}
				}
			} else if (left_time_ <= 0 && role.hp > 0) {//切后台回来，被服务端复活，关闭复活界面
				this.Close()
			}
			if (left_time_ >= 0) {
				this._lb_count_down.text = String(left_time_)
			}
			if (this.selected) {
				left_time_ = left_time_ - 1
			}
		}

		this.Remove = () => {
			SceneManager.Instance.SetKillerInfo(0)
			if (left_time_id_) {
				GlobalTimerQuest.CancelQuest(left_time_id_)
				left_time_id_ = null
			}
			if (this._head_killer) {
				this._head_killer.DeleteMe()
				this._head_killer = null
			}
			left_time_ = 10
		}

		this.SetReliveBtn = () => {
			//if (scene_mgr.IsEternityScene() ) {
			this._box_free_relive.visible = true
			this._box_relive.visible = true
			this._box_relive_and_snatch.visible = false
			// SetAnchoredPositionX(this._box_free_relive, -130)
			// SetAnchoredPositionX(this._box_relive, 130)
			this._box_free_relive.centerX = -100
			this._box_relive.centerX = 100
			this._lb_relive.text = "原地复活"
			this._lb_free_relive.text = "回出生点"
			this._lb_relive_cost.text = "20"
			this._box_check.visible = true
			//}
		}


	}



	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._box_effect,
			this._lb_desc,
			this._lb_count_down,
			this._box_relive,
			this._img_bg5,
			this._lb_relive,
			this._box_diamond_now,
			this._img_icon,
			this._lb_relive_cost,
			this._box_relive_and_snatch,
			this._img_bg4,
			this._lb_relive_stand,
			this._box_diamond_stand,
			this._Image4,
			this._lb_relive_cost0,
			this._box_free_relive,
			this._img_bg3,
			this._lb_free_relive,
			this._lb_killer_name,
			this._box_killer_msg,
			this._lb_fighting,
			this._lb_killer_msg,
			this._box_role_monster,
			this._img_kuang,
			this._img_circle,
			this._img_mon_head,
			this._box_role_head,
			this._img_tips,
			this._lb_to_safe,
			this._box_help,
			this._btn_help,
			this._lb_help_time,
			this._box_check,
			this._img_auto_relive,
			this._lb_auto_relive_time,
			this._box_use_potion,
			this._lb_desc2,
			this._img_goods_icon,
			this._lb_potion_num,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_box_effect",
				"_lb_desc",
				"_lb_count_down",
				"_box_relive",
				"_img_bg5",
				"_lb_relive",
				"_box_diamond_now",
				"_img_icon",
				"_lb_relive_cost",
				"_box_relive_and_snatch",
				"_img_bg4",
				"_lb_relive_stand",
				"_box_diamond_stand",
				"_Image4",
				"_lb_relive_cost0",
				"_box_free_relive",
				"_img_bg3",
				"_lb_free_relive",
				"_lb_killer_name",
				"_box_killer_msg",
				"_lb_fighting",
				"_lb_killer_msg",
				"_box_role_monster",
				"_img_kuang",
				"_img_circle",
				"_img_mon_head",
				"_box_role_head",
				"_img_tips",
				"_lb_to_safe",
				"_box_help",
				"_btn_help",
				"_lb_help_time",
				"_box_check",
				"_img_auto_relive",
				"_lb_auto_relive_time",
				"_box_use_potion",
				"_lb_desc2",
				"_img_goods_icon",
				"_lb_potion_num",
			])
	}
}
window["EternityReliveView"] = EternityReliveView
