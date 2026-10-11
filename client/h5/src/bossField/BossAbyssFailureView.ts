import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { SceneManager } from "../scene/SceneManager"
import { BossModel } from "../commonModel/BossModel"

export class BossAbyssFailureView extends BaseView1 {
	CancelCountTime
	InitEvent
	LoadSuccess
	Local_Close
	Remove
	SetData
	StartCountTime

	data
	left_time
	time_func
	time_id

	public constructor() {
		super()
		this.left_time = 10;
		this.base_file = "bossField"
		this.layout_file = "BossAbyssFailureView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.back_login_toClose = true
		let local_TimeUtil = TimeUtil
		let local_laya = Laya

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			if (!this.data) {
				this.Close()
			}
			//this.AddUIEffect2("ui_defeated_glow2", this._gp_effect, null, null, false, null, null, null, true, true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIcon("fieldBoss", "uiboss_099"))
			this._lb_name.text = Util.StrToHTML("归属者：" + Util.HtmlColorTxt(this.data.name, Enum_ColorUtil_Dark.ORANGE))
			this._lb_fighting.text = this.data.fighting
			//let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
			//this._head_owner.setData(this.data.level, this.data.career, this.data.picture, null, null, frame_id)
			let end_time = local_TimeUtil.getServerTime() + this.left_time
			let func = () => {
				let left_time = end_time - local_TimeUtil.getServerTime()
				if (left_time < 0) {
					this.Close()
					return
				}
				this._lb_tips.text = "点击任意位置继续(" + left_time + "s)"
			}

			this.StartCountTime(func)
		}

		this.InitEvent = () => {

		}

		this.StartCountTime = (func?) => {
			this.CancelCountTime()
			this.time_func = func
			this.time_id = local_laya.new Timer(1000, 0)
			this.time_id.addEventListener(local_laya.TimerEvent.TIMER, func, this)
			this.time_id.start()
			func()
		}

		this.CancelCountTime = () => {
			if (this.time_id) {
				this.time_id.stop()
				this.time_id.removeEventListener(local_laya.TimerEvent.TIMER, this.time_func, this)
				this.time_id = null
				this.time_func = null
			}
		}

		this.Remove = () => {
			this.CancelCountTime()
			// if (this._head_owner) {
			// 	this._head_owner.DeleteMe()
			// 	this._head_owner = null
			// }
		}

		this.SetData = (data?) => {
			this.data = data
		}

		this.Local_Close = () => {
			if (SceneManager.GetInstance().IsAbyssBossScene()) {
				BossModel.GetInstance().Fire(BossModel.SCMD_REQUEST, 46004, BossModel.BossType.abyss)
			}
			super.Close()
		}
	}

	public Close() {
		this.Local_Close()
	}

	_gp_effect: Laya.Box
	_head_owner: Laya.Box
	_lb_name: Laya.Label
	_lb_tips: Laya.Label
	_Group1: Laya.HBox
	_Image1: Laya.Image
	_lb_fighting: Laya.Label
	_img_tips: Laya.Image
	public GetComponents() {
		[
			this._gp_effect,
			this._head_owner,
			this._lb_name,
			this._lb_tips,
			this._Group1,
			this._Image1,
			this._lb_fighting,
			this._img_tips,
		]
			= this.GetChildrenByNames([
				"_gp_effect",
				"_head_owner",
				"_lb_name",
				"_lb_tips",
				"_Group1",
				"_Image1",
				"_lb_fighting",
				"_img_tips",
			])
	}
}
window["BossAbyssFailureView"] = BossAbyssFailureView