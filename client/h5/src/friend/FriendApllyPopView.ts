import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { LuaSoundManager } from "../common/SoundManager"
import { FriendModel, FriendEvent, FRIEND_TYPE } from "../commonModel/FriendModel"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"
import { FriendApllyPopItem } from "./FriendApllyPopItem"

export class FriendApllyPopView extends BaseView1 {
	InitEvent
	_model
	back_login_toClose
	click_bg_toClose
	close_callback
	destroy_imm
	initData
	is_center
	loop_mgr
	open_callback
	show_open_movie
	use_background

	nullGroup
	btnClose
	passBtn
	rejectBtn
	itemScroller
	Content
	_Group1
	_Label1
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Label2: Laya.Label
	_Image6: Laya.Image

	public constructor() {
		super()


		this.base_file = "friend"
		this.layout_file = "FriendApllyPopView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.back_login_toClose = true
		let arrayCollection = null
		let local_Message = Message
		let local_Util = Util
		this.load_callback = () => {
			this._model = FriendModel.GetInstance()
			this.InitEvent()

			// LayoutRebuilder(this._Group1)
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 20
			// }
		}

		this.open_callback = () => {
			this.initData()
		}

		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.InitEvent = () => {
			let closeClick = () => {
				this.Close()
			}

			Util.AddClickEvent(this.btnClose, closeClick, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			let rejectClick = () => {
				if (this.GetlistLength() > 0) {
					this._model.Fire(FriendEvent.ONECLICK_APPLY, 0)
				} else {
					local_Message.show("当前无好友申请!")
				}
			}

			Util.AddClickEvent(this.rejectBtn, rejectClick, this, true)
			let passClick = () => {
				if (this.GetlistLength() > 0) {
					this._model.Fire(FriendEvent.ONECLICK_APPLY, 1)
				} else {
					local_Message.show("当前无好友申请!")
				}
			}

			Util.AddClickEvent(this.passBtn, passClick, this, true)
			let update = () => {
				this.initData()
			}

			this.BindEvent(this._model, FriendEvent.APPLY_DATA_UPDATE, update)
		}

		this.initData = () => {
			let applyList=this._model.GetapplyList()
			if(applyList.length==0){
				this.nullGroup.visible=true
			}else{
				this.nullGroup.visible=false
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendApllyPopItem, this._model.GetapplyList(),LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(this._model.GetapplyList())
			}
		}


	}

	public GetlistLength() {

		return this._model.GetapplyList().length
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this.nullGroup,
			this._Image4,
			this._Label1,
			this._Group1,
			this._Image5,
			this._Label2,
			this._Image6,
			this.btnClose,
			this.itemScroller,
			this.Content,
			this.passBtn,
			this.rejectBtn,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"nullGroup",
				"_Image4",
				"_Label1",
				"_Group1",
				"_Image5",
				"_Label2",
				"_Image6",
				"btnClose",
				"itemScroller",
				"Content",
				"passBtn",
				"rejectBtn",
			])
	}
}

window["FriendApllyPopView"] = FriendApllyPopView