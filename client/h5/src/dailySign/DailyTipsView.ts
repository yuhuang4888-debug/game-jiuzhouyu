import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDelta, Util } from "../util/Util"

export class DailyTipsView extends BaseView1 {
	_Image111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Label1: Laya.Label
	_content: Laya.HTMLDivElement
	_Group1: Laya.HBox
	left_label: Laya.HTMLDivElement
	_Image6: Laya.Image
	_gp_vip: Laya.Box
	_gp_vipl: Laya.Box
	Image: Laya.Image
	_gp_vipr: Laya.Box
	_lb_vip: Laya.Label
	_cancel_btn: Laya.Box
	_Image11: Laya.Image
	_lb_cancel: Laya.Label
	_ok_btn: Laya.Box
	_Image1: Laya.Image
	_lb_ok: Laya.Label
	_close_btn: Laya.Image
	_Label2: Laya.Label
	Emp_cancel_btn
	Emp_ok_btn
	InitEvent
	LoadSuccess
	Out_lb_cancel
	Out_lb_ok
	Remove
	background_alpha
	click_bg_toClose
	destroy_callback
	goods_list
	is_center
	show_open_movie
	use_background

	public constructor(tip_type?, time?, money?, ok_func?, cancel_func?, reward?) {
		super()


		let type_ = tip_type
		let ok_callback_ = ok_func
		let cancel_callback_ = cancel_func
		let time_ = time
		let money_ = money
		let reward_ = reward

		this.base_file = "dailySign"
		this.layout_file = "DailyTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.use_background = true
		this.background_alpha = 1
		this.click_bg_toClose = true

		this.goods_list = []

		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._content.size = 20
			// 	this._content.lineSpacing = 1
			// 	let csf = this._lb_cancel.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDelta(this._lb_cancel, 170, 70)
			// 	this._lb_cancel.verticalAlign = "middle"
			// 	this._lb_cancel.textAlign = "center"
			// }
			this.LoadSuccess()
			this.InitEvent()
		}
		this.destroy_callback = () => {
			this.Remove()
		}

		this.LoadSuccess = () => {
			this._content.innerHTML = time_
			this._content.x=581/2-this._content.contextWidth/2
			if (type_ == 1) {	//补签提示
				this._gp_vip.visible = false

				this.left_label.innerHTML = money_
				// LayoutRebuilder(this._Group1)
			} else if (type_ == 2) {	//vip双倍提示
				this._Group1.visible = false

				this._lb_ok.text = "提升VIP"
				this._lb_cancel.text = "坚持领奖"

				for (let i = 0; i < 2; i++) {
					let parent_ = i == 0 && this._gp_vipl || this._gp_vipr
					let item = new BaseAwardItem(parent_, null, "Activity")
					item.Load()
					item.SetScale(0.7)
					this.goods_list[i] = item
				}
				if (reward_) {
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward_[0][0], reward_[0][1])
					let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						for (let i = 0; i < 2; i++) {
							let vip_item = this.goods_list[i]
							if (vip_item) {
								vip_item.SetData(goods_vo.type_id, Number(reward_[0][2]) * (i+1), lock)
							}
						}
					}

				}

			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._ok_btn, () => {
				if (ok_callback_) {
					ok_callback_()
				}
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._cancel_btn, () => {
				if (cancel_callback_) {
					cancel_callback_()
				}
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._close_btn, () => {
				this.Close()
			}, this, true)
		}

		this.Remove = () => {
			if (this.goods_list.length > 0) {
				for (let k in this.goods_list) {
					var item = this.goods_list[k]
					item.DeleteMe()
				}
				this.goods_list = []
			}
		}

	}



	public GetComponents() {
		[
			this._Image111,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Label1,
			this._content,
			this._Group1,
			this.left_label,
			this._Image6,
			this._gp_vip,
			this._gp_vipl,
			this.Image,
			this._gp_vipr,
			this._lb_vip,
			this._cancel_btn,
			this._Image11,
			this._lb_cancel,
			this._ok_btn,
			this._Image1,
			this._lb_ok,
			this._close_btn,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_Image111",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Label1",
				"_content",
				"_Group1",
				"left_label",
				"_Image6",
				"_gp_vip",
				"_gp_vipl",
				"Image",
				"_gp_vipr",
				"_lb_vip",
				"_cancel_btn",
				"_Image11",
				"_lb_cancel",
				"_ok_btn",
				"_Image1",
				"_lb_ok",
				"_close_btn",
				"_Label2",
			])
		this._content.style.fontSize=24
		this._content.style.color="#663915"
		this._content.style.wordWrap=false
		this.left_label.style.fontSize=24
		this.left_label.style.color="#663915"
		this.left_label.style.wordWrap=false
	}
}
window["DailyTipsView"]=DailyTipsView