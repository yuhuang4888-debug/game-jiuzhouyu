import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { SetAnchoredPositionX, SetSizeDelta, SetAnchoredPosition, SetAnchoredPositionY, Util, NotEnougnDiamond, Trim } from "../util/Util"

export class FtvShopItem extends BaseItem1 {
	_Image1: Laya.Image
	_lb_name: Laya.Label
	_lb_limit: Laya.Label
	_gp_item: Laya.Box
	_img_title: Laya.Image
	_img_discount: Laya.Image
	_Group2: Laya.Box
	_Label1: Laya.Label
	_img_jin: Laya.Image
	_Group1: Laya.Box
	_lb_price: Laya.Label
	_Image2: Laya.Image
	_gp_btn: Laya.Box
	_Image3: Laya.Image
	_gp_buy: Laya.Box
	_Label2: Laya.Label
	_img_btn_jin: Laya.Image
	_lb_btn_price: Laya.Label
	_lb_over: Laya.Label
	_img_over: Laya.Image
	point_gp: Laya.Box
	big_num: Laya.Image
	small_num: Laya.Image

	Emp_gp_btn
	base_type
	cond
	goods_basic
	grade_info
	item
	item_type
	limit_max
	model
	one_price
	price_type
	reward_obj
	sub_type

	public constructor(parent?) {
		super(parent)

		this.base_type = null
		this.sub_type = null
		this.grade_info = null
		this.model = null
		this.item = null
		this.limit_max = null
		this.cond = null
		this.one_price = null
		this.price_type = null
		this.goods_basic = null
		this.reward_obj = null
		this.item_type = 1

		this.base_file = "ftvShop"
		this.layout_file = "FtvShopItem"
		this.layer_value = Enum_UILayer.UI
		this.model = CustomActivityModel.GetInstance()
		this.load_callback = () => {

			this.InitEvent()

			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label2.visible = false
				SetAnchoredPositionX(this._img_btn_jin, 37)
				SetAnchoredPositionX(this._lb_btn_price, 73)

				this._lb_limit.fontSize = 16
				this._lb_name.fontSize = 16
				this._lb_name.leading = 0.7
				// let csf = this._lb_name.GetComponent("ContentSizeFitter")
				// csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				// csf.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
				SetSizeDelta(this._lb_name, 165, 40)
				SetAnchoredPosition(this._lb_name, 1, -44)
				this._lb_name.valign = "middle"
				this._lb_name.align = "center"

				this._lb_over.fontSize = 18
				SetAnchoredPositionY(this._lb_over, -16)
			}
		}

	}

	public InitEvent() {


		this.BindEvent(this.model, CustomActivityDefine.EVENT.UPDATE_ALL_COUNT, (...new_args) => {
			let args = new_args
			if (!this.grade_info) {
				return
			}
			if (this.base_type == args[0] && this.sub_type == args[1]) {
				if (this.grade_info.grade == args[2].grade) {
					let num = this.limit_max - args[2].count
					if (num < 0) { num = 0 }
					this._lb_limit.text = "全服限购:" + num + "/" + this.limit_max
					this.RefBtnVisible(num)
				}
			}
		}
		)

		this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
			let args = new_args
			if (!this.grade_info) {
				return
			}
			if (args[0] == this.base_type && args[1] == this.sub_type) {
				if (this.grade_info.grade == args[3].grade) {
					let num = this.limit_max - args[3].receive_times
					let desc = "限购"
					if (this.cond && this.cond.all_num != null) {
						if (this.grade_info.all_count != null) {
							num = this.limit_max - this.grade_info.all_count
						}
						desc = "全服限购"
					}
					if (num < 0) { num = 0 }
					this._lb_limit.text = desc + "：" + num + "/" + this.limit_max
					this.RefBtnVisible(num)
					if (this.goods_basic) {
						//let image = eui. new Image()
						//image.x = pos.x + this._gp_item.width / 2
						//image.y = pos.y + this._gp_item.height / 2
						//lua_resM:SetOutsideImageSprite(this, image, "resource/game/goodsicon/" + this.goods_basic.goods_icon + ".png")
						//LayerManager:GetInstance().stage.addChild(image)
						//let call_back = () => {
						//LayerManager:GetInstance().stage.removeChild(image)
						//}
						//Util.flyToDownUIIcon(image, MainFunc.Bag, call_back, 0.3, 0.3, 1000)
						let pos = this._gp_item.localToGlobal(new Laya.Point(0, 0))// UILocalToCanvasPoint(this._gp_item, co.TableXY(0, 1), co.TableXY(0, 1))
						let list = [[0, this.goods_basic.type_id, 1]]
						GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, 40, 300, 700)
					}
					Message.show("购买成功")
				}
			}
		}
		)

		Util.AddClickEvent(this._gp_btn, () => {
			let left_num = null
			if (this.grade_info.all_count != null) {
				left_num = this.limit_max - this.grade_info.all_count
				if (this.cond.personal_num) {
					left_num = this.grade_info.receive_times >= Number(this.cond.personal_num) && 0 || left_num
				}
			} else {
				left_num = this.limit_max - this.grade_info.receive_times
			}
			if (left_num > 0) {
				let base_type = this.base_type
				let sub_type = this.sub_type
				let act_key_dic = this.model.act_key_dic
				let cur_key_dic = act_key_dic[base_type] && act_key_dic[base_type][sub_type] || {}
				let jump_alert = false
				let ok_callback = () => {
					if (jump_alert) {
						act_key_dic[base_type] = act_key_dic[base_type] || {}
						act_key_dic[base_type][sub_type] = act_key_dic[base_type][sub_type] || {}
						act_key_dic[base_type][sub_type]["openAlert"] = false
					}
					let role_vo = RoleManager.GetInstance().mainRoleInfo
					let have_money = this.price_type == 2 && role_vo.jinLock || role_vo.jin
					let request = () => {
						let base_type = this.base_type
						this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33179, this.base_type, this.sub_type, this.grade_info.grade, 1)
					}
					//够钱直接买
					if (this.one_price <= have_money) {
						request()
					} else {
						let str = null
						let is_rechage = false
						if (this.price_type == 2 && this.one_price > role_vo.jinLock) {
							str = "绑玉不足，是否消耗<font color='#639c12'>" + (this.one_price - role_vo.jinLock) + "勾玉</font>继续购买"
						} else {
							NotEnougnDiamond()
							return
						}
						Alert.Show(str, Alert_Type.Two, () => {
							if (is_rechage) {
								OpenFun.OpenFunHandler(21)
							} else {
								request()
							}
						})
						Alert.SetIsCharge(true)
					}
				}

				if (this._lb_over.text == "个人已抢完" && this._lb_over.visible == true) {
					Message.show("购买次数不足")
					return
				}
				let is_openAlert = cur_key_dic && cur_key_dic["openAlert"]
				if (is_openAlert == false) {
					ok_callback()
					return
				}

				let money_name = this.price_type == 2 && "绑玉" || "勾玉"
				let str = "是否消耗<font color='#639c12'>" + this.one_price + money_name + "</font>"
				let num = this.reward_obj && this.reward_obj[3]
				str = str + "购买" + (num || 1) + "个<font color=" + ColorUtil.GetColorDark(this.goods_basic.color) + ">" + Trim(this.goods_basic.goods_name) + "</font>？"
				Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_callback, null, null, null, null, null, () => {
					jump_alert = !jump_alert
				}
				)
			} else {
				Message.show("购买次数不足")
			}
		}, this, true)
	}

	public InitView() {


		if (!this.grade_info) {
			return
		}
		let reward = this.grade_info.reward
		this.cond = this.model.GetActCondition(this.base_type, this.sub_type, "data", this.grade_info.grade)
		let cond = this.cond
		if (cond) {
			if (cond.price && Util.TableSize(cond.price) >= 4) {
				let price = cond.price
				let icon_url = Number(price[1]) == 1 && "com_diamond" || "com_bind_diamond"
				ResManager.GetInstance().SetImageSprite(this, this._img_btn_jin, "common_asset", icon_url)
				if (this._img_jin) {
					ResManager.GetInstance().SetImageSprite(this, this._img_jin, "common_asset", icon_url)
				}
				this._lb_price.text = price[2]
				if (this.item_type == 1) {
					// LayoutRebuilder(this._Group2)
				} else if (this.item_type == 2) {
					// LayoutRebuilder(this._Group1)
				}

				this.one_price = Number(price[3])
				this.price_type = Number(price[1])
				this._lb_btn_price.text = price[3]
				// LayoutRebuilder(this._gp_buy)

				let discount = Mathf.Floor(Number(price[3]) / Number(price[2]) * 10)
				let can_show = discount != 10
				let dis = (Number(price[3]) / Number(price[2]) * 10).toFixed(1)
				let [num, num_point] = CustomActivityModel.GetInstance().GetActDis(dis)
				this._img_discount.visible = num_point == 0 && can_show
				this.point_gp.visible = num_point != 0 && can_show
				if (can_show) {
					if (this.item_type == 1) {

						if (num_point == 0) {
							ResManager.GetInstance().SetImageSprite(this, this._img_discount, "ftvShop", "ui_First_label_" + discount)
						}
						else {
							ResManager.GetInstance().SetImageSprite(this, this.big_num, "ftvShop", "big" + num)
							ResManager.GetInstance().SetImageSprite(this, this.small_num, "ftvShop", "small0" + num_point)
						}



					} else {
						ResManager.GetInstance().SetImageSprite(this, this._img_discount, "ftvShop_asset", "uiqgsc_0" + discount)
					}
				}
			}
			let rare = cond.rare && Number(cond.rare)
			if (rare && rare > 0) {
				if (this.item_type == 1) {
					let title_url = cond.rare == "1" && "uiqgsd_004" || "uiqgsd_003"
					ResManager.GetInstance().SetImageSprite(this, this._img_title, "ftvShop_asset", title_url)
				} else if (this.item_type == 2) {
					let title_url = cond.rare == "1" && "uiqgsc_012b" || "uiqgsc_012"
					ResManager.GetInstance().SetImageSprite(this, this._img_title, "ftvShop_asset", title_url)
				}
			} else {
				this._img_title.visible = false
			}
			this.limit_max = (cond.all_num && Number(cond.all_num)) || (cond.personal_num && Number(cond.personal_num))
			let num = this.limit_max - this.grade_info.receive_times
			if (this.grade_info.all_count != null) {
				num = this.limit_max - this.grade_info.all_count
			} else {
				if (cond.all_num && Number(cond.all_num)) {
					if (Util.TableSize(cond.counter) >= 3) {
						let model_id = Number(cond.counter[1])
						let counter_id = Number(cond.counter[2])
						if (model_id && counter_id) {
							this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33106, this.base_type, this.sub_type, model_id, counter_id, this.grade_info.grade)
						}
					}
				}
			}

			let desc = cond.all_num && "全服限购" || "限购"
			if (num < 0) { num = 0 }
			this._lb_limit.text = desc + "：" + num + "/" + this.limit_max
			this.RefItem(reward)
			this.RefBtnVisible(num)
		}
	}

	public RefBtnVisible(num?) {


		if (num == 0) {
			this._lb_over.visible = true
			this._img_over.visible = true
			this._lb_over.text = "已售罄"
			this._gp_buy.visible = false
		} else {
			let bool = false
			if (this.grade_info.all_count != null && this.cond.personal_num && this.grade_info.receive_times >= Number(this.cond.personal_num)) {
				bool = true
			}
			this._img_over.visible = false
			this._lb_over.visible = bool
			this._lb_over.text = "个人已抢完"
			this._gp_buy.visible = !bool
		}
	}

	public RefItem(reward?) {


		if (reward) {
			let rewards = CustomActivityModel.GetInstance().GetActReward(this.base_type, this.sub_type, this.grade_info.form_type, reward)
			let good_model = GoodsModel.GetInstance()
			if (!rewards || !rewards[0]) {
				return
			}
			let [type_id, lock] = good_model.GetMappingTypeId(rewards[0][0], rewards[0][1])
			let basic = good_model.GetGoodsBasicByTypeId(type_id)
			if (basic) {
				this.goods_basic = basic
				this.reward_obj = rewards[0]
				if (!this.item) {
					this.item = new EquipmentItem(this._gp_item)
					this.item.Load()
					if (this.item_type == 1) {
						this.item.SetItemSize(90, 90)
					} else if (this.item_type == 2) {
						this.item.SetItemSize(100, 100)
					}
				}
				this.item.ExcuteCallback(() => {
					this.item.SetData(type_id, rewards[0][2], lock)
					// let cur_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
					this.ClearUIEffect(this._img_over)
				}
				)
				this._lb_name.text = basic.goods_name
			}
		}
	}

	public SetData(grade_info?, base_type?, sub_type?) {


		this.grade_info = grade_info
		this.base_type = base_type
		this.sub_type = sub_type
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
			this._lb_name,
			this._lb_limit,
			this._gp_item,
			this._img_title,
			this._img_discount,
			this._Group2,
			this._Label1,
			this._img_jin,
			this._Group1,
			this._lb_price,
			this._Image2,
			this._gp_btn,
			this._Image3,
			this._gp_buy,
			this._Label2,
			this._img_btn_jin,
			this._lb_btn_price,
			this._lb_over,
			this._img_over,
			this.point_gp,
			this.big_num,
			this.small_num,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_lb_limit",
				"_gp_item",
				"_img_title",
				"_img_discount",
				"_Group2",
				"_Label1",
				"_img_jin",
				"_Group1",
				"_lb_price",
				"_Image2",
				"_gp_btn",
				"_Image3",
				"_gp_buy",
				"_Label2",
				"_img_btn_jin",
				"_lb_btn_price",
				"_lb_over",
				"_img_over",
				"point_gp",
				"big_num",
				"small_num",
			])
	}
}
window["FtvShopItem"] = FtvShopItem