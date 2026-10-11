import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { SetAnchoredPositionY, Util } from "../util/Util"
import { EmailItem } from "./EmailItem"

export class EmailView extends BaseItem1 {
	InitEvent
	LoadSuccess
	initItme
	loop_mgr
	updateItem

	nullGroup
	btnDelet
	btnGet

	itemScroller
	Content

	_Label2
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_Image3: Laya.Image


	public constructor(parent?) {
		super(parent)


		this.base_file = "friend"
		this.layout_file = "EmailView"
		let _model = FriendModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label2.size  = 16
			// 	SetAnchoredPositionY(this._Label2,-882.8)
			// }
		}
		this.DeleteMe = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			super.DeleteMe()
		}

		this.InitEvent = () => {
			let deletClick = () => {
				//if (! _model.emailHasNoGetReward() ) {
				//Message.show("还有部分附件未领取哦!")
				//return
				//}
				if (_model.GetemailList().length <= 0) {
					Message.show("暂无可删除邮件!")
					return
				}
				let list1 = _model.GetemailList()
				let list = _model.GetNoGetRewardEmailList()
				if (list.length <= 0) {
					Message.show("暂无可删除邮件!")
					return
				}
				_model.Fire(FriendEvent.REQUEST_DELET_EMAIL, list)
			}

			Util.AddClickEvent(this.btnDelet, deletClick, this, true)
			let getClick = () => {
				let get = () => {
					let list = _model.allRewardEmailList()
					_model.Fire(FriendEvent.REQUEST_EMAIL_REWARD, list)
				}

				GoodsModel.GetInstance().CheckEquipNum(1, 0, get)
			}

			Util.AddClickEvent(this.btnGet, getClick, this, true)
			this.BindEvent(_model, FriendEvent.EMAIL_DATA_UPDATE, () => {
				this.updateItem()
			}
			)
			_model.Fire(FriendEvent.REQUEST_EMAIL_DATA)
		}

		this.LoadSuccess = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Label2.size = 18
			}
			FriendModel.GetInstance().is_unread_mail = false
			FriendModel.GetInstance().Fire(FriendEvent.EMAIL_VIEW_OPEN)
			this.initItme()
		}

		this.initItme = () => {

			this.updateItem()
		}

		this.updateItem = () => {
			if (this.is_loaded) {
				let email_List=_model.GetemailList()
				let nullEmail = email_List <= 0
				this.nullGroup.visible = nullEmail
				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content, EmailItem, email_List, LoopScrCon.Vertical, 1)
				} else {
					this.loop_mgr.replaceAll(email_List)
				}
			}
		}


	}

	public GetComponents() {
		[
			this._Image1,
			this.nullGroup,
			this._Image2,
			this._Label1,
			this.itemScroller,
			this.Content,
			this.btnDelet,
			this.btnGet,
			this._Image3,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"nullGroup",
				"_Image2",
				"_Label1",
				"itemScroller",
				"Content",
				"btnDelet",
				"btnGet",
				"_Image3",
				"_Label2",
			])
	}
}


window["EmailView"]=EmailView