import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { ColorUtil } from "../util/ColorUtil"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WithBtnHSlider } from "../common/WithBtnHSlider"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util, SetAnchoredPosition } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"

export class SellView extends BaseView1 {
	CloseCallback
	InitEvent
	show_open_movie
	slider
	use_background
	click_bg_toClose
	sell_count
	min
	sell_price
	close_callback
	goods_vo
	goodsmodel
	destroy_imm
	award_item
	SetText
	is_center
	InitView
	Local_Open

	public constructor() {
		super()
		this.base_file = "common"
		this.layout_file = "GoodsFuncView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true

		this.goodsmodel = GoodsModel.GetInstance()
		this.min = 1
		this.sell_price = 0
		let local_GoodsModel = GoodsModel

		this.load_callback = () => {
			this.lb_title.text = "批量出售"
			if (this.goods_vo) {
				this.InitView()
			}
			this.InitEvent()
		}

		this.close_callback = () => {
			this.CloseCallback()
		}

		this.Local_Open = (goods_vo?) => {
			this.goods_vo = goods_vo
			if (this.is_loaded) {
				this.InitView()
			}
			super.Open()
		}

		this.InitView = () => {
			if (!this.goods_vo) {
				return
			}
			if (!this.award_item) {
				this.award_item = new BaseAwardItem(this.gp_item)
				this.award_item.Load()
				this.award_item.SetScale(0.7)
				this.award_item.ChangeCountVisible(false)
				this.award_item.SetShowTips(false)
			}
			this.award_item.SetData(this.goods_vo.type_id)

			this.lb_name.text = this.goods_vo.goods_name
			this.lb_name.color = ColorUtil.GetColorLight(this.goods_vo.color, false)

			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_goods_price", false)
			let price_cfg = cfg[this.goods_vo.type_id]
			if (price_cfg) {
				this.sell_price = price_cfg.sell_price
				let sell_price_type = price_cfg.sell_price_type
				if (sell_price_type == 1) {
					ResManager.GetInstance().SetImageSprite(this, this.price_image, "common", "com_diamond")
					//this.price_image.source = "common_json.com_diamond_png"
				} else if (sell_price_type == 2) {
					ResManager.GetInstance().SetImageSprite(this, this.price_image, "common", "com_bind_diamond")
					//this.price_image.source = "common_json.com_cind_diamond_png"
				} else if (sell_price_type == 3) {
					ResManager.GetInstance().SetImageSprite(this, this.price_image, "common", "com_gold")
					//this.price_image.source = "common_json.com_gold_png"
				}
			}
			if(!this.slider){
				this.slider = new WithBtnHSlider(this.gp_slider)
				this.slider.Load()
			}
			this.slider.SetData(this.goods_vo.goods_num, 1, 0, this.goods_vo.goods_num, true, (value?) => {
				value = Number(value.toFixed(0))
				this.sell_count = value
				this.lb_price.text = String(this.sell_price * value)
			})

			this.slider.ExcuteCallback(() => {
				SetAnchoredPosition(this.slider.display_obj, -170, -70)
			})

			this.SetText()
		}

		this.InitEvent = () => {
			let OnCloseBtnClick = () => {
				this.Close()
			}
			Util.AddClickEvent(this.btn_close, OnCloseBtnClick, this, true)
			
			let OnCancelBtnClick = () => {
				this.Close()
			}
			Util.AddClickEvent(this.btn_cancel, OnCancelBtnClick, this, true)
			
			let OnEnterBtnClick = () => {
				let num = this.slider.GetValue()
				num = Number(num.toFixed(0))
				if(num < 1){
					Message.show("出售数量必须大于0")
					return
				}
				let list = [{ goods_id: this.goods_vo.goods_id, num: num }]
				this.goodsmodel.Fire(local_GoodsModel.SELL_GOODS, list)
				this.Close()
			}

			Util.AddClickEvent(this.btn_enter, OnEnterBtnClick, this, true)
		}

		this.SetText = () => {
			this.lb_enter.text = "出售"
			this.price_text.text = "价格:"
			this.price_text.visible = true
			this.price_image.visible = true
			this.lb_price.visible = true
			//this.cancel_btn.GetComponent("Text").text = "取消"
			//this.enter_btn.label = "确定"
		}

		this.CloseCallback = () => {
			if (this.slider) {
				this.slider.DeleteMe()
				this.slider = null
			}
			if (this.award_item) {
				this.award_item.DeleteMe()
				this.award_item = null
			}
		}
	}

	public Open(goods_vo?) {
		this.Local_Open(goods_vo)
	}

	img_bg: Laya.Image
	img_bg2: Laya.Image
	img_bg3: Laya.Image
	lb_title: Laya.Label
	lb_name: Laya.Label
	gp_item: Laya.Box
	gp_price: Laya.Box
	price_text: Laya.Label
	lb_price: Laya.Label
	price_image: Laya.Image
	gp_slider: Laya.Box
	btn_close: Laya.Image
	btn_cancel: Laya.Image
	lb_cancel: Laya.Label
	btn_enter: Laya.Image
	lb_enter: Laya.Label
	public GetComponents() {
		[
			this.img_bg,
			this.img_bg2,
			this.img_bg3,
			this.lb_title,
			this.lb_name,
			this.gp_item,
			this.gp_price,
			this.price_text,
			this.lb_price,
			this.price_image,
			this.gp_slider,
			this.btn_close,
			this.btn_cancel,
			this.lb_cancel,
			this.btn_enter,
			this.lb_enter,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"img_bg2",
				"img_bg3",
				"lb_title",
				"lb_name",
				"gp_item",
				"gp_price",
				"price_text",
				"lb_price",
				"price_image",
				"gp_slider",
				"btn_close",
				"btn_cancel",
				"lb_cancel",
				"btn_enter",
				"lb_enter",
			])
	}
}
window["SellView"] = SellView