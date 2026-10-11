import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ChatModel } from "../commonModel/ChatModel"
import { ChatToolGridItem } from "./ChatToolGridItem"

export class ChatToolPanel extends BaseView1 {
	Content
	InitEvent
	arrow
	arrow_pos
	back_login_toClose
	background_alpha
	clickThis
	click_bg_toClose
	close_callback
	destroy_imm
	initView
	open_callback
	open_mode
	setData
	setLocal
	touch_screen_pos
	use_background
	use_local_view
	x
	y
	bg:Laya.Image
	itemScroller:Laya.Panel
	loop_mgr
	localPoint

	public constructor() {
		super()

		this.base_file = "chat"
		this.layout_file = "ChatToolPanel"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		this.back_login_toClose = true
		// this.use_local_view = true
		let local_laya = Laya
		let _model = ChatModel.GetInstance()
		let item_arrayCollection = null
		let _scroller = false
		// let btnX = 0
		// let btnY = 0
		// let is_down = false

		this.load_callback = () => {

			this.InitEvent()
			this.setLocal(this.localPoint)
		}

		this.open_callback = () => {
			// this.setLocal()
			this.initView()
		}

		this.close_callback = () => {
			// this.removeEventListener(Laya.TouchEvent.TOUCH_TAP, this.clickThis, this, true)
			// item_arrayCollection = null
		}

		this.InitEvent = () => {
			// this.BindEvent(GlobalEventSystem, EventName.STAGE_CLICK_EVENT,() => {
			// 		this.Close()
			// 	}
			// )
			// this.addEventListener(Laya.TouchEvent.TOUCH_TAP, this.clickThis, this, true, 1)
			// this.itemScroller.addEventListener(local_eui.UIEvent.CHANGE_END,() => {
			// 		_scroller = false
			// 	}
			// 	, this)
			// this.itemScroller.addEventListener(local_eui.UIEvent.CHANGE_START,() => {
			// 		_scroller = true
			// 	}
			// 	, this)
			// Util.AddClickEvent(this.gameObject, this.clickThis, this, true)
		}

		this.clickThis = (e?) => {
			// e.stopImmediatePropagation()
			// if (((! _scroller && e.target) && e.target.parent) && (e.target.parent.instanceof(ChatToolGridItem) || e.target.parent.instanceof(ChatToolBagItem)) ) {
			// 	e.target.parent.dispatchEventWith(Laya.TouchEvent.TOUCH_TAP, false, e)
			// }
		}

		// this.setData = ( point?, is_down?) => {
		// 	btnX = point.x
		// 	btnY = point.y
		// 	is_down = is_down
		// }

		this.initView = (type?) => {
			// this.itemScroller.stopAnimation()
			let data = null
			let itemRenderer = null
			data = _model.faceList()
			// itemRenderer = ChatToolGridItem
			// if (! item_arrayCollection ) {
			// 	item_arrayCollection = local_eui. new ArrayCollection(data)
			// 	this.content_list.dataProvider = item_arrayCollection
			// 	this.content_list.itemRenderer = itemRenderer
			// 	let vayout = local_eui. new TileLayout()
			// 	vayout.horizontalGap = 12
			// 	vayout.verticalGap = 12
			// 	vayout.verticalAlign = Laya.VerticalAlign.TOP
			// 	this.content_list.layout = vayout
			// 	this.itemScroller.viewport = this.content_list
			// }else{
			// 	item_arrayCollection.source = data
			// }
			// this.itemScroller.viewport.scrollV = 0
			// this.itemScroller.viewport.validateNow()


			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, ChatToolGridItem,data, LoopScrCon.Vertical, 6)
			} else {
				this.loop_mgr.replaceAll(data)
			}
		}

		this.setLocal = (point?) => {
			let btnX = point.x
			let btnY = point.y
			// this.display_obj.x = btnX - this.display_obj.width + 200 - 28
			this.display_obj.y = btnY - this.display_obj.height
			this.arrow.x=0+btnX-this.display_obj.x+20
		}

				
		this.close_callback=()=>{
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr=null
			}
		}
	}

	public Open(...new_args) {

		// this.view_pos, this.touch_screen_pos = ...
		// this.view_pos, this.arrow_pos = ...
		// this.arrow_pos =new_args
		this.localPoint=new_args[0]
		super.Open()
	}

	



	public GetComponents() {
		[
			this.bg,
			this.arrow,
			this.itemScroller,
			this.Content,
		]
			= this.GetChildrenByNames([

				"bg",
				"arrow",
				"itemScroller",
				"Content",
			])
	}
}

window["ChatToolPanel"]=ChatToolPanel