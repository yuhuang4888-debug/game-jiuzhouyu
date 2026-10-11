import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { EquipModel } from "../commonModel/EquipModel"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { ModuleType } from "../common/RedDotManager"
import { GodBefallModel } from "../commonModel/GodBefallModel"

export class GodBefallBagItem extends BaseItemRenderer {
	WIDTH = 85
	HEIGT = 85

	_item
	_model
	need_refresh = false

	public constructor(parent) {
		super()
		this.base_file = "godBefall"
		this.layout_file = "GodBefallBagItem"

		this._model = GodBefallModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			//this:LoadSuccess()
			if(this.need_refresh){
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public InitEvent() {
		if (!this._item) {
			this._item = new EquipmentItem(this._gp_item, null, "Activity")
			this._item.SetUseMask(true)
			this._item.Load()
			this._item.SetItemSize(85, 85)
		}
		this._img_bg.visible = false
		this._gp_item.visible = true
	}

	public dataChanged() {
		let data = this.data
		if (!data) { return }
		if(!this.is_loaded){
			this.need_refresh = true
			return
		}

		this._item.SetData(data.type_id, data.goods_num, data.bind)
		this._item.SetClickCallBack(() => {
			UIToolTipMgr.GetInstance().AppendGodEquipTips(data.type_id, data, [2, 5])
		})

		let edata1 = EquipModel.GetInstance().GetEquipData(data.type_id)
		let edata4 = this._model.GetEquipData(data.type_id)
		let vo = this._model.GetGodVoInDic(data._god_id)
		let gdata = this._model.GetGodData(data._god_id)
		let same_color = gdata.color == edata4.limit
		let can_star = this._model.GetRedStatus(ModuleType.GOD_STAR, data._god_id)
		if (((vo && vo.equip_dic) && same_color) && !can_star) {
			let edata2 = vo.equip_dic[data.subtype]
			if (edata2) {
				let info = this._model.GetEquipInfo(edata2.goods_id)
				if (info) {
					let edata3 = EquipModel.GetInstance().GetEquipData(info.type_id)
					this._img_up.visible = edata1.base_rating > edata3.base_rating
				}
			} else {
				this._img_up.visible = true
			}
		} else {
			this._img_up.visible = false
		}
	}

	_img_bg: Laya.Image
	_gp_item: Laya.Box
	_img_icon: Laya.Image
	_img_lock: Laya.Image
	_img_up: Laya.Image
	_reddot: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._gp_item,
			this._img_icon,
			this._img_lock,
			this._img_up,
			this._reddot,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_gp_item",
				"_img_icon",
				"_img_lock",
				"_img_up",
				"_reddot",
			])
	}
}
window["GodBefallBagItem"] = GodBefallBagItem