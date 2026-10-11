import { HashEventDispatcher } from "../common/HashEventDispatcher";
import { Runner } from "../util/Runner";
import { FRAME_TYPE } from "../util/DeclareGlobalVar";
import { FightManager } from "../scene/fight/FightManager";
import { SkillParticalTargetEffect } from "./SkillParticalTargetEffect";
import { SkillParticalPosEffect } from "./SkillParticalPosEffect";
import { Set3DLocalScale, Util } from "../util/Util";
import { SettingModel } from "../commonModel/SettingModel";
// TypeScript file

let local_Laya = Laya
export class ParticleManager extends HashEventDispatcher {
    static Instance: ParticleManager;
    static CACHE_PS_TYPE = {
        TARGET_EFFECT: 1,
        POS_EFFECT: 2
    };
    particle_list: {
        [key: number]: any;
    } = {};

    particle_effect_Id = 1;
    skill_count = 0;
    ui_partical_list = {};
    ps_delay_list = [];
    fight_mgr: FightManager
    public static GetInstance() {
        if (!ParticleManager.Instance) {
            ParticleManager.Instance = new ParticleManager();
        }
        return ParticleManager.Instance;
    }
    public constructor() {
        super();
        Runner.GetInstance().AddRunObj(this, 1, FRAME_TYPE.even);

        this.fight_mgr = FightManager.GetInstance()
    }

    public AddEffect(tgt_skill_effect, is_delay) {
        let effectId = this.particle_effect_Id;
        tgt_skill_effect.is_delay = is_delay;
        this.particle_list[effectId] = tgt_skill_effect;
        this.particle_effect_Id = effectId + 1;
        this.skill_count = this.skill_count + 1;
        return effectId;
    };


    /**
     * 
     * @param res_name 资源名
     * @param target_id 挂载目标id
     * @param is_loop 是否循环
     * @param last_time 持续时间
     * @param dir 方向
     * @param attach_type 目标类型
     * @param call_back_func 删除回调
     * @param is_delay 是否延迟加载
     * @param priority 优先级 null或1：可添加， 2：特效总量少于上限的60%时可添加， 3：特效总量少于上限30%可添加
     * @param max_depth 深度
     * @param load_callback 加载回调
     * @param particle_speed 特效速度
     * @param load_level 加载优先级
     * @param offset 偏移
     * @param effect_res_type 资源类型
     * @returns ParticalEffect
     */
    public AddTargetEffect(res_name, target_id, is_loop, last_time?, dir?, attach_type?, call_back_func?, is_delay?, priority?, max_depth?, load_callback?, particle_speed?, load_level?, offset?, effect_res_type?) {

        if (!this.CanAddEffectPriority(priority))
            return null;
        let tgt_skill_effect = this.fight_mgr.particle_tar_pool.shift() || new SkillParticalTargetEffect();
        tgt_skill_effect.initData(this.particle_effect_Id, res_name, target_id, is_loop, last_time, dir, attach_type, call_back_func, ParticleManager.CACHE_PS_TYPE.TARGET_EFFECT, max_depth, load_callback, particle_speed, load_level, offset, effect_res_type);
        is_delay = ((is_delay == null || is_delay == true) && priority != 0) ? true : false; //默认为true
        if (is_delay)
            this.ps_delay_list.push(tgt_skill_effect);
        else
            tgt_skill_effect.PlayEffect();
        return this.AddEffect(tgt_skill_effect, is_delay);
    };

    /**
     * 
     * @param res_name 资源名
     * @param pos 特效位置
     * @param is_loop 循环
     * @param last_time 持续时间
     * @param dir 方向
     * @param is_delay 是否延迟加载
     * @param effect_attacker_id 唯一id 目的是为了删除该玩家的特效时 可以通过这个id定位到
     * @param move_speed 移动速度
     * @param move_dist 移动距离
     * @param priority 优先级 null或1：可添加， 2：特效总量少于上限的60%时可添加， 3：特效总量少于上限30%可添加
     * @param max_depth 深度
     * @param load_callback 加载回调
     * @param particle_speed 特效速度
     * @param load_level 加载优先级
     * @param call_back_func 删除回调
     * @param effect_res_type 资源类型
     * @returns ParticalEffect
     */
    public AddPosEffect(res_name, pos, is_loop?, last_time?, dir?, is_delay?, effect_attacker_id?, move_speed?, move_dist?, priority?, max_depth?, load_callback?, particle_speed?, load_level?, call_back_func?, effect_res_type?) {
        if (!this.CanAddEffectPriority(priority))
            return null;
        let tgt_skill_effect = this.fight_mgr.particle_pos_pool.shift() || new SkillParticalPosEffect();
        tgt_skill_effect.initData(this.particle_effect_Id, res_name, pos, is_loop, last_time, dir, effect_attacker_id, move_speed, move_dist, ParticleManager.CACHE_PS_TYPE.POS_EFFECT, max_depth, load_callback, particle_speed, load_level, call_back_func, effect_res_type);
        is_delay = ((is_delay == null || is_delay == true) && priority != 0) ? true : false; //默认为true
        if (is_delay)
            this.ps_delay_list.push(tgt_skill_effect);
        else
            tgt_skill_effect.PlayEffect();
        return this.AddEffect(tgt_skill_effect, is_delay);
    };

    //根据资源id删除特效
    public DelEffect(id) {
        let size = this.ps_delay_list.length;
        if (size > 0) {
            for (let i = 0; i < size; i++) {
                let effect = this.ps_delay_list[i];
                if (effect && id == effect.effect_id) {
                    this.ps_delay_list.splice(i, 1);
                    break;
                }
            }
        }
        let skill_effect = this.particle_list[id];
        if (skill_effect) {
            delete this.particle_list[id];
            skill_effect.AppendCache();
            this.skill_count = this.skill_count - 1;
        }
    };

    //根据优先级决定是否可以加特效
    //优先级为：null或1：可添加， 2：特效总量少于上限的60%时可添加， 3：特效总量少于上限30%可添加
    public CanAddEffectPriority(priority) {
        if (priority == 1)
            return true;
        else if (this.skill_count >= this.GetSkillEffectMaxCount())
            return false;
        return true;
    };

    public GetSkillEffectMaxCount() {
        return SettingModel.GetInstance().effect_num
    };

    //删除全部特效
    public DelAllEffects() {
        let deleteList = [];
        for (let id in this.particle_list)
            deleteList.push(id);
        for (let id of deleteList) {
            this.particle_list[id].AppendCache();
            delete this.particle_list[id];
        }
        let item = this.ps_delay_list.pop();
        while (item) {
            item.AppendCache();
            item = this.ps_delay_list.pop();
        }
        this.ps_delay_list.length = 0;
        this.skill_count = 0;
    };

    public SetEffectScale(id, scale) {
        let effect = this.particle_list[id];
        if (effect != null)
            // if (!effect.is_delay) {
            effect.SetScale(scale);
        // }
    };

    public SetEffectPos(id, x, y) {
        let effect = this.particle_list[id];
        if (effect != null)
            if (!effect.is_delay)
                effect.SetPos(x, y);
    };

    public GetEffect(id) {
        let effect = this.particle_list[id];
        return effect;
    };

    //添加ui特效 来每帧判断是否播放完毕 
    public AddUIPartical(go, callback) {
        this.ui_partical_list[go] = callback;
    };

    //移除ui特效
    public RemoveUIPartical(go) {
        delete this.ui_partical_list[go];
    };

    public Update(now_time, elapse_time) {
        let deleteList = null;
        let node;
        for (let id in this.particle_list) {
            node = this.particle_list[id];
            if (!node.is_delay) {
                let result = node.Update(now_time, elapse_time);
                if (!result) {
                    deleteList = deleteList ? deleteList : [];
                    deleteList.push(id);
                }
            }
        }
        if (deleteList) {
            for (let id of deleteList) {
                if (this.particle_list[id] != null) {
                    this.particle_list[id].AppendCache();
                    delete this.particle_list[id];
                    this.skill_count = this.skill_count - 1;
                }
            }
        }

        this.AddDelayPs(); //延迟加载特效
    };
    public AddDelayPs() {
        let size = this.ps_delay_list.length;
        if (size > 0) {
            let skill_effect = this.ps_delay_list.shift();
            if (!skill_effect || !this.particle_list[skill_effect.effect_id])
                return;
            if (skill_effect.effect_type) {
                if (skill_effect.effect_type == ParticleManager.CACHE_PS_TYPE.POS_EFFECT)
                    skill_effect.PlayEffect();
                else if (skill_effect.effect_type == ParticleManager.CACHE_PS_TYPE.TARGET_EFFECT)
                    skill_effect.PlayEffect();
                skill_effect.is_delay = false;
            }
        }
    };

    public static SetSpeed(go, speed: number) {
        if (go != null) {
            let anis = Util.GetComponentsInChildren(go, local_Laya.Animator)
            let len = anis.length;
            if (len > 0) {
                let ani;
                for (let i = 0; i < len; i++) {
                    ani = anis[i];
                    ani.speed = speed;
                }
            }

            let particles = Util.GetComponentsInChildren(go, local_Laya.ShuriKenParticle3D)
            len = particles.length;
            let particle;
            for (let i = 0; i < len; i++) {
                particle = particles[i];
                particle.particleSystem.simulationSpeed = speed;
            }
        }

    }

    public static SetLoop(go: Laya.Sprite3D, loop: boolean) {
        let particles = Util.GetComponentsInChildren(go, local_Laya.ShuriKenParticle3D)
        let len = particles.length;
        let particle;
        for (let i = 0; i < len; i++) {
            particle = particles[i];
            particle.particleSystem.looping = loop;
        }
    }

    public static SetScale(go: Laya.Sprite3D, scale: number) {
        if (go != null) {
            let particles = Util.GetComponentsInChildren(go, local_Laya.ShuriKenParticle3D)
            let len = particles.length;
            let particle: Laya.ShuriKenParticle3D, particle_system: Laya.ShurikenParticleSystem

            for (let i = 0; i < len; i++) {
                particle = particles[i];
                particle_system = particle.particleSystem
                if (particle_system.scaleMode == 1) {
                    // particle.transform.localScale = new Laya.Vector3(scale, scale, scale)
                    Set3DLocalScale(particle.transform, scale, scale, scale)
                } if (particle_system.scaleMode == 2) {
                    // //如果是3d模式
                    if (particle_system.threeDStartSize) {
                        switch (particle_system.startSizeType) {
                            case 0:
                                local_Laya.Vector3.scale(particle_system.startSizeConstantSeparate, scale, particle_system.startSizeConstantSeparate)
                                break
                            case 2:
                                local_Laya.Vector3.scale(particle_system.startSizeConstantMaxSeparate, scale, particle_system.startSizeConstantMaxSeparate)
                                break

                        }
                    }
                    else {
                        switch (particle_system.startSizeType) {
                            case 0:
                                particle_system.startSizeConstant *= scale
                                break
                            case 2:
                                particle_system.startSizeConstantMax *= scale
                                break

                        }
                    }
                }

            }
            Set3DLocalScale(go.transform, scale, scale, scale)
        }
    }

    public static PlayEnd(go) {
        let all_stopped: boolean = true;
        if (go != null) {
            let particles = Util.GetComponentsInChildren(go, local_Laya.ShuriKenParticle3D)
            let len = particles.length;
            let particle;
            for (let i = 0; i < len; i++) {
                particle = particles[i];
                if (particle && particle.particleSystem.isPlaying == true) {
                    all_stopped = false;
                    break;
                }
            }
        }
        return all_stopped;
    }
}

window["ParticleManager"] = ParticleManager