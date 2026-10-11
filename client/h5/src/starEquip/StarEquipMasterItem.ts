import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { SetAnchoredPosition } from "../util/Util"
import { StarEquipModel } from "../commonModel/StarEquipModel"
import { StarEquipMasterIcon } from "./StarEquipMasterIcon"

export class StarEquipMasterItem extends BaseItemRenderer {
	itemList
	need_refresh = false
	WIDTH = 581
	HEIGT = 310

	public constructor() {
		super()
		this.base_file = "starEquip"
		this.layout_file = "StarEquipMasterItem"
		this.itemList = []

		this.load_callback = () => {
			let posList = StarEquipModel.starMasterPos
			let i = 0
			do {
				let item = new StarEquipMasterIcon(this.display_obj)
				let index = i
				item.Load()
				item.ExcuteCallback(()=> {
					SetAnchoredPosition(item.display_obj, posList[index][0], posList[index][1])
				})
				this.itemList[i] = item
				i = i + 1
			} while ((i < 6))
			
			if (this.need_refresh) {
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public dataChanged() {
		if (this.data) {
			if (!this.is_loaded) {
				this.need_refresh = true
				return
			}
			let i = 0
			do {
				let item = this.itemList[i]
				let index = i
				if (item) {
					item.ExcuteCallback(() => {
						item.SetData(this.data[index], index)
					}
					)
				}
				ResManager.GetInstance().SetImageSprite(this, this["line" + i], "starEquip", (this.data[i].star > StarEquipModel.GetInstance().activeStar) && "uixzsy_041" || "uixzsy_040")
				i = i + 1
			} while ((i < 6))
		}
	}

	public DeleteMe() {
		for (let _tmpi in this.itemList) {
			let vo = this.itemList[_tmpi]
			vo.DeleteMe()
		}
		this.itemList = []
		super.DeleteMe()
	}
	line0: Laya.Image
	line1: Laya.Image
	line2: Laya.Image
	line3: Laya.Image
	line4: Laya.Image
	line5: Laya.Image
	public GetComponents() {
		[
			this.line0,
			this.line1,
			this.line2,
			this.line3,
			this.line4,
			this.line5,
		]
			= this.GetChildrenByNames([
				"line0",
				"line1",
				"line2",
				"line3",
				"line4",
				"line5",
			])
	}
}
window["StarEquipMasterItem"] = StarEquipMasterItem