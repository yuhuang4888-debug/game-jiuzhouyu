import { SkillManager } from "../../skill/SkillManager";
import { SceneManager } from "../SceneManager";
import { SceneBaseType } from "../SceneConfig";
import { TimeUtil } from "../../util/TimeUtil";
import { Status } from "../../util/Status";
import { SkillBuffType } from "./BuffManager";
import { GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { FightEvent } from "./FightEvent";
import { SkillVo } from "../../skill/SkillVo";
let local_SceneBaseType = SceneBaseType
let local_Status = Status
let local_TimeUtil = TimeUtil
let local_FightEvent = FightEvent
let local_SkillBuffType
export class BuffVo {
	skill_id = 0; //技能ID
	character;
	character_vo;
	is_main_role;
	buff_type = 0; //0
	lastTime = 0; //0
	vo = null; //false
	combo_skills: Array<any>;
	is_finish = false; //falsee
	skill_mgr = SkillManager.GetInstance();
	scene_mgr = SceneManager.GetInstance();
	create_time;
	public constructor() {
		local_SkillBuffType = SkillBuffType
	}
	public initData(character) {
		this.character = character;
		this.character_vo = character.vo;
		this.is_main_role = (character.GetType() == local_SceneBaseType.MainRole);
	}
	public resetData() {
		let self = this;
		self.skill_id = null; //0//技能ID
		self.character = null; //character
		self.character_vo = null; //character.GetVo()
		self.buff_type = 0; //0
		self.lastTime = 0; //0
		self.vo = null; //false
		self.combo_skills = null;
		self.is_finish = false; //false
	}
	public DeleteMe() {
		// super.DeleteMe()
		this.TriggerStop();
	}
	public GetBuffVo() {
		return this.vo;
	}
	public GetLeftTime() {
		let left_time = (this.vo.period - local_TimeUtil.getServerTimeMs()) / 1000;
		if (this.buff_type && this.skill_id && this.buff_type == 101 && this.skill_id == 3601060) {
			if (left_time > 1.2) {
				console.warn("晕眩buff时间异常-------------------");
				// GameError.GetInstance().SendErrorToPHP("晕眩buff时间异常	buff_type:" +  this.buff_type + "	技能id:" + this.skill_id  +
				// 	"	到期unix时间戳:" + this.vo.period + "	buff等级：" + this.vo.level + 
				// 	"	当前服务端时间ms:" + local_TimeUtil.getServerTimeMs() + " 未修正前持续时间：" + left_time, true)
				left_time = 1; //这里修正下晕眩buff的持续时长
			}
		}
		return left_time;
	}
	public SetData(vo) {
		let self = this;
		self.buff_type = vo.iconType;
		self.skill_id = vo.id;
		self.vo = vo;
		self.lastTime = local_Status.NowTime + self.GetLeftTime();
		if (self.is_main_role) {
			if (self.buff_type == local_SkillBuffType.COMBO_SKILL && !self.combo_skills) {
				self.combo_skills = self.skill_mgr.ParseComboSkill(vo.id);
			}
		}
	}
	public TriggerStart() {
		//-处理特殊buff的表现//-
		//主角清某个技能cd
		if (this.is_main_role)
			this.create_time = local_Status.NowTime;
	}
	//Buff结束时调用，要移除创建的特效
	public TriggerStop() {
		if (this.is_finish)
			return;
		let buff_type = this.buff_type;
		let skill_id = this.skill_id;
		if (this.is_main_role) {
		}
		this.is_finish = true;
	}
	public ForceFireSkill(skill_id, target_compress_id?) {
		if (this.is_main_role) {
			this.skill_mgr.setCurrentSkillId(skill_id);
			GlobalEventSystem.Fire(local_FightEvent.RELEASE_MAIN_SKILL, null, null, target_compress_id);
			this.skill_mgr.setCurrentSkillId(null);
		}
	}
	public ForceFireComboSkill(skill_id?, target_compress_id?){ 
	
		let last_fight_msg
		let career
		if (this.is_main_role) {
			if (this.is_main_role) {
				let skill_vo:SkillVo = this.skill_mgr.getSkill(skill_id)
				career  = skill_vo.getCarrer()
				if(career == 52){
					last_fight_msg = SceneManager.GetInstance().GetLastFightMsg(local_SceneBaseType.Partner)
				}
				else{
					last_fight_msg = SceneManager.GetInstance().GetLastFightMsg(local_SceneBaseType.MainRole)
				}
			}
			
			if (last_fight_msg) {
				//console.warn("BuffVo@ForceFireComboSkill", skill_id, last_fight_msg.skill_id)
				last_fight_msg.skill_id = skill_id
				GlobalEventSystem.Fire(local_FightEvent.ROLE_REQUEST_TOFIGHT, last_fight_msg, true)
			}
		}
	}
	public Update(total_time, elapse_time) {
		let self = this;
		if (self.is_finish)
			return false;
		let client_time = local_Status.NowTime;
		if (self.combo_skills) {
			let vo
			for (let key in self.combo_skills) {
				vo = self.combo_skills[key]
				if (vo.time <= client_time && vo.has_trigger == false) {
					vo.has_trigger = true;
					//触发技能
					self.ForceFireComboSkill(vo.skill_id);
				}
			}
		}
		else if (self.buff_type != local_SkillBuffType.COMBO_SKILL && client_time >= self.lastTime)
			return false;
		return true;
	}
}

window["BuffVo"] = BuffVo