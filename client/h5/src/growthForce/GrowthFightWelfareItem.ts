
import { BaseItem1 } from "../common/BaseItem1"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { table } from "../common/table"

export class GrowthFightWelfareItem extends BaseItem1 {

	InitEvent
	SetData
	data
	need_fresh
	stageItem
	SetSelete
	is_receive
	SetReceive
	PlayAnimation
	ClearTweenIds
	tween_ids
	public constructor(p) {
		super(p)
		this.base_file = "growthForce"
		this.layout_file = "GrowthFightWelfareItem"
		this.need_fresh = false
		this.is_receive = false
		this.tween_ids = []
		this.load_callback = () => {
			this.InitEvent()
			if (this.need_fresh) {
				this.SetData(this.data)
				this.SetReceive(this.is_receive)
			}
		}


		this.InitEvent = () => {

		}




		this.SetData = (data) => {
			this.data = data
			if (this.is_loaded) {
				if (!this.stageItem) {
					this.stageItem = new BaseAwardItem(this._box_item)
					this.stageItem.Load()
					this.stageItem.SetItemSize(90, 90)
				}

				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data[0], this.data[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					this.stageItem.SetData(goods_vo.type_id, this.data[2], lock)
				}
			} else {
				this.need_fresh = true
			}

		}

		this.SetSelete = () => {

		}

		this.SetReceive = (boo) => {
			this.is_receive = boo
			if (this.is_loaded) {
				this._img.visible = boo
			}
		}


		this.PlayAnimation = () => {
			if(!this.is_loaded)return
			this.ClearTweenIds()
			this._box_item.scale(1, 1)
			let scale1=1.1
			let time1=0.15
			let id = SYTweenLite.to(this, this._box_item, SYTweenLite.UiAnimationType.SCALE,
				{ x: scale1, y: scale1, z: scale1 }, time1, () => {
					// let id2 = SYTweenLite.to(this, this._box_item, SYTweenLite.UiAnimationType.SCALE,
					// 	{ x: 1, y: 1, z: 1 }, time1, null, SYTweenFunc.EASE_IN, false)
					this._box_item.scale(1, 1)
				}, SYTweenFunc.EASE_IN, false)
			table.insert(this.tween_ids, id)

		}

		this.ClearTweenIds = () => {
			for (let i = 0; i < this.tween_ids.length; i++) {
				SYTweenLite.Stop(this.tween_ids[i])
			}
		}

	}

	

	public DeleteMe(): void {
		this.ClearTweenIds()
		if (this.stageItem) {
			this.stageItem.DeleteMe()
			this.stageItem = null
		}
		super.DeleteMe()
	}




	_box_item: Laya.Box
	_img: Laya.Image
	public GetComponents() {
		[
			this._box_item,
			this._img,
		]
			= this.GetChildrenByNames([

				"_box_item",
				"_img",
			])
	}
}
window["GrowthFightWelfareItem"] = GrowthFightWelfareItem