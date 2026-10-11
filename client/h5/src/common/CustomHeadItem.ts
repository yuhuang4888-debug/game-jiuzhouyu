import { DressModel, DressType } from "../commonModel/DressModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetLocalScaleX, Util } from "../util/Util"
import { BaseItem1 } from "./BaseItem1"
import { Config } from "./Config"
import { CustomRoleHead } from "./CustomRoleHead"
import { ResManager } from "./ResManager"

export class CustomHeadItem extends BaseItem1 {

	private click_func
	private need_refresh
	tmp_role_vo
	is_active_frame
	is_active_level
	is_active_bg
	is_active_bg2
	is_team_panel

	InitEvent
	LoadFinished
	SetRoleVoData
	SetActiveFrame
	SetActiveLevel
	SetActiveBg
	SetActiveBg2
	SetDefaultHead
	SetTurnHead
	SetData
	UpdateFrame
	UpdateLevel
	SetClickFunc
	CloseClick
	SetLevelReverse
	SetHeadImgGray
	Dispose
	public constructor(parent?) {
		super(parent)

		this.base_file = "common"
		this.layout_file = "CustomHeadItem"

		let main_role = RoleManager.GetInstance().GetMainRoleVo()
		this.preload_server_config = {
			"config_reincarnation_cfg":false,
			"config_dress_up_cfg" :false
		}
		this.load_callback = () => {
			this.InitEvent()
			this.LoadFinished()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.click_group, (target?, x?, y?) => {
				if (this.click_func ) {
					if( !this.tmp_role_vo || !this.tmp_role_vo.role_id){
						Message.show("玩家已离线")
						return
					}
					this.click_func(target, x, y)
				}
			}, this)
		}

		this.LoadFinished = () => {
			if (this.need_refresh) {
				this.need_refresh = null
				this.SetRoleVoData(this.tmp_role_vo)
			}

			if (this.is_active_frame != null) {
				this.SetActiveFrame(this.is_active_frame)
			}
			if (this.is_active_level != null) {
				this.SetActiveLevel(this.is_active_level)
			}
			if (this.is_active_bg != null) {
				this.SetActiveBg(this.is_active_bg)
			}

			if (this.is_active_bg2 != null) {
				this.SetActiveBg2(this.is_active_bg2)
			}
		}

		this.SetDefaultHead = (role_career?, role_turn?) => {
			
			// 没有设置过头像，用职业默认
			let turn: number = role_turn? role_turn: 0;
			let picture_Id  = DressModel.GetInstance().getDressIdByTurn(turn);
			
			let _career = (role_career || main_role.career) 
			//picture_source = GameResPath.GetHeadPath(picture_source)
			this.icon_sys_head.visible = true
			this.icon.visible = false
			let headStr: string = DressModel.GetInstance().getHeadICon(picture_Id, _career)
			ResManager.GetInstance().SetImageSpriteTrans(this, this.icon_sys_head, GameResPath.GetIcon("head", headStr))
			//ResManager.GetInstance().SetTexture(this, this.icon_sys_head, picture_source)
		}

		this.SetTurnHead = (turn?) => {

		}

		/*
		role_id: 角色id
		role_career: 职业
		picture: 头像字段（默认是role_id）
		picture_ver：头像版本号（与picture连接，确认cdn文件名）
		role_turn：因为PHP,CDN逻辑问题，跨服玩家使用与转生数有关的头像
		server_id：同上原因
		dress_list: 头像框使用
		level: 等级
		*/
		this.SetData = (role_id?, role_career?, role_sex?, picture?, picture_ver?, role_turn?, server_id?, dress_list?, level?,is_team?) => {
			if (!this.is_loaded) {
				this.need_refresh = true
				this.is_team_panel=is_team
				this.tmp_role_vo = {
					role_id: role_id,
					career: role_career,
					role_sex: role_sex,
					picture: picture,
					picture_ver: picture_ver,
					role_turn: role_turn,
					server_id: server_id,
					dress_list: dress_list,
					level: level,
				}
			} else {
				// 头像 跨服
				if (server_id && server_id != main_role.server_unique_id) {
					if (!role_turn) {
						this.SetDefaultHead(role_career)
					} else {
						this.SetDefaultHead(role_career, role_turn)
					}
				} else {
					if (picture && picture != "") {
						let headStr: string = DressModel.GetInstance().getHeadICon(picture, role_career)
						if (headStr) {
							//let pic_res = GameResPath.GetHeadPath(picture_cfg.resource)
							ResManager.GetInstance().SetImageSpriteTrans(this, this.icon_sys_head, GameResPath.GetIcon("head", headStr))
							this.icon_sys_head.visible = true
							this.icon.visible = false
						} else {
							if (picture_ver && typeof (picture_ver) == "number" && picture_ver < 1) {
								this.SetDefaultHead(role_career, role_turn)
							} else {
								this.SetDefaultHead(role_career, role_turn)
								CustomRoleHead.GetInstance().Create((result?, tmp_pic?, tmp_pic_ver?) => {
									if (result && tmp_pic == picture && tmp_pic_ver == picture_ver) {
										this.icon_sys_head.visible = false
										this.icon.visible = true
									}
								}, this, this.icon, role_id, role_career, role_sex, null, null, picture_ver, picture)
							}
						}
					} else {
						this.SetDefaultHead(role_career, role_turn)
					}
				}
				// 头像框
				this.UpdateFrame(dress_list)
				this.UpdateLevel(level)

				if (this.is_active_frame != null) {
					this.SetActiveFrame(this.is_active_frame)
				}

				if (this.is_active_level != null) {
					this.SetActiveLevel(this.is_active_level)
				}

				if (this.is_active_bg != null) {
					this.SetActiveBg(this.is_active_bg)
				}
				if(is_team){
					this.bg.visible=false
					this.bg2.visible=false
					this._level_gp.visible=false
				}else{
					this.team_bg.visible=false
				}
			}
		}

		this.UpdateFrame = (dress_list?) => {

			if (dress_list) {
				let frame_id = DressModel.GetInstance().GetDressByType(dress_list, DressType.Photo)
				if (frame_id) {
					this.frame.visible = true
					ResManager.GetInstance().SetImageSpriteTrans(this, this.frame, GameResPath.GetIcon("head", "2_" + frame_id))
				} else {
					// ResManager.GetInstance().SetImageSprite(this, this.frame, "mainUI", "uizjm_005", true)
					this.frame.visible = false
				}
			} else {
				this.frame.visible = false
				// ResManager.GetInstance().SetImageSprite(this, this.frame, "mainUI", "uizjm_005", true)
			}

		}

		this.UpdateLevel = (level?) => {
			// 等级
			let is_active = level != null
			this._level_gp.visible = is_active
			if (is_active) {
				let is_sc = level > 370
				let lv = is_sc && level - 370 || level
				ResManager.GetInstance().SetImageSprite(this, this.lv_img, "mainUI", is_sc && "mainui_head_circle_purple" || "mainui_head_circle_blue", true)
				this._lev_.text = lv
				this._lev_.color=is_sc?"#fee54a":"#ffffff"
				if(is_sc){
					this.lv_img.centerY=-2
				}
			}
		}

		this.SetActiveFrame = (is_active?) => {
			if (!this.is_loaded) {
				this.is_active_frame = is_active
			} else {
				this.frame.visible = is_active
			}
		}

		this.SetActiveLevel = (is_active?) => {
			if (!this.is_loaded) {
				this.is_active_level = is_active
			} else {
				this._level_gp.visible = is_active
			}
		}

		this.SetActiveBg = (is_active?) => {
			if (!this.is_loaded) {
				this.is_active_bg = is_active
			} else {
				this.bg.visible = this.bg2.visible = is_active
			}
		}

		this.SetActiveBg2 = (is_active?) => {
			if (!this.is_loaded) {
				this.is_active_bg2 = is_active
			} else {
				this.bg.visible = is_active
			}
		}


		this.SetRoleVoData = (role_vo?, role_turn?, server_id?, level?) => {
			let lv = level || role_vo.level || role_vo.lv
			let ser_id = server_id || role_vo.ser_id
			let turn = role_turn || role_vo.turn
			if (!role_vo.role_id && (role_vo.player_id || role_vo.id)) {
				role_vo.role_id = role_vo.player_id || role_vo.id
			}
			this.SetData(role_vo.role_id, role_vo.career, role_vo.sex, role_vo.picture, role_vo.picture_ver, turn, ser_id, role_vo.dress_list, lv)
		}

		this.SetClickFunc = (click_func?) => {
			this.click_func = click_func
		}

		this.CloseClick = () => {
			this.ExcuteCallback(() => {
				if (this.click_group) {
					this.click_group.mouseEnabled = false
					this.display_obj.mouseEnabled = false
				}
			})
		}

		this.SetLevelReverse = () => {
			this.ExcuteCallback(() => {
				SetLocalScaleX(this._lev_, -1)
			})
		}

		this.SetHeadImgGray = (is_gray?) => {
			this.ExcuteCallback(() => {
				// if (!this.gray_mat) {
				// 	this.gray_mat = new Material(ShaderTools.gray_mat)
				// }
				Laya.UIUtils.gray(this.icon, is_gray)
			})
		}

		this.Dispose = () => {
			this.click_func = null
			this.need_refresh = null
			this.tmp_role_vo = null
			this.is_active_frame = null
			// this.gray_mat = null
		}
	}

	public DeleteMe() {

		this.Dispose()
		super.DeleteMe()
	}


	click_group: Laya.Box
	bg: Laya.Image
	bg2: Laya.Image
	icon: Laya.Image
	icon_sys_head: Laya.Image
	frame: Laya.Image
	_level_gp: Laya.Box
	lv_img: Laya.Image
	_lev_: Laya.Label
	team_bg: Laya.Image
	public GetComponents() {
		[
			this.click_group,
			this.bg,
			this.bg2,
			this.icon,
			this.icon_sys_head,
			this.frame,
			this._level_gp,
			this.lv_img,
			this._lev_,
			this.team_bg
		]
			= this.GetChildrenByNames([

				"click_group",
				"bg",
				"bg2",
				"icon",
				"icon_sys_head",
				"frame",
				"_level_gp",
				"lv_img",
				"_lev_",
				"team_bg"
			])
	}
}
window["CustomHeadItem"] = CustomHeadItem