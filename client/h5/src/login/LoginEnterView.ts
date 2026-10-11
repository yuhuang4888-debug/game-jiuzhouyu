import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName, LoginStateEvent } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { RefBoxVLayout, SetAnchoredPositionY, Util } from "../util/Util"
import { LoginManager } from "./LoginManager"
import { LoginModel } from "./LoginModel"
import { Enum_LoginState, LoginStateManager } from "./LoginStateManager"
import { LoginUserAgreementView } from "./LoginUserAgreementView"
import { ServerModel } from "./ServerModel"

import "./LoginTipsView"
import "./LoginNoticeView"
import { CookieWrapper } from "../common/CookieWrapper"
import { TimeUtil } from "../util/TimeUtil"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"

export class LoginEnterView extends BaseView1 {
	agreement_agree_state = false
	user_agreement_view

	login_model: LoginModel
	login_mgr: LoginManager
	res_mgr: ResManager
	plat_mgr: PlatformManager
	vn_box_: Laya.Box

	tt_kefu_btn
	public constructor() {
		super()

		this.base_file = "login"
		this.layout_file = "LoginEnterView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.not_close_by_android_back_key = true
		this.is_center = true

		this.res_mgr = ResManager.GetInstance()
		this.login_model = LoginModel.GetInstance()
		this.login_mgr = LoginManager.GetInstance()
		this.plat_mgr = PlatformManager.GetInstance()

		this.load_callback = () => {
			if (PlatformManager.IsEyouPlatform()) {
				this._img_16.visible = false
			}
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public Remove() {
		if (this.vn_box_) {
			this.vn_box_.removeSelf()
			this.vn_box_.destroy()
			this.vn_box_ = null
		}
		if (this.user_agreement_view) {
			this.user_agreement_view.Close()
			this.user_agreement_view = null
		}
		if (this.tt_kefu_btn) {
			this.tt_kefu_btn.destroy()
			this.tt_kefu_btn = undefined
		}
	}



	public LoadSuccess() {

		this.display_obj.left = this.display_obj.right = this.display_obj.bottom = this.display_obj.top
		this._img_notice.visible = false

		this.res_mgr.SetOutsideImageSprite(this, this._img_search_server_bg, GameResPath.GetIconOtherPath("login", "ui_Login_18"))
		this.InitEvent()
		this.UpdateLogo()
		this.UpdateServerName()
		this.CheckNoticeState()
		this.ShowCsBtn()

		this.UpdateAgreementState()
		this.InitAgreementAgreeState()
		this.UpdateAgreementAgreeState()

		this._img_return.visible = PlatformManager.IsAbroadPlatform()

		if (PlatformManager.IsEyouVnPlatform()) {
			this.vn_box_ = new Laya.Box()
			this.vn_box_.name = "Box_EyouVnAdultItem"
			this.vn_box_.width = 80
			this.vn_box_.height = 70
			this.vn_box_.centerX = 306
			this.vn_box_.y = 116
			this.display_obj.addChild(this.vn_box_)
			let view = new EyouThAdultItem(this.vn_box_)
			view.SetAnimType(2)
			view.Load()

			this._img_16.visible = false
		}


		if (PlatformManager.IsEyouPlatform() && Util.IsConch()) {
			this._img_change_account.visible = true
			this.res_mgr.SetOutsideImageSprite(this, this._img_change_account, GameResPath.GetIconOtherPath("login", "uixxsz_007"))
			Util.AddClickEvent(this._img_change_account, () => {
				PlatformManager.GetInstance().SwitchAccount()
			}, this, true)
		}

		this.InitTT()
		
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_enter, () => {
			// if (!this.plat_mgr.is_alpha) {
			if (ClientConfig.show_agreement) {
				// if (!this.agreement_agree_state) {
				// 	let str = "请勾选同意"
				// 	if (ClientConfig.agree_text) {
				// 		str += ClientConfig.agree_text
				// 	}
				// 	if (ClientConfig.privacy_text) {
				// 		str += `及${ClientConfig.privacy_text}`
				// 	}
				// 	Message.show(str)
				// 	return
				// }
				if (!this.agreement_agree_state) {
					this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginAlertView")
					return
				}
				// }
			}
			// 打点
			// PlatformMgr.GetInstance().SubmitSdkFinish()
			PlatformManager.GetInstance().EyouDataPlacement("game_login_completed", 0);

			this.EnterFun()
		}, this, true)

		Util.AddClickEvent(this._lb_agrement2, () => {
			this.OpenAgreementView(ClientConfig.agreement_type, 1)
		}, this, false)

		Util.AddClickEvent(this._lb_agrement4, () => {
			this.OpenAgreementView(ClientConfig.agreement_type, 2)
		}, this, false)

		Util.AddClickEvent(this._img_agreement_check_bg, () => {
			this.agreement_agree_state = !this.agreement_agree_state
			this.UpdateAgreementAgreeState()
		}, this, false)

		// if (!this.plat_mgr.is_alpha) {
		Util.AddClickEvent(this._box_search_server, () => {
			if (LoginModel.GetInstance().reconnect_on_game) {
				this.BeginFun()
			} else {
				this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginSelectServerView")
			}
		}, this, false)
		// }

		let close_fun = () => {
			this.Close()
		}

		this.BindEvent(this.login_mgr, LoginStateEvent.OPEN_VIEW, (view_name?) => {
			if (view_name == "LoginCreateRoleView" || view_name == "LoginSelectRoleView") {
				close_fun()
			}

			if (view_name == "LoginSelectServerView") {
				this._img_cs.visible = false
				this.UpdateBtnPos()
			}
		})

		this.BindEvent(this.login_mgr, LoginStateEvent.CLOSE_VIEW, (view_name?) => {
			if (view_name == "LoginSelectServerView") {
				this.ShowCsBtn()
			}
		})

		this.BindEvent(GlobalEventSystem, EventName.GAME_START, close_fun)
		this.BindEvent(this.login_mgr, LoginStateEvent.CHANGE_CUR_SERVER_ID, (name?) => {
			this.UpdateServerName(name)
		})

		Util.AddClickEvent(this._img_notice, () => {
			this.OpenNoticeView()
		}, this, true)

		Util.AddClickEvent(this._img_cs, () => {
			if (Util.IsWXGame()) {
				let local_wx
				local_wx = window["wx"]
				if (local_wx && local_wx.openCustomerServiceConversation) {
					local_wx.openCustomerServiceConversation()
				}
			}

			// if (ClientConfig && ClientConfig.OpenSdkCustomerInEnterView == 1 ) { //漫灵sdk客服
			// 	PlatformMgr.GetInstance().ShowSdkCustomer()
			// } else if (PlatformManager.IsKeYiPlatform() ) { 
			// 	PlatformMgr.GetInstance().CallGM()
			// }else{
			//GlobalEventSystem.Fire(EventName.OPEN_VIEW, "CustomServiceView")
			// }
		}, this, true)

		Util.AddClickEvent(this._img_return, () => {
			Alert.Show("是否切换账号?", Alert_Type.Two, () => {
				// PlatformMgr.GetInstance().LoginOut()
				this.Close()
				GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT)
			}, null, "确定", "取消")
		}, this, true)

		Util.AddClickEvent(this._img_16, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "LoginTipsView")
		}, this, true)

		this.BindEvent(this.login_mgr, LoginStateEvent.AGREE_LOGIN_ALERT, () => {
			this.agreement_agree_state = true
			this.UpdateAgreementAgreeState()
			this.EnterFun()
		})
	}

	public InitAgreementAgreeState() {
		if (ClientConfig.show_agreement) {
			let local_account_data = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_ACCOUNT_INFO, false)
			if (local_account_data) {
				local_account_data = JSON.parse(local_account_data)
				if (local_account_data[this.login_model.account_id]) {
					if (Util.IsKSGame()) {
						//快手没有本地记录 也不帮他勾选
						this.agreement_agree_state = false
					}
					else {
						this.agreement_agree_state = true
					}
				}
				else {
					this.agreement_agree_state = false
					this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginAlertView")
				}
			}
			else {
				this.agreement_agree_state = false
				this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginAlertView")
			}
		}
	}

	public UpdateAgreementAgreeState() {
		this._img_anreement_check.visible = this.agreement_agree_state
	}

	public CheckNoticeState = () => {
		if (this.plat_mgr.is_alpha) {
			return
		}
		let call_back = () => {
			if (this.use_delete_method) {
				return
			}

			if (LoginModel.GetInstance().is_pop_notice) {
				LoginModel.GetInstance().is_pop_notice = false
				this.OpenNoticeView()
			}
			this._img_notice.visible = true
			this.UpdateBtnPos()
		}

		LoginModel.GetInstance().CheckNoticeState(call_back)
	}

	public UpdateLogo = () => {
		// let res_name = GamePlatformRes.Define.LOGIN_LOGO
		// if ((ClientConfig.custom_logo_mode || GamePlatformRes.Data[res_name]) ) {
		// 	GamePlatformRes.LoadPlatImage(res_name, this._img_logo)
		// }else{

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_logo, this.plat_mgr.GetLogoImgPath(), true)

		// }
	}

	public OpenNoticeView = () => {
		this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginNoticeView")
	}

	last_trigger_time
	public BeginFun = () => {
		if (!this.last_trigger_time || Laya.timer.currTimer - this.last_trigger_time > 1000) {
			this.last_trigger_time = Laya.timer.currTimer
			this.login_mgr.Fire(LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ServerWin)
		}
	}

	public EnterFun = () => {
		this.BeginFun()
	}

	public UpdateAgreementState = () => {
		let bool = true

		if (!ClientConfig.show_agreement || ClientConfig.show_agreement != 1) {
			bool = false
		}

		if (bool && Laya.Browser.onKGMiniGame) {
			let local_account_data = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_ACCOUNT_INFO, false)
			if (local_account_data) {
				local_account_data = JSON.parse(local_account_data)
				if (!local_account_data[this.login_model.account_id]) {
					bool = false
				}
			}
			else {
				bool = false
			}
		}

		this._box_agreement.visible = bool
		this._lb_agrement2.text = ClientConfig.agree_text
		if (ClientConfig.privacy_text) {
			this._lb_agrement3.text = "和"
			this._lb_agrement4.text = ClientConfig.privacy_text
		}
	}

	public OpenAgreementView = (style?, type?) => {
		if (!this.user_agreement_view) {
			this.user_agreement_view = new LoginUserAgreementView()
		}
		if (!this.user_agreement_view.HasOpen()) {
			this.user_agreement_view.Open(style, type)
		}
	}

	public UpdateServerName = (name?) => {
		if (name) {
			this._lb_cur_server_name.text = name
		} else {
			this._lb_cur_server_name.text = ServerModel.GetInstance().GetServerName(this.login_mgr.GetCurServerId())
		}
	}

	public ShowCsBtn = () => {
		if (!this.plat_mgr.is_alpha && ClientConfig && ClientConfig.cs_mode && ClientConfig.cs_mode == 1) {
			this._img_cs.visible = true
		} else {
			this._img_cs.visible = false
		}
		this.UpdateBtnPos()
	}

	public UpdateBtnPos() {
		RefBoxVLayout(this._box1, 8, true)
	}

	InitTT(){
		if(!Util.IsTTGame()) return
		
		this.ShowTTKeFuBtn()

		this.BindEvent(GlobalEventSystem, EventName.BASEVIEW_OPEN_OR_CLOSE, (is_open, base_file, layer_value, layout_file) => {
			if (layout_file == "LoginAlertView" || layout_file == "LoginNoticeView" || layout_file == "LoginTipsView" || layout_file == "LoginUserAgreementView" || layout_file == "LoginSelectServerView") {
				if (is_open) {
					this.HideTTKeFuBtn()
				} else {
					this.ShowTTKeFuBtn()
				}
				
			}
		});
	}

	ShowTTKeFuBtn() {
		if (Util.IsTTGame() && !ClientConfig.not_show_douyin_kefu && window["tt"] && window["tt"].createContactButton) {
			if (!this.tt_kefu_btn) {
				let stage_width = LayerManager.GetInstance().stageWidth
				let stage_height = LayerManager.GetInstance().stageHeight
				let y = (stage_height - 1280) / 2 + 208
				let x = stage_width - 72 - 25
				let sysInfo = window["tt"].getSystemInfoSync();
				console.warn("------sysInfo------", sysInfo)
				let screenW = sysInfo.screenWidth;
				let screenH = sysInfo.screenHeight;
				let real_y = y * screenH / stage_height
				let real_x = x * screenW / stage_width
				let size = screenH / stage_height * 72
				var button = window["tt"].createContactButton({
					type: "image",
					image: "./assets/newkefu.png",
					style: {
						left: real_x,
						top: real_y,
						width: size,
						height: size,
						lineHeight: 40,
						backgroundColor: "#ffffff",
						textAlign: "center",
						fontSize: 16,
						borderRadius: 4,
						borderColor: "#ffffff",
						borderWidth: 1,
						textColor: "#ffffff"
					},
					success(res) {
						console.log("create success", res);
					},
					fail(res) {
						console.log("create fail", res);
					},
					complete(res) {
						console.log("create complete", res);
					}
				});
				this.tt_kefu_btn = button
				// 点击事件
				var handleClick = function () {
					console.warn("点击客服按钮");
				}
				button.onTap(handleClick); // 兼听点击事件
				// button.hide(); // 隐藏按钮
				// 错误处理
				var handleError = function (res) {
					console.warn(res.errMsg);
				}
				button.onError(handleError); // 监听错误
				button.offError(handleError); //取消监听错误
				// button.destroy(); // 销毁按钮
			}
			this.tt_kefu_btn.show(); // 显示按钮
		}
	}

	HideTTKeFuBtn(){
		if (Util.IsTTGame() && window["tt"] && window["tt"].createContactButton) {
			if (this.tt_kefu_btn) {
				this.tt_kefu_btn.hide()
			}
		}
	}

	_img_logo: Laya.Image
	_box1: Laya.Box
	_img_notice: Laya.Image
	_img_change_account: Laya.Image
	_img_16: Laya.Image
	_img_cs: Laya.Image
	_img_enter: Laya.Image
	_box_search_server: Laya.Box
	_img_search_server_bg: Laya.Image
	_box_cur_server: Laya.HBox
	_img_server_state: Laya.Image
	_lb_cur_server_name: Laya.Label
	_lb_tips: Laya.Label
	_box_agreement: Laya.Box
	_img_agreement_check_bg: Laya.Image
	_img_anreement_check: Laya.Image
	_box_agreement_content: Laya.HBox
	_lb_agrement: Laya.Label
	_lb_agrement2: Laya.Label
	_lb_agrement3: Laya.Label
	_lb_agrement4: Laya.Label
	_img_return: Laya.Image
	public GetComponents() {
		[
			this._img_logo,
			this._box1,
			this._img_notice,
			this._img_change_account,
			this._img_16,
			this._img_cs,
			this._img_enter,
			this._box_search_server,
			this._img_search_server_bg,
			this._box_cur_server,
			this._img_server_state,
			this._lb_cur_server_name,
			this._lb_tips,
			this._box_agreement,
			this._img_agreement_check_bg,
			this._img_anreement_check,
			this._box_agreement_content,
			this._lb_agrement,
			this._lb_agrement2,
			this._lb_agrement3,
			this._lb_agrement4,
			this._img_return,
		]
			= this.GetChildrenByNames([

				"_img_logo",
				"_box1",
				"_img_notice",
				"_img_change_account",
				"_img_16",
				"_img_cs",
				"_img_enter",
				"_box_search_server",
				"_img_search_server_bg",
				"_box_cur_server",
				"_img_server_state",
				"_lb_cur_server_name",
				"_lb_tips",
				"_box_agreement",
				"_img_agreement_check_bg",
				"_img_anreement_check",
				"_box_agreement_content",
				"_lb_agrement",
				"_lb_agrement2",
				"_lb_agrement3",
				"_lb_agrement4",
				"_img_return",
			])
	}
}
window["LoginEnterView"] = LoginEnterView