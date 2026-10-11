// console.warn("GameError@Util")
import { ClientConfig } from "./DeclareGlobalVar";
import { Status } from "./Status";
import { md5 } from "./md5";
export class GameError {
    static Instance: GameError;
    wait_sent_list: Array<string> = [];
    last_sent_time = 0;
    sent_interval = 10;
    save_file_error_count = 0;
    download_file_error_count = 0;
    load_file_error_count = 0;
    server_data_error_count = 0;
    longtime_mesh_error_count = 0;
    cur_timer = 0;
    public constructor() {

        window.onerror = (errorMessage, scriptURI, lineNumber, columnNumber, errorObj) => {
            console.log("错误信息：", errorMessage);
            console.log("出错文件：", scriptURI);
            console.log("出错行号：", lineNumber);
            console.log("出错列号：", columnNumber);
            console.log("错误详情：", errorObj);
            if (errorObj) {
                let str: string = `${errorObj.message}:\n${errorObj.stack}`;
                this.SendErrorToPHP(str, false);
            }
            return false;
        };
        if (!window["Util"]) return
        if (window["Util"].IsWXGame() || window["Util"].IsQQGame() || window["Util"].IsMTGame()) {
            let local_wx
            local_wx = window["wx"]
            if (local_wx) {
                local_wx.onError((error) => {
                    if (error) {
                        let str: string = `${error.message}`;
                        console.log("小程序错误信息：", str);
                        this.SendErrorToPHP(str, false);
                    }
                })
            }

        } else if (window["Util"].IsOPPOFastGame() || window["Util"].IsVivoFastGame() || window["Util"].IsMiFastGame() || window["Util"].IsMeiZuFastGame()) {
            let local_qg
            local_qg = window["qg"]
            if (local_qg) {
                local_qg.onError((error) => {
                    if (error) {
                        let str: string = `${error.message}`;
                        console.log("小程序错误信息：", str);
                        this.SendErrorToPHP(str, false);
                    }
                })
            }
        } else if (window["Util"].IsBiliBiliGame()) {
            let local_bl
            local_bl = window["bl"]
            if (local_bl) {
                local_bl.onError((error) => {
                    if (error) {
                        let str: string = `${error.message}`;
                        console.log("小程序错误信息：", str);
                        this.SendErrorToPHP(str, false);
                    }
                })
            }
        } else if (window["Util"].IsTTGame()) {
            let local_tt
            local_tt = window["tt"]
            if (local_tt) {
                local_tt.onError((error) => {
                    if (error) {
                        let str: string = `${error.message}`;
                        console.log("小程序错误信息：", str);
                        this.SendErrorToPHP(str, false);
                    }
                })
            }
        }
    }
    public static GetInstance() {
        if (!GameError.Instance) {
            GameError.Instance = new GameError();
        }
        return GameError.Instance;
    }
    public async SendErrorToPHP(str: string, show_in_console: boolean = true) {
        try {
            if (show_in_console) {
                console.error("error------------------\n" + str);
            }
            if (!window["LoginModel"] || (window["LoginModel"] && !window["LoginModel"].GetInstance().plat_name)) {
                //Alert.Show(str, Alert_Type.One)
                // if (ClientConfig.OpenLuaErrorWin)
                // {
                //     GlobalEventSystem.Fire(EventName.SET_ERROR_VIEW,str,TimeUtil.getClientTime())
                // }
                if (window["Util"].IsDebug()) //本地调试模式不上传日志
                {
                    return;
                } else {
                    window.alert("error:\n" + str);
                }
            }
            if (!ClientConfig.php_website_error) return
            let ignore_list: Array<string> = [];
            let ignore_str: string;
            for (let i = 0; i < ignore_list.length; i++) {
                ignore_str = ignore_list[i];
                let find_succeed = str.search(ignore_str);
                if (find_succeed >= 0) {
                    return;
                }
            }
            let error_str = str;
            let exist = this.ExistSameError(error_str);
            if (exist) {
                return;
            }
            this.wait_sent_list.push("<br>");
            this.wait_sent_list.push(error_str);
            if (this.cur_timer == 0) {
                let sent_func = () => {
                    this.SendNow();
                };
                let wait_time = this.sent_interval - (Status.NowTime - this.last_sent_time);
                if (wait_time > 0 && window["GlobalTimerQuest"]) {
                    this.cur_timer = window["GlobalTimerQuest"].AddPeriodQuest(sent_func, wait_time);
                }
                else {
                    sent_func();
                }
            }
        }
        catch (e) {
        }
    }
    public ExistSameError = (error_str) => {
        return this.wait_sent_list.indexOf(error_str) >= 0;
        // for (let i = 0; i < this.wait_sent_list.length; i ++)
        // {
        //     if (error_str == this.wait_sent_list[i])
        //     {
        //         return true
        //     }
        // }
        // return false
    };
    private SendNow = () => {
        let error_str = "";
        for (let i = 0; i < this.wait_sent_list.length; i++) {
            error_str = error_str.concat("\n", this.wait_sent_list[i]);
        }
        try {
            this.SendErrorMsg(error_str);
        }
        catch (e) {
        }
        this.last_sent_time = Status.NowTime;
        this.wait_sent_list.length = 0;
        this.cur_timer = 0;
    };
    private SendErrorMsg = (error_str: string) => {
        if (!error_str) {
            return;
        }
        let role_id = "0";
        let role_name = "";
        let role_lv = 0;
        // if (RoleManager && RoleManager.Instance)
        // {
        let RoleManager = window["RoleManager"]
        let vo = RoleManager.GetInstance().GetMainRoleVo();
        if (vo) {
            role_id = String(vo.role_id);
            role_name = vo.name;
            role_lv = vo.level;
        }
        // }
        let cur_server = 0;
        let server_name = "无";
        let playerInfo //= LoginManager.GetInstance().GetPlatUserInfo();
        if (playerInfo) {
            cur_server = playerInfo.server_id;
            server_name = playerInfo.server_name;
        }
        let no_empty_str: string = error_str.replace("%s", "");
        if (no_empty_str.length < 10) {
            return;
        }
        let no_line_str: string = error_str.replace("-", "");
        if (no_line_str.length < 10) {
            return;
        }
        error_str = error_str.replace(/&/g, "*");
        let scripts_ver = window["Util"].GetVersionMsg();
        let ticket = ClientConfig.login_key;
        let now_method = "log_client_error";
        let cur_time = String(Math.floor(new Date().getTime() / 1000));
        let call_func = (ret, error_msg, data) => {
            console.log("sent gameerror pose completed", ret, error_msg, data);
        };
        let sign = md5.hex_md5(String(ticket + cur_time + now_method)).toLowerCase();
        let params = `time=${cur_time}&content=${error_str}&method=${now_method}&player_id=${role_id}&nickname=${role_name}&sign=${sign}&server_id=${cur_server}&plat=${ClientConfig.plat_name}&game=yy25dlaya&info=${scripts_ver} plat:${ClientConfig.plat_name} server:${server_name} lv:${role_lv}`;
        window["HttpUtil"].HttpPostRequest(ClientConfig.php_website_error, params, call_func, 0);
    };
}
window["GameError"] = GameError;
