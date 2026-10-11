import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
export class DungeonGuildHelpItem extends BaseItem1 {
	help_data
	guild_model: GuildModel
	head_item: CustomHeadItem
	public constructor(parent) {
		super(parent)
		this.base_file = "dungeonCommon"
		this.layout_file = "DungeonGuildHelpItem"

		this.guild_model = GuildModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	InitEvent() {
		//确认协助对象是自己，然后显示
		this.BindEvent(this.guild_model, GuildEvent.UPDATE_HELP_OBJ, (scmd?) => {
			if(!SceneManager.GetInstance().IsMainLineDungeonScene()&&scmd.type==4){
				this.ShowPanel(false)
				return
			}
			if (scmd.type != 4) {
				this.ShowPanel(false)
				return
			}
			this.help_data = scmd
			let bool = scmd.role_id == RoleManager.GetInstance().GetMainRoleId()
			this.ShowPanel(bool)
		})

		//协助删除
		this.BindEvent(this.guild_model, GuildEvent.DEL_HELP_DATA, (scmd?) => {
			if (this.help_data) {
				if (this.help_data.assist_id == scmd.assist_id) {
					this.help_data = null
					this.ShowPanel(false)
				}
			}
		})
	}

	LoadSuccess() {
		this.ShowPanel(false)
		this.guild_model.Fire(GuildEvent.REQUEST_PROTO, 40408)
		this.InitEvent()
	}

	ShowPanel(bool) {
		this._box_con.visible = bool
		if(bool){
			this._lb_name.text = this.help_data.name
			if (!this.head_item) {
				this.head_item = new CustomHeadItem(this._box_head)
				this.head_item.Load()
				this.head_item.CloseClick()
			}
			let head_data = { role_id: this.help_data.role_id, career: this.help_data.career, picture: this.help_data.pic, picture_ver: this.help_data.pic_ver }
			this.head_item.SetRoleVoData(head_data, null, null, this.help_data.level)
		}
	}

	public DeleteMe() {
		if (this.head_item) {
			this.head_item.DeleteMe()
			this.head_item = undefined
		}
		super.DeleteMe()
	}

	_box_con: Laya.Box
	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_title: Laya.Label
	_box_head: Laya.Box
	_lb_name: Laya.Label
	public GetComponents() {
		[
			this._box_con,
			this._img_bg,
			this._img_bg2,
			this._lb_title,
			this._box_head,
			this._lb_name,
		]
			= this.GetChildrenByNames([
				"_box_con",
				"_img_bg",
				"_img_bg2",
				"_lb_title",
				"_box_head",
				"_lb_name",
			])
	}
}
window["DungeonGuildHelpItem"] = DungeonGuildHelpItem