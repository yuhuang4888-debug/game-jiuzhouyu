import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { Util } from "../util/Util";



export class RuneAwakeBagItem extends BaseItemRenderer {
	public WIDTH = 97
	public HEIGT = 91

	item: BaseAwardItem
	model = RuneModel.GetInstance()
	public constructor() {
		super()
		this.base_file = "rune"
		this.layout_file = `RuneAwakeBagItem`

		this.Load()
	}

	public load_callback() {
		this.BindEvent(this.model, RuneEvent.SELECT_AWAKE_MAT, (id) => {
			if (!id && this.data) {
				this.selectImg.visible = this.model.awakeSelect[this.data.goods_id]
			}
		})

		Util.AddClickEvent(this.itemGp, () => {
			if (this.data&&!this.data.is_faker) {
				if (this.model.awakeSelect[this.data.goods_id]) {
					delete this.model.awakeSelect[this.data.goods_id]
				} else {
					this.model.awakeSelect[this.data.goods_id] = true
				}
				this.selectImg.visible = this.model.awakeSelect[this.data.goods_id]
				this.model.Fire(RuneEvent.SELECT_AWAKE_MAT, this.data.goods_id)
			}
		}, this, true)



		if (!this.item) {
			this.item = new BaseAwardItem(this.itemGp)
			this.item.Load()
			this.item.SetItemSize(85, 85)
			this.item.SetShowTips(false)
			this.item.SetData()
		}
	}

	public createChildren() {
		super.createChildren()

	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if(!this.item)return

		if (!this.data.is_faker) {
			this.item.SetData(this.data.type_id)
			// this.item.SetItemVisible(true)
			this.selectImg.visible = this.model.awakeSelect[this.data.goods_id]
		} else {
			this.item.SetData(null)
			// this.item.SetItemVisible(false)
			this.selectImg.visible = false
		}

	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.base_item) {
			this.base_item.ClearUIEffect(this.awakeExpGp)
		}
		super.DeleteMe()
	}

	itemGp: Laya.Box
	selectImg: Laya.Image
	awakeExpGp: Laya.Box
	public GetComponents() {
		[
			this.itemGp,
			this.selectImg,
			this.awakeExpGp,
		]
			= this.GetChildrenByNames([

				"itemGp",
				"selectImg",
				"awakeExpGp",
			])
	}
}
window["RuneAwakeBagItem"] = RuneAwakeBagItem