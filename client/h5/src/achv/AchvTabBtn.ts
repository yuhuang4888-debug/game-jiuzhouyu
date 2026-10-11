import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDeltaX, SetAnchoredPositionX, SetAnchoredPosition, Util, Trim } from "../util/Util"
import { AchvTabSubBtn } from "./AchvTabSubBtn"

export class AchvTabBtn extends BaseItem1 {
btn_img
call_back
force_cache
index
index_cache
is_delay_callback
needRefresh
parent
red_dot
red_state
refresh_red
show
subBg
subCon:Laya.HBox
sub_index_cache
sub_tab_item_list
sub_tab_list
public tab
tab_txt
width
conta:Laya.Box
tabClick
thisObj

sub_item_red_list

public constructor(parent?){
super(parent) 
	
	//this.parent = parent
	this.needRefresh = false;
	this.index = 0;
	this.show = false;
	this.base_file = "achv"
	this.layout_file = "AchvTabBtn"
	this.is_delay_callback = false
	this.sub_item_red_list=[]

	this.load_callback = () => {
		if(PlatformManager.IsEyouThPlatform()){
			this.tab_txt.centerX = 103
			this.tab_txt.centerY = -23
			this.tab_txt.valign = "middle"
			this.tab_txt.align = "center"
			this.tab_txt.width = 137
			this.tab_txt.height = 71
			this.tab_txt.rotation = 90
			this.tab_txt.fontSize = 19
		}
		//this.tab = this.GetChild("conta/tab").gameObject
		this.LoadSuccess()
		this.InitEvents()		
		
	

	}
}

public DeleteMe(){ 
	
	if (this.sub_tab_item_list ) {
		for (let _tmpi in this.sub_tab_item_list) {
			var item = this.sub_tab_item_list[_tmpi]
			item.DeleteMe()
			item = null
		}
		this.sub_tab_item_list = null
	}
	super.DeleteMe()
}

public LoadSuccess(){ 

	this.sub_tab_item_list = []
	if (this.refresh_red ) {
		this.SetRedDot(this.red_state)
	}
	if(this.tab){
		if(this.tabClick){
			Util.AddClickEvent(this.tab, this.tabClick, this.thisObj)
		}
	}
}

public InitEvents(){ 
	
	let select_fun = (parent_idnex?, sub_index?, parent?) => {
		if (this.parent == parent ) {
			if (this.index == parent_idnex ) {
				this.SetSelectSubIndex(parent_idnex, sub_index)
			}else{
				this.SetSelectSubIndex(999, 999)
			}
		}
	}
	
	this.BindEvent(GlobalEventSystem, EventName.SUB_TAB_BTN_BE_SELECTED, select_fun)
	if (this.needRefresh ) {
		this.SetTabData(this.sub_tab_list, this.index, this.call_back,null,this.sub_item_red_list)
	}
}

public SetTabData(list?, index?, call_back?, icon?,sub_item_red_list?){ 
	this.sub_item_red_list=sub_item_red_list
	this.sub_tab_list = list
	this.index = index
	this.call_back = call_back
	if (this.is_loaded ) {
		if (this.sub_tab_list ) {
			// this.tab_txt.textFlow = Util.StrToHTML(Trim(this.sub_tab_list[0]))
			this.tab_txt.text = this.sub_tab_list[0]
			let item = null
			if (this.sub_tab_list[1] ) {
				for (let i = 0; i < this.sub_tab_list[1].length; i++){
					item = this.sub_tab_item_list[i]
					if (! item ) {
						item =  new AchvTabSubBtn(this.subCon)
						this.sub_tab_item_list[i] = item
						item.Load()
					}
					item.SetSubData(this.sub_tab_list[1][i], index, i, call_back)
					//成就纵览没有子标签
					item.SetPreRed(this.sub_item_red_list[i])
					let onBtnClickHandler = () => {
						// SoundManager.GetInstance().PlaySoundEffect("2_dianji")
						GlobalEventSystem.Fire(EventName.SUB_TAB_BTN_BE_SELECTED, index, i, this.parent)
					}
					item.setTabClick(onBtnClickHandler,this)
					
					// if (item.objsub_conta ) {
						// Util.AddClickEvent(item.sub_conta, onBtnClickHandler, this)
					// }
				}

				// let i = 0
				// do {
				// 	item = this.sub_tab_item_list[i]
				// 	if (! item ) {
				// 		item =  new AchvTabSubBtn(this.subCon)
				// 		this.sub_tab_item_list[i] = item
				// 		item.Load()
				// 	}
				// 	item.SetSubData(this.sub_tab_list[1][i], index, i, call_back)
				// 	let onBtnClickHandler = () => {
				// 		// SoundManager.GetInstance().PlaySoundEffect("2_dianji")
				// 		GlobalEventSystem.Fire(EventName.SUB_TAB_BTN_BE_SELECTED, index, i, this.parent)
				// 	}
					
				// 	if (item.objsub_conta ) {
				// 		Util.AddClickEvent(item.objsub_conta, onBtnClickHandler, this)
				// 	}
				// 	i=i+1
				// } while ((i < this.sub_tab_list[1].length))
			}
			this.RefreshSize()
			if (this.index_cache != null ) {
				this.SetSelectMode(this.index_cache, this.sub_index_cache, this.force_cache)
				this.index_cache = null
			}
		}
	}else{
		this.needRefresh = true
	}
}



public RefreshSize(){ 
	
	if (((this.show && this.sub_tab_list) && this.sub_tab_list[1]) && this.sub_tab_list[1].length > 0 ) {
		let width = this.sub_tab_list[1].length * AchvTabSubBtn.Width + 6 + this.subCon.x + 10
		this.display_obj.width=width
		this.subBg.width = width - 75
		this.subBg.visible=true;
	}else{
		//this.width = this.tab.width
		//SetSizeDeltaX(this.form, this.tab.sizeDelta.x)
		this.display_obj.width=this.tab.width
		this.subBg.width=0;
		this.subBg.visible=false;
	}
	GlobalEventSystem.Fire(EventName.TAB_BAR_REFRESH)
}

public SetSelectMode(index?, sub_index?, force_show?){ 
	
	if (this.is_loaded ) {
		if (this.index == index ) {
			if (this.sub_tab_list[1] ) {
				this.show = ! this.show
			}else{
				this.show = true
			}
		}else{
			this.show = false
		}
		if (force_show && this.index == index ) {
			this.show = true
		}
		if (this.show && (index != null || ! this.sub_tab_list[1]) ) {
			this.tab_txt.color="#663915"
			this.ShowSubBtnVisible(true)
			ResManager.GetInstance().SetImageSprite(this, this.btn_img, "achv_asset", "uicj_026", true)
			if (sub_index != null ) {
				this.SetSelectSubIndex(index, sub_index)
			}
		}else{
			this.tab_txt.color="#6773a5"
			ResManager.GetInstance().SetImageSprite(this, this.btn_img, "achv_asset", "uicj_027", true)
			this.ShowSubBtnVisible(false)
		}
		this.RefreshSize()
	}else{
		this.index_cache = index
		this.sub_index_cache = sub_index
		this.force_cache = force_show
	}
}

public ShowSubBtnVisible(show?){ 
	
	if ((this.subCon && this.sub_tab_item_list) && this.sub_tab_item_list.length != 0 ) {
		this.subCon.visible = show 
	}
}

public SetSelectSubIndex(index?, sub_index?){ 
	
	for (let _tmpi in this.sub_tab_item_list) {
		var item = this.sub_tab_item_list[_tmpi]
		if (item.parent_index == index && item.sub_index == sub_index ) {
			item.SetSelected(true)
		}else{
			item.SetSelected(false)
		}
	}
}

public SetRedDot(bool?){ 
	console.log(this.hashCode)
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

public PreSetRed(bool?){
	this.SetRedDot(bool)
}

public setTabClick(tabClick,thisObj){
	this.tabClick=tabClick
	this.thisObj=thisObj
	if(this.tab){
		Util.AddClickEvent(this.tab, this.tabClick, this.thisObj)
	}
}

	public GetComponents() {
		[
			this.conta,
			this.tab,
			this.btn_img,
			this.tab_txt,
			this.subBg,
			this.subCon,
			this.red_dot,
		]
			= this.GetChildrenByNames([

				"conta",
				"tab",
				"btn_img",
				"tab_txt",
				"subBg",
				"subCon",
				"red_dot",
			])
	}
}
window["AchvTabBtn"] = AchvTabBtn