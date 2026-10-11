import { BaseComponent } from "./BaseComponent";
import { BaseClass } from "./BaseClass";
import { LOAD_QUEUE } from "../util/DeclareGlobalVar";
import { ResManager } from "./ResManager";
import { GameResPath } from "../util/GameResPath";
import { GetTargetHashcode, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale, Util } from "../util/Util";
import { LayerManager } from "./LayerManager";
import { EffectResType } from "../scene/SceneConfig";

let local_Laya = Laya
class UIEffectInfo extends Laya.EventDispatcher {
    public static LOAD_COMPLETED = "LOAD_UIEFFECT_COMPLETED"
    public static MANUL_REMOVED = "MANUL_REMOVED" //手动发送的移除舞台时间，免得用Event.REMOVED 对其他地方的监听造成影响

    public key: number = 0
    public loaded: boolean = false
    public destroyed: boolean = false
    private parent_list: Array<Laya.Node> = []
    public render_texture: Laya.RenderTexture
    public scene: Laya.Scene3D
    public camera: Laya.Camera
    public gameObject: Laya.Sprite3D

    public constructor(key) {
        super()
        this.key = key
    }

    public AddParent(parent: Laya.Node) {
        let index = this.parent_list.indexOf(parent)
        if (index < 0) {
            let onRemove = () => {
                let index = this.parent_list.indexOf(parent)
                if (index >= 0) {
                    this.parent_list.splice(index, 1)
                }
                if (this.parent_list.length <= 0) {
                    this.DeleteMe()
                }
            }
            parent.once(local_Laya.Event.REMOVED, this, () => {
                onRemove()
                parent.offAll()
                parent["__effect_res_name"] = null
                parent["__effect_img"] = null
            })

            parent.once(local_UIEffectInfo.MANUL_REMOVED, this, () => {
                onRemove()
                parent.offAll()
                parent["__effect_res_name"] = null
                parent["__effect_img"] = null
            })
            this.parent_list.push(parent)
        }
    }

    public DeleteMe() {
        if (this.destroyed) return
        if (this.render_texture) {
            this.render_texture.destroy()
            this.render_texture = null
        }

        if (this.scene) {
            this.scene.destroy()
            this.scene = null
        }

        this.camera = null//跟随scene一块销毁了
        this.gameObject = null//跟随scene一块销毁了
        this.loaded = false
        this.destroyed = true
        delete local_UIEffect.ALL_UIEFFECT_DIC[this.key]
    }
}
var local_UIEffectInfo = UIEffectInfo
export class UIEffect extends BaseComponent {
    static ALL_UIEFFECT_DIC: { [key: string]: UIEffectInfo; } = {}
    curr_effect_parent_dic = {}
    public constructor() {
        super();
    }

    public ClearUIEffect = (parent_con: Laya.Sprite) => {
        if (parent_con) {
            let p_hashcode = GetTargetHashcode(parent_con)
            delete this.curr_effect_parent_dic[p_hashcode]
            parent_con.removeChildren();
            parent_con.event(local_UIEffectInfo.MANUL_REMOVED)
        }
    };

    public ResetUIEffect() {
        let parent
        for (let hash_code in this.curr_effect_parent_dic) {
            parent = this.curr_effect_parent_dic[hash_code]
            this.ClearUIEffect(parent)
        }
    }

    public DeleteMe() {
        this.ResetUIEffect()
        return super.DeleteMe()
    }
    /**
  * 添加ui粒子特效
  * @param res_name 特效名字
  * @param parent 父容器 注意设置好位置和大小
  * @param position 位置，修改的是粒子特效的位置而不是父容器的位置
  * @param scale 粒子特效的缩放大小 新增缩放XY，如果XYZ缩放一致还是传一个数字，如果XYZ缩放比例不一致则传{x:num,y:num,z:num}
  * @param is_loop 是否循环
  * @param last_time 持续时间，播放多久时间后销毁掉 单位秒
  * @param playend_call_back_func 播放last_time的时间后回调
  * @param load_finish_func 加载完粒子特效回调
  * @param hash_target 资源持有对象，一般在不销毁的类中播放特效时，手动创建一个BaseClass对象传进来，然后自己控制销毁
  * @param multi_children 是否支持同时显示多个子特效 默认一个父容器同时只能播放一个粒子特效 暂时不支持多个
  * @param rotation 粒子特效旋转值
  * @param load_queue 加载队列，一般无视
  * @param use_cache 使用缓存render_texture
  * @param effect_res_type 资源类型 默认UI
  * @param scene 指定哪个uiscene3d
  * @language zh_CN
  */
    public AddUIEffect = (res_name, parent: Laya.Sprite, position?, scale?, is_loop?, last_time?, playend_call_back_func?, load_finish_func?, hash_target?: BaseClass, multi_children?, rotation?, load_queue: LOAD_QUEUE = LOAD_QUEUE.LOW, use_cache = true, effect_res_type?, scene?) => {
        if (res_name && parent && parent instanceof local_Laya.Sprite) {
            let p_hashcode = GetTargetHashcode(parent)
            let old_parent: Laya.Node = this.curr_effect_parent_dic[p_hashcode]
            if (old_parent) {
                let old_res_name = old_parent["__effect_res_name"]
                if (old_res_name == res_name)//相同父容器且相同特效的请求直接return
                {
                    return old_parent["__effect_img"]
                } else {
                    old_parent.event(local_UIEffectInfo.MANUL_REMOVED) //删除相同容器旧的不一样的特效
                }
            }
            parent["__effect_res_name"] = res_name
            this.curr_effect_parent_dic[p_hashcode] = parent

            if (!position) {
                position = { x: 0, y: 0 }
            }
            if (!scale) {
                scale = { x: 1, y: 1, z: 1 }
            }
            else if (typeof (scale) == "number") {
                scale = { x: scale, y: scale, z: scale }
            }
            let key
            let effect_info: UIEffectInfo
            if (use_cache) {
                key = `${res_name}@${position.x}@${position.y}@${scale.x}@${scale.y}@${scale.z}@${parent.width}@${parent.height}`
                effect_info = local_UIEffect.ALL_UIEFFECT_DIC[key]
                if (effect_info) {
                    let CacheCallback = (_parent, img?) => {
                        img = img || window["GetImageFromPool"]() || new local_Laya.Image();
                        img.source = window["GetTextureFromPool"](effect_info.render_texture)
                        img.centerX = img.centerY = 0
                        _parent.addChild(img);
                        _parent["__effect_img"] = img
                        effect_info.AddParent(_parent)

                        if (load_finish_func) {
                            load_finish_func(effect_info.gameObject);
                        }
                        return img
                    }
                    if (effect_info.loaded) {
                        return CacheCallback(parent)
                    } else {
                        let img = window["GetImageFromPool"]() || new local_Laya.Image();
                        parent["__effect_img"] = img
                        effect_info.once(local_UIEffectInfo.LOAD_COMPLETED, this, () => {
                            CacheCallback(parent, img)
                        })
                        return img
                    }
                } else {
                    effect_info = new local_UIEffectInfo(key)
                    local_UIEffect.ALL_UIEFFECT_DIC[key] = effect_info
                }
            } else {
                key = p_hashcode
                effect_info = local_UIEffect.ALL_UIEFFECT_DIC[key]
                if (effect_info) {
                    return //理论上不可能进来
                } else {
                    effect_info = new local_UIEffectInfo(key)
                    local_UIEffect.ALL_UIEFFECT_DIC[key] = effect_info
                }
            }
            let UIModelClass3D = window["UIModelClass3D"]
            let curr_pos_index = UIModelClass3D.CURR_POS_INDEX;
            UIModelClass3D.CURR_POS_INDEX++;
            scene = scene || LayerManager.GetInstance().CreateUIScene3D()
            var load_call_back = (obj: Laya.Sprite3D) => {
                if (Util.IsNull(obj)) {
                    console.warn("!!!!!!!!!!!!!!!!!!!!ParticleEffect 找不到特效资源" + res_name)
                    return
                }
                if (this.use_delete_method || effect_info.destroyed) {
                    obj.destroy()
                    return
                }

                effect_info.loaded = true
                effect_info.gameObject = obj
                effect_info.event(local_UIEffectInfo.LOAD_COMPLETED)


                scene.addChild(obj)
                let pos_x = curr_pos_index * UIModelClass3D.POS_STEP_VALUE;
                let pos_y = curr_pos_index * UIModelClass3D.POS_STEP_VALUE;
                pos_x += position.x
                pos_y += position.y

                let transform = obj.transform
                Set3DLocalPosition(transform, -pos_x, -pos_y, 0)
                Set3DLocalRotationEuler(transform, 0, rotation || 0, 0)
                Set3DLocalScale(transform, scale.x, scale.y, scale.z)
                is_loop = is_loop || false
                if (last_time && last_time > 0) {
                    let onDelay = () => {
                        if (!this.use_delete_method && !effect_info.destroyed) {
                            parent.event(local_UIEffectInfo.MANUL_REMOVED)
                            if (playend_call_back_func) {
                                playend_call_back_func();
                            }
                        }
                    };
                    setTimeout(onDelay, last_time * 1000);
                }
                if (load_finish_func)
                    load_finish_func(obj);
            }

            let hashCode = hash_target && hash_target.hashCode || this.hashCode
            effect_res_type = effect_res_type || EffectResType.UI
            let full_url = GameResPath.GetEffectPath(effect_res_type, res_name)
            ResManager.GetInstance().CreatePrefab(hashCode, full_url, load_call_back, load_queue)


            let camera: Laya.Camera = scene.addChild(new local_Laya.Camera(0, 0.3, 1000)) as Laya.Camera
            camera.name = "uicamera"

            Set3DLocalPosition(camera.transform, -curr_pos_index * UIModelClass3D.POS_STEP_VALUE, -curr_pos_index * UIModelClass3D.POS_STEP_VALUE, -10)

            Set3DLocalRotationEuler(camera.transform, 0, 180, 0)

            Set3DLocalScale(camera.transform, 1, 1, 1)

            // //清除摄像机的标记
            camera.orthographic = true
            camera.useOcclusionCulling = false
            // // camera.clearFlag = local_Laya.CameraClearFlags.DepthOnly;
            camera.clearFlag = local_Laya.CameraClearFlags.SolidColor;
            camera.clearColor = new local_Laya.Vector4(0.0, 0.0, 0.0, 0.0);
            camera.enableHDR = false
            // // camera.fieldOfView = 60
            camera.orthographicVerticalSize = local_Laya.stage.height * 0.01;
            let p = local_Laya.stage.height / 1280
            let renderTexture = local_Laya.RenderTexture.createFromPool(parent.width * p, parent.height * p, local_Laya.RenderTextureFormat.R8G8B8A8, local_Laya.RenderTextureDepthFormat.DEPTH_16)
            camera.renderTarget = renderTexture
            // camera["effect_target"] = this
            // camera["parent_target"] = parent


            let img = window["GetImageFromPool"]() || new local_Laya.Image();
            img.source = new local_Laya.Texture(renderTexture)
            img.centerX = img.centerY = 0
            parent.addChild(img);

            parent["__effect_img"] = img
            effect_info.render_texture = renderTexture
            effect_info.camera = camera
            effect_info.scene = scene
            effect_info.AddParent(parent)
            return img
        }
    };
}
var local_UIEffect = UIEffect
window["UIEffect"] = UIEffect