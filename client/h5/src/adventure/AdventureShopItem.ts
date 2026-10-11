import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { AdventureModel } from "../commonModel/AdventureModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util, NotEnougnDiamond, Trim } from "../util/Util"

export class AdventureShopItem extends BaseItem1 {
	_Image1: Laya.Image
	_lb_limit: Laya.Label
	_gp_item: Laya.Box
	_gp_effect: Laya.Box
	_img_discount: Laya.Image
	_gp_effect1: Laya.Box
	_lb_name: Laya.Label
	_Group2: Laya.HBox
	_Label1: Laya.Label
	_img_jin: Laya.Image
	_Group1: Laya.Box
	_lb_price: Laya.Label
	_Image2: Laya.Image
	_gp_btn: Laya.Box
	_Image3: Laya.Image
	_gp_buy_eff: Laya.Box
	_gp_buy: Laya.Box
	_Label2: Laya.Label
	_img_btn_jin: Laya.Image
	_lb_btn_price: Laya.Label
	_lb_over: Laya.Label
	_img_red: Laya.Image
	_img_over: Laya.Image
	point_gp: Laya.Box
	big_num: Laya.Image
	small_num: Laya.Image

	custom_sorting_order
	data
	item
	model
	price
	reward_lsit

	public constructor(parent?) {
		super(parent)


		this.model = AdventureModel.GetInstance();
		this.base_file = "adventure"
		this.layout_file = "AdventureShopItem"
		this.layer_value = Enum_UILayer.Activity
		this.load_callback = () => {

			this.InitEvent()
		}
	}

	public InitEvent() {

		// this.custom_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		this.BindEvent(this.model, AdventureModel.BUY_SUCCESS, (id?) => {
			if (!this.data) {
				return
			}
			if (this.data.id == id && this.reward_lsit) {
				let view = new CongratulationObtainView(this.reward_lsit, 10)
				view.Open()
				this.data.state = 1
				this.RefStatus(this.data)
			}
		}
		)
		Util.AddClickEvent(this._gp_btn, () => {
			let left_time = this.model.GetZoreStatus()
			if (left_time > 0) {
				Message.show("商店0点刷新中")
				return
			}
			if (this.data && this.data.state == 0) {
				let request_scmd = () => {
					this.model.Fire(AdventureModel.REQUEST_SCMD, 42705, this.data.id)
				}

				let check = false
				let ok_func = () => {
					if (check) {
						this.model.alert_status["alert_shop_buy"] = false
					}
					let jin = RoleManager.GetInstance().mainRoleInfo.jin
					if (jin >= this.price) {
						request_scmd()
					} else {
						NotEnougnDiamond()
					}
				}

				if (this.price > 0 && this.model.alert_status["alert_shop_buy"]) {
					let str = "是否消耗<font color='#639c12'>" + this.price + "勾玉</font>,继续购买"
					let check_func = () => {
						check = !check
					}

					Alert.Show(Util.StrToHTML(str), Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, null, check_func, "本次登录不再提示")
				} else {
					request_scmd()
				}
			} else if (this.data && this.data.state == 1) {
				Message.show("已购买")
			}
		}
			, this, true)
	}

	public InitView() {


		if (!this.data) {
			return
		}
		let data = this.data
		if (!data) {
			return
		}
		this.RefStatus(data)
		this._lb_price.text = " " + data.show_price
		this.ClearUIEffect(this._gp_effect)
		this.ClearUIEffect(this._gp_effect1)
		if (data.over != 0) {

		}
		this.price = Number(data.price)
		let disc = Math.floor(data.price / data.show_price * 10)
		//this._img_discount.visible = disc > 0 && disc < 10

		let can_show = disc > 0 && disc < 10
		let discount = (Number(data.price) / Number(data.show_price) * 10).toFixed(1)
		let [num, num_point] = CustomActivityModel.GetInstance().GetActDis(discount)
		this._img_discount.visible = num_point == 0 && can_show
		this.point_gp.visible = num_point != 0 && can_show



		if (disc > 0 && disc < 10) {
			if (num_point == 0) {
				ResManager.GetInstance().SetImageSprite(this, this._img_discount, "adventure_asset", "dsic_" + disc)
			}
			else {
				ResManager.GetInstance().SetImageSprite(this, this.big_num, "adventure_asset", "big0" + num)
				ResManager.GetInstance().SetImageSprite(this, this.small_num, "adventure_asset", "small0" + num_point)
			}
			let data = {
				custom_sorting_order: this.custom_sorting_order,
				load_call_back: () => {
					// this.CoverEffect(this._img_discount,this.layer_value,this.custom_sorting_order+1)
					//this:CoverEffect(this._gp_item,this.layer_value,this.custom_sorting_order)
				}
			}
			// this.AddUIEffect("UI_yjtb_02", this._gp_effect1, null, 6, true)
		}
		this.AddUIEffect("UI_yjtb_02", this._gp_effect, null, 10, true)
		let reward = GoodsModel.RewardKeyToNumber(data.reward)
		if (reward && reward.length > 0) {
			this.reward_lsit = reward
			reward = reward[0]
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			this._lb_name.text = Trim(basic.goods_name)
			if (!this.item) {
				this.item = new EquipmentItem(this._gp_item)
				this.item.Load()
				this.item.SetItemSize(83, 83)
			}
			this.item.ExcuteCallback(() => {
				this.item.SetData(type_id, reward[2], lock)
			}
			)
		}
		// LayoutRebuilder(this._Group2)
	}

	public RefStatus(data?) {

		if (!data) {
			return
		}

		this._gp_buy.visible = data.price && data.price > 0 && data.state == 0
		this._lb_over.visible = (data.price != undefined && data.price == 0 || data.state != 0)
		if (this._gp_buy.visible) {
			this._lb_btn_price.text = data.price
		}
		if (this._lb_over.visible) {
			this._lb_over.text = (data.state == 1 && ("已购买") || ("免费"))
		}
		this._img_red.visible = data.price == 0 && data.state == 0
		this.ClearUIEffect(this._gp_buy_eff)
		if (data.price == 0 && data.state == 0) {
			this.AddUIEffect("ui_anniu_5", this._gp_buy_eff, null, 16, true)
		}
	}

	public SetData(data?) {
		this.data = data
		this.InitView()
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._Image1,
			this._lb_limit,
			this._gp_item,
			this._gp_effect,
			this._img_discount,
			this._gp_effect1,
			this._lb_name,
			this._Group2,
			this._Label1,
			this._img_jin,
			this._Group1,
			this._lb_price,
			this._Image2,
			this._gp_btn,
			this._Image3,
			this._gp_buy_eff,
			this._gp_buy,
			this._Label2,
			this._img_btn_jin,
			this._lb_btn_price,
			this._lb_over,
			this._img_red,
			this._img_over,
			this.point_gp,
			this.big_num,
			this.small_num,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_limit",
				"_gp_item",
				"_gp_effect",
				"_img_discount",
				"_gp_effect1",
				"_lb_name",
				"_Group2",
				"_Label1",
				"_img_jin",
				"_Group1",
				"_lb_price",
				"_Image2",
				"_gp_btn",
				"_Image3",
				"_gp_buy_eff",
				"_gp_buy",
				"_Label2",
				"_img_btn_jin",
				"_lb_btn_price",
				"_lb_over",
				"_img_red",
				"_img_over",
				"point_gp",
				"big_num",
				"small_num",
			])
	}
}
window["AdventureShopItem"] = AdventureShopItem