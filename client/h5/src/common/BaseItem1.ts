import { UIEffect } from "./UIEffect";
import { CommonManager } from "./CommonManager";
import { ResManager } from "./ResManager";
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { ViewManager } from "./ViewManager";
import { GetQualifiedClassName } from "../util/Util";
import { TranslationManager } from "../commonController/TranslationManager";
// TypeScript file
export class BaseItem1 extends UIEffect {
    public base_file: string = "";
    public layout_file: string = "";
    public is_loaded: boolean = false;
    public is_loading: Boolean = false;
    public load_callback: Function;
    public is_load_res = true;
    public layer_value;
    public dependent_res: Array<string>;
    public preload_server_config;
    public preload_client_config;
    public is_delay_callback = false; //是否延迟执行 loadcallback
    private delay_load_id; //延迟销毁句柄
    protected _parent: Laya.Sprite;
    protected data_callbacks: Array<Function> = new Array<Function>();
    private popChild: any;
    private cache_pos_x
    private cache_pos_y
    private cache_visible
    private cache_scale

    public constructor(parent: Laya.Sprite) {
        super();
        this._parent = parent;
        // this.once(egret.Event.REMOVED_FROM_STAGE, () =>
        //  {
        //      if(!this.use_delete_method)
        //      {
        //          Alert.RepeatShow(this["constructor"].name+"\n没有调用DeleteMe")
        //      }
        //  }
        //  , this)
    }
    public SetPopUpVisible(value) {
        let self = this;
        if (!self.is_loading) {
            if (self.is_loaded && self.display_obj) {
                self.display_obj.visible = value;
            }
            else {
                let func_is_open = self.Load();
                return func_is_open;
            }
        }
    }

    public Load() {
        //该功能是否开放
        let self = this;
        let func_is_open = CommonManager.GetInstance().CheckFuncOpenState(GetQualifiedClassName(self));
        if (func_is_open == false) {
            return false;
        }
        if (!self.is_loading) {
            if (self.display_obj && self.is_loaded) {
                if (!self.display_obj.visible) {
                    self.display_obj.visible = true;
                }
                self.AfterLoad();
            }
            else {
                self.LoadResAsync();
            }
        }
    }

    private async LoadResAsync() {
        let self = this, res_mgr = ResManager.GetInstance(), res_json;
        self.is_loading = true;
        self.is_loaded = false;
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
        if (self.use_delete_method)
            return;
        res_mgr.LoadUILayoutFile(this.hashCode, this.base_file, this.layout_file, this.OnLoadCompleted, this)
    }
    private OnLoadCompleted(view?: Laya.View, URL?: string) {
        // try { //try//异步代码里报错不会触发window.onerror 所以需要用try catch来捕获
        let self = this;
        if (!view) {
            return
        }
        if (self.use_delete_method) {
            view.destroy()
            return;
        }
        self.display_obj = view
        if (self._parent) {
            self._parent.addChild(self.display_obj);
        }
        this.createChildren()
        self.AfterLoad();
        // }
        // catch (error) {
        //     let str = "BaseItem OnLoadCompleted error ";
        //     if (error.stack) {
        //         str += error.stack;
        //     }
        //     GameError.GetInstance().SendErrorToPHP(str, true);
        // }
    }
    private LoadCompletedCallbackHandler() {
        let self = this;
        self.is_loading = false;
        self.is_loaded = true;
        if (self.cache_pos_x != null && self.cache_pos_y != null) {
            self.SetPosition(self.cache_pos_x, self.cache_pos_y)
            self.cache_pos_x = self.cache_pos_y = null
        }
        if (!self.display_obj.visible) {
            self.display_obj.visible = true;
        }

        if (self.cache_visible != null) {
            self.SetVisible(self.cache_visible)
            self.cache_visible = null
        }
        if (self.cache_scale != null) {
            self.SetScale(self.cache_scale)
            self.cache_scale = null
        }

        if (self.load_callback) {
            self.load_callback();
            TranslationManager.GetInstance().UpdateViewComponent(self)
        }
        if (self.data_callbacks.length > 0) {
            for (let callback of self.data_callbacks) {
                callback();
            }
            self.data_callbacks.length = 0;
        }
    }
    private AfterLoad() {
        let self = this;
        if (self.is_delay_callback) {
            // this.display_obj.visible = false
            let onDelayCallback = () => {
                if (!self.use_delete_method) {
                    self.delay_load_id = null;
                    // this.display_obj.visible = true
                    self.LoadCompletedCallbackHandler();
                }
            };
            self.delay_load_id = ViewManager.GetInstance().AddDelayQueue(onDelayCallback);
        }
        else {
            self.LoadCompletedCallbackHandler();
        }
    }
    public DeleteMe() {
        let self = this;
        if (!self.use_delete_method) {
            if (self.delay_load_id) {
                ViewManager.GetInstance().RemoveDelayQueue(self.delay_load_id);
                self.delay_load_id = null;
            }
            if (self.preload_client_config) {
                for (let config_name in self.preload_client_config) {
                    self.preload_client_config[config_name] = false;
                }
            }
            if (self.preload_server_config) {
                for (let config_name in self.preload_server_config) {
                    self.preload_server_config[config_name] = false;
                }
            }

            self.cache_pos_x = self.cache_pos_y = self.cache_visible = null
            self.popChild = null;
            self.is_loaded = false;
            super.DeleteMe();
            // self.skinName = "-1";
        }
    }
    public ExcuteCallback(callback) {
        if (this.is_loaded) {
            callback();
        }
        else {
            this.data_callbacks.push(callback);
        }
    }
    public PopUpChild(child) {
        if (child) {
            let self = this;
            if (self.popChild && self.popChild != child) {
                if (self.popChild.display_obj)
                    self.popChild.display_obj.visible = false;
            }
            self.popChild = child;
            if (self.popChild.display_obj)
                self.popChild.display_obj.visible = true;
        }
    }

    public SetVisible(bool) {
        if (this.is_loaded) {
            this.display_obj.visible = bool
        }
        else {
            this.cache_visible = bool
        }
    }

    public GetVisible() {
        if (this.is_loaded) {
            return this.display_obj.visible
        }
        else {
            return false
        }
    }

    public SetPosition(x, y) {
        if (this.is_loaded) {
            // console.warn("BaseItem1@SetPosition", x, y)
            this.display_obj.x = x
            this.display_obj.y = y
        }
        else {
            // console.warn("BaseItem1@SetPosition@cache", x, y)
            this.cache_pos_x = x
            this.cache_pos_y = y
        }
    }

    public SetScale(scale) {
        if (this.is_loaded) {
            this.display_obj.scaleX = scale
            this.display_obj.scaleY = scale
        }
        else {
            this.cache_scale = scale
        }
    }

    public get GetPoxX() {
        if (this.is_loaded) {
            return this.display_obj.x;
        } else {
            return this.cache_pos_x
        }
    }

    public get GetPoxY() {
        if (this.is_loaded) {
            return this.display_obj.y;
        } else {
            return this.cache_pos_y
        }
    }
}
window["BaseItem1"] = BaseItem1