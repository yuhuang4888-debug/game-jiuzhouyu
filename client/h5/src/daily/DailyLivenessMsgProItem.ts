import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { DailyModel } from "../commonModel/DailyModel"

export class DailyLivenessMsgProItem extends BaseItem1 {
	cfg_finish
	data
	model

	public constructor(parent) {
		super(parent)
		this.cfg_finish = false;
		this.base_file = "daily"
		this.layout_file = "DailyLivenessMsgProItem"
		this.model = DailyModel.GetInstance()
		this.data = null
		this.load_callback = () => {
			if (this.cfg_finish) {
				this.SetData(this.data)
				this.cfg_finish = false
			}
		}
	}



	public DeleteMe() {
		super.DeleteMe()
	}

	public SetData(data?) {
		this.data = data
		if (this.is_loaded) {
			if (this.data) {
				if (this.data[0]) {
					let pro_name = WordManager.GetProperties(this.data[0][0])
					let now = `${pro_name}:<font color='#0a953e'> ${this.data[0][1]}</font>`
					this.pro.style.fontSize = 20
					this.pro.width = 183
					this.pro.style.color = "#663915"
					this.pro.innerHTML = now
				}
				let next = "属性已达最高"
				if (this.data[1]) {
					let pro_name = WordManager.GetProperties(this.data[1][0])
					next = `${pro_name}:<font color='#0a953e'> ${this.data[1][1]}</font>`
				}
				this.next_pro.style.fontSize = 20
				this.next_pro.width = 183
				this.next_pro.style.color = "#663915"
				this.next_pro.innerHTML = next
			}
		} else {
			this.cfg_finish = true
		}

	}

	pro: Laya.HTMLDivElement
	next_pro: Laya.HTMLDivElement
	_Image1: Laya.Image
	public GetComponents() {
		[
			this.pro,
			this.next_pro,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"pro",
				"next_pro",
				"_Image1",
			])
	}
}
window["DailyLivenessMsgProItem"] = DailyLivenessMsgProItem