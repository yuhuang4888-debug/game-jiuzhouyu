import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CheatModel } from "../commonModel/CheatModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Status } from "../util/Status"
import { Util, NotEnougnDiamond, RefBoxChildsLayout } from "../util/Util"
import { OpenFun } from "../common/OpenFun"

export class DiscountGiftItem extends BaseItem1 {

	VHS_scr_reward

	_view_reward
	base_type
	can_buy
	click_time
	cond
	cost_type
	cost_url
	cur_price
	data
	model
	money_cfg
	needRefresh
	parent_wnd
	product_info
	reward_list
	show_goods
	sub_type
	config_recharge_product
	is_enough_vip

	public constructor(parent) {
		super(parent)

		this.base_file = "discountGift"
		this.layout_file = "DiscountGiftItem"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.data = null
		this.cost_url = ["com_diamond", "com_bind_diamond"]
		this.model = CustomActivityModel.GetInstance()
		this.reward_list = null
		this.show_goods = null
		this.can_buy = false
		this.product_info = null//顯示用
		this.money_cfg = null//接口用
		this.click_time = 0
		this.preload_server_config = { "config_recharge_product": false }
		this.config_recharge_product = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
	}

	public LoadSuccess() {

		// this.RegisterMask(this._view_reward, 2)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._item_bg, GameResPath.GetIcon("discountGift", "uiczth_003"))

		if (this.needRefresh) {
			this.RefreshView()
		}
		this.InitEvent()
	}

	public InitEvent() {


		Util.AddClickEvent(this._btn_buy, () => {
			if (Status.NowTime - this.click_time < 0.5) {
				return
			}
			this.click_time = Status.NowTime

			//vip
			if(!this.is_enough_vip){
				let vip_lv = this.cond["vip_lv"] && Number(this.cond["vip_lv"]) || 0
				Alert.Show(`升至VIP${vip_lv}可购买该礼包。`, Alert_Type.Two, () => {
					OpenFun.OpenFunHandler(23)
				}, null, "前往提升", "取消")
				return
			}


			let base_type = this.base_type
			let sub_type = this.sub_type

			if (this.can_buy) {
				if (this.cost_type == 3 || this.cost_type == 4) {
					//直購
					if (this.money_cfg) {
						// PlatformManager.GetInstance().PayRequest(this.money_cfg.money, { id: this.money_cfg.product_id, pay_title: this.money_cfg.product_name })
						let str = "recharge_" + this.cond.recharge_id
						CheatModel.GetInstance().Fire(CheatModel.SEND_CHEAT_TO_SERVER, str)
						let list = ErlangParser.GetInstance().Parse(this.data.reward)
						let view = new CongratulationObtainView(list, 10)
						view.Open()
					}
				} else {
					let is_jump = this.model.discountGift_is_jump_alert
					let buy_request = () => {
						if (is_jump) {
							this.model.setKeyDicValue(base_type, sub_type, "is_jump" + this.data.grade, true)
						}
						this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, base_type, sub_type, this.data.grade)
					}

					let role_vo = RoleManager.GetInstance().mainRoleInfo
					let need_money = this.cur_price
					let have_money = this.cost_type == 1 && role_vo.jin || role_vo.jinLock
					if (have_money >= need_money) {
						if (is_jump) {
							buy_request()
						} else {
							let check_func = () => {
								this.model.discountGift_is_jump_alert = !this.model.discountGift_is_jump_alert
							}
							let cost_str = this.cost_type == 1 && "勾玉" || "绑玉"
							Alert.Show("是否消耗<font color='#639c12'>" + need_money + cost_str + "</font>购买？", Alert_Type.AlertTypeCheckBox, buy_request, null, null, null, null, null, check_func)
						}
					} else {
						if (Number(this.cost_type) == 1) {
							NotEnougnDiamond()
							return
						} else if (Number(this.cost_type) == 2) {
							let str = "绑玉不足，是否消耗<font color='#639c12'>" + (need_money - role_vo.jinLock) + "勾玉</font>继续购买?"
							Alert.Show(str, Alert_Type.Two, () => {
								if (role_vo.jin >= (need_money - role_vo.jinLock)) {
									buy_request()
								} else {
									Message.show("您的勾玉不足")
								}
							})
							Alert.SetIsCharge(true)
						}
					}

				}

			} else {
				Message.show("该档次礼包已买完")
			}
		}, this, true)
	}

	public RefreshView() {

		if (!this.data) {
			return
		}

		this.InitBuyInfo()
		this.CreateReward()
	}

	//{cost_type, 1钻石/2绑钻/3超值特惠直购/4小额礼包直购}
	public InitBuyInfo() {

		this.cond = this.model.GetActCondition(this.base_type, this.sub_type, "data", this.data.grade)
		this.cost_type = Number(this.cond.cost_type)
		this.cur_price = Number(this.cond.price[2])



		//剩余次数
		this._lb_count.text = "限购次数：" + ((Number(this.cond.limit_buy) - this.data.receive_times))

		//是否已购买
		this.can_buy = this.data.receive_times < Number(this.cond.limit_buy)
		this._btn_buy.visible = this.can_buy
		this.none.visible = !this.can_buy
		this._gp_old.visible = this.can_buy
		this._img_dis.visible = this.can_buy
		this._lb_count.visible = this.can_buy
		this._Image1.visible = this.can_buy

		//折扣图片
		let dis = this.cond.price[3]
		let [num, num_point] = CustomActivityModel.GetInstance().GetActDis(dis)
		this._img_dis.visible = num_point == 0 && this.can_buy
		this.point_gp.visible = num_point != 0 && this.can_buy
		if (num_point == 0) {
			ResManager.GetInstance().SetImageSprite(this, this._img_dis, "discountGift_asset", "uiczth_zk0" + dis, true)
		}
		else {
			ResManager.GetInstance().SetImageSprite(this, this.big_num, "discountGift_asset", "big0" + num)
			ResManager.GetInstance().SetImageSprite(this, this.small_num, "discountGift_asset", "small0" + num_point)
		}

		Util.SetImageGray(this._img_buy, !this.can_buy)

		//价格信息
		this.InitBuyPrice()

	}

	public InitBuyPrice() {

		let cost_asset = "common_asset"
		let cost_url = this.cost_url[this.cost_type - 1] || ""

		//直购
		if (this.cost_type && (this.cost_type == 3 || this.cost_type == 4)) {
			let recharge_id = Number(this.cond.recharge_id)

			if (!this.product_info) {
				this.product_info = this.config_recharge_product[recharge_id]
				cost_asset = "discountGift_asset"
				cost_url = "ui_money"
			} else {
				cost_asset = "discountGift_asset"
				cost_url = "ui_money"
			}
			this.money_cfg = this.config_recharge_product[recharge_id]

			this._gp_old.visible = false
			this._img_dis.visible = false
		}

		let vip_lv = this.cond["vip_lv"] && Number(this.cond["vip_lv"]) || 0
		let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag
		this.is_enough_vip = role_vip>=vip_lv?true:false
		let is_sale_out=(Number(this.cond.limit_buy) - this.data.receive_times)==0 //是否售完

		//vip专属图标
		this._img_tab.visible = vip_lv > 0

		//划线
		this._Image1.visible = this.is_enough_vip&&!is_sale_out

		//货币图片
		ResManager.GetInstance().SetImageSprite(this, this._cost_old, cost_asset, cost_url, true)
		ResManager.GetInstance().SetImageSprite(this, this._cost_new, cost_asset, cost_url, true)



		if (this.is_enough_vip) {
			this._cost_new.visible=true
			//价格
			this._lb_old.text = this.cond.price[1]
			this._lb_new.text = this.cond.price[2]
			this._Text1.text="价格:"
		}else{
			this._cost_new.visible=false
			this._lb_old.text = this.cond.price[2]
			this._lb_new.text = `VIP${vip_lv}可买`
			this._Text1.text="现价:"
		
		}
		RefBoxChildsLayout(this._gp_new,5,null,true,"center")


	}

	public CreateReward() {

		this.show_goods = null

		if (!this.reward_list) {
			this.reward_list = []
		}

		for (let i = 0; i < this.reward_list.length; i++) {
			var item = this.reward_list[i]
			item.SetVisible(false)
		}

		let list = ErlangParser.GetInstance().Parse(this.data.reward)
		if (list) {
			for (let i = 0; i < list.length; i++) {
				var vo = list[i]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				let item = this.reward_list[i]
				if (!item) {
					let _parent = i == 0 && this._show || this._con_reward
					item = new BaseAwardItem(_parent, null, "UI")

					let _scale = i == 0 && 0.8 || 0.75
					item.SetScale(0.65)

					// if (i == 1) {
					// 	item.SetMaskId(1)
					// } else {
					// 	item.SetMaskId(2)
					// 	// item.SetMaskRect(this.mask_corners)
					// }
					// item.SetMaskItemMaterial(this.mask_item_mat)
					item.Load()
					table.insert(this.reward_list, item)
				}
				if (basic) {
					item.SetData(type_id, vo[2])
					item.SetVisible(true)
				}
			}

			//奖励格子，多余的要隐藏
			//for (let i = list.length; i <= this.reward_list.length; i++){
			//if (this.reward_list[i] ) {
			//let item = this.reward_list[i]
			//item:SetVisible(false)
			//}
			//}
		}
	}

	public SetData(reward_data?, base_type?, sub_type?) {

		if (!reward_data) {
			return
		}

		this.data = reward_data
		this.base_type = base_type
		this.sub_type = sub_type
		if (this.is_loaded) {
			this.RefreshView()
		} else {
			this.needRefresh = true
		}
	}

	public DeleteMe() {

		if (this.reward_list && this.reward_list.length > 0) {
			for (let i in this.reward_list) {
				var item = this.reward_list[i]
				item.DeleteMe()
			}
		}
		super.DeleteMe()
	}



	_item_bg: Laya.Image
	_show: Laya.Image
	_scr_reward: Laya.Panel
	_con_reward: Laya.HBox
	_gp_old: Laya.Box
	_Text1: Laya.Label
	_lb_old: Laya.Label
	_cost_old: Laya.Image
	_Image1: Laya.Image
	_btn_buy: Laya.Box
	_img_buy: Laya.Image
	_gp_new: Laya.Box
	_cost_new: Laya.Image
	_lb_new: Laya.Label
	_sold_out: Laya.Label
	none: Laya.Image
	_lb_count: Laya.Label
	_img_dis: Laya.Image
	point_gp: Laya.Box
	big_num: Laya.Image
	small_num: Laya.Image
	_img_tab: Laya.Image
	public GetComponents() {
		[
			this._item_bg,
			this._show,
			this._scr_reward,
			this._con_reward,
			this._gp_old,
			this._Text1,
			this._lb_old,
			this._cost_old,
			this._Image1,
			this._btn_buy,
			this._img_buy,
			this._gp_new,
			this._cost_new,
			this._lb_new,
			this._sold_out,
			this.none,
			this._lb_count,
			this._img_dis,
			this.point_gp,
			this.big_num,
			this.small_num,
			this._img_tab,
		]
			= this.GetChildrenByNames([

				"_item_bg",
				"_show",
				"_scr_reward",
				"_con_reward",
				"_gp_old",
				"_Text1",
				"_lb_old",
				"_cost_old",
				"_Image1",
				"_btn_buy",
				"_img_buy",
				"_gp_new",
				"_cost_new",
				"_lb_new",
				"_sold_out",
				"none",
				"_lb_count",
				"_img_dis",
				"point_gp",
				"big_num",
				"small_num",
				"_img_tab",
			])
	}
}
window["DiscountGiftItem"] = DiscountGiftItem