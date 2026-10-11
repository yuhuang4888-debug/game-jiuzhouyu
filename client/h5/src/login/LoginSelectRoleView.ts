import { BaseView1 } from "../common/BaseView1"
import { LoginModel } from "./LoginModel"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { LoginStateEvent, EventName } from "../common/EventName"
import { LoginManager } from "./LoginManager"
import { Vector2 } from "../util/Vector2"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { SoundManager } from "../common/SoundManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { CookieWrapper } from "../common/CookieWrapper"
import { LoginSelectRoleItem } from "./LoginSelectRoleItem"
import { Config } from "../common/Config"
import { Mathf } from "../util/Mathf"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"
import { PlatformManager } from "../PlatformManager"
export class LoginSelectRoleView extends BaseView1 {

    static SELECT_ROLE_ITEM = "LSRV.SELECT_ROLE_ITEM"

    item_list
    cur_index
    cur_data
    role_list

    login_model
    res_mgr
    login_mgr
    click_time = 0
    select_cfg
    show_count = 5

    layer_mgr:LayerManager
    cache_enter_btn_centery

    vn_box_:Laya.Box
    public constructor() {
        super()

        this.base_file = "login"
        this.layout_file = "LoginSelectRoleView"
        this.layer_value = Enum_UILayer.Top
        this.back_login_toClose = true
        this.not_close_by_android_back_key = true

        this.login_model = LoginModel.GetInstance()
        this.res_mgr = ResManager.GetInstance()
        this.login_mgr = LoginManager.GetInstance()
        this.layer_mgr = LayerManager.GetInstance()

        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.open_callback = function() {
            this.UpdateView(true)
        }
        this.close_callback = function() {
            this.SelectItem(undefined)
        }
        this.destroy_callback = function () {
            this.Clear()
        }
        this.preload_client_config = {
            "ConfigLogin": false,
            "SceneObjectParticle" :false,
            "ConfigModelAni":false,
            "ConfigLoadingBgTime":false
        }
        this.preload_server_config = {
            "config_dress_up_cfg": false,
            "config_suit_clt":false,
            "config_revelation_equip_figuire":false,
            "config_dragon_ball_figure":false,
            "config_temple_awaken_kv":false,
            "config_temple_awaken_suit":false
        }
    }

    public Clear = () => {

        if(this.vn_box_){
            this.vn_box_.removeSelf()
            this.vn_box_.destroy()
            this.vn_box_=null
        }

        this.role_list = undefined
        this.cur_index = undefined
        this.click_time = 0


        if (this.item_list) {
            for (let item of this.item_list) {
                item.DeleteMe()
            }
            this.item_list = undefined
        }
        if(this._img_enter){
            Laya.Tween.clearAll(this._img_enter)
        }
    }

    public LoadSuccess = () => {
        if (PlatformManager.IsEyouVnPlatform()&&PlatformManager.GetInstance().is_wx_alpha) {
            this.vn_box_ = new Laya.Box()
            this.vn_box_.name = "Box_EyouVnAdultItem"
            this.vn_box_.width = 80
            this.vn_box_.height = 70
            this.vn_box_.centerX = 306
            this.vn_box_.y = 40
            this.display_obj.addChild(this.vn_box_)
            let view = new EyouThAdultItem(this.vn_box_)
            view.SetAnimType(2)
            view.Load()
        }

        // let t:any
        // t.t = 0;
        Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle = ResManager.GetInstance().GetGameConfigFromCache(this, "SceneObjectParticle")
        Config.PRELOAD_CLIENT_CONFIG.ConfigModelAni = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigModelAni")
        Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dragon_ball_figure", false)
        // this.display_obj.left = this.display_obj.right = 0
        this.display_obj.top = this.display_obj.bottom = 0

        this._gp_model.width = this.layer_mgr.stageWidth
        
        this.select_cfg = this.preload_client_config.ConfigLogin.SelectRole
        // this.item_list = []
        this.InitEvent()

        this.cache_enter_btn_centery = this._img_enter.centerY

        this.CallLater(() => {
            if (this.use_delete_method) return
            this.login_model.PreLoadBg()
        })

        this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginSelectServerView")
    }

    public InitEvent = () => {

        Util.AddClickEvent(this._img_return, () => {
            this.Close()
            this.login_model.account_data_10000 = undefined
            UserMsgAdapter.GetInstance().CloseSocket() //断开socket
            if (ClientConfig.account_server) {
                LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginEnterView")
            }
            else {
                LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "AccountView")
            }
        }, this, true)

        Util.AddClickEvent(this._img_enter, () => {
            if (this.cur_data) {
                let role_id = this.cur_data.role_id
                if (this.click_time == 0 || TimeUtil.getClientTime() - this.click_time > 1) {
                    if (role_id)
                        this.login_mgr.Fire(LoginStateEvent.TRY_LOGIN_GAME, role_id)
                    this.click_time = TimeUtil.getClientTime()
                }
            }
            else {
                Message.show("未选择角色")
            }
        }, this, true)

        this.BindEvent(this.login_model, LoginSelectRoleView.SELECT_ROLE_ITEM, (data) => {
            this.SelectItem(data)
        })

        this.BindEvent(GlobalEventSystem, EventName.SHOW_GREEN_BG, (show) => {
            // if (!green_shape || green_shape.visible == false) {
            //     if (!green_shape) {
            //         green_shape = new local_egret.Shape()
            //         green_shape.graphics.beginFill(0x00FF00, 1)
            //         green_shape.graphics.drawRect(0, 0, layer_mgr.stageWidth, layer_mgr.stageHeight)
            //         this.addChildAt(green_shape, 99)
            //         this.setChildIndex(this._gp_model, 100)
            //     }
            //     green_shape.visible = true
            // }
            // else {
            //     green_shape.visible = false
            // }
        })
    }

    public UpdateView = (is_first) => {

        let last_role_id = CookieWrapper.Instance.GetCookie(CookieWrapper.LAST_LOGIN_ROLE_ID, false)
        let list = this.role_list

        let select_index = 0
        list.sort((a, b) => a.role_id - b.role_id)


        let total_count = list.length, count = 0
        if(total_count < this.select_cfg.TotalCount){
            total_count = this.select_cfg.TotalCount
        }

        let call_back = () =>{
            count ++ 
            if(count == total_count){
                
                this._panel_item.vScrollBarSkin = " "
                this._panel_item.vScrollBar.stopScroll()

                let call_back 
                if (total_count < this.show_count){
                    call_back = () =>{
                        this._panel_item.vScrollBar.value = 0
                        this._panel_item.vScrollBar.visible = false
                        this._panel_item.refresh()
                    }
                }
                else{
                    this._panel_item.vScrollBar.visible = true
                    if(select_index >= this.show_count){
                        call_back = () =>{
                            this._panel_item.refresh()
                            this._panel_item.vScrollBar.value = 136 * select_index
                        }
                    }
                    else{
                        call_back = () =>{
                            this._panel_item.refresh()
                            this._panel_item.vScrollBar.value = 0
                        }
                    }
                }

                this.CallLater(call_back)
            }
        }

        let item:LoginSelectRoleItem, vo

        if(!this.item_list)
            this.item_list = []

        for (let index = total_count; index < this.item_list.length; index++) {
            item = this.item_list[index]
            item.SetVisible(false)
            item.SetPosition(50, 0)
        }

        for (let index in list) {
            vo = list[index]
            item = this.item_list[index]
            if (!item) {
                item = new LoginSelectRoleItem(this._panel_item)
                item.Load()
                this.item_list[index] = item
                
            }
            if (vo.role_id == last_role_id) {
                select_index = Number(index)
            }
            item.SetData(vo, index)
            item.ExcuteCallback(call_back)
            item.SetVisible(true)
            item.SetPosition(50, Number(index) * 136)
        }

        for (let index = list.length; index < this.select_cfg.TotalCount; index++) {
            item = this.item_list[index]
            if (!item) {
                item = new LoginSelectRoleItem(this._panel_item)
                item.Load()
                this.item_list[index] = item
            }
            item.SetData({ none: true, role_id: 0 }, index)
            item.ExcuteCallback(call_back)
            item.SetVisible(true)
            item.SetPosition(50, Number(index) * 136)
        }

        this.SelectItem(select_index)

        Laya.Tween.clearAll(this._img_enter)
        this._img_enter.centerY = this.cache_enter_btn_centery + LoginModel.ViewTweenData.SelectBtnStartPos
        this._img_enter.alpha = LoginModel.ViewTweenData.SelectBtnStartAlpha
        Laya.Tween.to(this._img_enter, { centerY: this.cache_enter_btn_centery, alpha: 1 }, LoginModel.ViewTweenData.SelectBtnInTime, Laya.Ease.circOut,null,400)

        let delay_time = 3 * LoginModel.ViewTweenData.TabInTimeInterval
        this._panel_item.mouseEnabled = false
        setTimeout(() => {
            if(this.use_delete_method) return
            this._panel_item.mouseEnabled = true
        }, delay_time);
    }

    public SelectItem = (index) => {
        if (this.cur_index == index)
            return

        let old_item = this.item_list[this.cur_index]
        if (old_item)
            old_item.SetSelectState(false)

        let new_item = this.item_list[index]
        if (new_item)
            new_item.SetSelectState(true)

        this.cur_index = index
        this.cur_data = this.role_list[index]
        if(this.cur_data){

            let config_revelation_equip_figuire = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_figuire", false)
            let config_suit_clt = this.res_mgr.GetGameConfigFromCache(this, "config_suit_clt", false)

            let config_temple_awaken_suit = this.res_mgr.GetGameConfigFromCache(this, "config_temple_awaken_suit", false)
            let config_temple_awaken_kv = this.res_mgr.GetGameConfigFromCache(this, "config_temple_awaken_kv", false)

            let [clothe_id, texture_id] = Util.GetRoleClotheId(this.cur_data, config_revelation_equip_figuire, config_suit_clt, config_temple_awaken_suit)
            let [head_id, head_texture_id] = Util.GetRoleHeadId(this.cur_data, config_revelation_equip_figuire, config_suit_clt, config_temple_awaken_kv)
          
            let weapon_id = Util.GetWeaponClotheId(this.cur_data)
            let wing_id = Util.GetWingClotheId(this.cur_data)
            let back_ornament_id = Util.GetBackOrnamentId(this.cur_data)
            let liveness_id = Util.GetLivenessId(this.cur_data)

            let pos = { x: this.select_cfg.ModelPos.x, y: this.select_cfg.ModelPos.y }
            let offset = this.select_cfg.PosOffset[`${this.cur_data.career}@${this.cur_data.sex}`]
            if(offset){
                pos.x += offset.x 
                pos.y += offset.y
            }

            let show_model_data = {
                type: UI_MODEL_TYPE.ROLE,
                career: this.cur_data.career,
                sex: this.cur_data.sex,
                scale: 0.5,
                position: pos,
                layout_file: "LoginSelectRoleView",
                enableHDR:true,

                clothe_res_id: clothe_id,
                fashion_model_id: clothe_id,
			    texture_id: texture_id,

                head_wear_id: head_id,
                head_clothe_id: head_texture_id,

                back_ornament_id: back_ornament_id,//head_clothe_id,
                weapon_res_id: weapon_id,
                wing_id: wing_id,
                liveness_id: liveness_id
                
            }
            this.res_mgr.SetRoleModel(this, this._gp_model, show_model_data)
        }

    }


    public Open(...parms) {
        if (parms)
            this.role_list = parms[0]
        super.Open()
    }

    _gp_model: Laya.Box
    _panel_item: Laya.Panel
    _img_enter: Laya.Image
    _img_return: Laya.Image
    public GetComponents() {
        [
            this._gp_model,
            this._panel_item,
            this._img_enter,
            this._img_return,
        ]
            = this.GetChildrenByNames([

                "_gp_model",
                "_panel_item",
                "_img_enter",
                "_img_return",
            ])
    }
}
window["LoginSelectRoleView"] = LoginSelectRoleView