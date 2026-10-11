import { BaseItem1 } from "../common/BaseItem1"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

export class GuildListTopItem extends BaseItem1 {
	data
	model
	need_refresh

	public constructor(parent) {
		super(parent)


		this.base_file = "guildList"
		this.layout_file = "GuildListTopItem"
		this.model = GuildModel.GetInstance()

		this.load_callback=()=>{
			this.load_callback1()
		}
	}

	public load_callback1() {


		if (this.need_refresh) {
			this.dataChanged()
			this.need_refresh = false
		}
		Util.AddClickEvent(this._btn_build, () => {
			if (GuildModel.IsHasGuild()) {
				Message.show("您当前已有所属结社")
				return
			}
			this.model.Fire(GuildEvent.OPEN_VIEW, "GuildBuildView")
		}
			, this, true)
		Util.AddClickEvent(this._btn_apply, () => {
			if (GuildModel.IsHasGuild()) {
				Message.show("您当前已有所属结社")
				return
			}
			if (!this.data) {
				return
			}
			this.model.Fire(GuildEvent.REQUEST_PROTO, 40002, "l", this.data.guild_id)
		}
			, this, true)
		Util.AddClickEvent(this._lb_master, () => {
			if (this.data && this.data.chief_id != RoleManager.GetInstance().GetMainRoleId()) {
				if (!this.data) {
					return
				}

				//未曾移植模块
				//FriendModel.GetInstance().requestPlayerMessage(this.data.chief_id)
			}
		}
			, this, true)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.dataChanged()
		} else {
			this.need_refresh = true
		}
	}

	public dataChanged() {

		if (this.data) {
			let data = this.data
			this._lb_name.text = data.guild_name
			this._lb_member.text = data.member_num + "/" + data.member_capacity
			this._lb_master.text = data.chief_name
			this._gp_data.visible = true
			Util.SetImageGray(this._img_bg, false)
			this._btn_build.visible = false
		} else {
			this._gp_data.visible = false
			Util.SetImageGray(this._img_bg, true)
			this._btn_build.visible = true
		}
	}


	_img_bg: Laya.Image
	_gp_data: Laya.Box
	_lb_name: Laya.Label
	_Label1: Laya.Label
	_lb_master: Laya.Label
	_Label2: Laya.Label
	_lb_member: Laya.Label
	_btn_apply: Laya.Box
	_Image11: Laya.Image
	labelDisplay1: Laya.Label
	_btn_build: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._gp_data,
			this._lb_name,
			this._Label1,
			this._lb_master,
			this._Label2,
			this._lb_member,
			this._btn_apply,
			this._Image11,
			this.labelDisplay1,
			this._btn_build,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_data",
				"_lb_name",
				"_Label1",
				"_lb_master",
				"_Label2",
				"_lb_member",
				"_btn_apply",
				"_Image11",
				"labelDisplay1",
				"_btn_build",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["GuildListTopItem"] = GuildListTopItem