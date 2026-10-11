import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { EquipRefiUpTabItem } from "./EquipRefiUpTabItem"
import { ResManager } from "../common/ResManager"

export class EquipRefiUpLvView extends BaseView1 {
	CloseFunc
	InitView
	LoadCallback
	Open
	RefView
	_gp_add_attr
	_gp_extra_attr
	item_list = []
	_img_1

	sort_layer

	public constructor() {
		super()
		this.base_file = "equipRefinement"
		this.layout_file = "EquipRefiUpLvView"
		this.use_background = true
		this.is_center = true
		this.show_open_movie = true
		this.click_bg_toClose = true
		this.layer_value = Enum_UILayer.Activity

		let cfg = null
		let equip = null
		let extra_attr_item = null
		let now_lv_item = null
		let equip_item = null

		this.load_callback = () => {
			this.LoadCallback()
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.CloseFunc()
		}

		this.InitView = () => {
			if (!equip) {
				return
			}

			this.refText.text = "神炼+" + equip.refinement_lv

			let showCount = equip.equip_extra_attr.length
			let index = 0
			for (let i = 0; i < showCount; i++) {
				let vo = equip.equip_extra_attr[i]
				if (vo.color > 3) {
					let item = this.item_list[index]
					if (!item) {
						item = new EquipRefiUpTabItem(this.itemGp)
						item.Load()
						this.item_list[index] = item
					}
					item.SetData(equip.equip_extra_attr[i], equip.equip_type, equip.refinement_lv)
					index += 1
				}
			}
			/*
			if (!extra_attr_item) {
				extra_attr_item = new EquipRefiAttrsItem(this._gp_extra_attr)
				extra_attr_item.Load()
			}
			extra_attr_item.ExcuteCallback(() => {
				extra_attr_item.SetData(1, equip, null, true)
			}
			)
			if (!now_lv_item) {
				now_lv_item = new EquipRefiAttrsItem(this._gp_add_attr)
				now_lv_item.Load()
			}
			now_lv_item.ExcuteCallback(() => {
				now_lv_item.SetData(2, equip, null, true)
				this.RefView()
			})
			*/

			if (!equip_item) {
				equip_item = new EquipmentItem(this._gp_equip, null, "Activity")
				equip_item.Load()
				equip_item.SetItemSize(97, 97)
				equip_item.SetClickCallBack(() => {
					let goodsVo = GoodsModel.GetInstance().GetEquipById(equip.goods_id)
					if (goodsVo) {
						UIToolTipMgr.GetInstance().AppendEquipTips(equip.type_id, null, null, goodsVo, null, [1])
					}
				}
				)
			}
			equip_item.ExcuteCallback(() => {
				equip_item.SetData(equip.type_id, null, null, null, null, null, null, equip.equip_extra_attr, equip.goods_id)
			})
			/*
			this.AddUIEffect("UI_1103_shenliantisheng", "Activity", this._gp_guaoxiao, null, null, false)
			this.sort_layer = this.AddCurrLayerSortingOrder("Activity")
			this.CoverEffect(this._img_0, "Activity", this.sort_layer)
			this.CoverEffect(this._img_1, "Activity", this.sort_layer)
			this.CoverEffect(this._Image1, "Activity", this.sort_layer)
			this.CoverEffect(this._gp_extra_attr, "Activity", this.sort_layer)
			this.CoverEffect(this._gp_add_attr, "Activity", this.sort_layer)
			this.CoverEffect(this._gp_equip, "Activity", this.sort_layer)
			*/
		}

		/*
		this.RefView = () => {
			let attr_height = 64 + showCount * 36
			SetSizeDeltaY(this._img_1, 175 + attr_height)
			SetSizeDeltaY(this._img_0, 175 + attr_height)
			SetAnchoredPositionY(this._lb_desc, -257 - attr_height)
		}
		*/

		this.LoadCallback = () => {
			//let setImg = (com?, res?) => {
			//if (com && res ) {
			//lua_resM:SetOutsideImageSprite(this, com, "resource/game/common4/texture/" + res)
			//}
			//}
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_0, GameResPath.GetIcon("common4", "uijs_062"))
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_1, GameResPath.GetIcon("common4", "uijs_062"))
			//setImg(this._img_0, "uijs_062.png")
			//setImg(this._img_1, "uijs_062.png")
			//cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refinement", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_0, "resource/game/equipRefinement/other/up_bg.png")
		}

		this.Open = (...new_args) => {
			equip = new_args[0]
			super.Open()
		}

		this.CloseFunc = () => {
			/*
			if (extra_attr_item) {
				extra_attr_item.DeleteMe()
				extra_attr_item = null
			}
			if (now_lv_item) {
				now_lv_item.DeleteMe()
				now_lv_item = null
			}
			*/

			for (let vo of this.item_list) {
				vo.DeleteMe()
			}
			this.item_list = []

			if (equip_item) {
				equip_item.DeleteMe()
				equip_item = null
			}
			EquipModel.GetInstance().Fire(EquipEvent.CLOSE_REFIUP_VIEW)
		}
	}

	gp_con: Laya.Box
	_gp_guaoxiao: Laya.Box
	_img_0: Laya.Image
	_Image1: Laya.Image
	_Image0: Laya.Image
	_Image2: Laya.Image
	itemGp: Laya.VBox
	_lb_desc: Laya.Label
	_gp_equip: Laya.Box
	_Label1: Laya.Label
	refText: Laya.Label
	public GetComponents() {
		[
			this.gp_con,
			this._gp_guaoxiao,
			this._img_0,
			this._Image1,
			this._Image0,
			this._Image2,
			this.itemGp,
			this._lb_desc,
			this._gp_equip,
			this._Label1,
			this.refText,
		]
			= this.GetChildrenByNames([
				"gp_con",
				"_gp_guaoxiao",
				"_img_0",
				"_Image1",
				"_Image0",
				"_Image2",
				"itemGp",
				"_lb_desc",
				"_gp_equip",
				"_Label1",
				"refText",
			])
	}
}
window["EquipRefiUpLvView"] = EquipRefiUpLvView