// console.warn("RegisterState@ConnectGameState")
import { BaseState } from "./ConnectGameState";
// console.warn("RegisterState@DeclareGlobalVar")
import { GlobalEventSystem, ClientConfig } from "../../util/DeclareGlobalVar";
// console.warn("RegisterState@EventName")
import { EventName, LoginStateEvent } from "../../common/EventName";
// console.warn("RegisterState@LoginModel")
import { LoginModel } from "../LoginModel";
// console.warn("RegisterState@LoginManager")
import { LoginManager } from "../LoginManager";
// console.warn("RegisterState@SysInfoController")
import { Message } from "../../sysInfo/SysInfoController";
// console.warn("RegisterState@LoginStateManager")
import { Enum_LoginState } from "../LoginStateManager";
// console.warn("RegisterState@md5")
import { md5 } from "../../util/md5";
// console.warn("RegisterState@CookieWrapper")
import { CookieWrapper } from "../../common/CookieWrapper";
// console.warn("RegisterState@HttpUtil")
import { HttpUtil } from "../../util/HttpUtil";
import { ServerModel } from "../ServerModel";
// console.warn("RegisterState")
export class RegisterState implements BaseState {
    state_finish = false;
    OnStateEnter;
    OnStateUpdate;
    OnStateQuit;
    TryRegister;


    public constructor() {
        let local_GlobalEventSystem = GlobalEventSystem, 
        local_LoginStateEvent = LoginStateEvent, 
        local_LoginModel_Instance = LoginModel.GetInstance(), 
        local_LoginManager_Instance = LoginManager.GetInstance(), 
        local_Message = Message, 
        account_,
        password_,
        token_,
        request_count_ = 0, 
        bind_register_id_;
        this.OnStateEnter = () => {
            if (bind_register_id_) {
                local_GlobalEventSystem.UnBind(bind_register_id_);
                bind_register_id_ = null;
            }
            let register = (account, password) => {
                console.log("-----register-----", account, password);
                this.TryRegister(account, password);
            };
            bind_register_id_ = local_LoginManager_Instance.Bind(local_LoginStateEvent.COMFIRM_REGISTER_BTN, register);
        };
        this.OnStateUpdate = () => {
            if (this.state_finish) {
                this.state_finish = false;
                local_GlobalEventSystem.UnBind(bind_register_id_);
                local_LoginModel_Instance.SetRegisterAccount(account_, password_, token_);
                local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.Login);
            }
        };
        this.OnStateQuit = () => {
            request_count_ = 0;
        };
        this.TryRegister = (account, password) => {
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "player_register";
            let plat_name = local_LoginModel_Instance.plat_name || ClientConfig.plat_name;
            let now_sign = md5.hex_md5(String(ClientConfig.login_key + now_time + now_method)).toLowerCase();
            account_ = account;
            let get_param = {
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
                "username": account,
                "pwd": password,
                "site": plat_name,
            };
            let connect_state = false;
            let connect_error = () => {
                if (connect_state)
                    return;
                connect_state = true;
                if (ClientConfig.backurl_account_path) {
                    ClientConfig.login_php = ClientConfig.login_php.replace(ClientConfig.url_account_path, ClientConfig.backurl_account_path);
                } 
                if(request_count_ > 3){
                    request_count_ = 0;
                    local_Message.show("注册超时，请再次点击注册");
                    GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestRegisterLoading.hashCode);
                }
                else{
                    request_count_ = request_count_ + 1;
                    this.TryRegister(account, password);
                }
            };
            let call_func = (state) => // 判读注册是否成功,成功则进入自动登陆流程
            {
                GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestRegisterLoading.hashCode);
                request_count_ = request_count_ + 1;
                if (state) {
                    connect_state = true;
                    let info = JSON.parse(state);
                    if (info && Number(info["ret"]) == 0) //id 
                    {
                        local_Message.show("恭喜注册成功");
                        this.state_finish = true;
                        request_count_ = 0;
                        token_ = info["token"]
                        if(token_)
                        {
                            ClientConfig.login_token = token_
                        }
                        if (CookieWrapper.Instance) {
                            CookieWrapper.Instance.SaveCookie(CookieWrapper.LOGIN_USER_NAME, account);
                            let remember_pwd = CookieWrapper.GetInstance().GetCookie(CookieWrapper.REMEMBER_PASSWORD) || false;
                            if (Boolean(remember_pwd))
                                CookieWrapper.Instance.SaveCookie(CookieWrapper.LOGIN_USER_PASSWORD, password);
                        }
                        local_LoginModel_Instance.SetAccountHistoryListCookies(account, password);
                    }
                    else if (info && Number(info["ret"]) == 1) {
                        local_Message.show("注册不成功,账号已存在");
                        // local_LoginModel_Instance.Fire(LoginModel.REGISTER_FAILER)
                    }
                    else {
                        if (info && info["ret"]) {
                            local_Message.show("注册不成功,请再次尝试,错误码:" + info["ret"]);
                        }
                        else {
                            local_Message.show("注册不成功,请再次尝试");
                        }
                    }
                }
                else {
                    if (request_count_ == 1 && ClientConfig.backurl_account_path) {
                        connect_state = true;
                        ClientConfig.login_php = ClientConfig.login_php.replace(ClientConfig.url_account_path, ClientConfig.backurl_account_path);
                        this.TryRegister(account, password);
                    }
                    else
                    {
                        local_Message.show("注册超时，请再次点击注册");
                        request_count_ = 0
                    }
                }
            };
            console.log("ClientConfig.login_php++++++++++:", ClientConfig.login_php);
            HttpUtil.HttpGetRequest(ClientConfig.login_php, get_param, call_func);
            GlobalEventSystem.Fire(EventName.SHOW_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestRegisterLoading.hashCode);
            setTimeout(connect_error, 5000);
        };
    }
}

window["RegisterState"] = RegisterState