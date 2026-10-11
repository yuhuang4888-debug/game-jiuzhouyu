import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActivityModel, GuildActEvent } from "../commonModel/GuildActivityModel"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class EveningDragonCallItem extends BaseItemRenderer {
	_item
	model

	public WIDTH = 195
	public HEIGT = 97
	is_set

	public constructor(parent) {
		super()
		this.is_set = false
		this.base_file = "evening"
		this.layout_file = "EveningDragonCallItem"
		this.model = GuildActivityModel.GetInstance()

		this.load_callback = () => {
			this._item = new BaseAwardItem(this._gp_item)
			this._item.Load()
			this._item.SetItemSize(77, 77)
			Util.AddClickEvent(this._btn_use, () => {
				this.model.Fire(GuildActEvent.REQUEST_PROTO, 40263, "c", this.data[0])
			}
				, this, true)
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in goods_list) {
					var info = goods_list[_tmpi]
					if (info.type_id == Number(this.data[1])) {
						this.dataChanged()
						break
					}
				}
			}
			)


			if (!this.is_set) {
				this.SetData()
				this.is_set = true
			}
		}


		this.Load()
	}


	public dataChanged() {

		if (! super.dataChanged()) {
			return
		}

		if (this.is_loaded) {
			this.SetData()
			this.is_set = true
		} else {
			this.is_set = false
		}

	}


	SetData() {
		if (!this.data) return
		let data = this.data
		let type_id = data[1]
		let own = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
		// [ts2lua]lua中0和空字符串也是true，此处own > 0需要确认
		let color = (own > 0 && (Enum_ColorUtil_Light.GREEN) || (Enum_ColorUtil_Light.RED))
		this._item.SetData(type_id)
		// this._item.ForceSetNumberInFlow(ColorTxtToHTML(own, color))
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
		let name = GoodsModel.GetGoodsNameWithColorDark(type_id)
		this._lb_name.text =`${name}`
		this._reddot.visible = own > 0
	}

	public DeleteMe() {
		if(this._item ){
			this._item.DeleteMe()
			this._item =null
		}
		super.DeleteMe()
	}

	_Image11: Laya.Image
	_gp_item: Laya.Box
	_lb_name: Laya.Label
	_btn_use: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_reddot: Laya.Image
	public GetComponents() {
		[
			this._Image11,
			this._gp_item,
			this._lb_name,
			this._btn_use,
			this._Image1,
			this.labelDisplay,
			this._reddot,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_gp_item",
				"_lb_name",
				"_btn_use",
				"_Image1",
				"labelDisplay",
				"_reddot",
			])
	}
}

window["EveningDragonCallItem"] = EveningDragonCallItem