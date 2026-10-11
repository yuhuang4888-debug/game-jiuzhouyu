import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { FriendModel } from "../commonModel/FriendModel"
import { GuildModel } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { ApplyTabBtn } from "./ApplyTabBtn"
import { GuestApplyItem } from "./GuestApplyItem"
import { InvitedRenderer } from "./InvitedRenderer"

export class BanquetInviteView extends BaseView1 {
	InitInfo
	RefinviteArr
	RefinvitedArr
	ReftabArr
	SelectTab
	UpdateView
	inviteArr: LoopScrowViewMgr
	invitedArr
	invitedInfo
	model: BanquetModel
	tabArr:LoopScrowViewMgr
	UpdateTab


	public constructor() {
		super()


		this.model = BanquetModel.GetInstance();
		this.invitedInfo = [];
		this.base_file = "marriage2"
		this.layout_file = "BanquetInviteView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.change_scene_close = true
		let local_BanqEvent = BanqEvent
		let guild_model = GuildModel.GetInstance()

		this.preload_server_config = {"config_wedding_info": false}
		this.load_callback = () => {

			this.model.Fire(local_BanqEvent.REQUET_PROTO, 40006)
			this.model.Fire(local_BanqEvent.REQUET_PROTO, 17252)
			this.model.Fire(local_BanqEvent.REQUET_PROTO, 17260, "hc", 1, 2)
			this.InitInfo()
		}

		this.destroy_callback = () => {
			if (this.inviteArr) {
				this.inviteArr.DeleteMe()
				this.inviteArr = null
			}
			if (this.invitedArr) {
				this.invitedArr.DeleteMe()
				this.invitedArr = null
			}
			if (this.tabArr) {
				this.tabArr.DeleteMe()
				this.tabArr = null
			}
		}

		this.UpdateTab=()=>{
			if (this.model.AskData && this.model.AskData.length > 0) {
				this.ReftabArr([{ name: "好友" }, { name: "结社" }, { name: "申请信息" }])
				this.model.newApply = true
			} else {
				this.ReftabArr([{ name: "好友" }, { name: "结社" }])
				this.model.newApply = false
			}
		}

		this.InitInfo = () => {

			this.UpdateTab()
			ResManager.GetInstance().SetTexture(this, this.BG2, GameResPath.GetIcon("marriage2", "uijh_116"))
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.addBtn, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BuyInviteView")
			}, this, true)


			Util.AddClickEvent(this._btn_onekey, () => {
				//一键邀请
				this.model .Fire(BanqEvent.REQUET_PROTO, 17298)
			}, this, true)



			this.BindEvent(this.model, local_BanqEvent.INVITE_DATA, (info_list?) => {
				if (!info_list) {
					return
				}
				this.default2.visible = info_list.length == 0
				this.RefinvitedArr(info_list)
				if (this.model.AskData && this.model.AskData.length > 0) {
					this.ReftabArr([{ name: "好友" }, { name: "结社" }, { name: "申请信息" }])
					this.model.newApply = true
				} else {
					this.ReftabArr([{ name: "好友" }, { name: "结社" }])
					this.model.newApply = false
					if (this.Content11.selectedIndex == 2) {
						this.tabArr.SetSelectIndex(1)
					}
				}
				this.SelectTab(this.Content11.selectedIndex )
			}
			)
			this.BindEvent(this.model, local_BanqEvent.ASK_DATA, () => {
				this.UpdateTab()
				if (this.Content11.selectedIndex == 2) {
					this.SelectTab(2)
				}
			}
			)
			this.BindEvent(this.model, local_BanqEvent.INVITE_VIEW_DATA, () => {
				this.SelectTab(this.Content11.selectedIndex )
				this.UpdateView()
			}
			)
			this.BindVar(guild_model, "member_info", () => {
				if (this.Content11.selectedIndex == 1) {
					this.SelectTab(1)
				}
			}
			)


			this.UpdateView()
			this.SelectTab(0)
		}

		this.UpdateView = () => {
			let Info = this.model.InviteViewData
			if (Info) {
				this.canApplyLabel.text = "当前可邀请:" + Info.less_invite_num + "/" + Info.guest_num
				this.default2.visible = Info.guest_list.length == 0
				this.RefinvitedArr(Info.guest_list)
				let wedding_info_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_info", false)
				// [ts2lua]wedding_info_cfg下标访问可能不正确
				let cfg = wedding_info_cfg[Info.wedding_type]
				if (cfg) {
					this.applyLabel.text = "当前婚宴可免费邀请" + cfg.guest_num + "位宾客，请选择要宴请的宾客"
				}
			}
		}

		this.SelectTab = (index?) => {
			let data = null
			if (0 == index) {
				data = FriendModel.GetInstance().getFriendData(1, false)
			} else if (1 == index) {
				let vo = guild_model.GetMemberInfo()
				data = (vo && (vo.member_list) || ({}))
			} else if (2 == index) {
				data = this.model.AskData || {}
				for (let _tmpi in data) {
					var vo = data[_tmpi]
					vo.isAsk = true
				}
			}
			let realData = []
			let hasInvitedList = BanquetModel.GetInstance().guestList
			let roleId = RoleManager.GetInstance().GetMainRoleId()
			// [ts2lua]lua中0和空字符串也是true，此处this.model.InviteViewData需要确认
			let loverId = (this.model.InviteViewData && (this.model.InviteViewData.lover_role_id) || (0))
			if (data) {
				if (hasInvitedList) {
					let invited = null
					for (let _tmpi in data) {
						var vo = data[_tmpi]
						invited = false
						for (let _tmpi in hasInvitedList) {
							var hasVo = hasInvitedList[_tmpi]
							if (vo.role_id == hasVo.role_id) {
								invited = true
								break
							}
						}
						if (roleId == vo.role_id || vo.role_id == loverId) {
							invited = true
						}
						if (!invited) {
							table.insert(realData, vo)
						}
					}
				} else {
					realData = data
				}
			}
			this.default1.visible = !realData || realData.length == 0
			this.RefinviteArr(realData)
		}

		this.RefinviteArr = (list?) => {
			if (!this.inviteArr) {
				this.inviteArr = new LoopScrowViewMgr()
				this.inviteArr.SetData(this.Content, GuestApplyItem, list, LoopScrCon.Vertical, 0)
			} else {
				this.inviteArr.replaceAll(list)
			}
		}

		this.RefinvitedArr = (list?) => {
			if (!this.invitedArr) {
				this.invitedArr = new LoopScrowViewMgr()
				this.invitedArr.SetData(this.Content1, InvitedRenderer, list, LoopScrCon.Vertical, 0)
			} else {
				this.invitedArr.replaceAll(list)
			}
		}

		this.ReftabArr = (list?) => {
			if (!this.tabArr) {
				let func = (e?) => {
					this.SelectTab(e)
					if (e == 2) {
						this.model.newApply = false
						this.model.ChangeVar("newApply", false)
					}
				}
				this.tabArr = new LoopScrowViewMgr()
				this.tabArr.SetData(this.Content11, ApplyTabBtn, list, LoopScrCon.Horizontal, 0, func)
				// this.tabArr.SetSelectIndex(0)
			} else {
				this.tabArr.replaceAll(list)
			}
		}

	}


BG2:Laya.Image
closeBtn:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
addBtn:Laya.Image
_Image8:Laya.Image
_Image9:Laya.Image
applyLabel:Laya.Label
canApplyLabel:Laya.Label
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
tabBtnList:Laya.HBox
Content1:Laya.List
Content11:Laya.List
Content:Laya.List
default1:Laya.Label
default2:Laya.Label
_btn_onekey:Laya.Box
_img_onekey:Laya.Image
_lb_onekey:Laya.Label
public GetComponents() {
[
this.BG2,
this.closeBtn,
this._Image3,
this._Image4,
this._Image5,
this.addBtn,
this._Image8,
this._Image9,
this.applyLabel,
this.canApplyLabel,
this._Label1,
this._Label2,
this._Label3,
this.tabBtnList,
this.Content1,
this.Content11,
this.Content,
this.default1,
this.default2,
this._btn_onekey,
this._img_onekey,
this._lb_onekey,
]
 = this.GetChildrenByNames([

"BG2",
"closeBtn",
"_Image3",
"_Image4",
"_Image5",
"addBtn",
"_Image8",
"_Image9",
"applyLabel",
"canApplyLabel",
"_Label1",
"_Label2",
"_Label3",
"tabBtnList",
"Content1",
"Content11",
"Content",
"default1",
"default2",
"_btn_onekey",
"_img_onekey",
"_lb_onekey",
])
}
}
 window["BanquetInviteView"]= BanquetInviteView