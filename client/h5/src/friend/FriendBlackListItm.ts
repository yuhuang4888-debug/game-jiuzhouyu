import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"

export class FriendBlackListItm extends BaseItemRenderer {
	_head_main
	_model
	_vo
	head

	_lb_name
	lb_online
	_lb_fight
	btn_no
	touchGroup
	clickGroup: Laya.Box
	_Image1: Laya.Image
	_Group1: Laya.Box
	labelDisplay: Laya.Label
	_Image2: Laya.Image


	public HEIGT = 120
	public WIDTH = 554
	public constructor(parent) {
		super()

		this.base_file = "friend"
		this.layout_file = "FriendBlackListItm"
		// this.skinName="resource/game/friend/exml/FriendBlackListItmExml.exml"
		this._model = FriendModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		this.InitEvents()
	}

	public InitEvents() {
		let noClick = () => {
			if(this._vo)
				this._model.Fire(FriendEvent.FRIENDS_OPERATIONT, 3, this._vo.role_id)
		}

		Util.AddClickEvent(this.btn_no, noClick, this, true)
		Util.AddClickEvent(this.touchGroup, (e?, x?, y?) => {
			if (!this.data || RoleManager.GetInstance().GetMainRoleId() == this.data.role_id) {
				return
			}
			//Laya.Tween.get(this.clickGroup):to({scaleX=0.85, scaleY=0.85}, 50, Laya.Ease.circIn).to({scaleX=1, scaleY=1}, 100, Laya.Ease.circOut)
			this._model.Fire(FriendEvent.OPEN_FRIEND_MENU, e.stageX, e.stageY, this._vo)
			//evt:stopImmediatePropagation()
		}, this)
	}

	public dataChanged() {
		if(super.dataChanged()){
			this._vo = this.data
			if (this._vo.online_flag == 1) {
				this.lb_online.text = "(在线)"
				this.lb_online.color="#0a953e"
			} else if (this._vo.online_flag == 0) {
				let str = "(离线)"
				this.lb_online.text = str
				this.lb_online.color="#ff4f50"
			}
			// [ts2lua]lua中0和空字符串也是true，此处this._vo.online_flag == 0需要确认
			// this.lb_online.textFlow = Util.StrToHTML(this._vo.online_flag == 0 && "<font color='#ff4f50'>(离线)</font>" || "<font color='#639c12'>(在线)</font>")
			this._lb_name.text = this._vo.role_name
			this._lb_fight.text = String(this._vo.combat_power)
			let frame_id = DressModel.GetInstance().GetDressByType(this._vo.dress_list, DressType.Photo)
			//this._playerHead.setData(this._vo.lv, this._vo.career, this._vo.picture, null, null, frame_id)
			if (this._head_main == null) {
				this._head_main = new CustomHeadItem(this.head)
				this._head_main.SetActiveLevel(true)
				this._head_main.Load()
			}
			this._head_main.SetRoleVoData(this._vo, null, null, this._vo.lv)
		}
	}

	public DeleteMe() {
		//this._playerHead.DeleteMe()
		if (this._head_main) {
			this._head_main.DeleteMe()
			this._head_main = null
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.clickGroup,
			this._Image1,
			this._Group1,
			this._lb_name,
			this.lb_online,
			this._lb_fight,
			this.btn_no,
			this.labelDisplay,
			this._Image2,
			this.touchGroup,
			this.head,
		]
			= this.GetChildrenByNames([

				"clickGroup",
				"_Image1",
				"_Group1",
				"_lb_name",
				"lb_online",
				"_lb_fight",
				"btn_no",
				"labelDisplay",
				"_Image2",
				"touchGroup",
				"head",
			])
	}
}

window["FriendBlackListItm"] = FriendBlackListItm