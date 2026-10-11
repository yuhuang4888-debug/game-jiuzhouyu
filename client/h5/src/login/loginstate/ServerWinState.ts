import { BaseState } from "./ConnectGameState";
import { GlobalEventSystem, ClientConfig } from "../../util/DeclareGlobalVar";
import { LoginManager } from "../LoginManager";
import { LoginModel } from "../LoginModel";
import { EventName, LoginStateEvent } from "../../common/EventName";
import { GameError } from "../../util/GameError";
import { Enum_LoginState } from "../LoginStateManager";
import { Alert, Alert_Type } from "../../alert/Alert";
import { md5 } from "../../util/md5";
import { PlatformManager } from "../../PlatformManager";
import { HttpUtil } from "../../util/HttpUtil";
export class ServerWinState implements BaseState {
    state_finish = false;
    TrySelectServer;
    OnStateEnter;
    OnStateUpdate;
    OnStateQuit;
    public constructor() {
        let local_GlobalEventSystem = GlobalEventSystem, local_LoginManager_Instance = LoginManager.GetInstance(), local_LoginModel_Instance = LoginModel.GetInstance(), local_EventName = EventName, local_GameError_Instance = GameError.GetInstance(), local_LoginStateEvent = LoginStateEvent, retry_count_ = 0, server_error_info_;
        this.OnStateEnter = () => {
            retry_count_ = 0;
            this.TrySelectServer(LoginManager.GetInstance().GetCurServerId());
        };
        this.OnStateUpdate = () => {
            if (this.state_finish) {
                this.state_finish = false;
                local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ConnectGame);
            }
        };
        this.OnStateQuit = () => {
        };
        this.TrySelectServer = (server_id) => {
            let exit = () => {
                // local_GlobalEventSystem.Fire(local_EventName.CHANGE_ACCOUNT)
            };
            if (!server_id || server_id == "" || Number(server_id) == 0) {
                Alert.Show("选服操作失败，请退出游戏重新登录", Alert_Type.One, exit, null, "确定");
                return;
            }
            server_error_info_ = null;
            let player_login_info = local_LoginModel_Instance.player_login_info
            let now_player_id = player_login_info["id"];
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "get_server_info";
            let login_key = ClientConfig.login_key;
            let now_sign = (md5.hex_md5(login_key + now_time + now_method)).toLowerCase();
            let get_param = {
                "id": server_id,
                "player_id": now_player_id,
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
            };

            let token =  local_LoginModel_Instance.token || ClientConfig.login_token
            if(token)
            {
                get_param["token"] = token
            }
            local_LoginModel_Instance.register_max_num_data = null
            let check_server_info = function (info) {
                if (Number(info["ret"]) == 0 && info["port"] && info["host"] && info["accname"] && info["port"] != "" && info["host"] != "" && info["accname"] != "")
                    return true;
                return false;
            };
            let check_server_json = function (data) {
                if (data.indexOf("port") != -1 && data.indexOf("host") != -1 && data.indexOf("accname") != -1)
                    return true;
                return false;
            };
            let cur_error_code = 0;
            let sent_error = () => {
                if (server_error_info_) {
                    local_GameError_Instance.SendErrorToPHP("连接服务器失败，服务器ID:" + server_id + " 账号ID:" + now_player_id + " 异常数据:" + server_error_info_ + " 错误码:" + cur_error_code);
                    server_error_info_ = null;
                }
            };
            let retry = () => {
                this.TrySelectServer(server_id);
            };
            let show_message = (error_code) => {
                cur_error_code = error_code;
                if (retry_count_ < 3) {
                    retry_count_ = retry_count_ + 1;
                    let str = "服务器连接失败:" + error_code;
                    Alert.Show(str, Alert_Type.One, exit, null, "确定");
                    // let str = "服务器连接失败:" + error_code + "，请点击重试"
                    // Alert.Show(str, Alert_Type.Two, retry, exit, "重新连接", "稍后再来")
                    setTimeout(sent_error, 0.1);
                    //重试一次后依旧失败就发送报警
                    if (retry_count_ == 2) {
                        let sent_server_error = () => {
                            local_GameError_Instance.SendErrorToPHP("选服获取IP端口失败");
                        };
                        setTimeout(sent_server_error, 100);
                    }
                }
                else
                    Alert.Show("服务器连接失败，请检查网络连接，如不能进入，请联系客服解决", Alert_Type.One, exit, null, "确定");
            };
            let call_func = (data) => {
                /**
                 * {
                 *      "ret":0,
                 *      "closed":null,
                 *      "host":"",
                 *      "port":"",
                 *      "time":1663035999,
                 *      "accname":null,
                 *      "pid":null,
                 *      "register_max_num":{
                 *          "max_num":"999",
                 *          "start_time":"1662912000",
                 *          "end_time":"1663516800"
                 *      }
                 * }    
                 */

                console.log('get_server_info ---------------', data);
                server_error_info_ = data;
                if (data) {
                    if (check_server_json(data)) {
                        let info = JSON.parse(data);
                        if (info && check_server_info(info)) {
                            if(info.register_max_num && LoginManager.GetInstance().IsNewPlayer()){
                                local_LoginModel_Instance.register_max_num_data = info.register_max_num
                            }
                            local_LoginManager_Instance.Fire(local_LoginStateEvent.PLAYER_SERVER_INFO, info);
                            this.state_finish = true;
                        }
                        else
                            show_message(3000);
                    }
                    else
                        show_message(2000);
                }
                else
                    show_message(1000);
            };
            HttpUtil.HttpGetRequest(ClientConfig.login_php, get_param, call_func);
        };
    }
}

window["ServerWinState"] = ServerWinState