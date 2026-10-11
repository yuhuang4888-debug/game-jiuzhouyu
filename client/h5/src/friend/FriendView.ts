import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { FriendEvent, FriendModel, FRIEND_TYPE } from "../commonModel/FriendModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendListItem } from "./FriendListItem"

export class FriendView extends BaseItem1 {
	InitEvent
	LoadSuccess
	_model
	loop_mgr
	story_obj_list
	updateFriendList
	updateInfo

	nullGroup
	btnBlacklist
	btnAdd
	btnAplly
	redDot
	itemScroller
	Content
	numlabel
	_Label1
	_Label2
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image

	public constructor(parent?) {
		super(parent)


		this.base_file = "friend"
		this.layout_file = "FriendView"
		let arrayCollection = null
		let timer = null
		let friendList = []
		let local_FriendEvent = FriendEvent
		this.load_callback = () => {
			this._model = FriendModel.GetInstance()
			this.LoadSuccess()
			this.InitEvent()

			//	GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.FriendIcon, false)
		}

		this.createChildren = () => {
			this.story_obj_list = this.story_obj_list || {}
			// [ts2lua]this.story_obj_list下标访问可能不正确
			this.story_obj_list[TaskTipType.AddFriend] = [this.btnAdd]
			super.createChildren()
		}

		this.InitEvent = () => {
			let blacklistClick = () => {
				this._model.Fire(local_FriendEvent.OPEN_BLACK_VIEW)
			}

			Util.AddClickEvent(this.btnBlacklist, blacklistClick, this, true)
			let addClick = () => {
				this._model.Fire(local_FriendEvent.OPEN_ADD_VIEW)
			}

			Util.AddClickEvent(this.btnAdd, addClick, this, true)
			let apllyClick = () => {
				this._model.Fire(local_FriendEvent.OPEN_APPLY_VIEW)
				this._model.SethaveNewApply(false)
				this.redDot.visible = false
			}

			Util.AddClickEvent(this. btnAplly, apllyClick, this, true)
			let update = (...new_args) => {
				let args = new_args
				if (args[0] == FRIEND_TYPE.FRIEND) {
					this.updateFriendList()
				}
			}

			this.BindEvent(this._model, local_FriendEvent.FRIEND_DATA_UPDATE, update)
			let updateOline = () => {
				this.updateFriendList()
			}

			this.BindEvent(this._model, local_FriendEvent.FRIEND_OLINE_UPDATE, updateOline)
			this.BindEvent(this._model, local_FriendEvent.INTIMACY_UPDATE, updateOline)
			let redDot = () => {
				this.redDot.visible = this._model.GethaveNewApply()
			}

			this.BindEvent(this._model, local_FriendEvent.FRIEND_REDDOT_UPDATE, redDot)
		}

		this.LoadSuccess = () => {


			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label1.size = 18
				this._Label2.size = 18
			}


			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_shade, GameResPath.GetIcon("friend","friend_line"))
			FriendModel.GetInstance().Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.FRIEND)
		}

		this.updateFriendList = () => {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, FriendListItem, this.GetdataList(), LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(this.GetdataList())
			}
			this.updateInfo()
		}

		this.updateInfo = () => {
			let num = this._model.getOnlineDataNum(FRIEND_TYPE.FRIEND)
			this.numlabel.text =num + "/" + this.GetdataList().length
			this.redDot.visible = this._model.GethaveNewApply()
			this.nullGroup.visible = (this._model.getFriendData(FRIEND_TYPE.FRIEND)<= 0)
		}


	}

	public GetdataList() {

		return this._model.getFriendData(FRIEND_TYPE.FRIEND, true)
	}

	public DeleteMe() {

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image1,
			this.nullGroup,
			this._Image2,
			this._Image3,
			this._Label1,
			this._Label2,
			this._Image4,
			this.itemScroller,
			this.Content,
			this.numlabel,
			this.btnBlacklist,
			this.btnAdd,
			this.btnAplly,
			this.redDot,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"nullGroup",
				"_Image2",
				"_Image3",
				"_Label1",
				"_Label2",
				"_Image4",
				"itemScroller",
				"Content",
				"numlabel",
				"btnBlacklist",
				"btnAdd",
				"btnAplly",
				"redDot",
			])
	}
}

window["FriendView"] = FriendView