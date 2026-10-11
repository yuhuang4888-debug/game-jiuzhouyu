
import { EventDispatcher } from "../util/EventDispatcher";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "./EventName";
import { Util } from "../util/Util";

export enum Enum_UILayer {
    Scene,
    Shadow,
    SceneObj,
    NameBoard,
    TalkBoard,
    DamageFont,
    UIRoot,
    Main,
    UI,
    Activity,
    Top,
    Message,
    FightingUp,
    ClickEffect
}
window["Enum_UILayer"] = Enum_UILayer;

let local_laya = Laya
let local_Enum_UILayer = Enum_UILayer
export class LayerManager extends EventDispatcher {
    private static Instance: LayerManager;
    public static GetInstance() {
        if (!LayerManager.Instance) {
            LayerManager.Instance = new LayerManager();
        }
        return LayerManager.Instance;
    }

    private _stage: Laya.Stage;
    private _scene3d: Laya.Scene3D
    private _uiscene3d: Laya.Scene3D
    private _stageWidth: number = 0
    private _stageHeight: number = 0

    public gpu_size_label
   
    srcStageWidth: number = 1; //最开始的舞台宽度
    srcStageHeight: number = 1; //最开始的舞台高度
    camera_base_size: number = 12.8;
    ui_layer_list: Array<Laya.Box> = []
    full_screen_img: Laya.Image
    layer_visible_type_dic
    /**判断隐藏的优先级，值越大先判断 */
    layer_visible_type_level = {
        "BanquetAniManager":10,
        "LoginController":999
    }
    scene_3d_visible_type_dic
    /**判断隐藏的优先级，值越大先判断 */
    scene_3d_visible_type_level = {
        "BanquetAniManager":10
    }

    /**
     * 每层对应的名字 用来调试的时候看的更清晰
     */
    layer_name = [
        "Scene",
        "Shadow",
        "SceneObj",
        "NameBoard",
        "TalkBoard",
        "DamageFont",
        "UIRoot",
        "Main",
        "UI",
        "Activity",
        "Top",
        "Message",
        "FightUp",
        "ClickEffect"
    ]

    public constructor() {
        super();
    }

    public set stage(value: Laya.Stage) {
        this._stage = value;
    }
    public get stage() {
        return this._stage;
    }

    public set stageWidth(value: number) {
        this._stageWidth = value;
    }

    public get stageWidth() {
        return this._stageWidth;
    }

    public set stageHeight(value: number) {
        this._stageHeight = value;
    }

    public get stageHeight() {
        return this._stageHeight;
    }

    public set Scene3D(value: Laya.Scene3D) {
        this._scene3d = value
    }

    public get Scene3D() {
        return this._scene3d
    }

    public set UIScene3D(value: Laya.Scene3D) {
        this._uiscene3d = value
    }

    public get UIScene3D() {
        return this._uiscene3d
    }

    public GetTimeFromFrameStart(): number {
        return this._stage.getTimeFromFrameStart();
    }

    public CheckFrameTimeValid() {
        if (this.GetTimeFromFrameStart() > 33) {
            return false
        } else {
            return true
        }
    }

    CreateUIScene3D() {
        let uiscene = window["GetScene3DFromPool"]()
        uiscene.name = "UIScene3D"
        LayerManager.GetInstance().GetUILayer(Enum_UILayer.SceneObj).addChild(uiscene);
        uiscene.enableFog = false
        uiscene.enableLight = false
        return uiscene
    }

    InitUILayer() {
        if (!Laya.Browser.onMobile) {
            if (!this.full_screen_img) {
                this.full_screen_img = new Laya.Image()
                this.full_screen_img.alpha = 0
                window['ResManager'].GetInstance().SetOutsideImageSprite(this, this.full_screen_img, "resource/game/login/other/full_screen_bg1.jpg?v=3", null, () => {
                    this.full_screen_img.alpha = 1
                    Laya.stage.bgColor = "black"
                })
                Laya.stage.addChild(this.full_screen_img)
                this.UpdateFullScreenBg()
            }
        }


        let layer: Laya.Box;
        let ui_root;
        for (let i = 0; i < this.layer_name.length; i++) {
            layer = new Laya.Box();
            if (i <= local_Enum_UILayer.DamageFont) {
                layer.width = 100;
                layer.height = 100;
                if (i == local_Enum_UILayer.Scene) {
                    this._stage.addChild(layer);
                }
                else {
                    this.ui_layer_list[local_Enum_UILayer.Scene].addChild(layer);
                }
                if (i == local_Enum_UILayer.NameBoard || i == local_Enum_UILayer.TalkBoard || i == local_Enum_UILayer.DamageFont) {
                    layer.drawCallOptimize = true
                }
            }
            else {
                layer.width = this._stage.width;
                layer.height = this._stage.height;
                if (i == local_Enum_UILayer.UIRoot) {
                    this._stage.addChild(layer);
                    ui_root = layer;
                }
                else {
                    ui_root.addChild(layer);
                }
            }
            if (i == local_Enum_UILayer.UIRoot) {
                layer.mouseEnabled = true;
            }
            else {
                if (layer) {
                    layer.mouseThrough = true;
                }
                layer.mouseEnabled = true;
            }
            layer.name = this.layer_name[i];
            this.ui_layer_list[i] = layer;
        }
        let onClickHandler = () => {
            GlobalEventSystem.Fire(EventName.STAGE_CLICK_EVENT);
        };
        this._stage.on(local_laya.Event.CLICK, this, onClickHandler);
    };

    GetUILayer(layer_value: number) {
        let layer = this.ui_layer_list[layer_value];
        if (layer) {
            return layer;
        }
        else {
            console.error("can not get uilayer name is = ", layer_value);
        }
    }

    UpdateUILayer(need_refresh_screen: boolean = false) {
        for (let layer_value in this.ui_layer_list) {
            if (Number(layer_value) > local_Enum_UILayer.DamageFont) {
                let layer = this.ui_layer_list[layer_value];
                if (layer) {
                    layer.width = this._stage.width;
                    layer.height = this._stage.height;
                }
            }
        }
        if (this.full_screen_img) {
            this.UpdateFullScreenBg()
        }
    };

    SetLayerVisible(layer_value: number, visible_type, visible, need_refresh = true){
        if(this.layer_visible_type_dic == null){
            this.layer_visible_type_dic = {}
        }

        let level = this.layer_visible_type_level[visible_type] || 0
        if(this.layer_visible_type_dic[level] == null){
            this.layer_visible_type_dic[level] = {}
        }

        if(this.layer_visible_type_dic[level][layer_value] == null){
            this.layer_visible_type_dic[level][layer_value] = {}
        }
        if(visible == null){
            delete this.layer_visible_type_dic[level][layer_value][visible_type]
        }
        else{
            this.layer_visible_type_dic[level][layer_value][visible_type] = visible
        }

        if(need_refresh){
            this.UpdateLayerVisible(layer_value)
        }
    }

    UpdateLayerVisible(layer_value){
        let max_level = 0, visible_type_dic
        if(this.layer_visible_type_dic){
            for(let level in this.layer_visible_type_dic){
                var dic = this.layer_visible_type_dic[level]
                if(dic && !Util.IsTableEmpty(dic[layer_value]) && Number(level) > max_level){
                    max_level = Number(level)
                }   
            }
            if(max_level!=null){
                visible_type_dic = this.layer_visible_type_dic[max_level][layer_value]
            }
        }

        let ui_layer = this.GetUILayer(layer_value)
        if(visible_type_dic){
            let bool = true
            for(let visible_type in visible_type_dic){
                if(!visible_type_dic[visible_type]){
                    bool = false
                }
            }
            ui_layer.visible = bool
        }
        else{
            ui_layer.visible = true
        }
    }

    GetLayerVisible(layer_value: number, level?){
        if(!this.layer_visible_type_dic){
            return true
        }
        level = level != null ? level : 0
        if(!this.layer_visible_type_dic[level]){
            return true
        }

        if(!this.layer_visible_type_dic[level][layer_value]){
            return true
        }

        let bool = true
        let dic = this.layer_visible_type_dic[level][layer_value]
        for(let visible_type in dic){
            if(!dic[visible_type]){
                bool = false
            }
        }

        return bool
    }

    SetScene3DVisible(visible_type, visible, need_refresh = true){
        if(this.scene_3d_visible_type_dic == null){
            this.scene_3d_visible_type_dic = {}
        }
        let level = this.scene_3d_visible_type_level[visible_type] || 0
        if(this.scene_3d_visible_type_dic[level] == null){
            this.scene_3d_visible_type_dic[level] = {}
        }

        if(visible == null){
            delete this.scene_3d_visible_type_dic[level][visible_type]
        }
        else{
            this.scene_3d_visible_type_dic[level][visible_type] = visible
        }

        if(need_refresh){
            this.UpdateScene3DVisible()
        }
    }

    UpdateScene3DVisible(){
        let max_level = 0, visible_type_dic
        if(this.scene_3d_visible_type_dic){
            for(let level in this.scene_3d_visible_type_dic){
                if(!Util.IsTableEmpty(this.scene_3d_visible_type_dic[level]) && Number(level) > max_level){
                    max_level = Number(level)
                }   
            }
            if(max_level!=null){
                visible_type_dic = this.scene_3d_visible_type_dic[max_level]
            }
        }

        if(visible_type_dic){
            let bool = true
            for(let visible_type in visible_type_dic){
                if(!visible_type_dic[visible_type]){
                    bool = false
                }
            }
            this.Scene3D.visible = bool
        }
        else{
            this.Scene3D.visible = false
        }
    }

    UpdateFullScreenBg() {
        var clientWidth = this._stage.width
        var clientHeight = this._stage.height
        var bg_scaleX = 1280 / clientWidth;
        var bg_scaleY = 720 / clientHeight;
        var bg_max_scale = Math.min(bg_scaleX, bg_scaleY)
        var bg_width = 1280 / bg_max_scale
        var bg_height = 720 / bg_max_scale
        this.full_screen_img.width = bg_width
        this.full_screen_img.height = bg_height
    }
}
window["LayerManager"] = LayerManager