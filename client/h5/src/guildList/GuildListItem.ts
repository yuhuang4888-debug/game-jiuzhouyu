
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GuildEvent, GuildModel } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { HtmlColorTxt, Util } from "../util/Util"

export class GuildListItem extends BaseItemRenderer {
	model

	public WIDTH = 647
	public HEIGT = 88
	is_set
	public constructor(parent) {
		super()

		this.is_set=false
		this.base_file = "guildList"
		this.layout_file = "GuildListItem"
		this.model = GuildModel.GetInstance()

		this.load_callback=()=>{
			this.load_callback1()

			if(!this.is_set){
				this.SetDate()
				this.is_set=true
			}
		}
		this.Load()
	}

	public load_callback1() {


		Util.AddClickEvent(this._btn_apply, () => {
			if (GuildModel.IsHasGuild()) {
				Message.show("您当前已有所属结社")
				return
			}
			if(!this.data) return
			this.model.Fire(GuildEvent.REQUEST_PROTO, 40002, "l", this.data.guild_id)
		}
			, this, true)

		Util.AddClickEvent(this._lb_master, () => {
			if (this.data.chief_id != RoleManager.GetInstance().GetMainRoleId()) {
				//未曾移植模块
				//FriendModel.GetInstance().requestPlayerMessage(this.data.chief_id)
			}
		}
			, this, true)
	}


	public dataChanged() {
		if(!super.dataChanged())return
		if(this.is_loaded){
			this.SetDate()
			this.is_set=true
		}else{
			this.is_set=false
		}
	}

	SetDate(){
		if(!this.data)return
		let data = this.data
		this._lb_name.text = data.guild_name
		this._lb_member.text = data.member_num + "/" + data.member_capacity
		// [ts2lua]lua中0和空字符串也是true，此处data.auto_approve_power == 0需要确认
		let str = (data.auto_approve_power == 0 && ("无条件限制") || ("战力" + data.auto_approve_power + "以上"))
		let power = RoleManager.GetInstance().GetMainRoleVo().fighting
		// [ts2lua]lua中0和空字符串也是true，此处power >= data.auto_approve_power需要确认
		let color = (power >= data.auto_approve_power && (Enum_ColorUtil_Dark.WHITE) || (Enum_ColorUtil_Dark.GREEN))
		//let cond = HtmlColorTxt(str, color)
		// [ts2lua]lua中0和空字符串也是true，此处data.is_apply == 1需要确认

		if(data.is_apply == 1){
			this._lb_cond.color=ColorUtil.GetReplaceChar( Enum_ColorUtil_Dark.GREEN)
			this._lb_cond.text="等待审批"
		}else{
			this._lb_cond.color=ColorUtil.GetReplaceChar( color)
			this._lb_cond.text=str
		}

		
		//this._lb_cond.text = (data.is_apply == 1 && (HtmlColorTxt("等待审批", Enum_ColorUtil_Dark.GREEN)) || (cond))
		this._lb_master.text = data.chief_name
	}

	public DeleteMe() {
		super.DeleteMe()
	}



	_Image11: Laya.Image
	_lb_name: Laya.Label
	_lb_master: Laya.Label
	_lb_member: Laya.Label
	_lb_cond: Laya.Label
	_btn_apply: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	public GetComponents() {
		[
			this._Image11,
			this._lb_name,
			this._lb_master,
			this._lb_member,
			this._lb_cond,
			this._btn_apply,
			this._Image1,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_lb_name",
				"_lb_master",
				"_lb_member",
				"_lb_cond",
				"_btn_apply",
				"_Image1",
				"labelDisplay",
			])
	}
}
window["GuildListItem"] = GuildListItem