import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"

export class GodCourtSuitSingle extends BaseItem1 {
	data
	refresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "godCourt"
		this.layout_file = "GodCourtSuitSingle"

		this.load_callback = () => {
			this.suitLb.style.fontSize = 18
			this.suitLb.style.color = "#663915"
			this.suitLb.style.leading = 8
			this.suitLb.width = 145
			
			if (this.refresh) {
				this.SetData(this.data)
			}
		}
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			let cfg = this.data[0]
			let act_data = this.data[1]

			let active = act_data[cfg[0]]&&this.data[1][cfg[0]] ==this.data[2] //curNum >= Number(cfg[0])
			this.suitName.text = "【" + cfg[0] + "件套】"
			this.suitName.color = active ? "#0a953e" : "#4f4f4f"
			this.suitLb.style.color = active ? "#663915" : "#4f4f4f"
			let str = ""
			for (let _tmpi in cfg[1]) {
				let vo = cfg[1][_tmpi]
				str = str + "<font color='" + (active && "#d15e00" || "#4f4f4f") + "'>" + WordManager.GetProperties(vo[0]) + "</font> <font color='" + (active && "#d15e00" || "#4f4f4f") + ("'>+") + WordManager.ConvertToPercentValue(vo[0], vo[1]) + "</font><br>"
			}
			//Util.SetImageGray(this.bg, !active)
			this.suitLb.innerHTML = str
			this.suitLb.width = 145
			this.refresh = false
		} else {
			this.refresh = true
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	bg: Laya.Image
	suitName: Laya.Label
	suitLb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.bg,
			this.suitName,
			this.suitLb,
		]
			= this.GetChildrenByNames([
				"bg",
				"suitName",
				"suitLb",
			])
	}
}
window["GodCourtSuitSingle"] = GodCourtSuitSingle