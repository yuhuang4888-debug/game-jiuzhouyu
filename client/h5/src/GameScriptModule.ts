
import { ClientConfig, GlobalEventSystem, SetGlobalClientConfig } from "./util/DeclareGlobalVar";
import { EventName, LoginStateEvent } from "./common/EventName";
import { SoundManager } from "./common/SoundManager";
import { UserMsgAdapter } from "./common/UserMsgAdapter";
import { AppConst } from "./common/AppConst";
import { Util, DEVICE_OS } from "./util/Util";
import { ResManager } from "./common/ResManager";
import { HttpUtil } from "./util/HttpUtil";
import { ResVersionManager } from "./ResVersionManager";
import { LayerManager } from "./common/LayerManager";
import { GameError } from "./util/GameError";
import { ViewManager } from "./common/ViewManager";
import { RoleManager } from "./commonModel/RoleManager";
import { LoginController } from "./login/LoginController";
import { RoleController } from "./commonController/RoleController";
import { LoginManager } from "./login/LoginManager";
import { ServerTimeController } from "./serverTime/ServerTimeController";
import { Message, SysInfoController } from "./sysInfo/SysInfoController";
import { LoginModel } from "./login/LoginModel";
import { WorkerUtils } from "./util/WorkerUtils";
import { ViewPopLevelModel } from "./commonModel/ViewPopLevelModel";
import { PlatformManager } from "./PlatformManager";
import { LogManager } from "./common/LogManager";
import { OverrideEngineCode } from "./OverrideEngineCode";
import { SettingController } from "./commonController/SettingController";
import { ServerModel } from "./login/ServerModel";
import { GameResPath } from "./util/GameResPath";

export enum GAMERUNSTATE {
    Resume = "resume", //恢复正常运行
    Pause = "pause", //最小化
    FocusOut = "focusout"//失去焦点
}
export class GameScriptModule {
    private static Instance: GameScriptModule;
    SetStage;
    SetClientConfig;
    LoadClientConfig;
    LoadGameRes;
    LoadFont;
    InitCommonManager;
    OpenAccoutView;
    game_run_state = GAMERUNSTATE.Resume
    LoadLoginConfig

    public native_package_version = null//原生包包内版本号
    public constructor() {
        let local_GlobalEventSystem = GlobalEventSystem,
            local_EventName = EventName, sound_mgr = SoundManager.GetInstance(), user_msg_adapter = UserMsgAdapter.GetInstance(), local_AppConst = AppConst, local_Util = Util, local_DEVICE_OS = DEVICE_OS, res_mgr = ResManager.GetInstance(), local_HttpUtil = HttpUtil, local_JSON = JSON, res_version_mgr = ResVersionManager.GetInstance(), local_ResVersionManager = ResVersionManager, layer_mgr = LayerManager.GetInstance(), _is_pc_: Boolean = true, stage_: Laya.Stage, pause_time_ = 0, is_pause_ = false;
        this.SetStage = (stage) => {
            LayerManager.GetInstance().stage = stage;
            stage_ = stage;
            let stage_fun = () => {
                // if (is_pause_) {
                //     local_egret.lifecycle.onResume();
                // }
            };
            local_GlobalEventSystem.Bind(local_EventName.STAGE_CLICK_EVENT, stage_fun);
            let focus_time = 0;
            let is_focus_in = false;

            let resume = () => {
                console.log("--------------------WINDOW_RESUME-------------------")
                this.game_run_state = GAMERUNSTATE.Resume
                GlobalEventSystem.Fire(EventName.WINDOW_RESUME)
            }


            let pause = () => {
                console.log("--------------------WINDOW_PUSE-------------------")
                this.game_run_state = GAMERUNSTATE.Pause
                GlobalEventSystem.Fire(EventName.WINDOW_PUSE)
            }

            let focusOut = () => {
                console.log("--------------------WINDOW_FOCUS_OUT-------------------")
                this.game_run_state = GAMERUNSTATE.FocusOut
                GlobalEventSystem.Fire(EventName.WINDOW_FOCUS_OUT)
            }
            let hidden, visibilityChange;
            let handleVisibilityChange = () => {
                if (!document[hidden]) {
                    resume()
                }
                else {
                    pause()
                }
            };

            //svip图标展示(爱微游专服必接)
            let svip_iwy_func = (e) => {
                //data.status==1 代表开启，否则不开启 
                if (e&&e.data&&e.data.type&&e.data.type == 'svip') {
                    PlatformManager.GetInstance().iwy_svip_data = e.data
                    GlobalEventSystem.Fire(EventName.UPDATE_IWY_SVIP_STATE)
                }
            }

            window.addEventListener("focus", resume, false);
            window.addEventListener("blur", focusOut, false);
            window.addEventListener("message", svip_iwy_func, false);

            /**
             * 小游戏切后台
             */

            /**微信/QQ */
            let local_wx
            local_wx = window["wx"]
            if ((local_Util.IsWXGame() || local_Util.IsQQGame() || local_Util.IsMTGame()) && local_wx) {
                local_wx.onShow((res) => {
                    let CheckUpdate = window["CheckUpdate"]
                    if (CheckUpdate) {
                        CheckUpdate(res)
                    }
                    resume()
                })

                local_wx.onHide(() => {
                    pause()
                })
            }

            /**快手 */
            let local_ks
            local_ks = window["ks"]
            if (local_Util.IsKSGame() && local_ks) {
                local_ks.onShow((res) => {
                    let CheckUpdate = window["CheckUpdate"]
                    if (CheckUpdate) {
                        CheckUpdate(res)
                    }
                    resume()
                })

                local_ks.onHide(() => {
                    pause()
                })
            }


            /**BiliBili */
            let local_bl
            local_bl = window["bl"]
            if (local_Util.IsBiliBiliGame() && local_bl) {
                local_bl.onShow((res) => {
                    let CheckUpdate = window["CheckUpdate"]
                    if (CheckUpdate) {
                        CheckUpdate(res)
                    }
                    resume()
                })

                local_bl.onHide(() => {
                    pause()
                })
            }

            /**字节跳动 */
            let local_tt
            local_tt = window["tt"]
            if (local_Util.IsTTGame() && local_tt) {
                local_tt.onShow((res) => {
                    let CheckUpdate = window["CheckUpdate"]
                    if (CheckUpdate) {
                        CheckUpdate(res)
                    }
                    resume()
                })

                local_tt.onHide(() => {
                    pause()
                })
            }

            /**
             * 快应用切后台
             */
            let local_qg
            local_qg = window["qg"]
            if ((local_Util.IsOPPOFastGame() || local_Util.IsVivoFastGame() || Util.IsMiFastGame() || Util.IsMeiZuFastGame()) && local_qg) {
                local_qg.onShow((res) => {
                    let CheckUpdate = window["CheckUpdate"]
                    if (CheckUpdate) {
                        CheckUpdate(res)
                    }
                    resume()
                })

                local_qg.onHide(() => {
                    pause()
                })
            }

            if (typeof document.hidden !== "undefined") {
                hidden = "hidden";
                visibilityChange = "visibilitychange";
            } else if (typeof document["mozHidden"] !== "undefined") {
                hidden = "mozHidden";
                visibilityChange = "mozvisibilitychange";
            } else if (typeof document["msHidden"] !== "undefined") {
                hidden = "msHidden";
                visibilityChange = "msvisibilitychange";
            } else if (typeof document["webkitHidden"] !== "undefined") {
                hidden = "webkitHidden";
                visibilityChange = "webkitvisibilitychange";
            } else if (typeof document["oHidden"] !== "undefined") {
                hidden = "oHidden";
                visibilityChange = "ovisibilitychange";
            }
            if ("onpageshow" in window && "onpagehide" in window) {
                window.addEventListener("pageshow", resume, false);
                window.addEventListener("pagehide", pause, false);
            }
            if (hidden && visibilityChange) {
                document.addEventListener(visibilityChange, handleVisibilityChange, false);
            }

            // stage_.addEventListener("blur", (e: egret.FocusEvent) => {
            //     focus_time = local_egret.getTimer();
            // }, this, true);
            // stage_.addEventListener(local_egret.FocusEvent.FOCUS_IN, (e: egret.FocusEvent) => {
            //     focus_time = local_egret.getTimer();
            // }, this, true);
            // stage_.addEventListener(local_egret.FocusEvent.FOCUS_OUT, (e: egret.FocusEvent) => {
            //     focus_time = local_egret.getTimer();
            // }, this, true);
            // let check_timer_id;
            //主要处理iphone7上 关闭键盘会触发onPause导致游戏定住的问题
            // local_egret.lifecycle.onPause = () => {
            //     if (local_egret.getTimer() - focus_time > 100) {
            //         is_pause_ = true;
            //         if (!_is_pc_) {
            //             sound_mgr.SetVolume(0);
            //         }
            //         pause_time_ = local_egret.getTimer();
            //         local_GlobalEventSystem.Fire(local_EventName.EGRET_LIFE_CYCLE_CHANGE, false);
            //         if (!check_timer_id) {
            //             check_timer_id = local_egret.setInterval(() => {
            //                 if (window.hasOwnProperty("appInBackgound") && !window["appInBackgound"]) {
            //                     local_egret.lifecycle.onResume();
            //                 }
            //             }, this, 1000);
            //         }
            //     }
            // };
            // local_egret.lifecycle.onResume = () => {
            //     is_pause_ = false;
            //     if (!_is_pc_) {
            //         sound_mgr.SetVolume(1);
            //     }
            //     if (pause_time_) {
            //         let time = local_egret.getTimer() - pause_time_;
            //         pause_time_ = 0;
            //     }
            //     local_GlobalEventSystem.Fire(local_EventName.EGRET_LIFE_CYCLE_CHANGE, true);
            //     if (check_timer_id) {
            //         local_egret.clearInterval(check_timer_id);
            //         check_timer_id = null;
            //     }
            //     local_egret.log("------onResume------");
            //     if (!user_msg_adapter.IsGameConnected()
            //         && ((local_AppConst.SocketAddress != null && local_AppConst.SocketPort != 0)
            //             || local_AppConst.SslSocketPort != 0)
            //         && !local_LoginManager_Instance.IsInLoginProcess()) {
            //         login_model.reconnect_on_game = true;
            //         user_msg_adapter.ConnectSocket();
            //     }
            // };
            // if (document && document.addEventListener) {
            //     document.addEventListener("qbrowserVisibilityChange", function (e: any) {
            //         if (e.hidden) {
            //             // context.pause();
            //         }
            //         else {
            //             local_egret.lifecycle.onResume();
            //         }
            //         ;
            //     });
            // }
            //inject the custom material parser
            // Laya.stage.frameRate = Laya.Stage.FRAME_SLOW
            // Laya.Text.default_fontFamily = "SimHei,Arial";
            // if (local_Util.GetDeviceOS() == local_DEVICE_OS.IOS_APP) {
            //     // res_mgr.cdn_res_path = "http://cdn.yyhx_kf.suyougame.com/"
            // }
            // _is_pc_ = false;
            // if (!Util.IsRuntime2()) {
            //     stage_.scaleMode = local_egret.StageScaleMode.FIXED_NARROW;
            // }

            res_mgr.changeSceneClearRes = true
            /**
             * 小游戏设置屏幕常量和内存
             */
            if (local_Util.IsWXGame() || local_Util.IsQQGame() || local_Util.IsMTGame()) {
                let local_wx
                local_wx = window["wx"]
                if (local_wx) {
                    if (local_wx.setKeepScreenOn) {
                        local_wx.setKeepScreenOn({
                            keepScreenOn: true
                        });
                    }
                    if (local_wx.onMemoryWarning && (local_Util.IsWXGame() || local_Util.IsMTGame() )) {
                        local_wx.onMemoryWarning(function () {
                            // Message.show("微信剩余内存不足");
                            res_mgr.changeSceneClearRes = true
                            res_mgr.GCRES(true, 0.3);
                            console.warn("-----------剩余内存不足-------------")
                            if (ClientConfig && !ClientConfig.notForceGC) {
                                let wx
                                wx = window["wx"]
                                if (wx && wx.triggerGC) {
                                    wx.triggerGC()
                                }
                            }
                        });
                    }
                }
            }

            /**快手 */
            if (local_Util.IsKSGame() && local_ks) {
                if (local_ks.setKeepScreenOn) {
                    console.warn("-----------setKeepScreenOn")
                    local_ks.setKeepScreenOn({
                        keepScreenOn: true
                    });
                }
                if (local_ks.onMemoryWarning) {
                    console.warn("-----------onMemoryWarning")
                    local_ks.onMemoryWarning(function () {
                        res_mgr.changeSceneClearRes = true
                        res_mgr.GCRES(true, 0.3);
                        console.warn("-----------剩余内存不足-------------")
                        if (ClientConfig && !ClientConfig.notForceGC) {
                            if (local_ks.triggerGC) {
                                console.warn("-----------triggerGC")
                                local_ks.triggerGC()
                            }
                        }
                    });
                }
                
            }

            /**BiliBili */
            if (local_Util.IsBiliBiliGame()) {
                let local_bl
                local_bl = window["bl"]
                if (local_bl) {
                    if (local_bl.setKeepScreenOn) {
                        local_bl.setKeepScreenOn({
                            keepScreenOn: true
                        });
                    }
                    if (local_bl.onMemoryWarning) {
                        local_bl.onMemoryWarning(function () {
                            res_mgr.changeSceneClearRes = true
                            res_mgr.GCRES(true, 0.3);
                            console.warn("-----------剩余内存不足-------------")
                            if (ClientConfig && !ClientConfig.notForceGC) {
                                if (local_bl.triggerGC) {
                                    local_bl.triggerGC()
                                }
                            }
                        });
                    }
                }
            }

            /**字节跳动 */
            if (local_Util.IsTTGame()) {
                let local_tt
                local_tt = window["tt"]
                if (local_tt) {
                    if (local_tt.setKeepScreenOn) {
                        local_tt.setKeepScreenOn({
                            keepScreenOn: true
                        });
                    }
                    if (local_tt.onMemoryWarning) {
                        local_tt.onMemoryWarning(function () {
                            res_mgr.changeSceneClearRes = true
                            res_mgr.GCRES(true, 0.3);
                            console.warn("-----------剩余内存不足-------------")
                            if (ClientConfig && !ClientConfig.notForceGC) {
                                if (local_tt.triggerGC) {
                                    local_tt.triggerGC()
                                }
                            }
                        });
                    }
                }
            }

            /**
             * 快应用设置屏幕常量和内存
             */
             if (local_Util.IsOPPOFastGame() || local_Util.IsVivoFastGame() || Util.IsMiFastGame() || Util.IsMeiZuFastGame()) {
                let local_qg
                local_qg = window["qg"]
                if (local_qg) {
                    if (local_qg.setKeepScreenOn) {
                        local_qg.setKeepScreenOn({
                            keepScreenOn: true
                        });
                    }
                }


             }
        };
        this.SetClientConfig = (cfg, set_data_path = true) => {
            if (cfg && !cfg.has_reset_data) {
                cfg.has_reset_data = true;
                SetGlobalClientConfig(cfg);
                cfg.login_php = cfg.url_account_path + cfg.login_php;
                cfg.login_key = LoginModel.LoginKey;
                cfg.server_version = cfg.url_account_path + cfg.server_version;
                cfg.server_file = cfg.url_account_path + cfg.server_file;
                cfg.simplify_server_file = cfg.url_account_path + cfg.simplify_server_file;
                if (set_data_path && !local_Util.IsDebug()) {// && (local_Util.IsRuntime2() || login_model.plat_name)) {
                    res_mgr.cdn_res_path = cfg.ResUrl;
                    if (local_Util.IsConch() && PlatformManager.GetInstance().is_wx_alpha) {
                        res_mgr.cdn_res_path = cfg.AlphaCdnUrl;
                    }
                }
                if (Util.IsWXGame()) {
                    // if (cfg.autoCacheImgAndAudio == 0 || cfg.autoCacheImgAndAudio == 1)
                    // {
                    //     window["autoCacheImgAndAudio"] = cfg.autoCacheImgAndAudio //小程序是否自动缓存图片和声音到本地   弃用
                    // }
                    if (cfg.autoCacheFile == 0 || cfg.autoCacheFile == 1) {
                        Laya.MiniAdpter.autoCacheFile = cfg.autoCacheFile //小程序是否自动缓存图片和声音到本地
                        if (Laya.MiniAdpter.autoCacheFile) {
                            WorkerUtils.init();
                        }
                    }
                }
                if (cfg.useRetinalCanvas == 0 || cfg.useRetinalCanvas == 1) {
                    Laya.stage.useRetinalCanvas = cfg.useRetinalCanvas
                    Laya.stage["_changeCanvasSize"]()
                }
                if (cfg.forcePreCulling == 0 || cfg.forcePreCulling == 1) {
                    window["forcePreCulling"] = cfg.forcePreCulling //是否强制调用_preculling
                }
                if (!cfg.unoverride_mesh) {
                    let local_Laya = Laya
                    local_Laya.Mesh2D.prototype["configVAO"] = function (gl) {
                        if (this._applied)
                            return;
                        this._applied = true;
                        if (!this._vao) {
                            this._vao = new local_Laya.BufferState2D();
                        }
                        this._vao.bind();
                        this._vb._bindForVAO();

                        // this._ib.setNeedUpload();	//vao的话，必须要绑定ib。即使是共享的别人的。
                        // this._ib._bind_uploadForVAO();
                        var attribNum: number = this._attribInfo.length / 3;
                        var idx: number = 0;
                        for (var i: number = 0; i < attribNum; i++) {
                            var _size: number = this._attribInfo[idx + 1];
                            var _type: number = this._attribInfo[idx];
                            var _off: number = this._attribInfo[idx + 2];
                            gl.enableVertexAttribArray(i);
                            gl.vertexAttribPointer(i, _size, _type, false, this._stride, _off); //注意 normalize都设置为false了，想必没人要用这个功能把。
                            idx += 3;
                        }
                        this._vao.unBind();
                    }

                    local_Laya.Mesh2D.prototype.useMesh = function (gl) {
                        this._applied || this.configVAO(gl);
                        this._vao.bind();
                        this._vb.bind();	//vao必须要再bind vb,否则下面的操作可能是在操作其他的mesh
                        this._ib._bind_upload() || this._ib._bindForVAO();
                        this._vb._bind_upload() || this._vb.bind();
                    }
                }

                let max_call_num = cfg.max_call_num
                // if(!max_call_num && !LoginModel.GetInstance().plat_name) 
                // {
                //     max_call_num = 1000
                // }
                if (max_call_num && max_call_num > 0) {
                    let local_Laya = Laya
                    let local_Transform3D
                    local_Transform3D = local_Laya.Transform3D
                    local_Transform3D.prototype["_onWorldPositionRotationTransform"] = function (call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("Transform3D _onWorldPositionRotationTransform death loop")
                            return
                        }
                        if (!this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDPOSITION) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDQUATERNION) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDEULER)) {
                            this._setTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX | local_Transform3D.TRANSFORM_WORLDPOSITION | local_Transform3D.TRANSFORM_WORLDQUATERNION | local_Transform3D.TRANSFORM_WORLDEULER, true);
                            this.event(local_Laya.Event.TRANSFORM_CHANGED, this._transformFlag);
                        }
                        for (var i: number = 0, n: number = this._children!.length; i < n; i++)
                            this._children![i]._onWorldPositionRotationTransform(call_num);
                    }

                    local_Transform3D.prototype["_onWorldPositionScaleTransform"] = function (call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("local_Transform3D _onWorldPositionScaleTransform death loop")
                            return
                        }
                        if (!this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDPOSITION) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDSCALE)) {
                            this._setTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX | local_Transform3D.TRANSFORM_WORLDPOSITION | local_Transform3D.TRANSFORM_WORLDSCALE, true);
                            this.event(local_Laya.Event.TRANSFORM_CHANGED, this._transformFlag);
                        }
                        for (var i: number = 0, n: number = this._children!.length; i < n; i++)
                            this._children![i]._onWorldPositionScaleTransform(call_num);
                    }

                    local_Transform3D.prototype["_onWorldPositionTransform"] = function (call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("local_Transform3D _onWorldPositionTransform death loop")
                            return
                        }
                        if (!this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDPOSITION)) {
                            this._setTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX | local_Transform3D.TRANSFORM_WORLDPOSITION, true);
                            this.event(local_Laya.Event.TRANSFORM_CHANGED, this._transformFlag);
                        }
                        for (var i: number = 0, n: number = this._children!.length; i < n; i++)
                            this._children![i]._onWorldPositionTransform(call_num);
                    }

                    local_Transform3D.prototype["_onWorldTransform"] = function (call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("Transform3D _onWorldTransform death loop")
                            return
                        }
                        if (!this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDPOSITION) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDQUATERNION) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDEULER) || !this._getTransformFlag(local_Transform3D.TRANSFORM_WORLDSCALE)) {
                            this._setTransformFlag(local_Transform3D.TRANSFORM_WORLDMATRIX | local_Transform3D.TRANSFORM_WORLDPOSITION | local_Transform3D.TRANSFORM_WORLDQUATERNION | local_Transform3D.TRANSFORM_WORLDEULER | local_Transform3D.TRANSFORM_WORLDSCALE, true);
                            this.event(local_Laya.Event.TRANSFORM_CHANGED, this._transformFlag);
                        }
                        for (var i: number = 0, n: number = this._children!.length; i < n; i++)
                            this._children![i]._onWorldTransform(call_num);
                    }

                    let local_Sprite3D
                    local_Sprite3D = local_Laya.Sprite3D
                    local_Sprite3D.prototype["_setHierarchyAnimator"] = function (animator, parentAnimator, call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("local_Sprite3D _setHierarchyAnimator death loop")
                            return
                        }
                        this._changeHierarchyAnimator(animator);
                        this._changeAnimatorAvatar(animator.avatar);
                        for (var i: number = 0, n: number = this._children.length; i < n; i++) {
                            var child = this._children[i];
                            (child._hierarchyAnimator == parentAnimator) && (child._setHierarchyAnimator(animator, parentAnimator, call_num));
                        }
                    }

                    local_Sprite3D.prototype["_clearHierarchyAnimator"] = function (animator, parentAnimator, call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("local_Sprite3D _clearHierarchyAnimator death loop")
                            return
                        }
                        this._changeHierarchyAnimator(parentAnimator);
                        this._changeAnimatorAvatar(parentAnimator ? parentAnimator.avatar : null);
                        for (var i: number = 0, n: number = this._children.length; i < n; i++) {
                            var child = this._children[i];
                            (child._hierarchyAnimator == animator) && (child._clearHierarchyAnimator(animator, parentAnimator, call_num));
                        }
                    }

                    local_Sprite3D.prototype["_changeHierarchyAnimatorAvatar"] = function (animator, avatar, call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("local_Sprite3D _changeHierarchyAnimatorAvatar death loop")
                            return
                        }
                        this._changeAnimatorAvatar(avatar);
                        for (var i: number = 0, n: number = this._children.length; i < n; i++) {
                            var child = this._children[i];
                            (child._hierarchyAnimator == animator) && (child._changeHierarchyAnimatorAvatar(animator, avatar, call_num));
                        }
                    }

                    local_Sprite3D.prototype["_changeAnimatorToLinkSprite3DNoAvatar"] = function (animator, isLink: boolean, path: string[], call_num = 1): void {
                        ++call_num
                        if (call_num > max_call_num) {
                            GameError.GetInstance().SendErrorToPHP("local_Sprite3D _changeAnimatorToLinkSprite3DNoAvatar death loop")
                            return
                        }
                        animator._handleSpriteOwnersBySprite(isLink, path, this);
                        for (var i: number = 0, n: number = this._children.length; i < n; i++) {
                            var child = this._children[i];
                            var index: number = path.length;
                            path.push(child.name);
                            child._changeAnimatorToLinkSprite3DNoAvatar(animator, isLink, path, call_num);
                            path.splice(index, 1);
                        }
                    }
                }
            }
        };
        this.LoadClientConfig = async () => {
            let load_completed;
            let promise = new Promise<any>((resolve, reject) => {
                load_completed = resolve;
            });

            let load_default_config = () => {
                let load_default_config_call_back = (data) => {
                    if (data) {
                        // let cfg = local_JSON.parse(data);
                        // if (cfg) {
                        this.SetClientConfig(data, false);
                        // }
                        load_completed();
                    }
                    else {
                        load_completed();
                    }
                };
                local_HttpUtil.HttpLoadJson(res_mgr.cdn_res_path, "resource/config/client/ClientConfig.json?v=" + Math.random(), load_default_config_call_back);
            };
            if (LoginModel.GetInstance().plat_name) {
                let load_plat_config_call_back = (data) => {
                    if (data) {
                        // let cfg = local_JSON.parse(data);
                        // if (cfg) {
                        if (Util.IsConch())
                        {
                            if(!data.show_log)//原生包的log开关由远程cfg里的show_log控制
                            {
                                console.log = function (message) {
                                    
                                }
                                console.warn = function (message) {
                                    
                                }
                                LogManager.print_log = false
                            }else
                            {
                                LogManager.print_log = true
                            }
                            LoginModel.GetInstance().plat_name = data.plat_name
                            if(this.native_package_version && data.curr_alpha_version && this.native_package_version > data.curr_alpha_version) {
                                PlatformManager.GetInstance().is_wx_alpha = true
                            }
                        }
                        this.SetClientConfig(data);
                        load_completed();
                        // }
                        // else {
                        //     load_default_config();
                        // }
                    }
                    else {
                        load_default_config();
                    }
                };
                local_HttpUtil.HttpLoadJson(res_mgr.cdn_res_path, `platform/config_${LoginModel.GetInstance().plat_name}.cfg?v=` + Math.random(), load_plat_config_call_back);
            }
            else {
                load_default_config();
            }
            await promise;
        };
        this.LoadGameRes = async () => {
            res_mgr.Init()
            res_mgr.SetMaxLoadingThread(30);
            // window["progress"] = window["LoadStep"]["default_res"];
            Laya.AtlasInfoManager.getFileLoadPath = function (file: string): string {
                // if(Util.IsDebug()) return file
                if(file.indexOf(".png") > 0 && file.indexOf("/texture/") > 0) //图集
                {
                    let atlas_path = file.substring(0, file.lastIndexOf("/")) + ".atlas"
                    return atlas_path
                } else {
                    return file
                }
            }

            await res_mgr.PreloadNecessaryModuleRes();
            let version_p;
            version_p = res_version_mgr.LoadVersionConfig() || true;
            let p1 = res_mgr.LoadDebugIpList();
            let login_p = res_mgr.PreloadLoginConfig()
            await Promise.all([version_p, p1, login_p]);
            window["resource_version_zip"] = null;
            window["has_load_version"] = true;
            this.InitCommonManager();
        };
        
        this.LoadFont = async () => {
            let use_base_font = true
            if(Util.IsConch()){
                use_base_font = false
                var font_name 
                if(PlatformManager.IsEyouThPlatform()){
                    font_name = "th"
                }

                if(font_name){
                    use_base_font = false
                    await new Promise<void>((resolve, reject) => {
                        var xhr = new XMLHttpRequest();
                        xhr.responseType = 'arraybuffer';
                        var ttf_url = `${ResManager.GetInstance().cdn_res_path}resource/font/layabox_tran.ttf`
                        xhr.open('GET', ttf_url, true);
                        xhr.onload = () => 
                        {
                            window["conchTextCanvas"].setFontFaceFromBuffer(font_name, xhr.response);
                            Laya.Text.defaultFont = font_name
                            resolve()
                        };
                        xhr.onerror = function (e) 
                        {
                            console.error('>>>download ttf error :' + e);
                            use_base_font = true
                            resolve()
                        };
                        xhr.send(null);
                    });
                }
            }

            if(use_base_font){
                //注入自定义的素材解析器
                if (Laya.Browser.onMobile) {
                    Laya.Text.defaultFont = "SimHei";
                } else {
                    Laya.Text.defaultFont = "Arial";
                }
            }
        };
        this.InitCommonManager = async () => {
            GameError.GetInstance();
            // stage_.setContentSize(870, 1560)
            layer_mgr.stage = stage_;
            layer_mgr.stageWidth = stage_.width;
            layer_mgr.stageHeight = stage_.height;
            layer_mgr.srcStageWidth = stage_.width;
            layer_mgr.srcStageHeight = stage_.height;
            layer_mgr.InitUILayer();
            console.warn(`initSize: ${stage_.width} ${stage_.height}`)
            let src_screen_ratio = layer_mgr.srcStageWidth / layer_mgr.srcStageHeight
            let standard_screen_ratio = 720 / 1280
            if (standard_screen_ratio > src_screen_ratio)//长屏设备取其高度作为摄像机的size
            {
                layer_mgr.camera_base_size = layer_mgr.srcStageHeight * 0.01
            }
            let onResize = (e: Laya.Event) => {
                console.warn(`onResize: ${stage_.width} ${stage_.height}`)
                layer_mgr.stageWidth = stage_.width;
                layer_mgr.stageHeight = stage_.height;
                layer_mgr.UpdateUILayer();
                // SysInfoMiniMgr.GetInstance().UpdateMessageConX();
                local_GlobalEventSystem.Fire(local_EventName.STATE_RESET_SIZE, layer_mgr.stageWidth, layer_mgr.stageHeight);
            };
            stage_.on(Laya.Event.RESIZE, this, onResize);
            layer_mgr.UpdateUILayer();

            // user_msg_adapter;
            RoleManager.GetInstance()
            new LoginController();
            RoleController.GetInstance();
            ServerTimeController.GetInstance();
            new SettingController()
            // if(local_Util.IsWXGame() &&  window[plat_form_mgr.sdk_name])
            // {
            //     window[plat_form_mgr.sdk_name].dataPlacement({ action: 25000 });
            // }
        };
        this.OpenAccoutView = () => {
            OverrideEngineCode.AfterEngineInit()
            ResManager.GetInstance().Preload3DScene()
            // ResManager.GetInstance().OverrideAniComplete()
            // 开启登录流程
            new SysInfoController();
            LoginManager.GetInstance().Fire(LoginStateEvent.SHOW_LOGIN_BG_FIRST);
            // local_LoginManager_Instance.Fire(LoginStateEvent.START_LOGIN_MODULE)
            ViewManager.GetInstance().PreloadWaitforOpenViewLoading();
        };
    }
    public static GetInstance() {
        if (GameScriptModule.Instance == null) {
            GameScriptModule.Instance = new GameScriptModule();
        }
        return GameScriptModule.Instance;
    }
}

window["GameScriptModule"] = GameScriptModule