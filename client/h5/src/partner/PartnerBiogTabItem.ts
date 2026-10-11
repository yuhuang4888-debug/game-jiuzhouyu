
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { PartnerModel } from "../commonModel/PartnerModel";
import { GameResPath } from "../util/GameResPath";

export class PartnerBiogTabItem extends BaseItemRenderer {

	public WIDTH = 195
	public HEIGT = 60
	model


	public constructor(parent) {
		super()
		this.base_file = "partner"
		this.layout_file = "PartnerBiogTabItem"
		this.model = PartnerModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		this.BindEvent(this.model, PartnerModel.UPDATE_BIOG_RED, () => {
			if(this.data)this.UpdateView()
		})
	}


	public DeleteMe() {

		super.DeleteMe()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.UpdateView()
	}

	private UpdateView(){

		let status = this.model.CheckIsUnlockBiog(this.data.temp_companion_id,this.data.id)
		this.btnred.visible = status==1 //待解锁
		if(status!=2){
			this.tab_1_text.text = `未解锁`
		}else{
			this.tab_1_text.text = `传记·${this.GetCNNum(this.data.id)}`
		}
	
		let source1 = this.selected && "ui_role_btn_1" || "ui_role_btn_2"
		let text_color = this.selected  && "#9b572f" || "#ffffff"
		this.tab_1_img.skin = GameResPath.GetIcon("partner", `${source1}`)
		this.tab_1_text.color = text_color
	}

	private GetCNNum(num) {
		let num_list = ["零", "壹", "贰", "叁", "肆", "伍", "陆", "柒", "捌", "玖", "拾"]
		return num_list[num]||"壹"
	}


tab_1_con:Laya.Box
tab_1_img:Laya.Image
tab_1_text:Laya.Label
btnred:Laya.Image
public GetComponents() {
[
this.tab_1_con,
this.tab_1_img,
this.tab_1_text,
this.btnred,
]
 = this.GetChildrenByNames([

"tab_1_con",
"tab_1_img",
"tab_1_text",
"btnred",
])
}
}
 window["PartnerBiogTabItem"]= PartnerBiogTabItem