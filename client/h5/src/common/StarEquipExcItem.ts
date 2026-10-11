import { BaseItem1 } from "./BaseItem1"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { WordManager } from "./WordManager"
import { ResManager } from "./ResManager"

export class StarEquipExcItem extends BaseItem1 {
	SetData
	data
	needRefresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "common"
		this.layout_file = "StarEquipExcItem"

		this.load_callback = () => {
			this.attLb.style.fontSize = 20
			this.attLb.style.color = "#d431c7"
			this.attLb.style.wordWrap = false
			
			ResManager.GetInstance().SetImageSprite(this, this.star, "starEquip", "uixzsy_star2")
			
			if (this.needRefresh) {
				this.SetData(this.data)
				this.needRefresh = null
			}
		}

		this.SetData = (data?) => {
			this.data = data
			if (this.is_loaded) {
				if(data.type_id == 1){
					this.star.visible = true
					this.attLb.x = 28
				}else{
					this.star.visible = false
					this.attLb.x = 4
				}

				let color = ColorUtil.GetColorLight(data.color)
				if (WordManager.IsGrowthProType(data.attr_id)) {
					let str = "<font color=" + color + ">" + WordManager.GetProperties(data.attr_id) + "增加" + WordManager.ConvertToPercentValue(data.attr_id, data.plus_unit) + "点</font>"
					this.attLb.innerHTML = str.replace("{0}", data.plus_interval)
				} else {
					this.attLb.innerHTML = Util.StrToHTML("<font color=" + color + ">" + WordManager.GetProperties(data.attr_id) + (" + ") + WordManager.ConvertToPercentValue(data.attr_id, data.attr_val) + "</font>")
				}
			} else {
				this.needRefresh = true
			}
		}
	}

	star: Laya.Image
	attLb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.star,
			this.attLb,
		]
			= this.GetChildrenByNames([
				"star",
				"attLb",
			])
	}
}
window["StarEquipExcItem"] = StarEquipExcItem