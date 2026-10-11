import { BaseView1 } from "../common/BaseView1"
import { CookieWrapper } from "../common/CookieWrapper"
import { EventName, LoginStateEvent } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoginManager } from "./LoginManager"
import { LoginModel } from "./LoginModel"
import { Enum_LoginState } from "./LoginStateManager"

export class LoginView extends BaseView1 {
	

	LoadSuccess
	InitEvent
	UpdateView
	SelectFun
	public constructor() {
		super()

		let local_LoginStateEvent = LoginStateEvent
		let local_LoginManager_Instance = LoginManager.GetInstance()
		let local_CookieWrapper = CookieWrapper
		let check_select_ = 0

		this.base_file = "login"
		this.layout_file = "LoginView"

		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.not_close_by_android_back_key = true
		this.use_background = true
		this.is_center = true

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.open_callback = () => {
			// LoginModel.GetInstance().Fire(LoginStateEvent.HIDE_OR_SHOW_LOGIN_BG, true)
		}
		this.close_callback = () => {
			CookieWrapper.GetInstance().SaveCookie(CookieWrapper.REMEMBER_PASSWORD, check_select_)
		}
		this.LoadSuccess = () => {

			this.InitEvent()
			this.UpdateView()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.loginBtn, () => {
				let account = this.account.text.trim()
				let password = this.password.text.trim()
				if (account == "" || password == "") {
					Message.show("请输入账号密码")
					return
				}
				// if (HasLimitChar(account) || HasLimitChar(password) ) {
				// 	Message.show("账号或密码存在非法字符")
				// 	return
				// }
				if (account.trim() == "" || password.trim() == "") {
					Message.show("请输入账号密码")
					return
				}
				// GlobalEventSystem.Fire(EventName.SHOW_LOADING_VIEW)
				local_LoginManager_Instance.Fire(local_LoginStateEvent.COMFIRN_LOGIN_BTN, account, password)
			}, this, true)

			Util.AddClickEvent(this.registerBtn, () => {
				this.Close()
				if (!ClientConfig.sdk_server) {
					local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.Register)
					LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "RegisterView")
				}
			}
				, this, true)

			Util.AddClickEvent(this.checkBtn, () => {
				if(check_select_){
					check_select_ = 0
				}
				else{
					check_select_ = 1
				}
				this.SelectFun()
			}, this)
		}

		this.UpdateView = () => {
			let cookie_wrapper = CookieWrapper.GetInstance()
			if (cookie_wrapper) {
				let last_account = cookie_wrapper.GetCookie(CookieWrapper.LOGIN_USER_NAME)
				if (last_account) {
					this.account.text = last_account
				}
				let remember_pwd = cookie_wrapper.GetCookie(CookieWrapper.REMEMBER_PASSWORD)
				if (remember_pwd == null) {
					check_select_ = 1
					cookie_wrapper.SaveCookie(CookieWrapper.REMEMBER_PASSWORD, 1, false)
				}
				else{
					check_select_ = Number(remember_pwd)
				}

				if (check_select_) {
					let last_pwd = cookie_wrapper.GetCookie(CookieWrapper.LOGIN_USER_PASSWORD)
					if (last_pwd) {
						this.password.text = last_pwd
					}
				}

				
				this.SelectFun()
			}
		}

		this.SelectFun = () => {
			if (check_select_) {
				ResManager.GetInstance().SetImageSprite(this, this.check_img, "alert", "com_ui_gx1")
			} else {
				ResManager.GetInstance().SetImageSprite(this, this.check_img, "alert", "com_ui_gx")
			}
		}
	}
	bg: Laya.Image
	_Group1: Laya.Box
	_Label1: Laya.Label
	_Group2: Laya.Box
	_Label2: Laya.Label
	checkBtn: Laya.Box
	check_img: Laya.Image
	check_label: Laya.Label
	logo: Laya.Image
	registerBtn: Laya.Box
	_Image1: Laya.Image
	_Label3: Laya.Label
	loginBtn: Laya.Box
	_Image2: Laya.Image
	_Label4: Laya.Label
	account: Laya.TextInput
	password: Laya.TextInput
	public GetComponents() {
		[
			this.bg,
			this._Group1,
			this._Label1,
			this._Group2,
			this._Label2,
			this.checkBtn,
			this.check_img,
			this.check_label,
			this.logo,
			this.registerBtn,
			this._Image1,
			this._Label3,
			this.loginBtn,
			this._Image2,
			this._Label4,
			this.account,
			this.password,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Group1",
				"_Label1",
				"_Group2",
				"_Label2",
				"checkBtn",
				"check_img",
				"check_label",
				"logo",
				"registerBtn",
				"_Image1",
				"_Label3",
				"loginBtn",
				"_Image2",
				"_Label4",
				"account",
				"password",
			])
	}
}
window["LoginView"] = LoginView