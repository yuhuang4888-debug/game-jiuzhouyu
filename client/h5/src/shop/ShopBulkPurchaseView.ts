import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, NotEnougnDiamond, Trim } from "../util/Util"
import { OnHookModel } from "../commonModel/OnHookModel"
import { SpecialCharKey } from "../common/SpecialCharKey"

export class ShopBulkPurchaseView extends BaseView1 {
	GetOnePrice
	InitEvent
	LoadSuccess
	Local_Open
	NumChange
	NumChangeByCalculator
	SetAllPrice
	SetCurNum
	SetData
	calculator_fun
	title_bg

	public constructor() {
		super()


		this.base_file = "shop"
		this.layout_file = "ShopBulkPurchaseView"
		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true

		let model = ShopModel.GetInstance()
		let local_ShopEvent = ShopEvent
		let local_Message = Message
		let role_mgr = RoleManager.GetInstance()
		let data_ = null
		let item_ = null
		let cost_item_:BaseAwardItem = null
		let one_price_ = 0
		let cur_num_ = 0
		let all_price_ = null
		let is_buying_ = false

		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.SetData()
		}

		this.close_callback = () => {
			if (item_) {
				item_.DeleteMe()
				item_ = null
			}
			if (cost_item_) {
				cost_item_.DeleteMe()
				cost_item_ = null
			}
			// super.DeleteMe()
		}

		this.LoadSuccess = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIcon("shop","uibb_012"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, "resource/game/shop/uibb_012.png")
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("common", "uisy_023"))
			is_buying_ = false
			if (!item_) {
				item_ = new BaseAwardItem(this.goods_icon)
				item_.Load()
				item_.SetItemSize(88, 88)
			}
			if (!cost_item_) {
				cost_item_ = new BaseAwardItem(this.cost_icon)
				cost_item_.Load()
				cost_item_.SetItemSize(35, 35)
				cost_item_.SetItembgVisible(false)
			}
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.cancleBtn, close_fun, this, true)

			let success_fun = (key_id?) => {
				if (data_ && data_.key_id == key_id) {
					// let pos = UILocalToCanvasPoint(this.goods_icon,co.TableXY(0, 1), co.TableXY(0, 1))
					let pos = this.goods_icon.localToGlobal(new Laya.Point(0, 0))
					model.Fire(local_ShopEvent.SHOP_ICON_FLY, data_.goods_id, pos)
				}
				this.Close()
			}
			this.BindEvent(model, local_ShopEvent.BUY_GOODS_SUCCESS, success_fun)


			let failure_fun = (key_id?) => {
				if (data_ && data_.key_id == key_id) {
					is_buying_ = false
				}
			}
			this.BindEvent(model, local_ShopEvent.BUY_GOODS_FAILURE, failure_fun)

			let buy_fun = () => {
				let ok_func = () => {
					if (cur_num_ > 0) {
						if (!is_buying_) {
							is_buying_ = true
							if (data_.scmd) {
								if (data_.scmd == 17601) {
									//ShopPurchaseModel:GetInstance():Fire(ShopPurchaseModel.REQUEST_SCMD, data_.scmd, data_.key_id, cur_num_)
								} else if (data_.scmd == 15302) {
									if (data_["quick_use"]) {
										//挂机卡快速购买并使用

										let ok_func = () => {
											if (OnHookModel.GetInstance().call_back_obj) return//上一个步骤还没完成
											if (!OnHookModel.GetInstance().call_back_obj) {
												OnHookModel.GetInstance().call_back_obj = {}
											}
											OnHookModel.GetInstance().call_back_obj["cur_num"] = cur_num_
											OnHookModel.GetInstance().call_back_obj["type_id"] = data_.goods_id
											model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", data_.key_id, cur_num_)
										}



										let time =  OnHookModel.GetInstance().GetOnhookTime()
										let add_time = OnHookModel.GetInstance().add_time[data_.goods_id]
										if (time + add_time * cur_num_ > OnHookModel.GetInstance().max_outline_time) {
											let time = Math.floor(OnHookModel.GetInstance().max_outline_time / 3600)
											Alert.Show("使用后离线挂机时间将会溢出（最多" + time + "个小时），是否继续使用？", Alert_Type.Two, ok_func)
										} else {
											ok_func()
										}
									} else {
										model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15302, "ii", data_.key_id, cur_num_)
									}

								}
							}
						}
					} else {
						local_Message.show("请选择数量")
					}
				}

				let check_func = (bool?) => {
					model.jinLock_not_enough_not_alert = bool
				}

				if (data_.money_type == 2 && model.jinLock_not_enough_not_alert == false) { //消耗绑钻
					let [enough, gap] = model.MoneyIsEnough(data_.money_type, all_price_)
					if (!enough) {
						let content = Util.StrToHTML("<font color='#663915'>当前绑玉数量不足，是否消耗勾玉代替？</font>")
						Alert.Show(content, Alert_Type.Two, ok_func, null, "确定", "取消", null, false, check_func, "本次登录不再提示")
						Alert.SetIsCharge(true)
					} else {
						ok_func()
					}
				} else if (data_.money_type == 1) {
					if (role_mgr.mainRoleInfo.jin < one_price_ * cur_num_) {
						NotEnougnDiamond()
						return
					} else {
						ok_func()
					}
				} else {
					let need = one_price_ * cur_num_
					let [enough, gap, my_have, alert_str] = model.MoneyIsEnough(data_.money_type, need)
					if (!enough) {
						local_Message.show(alert_str)
						return
					} else {
						ok_func()
					}
				}
			}
			Util.AddClickEvent(this.confirmBtn, buy_fun, this, true)

			Util.AddClickEvent(this.cur_show_num, () => {
				this.calculator_fun()
			}, this, true)

			Util.AddClickEvent(this.minus_one, () => {
				if (cur_num_ == 1) {
					let new_num1 = 1
					local_Message.show("已经是最小购买数量了")
					this.SetCurNum(new_num1)
					this.SetAllPrice(new_num1)
				} else {
					this.NumChange(true, 1)
				}
			}, this, true)

			Util.AddClickEvent(this.minus_ten, () => {
				this.NumChange(true, 10)
			}, this, true)

			Util.AddClickEvent(this.add_one, () => {
				this.NumChange(false, 1)
			}, this, true)

			Util.AddClickEvent(this.add_ten, () => {

				//刚好加到货币能购买的数量
				let can_buy_num = 0
				for (let i = 1; i <= 10; i++) {
					let need = one_price_ * (cur_num_ + i)
					let [enough, gap] = model.MoneyIsEnough(data_.money_type, need)
					if (enough) {
						can_buy_num++
					}
				}

				if (can_buy_num != 0) {
					this.NumChange(false, can_buy_num)
				} else {
					local_Message.show("已是最大可购买数量了")
				}

			}, this, true)

			let update_jin = () => {
				if (data_ && data_.money_type == 1) {
					this.SetAllPrice(cur_num_)
				}
			}
			this.BindVar(role_mgr.GetMainRoleVo(), "jin", update_jin)

			let update_jinLock = () => {
				if (data_ && data_.money_type == 2) {
					this.SetAllPrice(cur_num_)
				}
			}
			this.BindVar(role_mgr.GetMainRoleVo(), "jinLock", update_jinLock)
		}

		this.Local_Open = (parms?) => {
			data_ = parms[0]
			super.Open()
		}

		this.SetData = () => {
			if (!data_) {
				return
			}
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data_.goods_id)
			if (basic) {
				item_.SetData(data_.goods_id, data_.num)
				let color_str = ColorUtil.GetColorLight(basic.color)
				color_str=color_str.replace(SpecialCharKey.ShopBulkPurchaseView1,"");
				color_str=color_str.replace(SpecialCharKey.ShopBulkPurchaseView1,"");
				// this.goodsname.text = name
				this.goodsname.color = color_str
				this.goodsname.text = Trim(basic.goods_name)
			}

			//限购
			if (!data_["quick_use"]) {
				this.lb_limit.visible = data_.quota_num > 0
			} else {
				this.lb_limit.visible = false
			}

			let now_num = (data_.cur_num != null && data_.cur_num != 0) && data_.cur_num || 1
			if (data_.quota_num > 0) {
				let str = data_.quota_type == 3 && "终生限购：" || "每日存货："
				let left_num = data_.quota_num - data_.sold_out
				str = str + left_num + "/" + data_.quota_num
				now_num = data_.quota_num >= 10 && 1 || left_num

				if (left_num <= 0) {
					now_num = 1
					str = "<font color='#ff4f50'>" + left_num + "</font>/" + data_.quota_num
				}
				// this.lb_limit.text = str
				this.lb_limit.style.fontSize = 20
				this.lb_limit.style.color = "#93847d"
				this.lb_limit.innerHTML = Util.StrToHTML(str)
				this.lb_limit.style.width = 500
				this.lb_limit.x = 455 / 2 - this.lb_limit.contextWidth / 2
			}
			this.SetCurNum(now_num)
			let money_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[data_.money_type]
			let cost_type_id = money_cfg && money_cfg.goods_id || 0
			cost_item_.SetData(cost_type_id,null,null,null,null,true)

			one_price_ = this.GetOnePrice()
			this.SetAllPrice(now_num)

			this._Label7.text = data_["quick_use"] ? "购买并使用" : "购买"
		}

		//设置当前数量
		this.SetCurNum = (num?) => {
			cur_num_ = num
			this.cur_show_num.text = String(num)
			// this.cur_show_num.textFlow = Util.StrToHTML(String(num))
		}

		//获取单价
		this.GetOnePrice = () => {
			let price = 0
			if (data_) {
				if (data_.discount == 0 || data_.discount < 100) {	//有打折
					price = Mathf.Round(data_.price * data_.discount / 100)
				} else {
					price = data_.price
				}
			}
			return price
		}

		//设置总价
		this.SetAllPrice = (buy_num?) => {
			if (data_ && one_price_ > 0) {
				let need = one_price_ * buy_num
				all_price_ = need
				let [enough, gap] = model.MoneyIsEnough(data_.money_type, need)
				let color_str = enough && "#4a3a32" || "#ff4f50"
				this.lb_price.text = String(need)
				this.lb_price.color = color_str
			}
		}

		//数量改变
		this.NumChange = (is_minus?, num?) => {
			if (data_) {
				let new_num = is_minus && cur_num_ - num || cur_num_ + num
				if (new_num <= 0) {
					new_num = 1
					local_Message.show("已经是最小购买数量了")
					this.SetCurNum(new_num)
					this.SetAllPrice(new_num)
					return
				}
				if (data_.quota_num > 0) {
					let left_num = data_.quota_num - data_.sold_out
						if (left_num < new_num) {
							if (data_["quick_use"]) {
								new_num = data_.quota_num
							} else {
								new_num = left_num
							}
							local_Message.show("超过最大购买数量了")
						}
				}
				if (new_num >= 999999) {
					local_Message.show("超过最大购买数量了")
					return
				}
				this.SetCurNum(new_num)
				this.SetAllPrice(new_num)
			}
		}

		this.NumChangeByCalculator = (num?) => {
			this.SetCurNum(num)
			this.SetAllPrice(num)
		}

		this.calculator_fun = () => {
			if (data_) {
				let max_num = 999999
				if (data_.quota_num > 0) {
					if (data_["quick_use"]) {
						max_num = data_.quota_num
					} else {
						max_num = data_.quota_num - data_.sold_out
					}
					
				}
				let num_change_fun = (value?) => {
					if (!this.use_delete_method) {
						this.NumChangeByCalculator(value)
					}
				}
				let pos = [0, 30]
				GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, pos)
			}
		}


	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}



_Image1:Laya.Image
_Group1:Laya.Box
_Image2:Laya.Image
_Label1:Laya.Label
goodsname:Laya.Label
goods_icon:Laya.Box
_Image7:Laya.Image
minus_ten:Laya.Box
_Image8:Laya.Image
_Label2:Laya.Label
minus_one:Laya.Box
_Image9:Laya.Image
_Label3:Laya.Label
show_conta:Laya.Box
_Image10:Laya.Image
cur_show_num:Laya.Label
add_one:Laya.Box
_Image11:Laya.Image
_Label4:Laya.Label
add_ten:Laya.Box
_Image12:Laya.Image
_Label5:Laya.Label
lb_limit:Laya.HTMLDivElement
_Group4:Laya.Box
_Group3:Laya.HBox
_Label8:Laya.Label
cost_icon:Laya.HBox
lb_price:Laya.Label
closeBtn:Laya.Image
_Group2:Laya.Box
cancleBtn:Laya.Box
_Image13:Laya.Image
_Label6:Laya.Label
confirmBtn:Laya.Box
_Image14:Laya.Image
_Label7:Laya.Label


	
public GetComponents() {
[
this._Image1,
this._Group1,
this._Image2,
this._Label1,
this.goodsname,
this.goods_icon,
this._Image7,
this.minus_ten,
this._Image8,
this._Label2,
this.minus_one,
this._Image9,
this._Label3,
this.show_conta,
this._Image10,
this.cur_show_num,
this.add_one,
this._Image11,
this._Label4,
this.add_ten,
this._Image12,
this._Label5,
this.lb_limit,
this._Group4,
this._Group3,
this._Label8,
this.cost_icon,
this.lb_price,
this.closeBtn,
this._Group2,
this.cancleBtn,
this._Image13,
this._Label6,
this.confirmBtn,
this._Image14,
this._Label7,
]
 = this.GetChildrenByNames([

"_Image1",
"_Group1",
"_Image2",
"_Label1",
"goodsname",
"goods_icon",
"_Image7",
"minus_ten",
"_Image8",
"_Label2",
"minus_one",
"_Image9",
"_Label3",
"show_conta",
"_Image10",
"cur_show_num",
"add_one",
"_Image11",
"_Label4",
"add_ten",
"_Image12",
"_Label5",
"lb_limit",
"_Group4",
"_Group3",
"_Label8",
"cost_icon",
"lb_price",
"closeBtn",
"_Group2",
"cancleBtn",
"_Image13",
"_Label6",
"confirmBtn",
"_Image14",
"_Label7",
])
}
}
 window["ShopBulkPurchaseView"]= ShopBulkPurchaseView