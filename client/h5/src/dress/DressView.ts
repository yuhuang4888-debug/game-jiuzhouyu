import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { DressModel, DressType } from "../commonModel/DressModel"
import { DressSubView } from "./DressSubView"
import { DressTab } from "./DressTab"

export const DressViewTab = [{ dress_type: DressType.Bubble, name: "气泡", icon_up_source: "uirwv4_zb_010_02", icon_down_source: "uirwv4_zb_010_01" },
{ dress_type: DressType.Photo, name: "相框", icon_up_source: "uirwv4_zb_010_05", icon_down_source: "uirwv4_zb_010_04" },
{ dress_type: DressType.Head, name: "头像", icon_up_source: "uirwv4_zb_010_05", icon_down_source: "uirwv4_zb_010_04" },
]
//{dress_type=DressType.Foot, name="脚印", icon_up_source="uirwv4_zb_010_09", icon_down_source="uirwv4_zb_010_08"}}
window["DressViewTab"] = DressViewTab
export class DressView extends BaseItem1 {
	sub_con: Laya.Box
	_Scroller1: Laya.List
	Content
	CustomMehod
	InitEvents
	InitTab
	LoadSuccess
	Scr_Scroller1
	SwtichView
	_tab_list
	dress_sub_view_
	model
	tabTouchHandler

	public constructor(parent?) {
		super(parent)


		this.base_file = "dress"
		this.layout_file = "DressView"
		this.dependent_res = ["chat"]
		this.model = DressModel.GetInstance()
		// let local_eui = eui
		let local_DressViewTab = DressViewTab
		let _tab_arraycollection_ = null
		let _select_tab_ = 1
		let _select_typeId = null
		this.dress_sub_view_ = null
		this.load_callback = () => {
			this.InitEvents()
			this.LoadSuccess()
		}



		this.InitEvents = () => {
			// this._tab_list.addEventListener(local_eui.ItemTapEvent.ITEM_TAP, this.tabTouchHandler, this)
			this.SwtichView(_select_tab_)
		}

		this.LoadSuccess = () => {
			this.InitTab()
		}

		this.CustomMehod = (type?, args?) => {
			if(args && args[0]){
				let bool = false
				for (let key in local_DressViewTab) {
					let vo = local_DressViewTab[key]
					let index = Number(key)
					if(this.model.DressCanActive(vo.dress_type) || this.model.DressCanUplevel(vo.dress_type)){
						_select_tab_ = index
						bool = true
						break
					}
				}
				if(!bool){
					for (let i = 0, len = local_DressViewTab.length; i < len; i++) {
						if(args[0] == local_DressViewTab[i].dress_type){
							_select_tab_ = i;
							break;
						}
					}
				}
			}else{
				_select_tab_ = 0
			}
			_select_typeId = args && args[1]
		}

		this.InitTab = () => {
			if (!this._tab_list) {
				this._tab_list = new LoopScrowViewMgr()
				this._tab_list.SetData(this._Scroller1, DressTab, local_DressViewTab, LoopScrCon.Horizontal, 1, this.tabTouchHandler, _select_tab_)
				// this._tab_list.SetSelectIndex(_select_tab_)
				// this._Scroller1.selectedIndex = 0
				// this.Scr_Scroller1.horizontal = false
				// this.Content.addEventListener(Laya.ItemTapEvent.ITEM_TAP,this.tabTouchHandler)
			}
		}

		this.tabTouchHandler = (e?) => {
			if (_select_tab_ == this._Scroller1.selectedIndex) {
				return
			}
			_select_tab_ = this._Scroller1.selectedIndex
			this.model.now_select_id = null
			this.SwtichView(_select_tab_)
			this._tab_list.replaceAll(local_DressViewTab)
		}

		this.SwtichView = (index?) => {
			if (!this.dress_sub_view_) {
				this.dress_sub_view_ = new DressSubView(this.sub_con)
				this.dress_sub_view_.Load()
			}
			let dress_type = (local_DressViewTab[index] && (local_DressViewTab[index].dress_type) || (1))
			if(_select_typeId){
				this.dress_sub_view_.SetData(dress_type, _select_typeId)
			}else{
				this.dress_sub_view_.SetData(dress_type)
			}
			
		}
	}

	public DeleteMe() {


		if (this.dress_sub_view_) {
			this.dress_sub_view_.DeleteMe()
			this.dress_sub_view_ = null
		}
		this.model.now_select_id = null

		if (this._tab_list) {
			this._tab_list.DeleteMe()
			this._tab_list = null
		}
		super.DeleteMe()
	}
	public GetComponents() {
		[
			this.sub_con,
			this._Scroller1,
		]
			= this.GetChildrenByNames([

				"sub_con",
				"_Scroller1",
			])
		this._Scroller1.scrollBar.visible = false
	}
}
window["DressView"] = DressView