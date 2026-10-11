import { EquipmentItem } from "../common/EquipmentItem"
import { CompositeModel } from "../commonModel/CompositeModel"
import { BaseAwardItem } from "../common/BaseAwardItem"

export class SelectMatItem extends EquipmentItem {
	_god_icon
	_grade
	grade_color_cache
	grade_out_line
	grade_out_line_color_cache
	star_list
	stren_txt_y_cahe
	touchEnabled
	cache_goodsId

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "SelectMatItem"
		//this.layer_value = Enum_UILayer.Activity
		this.touchEnabled = false
	}

	public LoadSuccess() {
		super.LoadSuccess()
		if (this.cache_goodsId) {
			this.setImgVisible(this.cache_goodsId)
			this.cache_goodsId = null
		}
	}

	public setImgVisible(goods_id?) {
		if (!this.is_loaded) {
			this.cache_goodsId = goods_id
			return
		}
		this._img.visible = CompositeModel.GetInstance().checkWearEquip(goods_id)
	}

	/*
	public LoadSuccess() {
		/*
		this.grade = this.GetChild("click_group/grade").GetComponent("Text")
		this.grade_out_line = this.GetChild("click_group/grade").GetComponent("Outline")
		this.grade_color_cache = this.grade.color
		this.grade_out_line_color_cache = this.grade_out_line.effectColor
		this._grade = this.GetChild("click_group/grade")
		this.stren = this.GetChild("click_group/stren").GetComponent("Text")
		this.star_group = this.GetChild("click_group/star_group")
		this._img_grade_bg = this.GetChild("click_group/_img_grade_bg")
		this.select_image = this.GetChild("click_group/select_image").gameObject
		this._bad_icon = this.GetChild("click_group/_bad_icon").gameObject
		this._god_icon = this.GetChild("click_group/god_icon").GetComponent("Image")
		this.item_bg = this.GetChild("click_group/item_bg").GetComponent("Image")
		this._img_tips = this.GetChild("click_group/_img_tips").GetComponent("Image")
		*/
	/*
			this._god_icon.visible = false
			this.stren_txt_y_cahe = this.stren.y
			this.star_list = []
			let i = 0
			do {
				this.star_list[i] = this["star_" + i]
				i = i + 1
			} while ((i < 4))
			BaseAwardItem.LoadSuccess()
		}
		*/

	click_group: Laya.Box
	item_bg: Laya.Image
	icon: Laya.Image
	num_text: Laya.HTMLDivElement
	lock: Laya.Image
	star_group: Laya.VBox
	star_4: Laya.Image
	star_0: Laya.Image
	star_1: Laya.Image
	star_2: Laya.Image
	select_image: Laya.Image
	stren: Laya.Label
	_img_grade_bg: Laya.Image
	grade: Laya.Label
	red_dot: Laya.Image
	_img: Laya.Image
	_bad_icon: Laya.Image
	god_icon: Laya.Image
	_img_tips: Laya.Image
	effect_con: Laya.Box
	public GetComponents() {
		[
			this.click_group,
			this.item_bg,
			this.icon,
			this.num_text,
			this.lock,
			this.star_group,
			this.star_4,
			this.star_0,
			this.star_1,
			this.star_2,
			this.select_image,
			this.stren,
			this._img_grade_bg,
			this.grade,
			this.red_dot,
			this._img,
			this._bad_icon,
			this.god_icon,
			this._img_tips,
			this.effect_con,
		]
			= this.GetChildrenByNames([

				"click_group",
				"item_bg",
				"icon",
				"num_text",
				"lock",
				"star_group",
				"star_4",
				"star_0",
				"star_1",
				"star_2",
				"select_image",
				"stren",
				"_img_grade_bg",
				"grade",
				"red_dot",
				"_img",
				"_bad_icon",
				"god_icon",
				"_img_tips",
				"effect_con",
			])
	}
}
window["SelectMatItem"] = SelectMatItem