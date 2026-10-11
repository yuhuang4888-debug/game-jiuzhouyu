import { TranslationManager } from "../commonController/TranslationManager";
import { Demon } from "../scene/sceneobj/Demon";
import { EventDispatcher } from "../util/EventDispatcher";
import { GetQualifiedClassName, GetTargetHashcode, Util } from "../util/Util";
import { HashObject, IBaseClass } from "./BaseClass";
import { BaseItem1 } from "./BaseItem1";
import { ResManager } from "./ResManager";

export class BaseItemRenderer extends Laya.Box implements IBaseClass {

    WIDTH = 100
    HEIGT = 100

    protected data//数据
    protected index//序号
    protected refresh_data = false
    public selected = false//当前cell是否被选择
    // public selectBox: Laya.Box//当前cell选择状态组件

    private _use_delete_method = false

    public base_file: string = "";
    public layout_file: string = "";
    public is_loaded: Boolean = false;
    public is_loading: Boolean = false;
    /**
     * 显示对象
     */
    protected display_obj: Laya.View

    protected base_item: BaseItem1

    set dataSource(value: any) {
        this._dataSource = value;
    }

    get dataSource() {
        return this._dataSource;
    }

    $hashCode: number;

    public get hashCode(): number {
        return this.$hashCode;
    }

    constructor() {
        super()
        this.$hashCode = new HashObject().hashCode;
        // this.autoSize = true

        // this.selectBox = new Laya.Box()
        // this.selectBox.name = "selectBox"
        // this.addChild(this.selectBox)


        this.once(Laya.Event.ADDED,this,this.AddStageCall);
        // this.on(Laya.Event.REMOVED, this, this.DeleteMe )
    }

    public AddStageCall(){
        if(this.parent && this.parent.parent){
            let data = BaseItemRenderer.list_to_size_dic[GetTargetHashcode(this.parent.parent)] 
            if(data){
                this.size(data.width, data.height)
                this.parent.parent["_setCellChanged"]()
            }
        }
        
    }

    public createChildren(): void {
        super.createChildren()
        // if (this.base_item) {
            //     this.base_item.createChildren()
        // }
    }


    public Load() {
        this.size(this.WIDTH, this.HEIGT)
        if (!this.is_loading) {
            this.is_loading = true
            this.base_item = new BaseItem1(this)
            this.base_item.base_file = this.base_file
            this.base_item.layout_file = this.layout_file
            this.base_item.load_callback = () => {
                this.is_loading = false
                this.is_loaded = true
                this.display_obj = this.base_item.display_obj

                if (this.GetComponents) {
                    this.GetComponents()
                }
                if (this.load_callback) {
                    this.load_callback()
                    TranslationManager.GetInstance().UpdateViewComponent(this)
                }
                if (this.refresh_data) {
                    this.dataChanged()
                    this.refresh_data = false
                }
            }

            this.base_item.Load()

            // this.on(Laya.Event.REMOVED, this, this.DeleteMe)
        }

    }

    public updateItem(_data, _index): any {
        this.data = _data
        this.index = _index
        this.dataChanged()
    }

    protected dataChanged(): any {
        if (this.is_loaded && this.display_obj && this.data) {
            // this.selected = this.index == this.parent.parent["selectedIndex"]
            return true
        } else {
            this.refresh_data = true
            return false
        }

    }

    public BindEvent = (eventDispatcher: EventDispatcher, key: string, func: Function, execute_func_imm: boolean = false) => {
        if (this.base_item) {
            this.base_item.BindEvent(eventDispatcher, key, func, execute_func_imm)
        }

    };

    public BindVar = (eventDispatcher: EventDispatcher, key: string, func: Function, execute_func_imm: boolean = false) => {
        if (this.base_item) {
            this.base_item.BindVar(eventDispatcher, key, func, execute_func_imm)
        }

    };

    public UnBindEvents = () => {
        if (this.base_item) {
            this.base_item.UnBindEvents()
        }

    };

    /**
     * 通过控件名字获取控件对象(调用次数少于3，否则尽量用GetChildrenByNames来批量获取）
     * @param name  控件名字
     * @returns 
     */
    public GetChildByName(name: string): any {
        if (this.base_item) {
            return this.base_item.GetChildByName(name)
        }
    }
    /**
     * 批量(3个以上)获取控件，减少频繁调用递归遍历 优化性能
     * @param names  控件名字数组
     * @returns 
     */
    public GetChildrenByNames(names: Array<string>): any {
        if (this.base_item) {
            return this.base_item.GetChildrenByNames(names)
        }

    }

    public load_callback() {

    }

    public GetComponents() {

    }

    onDestroy(){
        this.DeleteMe()
    }

    public destroyChildren(): void {
        //销毁子节点
        let _children = this["_children"]
        if (_children) {
            //为了保持销毁顺序，所以需要正序销毁
            for (var i: number = 0, n: number = _children.length; i < n; i++) {
                if(this.display_obj != _children[0])//为了不销毁item
                    _children[0].destroy(true);
            }
        }
    }

    public CallLater(call_back, args?){
        if(this.base_item){
            this.base_item.CallLater(call_back, args)
        }
    }
    

    public DeleteMe() {
        this.is_loaded = false;
        this.is_loading = false;
        this.refresh_data = null
        this.display_obj = null
        if (this.base_item) {
            this.base_item.DeleteMe()
            this.base_item = null
        }
        this._use_delete_method = true
        ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode)
        // this.off(Laya.Event.REMOVED, this, this.DeleteMe)
    }

    get use_delete_method() {
        if (this.base_item) {
            return this.base_item.use_delete_method
        } else {
            return this._use_delete_method
        }
    }

    static list_to_size_dic = {}
    static SetItemSize(list:Laya.List, width, height?){
        if(Util.IsNull(list)) return
        if(!width) return
        if(height == undefined) height = width
        BaseItemRenderer.list_to_size_dic[GetTargetHashcode(list)] = {width:width,height:height}
    }

    static ClearList(list){
        delete BaseItemRenderer.list_to_size_dic[GetTargetHashcode(list)]
    }
}


window["BaseItemRenderer"] = BaseItemRenderer