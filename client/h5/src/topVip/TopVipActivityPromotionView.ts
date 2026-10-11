import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { VipModel } from "../commonModel/VipModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TransformCurrency, Util } from "../util/Util"
import { TopVipActivityPromotionItem } from "./TopVipActivityPromotionItem"

export class TopVipActivityPromotionView extends BaseView1 {
	_Group2: Laya.Box
	bg_img: Laya.Image
	ber_img: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	recharge_gp: Laya.Box
	_Image3: Laya.Image
	_Label3: Laya.Label
	_Group1: Laya.Box
	_Image4: Laya.Image
	_Label4: Laya.Label
	recharge_num_lb: Laya.HTMLDivElement
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image111: Laya.Image
	recharge_day_num_gp: Laya.HBox
	buy_gp: Laya.Box
	_Image8: Laya.Image
	_Label5: Laya.Label
	close_img: Laya.Image
	InitEvent
	LoadSuccess
	UpdateView
	click_bg_toClose
	close_callback
	destroy_imm
	is_center
	not_show_item_use
	open_callback
	show_open_movie
	use_background

	public constructor() {
		super()


		let model = TopVipModel.GetInstance()

		let local_TopVipEvent = TopVipEvent
		let item_list_ = null
		let my_vip_vo_ = null
		let forever_vip_sell_ = null
		this.base_file = "topVip"
		this.layout_file = "TopVipActivityPromotionView"
		this.is_center = true
		this.use_background = true
		this.destroy_imm = true
		this.not_show_item_use = true
		this.click_bg_toClose = true
		this.show_open_movie = true

		this.layer_value = Enum_UILayer.Activity
		this.load_callback = () => {

		}

		this.open_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.close_callback = () => {
			if (item_list_ && item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = []
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("topVip", "uizz_022"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.ber_img, GameResPath.GetIcon("topVip", "uizz_015"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image6, GameResPath.GetIcon("topVip", "uizz_021"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("topVip", "uizz_017"), true)
			let pay_forever_vip_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_key_value", false)
			let value = null
			for (let key in pay_forever_vip_cfg) {

				if (Number(key) == 3) {
					// [ts2lua]pay_forever_vip_cfg下标访问可能不正确
					value = JSON.parse(pay_forever_vip_cfg[key].value)
					for (let _tmpi in value) {
						var pay = value[_tmpi]
						forever_vip_sell_ = String(pay[2])
					}
					break
				}
			}
		}

		this.UpdateView = () => {
			my_vip_vo_ = model.GetMyTopVipVo()
			let recharge_num = my_vip_vo_.today_gold
			let recharge_day = my_vip_vo_.charge_day
			let str = "<font color='#8fd100'>" + TransformCurrency(recharge_num) + "</font>" + `/${TransformCurrency(100)}元`
			this.recharge_num_lb.innerHTML = Util.StrToHTML(str)
			if (!item_list_) {
				item_list_ = []
			}
			let i = 1
			do {
				let item = item_list_[i]
				if (!item) {
					item = new TopVipActivityPromotionItem(this.recharge_day_num_gp)
					item.Load()
					item.SetScale(0.9)
					table.insert(item_list_, item)
				}
				if (recharge_day < i) {
					item.SetData(i, false)
				} else {
					item.SetData(i, true)
				}
				i = i + 1
			} while ((i < 8))
		}

		this.InitEvent = () => {
			model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45101)
			this.BindEvent(model, local_TopVipEvent.UPDATE_TOP_VIP_PROMOTION_VIEW, () => {
				this.UpdateView()
			}
			)
			Util.AddClickEvent(this.close_img, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.recharge_gp, () => {
				VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.buy_gp, () => {
				let str = "是否消耗<font color='#639c12'>" + forever_vip_sell_ + "勾玉</font>永久激活至尊Vip"
				let content = Util.StrToHTML(str)
				Alert.Show(content, Alert_Type.Two, () => {
					model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45107)
					this.Close()
				}
				)
			}
				, this, true)
		}


	}



	public GetComponents() {
		[
			this._Group2,
			this.bg_img,
			this.ber_img,
			this._Image1,
			this._Image2,
			this._Label1,
			this.recharge_gp,
			this._Image3,
			this._Label3,
			this._Group1,
			this._Image4,
			this._Label4,
			this.recharge_num_lb,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image111,
			this.recharge_day_num_gp,
			this.buy_gp,
			this._Image8,
			this._Label5,
			this.close_img,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"bg_img",
				"ber_img",
				"_Image1",
				"_Image2",
				"_Label1",
				"recharge_gp",
				"_Image3",
				"_Label3",
				"_Group1",
				"_Image4",
				"_Label4",
				"recharge_num_lb",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image111",
				"recharge_day_num_gp",
				"buy_gp",
				"_Image8",
				"_Label5",
				"close_img",
			])
		this.recharge_num_lb.style.fontSize=22
		this.recharge_num_lb.style.color="#c6373d"
		this.recharge_num_lb.style.wordWrap=false
	}
}
window["TopVipActivityPromotionView"]=TopVipActivityPromotionView