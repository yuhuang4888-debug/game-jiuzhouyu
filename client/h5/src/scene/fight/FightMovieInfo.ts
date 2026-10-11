import { SkillManager } from "../../skill/SkillManager";
import { SceneManager } from "../SceneManager";
import { ParticleManager } from "../../particalEffect/ParticleManager";
import { Scene } from "../Scene";
import { EffectResType, SceneBaseType } from "../SceneConfig";
import { GameError } from "../../util/GameError";
import { EarlyWarningManager } from "./EarlyWarningManager";
import { GameMath } from "../../util/GameMath";
import { SoundManager } from "../../common/SoundManager";
import { CameraManager } from "../CameraManager";
import { FightDamageManager, FightDamageFlag } from "./FightDamageManager";
import { FightManager } from "./FightManager";
import { SkillVo } from "../../skill/SkillVo";
import { Vector2 } from "../../util/Vector2";
import { Status } from "../../util/Status";
import { GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { FightEvent } from "./FightEvent";
import { SceneObj } from "../sceneobj/SceneObj";
import { PoseState } from "../../util/StateMachineManager";
import { EventName } from "../../common/EventName";
import { Config } from "../../common/Config";
import { Character } from "../sceneobj/Character";
import { GameResPath } from "../../util/GameResPath";
import { Vector3 } from "../../util/Vector3";
import { BaseClass, HashObject } from "../../common/BaseClass";
import { GameScriptModule } from "../../GameScriptModule";
import { Util } from "../../util/Util";
import { BaseWindowComponent } from "../../common/BaseWindowComponent";
import { RoleManager } from "../../commonModel/RoleManager";
import { SettingModel } from "../../commonModel/SettingModel";
// TypeScript file
let local_Vector2 = Vector2
let local_HashObject = HashObject
let local_GameMath = GameMath
let local_JSON = JSON
export class FightMovieInfo extends BaseClass {
	public show_particle;
	InitData;
	resetData;
	IsFinished;
	Update;
	PlayActions;
	setFightInfo;
	SendMsg;
	executeHitedAnimation;
	DefenderBeHited;
	PlayParticle;
	GetIsClientPreState
	public constructor() {
		super()
		let local_SkillManager = SkillManager.GetInstance(),
			local_SceneManager = SceneManager.GetInstance(),
			local_ParticleManager = ParticleManager.GetInstance(),
			local_Scene = Scene.GetInstance(),
			local_game_error = GameError.GetInstance(),
			early_warning_mgr = EarlyWarningManager.GetInstance(),
			// local_egret = egret, local_GameMath = GameMath,
			local_SoundManager = SoundManager.GetInstance(),
			local_CameraManager = CameraManager.GetInstance(),
			lcoal_FightDamageManager = FightDamageManager.GetInstance(),
			local_FightManager = FightManager.GetInstance(),
			start_time = null,
			attacker = null,
			attacker_vo = null,
			attacker_info = null,
			defender_list: Array<any> = null,
			defender_info_list: Array<any> = null,
			movie_cfg = null,
			skill_id = null,
			msg_info = null,
			skill_vo: SkillVo = null,
			is_main_role_attack = null,
			skill_damage_time = null,
			is_monster_attack = null,
			is_other_role_attack = null,
			is_client_pre_play = false, //not client_pre_play  		//只要不是预播，就要显示伤害
			show_damage = null,
			show_action = null,
			attack_pos_x = null,
			attack_pos_y = null,
			client_particles = [], //和受击目标无关的特效
			camera_infos: Array<any> = null, //和受击目标有关的特效
			camera_infos_id=0,
			is_finished = null,
			has_play_hited = false,
			rush_pos = null,
			attack_dir,
			main_sound_id,
			rigidity_time = null,
			is_partner_attack,
			is_main_role_partner_attack,
			cache_pos: Vector2,
			ignore_damage_time,
			attack_dir_num,
			main_roar_sound_id,
			is_god_skill
		this.GetIsClientPreState = () => {
			return is_client_pre_play
		}
		this.InitData = (skill_id1, _attacker, _attacker_info, _defender_list, _defender_info_list, _client_pre_play, _msg_info) => {
			start_time = Status.NowTime;
			attacker = _attacker;
			attacker_vo = attacker.vo;
			attacker_info = _attacker_info;
			defender_list = _defender_list ? _defender_list : [];
			defender_info_list = _defender_info_list ? _defender_info_list : [];
			movie_cfg = local_SkillManager.GetFightSkillMovie(skill_id1);
			skill_id = skill_id1;
			msg_info = _msg_info;
			skill_vo = local_SkillManager.getSkill(skill_id);
			if (skill_vo == null) {
				local_game_error.SendErrorToPHP("!!!!!!!!!!!!!!!!!!!!找不到后台技能id" + skill_id);
				is_finished = true
				return;
			}

			if (!movie_cfg) {
				local_game_error.SendErrorToPHP("!!!!!!!!!!!!!!!!!!!!找不到技能表现id" + skill_id)
				is_finished = true
				return
			}

			is_god_skill = skill_vo.getCarrer() == 38

			let scene_base_type = SceneBaseType;
			let attacker_type = attacker.GetType();

			is_main_role_attack = (attacker_type == scene_base_type.MainRole);
			is_monster_attack = (attacker_type == scene_base_type.Monster);
			is_partner_attack = (attacker_type == scene_base_type.Partner);
			is_other_role_attack = (attacker_type == scene_base_type.Role);
			if (is_partner_attack && !attacker.owner) {
				is_finished = true
				return
			}
			is_main_role_partner_attack = is_partner_attack && attacker.owner.GetType() == scene_base_type.MainRole

			skill_damage_time = movie_cfg.damage_time || 0; //配置的技能伤害时间
			let aoe_model = skill_vo.GetAoeMode();
			if (is_monster_attack && movie_cfg.pre_warn) {
				// local_local_console.log("FightMovieInfo pre_warn skill_id =========:", skill_id, Status.NowTime)
				if (movie_cfg.delete_pre_warn) { //需删掉技能预警（前摇）
					early_warning_mgr.StopWarning(attacker.id, aoe_model, movie_cfg.after_delete_pre_warn_time || 0);
				}
				else {
					let combo = skill_vo.GetComboSkillBySkillId(skill_id);
					if (combo) {
						if (aoe_model == 1) { //圆形
							early_warning_mgr.ShowWarning(attacker.id, aoe_model, skill_vo.GetArea(), combo.time, attacker.GetRealPos(), undefined, undefined, movie_cfg.show_count_down);
						}
						else if (aoe_model == 2 || aoe_model == 3 || aoe_model == 4) { //直线, 扇形， 十字星
							let pos = new local_Vector2(attacker_info.attack_pos_x, attacker_info.attack_pos_y);
							early_warning_mgr.ShowWarning(attacker.id, aoe_model, skill_vo.GetArea(), combo.time, pos, skill_vo.GetDistance(), attacker_info.attack_angle, movie_cfg.show_count_down);
						}
					}
				}
			}

			is_client_pre_play = _client_pre_play;
			show_damage = !_client_pre_play; //只要不是预播，就要显示伤害
			has_play_hited = is_client_pre_play;


			let main_show_action = false;

			let is_main_attack = is_main_role_attack || is_main_role_partner_attack
			if (is_main_attack
				&& (
					(_client_pre_play && skill_vo.GetBroadcast() == 0)
					|| (!_client_pre_play && skill_vo.GetBroadcast() == 1)
					|| RoleManager.GetInstance().GetMainRoleDepositState()
				)){
					main_show_action = true;
				}

			show_action = main_show_action || !is_main_attack; //主角预播/主角托管，或其他单位进行的攻击，都要显示动作、特效


			this.show_particle = show_action && !attacker.HasModelHideFlag(SceneObj.ModelHideFlag.Skill) && !attacker.HasModelHideFlag(SceneObj.ModelHideFlag.RoleNumLimit)

			//僵直时长
			rigidity_time = (movie_cfg.pre_swing || 0)
				+ (movie_cfg.spell_time || 0)
				+ (movie_cfg.back_swing || 0);

			if (is_main_attack) {
				ignore_damage_time = true
				if (rigidity_time > 0) {
					if (_client_pre_play || RoleManager.GetInstance().GetMainRoleDepositState()) {
						if (is_main_role_attack)
							local_SkillManager.SetSkillRigidity(rigidity_time);
						else if (is_main_role_partner_attack) {
							local_SkillManager.SetPartnerSkillRigidity(rigidity_time);
						}
						local_SkillManager.ResetSkill(skill_id) //预播技能的时候就设置cd
					}
					else if (show_damage)
						if (is_main_role_attack)
							local_SkillManager.SetSkillRigidity(rigidity_time);
						else if (is_main_role_partner_attack) {
							local_SkillManager.SetPartnerSkillRigidity(rigidity_time);
						}
				}
				else if (_client_pre_play || RoleManager.GetInstance().GetMainRoleDepositState()) {
					local_SkillManager.ResetSkill(skill_id);
				}
			}

			if (movie_cfg.particles && this.show_particle && attacker_vo) {
				for (let i = 0; i < movie_cfg.particles.length; i++) {
					client_particles.push(movie_cfg.particles[i]);
				}
			}
			//只有主角攻击可以有镜头参数
			if (is_main_role_attack && movie_cfg.camera_infos && this.show_particle 
				&& show_action && (!movie_cfg.shake_screen_need_hiter || defender_list.length > 0)
				&& SettingModel.GetInstance().GetShockScreenFlag() != 1) {
				camera_infos = local_JSON.parse(local_JSON.stringify(movie_cfg.camera_infos))
				camera_infos_id = local_HashObject.CreateHashcode()
			}

			//是否已经播放结束
			is_finished = false;
			let pos_x = attacker_info.pos_x;
			let pos_y = attacker_info.pos_y;
			attack_pos_x = attacker_info.attack_pos_x;
			attack_pos_y = attacker_info.attack_pos_y;
			let mx = attacker.x;
			let my = attacker.y;

			//处理攻击时的位移
			if (attacker_info.move_anim && attacker_info.move_anim > 0 ||
				(!is_main_role_attack && !is_partner_attack && pos_x && pos_y && local_GameMath.GetDistance(mx, my, pos_x, pos_y) > 2500))
				rush_pos = { x: pos_x, y: pos_y }

			let n = defender_info_list.length;
			if (n > 0) {
				let tx = 0, ty = 0, defender, dx, dy;
				for (let i = 0; i < n; i++) {
					defender = defender_list[i];
					dx = defender.x;
					dy = defender.y;
					tx = tx + dx;
					ty = ty + dy;
					//计算机受攻击效果的方向，在后面受击动作和死亡动作都要用上
					let defender_info = defender_info_list[i]
					let new_x = defender_info.pos_x
					let new_y = defender_info.pos_y
					if (defender_info.move_anim && defender_info.move_anim > 0) //or (new_x and new_y and local_GameMath.GetDistance(dx, dy, new_x, new_y) > 2500) then
						defender_info.new_pos = { x: new_x, y: new_y }
				}
				tx = tx / n;
				ty = ty / n;
				// tar_pos = co_TableXY(tx, ty)
				attack_dir = attack_dir || new local_Vector2();
				attack_dir.x = tx - mx;
				attack_dir.y = ty - my;
				attack_dir.normalise();
			}

			if (!is_main_attack || RoleManager.GetInstance().GetMainRoleDepositState()) {
				if (movie_cfg.pre_warn && (aoe_model == 2 || aoe_model == 3 || aoe_model == 4)) {
					attacker.SetRotateY(attacker_info.attack_angle, null, true)
					let dir = attacker.GetDirection()
					attack_dir = attack_dir || new local_Vector2();
					attack_dir.x = dir.x
					attack_dir.y = dir.y
				} else if (attack_dir && (attack_dir.x != 0 || attack_dir.y != 0)) {
					attack_dir_num = attacker.SetDirection(attack_dir);
				} else if (attacker_info.attack_angle) {
					attacker.SetRotateY(attacker_info.attack_angle, null, true)
				}
			}
		};
		this.DeleteMe = () =>{
			if(camera_infos_id && camera_infos && camera_infos.length > 0){
			}
			super.DeleteMe()
		}
		this.resetData = () => {
			start_time = null; //null
			attacker = null; //attacker
			attacker_vo = null; //1
			attacker_info = null; //attacker_info
			defender_list = null; //defender_list
			defender_info_list = null; //defender_info_list
			movie_cfg = null; //local_SkillManager.GetFightSkillMovie(skill_id)
			skill_id = null; //skill_id
			msg_info = null; //msg_info
			skill_vo = null; //1
			is_main_role_attack = null; //(attacker_type == SceneBaseType.MainRole)
			skill_damage_time = null; //1
			is_monster_attack = null; //1
			is_other_role_attack = null; //1
			is_main_role_partner_attack = null
			is_client_pre_play = false; //client_pre_play
			show_damage = null; //not client_pre_play  		//只要不是预播，就要显示伤害
			show_action = null; //true
			attack_pos_x = null; //true
			attack_pos_y = null; //true
			this.show_particle = null; //true
			client_particles.length = 0; //{} 	//和受击目标无关的特效
			is_finished = null; //false
			has_play_hited = false; //false
			rush_pos = false; //false
			attack_dir_num = null; //1
			// tar_dir = null//1
			// tar_pos = null//1
			main_sound_id = false;
			rigidity_time = null;
			main_roar_sound_id = false;
			ignore_damage_time = false
			attack_dir = null

			if(camera_infos_id && camera_infos && camera_infos.length > 0){
			}

			camera_infos = null
			camera_infos_id = null
		};
		this.IsFinished = () => {
			return is_finished;
		};
		this.Update = (now_time) => {
			if (is_finished)
				return;
			let past_time = now_time - start_time;

			if (show_damage && !has_play_hited) {
				//客户端主动发起的要忽略
				if (ignore_damage_time) {
					this.DefenderBeHited()
					has_play_hited = true
				}
				else {
					if (past_time >= skill_damage_time) {
						has_play_hited = true
						this.DefenderBeHited()
					}
				}
			}

			if (is_client_pre_play && msg_info && past_time >= skill_damage_time) {
				// console.warn("FightMovieInfo@Update", this.hashCode, skill_id)
				this.SendMsg();
				msg_info = null
			}

			let cfg = movie_cfg;
			if (show_action) {
				let sound_disabled = !local_SceneManager.CheckSceneFightSoundAvaliable() && !is_main_role_attack;
				let sound_finish = (sound_disabled || cfg.sound_res == null || main_sound_id || !this.show_particle);
				if (!sound_finish && (!cfg.sound_need_hiter || (defender_list && defender_list.length > 0)) && (cfg.sound_start_time == null || past_time >= cfg.sound_start_time)) {
					// let loop = (cfg.sound_time != null && cfg.sound_time > 0)
					let sound_id = local_SoundManager.PlaySoundEffect(cfg.sound_res, true, null, "skill");
					main_sound_id = sound_id;
					// sound_finish = true
					// if (loop){
					// let stop_func = function ()
					//	 lua_soundM:StopEffect( LuaSoundManager.SOUND_TYPE.SKILL, sound_id)
					// end
					// TimerQuest.AddDelayQuest(GlobalTimerQuest, stop_func, cfg.sound_time)
					// }
				}
				// let roar_sound_finish = (sound_disabled or cfg.roar_sound_list == null or main_roar_sound_id or not this.show_particle)
				// if not roar_sound_finish and (cfg.roar_sound_start_time == null or past_time >= cfg.roar_sound_start_time) then
				//	 let roar_cfg = cfg.roar_sound_list[math.random(1, #cfg.roar_sound_list)]
				//	 math.randomseed(os.time())
				//	 let random_value = math.random(1, 100)
				//	 if roar_cfg.probability >= random_value then
				//		 main_roar_sound_id = lua_soundM:PlayEffect( roar_cfg.res, false, LuaSoundManager.SOUND_TYPE.SKILL)
				//	 end
				//	 roar_sound_finish = true
				// end
				if (camera_infos && camera_infos.length > 0) {
					let vo, camera_mgr = local_CameraManager, delete_list;
					for (let i = 0; i < camera_infos.length; i++ ) {
						vo = camera_infos[i];
						if (!vo.start_time || past_time >= vo.start_time) {
							camera_mgr.ShakeCamera(vo, camera_infos_id, attacker);
							delete_list = delete_list || []
							delete_list.push(i)
						}
					}
					if(delete_list)
					{
						for (let j = delete_list.length - 1; j >= 0; j--) {
							camera_infos.splice(delete_list[j], 1);
						}
					}
				}

				let vo;
				for (let i = client_particles.length - 1; i >= 0; i--) {
					vo = client_particles[i];
					if (vo.start_time == null || past_time >= vo.start_time) {
						this.PlayParticle(vo);
						client_particles.splice(i, 1);
					}
				}

				if ((!camera_infos || camera_infos.length == 0) 
					&&(!client_particles || client_particles.length == 0) 
					&& !msg_info
					&& (is_client_pre_play || has_play_hited)) {
					is_finished = true;
				}
			}
			else {
				if (has_play_hited && !msg_info) {
					is_finished = true;
				}
			}
		};
		this.PlayActions = () => {
			let self = this;
			let cfg = movie_cfg;
			// let attacker = attacker
			if (show_damage)
				this.setFightInfo();
			if (show_action && rigidity_time > 0) {
				// let rush = null
				// if (rush_pos)
				// {
				//	 rush = {
				//	 rush_start_time 	= cfg.rush_start_time or 0.1,
				//	 rush_end_time 		= cfg.rush_end_time or 0.5,
				//	 rush_pos 			= rush_pos,
				//	 ignore_block 		= cfg.ignore_block}
				// }
				// let atr = attacker.GetDirectionNumber()
				// let dir = null// attack_dir_num || atr
				return attacker.DoAttack(null, cfg, null, skill_id, attacker_info.is_mainRole_defender, defender_list);
				// if is_client_pre_play and is_main_role_attack and msg_info and msg_info.role_list and #msg_info.role_list > 0 then
				//	 attacker:EnterFightState()
				// end
			}
		};
		this.setFightInfo = () => {
			// let attacker_info = attacker_info
			if (attacker_info.hp && attacker_vo) {
				// if (attacker && attacker.GetType() != SceneBaseType.Sprite && attacker.GetType() != SceneBaseType.Partner) {
				//	 let hp_off = attacker_info.hp - attacker_vo.hp
				// if (hp_off > 0)  //处理攻击者减血票伤害
				// lcoal_FightDamageManager.ShowAddHp(hp_off, attacker)
				// else if (hp_off < 0)
				// lcoal_FightDamageManager.ShowDamage(0, -hp_off, attacker,attacker)
				// }
				//好友助战时是打不死的
				// if (attacker.GetType() == SceneBaseType.Role && attacker_vo.is_virtual_role && attacker_info.hp <= 0)
				//	 attacker_info.hp = attacker_vo.maxHp
				//处理死亡(对象死亡)
				if (attacker_info.hp <= 0)
					attacker.ForceDoDead();
				attacker_vo.ChangeVar("hp", attacker_info.hp);
			}
			if (attacker_info.buff_list)
				attacker.SetBuffList(attacker_info.buff_list);
			if (attacker_info.mainRole_add_hp) {
				let addHpValue = local_Scene.GetMainRole().GetVo().hp + attacker_info.mainRole_add_hp;
				addHpValue = addHpValue > local_Scene.GetMainRole().GetVo().maxHp ? local_Scene.GetMainRole().GetVo().maxHp : addHpValue;
				local_Scene.GetMainRole().GetVo().ChangeVar("hp", addHpValue);
			}
			//第一时间刷新VO
			let defender_info, obj_vo, i = 0;
			for (let defender of defender_list) {
				defender_info = defender_info_list[i];
				obj_vo = defender.GetVo();
				if (!defender.IsDead() && obj_vo) //没有指定更新哪个受击者的时候全部更新vo 指定了的话就只更新指定的受击者vo
				{
					if (defender_info.buff_list)
						defender.SetBuffList(defender_info.buff_list, defender_info.breaked_skill_id);
					//刷新vo
					if (defender_info.hp != null) {
						//好友助战时是打不死的
						// if (defender.GetType() == SceneBaseType.Role && obj_vo.is_virtual_role && defender_info.hp <= 0)
						//	 defender_info.hp = obj_vo.maxHp
						obj_vo.ChangeVar("hp", defender_info.hp, true);
						if (defender_info.hp == 0) {
							let dir = new local_Vector2(defender.real_pos.x - attacker.real_pos.x, defender.real_pos.y - attacker.real_pos.y)
							dir.normalise()
							defender.DoDead(dir, attacker);
						}
					}
				}
				i++;
			}
		};
		this.SendMsg = () => {
			GlobalEventSystem.Fire(FightEvent.ROLE_REQUEST_TOFIGHT, msg_info);
			msg_info = null;
		};
		//执行每一个受击者的受击动作
		this.executeHitedAnimation = (defender: Character, defender_info, attacker, skill_id) => {
			if (defender != attacker && defender.vo) {
				let duo_bi_flag = FightDamageFlag.ShanBi,
					has_call_beAttacked = false,
					movie_cfg = local_SkillManager.GetFightSkillMovie(skill_id),
					x = defender.real_pos.x,
					y = defender.real_pos.y,
					//如果位移较大，就强制进入受击状态
					force_hited = movie_cfg.force_hited;

				if (defender_info.new_pos && local_GameMath.GetDistance(x, y, defender_info.new_pos.x, defender_info.new_pos.y, false) > 1500)
					force_hited = true;
				if (force_hited || (defender_info.damage && defender_info.damage > 0)
					|| (defender_info.damage_flag && defender_info.damage_flag == duo_bi_flag)
					|| (movie_cfg && movie_cfg.isSuckSkill)) {
					//如果受击者是主角并且躲避了伤害，就不显示受击动作
					if (movie_cfg && movie_cfg.no_behitted == null) {
						has_call_beAttacked = true;
						defender.DoBeAttacked(defender_info.attacked_dir, defender_info.new_pos, force_hited, movie_cfg, attacker, skill_id);
					}
				}
				if (has_call_beAttacked == false && defender.vo.hp == 0 && !defender.IsInState(PoseState.HITED))
					defender.SetLandInfo();
				// if (!defender.HasModelHideFlag(SceneObj.ModelHideFlag.OutScreen)) {
				lcoal_FightDamageManager.ShowFont(defender_info.damage_flag, defender_info.damage, attacker, defender);
				// }
			}
		};
		//播放受击方受击动作
		this.DefenderBeHited = () => {
			let main_role_type = SceneBaseType.MainRole, defender_info = null, self = this, i = 0;
			for (let defender of defender_list) {
				defender_info = defender_info_list[i];
				//竞技场 假人伤害飘字特殊处理
				if (defender.GetType() == main_role_type || is_main_role_attack || is_main_role_partner_attack) {
					this.executeHitedAnimation(defender, defender_info, attacker, skill_id);
					if (defender_info.damage_flag == FightDamageFlag.BaoJi && attacker.GetType() == SceneBaseType.MainRole) {
						GlobalEventSystem.Fire(EventName.SHOW_BAOJI_ANI, defender_info);
					}
				}
				else
					local_FightManager.appendHiterInfo(self, defender, defender_info, attacker, skill_id);
				i++;
			}
		};
		this.PlayParticle = (cfg) => {
			// let attacker = attacker
			let scene_base_type = SceneBaseType;
			// if (attacker.GetType() == scene_base_type.Role) return //测试用

			//后台时不添加技能特效
			if (GameScriptModule.GetInstance().game_run_state == "pause") return

			if (!Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) return

			//不是主角的跟随者不加特效
			if (attacker.owner && attacker.owner.GetType() != scene_base_type.MainRole)
				return;

			if (!is_main_role_attack && skill_vo.IsAngerSkill())
				return;

			if (cfg.career && attacker_vo && cfg.career != attacker_vo.career)
				return;

			if (attacker.GetType() == scene_base_type.Role && !local_SceneManager.IsArenaFightScene()) //&& attacker.HasBlockSetting("skill_effect")
				return;

			let attacker_dir = attack_dir
			if (attacker_dir == null) {
				let atr = attacker.GetDirection()
				attacker_dir = new local_Vector2(atr.x, atr.y)
				// console.warn("------PlayParticle@attacker_dir------", attacker_dir)
			}
			let res = cfg.res
			let dir = null
			let scale = cfg.scale

			if (cfg.dir_type) {
				if (cfg.dir_type == 1)
					dir = attacker_dir;
				else if (cfg.dir_type == 2) {
					if (rush_pos) {
						let now_real_pos = attacker.GetRealPos()
						let tmp_dir = new local_Vector2(rush_pos.x - now_real_pos.x, rush_pos.y - now_real_pos.y)
						let l = tmp_dir.normalise()
						if (l <= 10)
							dir = attacker_dir
						else
							dir = tmp_dir
					}
					else
						dir = attacker_dir

				}
			}



			let play_time = cfg.play_time_len || 0,
				n = defender_list.length,
				pos_type = cfg.pos_type,
				attacker_compress_id = attacker.compress_id,
				attach_type = cfg.attach_type || 7,
				max_depth = cfg.max_depth,
				particle_speed = cfg.particle_speed,
				particle_priority = 3,
				particle_id_list = [],
				effect_res_type = EffectResType.Skill


			// if(is_main_role_attack || is_other_role_attack){
			if (play_time == 0) {
				play_time = 3
			}
			// }
			// play_time = Math.min(play_time, 10);
			// particle_priority 优先级为：null或1：可添加， 2：特效总量少于上限的60%时可添加， 3：特效总量少于上限30%可添加
			if (pos_type == 13)
				pos_type = (n > 0) ? 3 : 2;

			if (is_partner_attack) {
				attacker_compress_id = null;
				particle_priority = 1;
			}
			else {
				particle_priority = attacker_vo.particle_priority;
			}

			let loop = cfg.loop;
			let defender;
			let end_pos;
			let target_pos
			switch (pos_type) {
				case 0: //在攻击者身上
					if (local_SceneManager.IsSeaHegemonyScene()) {
						effect_res_type = EffectResType.Other
					}
					particle_id_list.push(local_ParticleManager.AddTargetEffect(cfg.res, attacker.compress_id, loop, play_time, null, attach_type, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))

					//十字类型的技能 要显示4个方向的特效
					if(skill_vo.GetAoeMode() == 4){
						particle_id_list.push(local_ParticleManager.AddTargetEffect(cfg.res, attacker.compress_id, loop, play_time, { x:-1, y:0}, attach_type, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))
						particle_id_list.push(local_ParticleManager.AddTargetEffect(cfg.res, attacker.compress_id, loop, play_time, { x:0, y:-1}, attach_type, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))
						particle_id_list.push(local_ParticleManager.AddTargetEffect(cfg.res, attacker.compress_id, loop, play_time, { x:0, y:1}, attach_type, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))
					}
					break;
				case 1: // //在每个受击者身上
					let defender_dir;
					for (let i = 0; i < n; i++) {
						defender = defender_list[i];
						defender_dir = defender.GetDirection();
						if (defender.vo) {
							particle_id_list.push(local_ParticleManager.AddTargetEffect(cfg.res, defender.compress_id, loop, play_time, null, attach_type, null, null, defender.vo.particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))
						}
					}
					break;
				case 2: //在攻击者坐标上
					let now_real_pos = attacker.GetRealPos()
					target_pos = new local_Vector2();
					target_pos.x = now_real_pos.x;
					target_pos.y = now_real_pos.y;
					if (cfg.offset_dist && cfg.offset_dist != 0 && dir) {

						let dist = local_GameMath.ChangeEllipseValue(dir, cfg.offset_dist)
						target_pos.x += dir.x * dist
						target_pos.y += dir.y * dist
					}
					particle_id_list.push(local_ParticleManager.AddPosEffect(cfg.res, target_pos, loop, play_time, dir, null, null, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))

					break;
				case 3: //在每个受击者坐标分别创建
					for (let i = 0; i < n; i++) {
						defender = defender_list[i];
						end_pos = defender.GetRealPos();
						target_pos = new local_Vector2();
						target_pos.x = end_pos.x;
						target_pos.y = end_pos.y;
						particle_id_list.push(local_ParticleManager.AddPosEffect(cfg.res, target_pos, loop, play_time, dir, null, null, null, null, particle_priority, cfg.max_depth, null, particle_speed, null, null, effect_res_type))
					}
					break;
				case 4: //在所有受击者的中心坐标创建
					if (n == 0) {
						return
					}
					let x = 0, y = 0
					for (let i = 0; i < n; i++) {
						defender = defender_list[i];
						end_pos = defender.GetRealPos();
						x += end_pos.x
						y += end_pos.y
					}

					x = x / n
					y = y / n

					target_pos = new local_Vector2();
					target_pos.x = x
					target_pos.y = y

					particle_id_list.push(local_ParticleManager.AddPosEffect(cfg.res, target_pos, loop, play_time, dir, null, null, null, null, particle_priority, cfg.max_depth, null, particle_speed, null, null, effect_res_type))
					break;
				case 6: //在攻击点上
					target_pos = new local_Vector2();
					target_pos.x = attack_pos_x;
					target_pos.y = attack_pos_y;
					particle_id_list.push(local_ParticleManager.AddPosEffect(cfg.res, target_pos, loop, play_time, dir, null, null, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))
					break;
				case 12: //受击者中心
					if (defender_list) {
						let defender;
						let pos;
						let target_pos;
						for (let i = 0; i < n; i++) {
							defender = defender_list[i];
							pos = defender.GetRealPos();
							target_pos = new local_Vector2();
							target_pos.x = pos.x;
							target_pos.y = pos.y;
							particle_id_list.push(local_ParticleManager.AddPosEffect(cfg.res, target_pos, loop, play_time, dir, false, null, null, null, particle_priority, max_depth, null, particle_speed, null, null, effect_res_type))
						}
					}
					break;
				default:
					return;
			}
			if (scale && scale != 1 && particle_id_list.length > 0) {
				for (let i in particle_id_list) {
					local_ParticleManager.SetEffectScale(particle_id_list[i], scale)
				}
			}
		};
	}
}

window["FightMovieInfo"] = FightMovieInfo