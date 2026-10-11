import { BaseItem1 } from "../common/BaseItem1";
import { WordManager } from "../common/WordManager";
import { LungModel } from "../commonModel/LungModel";
import { Util } from "../util/Util";

export class LungUpgradeProItem extends BaseItem1 {


	static Height = 35

	public model: LungModel
	public data
	public next_data
	public needRefresh
	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungUpgradeProItem"
		this.model = LungModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvents()
		}
	}
	public DeleteMe() {

		super.DeleteMe()

	}
	public LoadSuccess() {

	}

	public InitEvents() {


		if (this.needRefresh) {
			this.SetData(this.data, this.next_data)
			this.needRefresh = null
		}
	}

	public SetData(data, next_data) {
		this.data = data
		this.next_data = next_data
		if (this.is_loaded) {
			let str = ""
			if (this.data) {
				this.pro.style.color = "#663915"
				this.pro.style.fontSize = 20
				this.pro.width = 220

				let str = WordManager.GetProperties(this.data[0]) + ": " + "<font color='#d15e00'>" + WordManager.ConvertToPercentValue(this.data[0], this.data[1]) + "</font>"
				this.pro.innerHTML = Util.StrToHTML(str)
				this.add_tag.visible = next_data != undefined
				this.next_value.visible = next_data != undefined
				if (this.next_data) {
					let gap = Number(this.next_data[1]) - Number(this.data[1])
					this.add_tag.visible = gap > 0
					this.next_value.visible = gap > 0
					this.next_value.text = WordManager.ConvertToPercentValue(this.next_data[0], gap)
				}
			}
		} else {
			this.needRefresh = true

		}
	}
	
	bg: Laya.Image
	pro: Laya.HTMLDivElement
	next_value: Laya.Label
	add_tag: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.pro,
			this.next_value,
			this.add_tag,
		]
			= this.GetChildrenByNames([

				"bg",
				"pro",
				"next_value",
				"add_tag",
			])
	}
}
window["LungUpgradeProItem"] = LungUpgradeProItem