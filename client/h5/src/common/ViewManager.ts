
import { HashEventDispatcher } from "./HashEventDispatcher";
import { LayerManager, Enum_UILayer } from "./LayerManager";
import { GlobalEventSystem, FRAME_TYPE } from "../util/DeclareGlobalVar";
import { EventName } from "./EventName";
import { Runner } from "../util/Runner";
import { TimeUtil } from "../util/TimeUtil";
import { GameError } from "../util/GameError";
import { GameResPath } from "../util/GameResPath";
import { Scene } from "../scene/Scene";
import { Alert } from "../alert/Alert";
import { LoginModel } from "../login/LoginModel";
import { Character } from "../scene/sceneobj/Character";
import { PoseState } from "../util/StateMachineManager";
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel";
import { Util } from "../util/Util";
import { CameraManager } from "../scene/CameraManager";
import { MapManager } from "../scene/MapManager";
let local_Util = Util
export class ViewManager extends HashEventDispatcher {
    private static _instance: ViewManager;

    //打开大界面的帧数
    public static OPENBIGVIEWFRAME = 1
    private view_dic;
    public view_ctl_queue = {};
    private view_index = 0;
    private now_open_view_list = {};
    private now_open_view_index = 0;
    private has_backgroup_view_dic = {};
    private _protected_logic_timer_id;
    private _background: Laya.Image;
    private _max_alpha = 0;
    private delay_ui_list = [];
    private waitfor_openView_loading
    private _check_scene3dobj_time_id

    public static PUSH_VIEWS_OUT_SCREEN = "PUSH_VIEWS_OUT_SCREEN"

    // private activity_state
    OpenBaseWindow;
    CloseBaseWindow;
    static is_lock_screen

    constructor() {
        super();
        let layer_mgr = LayerManager.GetInstance(), local_GlobalEventSystem = GlobalEventSystem, local_Enum_UILayer = Enum_UILayer;
        this.OpenBaseWindow = (force_hide: boolean = false) => {
            if ((force_hide || !window["Util"].IsTableEmpty(window["BaseWindowComponent"].CURR_OPEN_VIEW)) && ViewManager.OPENBIGVIEWFRAME == 1) {
                ViewManager.OPENBIGVIEWFRAME = 4
                
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.Shadow, "ViewManager", false)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.NameBoard, "ViewManager", false)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.TalkBoard, "ViewManager", false)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.DamageFont, "ViewManager", false)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.Main, "ViewManager", false)
                MapManager.GetInstance().SetMapVisible("ViewManager", false)
                LayerManager.GetInstance().SetScene3DVisible("ViewManager", false)
                CameraManager.GetInstance().SetMainCameraVisible("ViewManager", false)
            }
            local_GlobalEventSystem.Fire(EventName.CHANGE_CUR_VIEW_COUNT);
        };
        this.CloseBaseWindow = () => {
            if (window["Util"].IsTableEmpty(window["BaseWindowComponent"].CURR_OPEN_VIEW) && ViewManager.OPENBIGVIEWFRAME == 4) {
                ViewManager.OPENBIGVIEWFRAME = 1

                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.Shadow, "ViewManager", null)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.NameBoard, "ViewManager", null)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.TalkBoard, "ViewManager", null)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.DamageFont, "ViewManager", null)
                LayerManager.GetInstance().SetLayerVisible(local_Enum_UILayer.Main, "ViewManager", null)
                MapManager.GetInstance().SetMapVisible("ViewManager", null)
                LayerManager.GetInstance().SetScene3DVisible("ViewManager", null)
                CameraManager.GetInstance().SetMainCameraVisible("ViewManager", null)
                Scene.GetInstance().ReplayAllAction()
            }
            local_GlobalEventSystem.Fire(EventName.CHANGE_CUR_VIEW_COUNT);
            ViewPopLevelModel.GetInstance().NextPop();
        };
        this.view_dic = {};
        this.InitEvent();
    }
    public static GetInstance() {
        if (!ViewManager._instance) {
            ViewManager._instance = new ViewManager();
        }
        return ViewManager._instance;
    }
    public GetViewBackgroup = () => {
        if (!this._background) {
            this._background = new Laya.Image();
            this._background.skin = GameResPath.GetIcon("common", "com_sub_bg_7")
            // this._background.width = LayerManager.GetInstance().stageWidth + 10
            // this._background.height = LayerManager.GetInstance().stageHeight + 10
            // this._background.x = -5
            // this._background.y = -5
            this.ScreenSizeChange();
        }
        return this._background;
    };
    private ScreenSizeChange() {
        if (this._background) {
            this._background.width = LayerManager.GetInstance().stageWidth + 10;
            this._background.height = LayerManager.GetInstance().stageHeight + 10;
            this._background.x = -5;
            this._background.y = -5;
        }
    }
    public PreloadWaitforOpenViewLoading = () => {
        this.waitfor_openView_loading = new window["WaitforOpenViewLoading"](LayerManager.GetInstance().GetUILayer(Enum_UILayer.Message))
        this.waitfor_openView_loading.Load()
    };
    private InitEvent = () => {
        //打开界面
        GlobalEventSystem.Bind(EventName.OPEN_VIEW, (view_name: string, ...parms) => {
            if (window["PlatformManager"].GetInstance().is_alpha && (view_name == "DungeonBuyTimeView" || view_name == "DungeonMaterialAlertView")) {
                return
            }
            // let view_name = view_class.prototype.__class__
            console.log("open" + view_name)
            let view = this.view_dic[view_name];
            if (!view) {
                this.view_dic[view_name] = true;
                if (!window[view_name]) {
                    let viewModule;
                    // await new Promise<void>((resolve, reject) => {
                    //     ResManager.GetInstance().LoadGameConfig(this, "ConfigViewModule", true, LOAD_QUEUE.HIGHT, (view_module_cfg) => {
                    //         viewModule = view_module_cfg && view_module_cfg[view_name];
                    //         ResManager.GetInstance().DestoryGameConfig(this, "ConfigViewModule", true);
                    //         resolve();
                    //     });
                    // });
                    if (!viewModule) {
                        console.log(`${view_name}还没添加配置`);
                        return;
                    }
                    // if (!ResManager.GetInstance().IsJsLoad(viewModule)) {
                    //     await ResManager.GetInstance().LoadJs(viewModule);
                    // }
                }
                if (this.view_dic[view_name] == true) {
                    let view_class = window[view_name];
                    view = new view_class();
                    this.view_dic[view_name] = view;
                }
            }
            if (view && view != true) {
                view.Open(...parms);
                ViewPopLevelModel.GetInstance().isPopIng = false;
            }
        });
        GlobalEventSystem.Bind(EventName.CLOSE_VIEW, (view_name: string) => {
            let view = this.view_dic[view_name];
            if (view && view != true) {
                view.Close();
            }
            else if (view == true) {
                delete this.view_dic[view_name];
            }
        });
        GlobalEventSystem.Bind(EventName.DELETE_VIEW, (view_name) => {
            let view = this.view_dic[view_name];
            if (view) {
                delete this.view_dic[view_name];
            }
        });
        GlobalEventSystem.Bind(EventName.CHANGE_ACCOUNT, () => {
            for (let key in this.view_dic) {
                let view = this.view_dic[key];
                if (view && view != true) {
                    view.Close();
                }
            }
            this.view_dic = {};
        });
        let screen_size_change = (stageWidth, stageHeight) => {
            this.ScreenSizeChange();
        };
        GlobalEventSystem.Bind(EventName.STATE_RESET_SIZE, screen_size_change);
    };
    //添加进入延迟队列
    public AddDelayQueue = (call_back) => {
        this.delay_ui_list.push(call_back);
        Runner.GetInstance().AddRunObj(this, 1, FRAME_TYPE.total);
        return call_back;
    };
    //移除
    public RemoveDelayQueue = (call_back) => {
        let index = this.delay_ui_list.indexOf(call_back);
        if (index && index >= 0) {
            this.delay_ui_list.splice(index, 1);
        }
        if (this.delay_ui_list.length == 0) {
            Runner.GetInstance().RemoveRunObj(this.hashCode);
        }
    };
    public Update = (now_time: number, elapse_time: number) => {
        let size = this.delay_ui_list.length;
        if (size > 0) {
            let call_back;
            if (size <= 10) {
                call_back = this.delay_ui_list.shift();
                if (call_back) {
                    call_back();
                }
                if (this.delay_ui_list.length == 0) {
                    Runner.GetInstance().RemoveRunObj(this.hashCode);
                }
            }
            else {
                size = Math.ceil(size * 0.1);
                for (let i = 0; i < size; i++) {
                    call_back = this.delay_ui_list.shift();
                    if (call_back) {
                        call_back();
                    }
                }
            }
        }
    };
    public GetView = (view_name: string) => {
        let view = this.view_dic[view_name] == true ? undefined : this.view_dic[view_name];
        return view;
    };

    public GetViewOpenState = (view_name: string) => {
        let view = this.view_dic[view_name]
        let bool = false
        if (view == true) return false
        if (view && view.HasOpen()) {
            bool = true
        }
        return bool
    }
    public OpenView = (ref_tar) => {
        if (ref_tar.append_to_ctl_queue && this.view_ctl_queue[ref_tar.hashCode] == undefined) {
            for (let hashCode in this.view_ctl_queue) {
                let obj = this.view_ctl_queue[hashCode];
                if (obj) {
                    obj.view.SetVisible(false);
                }
            }
            this.view_index++;
            this.view_ctl_queue[ref_tar.hashCode] = { "index": this.view_index, view: ref_tar };
        }
        this.ShowBackGroup(ref_tar);
        if (local_Util.IsConch() && !ref_tar.not_close_by_android_back_key && (ref_tar.use_background2 || ref_tar.use_background)) {
            this.now_open_view_index++;
            this.now_open_view_list[ref_tar.hashCode] = { "index": this.now_open_view_index, view: ref_tar };
        }
    };
    public ShowBackGroup = (ref_tar, check_mostFront = true) => {
        if (ref_tar.use_background) {
            let background = this.GetViewBackgroup();
            let parent = ref_tar.display_obj.parent;
            let curr_index;
            let bg_index;
            if (parent) {
                curr_index = parent.getChildIndex(ref_tar.display_obj);
                bg_index = parent.getChildIndex(background);
                if (background["curr_view"] == ref_tar && curr_index - bg_index == 1) {
                    if (!check_mostFront && background.alpha != this._max_alpha) {
                        background.alpha = this._max_alpha;
                    }
                    return;
                }
            }
            this.has_backgroup_view_dic[ref_tar.hashCode] = ref_tar;
            if (check_mostFront) {
                let most_front_ref_tar = this.GetMostFrontView();
                if (!most_front_ref_tar) {
                    this.HideBackgroup(ref_tar);
                    return;
                }
                ref_tar = most_front_ref_tar;
                parent = ref_tar.display_obj.parent;
            }
            if (background.alpha != this._max_alpha)
                background.alpha = this._max_alpha; //|| 0 ref_tar.background_alpha
            // if (background["curr_view"] == ref_tar) return
            if (parent) {
                let curr_index = parent.getChildIndex(ref_tar.display_obj);
                bg_index = parent.getChildIndex(background);
                if (background.parent == parent && bg_index <= curr_index) {
                    --curr_index;
                }
                parent.addChildAt(background, curr_index);
                // parent.swapChildren(background, ref_tar)
            }
            if (!this._protected_logic_timer_id) {
                this._protected_logic_timer_id = setInterval(this.ProtectedLogic, 1000);
            }
            background.visible = true;
            // background.includeInLayout = true;
            background.off(Laya.Event.CLICK, this, this.BackgroupClickEvent);
            background["curr_view"] = ref_tar;
            if (background.mouseEnabled != ref_tar.backgroup_touchEnable) {
                background.mouseEnabled = ref_tar.backgroup_touchEnable;
            }
            if (ref_tar.click_bg_toClose) {
                background.on(Laya.Event.CLICK, this, this.BackgroupClickEvent);
            }
        }
    };
    //获得最高层的界面
    public GetMostFrontView = () => {
        let front_view, front_view_parent_depth = -1, front_view_depth = -1, curr_view, curr_view_parent_depth, curr_view_depth;
        this._max_alpha = 0;
        for (let hash_code in this.has_backgroup_view_dic) {
            curr_view = this.has_backgroup_view_dic[hash_code];
            if (curr_view.use_background && curr_view.display_obj && curr_view.display_obj.parent && curr_view.display_obj.parent.parent) {
                if (curr_view.background_alpha > this._max_alpha) {
                    this._max_alpha = curr_view.background_alpha;
                }
                curr_view_parent_depth = curr_view.display_obj.parent.parent.getChildIndex(curr_view.display_obj.parent);
                if (curr_view_parent_depth > front_view_parent_depth) {
                    front_view_parent_depth = curr_view_parent_depth;
                    front_view = curr_view;
                    front_view_depth = curr_view.display_obj.parent.getChildIndex(curr_view.display_obj);
                }
                else if (curr_view_parent_depth == front_view_parent_depth) {
                    curr_view_depth = curr_view.display_obj.parent.getChildIndex(curr_view.display_obj);
                    if (curr_view_depth > front_view_depth) {
                        front_view_depth = curr_view_depth;
                        front_view = curr_view;
                    }
                }
            }
        }
        return front_view;
    };
    private BackgroupClickEvent = (e: Laya.Event) => {
        if (e.target == this._background) {
            let view = this._background["curr_view"];
            if (view) {
                if (view.click_bg_can_close_time && view.open_view_time) {
                    if (TimeUtil.getServerTime() - view.open_view_time < view.click_bg_can_close_time) {
                        return;
                    }
                }
                view.Close();
            }
        }
    };
    //防错保护逻辑
    protected ProtectedLogic = () => {
        if (this._background && this._background.visible) {
            let view: Laya.Sprite = this._background["curr_view"].display_obj;
            let hide_background = false;
            if (!view) {
                hide_background = true;
                GameError.GetInstance().SendErrorToPHP("界面背景遮罩没有隐藏 但是界面已经关闭 ", true);
            }
            else if (!view.visible) {
                hide_background = true;
                let view_name = window["GetQualifiedClassName"](view) || "未知";
                let viewList = ``;
                for (let key in this.has_backgroup_view_dic) {
                    if (this.has_backgroup_view_dic[key]) {
                        viewList += window["GetQualifiedClassName"](this.has_backgroup_view_dic[key]);
                    }
                    else {
                        viewList += `null`;
                    }
                }
                let ref_tar = this.GetMostFrontView();
                if (ref_tar) {
                    viewList += `MostFrontView:${window["GetQualifiedClassName"](ref_tar)}`;
                }
                viewList += `lastCloseView:${this.lastCloseView}`;
                GameError.GetInstance().SendErrorToPHP(view_name + "界面背景遮罩没有隐藏 界面visible为false 但是界面已经关闭 " + viewList, true);
            }
            else if (!view.parent) {
                hide_background = true;
                let view_name = window["GetQualifiedClassName"](view) || "未知";
                GameError.GetInstance().SendErrorToPHP(view_name + "界面背景遮罩没有隐藏 界面parent为null 但是界面已经关闭 ", true);
            }
            // if (hide_background) {
            //     if (this._protected_logic_timer_id) {
            //         egret.clearInterval(this._protected_logic_timer_id);
            //         this._protected_logic_timer_id = null;
            //     }
            //     this._background.visible = false;
            // }
        }
    };
    lastCloseView;
    public HideBackgroup = (ref_tar) => {
        if (this._background) {
            if (ref_tar) {
                this.lastCloseView = window["GetQualifiedClassName"](ref_tar);
            }
            if (this.has_backgroup_view_dic[ref_tar.hashCode]) {
                delete this.has_backgroup_view_dic[ref_tar.hashCode];
                ref_tar = this.GetMostFrontView();
                if (ref_tar) {
                    // ref_tar.alpha = this._max_alpha || 0
                    this.ShowBackGroup(ref_tar, false);
                }
                else {
                    if (this._protected_logic_timer_id) {
                        clearInterval(this._protected_logic_timer_id);
                        this._protected_logic_timer_id = null;
                    }
                    this._background.off(Laya.Event.CLICK, this, this.BackgroupClickEvent);
                    this._background["curr_view"] = null;
                    this._background.visible = false;
                    // this._background.includeInLayout = false;
                    if (this._background.parent) {
                        this._background.parent.removeChild(this._background);
                    }
                }
            }
        }
    };
    public NoBackGroupViewInShow = () => {
        return window["Util"].IsTableEmpty(this.has_backgroup_view_dic);
    };
    public CloseView = (ref_tar) => {
        if (ref_tar.append_to_ctl_queue && this.view_ctl_queue) {
            delete this.view_ctl_queue[ref_tar.hashCode];
            let max_index = 0, max_view, obj, index;
            for (let hashCode in this.view_ctl_queue) {
                obj = this.view_ctl_queue[hashCode];
                index = obj.index;
                if (index > max_index) {
                    max_index = index;
                    max_view = obj.view;
                }
            }
            if (max_view) {
                max_view.SetVisible(true);
            }
        }
        this.HideBackgroup(ref_tar);
        GlobalEventSystem.Fire(EventName.CLOSED_ONE_VIEW);
        if (local_Util.IsConch() && this.now_open_view_list[ref_tar.hashCode]) {
            delete this.now_open_view_list[ref_tar.hashCode];
        }
        ViewPopLevelModel.GetInstance().NextPop();
        ViewPopLevelModel.GetInstance().CloseOne(window["GetQualifiedClassName"](ref_tar))
    };
    //获取可以关闭的界面数量
    public GetCanCloseViewNum = () => {
        return window["Util"].TableSize(this.now_open_view_list);
    };
    //每次关闭一个界面
    public CloseOneViewOneTimes = () => {
        if (this.GetCanCloseViewNum() > 0) {
            let max_index = 0, max_view, obj, index;
            for (let hashCode in this.now_open_view_list) {
                obj = this.now_open_view_list[hashCode];
                index = obj.index;
                if (index > max_index) {
                    max_index = index;
                    max_view = obj.view;
                }
            }
            if (max_view) {
                if(max_view.BaseWindowCloseFunc)
                {
                    max_view.BaseWindowCloseFunc();
                }else
                {
                    max_view.Close();
                }
            }
        }
    };
    public GetBackGround = () => {
        return this._background;
    };
    CheckBackGroup = () => {
        for (let key in this.has_backgroup_view_dic) {
            if (!this.has_backgroup_view_dic[key].use_background) {
                delete this.has_backgroup_view_dic[key];
            }
        }
    };
}

window["ViewManager"] = ViewManager