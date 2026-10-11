import { BaseItem1 } from "../common/BaseItem1";
import { WordManager } from "../common/WordManager";
import { Util } from "../util/Util";

export class FightComSubItem extends BaseItem1 {
	ImgWidth
	info
	need_refreshData
	nameLb
	p1Lb
	p2Lb
	p1Img
	p2Img
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image

	public constructor(parent?) {
		super(parent)


		this.ImgWidth = 214;
		this.base_file = "playerMessage"
		this.layout_file = "FightComSubItem"
		this.need_refreshData = false
		this.load_callback = () => {
			this.SetSubData(this.info)
		}
	}

	public SetSubData(info?) {

		this.info = info
		if (this.is_loaded && this.info) {
			let num1=null
			let num2=null
			this.nameLb.text = info.name
			if(info.value1>100000000){
				num1=WordManager.ConvertNum(info.value1,true)
				this.p1Lb.text=num1
			}else{
				this.p1Lb.text=info.value1
			}
			if(info.value2>100000000){
				num2=WordManager.ConvertNum(info.value2,true)
				this.p2Lb.text=num2
			}else{
				this.p2Lb.text=info.value2
			}
			// this.p1Lb.text = info.value1
			// this.p2Lb.text = info.value2
			let max = Math.max(info.value1, info.value2, 1)

			this.p1Img.width = info.value1 / max*229
			this.p2Img.width = info.value2 / max*229
		} else {
			this.need_refreshData = true
		}

	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Group1,
			this.nameLb,
			this._Image1,
			this._Image2,
			this.p1Img,
			this.p2Img,
			this.p1Lb,
			this.p2Lb,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"nameLb",
				"_Image1",
				"_Image2",
				"p1Img",
				"p2Img",
				"p1Lb",
				"p2Lb",
			])
	}
}

window["FightComSubItem"]=FightComSubItem