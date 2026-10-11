import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest } from "../util/Util"
import { SceneEventType } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { BossModel } from "../commonModel/BossModel"

export class BossSuitExit extends BaseView1 {
	CancelTime
	InitEvent
	LoadSuccess
	Local_Close
	StartTime
	btn_callback
	close_time
	hid_tired
	left_time
	on_time
	open_callback
	timer

	public constructor(left_time?, title?, content?, btn_callback?, hid_tired?) {
		super()
		this.base_file = "suitboss"
		this.layout_file = "BossSuitExit"
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.back_login_toClose = true
		this.is_center = true

		this.left_time = 30
		this.close_time = left_time
		this.btn_callback = btn_callback
		this.hid_tired = hid_tired

		let boss_base_model = BossModel.GetInstance()
		let exit_time = 0
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.InitEvent()
			this.StartTime()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_027, GameResPath.GetIcon("suitboss", "uighyh_027"), true)
			ResManager.GetInstance().LoadFont(this, "scene_boss", this._bit_time, null, false)
			this._img_028.visible = !this.hid_tired
			// if (!this.hid_tired) {
			// 	//lua_resM:SetOutsideImageSprite(this, this._img_028, GameResPath.GetIcon("suitboss","uighyh_028"),true)
			// } else {
			// 	SetAnchoredPositionY(this._gp_time, -35)
			// }
		}

		this.InitEvent = () => {
			let ok_func = () => {
				if (this.btn_callback) {
					this.btn_callback()
				}
				this.Close()
			}
			Util.AddClickEvent(this._ok_btn, ok_func, this, true)
			
			let scene_changed_func = () => {
				this.Close()
			}
			this.BindEvent(GlobalEventSystem, SceneEventType.SCENE_CHANGED, scene_changed_func)
		}

		this.StartTime = () => {
			this.CancelTime()
			exit_time = TimeUtil.getServerTime() + this.close_time
			this.timer = GlobalTimerQuest.AddPeriodQuest(this.on_time, 0.2, -1)
			this.on_time()
		}

		this.on_time = () => {
			let left_time = exit_time - TimeUtil.getServerTime()
			boss_base_model.relive_time = left_time
			if (left_time <= 0) {
				if (this.btn_callback) {
					this.btn_callback()
				}
				this.Close()
				return
			}
			this._bit_time.text = String(left_time)
		}

		this.CancelTime = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
			}
			exit_time = 0
		}

		this.Local_Close = () => {
			this.CancelTime()
			boss_base_model.relive_time = 0
			super.Close()
		}
	}

	public Close() {
		this.Local_Close()
	}

	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_lb_title: Laya.Label
	_lb_content: Laya.Label
	_ok_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_close_btn: Laya.Image
	_img_027: Laya.Image
	_img_028: Laya.Image
	_gp_time: Laya.Box
	_bit_time: Laya.Label
	_img_029: Laya.Image
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._lb_title,
			this._lb_content,
			this._ok_btn,
			this._Image1,
			this.labelDisplay,
			this._close_btn,
			this._img_027,
			this._img_028,
			this._gp_time,
			this._bit_time,
			this._img_029,
		]
			= this.GetChildrenByNames([
				"_Image11",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_lb_title",
				"_lb_content",
				"_ok_btn",
				"_Image1",
				"labelDisplay",
				"_close_btn",
				"_img_027",
				"_img_028",
				"_gp_time",
				"_bit_time",
				"_img_029",
			])
	}
}
window["BossSuitExit"] = BossSuitExit