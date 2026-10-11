import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class SeaReawrdPreTab extends BaseItemRenderer {

    public WIDTH: number = 152
    public HEIGT: number = 72

    public constructor(parent) {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaReawrdPreTab"

        this.load_callback = () => {

        }
        this.Load()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        let text_color = null
		let line_color = null
		let img_str = null
		if (this.selected) {
			text_color ="#ffffff" 
			line_color = "#ad455c"
			img_str = "ui_role_btn_3"
		} else {
			text_color ="#4f538f" 
			line_color = "#c6c3f4"
			img_str = "ui_role_btn_4"
		}
		this._lb_name.text = this.data
		this._lb_name.color = text_color
		this._lb_name.strokeColor=line_color
		ResManager.GetInstance().SetImageSprite(this, this._Image1, "common4", img_str, true)

    }

    public DeleteMe(): void {
        super.DeleteMe()
    }


    _Image1: Laya.Image
    _lb_name: Laya.Label
    _img_red: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._lb_name,
            this._img_red,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_lb_name",
                "_img_red",
            ])
    }
}
window["SeaReawrdPreTab"] = SeaReawrdPreTab