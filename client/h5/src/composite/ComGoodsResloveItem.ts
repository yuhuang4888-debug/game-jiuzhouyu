import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CompositeModel } from "../commonModel/CompositeModel"
import { EquipmentItem } from "../common/EquipmentItem"

export class ComGoodsResloveItem extends BaseItem1 {
	ClearData
	InitEvents
	SetData
	data
	is_source
	item
	model
	needRefresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "composite"
		this.layout_file = "ComGoodsResloveItem"
		this.is_delay_callback = false
		this.is_source = false
		
		this.model = CompositeModel.GetInstance()

		this.InitEvents = () => {
			let click_fun = () => {
				if (this.data) {
					if (this.is_source) {
						UIToolTipMgr.GetInstance().AppendGoodsTips(this.data.type_id)
					}
				}
			}

			Util.AddClickEvent(this.click_bg, click_fun, this)
			if (this.needRefresh) {
				this.SetData(this.data, this.is_source)
				this.needRefresh = false
			}
		}

		this.SetData = (data?, is_source?) => {
			this.data = data
			this.is_source = is_source
			if (this.is_loaded) {
				this.equip_con.visible = true
				if (!this.item) {
					this.item = new EquipmentItem(this.equip_con)
					this.item.Load()
					this.item.SetShowTips(!is_source)
				}
				this.item.SetItemSize(85, 85)
				this.click_bg.visible = this.is_source
				if (this.is_source) {
					this.item.SetData(data.type_id, 1)
				} else {
					this.item.SetData(data[1], data[2])
				}
			} else {
				this.needRefresh = true
			}
		}

		this.ClearData = () => {
			this.data = null
			if (this.is_loaded) {
				this.equip_con.visible = false
			}
		}

		this.load_callback = () => {
			this.InitEvents()
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
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
window["ComGoodsResloveItem"] = ComGoodsResloveItem