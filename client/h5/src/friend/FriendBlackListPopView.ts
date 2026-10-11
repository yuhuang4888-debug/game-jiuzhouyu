import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { FriendModel, FRIEND_TYPE, FriendEvent } from "../commonModel/FriendModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendBlackListItm } from "./FriendBlackListItm"

export class FriendBlackListPopView extends BaseView1 {
	InitEvent
	back_login_toClose
	click_bg_toClose
	close_callback
	initData
	is_center
	loop_mgr
	open_callback
	show_open_movie
	use_background
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Label1: Laya.Label
	_Group1: Laya.Box
	_Image5: Laya.Image
	_Label2: Laya.Label
	_Image6: Laya.Image
	Image: Laya.Image

	nullGroup
	btnClose
	Content
	itemScroller
	_Image1

	public constructor() {
		super()

		this.base_file = "friend"
		this.layout_file = "FriendBlackListPopView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.destroy_imm=true
		let _model = FriendModel.GetInstance()
		let local_FRIEND_TYPE = FRIEND_TYPE
		let local_FriendEvent = FriendEvent
		this.load_callback = () => {

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("common", "uity_080"))
			this.InitEvent()
		}

		this.close_callback = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.open_callback = () => {
			FriendModel.GetInstance().Fire(local_FriendEvent.REQUEST_FRIEND_DATA, local_FRIEND_TYPE.BLACKLIST)
		}

		this.InitEvent = () => {
			let closeClick = () => {
				this.Close()
			}

			Util.AddClickEvent(this.btnClose, closeClick, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			let update = (...new_args) => {
				let args = new_args
				if (args[0] == local_FRIEND_TYPE.BLACKLIST) {
					this.initData()
				}
			}

			this.BindEvent(_model, local_FriendEvent.FRIEND_DATA_UPDATE, update)
		}

		this.initData = () => {
			if (this.is_loaded) {
				let list = _model.getFriendData(local_FRIEND_TYPE.BLACKLIST, true)
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content, FriendBlackListItm, list, LoopScrCon.Vertical, 1)
				} else {
					this.loop_mgr.replaceAll(list)
				}
				this.nullGroup.visible = list.length == 0
			}
		}


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
			this.Image,
			this.btnClose,
			this.itemScroller,
			this.Content,
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
				"Image",
				"btnClose",
				"itemScroller",
				"Content",
			])
	}
}

window["FriendBlackListPopView"] = FriendBlackListPopView