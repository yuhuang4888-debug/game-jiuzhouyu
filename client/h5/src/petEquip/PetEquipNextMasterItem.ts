import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class PetEquipNextMasterItem extends BaseItemRenderer {
	private attr: Laya.HTMLDivElement

	public constructor() {
		super()
		// this.skinName = "resource/game/petEquip/exml/PetEquipMasterItemExml.exml"
		this.base_file="petEquip"
		this.layout_file="PetEquipMasterItem"
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let list = this.data
		if (!list[2]) {
			let str = WordManager.GetProperties(list[0]) + Util.HtmlColorTxt(`\t+${list[1]}`, Enum_ColorUtil_Dark.GREEN)
			this.attr.innerHTML =str// (new Laya.HtmlTextParser).parser(str)
		}
		else {
			let str = `全身强化<font color="#639c12"> +${list[1] / 100}%</font>`
			this.attr.innerHTML  = Util.StrToHTML(str)
		}
	}
}

window["PetEquipNextMasterItem"] = PetEquipNextMasterItem