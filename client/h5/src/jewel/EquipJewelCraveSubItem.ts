import { BaseItem1 } from "../common/BaseItem1"
import { EquipmentItem } from "../common/EquipmentItem"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"

export class EquipJewelCraveSubItem extends BaseItem1 {
	goods_model
	equip_data
	goods_item
	reddot_state
	unlock_num
	finish_callback: any

	public constructor(parent?) {
		super(parent)
		this.base_file = "jewel"
		this.layout_file = "EquipJewelCraveSubItem"

		this.goods_model = GoodsModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public DeleteMe() {
		if (this.goods_item) {
			this.goods_item.DeleteMe()
			this.goods_item = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		if (this.equip_data) {
			this.SetData(this.equip_data, this.unlock_num)
		}
		if (this.reddot_state) {
			this.SetRedDot(this.reddot_state)
		}
	}

	public SetData(data?, unlock_num?) {
		this.equip_data = data
		this.unlock_num = unlock_num
		if (this.is_loaded) {
			if (this.equip_data.type_id) {
				let goods_basic = this.goods_model.GetGoodsBasicByTypeId(this.equip_data.type_id)
				this.name_label.text = goods_basic.goods_name
				this.name_label.color = String(ColorUtil.GetColorDark(goods_basic.color)).substring(1, 8)

				if (!this.goods_item) {
					this.goods_item = new EquipmentItem(this.gp_item)
					this.goods_item.SetUseMask(true)
					this.goods_item.Load()
					// this.goods_item.transform.SetSiblingIndex(0)
					//this.goods_item.touchEnabled = false
					//this.item_group.setChildIndex(this.goods_item, 0)
					this.goods_item.SetScale(0.68)
				}
				this.goods_item.SetData(this.equip_data.type_id)
				this.goods_item.SetShowTips(false)
			}
			if (this.equip_data.stone_list) {
				let show_count = this.equip_data.stone_list.length + this.unlock_num
				for (let i = 0; i < 6; i++) {
					if (i < this.equip_data.stone_list.length) {
						let icon = this["_img_" + (i + 1)]
						let imgicon = this["_img_" + (i + 1)]
						let goods_base = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.equip_data.stone_list[i].type_id)
						if (icon && goods_base) {
							icon.visible = true
							icon.includeInLayout = true
							if (goods_base.subtype == 1) {
								ResManager.GetInstance().SetImageSprite(this, imgicon, "jewel_asset", "j1")
							} else if (goods_base.subtype == 2) {
								ResManager.GetInstance().SetImageSprite(this, imgicon, "jewel_asset", "j2")
							}
						}
					} else if (i < show_count) {
						let icon = this["_img_" + (i + 1)]
						let imgicon = this["_img_" + (i + 1)]
						if (icon) {
							icon.visible = true
							icon.includeInLayout = true
							ResManager.GetInstance().SetImageSprite(this, imgicon, "jewel_asset", "j")
						}
					} else {
						let icon = this["_img_" + (i + 1)]
						if (icon) {
							icon.visible = false
							icon.includeInLayout = false
						}
					}
				}
			}
			let crave_data = EquipModel.GetInstance().jewel_crave_data_list[this.equip_data.equip_type]
			if (crave_data) {
				this.level_label.text = "+" + crave_data.refine_lv
			}
			this.red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.JEWEL_CRAVE_RED, this.equip_data.equip_type)

			let equip_stone_refine_limit_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stone_refine_limit", false)
			if (EquipModel.GetInstance().IsOpenCrave(this.equip_data.equip_type, equip_stone_refine_limit_cfg)) {
				this.black_mask.visible = false
				this.lock_label.text = ""
			} else {
				let limit_config = equip_stone_refine_limit_cfg[this.equip_data.equip_type]
				if (limit_config) {
					this.lock_label.text = JSON.parse(limit_config.limit)[0][0] + "阶\n开启雕琢"
				}
				this.black_mask.visible = true
			}
			if (this.finish_callback) {
				this.finish_callback()
				this.finish_callback = undefined
			}
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.item_group, () => {
			if (this.equip_data) {
				EquipModel.GetInstance().Fire(EquipEvent.SELECT_JEWEL_CARVE_GOODS, this.equip_data.equip_type, this.red_dot.visible)
				this.select_img.visible = true
			}
		}, this, true)

		this.BindEvent(EquipModel.GetInstance(), EquipEvent.SELECT_JEWEL_CARVE_GOODS, (equip_type?) => {
			if (equip_type != this.equip_data.equip_type) {
				this.select_img.visible = false
			} else {
				this.select_img.visible = true
			}
		})

		this.BindEvent(EquipModel.GetInstance(), EquipEvent.JEWEL_SEMLT_INFO, (scmd?) => {
			if (this.equip_data && this.equip_data.equip_type == scmd.equip_type) {
				this.level_label.text = "+" + scmd.refine_lv
				let equip_stone_refine_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_stone_refine", false)
				let max = equip_stone_refine_cfg[scmd.equip_type + "@" + (scmd.refine_lv + 1)]
				if (!max) {
					this.red_dot.visible = false
				} else {
					this.red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.JEWEL_CRAVE_RED, scmd.equip_type)
				}
			}
		})

		this.BindEvent(EquipModel.GetInstance(), EquipEvent.UPDATE_JEWEL_CARVE_RED, () => {
			if (this.equip_data) {
				this.red_dot.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.JEWEL_CRAVE_RED, this.equip_data.equip_type)
			}
		})
	}

	public SetRedDot(bool?) {
		this.reddot_state = bool
		if (this.is_loaded) {
			if (bool) {
				this.red_dot.visible = true
			} else {
				this.red_dot.visible = false
			}
		}
	}

	public FinishCallback(func) {
		this.finish_callback = func
	}

	public GetTypeId() {
		if (this.equip_data) {
			return this.equip_data.equip_type
		}
		return 0
	}

	click_group: Laya.Box
	_Image2: Laya.Image
	_Image1: Laya.Image
	name_label: Laya.Label
	item_group: Laya.Box
	gp_item: Laya.Box
	select_img: Laya.Image
	black_mask: Laya.Image
	lock_label: Laya.Label
	level_label: Laya.Label
	jewel_icon_group: Laya.HBox
	_img_1: Laya.Image
	_img_2: Laya.Image
	_img_3: Laya.Image
	_img_4: Laya.Image
	_img_5: Laya.Image
	_img_6: Laya.Image
	red_dot: Laya.Image
	public GetComponents() {
		[
			this.click_group,
			this._Image2,
			this._Image1,
			this.name_label,
			this.item_group,
			this.gp_item,
			this.select_img,
			this.black_mask,
			this.lock_label,
			this.level_label,
			this.jewel_icon_group,
			this._img_1,
			this._img_2,
			this._img_3,
			this._img_4,
			this._img_5,
			this._img_6,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"click_group",
				"_Image2",
				"_Image1",
				"name_label",
				"item_group",
				"gp_item",
				"select_img",
				"black_mask",
				"lock_label",
				"level_label",
				"jewel_icon_group",
				"_img_1",
				"_img_2",
				"_img_3",
				"_img_4",
				"_img_5",
				"_img_6",
				"red_dot",
			])
	}
}
window["EquipJewelCraveSubItem"] = EquipJewelCraveSubItem