import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { WordManager } from "../common/WordManager"

export class chcSuccessItem extends BaseItemRenderer {
	WIDTH = 420
	HEIGT = 30
	need_refresh = false

	public constructor() {
		super()
		this.base_file = "chc"
		this.layout_file = "chcSuccessItem"

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
		let attr = this.data
		let val = WordManager.ConvertToPercentValue(attr[0], attr[1])
		this._Label1.text = WordManager.GetProperties(attr[0])
		this._lb_attr.text = val
	}

	_Label1: Laya.Label
	_lb_attr: Laya.Label
	_Image1: Laya.Image
	public GetComponents() {
		[
			this._Label1,
			this._lb_attr,
			this._Image1,
		]
			= this.GetChildrenByNames([
				"_Label1",
				"_lb_attr",
				"_Image1",
			])
	}
}
window["chcSuccessItem"] = chcSuccessItem