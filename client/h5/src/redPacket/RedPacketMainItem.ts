import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { RedPacketEvent, RedPacketModel, RedPacketStatus } from "../commonModel/RedPacketModel"

export class RedPacketMainItem extends BaseItemRenderer {
	Emp_btn_look
	_model
	_status
	head_item

	public WIDTH = 175
	public HEIGT = 237

	is_set: boolean = false

	public constructor(parent) {
		super()

		this._status = RedPacketStatus.Look;
		this.base_file = "redPacket"
		this.layout_file = "RedPacketMainItem"
		this._model = RedPacketModel.GetInstance()

		this.load_callback = () => {
			this.load_callback1()

			if (!this.is_set) {
				this.SetData(this.data)
			}
		}

		this.Load()
	}

	public DeleteMe() {
		if(this.head_item){
			this.head_item.DeleteMe()
			this.head_item = null
		}
		super.DeleteMe()
	}

	public load_callback1() {
		// super.createChildren()
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_007, GameResPath.GetIcon("redPacket", "uighhb_007"))
		Util.AddClickEvent(this._btn_look, () => {
			let data = this.data
			let mdata = this._model.GetRedMsgDic(data.id)
			if (data.recipients_num == data.total_num && mdata) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RedPacketDetailView", mdata)
			} else {
				this._model.Fire(RedPacketEvent.REQUEST_PROTO, 33902, "l", data.id)
			}
		}
			, this, true)
		Util.AddClickEvent(this._btn_open, () => {
			this._model.Fire(RedPacketEvent.REQUEST_PROTO, 33902, "l", this.data.id)
		}
			, this, true)
		Util.AddClickEvent(this._btn_send, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RedPacketCtrlView", this.data)
		}
			, this, true)

		this.head_item = new CustomHeadItem(this._img_head)
		this.head_item.SetActiveBg2(false)
		this.head_item.Load()
		this.head_item.ExcuteCallback(() => {
			//this.head_item.SetAnchoredPosition(0, 0)
		})

		//估计是平台的东西，先屏蔽
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
		// 	this._lb_name.size = 18
		// }
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
		// 	this._lb_name.size = 16
		// 	this._lb_count.size = 16
		// 	this._lb_name.lineSpacing = 0.6
		// 	let csf = this._lb_name.GetComponent("ContentSizeFitter")
		// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
		// 	SetSizeDeltaX(this._lb_name, 188)
		// 	this._lb_name.verticalAlign = "middle"
		// 	this._lb_name.textAlign = "center"
		// }
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		// if (! super.dataChanged() ) {
		// 	return
		// }
		if (this.is_loaded) {
			this.is_set = true
			this.SetData(this.data)
		} else {
			this.is_set = false
		}
	}


	SetData(data) {
		if(!data)return
		if (data.type == 100) {
			this._lb_name.text = data.msg
		} else {
			let config = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_red_envelopes", false)
			//let config = Config.Redenvelopes
			let rdata = this._model.GetRedPacketData(this.data.extra, config)
			// [ts2lua]lua中0和空字符串也是true，此处rdata需要确认
			this._lb_name.text = (rdata && (rdata.name) || ("红包"))
		}
		// this._model.SetRoleHead(this, this._img_head, data.carrer, data.picture)
		this.head_item.SetRoleVoData(data)
		this._lb_role_name.text = data.role_name
		let role_id = RoleManager.GetInstance().GetMainRoleId()
		if (data.receive_status == 2) {
			this._status = RedPacketStatus.Open
		} else if (data.status == 0) {
			// [ts2lua]lua中0和空字符串也是true，此处data.role_id == role_id需要确认
			this._status = (data.role_id == role_id && (RedPacketStatus.Send) || (RedPacketStatus.Other))
		} else if (data.status == 1 && data.receive_status == 0) {
			this._status = RedPacketStatus.Open
		} else {
			this._status = RedPacketStatus.Look
			// [ts2lua]lua中0和空字符串也是true，此处data.receive_status == 1需要确认
			let str = (data.receive_status == 1 && ("已领取") || ("派完啦！"))
			this._lb_count.text = str + "(" + data.recipients_num + "/" + data.total_num + ")"
		}
		this._btn_look.visible = this._status == RedPacketStatus.Look
		this._btn_open.visible = this._status == RedPacketStatus.Open
		this._btn_send.visible = this._status == RedPacketStatus.Send
		this._gp_look.visible = this._status == RedPacketStatus.Look
		this._lb_other.visible = this._status == RedPacketStatus.Other
	}

	
	_img_007: Laya.Image
	_Image1: Laya.Image
	_img_head: Laya.Image
	_lb_role_name: Laya.Label
	_lb_name: Laya.Label
	_lb_other: Laya.Label
	_btn_open: Laya.Image
	_btn_send: Laya.Image
	_img_split: Laya.Image
	_gp_look: Laya.Box
	_lb_count: Laya.Label
	_btn_look: Laya.Box
	_Label1: Laya.Label
	public GetComponents() {
		[
			this._img_007,
			this._Image1,
			this._img_head,
			this._lb_role_name,
			this._lb_name,
			this._lb_other,
			this._btn_open,
			this._btn_send,
			this._img_split,
			this._gp_look,
			this._lb_count,
			this._btn_look,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_img_007",
				"_Image1",
				"_img_head",
				"_lb_role_name",
				"_lb_name",
				"_lb_other",
				"_btn_open",
				"_btn_send",
				"_img_split",
				"_gp_look",
				"_lb_count",
				"_btn_look",
				"_Label1",
			])
	}
}
window["RedPacketMainItem"] = RedPacketMainItem