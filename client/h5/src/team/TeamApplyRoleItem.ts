import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { Util } from "../util/Util"

export class TeamApplyRoleItem extends BaseItemRenderer {
	_Image1: Laya.Image
	name_bg: Laya.Image
	role_name: Laya.Label
	level: Laya.Label
	shieldBtn: Laya.Image
	agreeBtn: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	refuseBtn: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	_lb_lv: Laya.Label

	is_delay_callback
	model

	public static width = 530
	public static height = 80

	public constructor(parent) {
		super()

		this.base_file = "team"
		this.layout_file = "TeamApplyRoleItem"
		// this.skinName = "resource/game/team/exml/TeamApplyRoleItemExml.exml"
		this.model = TeamModel.GetInstance()
		this.is_delay_callback = false
		this.WIDTH=560
		this.HEIGT=80
		this.Load()
	}

	public load_callback() {
		let refuseBtn_fun = () => {
			if (this.data) {
				this.model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, [[0, this.data.server_id, this.data.player_id]])
			}
		}

		Util.AddClickEvent(this.refuseBtn, refuseBtn_fun, this, true)
		let agreeBtn_fun = () => {
			if (this.data) {
				this.model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, [[1, this.data.server_id, this.data.player_id]])
			}
		}

		Util.AddClickEvent(this.agreeBtn, agreeBtn_fun, this, true)
		let shieldBtn_fun = () => {
			if (this.data) {
				this.model.UpdateShieldList(this.data.player_id)
				this.model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, [[0, this.data.server_id, this.data.player_id]])
			}
		}

		Util.AddClickEvent(this.shieldBtn, shieldBtn_fun, this, true)
	}
	public dataChanged() {
		if(!super.dataChanged()) return  
		if (this.data && this.data.player_id) {
			this.role_name.text = this.data.name
			// [ts2lua]lua中0和空字符串也是true，此处this.data.level > 370需要确认
			if(this.data.level>370){
				this._lb_lv.visible=true
			}else{
				this._lb_lv.visible=false
			}
			let lv = (this.data.level > 370 && ( (this.data.level - 370)) || (this.data.level))
			this.level.text = lv + "级"
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this.name_bg,
			this.role_name,
			this.level,
			this.shieldBtn,
			this.agreeBtn,
			this._Image2,
			this._Label1,
			this.refuseBtn,
			this._Image3,
			this._Label2,
			this._lb_lv
		]
			= this.GetChildrenByNames([

				"_Image1",
				"name_bg",
				"role_name",
				"level",
				"shieldBtn",
				"agreeBtn",
				"_Image2",
				"_Label1",
				"refuseBtn",
				"_Image3",
				"_Label2",
				"_lb_lv"
			])
	}
}
window["TeamApplyRoleItem"]=TeamApplyRoleItem