import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Util } from "../util/Util"

export class FriendApllyPopItem extends BaseItemRenderer {
	_head_main
	_model
	_vo
	head

	_vip_icon
	_lb_name
	_lb_level
	_lb_fight
	btn_no
	btn_yes
	_Image1: Laya.Image
	_Image2: Laya.Image

	public HEIGT = 92
	public WIDTH = 553
	public constructor(parent) {
		super()

		this.base_file = "friend"
		this.layout_file = "FriendApllyPopItem"
		// this.skinName="resource/game/friend/exml/FriendApllyPopItemExml.exml"
		this._model = FriendModel.GetInstance()
		this.Load()
	}

	public load_callback() {

		let noClick = () => {
			this._model.Fire(FriendEvent.ONE_APPLY, this._vo.role_id, 0)
		}

		Util.AddClickEvent(this.btn_no, noClick, this, true)
		let yesClick = () => {
			this._model.Fire(FriendEvent.ONE_APPLY, this._vo.role_id, 1)
		}

		Util.AddClickEvent(this.btn_yes, yesClick, this, true)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._vo = this.data
			this._lb_name.text = this._vo.role_name
			// [ts2lua]lua中0和空字符串也是true，此处this._vo.lv > 370需要确认
			let lv = this._vo.lv > 370 && "神创" + (this._vo.lv - 370) || "LV." + this._vo.lv
			this._lb_level.text = lv
			this._lb_fight.text = String(this._vo.combat_power)
			let vip_Lv = this._vo.vip
			this._vip_icon.visible = vip_Lv != null && vip_Lv > 0
			if (this._vip_icon.visible) {
				let str = "uivip_zjm_" + vip_Lv
				ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str)
			}
			let frame_id = DressModel.GetInstance().GetDressByType(this._vo.dress_list, DressType.Photo)
			//this._playerHead.setData(null, this._vo.career, this._vo.picture, null, null, frame_id)
			if (this._head_main == null) {
				this._head_main = new CustomHeadItem(this.head)
				this._head_main.Load()
			}
			this._head_main.SetRoleVoData(this._vo)
		}
	}

	public DeleteMe() {

		if (this._head_main) {
			this._head_main.DeleteMe()
			this._head_main = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this._vip_icon,
			this._lb_name,
			this._lb_level,
			this._lb_fight,
			this.btn_no,
			this.btn_yes,
			this._Image2,
			this.head,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_vip_icon",
				"_lb_name",
				"_lb_level",
				"_lb_fight",
				"btn_no",
				"btn_yes",
				"_Image2",
				"head",
			])
	}
}

window["FriendApllyPopItem"] = FriendApllyPopItem