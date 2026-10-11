// console.warn("ServerModel@EventDispatcher")
import { EventDispatcher } from "../util/EventDispatcher";
import { BaseClass } from "../common/BaseClass";
import { Util, DEVICE_OS } from "../util/Util";
import { CookieWrapper } from "../common/CookieWrapper";
import { LoginModel } from "./LoginModel";
import { LoginStateEvent, EventName } from "../common/EventName";
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { LoginManager } from "./LoginManager";
import { ResVersionManager } from "../ResVersionManager";
import { HttpUtil } from "../util/HttpUtil";
import { ResManager } from "../common/ResManager";
import { md5 } from "../util/md5";
import { GameError } from "../util/GameError";
import { PlatformManager } from "../PlatformManager";
export class ServerModel extends EventDispatcher {
    static Instance: ServerModel;
    static RequestServerLoading = new BaseClass();
    static RequestLoginLoading = new BaseClass();
    static RequestRegisterLoading = new BaseClass();
    static RequestLocationLoading = new BaseClass();

    /**
     * 服务器信息 大区对应大区内服务器列表
     */
    server_data; 
    /**
     * 大区信息
     */
    areas_data; 
    /**
     * /推荐信息
     */
    recommend_data; 
    /**
     * 登录界面 当前选中的大区ID
     */
    cur_selected_area_id; 
    /**
     * 登录界面 当前选中的地区
     */
    cur_selected_location;
    /**
     * 默认地区
     */
    base_location = 1;
    /**
     * 地区模式Url配置
     */
    location_info_cfg 


    GetServerData;
    GetAreaData;
    GetHistoryLoginInfo;
    GetLastServerId;
    GetServerName;
    InitServerArea;
    FilterServerData;
    GetRecommendServer;
    GetServerListCookie;
    SaveServerListCookie;
    GetServerListMd5;
    SaveServerListMd5;
    CheckServerState;
    GetServerByServerId;
    SelectServerFun;
    GetLocation;
    FormatAccountUrl;
    LocaltionRequestPlayerLoginInfo;
    ClearData;
    IsLocationMode;
    public constructor() {
        super();
        let local_Number = Number, local_Util = Util, cookie_wrapper = CookieWrapper.GetInstance(), local_CookieWrapper = CookieWrapper, local_LoginModel_Instance = LoginModel.GetInstance(), local_LoginStateEvent = LoginStateEvent, local_JSON = JSON;
        this.GetServerData = (area) => {
            return this.server_data && this.server_data[area];
        };
        this.GetAreaData = () => {
            return this.areas_data;
        };
        this.ClearData = () => {
            this.areas_data = null;
            this.server_data = null;
        };
        this.GetHistoryLoginInfo = () => {
            let player_login_info = local_LoginModel_Instance.player_login_info;
            return player_login_info && player_login_info.player_server;
        };
        this.GetLastServerId = () => {
            let player_login_info = local_LoginModel_Instance.player_login_info;
            return player_login_info && player_login_info.last;
        };
        this.GetServerName = (server_id) => {
            let name = null;
            if (this.server_data) {
                let server_dic;
                for (let area_id in this.server_data) {
                    server_dic = this.server_data[area_id];
                    if (server_dic) {
                        let v;
                        for (let id in server_dic) {
                            v = server_dic[id];
                            if (v && local_Number(v.id) == local_Number(server_id)) {
                                name = v.name;
                                break;
                            }
                        }
                    }
                }
            }
            if (!name)
                name = "未知服务器";
            return name;
        };
        this.GetServerByServerId = (server_id) => {
            let data = null;
            if (this.server_data) {
                let server_dic;
                for (let area in this.server_data) {
                    server_dic = this.server_data[area];
                    let v;
                    for (let id in server_dic) {
                        v = server_dic[id];
                        if (v && local_Number(v.id) == local_Number(server_id)) {
                            data = v;
                            break;
                        }
                    }
                }
            }
            return data;
        };
        this.FilterServerData = (server_data) => {
            let player_login_info = local_LoginModel_Instance.player_login_info;
            let need_delete = [];
            if (server_data) {
                for (let k in server_data) {
                    let v = server_data[k];
                    if (v) {
                        if (local_Number(v.num) < local_Number(player_login_info.display_num)) {
                            delete server_data[k];
                            need_delete.push(k);
                        }
                        else if (!ClientConfig.plat_belong && v["belong"] != "") {
                            delete server_data[k];
                            need_delete.push(k);
                        }
                    }
                }
            }
            if (!local_Util.IsTableEmpty(this.recommend_data)) {
                for (let id in this.recommend_data) {
                    for (let k of need_delete) {
                        if (local_Number(k) == local_Number(id)) {
                            delete this.recommend_data[id];
                        }
                    }
                }
            }
            if (player_login_info && player_login_info.player_server)
                if (!local_Util.IsTableEmpty(player_login_info.player_server)) {
                    let delete_list = [];
                    for (let id in player_login_info.player_server) {
                        let info = player_login_info.player_server[id];
                        for (let k of need_delete) {
                            if (local_Number(k) == local_Number(info.server_id) || !info.role_id || info.role_id == 1)
                                delete_list.push(id);
                        }
                    }
                    let delete_index = 0;
                    for (let index in delete_list) {
                        let delete_id = delete_list[index];
                        delete_id -= delete_index;
                        player_login_info.player_server.splice(delete_id, 1);
                        delete_index++;
                    }
                }
            if (player_login_info && player_login_info.last) {
                for (let k in need_delete) {
                    if (local_Number(k) == local_Number(player_login_info.last)) {
                        player_login_info.last = "";
                        break;
                    }
                }
            }
            // egret.log("filter server data:", server_data)
        };
        this.InitServerArea = () => {
            let player_login_info = local_LoginModel_Instance.player_login_info;
            let disable_area_list;
            let disable_data = player_login_info.disable_area_num;
            if (disable_data && disable_data != "" && local_Number(disable_data) != 0)
                disable_area_list = disable_data.split(",");
            let is_disable_area = (area) => {
                if (!disable_area_list)
                    return false;
                for (let key in disable_area_list) {
                    let disable_area = disable_area_list[key];
                    if (local_Number(disable_area) == local_Number(area))
                        return true;
                }
                return false;
            };
            let areas_data = this.areas_data;
            let playerInfo = LoginManager.GetInstance().GetPlatUserInfo();
            if (areas_data) {
                let index = 0;
                for (let k in areas_data) {
                    let v = areas_data[k];
                    if (v) {
                        if (local_Number(v.num) < local_Number(player_login_info.display_area_num)) {
                            delete areas_data[k];
                        }
                        else if (is_disable_area(v.num)) {
                            delete areas_data[k];
                        }
                    }
                }
                for (let k in areas_data) {
                    let v = areas_data[k];
                    if (v) {
                        if (playerInfo.create_time > v.otime && v.otime != 0) {
                            delete areas_data[k];
                        }
                    }
                }
            }
        };
        this.GetRecommendServer = () => {
            let recommend_data = this.recommend_data, server_data = this.server_data;
            if (!local_Util.IsTableEmpty(recommend_data)) {
                let max_id = 0;
                let count = 0;
                let index = local_Util.RandomRange(1, local_Util.TableSize(recommend_data));
                for (let id in recommend_data) {
                    count = count + 1;
                    if (count == index) {
                        max_id = local_Number(id);
                        break;
                    }
                }
                if (max_id > 0)
                    return max_id;
            }
            if (server_data) {
                let dic;
                for (let area_id in server_data) {
                    let dic = server_data[area_id];
                    if (dic)
                        for (let server_id in dic)
                            return server_id;
                }
            }
        };
        this.CheckServerState = (server_id, call_back) => {
            let server_data = this.GetServerByServerId(local_Number(server_id));
            if (!server_data) {
                let history_login_info = this.GetHistoryLoginInfo();
                if (history_login_info) {
                    for (let data of history_login_info) {
                        if (data.server_id == server_id) {
                            server_data = data;
                            break;
                        }
                    }
                }
            }
            let func = (state) => {
                let ok_callback = () => {
                    // if (window["wx"] && local_Util.IsWXGame()) {
                    // 	window["wx"].exitMiniProgram();
                    // } else if (window["hbs"]) {
                    // 	window["hbs"].exitApplication({
                    // 		success: function () {
                    // 		},
                    // 		fail: function () {
                    // 		},
                    // 		complete: function () {
                    // 		}
                    // 	});
                    // } else {
                    // 	window.location.reload()
                    // }
                };
                let Alert = window["Alert"]
                let Alert_Type = window["Alert_Type"]
                if (!state) {
                    let str = "服务器维护中，请稍后再进入";
                    if (server_data.close_desc && server_data.close_desc.trim() != "") {
                        str = server_data.close_desc;
                    }
                    
                    Alert.Show(str, Alert_Type.One, ok_callback, null, "确定");
                }
                else {
                    if (ClientConfig.close_channel) {
                        let str = ClientConfig.channel_close_detail ? ClientConfig.channel_close_detail : "本应用暂不可用，请稍后再试";
                        Alert.Show(str, Alert_Type.One, ok_callback, null, "确定");
                    }
                    else {
                        // call_back()
                        this.SelectServerFun(call_back);
                    }
                }
            };
            // let now_player_id = local_LoginModel_Instance.player_login_info["id"]
            // let now_time = String(Math.floor(new Date().getTime() / 1000))
            // let now_method = "get_server_info"
            // let now_sign = md5.hex_md5(String(ClientConfig.login_key + now_time + now_method)).toLowerCase()
            // let get_param = {
            // 	"id": server_id,
            // 	"player_id": now_player_id,
            // 	"method": now_method,
            // 	"time": now_time,
            // 	"sign": now_sign,
            // 	"token": PlatformManager.GetInstance().get_server_info_token
            // }
            // let call_func = (state, error, data) => {
            // 	if (state) {
            // 		let info = local_JSON.parse(data)
            // 		if (info && local_Number(info["closed"]) == 1)
            // 			func(false)
            // 		return
            // 	}
            // 	func(true)
            // }
            // let check_server_state = () => {
            // 	HttpUtil.HttpGetRequest(ClientConfig.login_php, get_param, call_func)
            // }
            if (server_data) {
                let allow_status = local_LoginModel_Instance.player_login_info ? local_LoginModel_Instance.player_login_info.allow_status : 0;
                console.log("---server_data----"+server_data)
                console.log("---server_data.closed----"+server_data.closed)
                console.log("---player_login_info----"+local_LoginModel_Instance.player_login_info)
                console.log("---allow_status----"+allow_status)
                if (local_Number(server_data.closed) == 1 && local_Number(allow_status) == 0) {
                    // check_server_state()
                    func(false);
                }
                else
                    func(true);
            }
        };
        this.SelectServerFun = (call_back) => {
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
                ) {
                if (ResVersionManager.wx_cdn_config_url && ResVersionManager.wx_alpha_version) {
                    HttpUtil.HttpLoadJson(ResVersionManager.base_cdn_config_url, ResVersionManager.wx_cdn_config_url + "?v=" + Math.random(), (cdn_cfg) => {
                        if (cdn_cfg) {
                            // cdn_cfg = JSON.parse(cdn_cfg);
                            if (ResVersionManager.wx_alpha_version != cdn_cfg.wx_alpha_version) {
                                let str = "您好，检查到游戏版本有更新，建议您退出游戏后重新登录。";
                                let Alert = window["Alert"]
                                let Alert_Type = window["Alert_Type"]
                                Alert.Show(str, Alert_Type.One, () => {
                                   PlatformManager.GetInstance().exitMiniProgram()
                                }, null, "确定");
                            }
                            else {
                                call_back();
                            }
                        }
                        else {
                            call_back();
                        }
                    }, 10000, ResVersionManager.backup_cdn_config_url);
                }
                else {
                    call_back();
                }
            }
            else {
                let ResUrl = ResManager.GetInstance().cdn_res_path
                let BackUpUrl = ClientConfig && ClientConfig.BackUpUrl
                if(!BackUpUrl){
                    BackUpUrl = ResUrl
                }
                HttpUtil.HttpLoadJson(ResUrl, 'resource/game_manul_version.json?v=' + Math.random(), (json_obj) => {
                    if (json_obj) {
                        let start_connect = true;
                        // json_obj = JSON.parse(json_obj);
                        if (ResVersionManager.main_version != null && ResVersionManager.main_version != null) {
                            //版本不一致  就要重新刷游戏
                            // Message.show(ResVersionManager.main_version +"_"+ json_obj.main_version +"_"+ ResVersionManager.hot_update_version +"_"+ json_obj.hot_update_version)
                            if (ResVersionManager.main_version != json_obj.main_version || ResVersionManager.hot_update_version != json_obj.hot_update_version) {
                                let str = `您好，检查到游戏版本有更新，是否重新登录游戏(${ResVersionManager.main_version}/${json_obj.main_version} ${ResVersionManager.hot_update_version}/${json_obj.hot_update_version})`;
                                let Alert = window["Alert"]
                                let Alert_Type = window["Alert_Type"]
                                Alert.Show(str, Alert_Type.One, () => {
                                    window.location.reload();
                                }, null, "确定");
                            }
                            else {
                                call_back();
                            }
                        }
                        else {
                            call_back();
                        }
                    }
                    else {
                        call_back();
                    }
                }, 10 ,BackUpUrl);
            }
        };

        this.GetLocation = () => {
            let cache_location = CookieWrapper.GetInstance().GetCookie(CookieWrapper.BASE_LOCATION_CACHE, false);
            if (cache_location != null) {
                return Number(cache_location);
            }
            return this.base_location;
        };

        this.FormatAccountUrl = (location) => {
            if (location && this.location_info_cfg) {
                let location_cfg = this.location_info_cfg[location];
                console.warn("--------------FormatAccountUrl", location_cfg, location);
                if (location_cfg && !ClientConfig.not_use_big_area_type) { //not_use_big_area_type是否使用大区模式，替换相关路径
                    ClientConfig.server_version = ClientConfig.server_version.replace(ClientConfig.url_account_path, location_cfg.url_account_path);
                    ClientConfig.simplify_server_file = ClientConfig.simplify_server_file.replace(ClientConfig.url_account_path, location_cfg.url_account_path);
                    ClientConfig.server_file = ClientConfig.server_file.replace(ClientConfig.url_account_path, location_cfg.url_account_path);
                    ClientConfig.login_php = ClientConfig.login_php.replace(ClientConfig.url_account_path, location_cfg.url_account_path);
                    ClientConfig.url_account_path = location_cfg.url_account_path;
                    ClientConfig.backurl_account_path = location_cfg.url_account_path;
                }
            }
        };
        this.LocaltionRequestPlayerLoginInfo = (localtion) => {
            let local_LoginManager_Instance = LoginManager.GetInstance();
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
                "accname": LoginModel.GetInstance().account_id,
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
                "site": plat_name,
                "idfa": idfa,
                "device_id": device_id,
                "os": os_type
            };
            let player_login_info = local_LoginModel_Instance.player_login_info
            let token = (player_login_info && player_login_info.token) ? player_login_info.token : (local_LoginModel_Instance.token || ClientConfig.login_token)
            if(token)
            {
                get_param["token"] = token
            }
            let connect_state = false;
            let connect_error = () => {
                if (connect_state)
                    return;
                connect_state = true;
                let exit_func = () => {
                    GlobalEventSystem.Fire(EventName.CHANGE_ACCOUNT);
                };
                let text = "Network error, please try again later";
                let Alert = window["Alert"]
                let Alert_Type = window["Alert_Type"]
                Alert.Show(text, Alert_Type.One, exit_func, null, "Confirm", null, null, true);
            };
            let retry_count = 0;
            let login_php = ClientConfig.login_php;
            let call_func = (data) => {
                if (data) {
                    if(localtion != ServerModel.GetInstance().cur_selected_location) return
                    let Message = window["Message"]
                    connect_state = true;
                    console.warn("PlayerLogin  state, error, data------------" + data);
                    let info;
                    try {
                        info = JSON.parse(data);
                    }
                    catch (e) {
                        GameError.GetInstance().SendErrorToPHP("Server verification error, please refresh the game", true);
                        if (!local_Util.IsMiniGame()) {
                            window.location.reload();
                        }
                        else {
                            info = null;
                        }
                    }
                    if (!info) {
                        if (retry_count < 3) {
                            Message.show("Server verification timeout, resending the request");
                            retry_count = retry_count + 1;
                            HttpUtil.HttpGetRequest(login_php, get_param, call_func);
                        }
                        else {
                            Message.show("Server verification error, please relogin");
                            // local_GlobalEventSystem.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, local_Enum_LoginState.Login)
                        }
                        return;
                    }
                    if (info && local_Number(info["ret"]) == 0) {
                        //解析获取角色服务器等信息
                        console.warn("解析获取角色服务器等信息++++++LoginWinState++++++", JSON.stringify(info));
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.PLAYER_LOGIN_INFO, info);
                        let Enum_LoginState = window["Enum_LoginState"]
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.SimplifyServer);
                    }
                    else {
                        Message.show("Failed to login, please try again error code:" + info["ret"]);
                    }
                }
                else {
                    connect_error();
                }
            };
            console.warn("request------------PlayerLogin-----:", JSON.stringify(get_param), login_php);
            HttpUtil.HttpGetRequest(login_php, get_param, call_func);
        };

        this.IsLocationMode = () =>{
            return PlatformManager.IsEyouEnPlatform()
        }
    }
    public static GetInstance() {
        if (!ServerModel.Instance) {
            ServerModel.Instance = new ServerModel();
        }
        return ServerModel.Instance;
    }
}

window["ServerModel"] = ServerModel