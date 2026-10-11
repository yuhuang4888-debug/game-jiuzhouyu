import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipEvent } from "../commonModel/EquipModel"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { EquipJewelBagView } from "./EquipJewelBagView"

export class EquipJewelBagItem extends BaseItemRenderer {
	_item
	_model
	WIDTH = 379
	HEIGT = 107

	public constructor() {
		super()
		this.base_file = "jewel"
		this.layout_file = "EquipJewelBagItem"

		this._model = EquipModel.GetInstance()

		this.load_callback = () => {
			this._lb_attr.width = 200
			this._lb_attr.style.fontSize = 22
			this._lb_attr.style.color = "#663915"
			
			if (!this._item) {
				this._item = new BaseAwardItem(this._gp_item)
				this._item.Load()
				this._item.SetItemSize(87, 87)
			}
			this.InitEvent()
			this.dataChanged()
		}
		this.Load()
	}

	public InitEvent() {
		Util.AddClickEvent(this._Image1, () => {
			let data = this.data
			if(!data) return
			if (data._is_show) {
				OpenFun.OpenFunHandler(60)
				EquipModel.GetInstance().Fire(EquipEvent.CLOSE_VIEW, "EquipJewelBagView")
				//this:Close()
			} else if (data.is_up_one) {
				var up_one = () => {
					if (data.equip_type && data.select_pos) {
						this._model.Fire(EquipEvent.REQUEST_PROTO, 15215, "ccc", data.equip_type, data.select_pos, 2)
					}
				}
				if (data.show_tips) {
					Alert.Show("该宝石等级过低，使用收益较低，是否坚持使用", Alert_Type.Two, up_one)
				} else {
					up_one()
				}
			} else if (data.goods_id) {
				if (data.equip_type && data.select_pos) {
					this._model.Fire(EquipEvent.REQUEST_PROTO, 15208, "ccl", data.equip_type, data.select_pos, data.goods_id)
				}
			}
		}, this, true)
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		if (!this.data) {
			return
		}
		this._reddot.visible=false
		if (this.data._is_show) {
			this._item.SetShowTips(false)
			this._lb_name.text = "前往商城购买"
			this._lb_name.color = ColorUtil.GetColorDark(ColorType.WHITE, false)
			this._lb_attr.innerHTML = "<font color='#0a953e'>可镶嵌" + this.data.name + "宝石</font>"
			this._img_now.visible = false
			this._lb_name0.visible = false
		} else {
			this._item.SetShowTips(true)
			this._lb_name.text = this.data.goods_name
			this._lb_name.color = ColorUtil.GetColorDark(this.data.color, false)
			this._img_now.visible = Boolean(this.data._is_equip)
			this._lb_name0.visible = Boolean(this.data._is_equip)
			let jewel_lv_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_equip_stone_lv", false)
			let jewel_cfg = jewel_lv_cfg[this.data.type_id]
			if (jewel_cfg) {
				let attr = JSON.parse(jewel_cfg.attr)
				this._lb_attr.innerHTML = this._model.GetJewelAttrStr(attr)
			} else if (this.data.is_up_one) {
				this._lb_attr.innerHTML = "可使用宝石直升卡"
				this._reddot.visible=true
			} else {
				this._lb_attr.innerHTML = ""
			}
		}
		this._lb_attr.width = 200
		this._item.SetData(this.data.type_id, this.data.goods_num)
	}


_Image1:Laya.Image
_gp_item:Laya.Box
_img_now:Laya.Image
_lb_name0:Laya.Label
_lb_name:Laya.Label
_lb_attr:Laya.HTMLDivElement
_reddot:Laya.Image
public GetComponents() {
[
this._Image1,
this._gp_item,
this._img_now,
this._lb_name0,
this._lb_name,
this._lb_attr,
this._reddot,
]
 = this.GetChildrenByNames([

"_Image1",
"_gp_item",
"_img_now",
"_lb_name0",
"_lb_name",
"_lb_attr",
"_reddot",
])
}
}
 window["EquipJewelBagItem"]= EquipJewelBagItem