import { EventName } from '../common/EventName';
import { ViewManager } from '../common/ViewManager';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EventDispatcher } from '../util/EventDispatcher';
import { TMap } from '../util/TMap';
import { Config } from "../common/Config"
import { LoginModel } from '../login/LoginModel';
import { SceneManager } from '../scene/SceneManager';
import { BanquetAniManager } from '../marriage2/BanquetAniManager';
import { Util } from '../util/Util';


export class ViewPopLevelModelEvent {
    static className: string = "ViewPopLevelEvent";

    static NEXT_OPEN_VIEW: string = ViewPopLevelModelEvent.className + '_NEXT_OPEN_VIEW'
    static POP_OVER: string = ViewPopLevelModelEvent.className + '_POP_OVER'  //所有界面弹出完毕
}

/**
 * 处理需要特殊处理的弹窗
 */
export class ViewPopLevelModel extends EventDispatcher {
    private static _instance: ViewPopLevelModel;
    public static IGNORE_BASEWINDOW_OPEN_STATE = false
    public static GetInstance() {
        if (!ViewPopLevelModel._instance) {
            ViewPopLevelModel._instance = new ViewPopLevelModel();
        }
        return ViewPopLevelModel._instance;
    }

    private _viewList: TMap<string, any>;
    // 弹窗中（弹出窗口动画的一个过程 窗口弹出完毕设置为false）
    private _isPopIng: boolean = false;
    //当前弹出的窗口名称
    private _cur_win_name: string = ""

    //游戏开始后 需要收集起来统一排序的界面
    com_sort_view = {}
    _com_sort_list = {}
    _is_game_start = false
    _com_wait_time 
    _look_view = null //等待这个界面弹出后再进行剩余的nextPop
    _look_wait_time=null

    public static VIEW_WAIT_TIME_1 = 4000
    public static VIEW_WAIT_TIME_2 = 8000

    public constructor() {
        super();
        this._viewList = new TMap<string, any>();
    }

    public get isPopIng(): boolean {
        return this._isPopIng;
    }

    public set isPopIng(bool: boolean) {
        this._isPopIng = bool;
    }

    public ClearView() {
        this._cur_win_name = ""
        this._viewList.clear();
        this._look_view=""
        if(this._look_wait_time){
            clearTimeout(this._look_wait_time)
            this._look_wait_time = null
        }
    }


    public GetView(name: string) {
        return this._viewList.get(name);
    }

    public SetView(name: string, ...param: any) {
        this._viewList.set(name, param);
        this.SortList()
        this.NextPop();
    }


    /**
     * 立马需要弹出的页面
     */
    public SetViewPop(name: string, ...param: any) {
        this._viewList.set(name, param);
        // 把指定的弹出
        let last = this._viewList.keys.pop();
        this._viewList.keys.unshift(last);

        if (SceneManager.GetInstance().IsWeddingScene() && BanquetAniManager.GetInstance().bool_playing) {
            // 婚宴婚礼动画暂时不弹出  婚礼动画结束或者退出婚宴场景，继续弹出
            return
        }

        this.NextPop();
    }

    /**删除队列中某个界面 */
    public RemoveOneView(win_name) {
        let boo = this._viewList.remove(win_name, true);
        return boo
    }


    /**检查某个页面是否正在弹出 */
    public CheckViewIsPoping(win_name?) {
        if (!win_name) {
            return this._cur_win_name && this._cur_win_name != ""
        }
        return this._cur_win_name == win_name
    }

    /**检查是否是关闭了最后一个弹窗 */
    public CloseOne(win_name) {
        let isLen: number = this._viewList.keys.length; // 是否为空
        if (isLen > 0) return

        if (this._cur_win_name == win_name) {
            this._cur_win_name = null
            this.Fire(ViewPopLevelModelEvent.POP_OVER)
        }
    }

    /**
     * 
     * @param name 设置锁定的界面 （锁定四秒钟）
     */
    public SetLockView(name){

        if(this._look_wait_time){
            clearTimeout(this._look_wait_time)
            this._look_wait_time = null
        }


        if(name){
            //防止协议没在时间内返回，卡死
            this._look_wait_time =setTimeout(() => {
                this._look_view = null
                this.NextPop()
            }, ViewPopLevelModel.VIEW_WAIT_TIME_1);
        }
        this._look_view = name
    }


    public IsLockView(name){
        return this._look_view==name
    }

    public NextPop() {
        let isLen: number = this._viewList.keys.length; // 是否为空
        let isLoad: boolean = LoginModel.GetInstance().is_show_loading_view; // 是否还在lod界面
        let isFrontView: any = ViewManager.GetInstance().GetMostFrontView(); // 最高层是否有ui
        let isBaseWindow: boolean = ViewPopLevelModel.IGNORE_BASEWINDOW_OPEN_STATE || window["Util"].IsTableEmpty(window["BaseWindowComponent"].CURR_OPEN_VIEW); // 是否打开继承BaseWindowComponent的界面
        if (isLen <= 0 || isLoad || isFrontView || !isBaseWindow) {
            return;
        }

        this.SortList()

        if (!this._isPopIng) {
        
            let viewName: string = this._viewList.keys[0];

            //是否锁定了队列
            if(this._look_view&&this._look_view!=viewName){
                return
            }
            if(this._look_view&&this._look_view==viewName){
                if(this._look_wait_time){
                    clearTimeout(this._look_wait_time)
                    this._look_wait_time = null
                }
                this._look_view = null
            }

            this.isPopIng = true;
            let param: any = this.GetView(viewName);
            this._cur_win_name = viewName //记录当前弹出的窗口名字

            //分为普通弹窗和活动类弹窗
            let conf = Config.PRELOAD_CLIENT_CONFIG.ClientConfigPopupLevel;
            if (conf && conf[viewName] && conf[viewName]["is_activity"]) {
                GlobalEventSystem.Fire(EventName.OPEN_ACT_VIEW, ...param);
            } else {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, viewName, ...param);
            }
            this._viewList.remove(viewName, true);
        }
    }

    private SortList() {
        let conf = Config.PRELOAD_CLIENT_CONFIG.ClientConfigPopupLevel;

        // 排序
        let list_temp=this._viewList.keys.sort((a: string, b: string) => {
            if (!(conf[a] && conf[b])) {
                return 0;
            }
            return conf[b].sort - conf[a].sort;
        });

        //重新排列
        let viewList_temp = new TMap<string, any>();
        for(let i=0;i<list_temp.length;i++){
            viewList_temp.set(list_temp[i],this._viewList.get(list_temp[i]))
        }
        this._viewList.clear()
        this._viewList=viewList_temp
        // console.warn("测试@this._viewList.keys",  this._viewList.keys)
    }

    /**
     * 特殊处理
     * 显示顺序: 挂机收益->挂机收益的恭喜获得界面->超值礼包->玩法预告->道具使用推送
     * @param is_pop 收到信息和弹出窗口是两回是，有时候收到协议但是不一定弹出窗口
     */
    public SetSpacialView(name: string, is_pop?, ...param: any) {

        if(!this._is_game_start){
            if(is_pop){
                this.SetView(name,param)
            }
            return
        }

        this.com_sort_view[name] = 1
        if (is_pop) {
            this._com_sort_list[name] = param
        }
        for (let key in this.com_sort_view) {
            if (this.com_sort_view[key] == 0) {
                return
            }
        }

        for (let key in this.com_sort_view) {
            if (this._com_sort_list[key]) {
                this._viewList.set(key, this._com_sort_list[key]);
            }
        }    
        this.SortList()
        this.NextPop();


        //使命完成 清空
        this.ClearSpacialData()
    }

    public ClearSpacialData(is_game_start?) {
        this._com_sort_list = {}

        //特殊处理的界面
        this.com_sort_view = {
            "OnHookMainView": 0,
            "SuperGiftView": 0,
            "DailyActTipView": 0
        }
        this._is_game_start = is_game_start

        if(this._is_game_start){
            //有些活动是走活动协议比如SuperGiftView，如果这个活动不开，那么久卡死了
            //现在做个定时器  定时等待4秒钟,如果在没有数据过来就强行设置

            if(this._com_wait_time){
                clearTimeout(this._com_wait_time)
                this._com_wait_time = null
            }
            this._com_wait_time =setTimeout(() => {
                for (let key in this.com_sort_view) {
                   this.SetSpacialView(key,false)
                }
            }, ViewPopLevelModel.VIEW_WAIT_TIME_1);
        }
    }

}

window['ViewPopLevel'] = ViewPopLevelModel;
