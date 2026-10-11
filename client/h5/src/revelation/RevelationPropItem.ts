import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { WordManager } from "../common/WordManager"
import { ResManager } from "../common/ResManager"

export class RevelationPropItem extends BaseItem1 {
	active
	data
	need_refresh

	public constructor(parent?) {
		super(parent)
		this.base_file = "revelation"
		this.layout_file = "RevelationPropItem"

		this.load_callback = () => {
			this.lb_prop.width = 140
			this.lb_prop.style.fontSize = 20
			this.lb_prop.style.color = "#888888"
			this.lb_prop.style.leading = 5
			
			if (this.need_refresh) {
				this.SetData(this.data, this.active)
			}
			/*
			if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
				this.propLb.size = 18
			}
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.propLb.size = 18
			}
			*/
		}
	}

	public SetData(data?, active?) {
		if (!data) {
			return
		}
		if (this.is_loaded) {
			this.img_bg.gray = !active
			this.img_tips.gray = !active
			
			let attrList = JSON.parse(data.attr)
			let str = ""
			if (active) {
				this.lb_count.text = "【" + data.num + "件】"
				this.lb_count.color = "#0a953e"
				
				for (let i = 0; i < attrList.length; i++) {
					if (i != attrList.length) {
						str = str + "<font color='#663915'>" + WordManager.GetProperties(attrList[i][0]) + "</font>:<font color='#d15e00'>" + WordManager.ConvertToPercentValue(attrList[i][0], attrList[i][1]) + "</font><br/>"
					} else {
						str = str + "<font color='#663915'>" + WordManager.GetProperties(attrList[i][0]) + "</font>:<font color='#d15e00'>" + WordManager.ConvertToPercentValue(attrList[i][0], attrList[i][1]) + "</font>"
					}
				}
				this.lb_prop.innerHTML = str
			} else {
				this.lb_count.text = "【" + data.num + "件】"
				for (let i = 0; i < attrList.length; i++) {
					if (i != attrList.length) {
						str = str + WordManager.GetProperties(attrList[i][0]) + ":" + WordManager.ConvertToPercentValue(attrList[i][0], attrList[i][1]) + "<br/>"
					} else {
						str = str + WordManager.GetProperties(attrList[i][0]) + ":" + WordManager.ConvertToPercentValue(attrList[i][0], attrList[i][1])
					}
				}
				this.lb_prop.innerHTML = str
			}
			this.lb_prop.width = 140
		} else {
			this.data = data
			this.active = active
			this.need_refresh = true
		}
	}

	img_bg: Laya.Image
	lb_count: Laya.Label
	lb_prop: Laya.HTMLDivElement
	img_tips: Laya.Image
	public GetComponents() {
		[
			this.img_bg,
			this.lb_count,
			this.lb_prop,
			this.img_tips,
		]
			= this.GetChildrenByNames([
				"img_bg",
				"lb_count",
				"lb_prop",
				"img_tips",
			])
	}
}
window["RevelationPropItem"] = RevelationPropItem