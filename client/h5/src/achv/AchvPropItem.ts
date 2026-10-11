import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager"

export class AchvPropItem extends BaseItem1 {
arrow_img
cur_value
name_label
name_label1
next_value
_Group1:Laya.Box
	
public constructor(parent?){
super(parent) 
	
	this.base_file = "achv"
	this.layout_file = "AchvPropItem"

	this.load_callback = () => { 
		
	}
}

public SetData(cur_data?, next_data?){ 
	
	if (cur_data ) {
		this.name_label1.text = WordManager.GetProperties(cur_data[0])
		this.name_label.text = this.name_label1.text
		this.cur_value.text = "+" + WordManager.ConvertToPercentValue(cur_data[0], cur_data[1])
	}else{
		this.cur_value.text = "+0"
	}
	if (next_data ) {
		if (! cur_data ) {
			this.name_label1.text = WordManager.GetProperties(next_data[0])
			this.name_label.text = this.name_label1.text
		}
		this.arrow_img.visible = true 
		this.name_label1.visible = true 
		this.next_value.text = "+" + WordManager.ConvertToPercentValue(next_data[0], next_data[1])
	}else{
		this.arrow_img.visible = false 
		this.name_label1.visible = false 
		this.next_value.text = ""
	}
}

	public DeleteMe(){
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Group1,
			this.name_label,
			this.cur_value,
			this.name_label1,
			this.next_value,
			this.arrow_img,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"name_label",
				"cur_value",
				"name_label1",
				"next_value",
				"arrow_img",
			])
	}
}
window["AchvPropItem"] = AchvPropItem