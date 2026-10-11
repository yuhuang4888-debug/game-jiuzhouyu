// console.warn("PlatformManager@GlobalEventSystem")
import { GlobalEventSystem, ClientConfig } from "./util/DeclareGlobalVar";
import { EventName, LoginStateEvent } from "./common/EventName";
import { Util, GlobalTimerQuest, GetOption } from "./util/Util";
import { LayerManager } from "./common/LayerManager";
import { GameError } from "./util/GameError";
import { md5 } from "./util/md5";
import { HttpUtil } from "./util/HttpUtil";
import { LogManager } from "./common/LogManager";
import { Status } from "./util/Status";
import { TimeUtil } from "./util/TimeUtil";
import { Config } from "./common/Config";
import { Base64 } from "./util/Base64";
import { LoginModel } from "./login/LoginModel";
import { LoginManager } from "./login/LoginManager";
import { table } from "./common/table";
import { DailyModel } from "./commonModel/DailyModel";

import { SettingModel } from "./commonModel/SettingModel";
import { Alert, Alert_Type } from "./alert/Alert";
import { ServerModel } from "./login/ServerModel";
import { EyouManager } from "./commonController/EyouManager";
import { Message } from "./sysInfo/SysInfoController";
import { RoleManager } from "./commonModel/RoleManager";
import { ActivityIconManager } from "./commonModel/ActivityIconManager";
import { ResManager } from "./common/ResManager";
import { UserMsgAdapter } from "./common/UserMsgAdapter";
import { SpecialCharKey } from "./common/SpecialCharKey";
import { CookieWrapper } from "./common/CookieWrapper";
import { DailyEvent } from "./daily/DailyEvent";


/**
 * 平台数据接口。
 */
export class PlatformManager {
    public static Instance: PlatformManager;
    /**速游聊天类型和深海上报的聊天类型的对应关系 */
    public static SyChatType2ShChatType = {
        "1": "4",
        "2": "4",
        "3": "4",
        "4": "5",
        "5": "2",
        "6": "1",
        "7": "1",
        "8": "3"
    }

    public static GetInstance() {
        if (!PlatformManager.Instance) {
            PlatformManager.Instance = new PlatformManager();
        }
        return PlatformManager.Instance;
    }

    /**
     * 
     * @returns 
     */
    public static GetPlatformName() {
        return LoginModel.GetInstance().plat_name || ClientConfig.plat_name;
    }

    /**
     * 米趣游渠道
     * @param plat_name 
     * @returns 
     */
    public static IsMQYPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name.search("jzy_sh921_mqywd_PM003163") >= 0

    }

    /**
     * 深海平台
     * @param plat_name 
     * @returns 
     */
    public static IsShenhaiPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name.search("jzy_sh921") == 0;
    }


    /**
     * 深海平台 肆狼渠道
     * @param plat_name 
     * @returns 
     */
    public static IsSiLangPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name.search("jzy_sh921_sl") == 0;
    }

    /**
     * Eyou平台
     * @param plat_name 
     * @returns 
     */
    public static IsEyouPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && plat_name.indexOf("jzy_eyou") >= 0
    }

    /**
     * Eyou平台(繁体)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouTwPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_tw") >= 0);
    }

    /**
     * Eyou平台(英文)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouEnPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_en") >= 0);
    }

    /**
     * Eyou平台(印尼)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouIdnPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_id") >= 0);
    }

    /**
     * Eyou平台(泰文)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouThPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_th") >= 0);
    }

    /**
     * Eyou平台(中东)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouArPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_me") >= 0);
    }

    /**
     * Eyou平台(日文)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouJpPlatform(plat_name?: string): boolean {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_jp") >= 0);
    }

    /**
     * Eyou平台(韩文)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouKrPlatform(plat_name?: string) {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_kr") >= 0);
    }

    /**
     * Eyou平台(越南)
     * @param plat_name 
     * @returns 
     */
    public static IsEyouVnPlatform(plat_name?: string) {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name && (plat_name.indexOf("jzy_eyou") >= 0 && plat_name.indexOf("_vn") >= 0);
    }

    /**
     * 4399平台
     * @param plat_name 
     * @returns 
     */
    public static Is4399Platform(plat_name?: string) {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name.search("jzy_sh921_ssjj_") == 0;
    }

    /**
     * 深海爱疯混服平台
     * @param plat_name 
     * @returns 
     */
    public static IsAiFengGamePlatform(plat_name?: string) {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name.search("jzy_sh921_aifeng") != -1
    }

    /**
     * 是否是小程序混服链接端
     * @returns 
     */
    public static IsWXGameLink() {
        return ClientConfig && ClientConfig.is_wx_game_link;
    }

    /**
     * 是否是H5大混服
     * @returns 
     */
    public static IsBigMixedServer() {
        return ClientConfig && ClientConfig.is_big_mixed_server;
    }

    /**
     * 
     * @returns 
     */
    public static IsAbroadPlatform() {
        return false
    }

    /**
     * 多游转服
     * @param plat_name 
     * @returns 
     */
    public static IsDuoYouPlatform(plat_name?: string) {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return plat_name.search("jzy_sh921_duoyou") > -1
    }

    /**
     * 深海上报时需要发送初始服务器id的平台
     * @param plat_name 
     * @returns 
     */
    public static NeedBaseServerIdPlatform(plat_name?) {
        plat_name = plat_name || PlatformManager.GetPlatformName();
        return PlatformManager.IsShenhaiPlatform(plat_name) && plat_name.search("PM002944") > -1
    }

    /**
     * true审核状态，false：正式状态, 无内购状态
     */
    private _is_alpha = false

    /**
     * sdk名字
     */
    sdk_name = "";
    /**
     * 链接是否检测敏感词
     */
    link_is_check_word = false;
    /**
     * 是否上报聊天内容
     */
    is_report_chat = false;//
    /**
     * 是否有百度版本标识
     */
    is_baidu_version = false//
    /**
     * 是否微信审核状态 包含原生ios包审核状态 
     */
    is_wx_alpha = false;
    /**
     * 审核状态。但不屏蔽内容
     */
    need_alpha_plat_belong = false;
    /**
     * 审核，有内购状态
     */
    need_alpha_open_charge = false;
    /**
     * IMEI/IDFA
     */
    gdevice = "";
    /**
     * 调用sdk login后的回调，还没开始验证
     */
    login_callback;
    /**
     * sdk登录成功回调 验证成功后的回调
     */
    login_request_call_back;
    get_server_info_token = 0;
    /**
     * 特殊活动的cid，小程序链接端链接里有cid参数，小程序端没有cid
     */
    activity_cid = 0;
    /**
     * sdk初始化一次
     */
    is_init = false;
    /**
     * sdk的login方法是否已经回调回来
     */
    sdk_login_had_callback;
    /**
     * sdk的login方法回调的数据
     */
    sdk_login_data
    /**
     * 原生包回调对应表
     */
    native_callback_list = {};
    /**
     * sdk内部实名系统参数，如果游戏内实名奖励界面需要受sdk控制，可以在sm为false的时候隐藏功能界面
     */
    realname_sm = false;
    /**
     * 是否展示svip图标(爱微游专服必接)  1开启 0关闭
     */
    iwy_svip_data;
    /**
     * 原生包代理
     */
    native_bridge

    public constructor() {
        if (window["ShSdk"]) {
            this.sdk_name = "ShSdk"
        }

        if (Util.IsConch()) {
            var os = window["conchConfig"].getOS();
            if (os == "Conch-ios") {
                this.native_bridge = window["PlatformClass"].createClass("JSBridge");//创建脚步代理
            }
            else if (os == "Conch-android") {
                //需要完整的类路径，注意与iOS的不同
                this.native_bridge = window["PlatformClass"].createClass("demo.JSBridge");//创建脚步代理
            }
        }
        this.CallNativeFunction("test", { "test": 1 })
    }


    public set is_alpha(value: boolean) {
        let old_value = this._is_alpha;
        this._is_alpha = value;
        if (old_value != value) {
            GlobalEventSystem.Fire(EventName.ALPHA_STATE_CHANGE);
        }
    }

    /**
     * 审核状态
     * ignore_sdk_alpha, 表示在this.is_wx_alpha为true的状态下是否忽视this._is_alpha 状态
     * ignore_cfg_alpha 忽视this.is_wx_alpha 状态
     */
    public get is_alpha(): boolean {
        if (this.is_wx_alpha) {
            if (window["recharge_state"]) {
                return this._is_alpha;
            }
            if (ClientConfig.ignore_cfg_alpha) {
                if (ClientConfig.ignore_sdk_alpha) {
                    return false;
                }
            }
            else {
                return true;
            }
        }
        if (Util.IsMTGame()) { //美团需特别美团app的版本号
            console.warn("platformManager IsMTGame  is_alpha--method---");
            if (!Util.MTSupportRecharge()) {
                console.warn("platformManager IsMTGame  not suppport--");
                return true;
            }
            console.warn("platformManager IsMTGame  is_alpha --method--22-:", this._is_alpha);
        }
        return this._is_alpha;
    }

    /**
     * 打点
     * @param action 
     */
    public DataPlacement(action) {
        let sdk = window[this.sdk_name];
        if (sdk && sdk.dataPlacement) {
            sdk.dataPlacement({ action: action });
        }
    }


    /**
     * 等待sdk登录成功回调的登录
     * @returns 
     */
    public LoginBySdkCallbak = () => {
        let login_callback = (login_data) => {
            this.sdk_login_had_callback = true;
            this.ShowTestInfo(this.sdk_name + ".login回调成功");
            this.sdk_login_data = login_data
            console.warn("login_callback1--------------------------------", login_data);
            if (login_data) {
                if (typeof login_data == "string") {
                    try {
                        login_data = JSON.parse(login_data);
                    }
                    catch (e) {
                        this.ShowTestInfo(this.sdk_name + ".login回调参数不是json格式 =" + login_data);
                    }
                }
                this.ShowTestInfo(this.sdk_name + ".login回调参数=" + JSON.stringify(login_data));

                //eyou链接端获取地区
                if (PlatformManager.IsEyouPlatform() && ServerModel.GetInstance().IsLocationMode() && !Util.IsConch()) {
                    console.log("---------------call@GetContinentId1")
                    if (window[this.sdk_name]) {
                        window[this.sdk_name]["call"]('GetContinentId', id => {
                            if (id) {
                                console.log("---------------call@GetContinentId2:" + id)
                                ServerModel.GetInstance().base_location = id;
                            }
                        });
                    }
                }

                let retry_times = 0;
                let check_complete = false;
                let check_login_function = () => {
                    retry_times++;
                    let call_func = (validate_data) => {
                        if (validate_data) {
                            if (typeof validate_data == "string") {
                                validate_data = JSON.parse(validate_data);
                            }
                            this.get_server_info_token = validate_data.token;
                        }
                        this.ShowTestInfo("请求check_login回调成功=");
                        if (validate_data) {
                            this.ShowTestInfo("请求check_login回调参数=" + JSON.stringify(validate_data));
                        }
                        if (validate_data && validate_data.ret == 0 && validate_data.uid) {
                            if (check_complete == false) {
                                check_complete = true;
                                this.DataPlacement(30001);
                                this.DataPlacement(40000);
                                if (this.login_request_call_back) {
                                    this.ShowTestInfo("login_request_call_back uid=" + validate_data.uid);
                                    this.login_request_call_back(+validate_data.uid, validate_data.token);
                                }
                            }
                        }
                        else {
                            if (retry_times >= 3) {
                                GameError.GetInstance().SendErrorToPHP("连续3次登陆验证失败");
                                let ok = () => {
                                    GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT);
                                };
                                let Alert = window["Alert"]
                                let Alert_Type = window["Alert_Type"]
                                Alert.Show("登陆验证失败，请退出游戏再次进入", Alert_Type.One, ok, null, "确定");
                            }
                            else {
                                check_login_function();
                            }
                        }
                        console.warn("httppost call fun ,validate_data =", validate_data);
                    };

                    let ticket = ClientConfig.login_key,
                        now_method = "check_login_" + LoginModel.GetInstance().plat_name,
                        cur_time = String(Math.floor(new Date().getTime() / 1000)),
                        sign = md5.hex_md5(String(ticket + cur_time + now_method)).toLowerCase(),
                        params;

                    if (Util.IsConch()) {
                        params = {
                            time: cur_time,
                            method: now_method,
                            sign: sign,
                            paramstr: encodeURIComponent(JSON.stringify({ uid: login_data.uid, token: login_data.token }))
                        }
                        HttpUtil.HttpGetRequest(ClientConfig.login_php, params, call_func, 10);
                    } else {
                        if (PlatformManager.IsShenhaiPlatform()) {
                            params = JSON.stringify({ token: login_data.tokenid });
                        }
                        else if (PlatformManager.IsEyouPlatform()) {
                            params = JSON.stringify({ uid: login_data.user_id });
                        }
                        console.warn("HttpPostRequest----------------:", params);
                        if (!params) return
                        HttpUtil.HttpPostRequest(ClientConfig.login_php + `?time=${cur_time}&method=${now_method}&sign=${sign}`, params, call_func);
                    }

                    this.ShowTestInfo("请求check_login url=" + ClientConfig.login_php + `?time=${cur_time}&method=${now_method}&sign=${sign}` + "参数=" + params);
                };
                check_login_function();
            }
            else {
                GameError.GetInstance().SendErrorToPHP(this.sdk_name + ".login回调成功 但是参数为空 重新刷新游戏！！！！！！！！！");
                if (window && window.location) {
                    window.location.reload();
                }
            }
        };

        this.login_callback = login_callback
        this.sdk_login_had_callback = false;

        if (PlatformManager.IsShenhaiPlatform()) {
            this.sdk_name = "ShSdk";
            //深海小程序
            if (Util.IsMiniGame()) {
                this.ShowTestInfo("IsMiniGame login= " + !!window[this.sdk_name]);
                let fail_call_back = (ret) => {
                    this.ShowTestInfo("IsMiniGame fail_call_back = " + ret);
                    new window["Meizu"].MzGame().onGameExit();
                };
                let fail_call_back_hw = (ret) => {
                    console.warn("fail-----------------ret----------:", ret);
                    this.ShowTestInfo("IsMiniGame fail_call_back_hw = " + ret);
                    if (ret) {
                        if (typeof ret == "string") {
                            ret = JSON.parse(ret);
                        }
                        if (ret.status == -1) {
                            this.LoginBySdkCallbak();
                        }
                    }
                };
                if (window[this.sdk_name]) {
                    this.DataPlacement(30000);
                    if (Util.IsMeiZuFastGame()) {
                        this.ShowTestInfo("IsMiniGame 调用魅族sdk login+++++++++++ ");
                        window[this.sdk_name].login(login_callback, fail_call_back);
                    }
                    else if (Util.IsHuaweiFastGame()) {
                        this.ShowTestInfo("IsMiniGame 调用华为sdk login+++++++++++ ");
                        window[this.sdk_name].login(login_callback, fail_call_back_hw);
                    }
                    else {
                        this.ShowTestInfo("IsMiniGame 调用通用sdk login+++++++++++ ");
                        window[this.sdk_name].login(login_callback);
                    }
                }
                 
            } else if (Util.IsConch()) {
                // 深海原生包
                // 将 SDK 实例赋给全局变量 ta，或者其他您指定的变量
                window['thinkingdata'] = window['thinkingdata'];
                if (window['thinkingdata']) {
                    var config = {
                        appId: '5a4e187bdea6470381baff4d5e3d6cee',
                        serverUrl: `https:${SpecialCharKey.PlatformManager1}ta.sydevlop.cn/`
                    };
                    console.log("原生包数数库加载正常,开始init接口")
                    // 用配置对象初始化 SDK
                    window['thinkingdata'].init(config);
                } else {
                    console.log("原生包数数库加载失败!!!!!!!!!!!!!!")
                }
                this.CallNativeFunction("login", {});
                return;
            } else {
                // 深海链接
                let url = `https:${SpecialCharKey.PlatformManager1}jiekou.diaigame.com/html/h5/client.js`;
                if (url) {
                    let has_callback = false;
                    this.ShowTestInfo("loadSDKScript = " + HttpUtil.ParseHttpType(url));
                    let load_sdk_timer_id;
                    let loadSDKScript = (url) => {
                        Util.LoadScript(HttpUtil.ParseHttpType(url), () => {
                            if (load_sdk_timer_id) {
                                GlobalTimerQuest.CancelQuest(load_sdk_timer_id);
                                load_sdk_timer_id = null;
                            }
                            let str = has_callback ? "has_callback=true" : "has_callback=false";
                            if (window[this.sdk_name]) {
                                str += "   window[this.sdk_name] = true";
                            }
                            else {
                                str += "   window[this.sdk_name] = false";
                            }
                            this.ShowTestInfo("loadSDKScript 下载成功 " + this.sdk_name + "    " + str);
                            if (has_callback == false) {
                                has_callback = true;
                                if (window[this.sdk_name]) {
                                    console.warn("开始调用sdk的login方法--------------------");
                                    this.ShowTestInfo("调用" + this.sdk_name + ".login");
                                    if (window[this.sdk_name].loginRd) {
                                        window[this.sdk_name].loginRd(login_callback);
                                    }
                                    else {
                                        window[this.sdk_name].login(login_callback);
                                    }
                                }
                                else {
                                    GameError.GetInstance().SendErrorToPHP("loadSDKScript 下载成功 但是window." + this.sdk_name + "== null  重新刷新游戏");
                                    window.location.reload();
                                }
                            }
                        });
                    };
                    load_sdk_timer_id = GlobalTimerQuest.AddDelayQuest(() => {
                        GameError.GetInstance().SendErrorToPHP("loadSDKScript 超时 重新刷新游戏 ");
                        load_sdk_timer_id = null;
                        window.location.reload();
                    }, 5000);
                    loadSDKScript(url);
                }
            }
        } else if (PlatformManager.IsEyouPlatform()) {
            if (Util.IsConch()) {
                //eyou原生包
                if (window['thinkingdata']) {
                    var config = {
                        appId: '5a4e187bdea6470381baff4d5e3d6cee',
                        serverUrl: `https:${SpecialCharKey.PlatformManager1}ta.sydevlop.cn/`
                    };
                    console.log("原生包数数库加载正常,开始init接口")
                    // 用配置对象初始化 SDK
                    window['thinkingdata'].init(config);
                } else {
                    console.log("原生包数数库加载失败!!!!!!!!!!!!!!")
                }
                this.CallNativeFunction("login", {});
            }
            else {
                this.sdk_name = "EyouSDK";
                let url = `https:${SpecialCharKey.PlatformManager1}eyouh5.com/sdk.js/`

                let init_eyousdk = function (w, d, e, n, u) {
                    if (w[e]) return; w[e] = { queue: [], call: function () { w[e].queue.push(arguments) } };
                    let t = d.createElement(n); t.async = !0; t.src = u; d.getElementsByTagName('head')[0].appendChild(t);
                    t.addEventListener('load', function () {
                        w["EyouSDK"]["call"]('GetInfo', (data) => {
                            console.log(data);
                            login_callback(data)
                        });
                    }, false);
                }
                init_eyousdk(window, document, 'EyouSDK', 'script', url);
            }
        }
    };

    public CallNativeFunction = (func_name: string, params: any = {}, call_back: Function = null) => {
        if (call_back) {
            this.native_callback_list[func_name] = call_back;
        }
        params.type = func_name;
        params = JSON.stringify(params);
        // egret.ExternalInterface.call("sendToNative", params);
        if (this.native_bridge) {
            console.warn("---------------sendToNative-------------" + params);
            // alert(bridge.call("testString:","hello"));
            // alert(bridge.call("testNumber:",256.0));
            // alert(bridge.call("testBool:",false));
            // obj.value = "Hello OC!";
            var os = window["conchConfig"].getOS();
            if (os == "Conch-ios") {
                this.native_bridge.callWithBack((value) => {
                    // var obj = JSON.parse(value)
                    // // alert(obj.value);
                    // console.warn("---------------CallBackToJS-------------"+ value);
                    this.SendToJsFormNative(value)
                }, "testAsyncCallback:", params);
            }
            else if (os == "Conch-android") {
                this.native_bridge.callWithBack((value) => {
                    // var obj = JSON.parse(value)
                    // alert(obj.value);
                    // console.warn("---------------CallBackToJS-------------"+ value);
                    this.SendToJsFormNative(value)
                }, "testAsyncCallback", params);
            }
        }

    };

    public SendToJsFormNative = (msg) => {
        console.warn("---------------CallBackToJS-------------" + msg);
        if (msg) {
            try {
                let obj = JSON.parse(msg);
                if (obj && obj.type) {
                    let call_back = this.native_callback_list[obj.type];
                    if (call_back) {
                        call_back(obj);
                    }
                    if (obj.type == "login") {
                        if (obj.channel && String(obj.channel).trim() !== "") {
                            LoginModel.GetInstance().login_channel = obj.channel;
                        }
                        if (this.login_callback) {
                            this.login_callback(obj.paramstr)
                        }

                        if (obj.location) {
                            console.log("---------------login@location:" + obj.location)
                            ServerModel.GetInstance().base_location = obj.location;
                        }
                    }
                    else if (obj.type == "loginOut") { //登出
                        GlobalEventSystem.Fire(EventName.SWTICH_SERVER_ID);
                    }
                    else if (obj.type == "exitGame") {
                        this.AndroidBackBtnListener();
                    }
                    else if (obj.type == "sku_return") {
                        let Message = window["Message"]
                        Message.show("sku_return");
                    }
                    else if (obj.type == "sku_return2") {
                        let Message = window["Message"]
                        Message.show("sku_return2222");
                    }
                    else if (obj.type == "exitGameConfirm") {
                        // this.AlertQuitGame();
                    }
                }
            }
            catch (e) {
                let str = "sendtojs content is not json object.  msg=" + msg;
                console.warn("---------sendToJS params error-------------", str);
                GameError.GetInstance().SendErrorToPHP(str);
            }
        }
    };
    public ShowTestInfo(str) {
        if (ClientConfig && ClientConfig.show_login_info) {
            if (LoginModel.GetInstance().plat_name == ClientConfig.PlatName) {
                let na = LoginModel.GetInstance().plat_name;
                if (navigator && navigator.userAgent) {
                    na = "_" + navigator.userAgent.toLowerCase();
                }
                GameError.GetInstance().SendErrorToPHP(na + " *************************ShowTestInfo " + str);
            }
        }
    }

    /**
     * http请求验证的sdk登录
     */
    public LoginByHttpValidate = () => {
        let uid = GetOption("uid");
        let login_time = GetOption("login_time");
        let token = GetOption("token");
        // LoginModel.GetInstance().plat_name = GetOption("gsource")
        let gtype = GetOption("gtype"); //gtype=1：地址       gypte=0|或者不存在：回调
        let galpha = GetOption("galpha");
        this.gdevice = GetOption("gdevice");
        this.link_is_check_word = GetOption("is_check_word") == "1";
        this.is_report_chat = GetOption("is_report_chat") == "1";
        this.is_baidu_version = GetOption("baidu_version") == "1"
        this.ShowTestInfo("LoginByHttpValidate+++++000+++++");
        if (!uid && !login_time && !token && !LoginModel.GetInstance().plat_name && !gtype && !galpha && !this.gdevice) {
            //ClientConfig.sdk_server = 0
            // this.resolve_callback()
            // return
        }
        else {
            //ClientConfig.sdk_server = 1
            console.warn("uid--------------------------------" + "_" + uid + "_" + gtype + "_" + token + "_" + LoginModel.GetInstance().plat_name + "_" + this.is_alpha);
            this.ShowTestInfo(gtype ? "gtype =" + gtype : "gtype == null || gtype == 0");
            if (!LoginModel.GetInstance().plat_name) {
                let Message = window["Message"]
                Message.show("获取包名失败，请退出重新登录。");
                return;
            }
            this.is_alpha = galpha == "1";
            this.need_alpha_plat_belong = galpha == "2";
            this.need_alpha_open_charge = galpha == "3";
            // if (!this.need_alpha_open_charge){
            //     this.need_alpha_open_charge = ClientConfig.need_alpha_open_charge
            // }
            //ClientConfig.sdk_server = 1
            if (!gtype || Number(gtype) == 0) {
                console.warn("LoginByHttpValidate------------------------------");
                this.LoginBySdkCallbak();
                return;
            }
            let ticket = ClientConfig.login_key;
            let now_method = "check_login_" + LoginModel.GetInstance().plat_name;
            let cur_time = String(Math.floor(new Date().getTime() / 1000));
            let call_func = (data) => {
                if (data) {
                    // data = JSON.parse(data);
                    this.get_server_info_token = data.token;
                    console.log("ret,error_msg,data =", data.ret, data.uid, data.token);
                    if (data.uid) {
                        uid = data.uid;
                    }
                    // LoginModel.GetInstance().account_id = +uid 
                    if (data.ret == 0) //seccuss
                    {
                        if (this.login_request_call_back) {
                            this.login_request_call_back(+uid);
                        }
                    }
                }
            };
            let sign = md5.hex_md5(String(ticket + cur_time + now_method)).toLowerCase();
            let params = JSON.stringify({ uid: uid, login_time: login_time, token: token });
            HttpUtil.HttpPostRequest(ClientConfig.login_php + `?time=${cur_time}&method=${now_method}&sign=${sign}`, params, call_func);
        }
    };

    public LoginRequest = (login_request_call_back) => {
        this.ShowTestInfo("LoginRequest+++++000+++++");
        this.login_request_call_back = login_request_call_back;
        this.LoginByHttpValidate();
    };

    public ServerRole = (product_id) => {
        let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
        let RoleManager = window["RoleManager"]
        let role_info = RoleManager.GetInstance().mainRoleInfo;
        if (!playerInfo || !role_info)
            return "";
        // let server_role = role_info.server_id + "gzsy" + role_info.role_id + "gzsy" + product_id
        let server_role = playerInfo.server_id + "gzsy" + role_info.role_id + "gzsy" + product_id;
        return server_role;
    };

    last_pay_request_time = 0;
    public PayRequest = (custom_money, custom_info, custom_callpack?) => {
        let cur_time = Status.NowTime;
        if (cur_time - this.last_pay_request_time < 1)
            return;
        this.last_pay_request_time = cur_time;
        this.PayStart(custom_money, custom_info, custom_callpack);
    };

    public PayStart = (custom_money, custom_info, custom_callpack) => {
        let random = Util.RandomRange(100, 999);
        let server_role = this.ServerRole(custom_info.id || 0);
        let now_order_num = server_role + "-" + LoginModel.GetInstance().account_id + "-" + Status.NowTime + random + '-' + ClientConfig.plat_name;
        let RoleManager = window["RoleManager"]
        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
        let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
        console.log("-----------PayStart111111-------------", playerInfo);
        if (main_role_vo && playerInfo) {
            if (window['thinkingdata']) {
                //TA订单请求打点
                let product_id = custom_info.id
                let product_cfg = product_id && Config.PRELOAD_SERVER_CONFIG.config_recharge_product[product_id]// Rechargeproduct[product_id]
                if (product_cfg) {

                    let data = {
                        account_id: main_role_vo.role_id,
                        event_name: "order_init",
                        currency: "RMB",
                        pay_amount: Number(custom_money) || 0,
                        pay_item_type: String(product_cfg.product_type) || "",
                        pay_sub_type: String(product_cfg.product_subtype) || "",
                        pay_item_id: String(product_id) || "",
                        pay_item: custom_info.pay_title || "",
                        is_quick: custom_info.recharge_type && custom_info.recharge_type == 1 || false,
                        distinct_id: this.GetTADeviceID()
                    }
                    window['thinkingdata'].track("order_init", data);
                }
            }


            if (Util.IsMiniGame()) {
                if (window[this.sdk_name] && !this.is_alpha) {
                    let RoleManager = window["RoleManager"]
                    let role_platform_times_data = RoleManager.GetInstance().role_platform_times_data;
                    let params = {
                        game_no: now_order_num,
                        order_money: 100 * (custom_money || 0),
                        order_name: custom_info.pay_title || "",
                        server_id: playerInfo.server_id,
                        server_name: playerInfo.server_name,
                        role_id: main_role_vo.role_id,
                        role_name: main_role_vo.name,
                        role_level: main_role_vo.level,
                        ext: now_order_num,
                        dun_exp_count: role_platform_times_data[1] || 0,
                        per_boss_count: role_platform_times_data[2] || 0,
                        enchantment_guard_gate: role_platform_times_data[3] || 0 //主线本关卡数
                    };
                    let wx
                    wx = window["wx"]
                    console.log("-----------PayStart222222222-------------", params);
                    window[this.sdk_name].pay(params, function (data) {
                        console.warn("-----------pay callback-------------", data);
                        if (data.ret == 'SUCCESS') { //前端通知，不能做为实际发货的凭证，真实情况以服务端通知为准
                            console.log("支付完成");
                            Util.IsWXGame() && wx.showModal({
                                title: "支付成功",
                                content: "支付成功"
                            });
                        }
                        else if (data.ret == 'YD_TIPS') {
                            Util.IsWXGame() && wx.showModal({
                                title: "温馨提示",
                                content: data.msg //充值引导文字，由我们后台配置
                            });
                        }
                        else if (data.ret == 'NOT_ALLOW') {
                            Util.IsWXGame() && wx.showModal({
                                title: "支付失败",
                                content: "暂不支持ios支付"
                            });
                        }
                        else {
                            console.log("支付取消或失败");
                        }
                    });
                }
            }
            else if (PlatformManager.IsShenhaiPlatform() || PlatformManager.IsEyouPlatform()) {
                if (Util.IsConch()) {
                    let real_plat = ClientConfig.plat_name;
                    let pay_callback_url = ClientConfig.url_account_path + "api/pay.php?plat=suyou&platname=" + real_plat;
                    let data = {
                        accname: LoginModel.GetInstance().account_id,
                        role_id: main_role_vo.role_id,
                        role_name: main_role_vo.name,
                        server_id: playerInfo.server_id,
                        server_name: playerInfo.server_name,
                        role_lv: main_role_vo.level,
                        money: custom_money || 0,
                        product_id: String(custom_info.id),
                        product_name: custom_info.pay_title || "",
                        extra_info: now_order_num,
                        notify_url: pay_callback_url,
                        has_gold: main_role_vo.jin,
                        vip_level: main_role_vo.vip_flag,
                        reg_time: TimeUtil.getServerTime()
                    };
                    let plat_name: string = ClientConfig.product_plat || PlatformManager.GetPlatformName();
                    if (plat_name) {
                        plat_name = plat_name.replace("_alpha", "");
                        let index = plat_name + "@" + data["product_id"];
                        if (Config.PRELOAD_SERVER_CONFIG.config_appstroe_product) {
                            let product_info = Config.PRELOAD_SERVER_CONFIG.config_appstroe_product[index];
                            if (product_info) {
                                data["appstore_product_id"] = product_info.product ? String(product_info.product).trim() : 0;
                            }
                            else {
                                data["appstore_product_id"] = "";
                                data["appstore_product_id_1"] = plat_name + (data["money"] / 10);
                                data["appstore_product_id_2"] = plat_name + (data["money"] * 10);
                                data["appstore_product_id_3"] = plat_name + (data["money"]);
                            }
                        }
                    }
                    this.CallNativeFunction("sku", data);
                }
                else {
                    if (PlatformManager.IsEyouPlatform()) {
                        if (window[this.sdk_name]) {
                            window[this.sdk_name]["call"]('TopUp');
                        }
                    } else {
                        let params = {
                            game_no: now_order_num,
                            order_money: 100 * (custom_money || 0),
                            order_name: custom_info.pay_title || "",
                            server_id: playerInfo.server_id,
                            server_name: playerInfo.server_name,
                            role_id: main_role_vo.role_id,
                            role_name: main_role_vo.name,
                            role_level: main_role_vo.level,
                            ext: now_order_num, //扩展信息，通知发货时会原样返回
                            has_gold: main_role_vo.jin, //玩家账户余额（如：元宝数）
                            vip_level: main_role_vo.vip_flag, //vip等级
                        };
                        window[this.sdk_name].pay(params, function (data) {
                            //前端通知，不能做为实际发货的凭证，真实情况以服务端通知为准
                            if (data.ret == 'SUCCESS') {
                            } else if (data.ret == 'POPPAYTIPS_CALLBACK_CLOSE') {
                            } else {
                            }
                            if (custom_callpack) {
                                custom_callpack(data.ret)
                            }
                        });
                    }
                }
            }
        }
    };

    /**
     * 数据上报
     * @param post_type 1 :进入游戏 2:升级 3:创角  4:初始化 5:登录  6:充值 7:主线关卡
     * @returns 
     */
    public DataPost = (post_type: number = 1) => {
        let RoleManager = window["RoleManager"]
        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
        let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
        if (main_role_vo && playerInfo) {
            if (Util.IsWXGame()
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
            ) {
                let server_id = playerInfo.server_id
                //针对某些渠道如果取不到初始服务器id,就先不上报，等待我们自己的上报返回初始服务器id后在上传
                if (PlatformManager.NeedBaseServerIdPlatform()) {
                    server_id = this.GetBaseServerId(main_role_vo.role_id)
                    if (!server_id) {
                        return
                    }
                }
                let role_platform_times_data = RoleManager.GetInstance().role_platform_times_data;
                let role_info = {
                    role_id: main_role_vo.role_id,
                    role_name: main_role_vo.name,
                    role_level: main_role_vo.level,
                    server_id: server_id,
                    server_name: playerInfo.server_name,
                    has_gold: main_role_vo.jin,
                    vip_level: main_role_vo.vip_flag,
                    role_power: main_role_vo.fighting || 0,
                    create_time: TimeUtil.getServerTime(),
                    dun_exp_count: role_platform_times_data[1] || 0,
                    per_boss_count: role_platform_times_data[2] || 0,
                    enchantment_guard_gate: role_platform_times_data[3] || 0 //主线本关卡数
                };
                //进入游戏角色信息上报
                if (window[this.sdk_name]) {
                    if (post_type == 1) {
                        this.DataPlacement(90500);

                        window[this.sdk_name].enterGame(role_info, (ret) => {
                            console.log('进入游戏角色上报', ret);
                            this.realname_sm = ret.data.sm
                            if (ret.data.msg.sp) { //true为显示支付按钮，false为不显示支付按钮
                                console.warn("enterGame 显示支付");
                                this.is_alpha = false;
                            }
                            else {
                                console.warn("enterGame 不显示支付");
                                this.is_alpha = true;
                            }
                        });

                    }
                    else if (post_type == 2) {
                        window[this.sdk_name].roleUpLevel(role_info, (ret) => {
                            console.warn('角色升级上报', ret);
                            this.realname_sm = ret.data.sm
                            if (ret.data.msg.sp) { //true为显示支付按钮，false为不显示支付按钮
                                console.warn("roleUpLevel 显示支付");
                                this.is_alpha = false;
                            }
                            else {
                                console.warn("roleUpLevel 不显示支付");
                                this.is_alpha = true;
                            }
                        });
                    }
                }
            }
            else if (PlatformManager.IsEyouPlatform() || PlatformManager.IsShenhaiPlatform()) {

                let server_id = playerInfo.server_id
                //针对某些渠道需要上报初始服务器id,如果取不到初始服务器id,就先不上报，等待异步的请求返回后在上报
                if (PlatformManager.NeedBaseServerIdPlatform()) {
                    server_id = this.GetBaseServerId(main_role_vo.role_id)
                    if (!server_id) {
                        return
                    }
                }
                var role_info = {
                    role_id: main_role_vo.role_id,
                    role_name: main_role_vo.name,
                    role_level: main_role_vo.level,
                    server_id: server_id,
                    server_name: playerInfo.server_name,
                    has_gold: main_role_vo.jin,
                    vip_level: main_role_vo.vip_flag,
                    role_power: main_role_vo.fighting || 0,
                    create_time: TimeUtil.getServerTime() //时间戳，单位：秒
                };
                if (Util.IsConch()) {
                    if (post_type == 1) {
                        this.CallNativeFunction("enterGame", role_info);
                    }
                    else if (post_type == 2) {
                        this.CallNativeFunction("roleUpLevel", role_info);
                    }
                }
                else {
                    if (PlatformManager.IsEyouPlatform()) {
                        if (window[this.sdk_name]) {
                            if (post_type == 1) {
                                window[this.sdk_name]["call"]('SaveData', {
                                    server_id: playerInfo.server_id,
                                    role_id: main_role_vo.role_id
                                });
                            }
                        }
                    }
                    else {
                        if (window[this.sdk_name]) {
                            if (post_type == 1) {
                                this.DataPlacement(90500);
                                window[this.sdk_name].enterGame(role_info);
                            } else if (post_type == 2) {
                                window[this.sdk_name].roleUpLevel(role_info);
                            } else if (post_type == 7 && window["AutoBrushModel"]) {
                                if (PlatformManager.IsDuoYouPlatform()) {
                                    role_info["checkpoint"] = window["AutoBrushModel"].GetInstance().GetLevel()
                                    window[this.sdk_name].roleUpLevel(role_info);
                                }
                            }
                        }
                    }
                }
            }
            else {
                let data = {
                    type: post_type,
                    role_id: main_role_vo.role_id,
                    role_name: main_role_vo.name,
                    server_id: playerInfo.server_id,
                    server_name: playerInfo.server_name,
                    role_lv: main_role_vo.level,
                    reg_time: TimeUtil.getServerTime()
                };
                let url = `syudata:${SpecialCharKey.PlatformManager1}` + Base64.encode(JSON.stringify(data));
                if (ClientConfig && ClientConfig.href_mode) {
                    window.location.href = url;
                }
            }
        }
    };
    public CreateRoleDataPost = (role_id, role_lv) => {
        let RoleManager = window["RoleManager"]
        if (!RoleManager)
            return;
        let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
        if (!playerInfo) {
            return;
        }
        let cur_role_name = LoginModel.GetInstance().new_select_name || "无";
        if (Util.IsWXGame()
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
        ) {

            let server_id = playerInfo.server_id
            //针对某些渠道需要上报初始服务器id,如果取不到初始服务器id,就先不上报，等待异步的请求返回后在上报
            if (PlatformManager.NeedBaseServerIdPlatform()) {
                server_id = this.GetBaseServerId(role_id)
                if (!server_id) {
                    return
                }
            }
            let role_platform_times_data = RoleManager.GetInstance().role_platform_times_data;
            let role_info = {
                role_id: role_id,
                role_name: cur_role_name,
                role_level: role_lv,
                server_id: server_id,
                server_name: playerInfo.server_name,
                has_gold: 0,
                vip_level: 0,
                role_power: 0,
                create_time: TimeUtil.getServerTime(),
                dun_exp_count: role_platform_times_data[1] || 0,
                per_boss_count: role_platform_times_data[2] || 0,
                enchantment_guard_gate: role_platform_times_data[3] || 0 //主线本关卡数
            };
            if (window[this.sdk_name]) {
                window[this.sdk_name].createRole(role_info, (ret) => {
                    console.log('创建角色上报', ret);
                    this.realname_sm = ret.data.sm
                    if (ret.data.msg.sp) { //true为显示支付按钮，false为不显示支付按钮
                        console.warn("createRole 显示支付");
                        this.is_alpha = false;
                    }
                    else {
                        console.warn("createRole 不显示支付");
                        this.is_alpha = true;
                    }
                });
            }

        }
        else if (PlatformManager.IsShenhaiPlatform()) {
            let server_id = playerInfo.server_id
            //针对某些渠道需要上报初始服务器id,如果取不到初始服务器id,就先不上报，等待异步的请求返回后在上报
            if (PlatformManager.NeedBaseServerIdPlatform()) {
                server_id = this.GetBaseServerId(role_id)
                if (!server_id) {
                    return
                }
            }
            var role_info = {
                role_id: role_id,
                role_name: cur_role_name,
                role_level: role_lv,
                server_id: server_id,
                server_name: playerInfo.server_name,
                has_gold: 0,
                vip_level: 0,
                role_power: 0,
                create_time: TimeUtil.getServerTime() //时间戳，单位：秒
            };
            if (Util.IsConch()) {
                this.CallNativeFunction("createRole", role_info);
            }
            else {
                if (window[this.sdk_name]) {
                    window[this.sdk_name].createRole(role_info);
                }
            }
        }
        else {
            let data = {
                type: 3,
                role_id: role_id,
                role_name: cur_role_name,
                server_id: playerInfo.server_id,
                server_name: playerInfo.server_name,
                role_lv: role_lv,
                reg_time: TimeUtil.getServerTime()
            };
            let url = `syudata:${SpecialCharKey.PlatformManager1}}` + Base64.encode(JSON.stringify(data));
            if (ClientConfig && ClientConfig.href_mode) {
                window.location.href = url;
            }
        }
    };
    // //登录埋点 
    public LoginBuryingPoint = (type: number, step: number) => {
        // if (ClientConfig.sdk_server) {
        //     var plat_name = PlatformManager.GetPlatformName();
        //     if (type == 1) {
        //         let has_set = CookieWrapper.GetInstance().GetCookie("SET_TYPE1_STEP2_BURYING_POINT_COMPLETE");
        //         if (!has_set) {
        //             let param = `data=${JSON.stringify({ "source": plat_name, "step": step, "type": type })}`;
        //             var url = 'https://websqs.suyougame.cn/yys/put?auth=Ks9maj2hXa&' + param;
        //             HttpUtil.HttpPostRequest(url, null, null, 0, false);
        //             CookieWrapper.GetInstance().SaveCookie("SET_TYPE1_STEP2_BURYING_POINT_COMPLETE", "1", false);
        //         }
        //     }
        //     else if (type == 2) {
        //         if (LoginModel.GetInstance().account_id) {
        //             let has_set = CookieWrapper.GetInstance().GetCookie(LoginModel.GetInstance().account_id.toString(), false);
        //             if (!has_set) {
        //                 let param = `data=${JSON.stringify({ "source": plat_name, "accname": LoginModel.GetInstance().account_id, "step": step, "type": type })}`;
        //                 var url = 'https://websqs.suyougame.cn/yys/put?auth=Ks9maj2hXa&' + param;
        //                 HttpUtil.HttpPostRequest(url, null, null, 0, false);
        //                 if (step == 6) {
        //                     CookieWrapper.GetInstance().SaveCookie(LoginModel.GetInstance().account_id.toString(), "1", false);
        //                 }
        //             }
        //         }
        //     }
        // }
    };


    public ChatMonitor = (type, msg, receive_name) => {
        if (!type || !msg) return
        let RoleManager = window["RoleManager"]
        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
        let player_info = LoginManager.GetInstance().GetPlatUserInfo();
        if (!main_role_vo || !player_info) return
        if (PlatformManager.IsShenhaiPlatform()) {
            if (window["ShSdk"] && window["ShSdk"].chatMonitor) {
                type = PlatformManager.SyChatType2ShChatType[String(type)]
                window["ShSdk"].chatMonitor({
                    type: type, //(1:私聊，2:房间(组队)，3:区服(单服)，4:世界(全服)，5:帮会(公会)，6:跨服，7:同城(同省),99:未知(未定义的))
                    server_id: player_info.server_id, //(选服界面的显示的区服id，数字部分)
                    server_name: player_info.server_name,
                    role_name: main_role_vo.name,
                    role_id: main_role_vo.role_id,
                    to_role_name: receive_name ? receive_name : "",
                    msg: msg,
                });
            }
            if (this.is_report_chat) {
                var param = {
                    "type": type,//|聊天类型，1:私聊，2:房间，3:区服(单服)，4:世界(全服)，5:帮会
                    "server_id": player_info.server_id,//消息发送者区服id
                    "uid": LoginModel.GetInstance().account_id,//消息发送者uid(sdk服务端登录验证返回的uid)
                    "role_name": main_role_vo.name,
                    "touid": LoginModel.GetInstance().account_id,//消息接收者uid(sdk服务端登录验证返回的uid)，房间聊天时为房间id，私聊不能为空，其他情况可以为空
                    "to_role_name": receive_name ? receive_name : "",//消息接收者角色名，私聊不能为空，其他情况可以为空
                    "msg": msg,//消息内容
                }
                var data: any = {}
                data.func = 'AWY_CHATMONITOR'
                data.param = param
                parent.postMessage(JSON.stringify(data), "*")
            }
        }
    }



    role_id_2_base_server_id_dic
    public GetBaseServerId(role_id) {
        if (!this.role_id_2_base_server_id_dic) {
            let data = window['CookieWrapper'].GetInstance().GetCookie(window['CookieWrapper'].CACHE_BASE_SERVER_ID, false);
            if (data) {
                this.role_id_2_base_server_id_dic = JSON.parse(data)
            }
            else {
                this.role_id_2_base_server_id_dic = {}
            }
        }
        return this.role_id_2_base_server_id_dic[role_id]
    }


    //获得游戏logo图片路径
    public GetLogoImgPath = () => {
        if (LoginModel.GetInstance().plat_name) {
            if (ClientConfig && ClientConfig.logo_img) {
                return `platform/res/login/${ClientConfig.logo_img}`;
            }
        }
        return "resource/game/login/texture/logo.png";
    };
    //获得游戏登录背景图片路径
    public GetLoginBgPath = () => {
        if (LoginModel.GetInstance().plat_name) {
            if (ClientConfig && ClientConfig.login_bg) {
                return `platform/res/login/${ClientConfig.login_bg}`;
            }
        }
        return "resource/game/scene/dragonBones/denglu/denglu_bg.jpg?v=7";
    };

    //获得进入游戏加载图背景图片路径
    public GetEnterGameLoadingBgPath = () => {
        if ((this.is_alpha || this.need_alpha_open_charge) && ClientConfig && ClientConfig.loading_bg) {
            return `platform/res/login/${ClientConfig.loading_bg}`;
        }
        else {
            return `resource/game/login/texture/load_bg0.jpg`;
        }
    };

    //特殊活动的cid，链接端链接里有cid参数，小程序没有cid
    public SetCidState(cid) {
        if (cid && cid != "") {
            this.activity_cid = Number(cid);
        }
    }

    //获得微信的packagecode
    public GetWXPackageCode() {
        let local_json_cfg = window["local_json_cfg"], package_code;
        if (local_json_cfg) {
            local_json_cfg = JSON.parse(local_json_cfg);
            let is_android = false;
            if (Laya.Browser.onAndroid) {
                is_android = true;
            }
            package_code = is_android ? local_json_cfg["android_number"] : local_json_cfg["ios_number"];
        }
        return package_code
    }

    //获得QQ的特有的package_code
    public GetQQPackageCode() {
        let local_json_cfg = window["local_json_cfg"], package_code;
        if (local_json_cfg) {
            local_json_cfg = JSON.parse(local_json_cfg);
            let is_android = false;
            if (Laya.Browser.onAndroid) {
                is_android = true;
            }
            package_code = is_android ? local_json_cfg["android_package_code"] : local_json_cfg["ios_package_code"];
        }
        return package_code
    }

    //获得微信的token_id
    public GetWXTokenId() {
        if (!this.sdk_login_data) {
            return
        }
        let token_id
        let login_data = this.sdk_login_data
        if (login_data.channel && String(login_data.channel).trim() !== "") {
            LoginModel.GetInstance().login_channel = login_data.channel;
            token_id = login_data.token
        }
        else if (PlatformManager.IsShenhaiPlatform()) {
            token_id = login_data.tokenid
        }
        else {
            token_id = login_data.token
        }
        return token_id;
    }

    /**
     * android返回键
     */
    public AndroidBackBtnListener = () => {
        if (Util.IsConch() && (Laya.Browser.onAndroid)) {
            if (window["ViewManager"].GetInstance().GetCanCloseViewNum() > 0) {
                window["ViewManager"].GetInstance().CloseOneViewOneTimes();
            }
            else {
                if (PlatformManager.IsEyouPlatform()) {
                    let content = Util.StrToHTML(`是否确认退出游戏?`);
                    let ok_call = () => {
                        //@ts-ignore
                        if (window.conch) {
                            //@ts-ignore
                            window.conch.exit();
                        }
                    };
                    let Alert = window["Alert"]
                    let Alert_Type = window["Alert_Type"]
                    let alert_view = Alert.Show(content, Alert_Type.Two, ok_call, undefined, "确认", "取消");
                    alert_view.click_bg_toClose = false
                } else {
                    this.NativeQuitGame();
                }

            }
        }
    };

    /**
     * 原生包退出游戏
     */
    public NativeQuitGame = () => {
        if (Util.IsConch()) {
            this.CallNativeFunction("exitGame", {});
        }
    };

    /**
     * 原生包切换账号
     */
    public NativeLoginOut = () => {
        if (Util.IsConch()) {
            this.CallNativeFunction("loginOut", {});
        }
        else {
            if (ClientConfig && ClientConfig.ShowSwtichIdBtn && this.sdk_name
                && window[this.sdk_name] && window[this.sdk_name].logout) { //登出接口
                console.warn("登出------------");
                window[this.sdk_name].logout();
            }
        }
    };

    /**
     * 原生包登录背景加载好
     */
    public NativeLogigBgSuccess = () => {
        if (Util.IsConch()) {
            this.CallNativeFunction("loginBgShow", {});
        }
    };


    /**
     * 英文0元礼包跳转
     * @param custom_money 
     * @param custom_info 
     * @returns 
     */
    public FreePayRequest = (custom_money, custom_info) => {
        if (!PlatformManager.IsEyouPlatform()) {
            return
        }
        if (!Util.IsConch()) {
            return
        }
        let random = Util.RandomRange(100, 999);
        let server_role = this.ServerRole(custom_info.id || 0);
        let now_order_num = server_role + "-" + LoginModel.GetInstance().account_id + "-" + Status.NowTime + random;
        let RoleManager = window["RoleManager"]
        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
        let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
        if (main_role_vo && playerInfo) {
            let real_plat = ClientConfig.plat_name;
            let pay_callback_url = ClientConfig.url_account_path + "api/pay.php?plat=suyou&platname=" + real_plat;
            let data = {
                accname: LoginModel.GetInstance().account_id,
                role_id: main_role_vo.role_id,
                role_name: main_role_vo.name,
                server_id: playerInfo.server_id,
                server_name: playerInfo.server_name,
                role_lv: main_role_vo.level,
                money: custom_money || 0,
                product_id: String(custom_info.id),
                product_name: custom_info.pay_title || "",
                extra_info: now_order_num,
                notify_url: pay_callback_url,
                reg_time: TimeUtil.getServerTime()
            };
            let plat_name: string = ClientConfig.product_plat || PlatformManager.GetPlatformName();
            if (plat_name) {
                plat_name.replace("_alpha", "");
                let index = plat_name + "@" + data["product_id"];
                if (Config.PRELOAD_SERVER_CONFIG.config_appstroe_product) {
                    let product_info = Config.PRELOAD_SERVER_CONFIG.config_appstroe_product[index];
                    if (product_info) {
                        data["appstore_product_id"] = product_info.product ? String(product_info.product).trim() : 0;
                    }
                    else {
                        data["appstore_product_id"] = "";
                        data["appstore_product_id_1"] = plat_name + (data["money"] / 10);
                        data["appstore_product_id_2"] = plat_name + (data["money"] * 10);
                        data["appstore_product_id_3"] = plat_name + (data["money"]);
                    }
                }
            }
            this.CallNativeFunction("freePurchase", data);
        }
    };

    /**
     * FaceBook 按钮状态
     * @returns 
     */
    public IsShowFB = () => {
        if (!PlatformManager.IsEyouPlatform()) {
            return
        }
        if (!Util.IsConch()) {
            return
        }
        let RoleManager = window["RoleManager"]
        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
        let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
        if (main_role_vo && playerInfo) {
            this.CallNativeFunction("IsShowFB", {}, (data) => {
                if (data && data.type == "IsShowFB") {
                    //0没有按钮，1有特效，2无特效
                    EyouManager.GetInstance().SetFbState(data.value)
                }

            });
        }
    };

    /**
     * eyou打点
     * @param post_type "game_login_completed"sdk登录完成后，等级登录游戏按钮/"role_completed"创角成功/"level_up"玩家升级/"game_completed"角色进入游戏
     * @param role_id 
     * @returns 
     */
    public EyouDataPlacement(post_type, role_id?) {
        if (!post_type) return
        if (!PlatformManager.IsEyouPlatform()) return

        if (Util.IsConch()) {
            let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
            if (!playerInfo) {
                return;
            }
            let RoleManager = window["RoleManager"]
            let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
            let data = {
                Roleid: (role_id != undefined) ? role_id : (main_role_vo ? main_role_vo.role_id : 0),
                Serverid: playerInfo.server_id,
                event: post_type,
                count: main_role_vo ? main_role_vo.level : 0
            };
            if (post_type) {
                this.CallNativeFunction("EyouEventRecord", data);
            }
        }
        else {
            let sdk = window[this.sdk_name]
            if (sdk && sdk.call) {
                let data = {
                    event: post_type,
                }

                sdk.call('Statistics', data)
            }
        }
    }

    /**
     * eyou 打开客服
     */
    public EyouOpenGM() {
        if (PlatformManager.IsEyouEnPlatform()) {
            this.CallNativeFunction("CallEyouGM", {});
        }
    }

    /**
     * 是否支持第三方充值
     * @param call_fun 
     */
    public SupportOtherPay(call_fun) {
        if (PlatformManager.IsEyouEnPlatform() || PlatformManager.IsEyouThPlatform()) {
            this.CallNativeFunction("SupportOtherPay", {}, call_fun);
        }
    }

    /**
     * 第三方充值
     */
    public OtherPayRequest() {
        if (PlatformManager.IsEyouEnPlatform()) {
            this.CallNativeFunction("OtherPayRequest", {});
        }
    }

    /**
     * 深海平台 是否进行了实名制验证
     * @param finish_func         实名完成调用函数
     * @param unfinished_fun      未完成实名调用函数
     */
    public CheckSHNameVerify(finish_func?, unfinished_fun?) {

        //unfinished_fun(type)
        // 1 未完成实名 
        // 2 找不到对应的接口方法
        // 3 找不到平台接口
        // 4 平台屏蔽

        let sdk_name = PlatformManager.GetInstance().sdk_name//"PlatTest"
        if (sdk_name) {
            if (Util.IsWXGame() && window[sdk_name] && window[sdk_name].getRealnameInfo) {
                //根据接口文档，实名验证成功才会有ret这个参数
                window[sdk_name].getRealnameInfo((ret) => {
                    //当sm为false的时候，活动隐藏
                    let open_cond = true
                    if (this.realname_sm == null || this.realname_sm == false) {
                        open_cond = false
                    }

                    if (open_cond) {
                        // ret.data.msg.realname
                        //#参数realname==true验证完成
                        if (ret
                            && ret["data"]
                            && ret["data"]["msg"]
                            && ret["data"]["msg"]["realname"]
                            && ret["data"]["msg"]["realname"] == true) {
                            if (finish_func) finish_func(ret)
                        } else {
                            console.warn("NameVerify:Has`t verify")
                            if (unfinished_fun) unfinished_fun(1)
                        }
                    } else {
                        console.warn("NameVerify:Verify be hide")
                        if (unfinished_fun) unfinished_fun(4)
                    }

                });
            } else {
                console.warn("NameVerify:Plat is error")
                if (unfinished_fun) unfinished_fun(2)
            }
        } else {
            // console.warn("NameVerify:sdk_name is null")
            if (unfinished_fun) unfinished_fun(3)
        }
    }

    /**
     * 深海平台  前往实名
     */
    public GoToSHNameVerify() {
        let sdk_name = PlatformManager.GetInstance().sdk_name// "PlatTest"// 
        if (sdk_name) {
            if (Util.IsWXGame() && window[sdk_name] && window[sdk_name].goXcxRealname) {
                console.warn("NameVerify:Go to Verify")
                window[sdk_name].goXcxRealname();
            } else {
                console.warn("NameVerify:Can`t to verify,Plat is error")
            }
        }
    }

    /**
     * 深海平台 微信一次性订阅--用户触发
     * @param id  配置中的id
     * @param is_got /module_sub/ac_sub 拉取完权限是否发送领取预约奖励的协议
    */
    public WeChatSubscriptionSH(id?, is_got?, module?, module_sub?, ac_sub?) {
        let sdk_name = PlatformManager.GetInstance().sdk_name//"PlatTest" //
        if (sdk_name) {
            if (Util.IsWXGame() && window[sdk_name] && window[sdk_name].requestSubscribeMessage) {
                console.warn("Subscription:Try to get")

                //获取模板数据
                let s_model = SettingModel.GetInstance()
                let data = s_model.GetSubscriptionModuleIds2(id)
                let param = [data.temp_id]
                s_model.WxSaveAntiKey(data.temp_id)

                //callback 订阅回调
                window[sdk_name].requestSubscribeMessage(param, (res) => {
                    console.warn(`Subscription:${res}`)

                    //请求一次性订阅权限 回调成功
                    if (res && res["errMsg"] && res["errMsg"] == "requestSubscribeMessage:ok") {
                        let module_id_list = []
                        for (let key in res) {
                            if (key != "errMsg" && res[key] == "accept") {
                                s_model.WxDeleteAntiKey(key)
                                table.insert(module_id_list, Number(data.id))
                            }
                        }

                        //将模板id发送到服务端
                        if (module_id_list && module_id_list.length > 0) {
                            console.warn(module_id_list)
                            s_model.Fire(SettingModel.SETTING_REQUEST_PROTO_11305, module_id_list[0])
                        } else {
                            console.warn(`Subscription:Length is 0`)
                        }


                        //领取预约奖励
                        if (is_got) {
                            console.warn("got:15720")
                            DailyModel.GetInstance().Fire(DailyEvent.DAILY_REQUEST_PROTO, 15720, "iii", module, module_sub, ac_sub)
                        }

                    }
                });
            } else {
                console.warn("Subscription:sdk_name is null")
            }
        }
    }

    /**
     * 获取数数唯一ID
     * @returns 
     */
    public GetTaDistinctId() {
        if (!ClientConfig.ta_distinct_id && window['thinkingdata']) {
            ClientConfig.ta_distinct_id = window['thinkingdata'].getDistinctId();//self.cur_platform:GetTaDistinctId()
        }
        return ClientConfig.ta_distinct_id
    }

    /**
     * 获取数数设备ID
     * @returns 
     */
    public GetTADeviceID() {
        if (window['thinkingdata']) {
            return window['thinkingdata'].getDeviceId();//self.cur_platform:GetTaDistinctId()
        } else {
            return ""
        }
    }

    /**
     * 退出小程序
     */
    public exitMiniProgram() {
        if (Util.IsWXGame()) {

        } else if (Util.IsQQGame()) {
            window["qq"].exitMiniProgram()
        } else if (Util.IsOPPOFastGame() || Util.IsVivoFastGame() || Util.IsMiFastGame() || Util.IsMeiZuFastGame()) {
            window["qg"].exitApplication({})
        } else if (Util.IsUCGame()) {
            window["uc"].exit()
        } else if (Util.IsBiliBiliGame()) {
            window['bl'].exitMiniProgram({})
        } else if (Util.IsKSGame()) {
            window['bl'].exitMiniProgram()
        } else if (Util.IsTTGame()) {
            window['tt'].exitMiniProgram()
        }
        else {

        }
    }

    /**
     * 打开APP商店
     */
    public JumpToAppStore() {
        if (PlatformManager.IsEyouPlatform()) {
            if (Util.IsConch()) {
                this.CallNativeFunction("OpenAppStore");
            } else {
            }
        }
    }

    /**
     * 打开FaceBook
     */
    public JumpToFaceBook() {
        if (PlatformManager.IsEyouPlatform()) {
            if (Util.IsConch()) {
                this.CallNativeFunction("FacebookAction");
            } else {
            }
        }
    }

    /**
     * 切换账号
     */
    public ShowTheBlockUserAccountViewBlock() {
        if (PlatformManager.IsEyouPlatform()) {
            if (Util.IsConch()) {
                this.CallNativeFunction("CancelAccount");
            } else {

            }
        }
    }

    public ShowUserCenter() {
        if (PlatformManager.IsEyouPlatform()) {
            if (Util.IsIOSConch()) {
                this.CallNativeFunction("ShowUserCenter");
            } else {

            }
        }
    }

    /**
     * 复制
     * @param str 
     */
    public Clipboard(str) {
        if (Util.IsConch()) {
            this.CallNativeFunction("Clipboard", { data: str });
        } else {

        }
    }

    public SaveAPKShortcut = (callback) => {
        if (!Util.IsKSGame()) {
            callback()
            return
        }

        if (!Laya.Browser.onAndroid) {
            callback()
            return
        }

        let sdk_name = this.sdk_name
        if (!window[sdk_name] || !window[sdk_name].saveAPKShortcut) {
            return
        }

        //调起下载
        window[sdk_name].saveAPKShortcut(() => {
            //关闭领取面板，保留入口，无需其他操作
            callback()
        })
    }

    public ResetAPKShourtcut() {
        this.apk_shourtcut_open_state = false
        this.apk_shourtcut_has_show = false
        this.CancelAPKShourtcutTimer()
    }

    apk_shourtcut_open_state = false
    apk_shourtcut_open_level
    apk_shourtcut_has_show = false
    public CheckSaveAPKShourtcutState() {
        if (!Util.IsKSGame()) {
            return
        }

        if (!ClientConfig.show_apk_shortcut) {
            return
        }

        if (!window["ks"] || !window["ks"].isLaunchFromApk) {
            return
        }

        //判断小游戏是否从Apk启动
        if (window["ks"].isLaunchFromApk()) {
            UserMsgAdapter.GetInstance().SendAllFmtToGame(11308, "c", [1])
        }

        if (!Laya.Browser.onAndroid) {
            return
        }
        let sdk_name = this.sdk_name
        if (!window[sdk_name] || !window[sdk_name].showAPKShortcut) {
            return
        }

        if (this.apk_shourtcut_open_level == null) {
            let cfgs = Config.PRELOAD_SERVER_CONFIG.config_wx_kv
            if (cfgs) {
                if (cfgs["14"]) {
                    this.apk_shourtcut_open_level = Number(cfgs["14"].value)
                    console.log("------apk_shourtcut_open_level------", this.apk_shourtcut_open_level)
                    let callback = (e) => {
                        //success:显示入口  fail:不显示入口
                        let apk_shourtcut_open_state = e == 'success'
                        console.log("------showAPKShortcut1------", e, apk_shourtcut_open_state)
                        if (apk_shourtcut_open_state != this.apk_shourtcut_open_state) {
                            this.apk_shourtcut_open_state = apk_shourtcut_open_state
                            this.UpdateSaveAPKShourtcut()
                        }
                    }
                    window[sdk_name].showAPKShortcut(callback)
                }
            }
        } else {
            let callback = (e) => {
                //success:显示入口  fail:不显示入口
                let apk_shourtcut_open_state = e == 'success'
                console.log("------showAPKShortcut2------", e, apk_shourtcut_open_state)
                if (apk_shourtcut_open_state != this.apk_shourtcut_open_state) {
                    this.apk_shourtcut_open_state = apk_shourtcut_open_state
                    this.UpdateSaveAPKShourtcut()
                }
            }
            window[sdk_name].showAPKShortcut(callback)
        }
    }

    public UpdateSaveAPKShourtcut() {
        if (this.apk_shourtcut_open_level == null) {
            return
        }
        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
        console.log("------updateSaveAPKShourtcut------", this.apk_shourtcut_has_show, this.apk_shourtcut_open_state, main_role_vo.level, this.apk_shourtcut_open_level)
        if (main_role_vo && !this.apk_shourtcut_has_show && this.apk_shourtcut_open_state && main_role_vo.level >= this.apk_shourtcut_open_level) {
            //每次帐号登录只触发一次
            this.apk_shourtcut_has_show = true
            let icon_info = ActivityIconManager.GetInstance().getIconInfo(113113113)
            if (!icon_info) {
                ActivityIconManager.GetInstance().addIcon(113113113)
            }
            this.StartAPKShourtcutTimer()
        }
    }

    apk_shourtcut_timer
    public StartAPKShourtcutTimer() {
        this.CancelAPKShourtcutTimer()
        this.apk_shourtcut_timer = setTimeout(() => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "KSAPKShortcutTipsView")
        }, 60 * 1000)
    }

    public CancelAPKShourtcutTimer() {
        if (this.apk_shourtcut_timer) {
            clearTimeout(this.apk_shourtcut_timer)
            this.apk_shourtcut_timer = undefined
        }
    }

    public SwitchAccount(){
        if (PlatformManager.IsEyouPlatform()) {
            if(Util.IsConch()){
                this.CallNativeFunction("switchAccount");
                return true
            }
            else{
                let sdk_name = PlatformManager.GetInstance().sdk_name
                if (window[sdk_name]) {
                    window[sdk_name]["call"]('HandleAccount');
                    return true
                }
            }
        }
    }

    /**
     * 看广告
     * @param ad_id 广告ID
     * @returns 
     */
    public ShowAd(ad_id?) {
        if (!PlatformManager.IsEyouPlatform()) {
            return
        }
        ad_id = ad_id || 0
        this.CallNativeFunction("ShowAd", {
            ad_id: String(ad_id)
        })
    }


    /***是否展示 pv消消乐*/
    public IsShowEnMiniGame() {
        if (ClientConfig && ClientConfig.is_open_elim_round) {
            if (PlatformManager.GetInstance().is_wx_alpha) {
                return true
            } else {
                let flag = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_POP_MIN_GAME, false)
                if (!flag) {
                    return true
                }
            }
        }
        return false
    }

}
window["PlatformManager"] = PlatformManager