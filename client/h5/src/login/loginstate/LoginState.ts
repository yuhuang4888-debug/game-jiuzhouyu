
import { BaseState } from "./ConnectGameState";
import { LoginModel } from "../LoginModel";
import { PlatformManager } from "../../PlatformManager";
import { UserMsgAdapter } from "../../common/UserMsgAdapter";
import { GlobalEventSystem, ClientConfig, LOAD_QUEUE } from "../../util/DeclareGlobalVar";
import { LoginManager } from "../LoginManager";
import { LoginStateEvent, EventName } from "../../common/EventName";
import { ServerModel } from "../ServerModel";
import { Enum_LoginState } from "../LoginStateManager";
import { Util, DEVICE_OS } from "../../util/Util";
import { Message } from "../../sysInfo/SysInfoController";
import { HttpUtil } from "../../util/HttpUtil";
import { md5 } from "../../util/md5";
import { Alert, Alert_Type } from "../../alert/Alert";
import { GameError } from "../../util/GameError";
import { CookieWrapper } from "../../common/CookieWrapper";
import { BaseClass } from "../../common/BaseClass";
import { ResManager } from "../../common/ResManager";
export class LoginState implements BaseState {
    state_finish = false;
    OnStateEnter;
    OnStateUpdate;
    OnStateQuit;
    PlayerLogin;
    TryLogin;
    SentActiveCode;
    CheckActiveCode;
    config_tar = new BaseClass();
    public constructor() {
        let login_model = LoginModel.GetInstance(), local_LoginModel_Instance = LoginModel.GetInstance(), local_PlatformManager_Instance = PlatformManager.GetInstance(), local_UserMsgAdapter_Instance = UserMsgAdapter.GetInstance(), local_GlobalEventSystem = GlobalEventSystem, local_LoginManager_Instance = LoginManager.GetInstance(), local_LoginStateEvent = LoginStateEvent, local_ServerModel_Instance = ServerModel.GetInstance(), local_Enum_LoginState = Enum_LoginState, local_Util = Util, local_Message = Message, local_HttpUtil = HttpUtil, local_Number = Number, login_from_register_ = false, 
        // need_active_code_ = false,
        request_count_ = 0, //尝试登录次数计数器
        account_, token_, try_login_finish_, login_completed_time_, bind_login_id_;
        this.OnStateEnter = () => {
            PlatformManager.GetInstance().ShowTestInfo("LoginState OnStateEnter++sdk_server+++:" + ClientConfig.sdk_server);
            if (ClientConfig.use_sdk_bg) {
                LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginSdkCallView");
            }
            if (ClientConfig.sdk_server) {
                let call_fun = (user_id, token = null) => {
                    account_ = user_id;
                    token_ = token;
                    try_login_finish_ = true;
                    local_PlatformManager_Instance.LoginBuryingPoint(1, 2);
                    local_PlatformManager_Instance.LoginBuryingPoint(2, 1);
                    local_UserMsgAdapter_Instance.RemoveConnectCheckTimer();
                    console.warn("LoginState LoginRequest call_back-------------");
                };
                if (LoginManager.GetInstance().swtich_account_user_id) { //sdk 切换账号
                    PlatformManager.GetInstance().ShowTestInfo("LoginState sdk切换账号++:" + LoginManager.GetInstance().swtich_account_user_id);
                    call_fun(LoginManager.GetInstance().swtich_account_user_id);
                    LoginManager.GetInstance().swtich_account_user_id = undefined;
                }
                else {
                    local_PlatformManager_Instance.LoginRequest(call_fun);
                }
                return;
            }
            local_UserMsgAdapter_Instance.RemoveConnectCheckTimer();
            let [register_account, register_password, register_token]  = local_LoginModel_Instance.GetRegisterAccount();
            if (register_account) {
                login_from_register_ = true;
                account_ = register_account;
                try_login_finish_ = true;
                local_LoginModel_Instance.SetRegisterAccount(null);
            }
            else {
                LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginView");
                try_login_finish_ = false;
                account_ = 0;
                if (bind_login_id_) {
                    local_GlobalEventSystem.UnBind(bind_login_id_);
                    bind_login_id_ = null;
                }
                //本地测试方法
                if (LoginManager.GetInstance().swtich_account_user_id) { //sdk 切换账号 
                    PlatformManager.GetInstance().ShowTestInfo("LoginState sdk切换账号+11+:" + LoginManager.GetInstance().swtich_account_user_id);
                    this.TryLogin(LoginManager.GetInstance().account, LoginManager.GetInstance().password);
                    LoginManager.GetInstance().swtich_account_user_id = undefined;
                }
                else {
                    bind_login_id_ = local_LoginManager_Instance.Bind(local_LoginStateEvent.COMFIRN_LOGIN_BTN, (account, password) => {
                        LoginManager.GetInstance().account = account;
                        LoginManager.GetInstance().password = password;
                        this.TryLogin(account, password);
                    });
                }
            }
        };
        this.OnStateUpdate = () => {
            if (try_login_finish_) {
                try_login_finish_ = false;
                local_LoginModel_Instance.account_id = account_;
                local_LoginModel_Instance.token = token_;
                if (ServerModel.GetInstance().IsLocationMode()) {
                    let localtion = ServerModel.GetInstance().GetLocation();
                    ServerModel.GetInstance().FormatAccountUrl(localtion);
                    ServerModel.GetInstance().cur_selected_location = localtion;
                    this.PlayerLogin();
                }
                else {
                    this.PlayerLogin();
                }
            }
            if (this.state_finish) {
                GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestLoginLoading.hashCode);
                if (ClientConfig.use_sdk_bg) {
                    LoginManager.GetInstance().Fire(LoginStateEvent.CLOSE_VIEW, "LoginSdkCallView");
                }
                if (!ClientConfig.sdk_server) {
                    LoginManager.GetInstance().Fire(LoginStateEvent.CLOSE_VIEW, "LoginView");
                    LoginManager.GetInstance().Fire(LoginStateEvent.CLOSE_VIEW, "RegisterView");
                }
                if (local_LoginManager_Instance.IsNewPlayer()) //新账号
                 {
                    if (PlatformManager.GetInstance().IsShowEnMiniGame()) {
                        let call_func = () => {
                            local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, local_Enum_LoginState.SimplifyServer);
                        }
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ElimMainView", 1, call_func)
                        if(!PlatformManager.GetInstance().is_wx_alpha) {
                            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LOCAL_POP_MIN_GAME, 1, false)
                        }
                    } else{
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, local_Enum_LoginState.SimplifyServer);
                    }
                }
                else {
                    let isreview = 0;
                    if (PlatformManager.GetInstance().is_alpha) {
                        isreview = 1;
                    }
                    let info = local_LoginModel_Instance.player_login_info;
                    let data: any = {};
                    data.server = {};
                    data.server[info.last] = {
                        "area": info.area,
                        "id": local_Number(info.last),
                        "close_desc": info.close_desc,
                        "name": info.lastname,
                        "isreview": isreview,
                        "closed": info.closed,
                        "num": info.num,
                        "belong": "",
                    };
                    local_LoginManager_Instance.Fire(local_LoginStateEvent.SIMPLIFY_SERVER_INFO, data);

                    if (PlatformManager.GetInstance().IsShowEnMiniGame()) {
                        let call_func = () => {
                            local_LoginManager_Instance.Fire(LoginStateEvent.OPEN_VIEW, "LoginEnterView");
                        }
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ElimMainView", 1, call_func)
                        if(!PlatformManager.GetInstance().is_wx_alpha) {
                            CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LOCAL_POP_MIN_GAME, 1, false)
                        }
                    } else{
                        local_LoginManager_Instance.Fire(LoginStateEvent.OPEN_VIEW, "LoginEnterView");
                    }
  
                }
                if (bind_login_id_) {
                    local_GlobalEventSystem.UnBind(bind_login_id_);
                    bind_login_id_ = null;
                    login_from_register_ = false;
                }
                let sdk = window[PlatformManager.GetInstance().sdk_name]
                if(Util.IsWXGame() && sdk && sdk.shFloatIcon)
                {
                    var icon = {
                        stage:Laya.stage,	                //游戏内自定义图层，或者直接以示例代码中的值传过来即可
                        entryIconX:0,			//X轴的距离
                        entryIconY:0			//Y轴的距离
                      }
                    sdk.shFloatIcon(icon);
                }
                this.state_finish = false;
            }
        };
        this.OnStateQuit = () => {
            request_count_ = 0;
            setTimeout(() => {
                ResManager.GetInstance().LoadGameConfig(this.config_tar,"ConfigPrivac",true, LOAD_QUEUE.HIGHT,  (cfg) => {
                    if (cfg) {
                        local_LoginModel_Instance.RefreshPrivacViewState(cfg);
                    }
                    ResManager.GetInstance().DestoryGameConfig(this.config_tar, "ConfigPrivac", true);
                });
            }, 2000);
        };
        this.PlayerLogin = () => {
            let device_id = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_DEVICE_ID, false)
            if(!device_id){
                device_id = Util.RandomDeviceId()
                CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LOCAL_DEVICE_ID, device_id, false)
            }
            let idfa = device_id;
            let os_type = 2;
            let login_key = ClientConfig.login_key;
            let plat_name = local_LoginModel_Instance.plat_name || ClientConfig.plat_name;
            if (Laya.Browser.onAndroid) {
                os_type = 0;
            }
            else if (Laya.Browser.onIOS) {
                os_type = 1;
            }
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "player_login";
            let now_sign = (md5.hex_md5(login_key + now_time + now_method)).toLowerCase();
            let get_param = {
                "accname": account_,
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
                "site": plat_name,
                "idfa": idfa,
                "device_id": device_id,
                "os": os_type
            };
            let player_login_info = local_LoginModel_Instance.player_login_info
            let token = (player_login_info && player_login_info.token) ? player_login_info.token : (token_ || ClientConfig.login_token)
            if(token)
            {
                get_param["token"] = token
            }
            let error_alert
            let connect_state = false;
            let connect_error = (comeback) => {
                if (connect_state)
                    return;
                connect_state = true;

                if(error_alert){
                    error_alert.Close()
                }

                let text 
                if(comeback){
                    text = "请求异常，请稍后再试";
                }
                else{
                    text = "网络异常，请稍后再试";
                }

                let exit_func = () => {
                    local_GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT);
                };
                error_alert = Alert.Show(text, Alert_Type.One, exit_func, null, "确定", null, null, true);
            };
            let retry_count = 0;
            let login_php = ClientConfig.login_php;
            let call_func = (data) => {
                console.log("------LoginState0000------玩家登录信息:" + data);
                if (data) {
                    if(error_alert){
                        error_alert.Close()
                    }
                    connect_state = true;
                    let info;
                    try {
                        info = JSON.parse(data);
                    }
                    catch (e) {
                        GameError.GetInstance().SendErrorToPHP("服务器验证错误，重新刷新游戏", true);
                        if (!local_Util.IsMiniGame()) {
                            window.location.reload();
                        }
                        else {
                            info = null;
                        }
                    }
                    if (!info) {
                        if (retry_count < 3) {
                            local_Message.show("服务器验证超时，已重新发送请求");
                            retry_count = retry_count + 1;
                            local_HttpUtil.HttpGetRequest(login_php, get_param, call_func);
                        }
                        else {
                            local_Message.show("服务器验证失败，请再次登陆");
                            local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, local_Enum_LoginState.Login);
                            GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestLoginLoading.hashCode);
                        }
                        return;
                    }
                    if (info && local_Number(info["ret"]) == 0) {
                        //解析获取玩家登录信息
                        console.log("------LoginState------玩家登录信息:", info);
                        local_LoginModel_Instance.SetTestServerData(info.testname, info.testotime);
                        // local_LoginModel_Instance.SetTestServerData("永夜开发",Math.floor(new Date().getTime() / 1000) + 60)
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.PLAYER_LOGIN_INFO, info);
                        this.state_finish = true;
                        if(window['thinkingdata'])
                        {
                            
                            if(info.new_accname == 1)
                            {
                                let register_data = {
                                    reg_ip : info.ip,
                                    is_simulator: ClientConfig.is_simulator && 1 || 0
                                }
                                window['thinkingdata'].track("account_register", register_data);
                            }
                            let login_data = {
                                login_ip : info.ip,
                                is_simulator: ClientConfig.is_simulator && 1 || 0
                            }

                            window['thinkingdata'].track("account_login", login_data);
                            

                        }
                        if (!login_completed_time_ || Laya.timer.currTimer - login_completed_time_ > 3000) {
                            login_completed_time_ = Laya.timer.currTimer;
                            local_Message.show("恭喜登录成功");
                            local_PlatformManager_Instance.DataPlacement(290004); //php登录成功
                        }
                    }
                    else {
                        local_Message.show("登陆游戏失败,请再次尝试错误码:" + info["ret"]);
                    }
                }
                else {
                    connect_error(true);
                }
            };
            local_HttpUtil.HttpGetRequest(login_php, get_param, call_func);
            setTimeout(connect_error, 5000);
            GlobalEventSystem.Fire(EventName.SHOW_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestLoginLoading.hashCode);
        };
        this.TryLogin = (account, password) => {
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "player_check_login";
            let plat_name = local_LoginModel_Instance.plat_name || ClientConfig.plat_name;
            let login_key = ClientConfig.login_key;
            let login_php = ClientConfig.login_php;
            let backurl_account_path = ClientConfig.backurl_account_path;
            let now_sign = (md5.hex_md5(login_key + now_time + now_method)).toLowerCase();
            let get_param = {
                "pwd": password,
                "username": account,
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
            };
            let connect_state = false;
            let connect_error = (comeback) => {
                if (connect_state)
                    return;
                connect_state = true;
                if (!comeback) {
                    backurl_account_path = ClientConfig.backurl_account_path;
                    if (backurl_account_path) {
                        let url_account_path = ClientConfig.url_account_path;
                        ClientConfig.login_php = login_php.replace(url_account_path, backurl_account_path);
                    }
                    if (request_count_ == 0) {
                        request_count_ = request_count_ + 1;
                        this.TryLogin(account, password);
                        return;
                    }
                }
                local_Message.show("登录超时，请再次点击登录");
            };
            let call_func = (data) => {
                // 判读登陆验证是否成功,成功则进入服务器登陆验证
                request_count_ = request_count_ + 1;
                if (data) {
                    connect_state = true;
                    let info = JSON.parse(data);
                    if (info && local_Number(info["ret"]) == 0) {
                        if(info["token"]){
                            ClientConfig.login_token = info["token"]
                        }
                        try_login_finish_ = true;
                        request_count_ = 0;
                        account_ = account;
                        // 保存帐号
                        if (CookieWrapper.GetInstance()) {
                            CookieWrapper.Instance.SaveCookie(CookieWrapper.LOGIN_USER_NAME, account_);
                            let remember_pwd = CookieWrapper.GetInstance().GetCookie(CookieWrapper.REMEMBER_PASSWORD);
                            if (Boolean(remember_pwd))
                                CookieWrapper.Instance.SaveCookie(CookieWrapper.LOGIN_USER_PASSWORD, password);
                        }
                    }
                    else {
                        local_Message.show("账号或密码错误,请再次尝试");
                    }
                }
                else {
                    if (request_count_ == 1 && ClientConfig.backurl_account_path) {
                        connect_state = true;
                        ClientConfig.login_php = login_php.replace(ClientConfig.url_account_path, ClientConfig.backurl_account_path);
                        this.TryLogin(account, password);
                    }
                    else
                        connect_error(true);
                }
            };
            local_HttpUtil.HttpGetRequest(ClientConfig.login_php, get_param, call_func);
            setTimeout(connect_error, 5000);
        };
        this.SentActiveCode = (active_code, call_func) => {
            let device_id = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_DEVICE_ID, false)
            if(!device_id){
                device_id = Util.RandomDeviceId()
                CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LOCAL_DEVICE_ID, device_id, false)
            }
            let idfa = device_id

            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "player_login";
            let plat_name = local_LoginModel_Instance.plat_name || ClientConfig.plat_name;
            let login_key = ClientConfig.login_key;
            // let login_key = "#LMfJyNQUKhLVLmpJ%WBo4@k^VdTEB5m"
            let login_php = ClientConfig.login_php;
            let now_sign = (md5.hex_md5(login_key + now_time + now_method)).toLowerCase();
            let get_param = {
                "accname": account_,
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
                "site": plat_name,
                "idfa": idfa,
                "device_id": device_id,
                "os": active_code
            };
            local_HttpUtil.HttpGetRequest(login_php, get_param, call_func);
        };
        this.CheckActiveCode = (data) => {
            let active_code_use = data["code_use"];
            if (active_code_use && local_Number(active_code_use) == 1) {
                local_Message.show("激活码已被使用");
                return false;
            }
            let active_code_error = data["code_error"];
            if (active_code_error) {
                if (local_Number(active_code_error) == 1) {
                    local_Message.show("激活失败");
                    return false;
                }
                else if (local_Number(active_code_error) == 2) {
                    local_Message.show("激活时间未到");
                    return false;
                }
                else if (local_Number(active_code_error) == 3) {
                    local_Message.show("激活时间过期");
                    return false;
                }
            }
            let active_code_not_exist = data["code_not_exist"];
            if (active_code_not_exist && local_Number(active_code_not_exist) == 1) {
                local_Message.show("激活码不存在");
                return false;
            }
            return true;
        };
    }
}

window["LoginState"] = LoginState