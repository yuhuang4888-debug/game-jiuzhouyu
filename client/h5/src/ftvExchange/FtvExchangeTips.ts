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
import { Message } from "../sysinfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, NotEnougnDiamond, Trim } from "../util/Util"
import { table } from "../common/table"
import { FtvExchangeGoodItem } from "./FtvExchangeGoodItem"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { ErlangParser } from "../util/ErlangParser"

export class FtvExchangeTips extends BaseView1 {
	Empadd_one
	Empadd_ten
	EmpcancleBtn
	EmpconfirmBtn
	Empminus_one
	Empminus_ten
	GetOnePrice
	InitEvent
	LoadSuccess
	Local_Open
	NumChange
	NumChangeByCalculator
	SetAllPrice
	SetCurNum
	SetData
	add_one
	add_ten
	calculator_fun
	cancleBtn
	click_bg_toClose
	closeBtn
	confirmBtn
	cost_icon
	cur_show_num
	close_callback
	destroy_imm
	goods_icon
	goodsname
	horizontalCenter
	lb_limit
	lb_price
	minus_one
	minus_ten
	open_callback
	show_open_movie
	title_bg
	use_background
	verticalCenter
	_Image1
	reward_item
	_Group1: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Label2: Laya.Label
	_Image9: Laya.Image
	_Label3: Laya.Label
	show_conta: Laya.Box
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Label4: Laya.Label
	_Image12: Laya.Image
	_Label5: Laya.Label
	_Group2: Laya.HBox
	_Image13: Laya.Image
	_Label6: Laya.Label
	_Image14: Laya.Image
	_Label7: Laya.Label
	_Group4: Laya.HBox
	_Group3: Laya.HBox
	_Label8: Laya.Label
    goods_item
    cost
	public constructor() {
		super()


		this.base_file = "ftvExchange"
		this.layout_file = "FtvExchangeTips"
		this.layer_value = Enum_UILayer.Activity

		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.horizontalCenter = 0
		this.verticalCenter = 0

		let model = ShopModel.GetInstance()
		let local_ShopEvent = ShopEvent
		let local_Message = Message
		let role_mgr = RoleManager.GetInstance()
		let data_ = null
		let item_ = null
		let cost_item_ = null
		let one_price_ = 0
		let cur_num_ = 0
		let all_price_ = null
		let is_buying_ = false
		this.goods_item = []
        this.cost = null
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.SetData()
		}

		this.close_callback = () => {
			if (this.reward_item) {
				this.reward_item.DeleteMe()
				this.reward_item = null
			}
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
			// if (!item_) {
			// 	item_ = new BaseAwardItem(this.goods_icon)
			// 	item_.Load()
			// 	item_.SetItemSize(88, 88)
			// }
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

			let buy_fun = () => {
					if (cur_num_ > 0) {
						let need = one_price_ * cur_num_
						all_price_ = need
                        let enough = GoodsModel.GetInstance().GetTypeGoodsNum(this.cost[0][1]) -all_price_ >= 0
						let times
						for (let i in data_.condition) {

							if (data_.condition[i][0] == "exchang_times") {
								times = data_.condition[i][1]
								break
							}
						}
						if ((Number(times)-data_.receive_times - cur_num_) >= 0) {
							if(enough ){
								CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33179,data_.base_type ,data_.sub_type, data_.grade, cur_num_)
								this.Close()
							}else{
								Message.show("物品不足，无法兑换")
							}
						}else {
							Message.show("超出最大可兑换数量")
						}
					} else {
						local_Message.show("请选择数量")
					}

			}
			Util.AddClickEvent(this.confirmBtn, buy_fun, this, true)

			Util.AddClickEvent(this.cur_show_num, () => {
				this.calculator_fun()
			}, this, true)

			Util.AddClickEvent(this.minus_one, () => {
				if (cur_num_ == 1) {
					let new_num1 = 1
					local_Message.show("已经是最小兑换数量了")
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
				this.NumChange(false, 10)
			}, this, true)
		}

		this.Local_Open = (parms?) => {
			data_ = parms[0]
			super.Open()
		}

		this.SetData = () => {
			if (!data_) {
				return
			}
            for (let i in data_.condition) {

                if (data_.condition[i][0] == "cost") {
                    if (this.goods_item.length > 0) {
                        for (let k in this.goods_item) {
                            var vo = this.goods_item[Number(k)]
                            vo.SetVisible(false)
                        }
                    }
    
                    this.cost = data_.condition[i][1]
                    // for (let j in data_.condition[i][1]) {
    
                    //     let item = this.goods_item[Number(j)]
                    //     if (!item) {
                    //         item = new FtvExchangeGoodItem(this.goods_icon)
                    //         item.Load()
                    //         table.insert(this.goods_item, item)
                    //     }
                    //     item.ExcuteCallback(() => {
                    //         item.SetData(data_.condition[i][1][j], true)
                    //         item.SetVisible(true)
                    //     }
                    //     )
                    // }
                }
            }
			let reward = ErlangParser.GetInstance().Parse(data_.reward)
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this.goodsname.text = (basic && (basic.goods_name) || (""))
			if (!this.reward_item) {
				this.reward_item = new EquipmentItem(this.goods_icon)
				this.reward_item.Load()
				this.reward_item.SetItemSize(85, 85)
			}
			this.reward_item.ExcuteCallback(() => {
				this.reward_item.SetData(type_id, reward[0][2])
			}
			)

			// if (basic) {
			// 	item_.SetData(data_.goods_id, data_.num)
			// 	let color_str = ColorUtil.GetColorLight(basic.color)
			// 	color_str=color_str.replace("'","");
			// 	color_str=color_str.replace("'","");
			// 	this.goodsname.color=color_str
			// 	this.goodsname.text = Trim(basic.goods_name)
			// }

			let now_num = 1
			this.SetCurNum(now_num)

			let cost_type_id = this.cost[0][1]
			cost_item_.SetData(cost_type_id)
			one_price_ = this.cost [0][2]
			this.SetAllPrice(now_num)
		}

		//设置当前数量
		this.SetCurNum = (num?) => {
			cur_num_ = num
			this.cur_show_num.text = String(num)
		}

		//获取单价
		this.GetOnePrice = () => {
			let price = 0
			if (this.cost) {
				price = this.cost[0][2]
			}
			return price
		}

		//设置总价
		this.SetAllPrice = (buy_num?) => {
			if (data_ && one_price_ > 0) {
				let need = one_price_ * buy_num
				all_price_ = need
				let enough = GoodsModel.GetInstance().GetTypeGoodsNum(this.cost[0][1]) -all_price_ >= 0
				let color_str = enough && "#4a3a32" || "#ff4f50"
				this.lb_price.text = String(need)
				this.lb_price.color=color_str
			}
		}

		//数量改变
		this.NumChange = (is_minus?, num?) => {
			if (data_) {
				let new_num = is_minus && cur_num_ - num || cur_num_ + num
				if (new_num <= 0) {
					new_num = 1
					local_Message.show("已经是最小兑换数量了")
					this.SetCurNum(new_num)
					this.SetAllPrice(new_num)
					return
				}
				if (new_num >= 999999) {
					local_Message.show("超过最大兑换数量了")
					return
				}
				let times
				for (let i in data_.condition) {
					if (data_.condition[i][0] == "exchang_times") {
						times = data_.condition[i][1]
						break
					}
				}
	
				if ((Number(times) - data_.receive_times - new_num) >= 0) {
					new_num = new_num
				} else {
					local_Message.show("超过最大兑换数量")
					new_num = Number(times) - data_.receive_times
				}
				let need = one_price_ * new_num
				let enough = GoodsModel.GetInstance().GetTypeGoodsNum(this.cost[0][1]) - need >= 0
				if(!enough){
					local_Message.show("超过最大兑换数量")
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
				let num_change_fun = (value?) => {
					if (!this.use_delete_method) {
						this.NumChangeByCalculator(value)
					}
				}
				let pos=[0,30]
				GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, max_num, num_change_fun, pos)
			}
		}


	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}


	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this._Image2,
			this._Label1,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
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
			this._Group2,
			this.cancleBtn,
			this._Image13,
			this._Label6,
			this.confirmBtn,
			this._Image14,
			this._Label7,
			this.goods_icon,
			this.title_bg,
			this.goodsname,
			this.lb_limit,
			this.closeBtn,
			this._Group4,
			this._Group3,
			this._Label8,
			this.cost_icon,
			this.lb_price,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"_Image2",
				"_Label1",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
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
				"_Group2",
				"cancleBtn",
				"_Image13",
				"_Label6",
				"confirmBtn",
				"_Image14",
				"_Label7",
				"goods_icon",
				"title_bg",
				"goodsname",
				"lb_limit",
				"closeBtn",
				"_Group4",
				"_Group3",
				"_Label8",
				"cost_icon",
				"lb_price",
			])
		this.lb_limit.visible = false
	}
}

window["FtvExchangeTips"]=FtvExchangeTips