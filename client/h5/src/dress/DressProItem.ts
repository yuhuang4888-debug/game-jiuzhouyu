import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"
import { DressModel } from "../commonModel/DressModel"
import { Util } from "../util/Util"

export class DressProItem extends BaseItem1 {
	now_label: Laya.Label
	next_label: Laya.Label
	next_arrow: Laya.Image
	InitEvents
	SetData


	public constructor(parent?) {
		super(parent)


		this.base_file = "dress"
		this.layout_file = "DressProItem"
		let model = DressModel.GetInstance()
		let local_WordManager = WordManager
		let data_ = null
		let needRefresh_ = null
		let now_pro_ = null
		let next_pro_ = null
		this.load_callback = () => {

			this.InitEvents()
		}


		this.InitEvents = () => {
			if (needRefresh_) {
				this.SetData(now_pro_, next_pro_)
			}
		}

		this.SetData = (now_pro?, next_pro?) => {
			now_pro_ = now_pro
			next_pro_ = next_pro
			if (this.is_loaded) {
				if (now_pro) {
					this.now_label.text = local_WordManager.GetProperties(now_pro[0]) + "  " + local_WordManager.ConvertToPercentValue(now_pro[0], now_pro[1])
				} else {
					if (next_pro) {
						this.now_label.text = local_WordManager.GetProperties(next_pro[0]) + "  " + "0"
					}
				}
				let bol = !Util.IsTableEmpty(next_pro);
				this.next_arrow.visible = bol
				this.next_label.visible = bol
				this.now_label.align = bol ? "left" : "center";
				if (next_pro) {
					this.next_label.text = local_WordManager.ConvertToPercentValue(next_pro[0], next_pro[1])
				}
			} else {
				needRefresh_ = true
			}
		}
	}

	public GetComponents() {
		[
			this.now_label,
			this.next_label,
			this.next_arrow,
		]
			= this.GetChildrenByNames([

				"now_label",
				"next_label",
				"next_arrow",
			])
	}
}
window["DressProItem"] = DressProItem