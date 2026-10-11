import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Trim, Util } from "../util/Util"

export class EquipStoneItem extends BaseItem1 {
	data
	needRefresh
	public static Height = 52

	public constructor(parent?) {
		super(parent)
		this.base_file = "common"
		this.layout_file = "EquipStoneItem"
		this.is_delay_callback = false

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public LoadSuccess() {
		this.stone_name.width = 369
		this.stone_name.style.fontSize = 20
		this.stone_name.style.color = "#93847d"

		this.stone_label.width = 369
		this.stone_label.style.fontSize = 20
		this.stone_label.style.color = "#663915"
	}

	public InitEvents() {
		if (this.needRefresh) {
			this.SetData(this.data)
		}
	}

	public SetData(data?) {
		this.data = data
		if (!this.data) {
			return
		}
		if (this.is_loaded) {
			if (this.data.type_id == 0) {
				if (this.data.vipCond != "") {
					this.stone_lock.visible = true
					this.stone_name.innerHTML = this.data.vipCond
				} else if (this.data.stageStr != "") {
					this.stone_lock.visible = true
					this.stone_name.innerHTML = this.data.stageStr
				} else {
					this.stone_name.innerHTML = "未镶嵌"
					this.stone_lock.visible = false
				}
				this.display_obj.height = EquipStoneItem.Height / 2
				this.stone_label.innerHTML = ""
				ResManager.GetInstance().SetImageSprite(this, this.stone_icon, "common4", "ui_tips_03")
			} else {
				this.stone_lock.visible = false
				this.display_obj.height = EquipStoneItem.Height
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
				if (basic) {


					let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.type_id)
					let name = basic.goods_name
					if (basic) {
						let color = ColorUtil.GetColorDark(basic.color, true)
						name = HtmlColorTxt(name,color)
					}
					this.stone_name.innerHTML = Util.StrToHTML((name != "" && (name) || ("未知")))//textFlow

					ResManager.GetInstance().SetTexture(this, this.stone_icon, GameResPath.GetGoodsIconPath(this.data.type_id))
					// if (basic.subtype == 1) {
					// 	ResManager.GetInstance().SetImageSprite(this, this.stone_icon, "common_asset", "uity_016g")
					// } else {
					// 	ResManager.GetInstance().SetImageSprite(this, this.stone_icon, "common_asset", "uity_016h")
					// }
					if (this.data.cfg) {
						let pro_list = JSON.parse(this.data.cfg.attr)
						let str = this.GetStoneProStr(pro_list)
						this.stone_label.innerHTML = Util.StrToHTML(str)
					}
				}
			}

			this.stone_name.width = 369
			this.stone_label.width = 369
		} else {
			this.needRefresh = true
		}
	}

	public GetStoneProStr(base_attrlist?) {
		let str = ""
		let pro = null
		if (base_attrlist && base_attrlist != null && base_attrlist != []) {
			let vo = null
			for (let i = 0; i < base_attrlist.length; i++) {
				vo = base_attrlist[i]
				if (i % 2 == 0) {
					if (i == 0) {
						str = WordManager.GetProperties(vo[0]) + "：<font color='#d15e00'>" + vo[1] + "</font>"
					} else {
						str = str + "<br/>" + WordManager.GetProperties(vo[0]) + "：<font color='#d15e00'>" + vo[1] + "</font>"
					}
				} else {
					str = str + "&nbsp;&nbsp;" + WordManager.GetProperties(vo[0]) + "：<font color='#d15e00'>" + vo[1] + "</font>"
				}
			}
		}
		return str
	}


	conta: Laya.Box
	stone_bg: Laya.Image
	stone_icon: Laya.Image
	stone_lock: Laya.Image
	stone_name: Laya.HTMLDivElement
	stone_label: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.conta,
			this.stone_bg,
			this.stone_icon,
			this.stone_lock,
			this.stone_name,
			this.stone_label,
		]
			= this.GetChildrenByNames([

				"conta",
				"stone_bg",
				"stone_icon",
				"stone_lock",
				"stone_name",
				"stone_label",
			])
	}
}
window["EquipStoneItem"] = EquipStoneItem