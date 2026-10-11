import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { BaseItem1 } from "./BaseItem1"
import { EquipmentItem } from "./EquipmentItem"

export class RewardPreItem extends BaseItem1 {
	private _item: EquipmentItem;
	private basic
	private no_name
	private type_id
	private count
	private visible
	private scaleX
	private scaleY

	public constructor(parent?) {
		super(parent)

		this.base_file = "common"
		this.layout_file = "RewardPreItem"
		this.is_delay_callback = false

		this.scaleX = 1;
		this.scaleY = 1;
		this.visible = true

		this.load_callback = () => {
			this.display_obj.visible = this.visible
			this.display_obj.scaleX = this.scaleX
			this.display_obj.scaleY = this.scaleY
			if (this.basic) {
				var textColor = ColorUtil.GetColorDark(this.basic.color)
				this._lb_name.color = ColorUtil.GetReplaceChar(textColor)
				this._lb_name.text = this.basic.goods_name
				this._lb_name.visible = !this.no_name
			}
			//equipmentitem 先注释掉
			this._item = new EquipmentItem(this.con, null, this.layer_value)
			this._item.Load()
			this._item.ExcuteCallback(() => {

				this._item.SetData(this.type_id, this.count)
				this._item.SetScale(0.7)
				this.con.x = (this.display_obj.width - this.display_obj.width * 0.7) / 2
			})

			// this._item.load_callback = () => {

			// }
			//
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_name.size = 18
			// }
		}
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public SetData(type_id?, count?, no_name?) {

		if (no_name == null) {
			no_name = false
		}
		this.basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		this.no_name = no_name
		this.type_id = type_id
		this.count = count;
	}

	public SetScaleX(scale) {
		this.scaleX = scale
	}

	public SetScaleY(scale) {
		this.scaleY = scale
	}

	public SetVisible(bool) {
		this.visible = bool;
	}


	con: Laya.Box
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this.con,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"con",
				"_lb_name",
			])
	}
}
window["RewardPreItem"] = RewardPreItem