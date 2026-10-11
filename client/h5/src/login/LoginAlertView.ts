import { BaseView1 } from "../common/BaseView1";
import { LoginStateEvent } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { PlatformManager } from "../PlatformManager";
import { ClientConfig } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { LoginManager } from "./LoginManager";
import { LoginUserAgreementView } from "./LoginUserAgreementView";

// TypeScript file
class LoginAlertView extends BaseView1 {
    user_agreement_view
    public constructor() {
        super()
        this.base_file = "login"
        this.layout_file = "LoginAlertView"
        this.layer_value = Enum_UILayer.Top

        this.use_background = true
        this.is_center = true
        this.destroy_imm = true

        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            this._html_content.off(Laya.Event.LINK, this, this.ClickFunc)
            if (this.user_agreement_view) {
                this.user_agreement_view.Close()
                this.user_agreement_view = null
            }
        }
    }

    public LoadSuccess() {
        this.InitEvent()

        let desc
        if(Laya.Browser.onKGMiniGame){
            desc = `用户协议和隐私保护指引请你务必审慎阅读,充分理解“用户协议”和“隐私保护指引”各条款,包括但不限于:为了向你提供即时通讯、内容分享等服务,我们需要收集你的设备信息、操作日志等个人信息。你可以在“设置”中查看、变更、删除个人信息并管理你的授权。你可阅读<a href='1'><font color='#ff4f50'>《用户协议》</font></a>，<a href='2'><font color='#ff4f50'>《隐私保护指引》</font></a>了解详细信息。如你同意,请点击同意“开始接受我们的服务”。`
            // this._box_cancel.visible = false
            // this._box_ok.x = 290
            // this._lb_ok.text = "确定"
        }
        else{
            desc = `用户协议和隐私保护指引请你务必审慎阅读,充分理解“用户协议”和“隐私保护指引”各条款,包括但不限于:为了向你提供即时通讯、内容分享等服务,我们需要收集你的设备信息、操作日志等个人信息。你可以在“设置”中查看、变更、删除个人信息并管理你的授权。你可阅读<a href='1'><font color='#ff4f50'>《用户协议》</font></a>，<a href='2'><font color='#ff4f50'>《隐私保护指引》</font></a>了解详细信息。如你同意,请点击同意“开始接受我们的服务”。`
        }

        this._html_content.innerHTML = desc


    }


    public InitEvent() {
        Util.AddClickEvent(this._box_ok, () => {
            this.Close()
            LoginManager.GetInstance().Fire(LoginStateEvent.AGREE_LOGIN_ALERT)
        }, this, true)

        Util.AddClickEvent(this._box_cancel, () => {
            this.Close()
            if(Util.IsQQGame() || Util.IsMiFastGame()){
                PlatformManager.GetInstance().exitMiniProgram()
            }
        }, this, true)

        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)
        this._html_content.on(Laya.Event.LINK, this, this.ClickFunc)
    }
    public ClickFunc(e?) {
        if (e) {
            this.OpenAgreementView(ClientConfig.agreement_type, e)
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


    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_title: Laya.Image
    _box_cancel: Laya.Box
    _img_cancel: Laya.Image
    _lb_cancel: Laya.Label
    _box_ok: Laya.Box
    _img_ok: Laya.Image
    _lb_ok: Laya.Label
    _img_close: Laya.Image
    _html_content: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_title,
            this._box_cancel,
            this._img_cancel,
            this._lb_cancel,
            this._box_ok,
            this._img_ok,
            this._lb_ok,
            this._img_close,
            this._html_content,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_title",
                "_box_cancel",
                "_img_cancel",
                "_lb_cancel",
                "_box_ok",
                "_img_ok",
                "_lb_ok",
                "_img_close",
                "_html_content",
            ])
        this._html_content.width = 525
        this._html_content.style.fontSize = 26
        this._html_content.style.color = "#783528"
        this._html_content.style.align = "left"
        this._html_content.style.lineHeight = 32
        this._html_content.style.wordWrap = true
    }

}
window["LoginAlertView"] = LoginAlertView