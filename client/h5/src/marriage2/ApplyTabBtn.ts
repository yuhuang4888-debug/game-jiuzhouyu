
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BanquetModel } from "../commonModel/BanquetModel"
export class ApplyTabBtn extends BaseItemRenderer {
	// _Image1
	// _Image2
	// red
	// tabLabel

	public WIDTH = 98
	public HEIGT = 52

	public constructor(parent) {
		super()

		this.base_file = "marriage2"
		this.layout_file = "ApplyTabBtn"
		this.load_callback = () => {
			this.BindVar(BanquetModel.GetInstance(), "newApply", (value?) => {
				if (this.data && this.data.name == "申请信息") {
					this.red.visible = true;
				}
			}
			)
		}
		this.Load();
	}

	public dataChanged() {
		if (!super.dataChanged()) return;
		this._Image2.visible = this.selected
		this._Image1.visible = !this.selected
		if (this.data) {
			this.tabLabel.text = this.data.name
			this.tabLabel.strokeColor = this.selected ? "#e14c47" : "#35a3aa";
		}
		if (this.data && this.data.name == "申请信息") {
			this.red.visible = true;
		}
	}


_Group1:Laya.Box
_Image1:Laya.Image
_Image2:Laya.Image
red:Laya.Image
tabLabel:Laya.Label
public GetComponents() {
[
this._Group1,
this._Image1,
this._Image2,
this.red,
this.tabLabel,
]
 = this.GetChildrenByNames([

"_Group1",
"_Image1",
"_Image2",
"red",
"tabLabel",
])
}
}
 window["ApplyTabBtn"]= ApplyTabBtn