import { ParticleEffect } from "../particalEffect/ParticleEffect"

//////////////////////////////////////////////////////////////// 基于目标的技能
export class SkillParticalUIModelEffect extends ParticleEffect {
	attach_type
	call_back_func
	cast_res
	dir
	effect_id
	effect_type
	is_loop
	is_weapon
	last_time
	layer
	max_depth
	ref_tar
	public constructor(effect_id?, cast_res?, ref_tar?, is_loop?, last_time?, attach_type?, call_back_func?, dir?, effect_type?, max_depth?, is_weapon?, layer?, load_callback?) {
		super()

		super.initData()
		this.effect_id = effect_id
		this.cast_res = cast_res
		this.is_loop = is_loop || false
		this.last_time = last_time || null
		//复合id
		this.ref_tar = ref_tar
		this.attach_type = attach_type || 7  //挂点
		this.call_back_func = call_back_func //播放完特效回调
		this.dir = dir
		this.effect_type = effect_type
		this.max_depth = max_depth
		this.is_weapon = is_weapon
		this.layer = layer
		this.load_callback = load_callback
	}

}
window["SkillParticalUIModelEffect"] = SkillParticalUIModelEffect