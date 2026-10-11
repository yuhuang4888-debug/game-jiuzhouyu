import { BaseItem1 } from "../common/BaseItem1";
import { WordManager } from "../common/WordManager";
import { LungModel } from "../commonModel/LungModel";
import { Util } from "../util/Util";

export class LungMainProItem extends BaseItem1 {

	static Height = 28

	public model: LungModel
	public data
	public needRefresh
	public constructor(parent) {
		super(parent)
		this.base_file = "lung"
		this.layout_file = "LungMainProItem"
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
			this.SetData(this.data)
			this.needRefresh = null
		}
	}

	public SetData(data) {
		this.data = data
		if (this.is_loaded) {
			let str = ""
			if (this.data) {
				this.pro1.style.color = "#663915"
				this.pro2.style.color = "#663915"
				this.pro1.style.fontSize = 20
				this.pro2.style.fontSize = 20
				this.pro1.width = 200
				this.pro2.width = 200
				if (this.data[0]) {
					str = WordManager.GetProperties(this.data[0].attr_id) + ": " + "<font color='#d15e00'>" + WordManager.ConvertToPercentValue(this.data[0].attr_id, this.data[0].attr_value) + "</font>"
					this.pro1.innerHTML = Util.StrToHTML(str)
				}
				if (this.data[1]) {
					this.pro2.visible = true
					str = WordManager.GetProperties(this.data[1].attr_id) + ": " + "<font color='#d15e00'>" + WordManager.ConvertToPercentValue(this.data[1].attr_id, this.data[1].attr_value) + "</font>"
					this.pro2.innerHTML = Util.StrToHTML(str)
				} else {
					this.pro2.visible = false
				}
			}
		} else {
			this.needRefresh = true

		}
	}

	
	bg: Laya.Image
	pro1: Laya.HTMLDivElement
	pro2: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.bg,
			this.pro1,
			this.pro2,
		]
			= this.GetChildrenByNames([

				"bg",
				"pro1",
				"pro2",
			])
	}
}
window["LungMainProItem"] = LungMainProItem