import { BaseClass } from "../../common/BaseClass";
import { SceneObj } from "../sceneobj/SceneObj";
import { SkillVo } from "../../skill/SkillVo";
import { Vector2 } from "../../util/Vector2";
import { Scene } from "../Scene";
import { SceneBaseType } from "../SceneConfig";
import { SkillManager } from "../../skill/SkillManager";
import { GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { GameMath } from "../../util/GameMath";
import { ParticleManager } from "../../particalEffect/ParticleManager";
import { LayerManager, Enum_UILayer } from "../../common/LayerManager";
import { FightEvent } from "./FightEvent";
import { Status } from "../../util/Status";
import { GameError } from "../../util/GameError";
import { Character } from "../sceneobj/Character";
export class BulletObj extends BaseClass {
	// static BulletMoveType = {Direction : 1,Trace : 2}
	//沿固定方向移动，按时间结束
	//追踪单个目标，击中目标时结束
	// static BulletDamageType = {OnCollide : 1,OnTime : 2}
	attacker_id = 0;
	skill_id = null;
	live_time = null;
	move_speed = null;
	move_dir = null;
	trace_id = null;
	trace_hiter = null;
	start_time = null;
	delta_time = null;
	end_time = null;
	attacker: Character = null;
	skill_vo: SkillVo;
	has_hited_mon_num = 0;
	has_hited_role_num = 0;
	left_mon_num = 0;
	left_role_num = 0;
	targets_list = [];
	collide_list = {}; //造成过伤害 的目标列表，（为了有些技能对同一个目标只造成一次伤害 )
	last_collide_time = null;
	particle_id = null;
	weapon_type = null; //需要丢出去的武器类型
	particle_res = null;
	has_trigger_damage = null; //是否已经出发完了伤害
	no_damage = false; //客户端战斗场景
	hiter_pos_type;
	attach_type;
	now_pos;
	start_pos = new Vector2();
	damage_pos = new Vector2();
	dir_3d_start_angle;
	is_first_damage = true;
	damage_offset_dist;
	ignore_damage_time = false;
	SetData;
	SetParticleRes;
	Release;
	resetData;
	Update;
	FindTargets;
	TriggerDamage;
	public DeleteMe() {
		this.Release();
		super.DeleteMe();
	}
	public constructor() {
		super();
		//@attacker_id 	攻击者的compress_id
		//@skill_id 	子弹命中目标时放的技能ID
		//@live_time 	子弹的存活时间（不管何种移动类型或伤害触发类型，都可以设置存活时间)
		//@move_type 	子弹移动方式
		//@damage_type 	子弹伤害的触发方式（命中时触发或定时触发）
		//@dir 			方向型移动时的方向
		//@trace_id 	追踪型移动时的追踪目标
		//@delta_time 	每隔一段时间触发伤害的触发间隔
		//@select_type 	选取受击方类型 1圆形 2方形
		let scene = Scene.GetInstance();
		let skill_mgr = SkillManager.GetInstance();
		let local_GlobalEventSystem = GlobalEventSystem;
		let local_SceneBaseType = SceneBaseType;
		let local_GameMath = GameMath;
		let partical_mgr = ParticleManager.GetInstance();
		let sceneObj_lay = LayerManager.GetInstance().GetUILayer(Enum_UILayer.SceneObj);
		let FIND_TARGET_monster = Scene.FIND_TARGET_TYPE.monster;
		let FIND_TARGET_role = Scene.FIND_TARGET_TYPE.role;
		let local_FightEvent = FightEvent;
		this.SetData = (attacker_id, skill_id, live_time, move_speed, move_dir, delta_time, start_time, offset_dist, attach_type, dir_3d_start_angle, is_first_bullet, damage_offset_dist, ignore_damage_time = false, main_skill_id = 0) => {
			delta_time = delta_time || 0.3;
			live_time = live_time || 10;
			this.attacker_id = attacker_id || scene.main_role.compress_id;
			this.skill_id = skill_id;
			this.dir_3d_start_angle = dir_3d_start_angle;
			this.live_time = live_time;
			this.damage_offset_dist = damage_offset_dist;
			this.move_speed = move_speed;
			this.ignore_damage_time = ignore_damage_time;
			// this.trace_hiter = scene.GetObjByCompressedId(this.trace_id)	
			this.start_time = (start_time || 0) + Status.NowTime;
			this.delta_time = delta_time;
			this.move_dir = move_dir;
			this.end_time = this.start_time + live_time;
			this.skill_vo = skill_mgr.getSkill(skill_id);
			if (this.skill_vo == null) {
				GameError.GetInstance().SendErrorToPHP("!!!!!!!!!!!!!!!!!!!!找不到后台技能id" + skill_id);
				return;
			}
			else {
				if (main_skill_id) {
					let main_skill_vo: SkillVo = skill_mgr.getSkill(main_skill_id);
					this.skill_vo.level = main_skill_vo.level;
				}
				let att_num = this.skill_vo.GetAttackNum();
				this.left_mon_num = att_num[1] == 0 ? 99 : att_num[1];
				this.left_role_num = att_num[0] == 0 ? 99 : att_num[0];
				this.has_hited_mon_num = 0;
				this.has_hited_role_num = 0;
			}
			this.has_trigger_damage = false;
			this.attacker = scene.GetObjByCompressedId(attacker_id);
			this.hiter_pos_type = 1; //脚底选怪  1腰部选怪 2头部
			this.attach_type = attach_type || 0;
			if (this.attacker) {
				if (this.attacker.GetType() == local_SceneBaseType.Partner) {
					console.log("-------------------------------------parent");
				}
				// this.now_pos = this.attacker.GetAttachPos(attach_type, this.now_pos);
				// if (this.trace_hiter)
				// {
				//	 let h_pos = this.trace_hiter.GetRealPos()
				//	 let nx, ny = this.now_pos.x, this.now_pos.y
				//	 ty = ty + this.trace_hiter.GetBodyHeight() * 0.5
				//	 ny = ny + this.attacker.GetBodyHeight() * 0.5
				//	 this.move_dir 	= co.Vector2(tx-nx, ty-ny)
				//	 co.NormaliseXYTable(this.move_dir)
				// }
				if (offset_dist) {
					this.now_pos.x = this.now_pos.x + this.move_dir.x * offset_dist;
					this.now_pos.y = this.now_pos.y + this.move_dir.y * offset_dist;
				}
				this.start_pos.x = this.now_pos.x;
				this.start_pos.y = this.now_pos.y;
				// this.attacker.SetDirectionByDir(this.move_dir);
				this.no_damage = !main_skill_id;
			}
			if (!is_first_bullet) {
				this.no_damage = true;
			}
		};
		this.SetParticleRes = (res) => {
			this.particle_res = res;
		};
		this.Release = () => {
			if (this.particle_id) {
				partical_mgr.DelEffect(this.particle_id);
				this.particle_id = null;
			}
		};
		this.resetData = () => {
			this.is_first_damage = true;
			this.targets_list = [];
			this.collide_list = {};
			this.Release();
		};
		//返回false表示生命周期结束
		this.Update = (total_time, elapse_time) => {
			if (total_time < this.start_time)
				return true;
			if (this.attacker == null || this.attacker.vo == null || this.attacker.IsDead())
				return false;
			if (this.particle_id == null) {
				if (this.particle_res) {
					this.particle_id = partical_mgr.AddPosEffect(this.particle_res, this.now_pos, true, null, this.move_dir, false, null, null, this.attacker.vo.particle_priority, sceneObj_lay, null, this.move_dir, false, this.dir_3d_start_angle);
				}
			}
			let hitted = false;
			//按方向移动
			// if (this.move_type == BulletObj.BulletMoveType.Direction)
			// {
			this.now_pos.x += this.move_dir.x * this.move_speed * elapse_time;
			this.now_pos.y += this.move_dir.y * this.move_speed * elapse_time;
			// }
			//追踪指定目标
			// elseif this.move_type == BulletObj.BulletMoveType.Trace then
			//	 if this.trace_hiter and not this.trace_hiter.IsDead() then
			//		 let tx, ty = this.trace_hiter.GetRealPos()
			//		 ty = ty + this.trace_hiter.GetBodyHeight() / 2
			//		 let nx, ny = this.now_pos.x, this.now_pos.y
			//		 let dir 	= co.Vector2(tx-nx, ty-ny)
			//		 let dist 	= dir.normalise()
			//		 this.move_dir = dir
			//		 let move_speed = GameMath.ChangeEllipseValue(this.move_dir, this.move_speed)
			//		 let delta = move_speed * elapse_time
			//		 if dist <= delta + 20 then
			//			 hitted = true				
			//			 this.now_pos.x = tx
			//			 this.now_pos.y = ty
			//		 else
			//			 this.now_pos.x = nx + dir.x * delta
			//			 this.now_pos.y = ny + dir.y * delta
			//		 end
			//	 else
			//		 //跟踪行的需要依赖战斗返回 即使是没有受击方也要发送20001
			//		 this.TriggerDamage()
			//		 //目标不存在，直接终结子弹
			//		 return false
			//	 end
			// end
			//刷新特效
			if (this.particle_id)
				partical_mgr.SetEffectPos(this.particle_id, this.now_pos.x, this.now_pos.y);
			// if (this.damage_type == BulletObj.BulletDamageType.	 // {
			//	 if hitted then
			//		 if not this.no_damage then
			//			 //把追踪目标作为唯一目标塞入列表
			//			 this.targets_list = {}
			//			 if this.trace_hiter and not this.trace_hiter.IsDead() then
			//				 table.insert(this.targets_list, this.trace_hiter)
			//			 end	
			//			 //造成伤害 
			//			 this.TriggerDamage()
			//		 end
			//		 return false
			//	 end
			//造成伤害 
			// if (this.damage_type == BulletObj.BulletDamageType.OnTime)
			// {
			// if ((this.last_collide_time == null || total_time - this.last_collide_time >= this.delta_time) && !this.no_damage)
			// {
			//	 this.last_collide_time = total_time
			//	 this.FindTargets() //查找目标
			//	 this.TriggerDamage() //触发伤害 
			//	 if (this.targets_list.length > 0 && this.total_damage_count != null)
			//	 {
			//		 this.total_damage_count = this.total_damage_count - 1
			//		 if (this.total_damage_count <= 0)
			//			 return false
			//	 }
			// }
			// }
			// else if (this.damage_type == BulletObj.BulletDamageType.OnCollide)
			// {
			if ((this.last_collide_time == null || total_time - this.last_collide_time >= this.delta_time) && !this.no_damage && !this.has_trigger_damage) {
				this.last_collide_time = total_time;
				//找到周围目标
				if (this.FindTargets()) {
					//触发伤害 
					this.TriggerDamage();
				}
				else {
					this.has_trigger_damage = true;
				}
				//  if (this.targets_list.length > 0 && this.total_damage_count != null)
				//  {
				//	 this.total_damage_count = this.total_damage_count - 1
				// if (this.total_damage_count <= 0)
				// return false
				// this.has_trigger_damage = true
				//  }
			}
			// }
			if (total_time >= this.end_time) {
				// if this.move_type == BulletObj.BulletMoveType.Trace then
				//	 //跟踪行的需要依赖战斗返回 即使是没有受击方也要发送20001
				//	 this.TriggerDamage()
				//	 //目标不存在，直接终结子弹
				// end
				return false;
			}
			return true;
		};
		this.FindTargets = () => {
			if (this.attacker == null || this.attacker.vo == null || this.attacker.IsDead() || (this.left_role_num <= this.has_hited_role_num && this.left_mon_num <= this.has_hited_mon_num))
				return false;
			let find_area = this.skill_vo.GetArea();
			this.targets_list.length = 0;
			// let att_num = this.skill_vo.GetAttackNum()
			let center_pos = this.now_pos;
			if (local_GameMath.GetDistance(this.start_pos.x, this.start_pos.y, center_pos.x, center_pos.y, false) >= 250000) {
				return false;
			}
			if (this.is_first_damage) {
				this.is_first_damage = false;
				center_pos = null;
				find_area = 100;
			}
			else if (this.damage_offset_dist) {
				this.damage_pos.x = center_pos.x + this.move_dir.x * this.damage_offset_dist;
				this.damage_pos.y = center_pos.y + this.move_dir.y * this.damage_offset_dist;
				center_pos = this.damage_pos;
			}
			let monster_list, role_list;
			// find_area *= 0.5
			if (this.left_mon_num > 0) {
				monster_list = scene.FindTargets(FIND_TARGET_monster, this.left_mon_num, null, find_area, null, null, center_pos, this.attacker)[0];
			}
			if (this.left_role_num > 0) {
				role_list = scene.FindTargets(FIND_TARGET_role, this.left_role_num, null, find_area, null, null, center_pos, this.attacker)[0];
			}
			// att_num = left_mon_num + left_role_num
			// if (att_num > 0)
			// {
			// if this.select_type == 1 then
			// 	this.targets_list, role_list = Scene.Instance.FindTargets(Scene.FIND_TARGET_TYPE.all, att_num, null, find_area * 0.5, null, null, this.now_pos, this.attacker, null, null, null, true)
			// elseif this.select_type == 2 then
			// let distance = this.move_speed * (this.delta_time + 0.02)
			// let [monster_list, role_list] = Scene.Instance.FindTargets(Scene.FIND_TARGET_TYPE.all, att_num, null, find_area, this.move_dir, null, center_pos, this.attacker)
			// end
			if (monster_list) {
				//把旧列表缓存，然后进行筛选，把没打过的目标放进新列表
				for (let hiter of monster_list) {
					if (this.collide_list[hiter.id] == null && this.left_mon_num > this.has_hited_mon_num) {
						this.collide_list[hiter.id] = true;
						this.targets_list.push(hiter);
						this.has_hited_mon_num++;
					}
				}
			}
			if (role_list) {
				//把旧列表缓存，然后进行筛选，把没打过的目标放进新列表
				for (let hiter of role_list) {
					if (this.collide_list[hiter.id] == null && this.left_role_num > this.has_hited_role_num) {
						this.collide_list[hiter.id] = true;
						this.targets_list.push(hiter);
						this.has_hited_role_num++;
					}
				}
			}
			// }
			return true;
		};
		this.TriggerDamage = () => {
			if (this.no_damage)
				return;
			//如果没有受击者，跳出
			if (this.targets_list.length == 0) // && this.move_type != BulletObj.BulletMoveType.Trace)
				return;
			let msg_info = {
				attacker_id: this.attacker.id,
				monster_list: [],
				role_list: [],
				skill_id: this.skill_id,
				attack_x: this.now_pos.x,
				attack_y: this.now_pos.y,
				attack_angle: 0,
				move_anim: 0,
				ignore_damage_time: this.ignore_damage_time
			};
			let monster_list = [];
			let role_list = [];
			for (let hiter of this.targets_list) {
				if (hiter.GetType() == local_SceneBaseType.Monster || hiter.GetVo().is_fake_role) {
					msg_info.monster_list.push(hiter.id);
					monster_list.push(hiter);
				}
				else {
					msg_info.role_list.push(hiter.id);
					role_list.push(hiter);
				}
			}
			//技能
			local_GlobalEventSystem.Fire(local_FightEvent.ROLE_REQUEST_TOPREPLAYFIGHT, this.skill_id, monster_list, role_list, msg_info, this.attacker);
		};
	}
}

window["BulletObj"] = BulletObj