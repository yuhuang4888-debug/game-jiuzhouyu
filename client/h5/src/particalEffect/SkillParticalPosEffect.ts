import { ParticleEffect } from "../particalEffect/ParticleEffect"
import { EffectResType } from "../scene/SceneConfig"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"

export class SkillParticalPosEffect extends ParticleEffect {
	effect_id
	res_name
	effect_pos
	is_loop
	last_time
	dir
	target_id
	move_speed
	move_dist
	effect_type
	max_depth
	load_callback
	particle_speed
	load_level
	call_back_func
	public constructor(){
		super() 
	}

	public initData(effect_id?, res_name?, pos?, is_loop?, last_time?, dir?, effect_attacker_id?, move_speed?, move_dist?, effect_type?, max_depth?, load_callback?, particle_speed?, load_level?, call_back_func?, effect_res_type?){ 
		super.initData()

		this.effect_id = effect_id
		this.res_name = res_name
		this.effect_pos = pos
		this.is_loop = is_loop || false
		this.last_time = last_time || null
		this.dir = dir
		this.target_id = effect_attacker_id //唯一id 目的是为了删除该玩家的特效时 可以通过这个id定位到
		this.move_speed = move_speed
		this.move_dist = move_dist
		this.effect_type = effect_type
		this.max_depth = max_depth
		this.load_callback = load_callback || false
		this.particle_speed = particle_speed
		this.load_level = load_level || LOAD_QUEUE.MIDDLE
		this.call_back_func = call_back_func
		this.effect_res_type = effect_res_type || EffectResType.Skill
	}
}
window["SkillParticalPosEffect"] = SkillParticalPosEffect