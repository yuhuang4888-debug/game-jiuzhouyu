import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { EquipModel } from "../commonModel/EquipModel"
import { TimeUtil } from "../util/TimeUtil"
export class MarketRecordItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_group_item: Laya.Box
	_lb_name: Laya.Label
	_lb_stage: Laya.Label
	_lb_type: Laya.Label
	_lb_time: Laya.Label
	_Group1: Laya.VBox
	_group_out: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_lb_out: Laya.Label
	_group_in: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	_lb_in: Laya.Label
	_group_tax: Laya.Box
	_Image4: Laya.Image
	_Label3: Laya.Label
	_lb_tax: Laya.Label

	item
	public static width = 698
	public static height = 145
	public constructor(parent) {
		super()
		this.base_file = "market"
		this.layout_file = "MarketRecordItem"

		this.Load()
		this.load_callback = () => {

		}


		// this.load_callback = () => {


		// }

	}
	public createChildren() {
		super.createChildren()
		this.item = new EquipmentItem(this._group_item)
		this.item.SetItemSize(119, 119)
		this.item.Load()
	}

	public dataChanged() {

		let data = this.data
		this.item.SetData(data.type_id, data.goods_num)
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.type_id)
		this._lb_name.text = basic.goods_name
		let equip_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "Equipattr", false)
		// [ts2lua]lua中0和空字符串也是true，此处basic.type == 10需要确认
		this._lb_stage.text = basic.type == 10 && EquipModel.GetInstance().GetStageByTypeId(data.type_id, equip_attr_cfg) + "阶" || ""
		this._lb_time.text = TimeUtil.timeConversion(data.time, "yyyy/mm/dd hh.MM:ss")
		this._lb_type.text = this.GetTypeStr(data.type)
		let is_in = data.type == 1
		this.SetGroupVisible(this._group_in, is_in)
		this.SetGroupVisible(this._group_tax, is_in)
		this.SetGroupVisible(this._group_out, !is_in)
		this._lb_in.text = "+" + data.price
		this._lb_out.text = "-" + ((data.price + data.tax))
		this._lb_tax.text = "-" + data.tax
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}

	public SetGroupVisible(group?, visible?) {

		group.visible = visible
	}

	public GetTypeStr(type?) {

		if (type == 1) {
			return "出售"
		} else if (type == 2) {
			return "购买"
		} else if (type == 3) {
			return "购买"
		}
	}



	public GetComponents() {
		[
			this._Image1,
			this._group_item,
			this._lb_name,
			this._lb_stage,
			this._lb_type,
			this._lb_time,
			this._Group1,
			this._group_out,
			this._Image2,
			this._Label1,
			this._lb_out,
			this._group_in,
			this._Image3,
			this._Label2,
			this._lb_in,
			this._group_tax,
			this._Image4,
			this._Label3,
			this._lb_tax,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_group_item",
				"_lb_name",
				"_lb_stage",
				"_lb_type",
				"_lb_time",
				"_Group1",
				"_group_out",
				"_Image2",
				"_Label1",
				"_lb_out",
				"_group_in",
				"_Image3",
				"_Label2",
				"_lb_in",
				"_group_tax",
				"_Image4",
				"_Label3",
				"_lb_tax",
			])
	}
}

window["MarketRecordItem"] = MarketRecordItem