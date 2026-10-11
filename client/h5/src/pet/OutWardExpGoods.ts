import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { Util } from "../util/Util"


export class OutWardExpGoods extends BaseItem1 {
	item_gp: Laya.Box
	effect_gp: Laya.Box
	item_name: Laya.Label
	click: Laya.Image


	public item
	public goods_num
	public id
	public info
	public is_max
	public refVisibleNum

	public local_goodsModelIns = GoodsModel.GetInstance()
	public local_outwardModelIns = OutWardBaseModel.GetInstance()

	public constructor(parent?) {
		super(parent)

		this.base_file = "pet"
		this.layout_file = "OutWardExpGoods"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {
			this.InitEvent()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.click, () => {
			if (!this.info) { return }
			if (this.info.type == 3 && this.goods_num && this.goods_num > 0 && !this.is_max) {
				this.local_outwardModelIns.Fire(OutWardBaseModel.EVOLUTION_OUTWARD_FIGURE, this.info.type_id, this.id, this.info.goods_id)
			} else {
				UIToolTipMgr.GetInstance().DefaultAppendTips(this.info.goods_id, this.goods_num)
			}
		}, this, false)

		let OnGoodsNumberChange = (list?) => {
			if (!list) {
				return
			}
			for (let v of list) {
				if (v.type_id == this.info.goods_id) {
					this.goods_num = this.local_goodsModelIns.GetTypeGoodsNum(this.info.goods_id)
					this.item.ExcuteCallback(() => {
						this.item.ForceSetNumber(this.goods_num)
					})
					this.RefEffect()
				}
			}
		}
		this.BindEvent(this.local_goodsModelIns, GoodsModel.CHANGE_BAG_LIST, OnGoodsNumberChange)
	}

	public InitView() {
		if (!this.info) { return }
		let cur_info = this.info
		let goods_name = GoodsModel.GetGoodsName(cur_info.goods_id)
		this.item_name.text = goods_name
		let item = this.item
		if (!item) {
			item = new BaseAwardItem(this.item_gp, undefined, undefined, false)
			// item.SetMaskId(1)
			item.Load()
			item.SetScale(90 / 127)
			this.item = item
		}
		this.goods_num = this.local_goodsModelIns.GetTypeGoodsNum(cur_info.goods_id)
		item.ExcuteCallback(() => {
			item.SetData(cur_info.goods_id, this.goods_num)
			item.ForceSetNumber(this.goods_num)
		})
		this.RefEffect()
	}

	public RefEffect() {
		this.ClearUIEffect(this.effect_gp)
		if (this.info.type == 3) { //有数量才显示
			let bool = this.goods_num && this.goods_num > 0
			this.display_obj.visible = bool
			if (!bool) {
				this.refVisibleNum()
			}
		}
		if (this.info.type == 3 && this.goods_num && this.goods_num > 0 && !this.is_max) {
			this.AddUIEffect("UI_1138", this.effect_gp, undefined, undefined, true)
		}
	}

	public SetData(info?, id?, is_max?, refVisibleNum?) {
		this.info = info
		this.id = id
		this.is_max = is_max
		this.refVisibleNum = refVisibleNum
		if (info) {
			this.InitView()
		}
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
			this.item_gp,
			this.effect_gp,
			this.item_name,
			this.click,
		]
			= this.GetChildrenByNames([

				"item_gp",
				"effect_gp",
				"item_name",
				"click",
			])
	}
}
window["OutWardExpGoods"] = OutWardExpGoods