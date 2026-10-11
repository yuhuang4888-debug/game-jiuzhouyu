import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { Config } from "../common/Config";
import { ResManager } from "../common/ResManager";
import { DemonModel } from "../commonModel/DemonModel";

export class DemonTalentSelectItem extends BaseItemRenderer {
	_gp_item: Laya.Box
	_gp_effect: Laya.Box
	_gp_select: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_red_dot: Laya.Image


	_item
	demon_model: DemonModel

	// public static height = 80 + 2
	// public static width = 80 + 2
	public constructor() {
		super()

		// this.skinName = "resource/game/demon/exml/DemonTalentSelectItemExml.exml";
		this.base_file = "demon"
		this.layout_file = "DemonTalentSelectItem"
		this.demon_model = DemonModel.GetInstance()
		this.Load()
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		// this.ClearUIEffect(this._gp_effect)
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}

		this._gp_select.visible = this.selected

		if (!this._item) {
			this._item = new BaseAwardItem(this._gp_item)
			this._item.SetShowTips(false)
			this._item.Load()
			// this._item.SetMaskId(1)
			this._item.SetScale(0.62)
			this._item.touchEnabled = false;
			this._item.touchChildren = false;
		}

		let max = false

		if (this.data) {
			this._item.SetData(this.data.type_id, this.data.goods_num)

			//let need_count = 0

			let demon_data = this.demon_model.select_demon_data
			let slot = this.demon_model.select_slot
			if (demon_data) {
				let demons_skill_add_cfgs = ResManager.GetInstance().GetGameConfigFromCache(ResManager.GetInstance(), "config_demons_skill_add", false)
				this._red_dot.visible = this.demon_model.TalentSelectRedDot(this.data.type_id,slot,demon_data.demon_id,demons_skill_add_cfgs,true)
			}
		}
		this.SetGray(max)
	}
	public SetGray(bool?) {
		this._item.SetGary(bool)
	}

	public GetComponents() {
		[
			this._gp_item,
			this._gp_effect,
			this._gp_select,
			this._Image1,
			this._Image2,
			this._red_dot,
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_gp_effect",
				"_gp_select",
				"_Image1",
				"_Image2",
				"_red_dot",
			])
	}
}
window["DemonTalentSelectItem"]=DemonTalentSelectItem