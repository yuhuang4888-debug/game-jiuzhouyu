import { BaseView1 } from "../common/BaseView1";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class DemonRotaryUpView extends BaseView1 {
	_img6: Laya.Image
	_img0: Laya.Image
	_img1: Laya.Image
	_img2: Laya.Image
	_img3: Laya.Image
	_img5: Laya.Image
	_img4: Laya.Image
	_effect: Laya.Box
	_item: Laya.Box
	_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label


	equip_item
	goods

	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonRotaryUpView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.show_open_movie = true
		this.click_bg_toClose = true
		this.destroy_imm = true

		this.goods = null

		this.open_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (this.equip_item) {
				this.equip_item.DeleteMe()
				this.equip_item = null
			}
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn, () => {
			this.Close()
		}, this, true)
	}

	public LoadSuccess() {
		let goods = this.goods
		let setImg = (compoent?, name?) => {
			ResManager.GetInstance().SetTexture(this, compoent, GameResPath.GetIconOtherPath("demon",name))
		}

		setImg(this._img0, "uijs_100")
		setImg(this._img2, "uijs_102a")
		setImg(this._img3, "uijs_102a")
		setImg(this._img4, "uijs_104a")
		setImg(this._img5, "uijs_105a")
		setImg(this._img6, "uijs_088")

		// this.AddUIEffect("ui_Special_glow", this._effect, null, {x=0.85, y=0.85}, true)
		if (goods) {
			if (!this.equip_item) {
				this.equip_item = new EquipmentItem(this._item)
				this.equip_item.Load()
				this.equip_item.SetItemSize(100, 100)
			}
			this.equip_item.ExcuteCallback(() => {
				let [type, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods[0], goods[1])
				this.equip_item.SetData(type, goods[2], lock)
			})
		}

		this.InitEvent()
	}

	public Open(...parms) {
		this.goods = parms[0]
		super.Open()
	}


	public GetComponents() {
		[
			this._img6,
			this._img0,
			this._img1,
			this._img2,
			this._img3,
			this._img5,
			this._img4,
			this._effect,
			this._item,
			this._btn,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_img6",
				"_img0",
				"_img1",
				"_img2",
				"_img3",
				"_img5",
				"_img4",
				"_effect",
				"_item",
				"_btn",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["DemonRotaryUpView"]=DemonRotaryUpView