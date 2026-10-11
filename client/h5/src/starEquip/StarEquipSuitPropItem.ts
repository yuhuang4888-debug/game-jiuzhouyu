import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetAnchoredPosition, SetSizeDeltaY } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"

export class StarEquipSuitPropItem extends BaseItem1 {
	data
	haveNum
	needRefresh
	suitName

	public constructor(parent?) {
		super(parent)
		this.base_file = "starEquip"
		this.layout_file = "StarEquipSuitPropItem"

		this.load_callback = () => {
			if (this.needRefresh) {
				this.SetData(this.data, this.haveNum, this.suitName)
				this.needRefresh = null
			}
		}
	}

	public SetData(data?, haveNum?, suitName?) {
		this.data = data
		this.haveNum = haveNum
		this.suitName = suitName
		if (this.is_loaded) {
			this.needRefresh = false
			if (suitName) {
				this.suitNumLb.text = suitName
				this.suitAttrLb.text = ""
				this.bg.visible = true
				this.bg2.visible = false
			} else {
				this.suitNumLb.text = ""
				this.suitAttrLb.color = haveNum >= Number(data[0]) ? "#d85d03" : "#8f8f8f"
				let propStr = "【" + data[0] + "件激活】"
				for (let _tmpi in data[2]) {
					let vo = data[2][_tmpi]
					if (Number(_tmpi) == data[2].length - 1) {
						propStr = propStr + " " + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1])
					} else {
						propStr = propStr + " " + WordManager.GetProperties(vo[0]) + (" + ") + WordManager.ConvertToPercentValue(vo[0], vo[1])
					}
				}
				this.suitAttrLb.text = propStr
				this.bg.visible = false
				this.bg2.visible = true
			}
		} else {
			this.needRefresh = true
		}
	}

	bg: Laya.Image
	bg2: Laya.Image
	suitNumLb: Laya.Label
	suitAttrLb: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.bg2,
			this.suitNumLb,
			this.suitAttrLb,
		]
			= this.GetChildrenByNames([
				"bg",
				"bg2",
				"suitNumLb",
				"suitAttrLb",
			])
	}
}
window["StarEquipSuitPropItem"] = StarEquipSuitPropItem