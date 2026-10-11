import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { DressModel, DressType } from "../commonModel/DressModel"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, GlobalTimerQuest } from "../util/Util"

export class DungeonDragonReliveView extends BaseView1 {
	Clear
	InitEvent
	LoadSuccess
	UpdateHead
	UpdateView
	destroy_callback
	destroy_imm
	is_center
	not_close_by_android_back_key
	onTimer
	open_callback
	use_background

	head_killer
	public constructor() {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonReliveView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.is_center = true
		this.not_close_by_android_back_key = true
		let scene_mgr = SceneManager.GetInstance()
		let local_laya = Laya
		let local_GlobalEventSystem = GlobalEventSystem
		let local_Util = Util
		let layer_mgr = LayerManager.GetInstance()
		let local_SceneBaseType = SceneBaseType
		let local_GameResPath = GameResPath
		let RELIVE_BY_TYPE = EventName.RELIVE_BY_TYPE
		let left_time_ = 6
		let left_time_id_ = null
		let voice
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}
			this.Clear()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.Clear = () => {
			if (left_time_id_) {
				GlobalTimerQuest.CancelQuest(left_time_id_)
				left_time_id_ = null
			}
		}

		this.InitEvent = () => {
			let relive_fuc = () => {
				local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 1, false, true)
			}

			Util.AddClickEvent(this._gp_relive, () => {
				if (Util.CheckMoney(20, relive_fuc, true, false, false)) {
					relive_fuc()
				}
			}
				, this, true)
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("fieldBoss", "uiboss_039b"), true)
			voice = CommonManager.GetInstance().PlayFightingVoice(1)
		}

		this.UpdateView = () => {
			this._lb_killer_name.text = "很遗憾！你被" + scene_mgr.killerName + "击杀！"
			this._lb_killer_msg.text = scene_mgr.killerName
			this.UpdateHead()
			left_time_ = 6
			// if (! left_time_id_ ) {
			// 	left_time_id_ = local_laya. new Timer(1000, 0)
			// 	left_time_id_.addEventListener(local_laya.TimerEvent.TIMER, this.onTimer, this)
			// }
			// left_time_id_.start()
			if (!left_time_id_) {
				left_time_id_ = GlobalTimerQuest.AddPeriodQuest(() => {
					this.onTimer()
				}, 1, -1)
			}
			this.onTimer()
		}

		this.UpdateHead = () => {
			let effect_width = 262
			let effect_height = 384
			let width = layer_mgr.stageWidth
			let height = layer_mgr.stageHeight
			let scale_x = width / effect_width
			let scale_y = height / effect_height

			if (!this.head_killer) {
				this.head_killer = new CustomHeadItem(this._head_killer)
				this.head_killer.Load()
			}
			//this.role_head.SetData(data.player_id, data.career, data.sex, data.picture, data.picture_ver)

			if (scene_mgr.killerType == local_SceneBaseType.Role) {
				let role_vo = scene_mgr.GetRoleVo(scene_mgr.killerId)
				let role_fight = 0
				if (role_vo) {
					this._lb_fighting.text = role_vo.fighting
					let frame_id = DressModel.GetInstance().GetDressByType(role_vo.dress_list, DressType.Photo)
					this.head_killer.setData(role_vo.player_id, role_vo.career, role_vo.sex, role_vo.picture, role_vo.picture_ver)
				} else {
					this.head_killer.setData(null, 1, role_vo.sex, role_vo.picture, role_vo.picture_ver)
					//this.head_killer.setData(null, 1, null, true, local_GameResPath.GetMonsterHeadPath("0"))
				}
				this._gp_killer_msg.visible = true
				// this._head_killer.horizontalCenter = -99.5
				// this.AddUIEffect("ui_frame_white", this._gp_effect, null, {x=scale_x, y=scale_y}, true)
			} else if (scene_mgr.killerType == local_SceneBaseType.Monster) {
				let monster_vo = scene_mgr.GetMonsterVo(scene_mgr.killerId)
				this._gp_killer_msg.visible = false
				// this._head_killer.horizontalCenter = 0
				if (monster_vo) {
					this.head_killer.setData(monster_vo.cfg_data.lv, 1, null, true, local_GameResPath.GetMonsterHeadPath(monster_vo.cfg_data.icon))
				} else {
					this.head_killer.setData(null, 1, null, true, local_GameResPath.GetMonsterHeadPath("0"))
				}
				// this.AddUIEffect("ui_frame_white", this._gp_effect, null, {x=scale_x, y=scale_y}, true)
			}
		}

		this.onTimer = () => {
			if (left_time_ <= 0) {
				// left_time_id_.stop()
				GlobalTimerQuest.CancelQuest(left_time_id_)
				local_GlobalEventSystem.Fire(RELIVE_BY_TYPE, 11)
			}
			this._lb_count_down.text = String(left_time_)
			left_time_ = left_time_ - 1
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_gp_effect: Laya.Box
	_Label1: Laya.Label
	_lb_killer_name: Laya.Label
	_lb_count_down: Laya.Label
	_head_killer: Laya.Box
	_gp_killer_msg: Laya.Box
	_lb_fighting: Laya.Label
	_Image1: Laya.Image
	_lb_killer_msg: Laya.Label
	_gp_relive: Laya.Box
	_Image2: Laya.Image
	_lb_relive: Laya.Label
	_Image3: Laya.Image
	_lb_relive_cost: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._gp_effect,
			this._Label1,
			this._lb_killer_name,
			this._lb_count_down,
			this._head_killer,
			this._gp_killer_msg,
			this._lb_fighting,
			this._Image1,
			this._lb_killer_msg,
			this._gp_relive,
			this._Image2,
			this._lb_relive,
			this._Image3,
			this._lb_relive_cost,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_effect",
				"_Label1",
				"_lb_killer_name",
				"_lb_count_down",
				"_head_killer",
				"_gp_killer_msg",
				"_lb_fighting",
				"_Image1",
				"_lb_killer_msg",
				"_gp_relive",
				"_Image2",
				"_lb_relive",
				"_Image3",
				"_lb_relive_cost",
			])
	}
}
window["DungeonDragonReliveView"] = DungeonDragonReliveView