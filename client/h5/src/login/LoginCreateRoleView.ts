import { BaseView1 } from "../common/BaseView1"
import { LoginUserAgreementView } from "./LoginUserAgreementView"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { PlatformManager } from "../PlatformManager"
import { GetTargetHashcode, GlobalTimerQuest, Util } from "../util/Util"
import { ServerModel } from "./ServerModel"
import { LoginModel } from "./LoginModel"
import { GlobalEventSystem, ClientConfig, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { LoginStateEvent, EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { LoginManager } from "./LoginManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { TimeUtil } from "../util/TimeUtil"
import { LoginCreateRoleItem } from "./LoginCreateRoleItem"
import { GameResPath } from "../util/GameResPath"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { Config } from "../common/Config"
import { EffectResType } from "../scene/SceneConfig"
import { SoundManager } from "../common/SoundManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { table } from "../common/table"
import { EyouThAdultItem } from "../mainUI/EyouThAdultItem"
export class LoginCreateRoleView extends BaseView1 {

    now_index: number
    language_cfg

    career_head_list
    last_click_time: number = 0
    wait_click_time: number = 1

    start_random_name = false
    random_name_index = 0
    random_name
    max_random_count = 10

    create_cfg
    ui_cfg

    sound_channel: Laya.SoundChannel
    has_init = false

    platform_mgr: PlatformManager
    layer_mgr: LayerManager
    server_model: ServerModel
    login_model: LoginModel
    login_mgr: LoginManager
    res_mgr: ResManager

    cache_img_enter_centery
    cache_img_bg_centery
    cache_img_random_centery
    cache_lb_random_name_centery

    cache_img_tips_centerx
    cache_img_tips2_centerx
    cache_img_tips3_centerx

    vn_box_: Laya.Box
    public constructor() {
        super()
        this.base_file = "login"
        this.layout_file = "LoginCreateRoleView"
        this.layer_value = Enum_UILayer.Top
        this.not_close_by_android_back_key = true

        this.platform_mgr = PlatformManager.GetInstance()
        this.layer_mgr = LayerManager.GetInstance()
        this.server_model = ServerModel.GetInstance()
        this.login_model = LoginModel.GetInstance()
        this.res_mgr = ResManager.GetInstance()
        this.login_mgr = LoginManager.GetInstance()
        let local_LoginModel_Instance = LoginModel.GetInstance()
        let local_LoginManager_Instance = LoginManager.GetInstance()

        if (PlatformManager.IsEyouEnPlatform()) {
            this.preload_client_config = {
                "ConfigLogin": false,
                "ConfigRandomNameEyouEn": false,
                "ConfigLanguageMaskEyouEn": false,
                "SceneObjectParticle": false
            }
            this.language_cfg = "ConfigLanguageMaskEyouEn"
        } else if (PlatformManager.IsEyouThPlatform()) {
            this.preload_client_config = {
                "ConfigLogin": false,
                "ConfigRandomNameEyouTh": false,
                "ConfigLanguageMaskEyouEn": false,
                "SceneObjectParticle": false
            }
            this.language_cfg = "ConfigLanguageMaskEyouEn"
        }
        else if (this.platform_mgr.is_alpha || this.platform_mgr.need_alpha_open_charge) {
            if (Util.IsWXGame() || Util.IsQQGame() || Util.IsKSGame()) {
                this.preload_client_config = {
                    "ConfigLogin": false,
                    "ConfigRandomName": false,
                    "SceneObjectParticle": false
                }
            } else {
                this.preload_client_config = {
                    "ConfigLogin": false,
                    "ConfigRandomName": false,
                    "ConfigLanguageMaskAlpha": false,
                    "SceneObjectParticle": false
                }
                this.language_cfg = "ConfigLanguageMaskAlpha"
            }
        }
        else {
            if (Util.IsWXGame() || Util.IsQQGame() || Util.IsKSGame()) {
                this.preload_client_config = {
                    "ConfigLogin": false,
                    "ConfigRandomName": false,
                    "SceneObjectParticle": false
                }
            } else {
                this.preload_client_config = {
                    "ConfigLogin": false,
                    "ConfigRandomName": false,
                    "ConfigLanguageMask": false,
                    "SceneObjectParticle": false,
                    "ConfigModelAni": false
                }
                this.language_cfg = "ConfigLanguageMask"
            }
        }

        this.preload_server_config = {
            "config_dress_up_cfg": false
        }

        this.load_callback = () => {

            if (PlatformManager.IsEyouVnPlatform() && PlatformManager.GetInstance().is_wx_alpha) {
                this.vn_box_ = new Laya.Box()
                this.vn_box_.name = "Box_EyouVnAdultItem"
                this.vn_box_.width = 80
                this.vn_box_.height = 70
                this.vn_box_.centerX = 150
                this.vn_box_.y = 40
                this.display_obj.addChild(this.vn_box_)
                let view = new EyouThAdultItem(this.vn_box_)
                view.SetAnimType(2)
                view.Load()
            }


            if (PlatformManager.IsEyouEnPlatform()) {
                this.login_mgr.is_wait_video = ClientConfig && ClientConfig["is_open_video"]
            } else {
                if(local_LoginModel_Instance.plat_name && Util.IsWXGame() && (ClientConfig["is_open_video"] || ClientConfig["is_open_elim"])){
                    local_LoginManager_Instance.is_wait_video = true
                } else if (LoginModel.GetInstance().account_data_10000 && LoginModel.GetInstance().account_data_10000.role_num == 0) {
                    if (local_LoginModel_Instance.plat_name) {
                        //其他平台
                        if (ClientConfig && ((!Util.IsIOSConch() && ClientConfig["is_open_video"]) || ClientConfig["is_open_elim"])
                            && LoginManager.GetInstance().IsNewPlayer()) {
                            local_LoginManager_Instance.is_wait_video = true
                        }
                    } else {
                        //开发
                        if (ClientConfig && ((!Util.IsIOSConch() && ClientConfig["is_open_video"]) || ClientConfig["is_open_elim"])) {
                            local_LoginManager_Instance.is_wait_video = true
                        }
                    }
                }
            }
            this.LoadSuccess()
        }

        this.open_callback = () => {

            this.platform_mgr.DataPlacement(290006) //到达创角页（未创角）
            this.platform_mgr.EyouDataPlacement("role_completed", 0)

            this.UpdateView()
            this.SelectCareer(this.GetRandomIndex())

            this.StartRandomName()


            this.ShowTween()

        }

        this.close_callback = () => {
            this.start_random_name = false
            this.random_name_index = 0
            if (this.sound_channel) {
                this.sound_channel.stop()
                this.sound_channel = undefined
            }
        }

        this.destroy_callback = () => {
            this.Remove()
        }


    }

    public Open(...args): void {

        super.Open()
    }


    public Remove() {

        if (this.vn_box_) {
            this.vn_box_.removeSelf()
            this.vn_box_.destroy()
            this.vn_box_ = null
        }

        if (this.career_head_list) {
            for (let obj of this.career_head_list) {
                obj.DeleteMe()
            }
            this.career_head_list = undefined
        }
        this.now_index = undefined

        this.ClearCheckTimer()

        if (this._img_enter) {
            Laya.Tween.clearAll(this._img_enter)
            Laya.Tween.clearAll(this._img_bg)
            Laya.Tween.clearAll(this._img_random)
            Laya.Tween.clearAll(this._lb_random_name)
            Laya.Tween.clearAll(this._img_tips)
            Laya.Tween.clearAll(this._img_tips2)
            Laya.Tween.clearAll(this._img_tips3)
        }
    }

    public ShowTween() {
        //下面
        Laya.Tween.clearAll(this._img_enter)
        Laya.Tween.clearAll(this._img_bg)
        Laya.Tween.clearAll(this._img_random)
        Laya.Tween.clearAll(this._lb_random_name)

        this._img_enter.centerY = this.cache_img_enter_centery + LoginModel.ViewTweenData.CreateDownStartPos
        this._img_bg.centerY = this.cache_img_bg_centery + LoginModel.ViewTweenData.CreateDownStartPos
        this._img_random.centerY = this.cache_img_random_centery + LoginModel.ViewTweenData.CreateDownStartPos
        this._lb_random_name.centerY = this.cache_lb_random_name_centery + LoginModel.ViewTweenData.CreateDownStartPos

        this._img_enter.alpha = LoginModel.ViewTweenData.CreateDownStartAlpha
        this._img_bg.alpha = LoginModel.ViewTweenData.CreateDownStartAlpha
        this._img_random.alpha = LoginModel.ViewTweenData.CreateDownStartAlpha
        this._lb_random_name.alpha = LoginModel.ViewTweenData.CreateDownStartAlpha

        Laya.Tween.to(this._img_enter, { centerY: this.cache_img_enter_centery, alpha: 1 }, LoginModel.ViewTweenData.CreateDownInTime, Laya.Ease.circOut, null, 400)
        Laya.Tween.to(this._img_bg, { centerY: this.cache_img_bg_centery, alpha: 1 }, LoginModel.ViewTweenData.CreateDownInTime, Laya.Ease.circOut, null, 400)
        Laya.Tween.to(this._img_random, { centerY: this.cache_img_random_centery, alpha: 1 }, LoginModel.ViewTweenData.CreateDownInTime, Laya.Ease.circOut, null, 400)
        Laya.Tween.to(this._lb_random_name, { centerY: this.cache_lb_random_name_centery, alpha: 1 }, LoginModel.ViewTweenData.CreateDownInTime, Laya.Ease.circOut, null, 400)


        //右边
        Laya.Tween.clearAll(this._img_tips)
        Laya.Tween.clearAll(this._img_tips2)
        Laya.Tween.clearAll(this._img_tips3)

        this._img_tips.centerX = this.cache_img_tips_centerx + LoginModel.ViewTweenData.CreateRightStartPos
        this._img_tips2.centerX = this.cache_img_tips2_centerx + LoginModel.ViewTweenData.CreateRightStartPos
        this._img_tips3.centerX = this.cache_img_tips3_centerx + LoginModel.ViewTweenData.CreateRightStartPos

        this._img_tips.alpha = LoginModel.ViewTweenData.CreateRightStartAlpha
        this._img_tips2.alpha = LoginModel.ViewTweenData.CreateRightStartAlpha
        this._img_tips3.alpha = LoginModel.ViewTweenData.CreateRightStartAlpha

        Laya.Tween.to(this._img_tips, { centerX: this.cache_img_tips_centerx, alpha: 1 }, LoginModel.ViewTweenData.CreateRightInTime, Laya.Ease.circOut)
        Laya.Tween.to(this._img_tips2, { centerX: this.cache_img_tips2_centerx, alpha: 1 }, LoginModel.ViewTweenData.CreateRightInTime, Laya.Ease.circOut)
        Laya.Tween.to(this._img_tips3, { centerX: this.cache_img_tips3_centerx, alpha: 1 }, LoginModel.ViewTweenData.CreateRightInTime, Laya.Ease.circOut)
    }

    public LoadSuccess() {
        if (PlatformManager.IsEyouEnPlatform()) {
            this._img_tips3.centerY = -210
        }
        Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle = ResManager.GetInstance().GetGameConfigFromCache(this, "SceneObjectParticle")
        Config.PRELOAD_CLIENT_CONFIG.ConfigModelAni = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigModelAni")
        // this.display_obj.left = this.display_obj.right = 
        this.display_obj.top = this.display_obj.bottom = 0

        this._gp_model_con.width = this.layer_mgr.stageWidth
        this._gp_model_con.height = this.layer_mgr.stageHeight

        this.cache_img_enter_centery = this._img_enter.centerY
        this.cache_img_bg_centery = this._img_bg.centerY
        this.cache_img_random_centery = this._img_random.centerY
        this.cache_lb_random_name_centery = this._lb_random_name.centerY

        this.cache_img_tips_centerx = this._img_tips.centerX
        this.cache_img_tips2_centerx = this._img_tips2.centerX
        this.cache_img_tips3_centerx = this._img_tips3.centerX

        GlobalEventSystem.Fire(EventName.HIDE_OR_SHOW_CANVAS_LAYER, false)
        this.platform_mgr.LoginBuryingPoint(2, 3)
        this.create_cfg = this.preload_client_config.ConfigLogin.CreateRole
        this.ui_cfg = this.create_cfg.UI
        this.InitEvent()


        // let shader_obj_list = this.res_mgr.GetGameConfigFromCache(this, "ConfigLoginShaderObj")
        // let arr
        // let compile_list = []
        // for(let shader_name in shader_obj_list){
        //     arr = shader_obj_list[shader_name]
        //     let dic = {}
        //     for (let index = 0; index < arr.length; index++) {
        //         let obj = arr[index];
        //         Laya.Shader3D.compileShaderByDefineNames(shader_name, obj.subShaderIndex, obj.passIndex, obj.defineNames)
        //     }
        // }

        this.CallLater(() => {
            if (this.use_delete_method) return
            this.PreLoadVideoRes()
            this.login_model.PreLoadBg()
        })


        this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginSelectServerView")
    }

    public InitEvent = () => {

        Util.AddClickEvent(this._img_random, () => {
            this.StartRandomName()
        }, this, true)

        Util.AddClickEvent(this._img_enter, () => {
            this.EnterFun()
        }, this, true)

        Util.AddClickEvent(this._img_return, () => {

            let account_data_10000 = this.login_model.account_data_10000
            if (account_data_10000 && account_data_10000.role_num > 0 && account_data_10000.role_list) {
                this.Close()
                this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginSelectRoleView", account_data_10000.role_list)
            }
            else {

                this.Close()
                this.login_model.account_data_10000 = undefined

                UserMsgAdapter.GetInstance().CloseSocket() //断开socket
                if (ClientConfig.account_server) {
                    this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginEnterView")
                }
                else {
                    this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "AccountView")
                }
            }
        }, this, true)

        this.BindEvent(GlobalEventSystem, EventName.CHANGE_ACCOUNT, () => {
            this.Close()
        })

        this.BindEvent(this.login_mgr, LoginStateEvent.UPDATE_VERIFY_NAME_RESULT, (result) => {
            if (result) {
                this.EndRandomName()
            } else {
                this.RandomName()
            }
        })

        this.BindEvent(this.login_mgr, LoginStateEvent.START_GAME_CONNECT, () => {
            this.start_random_name = false
        })

        let change_name_time = 0
        this._lb_random_name.on(Laya.Event.CHANGE, this, () => //不用手动解绑，引擎在空间销毁的时候会自动解绑所有事件
        {
            change_name_time++
            if (change_name_time > 1) {
                this.login_model.create_role_change_name = 1
            }
        })

    }
    public EnterFun = () => {
        let success_fun = () => {
            if (this.last_click_time == 0 || TimeUtil.getClientTime() - this.last_click_time > this.wait_click_time) {
                this.platform_mgr.DataPlacement(290007) //点击进入游戏（创角）
                if (this.use_delete_method)
                    return
                let name: string = this._lb_random_name.text.trim()
                if (!name) {
                    Message.show("请输入昵称")
                    return
                }
                let language_cfg = this.res_mgr.GetGameConfigFromCache(this, this.language_cfg, true)
                let filter_callback = (is_filter) => {
                    if (is_filter) {
                        Message.show("内容有敏感词")
                        return
                    }
                    let career_data = this.ui_cfg[this.now_index]
                    if (name && career_data) {
                        let len = 0
                        for (let i = 0; i < name.length; i++) {
                            var c = name.charCodeAt(i)
                            //单字节加1   
                            if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
                                len++
                            }
                            else {
                                len += 2
                            }
                        }
                        if (len < 4 || len > 12) {
                            Message.show("角色名称长度为4～12个字符 ")
                            return
                        }
                        this.login_mgr.Fire(LoginStateEvent.TRY_CREATE_ROLE, name, career_data.career, career_data.sex)
                        this.platform_mgr.LoginBuryingPoint(2, 4)
                    }
                    this.last_click_time = TimeUtil.getClientTime()
                }
                Util.HasFilterWord(name, language_cfg, filter_callback, 1)
            }
        }
        let cur_server_id = this.login_mgr.GetCurServerId()
        if (ClientConfig.account_server && cur_server_id) {
            this.server_model.CheckServerState(cur_server_id, success_fun)
        }
        else {
            success_fun()
        }
    }

    public UpdateView = () => {
        let ui_cfg = this.ui_cfg
        if (!this.career_head_list)
            this.career_head_list = []

        let data, item
        for (let key in ui_cfg) {
            data = ui_cfg[key]
            item = this.career_head_list[key]
            if (!item) {
                item = new LoginCreateRoleItem(this._gp_head_con)
                item.Load()
                this.career_head_list[key] = item
                item.SetPosition(0, Number(key) * 133)
            }
            item.SetData(key, data, this.SelectCareer)
        }
    }
    public SelectCareer = (index: number, is_mannul_change = false) => {
        if (this.now_index == index)
            return
        if (is_mannul_change) {
            this.login_model.create_role_change_carrer = 1
        }
        let old_item = this.career_head_list[this.now_index]
        if (old_item) {
            old_item.SetSelectState(false)
        }
        let now_item = this.career_head_list[index]
        if (now_item) {
            now_item.SetSelectState(true)
        }
        this.now_index = index

        let data = this.ui_cfg[index]
        if (data) {
            let key = `${data.career}@${data.sex}`
            // this._img_tips.skin = GameResPath.GetIcon("login", data.img1)
            // this._img_tips2.skin = GameResPath.GetIcon("login", data.img2)
            // this._img_tips3.skin = GameResPath.GetIcon("login", data.img3)

            this.res_mgr.SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIconOtherPath("login", data.img1))
            this.res_mgr.SetOutsideImageSprite(this, this._img_tips2, GameResPath.GetIconOtherPath("login", data.img2))
            this.res_mgr.SetOutsideImageSprite(this, this._img_tips3, GameResPath.GetIconOtherPath("login", data.img3))


            let effect = this.create_cfg.Effect[key]
            if (effect) {

            }

            let action_name_list = ["create3"]
            let res = this.create_cfg.Res[key]
            if (res) {

                let sound = data.sound
                let bone_effect = {
                    "clothe": {
                        root: {
                            name: `cj_1${data.career}00`,
                            type: EffectResType.Skill
                        }
                    }
                }

                let pos = { x: this.create_cfg.ModelPos.x, y: this.create_cfg.ModelPos.y }
                let offset = this.create_cfg.PosOffset[key]
                if (offset) {
                    pos.x += offset.x
                    pos.y += offset.y
                }

                let ref_info

                if (this.sound_channel) {
                    this.sound_channel.stop()
                    this.sound_channel = undefined
                }
                let load_call_back = () => {
                    if (ref_info) {
                        let role_model = ref_info[GetTargetHashcode(this._gp_model_con)]
                        if (role_model) {
                            role_model.ClearActionTimerList()
                            role_model.PlayActions(["create2", "create3"])
                            role_model.PlayBoneparticle()
                            if (sound) {
                                this.sound_channel = SoundManager.GetInstance().PlaySoundEffect(sound);
                            }
                        }
                    }
                }

                let show_model_data = {
                    type: UI_MODEL_TYPE.ROLE,
                    career: data.career,
                    sex: data.sex,
                    clothe_res_id: res.role_res,
                    weapon_res_id: res.weapon_res,
                    wing_id: res.wing_res,
                    head_wear_id: res.head_res,
                    scale: 0.5,
                    action_name_list: action_name_list,
                    position: pos,
                    bone_effect: bone_effect,
                    load_call_back: load_call_back,
                    layout_file: "LoginCreateRoleView",
                    enableHDR: true,
                    loadAniByCfg: true
                }
                ref_info = this.res_mgr.SetRoleModel(this, this._gp_model_con, show_model_data)
            }
            else {
                this.res_mgr.ClearRoleMode(this.hashCode)
            }
        }
    }
    public StartRandomName = () => {
        if (this.start_random_name) {
            return
        }
        this.start_random_name = true
        this.random_name_index = 0
        this.RandomName()
    }
    public EndRandomName = () => {
        this.start_random_name = false
        if (this.random_name != "") {
            this._lb_random_name.text = this.random_name
            this.random_name = ""
        }
        this.ClearCheckTimer()
    }
    public GetRandomName = () => {
        let name_cfg
        if (PlatformManager.IsEyouEnPlatform()) {
            name_cfg = this.preload_client_config.ConfigRandomNameEyouEn
        } else if (PlatformManager.IsEyouThPlatform()) {
            name_cfg = this.preload_client_config.ConfigRandomNameEyouTh
        }
        else {
            name_cfg = this.preload_client_config.ConfigRandomName
        }
        if (!name_cfg)
            return "程运生"
        let nick_name: string
        let surname: string = name_cfg["surname"]
        nick_name = surname[Math.floor(surname.length * Math.random())]

        let data = this.ui_cfg[this.now_index]
        if (data) {
            //泰语名字不区分男女
            if (PlatformManager.IsEyouThPlatform()) {
                let thai_name: string = name_cfg["thai_name"]
                nick_name = nick_name + thai_name[Math.floor(thai_name.length * Math.random())]
                return nick_name
            }

            if (data.sex == 1) {
                let forename_man: string = name_cfg["forename_man"]
                nick_name = nick_name + forename_man[Math.floor(forename_man.length * Math.random())]
            }
            else if (data.sex == 2) {
                let forename_woman: string = name_cfg["forename_woman"]
                nick_name = nick_name + forename_woman[Math.floor(forename_woman.length * Math.random())]
            }
        }
        return nick_name
    }

    public RandomName = () => {
        if (this.random_name_index >= this.max_random_count) {
            this.EndRandomName()
            return
        }
        this.random_name_index++
        this.random_name = this.GetRandomName()
        console.log("------RandomName------", this.random_name, this.random_name_index)
        if ((Util.IsWXGame() || Util.IsQQGame() || Util.IsKSGame()) && window[PlatformManager.GetInstance().sdk_name]) {
            this.CheckNameState(this.random_name)
        }
        else {
            this.login_mgr.Fire(LoginStateEvent.VERIFY_NAME, this.random_name)
            this.CheckErrorTimer()
        }
    }

    public CheckNameState = (name) => {
        let call_back = (result, content) => {
            if (this.use_delete_method) {
                return
            }
            if (result) {
                this.EndRandomName()
            }
            else {
                this.RandomName()
            }
        }
        let language_cfg = this.res_mgr.GetGameConfigFromCache(this, this.language_cfg, true)
        let filter_callback = (is_filter) => {
            if (is_filter) {
                // Message.show("内容有敏感词")
                call_back(false, name)
                return
            }
            let len = 0
            for (let i = 0; i < name.length; i++) {
                var c = name.charCodeAt(i)
                //单字节加1   
                if ((c >= 0x0001 && c <= 0x007e) || (0xff60 <= c && c <= 0xff9f)) {
                    len++
                }
                else {
                    len += 2
                }
            }
            if (len < 4 || len > 12) {
                // Message.show("角色名称长度为4～12个字符 ")
                call_back(false, name)
                return
            }
            call_back(true, name)
        }
        Util.HasFilterWord(name, language_cfg, filter_callback, 1)
    }

    public GetRandomIndex() {
        let totoal_weight = 0
        let list = []
        let vo
        for (let index in this.ui_cfg) {
            vo = this.ui_cfg[index]
            if (vo.open_state) {
                list.push({
                    index: index,
                    start_value: totoal_weight,
                    end_value: totoal_weight + vo.random_weight,
                })
                totoal_weight += vo.random_weight
            }
        }

        let value = Math.random() * totoal_weight
        for (let vo of list) {
            if (vo.start_value <= value && vo.end_value > value)
                return vo.index
        }
        // return 0
    }

    check_error_timer_id
    public CheckErrorTimer() {
        this.ClearCheckTimer()
        this.check_error_timer_id = setTimeout(() => {
            this.start_random_name = false
            this.StartRandomName()
        }, 10 * 1000);
    }

    public ClearCheckTimer() {
        if (this.check_error_timer_id) {
            clearTimeout(this.check_error_timer_id)
            this.check_error_timer_id = undefined
        }
    }

    /**预加载创角视频资源 
     * 
     * video好像不支持视频预加载
    */
    public PreLoadVideoRes() {
        if (!ClientConfig || !ClientConfig["is_open_video"]) {
            return
        }
        if (!this.login_mgr.is_wait_video) return
        let rescores = []
        table.insert(rescores, LoginManager.GetInstance().GetVideoUrl())
        if (rescores && rescores.length > 0) {
            Laya.loader.create(rescores)
        }
    }


    _gp_model_con: Laya.Box
    _gp_head_con: Laya.Box
    _img_bg: Laya.Image
    _img_random: Laya.Image
    _img_return: Laya.Image
    _img_tips: Laya.Image
    _img_tips2: Laya.Image
    _img_tips3: Laya.Image
    _img_enter: Laya.Image
    _img_16: Laya.Image
    _lb_random_name: Laya.TextInput
    public GetComponents() {
        [
            this._gp_model_con,
            this._gp_head_con,
            this._img_bg,
            this._img_random,
            this._img_return,
            this._img_tips,
            this._img_tips2,
            this._img_tips3,
            this._img_enter,
            this._img_16,
            this._lb_random_name,
        ]
            = this.GetChildrenByNames([

                "_gp_model_con",
                "_gp_head_con",
                "_img_bg",
                "_img_random",
                "_img_return",
                "_img_tips",
                "_img_tips2",
                "_img_tips3",
                "_img_enter",
                "_img_16",
                "_lb_random_name",
            ])
    }
}
window["LoginCreateRoleView"] = LoginCreateRoleView