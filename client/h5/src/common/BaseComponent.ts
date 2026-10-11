// console.warn("BaseComponent@BaseClass")
import { BaseClass } from "./BaseClass";
import { EventDispatcher } from "../util/EventDispatcher";
import { ClientConfig, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "./EventName";
import { GetQualifiedClassName } from "../util/Util";
import { Alert } from "../alert/Alert";
import { GameError } from "../util/GameError";
let local_EventName = EventName
let local_GlobalEventSystem = GlobalEventSystem
let local_Laya = Laya
export class BaseComponent extends BaseClass {
    story_target_name_dic; //剧情引导的目标名字字典
    select_story_target_id; //监听剧情引导选择目标的事件id
    story_obj_list; //剧情引导对象列表  每一个对象表示一步  
    main_task_change_id; //主线改变事件id
    curr_view_story_step;//当前界面引导的第几步
    story_model
    task_model
    is_get = false
    protected event_dic: {
        [id: number]: EventDispatcher;
    };
    public not_cache_display_obj = false; //是否不复用view对象
    force_bind_event = false;
    /**eventDispatcher: EventDispatcher, key: string, func: Function, execute_func_imm: boolean = false */
    /**
     * 显示对象
     */
    public display_obj: Laya.View

    //返回批量获取空间的对象
    private static _GET_COMPONENTS_OBJ = { results : [], has_get_count : 0}
    public constructor() {
        super();
        this.story_model = window["StoryModel"].GetInstance()
        this.task_model = window["TaskModel"].GetInstance()

    }
    public BindEvent = (eventDispatcher: EventDispatcher, key: string, func: Function, execute_func_imm: boolean = false) => {
        if (execute_func_imm) {
            if (func) {
                func();
            }
        }
        let id = eventDispatcher.Bind(key, func);
        this.event_dic = this.event_dic || {};
        this.event_dic[id] = eventDispatcher;
    };

    public BindVar = (eventDispatcher: EventDispatcher, key: string, func: Function, execute_func_imm: boolean = false) => {
        if (execute_func_imm) {
            if (func) {
                func();
            }
        }
        let id = eventDispatcher.BindOne(key, func);
        this.event_dic = this.event_dic || {};
        this.event_dic[id] = eventDispatcher;
    };

    public UnBindEvents = () => {
        if (this.event_dic) {
            for (let id in this.event_dic) {
                let eventDispatcher = this.event_dic[id];
                eventDispatcher.UnBind(id);
            }
            this.event_dic = null;
        }
    };
    /**
     * 获取指定父控件下对应名字的子控件 不对外调用
     * @param node 
     * @param name 
     * @returns 
     */
    private static _GetChild(node: Laya.Node, name: string) {
        let child: Laya.Node
        for (var i = 0; i < node.numChildren; i++) {
            child = node.getChildAt(i)
            if (child.name == name) {
                return child
            } else if (child.numChildren > 0) {
                child = local_BaseComponent._GetChild(child, name)
                if (child) {
                    return child
                }
            }
        }
        return null
    }
    /**
    * 获取指定父控件下对应名字的子控件 不对外调用
    * @param node 
    * @param name 
    * @param results 
    * @returns 
    */
    private static _GetChilds(node: Laya.Node, names: Array<string>, out_results) {
        let child: Laya.Node
        let name_index = -1
        for (var i = 0; i < node.numChildren; i++) {
            child = node.getChildAt(i)
            name_index = names.indexOf(child.name)
            if (name_index >= 0) {
                out_results.results[name_index] = child
                out_results.has_get_count++
            }
            if (out_results.has_get_count >= names.length) {
                return out_results.results
            }
            // out_results.results[name_index] = child
            if (child.numChildren > 0) {
                local_BaseComponent._GetChilds(child, names, out_results)
            }
        }
        return out_results.results
    }
    /**
     * 通过控件名字获取控件对象(调用次数少于3，否则尽量用GetChildrenByNames来批量获取）
     * @param name  控件名字
     * @returns 
     */
    public GetChildByName(name: string): any {
        return local_BaseComponent._GetChild(this.display_obj, name)
        // return this.display_obj.getChildByName(name)
    }
    /**
     * 批量(3个以上)获取控件，减少频繁调用递归遍历 优化性能
     * @param names  控件名字数组
     * @returns 
     */
    public GetChildrenByNames(names: Array<string>): any {
        local_BaseComponent._GET_COMPONENTS_OBJ.results.length = names.length
        local_BaseComponent._GET_COMPONENTS_OBJ.has_get_count = 0
        return local_BaseComponent._GetChilds(this.display_obj, names, local_BaseComponent._GET_COMPONENTS_OBJ)
        // return this.display_obj.getChildByName(name)
    }
    //第一次添加到舞台的时候调用
    public createChildren() {
        if (this["GetComponents"] && !this.is_get) {
            this["GetComponents"]()
        }
        let skin_dependence_map = this.display_obj['skin_dependence_map']
        if(skin_dependence_map)
        {
            let res = window['ResManager'].GetInstance()
            for(let skin in skin_dependence_map)
            {
                skin = res.cdn_res_path + skin;
                res.AddReferenceCount(this.hashCode, skin)
                // console.warn("-----------------------skin_dependence_map--------------", skin)
            }
        }
        this.display_obj.on(local_Laya.Event.REMOVED, this, () =>
        {
            // local_Laya.timer.callLater(this, () =>
            // {
                if(!this.use_delete_method && this.display_obj.destroyed)
                {
                    // let msg = "销毁界面的时候有item没有调用DeleteMe。"+ GetQualifiedClassName(this)
                    // // Alert.Show(msg)
                    // console.warn(msg)
                    // if(ClientConfig && !ClientConfig.forbid_check_deleteme)
                    // {
                        this.DeleteMe()
                    // }else
                    // {
                    //     GameError.GetInstance().SendErrorToPHP(msg)
                    // }
                }
            // })
        })
        // super.createChildren();
        //有设置目标对象的时候 监听选择目标的事件 如果发现目标是自己 就添加手指
        let self = this;
        if (self.story_target_name_dic || this.force_bind_event) {
            if (!self.select_story_target_id) {
                let onStartCurrStory = (target_name: string, is_add, force_show_main_ui_icon) => { //force_show_main_ui_icon是否强制把主界面下方的功能图标显示出来
                    // if (Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)){
                    let info = self.story_target_name_dic[target_name];
                    if (info) {
                        let obj: Laya.Sprite, x_off, y_off;
                        if (info instanceof local_Laya.Sprite) {
                            obj = info;
                        }
                        else {
                            obj = info.obj;
                            x_off = info.x_off;
                            y_off = info.y_off;
                        }
                        if (obj) {
                            if (is_add) {
                                if (!self.story_model.GetFinger(obj)) {
                                    this.story_model.now_story_target_name = target_name;
                                    local_GlobalEventSystem.Fire(local_EventName.SHOW_FINGER, this, obj, undefined, x_off, y_off, true);
                                    let onTouchBtn = () => {
                                        /**通过点击主界面有引导的按钮进入公共界面
                                        公共界面先打开 然后再触发onTouchBtn
                                        如果界面设置了curr_view_story_step!=0
                                        触发onTouchBtn的时候会把curr_view_story_step重新设置为0  表现异常*/
                                        // self.story_model.curr_view_story_step = 0;
                                        local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER,obj);
                                        this.story_model.now_story_target_name = null;
                                    };
                                    obj.once(local_Laya.Event.CLICK, self, onTouchBtn);
                                }
                            }
                            else {
                                local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, obj);
                                // this.story_model.now_story_target_name = null
                            }
                        }
                    }
                    // }
                };
                self.select_story_target_id = local_GlobalEventSystem.Bind(local_EventName.SELECT_STORY_TARGET, onStartCurrStory);
            }
        }
        //如果有设置剧情对象列表 就监听主线变化事件 如果发现是自己这个剧情内容类型的任务  那就执行该引导
        if (self.story_obj_list) {
            if (self.use_delete_method) return;
            if (!self.main_task_change_id) {
                let onUpdateMainLineVo = () => {
                    if (self.use_delete_method) return
                    self.RegisterStoryInfo(false)
                }
                self.main_task_change_id = local_GlobalEventSystem.Bind(local_EventName.UPDATE_NEWEST_TASK_ID, onUpdateMainLineVo)


                this.BindEvent(GlobalEventSystem,local_EventName.UPDATE_VIEW_STORY_STEP, ()=>{
                    self.RegisterStoryInfo(false)
                })
            }
        }
        self.RegisterStoryInfo(true);
        self.ShowViewTween();
    }
    //注册当前主线剧情内容类型的剧情对象列表 
    //do_form_create 是否在对象创建的时候调用
    protected RegisterStoryInfo(do_form_create?) {
        let self = this
        if (self.story_obj_list && !self.task_model.IsCurrMainTaskHasFinish()) {
            let tt = window["TaskTipType"]
            let main_line_vo = this.task_model.GetMainLineTaskVo()
            let _task_tip_type
            for (let task_tip_type in this.story_obj_list) {
                _task_tip_type = +task_tip_type
                if (this.task_model.IsCurrMainLineTaskTipType(_task_tip_type)) {
                    let list = this.story_obj_list[task_tip_type]
                    switch(_task_tip_type)
                    {

                        case tt.FinDunType:
                        case tt.FinDungeon:
                        case tt.Kill:
                        case tt.KillBoss:
                        case tt.Kill_boss_id:
                        case tt.FinTask:
                        case tt.Award_lv_gift:
                        case tt.MountLevel:
                            if (main_line_vo && this.story_obj_list[task_tip_type] && this.story_obj_list[task_tip_type][main_line_vo.id]) {
                                list = this.story_obj_list[task_tip_type][main_line_vo.id]
                            }
                            break;
                        case tt.AddFriend:
                            let friend_model = window["FriendModel"]
                            if (friend_model.GetInstance().recommend_cache && friend_model.GetInstance().recommend_cache[0]) {
                                let role_id = friend_model.GetInstance().recommend_cache[0].role_id
                                list = this.story_obj_list[task_tip_type][role_id]
                            }
                            break;
                        case tt.RuneNum:
                            let rune_model = window["RuneModel"]
                            if (rune_model.GetInstance().now_guide_goods_id) {
                                list = this.story_obj_list[task_tip_type][rune_model.GetInstance().now_guide_goods_id]
                            }
                            break;
                        case tt.JoinJcc:
                            let arena_model = window["ArenaModel"]
                            if (arena_model.GetInstance().guide_info) {
                                let rank = arena_model.GetInstance().guide_info.rank
                                list = this.story_obj_list[task_tip_type][rank]
                            }
                            break;
                        case tt.Fin_glad:
                            list = this.story_obj_list[task_tip_type][1]
                            break;
                        default:
                            break;
                    }
                    if (list) {
                        for (let i = 0; i < list.length; i++) {
                            if (i >= self.story_model.curr_view_story_step) {
                                let info = list[i],
                                    obj: Laya.Sprite
                                if (info) {
                                    if (info instanceof local_Laya.Sprite) {
                                        obj = info
                                    } else {
                                        obj = info.obj
                                    }
                                    //如果是打开公共大界面的时候 发现当前的引导是点击关闭按钮 那就不需要引导
                                    if (obj && (
                                            !window["BaseWindowComponent"].CURR_BASE_WINDOW_COMPONENT 
                                            || window["BaseWindowComponent"].CURR_BASE_WINDOW_COMPONENT._img_return != obj 
                                            || !do_form_create
                                            ||(do_form_create && self.story_model.curr_view_story_step != list.length - 1)
                                        )) {
                                        self.ShowCurrObjFinger(task_tip_type)
                                    }
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //显示当前步骤的手指
    private ShowCurrObjFinger(task_tip_type) {
        let list = this.story_obj_list[task_tip_type]
        let step_cfg = null
        let tt = window["TaskTipType"]
        let main_line_vo = this.task_model.GetMainLineTaskVo()
        let _task_tip_type = +task_tip_type
        switch(_task_tip_type)
        {

            case tt.FinDunType:
            case tt.FinDungeon:
            case tt.Kill:
            case tt.KillBoss:
            case tt.Kill_boss_id:
            case tt.FinTask:
            case tt.Award_lv_gift:
            case tt.MountLevel:
                if (main_line_vo && this.story_obj_list[task_tip_type] && this.story_obj_list[task_tip_type][main_line_vo.id]) {
                    list = this.story_obj_list[task_tip_type][main_line_vo.id]
                    step_cfg = this.task_model.GetNowGuideCfgByTaskTipsype(main_line_vo.task_tips_type)
                }
                break;
            case tt.AddFriend:
                let friend_model = window["FriendModel"]
                if (friend_model.GetInstance().recommend_cache && friend_model.GetInstance().recommend_cache[0]) {
                    let role_id = friend_model.GetInstance().recommend_cache[0].role_id
                    list = this.story_obj_list[task_tip_type][role_id]
                }
                break;
            case tt.RuneNum:
                let rune_model = window["RuneModel"]
                if (rune_model.GetInstance().now_guide_goods_id) {
                    list = this.story_obj_list[task_tip_type][rune_model.GetInstance().now_guide_goods_id]
                }
                break;
            case tt.JoinJcc:
                let arena_model = window["ArenaModel"]
                if (arena_model.GetInstance().guide_info) {
                    let rank = arena_model.GetInstance().guide_info.rank
                    list = this.story_obj_list[task_tip_type][rank]
                }
                break;
            case tt.Fin_glad:
                list = this.story_obj_list[task_tip_type][1]
                break;
            default:
                break;
        }
        if (list) {
            let info = list[this.story_model.curr_view_story_step]
            let obj: Laya.Sprite
            if (info) {
                // let x_off = null
                // let y_off = null
                if (info instanceof local_Laya.Sprite) {
                    obj = info
                } else {
                    obj = info.obj
                    // x_off = info.x_off
                    // y_off = info.y_off
                }
                let onTouchBtn = () => {
                    local_GlobalEventSystem.Fire(local_EventName.HIDE_FINGER, obj)
                    this.story_model.curr_view_story_step = this.story_model.curr_view_story_step + 1
                    local_GlobalEventSystem.Fire(local_EventName.UPDATE_VIEW_STORY_STEP)
                    // this.ShowCurrObjFinger(task_tip_type)
                    if (obj.name == "_story_bar2" && this.story_model.story_index != undefined && this.story_model.story_obj) {

                        this.story_model.story_obj.SetSelectIndex(this.story_model.story_index)
                        obj.mouseEnabled = false
                        obj.mouseThrough = true
                    }

                }
                obj.once(local_Laya.Event.CLICK, this, onTouchBtn)
                if (obj.name == "_story_bar2") {
                    obj.mouseEnabled = true
                    obj.mouseThrough = false
                }

                local_GlobalEventSystem.Fire(local_EventName.SHOW_FINGER, this, obj, undefined, info.x_off, info.y_off, undefined, undefined, step_cfg, true)
            }
        }
    }
    public DeleteMe() {
        let self = this;
        if (!self.use_delete_method) {
            self.use_delete_method = true;
            self.RemoveAllCallLayer()
            let display_obj:any = self.display_obj
            if (display_obj) {
                Laya.Tween.clearAll(display_obj)
                display_obj.destroy(true, self.not_cache_display_obj)
                self.display_obj = null
            }
            self.UnBindEvents();
            if (self.select_story_target_id) {
                local_GlobalEventSystem.UnBind(self.select_story_target_id);
                self.select_story_target_id = null;
            }
            self.RemoveViewTween();
            if (self.main_task_change_id) {
                self.task_model.UnBind(self.main_task_change_id)
                self.main_task_change_id = null
            }
            let ResManager = window["ResManager"]
            ResManager.GetInstance().DestroyAllReferenceRes(self.hashCode);
            // let Util = window["Util"]
        }
    }
    private ShowViewTween() {
        let self = this;
        let name = GetQualifiedClassName(self);
        let Config = window["Config"]
        let view_tween_list = Config.PRELOAD_CLIENT_CONFIG.ConfigViewTween && Config.PRELOAD_CLIENT_CONFIG.ConfigViewTween[name];
        if (view_tween_list && self.display_obj) {
            for (let tweens of view_tween_list) {
                let component = tweens.component;
                for (let tween_info of tweens.tween_list) {
                    self[component][tween_info.attr] = tween_info.start;
                    let attr = {};
                    attr[tween_info.attr] = tween_info.end;
                    local_Laya.Tween.to(self[component], attr, tween_info.time, null, local_Laya.Handler.create(this, () => {
                        if (self[component])
                            self[component][tween_info.attr] = tween_info.end;
                        // egret.Tween.removeTweens(self.display_obj[component])
                    }));
                }
            }
        }
    }
    private RemoveViewTween() {
        let self = this;
        let name = GetQualifiedClassName(self);
        let Config = window["Config"]
        let view_tween_list = Config.PRELOAD_CLIENT_CONFIG.ConfigViewTween && Config.PRELOAD_CLIENT_CONFIG.ConfigViewTween[name];
        if (view_tween_list && self.display_obj) {
            // egret.Tween.removeTweens(self)
            let component;
            for (let tweens of view_tween_list) {
                component = tweens.component;
                if (self.display_obj[component]) {
                    local_Laya.Tween.clearAll(self.display_obj[component]);
                }
                //     for(let tween_info of tweens.tween_list)
                //     {
                //         self.display_obj[component][tween_info.attr] = tween_info.end
                // }
            }
        }
    }

    // later_hander_dic = {}
    // later_hander_index = 0
    // public CallLater(call_back, args){
    //     if(this.display_obj){
    //         let local_index
    //         let local_call_back = () =>{
    //             delete this.later_hander_dic[local_index]
    //             call_back(args)
    //         }
    //         local_index = this.later_hander_index
    //         this.later_hander_dic[local_index] = this.display_obj.callLater(local_call_back, args)
    //         this.later_hander_index++
    //     }
    // }

    later_hander_dic
    later_hander_call
    public CallLater(call_back:Function, args?){
        if(!this.later_hander_dic){
            this.later_hander_dic = {}
        }
        if(!this.later_hander_call){
            this.later_hander_call = {}
        }
        local_Laya.CallLater.I.callLater(this, call_back, args)
        let later_handler = local_Laya.CallLater.I["_getHandler"](this, call_back)
        this.later_hander_dic[later_handler.key] = later_handler
    }


    public RemoveAllCallLayer(){
        if(this.later_hander_dic){
            for(let key in this.later_hander_dic){
                var later_hander = this.later_hander_dic[key]
                if(key === later_hander.key){
                    later_hander.clear()
                }
            }
            this.later_hander_dic = undefined
        }
    }

}
let local_BaseComponent = BaseComponent
window["BaseComponent"] = BaseComponent