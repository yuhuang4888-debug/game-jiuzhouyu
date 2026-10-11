import { EventDispatcher } from "../util/EventDispatcher";
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar";
import { EventName, LoginStateEvent } from "../common/EventName";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { LoginModel } from "./LoginModel";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { PlatformManager } from "../PlatformManager";
import { ServerModel } from "./ServerModel";
import { AppConst } from "../common/AppConst";
import { Util, DEVICE_OS } from "../util/Util";
import { ResManager } from "../common/ResManager";
import { md5 } from "../util/md5";
import { Base64 } from "../util/Base64";
import { HttpUtil } from "../util/HttpUtil";
import { GameError } from "../util/GameError";
import { CookieWrapper } from "../common/CookieWrapper";
import { GameResPath } from "../util/GameResPath";
export class LoginManager extends EventDispatcher {
    static Instance: LoginManager;
    Init;
    GetCurServerId;
    SetCurServerId;
    GetCurServer2Location;
    StartAccountLogin;
    InitLoginStateManager;
    RemoveLoginStateManager;
    GetPlatUserInfo;
    RecordRoleData;
    SentRoleLoginServer;
    IsNewPlayer;
    IsInLoginProcess;
    ReconectAccountLogin;
    SelectDefaultServer;
    RequestTestServerData;
    SetGameStartReceiveFlag
    ResetGameStartReceiveFlag
    InitGameResceuveFlag
    GetVideoUrl

    swtich_account_user_id;
    account;
    password;
    game_start_reveive_flag
    try_game_start = true

    /**是否等待创角视频播放 */
    is_wait_video = false
    /**当前服务器ID */
    cur_server_id_
    /**
     * 当前服务器对应的地区(地区模式选服会用到)
     */
    cur_server_id_2_location
    /**
     * 登录流程状态机
     */
    login_state_manager
    public constructor() {
        super();
        let local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            local_UserMsgAdapter_Instance = UserMsgAdapter.GetInstance(),
            local_LoginStateEvent = LoginStateEvent,
            local_LoginModel = LoginModel,
            local_LoginModel_Instance = LoginModel.GetInstance(),
            local_PlatformManager_Instance = PlatformManager.GetInstance(),
            local_ServerModel_Instance = ServerModel.GetInstance(),
            local_AppConst = AppConst,
            local_Util = Util
            
        this.Init = () => {

            this.Bind(local_LoginStateEvent.SHOW_LOGIN_BG_FIRST, () => {
                if (local_LoginModel_Instance.reconnect_on_game) {
                    this.Fire(local_LoginStateEvent.START_LOGIN_MODULE)
                }
                else {
                    this.InitLoginStateManager();
                    this.Fire(local_LoginStateEvent.CLOSE_VIEW, "LoginEnterView")
                    this.Fire(local_LoginStateEvent.OPEN_VIEW, "LoginBgView")
                }
            });

            this.Bind(local_LoginStateEvent.START_LOGIN_MODULE, () => {
                PlatformManager.GetInstance().ShowTestInfo("LoginController open_bg_view++++++++");
                if (local_LoginModel.ConfigDebugIpList.ip_list == null || local_LoginModel.ConfigDebugIpList.ip_list.length == 0) {
                    ClientConfig.account_server = 1;
                }
                PlatformManager.GetInstance().ShowTestInfo("LoginController ShowLoginView++++++++:" + ClientConfig.account_server);

                if (ClientConfig.account_server) {
                    if (local_LoginModel_Instance.reconnect_on_game && local_LoginModel_Instance.player_login_info && this.GetCurServerId()) {
                        this.ReconectAccountLogin();
                    }
                    else {
                        this.StartAccountLogin();
                    }
                }
                else {
                    this.Fire(LoginStateEvent.OPEN_VIEW, "AccountView");
                }
            });

            this.Bind(local_LoginStateEvent.PLAYER_LOGIN_INFO, (player_login_info) => {
                local_LoginModel_Instance.player_login_info = player_login_info;
            });
            this.Bind(local_LoginStateEvent.CHANGE_CUR_SERVER_ID, (name, id) => {
                this.SetCurServerId(id);
            });
            this.Bind(local_LoginStateEvent.SIMPLIFY_SERVER_INFO, (info) => {
                local_ServerModel_Instance.areas_data = info.areas;
                local_ServerModel_Instance.recommend_data = info.recommend || [];
                local_ServerModel_Instance.InitServerArea();
                let server_data = local_ServerModel_Instance.server_data;
                if (!server_data) {
                    server_data = {};
                    local_ServerModel_Instance.server_data = server_data;
                }
                local_ServerModel_Instance.FilterServerData(info.server);
                let data;
                for (let server_id in info.server) {
                    data = info.server[server_id];
                    if (!server_data[data.area]) {
                        server_data[data.area] = {};
                    }
                    server_data[data.area][server_id] = data;
                }
                if (!this.cur_server_id_) {
                    this.SelectDefaultServer();
                }
                this.Fire(local_LoginStateEvent.UPDATE_SELECT_SERVER_VIEW);
            });
            this.Bind(local_LoginStateEvent.SERVER_LIST_INFO, (area, info) => {
                let server_data = local_ServerModel_Instance.server_data;
                if (!server_data) {
                    server_data = {};
                    local_ServerModel_Instance.server_data = server_data;
                }
                local_ServerModel_Instance.FilterServerData(info);
                server_data[area] = info;
                this.Fire(local_LoginStateEvent.UPDATE_SELECT_SERVER_VIEW, area);
            });
            this.Bind(local_LoginStateEvent.PLAYER_SERVER_INFO, (server_info) => {
                local_AppConst.SocketPort = Number(server_info["port"]) || 0;
                local_AppConst.SslSocketPort = Number(server_info["sslport"]) || 0;
                local_AppConst.SocketAddress = server_info["host"];
                local_AppConst.SocketLburl = server_info["lburl"];
                console.warn("-------------AppConst.SocketLburl =" + local_AppConst.SocketLburl);
                local_LoginModel_Instance.account_id = server_info["accname"];
                local_LoginModel_Instance.pid = server_info["pid"];
                local_LoginModel_Instance.time_stamp = server_info["time"];
            });
            //返回登录
            let on_back_login = () => {
                if (Util.IsConch() || (ClientConfig && ClientConfig.need_recall_login)) {
                    local_LoginModel_Instance.wait_show_account_view = true;
                    local_LoginModel_Instance.wait_view_open = true
                    GlobalEventSystem.Fire(EventName.SWTICH_SERVER_ID);
                    return;
                }
                let SceneManager = window["SceneManager"]
                if (SceneManager) {
                    SceneManager.GetInstance().can_receive_scene_protocal = false;
                }
                if (window["Scene"] && window["Scene"].Instance) {
                    if (window["SceneManager"]) {
                        window["SceneManager"].GetInstance().ClearAllVo()
                        if (window['MapManager']) {
                            window['MapManager'].GetInstance().UnRegiestEffectList(window["SceneManager"].GetInstance().GetSceneId())
                        }
                    }
                    window["Scene"].Instance.ClearScene()
                }
                ResManager.GetInstance().true_game_start = false;
                this.RecordRoleData();
                // if(window["wx"])
                // {
                //     // window["wx"].exitMiniProgram();
                //     // window["wx"].getUpdateManager().onCheckForUpdate(function (res) {
                //     // // 请求完新版本信息的回调
                //     //     local_Message.show("has update")
                //     //     local_egret.log(res.hasUpdate)
                //     // })
                //     // window["wx"].getUpdateManager().onUpdateReady(function () {
                //     //     window["wx"].getUpdateManager().applyUpdate();
                //     // })
                // }else
                // {
                //     window.location.reload()
                // }
                local_LoginModel_Instance.reconnect_on_game = false;
                local_LoginModel_Instance.is_back_from_game = true
                local_LoginModel_Instance.account_data_10000 = null
                local_UserMsgAdapter_Instance.CloseSocket();

                local_LoginModel_Instance.wait_show_account_view = true;
                local_LoginModel_Instance.wait_view_open = true


                this.RemoveLoginStateManager();
                if (window["ActivityIconManager"]) {
                    window["ActivityIconManager"].GetInstance().DeleteAllIcon()
                }
                this.Fire(LoginStateEvent.SHOW_LOGIN_BG_FIRST);
            };
            local_GlobalEventSystem.Bind(local_EventName.CHANGE_ACCOUNT, on_back_login);

            //切换角色
            let on_change_role = () => {
                if (Util.IsConch() || (ClientConfig && ClientConfig.need_recall_login)) {
                    local_LoginModel_Instance.wait_request_into_role = true;
                    local_LoginModel_Instance.wait_view_open = true
                    GlobalEventSystem.Fire(EventName.SWTICH_SERVER_ID);
                    return;
                }
                let SceneManager = window["SceneManager"]
                if (SceneManager) {
                    SceneManager.GetInstance().can_receive_scene_protocal = false;
                }
                if (window["Scene"] && window["Scene"].Instance) {
                    if (window["SceneManager"]) {
                        window["SceneManager"].GetInstance().ClearAllVo()
                        if (window['MapManager']) {
                            window['MapManager'].GetInstance().UnRegiestEffectList(window["SceneManager"].GetInstance().GetSceneId())
                        }
                    }
                    window["Scene"].Instance.ClearScene()
                }
                ResManager.GetInstance().true_game_start = false;
                this.RecordRoleData();
                // if(window["wx"])
                // {
                //     // window["wx"].exitMiniProgram();
                //     // window["wx"].getUpdateManager().onCheckForUpdate(function (res) {
                //     // // 请求完新版本信息的回调
                //     //     local_Message.show("has update")
                //     //     local_egret.log(res.hasUpdate)
                //     // })
                //     // window["wx"].getUpdateManager().onUpdateReady(function () {
                //     //     window["wx"].getUpdateManager().applyUpdate();
                //     // })
                // }else
                // {
                //     window.location.reload()
                // }
                local_LoginModel_Instance.reconnect_on_game = false;
                local_LoginModel_Instance.is_back_from_game = true
                local_LoginModel_Instance.account_data_10000 = null
                local_UserMsgAdapter_Instance.CloseSocket();

                local_LoginModel_Instance.wait_request_into_role = true;
                local_LoginModel_Instance.wait_view_open = true

                this.RemoveLoginStateManager();
                if (window["ActivityIconManager"]) {
                    window["ActivityIconManager"].GetInstance().DeleteAllIcon()
                }
                this.Fire(LoginStateEvent.SHOW_LOGIN_BG_FIRST);

            };
            local_GlobalEventSystem.Bind(local_EventName.CHANGE_ROLE, on_change_role);

            //通过游戏平台的浮标，切换账号
            this.Bind(local_LoginStateEvent.SDK_LOGIN_CALL_BACK_SUCCESS, (user_id, sdk_server) => {
                if (sdk_server == 0) { //内网测试用
                    this.swtich_account_user_id = 11111111;
                    GlobalEventSystem.Fire(EventName.SWTICH_SERVER_ID);
                }
                else {
                    if (user_id) {
                        this.swtich_account_user_id = user_id;
                        GlobalEventSystem.Fire(EventName.SWTICH_SERVER_ID);
                    }
                }
            });
        };

        //开启登录流程
        this.StartAccountLogin = () => {
            PlatformManager.GetInstance().ShowTestInfo("LoginController StartAccountLogin++++++++");
            this.InitLoginStateManager();
            let Enum_LoginState = window["Enum_LoginState"]
            this.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.Login);
        };

        //开启登录流程
        this.ReconectAccountLogin = () => {
            this.InitLoginStateManager();
            let Enum_LoginState = window["Enum_LoginState"]
            this.Fire(local_LoginStateEvent.LOGIN_STATE_CHANGE, Enum_LoginState.ServerWin);
        };
        this.InitLoginStateManager = () => {
            if (!this.login_state_manager) {
                let LoginStateManager = window["LoginStateManager"]
                this.login_state_manager = new LoginStateManager();
            }
        };
        this.RemoveLoginStateManager = () => {
            if (this.login_state_manager) {
                this.login_state_manager.Remove();
                this.login_state_manager.DeleteMe();
                this.login_state_manager = null;
            }
        };
        this.GetPlatUserInfo = () => {
            let data: any = {};
            data.server_id = this.GetCurServerId();
            if (local_ServerModel_Instance) {
                data.server_name = local_ServerModel_Instance.GetServerName(data.server_id);
            }
            else {
                data.server_name = "无";
            }
            if (local_LoginModel_Instance) {
                data.account = local_LoginModel_Instance.account_id;
                if (local_LoginModel_Instance.player_login_info) {
                    data.create_time = local_LoginModel_Instance.player_login_info.reg_time;
                    data.role_name = local_LoginModel_Instance.player_login_info.role_name;
                }
            }
            return data;
        };
        this.GetCurServerId = () => {
            return this.cur_server_id_;
        };
        this.SetCurServerId = (cur_server_id) => {
            this.cur_server_id_ = cur_server_id;
            this.cur_server_id_2_location = ServerModel.GetInstance().cur_selected_location;
        };
        this.GetCurServer2Location = () => {
            return this.cur_server_id_2_location;
        };
        this.RecordRoleData = () => {

            if (!ClientConfig.account_server)
                return;
            let RoleManager = window["RoleManager"]
            if (!RoleManager)
                return;
            let role_info = RoleManager.GetInstance().mainRoleInfo;
            if (!role_info)
                return;
            if (!local_LoginModel_Instance.player_login_info)
                return;
            let login_key = ClientConfig.login_key;
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "player_server";
            let now_sign = (md5.hex_md5(login_key + now_time + now_method)).toLowerCase();
            let role_name = role_info.name;
            if (Util.IsMTGame()) {
                role_name = Base64.encode(JSON.stringify(role_name));
            }
            let local_role_id = role_info.role_id
            let is_server_cache = 1
            if (PlatformManager.NeedBaseServerIdPlatform()) {
                if (!PlatformManager.GetInstance().GetBaseServerId(local_role_id)) {
                    is_server_cache = 0
                }
            }



            let get_param = {
                "server_id": this.GetCurServerId(),
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
                "id": local_LoginModel_Instance.player_login_info["id"],
                "lv": role_info.level || 1,
                "career": role_info.career,
                "nickname": role_name,
                "role_id": local_role_id,
                "is_server_cache": is_server_cache
            };


            let call_func = function (state, error, data) {
                if (state) {
                    if (PlatformManager.NeedBaseServerIdPlatform()) {
                        state = JSON.parse(state)
                        if (state.sid) {
                            let role_id_2_base_server_id_dic = PlatformManager.GetInstance().role_id_2_base_server_id_dic
                            if (!role_id_2_base_server_id_dic) {
                                role_id_2_base_server_id_dic = {}
                            }
                            role_id_2_base_server_id_dic[local_role_id] = state.sid
                            window['CookieWrapper'].GetInstance().SaveCookie(window['CookieWrapper'].CACHE_BASE_SERVER_ID, JSON.stringify(role_id_2_base_server_id_dic), false);
                            //存起来后重新触发数据上报
                            if (local_LoginModel_Instance.is_new_career) {
                                PlatformManager.GetInstance().CreateRoleDataPost(local_role_id, 1)
                            }
                            PlatformManager.GetInstance().DataPost(1)
                            PlatformManager.GetInstance().DataPost(2)
                        }
                        console.log("----RecordRoleServer Succeed----+++++++++");
                    }
                }
            };
            HttpUtil.HttpGetRequest(ClientConfig.login_php, get_param, call_func);
        };
        this.SentRoleLoginServer = () => {
            if (!ClientConfig.account_server) {
                return;
            }
            let call_func = (state, error, data) => {
                if (state) {
                    console.log("----SentRoleLoginServer Succeed----++++");
                }
            };
            let now_time = String(Math.floor(new Date().getTime() / 1000));
            let now_method = "last_login_server_update";
            let now_sign = (md5.hex_md5(ClientConfig.login_key + now_time + now_method)).toLowerCase();
            let get_param = {
                sid: this.GetCurServerId(),
                method: now_method,
                time: now_time,
                sign: now_sign,
                player_id: local_LoginModel_Instance.player_login_info["id"]
            };
            HttpUtil.HttpGetRequest(ClientConfig.login_php, get_param, call_func);
        };
        //新玩家
        this.IsNewPlayer = () => {
            let player_login_info = local_LoginModel_Instance.player_login_info;
            return player_login_info && player_login_info.last == 0;
        };
        //是否处于登录流程
        this.IsInLoginProcess = () => {
            return this.login_state_manager;
        };
        this.SelectDefaultServer = () => {
            if (this.IsNewPlayer() || local_PlatformManager_Instance.is_wx_alpha) {
                this.Fire(local_LoginStateEvent.CHANGE_CUR_SERVER_ID, null, local_ServerModel_Instance.GetRecommendServer());
            }
            else
                this.Fire(local_LoginStateEvent.CHANGE_CUR_SERVER_ID, null, local_ServerModel_Instance.GetLastServerId());
        };
        this.RequestTestServerData = () => {
            let device_id = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_DEVICE_ID, false)
            if (!device_id) {
                device_id = Util.RandomDeviceId()
                CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LOCAL_DEVICE_ID, device_id, false)
            }
            // let device_id = local_PlatformManager_Instance.gdevice;
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
                "accname": local_LoginModel_Instance.account_id,
                "method": now_method,
                "time": now_time,
                "sign": now_sign,
                "site": plat_name,
                "idfa": idfa,
                "device_id": device_id,
                "os": os_type
            };
            let login_php = ClientConfig.login_php;
            let call_func = (data) => {
                if (data) {
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
                    }
                    if (info && Number(info["ret"]) == 0) {
                        local_LoginModel_Instance.SetTestServerData(info.testname, info.testotime);
                        // local_LoginModel_Instance.SetTestServerData("永夜开发",Math.floor(new Date().getTime() / 1000) + 60)
                    }
                    else {
                    }
                }
            };
            HttpUtil.HttpGetRequest(login_php, get_param, call_func);
        };

        this.SetGameStartReceiveFlag = (request_name, value) => {
            this.game_start_reveive_flag[request_name] = value
            for (let name in this.game_start_reveive_flag) {
                if (this.game_start_reveive_flag[name] == false) {
                    return
                }
            }
            if (this.try_game_start) {
                this.try_game_start = false
                if (local_LoginModel_Instance.reconnect_on_game) {
                    GlobalEventSystem.Fire(EventName.PRELOAD_LOADING_COMPLETED)
                }
                else {
                    if (this.is_wait_video) {
                        if (ClientConfig && ClientConfig["is_open_elim"]) {
                            GlobalEventSystem.Fire(EventName.OPEN_VIEW, "ElimMainView")
                        } else if (ClientConfig && ClientConfig["is_open_video"]) {
                            LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginCreatRoleVideoView");
                        } else {
                            LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginLoadingView");
                        }

                    } else {
                        LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginLoadingView");
                    }
                }
            }
        }

        this.ResetGameStartReceiveFlag = () => {
            for (let name in this.game_start_reveive_flag) {
                this.game_start_reveive_flag[name] = false
            }
        }

        this.InitGameResceuveFlag = () => {
            this.game_start_reveive_flag = {}
            this.game_start_reveive_flag["13001"] = false
            this.game_start_reveive_flag["10201"] = false
            this.game_start_reveive_flag["30005"] = false
            this.game_start_reveive_flag["13088@300@1"] = false
            this.game_start_reveive_flag["10202@3"] = false
        }

        this.GetVideoUrl = () => {
            let name_ = ""
            if (ClientConfig && ClientConfig["video_name"]) {
                name_ = ClientConfig["video_name"]
            }

            let url = `${ResManager.GetInstance().cdn_res_path}${GameResPath.GetVideoPath(name_)}`
            return url
        }

        this.Init();
        this.InitGameResceuveFlag()
    }
    public static GetInstance() {
        if (!LoginManager.Instance) {
            LoginManager.Instance = new LoginManager();
        }
        return LoginManager.Instance;
    }
}

window["LoginManager"] = LoginManager