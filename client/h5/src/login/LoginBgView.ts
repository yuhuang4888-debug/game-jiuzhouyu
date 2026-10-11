import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { GlobalTimerQuest, Util } from "../util/Util"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { LoginModel } from "./LoginModel"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { LoginStateEvent } from "../common/EventName"
import { LoginManager } from "./LoginManager"
import { SoundManager } from "../common/SoundManager"
export class LoginBgView extends BaseView1 {


    /**
     * 已加载背景
     */
    bg_had_load = false


    res_mgr:ResManager
    plat_mgr:PlatformManager
    login_mgr:LoginManager
    login_model:LoginModel

    last_open_view

    public constructor() {
        super()
        this.base_file = "login"
        this.layout_file = "LoginBgView"
        this.layer_value = Enum_UILayer.Top
        this.destroy_imm = true
        this.need_loading_view = false

        if(Laya.Browser.onMobile){
            this.background_alpha = 1
        }else{
            this.background_alpha = 0
        }
        
        this.not_close_by_android_back_key = true
        this.use_background = true

        this.login_model = LoginModel.GetInstance()
        this.res_mgr = ResManager.GetInstance()
        this.plat_mgr = PlatformManager.GetInstance()
        this.login_mgr = LoginManager.GetInstance()

        this.load_callback = () => {
            if (PlatformManager.IsEyouThPlatform()) {
                this._lb_down.visible = false
            }
            this.LoadSuccess()
        }

        this.open_callback = function () {
            this.bg_had_load = false
            this.UpdateView()
        }

        this.destroy_callback = function () {
            this.Remove()
            this.last_open_view = null
        }
    }

    Remove(){
        Util.RemoveVersionText()
        if (
            Util.IsWXGame() 
            || Util.IsQQGame() 
            || Util.IsOPPOFastGame() 
            || Util.IsVivoFastGame() 
            || Util.IsMiFastGame() 
            || Util.IsUCGame() 
            || Util.IsBiliBiliGame() 
            || Util.IsMeiZuFastGame() 
            || Util.IsKSGame() 
            || Util.IsMTGame()
            ) {
            Laya.loader.clearRes("assets/denglu_bg.jpg")
            Laya.loader.clearRes("assets/load_bg2.ktx")
        }
        if(this._img_bg){
            Laya.Tween.clearAll(this._img_bg)
        }
    }

    LoadSuccess(){
        if (Util.IsMiniGame()) {
            let version_text = window["version_text"]
            if (version_text) {
                Laya.stage.setChildIndex(version_text, Laya.stage.numChildren - 1)
            }
        }
        SoundManager.GetInstance().PlaySoundEffect("2_dianji", true, 0)
        this.InitEvent()
        this._img_bg.anchorX = 0.5
        this._img_bg.anchorY = 0.65
    }


    InitEvent(){
        let bg_fun = () => {
            let sdk_name = this.plat_mgr.sdk_name
            if (sdk_name && (window[sdk_name] || Util.IsConch()) && this.plat_mgr.sdk_login_had_callback == false && ClientConfig.click_bg_can_login_sdk) {
                this.plat_mgr.LoginBySdkCallbak()
            }
        }
        Util.AddClickEvent(this._img_bg, bg_fun, this)

        this.BindEvent(LoginManager.GetInstance(), LoginStateEvent.OPEN_VIEW, (view_name) => {
            if (view_name == "LoginCreateRoleView" || view_name == "LoginSelectRoleView") {
                this.ChangeRoleStatus(view_name)
            }
        })

        this.BindEvent(LoginManager.GetInstance(), LoginStateEvent.OPEN_VIEW, (view_name) => {
            if (view_name == "LoginEnterView" || view_name == "AccountView") {
                this.UpdateView()
                this.last_open_view = null
            }
        })
    }

    ChangeRoleStatus(view_name){
        this._lb_copy_right.visible = false
        let bg_url = "resource/game/login/texture/ui_Login_bg2.jpg"
        this._img_bg.visible = true
        this.res_mgr.SetTexture(this, this._img_bg, bg_url, (texture) => {
            if (texture) {
                Util.SetLargeScreenImageSize(this._img_bg, texture.sourceWidth, texture.sourceHeight)
            }
        }, this, true, null, null, true)
        if(this.last_open_view) return
        this.last_open_view = view_name

        Laya.Tween.clearAll(this._img_bg)
        this._img_bg.scale(LoginModel.ViewTweenData.BgInStartScale, LoginModel.ViewTweenData.BgInStartScale)
        Laya.Tween.to(this._img_bg, { scaleX: 1, scaleY: 1 }, LoginModel.ViewTweenData.BgInTime, Laya.Ease.circOut)
    }

    SetCopyRight(){
        if (ClientConfig && ClientConfig.copy_right && String(ClientConfig.copy_right).trim() != "") {
            this._lb_copy_right.visible = true
            this._lb_copy_right.text = ClientConfig.copy_right
        }
        else {
            this._lb_copy_right.visible = false
        }
    }
    
    UpdateView(){
        let begin_login = () => {
            if (!this.bg_had_load) {
                Util.RemoveGameStartLoading()
                this.bg_had_load = true
                //返回角色
                if (this.login_model.wait_request_into_role) {
                    this.login_mgr.Fire(LoginStateEvent.START_GAME_CONNECT, true);
                    this.login_model.wait_request_into_role = false
                //返回登录
                } else if(this.login_model.wait_show_account_view) {
                    this.login_mgr.Fire(LoginStateEvent.START_LOGIN_MODULE)
                    this.login_model.wait_show_account_view = false
                //正常登录
                } else{
                    this.login_mgr.Fire(LoginStateEvent.START_LOGIN_MODULE)
                }
                setTimeout(() => {
                    this.res_mgr.PreloadCommonRes()
                    this.res_mgr.LoadProtocalConfigZip()
                    if(!Util.IsWXGame() && ClientConfig && ClientConfig.solveRepeatMusic)
                    {
                        Laya.SoundManager.stopAll() //解决app链接包会出现同时播放两次的bug
                    }
                    SoundManager.GetInstance().PlaySceneSound(0.1, null, "main")
                }, 500);
            }
        }

        GlobalTimerQuest.AddDelayQuest(() => {
            if (!this.use_delete_method) {
                begin_login()
            }
        }, 10)

        let onLoadCallback = async (texture?) => {
            if (Util.IsOPPOFastGame()) {
                window["qg"].loadingComplete({})
            }
            if (texture) {
                Util.SetLargeScreenImageSize(this._img_bg, texture.sourceWidth, texture.sourceHeight)
            }
            PlatformManager.GetInstance().NativeLogigBgSuccess()
            begin_login()
        }

        if (ClientConfig && ClientConfig.login_bg) {
            this._img_bg.visible = true
            let bg_url = PlatformManager.GetInstance().GetLoginBgPath()
            this.res_mgr.SetTexture(this, this._img_bg, bg_url, onLoadCallback, this, true, null, null)
        }
        else {
            if (Util.IsCanvasRenderMode()) {
                this._img_bg.visible = true
                let bg_url = "resource/game/scene/dragonBones/denglu/denglu_bg.jpg"
                this.res_mgr.SetTexture(this, this._img_bg, bg_url, onLoadCallback, this, true, null, null, true)
            }
            else {
                this._img_bg.visible = true
                if ((
                    Util.IsWXGame() 
                    || Util.IsQQGame() 
                    || Util.IsOPPOFastGame() 
                    || Util.IsVivoFastGame() 
                    || Util.IsMiFastGame() 
                    || Util.IsUCGame() 
                    || Util.IsBiliBiliGame() 
                    || Util.IsMeiZuFastGame()
                    || Util.IsKSGame()
                    || Util.IsMTGame()
                    ) && window["login_bg"]) {
                    this._img_bg.texture = window["login_bg"].texture
                    onLoadCallback()
                }
                else {
                    let bg_url = "resource/game/scene/dragonBones/denglu/denglu_bg.jpg"
                    this.res_mgr.SetTexture(this, this._img_bg, bg_url, onLoadCallback, this, true, null, null, true)
                }
            }
        }
        this.SetCopyRight()
    }

    _img_bg: Laya.Image
    _lb_version: Laya.Label
    _lb_down: Laya.Label
    _lb_copy_right: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._lb_version,
            this._lb_down,
            this._lb_copy_right,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_lb_version",
                "_lb_down",
                "_lb_copy_right",
            ])
    }
}
window["LoginBgView"] = LoginBgView