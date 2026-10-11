import { BaseClass } from "../common/BaseClass"
import { Config, Config_Type } from "../common/Config"
import { LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { FightManager } from "../scene/fight/FightManager"
import { Scene } from "../scene/Scene"
import { AttachNode, EffectResType, ParticleAttachNode, SceneBaseType, SceneRotateY } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Status } from "../util/Status"
import { ResetTransform, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { ParticleManager } from "./ParticleManager"



// 粒子特效基类
let local_ParticleManager
let local_Util = Util
export class ParticleEffect extends BaseClass {
    abName
    attach_type
    call_back_func
    res_name
    dir
    effect_id
    effect_pos
    effect_type
    transform:Laya.Transform3D
    gameObject:Laya.Sprite3D
    ignore_floor
    is_loop
    is_push_to_cache
    last_time
    last_time_id
    layer
    max_depth
    move_speed
    move_dist
    offset
    order
    play_complete_time
    scale = 1
    speed
    target_id
    time_index = 0
    load_callback      
    can_update = true
    rotateY = 0
    is_loaded = false     //是否加载完资源 
    particle_speed = false//播放速度
    load_level = LOAD_QUEUE.MIDDLE
    fight_mgr = FightManager.GetInstance()   
    scene_mgr = SceneManager.GetInstance()
    curr_rotate = new Laya.Vector3(0, 0, 0)
    ref_tar
    effect_res_type
    ignore_pool
    res_url
    resMgr:ResManager = ResManager.GetInstance()
    cache_scale
    cache_speed
    public constructor(){ 
        super()
        local_ParticleManager = ParticleManager
    }


    public DeleteMe(){ 
        this.DelEffect()
        super.DeleteMe()
    }

    public AppendCache(){ 
        
        if (this.is_push_to_cache ) {
            return
        }
        if (this.effect_type == local_ParticleManager.CACHE_PS_TYPE.TARGET_EFFECT ) {
            if (! this.is_push_to_cache ) {
                this.fight_mgr.pushTarParticleVo(this)
            }
        } else if (this.effect_type == local_ParticleManager.CACHE_PS_TYPE.POS_EFFECT ) {
            if (! this.is_push_to_cache ) {
                this.fight_mgr.pushPosParticleVo(this)
            }
        }else{
            this.DeleteMe()
        }
    }

    public initData(){ 
        this.is_push_to_cache = false
    }

    public resetData(){ 
        this.is_push_to_cache = true
        this.DelEffect()
    }

    //删除特效
    public DelEffect(){ 
        
        if (this.call_back_func &&  typeof(this.call_back_func) == "function") {
            this.call_back_func()
        }
        if (this.effect_type == local_ParticleManager.CACHE_PS_TYPE.TARGET_EFFECT && this.target_id ) {
            if (typeof(this.target_id) == "string" ) {
                let tgt_obj = Scene.Instance.GetObjByCompressedId(this.target_id, true)
                if (tgt_obj ) {
                    tgt_obj.RemoveParticle(this.effect_id)
                }
            }
        }

        if (!local_Util.IsNull(this.gameObject)) {
            if (!this.ignore_pool && this.res_url) {
                this.SetScale(1 / (this.scale))
                this.resMgr.AddSprite3DToPool(this.hashCode, this.res_url , this.gameObject)
            }else{
                this.gameObject.destroy()
            }
        }

        this.resMgr.DestroyAllReferenceRes(this.hashCode)
        this.effect_id = null
        this.gameObject = null
        this.transform = null
        this.res_name = null
        this.res_url = null
        this.abName = null
        this.is_loop = null
        this.speed = false
        this.scale = 1
        this.last_time = false
        this.play_complete_time = false
        this.effect_pos = null
        this.call_back_func = false
        this.dir = null
        this.max_depth = false
        this.rotateY = 0
        this.effect_type = false
        this.target_id = null
        this.attach_type = null
        this.can_update = true
        this.is_loaded = false
        this.time_index = 0		
        this.layer = false      	   //特效层次
        this.order = false
        this.load_callback = false
        this.offset = false
        this.cache_scale = undefined
        this.cache_speed = undefined
    }


    //创建粒子特效
    public CreateEffect(){ 
        if (!this.res_name || this.res_name == "0") {
            this.can_update = false
            return
        }
        if (this.effect_type == local_ParticleManager.CACHE_PS_TYPE.TARGET_EFFECT && this.target_id ) {
            if (typeof(this.target_id) == "string" ) {
                let tgt_obj = Scene.Instance.GetObjByCompressedId(this.target_id, true)
                let index = this.target_id.indexOf("_");
			    let obj_type = +this.target_id.substr(0, index);
                
                if (!tgt_obj || (obj_type == SceneBaseType.Drop && !tgt_obj.model_transform) || (obj_type != SceneBaseType.Drop && !tgt_obj.transform)) {//有可能是宿主隐藏掉了 没有加载模型资源 导致特效挂不上去
                    this.can_update = false
                    return
                }
            }
        }
        let local_res_name = this.res_name

        let res_url = GameResPath.GetEffectPath(this.effect_res_type, local_res_name)
        this.res_url = res_url
        var load_call_back = (obj:Laya.Sprite3D)=> {
            if (!obj) {
                console.warn("!!!!!!!!!!!!!!!!!!!!ParticleEffect 找不到特效资源" + this.res_name)
                this.can_update = false
                return
            }
            if (this.use_delete_method || this.is_push_to_cache || ! this.res_url ) {
                this.can_update = false
                this.resMgr.AddSprite3DToPool(this.hashCode, obj.url, obj)
                return
            }
            if (this.gameObject) {
                if (res_url == this.res_url ) { //最后加载的特效是最新的 就删掉旧的特效
                    this.SetScale(1 / (this.scale))
                    this.resMgr.AddSprite3DToPool(this.hashCode, this.gameObject.url, this.gameObject)
                }else{
                    this.resMgr.AddSprite3DToPool(this.hashCode, obj.url, obj)
                    return
                }
            }

            
            this.gameObject = obj
            this.transform = this.gameObject.transform
            if (this.effect_type == local_ParticleManager.CACHE_PS_TYPE.POS_EFFECT) {
                LayerManager.GetInstance().Scene3D.addChild(obj)
                ResetTransform(this.transform)
               
                local_Util.tempVector3.setValue(0, SceneObj.StartRotate.y, 0)//
                this.transform.rotate(local_Util.tempVector3, true, false)
                local_Util.tempVector3.setValue(SceneObj.StartRotate.x, 0, 0)//
                this.transform.rotate(local_Util.tempVector3, true, false)
                
                let pos = this.effect_pos || new Vector3(0, 0, 0)
                this.SetPos(pos.x, pos.y, pos.z)
                this.SetDirection()
                if (this.particle_speed) {
                    this.SetSpeed(this.particle_speed)	
                }
            } else if (this.effect_type == local_ParticleManager.CACHE_PS_TYPE.TARGET_EFFECT && this.target_id ) {
                if (typeof(this.target_id) != "string" ) {
                    let bone_name = ParticleAttachNode[this.attach_type] || this.attach_type
                    let transform = this.target_id.transform
                    let bone:Laya.Sprite3D
                    if (bone_name && transform ) {
                        if (bone_name == AttachNode.SceneObj ) {
                            bone = this.target_id.root_transform.owner
                        }else{
                            bone = local_Util.FindBone(transform.owner, bone_name)
                        }
                        if (bone == null ) {
                            this.gameObject.destroy()
                            this.gameObject = null
                            this.transform = null
                            this.can_update = false
                            return
                        }
                        bone.addChild(this.gameObject)
                        ResetTransform(this.transform)

                        if (bone_name == AttachNode.SceneObj ) {
                            local_Util.tempVector3.setValue(-SceneObj.StartRotate.x, 0, 0)
                            this.transform.rotate(local_Util.tempVector3, true, false)
                        }

                        this.SetDirection()

                        if (this.particle_speed) {
                            this.SetSpeed(this.particle_speed)	
                        }
                    }
                }else{
                    let tgt_obj = Scene.Instance.GetObjByCompressedId(this.target_id, true)
                    if (tgt_obj) {
                        tgt_obj.AddParticle(this.effect_id, this.transform, this.attach_type, this.particle_speed, this.dir)
                    }else{
                        this.gameObject.destroy()
                        this.gameObject = null
                        this.transform = null
                        this.can_update = false
                        return
                    }
                }
            }

            if(this.cache_scale){
                this.SetScale(this.cache_scale)
            }

            if (this.last_time && this.last_time > 0 ) {
                this.play_complete_time = Status.NowTime + this.last_time
            }
            
            this.is_loaded = true
            if (this.load_callback ) { this.load_callback(this.gameObject) }

            if (this.offset) {
                Set3DLocalPosition(this.transform,this.offset.x,this.offset.y,this.offset.z)
            }
        }
        
        this.resMgr.CreatePrefab(this.hashCode, this.res_url, load_call_back, this.load_level)
    }


    //设置方向
    public SetDirection(){ 
        if (this.dir) {
            let angle = this.scene_mgr.GetAngle(this.dir.x,this.dir.y)
            this.SetRotateY(angle, this.dir)
        }
    }


    public SetRotateY( rotate ?, dir?){ 
        let y_off = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.test_ps_angle * Math.sin(rotate * 2 / 180 * Math.PI)
        let curRotate = - rotate + 90 + y_off
        // console.warn("------SetRotateY------", rotate, this.dir, curRotate)
        if(this.transform){
            this.curr_rotate.y = curRotate - this.rotateY
            this.transform.rotate(this.curr_rotate, true, false)
        }
        this.rotateY = rotate
    }

    public SetPos(x?, y?, z?){ 
        if (this.transform ) {
            let depth = this.scene_mgr.GetSceneObjDepth(y)
            Set3DLocalPosition(this.transform, x * 0.01, y * 0.01, depth)
        }
    }

    public SetSpeed(speed?){ 
        this.speed = speed || this.speed
        if (this.speed && !local_Util.IsNull(this.gameObject) ) {
            local_ParticleManager.SetSpeed(this.gameObject, speed)
        }
    }

    public SetScale(scale?){ 
        if (scale && this.scale != scale ) {
            if(!local_Util.IsNull(this.gameObject)){
                this.scale = scale
                local_ParticleManager.SetScale(this.gameObject, scale)
            }
            else{
                this.cache_scale = scale
            }
        }
    }


    public PlayEnd(){ 
        this.can_update = false
    }

    public Update(now_time?, elapse_time?){ 
        
        if (this.can_update && this.is_loaded ) {
            if (this.move_speed && this.move_speed != 0 ) {
                let step_dist = this.move_speed * elapse_time
                this.effect_pos.x = this.effect_pos.x + this.dir.x * step_dist
                this.effect_pos.y = this.effect_pos.y + this.dir.y * step_dist
                if (this.dir.z ) {
                    this.effect_pos.z = this.effect_pos.z + this.dir.z * step_dist
                }
                this.SetPos(this.effect_pos.x, this.effect_pos.y,this.effect_pos.z)
                this.move_dist = this.move_dist - step_dist
                if (this.move_dist <= 0 ) {
                    this.PlayEnd()
                }
            }
            this.time_index = this.time_index + 1
            if (this.play_complete_time ) {
                if (now_time - this.play_complete_time >= 0 ) {
                    this.PlayEnd()
                }
            }else{
                if (this.time_index % 13 == 0 && this.is_loop != true && ! local_Util.IsNull(this.gameObject) && local_ParticleManager.PlayEnd(this.gameObject) ) {
                    this.PlayEnd()
                }
            }
        }
        return this.can_update
    }

    //设置特效的显示状态
    public ShowEffect(bool){
        if(!local_Util.IsNull(this.gameObject)){
            this.gameObject.active = bool
        }
    }

    //播放粒子特效
    public PlayEffect(){ 
        this.CreateEffect()
    }
}

window["ParticleEffect"] = ParticleEffect