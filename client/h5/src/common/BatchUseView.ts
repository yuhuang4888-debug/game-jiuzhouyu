
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "./BaseView1"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetAnchoredPosition } from "../util/Util"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"
import { BaseAwardItem } from "./BaseAwardItem"
import { WithBtnHSlider } from "./WithBtnHSlider"
import { Mathf } from "../util/Mathf"
import { BagModel } from "../commonModel/BagModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "./EventName"
import { OutLineModel } from "../commonModel/OutLineModel"
import { DailyModel } from "../commonModel/DailyModel"
import { ColorUtil } from "../util/ColorUtil"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { SettingModel } from "../commonModel/SettingModel"
import { PlatformManager } from "../PlatformManager"
import { OnHookModel } from "../commonModel/OnHookModel"

export class BatchUseView extends BaseView1 {
	default_value
	_click_time
	goods_vo

	cur_quantity: any
	min_quantity: number
	max_quantity: number

	slider
	award_item
	out_line_model:OutLineModel

	public constructor() {
		super()
		this.dependent_res = ["bag"]
		this.base_file = "common"
		this.layout_file = "GoodsFuncView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.out_line_model = OutLineModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.close_callback = () => {
			this.CloseFunc()
		}
	}

	private CloseFunc() {
		if (this.slider) {
			this.slider.DeleteMe()
			this.slider = null
		}

		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}

	private Local_Open(param?, min?, default1?, max?) {
		this.goods_vo = param
		this.default_value = default1
		this.min_quantity = (min != null && (min) || (1))
		this.max_quantity = max || this.goods_vo.goods_num
		this.default_value = (this.default_value != null && (this.default_value) || (this.goods_vo.goods_num))
		if (this.is_loaded) {
			this.InitView()
		}
		super.Open()
	}

	private LoadSuccess() {
		if (this.goods_vo) {
			this.InitView()
		}
		this.gp_price.visible = false
		this.InitEvent();
		GlobalEventSystem.Fire(EventName.SETTING_INPUT_FOCUS);
	}

	private InitEvent() {
		Util.AddClickEvent(this.btn_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.btn_cancel, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.btn_enter, () => {
			let value = this.slider.GetValue()
			if (value) {
				value = Number(value.toFixed(0))
				if (this._click_time && this._click_time > TimeUtil.getServerTime()) {
					return
				}
				this._click_time = TimeUtil.getServerTime() + 1
				let ok_callback = () => {
					GoodsModel.GetInstance().Fire(GoodsModel.USE_BAG_GOODS, this.goods_vo.goods_id, value)
					this.Close()
				}

				let ok_callback2 = () => {
					GoodsModel.GetInstance().Fire(GoodsModel.USE_BAG_GOODS, this.goods_vo.goods_id, value)
					//微信订阅权限
					let s_model = SettingModel.GetInstance()
					if (s_model.CheckSubsOpen()) {
						let out_cfg = s_model.GetWxOutLinePosCfg()
						if (out_cfg&&!s_model.CheckWxSubsState(out_cfg.id)&&!s_model.WxCheckAntiKey(out_cfg.temp_id)) {
							let is_subscription = s_model.CheckWxSubsState(out_cfg.id)
							if (!is_subscription) {
								Message.show("更新订阅")
								PlatformManager.GetInstance().WeChatSubscriptionSH(out_cfg.id)
							}
						}
					}
					this.Close()
				}


				// 挂机卡使用
				if (this.goods_vo.type == 38 && this.goods_vo.subtype == 7) {
					let time = DailyModel.GetInstance().outline_info || this.out_line_model.GetOnhookTime()
					let add_time = this.out_line_model.add_time[this.goods_vo.type_id]
					if (time + add_time * value > this.out_line_model.max_outline_time) {
						let time = Math.floor(this.out_line_model.max_outline_time / 3600)
						Alert.Show("使用后离线挂机时间将会溢出（最多" + time + "个小时），是否继续使用？", Alert_Type.Two, ok_callback2)
					} else {
						ok_callback2()
					}
					return
				} else if (this.goods_vo.type == 38 && this.goods_vo.subtype == 10) {
					MarriageModel.GetInstance().Fire(MarriageEvent.GIVE_GIFT, this.goods_vo.type_id, value)
					this.Close()
					return
				}
				ok_callback()
			} else {
				Message.show("请选择使用数量")
			}
		}, this, true)
	}

	private InitView() {
		if (!this.goods_vo) {
			return
		}

		if (!this.award_item) {
			this.award_item = new BaseAwardItem(this.gp_item)
			this.award_item.Load()
			this.award_item.SetScale(0.7)
			//this.award_item.ChangeCountVisible(false)
		}
		this.award_item.SetData(this.goods_vo.type_id, this.goods_vo.goods_num, this.goods_vo.bind)
		this.award_item.SetShowTips(false)

		this.lb_name.text = this.goods_vo.goods_name
		this.lb_name.color = ColorUtil.GetColorLight(this.goods_vo.color, false)

		if(!this.slider){
			this.slider = new WithBtnHSlider(this.gp_slider)
			this.slider.Load()
		}
		this.slider.SetData(this.default_value, 1, this.min_quantity, this.max_quantity, true)
		this.slider.ExcuteCallback(() => {
			SetAnchoredPosition(this.slider.display_obj, -170, -70)
		})
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
window["BatchUseView"] = BatchUseView