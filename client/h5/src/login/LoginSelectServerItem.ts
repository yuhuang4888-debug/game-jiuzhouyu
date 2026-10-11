import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { LoginStateEvent } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoginModel } from "./LoginModel"
import { LoginSelectServerView } from "./LoginSelectServerView"

export class LoginSelectServerItem extends BaseItemRenderer {

	WIDTH = 498
	HEIGT = 96

	login_model: LoginModel
	res_mgr: ResManager
	public constructor() {
		super()
		this.base_file = "login"
		this.layout_file = "LoginSelectServerItem"
		this.login_model = LoginModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			Util.AddClickEvent(this._img_bg, () => {
				GlobalEventSystem.Fire(LoginStateEvent.SELECT_SERVER_ITEM, this.index)
			}, this)
		}
		this.Load()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.UpdateName()
		this.UpdateState()
		this.UpdateCareer()
	}

	public UpdateName() {
		let server_data = this.data.server_data
		let desc = null
		if (server_data.num) {
			if(PlatformManager.IsMQYPlatform() && server_data.num){
				desc = `s${server_data.num}.${server_data.name}`
			}
			else{
				desc = server_data.name
			}
		} else {
			if(PlatformManager.IsMQYPlatform() && server_data.server_num){
				desc = `s${server_data.server_num}.${server_data.sname}`
			}
			else{
				desc = server_data.sname
			}
			
		}

		if (typeof (desc) == "string") {
			this._lb_server_name.text = desc //lighting usedata
		}
	}

	public UpdateState() {
		let server_data = this.data.server_data
		let state = Number(server_data.state)
		let closed = Number(server_data.closed)
		if (closed == 1) {
			this._img_mode.skin = GameResPath.GetIcon("login", "ui_Login_29")
			this._img_tips.visible = false
		} else {
			if (state == 0) {
				this._img_tips.visible = true
				this._img_tips.skin = GameResPath.GetIcon("login", "uidl_026")
				this._img_mode.skin = GameResPath.GetIcon("login", "ui_Login_27")
			} else if (state == 1) {
				this._img_tips.visible = true
				this._img_tips.skin = GameResPath.GetIcon("login", "uidl_027")
				this._img_mode.skin = GameResPath.GetIcon("login", "ui_Login_28")
			} else {
				this._img_tips.visible = false
				this._img_mode.skin = GameResPath.GetIcon("login", "ui_Login_27")
			}
		}
	}

	public UpdateCareer() {
		let player_data = this.data.player_data
		if (player_data) {
			this._lb_level.visible = true
			this._img_career.visible = true
			let career = Number(player_data.career)
			if (career == 1) {
				this._img_career.skin = GameResPath.GetIcon("login", "ui_Login_23")
			} else if (career == 2) {
				this._img_career.skin = GameResPath.GetIcon("login", "ui_Login_24")
			} else if (career == 3) {
				this._img_career.skin = GameResPath.GetIcon("login", "ui_Login_25")
			} else if (career == 4) {
				this._img_career.skin = GameResPath.GetIcon("login", "ui_Login_26")
			}
			this._lb_level.text = "Lv." + player_data.lv
		} else {
			this._lb_level.visible = false
			this._img_career.visible = false
		}
	}

	_img_bg: Laya.Image
	_img_mode: Laya.Image
	_img_tips: Laya.Image
	_lb_server_name: Laya.Label
	_img_career: Laya.Image
	_lb_level: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_mode,
			this._img_tips,
			this._lb_server_name,
			this._img_career,
			this._lb_level,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_mode",
				"_img_tips",
				"_lb_server_name",
				"_img_career",
				"_lb_level",
			])
	}
}
window["LoginSelectServerItem"] = LoginSelectServerItem
