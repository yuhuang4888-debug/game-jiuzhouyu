import { EventDispatcher } from "../util/EventDispatcher"
import { CookieWrapper } from "../common/CookieWrapper"
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar"
import { EventName, LoginStateEvent } from "../common/EventName"
import { PlatformManager } from "../PlatformManager"
import { GlobalTimerQuest, Util } from "../util/Util"
import { LayerManager } from "../common/LayerManager"
import { HttpUtil } from "../util/HttpUtil"
import { LoginManager } from "./LoginManager"
import { ResVersionManager } from "../ResVersionManager"
import { TimeUtil } from "../util/TimeUtil"
import { table } from "../common/table"
import { md5 } from "../util/md5"
// console.warn("LoginModel")
export class LoginModel extends EventDispatcher {
    static Instance: LoginModel
    //loading锁住状态，用来在loading界面打开的过程中加载需要的资源，
    static LoadingLockFlag = {
        StoryAnimation: 0x001,
        All: 0
    }
    static ConfigDebugIpList
    static LoginKey = "#LMfJyNQUKhLVLmpJ%WBo4@k^VdTEB5m"
    static TestServerShowTime = 20 * 60

    static ViewTweenData = {
        BgInTime: 700,
        BgInStartScale: 1.05,

        SelectBtnInTime: 500,
        SelectBtnStartPos: 50,
        SelectBtnStartAlpha: 0,

        CreateDownInTime: 500,
        CreateDownStartPos: 70,
        CreateDownStartAlpha: 0,

        CreateRightInTime: 400,
        CreateRightStartPos: 50,
        CreateRightStartAlpha: 0,

        TabInTimeInterval: 70,
        TabInStartPos: -50,
        TabInStartAlpha: 0,
    }

    /**
     * 玩家登录信息
     */
    player_login_info

    /**
     * 在场景中断线重连(不切场景)
     */
    reconnect_on_game //当次登录是不是重连后的登录
    /**
     * 是否返回登录
     */
    is_back_from_game = false

    /**
     * 是否不显示短线重连界面
     */
    not_show_reconnect = false

    /**
     * 异地登录 
     */
    other_place_login

    /**
     * 当前帐号
     */
    account_id: string
    /**
     * token
     */
    token: string
    /**
     * pid
     */
    pid: number = 1
    /**
     * 平台标识
     */
    plat_name: string

    /**
     * lburl
     */
    Lburl: string

    /**
     * 是否已授权
     */
    had_authorize = false

    /**
     * channel
     */
    login_channel = ""


    /**
     * 登录游戏内的角色id
     */
    login_role_id = 0

    /**
     * 在这个区是不是新角色
     */
    is_new_career = false

    /**
     * 是否正在显示加载界面
     */
    is_show_loading_view = false

    /**
     * 创角选择的职业
     */
    new_select_sex = 1

    /**
     * 创角选择的名字
     */
    new_select_name = ""


    /**
     * 请求服务器信息返回的时间戳，用于10000协议
     */
    time_stamp // 
    /**
     * 邀请者id
     */
    inviter_id = 0
    /**
     * 心跳包时间记录
     */
    revice_10006_response_time = 0
    /**
     * 切换帐号标识
     */
    wait_show_account_view = false
    /**
     * 切换角色标识
     */
    wait_request_into_role = false
    /**
     * 返回登录/返回角色 界面是否打开
     */
    wait_view_open = false
    /**
     * 10000协议信息
     */
    account_data_10000
    /**
     * 当前服注册数量信息
     */
    register_max_num_data
    /**
     * 当前服已注册帐号数量
     */
    register_max_num

    notice_cfg
    cur_plat_cfg
    // max_enter_game_loading_step = 95 + ResManager.PRELOAD_MUST_MODULE_RES.length * 2
    into_select_role_view = false
    is_pop_notice = false
    _curr_enter_game_loading_step = 1

    create_role_change_carrer = 0 //创角是否主动切换过角色
    create_role_change_name = 0//创角是否主动修改过名字

    //登录背景预加载
    _preload_bg_id = 0
    is_preload = false
    PreLoadBg


    PreLoadGameRes
    SetRegisterAccount
    GetRegisterAccount
    SetAccountHistoryListCookies
    GetCurPlatConfig
    SetLockFlag
    HasLockFlag
    GetNoticeContent
    GetInviteRoleId
    // GetNoticeStateByKey
    CheckNewNotice
    CheckNoticePopCond
    CheckDayFristLogin
    CheckNoticeCond

    OpenWXCustomerService
    CheckNoticeState
    GetNoticePath
    GetQuestionPath
    CreateWXAuthorizeBtn
    DeleteWXAuthorizeBtn
    GetPrivacCfg
    CheckPrivacState
    RefreshPrivacViewState
    GetTestServerData
    SetTestServerData
    StartTestServerTimer
    CancelTestServerTimer
    SaveInsideNoticeRed
    IsGameOutState
    ResetGameOutState
    public constructor() {
        super()
        let local_LoginModel = LoginModel,
            local_CookieWrapper_Instance = CookieWrapper.GetInstance(),
            local_CookieWrapper = CookieWrapper,
            local_GlobalEventSystem = GlobalEventSystem,
            local_LoginStateEvent = LoginStateEvent,
            register_account_,
            register_password_,
            register_token_,
            loading_lock_flag_ = 0,
            is_first_enter_game_ = true,
            first_enter_game_promise_,
            first_enter_game_resolve_,
            platform_mgr = PlatformManager.GetInstance(),
            local_Util = Util,
            layer_mgr = LayerManager.GetInstance(),
            wx_btn_,
            test_server_data_,
            test_server_time_id_,
            test_server_time_func_
        // first_enter_game_promise_ = new Promise<any>((resolve, reject) => {
        //     first_enter_game_resolve_ = resolve
        // })
        local_LoginModel.LoadingLockFlag.All = local_LoginModel.LoadingLockFlag.StoryAnimation
        this.PreLoadGameRes = async () => {
            // if (is_first_enter_game_) {
            //     is_first_enter_game_ = false
            //     let theme_promise
            //     if (!Util.IsDebug()) {
            //         theme_promise = new Promise<void>((resolve, reject) => {
            //             //加载皮肤主题配置文件,可以手动修改这个文件。替换默认皮肤。
            //             let theme = new eui.Theme("gameEui", LayerManager.GetInstance().stage)
            //             theme.addEventListener(eui.UIEvent.COMPLETE, () => {
            //                 resolve()
            //             }, this)
            //         })
            //     }
            //     else {
            //         theme_promise = true
            //     }
            //     await theme_promise
            //     this.curr_enter_game_loading_step += 20
            //     // GameError.GetInstance().SendErrorToPHP("------ new modulesController------" + TimeUtil.getClientTime(), true)
            //     first_enter_game_resolve_()
            // }
        }
        this.SetRegisterAccount = (account, password, token) => {
            register_account_ = account
            register_password_ = password
            register_token_ = token
        }
        this.GetRegisterAccount = () => {
            return [register_account_, register_password_, register_token_]
        }
        this.SetAccountHistoryListCookies = (account, password) => {
            if (!local_CookieWrapper_Instance) {
                return
            }
            let history_list = []
            let history = local_CookieWrapper_Instance.GetCookie(local_CookieWrapper.ACCOUNT_HISTORY)
            let list = []
            let remember_pwd = local_CookieWrapper_Instance.GetCookie(local_CookieWrapper.REMEMBER_PASSWORD)
            let have_same_account = false
            if (history) {
                history_list = JSON.parse(history)
                for (let obj of history_list) {
                    if (obj.account_id == account) {
                        if (remember_pwd) {
                            obj.password = password
                        }
                        else {
                            obj.password = undefined
                        }
                        have_same_account = true
                    }
                    list.push(obj)
                }
            }
            if (have_same_account == false) {
                let obj = []
                obj["account_id"] = account
                if (remember_pwd) {
                    obj["password"] = password
                }
                list.push(obj)
            }
            let list_str = JSON.stringify(list)
            local_CookieWrapper_Instance.SaveCookie(local_CookieWrapper.ACCOUNT_HISTORY, list_str)
        }

        this.GetCurPlatConfig = (cfg) => {
            let plat_list = []
            if (cfg && cfg.belong) {
                let key_str = cfg.belong[`${ClientConfig.plat_belong}`]
                if (!key_str) return plat_list
                let key = key_str.split(",")
                if (key && key.length > 0) {
                    for (let item of key) {
                        let vo = cfg.notice[`${item}`]
                        if (!vo) continue
                        let date = new Date()
                        let time = date.getTime()
                        if (Number(vo.start_time) * 1000 <= time && Number(vo.end_time) * 1000 >= time) {
                            if (vo.source == "") {
                                plat_list.push(vo)
                            }
                            else {
                                let source_list = vo.source.split(",")
                                for (let v of source_list) {
                                    if (ClientConfig.plat_name.search(v) == 0) {
                                        plat_list.push(vo)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
            }

            return plat_list
        }
        this.GetNoticeContent = (cfg, key) => {
            if (!cfg)
                return undefined
            for (let vo of cfg.content) {
                if (vo.title == key) {
                    return vo
                }
            }
        }
        // this.GetNoticeStateByKey = (key) => {
        //     if (this.notice_cfg) {
        //         let notice_cfg_ = LoginModel.GetInstance().GetCurPlatConfig(this.notice_cfg)
        //         let content_cfg_ = LoginModel.GetInstance().GetNoticeContent(notice_cfg_, `${key}`)
        //         if (content_cfg_)
        //             return true
        //     }
        // }
        this.CheckNewNotice = () => {
            let check_notice_version = (data) => {
                let ckeck_notice_content = (data) => {
                    if (!data)
                        return
                    let cfg = data
                    // cfg = JSON.parse(data)
                    this.notice_cfg = cfg
                    this.SaveInsideNoticeRed()
                }
                if (data) {
                    let cfg_v = data//JSON.parse(data)
                    if (cfg_v) {
                        let last_version = CookieWrapper.GetInstance().GetCookie(CookieWrapper.NOTICE_VERSION, false)
                        if (!cfg_v.version || last_version != cfg_v.version || !LoginModel.GetInstance().notice_cfg) {
                            let [http_path, cfg_path] = this.GetNoticePath()
                            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.NOTICE_VERSION, String(cfg_v.version), false)
                            HttpUtil.HttpLoadJson(http_path, `${cfg_path}/login_notice.json.cfg?v=` + Math.random(), ckeck_notice_content, 10000, http_path)
                        }
                    }
                }
            }
            if (!ClientConfig.not_request_notice && !PlatformManager.GetInstance().is_alpha) {
                let [http_path, cfg_path] = this.GetNoticePath()
                HttpUtil.HttpLoadJson(http_path, `${cfg_path}/login_notice.json.cfg?v=` + Math.random(), check_notice_version, 10000, http_path)
            }
        }
        /**通知红点规则
             * 1--在首次新增公告时，增加小红点提示
             * 2--在首次新增或内容变更时，增加小红点提示
             * 3--玩家角色每次登录时，增加小红点提示
             * 4--玩家角色每天第一次登录时，增加小红点提示，第二次登录不提示（每天第一次登录玩家未点开公告消除小红点情况除外）
             * 本地缓存记录 1--有红点，2--没有红点
             */
        this.SaveInsideNoticeRed = () => {
            let notice_list = LoginModel.GetInstance().GetInsideNoticeList()
            let cookie_red = CookieWrapper.GetInstance().GetCookie(CookieWrapper.INSIDE_NOTIVE_RED) //记录所有的红点key,对照key
            if (!notice_list || notice_list.length == 0) {
                if (cookie_red) CookieWrapper.GetInstance().RemoveCookie(CookieWrapper.INSIDE_NOTIVE_RED) // 清除
                return
            }
            let all_key_str = "" //记录所有的对照key为字符串
            let now_key_list = {} //新旧对照key:red_rule对象
            for (let item of notice_list) {
                let content = item.content[0] //通过GetInsideNoticeList已经把open_inside设置为唯一一个
                let md5_key = md5.hex_md5(content.content).toLowerCase()
                let red_rule = content.red_dot_rule ? content.red_dot_rule : 0
                if (Number(content.red_dot_rule) > 0) { // 只有red_dot_rule才走规则 没有就不走
                    all_key_str += `${md5_key},`
                    now_key_list[md5_key] = red_rule
                }
            }
            if (cookie_red) { //旧的对照key
                let cookie_key_list = cookie_red.split(",")
                if (cookie_key_list && cookie_key_list.length > 0) {
                    for (let item of cookie_key_list) {
                        if (!now_key_list[item]) { //应该删除的缓存
                            CookieWrapper.GetInstance().RemoveCookie(item)
                        } else if (Number(now_key_list[item]) > 0) {  //该公告依旧存在
                            let old_value = CookieWrapper.GetInstance().GetCookie(item)
                            let is_judge_three = Number(now_key_list[item]) == 3
                            let is_jugge_four = Number(now_key_list[item]) == 4 && this.CheckDayFristLogin()
                            if (Number(old_value) == 2 && (is_judge_three || is_jugge_four)) {
                                CookieWrapper.GetInstance().SaveCookie(item, 1)
                            }
                        }
                    }
                }
                for (let item in now_key_list) { //最后过滤一边 看看是否有没有加入缓存的红点规则
                    let old_value = CookieWrapper.GetInstance().GetCookie(item)
                    if (!old_value) {
                        CookieWrapper.GetInstance().SaveCookie(item, 1)
                    }
                }
            } else { //没有对照key 清缓存或者从来没有进来过
                for (let item in now_key_list) {
                    if (Number(now_key_list[item]) > 0) {
                        CookieWrapper.GetInstance().SaveCookie(item, 1)
                    }
                }
            }
            all_key_str = all_key_str.substring(0, all_key_str.length - 1) //清掉最后一个逗号
            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.INSIDE_NOTIVE_RED, all_key_str)
            GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 417)
        }


        //设置锁住状态
        this.SetLockFlag = (flag, lock) => {
            if (!flag) {
                return
            }
            let now_flag = 0
            if (lock) {
                now_flag = loading_lock_flag_ | flag
            }
            else {
                now_flag = loading_lock_flag_ & ~flag
            }
            if (now_flag == loading_lock_flag_) {
                return
            }
            loading_lock_flag_ = now_flag
            if (!lock) {
                LoginManager.GetInstance().Fire(local_LoginStateEvent.REFRESH_LODINGVIEW_LOCK_FLAG)
            }
        }
        //是否包含指定flag
        this.HasLockFlag = (flag?) => {
            flag = flag || local_LoginModel.LoadingLockFlag.All
            return ((loading_lock_flag_ & flag) != 0)
        }
        //小程序端获取邀请者id
        this.GetInviteRoleId = () => {
            if ((Util.IsWXGame() || Util.IsQQGame()) && window["onShowMethodReturnParams"] && window["onShowMethodReturnParams"].query) { //wx.onshow()  返回的参数
                console.warn("小程序端，获取邀请者id-------------------", window["onShowMethodReturnParams"].query)
                let query_param = window["onShowMethodReturnParams"].query
                if (query_param.invite_role_id) {
                    this.inviter_id = Number(query_param.invite_role_id)
                }
            }
            return this.inviter_id
        }



        //打开微信客服
        this.OpenWXCustomerService = () => {
            // if (Util.IsWXGame()) {
            //     let sdk_name = PlatformManager.GetInstance().sdk_name
            //     if (window[sdk_name] && window[sdk_name].customerService) {
            //         window[sdk_name].customerService()
            //     }
            //     else {
            //         window["wx"].openCustomerServiceConversation()
            //     }
            // }
        }


        //公告弹出规则
        this.CheckNoticePopCond = (ckeck_notice_content?, check_notice_version?) => {
            //cfg ={
            // end_time: "1641657599"
            // new_reg: "1"
            // show_rule: "1"
            // source: "yy25dlaya_kf"
            // start_time: "0"
            // title: "谨防诈骗"
            //}

            if (!ckeck_notice_content) return false

            //判断是否是新用户
            if (LoginManager.GetInstance().IsNewPlayer()) {
                //==0不弹出
                if (ckeck_notice_content.new_reg == 0) return false
            }

            //判断时间
            if (!this.CheckNoticeCond(ckeck_notice_content)) return false

            //判断弹出规则
            let boo = false

            switch (ckeck_notice_content.show_rule) {
                case "1":
                    //根据版本号，有新的公告内容弹出
                    if (!check_notice_version) {
                        boo = false
                    } else {
                        let last_version = CookieWrapper.GetInstance().GetCookie(CookieWrapper.POP_NOTICE_VERSION, false)
                        boo = last_version != check_notice_version.version
                        CookieWrapper.GetInstance().SaveCookie(CookieWrapper.POP_NOTICE_VERSION, String(check_notice_version.version), false)
                    }
                    break
                case "2":
                    //每天第一次登录弹出公告
                    boo = this.CheckDayFristLogin()
                    break
                case "3":
                    //每次登录都弹出公告
                    boo = true
                    break
                case "4":
                    //每次登录都不弹出公告
                    boo = false
                    break
            }

            return boo
        }


        //检查公告是否在规定时间开启  false不在规定时间
        this.CheckNoticeCond = (ckeck_notice_content?) => {
            if (!ckeck_notice_content) return false
            //判断开始时间
            if (ckeck_notice_content.start_time > 0) {
                if (Number(ckeck_notice_content.start_time) > TimeUtil.getServerTime()) {
                    //还没到开启时间
                    return false
                }
            }

            //判断结束时间
            if (ckeck_notice_content.end_time > 0) {
                if (Number(ckeck_notice_content.end_time) <= TimeUtil.getServerTime()) {
                    //已过期
                    return false
                }
            }

            return true
        }


        //**
        //* 检测玩家是否是当天第一次登陆  true/当天第一次登录
        //*
        this.CheckDayFristLogin = () => {
            let boo = false
            let last_date = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LAST_LOGIN_DATE)
            let now_date = new Date()
            let date = `${now_date.getFullYear()}-${now_date.getMonth() + 1}-${now_date.getDate()}`
            if (last_date != date) {
                boo = true
            }
            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LAST_LOGIN_DATE, date)

            return boo
        }


        this.CheckNoticeState = (call_func) => {
            let check_notice_version = (data_v) => {
                let ckeck_notice_content = (data, is_cache?) => {
                    if (!data)
                        return
                    let cfg = data
                    if (!is_cache) {
                        cfg = data//JSON.parse(data)
                        this.notice_cfg = cfg
                    }
                    ResVersionManager.GetInstance().SetLastGameMainVersion()
                    // let content
                    let need_pop = false

                    if (cfg) {
                        let cfg_list = this.GetCurPlatConfig(cfg)
                        for (let i = 0; i < cfg_list.length; i++) {
                            let sfg_ = cfg_list[i]
                            // if (sfg_.end_time) {
                            //     if (Number(sfg_.end_time) > TimeUtil.getServerTime()) {
                            //         content = this.GetNoticeContent(sfg_, "open_login")
                            //     }
                            // } else {
                            //     content = this.GetNoticeContent(sfg_, "open_login")
                            // }


                            //根据公告弹出的规则 是否需要主动弹出弹窗
                            if (!this.is_pop_notice) {
                                this.is_pop_notice = this.CheckNoticePopCond(sfg_, data_v)
                            }


                            //根据公告广播规则 是否有需要展示的公告
                            if (!need_pop) {
                                need_pop = this.CheckNoticeCond(sfg_)
                            }

                        }
                    }

                    //检查是否需要弹出公告
                    if (call_func && need_pop) {
                        call_func()
                    }

                }
                if (data_v) {
                    let cfg_v = data_v//JSON.parse(data_v)
                    if (cfg_v) {
                        let last_version = CookieWrapper.GetInstance().GetCookie(CookieWrapper.NOTICE_VERSION, false)
                        if (!cfg_v.version || last_version != cfg_v.version || !this.notice_cfg) {
                            let [http_path, cfg_path] = this.GetNoticePath()
                            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.NOTICE_VERSION, String(cfg_v.version), false)
                            HttpUtil.HttpLoadJson(http_path, `${cfg_path}/login_notice.json.cfg?v=` + Math.random(), ckeck_notice_content, 10000, http_path)
                        } else {
                            ckeck_notice_content(LoginModel.GetInstance().notice_cfg, true)
                        }
                    }
                }
            }
            // let http_path = ClientConfig.plat_name == `yy_suyou` ? ClientConfig.url_account_path : ClientConfig.url_cdn_path
            // let cfg_path = ClientConfig.plat_name == `yy_suyou` ? "logs" : "login_notice/yyhx"
            if (!ClientConfig.not_request_notice && !PlatformManager.GetInstance().is_alpha) {
                let [http_path, cfg_path] = this.GetNoticePath()
                HttpUtil.HttpLoadJson(http_path, `${cfg_path}/login_notice.json.cfg.v?v=` + Math.random(), check_notice_version, 10000, http_path)
            }
        }
        //获取公告地址和文件夹结构
        this.GetNoticePath = () => {
            let http_path = ClientConfig.url_cdn_path
            let cfg_path = "login_notice/jzy"
            if (PlatformManager.IsEyouPlatform() || !LoginModel.GetInstance().plat_name) {
                http_path = ClientConfig.url_account_path
                cfg_path = "logs"
            }

            // let http_path = !LoginModel.GetInstance().plat_name ? ClientConfig.url_account_path : ClientConfig.url_cdn_path
            // let cfg_path = !LoginModel.GetInstance().plat_name ? "logs" : "login_notice/jzy"//"login_notice/yyhx"

            if (!http_path) {
                http_path = ""
            }
            if (!cfg_path) {
                cfg_path = ""
            }
            return [http_path, cfg_path]
        }

        //获取问卷调查的地址和文件夹结构
        this.GetQuestionPath = () => {
            let http_path = !LoginModel.GetInstance().plat_name ? ClientConfig.url_account_path : ClientConfig.url_cdn_path
            let cfg_path = !LoginModel.GetInstance().plat_name ? "logs" : "survey_question/jzy"//"login_notice/yyhx"

            if (!http_path) {
                http_path = ""
            }
            if (!cfg_path) {
                cfg_path = ""
            }
            return [http_path, cfg_path]
        }
        //微信授权
        this.CreateWXAuthorizeBtn = (btn_y, btn_height, call_func) => {
            let sdk_name = platform_mgr.sdk_name
            let self = this
            if ((local_Util.IsWXGame() || local_Util.IsBiliBiliGame()) && window[sdk_name] && btn_y && btn_height) {
                if (wx_btn_) {
                    wx_btn_.destroy()
                    wx_btn_ = null
                }
                let stage_width = layer_mgr.stageWidth
                let stage_height = layer_mgr.stageHeight
                let sysInfo = window["wx"].getSystemInfoSync()
                let screenW = sysInfo.screenWidth
                let screenH = sysInfo.screenHeight
                let real_y = btn_y * screenH / stage_height
                console.warn("微信授权++++++++++:", btn_y)
                // window["wx"].getSetting({
                //     success(res) {
                //         if (res.authSetting['scope.userInfo'] && !window["authorize_expired"]) { //已经授权
                //             self.had_authorize = true
                //             platform_mgr.DataPlacement(90003) //授权成功
                //         }
                //         else { //没有授权
                //             console.warn("创建授权按钮++++++++++")
                //             wx_btn_ = window["wx"].createUserInfoButton({
                //                 type: 'text',
                //                 text: ' ',
                //                 style: {
                //                     x: 0,
                //                     top: real_y,
                //                     width: screenW,
                //                     height: btn_height,
                //                     lineHeight: btn_height,
                //                     backgroundColor: "",
                //                     color: '#ffffff',
                //                     textAlign: 'center',
                //                     fontSize: 16,
                //                     borderRadius: 10
                //                 }
                //             })
                //             //监听用户信息按钮的点击事件,用户每点击一次，就会触发一次响应函数
                //             wx_btn_.onTap(function (res) {
                //                 console.warn("点击授权按钮++++++++++", res) //res 为 json 格式，用户点击"拒绝"或"允许"都会对应不同的数据
                //                 if (wx_btn_) {
                //                     wx_btn_.destroy()
                //                     wx_btn_ = null
                //                 }
                //                 self.had_authorize = res.userInfo != null
                //                 if (res.userInfo) { //用户允许授权
                //                     platform_mgr.DataPlacement(90003) //授权成功
                //                     if (window[sdk_name].unionId) {
                //                         window[sdk_name].unionId(res)
                //                     }
                //                 }
                //                 else { //用户不允许授权
                //                     platform_mgr.DataPlacement(90010) //授权失败
                //                 }
                //                 call_func()
                //             })
                //         }
                //     }
                // })
            }
        }

        this.DeleteWXAuthorizeBtn = () => {
            if (wx_btn_) {
                wx_btn_.destroy()
                wx_btn_ = null
            }
        }

        this.CheckPrivacState = (privac_cfg) => {
            let bool = false
            if (privac_cfg) {
                let plat_name: string = ClientConfig.plat_name
                if (plat_name && privac_cfg) {
                    for (let plat_tips in privac_cfg) {
                        if (plat_name.indexOf(plat_tips) != -1) {
                            bool = true
                            break
                        }
                    }
                }
            }
            return bool
        }

        this.GetPrivacCfg = (privac_cfg) => {
            let plat_name: string = ClientConfig.plat_name
            if (plat_name && privac_cfg) {
                for (let plat_tips in privac_cfg) {
                    if (plat_name.indexOf(plat_tips) != -1) {
                        return privac_cfg[plat_tips]
                    }
                }
            }
        }

        this.RefreshPrivacViewState = (privac_cfg) => {
            if (!this.CheckPrivacState(privac_cfg))
                return
            let cache_show_privac_view_data = local_CookieWrapper_Instance.GetCookie(CookieWrapper.SHOW_PRIVAC_VIEW_STATE, false), cache_list
            if (cache_show_privac_view_data) {
                cache_list = JSON.parse(cache_show_privac_view_data)
                if (cache_list.indexOf(this.account_id) != -1)
                    return
            }
            if (!cache_list) {
                cache_list = []
            }
            cache_list.push(this.account_id)
            local_CookieWrapper_Instance.SaveCookie(local_CookieWrapper.SHOW_PRIVAC_VIEW_STATE, JSON.stringify(cache_list), false)
            LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginPrivacyView")
        }

        this.GetTestServerData = () => {
            return test_server_data_
        }

        this.SetTestServerData = (name, time) => {
            if (name == "" || name == 0) {
                test_server_data_ = null
            }
            else {
                test_server_data_ = {
                    testname: name,
                    testotime: time
                }
            }
            this.CancelTestServerTimer()
            if (test_server_data_) {
                let now_time = Math.floor(new Date().getTime() / 1000)
                let targer_time = test_server_data_.testotime
                let left_time = targer_time - now_time + 1 //加2容错
                if (left_time > 1) {
                    this.StartTestServerTimer(() => {
                        LoginManager.GetInstance().RequestTestServerData()
                        let Enum_LoginState = window["Enum_LoginState"]
                        LoginManager.GetInstance().Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ServerList)
                    }, left_time)
                }
            }
            LoginManager.GetInstance().Fire(LoginStateEvent.UPDATE_TEST_SERVER_DATA)
        }

        this.StartTestServerTimer = (func, time) => {
            this.CancelTestServerTimer()
            test_server_time_func_ = func
            test_server_time_id_ = GlobalTimerQuest.AddDelayQuest(func, time * 1000)
        }

        this.CancelTestServerTimer = () => {
            if (!test_server_time_id_)
                return
            GlobalTimerQuest.CancelQuest(test_server_time_id_)
            test_server_time_id_ = null
            test_server_time_func_ = null
        }

        this.IsGameOutState = () => {
            return this.wait_show_account_view || this.wait_request_into_role || this.wait_view_open
        }

        this.ResetGameOutState = () => {
            this.wait_show_account_view = false
            this.wait_request_into_role = false
            this.wait_view_open = false
        }

        /**预加载 登录加载图背景 */
        this.PreLoadBg = () => {
            if(this.is_preload){
                return
            }
            this.is_preload = true
            this._preload_bg_id = -1
            let validata_list = []
            let platform_mgr = window["PlatformManager"].GetInstance()
            let server_time_model = window["ServerTimeModel"].GetInstance()
            if (
                Util.IsWXGame()
                || Util.IsQQGame()
                || Util.IsOPPOFastGame()
                || Util.IsVivoFastGame()
                || Util.IsUCGame()
                || Util.IsMiFastGame()
                || Util.IsBiliBiliGame()
                || Util.IsMeiZuFastGame()
                || Util.IsKSGame()
                || Util.IsMTGame()
                || Util.IsTTGame()
                || (!platform_mgr.is_alpha && !platform_mgr.need_alpha_open_charge)) {
                let cfg = window["ResManager"].GetInstance().GetGameConfigFromCache(this, "ConfigLoadingBgTime", true)
                let mainrole_level = window["RoleManager"].GetInstance().GetMainRoleVo().level
                let curr_open_server_day = server_time_model.GetOpenServerDay()
                let curr_merge_server_day = server_time_model.GetMergeServerDay()
                let curr_time = TimeUtil.getServerTime()
                let list
                let curr_week = new Date(curr_time).getDay()
                for (let id in cfg) {
                    list = cfg[id]
                    for (let vo of list) {
                        if (mainrole_level >= vo.min_level && mainrole_level <= vo.max_level
                            && curr_open_server_day >= vo.open_server_day && curr_open_server_day <= vo.end_server_day
                            && curr_merge_server_day >= vo.merge_server_start_day && curr_merge_server_day <= vo.merger_server_end_day
                            && vo.open_week.indexOf(curr_week) >= 0
                            && curr_time >= vo.custom_open_time && curr_time <= vo.custom_end_time) {
                            validata_list.push(id)
                            break
                        }
                    }
                }
            }

            this._preload_bg_id = -1
            let name_list = []
            let len = validata_list.length
            if (len > 0) {
                let id = validata_list[Util.RandomRange(0, len - 1)]
                this._preload_bg_id = id
                table.insert(name_list, `resource/game/login/texture/load_bg${id}.jpg`)
            }
            else {
                if (platform_mgr.is_alpha) {
                    this._preload_bg_id = 1
                    table.insert(name_list, `resource/game/login/texture/load_bg1.jpg`)
                }
                else {
                    if ((platform_mgr.is_alpha || platform_mgr.need_alpha_open_charge) && ClientConfig && ClientConfig.loading_bg) {
                        table.insert(name_list, `platform/res/login/${ClientConfig.loading_bg}`)
                    }
                    else {
                        table.insert(name_list, `resource/game/login/texture/load_bg0.jpg`)
                    }
                }
            }


            let res = []
            for (let i = 0; i < name_list.length; i++) {
                let is_ktx =false
                let img_url = `${window["ResManager"].GetInstance().cdn_res_path}${name_list[i]}`
                if (img_url.indexOf("/texture/") != -1) {
                    img_url = img_url.replace("texture", "other")
                } else if (img_url.indexOf('/bigBg/') != -1) {
                    is_ktx = true;
                }

                else if (img_url.indexOf('/bigBg/') != -1) {
                    is_ktx = true;
                }
    
                if (is_ktx && local_Util.use_ktx) {
                    img_url = img_url.substring(0, img_url.lastIndexOf(".")) + ".ktx"
                }

        
                table.insert(res, {
                    url:img_url,
                    type: Laya.Loader.IMAGE
                })
            }

            if (res && res.length > 0) {
                Laya.loader.load(res, Laya.Handler.create(this, () => {
                }, null, true), null, null, null, true)
            }
        }
    }

    public GetNoticeRed() {
        let cookie_red = CookieWrapper.GetInstance().GetCookie(CookieWrapper.INSIDE_NOTIVE_RED) //记录所有的红点key,对照key
        let status = false
        if (cookie_red) {
            let cookie_key_list = cookie_red.split(",")
            for (let item of cookie_key_list) {
                let old_value = CookieWrapper.GetInstance().GetCookie(item)
                if (Number(old_value) == 1) {
                    status = true
                    break
                }
            }
        }
        return status
    }

    public GetInsideNoticeList() {
        let cfg = LoginModel.GetInstance().notice_cfg
        let notice_list = []
        if (cfg && cfg.belong && cfg.belong[`${ClientConfig.plat_belong}`]) {
            let key = cfg.belong[`${ClientConfig.plat_belong}`].split(",")
            if (key && key.length > 0) {
                for (let item of key) {
                    let vo = cfg.notice[`${item}`]
                    if (!vo) continue
                    let date = new Date()
                    let time = date.getTime()
                    if (Number(vo.start_time) * 1000 <= time && Number(vo.end_time) * 1000 >= time) {
                        if (vo.source == "") {
                            notice_list.push(vo)
                        } else {
                            let source_list = vo.source.split(",")
                            for (let v of source_list) {
                                if (ClientConfig.plat_name.search(v) == 0) {
                                    notice_list.push(vo)
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
        let notice_list_copy  = Util.DeepCopy(notice_list)
        if (notice_list_copy.length > 0) {
            for (let item of notice_list_copy) {
                if (item.content && item.content.length > 0) {
                    item.content = item.content.filter(vo => {
                        return vo.title == "open_inside"
                    })
                }
            }
        }

        notice_list_copy = notice_list_copy.filter(item => {
            return item.content && item.content.length > 0
        })
        return notice_list_copy
    }

    public set curr_enter_game_loading_step(value: number) {
        this._curr_enter_game_loading_step = value
    }
    public get curr_enter_game_loading_step(): number {
        return this._curr_enter_game_loading_step
    }
    public static GetInstance() {
        if (!LoginModel.Instance) {
            LoginModel.Instance = new LoginModel()
        }
        return LoginModel.Instance
    }
}
window["LoginModel"] = LoginModel