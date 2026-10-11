import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseView1 } from "../common/BaseView1";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { ShopModel } from "../commonModel/ShopModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class FtvBulkPurchaseView extends BaseView1 {
	public _Image1: Laya.Image;
	public _Group1: Laya.Box;
	public _Image2: Laya.Image;
	public _lb_title: Laya.Label;
	public _Image3: Laya.Image;
	public _Image4: Laya.Image;
	public _Image5: Laya.Image;
	public _Image6: Laya.Image;
	public _Image7: Laya.Image;
	public minus_ten: Laya.Box;
	public _Image8: Laya.Image;
	public _Label1: Laya.Label;
	public minus_one: Laya.Box;
	public _Image9: Laya.Image;
	public _Label2: Laya.Label;
	public show_conta: Laya.Box;
	public _Image10: Laya.Image;
	public cur_show_num: Laya.Label;
	public add_one: Laya.Box;
	public _Image11: Laya.Image;
	public _Label3: Laya.Label;
	public add_ten: Laya.Box;
	public _Image12: Laya.Image;
	public _Label4: Laya.Label;
	public _Group2: Laya.Box;
	public cancleBtn: Laya.Box;
	public _Image13: Laya.Image;
	public _Label5: Laya.Label;
	public confirmBtn: Laya.Box;
	public _Image14: Laya.Image;
	public _Label6: Laya.Label;
	public goods_icon: Laya.Box;
	public title_bg: Laya.Image;
	public goodsname
	public lb_limit: Laya.Label;
	public closeBtn: Laya.Image;
	public _gp_price: Laya.Box;
	public _Group3: Laya.Box;
	public _Label7: Laya.Label;
	public cost_icon: Laya.Box;
	public lb_price: Laya.Label;

	InitEvent
	LoadSuccess
	Local_Open
	NumChange
	NumChangeByCalculator
	SetCurNum
	SetData
	calculator_fun

	public constructor() {
		super()

		this.base_file = "ftvCollectionExchange"
		this.layout_file = "FtvBulkPurchaseView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = false
		this.show_open_movie = true
		// this.horizontalCenter = 0
		// this.verticalCenter = 0
		let model = ShopModel.GetInstance()
		let local_Message = Message
		let data_ = null
		let item_ = null
		let cost_item_ = null
		let one_price_ = 0
		let cur_num_ = 0
		let all_price_ = null
		let is_buying_ = false
		let is_max_ = false

		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.SetData()
		}

		this.destroy_callback = () => {
			if (item_) {
				item_.DeleteMe()
				item_ = null
			}
			if (cost_item_) {
				cost_item_.DeleteMe()
				cost_item_ = null
			}
			one_price_ = 0
			cur_num_ = 0
			all_price_
			is_buying_ = false
			is_max_ = false
		}

		this.LoadSuccess = () => {

			ResManager.GetInstance().SetImageSprite(this, this.title_bg, "shop", "uibb_012")
			is_buying_ = false
			if (!item_) {
				item_ = new BaseAwardItem(this.goods_icon)
				item_.Load()
				item_.SetItemSize(87, 87)
			}
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.cancleBtn, close_fun, this, true)

			let buy_fun = () => {
				if (cur_num_ > 0) {
					if (!is_buying_) {
						is_buying_ = true
						let data = data_
						if (data.scmd) {
							if (33179 == data.scmd) {
								let args = data.args
								if (args.length >= 3) {
									CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, data.scmd, args[0], args[1], args[2], cur_num_)
								}
							}
						}
						is_max_ = false
						this.Close()
					}
				} else {
					local_Message.show("请选择数量")
				}
			}
			Util.AddClickEvent(this.confirmBtn, buy_fun, this, true)

			Util.AddClickEvent(this.show_conta, () => {
				this.calculator_fun()
			}, this, true)

			Util.AddClickEvent(this.minus_one, () => {
				this.NumChange(true, 1)
			}, this, true)

			Util.AddClickEvent(this.minus_ten, () => {
				this.NumChange(true, 10)
			}, this, true)

			Util.AddClickEvent(this.add_one, () => {
				this.NumChange(false, 1)
			}, this, true)

			Util.AddClickEvent(this.add_ten, () => {
				this.NumChange(false, 10)
			}, this, true)

		}

		this.Local_Open = (parms?) => {
			[data_] = parms
			super.Open()
		}

		this.SetData = () => {
			if (!data_) {
				return
			}
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data_.goods_id)
			if (basic) {
				item_.SetData(data_.goods_id, data_.num)
				let color_str = ColorUtil.GetColorLight(basic.color,false)
				// let name = "<font color='" + color_str + "'>" + basic.goods_name + "</font>"
				this.goodsname.text = basic.goods_name
				this.goodsname.fontColor=color_str
			}
			let now_num = data_.cur_num
			this.SetCurNum(now_num)
		}

		//设置当前数量
		this.SetCurNum = (num?) => {
			cur_num_ = num
			this.cur_show_num.text = String(num)
		}

		//数量改变
		this.NumChange = (is_minus?, num?) => {
			if (data_) {
				let new_num = (is_minus ? (cur_num_ - num) : (cur_num_ + num))
				if(is_minus){
					is_max_=false
				}
				if (new_num <= 0) {
					new_num = 1
					local_Message.show("已经是最小购买数量了")
					this.SetCurNum(new_num)
					return
				}
				if (data_.max_num > 0) {
					let left_num = data_.max_num
					if (left_num < new_num && is_max_) {
						local_Message.show("超过最大购买数量了")
						return
					} else if (left_num < new_num && !is_max_) {
						is_max_ = true
						new_num = left_num
					}
				}
				if (new_num >= 999999) {
					local_Message.show("超过最大购买数量了")
					return
				}
				this.SetCurNum(new_num)
			}
		}

		this.NumChangeByCalculator = (num?) => {
			this.SetCurNum(num)
		}

		this.calculator_fun = () => {
			if (data_) {
				let max_num = 999999
				if (data_.max_num > 0) {
					max_num = data_.max_num
				}
				let num_change_fun = (value?) => {
					this.NumChangeByCalculator(value)
				}

				GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, [0, 0])
			}
		}


	}

	public Open(...parms) {
		this.Local_Open(parms)
	}

	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this._Image2,
			this._lb_title,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this.minus_ten,
			this._Image8,
			this._Label1,
			this.minus_one,
			this._Image9,
			this._Label2,
			this.show_conta,
			this._Image10,
			this.cur_show_num,
			this.add_one,
			this._Image11,
			this._Label3,
			this.add_ten,
			this._Image12,
			this._Label4,
			this._Group2,
			this.cancleBtn,
			this._Image13,
			this._Label5,
			this.confirmBtn,
			this._Image14,
			this._Label6,
			this.goods_icon,
			this.title_bg,
			this.goodsname,
			this.lb_limit,
			this.closeBtn,
			this._gp_price,
			this._Group3,
			this._Label7,
			this.cost_icon,
			this.lb_price,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"_Image2",
				"_lb_title",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"minus_ten",
				"_Image8",
				"_Label1",
				"minus_one",
				"_Image9",
				"_Label2",
				"show_conta",
				"_Image10",
				"cur_show_num",
				"add_one",
				"_Image11",
				"_Label3",
				"add_ten",
				"_Image12",
				"_Label4",
				"_Group2",
				"cancleBtn",
				"_Image13",
				"_Label5",
				"confirmBtn",
				"_Image14",
				"_Label6",
				"goods_icon",
				"title_bg",
				"goodsname",
				"lb_limit",
				"closeBtn",
				"_gp_price",
				"_Group3",
				"_Label7",
				"cost_icon",
				"lb_price",
			])
	}
}

window["FtvBulkPurchaseView"]=FtvBulkPurchaseView