import { BuffVo } from "./BuffVo";
import { FightManager } from "./FightManager";
import { SkillManager } from "../../skill/SkillManager";
import { SceneManager } from "../SceneManager";
import { Config } from "../../common/Config";
import { EffectResType, SceneBaseType } from "../SceneConfig";
import { Util } from "../../util/Util";
import { Vector2 } from "../../util/Vector2";
import { ParticleManager } from "../../particalEffect/ParticleManager";
import { EarlyWarningManager, EarlyWarnType } from "./EarlyWarningManager";
// TypeScript file
let local_BuffVo = BuffVo
export class BuffListVo {
	parent_manager;
	character;
	character_vo;
	is_main_role;
	buff_type = 0;
	buff_list: {
		[key: number]: BuffVo;
	} = {};
	particle_list = {};
	is_finish = null;
	update_times_index = 0;
	fight_mgr = FightManager.GetInstance();
	skill_mgr = SkillManager.GetInstance();
	scene_mgr = SceneManager.GetInstance();
	// particle_mgr = ParticleManager.GetInstance()
	other_fight_info = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo;
	public constructor() {
	}
	public initData(parent_manager, character) {
		this.parent_manager = parent_manager;
		this.character = character;
		this.character_vo = character.vo;
		this.is_main_role = (character.GetType() == SceneBaseType.MainRole);
	}
	public resetData() {
		this.parent_manager = null; //parent_manager
		this.character = null; //character
		this.character_vo = null; //character:GetVo()
		this.is_main_role = null; //(character:GetType() == SceneBaseType.MainRole)
		this.buff_type = 0;
		this.buff_list = {};
		this.particle_list = {};
		this.is_finish = null;
		this.update_times_index = 0;
	}
	public DeleteMe() {
		// super.DeleteMe()
	}
	public AddBuffVo(vo) {
		let trigger_start = false;
		this.buff_type = vo.iconType;
		let buff_vo = this.buff_list[vo.id];
		if (buff_vo == null) {
			trigger_start = true;
			buff_vo = this.fight_mgr.buffVo_pool.shift() || new local_BuffVo();
			buff_vo.initData(this.character);
			this.buff_list[vo.id] = buff_vo;
		}
		buff_vo.SetData(vo);
		if (trigger_start) {
			this.TriggerStartBuff(buff_vo);
			this.is_finish = false; //有新增的时候重新设置为未完成 是为了防止在设为true等待manager删除的时候 
		} //调用了这个方法增加buff 但是该属性没改变导致会也一起被删除 而没有调用TriggerStopBuff
		this.parent_manager.checkBuffShowTime(vo);
		return trigger_start
	}
	public DeleteBuffVo(vo) {
		this.parent_manager.delBuffShowTime(vo);
		delete this.buff_list[vo.skill_id];
		this.TriggerStopBuff(vo);
		if (Util.IsTableEmpty(this.buff_list))
			this.is_finish = true;
	}
	public GetBuffFormComboSkill(main_skill) {
		let skill_vo = this.skill_mgr.getSkill(main_skill);
		if (skill_vo) {
			let vo = null;
			let combo_infos = skill_vo.getComboSkill();
			if (combo_infos) {
				for (let i = 0; i < combo_infos.length; i++) {
					let info = combo_infos[i];
					vo = this.GetBuffBySkillId(info.skill_id);
					if (vo)
						return vo;
				}
			}
		}
	}
	public GetBuffBySkillId(skill_id) {
		return this.buff_list[skill_id];
	}
	public DeleteBuffBySkillId(skill_id) {
		let vo = this.buff_list[skill_id];
		if (vo)
			this.DeleteBuffVo(vo);
	}
	public TriggerStartBuff(buff_vo) {
		buff_vo.TriggerStart();
		//处理一个特效资源只能显示一个 不能叠加
		let vo = buff_vo.GetBuffVo()
		let buff_effect_id = vo.buff_effect_id;
		let has_add = false;
		if (buff_effect_id > 0) //大于0需要显示buff特效
		{

			let particle_name = `buffparticle_${this.buff_type}_${buff_effect_id}`;

			let is_loop = true
			let time = 99999
			let effect_res_type = EffectResType.Buff
			let assist_buff_res_vo = this.other_fight_info.assist_buff_res && this.other_fight_info.assist_buff_res[vo.id]
			if (assist_buff_res_vo) { //辅助技能读取特效配置
				particle_name = assist_buff_res_vo.res
				is_loop = assist_buff_res_vo.isLoop
				time = assist_buff_res_vo.time
				effect_res_type = assist_buff_res_vo.effect_res_type || EffectResType.Buff
			}

			let particle_id = this.particle_list[particle_name];
			if (particle_id == null) {
				has_add = true;
				let max_depth = false;
				let buff_cfg = this.other_fight_info.buff_res_info_list[this.buff_type];
				let attach_type = 7
				if (buff_cfg) {
					attach_type = buff_cfg.attach_type || 7
					is_loop = (buff_cfg.isLoop == null) ? is_loop : buff_cfg.isLoop
				}
				particle_id = ParticleManager.GetInstance().AddTargetEffect(particle_name, this.character.compress_id, is_loop, time, null, null, null, true, 1, max_depth, null, null, null, null, effect_res_type);
				this.particle_list[particle_name] = particle_id;
			}

		}
	}
	public TriggerStopBuff(buff_vo) {
		buff_vo.TriggerStop();
		let vo = buff_vo.GetBuffVo()
		//处理停止一个buff的时候 如果还有其他需要显示该特效的buff 就不能删除buff特效//
		let buff_effect_id = vo.buff_effect_id;
		let stop_particle = true;
		if (buff_effect_id > 0) //大于0需要显示buff特效
		{
			for (let id in this.buff_list) {
				if (this.buff_list[id].GetBuffVo().buff_effect_id == buff_effect_id) {
					stop_particle = false;
					break;
				}
			}
			if (stop_particle) {
				if (this.other_fight_info.pre_warn_buffer_type[this.buff_type]) {
					EarlyWarningManager.GetInstance().StopWarning(this.character.id, EarlyWarnType.Circle, 0);
				}
				else {
					let particle_name = `buffparticle_${this.buff_type}_${buff_effect_id}`;
					let assist_buff_res_vo = this.other_fight_info.assist_buff_res && this.other_fight_info.assist_buff_res[vo.id]
					if (assist_buff_res_vo) { //辅助技能读取特效配置
						particle_name = assist_buff_res_vo.res
					}
					let particle_id = this.particle_list[particle_name];
					if (particle_id) {
						ParticleManager.GetInstance().DelEffect(particle_id);
						delete this.particle_list[particle_name];
					}
				}
			}
		}
		this.fight_mgr.pushBuffVo(buff_vo);
	}
	public GetValue(base_value) {
		let value = base_value;
		for (let id in this.buff_list) {
			value = value + this.buff_list[id].GetBuffVo().integer + base_value * this.buff_list[id].GetBuffVo().decimals / 1000;
		}
		return value;
	}
	//得到最大的持续时间
	public GetMaxLastTime() {
		let value = 0;
		for (let id in this.buff_list)
			value = Math.max(value, this.buff_list[id].GetLeftTime());
		return value;
	}
	public Update(total_time, elapse_time) {
		if (this.is_finish)
			return false;
		let delList: Array<any>;
		for (let id in this.buff_list) {
			if (this.buff_list[id].Update(total_time, elapse_time) == false) {
				if (delList == null)
					delList = [];
				delList.push(this.buff_list[id]);
			}
		}
		if (delList)
			this.DeleteBuffList(delList);
		return true;
	}
	public DeleteBuffList(delList) {
		//删除已经到期的buff
		for (let buffVo of delList) {
			if (buffVo)
				this.DeleteBuffVo(buffVo);
		}
	}
	//预警类型buff
	public ShowPreWarnBuffer(pre_warn_buff_cfg) {
		EarlyWarningManager.GetInstance().ShowWarning(this.character.id, EarlyWarnType.Circle, pre_warn_buff_cfg.area, pre_warn_buff_cfg.time / 1000, this.character.GetRealPos(), undefined, undefined, pre_warn_buff_cfg.show_count_down);
	}
}

window["BuffListVo"] = BuffListVo