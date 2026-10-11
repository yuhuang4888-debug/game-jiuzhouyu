import { BaseView1 } from "../common/BaseView1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { RedPacketDetailItem } from "./RedPacketDetailItem"
import { RedPacketModel } from "../commonModel/RedPacketModel"

export class RedPacketDetailView extends BaseView1 {
	Clear
	InitEvent
	LoadSuccess
	Local_Open
	Scr_Scroller1
	UpdateView

	_list
	click_bg_toClose
	destroy_callback
	destroy_imm
	head_item
	is_center
	open_callback
	use_background

	public constructor() {
		super()

		this.base_file = "redPacket"
		this.layout_file = "RedPacketDetailView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		let _rp_data_ = null
		this.show_open_movie=true
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.Local_Open = (parms?) => {
			_rp_data_ = parms
			super.Open()
			// super.Open(this)
		}

		this.Clear = () => {
			if (this._list) {
				this._list.DeleteMe()
				this._list = null
			}
			this.head_item.DeleteMe()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_018, GameResPath.GetIcon("redPacket", "uighhb_018"))
			// _ac_list_ = eui. new ArrayCollection()
			// this._list.dataProvider = _ac_list_
			// this._list.itemRenderer = RedPacketDetailItem

			this._list = new LoopScrowViewMgr()
			this.InitEvent()

			this.head_item = new CustomHeadItem(this._img_head)
			this.head_item.Load()
			this.head_item.ExcuteCallback(() => {
				//this.head_item.SetAnchoredPosition(0, 0)
			})
		}

		this.InitEvent = () => {

		}

		this.UpdateView = () => {
			if (!_rp_data_) {
				return
			}
			let data = _rp_data_
			// _ac_list_.source = data.recipient_list
			this._list.SetData(this._list_infos, RedPacketDetailItem, data.recipient_list, LoopScrCon.Vertical)
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			// _model.SetRoleHead(this, this._img_head, role_vo.career, role_vo.picture)
			this.head_item.SetRoleVoData(role_vo)
			this._lb_name.text = role_vo.name
			let count = HtmlColorTxt(data.recipients_num + "/" + data.total_num, "'#d15e00'")
			let money = HtmlColorTxt(data.money, "'#d15e00'")

			SetHtmlStyle(this._lb_tips, { f: 18, c: "#663915", ww: false })
			this._lb_tips.innerHTML = `已领取${count}个，共${money}个`

			let pic = (data.type == 100 && ("com_diamond") || ("com_bind_diamond"))
			ResManager.GetInstance().SetImageSprite(this, this._img_tips, "common_asset", pic)
			let isGet = data.receive_money > 0
			this._lb_hasnt.visible = !isGet
			this._gp_money.visible = isGet
			if (isGet) {
				this._lb_money.text = data.receive_money
				// this._img_money.source = pic
				ResManager.GetInstance().SetImageSprite(this, this._img_money, "common_asset", pic)
			}
		}
	}

	public Open(parms?) {

		this.Local_Open(parms)
	}

_img_018:Laya.Image
_img_head:Laya.Image
_lb_name:Laya.Label
_lb_hasnt:Laya.Label
_gp_money:Laya.HBox
_lb_money:Laya.Label
_img_money:Laya.Image
_Group1:Laya.HBox
_lb_tips:Laya.HTMLDivElement
_img_tips:Laya.Image
_list_infos:Laya.List
public GetComponents() {
[
this._img_018,
this._img_head,
this._lb_name,
this._lb_hasnt,
this._gp_money,
this._lb_money,
this._img_money,
this._Group1,
this._lb_tips,
this._img_tips,
this._list_infos,
]
 = this.GetChildrenByNames([

"_img_018",
"_img_head",
"_lb_name",
"_lb_hasnt",
"_gp_money",
"_lb_money",
"_img_money",
"_Group1",
"_lb_tips",
"_img_tips",
"_list_infos",
])
}
}
 window["RedPacketDetailView"]= RedPacketDetailView