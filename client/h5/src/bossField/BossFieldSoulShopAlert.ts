import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class BossFieldSoulShopAlert extends BaseView1 {


	goods_model: GoodsModel
	show_item: BaseAwardItem
	public constructor() {
		super()

		this.base_file = "bossField"
		this.layout_file = "BossFieldSoulShopAlert"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.not_show_item_use = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.goods_model = GoodsModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {

		}

		this.close_callback = () => {
			if (this.show_item) {
				this.show_item.DeleteMe()
				this.show_item = null
			}
		}
	}

	//是否使用一张双倍战魂卡获得<color=#639c12>2小时双倍战魂</color>时间？
	//是否使用一张双倍战魂卡获得2小时双倍战魂时间？
	public InitEvent() {

		Util.AddClickEvent(this._box_use, () => {
			let num = this.goods_model.GetTypeGoodsNum(37110001)
			if (num > 0) {
				let goods_base = GoodsModel.GetInstance().GetGoodsBasicByTypeId(37110001)
				let vo = GoodsModel.GetInstance().GetTypeGoods(37110001)
				this.goods_model.Fire(GoodsModel.USE_BAG_GOODS, vo[0].goods_id, 1)
			} else {
				Message.show("无可使用物品")
				//MaterialsTool:GetInstance():materialsTips(37110001)
			}
		}
			, this, true)

		Util.AddClickEvent(this._box_cancel, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)

		this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
			if (type_id != 37110001) {
				return
			}
			let num = this.goods_model.GetTypeGoodsNum(37110001)
			this._lb_have.text = Util.StrToHTML("拥有：" + num )//<font color=0x82AB20></font>"
		})
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("common", "uisy_023"))

		if (!this.show_item) {
			this.show_item = new BaseAwardItem(this._box_icon, null, this.layer_value)
			this.show_item.Load()
			this.show_item.SetItemSize(110, 110)
		}
		this.show_item.SetData(37110001)
		let num = this.goods_model.GetTypeGoodsNum(37110001)
		this._lb_have.text = Util.StrToHTML("拥有：" + num )//<font color=0x82AB20></font>
		this.InitEvent()
	}

	_img_bg: Laya.Image
	_img_title: Laya.Image
	_img_close: Laya.Image
	_box_icon: Laya.Box
	_lb_name: Laya.Label
	_lb_have: Laya.Label
	_lb_desc: Laya.Label
	_box_cancel: Laya.Box
	_img_cancel: Laya.Image
	_lb_cancel: Laya.Label
	_box_use: Laya.Box
	_img_use: Laya.Image
	_lb_use: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._img_close,
			this._box_icon,
			this._lb_name,
			this._lb_have,
			this._lb_desc,
			this._box_cancel,
			this._img_cancel,
			this._lb_cancel,
			this._box_use,
			this._img_use,
			this._lb_use,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_img_close",
				"_box_icon",
				"_lb_name",
				"_lb_have",
				"_lb_desc",
				"_box_cancel",
				"_img_cancel",
				"_lb_cancel",
				"_box_use",
				"_img_use",
				"_lb_use",
			])
	}
}
window["BossFieldSoulShopAlert"] = BossFieldSoulShopAlert