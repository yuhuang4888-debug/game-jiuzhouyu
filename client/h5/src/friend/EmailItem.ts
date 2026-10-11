import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { PlatformManager } from "../PlatformManager"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

export class EmailItem extends BaseItemRenderer {
	_model
	bg
	emailId
	time2
	read
	unread
	rewardImg
	click
	title
	time
	time2_text
	getImg
	public HEIGT = 119
	public WIDTH = 676
	public constructor(parent) {
		super()


		this.base_file = "friend"
		this.layout_file = "EmailItem"
		// this.skinName="resource/game/friend/exml/EmailItemExml.exml"
		this._model = FriendModel.GetInstance()
		this.Load()
		// this.load_callback()
	}

	public load_callback() {
		let Click = () => {
			//SoundManager:GetInstance():PlaySoundEffect("2_dianji")
			this._model.Fire(FriendEvent.REQUEST_EMAIL_INFO, this.emailId)
		}

		Util.AddClickEvent(this.click, Click, this, true)

		if (PlatformManager.IsEyouEnPlatform()) {
			this.title.size = 20
			this.time.size = 20
		}
	}
	public dataChanged() {
		if(super.dataChanged()){
			if (this.data == null) { return }
			this.emailId = this.data.mail_id
			this.title.text = this.data.title
			this.read.visible = this.data.state == 1 || this.data.state == 3
			this.unread.visible = !this.read.visible
			this.rewardImg.visible = this.data.is_attach == 1 && this.data.state != 3
			this.getImg.visible=!this.rewardImg.visible
			if(this.getImg.visible){
				this.getImg.visible= this.data.is_attach==0 ? false :true
			}
			if (this.read.visible) {
				// this.bg.alpha = 0.7
			} else {
				this.bg.alpha = 1
			}
			this.time.text = TimeUtil.timeConversion(this.data.time, "yyyy-mm-dd hh:MM:ss")
		}
	}


	public GetComponents() {
		[
			this.bg,
			this.title,
			this.time,
			this.time2,
			this.read,
			this.unread,
			this.rewardImg,
			this.click,
			this.getImg

		]
			= this.GetChildrenByNames([

				"bg",
				"title",
				"time",
				"time2",
				"read",
				"unread",
				"rewardImg",
				"click",
				"getImg"
			])
	}
}

window["EmailItem"] = EmailItem