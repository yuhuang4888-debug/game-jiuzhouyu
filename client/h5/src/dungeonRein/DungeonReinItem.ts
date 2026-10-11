import { BaseItem1 } from "../common/BaseItem1"
import { MainUIManager } from "../common/MainUIManager"
import { TranslationManager } from "../commonController/TranslationManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GuardModel } from "../commonModel/GuardModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { PlatformManager } from "../PlatformManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetSizeDeltaX, SetAnchoredPosition, SetAnchoredPositionY, SetAnchoredPositionX, Util, SetLocalScaleX } from "../util/Util"

export class DungeonReinItem extends BaseItem1 {
	UpdateArrowState
	UpdateView
	tween_id
	LoadSuccess
	InitEvent
	ClickFun
	public constructor(parent?) {
		super(parent)
		this.base_file = "dungeonRein"
		this.layout_file = "DungeonReinItem"
		let base_model = BaseDungeonModel.GetInstance()
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let local_laya = Laya
		let arrow_state_ = false
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.DeleteMe = () => {
			this.StopTween()
			if (this._lb_skill_desc) {
				this._lb_skill_desc.off(Laya.Event.LINK, this, this.ClickFun)
			}
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			if(PlatformManager.IsEyouPlatform()){
				this._Image2_title2.width = 236
				this._Image2_title2.sizeGrid ="0,32,0,36"
				this._lb_title2.fontSize = 16
				this._lb_title2.pos(31.5,23)
				TranslationManager.GetInstance().HelpLableCenter(this._lb_name,2,86,243,59)
				TranslationManager.GetInstance().HelpLableCenter(this._lb_tips,124,263,229,37)
			}
			this.display_obj.mouseThrough = true
			SetAnchoredPositionX(this.display_obj, 10)
			SetAnchoredPositionY(this.display_obj, 500)
			this.InitEvent()
			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_arrow, () => {
				arrow_state_ = !arrow_state_
				this.UpdateArrowState()
			}, this, true)

			MainUIManager.GetInstance().AddMoveComponent(this, this._box_con, false, null)

			// Util.AddClickEvent(this._lb_skill_desc, () => {

			// }, this, false)

			this._lb_skill_desc.on(Laya.Event.LINK, this, this.ClickFun)
		}

		this.ClickFun = () => {
			GuardModel.GetInstance().Fire(GuardModel.OPEN_VIEW, 1)
		}

		this.UpdateArrowState = () => {
			SetLocalScaleX(this.img2, arrow_state_ && 1 || -1)
			this.StopTween()
			let value = arrow_state_ && -250 || 0
			this.tween_id = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POSX, value, 0.3)
		}

		this.UpdateView = () => {
			this._lb_skill_desc.style.fontSize = 20
			this._lb_skill_desc.style.color = "#663915"
			this._lb_skill_desc.style.width = 233
			this._lb_skill_desc.style.align = "center"
			if(PlatformManager.IsEyouPlatform())
			{
				this._lb_skill_desc.style.leading = 0.1
			}
			this._lb_skill_desc.innerHTML = Util.StrToHTML("激活<font color='#0a953e'>守护喵</font>更易通关"
			)
		}

	}

	public StopTween() {

		if (this.tween_id) {
			SYTweenLite.Stop(this.tween_id)
			this.tween_id = null
		}
	}


	_box_con: Laya.Box
	_img_bg: Laya.Image
	_lb_name: Laya.Label
	_img_skill_icon: Laya.Image
	_lb_skill_desc: Laya.HTMLDivElement
	_img_arrow: Laya.Box
	img2: Laya.Image
	_Image2_title2: Laya.Image
	_lb_title2: Laya.Label
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._lb_name,
			this._img_skill_icon,
			this._lb_skill_desc,
			this._img_arrow,
			this.img2,
			this._Image2_title2,
			this._lb_title2,
			this._Image2,
			this._Image3,
			this._Label1,
			this._Label2,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_box_con",
				"_img_bg",
				"_lb_name",
				"_img_skill_icon",
				"_lb_skill_desc",
				"_img_arrow",
				"img2",
				"_Image2_title2",
				"_lb_title2",
				"_Image2",
				"_Image3",
				"_Label1",
				"_Label2",
				"_lb_tips",
			])
	}
}
window["DungeonReinItem"] = DungeonReinItem