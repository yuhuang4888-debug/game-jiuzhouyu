import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { Util } from "../util/Util"

export class PetEquipMasterItem extends BaseItemRenderer {
	attr: Laya.HTMLDivElement
	attr_name:Laya.HTMLDivElement
	public constructor() {
		super()
		// this.skinName = "resource/game/petEquip/exml/PetEquipMasterItemExml.exml"
		this.base_file="petEquip"
		this.layout_file="PetEquipMasterItem"
		this.WIDTH=405
		this.HEIGT=35
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let list = this.data
		this.attr.width=300
		if (!list[2]) {
			this.attr_name.innerHTML=`<font color="#4a3a32"> ${WordManager.GetProperties(list[0])}</font>`
			let str =  Util.HtmlColorTxt(`+${list[1]}`, "'#0a953e'")
			this.attr.innerHTML = str//(new Laya.HtmlTextParser).parser(str)
		}
		else {
			let str = `全身强化<font color="#4a3a32"> +${list[1] / 100}%</font>`
			this.attr.innerHTML = Util.StrToHTML(str)
		}
		// this.attr.x=405/2-this.attr.contextWidth/2
	}

	public GetComponents() {
		[
			this.attr,
			this.attr_name,
		]
			= this.GetChildrenByNames([

				"attr",
				"attr_name"
			])
		this.attr.style.fontSize=24
		this.attr.style.color="#663915"
		this.attr.style.wordWrap=false
		this.attr_name.style.fontSize=24
		this.attr_name.style.color="#4a3a32"
		this.attr_name.style.wordWrap=false
	}
}
window["PetEquipMasterItem"] = PetEquipMasterItem