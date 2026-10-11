import { BaseView1 } from "../common/BaseView1"
import { LoginModel } from "./LoginModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem, ClientConfig, LOAD_QUEUE, FRAME_TYPE } from "../util/DeclareGlobalVar"
import { LoginManager } from "./LoginManager"
import { EventName, LoginStateEvent } from "../common/EventName"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Runner } from "../util/Runner"
// import { UIDragonBonesModelClass } from "../common/UIDragonBonesModelClass"
import { Enum_UILayer } from "../common/LayerManager"
// import { StoryAnimationModel } from "../storyAnimation/StoryAnimationModel"
import { TimeUtil } from "../util/TimeUtil"
import { Message } from "../sysInfo/SysInfoController"
import { ViewManager } from "../common/ViewManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { GameResPath } from "../util/GameResPath"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"
export class LoginLoadingView extends BaseView1 {

    login_model: LoginModel
    platform_mgr: PlatformManager
    login_mgr: LoginManager
    res_mgr: ResManager
    role_mgr: RoleManager
    server_time_model: ServerTimeModel
    runner: Runner

    count_down_state
    game_start_state
    move_speed = 80
    /**
     * 超时多久关闭加载界面
     */
    left_time = 12
    front_img_width = 632
    should_be_close = false
    alpha_state_to_close = false
    last_curr_target_value = 0
    tween_trigger = true
    video_: Laya.Video
    vn_box_:Laya.Box
    public constructor() {
        super()

        this.base_file = "login"
        this.layout_file = "LoginLoadingView"
        this.layer_value = Enum_UILayer.Top
        this.is_center = true
        this.destroy_imm = true
        this.is_delay_callback = false
        this.need_loading_view = false
        this.not_show_main_msg = true
        this.not_show_attr_main_msg = true
        this.use_background = true
        this.background_alpha = 1
        this.not_close_by_android_back_key = true


        this.login_model = LoginModel.GetInstance()
        this.platform_mgr = PlatformManager.GetInstance()
        this.login_mgr = LoginManager.GetInstance()
        this.res_mgr = ResManager.GetInstance()
        this.role_mgr = RoleManager.GetInstance()
        this.server_time_model = ServerTimeModel.GetInstance()
        this.runner = Runner.GetInstance()

        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.open_callback = function () {

        }
        this.close_callback = function () {
            ViewManager.GetInstance().CloseBaseWindow();
            ViewPopLevelModel.GetInstance().NextPop();
        }

        this.destroy_callback = function () {
            this.Remove()
        }
        this.preload_client_config = {
            "ConfigLoadingBgTime": false
        }
    }

    public InitEvent() {
        this.BindEvent(GlobalEventSystem, EventName.GAME_START, () => {
            this.CallLater(() => {
                this.game_start_state = true
                this.move_speed = 200
                this.login_model.curr_enter_game_loading_step += 5
                this.TryCloseLoading()
            })
        })
        this.BindEvent(this.login_mgr, LoginStateEvent.REFRESH_LODINGVIEW_LOCK_FLAG, () => {
            this.login_model.curr_enter_game_loading_step += 3
            this.TryCloseLoading()
        })
        this.BindEvent(GlobalEventSystem, EventName.CHANGE_ACCOUNT, () => {
            this.Close()
        })

    }
    public Update(now_time, elapse_time) {
        if (this._img_front) {
            let curr_target_value = this._img_front.width + this.move_speed * Math.min(elapse_time, 0.1)
            if (curr_target_value >= (this.front_img_width * 0.98)) {
                this._img_front.width = this.front_img_width * 0.98
                this.count_down_state = true
                this.TryCloseLoading()
            }
            else {
                this._img_front.width = curr_target_value
            }
            this.OnChange()
        }

        if (/*!this.login_mgr.is_wait_video&&*/this.should_be_close) {
            this.should_be_close = false
            this.Close()
        }

    }

    public LoadSuccess() {

        if (PlatformManager.IsEyouVnPlatform()&&PlatformManager.GetInstance().is_wx_alpha) {
            this.vn_box_ = new Laya.Box()
            this.vn_box_.name = "Box_EyouVnAdultItem"
            this.vn_box_.width = 80
            this.vn_box_.height = 70
            this.vn_box_.centerX = 150
            this.vn_box_.y = 40
            this.display_obj.addChild(this.vn_box_)
            let view = new EyouThAdultItem(this.vn_box_)
            view.Load()
        }

        this._lb_first_load.fontSize = 48
        this._lb_first_load.scale(0.5, 0.5)
        this._lb_load_progress.fontSize = 48
        this._lb_load_progress.scale(0.5, 0.5)
        this._lb_version.fontSize = 48
        this._lb_version.scale(0.5, 0.5)

        this.res_mgr.SetTexture(this, this._img_back, "resource/game/login/texture/uidl_015.png")
        this.res_mgr.SetTexture(this, this._img_front, "resource/game/login/texture/uidl_016.png")

        if (PlatformManager.IsEyouEnPlatform()) {
            this._lb_version.visible = false
        }

        this.login_model.is_show_loading_view = true
        GlobalEventSystem.Fire(EventName.DELAY_SHOW_FIGHTUP, true)

        this.login_model.curr_enter_game_loading_step += 1

        // let validata_list = []
        // if (
        //     Util.IsWXGame()
        //     || Util.IsQQGame()
        //     || Util.IsOPPOFastGame()
        //     || Util.IsVivoFastGame()
        //     || Util.IsUCGame()
        //     || Util.IsMiFastGame()
        //     || Util.IsBiliBiliGame()
        //     || Util.IsMeiZuFastGame()
        //     || Util.IsKSGame()
        //     || Util.IsMTGame()
        //     || (!this.platform_mgr.is_alpha && !this.platform_mgr.need_alpha_open_charge)) {
        //     let cfg = this.res_mgr.GetGameConfigFromCache(this, "ConfigLoadingBgTime", true)
        //     let mainrole_level = this.role_mgr.GetMainRoleVo().level
        //     let curr_open_server_day = this.server_time_model.GetOpenServerDay()
        //     let curr_merge_server_day = this.server_time_model.GetMergeServerDay()
        //     let curr_time = TimeUtil.getServerTime()
        //     let list
        //     let curr_week = new Date(curr_time).getDay()
        //     for (let id in cfg) {
        //         list = cfg[id]
        //         for (let vo of list) {
        //             if (mainrole_level >= vo.min_level && mainrole_level <= vo.max_level
        //                 && curr_open_server_day >= vo.open_server_day && curr_open_server_day <= vo.end_server_day
        //                 && curr_merge_server_day >= vo.merge_server_start_day && curr_merge_server_day <= vo.merger_server_end_day
        //                 && vo.open_week.indexOf(curr_week) >= 0
        //                 && curr_time >= vo.custom_open_time && curr_time <= vo.custom_end_time) {
        //                 validata_list.push(id)
        //                 break
        //             }
        //         }
        //     }
        // }
        let onLoadCallback = async (texture) => {
            if (texture) {
                Util.SetLargeScreenImageSize(this._img_bg, texture.textureWidth, texture.textureHeight)
                this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginSelectRoleView");
                this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginCreateRoleView");
                this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginBgView");
            }
            if (!this.use_delete_method) {
                ViewManager.GetInstance().OpenBaseWindow(true)
            }
        }
        // let len = validata_list.length
        if (this.login_model._preload_bg_id!=-1) {
            let id = this.login_model._preload_bg_id//validata_list[Util.RandomRange(0, len - 1)]
            this.res_mgr.SetTexture(this, this._img_bg, `resource/game/login/texture/load_bg${id}.jpg`, onLoadCallback, this, true, LOAD_QUEUE.HIGHT, true, true)
        }
        else {
            if (PlatformManager.GetInstance().is_alpha) {
                let source = `resource/game/login/texture/load_bg1.jpg`
                this.res_mgr.SetTexture(this, this._img_bg, source, onLoadCallback, this, true, LOAD_QUEUE.HIGHT, null, true)
            }
            else {
                this.res_mgr.SetTexture(this, this._img_bg, this.platform_mgr.GetEnterGameLoadingBgPath(), onLoadCallback, this, true, LOAD_QUEUE.HIGHT, true, true)
            }
        }
        this.runner.AddRunObj(this, 1, FRAME_TYPE.total)
        if (
            !Util.IsWXGame()
            && !Util.IsQQGame()
            && !Util.IsOPPOFastGame()
            && !Util.IsVivoFastGame()
            && !Util.IsUCGame()
            && !Util.IsMiFastGame()
            && !Util.IsBiliBiliGame()
            && !Util.IsMeiZuFastGame()
            && !Util.IsKSGame()
            && !Util.IsMTGame()
            && !Util.IsTTGame()
            && (this.platform_mgr.is_alpha || this.platform_mgr.need_alpha_open_charge)) {
            this._box_con.visible = false
        }
        else {
            this._box_con.visible = true
        }
        GlobalEventSystem.Fire(EventName.PRELOAD_LOADING_COMPLETED)
        if (this.login_model.is_new_career) {
            this.BindEvent(GlobalEventSystem, EventName.LOAD_LOADING_OTHER_RES, () => {
                this.LoadOtherRes()
            })
        }
        else {
            this.LoadOtherRes()
        }
    }

    public LoadOtherRes() {
        if (this.login_model.is_new_career) {
            this.platform_mgr.DataPlacement(290008) //创角成功后加载
        }
    }
    public OnChange() {
        if (this._img_front) {
            let value = this._img_front.width / this.front_img_width
            let pro = (value * 100).toFixed(2)
            this._lb_load_progress.text = `loading......${pro}%`
            if (this.tween_trigger && Number(pro) >= 55 && this.login_model.is_new_career) {
                this.tween_trigger = false
            }
        }
    }

    public TryCloseLoading() {
        if (this.alpha_state_to_close) {
            this.Close()
        }
        else {
            if (this.count_down_state && (this.game_start_state) && !this.login_model.HasLockFlag()) {
                this.count_down_state = false
                this.should_be_close = true
                if (this._img_front) {
                    this._img_front.width = this.front_img_width
                }
                this.OnChange()
            }
        }
    }

    public Remove() {
        if(this.vn_box_){
            this.vn_box_.removeSelf()
            this.vn_box_.destroy()
            this.vn_box_=null
        }
        this.Dispatcher()
        this.runner.RemoveRunObj(this.hashCode)
    }

    private Dispatcher() {
        GlobalEventSystem.Fire(EventName.HIDE_OR_SHOW_CANVAS_LAYER, true)
        this.platform_mgr.DataPlacement(290009) //到达游戏场景
        kfStageModel.GetInstance().wait_loginloading = false
        kfStageModel.GetInstance().CheckKFStage()
        GlobalEventSystem.Fire(EventName.DELAY_SHOW_FIGHTUP, false)
        GlobalEventSystem.Fire(EventName.LOGIN_LOADING_VIEW_CLOSE)
        this.login_model.is_show_loading_view = false
    }

    public Open() {
        this.count_down_state = this.game_start_state = this.should_be_close = false
        this.InitEvent()
        super.Open()
    }


    _img_bg: Laya.Image
    _box_con: Laya.Box
    _lb_first_load: Laya.Label
    _img_back: Laya.Image
    _img_front: Laya.Image
    _lb_load_progress: Laya.Label
    _lb_version: Laya.Label
    public GetComponents() {
        [
            this._img_bg,
            this._box_con,
            this._lb_first_load,
            this._img_back,
            this._img_front,
            this._lb_load_progress,
            this._lb_version,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_box_con",
                "_lb_first_load",
                "_img_back",
                "_img_front",
                "_lb_load_progress",
                "_lb_version",
            ])
    }
}
window["LoginLoadingView"] = LoginLoadingView