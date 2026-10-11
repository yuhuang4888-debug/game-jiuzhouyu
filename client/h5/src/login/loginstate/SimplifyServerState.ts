import { BaseState } from "./ConnectGameState";
import { GlobalEventSystem, ClientConfig } from "../../util/DeclareGlobalVar";
import { LoginManager } from "../LoginManager";
import { ServerModel } from "../ServerModel";
import { LoginStateEvent, EventName } from "../../common/EventName";
import { Enum_LoginState } from "../LoginStateManager";
import { PlatformManager } from "../../PlatformManager";
import { LoginModel } from "../LoginModel";
import { Alert, Alert_Type } from "../../alert/Alert";
import { HttpUtil } from "../../util/HttpUtil";
export class SimplifyServerState implements BaseState {
    state_finish = false;
    OnStateEnter;
    OnStateUpdate;
    OnStateQuit;
    public constructor() {
        let  local_GlobalEventSystem = GlobalEventSystem, local_LoginManager_Instance = LoginManager.GetInstance(), local_ServerModel_Instance = ServerModel.GetInstance(), local_LoginStateEvent = LoginStateEvent, local_Enum_LoginState = Enum_LoginState, local_PlatformManager_Instance = PlatformManager.GetInstance(), local_LoginModel_Instance = LoginModel.GetInstance();
        this.OnStateEnter = () => {
            GlobalEventSystem.Fire(EventName.SHOW_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestServerLoading.hashCode);
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let get_param = {
                "time": now_time,
            };
            let call_func = (data) => {
                //解析精简服务器列表文件信息
                console.log("请求精简服务器返回----------------------：", data);
                if (data) {
                    let info = JSON.parse(data);
                    if (info)
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.SIMPLIFY_SERVER_INFO, info);
                    this.state_finish = true;
                }
                else {
                    let ok_callback = () => {
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, local_Enum_LoginState.SimplifyServer);
                    };
                    let cancel_callback = () => {
                        local_GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT);
                    };
                    Alert.Show("下载服务器简易列表文件失败\n是否重新请求下载？", Alert_Type.Two, ok_callback, cancel_callback, "重试", "退出");
                    GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestServerLoading.hashCode);
                }
            };
            let client_config = ClientConfig;
            let request_url = client_config.simplify_server_file;
            if (local_PlatformManager_Instance.is_alpha || local_PlatformManager_Instance.need_alpha_plat_belong || local_PlatformManager_Instance.need_alpha_open_charge
                || local_PlatformManager_Instance.is_wx_alpha) {
                if (client_config.alpha_plat_belong) {
                    request_url = client_config.simplify_server_file.replace("server", "server_" + client_config.alpha_plat_belong);
                }
            }
            else {
                if (client_config.plat_belong) {
                    request_url = client_config.simplify_server_file.replace("server", "server_" + client_config.plat_belong);
                }
            }
            console.log("请求精简服务 request_url----------------------:", request_url);
            HttpUtil.HttpGetRequest(request_url, get_param, call_func);
        };
        this.OnStateUpdate = () => {
            if (this.state_finish) {
                this.state_finish = false;
                LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginEnterView");
                GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestServerLoading.hashCode);
            }
        };
        this.OnStateQuit = () => {
        };
    }
}

window["SimplifyServerState"] = SimplifyServerState