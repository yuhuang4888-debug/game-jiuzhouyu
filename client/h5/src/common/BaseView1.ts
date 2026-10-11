// console.warn("BaseView1@UIEffect")
import { UIEffect } from "./UIEffect";
// console.warn("BaseView1@LayerManager")
import { Enum_UILayer, LayerManager } from "./LayerManager";
// console.warn("BaseView1@DeclareGlobalVar")
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
// console.warn("BaseView1@EventName")
import { EventName, SceneEventType } from "./EventName";
// console.warn("BaseView1@ResManager")
import { ResManager } from "./ResManager";
// console.warn("BaseView1@DeclareGlobalVar")
import {LOAD_QUEUE} from "../util/DeclareGlobalVar"
// console.warn("BaseView1@ViewManager")
import { ViewManager } from "./ViewManager";
// console.warn("BaseView1@TimeUtil")
import { TimeUtil } from "../util/TimeUtil";
// console.warn("BaseView1@PopManager")
import { PopManager } from "./PopManager";
// console.warn("BaseView1@CommonManager")
import { CommonManager } from "./CommonManager";
import { GetQualifiedClassName, Util } from "../util/Util";
import { GameResPath } from "../util/GameResPath";
import { TranslationManager } from "../commonController/TranslationManager";
// import { CompressTextureProcessor } from "../CompressTextureProcessor";
// console.warn("BaseView1")
// // // TypeScript file
export enum CloseMode {
    CloseVisible = 1,
    CloseDestroy = 2
}
export enum OpenMode {
    OpenOnly,
    OpenToggle
}
window["CloseMode"] = CloseMode;
window["OpenMode"] = OpenMode;
export interface BaseViewInterface {
    name: string;
    base_file: string;
    layout_file: string;
    new ();
    Open(...parms);
    DeleteMe();
    Close();
    PopUpChild();
    Destroy();
    HasOpen();
}
export class BaseView1 extends UIEffect {
    static localBackOut = function(t: number, b: number, c: number, d: number, s: number = 3.70158): number {
        return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
    }
    public base_file: string = "";
    public layout_file: string = "";
    public layer_value: number = Enum_UILayer.UI;
    public destroy_imm: Boolean = false;
	public destroy_child_imm: Boolean = false;	// BaseWin的子界面是否需要立即删除
    public delay_delete_time: number = 3000;
    private _destroy_timer;
    protected open_mode = OpenMode.OpenOnly;
    protected close_mode: CloseMode = CloseMode.CloseDestroy;
    public isPop: boolean = false;
    public is_loaded: boolean = false;
    public is_loading: Boolean = false;
    public load_callback: Function;
    public open_callback: Function;
    public close_callback: Function;
    public destroy_callback: Function;
    private uilayer: Laya.Sprite;
    private popChild: any;
    public is_load_res: boolean = true; // 没有自己独立资源的界面 不需要加载资源组 
    public change_scene_close = false; //切场景自动关闭
    public click_bg_toClose: boolean = false; //点击背景关闭
    public click_bg_can_close_time: number; //秒，多少秒后，背景才可以接收点击事件，关闭界面
    public open_view_time: number;
    public back_login_toClose = false; //返回登录关闭
    public is_lastView_close: boolean = false; //打开一个界面 是否关闭上一个界面
    public need_close_between_field_scene = false; //野外场景到野外场景之间的切场景是否要关闭界面
    public back_login_toClose_id;
    private change_scene_close_event_id = undefined;
    public is_delay_callback = false; //是否延迟执行 loadcallback 和opencallback
    private delay_load_id; //延迟销毁句柄
    public append_to_ctl_queue = false; //添加进控制队列 打开一个界面会隐藏存在于该队列的所有界面，关闭一个界面会打开一个最近添加进队列的界面
    protected is_center: boolean = false;
    public use_background: boolean = false;
    public use_background2: boolean = false;
    public show_custom_background = false //显示自定义背景
    public backgroup_touchEnable = true;
    public background_alpha: number = 1;
    private _background: Laya.Image;
    protected show_open_movie = false;
    public default_child_index: number = null; //默认的深度值 如果为空则放在最上面 否则设置setChildIndex
    public dependent_res: Array<string>;
    public not_show_main_msg = false;
    public need_loading_view = true; //加载的时候需要打开loading界面
    public not_show_attr_main_msg = false; //是否允许属性提升飘字上界面上面
    public not_show_item_use = false; //是否允许道具推送
    public not_close_by_android_back_key = false; //android返回键是否可以关闭界面
    public not_tooltips_jump_close = false//物品tips跳转时是否可以关闭
    public tips_jump_id
    public close_imme = false // 是否立即关闭，有的界面关闭后会打开某些新的界面
    public preload_server_config;
    public preload_client_config;
    static NOT_SHOW_MAIN_MSG_OPEN_VIEW = {};
    static NOT_SHOW_ATTR_MAIN_MSG_OPEN_VIEW = {};
    static NOT_SHOW_ITEM_USE_OPEN_VIEW = {};
    
    LoadResAsync;
    LoadCompletedCallbackHandler;
    OnLoadCompleted;
    AfterOpen;
    SetScale;
    HasOpen;
    LocalOpen;
    CanOpen;
    LocalClose;
    CloseHandler;
    CloseVisible;
    CloseDestroy;
    AfterClose;
    LocalDestroy;
    PopUpChild;
    SetVisible;
    hide_maincanvas: boolean;
    ReOpen_callback: any;
    public constructor() {
        super();
        let local_GlobalEventSystem = GlobalEventSystem;
        let local_EventName = EventName;
        let local_Enum_UILayer = Enum_UILayer;
        let res_mgr = ResManager.GetInstance();
        let layer_mgr = LayerManager.GetInstance();
        let view_mgr = ViewManager.GetInstance();
        let local_BaseView1 = BaseView1;
        this.LoadResAsync = async () => {
            let res_json;
            let self = this
            self.is_loading = true;
            self.is_loaded = false;
            if (self.need_loading_view && self.layer_value != local_Enum_UILayer.Main) { // loading界面
                local_GlobalEventSystem.Fire(local_EventName.SHOW_WAITFOR_OPENVIEW_LOADING, self.hashCode);
            }
            let preload_cfg_list:Array<any> = null
            let cfg
            if (self.preload_client_config) {
                preload_cfg_list = []
                for (let config_name in self.preload_client_config) {
                    if (!self.preload_client_config[config_name]) {
                        cfg = res_mgr.GetGameConfigFromCache(self, config_name, true);
                        if (!cfg) {
                            preload_cfg_list.push(res_mgr.LoadGameConfig(self, config_name, true, LOAD_QUEUE.HIGHT));
                        }
                    }
                }
            }
            if (self.preload_server_config) {
                preload_cfg_list = preload_cfg_list || []
                for (let config_name in self.preload_server_config) {
                    if (!self.preload_server_config[config_name]) {
                        cfg = res_mgr.GetGameConfigFromCache(self, config_name, false);
                        if (!cfg) {
                            preload_cfg_list.push(res_mgr.LoadGameConfig(self, config_name, false, LOAD_QUEUE.HIGHT));
                        }
                    }
                }
            }
            if(preload_cfg_list)
            {
                await Promise.all(preload_cfg_list)
            }
            if (self.preload_client_config) {
                for (let config_name in self.preload_client_config) {
                    if (!self.preload_client_config[config_name]) {
                        cfg = res_mgr.GetGameConfigFromCache(self, config_name, true);
                        if (cfg) {
                            self.preload_client_config[config_name] = cfg;
                        }
                    }
                }
            }
            if (self.preload_server_config) {
                for (let config_name in self.preload_server_config) {
                    if (!self.preload_server_config[config_name]) {
                        cfg = res_mgr.GetGameConfigFromCache(self, config_name, false);
                        if (cfg) {
                            self.preload_server_config[config_name] = cfg;
                        }
                    }
                }
            }
            res_mgr.LoadUILayoutFile(this.hashCode, this.base_file ,this.layout_file, this.OnLoadCompleted, this)
        };
        this.LoadCompletedCallbackHandler = () => {
            this.is_loading = false;
            this.is_loaded = true;
            this.createChildren()
            if (this.load_callback) {
                this.load_callback();
                TranslationManager.GetInstance().UpdateViewComponent(this)
            }
			if (!this.isPop){
				return
			}
            
            if (this.use_background2 && !this.use_background && this.uilayer) {
                let background = new Laya.Image()
                if (this.show_custom_background && Laya.Browser.onMobile) 
                {
                    // background.skin="resource/game/login/texture/full_screen_bg1.jpg"
                    ResManager.GetInstance().SetTexture(this, background, "resource/game/login/texture/full_screen_bg1.jpg")
                    background.width = 1280 * Laya.stage.height / 720
                    background.height = Laya.stage.height
                    background.x = 0
                    background.y = 0
                    background.alpha = 1
                }else
                {
                    background.skin = GameResPath.GetIcon("common", "com_sub_bg_7")
                    background.width = this.uilayer.width + 10
                    background.height = this.uilayer.height + 10
                    background.x = -5
                    background.y = -5
                    background.alpha = this.background_alpha
                }
                let curr_index = this.uilayer.getChildIndex(this.display_obj)
                this.uilayer.addChildAt(background, curr_index)
                if (this.click_bg_toClose) {
                    background.mouseEnabled = true
                    Util.AddClickEvent(background, () => { 
                        if(this.click_bg_toClose) //有可能中途会设置为false
                            this.Close() 
                    }, this)
                }
                this._background = background
            }
            this.AfterOpen();
        };
        this.OnLoadCompleted = (view?: Laya.View, URL?: string) => {
            // try//异步代码里报错不会触发window.onerror 所以需要用try catch来捕获
            // {
            if (this.need_loading_view && this.layer_value != local_Enum_UILayer.Main) {
                local_GlobalEventSystem.Fire(local_EventName.HIDE_WAITFOR_OPENVIEW_LOADING, this.hashCode);
            }
            if(!view)
            {
                return
            }
            if (!this.isPop) {
                view.destroy()
                this.Destroy();
                return;
            }
            this.display_obj = view
            this.uilayer = layer_mgr.GetUILayer(this.layer_value);
            if (this.uilayer) {
                if (this.default_child_index == null) {
                    this.uilayer.addChild(view);
                }
                else {
                    this.uilayer.setChildIndex(view, this.default_child_index);
                }
            }
            if (this.is_center) {
                this.display_obj.centerX = this.display_obj.centerY = 0
            }
            if (this.is_delay_callback) {
                let onDelayCallback = () => {
                    if (!this.use_delete_method) {
                        this.delay_load_id = null;
                        this.LoadCompletedCallbackHandler();
                    }
                };
                this.delay_load_id = view_mgr.AddDelayQueue(onDelayCallback);
            }
            else {
                this.LoadCompletedCallbackHandler();
            }
            // } catch (error) {
            //     let str = "local_BaseView1 OnLoadCompleted error "
            //     if (error.stack) {
            //         str += error.stack
            //     }
            //     GameError.GetInstance().SendErrorToPHP(str, true)
            // }
        };
        this.AfterOpen = () => {
            if (this.isPop) {
                this.open_view_time = TimeUtil.getServerTime();
                let SysInfoMiniMgr = window["SysInfoMiniMgr"]
                if (this.not_show_main_msg) {
                    local_BaseView1.NOT_SHOW_MAIN_MSG_OPEN_VIEW[this.hashCode] = true;
                    SysInfoMiniMgr.GetInstance().ResetItem();
                }
                if (this.not_show_attr_main_msg) {
                    local_BaseView1.NOT_SHOW_ATTR_MAIN_MSG_OPEN_VIEW[this.hashCode] = true;
                    SysInfoMiniMgr.GetInstance().ResetItem(SysInfoMiniMgr.MessageType.Two);
                }
                if (this.not_show_item_use) {
                    local_BaseView1.NOT_SHOW_ITEM_USE_OPEN_VIEW[this.hashCode] = true;
                }
                if (this.is_lastView_close)
                    PopManager.GetInstance().popViewOpen(this);
                this.SetVisible(true)
                if (this.open_callback) {
                    this.open_callback();
                }
				if (!this.isPop){
					return
				}
                if (this.layer_value != local_Enum_UILayer.Main) {
                    view_mgr.OpenView(this);
                }
                if (this.show_open_movie) {
                    Laya.Tween.clearAll(this.display_obj)
                    this.display_obj.anchorX = 0.5
                    this.display_obj.anchorY = 0.75
                    //@ts-ignore
                    this.display_obj.runCallLater(this.display_obj._sizeChanged)
                    //@ts-ignore
                    this.display_obj._getWidget().resetLayout()

                    this.display_obj.scaleX = this.display_obj.scaleY = 0.825;
                    Laya.Tween.to(this.display_obj, { scaleX: 1, scaleY: 1 }, 250, BaseView1.localBackOut)
                }
                local_GlobalEventSystem.Fire(local_EventName.BASEVIEW_OPEN_OR_CLOSE, true, this.base_file, this.layer_value, this.layout_file, this);
            }
            else {
                this.Close();
            }
        };
        this.SetScale = (scale) => {
        };
        //是否真正打开  判断依据是调用了open以及资源加载已经完成
        this.HasOpen = () => {
            return this.isPop && this.is_loaded;
        };
        this.CanOpen = () => {
            let func_is_open = CommonManager.GetInstance().CheckFuncOpenState(GetQualifiedClassName(this));
            if (func_is_open == false) {
                return false;
            }
            if (this.open_mode == OpenMode.OpenToggle && this.isPop) {
                this.Close();
                return false;
            }
            return true;
        };
        this.LocalOpen = () => {
            //判断该功能是否开放
            if (!this.CanOpen()) {
                return;
            }
            this.use_delete_method = false;
            if (this._destroy_timer) {
                clearTimeout(this._destroy_timer);
                this._destroy_timer = null;
            }
            this.isPop = true;
            if (!this.is_loading) {
                if (this.is_loaded) {
                    if (this.is_delay_callback) {
                        let onDelayCallback = () => {
                            if (!this.use_delete_method) {
                                this.delay_load_id = null;
                                if (this.default_child_index == null) {
                                    this.uilayer.addChild(this.display_obj);
                                }
                                else {
                                    this.uilayer.setChildIndex(this.display_obj, this.default_child_index);
                                }
                                if(this._background)
                                {
                                    this._background.removeSelf()
                                    let curr_index = this.uilayer.getChildIndex(this.display_obj)
                                    this.uilayer.addChildAt(this._background, curr_index)
                                }
                                this.AfterOpen();
                            }
                        };
                        this.delay_load_id = view_mgr.AddDelayQueue(onDelayCallback);
                    }
                    else {
                        if (this.default_child_index == null) {
                            this.uilayer.addChild(this.display_obj);
                        }
                        else {
                            this.uilayer.setChildIndex(this.display_obj, this.default_child_index);
                        }
                        if(this._background)
                        {
                            this._background.removeSelf()
                            let curr_index = this.uilayer.getChildIndex(this.display_obj)
                            this.uilayer.addChildAt(this._background, curr_index)
                        }
                        this.AfterOpen();
                    }
                }
                else {
                    this.LoadResAsync();
                }
            }
            if ((this.change_scene_close == true || this.need_close_between_field_scene) && !this.change_scene_close_event_id) {
                let scene_start = () => {
                    //如果是从 材料副本 或者主线副本 进入退出出 不关闭打开的界面
                    let scene_mgr = window["SceneManager"].GetInstance()
                    let scene_id_list = [scene_mgr.curr_scene_id, scene_mgr.last_scene_id];
                    for (let id of scene_id_list) {
                        if (id) {
                            if (scene_mgr.IsMainLineDungeonScene(id)
                                || scene_mgr.IsNineSkyFightScene(id)
                                || scene_mgr.IsKfNineSkyFightScene(id))
                                return;
                        }
                    }
                    let dun_id_list = [scene_mgr.curr_dun_id, scene_mgr.last_dun_id];
                    for (let id of dun_id_list) {
                        if (id) {
                            if (scene_mgr.IsHeartDungeon(id))
                                return;
                        }
                    }
                    //野外场景和野外场景之间切且场景，是否要关闭界面
                    if (scene_mgr.IsFieldScene(scene_mgr.last_scene_id)
                        && scene_mgr.IsFieldScene()) {
                        if (this.need_close_between_field_scene) {
                            this.Close();
                        }
                        return;
                    }
                    if (this.change_scene_close) {
                        this.Close();
                    }
                };
                this.change_scene_close_event_id = local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, scene_start);
            }
            if (this.back_login_toClose && !this.back_login_toClose_id) {
                let on_back_login = () => {
                    this.Close();
                };
                this.back_login_toClose_id = local_GlobalEventSystem.Bind(local_EventName.CHANGE_ACCOUNT, on_back_login);
            }

            if ((this.layer_value == Enum_UILayer.Activity || this.layer_value == Enum_UILayer.Top) && !this.not_tooltips_jump_close && !this.tips_jump_id) {
                let close = () => {
                    this.Close()
                }
                this.tips_jump_id = local_GlobalEventSystem.Bind(EventName.TOOLTIPS_JUMP, close)
            }
        };
        this.LocalClose = () => {
            this.isPop = false;
            // if (this.show_open_movie) {
            //     Laya.Tween.clearAll(this.display_obj)
            //     this.display_obj.scaleX = this.display_obj.scaleY = 1
            //     Laya.Tween.to(this.display_obj, { scaleX: 0.8, scaleY: 0.8 }, 280, Laya.Ease.elasticInOut, Laya.Handler.create(this, this.CloseHandler))
            //     // local_egret.Tween.get(this).to({ scaleX: 1.02, scaleY: 1.02 }, 90).wait(90).to({ scaleX: 0.8, scaleY: 0.8 }, 100).call(this.CloseHandler, this);
            // }
            // else {
                this.CloseHandler();
            // }
        };
        this.CloseHandler = () => {
            if (this.close_mode == CloseMode.CloseVisible) {
                this.CloseVisible();
            }
            else {
                this.CloseDestroy();
            }
            view_mgr.CloseView(this);
            
        };
        this.CloseVisible = () => {
            this.SetVisible(false);
            if (this.change_scene_close_event_id) {
                local_GlobalEventSystem.UnBind(this.change_scene_close_event_id);
                this.change_scene_close_event_id = undefined;
            }
            if (this.back_login_toClose_id) {
                local_GlobalEventSystem.UnBind(this.back_login_toClose_id);
                this.back_login_toClose_id = undefined;
            }
            if (this.tips_jump_id) {
                local_GlobalEventSystem.UnBind(this.tips_jump_id)
                this.tips_jump_id = undefined
            }
            // local_egret.Tween.removeTweens(this);
            if (this.not_show_main_msg) {
                delete local_BaseView1.NOT_SHOW_MAIN_MSG_OPEN_VIEW[this.hashCode];
            }
            if (this.not_show_attr_main_msg) {
                delete local_BaseView1.NOT_SHOW_ATTR_MAIN_MSG_OPEN_VIEW[this.hashCode];
            }
            if (this.not_show_item_use) {
                delete local_BaseView1.NOT_SHOW_ITEM_USE_OPEN_VIEW[this.hashCode];
            }
            
            this.AfterClose();
        };
        this.CloseDestroy = () => {
            this.CloseVisible();
            if (this.destroy_imm) {
                this.Destroy();
            }
            else {
                if (this._destroy_timer) {
                    clearTimeout(this._destroy_timer);
                    this._destroy_timer = null;
                }
                let delay_destroy_func = () => {
                    this._destroy_timer = null;
                    this.Destroy();
                };
                this._destroy_timer = setTimeout(delay_destroy_func, this.delay_delete_time);
            }
        };
        this.AfterClose = () => {
            if (this.is_lastView_close)
                PopManager.GetInstance().popViewClocse(this);
            if (this.delay_load_id) {
                view_mgr.RemoveDelayQueue(this.delay_load_id);
                this.delay_load_id = null;
            }
            if (this.is_loaded && this.close_callback) {
                this.close_callback();
            }
            this.close_imme = false;
            local_GlobalEventSystem.Fire(local_EventName.RESTORE_FINGER, this.layout_file);
            local_GlobalEventSystem.Fire(local_EventName.BASEVIEW_OPEN_OR_CLOSE, false, this.base_file, this.layer_value, this.layout_file, this);


            if (this.not_show_item_use&&Util.IsTableEmpty(BaseView1.NOT_SHOW_ITEM_USE_OPEN_VIEW)) {
                local_GlobalEventSystem.Fire(local_EventName.CHECK_ITEM_USE)
            }
        };
        this.LocalDestroy = () => {
            if (this.use_delete_method)
                return;
            if (this._destroy_timer) {
                clearTimeout(this._destroy_timer);
                this._destroy_timer = null;
            }
            if (this.is_loaded && this.destroy_callback) {
                this.destroy_callback();
            }
            if (this.preload_client_config) {
                for (let config_name in this.preload_client_config) {
                    this.preload_client_config[config_name] = false;
                }
            }
            if (this.preload_server_config) {
                for (let config_name in this.preload_server_config) {
                    this.preload_server_config[config_name] = false;
                }
            }
            this.is_loading = false;
            this.is_loaded = false;
            if (this._background && this._background.parent) {
                this._background.parent.removeChild(this._background)
                this._background = null
            }
            super.DeleteMe();
            this.popChild = null;
            // this.skinName = "-1";
            local_GlobalEventSystem.Fire(local_EventName.DELETE_VIEW, GetQualifiedClassName(this));
        };
        this.PopUpChild = (child) => {
            if (child) {
                // if (this.popChild != null && this.popChild != child)
                //     this.popChild.visible = false
                // this.popChild = child
                // this.popChild.visible = true
                let func_is_open = child.SetPopUpVisible(true);
                if (func_is_open != false) {
                    if (this.popChild != null && this.popChild != child) {
                        //this.popChild.display_obj.visible = false;
						if (this.destroy_child_imm){	// 子界面立即删除
							this.popChild.DeleteMe()
							this.popChild = null
						} else {						// 子界面隐藏
							this.popChild.SetVisible(false)
						}
                    }
                    this.popChild = child;
                }
            }
        };
        this.SetVisible = (value) => {
            if(this.display_obj)
            {
                this.display_obj.visible = value;
                if(this._background) this._background.visible = value
                if (value) {
                    view_mgr.ShowBackGroup(this);
                }
                else {
                    view_mgr.HideBackgroup(this);
                }
            }
        };
    }
    public Open() {
        this.LocalOpen();
    }
    public Close() {
        this.LocalClose();
    }
    public Destroy() {
        this.LocalDestroy();
    }
    public DeleteMe() {
        if (!this.use_delete_method) {
            this.CloseDestroy();
        }
    }

    public Hide(){
        this.SetVisible(false)
    }

    public CancelHide(){
        this.SetVisible(true)
        if (this.ReOpen_callback ){
            this.ReOpen_callback()
        }
    }

}
window["BaseView1"] = BaseView1