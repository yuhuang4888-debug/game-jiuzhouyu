import { BaseView1 } from "../common/BaseView1"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { ArmorModel } from "../commonModel/ArmorModel"
import { ArmorAttrItem } from "./ArmorAttrItem"

export class ArmorAttrView extends BaseView1 {
	attr_items
	model
	res_mgr
	armour_cfg
	suit_cfg

	public constructor() {
		super()
		this.base_file = "equipArmor"
		this.layout_file = "ArmorAttrView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.background_alpha = 0.5
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		this.model = ArmorModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.attr_items = []

		this.load_callback = () => {
			this.armour_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_armour_equipment", false)
			this.suit_cfg = this.res_mgr.GetGameConfigFromCache(this, "config_armour_suit", false)
			
			this._gp_attr.vScrollBar.visible = false
		}

		this.open_callback = () => {
			this.InitView()
		}
		
		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {
		if (this.attr_items) {
			for (let i in this.attr_items) {
				let vo = this.attr_items[i]
				vo.DeleteMe()
			}
			this.attr_items = []
		}
	}

	public InitView() {
		let attr_list = this.model.GetAllAttrList(this.suit_cfg, this.armour_cfg)
		let item = null
		for (let i in attr_list) {
			let vo = attr_list[i]
			item = new ArmorAttrItem(this.Content)
			item.Load()
			item.SetData(vo, 3)
			table.insert(this.attr_items, item)
		}
		this._gp_none.visible = Util.IsTableEmpty(attr_list)
	}

	_img_bg: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_gp_attr: Laya.Panel
	Content: Laya.VBox
	_gp_none: Laya.Box
	_lb_none: Laya.Label
	_img_none: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._lb_title,
			this._gp_attr,
			this.Content,
			this._gp_none,
			this._lb_none,
			this._img_none,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_title",
				"_lb_title",
				"_gp_attr",
				"Content",
				"_gp_none",
				"_lb_none",
				"_img_none",
			])
	}
}
window["ArmorAttrView"] = ArmorAttrView