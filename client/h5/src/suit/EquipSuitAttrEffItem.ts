import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { EquipModel, EquipDefine } from "../commonModel/EquipModel"
import { Enum_ColorUtil_Dark, ColorUtil } from "../util/ColorUtil"
import { SetHtmlCenter, Util } from "../util/Util"

export class EquipSuitAttrEffItem extends BaseItem1 {


	data
	equipInfo
	model: EquipModel;
	needRefresh

	_img_bg: Laya.Image
	bg_1: Laya.Image
	bg_2: Laya.Image
	line: Laya.Image
	_lb_num: Laya.Label
	_lb_attr: Laya.HTMLDivElement




	public constructor(parent) {
		super(parent)

		this.model = EquipModel.GetInstance()
		this.base_file = "suit"
		this.layout_file = "EquipSuitAttrEffItem"

		this.load_callback = () => {
			if (this.needRefresh) {
				this.SetData(this.data, this.equipInfo)
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public SetData(data?, equipInfo?) {

		this.data = data
		this.equipInfo = equipInfo
		if (this.is_loaded) {
			//let suit_num = Number(data[1])
			let unlock = data.isActive
			let color = "#0a953e"//unlock && Enum_ColorUtil_Dark.GREEN || "#7D7D7D"
			if (this.equipInfo) {
				if (this.equipInfo.isEquipType) {
					let stage = Math.max(this.equipInfo.stage, EquipDefine.EQUIP_SUIT_MIN_STAGE)
					// this._lb_num.textFlow = Util.StrToHTML("<font color=" + color + ">[" + data[0] + "件] " + stage + "阶</font>")
					this._lb_num.text = "["+ data[0] + "件] " + stage + "阶"
				} else {
					let lv = this.equipInfo.curLv == 0 && 1 || this.equipInfo.curLv
					// this._lb_num.textFlow = Util.StrToHTML("<font color=" + color + ">[" + data[0] + "件] " + lv + "级共鸣</font>")
					this._lb_num.text = "[" + data[0] + "件] " + lv + "级共鸣"
				}
			}
			let attr_color = unlock && "#663915" || "#4c524e"

			this._lb_attr.style.color = ColorUtil.TryParseHtmlString(attr_color)
			// let sp_name = unlock && "uitz_005a" || "uitz_006b"
			// ResManager.GetInstance().SetImageSprite(this, this._img_bg, "suit_asset", sp_name, true)
			if (unlock) {
				Util.SetImageGray(this.bg_1, false)
				Util.SetImageGray(this.bg_2, false)
				Util.SetImageGray(this.line, false)
			} else {
				Util.SetImageGray(this.bg_1, true)
				Util.SetImageGray(this.bg_2, true)
				Util.SetImageGray(this.line, true)
				this._lb_num.gray=true
			}
			this._lb_attr.width=200
			if(unlock){
				this._lb_attr.innerHTML = Util.StrToHTML(this.model.GetAttrStr(data[1], color))
			}
			else{
				this._lb_attr.innerHTML =Util.StrToHTML(this.model.GetAttrStr(data[1], )) //Util.StrToHTML(this.model.GetAttrStr(data[1], color))
			}
			this._lb_attr.style.leading = 10
		} else {
			this.needRefresh = true
		}
	}


	public GetComponents() {
		[
			this._img_bg,
			this.bg_1,
			this.bg_2,
			this.line,
			this._lb_num,
			this._lb_attr,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"bg_1",
				"bg_2",
				"line",
				"_lb_num",
				"_lb_attr",
			])
		this._lb_attr.style.color="#7b4e35"
		this._lb_attr.style.fontSize=24
	}
}
window["EquipSuitAttrEffItem"] = EquipSuitAttrEffItem