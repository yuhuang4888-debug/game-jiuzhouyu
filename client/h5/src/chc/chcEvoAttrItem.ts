import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"
import { ColorUtil } from "../util/ColorUtil"
import { ResManager } from "../common/ResManager"

export class chcEvoAttrItem extends BaseItemRenderer {
	WIDTH = 370
	HEIGT = 35
	need_refresh = false
	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcEvoAttrItem"
		
		this.load_callback = () => {
			if(this.need_refresh){
				this.need_refresh = false
				this.dataChanged()
			}
		}	
		this.Load()
	}

	public dataChanged() {
		if(!this.data){
			return
		}
		if(!this.is_loaded){
			this.need_refresh = true
			return
		}
		let data = this.data
		let vo = data.vo
		let name = WordManager.GetProperties(vo[0])
		let valc = WordManager.ConvertToPercentValue(vo[0], vo[1])
		let lv = vo[4]
		let gval = vo[5]
		name = ((lv && gval) && (name.replace("{0}", lv)) || (name))
		valc = ((lv && gval) && (gval) || (valc))
		this._lb_attr.text = "卓越(" + name + (" + ") + valc + ")"
		this._lb_attr.color = ColorUtil.TryParseHtmlString(data.is_get && "#179846" || "#663915")
		let pic = (data.is_get && ("001") || ("002"))
		ResManager.GetInstance().SetImageSprite(this, this._img_tips, "chc", "uisljjyl_" + pic, true)
		let isStar = lv && Number(vo[3]) == 1 || vo[2] == 1
		this._img_star.visible = isStar
	}

	_img_star: Laya.Image
	_img_tips: Laya.Image
	_lb_attr: Laya.Label
	public GetComponents() {
		[
			this._img_star,
			this._img_tips,
			this._lb_attr,
		]
			= this.GetChildrenByNames([

				"_img_star",
				"_img_tips",
				"_lb_attr",
			])
	}
}
window["chcEvoAttrItem"] = chcEvoAttrItem