import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SetAnchoredPositionX, Util } from "../util/Util"

export class MoneyTreeShopItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_Image2: Laya.Image
	name_label: Laya.HTMLDivElement
	_Group1: Laya.VBox
	score_label: Laya.HTMLDivElement
	_num: Laya.HTMLDivElement
	item_group: Laya.Box
	select_img: Laya.Image
	rare_img: Laya.Image

	item

	public static width = 298
	public static height = 116
	public constructor(parent) {
		super()
		this.WIDTH=298
		this.HEIGT=116
		this.base_file = "moneyTree"
		this.layout_file = "MoneyTreeShopItem"
		this.load_callback = () => {

			//this:InitEvent()

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.name_label.size  = 18
			// 	this.score_label.size  = 18
			// 	SetAnchoredPositionX(this._Group1,117)
			// }
		}
		this.Load()
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		let local_gmodel = GoodsModel.GetInstance()
		let data = this.data
		let model = CustomActivityModel.GetInstance()
		let base_type = data.base_type
		let sub_type = data.sub_type
		this.select_img.visible = this.selected
		if (data) {
			if (!this.item) {
				this.item = new BaseAwardItem(this.item_group, null, Enum_UILayer.Activity)
				this.item.Load()
				this.item.SetScale(0.7)
				this.item.SetUseMask(true)
			}
			let reward = model.GetActReward(base_type, sub_type, data.form_type, data.reward)
			if (reward && reward[0]) {
				let [type_id, lock] = local_gmodel.GetMappingTypeId(reward[0][0], reward[0][1])
				if (type_id) {
					this.item.SetData(type_id, reward[0][2])
					this.name_label.innerHTML = Util.StrToHTML(GoodsModel.GetGoodsNameWithColorDark(type_id))
					this.name_label.x=this._Image2.width/2-this.name_label.contextWidth/2
					this.name_label.y=this._Image2.height/2-this.name_label.contextHeight/2
				}
			}
			let cond = model.GetActCondition(base_type, sub_type, "data", data.grade)
			if (cond) {
				let cost = cond["cost"] && cond["cost"][0]
				if (!cost) {
					return
				}
				let need_score = Number(cost[2])
				let color = (data.currency && need_score <= data.currency) && "'#359700'" || "'#ff4f50'"
				this.score_label.innerHTML = Util.StrToHTML("所需积分:<font color=" + color + ">" + need_score + "</font>")
				let max_num = Number(cond["exchange_num"])
				let bool = max_num && max_num > 0
				//this._num.includeInLayout = bool
				this._num.visible = bool
				if (bool) {
					let left_num = data.receive_times
					let color1 = left_num < max_num && "'#639c12'" || "'#ff4f50'"
					this._num.innerHTML = Util.StrToHTML("兑换次数:<font color=" + color1 + ">" + left_num + "/" + max_num + "</font>")
				}
			}
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
			this._Image1,
			this._Image2,
			this.name_label,
			this._Group1,
			this.score_label,
			this._num,
			this.item_group,
			this.select_img,
			this.rare_img,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"name_label",
				"_Group1",
				"score_label",
				"_num",
				"item_group",
				"select_img",
				"rare_img",
			])
		this.name_label.style.fontSize=20
		this.name_label.style.color="#ffffff"
		this.name_label.style.wordWrap=false
		this.score_label.style.fontSize=20
		this.score_label.style.color="#774239"
		this.score_label.style.wordWrap=false
		this._num.style.fontSize=20
		this._num.style.color="#93847d"
		this._num.style.wordWrap=false
	}
}
window["MoneyTreeShopItem"]=MoneyTreeShopItem