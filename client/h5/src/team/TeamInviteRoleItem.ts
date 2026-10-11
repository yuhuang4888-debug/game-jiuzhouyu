import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamModel } from "../commonModel/TeamModel"
import { SceneManager } from "../scene/SceneManager"
import { Util } from "../util/Util"

export class TeamInviteRoleItem extends BaseItemRenderer {
	bg: Laya.Image
	role_head: Laya.Box
	_img_role_head: Laya.Image
	_img_frame: Laya.Image
	role_name: Laya.Label
	level: Laya.Label
	select_bg: Laya.Image
	click_bg: Laya.Box
	InitEvent
	is_delay_callback
	model
	head
	public static width = 160
	public static height = 200

	public constructor(parent) {
		super()

		this.base_file = "team"
		this.layout_file = "TeamInviteRoleItem"
		this.WIDTH=140
		this.HEIGT=180
		// this.skinName = "resource/game/team/exml/TeamInviteRoleItemExml.exml"
		this.model = TeamModel.GetInstance()
		this.is_delay_callback = false
		this.Load()
	}

	public load_callback(){
		let refuseBtn_fun = () => {
			if (this.data) {
				this.model.InviteJoinTeam(this.data.role_id,this.data.serv_id)
			}
		}

		Util.AddClickEvent(this.click_bg, refuseBtn_fun, this)
	}

	public DeleteMe() {

		if (this.head) {
			this.head.DeleteMe()
			this.head = null
		}
		super.DeleteMe()
	}

	public dataChanged() {
		if(!super.dataChanged()) return 
		if (this.data && this.data.role_id) {
			//let frame_id = 0
			//this.role_head.setData(null, this.data.career, this.data.picture, null, null, frame_id)
			//let head_res = ""
			//if (this.data.picture ) {
			//let picture_cfg = Config.Picture[Number(this.data.picture)]
			//if (picture_cfg ) {
			//head_res = picture_cfg.resource
			//}
			//}
			//lua_resM:SetOutsideImageSprite(this,this._img_role_head, GameResPath.GetIcon("head", head_res))
			let data = this.data
			if (!this.head) {
				this.head = new CustomHeadItem(this.role_head)
				this.head.Load()
			}
			this.head.SetData(data.role_id, data.career, data.sex, data.picture, data.picture_ver)
			let mask_scene = SceneManager.GetInstance().CanMaskScene()
			let can_mask = this.data.mask_id != 0 && mask_scene
			if (this.data.role_name) {
				// [ts2lua]lua中0和空字符串也是true，此处can_mask需要确认
				this.role_name.text = (can_mask && ("蒙面人") || (this.data.role_name))
			} else if (this.data.name) {
				// [ts2lua]lua中0和空字符串也是true，此处can_mask需要确认
				this.role_name.text = (can_mask && ("蒙面人") || (this.data.name))
			}
			if (this.data.level) {
				// [ts2lua]lua中0和空字符串也是true，此处this.data.level > 370需要确认
				let lv = (this.data.level > 370 && ("神创" + (this.data.level - 370)) || (this.data.level))
				// [ts2lua]lua中0和空字符串也是true，此处can_mask需要确认
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	this.level.text = (can_mask && ( "" ) || ( lv + "Lv." ) )
				// }else{
				this.level.text = (can_mask && ("") || (lv + "级"))
				// }
			} else if (this.data.lv) {
				// [ts2lua]lua中0和空字符串也是true，此处this.data.lv > 370需要确认
				let lv = (this.data.lv > 370 && ("神创" + (this.data.lv - 370)) || (this.data.lv))
				// [ts2lua]lua中0和空字符串也是true，此处can_mask需要确认
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	this.level.text = (can_mask && ( "" ) || ( lv + "Lv." ) )
				// }else{
				this.level.text = (can_mask && ("") || (lv + "级"))
				// }
			}
		}
	}


	public GetComponents() {
		[
			this.bg,
			this.role_head,
			this._img_role_head,
			this._img_frame,
			this.role_name,
			this.level,
			this.select_bg,
			this.click_bg,
		]
			= this.GetChildrenByNames([

				"bg",
				"role_head",
				"_img_role_head",
				"_img_frame",
				"role_name",
				"level",
				"select_bg",
				"click_bg",
			])
	}
}
window["TeamInviteRoleItem"]=TeamInviteRoleItem