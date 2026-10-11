import { BaseItem1 } from "../common/BaseItem1"
import { table } from "../common/table"
import { NotEnougnDiamond, RefBoxChildsLayout, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { ErlangParser } from "../util/ErlangParser"
import { OpenFun } from "../common/OpenFun"
import { TranslationManager } from "../commonController/TranslationManager"
import { PlatformManager } from "../PlatformManager"

export class LuckyDuoBaoLimitBuyItem extends BaseItem1 {
	//_show
	//_view_reward
	base_type
	can_buy
	cond
	cost_type
	cost_url
	cur_price
	data
	model
	needRefresh
	parent_mask_corners
	product_info
	reward_list
	show_goods
	sub_type
	cfg_recharge
	is_enough_vip
	public constructor(parent) {
		super(parent)
		this.base_file = "luckyDuobao"
		this.layout_file = "LuckyDuoBaoLimitBuyItem"
		this.preload_server_config = {
			"config_recharge_product": false
		}

		this.data = null
		this.cost_url = ["", "com_diamond", "com_bind_diamond", "ui_yuan"]
		this.model = CustomActivityModel.GetInstance()
		this.reward_list = null
		this.show_goods = null
		this.can_buy = false
		this.product_info = null

		this.load_callback = () => {
			this._lb_count.style.fontSize = 22
			this._lb_count.style.color = "#663915"
			this._lb_count.style.wordWrap = false

			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this.cfg_recharge = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._item_bg, "resource/game/luckyDuobao/other/uixsqg_006.png")
		this._scr_reward.hScrollBarSkin = ""

		this.InitEvent()
		//this.parent_mask_corners = GetWorldCorners(this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect)).transform.Find("Viewport"))
		///this.vhscroll = this.GetChild("_scr_reward").GetComponent("VHScrollRect")
		//this.vhscroll.parentScroll = this.form.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect))
		if (this.needRefresh) {
			this.RefreshView()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn_buy, () => {
			if (this.can_buy) {

				//vip
				if (!this.is_enough_vip) {
					let vip_lv = this.cond["vip_lv"] && Number(this.cond["vip_lv"]) || 0
					Alert.Show(`升至VIP${vip_lv}可购买该礼包。`, Alert_Type.Two, () => {
						OpenFun.OpenFunHandler(23)
					}, null, "前往提升", "取消")
					return
				}



				if (this.cost_type == 3) {
					//直购
					if (this.product_info) {
						//PlatformMgr.GetInstance().PayRequest(this.product_info.money, { id=this.product_info.product_id, pay_title=this.product_info.product_name })
					}
				} else {
					let buy_request = () => {
						this.model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33179, this.base_type, this.sub_type, this.data.grade, 1)
					}
					let role_vo = RoleManager.GetInstance().mainRoleInfo
					let need_money = this.cur_price
					let have_money = this.cost_type == 1 && role_vo.jin || role_vo.jinLock
					if (have_money >= need_money) {
						let cost_str = this.cost_type == 1 && "勾玉" || "绑玉"
						if (!this.model.luckyDuobao_buy_alert1) {
							let gap = ""
							Alert.Show("是否消耗<font color='#00a22e'>" + need_money + gap + cost_str + "</font>购买？", Alert_Type.AlertTypeCheckBox, buy_request, null, null, null, null, false, (bool?) => {
								this.model.luckyDuobao_buy_alert1 = bool
							})
						} else {
							buy_request()
						}
					} else {
						if (Number(this.cost_type) == 1) {
							NotEnougnDiamond()
							return
						} else if (Number(this.cost_type) == 2) {
							let str = "绑玉不足，是否消耗<font color='#00a22e'>" + (need_money - role_vo.jinLock) + "勾玉</font>继续购买?"
							let ok_func = () => {
								if (role_vo.jin >= (need_money - role_vo.jinLock)) {
									buy_request()
								} else {
									Message.show("您的勾玉不足")
								}
							}
							if (!this.model.luckyDuobao_buy_alert2) {
								Alert.Show(str, Alert_Type.AlertTypeCheckBox, ok_func, null, null, null, null, false, (bool?) => {
									this.model.luckyDuobao_buy_alert2 = bool
								})
								Alert.SetIsCharge(true)
							} else {
								ok_func()
							}
						}
					}
				}
			} else {
				Message.show("该档次礼包已买完")
			}
		}, this, true)

		this.BindEvent(this.model, CustomActivityDefine.EVENT.ANSWER_TARGET, (...new_args) => {
			let args = new_args
			if (!this.data) {
				return
			}
			if (args[0] == this.base_type && args[1] == this.sub_type) {
				if (this.data.grade == args[3].grade) {
					this.data.receive_times = args[3].receive_times
					this.RefreshView()
				}
			}
		}
		)
	}

	public RefreshView() {
		if (!this.data) {
			return
		}
		this.InitBuyInfo()
		this.CreateReward()
	}

	//{cost_type, 1勾玉/2绑玉/3人民币}
	public InitBuyInfo() {
		this.cond = this.model.GetActCondition(this.base_type, this.sub_type, "data", this.data.grade)
		//test
		//this.cond.cost_type = 1
		this.cost_type = Number(this.cond.price[1])
		let cost_url = this.cost_url[this.cost_type]
		ResManager.GetInstance().SetImageSprite(this, this._cost_old, "common", cost_url)
		ResManager.GetInstance().SetImageSprite(this, this._cost_new, "common", cost_url)

		// ResManager.GetInstance().SetImageSprite(this, this._img_dis, "discountGift_asset", "uiczth_zk0" + this.cond.price[4], true)
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
		// 	this._show.visible = false
		// }
		let discount = (Number(this.cond.price[3]) / Number(this.cond.price[2]) * 10).toFixed(1)
		let [num, num_point] = CustomActivityModel.GetInstance().GetActDis(discount)
		this.img_discount_num.visible = num_point == 0
		this.point_gp.visible = num_point != 0
		if (num_point == 0) {
			ResManager.GetInstance().SetImageSprite(this, this.img_discount_num, "luckyDuobao", "uixsqg_004_" + num)
		}
		else {
			ResManager.GetInstance().SetImageSprite(this, this.big_num, "luckyDuobao", "big0" + num)
			ResManager.GetInstance().SetImageSprite(this, this.small_num, "luckyDuobao", "small0" + num_point)
		}

		if (this.cond.rare) {
			ResManager.GetInstance().SetImageSprite(this, this.img1, "luckyDuobao", "tag_" + this.cond.rare, true)
			this.img1.visible = true
		} else {
			this.img1.visible = false
		}


		this._lb_count.innerHTML = "剩余次数：<font color='#00a22e'>" + ((Number(this.cond.personal_num) - this.data.receive_times)) + "</font>"
		this.cur_price = Number(this.cond.price[3])

		this.can_buy = this.data.receive_times < Number(this.cond.personal_num)
		this._gp_new.visible = this.can_buy
		this._sold_out.visible = !this.can_buy
		Util.SetImageGray(this._img_buy, !this.can_buy)
		this._gp_buy.visible = this.can_buy
		this._img_dis.visible = !this.can_buy

		if (this.cost_type && this.cost_type == 3) {
			let recharge_id = this.cond.recharge_id
			this.product_info = this.cfg_recharge[Number(recharge_id)]
		}


		//vip显示处理
		let vip_lv = this.cond["vip_lv"] && Number(this.cond["vip_lv"]) || 0
		let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag
		this.is_enough_vip = role_vip >= vip_lv ? true : false
		//划线
		this._Image1.visible = this.is_enough_vip

		if (this.is_enough_vip) {
			this._cost_new.visible = true
			//价格
			this._lb_old.text = this.cond.price[2]
			this._lb_new.text = this.cond.price[3]
			this._Text1.text = "价格:"
			if(PlatformManager.IsEyouPlatform()){
				this._lb_new.autoSize = true
				this._lb_new.wordWrap = false
				this._lb_new.y = 2
			}
		} else {
			this._cost_new.visible = false
			this._lb_old.text = this.cond.price[3]
			this._lb_new.text = `VIP${vip_lv}可买`
			this._Text1.text = "现价:"

			if(PlatformManager.IsEyouPlatform()){
				this._lb_new.autoSize = false
				this._lb_new.width = 108
				this._lb_new.wordWrap = true
				this._lb_new.leading = 0.1
				this._lb_new.y = -10.5
			}
		}
		RefBoxChildsLayout(this._gp_new, 5, null, true, "center")
	}

	public CreateReward() {
		this.show_goods = null
		if (!this.reward_list) {
			this.reward_list = []
		}
		let list = ErlangParser.GetInstance().parse(this.data.reward)
		if (list) {
			for (let i = 0; i < list.length; i++) {
				let vo = list[i]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				let item = this.reward_list[i]
				if (!item) {
					// let _parent = i == 1 && this._show || this._con_reward
					let _parent = this._con_reward
					item = new BaseAwardItem(_parent)
					// let _scale = i == 1 && 0.8 || 0.75
					//let _scale = 0.75
					//item.SetScale(_scale)
					item.SetItemSize(90, 90)
					// if (i != 1) {
					// 	item.SetMaskId(1)
					// }
					// item.SetMaskId(2)
					// item.SetMaskRect(this.parent_mask_corners)
					item.Load()
					table.insert(this.reward_list, item)
				}
				if (basic) {
					item.SetData(type_id, vo[2])
					item.SetVisible(true)
				}
			}
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
				let item = this.reward_list[i]
				item.DeleteMe()
			}
		}
		super.DeleteMe()
	}


	_item_bg: Laya.Image
	img_discount_num: Laya.Image
	_scr_reward: Laya.Panel
	_con_reward: Laya.HBox
	_gp_buy: Laya.Box
	_gp_old: Laya.HBox
	_Text1: Laya.Label
	_lb_old: Laya.Label
	_cost_old: Laya.Image
	_Image1: Laya.Image
	_btn_buy: Laya.Box
	_img_buy: Laya.Image
	_gp_new: Laya.Box
	_lb_new: Laya.Label
	_cost_new: Laya.Image
	_sold_out: Laya.Label
	_lb_count: Laya.HTMLDivElement
	_img_dis: Laya.Image
	img1: Laya.Image
	point_gp: Laya.Box
	big_num: Laya.Image
	small_num: Laya.Image
	public GetComponents() {
		[
			this._item_bg,
			this.img_discount_num,
			this._scr_reward,
			this._con_reward,
			this._gp_buy,
			this._gp_old,
			this._Text1,
			this._lb_old,
			this._cost_old,
			this._Image1,
			this._btn_buy,
			this._img_buy,
			this._gp_new,
			this._lb_new,
			this._cost_new,
			this._sold_out,
			this._lb_count,
			this._img_dis,
			this.img1,
			this.point_gp,
			this.big_num,
			this.small_num,
		]
			= this.GetChildrenByNames([

				"_item_bg",
				"img_discount_num",
				"_scr_reward",
				"_con_reward",
				"_gp_buy",
				"_gp_old",
				"_Text1",
				"_lb_old",
				"_cost_old",
				"_Image1",
				"_btn_buy",
				"_img_buy",
				"_gp_new",
				"_lb_new",
				"_cost_new",
				"_sold_out",
				"_lb_count",
				"_img_dis",
				"img1",
				"point_gp",
				"big_num",
				"small_num",
			])
	}
}
window["LuckyDuoBaoLimitBuyItem"] = LuckyDuoBaoLimitBuyItem