import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer, LayerManager } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GameResPath } from "../util/GameResPath";
import { GlobalTimerQuest, Util } from "../util/Util";
import { CheckBox } from "./CheckBox";

export class BaseAlert extends BaseView1 {

	public is_charge = false
	public _close_btn
	public _content
	public _ok_btn
	public _cancel_btn
	public check
	public _img_icon
	public _lb_target
	public _title_lb
	public _lb_top
	public _lb_down
	public title_img
	public bg

	public _content_html
	public _lb_top_html
	public _lb_down_html
	public _lb_target_html

	public cancel_callback
	public left_time

	//private _end_time
	private checkBox

	slider

	Local_SetBaseInfo
	InitEvent
	OnTime
	SetCheckStatus
	SetOkBtnSkin
	ClearTimer
	Local_Close
	public constructor(show_content, ok_callback, cancel_callback, ok_text, cancel_text,
		left_time, is_close_hide, check_callback, check_text, use_background, good_source,
		target_text, title_text, three_top_text, three_down_text, show_close_ani = true, title_img, close_callback, alert_type = null) {
		super()

		let local_laya = Laya,
			local_Util = Util,
			show_content_,
			ok_callback_,
			ok_text_,
			cancel_text_,
			is_close_hide_,
			timer_,
			check_callback_: Function,
			check_text_,
			good_source_,
			target_text_,
			title_text_,
			top_text_,
			down_text_,
			show_close_ani_,
			title_img_,
			close_callback_,
			alert_type_

		this.layer_value = Enum_UILayer.FightingUp
		this.not_tooltips_jump_close = true
		show_content_ = show_content
		ok_callback_ = ok_callback
		this.cancel_callback = cancel_callback
		ok_text_ = ok_text
		cancel_text_ = cancel_text
		this.left_time = left_time
		is_close_hide_ = is_close_hide
		check_callback_ = check_callback
		check_text_ = check_text
		good_source_ = good_source
		target_text_ = target_text
		title_text_ = title_text
		top_text_ = three_top_text
		down_text_ = three_down_text
		title_img_ = title_img
		close_callback_ = close_callback
		alert_type_ = alert_type
		// this.horizontalCenter = 0
		// this.verticalCenter = 0
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background2 = true//use_background
		this.background_alpha = 0
		this.click_bg_toClose = true
		//this.use_alpha_bg = true
		this.load_callback = function () {
			this.LoadSuccess()
			if (this.check) {
				this.checkBox = new CheckBox(this.check, check_callback_, check_text_)
				this.checkBox.Load()
			}
			this.SetBaseInfo()
			this.InitEvent()

			if (this)

				if (alert_type_ == null) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("alert", "uisy_023"))
				}


		}

		this.destroy_callback = () => {
			if (this.checkBox) {
				this.checkBox.DeleteMe()
				this.checkBox = undefined
			}
			this.is_charge = false
		}

		this.Local_SetBaseInfo = () => {
			if (is_close_hide_ && this._close_btn)
				this._close_btn.visible = false
			if (this.left_time && this._cancel_btn && this.left_time > 0) {
				let onTimer = () => {

				}
				this.ClearTimer();
				// timer_ = new local_egret.Timer(1000, 0);
				// timer_.addEventListener(local_egret.TimerEvent.TIMER, this.OnTime, this);
				// timer_.start();
				timer_ = GlobalTimerQuest.AddDelayQuest(this.OnTime, 1)
				this.OnTime()
			}
			if (show_content_) {
				this._content_html.style.color = "#663915";
				if(window["PlatformManager"].IsEyouThPlatform()){
					this._content_html.style.fontSize = 32;
				}else{
				this._content_html.style.fontSize = 22;
				}
				this._content_html.style.align = "center"
				this._content_html.style.leading = 10

			}
			if (this._ok_btn && ok_text_) {
				var ok_label: Laya.Label = this._ok_btn.getChildByName("ok_label") as Laya.Label;
				ok_label.text = ok_text_
				ok_label.x = this._ok_btn.width / 2 - ok_label.width / 2
			}
			if (this._cancel_btn && cancel_text_ && !this.left_time) {
				var cancel_label: Laya.Label = this._cancel_btn.getChildByName("cancel_label") as Laya.Label;
				cancel_label.text = cancel_text_
				cancel_label.x = this._cancel_btn.width / 2 - cancel_label.width / 2
			}

			if (good_source_) {
				// this._img_icon.source = good_source_<img src="/i/eg_tulip.jpg"  alt="上海鲜花港 - 郁金香" />
				show_content_ += "<img src='" + good_source_ + "' width='40' height='40'/>"
			}
			if (target_text_) {
				show_content_ += target_text_
			}
			this._content_html.innerHTML = show_content_
			this._content_html.innerHTML = show_content_
			this._content_html.width = this._content.width
			this._content_html.x = this._content.width / 2 - this._content_html.contextWidth / 2
			this._content_html.y = this._content.height / 2 - this._content_html.contextHeight / 2
			if (this._title_lb && title_text_) {
				this._title_lb.text = title_text_
			}
			if (top_text_) {
				this._lb_top_html.style.color = "#663915";
				this._lb_top_html.style.fontSize = 22;
				this._lb_top_html.innerHTML = top_text_
				this._lb_top_html.width = this._content.width
				this._lb_top_html.x = 537 / 2 - this._lb_top_html.contextWidth / 2
			}
			if (down_text_) {
				this._lb_down_html.style.color = "#663915";
				this._lb_down_html.style.fontSize = 22;
				this._lb_down_html.innerHTML = down_text_
				this._lb_down_html.width = this._content.width
				this._lb_down_html.x = 537 / 2 - this._lb_down_html.contextWidth / 2
			}
			if (this.title_img && title_img_) {
				this.title_img.source = title_img_
			}
		}

		this.InitEvent = () => {
			if (this._ok_btn) {
				local_Util.AddClickEvent(this._ok_btn, () => {
					if (ok_callback_)
						ok_callback_()
					this.Close()
				}, this, true)
			}

			if (this._cancel_btn) {
				local_Util.AddClickEvent(this._cancel_btn, () => {
					if (this.cancel_callback)
						this.cancel_callback()
					this.Close()
				}, this, true)
			}


			local_Util.AddClickEvent(this._close_btn, () => {
				if (close_callback_) {
					close_callback_()
				}
				this.Close()
			}, this, true)

		}

		this.OnTime = () => {
			var cancel_label: Laya.Label = this._cancel_btn.getChildByName("cancel_label") as Laya.Label;
			cancel_label.text = (cancel_text_ || "取消") + "（" + this.left_time + "）"
			if (this.left_time > 0)
				this.left_time = this.left_time - 1
			else
				this.Close()
		}


		this.SetCheckStatus = (bool) => {
			if (this.check) {
				this.checkBox.selected = bool
			}
		}

		this.SetOkBtnSkin = (type) => {
			if (type == 1) {
				// this._ok_btn.skinName = ButtonThreeSkin
			}
		}

		this.ClearTimer = () => {
			if (timer_) {
				// timer_.stop();
				// timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.OnTime, this);
				GlobalTimerQuest.CancelQuest(timer_)
				timer_ = null;
			}
		}

		this.Local_Close = () => {
			if (this.cancel_callback) {
				this.cancel_callback(true)
				this.cancel_callback = undefined
			}
			this.ClearTimer()
			if (!show_close_ani_) {
				this.show_open_movie = false
			}
			super.Close()
		}
	}
	public LoadSuccess() {
	}

	public SetBaseInfo() {
		this.Local_SetBaseInfo()
	}

	// public GetComponents() {
	// 	[this._close_btn,
	// 	this._content,
	// 	this._ok_btn,
	// 	this._cancel_btn,
	// 	this.check,
	// 	this._img_icon,
	// 	this._lb_target,
	// 	this._title_lb,
	// 	this._lb_top,
	// 	this._lb_down,
	// 	this.title_img,
	// 	this.bg,
	// 	this._content_html,
	// 	this._lb_top_html,
	// 	this._lb_down_html,
	// 	this._lb_target_html] =
	// 		this.GetChildrenByNames(["_close_btn"
	// 			, "_content",
	// 			"_ok_btn",
	// 			"_cancel_btn",
	// 			"check",
	// 			"_img_icon",
	// 			"_lb_target",
	// 			"_title_lb",
	// 			"_lb_top",
	// 			"_lb_down",
	// 			"title_img",
	// 			"bg",
	// 			"_content_html",
	// 			"_lb_top_html",
	// 			"_lb_down_html",
	// 			"_lb_target_html"])

	// }
	public Close() {
		this.Local_Close()
	}
}
window["BaseAlert"] = BaseAlert