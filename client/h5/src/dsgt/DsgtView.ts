import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { DsgtModel } from "../commonModel/DsgtModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { DsgtDetailsItem } from "./DsgtDetailsItem"
import { DsgtItemRenderer } from "./DsgtItemRenderer"

export class DsgtView extends BaseItem1 {
Content
CreateDsgt
CreateDsgtDetailsItem
CustomMehod
InitEvent
InitScroll
InitSelectDsgt
InitSelectDsgt2
OpenDsgtView
RefreshDsgtDetails
TouchDsgtCallBack
UpdataDsgt
_img_bg
dsgt_List
dsgt_awarditem_
dsgt_details_group
dsgt_details_item_
dsgt_scoller
mask_corners
time_out_list_
RefSelType
dsgtdetailsitem
_Image1:Laya.Image
_gp_effect:Laya.Box
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "dsgt"
	this.layout_file = "DsgtView"
	let dsgtModel = DsgtModel.GetInstance()
	let local_DsgtModel = DsgtModel
	this.dsgt_awarditem_ = null
	this.dsgt_details_item_ = null
	let current_selected_index_ = 0
	let current_selected_id_ = 0
	//this.time_out_list_ = []
	this.load_callback = () => {
		
		// this.RegisterMask(this.dsgt_List)
		// this.mask_corners = GetWorldCorners(this.dsgt_List)
		this.OpenDsgtView()
		this.InitEvent()
	}
	
	this.CustomMehod = ( index?, arg?) => {
		if (arg ) {
			current_selected_id_ = arg[0]
		}
	}
	
	this.InitEvent = () => {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/bigBg/ui_role_bg5.jpg")
		let ViewUpdate = (type?) => {
			this.InitSelectDsgt(type)
			GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "DsgtWindowView", 0, dsgtModel.ShowRedIcon())
			this.UpdataDsgt()
		}
		
		this.BindEvent(dsgtModel, local_DsgtModel.DSGT_UPDATE_VIEW, ViewUpdate)
		let DsgtAdorn = () => {
			this.UpdataDsgt()
		}
		
		this.BindEvent(dsgtModel, local_DsgtModel.DSGT_ADORN_BUT, DsgtAdorn)
		let playEffect = (order?) => {
			//this:AddUIEffect("ui_jinshengchenggong_glow", this._gp_effect, null, null, false)
		}
		
		this.BindEvent(dsgtModel, local_DsgtModel.DSGT_ORDER, playEffect)
	}
	
	this.OpenDsgtView = () => {
		this.CreateDsgt()
		this.InitSelectDsgt2()
		this.CreateDsgtDetailsItem(this.Content.selectedIndex)
		this.UpdataDsgt()
	}
	
	this.RefSelType=(item?)=>{
		this.dsgt_details_item_.SetData(this.Content.selectedIndex)
		this.dsgt_List.replaceAll(dsgtModel.GetDsgtList())
	}
	this.CreateDsgt = () => {
		let source = dsgtModel.GetDsgtList()
		if (! this.dsgt_List ) {
			this.dsgt_List =  new LoopScrowViewMgr()
			this.dsgt_List.SetData(this.Content,DsgtItemRenderer,source,LoopScrCon.Vertical,1,this.TouchDsgtCallBack)
			// this.Content.selectedIndex=50
			// this.Content.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.TouchDsgtCallBack, this)
		}else{
			this.dsgt_List.replaceAll(source)
		}
	}

	
	this.InitSelectDsgt2 = ( type?) => {
		[current_selected_index_, current_selected_id_] = dsgtModel.GetPriSelDsgt()
		// this.dsgt_List.select_index = current_selected_index_
		this.InitScroll(current_selected_index_)
		this.dsgt_List.SetSelectIndex(current_selected_index_)
		if(current_selected_index_-2<0){
			this.dsgt_List.FirstOnChild(0)
		}else{
			this.dsgt_List.FirstOnChild(current_selected_index_-2)
		}
	}

	this.InitSelectDsgt = ( type?) => {
		[current_selected_index_, current_selected_id_] = dsgtModel.GetPriSelDsgt(type, current_selected_index_, current_selected_id_)
		// this.dsgt_List.select_index = current_selected_index_
		this.InitScroll(current_selected_index_)
		this.dsgt_List.SetSelectIndex(current_selected_index_)
		if(current_selected_index_-2<0){
			this.dsgt_List.FirstOnChild(0)
		}else{
			// this.Content.startIndex = current_selected_index_ - 2
			// this.Content.scrollBar.value=120*(current_selected_index_-2)
			this.dsgt_List.FirstOnChild(current_selected_index_-2)
		}
	}
	
	this.InitScroll = ( _index?) => {
		this.dsgt_List.CenterOnChild(_index)
		// let time_out = () => {
		// 	let item_num = dsgtModel.length.GetDsgtList()
		// 	let contentheight = this.dsgt_scoller.viewport.contentHeight
		// 	let height = this.dsgt_scoller.height
		// 	let item_height = contentheight / item_num * _index
		// 	let move_x = null
		// 	if (item_height > height / 2 && item_height < contentheight - height / 2 ) {
		// 		move_x = item_height - height / 2
		// 	} else if (item_height <= height / 2 ) {
		// 		move_x = 0
		// 	} else if (item_height > contentheight - height / 2 ) {
		// 		move_x = contentheight - height
		// 	}
		// 	this.dsgt_scoller.viewport.scrollV = move_x
		// 	this.dsgt_List.validateNow()
		// }
		
		// let id = setTimeout(time_out, this, 100)
		// table.insert(this.time_out_list_, id)
	}
	
	this.CreateDsgtDetailsItem = ( selectedIndex?) => {
		if (! this.dsgt_details_item_ ) {
			this.dsgt_details_item_ =  new DsgtDetailsItem(this.dsgt_details_group)
			this.dsgt_details_item_.Load()
		}
		this.dsgt_details_item_.SetData(selectedIndex)
	}
	
	this.RefreshDsgtDetails = (selectedIndex?) => {
		this.dsgt_details_item_.SetData(selectedIndex)
	}
	
	this.TouchDsgtCallBack = (e?) => {
		this.Content.selectedIndex=e
		current_selected_index_ = e
		// [ts2lua]dsgtModel:GetDsgtList()下标访问可能不正确
		let dsgt = dsgtModel.GetDsgtList()[current_selected_index_]
		current_selected_id_ = dsgt && dsgt.id
		this.CreateDsgtDetailsItem(current_selected_index_)
		
		// // this.dsgt_details_item_.SetData(e.itemIndex)
		// this.dsgt_List.soureArr.refresh()
		// this.Content.selectedIndex = current_selected_index_
	}
	
	this.UpdataDsgt = () => {
		for (let _index in dsgtModel.GetDsgtList()) {
			
			// [ts2lua]dsgtModel:GetDsgtList()下标访问可能不正确
			if (dsgtModel.GetDsgtList()[_index].id == current_selected_id_ ) {
				current_selected_index_ = Number(_index)
				break
			}
		}
		this.dsgt_List.replaceAll(dsgtModel.GetDsgtList())
		this.dsgt_List.SetSelectIndex(current_selected_index_)
		this.dsgt_List.selectedIndex = current_selected_index_
		if (current_selected_index_ != -1 ) {
			this.InitScroll(current_selected_index_)
		}
		this.RefreshDsgtDetails(current_selected_index_)
	}
	
	
	
	dsgtModel.Fire(local_DsgtModel.DSGT_INSTANCE_LIST)
}

public DeleteMe(){ 
	
	if (this.dsgt_List ) {
		this.dsgt_List.DeleteMe()
		this.dsgt_List = null
	}
	//if (this.time_out_list_.length > 0 ) {
		//for (let _tmpi in this.time_out_list_) {
	// var id = this.time_out_list_[_tmpi]
			////local_laya:clearTimeout(id)
		//}
	//}

	if (this.dsgt_details_item_ ) {
		this.dsgt_details_item_.DeleteMe()
		this.dsgt_details_item_ = null
	}
	super.DeleteMe()
}

	public GetComponents() {
		[
			this._Image1,
			this._img_bg,
			this.dsgt_scoller,
			this.Content,
			this.dsgt_details_group,
			this._gp_effect,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_bg",
				"dsgt_scoller",
				"Content",
				"dsgt_details_group",
				"_gp_effect",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
			])
		this.Content.scrollBar.visible=false
	}
}

window["DsgtView"]=DsgtView