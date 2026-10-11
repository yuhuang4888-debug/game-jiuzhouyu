import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ColorUtil } from "../util/ColorUtil"
import { GoodsModel } from "../commonModel/GoodsModel"
import { BaseAwardItem } from "../common/BaseAwardItem"

export class BossPersonalAlert extends BaseView1 {
	InitEvent
	InitView
	Local_Open

	public constructor() {
		super()
		this.base_file = "bossPersonal"
		this.layout_file = "BossPersonalAlert"
		this.use_background = true
		this.show_open_movie = true
		this.is_center = true
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.layer_value = Enum_UILayer.Activity

		let _awarditem_ = null
		let enter_type_ = null
		let dun_id_ = null
		let enter_callback_ = null
		let all_cost_ = 0
		let data_ = null
		let desc_ = null
		let btn_text_ = null

		this.load_callback = () => {
			this._lb_name.style.fontSize = 24
			this._lb_name.style.color = "#663915"
			this._lb_name.style.wordWrap = false
			
			this._lb_hint.style.fontSize = 22
			this._lb_hint.style.color = "#663915"
			this._lb_hint.style.wordWrap = false
			
			this.InitEvent()
			/*
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this._lb_name.size = 20
				let csf = this._lb_name.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this._lb_name, 338)
				SetAnchoredPositionY(this._lb_name, -131)
				this._lb_hint.size = 18
				this._lb_hint.lineSpacing = 0.8
				let csf = this._lb_hint.GetComponent("ContentSizeFitter")
				csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDeltaX(this._lb_hint, 518.5)
				SetAnchoredPositionY(this._lb_hint, -225)
				this._lb_hint.verticalAlign = "middle"
				this._lb_hint.textAlign = "center"
				this.labelDisplay1.size = 22
				this.labelDisplay.size = 22
			}
			*/
		}

		this.open_callback = () => {
			//LayoutRebuilder(this._Group1)
			this.InitView()
		}

		this.destroy_callback = () => {
			if (_awarditem_) {
				_awarditem_.DeleteMe()
				_awarditem_ = null
			}
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				data_ = { goods_type: parms[0], num: parms[1], need_num: parms[2], hite: parms[3], tiket_name: parms[5] }
				dun_id_ = parms[4]
				enter_type_ = parms[6]
				enter_callback_ = parms[7]
				desc_ = parms[8]
				btn_text_ = parms[9]
			}
			super.Open()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_cancel, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_enter, () => {
				if (enter_callback_) {
					enter_callback_()
				}
				this.Close()
			}, this, true)
		}

		this.InitView = () => {
			let goods_type = data_.goods_type
			let num = data_.num
			let need_num = data_.need_num
			let hite = data_.hite
			let tiket_name = data_.tiket_name
			let label = this.labelDisplay1
			if (btn_text_) {
				label.text = btn_text_
			}
			if (!_awarditem_) {
				_awarditem_ = new BaseAwardItem(this._gp_awarditem)
				_awarditem_.Load()
				_awarditem_.SetItemSize(100, 100)
			}
			_awarditem_.SetData(goods_type, null, false)
			this._lb_num.text = String(num)
			this._lb_need_num.text = "/" + need_num
			all_cost_ = hite * (need_num - num)
			let str = "可消耗<font color='#0a953e'>" + all_cost_ + "</font>绑定勾玉或勾玉进入(优先消耗绑定勾玉)"
			if (desc_) {
				str = desc_
			}
			this._lb_hint.innerHTML = Util.StrToHTML(str)
			if (num >= need_num) {
				this._lb_num.color = ColorUtil.TryParseHtmlString("#b3ff48")
			} else {
				this._lb_num.color = ColorUtil.TryParseHtmlString("#ff4f50")
			}
			let goodinfo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_type)
			//this._lb_name.text = goodinfo.goods_name
			let color = ColorUtil.GetColorLight(goodinfo.color)
			this._lb_name.innerHTML = "还缺少：" + "<font color=" + color + ">" + tiket_name + "</font>" + "x" + (String(need_num - num))
		}
	}

	public Open(...new_args) {
		let parms = new_args
		this.Local_Open(parms)
	}

	_Group4: Laya.Box
	_Image1: Laya.Image
	_Image3: Laya.Image
	_Group1: Laya.Image
	_Label1: Laya.Label
	_img_close: Laya.Image
	_btn_enter: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	_btn_cancel: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	_Group3: Laya.Box
	_gp_awarditem: Laya.Box
	_Image6: Laya.Image
	_Group2: Laya.HBox
	_lb_num: Laya.Label
	_lb_need_num: Laya.Label
	_Label2: Laya.Label
	_lb_name: Laya.HTMLDivElement
	_lb_hint: Laya.HTMLDivElement
	_lb_cost: Laya.Label
	public GetComponents() {
		[
			this._Group4,
			this._Image1,
			this._Image3,
			this._Group1,
			this._Label1,
			this._img_close,
			this._btn_enter,
			this._Image111,
			this.labelDisplay1,
			this._btn_cancel,
			this._Image11,
			this.labelDisplay,
			this._Group3,
			this._gp_awarditem,
			this._Image6,
			this._Group2,
			this._lb_num,
			this._lb_need_num,
			this._Label2,
			this._lb_name,
			this._lb_hint,
			this._lb_cost,
		]
			= this.GetChildrenByNames([

				"_Group4",
				"_Image1",
				"_Image3",
				"_Group1",
				"_Label1",
				"_img_close",
				"_btn_enter",
				"_Image111",
				"labelDisplay1",
				"_btn_cancel",
				"_Image11",
				"labelDisplay",
				"_Group3",
				"_gp_awarditem",
				"_Image6",
				"_Group2",
				"_lb_num",
				"_lb_need_num",
				"_Label2",
				"_lb_name",
				"_lb_hint",
				"_lb_cost",
			])
	}
}
window["BossPersonalAlert"] = BossPersonalAlert