import { ParticleEffect } from "../particalEffect/ParticleEffect"
import { EffectResType } from "../scene/SceneConfig"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"

export class SkillParticalTargetEffect extends ParticleEffect {
	effect_id
	res_name
	target_id
	is_loop
	last_time
	dir
	attach_type
	call_back_func
	is_delay
	priority
	max_depth
	load_callback
	particle_speed
	load_level
	offset
	
	public constructor(){
		super()

	}

	public initData(effect_id?, res_name?, target_id?, is_loop?, last_time?, dir?, attach_type?, call_back_func?, effect_type?, max_depth?, load_callback?, particle_speed?, load_level?, offset?, effect_res_type?) {
		super.initData()
		this.effect_id = effect_id
		this.res_name = res_name
		this.is_loop = is_loop || false
		this.last_time = last_time || null

		//复合id
		this.target_id = target_id
		this.attach_type = attach_type || 7  //挂点
		this.call_back_func = call_back_func //播放完特效回调
		this.dir = dir
		this.effect_type = effect_type
		this.max_depth = max_depth
		this.load_callback = load_callback || false
		this.particle_speed = particle_speed
		this.load_level = load_level || LOAD_QUEUE.MIDDLE
		this.offset = offset || false
		this.effect_res_type = effect_res_type || EffectResType.Skill
	}
}


window["SkillParticalTargetEffect"] = SkillParticalTargetEffect