import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"

export class DungeonPolarRewardItem extends BaseItemRenderer {

	_model
	_reward_list

	public WIDTH = 615
	public HEIGT = 124
	public constructor(parent) {
		super()

		this._reward_list = []
		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarRewardItem"
		this.load_callback = () => {
		}
		this.Load()
	}

	public createChildren() {

		this._model = BaseDungeonModel.GetInstance()
	}

	public DeleteMe() {

		for (let key in this._reward_list) {

			let item = this._reward_list[key]
			item.DeleteMe()
		}
		this._reward_list = []
		super.DeleteMe()
	}

	public dataChanged() {
		if(!super.dataChanged())return
		if (this._reward_list && this._reward_list.length > 0) {
			for (let i = 0; i < this._reward_list.length; i++) {
				this._reward_list[i].SetVisible(false)
			}
		}


		this._lb_name.text = this.data.boss_name
		this._icon.visible = !this._model.rewardHasGet(this.data.dun_id, this.data.boss_id)
		this._icon_get.visible = !this._icon.visible
		let reward_list = JSON.parse(this.data.rewards_view)
		let index = 0
		for (let key in reward_list) {

			let vo = reward_list[key]
			let item: BaseAwardItem = this._reward_list[index]
			if (!item) {
				item = new BaseAwardItem(this.Content)
				
				item.Load()
				table.insert(this._reward_list, item)
			}
			item.ExcuteCallback(() => {
				item.SetVisible(true)
				item.SetItemSize(99,99)
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					item.SetData(goods_vo.type_id, vo[2])
				}
			}
			)
			index = index + 1
		}

	}



_bg:Laya.Image
_Image1_1:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.HBox
_lb_name:Laya.Label
_icon:Laya.Image
_icon_get:Laya.Image
public GetComponents() {
[
this._bg,
this._Image1_1,
this._Scroller1,
this.Content,
this._lb_name,
this._icon,
this._icon_get,
]
 = this.GetChildrenByNames([

"_bg",
"_Image1_1",
"_Scroller1",
"Content",
"_lb_name",
"_icon",
"_icon_get",
])
}
}
 window["DungeonPolarRewardItem"]= DungeonPolarRewardItem