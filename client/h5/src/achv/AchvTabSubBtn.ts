import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { SetSizeDelta, SetSizeDeltaX, SetAnchoredPosition, Util, Trim } from "../util/Util"

export class AchvTabSubBtn extends BaseItem1 {
btn_state
btn_text
call_back
is_delay_callback
needRefresh
parent_index
red_dot
red_state
refresh_red
select_cache
public sub_conta
sub_index
title

tabClick
thisObj


public static Width = 57;
public constructor(parent?){
super(parent) 
	
	this.needRefresh = false;
	this.parent_index = 1;
	this.sub_index = 1;
	this.base_file = "achv"
	this.layout_file = "AchvTabSubBtn"
	this.is_delay_callback = false
	this.load_callback = () => {
		
		if(PlatformManager.IsEyouThPlatform()){
			this.btn_text.centerX = 114
			this.btn_text.centerY = -67
			this.btn_text.valign = "middle"
			this.btn_text.align = "center"
			this.btn_text.width = 181
			this.btn_text.height = 49
			this.btn_text.rotation = 90
		}
		this.LoadSuccess()
		this.InitEvents()
		
	}
}

public DeleteMe(){
	super.DeleteMe()
}
public LoadSuccess(){ 
	if (this.refresh_red ) {
		this.SetRedDot(this.red_state)
	}
	if(this.sub_conta){
		if(this.tabClick){
			Util.AddClickEvent(this.sub_conta, this.tabClick, this.thisObj)
		}
	}
}

public InitEvents(){ 
	
	if (this.needRefresh ) {
		this.SetSubData(this.title, this.parent_index, this.sub_index, this.call_back)
	}
}

public SetSubData(text?, parent_index?, sub_index?, call_back?){ 
	
	this.title = text
	this.parent_index = parent_index
	this.sub_index = sub_index
	this.call_back = call_back
	if (this.is_loaded ) {
		// this.btn_text.textFlow = Util.StrToHTML(Trim(this.title))
		this.btn_text.text = this.title
		if (this.select_cache != null ) {
			this.SetSelected(this.select_cache)
			this.select_cache = null
		}
	}else{
		this.needRefresh = true
	}
}

public SetSelected(bool?){ 
	console.log(this.hashCode)
	if (this.is_loaded ) {
		if (bool ) {
			this.btn_text.color="#663915"
			ResManager.GetInstance().SetImageSprite(this, this.btn_state, "achv_asset", "uicj_029", true)
			if (this.call_back ) {
				//this:call_back(this.parent_index, this.sub_index)
				this.call_back(this.parent_index, this.sub_index)
			}
		}else{
			this.btn_text.color="#6773a5"
			ResManager.GetInstance().SetImageSprite(this, this.btn_state, "achv_asset", "uicj_029b", true)
		}
	}else{
		this.select_cache = bool
	}
}

public SetRedDot(bool?){ 
	
	this.red_state = bool
	if (this.is_loaded ) {
		this.refresh_red = false
		if (bool ) {
			this.red_dot.visible = true 
		}else{
			this.red_dot.visible = false 
		}
	}else{
		this.refresh_red = true
	}
}

public SetPreRed(bool?){
	this.SetRedDot(bool)
}

public setTabClick(tabClick,thisObj){
	this.tabClick=tabClick
	this.thisObj=thisObj
	if(this.sub_conta){
		Util.AddClickEvent(this.sub_conta, this.tabClick, this.thisObj)
	}
}

	public GetComponents() {
		[
			this.sub_conta,
			this.btn_state,
			this.btn_text,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"sub_conta",
				"btn_state",
				"btn_text",
				"red_dot",
			])
	}
}
window["AchvTabSubBtn"] = AchvTabSubBtn