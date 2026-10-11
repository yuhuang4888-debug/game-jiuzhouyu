import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CompositeModel } from "../commonModel/CompositeModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class ComposeEquipResolveItem extends BaseItem1 {
	ClearData
	DeleteMe
	InitEvents
	SetData

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "CompositeEquipResolveItem"
		this.is_delay_callback = false
		
		let model = CompositeModel.GetInstance()
		let data_ = null
		let needRefresh_ = null
		let item_ = null
		let is_source_ = false

		this.load_callback = () => {
			this.InitEvents()
		}

		this.DeleteMe = () => {
			if (item_) {
				item_.DeleteMe()
				item_ = null
			}
			super.DeleteMe()
		}

		this.InitEvents = () => {
			let click_fun = () => {
				if (data_) {
					if (is_source_) {
						UIToolTipMgr.GetInstance().AppendEquipTips(data_.type_id, null, null, data_, null)
					}
				}
			}
			Util.AddClickEvent(this.click_bg, click_fun, this)

			if (needRefresh_) {
				this.SetData(data_, is_source_)
				needRefresh_ = false
			}
		}

		this.SetData = (data?, is_source?) => {
			data_ = data
			is_source_ = is_source
			if (this.is_loaded) {
				this.equip_con.visible = true
				if (!item_) {
					item_ = new EquipmentItem(this.equip_con)
					item_.SetUseMask(1)
					item_.Load()
					item_.SetShowTips(!is_source_)
				}
				item_.SetItemSize(85, 85)
				this.click_bg.visible = is_source_
				if (is_source_) {
					item_.SetData(data.type_id)
				} else {
					item_.SetData(data[1], data[2])
				}
			} else {
				needRefresh_ = true
			}
		}

		this.ClearData = () => {
			data_ = null
			if (this.is_loaded) {
				this.equip_con.visible = false
			}
		}
	}
	
	bg: Laya.Image
	equip_con: Laya.Box
	click_bg: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this.equip_con,
			this.click_bg,
		]
			= this.GetChildrenByNames([
				"bg",
				"equip_con",
				"click_bg",
			])
	}
}
window["ComposeEquipResolveItem"] = ComposeEquipResolveItem