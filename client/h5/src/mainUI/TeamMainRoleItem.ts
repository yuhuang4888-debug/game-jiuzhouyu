import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { EventName } from "../common/EventName"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util, SetSizeDeltaX } from "../util/Util"

export class TeamMainRoleItem extends BaseItemRenderer {
	_Image1: Laya.Image
	non_role: Laya.Box
	Image: Laya.Image
	lbl_tips: Laya.Label
	red_point: Laya.Image
	role_group: Laya.Box
	online_img: Laya.Image
	role_head: Laya.Box
	leader_tag: Laya.Image
	head_click_group: Laya.Box
	role_name: Laya.Label
	_Group1: Laya.Box
	destiny_img: Laya.Image
	level: Laya.Label
	quitBtn: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	pleaseLeaveBtn: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	Emphead_click_group
	Empnon_role
	EmppleaseLeaveBtn
	EmpquitBtn
	InitEvent
	Out_Label1
	Out_Label2
	is_delay_callback
	model
	head
	public static width = 222
	public static height = 87

	public constructor(parent) {
		super()

		this.base_file = "team"
		this.layout_file = "TeamMainRoleItem"
		this.WIDTH = 222
		this.HEIGT = 78
		// this.skinName = "resource/game/team/exml/TeamMainRoleItemExml.exml"
		this.model = TeamModel.GetInstance()
		this.is_delay_callback = false
		this.Load()
		// this.load_callback = () => {
		// }
		// this.InitEvent = () => {

		// }
		// this.InitEvent()
	}

	public load_callback() {
		let quit_fun = () => {
			if (this.data) {
				this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
			}
		}

		Util.AddClickEvent(this.quitBtn, quit_fun, this, true)
		let please_leave_fun = () => {
			if (this.data) {
				this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24009, "l", this.data.id)
			}
		}

		Util.AddClickEvent(this.pleaseLeaveBtn, please_leave_fun, this, true)
		let head_click_fun = (e?, x?, y?) => {
			if (this.data) {
				if (RoleManager.GetInstance().mainRoleInfo.role_id == this.data.id || this.data.team_position == 3) {
					return
				}
				let tab_list = [1, 3]
				// let fdata = FriendModel.GetInstance().getFriendById(this.data.id)
				// let is_leader = this.model.IsLeaderInTeam(RoleManager.GetInstance().mainRoleInfo.role_id)
				// if (is_leader)
				// {
				//     if (! fdata)
				//     {
				//         tab_list = [1, 3, 8]
				//     }else{
				//         tab_list = [1, 8]
				//     }
				// }else{
				//     if (! fdata)
				//     {
				//         tab_list = [1, 3]
				//     }else{
				//         tab_list = [1]
				//     }
				// }
				// FriendModel.GetInstance().Fire(FriendEvent.OPEN_PLAYER_MENU, tab_list, x, y, this.data)
			}
		}
		Util.AddClickEvent(this.head_click_group, head_click_fun, this, true)

		let inviteBtn_fun = () => {
			//this.model.Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamInviteView")
			this.model.Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamView", false)
		}
		Util.AddClickEvent(this.non_role, inviteBtn_fun, this, true)

		// this.BindEvent(
		// 	GlobalEventSystem,
		// 	EventName.UPDATE_REDDOT, (rType?, key?) => {
		// 		if (rType != ModuleType.TEAM_APPLY) {
		// 			return
		// 		}
		// 		if (this.data) {
		// 			this.CheckApplyRed()
		// 		}
		// 	}
		// )
		console.log("+++++++++++++++++++++++++++", String(this.BindEvent))
	}

	public DeleteMe() {

		if (this.head) {
			this.head.DeleteMe()
			this.head = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if(!super.dataChanged())  return 
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, "resource/game/alphaMain/texture/uirwl_007.png")
		if (!this.non_role) { return }

		if (this.data) {
			if (this.data.id) {
				this.red_point.visible = false
				this.non_role.visible = false
				this.role_group.visible = true


				if (!this.head) {
					this.head = new CustomHeadItem(this.role_head)
					this.head.CloseClick()
					this.head.Load()
				}
				this.data.role_id = this.data.id
				this.head.SetRoleVoData(this.data)

				//let head_res = this.data.career
				//if (this.data.picture && this.data.picture != "" ) {
				//	head_res = this.data.picture
				//}
				//if (head_res ) { 
				//    let picture_cfg = Config.Picture[Number(head_res)]
				//    if (picture_cfg ) {
				//        head_res = picture_cfg.resource
				//    }
				//}
				//lua_resM:SetOutsideImageSprite(this,this._img_role_head, GameResPath.GetIcon("head", head_res))
				//let state_str = Util.StrToHTML(this.model.GetOnlineStateBracketStr(this.data.online, this.data.scene_id, this.data.id))
				let sp_name = this.model.GetOnlineStateImg(this.data.online, this.data.scene_id, this.data.id)
				if (sp_name != "") {
					ResManager.GetInstance().SetImageSprite(this, this.online_img, "mainUI_asset", sp_name, true)
				}
				this.online_img.visible = sp_name != ""
				this.role_name.text = this.data.name
				// [ts2lua]lua中0和空字符串也是true，此处this.data.level > 370需要确认
				let level = (this.data.level > 370 && (this.data.level - 370) || (this.data.level))
				this.level.text = level + "级"
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	this.level.text = "Lv." + level
				// }	
				// [ts2lua]lua中0和空字符串也是true，此处this.data.level > 370需要确认
				//this.destiny_img.width = (this.data.level > 370 && ( 33 ) || ( 0 ) )
				let width = (this.data.level > 370 && (33) || (0))
				SetSizeDeltaX(this.destiny_img, width)
				//this.online_state.textFlow = Util.StrToHTML(this.model.GetOnlineStateStr(this.data.online, this.data.scene_id, this.data.id))
				this.head.SetHeadImgGray(this.data.online == 0)
				//SetImageGray(this._img_role_head, this.data.online == 0)
				let is_leader = this.model.IsLeaderInTeam(RoleManager.GetInstance().mainRoleInfo.role_id)
				this.leader_tag.visible = this.data.team_position == 1
				if (is_leader) {
					if (this.data.id == RoleManager.GetInstance().mainRoleInfo.role_id) {
						this.quitBtn.visible = true
						this.pleaseLeaveBtn.visible = false
					} else {
						this.quitBtn.visible = false
						this.pleaseLeaveBtn.visible = true
					}
				} else {
					if (this.data.id == RoleManager.GetInstance().mainRoleInfo.role_id) {
						this.quitBtn.visible = true
						this.pleaseLeaveBtn.visible = false
					} else {
						this.quitBtn.visible = false
						this.pleaseLeaveBtn.visible = false
					}
				}
			} else {
				this.non_role.visible = true
				this.role_group.visible = false
				this.CheckApplyRed()
			}
		}
	}

	public CheckApplyRed() {

		// this.red_point.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.TEAM_APPLY)
	}


	public GetComponents() {
		[
			this._Image1,
			this.non_role,
			this.Image,
			this.lbl_tips,
			this.red_point,
			this.role_group,
			this.online_img,
			this.role_head,
			this.leader_tag,
			this.head_click_group,
			this.role_name,
			this._Group1,
			this.destiny_img,
			this.level,
			this.quitBtn,
			this._Image2,
			this._Label1,
			this.pleaseLeaveBtn,
			this._Image3,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"non_role",
				"Image",
				"lbl_tips",
				"red_point",
				"role_group",
				"online_img",
				"role_head",
				"leader_tag",
				"head_click_group",
				"role_name",
				"_Group1",
				"destiny_img",
				"level",
				"quitBtn",
				"_Image2",
				"_Label1",
				"pleaseLeaveBtn",
				"_Image3",
				"_Label2",
			])
	}
}
window["TeamMainRoleItem"]=TeamMainRoleItem