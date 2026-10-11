import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { Util } from "../util/Util"

export class RuneTreasureStageRewardItem extends BaseItem1 {
	InitEvents
	SetData
	public constructor(parent) {
		super(parent)
		this.base_file = "runeTreasure"
		this.layout_file = "RuneTreasureStageRewardItem"

		let model = RuneTreasureModel.GetInstance(),
			data_,
			needRefresh_,
			item_: BaseAwardItem,
			cfg_,
			index_

		this.load_callback = function () {
			this.InitEvents()
		}

		this.DeleteMe = () => {
			this.ClearUIEffect(this.effect_group)
			if (item_) {
				item_.DeleteMe()
				item_ = null
			}
			super.DeleteMe()
		}

		this.InitEvents = () => {
			Util.AddClickEvent(this.click_bg, () => {
				if (data_) {
					model.Fire(RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO, 41607, "h", data_.stage)
				}
			}, this)

			if (needRefresh_) {
				this.SetData(data_, cfg_, index_)
			}
		}

		this.SetData = (data, cfg, index) => {
			data_ = data
			cfg_ = cfg
			index_ = index
			if (this.is_loaded) {
				if (!data_ || !cfg_) {
					return
				}
				let goods_list = JSON.parse(cfg_.reward)
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(goods_list[0][0], goods_list[0][1])
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					// if (item_) {
					// 	item_.DeleteMe()
					// 	item_ = null
					// }
					if (!item_) {
						item_ = new BaseAwardItem(this.conta)
						item_.Load()
						item_.SetItemSize(90, 90)
					}
					this.ClearUIEffect(this.effect_group)
					item_.SetData(type_id, undefined, lock, undefined, undefined, true)
					if (data_.status == 0) {	//不可领取
						this.got_tag.visible = false
						this.click_bg.visible = false
					} else {
						if (data_.status == 1) {
							this.got_tag.visible = false
							this.click_bg.visible = true
							this.AddUIEffect("UI_2033_1", this.effect_group, null, 15, true)
						} else {
							this.got_tag.visible = true
							this.click_bg.visible = false
						}
					}
					this.need_times.text = `${cfg_.draw_time}次`
					this.display_obj.x = index_ * 145 - 45
				}
			} else {
				needRefresh_ = true
			}
		}
	}

	click_bg: Laya.Image
	conta: Laya.Box
	effect_group: Laya.Box
	need_times: Laya.Label
	got_tag: Laya.Image
	public GetComponents() {
		[
			this.click_bg,
			this.conta,
			this.effect_group,
			this.need_times,
			this.got_tag,
		]
			= this.GetChildrenByNames([
				"click_bg",
				"conta",
				"effect_group",
				"need_times",
				"got_tag",
			])
	}
}
window["RuneTreasureStageRewardItem"] = RuneTreasureStageRewardItem