// import { ChatToolGridItem } from "../chat/ChatToolGridItem"
import { ChatToolGridItem } from "../chat/ChatToolGridItem"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { ChatModel } from "../commonModel/ChatModel"
import { FriendModel } from "../commonModel/FriendModel"
import { GameResPath } from "../util/GameResPath"

export class FriendFacePanel extends BaseView1 {
	InitEvent
	LoadSuccess
	_scroller
	back_login_toClose
	background_alpha
	close_callback
	content_list
	destroy_imm
	item_arrayCollection
	loop_mgr
	open_callback
	open_mode
	setLocal
	x
	y
	_Image1: Laya.Image
	_Image2: Laya.Image

	itemScroller
	Content
	FriendModel: any
	public localPoint

	public constructor() {
		super()


		this.content_list = []
		this._scroller = false;
		this.base_file = "chat"
		this.layout_file = "FriendFacePanel"
		this.layer_value = Enum_UILayer.Top
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.back_login_toClose = true
		this.background_alpha = 0
		this.click_bg_toClose = true
		this.use_background = true

		this.load_callback = () => {
			this.InitEvent()
		}

		this.open_callback = () => {
			this.LoadSuccess()
			this.setData()
		}

		this.close_callback = () => {
			// this.removeEventListener(Laya.TouchEvent.TOUCH_TAP, this.clickThis, this, true)
			this.item_arrayCollection = null
		}

		this.InitEvent = () => {
			//this:BindEvent(GlobalEventSystem, EventName.STAGE_CLICK_EVENT,() => {
			//this:Close()
			//}
			//)
			//this.itemScroller.addEventListener(Laya.UIEvent.CHANGE_END,() => {
			//this._scroller = false
			//}
			//, this)
			//this.itemScroller.addEventListener(Laya.UIEvent.CHANGE_START,() => {
			//this._scroller = true
			//}
			//, this)
			//this:addEventListener(Laya.TouchEvent.TOUCH_TAP,(e?) => {
			//e:stopImmediatePropagation()
			//// [ts2lua]window下标访问可能不正确
			//// [ts2lua]window下标访问可能不正确
			//if (((! this._scroller && e.target) && e.target.parent) && (e.target.parent.instanceof(window["ChatToolGridItem"]) || e.target.parent.instanceof(window["ChatToolBagItem"])) ) {
			//e.target.parent.dispatchEventWith(Laya.TouchEvent.TOUCH_TAP, false, e)
			//}
			//}
			//, this, true, 1)
		}

		this.LoadSuccess = () => {

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("chat","friend_bg01"))
			this.setLocal(this.localPoint)
		}

		this.setLocal = (point?) => {
			let btnX = point.x
			let btnY = point.y
			this.display_obj.x = btnX - this.display_obj.width + 200 - 28
			this.display_obj.y = btnY - this.display_obj.height
		}

		
		this.close_callback=()=>{
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr=null
			}
		}


	}

	public setData() {

		// this.itemScroller.stopAnimation()
		let data = ChatModel.GetInstance().faceList()

		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this.Content, ChatToolGridItem,data, LoopScrCon.Vertical, 6)
		} else {
			this.loop_mgr.replaceAll(data)
		}
	}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.itemScroller,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"itemScroller",
				"Content",
			])
	}
}

window["FriendFacePanel"] = FriendFacePanel