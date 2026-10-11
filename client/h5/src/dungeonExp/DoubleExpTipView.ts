import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { WordManager } from "../common/WordManager"
import { EquipmentItem } from "../common/EquipmentItem"
import { OpenFun } from "../common/OpenFun"
import { GoodsModel } from "../commonModel/GoodsModel"

export class DoubleExpTipView extends BaseView1 {
	btn_close: Laya.Image
	img_bg: Laya.Image
	icon: Laya.Image
	img_title: Laya.Image
	img_nameBg: Laya.Image
	lb_name: Laya.Label
	img_line: Laya.Image
	lb_hit: Laya.Label
	_gp_good_info: Laya.Box
	_gp_goods: Laya.Box
	_lb_goods_name: Laya.Label
	_lb_goods_num: Laya.Label
	_gp_btn: Laya.Box
	_Image4: Laya.Image
	_lb_btn: Laya.Label
	_img_red: Laya.Image
	des:Laya.Image
	item
	res_mgr


	public constructor() {
		super()
		this.base_file = "dungeonExp"
		this.layout_file = "DoubleExpTipView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		//this.is_lastView_close = true
		this.destroy_imm = true
		

		this.res_mgr = ResManager.GetInstance()


		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
	}

	private LoadSuccess() {
		this.res_mgr.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("dungeonExp", "ui_guard_01"))
		this.res_mgr.SetOutsideImageSprite(this, this.des, GameResPath.GetIcon("dungeonExp", "des"),true)
		if (!this.item) {
			this.item = new EquipmentItem(this._gp_goods)
			this.item.Load()
			this.item.SetItemSize(70, 70)
		}
		this.item.ExcuteCallback(() => {
			this.item.SetData(37020002, 1, 0)
		}
		)
		let goods_num = GoodsModel.GetInstance().GetBagGoodsNum(37020002)
		this._lb_goods_num.text = `${goods_num}/${1}`
		this._lb_goods_num.color = (goods_num > 0) ? "#19ae4a" : "#ff4f50"
	}

	private InitEvent() {
		Util.AddClickEvent(this._gp_btn, () => {
			OpenFun.OpenFunHandler(70)
			this.Close()
		}, this, true)
	}

	




	public GetComponents() {
		[
			this.btn_close,
			this.img_bg,
			this.icon,
			this.img_title,
			this.img_nameBg,
			this.lb_name,
			this.img_line,
			this.lb_hit,
			this._gp_good_info,
			this._gp_goods,
			this._lb_goods_name,
			this._lb_goods_num,
			this._gp_btn,
			this._Image4,
			this._lb_btn,
			this._img_red,
			this.des
		]
			= this.GetChildrenByNames([

				"btn_close",
				"img_bg",
				"icon",
				"img_title",
				"img_nameBg",
				"lb_name",
				"img_line",
				"lb_hit",
				"_gp_good_info",
				"_gp_goods",
				"_lb_goods_name",
				"_lb_goods_num",
				"_gp_btn",
				"_Image4",
				"_lb_btn",
				"_img_red",
				"des"
			])
	}
}
window["DoubleExpTipView"] = DoubleExpTipView