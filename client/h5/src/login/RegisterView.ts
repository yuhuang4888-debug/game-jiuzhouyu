import { BaseView1 } from "../common/BaseView1"
import { LoginStateEvent } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoginManager } from "./LoginManager"
import { Enum_LoginState } from "./LoginStateManager"

export class RegisterView extends BaseView1 {
	InitEvent
	LoadSuccess
	UpdateView
	not_close_by_android_back_key
	public constructor() {
		super()

		let res_mgr = ResManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_LoginManager_Instance = LoginManager.GetInstance()
		let local_LoginStateEvent = LoginStateEvent
		let local_String = String

		this.base_file = "login"
		this.layout_file = "RegisterView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.not_close_by_android_back_key = true
		this.use_background = true
		this.is_center = true
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {

			this.InitEvent()
			this.UpdateView()

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.logo, GameResPath.GetIcon("login", "uidl_002"))
		}

		this.InitEvent = () => {

			Util.AddClickEvent(this.confirmBtn, () => {
				let account = this.account.text
				let password = this.password.text
				if (local_String(account).trim() == "" || local_String(password).trim() == "") {
					Message.show("请输入账号密码")
					return
				}
				local_LoginManager_Instance.Fire(local_LoginStateEvent.COMFIRM_REGISTER_BTN, account, password)
			}
				, this, true)

			Util.AddClickEvent(this.returnBtn, () => {
				this.Close()
				local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.Login)
			}
				, this, true)

		}

		this.UpdateView = () => {
			this.account.text = String(Math.floor(Math.random() * 100000))
			this.password.text = String(Math.floor(Math.random() * 100000))
		}
	}
	bg: Laya.Image
	_Group1: Laya.Box
	_Label1: Laya.Label
	_Group2: Laya.Box
	_Label2: Laya.Label
	logo: Laya.Image
	confirmBtn: Laya.Box
	_Image1: Laya.Image
	_Label3: Laya.Label
	returnBtn: Laya.Box
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
			this.logo,
			this.confirmBtn,
			this._Image1,
			this._Label3,
			this.returnBtn,
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
				"logo",
				"confirmBtn",
				"_Image1",
				"_Label3",
				"returnBtn",
				"_Image2",
				"_Label4",
				"account",
				"password",
			])
	}
}
window["RegisterView"] = RegisterView