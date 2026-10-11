import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDelta, Util } from "../util/Util"

export class FtvExchangeGoodItem extends BaseItem1 {
	_gp: Laya.HBox
	_gp_item: Laya.Box
	_img_goods: Laya.Image
	_lb_count: Laya.HTMLDivElement
	good_item
	layout_gp
	typy_id

	public constructor(parent?) {
		super(parent)


		this.base_file = "ftvExchange"
		this.layout_file = "FtvExchangeGoodItem"
		this.load_callback = () => {

			this.InitEvent()
		}


	}

	public InitEvent() {


		Util.AddClickEvent(this._img_goods, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(this.typy_id)
		}, this, true)
	}

	public SetData(data?, is_good?) {


		if (is_good) {
			this._img_goods.visible = false

			if (!this.good_item) {
				this.good_item = new EquipmentItem(this._gp_item)
				//this.good_item.SetMaskId(1)
				this.good_item.Load()
				this.good_item.SetItemSize(30, 30)
			}
			this.good_item.ExcuteCallback(() => {
				let [typeId, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
				this.good_item.SetData(typeId)
				this._gp.refresh()
			}
			)
			let num = GoodsModel.GetInstance().GetTypeGoodsNum(data[1])
			let count_color = num >= Number(data[2]) && "'#1bb835'" || "'#ff4f50'"
			this._lb_count.style.fontSize = 20
			this._lb_count.style.color = "#ffffff"
			this._lb_count.style.wordWrap = false
			this._lb_count.innerHTML = Util.StrToHTML("<font color=" + count_color + ">" + data[2] + "</font>"
			)

			//LayoutRebuilder(this._gp)
		} else {
			let [typeId, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1])
			this.typy_id = typeId
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_goods, GameResPath.GetGoodsIconPath(typeId))
			SetSizeDelta(this._img_goods, 30, 30)
			this._lb_count.style.fontSize = 24
			this._lb_count.style.color = "#ffffff"
			this._lb_count.style.wordWrap = false
			this._lb_count.innerHTML = Util.StrToHTML("<font color='#639c12'>" + data[2] + "</font>"
			)

			// this.layout_gp = this._gp.GetComponent("UnityEngine.UI.HorizontalLayoutGroup")
			// this.layout_gp.spacing = Number(data[3]) >= 100 && 0 || 6
		}
		this._gp.refresh()
	}

	public SetSize(x?, y?) {

		SetSizeDelta(this._gp_item, x, y)
		SetSizeDelta(this._img_goods, x, y)
	}

	public SetGoodsNum(count?) {
		this._lb_count.style.fontSize = 24
		this._lb_count.style.color = "#ffffff"
		this._lb_count.style.wordWrap = false
		this._lb_count.innerHTML = Util.StrToHTML("<font color='#639c12'>" + count + "</font>"
		)
	}

	public DeleteMe() {


		if (this.good_item) {
			this.good_item.DeleteMe()
			this.good_item = null
		}
		super.DeleteMe()
	}




	public GetComponents() {
		[
			this._gp,
			this._gp_item,
			this._img_goods,
			this._lb_count,
		]
			= this.GetChildrenByNames([

				"_gp",
				"_gp_item",
				"_img_goods",
				"_lb_count",
			])
	}
}
window["FtvExchangeGoodItem"] = FtvExchangeGoodItem