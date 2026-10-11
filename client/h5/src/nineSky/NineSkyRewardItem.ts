import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { GameResPath } from "../util/GameResPath"

export class NineSkyRewardItem extends BaseItem1 {


	item_list
	vo
	model: NineSkyModel
	need_refresh_data
	public constructor(parent) {
		super(parent)
		this.base_file = "nineSky"
		this.layout_file = "NineSkyRewardItem"
		this.model = NineSkyModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this._html_desc.style.color = "#663915"
		this._html_desc.style.fontSize = 22
		this._html_desc.style.wordWrap = false
		
		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateItem()
		}
	}

	public SetData(vo?) {
		this.vo = vo
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {
		if (this.vo) {
			this._html_desc.innerHTML = this.vo.desc
			let len = this.vo.reward.length
			if (!this.item_list) {
				this.item_list = []
			}
			let i = len
			if (i < this.item_list.length) {
				do {
					this.item_list[i].SetVisible(false)
					i = i + 1
				} while ((i < this.item_list.length))
			}

			if (len > 0) {
				for (let key in this.vo.reward) {
					let item = this.item_list[key]
					if (!item) {
						item = new BaseAwardItem(this._panel_reward)
						this.item_list[key] = item
						item.SetItemSize(85, 85)
						item.Load()
					}

					let vo = this.vo.reward[key]
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
					let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						item.SetData(goods_vo.type_id, vo[2], lock)
					}
					item.SetPosition(90 * Number(key), 0)
					item.SetVisible(true)
				}
			}
			this._img_get.visible = this.vo.is_get
		}
	}

	public DeleteMe() {
		if (this.item_list) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
		}
		this.item_list = null
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_img_get: Laya.Image
	_html_desc: Laya.HTMLDivElement
	_panel_reward: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_get,
			this._html_desc,
			this._panel_reward,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_get",
				"_html_desc",
				"_panel_reward",
			])
	}
}
window["NineSkyRewardItem"] = NineSkyRewardItem