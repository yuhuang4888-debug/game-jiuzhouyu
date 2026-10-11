import { BaseController } from "../common/BaseController";
import { LoginModel } from "./LoginModel";
import { LoginManager } from "./LoginManager";
import { PlatformManager } from "../PlatformManager";
import { GlobalEventSystem, ClientConfig } from "../util/DeclareGlobalVar";
import { EventName, LoginStateEvent } from "../common/EventName";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { ServerModel } from "./ServerModel";
import { Message } from "../sysInfo/SysInfoController";
import { Alert, Alert_Type } from "../alert/Alert";
import { Config } from "../common/Config";
import { TimeUtil } from "../util/TimeUtil";
import { ResManager } from "../common/ResManager";
import { FigureProtoVo } from "../common/FigureProtoVo";
import { CookieWrapper } from "../common/CookieWrapper";
import { GlobalTimerQuest, Util } from "../util/Util";
import { HashObject } from "../common/BaseClass";
import { Enum_UILayer, LayerManager } from "../common/LayerManager";
import { UIEffect } from "../common/UIEffect";
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel";
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager";

import "./AccountView";
import "./LoginBgView";
import "./LoginCreateRoleView";
import "./LoginCreateRoleItem";
import "./LoginSelectRoleItem";
import "./LoginSelectRoleView";
import "./LoginLoadingView";
import "./LoginStateManager"
import "./LoginSelectServerItem";
import "./LoginSelectServerTabItem";
import "./LoginSelectServerView";
import "./LoginEnterView";
import "./LoginAlertView";
import "./LoginView";
import "./RegisterView";
import "./LoginCreatRoleVideoView";

export class LoginController extends BaseController {
    static Instance: LoginController;
    InitEvents;
    InitInfo;
    public constructor() {
        super();
        let local_LoginModel_Instance = LoginModel.GetInstance(),
            local_LoginManager_Instance = LoginManager.GetInstance(),
            local_PlatformManager = PlatformManager,
            local_PlatformManager_Instance = PlatformManager.GetInstance(),
            local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName,
            local_LoginStateEvent = LoginStateEvent,
            local_UserMsgAdapter_Instance = UserMsgAdapter.GetInstance(),
            local_ServerModel_Instance = ServerModel.GetInstance(),
            local_Message = Message,
            local_Alert = Alert,
            local_Alert_Type = Alert_Type,
            delay_timer_10006_,
            delay_timer_59004_,
            view_dic_,
            clickEffectObj_: UIEffect;

        this.InitEvents = () => {
            let loading_circle = new HashObject();
            //初始化 请求连接socket
            local_LoginManager_Instance.Bind(local_LoginStateEvent.START_GAME_CONNECT, (not_check) => {
                let call_back = () => {
                    local_GlobalEventSystem.Fire(local_EventName.SHOW_WAITFOR_OPENVIEW_LOADING, loading_circle.hashCode);
                    local_UserMsgAdapter_Instance.ConnectSocket();
                };
                let cur_server_id = local_LoginManager_Instance.GetCurServerId();
                if (!not_check && cur_server_id) {
                    local_ServerModel_Instance.CheckServerState(cur_server_id, call_back);
                }
                else {
                    call_back();
                }
            });
            //socket 已连接 请求 帐号登录
            local_GlobalEventSystem.Bind(local_EventName.GAME_CONNECT, async () => {
                if (!Config.load_protocal_config_promise)
                    return;
                await Config.load_protocal_config_promise;
                local_GlobalEventSystem.Fire(local_EventName.HIDE_WAITFOR_OPENVIEW_LOADING, loading_circle.hashCode);
                local_PlatformManager_Instance.DataPlacement(50000);
                let pid = Number(local_LoginModel_Instance.pid);
                let time_stamp = local_LoginModel_Instance.time_stamp || String(Math.floor(new Date().getTime() / 1000));
                let account_id = local_LoginModel_Instance.account_id.toString();
                let plat_name = local_LoginModel_Instance.plat_name || ClientConfig.plat_name;
                if (local_LoginModel_Instance.login_channel) {
                    plat_name += "_" + local_LoginModel_Instance.login_channel;
                }
                this.SendFmtToGame(10000, "iiss", pid, time_stamp, account_id, plat_name);
                local_LoginManager_Instance.SentRoleLoginServer();
            });
            //GAME_START
            local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
                ViewPopLevelModel.GetInstance().ClearView();
                let sent_role_info = () => {
                    local_LoginManager_Instance.RecordRoleData();
                };
                //防止游戏进入前预加载两次 进入游戏后把开关初始化，为下一次预加载做准备
                LoginModel.GetInstance().is_preload = false
                GlobalTimerQuest.AddDelayQuest(sent_role_info, 3);
                local_LoginManager_Instance.Fire(LoginStateEvent.CLOSE_VIEW, "LoginSelectRoleView");
                local_LoginManager_Instance.Fire(LoginStateEvent.CLOSE_VIEW, "LoginCreateRoleView");
                local_LoginManager_Instance.Fire(LoginStateEvent.CLOSE_VIEW, "LoginBgView");


                PlatformManager.GetInstance().ResetAPKShourtcut()
                PlatformManager.GetInstance().CheckSaveAPKShourtcutState()
            });
            //-------------------------------------------------------------------------------------
            //请求创建角色
            local_LoginManager_Instance.Bind(local_LoginStateEvent.TRY_CREATE_ROLE, (role_name: string, career: number, sex: number) => {
                local_LoginModel_Instance.new_select_sex = career;
                local_LoginModel_Instance.new_select_name = role_name;
                let play_name = local_LoginModel_Instance.plat_name || ClientConfig.plat_name;
                let inviter_id = local_LoginModel_Instance.GetInviteRoleId();
                //渠道账号
                let plat_account = ""
                let ta_distinct_id = PlatformManager.GetInstance().GetTaDistinctId()
                let is_simulator = ClientConfig.is_simulator && 1 || 0
                let ta_device_id = PlatformManager.GetInstance().GetTADeviceID()
                this.SendFmtToGame(10003, "cccsslsscscc", 0, career, sex, role_name, play_name, inviter_id, plat_account, ta_distinct_id, is_simulator, ta_device_id, LoginModel.GetInstance().create_role_change_carrer, LoginModel.GetInstance().create_role_change_name);
            });
            //请求进入游戏
            local_LoginManager_Instance.Bind(local_LoginStateEvent.TRY_LOGIN_GAME, (role_id: number) => {
                local_PlatformManager_Instance.DataPlacement(80000);
                if (role_id) {
                    let time_stamp: number = TimeUtil.getServerTime();
                    let plat_name = local_PlatformManager.GetPlatformName() || "";
                    let plat_account = "";
                    let is_whitelist = 0;
                    local_LoginModel_Instance.login_role_id = role_id
                    let ta_distinct_id = PlatformManager.GetInstance().GetTaDistinctId()
                    let is_simulator = ClientConfig.is_simulator && 1 || 0
                    let ta_device_id = PlatformManager.GetInstance().GetTADeviceID()

                    let get_scene = () => {
                        if (!Util.IsWXGame()) return 0
                        if (window["wx"] && window["wx"]["getLaunchOptionsSync"]) {
                            return window["wx"]["getLaunchOptionsSync"]().scene
                        }
                        return 0
                    }

                    this.SendFmtToGame(10004, "lsisisscscsh", role_id, "开发", time_stamp, "", 1, plat_name, plat_account,
                        is_whitelist, ta_distinct_id, is_simulator, ta_device_id, get_scene());
                }
            });
            local_LoginManager_Instance.Bind(local_LoginStateEvent.OPEN_VIEW, async (view_name, ...parms) => {
                if (!view_dic_)
                    view_dic_ = {};
                console.warn("LoginStateEvent.OPEN_VIEW@view_name333", view_name)
                let view: any = view_dic_[view_name];
                if (!view) {
                    let view_class: any = window[view_name];
                    view = new view_class();
                    view_dic_[view_name] = view
                }
                let bool = false;
                if (view_name == "LoginCreateRoleView") {
                    local_PlatformManager_Instance.DataPlacement(70000);
                }
                else if (view_name == "LoginSelectServerView") {
                    local_PlatformManager_Instance.DataPlacement(75000);
                }
                else if (view_name == "LoginEnterView") {
                    bool = true
                }
                else if (view_name == "LoginTestServerTipsView") {
                    let view = view_dic_["LoginEnterView"];
                    if (view == null || !view.HasOpen()) {
                        return;
                    }
                }
                if (view) {
                    if (bool) {
                        if (!view.HasOpen())
                            view.Open(...parms);
                    }
                    else {
                        view.Open(...parms);
                    }
                }
            });
            local_LoginManager_Instance.Bind(local_LoginStateEvent.CLOSE_VIEW, (view_name) => {
                let view = view_dic_ && view_dic_[view_name];
                if (view) {
                    if (view.HasOpen()) {
                        view.Close();
                    }
                    delete view_dic_[view_name];
                }
            });
            let switch_server_fun = () => {
                window["SceneManager"].GetInstance().can_receive_scene_protocal = false;
                ResManager.GetInstance().true_game_start = false;
                local_LoginManager_Instance.RecordRoleData();
                local_LoginModel_Instance.reconnect_on_game = false;
                local_LoginModel_Instance.is_back_from_game = true
                local_LoginModel_Instance.account_data_10000 = null
                local_UserMsgAdapter_Instance.CloseSocket();
                // local_PlatformManager_Instance.NativeLoginOut();
                local_LoginManager_Instance.RemoveLoginStateManager();
                local_LoginManager_Instance.Fire(local_LoginStateEvent.SHOW_LOGIN_BG_FIRST);
            };
            //回到选服界面
            local_GlobalEventSystem.Bind(local_EventName.SWTICH_SERVER_ID, switch_server_fun);

            local_GlobalEventSystem.Bind(local_EventName.HIDE_OR_SHOW_ALL_UI_CANVAS_LAYER, () => {
                let show = !LayerManager.GetInstance().GetLayerVisible(Enum_UILayer.Main, "LoginController");
                LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Main, "LoginController", show)
			    LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.UI, "LoginController", show)
                LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Activity, "LoginController", show)
                LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Top, "LoginController", show)
                LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.Message, "LoginController", show)
                LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.FightingUp, "LoginController", show)
                LayerManager.GetInstance().SetLayerVisible(Enum_UILayer.ClickEffect, "LoginController", show)
            });

            local_LoginManager_Instance.Bind(local_LoginStateEvent.VERIFY_NAME, (name) => {
                this.SendFmtToGameImme(10007, "s", name)
            }
            )
            if (!clickEffectObj_) {
                clickEffectObj_ = new UIEffect()
            }
            let click_effect_gp: Laya.Sprite = new Laya.Sprite()
            let effectLayer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.ClickEffect)
            effectLayer.addChild(click_effect_gp)
            let click_effect_scene = null
            let click_effect_delay_timeout_id = null

            let play_click_effect = (stage) => {
                if (click_effect_delay_timeout_id) {
                    clearTimeout(click_effect_delay_timeout_id)
                    click_effect_delay_timeout_id = null
                }
                if (click_effect_scene)
                    click_effect_scene.active = false
                // if (clickEffectObj_) {
                // 	clickEffectObj_.ClearUIEffect(click_effect_gp)
                // }
                click_effect_gp.width = 256
                click_effect_gp.height = 256
                click_effect_gp.x = stage.stageX - 128
                click_effect_gp.y = stage.stageY - 128
                if (click_effect_scene) {
                    click_effect_gp.visible = true
                    click_effect_scene.active = true
                } else {
                    click_effect_scene = LayerManager.GetInstance().CreateUIScene3D()
                    clickEffectObj_.AddUIEffect("ui_click_1", click_effect_gp, null, 5, null, null, null, null, null, null, null, null, null, null, click_effect_scene)
                }
                click_effect_delay_timeout_id = setTimeout(() => {
                    click_effect_scene.active = false
                    click_effect_gp.visible = false
                    click_effect_delay_timeout_id = null
                }, 2000);

            }
            local_GlobalEventSystem.Bind(EventName.CLICK_EFFECT, play_click_effect)
        };
        /*
    
            协议回调
    
        */
        this.InitInfo = () => {
            let On10000 = () => {
                let [career, time, open_time, count, register_num] = this.ReadFmt("clihi");
                console.log("career , time , count = ", career, time, count);
                TimeUtil.notifyServerTime(time);
                window["ServerTimeModel"].GetInstance().open_time = open_time;
                let data = { role_num: count, role_list: [] };
                data.role_num = count;
                let vo;
                for (let i = 0; i < count; i++) {
                    vo = {};
                    vo.role_id = this.ReadFmt("l");
                    vo.state = this.ReadFmt("c");
                    new FigureProtoVo().ReadFmt(vo);
                    vo.reward_id = this.ReadFmt("c");
                    data.role_list.push(vo);
                }

                if(local_LoginModel_Instance.register_max_num_data){

                    // local_LoginModel_Instance.register_max_num_data.start_time = "21:00:00"
                    // local_LoginModel_Instance.register_max_num_data.end_time = "02:00:00"


                    let start_time_str = local_LoginModel_Instance.register_max_num_data.start_time
                    let time_bool = false
                    if(start_time_str === "0"){
                        time_bool = true
                    }
                    else{
                        let date = new Date(time)
                        date.setHours(0);
                        date.setMinutes(0);
                        date.setSeconds(0);

                        let start_time_list = start_time_str.split(":"),
                            end_time_list = local_LoginModel_Instance.register_max_num_data.end_time.split(":")

                        let start_time = start_time_list[0] * 60 * 60 + start_time_list[1] * 60 + Number(start_time_list[2])
                        let end_time = end_time_list[0] * 60 * 60 + end_time_list[1] * 60 + Number(end_time_list[2])

                        start_time *= 1000
                        end_time *= 1000

                        start_time+=date.getTime()
                        end_time+=date.getTime()

                        if(start_time > end_time){
                            time_bool = !(time >= start_time || time <= end_time)
                        }
                        else{
                            time_bool = !(time >= start_time && time <= end_time)
                        }
                    }
                    if(time_bool){
                        if(register_num > local_LoginModel_Instance.register_max_num_data.max_num){
                            Alert.Show("当前服务器注册已满<br/>请选择其他服务器", Alert_Type.One, null, null, "确定");
                            return
                        }
                    }
 
                }

                local_LoginModel_Instance.account_data_10000 = data
                local_PlatformManager_Instance.DataPlacement(60000);

                let role_mgr = window["RoleManager"] && window["RoleManager"].GetInstance()
                local_LoginModel_Instance.is_new_career = false;
                local_LoginManager_Instance.is_wait_video = false
                if (!local_LoginModel_Instance.reconnect_on_game
                    || !role_mgr
                    || !role_mgr.mainRoleInfo
                    || !role_mgr.mainRoleInfo.role_id) {

                     

                    if (data.role_num == 0) {

                        local_LoginManager_Instance.Fire(LoginStateEvent.OPEN_VIEW, "LoginCreateRoleView");
  

                    }
                    else {
                        local_LoginManager_Instance.Fire(LoginStateEvent.OPEN_VIEW, "LoginSelectRoleView", data.role_list);
                    }
                }
                else //直接在游戏内重连
                {
                    if (role_mgr.mainRoleInfo.role_id) {
                        local_LoginManager_Instance.Fire(local_LoginStateEvent.TRY_LOGIN_GAME, role_mgr.GetMainRoleId());
                    }
                }
                this.SendFmtToGame(10006, "");

                let local_account_data = CookieWrapper.GetInstance().GetCookie(CookieWrapper.LOCAL_ACCOUNT_INFO, false)
                if (!local_account_data) {
                    //@ts-ignore
                    local_account_data = {}
                }
                else {
                    local_account_data = JSON.parse(local_account_data)
                }
                local_account_data[local_LoginModel_Instance.account_id] = true
                CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LOCAL_ACCOUNT_INFO, JSON.stringify(local_account_data), false)
            };
            let On10003 = () => {
                let [result, role_id] = this.ReadFmt("cl");
                console.log("On10003 =>result,role_id: ", result, role_id);
                if (result == 1) {
                    local_PlatformManager_Instance.CreateRoleDataPost(role_id, 1)
                    local_LoginModel_Instance.is_new_career = true;
                    local_LoginManager_Instance.Fire(local_LoginStateEvent.TRY_LOGIN_GAME, role_id);
                    local_PlatformManager_Instance.DataPlacement(90200);
                }
                else if (result == 2) {
                    local_Message.show("未知错误");
                }
                else if (result == 3) {
                    local_Message.show("角色名称已经被使用");
                }
                else if (result == 4) {
                    local_Message.show("敏感字符");
                }
                else if (result == 5) {
                    local_Message.show("角色名称长度为2~6个汉字");
                }
                else if (result == 6) {
                    local_Message.show("用户已经创建角色");
                }
                else if (result == 7) {
                    local_Message.show("角色名存在敏感字符");
                }
                else if (result == 8) {
                    local_Message.show("职业未开放");
                }
            };
            let On10004 = () => {
                local_PlatformManager_Instance.DataPlacement(90100);
                let result: number = this.ReadFmt("c");
                if (result == 1) {
                    // this.SendFmtToGame(13001, "");
                    let cur_server_id = local_LoginManager_Instance.GetCurServerId();
                    if (local_LoginModel_Instance.player_login_info && cur_server_id) {
                        local_LoginModel_Instance.player_login_info.last = cur_server_id;
                    }
                    if (PlatformManager.IsEyouEnPlatform())
                        CookieWrapper.GetInstance().SaveCookie(CookieWrapper.BASE_LOCATION_CACHE, ServerModel.GetInstance().cur_selected_location, false);

                    if (local_LoginModel_Instance.login_role_id)
                        CookieWrapper.GetInstance().SaveCookie(CookieWrapper.LAST_LOGIN_ROLE_ID, local_LoginModel_Instance.login_role_id, false);


                    // BaseController.is_delay_send_protocal = true
                    LoginModel.GetInstance().ResetGameOutState()
                    LoginModel.GetInstance().is_back_from_game = false
                    local_LoginManager_Instance.try_game_start = true
                    local_LoginManager_Instance.ResetGameStartReceiveFlag()


                    this.SendFmtToGameImme(13001)
                    this.SendFmtToGameImme(10201)
                    this.SendFmtToGameImme(30005)
                    GlobalEventSystem.Fire(EventName.REQUEST_13088, FuncFirstOpenManager.MoudleId, FuncFirstOpenManager.SubModuleId, FuncFirstOpenKey)
                    GlobalEventSystem.Fire(EventName.REQUEST_10202)
                }
                local_LoginManager_Instance.RemoveLoginStateManager();
                Util.ErrorCodeShow(result);
            };
            let On10006 = () => {
                window["SceneManager"].GetInstance().has_recevie_10006 = true;
                if (delay_timer_10006_) {
                    GlobalTimerQuest.CancelQuest(delay_timer_10006_);
                    delay_timer_10006_ = null;
                }
                let send_keep_alive_to_game_func = () => {
                    if (local_UserMsgAdapter_Instance.IsGameConnected()) {
                        this.SendFmtToGame(10006, "");
                        local_GlobalEventSystem.Fire(local_EventName.CHECK_ALIVE_GAME_SENT);
                    }
                };
                delay_timer_10006_ = GlobalTimerQuest.AddDelayQuest(send_keep_alive_to_game_func, 5);
                local_GlobalEventSystem.Fire(local_EventName.CHECK_ALIVE_GAME_RESPONSE);
            };
            let On10007 = () => {
                let result = this.ReadFmt("c")
                local_LoginManager_Instance.Fire(LoginStateEvent.UPDATE_VERIFY_NAME_RESULT, result == 1)
                if (result == 1) {
                    console.log("On10007 验证成功")
                } else if (result == 0) {
                    console.log("On10007 验证失败")
                } else if (result == 2) {
                    console.log("On10007 未知错误")
                } else if (result == 3) {
                    console.log("On10007 角色名称已经使用")
                } else if (result == 4) {
                    console.log("On10007 非法字符")
                } else if (result == 5) {
                    console.log("On10007 角色名称长度为1-5")
                } else if (result == 6) {
                    console.log("On10007 用户已经创建角色")
                } else if (result == 7) {
                    console.log("On10007 角色名存在非法字符")
                } else if (result == 8) {
                    console.log("On10007 职业未开放")
                } else if (result == 9) {
                    console.log("On10007 登录状态错误")
                } else if (result == 10) {
                    console.log("On10007 账号格式错误")
                } else if (result == 11) {
                    console.log("On10007 名字格式错误")
                }
            }
            let On59004 = () => {
                let flag = this.ReadFmt("h");
                let login_tips;
                if (flag == 0)
                    login_tips = "失败";
                else if (flag == 2)
                    login_tips = "登录太频繁";
                else if (flag == 3)
                    login_tips = "IP黑名单";
                else if (flag == 4)
                    login_tips = "使用外挂";
                else if (flag == 5) {
                    if (PlatformManager.IsBigMixedServer() && window["ShSdk"] && window["ShSdk"].logout) {
                        local_Alert.Close();
                        let ok = () => {
                            window["ShSdk"].logout();
                        };
                        local_Alert.Show("该账号已在其他地方登录", local_Alert_Type.One, ok, null, "确定", null, null, true);
                    } else if (!Util.IsMiniGame() && PlatformManager.IsShenhaiPlatform() && window["ShSdk"] && window["ShSdk"].logout) {
                        local_Message.show("该账号已在其他地方登录");
                        local_UserMsgAdapter_Instance.CloseSocket(); //关闭socket
                        let ok = () => {
                            window["ShSdk"].logout()
                            local_GlobalEventSystem.Fire(local_EventName.CHANGE_ACCOUNT);
                        };
                        local_Alert.Show("该账号已在其他地方登录", local_Alert_Type.One, ok, null, "返回登录", null, null, true);
                    } else if (!Util.IsMiniGame() && PlatformManager.Is4399Platform() && window["H5API"] && window["H5API"].logout) {
                        local_Message.show("该账号已在其他地方登录");
                        local_UserMsgAdapter_Instance.CloseSocket(); //关闭socket
                        let ok = () => {
                            window["H5API"].logout()
                            local_GlobalEventSystem.Fire(local_EventName.CHANGE_ACCOUNT);
                        };
                        local_Alert.Show("该账号已在其他地方登录", local_Alert_Type.One, ok, null, "返回登录", null, null, true);
                    } else {
                        login_tips = "该账号已在其他地方登录";
                    }
                }
                else if (flag == 6)
                    login_tips = "封号";
                else if (flag == 7)
                    login_tips = "买卖元宝封号";
                else if (flag == 8)
                    login_tips = "不正当竞争封号";
                else if (flag == 9)
                    login_tips = "状态不正常";
                else if (flag == 10)
                    login_tips = "账号被封";
                else if (flag == 12) {
                    let ok_callback = () => {
                        if (ClientConfig.account_server) {
                            local_UserMsgAdapter_Instance.CloseSocket(); //关闭socket
                            local_LoginManager_Instance.Fire(LoginStateEvent.OPEN_VIEW, "LoginEnterView");
                        }
                        else
                            local_Message.show("未开启账号登陆流程不能打开选服界面");
                    };
                    local_Alert.Show("创角已成功\n游戏将于11月15日上午10:00准时开放，记得来玩噢！", local_Alert_Type.Two, ok_callback, ok_callback);
                }
                else if (flag == 11) {
                    local_Message.show("服务器维护");
                    local_UserMsgAdapter_Instance.CloseSocket(); //关闭socket
                    let ok = () => {
                        if (delay_timer_59004_) {
                            GlobalTimerQuest.CancelQuest(delay_timer_59004_);
                            delay_timer_59004_ = null;
                        }
                        local_GlobalEventSystem.Fire(local_EventName.CHANGE_ACCOUNT);
                    };
                    local_Alert.Show("服务器维护中", local_Alert_Type.One, ok, null, "返回登录", null, null, true);
                    //内部开发模式不主动退出
                    if (!ClientConfig.account_server)
                        return;
                    //10后自动退出
                    let func = () => {
                        if (delay_timer_59004_) {
                            GlobalTimerQuest.CancelQuest(delay_timer_59004_);
                            delay_timer_59004_ = null;
                        }
                        ok();
                    };
                    delay_timer_59004_ = GlobalTimerQuest.AddPeriodQuest(func, 10);
                }
                else if (flag == 13) {
                    login_tips = "来源异常";
                }
                if (login_tips) {
                    local_Message.show(login_tips);
                    local_UserMsgAdapter_Instance.CloseSocket(); //关闭socket
                    let ok = () => {
                        local_GlobalEventSystem.Fire(local_EventName.CHANGE_ACCOUNT);
                    };
                    local_Alert.Show(login_tips, local_Alert_Type.One, ok, null, "返回登录", null, null, true);
                }
            };
            let On10207 = () => {
                let scmd = local_UserMsgAdapter_Instance.GetSCMD(10207);
                if (scmd.type) {
                    local_LoginModel_Instance.CheckNewNotice();
                }
            };
            let On30005 = () => {
                let task_id = this.ReadFmt("i")
                window["TaskModel"].GetInstance().newest_finish_task_id = task_id
                LoginManager.GetInstance().SetGameStartReceiveFlag("30005", true)
            };
            this.RegisterProtocal(10000, On10000);
            this.RegisterProtocal(10003, On10003);
            this.RegisterProtocal(10004, On10004);
            this.RegisterProtocal(10006, On10006);
            this.RegisterProtocal(10007, On10007);
            this.RegisterProtocal(59004, On59004);
            this.RegisterProtocal(10207, On10207);
            this.RegisterProtocal(30005, On30005);

        };
        this.InitEvents();
        this.InitInfo();
    }
}

window["LoginController"] = LoginController