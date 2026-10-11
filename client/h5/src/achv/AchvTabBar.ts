import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDeltaX, Util, SetAnchoredPositionX } from "../util/Util"
import { AchvTabBtn } from "./AchvTabBtn"

export class AchvTabBar extends BaseItem1 {
Content
btn
call_back
force_show
iconList
index
is_delay_callback
needRefresh
need_refresh_scroller
parent_width
parent_wnd
scroll
select_cache
sub_index
tab_item_list
tab_list
tabbtn_func
tab_item_red_list
tab_sub_red_list
_tx
beginX
hasMouseMove
onlyClick


public constructor(parent?){
	super(parent) 	
	this.hasMouseMove=false
	this.onlyClick=true
	this.needRefresh = false;
	this.need_refresh_scroller = false;
	this.tab_item_list = [];
	this.sub_index = 0;
	this.index = 0;
	this.parent_wnd = parent
	this.base_file = "achv"
	this.layout_file = "AchvTabBar"
	this.is_delay_callback = false
	//red
	this.tab_item_red_list=[false,false,false,false,false,false,false]
	this.tab_sub_red_list=[[],[false,false,false,false],[false],[false,false,false],[false,false],[false,false],[false,false,false]]
	//
	this.load_callback = () => {
		this.Content.on(Laya.Event.MOUSE_DOWN, this,this.OnMouseDown);
		this.LoadSuccess()
		this.InitEvents()
	}
}

public OnMouseDown(){
	Laya.Tween.clearAll(this.Content)
	this.beginX=this.Content.x
	this._tx = Laya.stage.mouseX;
	Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
	Laya.stage.once(Laya.Event.MOUSE_UP, this, this.mouseUp);
	Laya.stage.once(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	// this.value_text.text=this.value.toString()
}

private mouseMove(e: Event): void {
	this.hasMouseMove=true
	let stage = Laya.stage;
	this.Content.x +=stage.mouseX - this._tx
	if (this.Content.x > 400){
		this.Content.x = 400
	}else if (this.Content.x <= -374){
		this.Content.x  = -374;
	}
	this._tx = stage.mouseX;
}


private mouseUp(e: Event): void {
	if(this.hasMouseMove){
		//向左拖
		this.onlyClick=false
		if(this.Content.x<this.beginX){
			//在左边的最小x值
			let nowX=680-this.Content.width
			if(this.Content.x<nowX && nowX<0){
				Laya.Tween.to(this.Content,{ x:nowX },1000,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
					this.onlyClick = true
				}))
			}else if(this.Content.x<nowX && nowX>25){
				Laya.Tween.to(this.Content,{ x:25 },1000,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
					this.onlyClick = true
				}))
			}else{
				this.onlyClick = true
			}
		}else{
			//向右拖
			if(this.Content.x>30){
				Laya.Tween.to(this.Content,{ x:25 },1000,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
					this.onlyClick = true
				}))
			}else{
				this.onlyClick = true
			}
			// Laya.Tween.to(this.Content,{ x:this.beginX },1000,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
			// }))
		}

	}else{
		this.onlyClick=true
	}
	let stage = Laya.stage;
	stage.off(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
	stage.off(Laya.Event.MOUSE_UP, this, this.mouseUp);
	stage.off(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	this.hasMouseMove=false
}




public DeleteMe(){ 
	
	if (this.tab_item_list ) {
		for (let _tmpi in this.tab_item_list) {
			var obj = this.tab_item_list[_tmpi]
			obj.DeleteMe()
			obj=null
		}
		this.tab_item_list = []
	}
	super.DeleteMe()
}

public LoadSuccess(){ 
	// this.scroll.hScrollBarSkin=""
	SetAnchoredPositionX(this.Content, 25)
}

public InitEvents(){ 
	
	let refresh_size_fun = () => {
		if (this.parent_wnd ) {
			// this.parent_wnd.invalidateSize()
			// this.RefreshSrollerPos()
		}
	}
	
	this.BindEvent(GlobalEventSystem, EventName.TAB_BAR_REFRESH, refresh_size_fun)
	if (this.needRefresh ) {
		this.SetTabBar(this.tab_list, this.call_back, this.parent_width, this.tabbtn_func)
	}
	// if (this.need_refresh_scroller ) {
		// this.RefreshSrollerPos()
	// }
}

public SetTabBar(tab_list?, call_back?, parent_width?, tabbtn_func?, btn?, iconList?){ 
	
	// this.ClearTab()
	this.parent_width = parent_width
	this.tab_list = tab_list
	this.call_back = call_back
	this.tabbtn_func = tabbtn_func
	this.btn = btn
	this.iconList = iconList
	if (this.is_loaded ) {
		// this.scroll.width = parent_width
		SetSizeDeltaX(this.scroll, parent_width)
		if (this.tab_list && this.tab_list.length > 0 ) {
			let item = null
			for (let i = 0; i < this.tab_list.length; i++){
				item = this.tab_item_list[i]
				if (! item ) {
					// [ts2lua]lua中0和空字符串也是true，此处this.btn需要确认
					let tabBtn = (this.btn && ( this.btn ) || ( AchvTabBtn ) )
					item =  new tabBtn(this.Content)
					this.tab_item_list[i] = item
					item.Load()
				}
				let icon = null
				if (this.iconList ) {
					icon = this.iconList[i]
				}
				item.SetTabData(this.tab_list[i], i, call_back, icon,this.tab_sub_red_list[i])
				item.PreSetRed(this.tab_item_red_list[i])
				let onBtnClickHandler = () => {
				if(this.onlyClick){
					// SoundManager.GetInstance().PlaySoundEffect("2_dianji")
					let subitemList = this.tab_item_list[i].sub_tab_item_list
					let subIndex = 0
					let j = 0
					do {
						let item = subitemList[j]
						if (item && item.red_state ) {
							subIndex = j
							break
						}
						j=j+1
					} while ((j < subitemList.length))
					this.SetSelectTab(i, subIndex)
					if (this.tabbtn_func ) {
						this.tabbtn_func(i)
					}
					this.RefreshSrollerPos()
				}
				}
				item.setTabClick(onBtnClickHandler,this)
			}
			if (this.select_cache ) {
				this.select_cache = null
				this.SetSelectTab(this.index, this.sub_index, this.force_show)
			}
		}
	}else{
		this.needRefresh = true
	}
}

public SetSelectTab(index?, sub_index?, force_show?){ 
	
	this.sub_index = sub_index
	this.index = index
	this.force_show = force_show
	if (this.is_loaded ) {
		for (let _tmpi in this.tab_item_list) {
			var item = this.tab_item_list[_tmpi]
			item.SetSelectMode(index, sub_index, force_show)
		}
	}else{
		this.select_cache = true
	}
	this.RefreshSrollerPos()
}

public GetTabLastPos(){ 
	
	if (this.tab_item_list ) {
		// [ts2lua]this.tab_item_list下标访问可能不正确
		let lasttabbtn = this.tab_item_list[this.tab_item_list.length - 1]
		if (! lasttabbtn ) {
			return null
		}
		if (lasttabbtn.show ) {
			// [ts2lua]lasttabbtn.sub_tab_item_list下标访问可能不正确
			let lastsubbtn = lasttabbtn.sub_tab_item_list[lasttabbtn.sub_tab_item_list.length - 1]
			if (lastsubbtn ) {
				return lastsubbtn.localToGlobal(0, lastsubbtn.width)
				//return UILocalToCanvasPoint(this.lastsubbtn)
			}else{
				return false
			}
		}else{
			return lasttabbtn.localToGlobal(0, lasttabbtn.width)
			//return UILocalToCanvasPoint(this.lasttabbtn)
		}
	}
	return null
}

public ClearTab(){ 
	
	if (this.tab_item_list ) {
		for (let _tmpi in this.tab_item_list) {
			var obj = this.tab_item_list[_tmpi]
			obj.DeleteMe()
		}
		this.tab_item_list = []
	}
	this.tab_item_list = []
}

public RefreshSrollerPos(){ 
	
	if (this.is_loaded ) {
		// this.scroll_group.validateNow()
		// let max_scroll = this.scroll_group.contentWidth - this.scroll.width
		// this.scroll_group.scrollH = Math.min(this.index * 65, max_scroll)
		//LayoutRebuilder(this.Content)
		// let scroll = this.Content.parent.parent
		let scroll
		let hasChild=false
		let contentWidth=0
		for(let i=0;i<7;i++){
			let child=this.Content.getChildAt(i)
			if(child){
				contentWidth+=child.width;
				hasChild=true
			}else{
				hasChild=false
			}
		}
		if(hasChild){
			 scroll = this.Content.parent.parent
		}else{
			scroll = this.Content.parent
		}
		contentWidth+=20*6
		if (contentWidth > scroll.width) {
			if (this.index >= 4 ) {
				SetAnchoredPositionX(this.Content, scroll.width - contentWidth)
			}else{
				SetAnchoredPositionX(this.Content, 25)
			}
		}else{
			if (this.index >= 4 ) {
				SetAnchoredPositionX(this.Content, 25)
			}else{
				SetAnchoredPositionX(this.Content, 25)
			}
		}
	}else{
	}
}

	public GetComponents() {
		[
			this.scroll,
			this.Content,
		]
			= this.GetChildrenByNames([
				"scroll",
				"Content",
			])
	}
}
window["AchvTabBar"] = AchvTabBar