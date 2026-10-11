import { BaseState } from "./ConnectGameState";
import { ServerModel } from "../ServerModel";
import { GlobalEventSystem, ClientConfig } from "../../util/DeclareGlobalVar";
import { LoginManager } from "../LoginManager";
import { LoginStateEvent, EventName } from "../../common/EventName";
import { PlatformManager } from "../../PlatformManager";
import { Enum_LoginState } from "../LoginStateManager";
import { Alert, Alert_Type } from "../../alert/Alert";
import { HttpUtil } from "../../util/HttpUtil";
export class ServerListState implements BaseState {
    state_finish = false;
    OnStateEnter;
    OnStateUpdate;
    OnStateQuit;
    public constructor() {
        let local_ServerModel_Instance = ServerModel.GetInstance(), local_GlobalEventSystem = GlobalEventSystem, local_LoginManager_Instance = LoginManager.GetInstance(), local_LoginStateEvent = LoginStateEvent, local_PlatformManager_Instance = PlatformManager.GetInstance();
        this.OnStateEnter = () => {
            GlobalEventSystem.Fire(EventName.SHOW_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestServerLoading.hashCode);
            let cur_selected_area_id = local_ServerModel_Instance.cur_selected_area_id;
            if (!cur_selected_area_id)
                return;
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let get_params = {
                "time": now_time,
            };
            let call_func = (data) => {
                if (data) {
                    let info = JSON.parse(data);
                    if (info) {
                        console.log(`${cur_selected_area_id}大区服务器列表:`, info);
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.SERVER_LIST_INFO, cur_selected_area_id, info);
                        this.state_finish = true;
                    }
                }
                else {
                    let ok_callback = () => {
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ServerList);
                    };
                    let cancel_callback = () => {
                        local_GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT);
                    };
                    Alert.Show("下载服务器列表文件失败\n是否重新请求下载？", Alert_Type.Two, ok_callback, cancel_callback, "重试", "退出");
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
            request_url += String(cur_selected_area_id);
            console.log(`请求下载${cur_selected_area_id}大区服务器列表`);
            HttpUtil.HttpGetRequest(request_url, get_params, call_func);
        };
        this.OnStateUpdate = () => {
            if (this.state_finish) {
                this.state_finish = false;
                GlobalEventSystem.Fire(EventName.HIDE_WAITFOR_OPENVIEW_LOADING, ServerModel.RequestServerLoading.hashCode);
            }
        };
        this.OnStateQuit = () => {
        };
    }
}

window["ServerListState"] = ServerListState