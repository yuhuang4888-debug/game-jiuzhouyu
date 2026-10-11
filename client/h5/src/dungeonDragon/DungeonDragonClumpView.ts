
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ModuleType, RedDotManager } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { GuildModel } from "../commonModel/GuildModel"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util,HtmlColorTxt } from "../util/Util"
import { DungeonDragonClumpApplyItem } from "./DungeonDragonClumpApplyItem"
import { DungeonDragonClumpInviteItem } from "./DungeonDragonClumpInviteItem"

export class DungeonDragonClumpView extends BaseView1 {

	apply_loop_mgr
	array_apply
	array_invite
	background_alpha
	change_scene_close
	click_bg_toClose
	destroy_callback
	invite_loop_mgr: LoopScrowViewMgr
	is_center
	show_open_movie
	//toggle_apply
	//toggle_group
	//toggle_recruit
	use_background
	LoadSuccess
	Remove
	Local_Open
	InitEvent
	InitView
	RefreshApplyRed
	UpdateApply
	UpdateInvite
	SwitchInvite
	PopItem
	SwitchItem
	UpdateInviteBtn
	UpdateView
	SwitchFunc
	RefreshInviteItem
	click_call_back
	public static ShowType = { invite: 0, apply: 1 }
	public static InviteType = { recommend: 1, guild: 2, friend: 3 }
	public constructor(parent?) {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonClumpView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		this.is_center = true
		let team_model = TeamModel.GetInstance()
		let local_TeamEvent = TeamEvent
		let local_Util = Util
		let local_DungeonDragonClumpView = DungeonDragonClumpView
		let local_TeamModel = TeamModel
		let now_index_ = null
		let default_index_ = local_DungeonDragonClumpView.ShowType.invite
		let invite_index_ = null
		let invite_default_index_ = local_DungeonDragonClumpView.InviteType.recommend
		let dun_id_ = null
		let invite_list = null
		let apply_list = null
		this.destroy_imm=true
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				dun_id_ = parms
			}
			super.Open()
		}

		this.LoadSuccess = () => {


			// this.toggle_group = [
			// 	this.toggle_recruit,
			// 	this.toggle_apply
			// ]

			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("common", "uity_064"))
			//this.array_invite = eui. new ArrayCollection()
			//this._list_invite_con.dataProvider = this.array_invite
			//this._list_invite_con.itemRenderer = DungeonEquipClumpInviteItem
			if (!this.invite_loop_mgr) {
				invite_list = []
				this.invite_loop_mgr = new LoopScrowViewMgr()
				var SelectFunc = () => {
				}
				this.invite_loop_mgr.SetData(this.Content, DungeonDragonClumpInviteItem, invite_list, LoopScrCon.Vertical, 1, SelectFunc)
			}

			//this.array_apply = eui. new ArrayCollection()
			//this._list_apply_con.dataProvider = this.array_apply
			//this._list_apply_con.itemRenderer = DungeonEquipClumpApplyItem
			if (!this.apply_loop_mgr) {
				apply_list = []
				this.apply_loop_mgr = new LoopScrowViewMgr()
				var SelectFunc = () => {
				}
				this.apply_loop_mgr.SetData(this.Content1, DungeonDragonClumpApplyItem, apply_list, LoopScrCon.Vertical, 1, SelectFunc)
			}

			// [ts2lua]this下标访问可能不正确




			this.InitEvent()
			this.InitView()
			this.RefreshApplyRed()

			this.SwitchFunc(local_DungeonDragonClumpView.ShowType.invite)
			
		}

		this.click_call_back = (target?) => {
			let index = null

			switch (target.name) {
				case this._img_tab1.name:
					index = local_DungeonDragonClumpView.InviteType.recommend
					break;
				case this._img_tab2.name:
					index = local_DungeonDragonClumpView.InviteType.guild
					break;
				case this._img_tab3.name:
					index = local_DungeonDragonClumpView.InviteType.friend
					break;
			}

			this.SwitchInvite(index)
			this.UpdateInviteBtn()

		}

		this.InitEvent = () => {

			this.BindEvent(
				GlobalEventSystem,
				EventName.UPDATE_REDDOT, (rType?, key?) => {
					if (rType != ModuleType.TEAM_APPLY) {
						return
					}
					this.RefreshApplyRed()
				}
			)
			this.BindEvent(
				team_model,
				local_TeamEvent.TEAM_UPDATE_ZHAO_MU_DATA, (type?) => {
					if (invite_index_ == type) {
						this.UpdateInvite()
					}
				}
			)
			this.BindEvent(
				team_model,
				local_TeamEvent.TEAM_UPDATE_APPLY_LIST, () => {
					this.UpdateApply()
				}
			)

			Util.AddClickEvent(
				this._img_close, () => {
					this.Close()
				},
				this,
				true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE
			)

			this._lb_add_friend.text = `点击加好友`//Util.StrToHTML("<font color='#458C00'>点击加好友</font>")
			//AddUnderlineText(this._lb_add_friend, this._lb_add_friend, "#458C00", 15, 7)
			Util.AddClickEvent(
				this._lb_add_friend, () => {
					Message.show("加好友")
				},
				this,
				true
			)
			this._lb_add_guild.text = `点击加入结社`//Util.StrToHTML("<font color='#458C00>点击加入结社</font>")
			Util.AddClickEvent(
				this._lb_add_guild, () => {
					this.Close()
					OpenFun.OpenFunHandler(4)
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._toggle_recruit, () => {
					this.SwitchFunc(local_DungeonDragonClumpView.ShowType.invite)
				},
				this,
				true
			)

			Util.AddClickEvent(
				this._toggle_apply, () => {
					this.SwitchFunc(local_DungeonDragonClumpView.ShowType.apply)
				},
				this,
				true
			)


			// {
			// 		{this._img_tab1.name] = () => {
			// 			return local_DungeonDragonClumpView.InviteType.recommend
			// 		},
			// 		[this._img_tab2.name] = () => {
			// 			return local_DungeonDragonClumpView.InviteType.guild
			// 		},
			// 		[this._img_tab3.name] = () => {
			// 			return local_DungeonDragonClumpView.InviteType.friend
			// 		}
			// 	}


			Util.AddClickEvent(this._img_tab1, ()=>{
				this.click_call_back(this._img_tab1)
			}, this)

			Util.AddClickEvent(this._img_tab2, ()=>{
				this.click_call_back(this._img_tab2)
			}, this)

			Util.AddClickEvent(this._img_tab3, ()=>{
				this.click_call_back(this._img_tab3)
			}, this)

			Util.AddClickEvent(
				this._gp_refresh, () => {
					this.RefreshInviteItem()
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._gp_world_invite, () => {
					if (team_model.world_shout_time && local_TeamModel.WORLD_SHOUT_COOL_TIME > TimeUtil.getServerTime() - team_model.world_shout_time) {
						let left_time = local_TeamModel.WORLD_SHOUT_COOL_TIME - (TimeUtil.getServerTime() - team_model.world_shout_time)
						Message.show("冷却中(" + HtmlColorTxt(left_time, ColorUtil.GetColorLight(ColorType.GREEN)) + "s)")
					} else {
						team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24055)
					}
				},
				this,
				true
			)
			Util.AddClickEvent(
				this._gp_refuse, () => {
					let list = apply_list
					if (list && list.length > 0) {
						for (let _tmpi in list) {
							var vo = list[_tmpi]
							team_model.Fire(local_TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, [[0, vo.server_id, vo.player_id]])
						}
					}
				},
				this,
				true
			)
		}

		this.SwitchFunc = (showIndex?) => {
			if (showIndex != null) {

				this._Image2.height = showIndex!=local_DungeonDragonClumpView.ShowType.apply?450:512
				if (showIndex == local_DungeonDragonClumpView.ShowType.apply) {
					team_model.SetTeamApplyRedDot(false)
				}
				this.SwitchItem(showIndex)

				//let isApply = showIndex == local_DungeonDragonClumpView.ShowType.apply
				let text_color = null
				let img_str = null

				for (let i = 1, len = 3; i < len; i++) {
					let lb = this["_lb_btn" + i]
					let img = this["_img_btn" + i]
					let isSelete = (i - 1) == showIndex
					if (isSelete) {
						text_color = "#9b572f"
						img_str = "tab2"
					} else {
						text_color = "#ffffff"
						img_str = "tab1"
					}
					lb.color = text_color
					img.y = isSelete ? -5 : 0
					ResManager.GetInstance().SetImageSprite(this, img, "common4",img_str, true)
				}


			}
		}

		this.SwitchItem = (index?) => {
			if (now_index_ == index) {
				return
			}
			now_index_ = index
			this.UpdateView()
			this.PopItem()
		}

		this.UpdateView = () => {
			if (now_index_ == local_DungeonDragonClumpView.ShowType.invite) {
				let index = invite_index_ || invite_default_index_
				this.SwitchInvite(index)
				this.UpdateInviteBtn()
			} else {
				team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24047)
			}
		}

		this.SwitchInvite = (index?) => {
			if (invite_index_ == index) {
				return
			}
			invite_index_ = index
			
			this._gp_invite_none.visible = false
			this._gp_guild_none.visible = false//this._gp_invite_none.visible
			this._gp_friend_none.visible =false// this._gp_friend_none.visible


			if (index == local_DungeonDragonClumpView.InviteType.recommend) {
				if (index && dun_id_) {
					team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24060, "ci", index, dun_id_)
				}
				this._lb_tips.text = "挑战次数"
			}
			else if (index == local_DungeonDragonClumpView.InviteType.guild) {
				let bool = GuildModel.IsHasGuild()
				this._gp_guild_none.visible = !bool
				if (bool) {
					team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24061, "c", index)
				} else {
					//this.array_invite.source = []
					//this.array_invite.refresh()
					invite_list = []
					this.invite_loop_mgr.replaceAll(invite_list)
					//this.invite_loop_mgr.ResetPosition()
				}
				this._lb_tips.text = "等级"
			}
			else if (index == local_DungeonDragonClumpView.InviteType.friend) {
				team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24061, "c", index)
				this._lb_tips.text = "等级"
			}

		

		}

		this.UpdateInviteBtn = () => {
			let i = 1
			do {
				let sp_name = (i == invite_index_) && "com_ui_gx1" || "com_ui_gx"
				ResManager.GetInstance().SetImageSprite(this, this["_img_tab" + i], "common_asset", sp_name, true)
				i = i + 1
			} while ((i < 4))
		}

		this.UpdateInvite = () => {
			// [ts2lua]team_model.zhao_mu_list下标访问可能不正确
			let zhao_mu_list = team_model.zhao_mu_list && team_model.zhao_mu_list[invite_index_]
			if (zhao_mu_list) {
				invite_list = zhao_mu_list
				let bool = zhao_mu_list.length == 0
				this._gp_invite_none.visible = bool
				this.invite_loop_mgr.replaceAll(invite_list)
			}
		}

		this.UpdateApply = () => {
			let list = []
			if (team_model.apply_list) {
				list = team_model.apply_list
			}
			this._gp_none.visible = list.length == 0
			apply_list = list
			this.apply_loop_mgr.replaceAll(apply_list)
		}

		this.Remove = () => {
			invite_index_ = null
			now_index_ = invite_index_

			if (this.invite_loop_mgr) {
				this.invite_loop_mgr.DeleteMe()
				this.invite_loop_mgr = null
			}

			if (this.apply_loop_mgr) {
				this.apply_loop_mgr.DeleteMe()
				this.apply_loop_mgr = null
			}
		}

		this.RefreshInviteItem = () => {
			//this.array_invite.source = []
			//this.array_invite.refresh()
			invite_list = []
			this.invite_loop_mgr.replaceAll(invite_list)
			if (invite_index_ == local_DungeonDragonClumpView.InviteType.recommend) {
				if (invite_index_ && dun_id_) {
					team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24060, "ci", invite_index_, dun_id_)
				}
			}
			else if (invite_index_ == local_DungeonDragonClumpView.InviteType.guild || invite_index_ == local_DungeonDragonClumpView.InviteType.friend) {
				team_model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24061, "c", invite_index_)
			}
		}

		this.InitView = () => {
			//this._btn_apply.group.selectedValue = String(default_index_)
			//this.toggle_group[default_index_].isOn = true
			this.SwitchItem(default_index_)
		}

		this.PopItem = () => {
			this._gp_apply.visible = now_index_ == local_DungeonDragonClumpView.ShowType.apply
			this._gp_invite.visible = now_index_ == local_DungeonDragonClumpView.ShowType.invite
		}

		this.RefreshApplyRed = () => {
			this._img_apply_red.visible = RedDotManager.GetInstance().CheckRedStatus(ModuleType.TEAM_APPLY)
		}
	}




	public Open(...new_args) {

		this.Local_Open(...new_args)
	}

	public DeleteMe(){
		super.DeleteMe()
	}

_Image111:Laya.Image
_Image2:Laya.Image
_Image_blue:Laya.Image
_Image_title:Laya.Image
titleLabel:Laya.Label
_Group2:Laya.HBox
_toggle_recruit:Laya.Box
_img_btn1:Laya.Image
_lb_btn1:Laya.Label
red_dot1:Laya.Image
_toggle_apply:Laya.Box
_img_btn2:Laya.Image
_lb_btn2:Laya.Label
red_dot:Laya.Image
_gp_invite:Laya.Box
_Label2:Laya.Label
_lb_tips:Laya.Label
_Label3:Laya.Label
_Image_split:Laya.Image
_img_tab1:Laya.Image
_img_tab2:Laya.Image
_img_tab3:Laya.Image
_Label4:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
Content:Laya.List
_gp_refresh:Laya.Box
_Image9:Laya.Image
_Label7:Laya.Label
_gp_world_invite:Laya.Box
_Image10:Laya.Image
_Label8:Laya.Label
_gp_invite_none:Laya.Box
_Image1111:Laya.Image
_Image12:Laya.Image
_Label101:Laya.Label
_gp_guild_none:Laya.Box
_Image13:Laya.Image
_Image14:Laya.Image
_Label10:Laya.Label
_lb_add_guild:Laya.Label
_gp_friend_none:Laya.Box
_Image15:Laya.Image
_Image16:Laya.Image
_Label11:Laya.Label
_lb_add_friend:Laya.Label
_gp_apply:Laya.Box
_Label12:Laya.Label
_Label13:Laya.Label
_Label14:Laya.Label
_gp_refuse:Laya.Box
_Image19:Laya.Image
_Label15:Laya.Label
_gp_none:Laya.Box
_Image20:Laya.Image
_Image21:Laya.Image
_Label16:Laya.Label
Content1:Laya.List
_img_apply_red:Laya.Image
_img_close:Laya.Image
public GetComponents() {
[
this._Image111,
this._Image2,
this._Image_blue,
this._Image_title,
this.titleLabel,
this._Group2,
this._toggle_recruit,
this._img_btn1,
this._lb_btn1,
this.red_dot1,
this._toggle_apply,
this._img_btn2,
this._lb_btn2,
this.red_dot,
this._gp_invite,
this._Label2,
this._lb_tips,
this._Label3,
this._Image_split,
this._img_tab1,
this._img_tab2,
this._img_tab3,
this._Label4,
this._Label5,
this._Label6,
this.Content,
this._gp_refresh,
this._Image9,
this._Label7,
this._gp_world_invite,
this._Image10,
this._Label8,
this._gp_invite_none,
this._Image1111,
this._Image12,
this._Label101,
this._gp_guild_none,
this._Image13,
this._Image14,
this._Label10,
this._lb_add_guild,
this._gp_friend_none,
this._Image15,
this._Image16,
this._Label11,
this._lb_add_friend,
this._gp_apply,
this._Label12,
this._Label13,
this._Label14,
this._gp_refuse,
this._Image19,
this._Label15,
this._gp_none,
this._Image20,
this._Image21,
this._Label16,
this.Content1,
this._img_apply_red,
this._img_close,
]
 = this.GetChildrenByNames([

"_Image111",
"_Image2",
"_Image_blue",
"_Image_title",
"titleLabel",
"_Group2",
"_toggle_recruit",
"_img_btn1",
"_lb_btn1",
"red_dot1",
"_toggle_apply",
"_img_btn2",
"_lb_btn2",
"red_dot",
"_gp_invite",
"_Label2",
"_lb_tips",
"_Label3",
"_Image_split",
"_img_tab1",
"_img_tab2",
"_img_tab3",
"_Label4",
"_Label5",
"_Label6",
"Content",
"_gp_refresh",
"_Image9",
"_Label7",
"_gp_world_invite",
"_Image10",
"_Label8",
"_gp_invite_none",
"_Image1111",
"_Image12",
"_Label101",
"_gp_guild_none",
"_Image13",
"_Image14",
"_Label10",
"_lb_add_guild",
"_gp_friend_none",
"_Image15",
"_Image16",
"_Label11",
"_lb_add_friend",
"_gp_apply",
"_Label12",
"_Label13",
"_Label14",
"_gp_refuse",
"_Image19",
"_Label15",
"_gp_none",
"_Image20",
"_Image21",
"_Label16",
"Content1",
"_img_apply_red",
"_img_close",
])
}
}
 window["DungeonDragonClumpView"]= DungeonDragonClumpView