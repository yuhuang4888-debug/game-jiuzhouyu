import { GoodsModel } from "../commonModel/GoodsModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { BaseAwardItem } from "./BaseAwardItem";
import { BaseView1 } from "./BaseView1";
import { EventName } from "./EventName";
import { Enum_UILayer } from "./LayerManager";
import { ResManager } from "./ResManager";
import { UIToolTipMgr } from "./UIToolTipMgr";


export class ExchangeViewOne extends BaseView1 {
	_bg: Laya.Image
	close: Laya.Image
	Image2: Laya.Image
	Image3: Laya.Image
	goods_item: Laya.Box
	goods_name: Laya.HTMLDivElement
	Text1: Laya.Label
	price_icon: Laya.Image
	price_label: Laya.Label
	Image4: Laya.Image
	Text_num: Laya.Label
	reduce_btn: Laya.Image
	num_touch: Laya.Image
	increase_btn: Laya.Image
	max_btn: Laya.Image
	_lb_cur_num: Laya.Label
	Text_price: Laya.Label
	allprice_icon: Laya.Image
	allprice_label: Laya.Label
	_lb_have_num: Laya.Label
	_btn_cancel: Laya.Box
	cancel: Laya.Image
	_lb_cancel: Laya.Label
	_btn_ok: Laya.Box
	ok: Laya.Image
	_lb_ok: Laya.Label

	_cur_num
	price
	have_num
	cost
	goodsmodel
	res_mgr
	item
	exchange_type
	exchange_id
	max_num


	public constructor() {
		super()

		this.base_file = "common"
		this.layout_file = "ExchangeViewOne"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.goodsmodel = GoodsModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.preload_server_config = {
			"config_goods_exchange_rule": false
		}
		this.load_callback = () => {
			// this.res_mgr.SetTexture(this, this._bg, GameResPath.GetIcon("common2", "uitc_001"))
		}
		this.open_callback = () => {
			this._cur_num = 0
			this.price = 0
			this.have_num = 0
			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.DestoryFunc()
		}
	}

	public InitView() {
		if (!this.exchange_type || !this.exchange_id) { return }
		let ex_info = this.goodsmodel.GetGoodsExchangeData(this.exchange_type)
		if (ex_info) {
			for (let k in ex_info) {
				let v = ex_info[k]
				if (v.id == this.exchange_id) {
					let exchange_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_goods_exchange_rule", false)
					let cfg = exchange_cfgs[this.exchange_id]
					if (cfg) {
						let cost = JSON.parse(cfg.cost_list)
						if (cost && !Util.IsTableEmpty(cost)) {
							this.cost = cost
							//货币信息
							let [type, lock] = this.goodsmodel.GetMappingTypeId(cost[0][0], cost[0][1])
							let basic = this.goodsmodel.GetGoodsBasicByTypeId(type)
							if (basic) {
								this.res_mgr.SetTexture(this, this.price_icon, GameResPath.GetGoodsIconPath(basic.goods_icon))
								this.res_mgr.SetTexture(this, this.allprice_icon, GameResPath.GetGoodsIconPath(basic.goods_icon))
								this.price_label.text = cost[0][2]
								this.price = Number(cost[0][2])
							}

							this.RefNum()

						}
						//兑换物品信息
						this.RefGoodsItem(cfg)
					}
					return
				}
			}
		}
	}

	//拥有数量、可兑换最大数量
	public RefNum() {
		if (this.cost && !Util.IsTableEmpty(this.cost)) {
			let cost = this.cost
			let [type, lock] = this.goodsmodel.GetMappingTypeId(cost[0][0], cost[0][1])
			let num = this.goodsmodel.GetTypeGoodsNum(type)
			if (num >= Number(cost[0][2])) { // 此处默认限制类型为0
				this.max_num = Math.floor(num / Number(cost[0][2]))
			}
			//拥有数量
			this._lb_have_num.text = "拥有：" + num
			this.have_num = num

		}
	}

	public RefGoodsItem(cfg?, cost?) {
		if (cfg) {
			let goods = JSON.parse(cfg.obtain_list)
			if (goods && !Util.IsTableEmpty(goods)) {
				let [type, lock] = this.goodsmodel.GetMappingTypeId(goods[0][0], goods[0][1])
				let basic = this.goodsmodel.GetGoodsBasicByTypeId(type)
				if (basic) {
					if (!this.item) {
						this.item = new BaseAwardItem(this.goods_item)
						this.item.Load()
						this.item.SetItemSize(87, 87)
					}
					this.item.ExcuteCallback(() => {
						this.item.SetData(type)
					})
					this.goods_name.innerHTML = Util.StrToHTML("<font color=" + ColorUtil.GetColorDark(basic.color) + ">" + basic.goods_name + "</font>"
					)
				}
			}
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.allprice_icon, () => {
			if (this.cost && !Util.IsTableEmpty(this.cost)) {
				let [type, lock] = this.goodsmodel.GetMappingTypeId(this.cost[0][0], this.cost[0][1])
				UIToolTipMgr.GetInstance().DefaultAppendTips(type, 1)
			}
		}, this, true)

		Util.AddClickEvent(this.reduce_btn, () => {
			this.NumChange(this._cur_num - 1)
		}, this, true)

		Util.AddClickEvent(this.increase_btn, () => {
			this.NumChange(this._cur_num + 1)
		}, this, true)

		Util.AddClickEvent(this.max_btn, () => {
			let max = Math.floor(this.have_num / this.price)
			if (!max || max == 0) {
				max = 1
			}
			this.NumChange(max)
		}, this, true)

		Util.AddClickEvent(this.close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this.num_touch, () => {
			this.calculator_fun()
		}, this, false)

		Util.AddClickEvent(this._btn_cancel, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._btn_ok, () => {
			if (this.exchange_id && this._cur_num > 0) {
				this.goodsmodel.Fire(GoodsModel.EXCHANGE_GOODS, this.exchange_id, this._cur_num)
			} else if (this._cur_num == 0) {
				Message.show("请选择数量")
			}
		}, this, true)

		let change_bag = (list?) => {
			if (list && this.cost && !Util.IsTableEmpty(this.cost)) {
				for (let k in list) {
					let v = list[k]
					let basic = this.goodsmodel.GetGoodsBasicByTypeId(v.type_id)
					if (basic && basic.type == 22) {
						this.RefNum()
						return
					}
				}
			}
		}
		this.BindEvent(this.goodsmodel, GoodsModel.CHANGE_BAG_LIST, change_bag)

		let success_func = (id?) => {
			if (id == this.exchange_id) {
				this.Close()
			}
		}
		this.BindEvent(this.goodsmodel, GoodsModel.BUY_SUCCESS, success_func)

	}

	//数量改变
	public NumChange(new_num?) {
		if (this.is_loaded) {
			if (new_num <= 0) {
				new_num = 0
				Message.show("已经是最小购买数量了")
				this.SetCurNum(new_num)
				this.SetAllPrice(new_num)
				return
			}
			let enough = (this.have_num / this.price) >= new_num
			if (!enough) {
				Message.show("超过最大购买数量了")
				return
			}
			this.SetCurNum(new_num)
			this.SetAllPrice(new_num)
		}
	}

	//设置总价
	public SetAllPrice(buy_num?) {
		this.allprice_label.text = String(buy_num * this.price)
	}

	//设置当前数量
	public SetCurNum(num?) {
		if (!this.is_loaded) {
			return
		}
		this._cur_num = num
		this._lb_cur_num.text = num
	}

	public calculator_fun() {
		if (this.max_num && this.max_num > 0) {
			let num_change_fun = (value?) => {
				this.NumChange(value)
			}
			GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, this.max_num, num_change_fun, [0, 0])
		}
	}

	public Open(...parms) {
		this.exchange_type = parms[0]
		this.exchange_id = parms[1]
		super.Open()
	}


	public DestoryFunc() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
	}

	public GetComponents() {
		[
			this._bg,
			this.close,
			this.Image2,
			this.Image3,
			this.goods_item,
			this.goods_name,
			this.Text1,
			this.price_icon,
			this.price_label,
			this.Image4,
			this.Text_num,
			this.reduce_btn,
			this.num_touch,
			this.increase_btn,
			this.max_btn,
			this._lb_cur_num,
			this.Text_price,
			this.allprice_icon,
			this.allprice_label,
			this._lb_have_num,
			this._btn_cancel,
			this.cancel,
			this._lb_cancel,
			this._btn_ok,
			this.ok,
			this._lb_ok,
		]
			= this.GetChildrenByNames([

				"_bg",
				"close",
				"Image2",
				"Image3",
				"goods_item",
				"goods_name",
				"Text1",
				"price_icon",
				"price_label",
				"Image4",
				"Text_num",
				"reduce_btn",
				"num_touch",
				"increase_btn",
				"max_btn",
				"_lb_cur_num",
				"Text_price",
				"allprice_icon",
				"allprice_label",
				"_lb_have_num",
				"_btn_cancel",
				"cancel",
				"_lb_cancel",
				"_btn_ok",
				"ok",
				"_lb_ok",
			])
		this.goods_name.style.fontSize=22
		this.goods_name.style.wordWrap=false	
	}
}
window["ExchangeViewOne"] = ExchangeViewOne