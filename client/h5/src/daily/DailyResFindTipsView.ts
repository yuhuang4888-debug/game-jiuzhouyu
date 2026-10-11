import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { GoodsType } from "../common/CommonGoodsListVo"
import { Enum_UILayer } from "../common/LayerManager"
import { LuaSoundManager } from "../common/SoundManager"
import { WithBtnHSlider } from "../common/WithBtnHSlider"
import { DailyModel } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { Util, SetAnchoredPosition, SetHtmlCenter } from "../util/Util"
import { DailyEvent } from "./DailyEvent"

export class DailyResFindTipsView extends BaseView1 {
	InitEvent
	LoadSuccess
	OpenCallback
	RefreshPrice
	SetSlider
	_Local_Open

	public constructor() {
		super()

		let model = DailyModel.GetInstance()
		let local_Util = Util
		let local_DailyEvent = DailyEvent
		//let shop_model = ShopModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_Erlang = ErlangParser.GetInstance()
		let _data = null
		let _slider = null
		let _one_price = null
		let _extra_price = 0
		let _now_times = 0
		let _extra_times = 0
		let _fixed_times = 0
		let _all_price = 0
		this.base_file = "daily"
		this.dependent_res = ["bag"]
		this.layout_file = "DailyResFindTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			if (_slider) {
				_slider.DeleteMe()
				_slider = null
			}
		}

		this.LoadSuccess = () => {

		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.cancleBtn, close_fun, this, true)

			Util.AddClickEvent(this.confirmBtn, () => {
				if (_data) {
					let _type = (model.resFindCheck[0] && (1) || (2))
					if (model.resFindCheck[0]) {
						if (_now_times > _data.lefttimes && _now_times <= _data.lefttimes + _data.lefttimes_vip) {
							_extra_times = _now_times - _data.lefttimes
							_fixed_times = _data.lefttimes
						}
						else if (_now_times <= _data.lefttimes) {
							_fixed_times = _now_times
							_extra_times = 0
						}
					}
					let ok_func = () => {
						if(_fixed_times + _extra_times <= 0)
						{
							Message.show("请至少找回1次")
							return
						}
						model.Fire(local_DailyEvent.RES_FIND_REQUEST_PROTO, 41903, "ihchh", _data.act_id, _data.act_sub, _type, _fixed_times, _extra_times)
					}

					let check_func = (bool?) => {
						model.res_find_not_alert = bool
					}

					let cancle_fun = () => {
						if (this.display_obj) {
							this.display_obj.visible = true
						}
					}

					if (_type == 1) {
						//let enough, gap = shop_model.MoneyIsEnough(2, _all_price)
						let enough, gap = goods_model.CheckCoinEnough(GoodsType.Bangzuan, _all_price, false, null, true, true)
						if (!enough) {
							//let diamond_enough, gap2 = shop_model.MoneyIsEnough(1, gap)
							let diamond_enough, gap2 = goods_model.CheckCoinEnough(GoodsType.Zuanshi, gap)
							if (diamond_enough) {
								if (!model.res_find_not_alert) {
									let str = "<font color='#ff4f50'>当前绑玉数量不足，是否消耗<font color='#639c12'>" + gap + "勾玉</font>代替？</font>"
									let content = str
									Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, cancle_fun, "确定", "取消", null, false, check_func, "本次登录不再提示")
									Alert.SetIsCharge(true)
									this.display_obj.visible = false
								} else {
									ok_func()
								}
							} else {
								ok_func()
							}
						} else {
							ok_func()
						}
					} else {
						ok_func()
					}
				}
			}
				, this, true)
			this.BindEvent(model, local_DailyEvent.RES_FIND_SUCCESS, () => {
				this.Close()
			}
			)
		}

		this._Local_Open = (parms?) => {
			_data = parms
			if (parms) {
				_data = parms[0]
			}
			super.Open()
		}

		this.OpenCallback = () => {
			if (!_data) {
				return
			}
			let money = null
			let extra_money = null
			let title_str = null
			let default_value = 1
			let max = 1
			if (model.resFindCheck[0] && _data.config_res_act) {
				money = JSON.parse(_data.config_res_act.gold_per)
				extra_money = JSON.parse(_data.config_res_act.other_cost)
				if (_data.lefttimes == 0) {
					default_value = _data.lefttimes_vip
					max = _data.lefttimes + _data.lefttimes_vip
					//this:SetSlider(_data.lefttimes_vip, 1, 0, _data.lefttimes + _data.lefttimes_vip)
				} else {
					default_value = _data.lefttimes
					max = _data.lefttimes + _data.lefttimes_vip
					//this:SetSlider(_data.lefttimes, 1, 0, _data.lefttimes + _data.lefttimes_vip)
				}
				if (extra_money && extra_money[0]) {
					title_str = _data.config_res_act.name + " (可找回<font color='#0a953e'>" + _data.lefttimes + "</font>次, 额外次数<font color='#0a953e'>+" + _data.lefttimes_vip + "</font>)"
				} else {
					title_str = _data.config_res_act.name + " (可找回<font color='#0a953e'>" + _data.lefttimes + "</font>次)"
				}
			} else {
				money = JSON.parse(_data.config_res_act.coin_per)
				default_value = _data.lefttimes
				max = _data.lefttimes
				//this:SetSlider(_data.lefttimes, 1, 0, _data.lefttimes)
				title_str = _data.config_res_act.name + " (可找回<font color='#0a953e'>" + _data.lefttimes + "</font>次)"
			}
			_one_price = (money && (money[0][2]) || (0))
			if (extra_money) {
				_extra_price = (extra_money[0] && (extra_money[0][2]) || (0))
			}
			this.title.style.fontSize = 24
			this.title.width = 538
			this.title.style.color = "#663915"
			this.title.innerHTML = title_str
			SetHtmlCenter(this.title, { "x": 28, "w": 538 })

			this.SetSlider(default_value, 1, 0, max)
		}

		this.SetSlider = (default_value?, step?, min?, max?) => {
			_now_times = Math.round(default_value)
			let call_fun = (value?) => {
				_now_times = Math.round(value)
				this.RefreshPrice(value)
			}

			if (!_slider) {
				_slider = new WithBtnHSlider(this.slider_group)
				_slider.SetData(default_value, step, min, max, true, call_fun)
				_slider.Load()

				_slider.ExcuteCallback(() => {
					SetAnchoredPosition(_slider.transform, -289, 30)
				})
			} else {
				_slider.SetData(default_value, step, min, max, true, call_fun)
			}
		}

		this.RefreshPrice = (value?) => {
			_extra_times = 0
			_fixed_times = Math.round(_now_times)
			let money = Math.round(value) * Number(_one_price)
			if (model.resFindCheck[0]) {
				if (_now_times > _data.lefttimes && _now_times <= _data.lefttimes + _data.lefttimes_vip) {
					_extra_times = _now_times - _data.lefttimes
					_fixed_times = _data.lefttimes
				}
				else if (_now_times <= _data.lefttimes) {
					_fixed_times = _now_times
					_extra_times = 0
				}
				money = _fixed_times * Number(_one_price) + _extra_times * Number(_extra_price)
			}
			_all_price = money
			let str = "总价：<font color='#0a953e'>" + money + "</font>绑玉(单价" + _one_price + "绑玉，额外单价" + _extra_price + "绑玉)"
			if (_extra_price == 0) {
				str = "总价：<font color='#0a953e'>" + money + "</font>绑玉(单价" + _one_price + "绑玉)"
			}
			if (model.resFindCheck[1]) {
				this.price.visible = false
				return
			}
			this.price.visible = true
			this.price.style.fontSize = 20
			this.price.width = 533
			this.price.style.color = "#663915"
			this.price.innerHTML = str
		}


	}

	public Open(...new_args) {

		let params = new_args
		this._Local_Open(params)
	}


	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	closeBtn: Laya.Image
	_Image5: Laya.Image
	cancleBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	confirmBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	title: Laya.HTMLDivElement
	price: Laya.HTMLDivElement
	slider_group: Laya.Box
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image4,
			this.closeBtn,
			this._Image5,
			this.cancleBtn,
			this._Image1,
			this.labelDisplay,
			this.confirmBtn,
			this._Image111,
			this.labelDisplay1,
			this.title,
			this.price,
			this.slider_group,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Image3",
				"_Image4",
				"closeBtn",
				"_Image5",
				"cancleBtn",
				"_Image1",
				"labelDisplay",
				"confirmBtn",
				"_Image111",
				"labelDisplay1",
				"title",
				"price",
				"slider_group",
			])
	}
}
window["DailyResFindTipsView"] = DailyResFindTipsView