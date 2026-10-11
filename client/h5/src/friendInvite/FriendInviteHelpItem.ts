import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { FriendInviteModel } from "../commonModel/FriendInviteModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"

export class FriendInviteHelpItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_desc: Laya.Label
	_img_head: Laya.Image
	_Image11: Laya.Image
	_lb_cond: Laya.HTMLDivElement
	_Group1: Laya.HBox
	_Label1: Laya.Label
	_lb_reward: Laya.Label
	_img_icon: Laya.Image
	_btn_get: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_img_red: Laya.Image
	_img_head0: Laya.Image
	receive: Laya.Image
	Emp_btn_get
	state
	public static width = 177
	public static height = 344
	WIDTH = 159
	HEIGT = 341
	public constructor(parent) {
		super()

		this.base_file = "friendInvite"
		this.layout_file = "FriendInviteHelpItem"
		this.load_callback = () => {
			let circle_mask = new Laya.Sprite()
			this._img_head.mask = circle_mask
			//this._img_head.addChild(circle_mask)
			circle_mask.graphics.drawPie(this._img_head.width / 2, this._img_head.height / 2, this._img_head.width / 2, 0, 360, "#ffffff")
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("friendInvite", "uiyqkbx_020"), true)
			Util.AddClickEvent(this._btn_get, () => {
				if (this.state == 0) {
					Message.show("条件不足")
				} else if (this.state == 1) {
					Message.show("已领取")
				} else if (this.state == 2) {
					if (this.data) {
						FriendInviteModel.GetInstance().Fire(FriendInviteModel.SCMD_REQUEST, 34007, this.data.lv_key, this.data.pos)
					}
				} else if (this.state == 3) {
					Message.show("您当前没有宝箱好友")
				}
			}
				, this, true)
		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_cond.style.fontSize = 20
			this._lb_cond.style.color = "#5a1c20"
			this._lb_cond.style.align = "center"
			this._lb_cond.style.wordWrap = false
			this._lb_reward.text = this.data.reward[2]
			this.receive.visible = true
			this._btn_get.visible = true
			if (this.data.vo) {
				this.state = this.data.vo.status
				this._lb_cond.visible = true
				this._lb_desc.text = this.data.vo.name
				this._lb_cond.innerHTML = "Lv:" + HtmlColorTxt(this.data.vo.lv + "/" + this.data.lv_key, "'#e60909'")
				let a = <Laya.HBox>this._lb_cond.parent
				a.refresh()
				this._img_red.visible = this.state == 2
				this._img_head.visible = true
				this._img_head0.visible = false
				ResManager.GetInstance().SetImageSprite(this, this._img_head,"head_asset", this.data.vo.career + "001")
				//Util.SetImageGray(this._Image1, this.state != 2)
				let source = (this.state != 2) ? "ui_button_rect9" : "ui_button_rect8"
				let strokeColor = (this.state != 2) ? "#d1f6f4" : "#ffffff"
				let color = (this.state != 2) ? "#186e74" : "#a51c1c"
				this.labelDisplay.color = color
				this.labelDisplay.strokeColor = strokeColor
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", source)
				this.receive.visible = this.state == 1 ? true : false
				this._btn_get.visible = this.state != 1 ? true : false
				if (this.state == 0) {
					this.labelDisplay.text = "未达到"
				} else if (this.state == 1) {
					this.labelDisplay.text = "已领取"
				} else if (this.state == 2) {
					this.labelDisplay.text = "领取"
				}
			} else {
				this.receive.visible = false
				this._lb_desc.text = "第" + this.data.pos + "位好友"
				this._lb_cond.visible = false
				this._img_head.visible = false
				this._img_head0.visible = true
				//ResManager.GetInstance().SetImageSprite(this, this._img_head, "common_asset", "ui_button_rect9")
				this.state = 3
				this._img_red.visible = false
				//Util.SetImageGray(this._Image1, true)
				ResManager.GetInstance().SetImageSprite(this, this._Image1, "common_asset", "ui_button_rect9")
				this.labelDisplay.text = "未达到"
				this.labelDisplay.strokeColor = "#d1f6f4"
				this.labelDisplay.color = "#186e74"
			}
			//LayoutRebuilder(this._Group1)
		}
	}


	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._img_head,
			this._Image11,
			this._lb_cond,
			this._Group1,
			this._Label1,
			this._lb_reward,
			this._img_icon,
			this._btn_get,
			this._Image1,
			this.labelDisplay,
			this._img_red,
			this._img_head0,
			this.receive
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_img_head",
				"_Image11",
				"_lb_cond",
				"_Group1",
				"_Label1",
				"_lb_reward",
				"_img_icon",
				"_btn_get",
				"_Image1",
				"labelDisplay",
				"_img_red",
				"_img_head0",
				"receive"
			])
	}
}
window["FriendInviteHelpItem"] = FriendInviteHelpItem