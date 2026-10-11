
import "./common/BaseClass"
import "./util/Status"
import "./util/Base64"
import "./util/ColorUtil"
import "./scene/SceneConfig"
import "./util/GameResPath"
import "./util/Mathf"
import "./util/md5"
import "./common/EventName"
import "./util/EventDispatcher"
import "./common/HashEventDispatcher"
import "./util/DeclareGlobalVar"
import "./util/Runner"
import "./util/StateMachineManager"
import "./util/SYTweenFunc"
import "./util/TimeUtil"
import "./util/GameMath"
import "./scene/ObjPool"

import "./util/TMap"
import "./util/Vector2"
import "./util/Vector3"
import "./common/AppConst"

import "./util/GameError"
import "./util/HttpUtil"
import "./util/ErlangParser"
import "./util/GameVideo"

import "./common/Config";
import "./common/table";

import "./common/LayerManager";
import "./common/WordManager";
import "./common/CookieWrapper"

import "./util/Util"
import "./common/CommonGoodsListVo"
import "./common/BaseAttrProtoVo"
import "./common/FigureProtoVo"
import "./common/UserMsgAdapter"
import "./common/ViewManager"
import "./common/SoundManager"
import "./util/SYTweenLite"

import "./ResVersionManager"
import "./common/ResManager"
import "./common/LogManager"
import "./common/CommonManager"
import "./common/PopManager"
import "./common/GameSettingManager"

import "./common/BaseVo"
import "./common/BaseController"
import "./common/BaseComponent"
import "./common/UIEffect"
import "./common/BaseItem1"
import "./common/BaseView1"
import "./common/UIModelClass3D"
import "./login/WaitforOpenViewLoading"
import "./alert/Alert"

import "./GameScriptModule"
import "./AutoRequireMainSubPackage"

import GameConfig from "./GameConfig";
import { GetOption, GetTargetHashcode, Util } from "./util/Util"
import { HttpUtil } from "./util/HttpUtil"
import { LoginModel } from "./login/LoginModel"
import { ClientConfig } from "./util/DeclareGlobalVar"
import { GameScriptModule } from "./GameScriptModule"
import { ResManager } from "./common/ResManager"
import { ResVersionManager } from "./ResVersionManager"
import { PlatformManager } from "./PlatformManager"
import { KeyInput } from "./util/KeyInput"
import { LogManager } from "./common/LogManager"
import { OverrideEngineCode } from "./OverrideEngineCode"
class Main {
    constructor() {
        if (!Util.IsMiniGame()) {
            //根据IDE设置初始化引擎		
            if (window["Laya3D"]) {
                let config3d: Config3D = Config3D["_config"]
                config3d.isAntialias = false
                config3d.isStencil = false
                config3d.enableMultiLight = false
                config3d.maxLightCount = 0
                config3d.octreeCulling = false
                config3d.isAlpha = true
                // config3d.debugFrustumCulling = true
                // config3d.pixelResol = 1
                // config3d.setResSize(720,1280)
                var u: string = window.navigator.userAgent;
                let laya_Config = Laya['Config']
                if (!!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/))//ios 处理花屏问题
                {
                    laya_Config.useWebGL2 = false;
                    laya_Config.useRetinalCanvas = false;
                } else {
                    laya_Config.useRetinalCanvas = true;//非小程序的ios禁止高清模式  小程序包里写死了安卓开启 ios关闭  也可以通过在对比编码的cfg里设置useRetinalCanvas来动态控制
                }
                Laya3D.init(GameConfig.width, GameConfig.height);
                laya_Config.isAlpha = true;//设置画布是否透明，只对2D(WebGL)、3D有效。
                if (Laya.Browser.onPC) {
                    Laya.stage.bgColor = null;//背景透明
                }
                Config3D.enableDynamicManager = false
                Config3D.enableStaticManager = false
                console.log("-------------------------Laya3D--------------------------");
            }
            else {
                Laya.init(GameConfig.width, GameConfig.height, Laya["WebGL"]);
                console.log("-------------------------Laya2D--------------------------", Laya["WebGL"])
            }
            window["Config"] = window["Config1"]
            Laya["Physics"] && Laya["Physics"].enable();
            Laya["DebugPanel"] && Laya["DebugPanel"].enable();
            Laya.stage.scaleMode = GameConfig.scaleMode;
            Laya.stage.screenMode = GameConfig.screenMode;
            Laya.stage.alignV = GameConfig.alignV;
            Laya.stage.alignH = GameConfig.alignH;
            // Laya.stage.drawCallOptimize = true
            //兼容微信不支持加载scene后缀场景
            Laya.URL.exportSceneToJson = GameConfig.exportSceneToJson;

            // //打开调试面板（通过IDE设置调试模式，或者url地址增加debug=true参数，均可打开调试面板）
            // if (GameConfig.debug || Laya.Utils.getQueryString("debug") == "true") 
            //     Laya.enableDebugPanel();
            // if (GameConfig.physicsDebug && Laya["PhysicsDebugDraw"]) Laya["PhysicsDebugDraw"].enable();
            //     Laya.alertGlobalError(false);
            // //设置性能分析工具
            // Laya.PerformancePlugin.setPerformanceDataTool(window['PerformanceDataTool'].instance);
            // //开启性能分析
            // Laya.PerformancePlugin.enable = true;
            // // 项目地址为外网或者内嵌在别的应用中（如微信小游戏）时，需要设置性能分析器所在机器的局域网ip
            // window['PerformanceDataTool'].setDataExportHost('局域网ip，如10.10.20.25');         
            // //开启性能数据传输（没有打开性能分析器的时候是没用的）
            // Laya.PerformancePlugin.enableDataExport = true;
            // Laya.PerformancePlugin.showFunSampleFun(Laya.PerformancePlugin.PERFORMANCE_LAYA)

            //Laya.Stat.show()
        }else
        {
            
        }

        Config3D.enableDynamicManager = false
        Config3D.enableStaticManager = false
        this.runGame();
        // console.log("-------------------------runGame--------------------------")
    }


    private async runGame() {
        // ResManager.GetInstance().cdn_res_path = "http://cdn.yy25dlaya_kf.sydevlop.cn/"
        let is_debug = false
        if (!Util.IsMiniGame()) {
            let url = window.location.href.toString();
            console.warn("url-------------------:", url);
            HttpUtil.game_url = url
            if (url) {
                let list = url.split(":");
                if (list && list[0]) {
                    if (list[0] == "https") {
                        HttpUtil.is_http = false;
                    }
                    else {
                        HttpUtil.is_http = true;
                    }
                    if (list[0] == "file" || url.indexOf("localhost") >= 0) {
                        is_debug = true
                    }
                }
            }
            if (Laya.Browser.onMobile && !Util.IsIOSConch())//手机浏览器上如果不能使用ktx说明是pc端 
            {
                let local_resolve
                let time_out = setTimeout(() => {
                    if (local_resolve) {
                        local_resolve()
                    }
                }, 3000);
                window.onerror = (errorMessage, scriptURI, lineNumber, columnNumber, errorObj) => {
                    if ((errorObj + "") == "unknown texture format.") {
                        let br = Laya.Browser;
                        br.onAndroid = false;
                        br.onMobile = false;
                        br.onIOS = false;
                        br.onIPhone = false;
                        br.onPC = true;
                        if (local_resolve) {
                            local_resolve();
                        }
                        local_resolve = null
                    }
                    return false;
                };
                await new Promise<void>((resolve, reject) => {
                    local_resolve = resolve
                    Laya.loader.load("resource/game/common/other/test_mobile.ktx", Laya.Handler.create(this, (tex: Laya.Texture) => {
                        if (tex && tex.bitmap["_format"] == -1) {
                            let br = Laya.Browser
                            br.onAndroid = false
                            br.onMobile = false
                            br.onIOS = false
                            br.onIPhone = false
                            br.onPC = true
                        }
                        time_out = null
                        local_resolve = null
                        resolve()
                    }), null, Laya.Loader.IMAGE, 1, true);
                });

            }
        }

        Util.use_ktx = !Laya.Browser.onPC
            && !Util.IsIOSConch()
            && !Util.IsQQGame()
            && !Util.IsOPPOFastGame()
            && !Util.IsVivoFastGame()
            && !Util.IsMiFastGame()
            && !Util.IsMeiZuFastGame()
            && !Util.IsBiliBiliGame()
            && !Util.IsKSGame()
            && !Util.IsMTGame()
            && !Util.IsTTGame()
        Util.is_debug = is_debug
        if (Util.is_debug && GameConfig.stat) Laya.Stat.show();
        if (Util.IsMiniGame()) {
            LoginModel.GetInstance().plat_name = ""; //"yy_sh921_lj_PM000429"
        }
        else {
            if (Util.IsConch()) {
                let native_cfg = window["native_cfg"]
                console.log("--------native_cfg1------------" + native_cfg)
                if (native_cfg) {
                    if (native_cfg.is_debug) {
                        window["is_debug"] = true
                        window['thinkingdata'] = null
                        ResManager.GetInstance().cdn_res_path = native_cfg.debug_cdn;
                    } else {
                        LoginModel.GetInstance().plat_name = native_cfg["ConfigUrl"] || "";
                        ResManager.GetInstance().cdn_res_path = native_cfg.ResUrl;
                    }
                    GameScriptModule.GetInstance().native_package_version = native_cfg.curr_alpha_version
                    if (native_cfg.is_http) {
                        HttpUtil.is_http = true;
                    }
                    else {
                        HttpUtil.is_http = false;
                    }
                }

                //屏蔽laya点击两次返回退出的逻辑
                if (window.conch.setOnBackPressedFunction) {
                    window.conch.setOnBackPressedFunction(() => { })
                }
            }
            else {
                LoginModel.GetInstance().plat_name = GetOption("gskin") || window["plat_name"];
                if (LoginModel.GetInstance().plat_name)
                    LogManager.print_log = GetOption("log") == "1";
                else
                    LogManager.print_log = true
            }
        }
        GameScriptModule.GetInstance().SetStage(Laya.stage);
        if (ClientConfig) {
            GameScriptModule.GetInstance().SetClientConfig(ClientConfig);
        }
        else {
            if (Util.IsMiniGame()) {
                HttpUtil.is_http = true;
                let load_completed;
                let promise = new Promise<any>((resolve, reject) => {
                    load_completed = resolve;
                });
                console.warn("load cfg");
                let load_default_config_call_back = async (data) => {
                    if (data) {
                        let cfg = JSON.parse(data);
                        if (cfg.hide_log) {
                            console.log = function (message) {

                            }
                            console.warn = function (message) {

                            }
                            LogManager.print_log = false
                        } else {
                            LogManager.print_log = true
                        }
                        if (cfg.is_debug) {
                            ResManager.GetInstance().cdn_res_path = cfg.debug_cdn; //"http://cdn.yyhx_kf.suyougame.com/"
                            if (Util.IsWXGame() || Util.IsQQGame() || Util.IsMTGame()) {
                                Util.is_wxgame_bebug = true;
                                let local_wx
                                local_wx = window["wx"]
                                if (local_wx && local_wx.setEnableDebug) {
                                    local_wx.setEnableDebug({
                                        enableDebug: true
                                    });
                                }
                            } else if (Util.IsBiliBiliGame()) {
                                let local_bl
                                local_bl = window["bl"]
                                if (local_bl && local_bl.setEnableDebug) {
                                    local_bl.setEnableDebug({
                                        enableDebug: true
                                    });
                                }
                            } else if (Util.IsOPPOFastGame()) {
                                let local_qg
                                local_qg = window["qg"]
                                if (local_qg && local_qg.setEnableDebug) {
                                    local_qg.setEnableDebug({
                                        enableDebug: true
                                    });
                                }
                            }
                            await GameScriptModule.GetInstance().LoadClientConfig();
                            load_completed();
                            return;
                        }

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
                            HttpUtil.is_http = cfg.is_http && true || false;
                        }

                        let number, configUrl
                        if (Laya.Browser.onAndroid) {
                            number = cfg.android_number;
                            configUrl = cfg.ConfigUrl;
                        }
                        else {
                            configUrl = cfg.IOSConfigUrl
                            if (!configUrl) {
                                configUrl = cfg.ConfigUrl;
                                number = `ios_${cfg.ios_number}`;
                            }
                            else {
                                number = cfg.ios_number
                            }
                        }

                        console.warn("HttpUtil.is_http", HttpUtil.is_http);

                        let cdn_config_url = configUrl + number + ".cfg";

                        let version_mgr = ResVersionManager;
                        version_mgr.base_cdn_config_url = cfg.ResUrl;
                        version_mgr.backup_cdn_config_url = cfg.BackUpUrl;
                        HttpUtil.HttpLoadJson(version_mgr.base_cdn_config_url, cdn_config_url + "?v=" + Math.random(), (cdn_cfg) => {
                            if (cdn_cfg && !version_mgr.wx_alpha_version) {
                                LoginModel.GetInstance().plat_name = cdn_cfg.PlatName;
                                GameScriptModule.GetInstance().SetClientConfig(cdn_cfg, false);
                                version_mgr.wx_cdn_config_url = cdn_config_url;
                                version_mgr.wx_alpha_version = cdn_cfg.wx_alpha_version;
                                version_mgr.cfg_wx_alpha_version = cfg.wx_alpha_version;
                                if (window["version_text"]) {
                                    window["version_text"].text = "(" + cfg.wx_alpha_version + "." + cdn_cfg.wx_alpha_version + ")";
                                }
                                if (cfg.wx_alpha_version && cdn_cfg.wx_alpha_version && cfg.wx_alpha_version > cdn_cfg.wx_alpha_version) //当前代码包的审核版本号大于cdn的 说明需要切审核服cdn 

                                //更新大版本的时候需要把两个值改为一致。热更的话 在代码提审的时候把包内版本号+1 审核通过后把cdn的版本号+1 再热更cdn  热更完cdn后再发布代码出去
                                {
                                    PlatformManager.GetInstance().is_wx_alpha = true
                                    ResManager.GetInstance().cdn_res_path = cdn_cfg.AlphaCdnUrl;
                                }
                                else {
                                    PlatformManager.GetInstance().is_wx_alpha = false
                                    ResManager.GetInstance().cdn_res_path = cdn_cfg.ResUrl;
                                }
                            }
                            load_completed();
                        }, 10000, version_mgr.backup_cdn_config_url);
                    }
                    else {
                        load_completed();
                    }
                };
                if (window["local_json_cfg"]) {
                    load_default_config_call_back(window["local_json_cfg"]);
                }
                else {
                    HttpUtil.HttpLoadJson("", "config/cfg.json", load_default_config_call_back, 0);
                }
                await promise;
            }
            else {
                if (window["PreloadClientConfig"]) {
                    GameScriptModule.GetInstance().SetClientConfig(window["PreloadClientConfig"]);
                } else {
                    await GameScriptModule.GetInstance().LoadClientConfig();
                }
            }
        }
        window["ClientConfig"] = ClientConfig;
        let cid = GetOption("cid");
        PlatformManager.GetInstance().SetCidState(cid)
        await GameScriptModule.GetInstance().LoadFont();
        await GameScriptModule.GetInstance().LoadGameRes();
        if (Util.IsMiniGame()) {
            if (window["version_text"]) {
                window["version_text"].text = "version:" + ResVersionManager.main_version + "." + ResVersionManager.hot_update_version + window["version_text"].text;
                Util.SetVersionMsg(window["version_text"].text);
            }
        }
        else {
            var version_text;
            version_text = document.getElementById("version_text");
            if (version_text) {
                Util.SetVersionMsg(version_text.textContent);
            }
        }
        let key_input = new KeyInput();
        GameScriptModule.GetInstance().OpenAccoutView();
        Util.OrientationChange();
    }
}
OverrideEngineCode.BeforeEngineInit()
if (!Util.IsMiniGame()) {
    //激活启动类
    new Main();
} else {
    // local_Laya.MiniAdpter.AutoCacheDownFile = true
}

window["Main"] = Main

//setInterval(() =>
//{
 //   Laya.Resource.destroyUnusedResources()
//}, 2000)