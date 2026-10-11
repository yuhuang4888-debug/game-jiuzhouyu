import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { EquipmentItem } from "../common/EquipmentItem"

export class StarEquipComPreview extends BaseView1 {
	InitView
	Open
	data
	itemList

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipComPreview"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		
		this.itemList = []

		this.load_callback = () => {
			this._Scroller1.vScrollBar.visible = false
			//this.RegisterMask(this.itemGp)
			this.InitView()
		}

		this.close_callback = () => {
			for (let _tmpi in this.itemList) {
				let vo = this.itemList[_tmpi]
				vo.DeleteMe()
			}
			this.itemList = []
		}

		this.InitView = () => {
			if (this.data) {
				Util.AddClickEvent(this.closeBtn, () => {
					this.Close()
				}, this, true)

				let showList = this.data
				let i = 0
				do {
					let item = new EquipmentItem(this.itemGp)
					item.Load()
					item.SetUseMask(true)
					item.SetItemSize(100, 100)
					this.itemList[i] = item
					item.SetData(showList[i][2])
					i = i + 1
				} while ((i < showList.length))
			}
		}

		this.Open = (...new_args) => {
			this.data = new_args[0]
			super.Open()
		}
	}

	_Image1: Laya.Image
	closeBtn: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Scroller1: Laya.Panel
	itemGp: Laya.VBox
	_Label1: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this.closeBtn,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Scroller1,
			this.itemGp,
			this._Label1,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"closeBtn",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Scroller1",
				"itemGp",
				"_Label1",
			])
	}
}
window["StarEquipComPreview"] = StarEquipComPreview