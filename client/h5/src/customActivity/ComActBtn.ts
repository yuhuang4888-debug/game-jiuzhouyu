import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine, Enum_Btn_Type, Enum_Currency_Type } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { NotEnougnDiamond, HtmlColorTxt, Util, SetLocalPositionY, GetSizeDeltaY, SetSizeDeltaY, SetSizeDeltaX, SetLocalPositionX, GlobalTimerQuest, RefBoxChildsLayout } from "../util/Util"

export class ComActBtn extends BaseItem1 {

	SetRedPos
	SetFreeBtn
	InitEvent
	SetData
	Local_DeleteMe
	SetRed
	RefHaveNum
	RefRedPos
	InitView

	public constructor(parent?) {
		super(parent)

		this.base_file = "customActivity"
		this.layout_file = "ComActBtn"
		this.is_load_res = false

		let local_Enum_Currency_Type = Enum_Currency_Type,
			local_Message = Message,
			goods_model = GoodsModel.GetInstance(),
			// local_egret = egret,
			local_Config = Config,
			local_Util = Util,
			model = CustomActivityModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			local_Enum_Btn_Type = Enum_Btn_Type,
			is_requesting = false,
			timeout_id_list = [],
			_cost,
			_cost2,//代替消耗 [type_id,.....]
			_full_mat_red,
			_is_auto_buy,
			_click_func,
			_btn_type,
			_currency_type,
			_act_data,
			_draw_num,

			_type_id,
			need_num,
			red_right,
			red_top

		//let _loaded_func = null


		this.load_callback = () => {
			
			this.InitEvent()
		}

		this.InitEvent = () => {
			let click = () => {
				if (!_draw_num) {
					return
				}
				if (_click_func) {
					_click_func()
				} else {
					if (_currency_type == local_Enum_Currency_Type.Money) {

					} else if (_currency_type == local_Enum_Currency_Type.Special) {
						if (is_requesting) {
							local_Message.show("操作过快")
							return
						}
						let cost = _cost
						if (!cost) {
							return
						}
						let [type, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
						let count = Number(cost[2])
						let my_have2=0
						if(_cost2){
							for(let i=0;i<_cost2.length;i++){
								my_have2 += goods_model.GetTypeGoodsNum(_cost2[i])
							}
						}
						let have_num = goods_model.GetTypeGoodsNum(type)+my_have2
						let data = _act_data
						let b = data && data.base_type
						let s = data && data.sub_type
						if (b == undefined) {
							b = data.model_id
						}
						let request = (is_auto_buy?) => {
							if (b != undefined) {
								let id = setTimeout(() => {
									is_requesting = false
								}, 1000)
								timeout_id_list.push(id)
								is_requesting = true
								let ACT_ID = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID
								let scmd
								if (b == ACT_ID.LUC_TREA) {
									scmd = 33214
								} else if (b == ACT_ID.MONEYTREE
									|| b == ACT_ID.HOLYCALL) {
									scmd = 33191
								} else if (b == 509) {
									let demon_model = window["DemonModel"].GetInstance()
									let demon_event = window["DemonEvent"]
									demon_model.Fire(demon_event.REQUEST_PROTO, 50902, data.type, _draw_num)
									return
								}
								if (scmd) {
									model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, scmd, b, s, _draw_num, is_auto_buy)
								}
							}
						}

						if (_is_auto_buy && have_num < count) {
							let is_check = false
							let price_info = Config.PRELOAD_SERVER_CONFIG.config_goods_price[Number(type)]
							if (!price_info) {
								return
							}
							let price = price_info.price
							let all_cost = (count - have_num) * price
							let act_key_dic = model.act_key_dic
							let cur_key_dic = act_key_dic[b] && act_key_dic[b][s] || {}
							let openAlert = false
							let cost_func = () => {
								let have_jin = RoleManager.GetInstance().mainRoleInfo.jin
								if (all_cost > have_jin) {
									let need = all_cost - have_jin
									let str = "勾玉不足，还需<font color='#0a953e'>"+ need + "</font>勾玉，是否前往充值?"
									NotEnougnDiamond(str)
								} else {
									request(1)
								}
							}

							let is_openAlert = model.getKeyDicValue(b, s, "openAlert")
							if (!is_openAlert) {
								let ok_callback = () => {
									if (is_check) {
										model.setKeyDicValue(b, s, "openAlert", true)
									}
									cost_func()
								}

								let check_callback = () => {
									is_check = is_check ? false : true
								}

								let basic = goods_model.GetGoodsBasicByTypeId(type)
								if (!basic) {
									return
								}
								let str = `${local_Util.HtmlColorTxt(basic.goods_name, "'#639c12'")}数量不足${local_Util.HtmlColorTxt(count + '个', "'#639c12'")}<br/>是否消耗${local_Util.HtmlColorTxt(all_cost + '勾玉', "'#639c12'")}自动购买`
								Alert.Show(Util.StrToHTML(str), Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, check_callback)
							} else {
								cost_func()
							}
						} else if (have_num >= count) {
							request(0)
						} else {
							local_Message.show("物品不足")
							if (b == 509) {
								MaterialsTool.GetInstance().materialsTips(type)
							}
						}
					}
				}
			}
			Util.AddClickEvent(this._btn_0, click, this, true)
			Util.AddClickEvent(this._btn_1, click, this, true)

			let RefGoodsNum = (list?) => {
				if (this.use_delete_method) {
					return
				}
				let type = _type_id
				for (let v of list) {
					if (v.type_id == type||(_cost2&&_cost2.indexOf(v.type_id)!=-1)) {
						this.RefHaveNum(type)
						return
					}
				}
			}
			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, RefGoodsNum)

			Util.AddClickEvent(this._img_cost_0, () => {
				UIToolTipMgr.GetInstance().DefaultAppendTips(_type_id, 1)
			}, this, false)
		}

		this.InitView = (cost?, btn_dic?, bg_source?, bg_url?, btn_type?) => {
			if (cost) {
				let [type_id, lock] = goods_model.GetMappingTypeId(cost[0], cost[1])
				let basic = goods_model.GetGoodsBasicByTypeId(type_id)
				if (basic) {
					res_mgr.SetTexture(this, this[`_img_cost_${btn_type}`], GameResPath.GetGoodsIconPath(basic.goods_icon))
					_type_id = type_id
					need_num = cost[2]
					this.RefHaveNum(type_id)
				}
			}

			let _bg = this[`_bg_${btn_type}`]
			if (bg_source)
				_bg.skin = bg_source
			else if (bg_url)
				res_mgr.SetTexture(this, _bg, bg_url)

			let v = btn_dic
			if (v) {
				let _name = this[`_name_${btn_type}`]
				if (v.text != undefined) {
					_name.text = v.text
				}
				if (v.t_size) {
					_name.size = v.t_size
				}
				if (v.strokeColor) {
					_name.stroke = 2
					_name.strokeColor = v.strokeColor
					if (btn_type == local_Enum_Btn_Type.TWO) {
						this[`_lb_have_${_btn_type}`].stroke = 2
						this[`_lb_have_${_btn_type}`].strokeColor = v.strokeColor
						this[`_lb_cost_${_btn_type}`].stroke = 2
						this[`_lb_cost_${_btn_type}`].strokeColor = v.strokeColor
					} else {
						this[`_lb_have_${_btn_type}`].stroke = 0
						this[`_lb_cost_${_btn_type}`].stroke = 0
					}
				}
				if (v.x)
					_bg.width = v.x
				if (v.y)
					_bg.width = v.y
			}

			if (btn_type == local_Enum_Btn_Type.ONE) {
				this._gp_cost_0.y = 68//this._btn_0.height
				this._one.visible = this._one.mouseEnabled = true
				this._two.mouseEnabled = false
			} else if (btn_type == local_Enum_Btn_Type.TWO) {
				this._two.visible = this._two.mouseEnabled = true
				this._one.mouseEnabled = false
			}

			this.RefRedPos(red_right, red_top)
		}

		this.RefHaveNum = (type?) => {
			//代替消耗 比如正常的夺宝币需要20个，可以用N个限时夺宝币+20-N个普通夺宝币代替
			let my_have2=0
			if(_cost2){
				for(let i=0;i<_cost2.length;i++){
					my_have2 += goods_model.GetTypeGoodsNum(_cost2[i])
				}
			}
			let num = goods_model.GetTypeGoodsNum(type)+my_have2
			this[`_lb_have_${_btn_type}`].text = `${num}`
			this[`_lb_cost_${_btn_type}`].text = `/${need_num}`
			let bool = _full_mat_red && num >= need_num
			this.SetRed(bool)
		}

		this.SetRed = (bool?) => {
			this[`_red_${_btn_type}`].visible = bool
		}

		this.SetRedPos = (x?, y?) => {
			if (this.is_loaded) {
				this.RefRedPos(x, y)
			} else {
				red_right = x
				red_top = y
			}
		}

		this.RefRedPos = (x?, y?) => {
			if (x != undefined)
				this[`_red_${_btn_type}`].right = x
			if (y != undefined)
				this[`_red_${_btn_type}`].top = y
		}

		///**
		//* btn_dic 按键样式 x.width,y.heigh,text,t_size,strokeColor
		//* draw_num 抽奖次数
		//* full_mat_red 材料满足自动显示红点
		//* is_auto_buy 是否允许自动购买
		//* bg_source 背景图集路径
		//* bg_url 背景散图片路径
		//* btn_type 按键类型，表现形式不一眼
		//* currency_type 货币类型,钻石、特殊货币
		//*/
		this.SetData = (act_data, cost, btn_dic, draw_num, bg_source?, bg_url?, full_mat_red = true, is_auto_buy = true,
			 click_func?, btn_type = local_Enum_Btn_Type.ONE, currency_type = local_Enum_Currency_Type.Special,loaded_func?,cost2?) => {
			_act_data = act_data
			_cost = cost
			_cost2 = cost2
			_draw_num = draw_num
			_full_mat_red = full_mat_red
			_is_auto_buy = is_auto_buy
			_click_func = click_func
			_currency_type = currency_type
			_btn_type = btn_type
			this.InitView(cost, btn_dic, bg_source, bg_url, btn_type)
		}

		this.SetFreeBtn = (bool, text?) => {
			let type = _btn_type
			this[`_name_${type}`].visible = this[`_gp_cost_${type}`].visible = !bool
			this[`_free_${type}`].visible = this[`_red_${type}`].visible = bool
			if (bool && text)
				this[`_free_${type}`].text = text
		}

		this.Local_DeleteMe = () => {
			if (timeout_id_list.length > 0) {
				for (let id of timeout_id_list)
					clearTimeout(id)
				timeout_id_list.length = 0
			}
			super.DeleteMe()
		}

	}

	
	public DeleteMe() {
		this.Local_DeleteMe()
        super.DeleteMe()
	}




_one:Laya.Box
_btn_0:Laya.Box
_bg_0:Laya.Image
_name_0:Laya.Label
_red_0:Laya.Image
_free_0:Laya.Label
_gp_cost_0:Laya.HBox
_lb_have_0:Laya.Label
_lb_cost_0:Laya.Label
_img_cost_0:Laya.Image
_two:Laya.Box
_btn_1:Laya.Box
_bg_1:Laya.Image
_name_1:Laya.Label
_gp_cost_1:Laya.HBox
_lb_have_1:Laya.Label
_lb_cost_1:Laya.Label
_img_cost_1:Laya.Image
_red_1:Laya.Image
_free_1:Laya.Label
public GetComponents() {
[
this._one,
this._btn_0,
this._bg_0,
this._name_0,
this._red_0,
this._free_0,
this._gp_cost_0,
this._lb_have_0,
this._lb_cost_0,
this._img_cost_0,
this._two,
this._btn_1,
this._bg_1,
this._name_1,
this._gp_cost_1,
this._lb_have_1,
this._lb_cost_1,
this._img_cost_1,
this._red_1,
this._free_1,
]
 = this.GetChildrenByNames([

"_one",
"_btn_0",
"_bg_0",
"_name_0",
"_red_0",
"_free_0",
"_gp_cost_0",
"_lb_have_0",
"_lb_cost_0",
"_img_cost_0",
"_two",
"_btn_1",
"_bg_1",
"_name_1",
"_gp_cost_1",
"_lb_have_1",
"_lb_cost_1",
"_img_cost_1",
"_red_1",
"_free_1",
])
}
}
 window["ComActBtn"]= ComActBtn