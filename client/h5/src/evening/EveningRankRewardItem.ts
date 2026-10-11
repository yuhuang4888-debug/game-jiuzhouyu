import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { ErlangParser } from "../util/ErlangParser"

export class EveningRankRewardItem extends BaseItemRenderer {
	_group_item
	item_list
	model
	parent_mask_corners

	public WIDTH = 535
	public HEIGT = 120
	is_set
	public constructor(parent) {
		super()
		this.is_set = false
		this.item_list = [];
		this.base_file = "evening"
		this.layout_file = "EveningRankRewardItem"
		this.model = GuildActivityModel.GetInstance()
		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin=""
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
		let reward_list = JSON.parse(this.data.reward_list)
		let i = 0
		do {
			let info = reward_list[i]
			let item = this.item_list[i]
			if (!item) {
				item = new BaseAwardItem(this.Content)
				item.Load()
				this.item_list[i] = item
			}
			let type_id, lock 
			[type_id, lock ]= GoodsModel.GetInstance().GetMappingTypeId(info[0], info[1])
			let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			item.SetData(type_id, info[2])
			i = i + 1
		} while ((i < reward_list.length)
		)

		let str_list = ["a", "b", "c"]
		let is_show = this.data.rank < 4 && this.data.max_rank == this.data.rank
		this._img_rank.visible = is_show
		this._lb_rank.visible = !is_show
		if (is_show) {
			 let str = str_list[this.data.rank - 1]
			ResManager.GetInstance().SetImageSprite(this, this._img_rank, "evening_asset", "ui_phb_1" + str )
		} else {
			let str = this.data.rank + (" - ") + this.data.max_rank
			this._lb_rank.text = str
		}
	}


	public DeleteMe() {
		for (let _tmpi in this.item_list) {
			this.item_list[_tmpi].DeleteMe()
		}
		this.item_list = []
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_Group1: Laya.Box
	_img_rank: Laya.Image
	_lb_rank: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	public GetComponents() {
		[
			this._Image1,
			this._Group1,
			this._img_rank,
			this._lb_rank,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Group1",
				"_img_rank",
				"_lb_rank",
				"_Scroller1",
				"Content",
			])
	}
}

window["EveningRankRewardItem"] = EveningRankRewardItem