import { SceneObj } from "./SceneObj";
import { Scene } from "../Scene";
import { EffectResType, MonsterType, SceneBaseType } from "../SceneConfig";
import { SceneManager } from "../SceneManager";
import { EventName, ObjectEventType, SceneEventType } from "../../common/EventName";
import { GlobalEventSystem } from "../../util/DeclareGlobalVar";
import { ParticleManager } from "../../particalEffect/ParticleManager";
import { Status } from "../../util/Status";
import { Config } from "../../common/Config";
import { ResManager } from "../../common/ResManager";
import { LayerManager } from "../../common/LayerManager";
import { PoseState } from "../../util/StateMachineManager";
import { GameMath } from "../../util/GameMath";
import { TimeUtil } from "../../util/TimeUtil";
import { ErlangParser } from "../../util/ErlangParser";
import { Vector2 } from "../../util/Vector2";
import { DropVo } from "../../sharedata/DropVo";
import { Character } from "./Character";
import { RoleManager } from "../../commonModel/RoleManager";
import { ColorUtil } from "../../util/ColorUtil";
import { Vector3 } from "../../util/Vector3";
import { GlobalTimerQuest } from "../../util/Util";
import { HolyBattleModel } from "../../commonModel/HolyBattleModel";
import { BanquetModel } from "../../commonModel/BanquetModel";
import { FightController } from "../fight/FightController";
let local_PoseState = PoseState
let local_SceneBaseType = SceneBaseType
let local_SceneObj = SceneObj
let local_EventName = EventName
let local_Character = Character
let Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Status = Status
let local_Vector2 = Vector2
let local_GlobalEventSystem = GlobalEventSystem
let local_ObjectEventType = ObjectEventType
let local_MonsterType = MonsterType
export class Monster extends Character {
	last_hited_time
	dead_start_time
	assign_angle
	is_dead
	collect_timer
	s_hited_info
	dead_end_pos
	foot_effect_id
	has_dispatchDead_event
	dead_body_id
	birth_effect_id
	canatk_effect_id
	dead_dir
	is_boss

	public constructor() {
		super()

		this._type = local_SceneBaseType.Monster

		this.dead_dir = false
		this.foot_effect_id = false
		this.birth_effect_id = false
		this.last_hited_time = false
		this.has_dispatchDead_event = false
		this.is_boss = false

	}

	public Update(now_time?, elapse_time?) {

		if (this.last_hited_time && now_time - this.last_hited_time >= 5) {
			if (this.IsHideNameBorad() && !this.IsMarriageTable()) {
				this.SetHideNameBord(true)
			}
			this.last_hited_time = false
		}
		super.Update(now_time, elapse_time)
	}

	public DeleteMe() {
		this.CancelTalkTime()
		super.DeleteMe()
	}

	public InitMonsterVo(vo?) {

		this.vo = vo
		this.id = vo.instance_id

		this.name = this.vo.name
		this.assign_angle = this.vo.assign_angle || -1
		this.compress_id = Scene.GetInstance().CompressObjId(local_SceneBaseType.Monster, this.id)
		this.is_boss = this.IsBoss()
		//怪物不可拣选 如果在自身圣域 不可攻击
		let can_pick = (this.vo.can_pick == 1)// && (! HolyTerritoryModel.GetInstance().SelfHT)
		this.SetPickInfo(can_pick)

		//主线副本怪物
		if (this.vo && this.vo.type_id == window["AutoBrushModel"].AutoBrushMonsterId) {
			this.InitAutoBrushMoster()
		}


		if (this.IsHideNameBorad()) {
			//餐桌显示可食用特效
			if (this.IsMarriageTable()) {
				this.SetHideNameBord(false)
				if (this.name_board) {
					this.name_board.SetTitleEff("UI_1804", { x: 0, y: -3 })
				}
				this.SetHpState()

			} else {
				this.SetHideNameBord(true)
			}

		} else {
			this.SetHideNameBord(false)
			this.SetHpState()
			//必须放在上面语句下面
			if (this.name_board) {
				this.name_board.SetHp(this.vo.hp, this.vo.maxHp)
			}
			this.UpdateName()
		}




		this.SetRealPos(this.vo.pos_x, this.vo.pos_y, true)
		this.SetScale(this.vo.icon_scale)

		if (this.vo.hide_flag == 1) {
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, true)
		}

		if (this.vo.cfg_data && this.vo.cfg_data.figure_visible == 0) { //根据配置隐身
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, true)
		}

		let res_change_func = (oldVar1?, value?) => {
			this.CreateClotheSprite(this.vo.monster_res)
		}

		let scale_change_func = (oldVar1?, value?) => {
			let scale = this.vo.icon_scale || 1.0
			this.SetScale(scale)
		}

		let move_speed_change_func = (oldVar1?, value?) => {
			this.SetMoveSpeed(value)
		}
		let name_change_func = (oldVar1?, value?) => {
			this.UpdateName()
		}
		let hp_change_func = (oldVar1?, value?) => {
			if (!this.vo) { return }
			let hp = this.vo.hp
			let max_hp = this.vo.maxHp
			let p = hp / max_hp

			//刷新头顶血条
			if (this.name_board) {
				this.name_board.SetHp(hp, max_hp)
			}

			local_GlobalEventSystem.Fire(local_EventName.REFRESH_MONSTER_HP, this.vo.instance_id, this.vo)
		}
		let show_model_change_func = (oldVar1?, value?) => {
			this.SetModelHideFlag(local_SceneObj.ModelHideFlag.ServerHide, (value == 1))
		}
		var can_pick_change_func = () => {
			this.SetPickInfo(this.vo.can_pick == 1)
		}

		var can_attack_change_func = () => {
			this.SetHpState()
			this.UpdateName()
			this.OnCanAttackChange()
		}

		var next_collect_time_change = () => {
			this.CheckCollectTime()
		}

		this.vo.BindOne("monster_res", res_change_func)
		this.vo.BindOne("move_speed", move_speed_change_func)
		this.vo.BindOne("name", name_change_func)
		this.vo.BindOne("level", name_change_func)
		this.vo.BindOne("hp", hp_change_func)
		this.vo.BindOne("icon_scale", scale_change_func)
		this.vo.BindOne("hide_flag", show_model_change_func)
		this.vo.BindOne("can_pick", can_pick_change_func)
		this.vo.BindOne("can_attack", can_attack_change_func)
		this.vo.BindOne("next_collect_time", next_collect_time_change)

		this.CreatTalkTimer()
	}

	public CancelCollectTime() {
		if (this.collect_timer) {
			GlobalTimerQuest.CancelQuest(this.collect_timer)
			this.collect_timer = null
		}
	}

	public LoadClotheResComplete() {
		if (this.vo.cfg_data.boss >= FightController.SHOW_HP_BOSS_TYPE) {
			this.res_size.y += 50
			this.model_res_size.y += 50
		}

		super.LoadClotheResComplete()
		if (this.vo.foot_effect_res && this.vo.foot_effect_res != "") {
			if (!this.foot_effect_id) {
				this.foot_effect_id = this.particle_mgr.AddTargetEffect(this.vo.foot_effect_res, this.compress_id, true, 99999, null, 15, null, null, this.vo && this.vo.particle_priority || null, null, null, null, null, null, EffectResType.Monster)
			}
		}
		if (this.vo.birth_effect_res && this.vo.birth_effect_res != "0" && this.vo.birth_effect_res != "") {
			if (!this.birth_effect_id) {
				this.birth_effect_id = this.particle_mgr.AddTargetEffect(this.vo.birth_effect_res, this.compress_id, true, 99999, null, 7, null, null, this.vo && this.vo.particle_priority || null, null, null, null, null, null, EffectResType.Monster)
			}
		}
		this.SetRotate()
		this.OnPropertyChange()
	}

	public OnPropertyChange() {

		this.OnCanAttackChange()
		this.CheckCollectTime()
	}

	public CanCollect() {

		return this.vo.next_collect_time - TimeUtil.getServerTime() < 0
	}

	public CheckCollectTime() {

		if (!this.vo) {
			return
		}
		let next_collect_time = this.vo.next_collect_time
		let now_time = TimeUtil.getServerTime()
		if (next_collect_time > 0 && next_collect_time - now_time > 0) {
			if (this.name_board) {
				this.CancelCollectTime()
				let time = null
				this.collect_timer = GlobalTimerQuest.AddPeriodQuest(() => {
					if (this.name_board) {
						time = next_collect_time - TimeUtil.getServerTime()
						if (time > 0) {
							// text = TimeUtil.timeConversion(time, "MM-ss")
							// this.name_board.SetCollectText("冷却中: " + text)
							this.name_board.SetCollectText(`冷却中: ${time}s`)
						} else {
							this.CancelCollectTime()
							if (this.name_board) {
								this.name_board.SetCollectText(null)
							}
						}
					}
				}, 1, -1)
			}
		} else {
			if (this.name_board) {
				this.name_board.SetCollectText(null)
			}
		}
	}

	//设置自定义角度
	public SetRotate() {

		if (this.assign_angle && this.assign_angle != -1) {
			this.SetRotateY(this.assign_angle)
			return
		}

	}

	//血条状态
	public SetHpState() {

		if (this.vo) {
			let show = !this.vo.is_hide_hp
			if (this.vo.type == local_MonsterType.TASK_COLLECT || this.vo.type == local_MonsterType.COLLECT
				|| this.vo.type == local_MonsterType.INFINITE_COLLECT || this.vo.type == local_MonsterType.HAVE_COUNT_NOT_DEAD_COLLECT
				|| this.vo.type == local_MonsterType.NOT_DEAD_COLLECT) {
				show = false
			} else if (this.vo.type == local_MonsterType.PRICE && this.vo.can_attack == 0) {
				show = false
			}
			if (this.name_board) {
				this.name_board.SetHpVisible(show)
			}
		}
	}

	public UpdateName(name="") {

		//if (this.IsHideNameBorad() ) {
		//return
		//}
		if (this.vo && this.name_board) {

			if (this.scene_mgr.IsCanAttackByMainRole(this.vo, true, false, false)) {
				this.name_board.SetRedBar()
			} else {
				this.name_board.SetGreenBar()
			}
			if (this.IsHideNameBorad()) {
				this.name_board.SetName(name)
			} else {
				let monster_name = this.vo.name
				let name_color
				//如果在结社战场, 显示占领方
				if (this.scene_mgr.IsHolyBattleFightScene()) {
					//尊神战场
					let name_state = this.vo.warGroup == 0 && "中立" || HolyBattleModel.GroupName[this.vo.warGroup - 1]
					monster_name = monster_name + " 【" + name_state + "】"
				}

				this.name_board.SetName(monster_name, name_color)
			}
		}
	}

	//是否需要隐藏nameborad
	//被选择的目标才需要显示
	public IsHideNameBorad() {
		return this.vo.is_hide_hp || this.IsMonster() //and ! this.scene_mgr.IsConvoyScene()
	}

	/**是否是婚宴的餐桌 */
	public IsMarriageTable() {
		return BanquetModel.GetInstance().IsTable(this.vo.type_id)
	}

	public LoadInfoFromVo() {
		this.SetMoveSpeed(this.vo.move_speed)
		this.SetRealPos(this.vo.pos_x, this.vo.pos_y, true)
		if (this.vo.hp == 0) {
			this.DoDead()
		} else {
			this.DoStand()
		}
		this.MonsterClothChange()
	}

	public MonsterClothChange() {
		if (!this.vo) {
			return
		}
		let create_clothes = true
		if (create_clothes) {
			this.CreateClotheSprite(this.vo.monster_res)
		}
	}

	public DoAttack(dir_vec?, movie_cfg?, rush_cfg?, attack_skill_id?, is_mainRole_defender?) {

		if (is_mainRole_defender) {
			this.last_hited_time = local_Status.NowTime
		}

		return super.DoAttack(dir_vec, movie_cfg, rush_cfg, attack_skill_id)
	}

	public EnterStateAttack(state_name?) {

		super.EnterStateAttack(state_name)

		let cfg = this.movie_cfg
		let anim_name = ""
		if (cfg && cfg.anim) {
			anim_name = cfg.anim
		} else {
			anim_name = "attack"
		}
		let force_dir = null
		this.PlayAction(anim_name, force_dir)
	}

	public QuitStateAttack(state_name?) {

		if (!this.vo) {
			return
		}
		super.QuitStateAttack(state_name)
	}


	public DoBeAttacked(dir?, pos?, force_hited?, movie_cfg?, attacker?, skill_id?) {

		let update_name = false
		if (this.hide_nameboard) {
			update_name = true
		}

		if (update_name) {
			this.SetHideNameBord(false)
			let name
			if (this.name_board) {
				this.name_board.SetHpVisible(true)
				this.name_board.SetHp(this.vo.hp, this.vo.maxHp)
				name = this.name
				if (this.scene_mgr.IsFieldScene() ) {
					 name = `${name} (${this.vo.level})`
				}
			}
			this.UpdateName(name)
			
		}
		this.last_hited_time = local_Status.NowTime

		if (this.NoHitedState()) {
			return
		}

		if (super.DoBeAttacked(dir, pos, force_hited, movie_cfg, attacker, skill_id)) {
			if (this.vo.is_hit_ac == 1 || (pos != null)) {
				if (this.ChangeState(local_PoseState.HITED)) {
					let now_time = local_Status.NowTime
					let t = {
						start_time: now_time,
						total_time: null,
						stop_time: null,
						start_pos: null,
						end_pos: null,
						hit_animation_time: null,
					}


					t.total_time = this.normal_hited_totalTime
					t.stop_time = now_time + t.total_time
					t.start_pos = new local_Vector2(this.real_pos.x, this.real_pos.y)
					t.end_pos = null
					if (pos) {
						t.end_pos = new local_Vector2(pos.x, pos.y)
					}
					t.hit_animation_time = (this.hited_cfg && this.hited_cfg.hit_stay_time == -1) && t.total_time || (this.hited_cfg && this.hited_cfg.hit_stay_time || 0.3) //受击动作时间
					this.s_hited_info = t
				} else {
				}
			}
		}
		return true
	}

	public DoReborn(hp?) {

		if (hp == null) {
			hp = this.vo.maxHp
		} else if (hp <= 1) {
			hp = this.vo.maxHp * hp
		}

		this.vo.ChangeVar("hp", hp)
		this.is_dead = false
		this.is_to_dead = false
		this.has_dispatchDead_event = false
		this.SetLandInfo()
		this.DoStand()
	}


	public DoDead(dead_dir?) {

		if (this.is_dead) {
			return
		}
		this.dead_dir = dead_dir || false
		this.DispatchReallyDeadEvent()
		super.DoDead()
	}

	//派发副本监听的怪物死亡处理
	public DispatchReallyDeadEvent() {
		if (this.GetType() == local_SceneBaseType.Monster) {
			if (!this.has_dispatchDead_event) {
				this.has_dispatchDead_event = true
				if (this.vo) {
					local_GlobalEventSystem.Fire(local_ObjectEventType.MONSTER_REALLY_DEAD, this.vo.instance_id, this.vo.type_id, this)
				}
			}
		}
		super.DispatchReallyDeadEvent()
	}

	public EnterStateDead(state_name?) {

		//尸体不能检选
		this.SetPickInfo(false)
		local_GlobalEventSystem.Fire(local_ObjectEventType.OBJ_DEAD, this.id, this.compress_id)
		this.dead_start_time = local_Status.NowTime
		// if (lua_viewM.is_lock_screen ) {
		//	 local_GlobalEventSystem.Fire(local_ObjectEventType.OBJ_DEADBODY_FADE_END, this.dead_body_id)
		// }
		// boss 走以前的逻辑
		if (this.IsBoss() || (this.vo && this.vo.type_id && Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.NoDeadActionMonsterId[this.vo.type_id] == true)) {
			this.dead_dir = false
		}

		if (!this.dead_dir) {
			this.dead_end_pos = false
			super.EnterStateDead(state_name)
		} else {
			this.SetDirection(new local_Vector2(-this.dead_dir.x, -this.dead_dir.y))
			this.PlayAction("death")
			let dist = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.monsterAttackFly.distance
			this.dead_end_pos = new local_Vector2(this.real_pos.x + this.dead_dir.x * dist, this.real_pos.y + this.dead_dir.y * dist)
		}

		if (this == this.scene.GetClickTarget()) {
			this.scene.CancelClickTarget(true)
		}
	}

	public UpdateStateDead(state_name?, elapse_time?) {

		let total_pass_time = local_Status.NowTime - this.dead_start_time
		let fade_time = 2.0
		if (!this.dead_dir) {
			let p = total_pass_time / fade_time
			if (p <= 1) {
				// if (this.is_boss) {
				// 	this.SetAlphaFlag(local_Character.AlphaFlag.Death, (1 - p))
				// }
			} else {
				local_GlobalEventSystem.Fire(local_ObjectEventType.OBJ_DEADBODY_FADE_END, this.dead_body_id)
			}
		} else {
			//计算移动基本信息
			if (total_pass_time >= 0.3) {
				this.dead_start_time = local_Status.NowTime
				this.dead_dir = false
			} else if (this.dead_end_pos) {
				let dir = new local_Vector2(this.dead_end_pos.x - this.real_pos.x, this.dead_end_pos.y - this.real_pos.y)
				let total_distance = dir.normalise()
				if (total_distance <= 100) {
					this.dead_start_time = local_Status.NowTime
					this.dead_dir = false
				}
				let move_speed = Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.monsterAttackFly.end_speed + total_distance / 300 * Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.monsterAttackFly.start_speed
				let dist = this.GetMoveSpeed(dir, move_speed) * elapse_time
				let x = this.real_pos.x + dir.x * dist
				let y = this.real_pos.y + dir.y * dist
				this.SetRealPos(x, y)
			}
		}
	}

	public SetDeadBodyID(id?) {

		this.dead_body_id = id
	}

	//是否不需要有受击状态
	public NoHitedState() {

		if (this.IsDead() || !this.vo) {
			return true
		}
		if (this.buff_manager.hasNoEffectBuff() || this.IsNoDisplaceType() || this.vo.is_armor == 1) {
			return true
		}
		return false
	}



	//是否是不需要位移的怪物类型 2为旗子
	public IsNoDisplaceType() {

		return (this.vo && this.vo.type == 2)
	}

	public IsHideNameMonster() {

		return this.vo && this.vo.type == 12
	}


	public IsMonster() {
		return this.vo && this.vo.type == 0 && !this.scene_mgr.IsHolyBattleFightScene()
	}

	//boss类型>=3的才是boss
	public IsBoss() {
		return this.vo && this.vo.type == 0 && this.vo.boss_type >= 3
	}

	public ReleaseObj() {

		this.ReleaseCharacter()


		this.CancelCollectTime()

		if (this.vo) {
			this.vo.UnBindAll()
			this.vo.DeleteMe()
			if (this.vo.type != local_MonsterType.TASK_COLLECT && this.vo.type != local_MonsterType.COLLECT) {
				this.scene_mgr.AddMonsterVoPool(this.vo)
			}
			this.vo = false
		}
		this.dead_dir = false
		this.dead_end_pos = false
		this.is_dead = true
		this.is_to_dead = true
		this.is_boss = false
		this.has_dispatchDead_event = false
	}

	public RemoveAllParticle() {
		if (this.foot_effect_id) {
			ParticleManager.GetInstance().DelEffect(this.foot_effect_id)
			this.foot_effect_id = false
		}
		if (this.birth_effect_id) {
			ParticleManager.GetInstance().DelEffect(this.birth_effect_id)
			this.birth_effect_id = false
		}
		if (this.canatk_effect_id) {
			this.particle_mgr.DelEffect(this.canatk_effect_id)
			this.canatk_effect_id = false
		}

		this.CancelTalkTime()  //怪物没有delete，也要取消定时器
		super.RemoveAllParticle()
	}

	public ResetObj() {
		// if (this.name_board) {
		// 	this.name_board.SetHpVisible(true)
		// }
		this.ResetCharacter()
	}

	/*
		海域不能攻击时候加无敌特效
	*/
	public OnCanAttackChange() {
		if (this.scene_mgr.IsSeaHegemonyScene()) {
			if (this.vo.can_attack == 1) {
				if (this.canatk_effect_id) {
					this.particle_mgr.DelEffect(this.canatk_effect_id)
					this.canatk_effect_id = false
				}
			} else {
				let effect_name = "effect_monster_dakaihuang_003"
				this.canatk_effect_id = this.particle_mgr.AddTargetEffect(effect_name, this.compress_id, true, null, null, 7, null, null, null, true, null, null, null, null, null)
				this.particle_mgr.SetEffectScale(this.canatk_effect_id, null)
			}
		}
	}




	public UpdateMoveEndPos() {

		this.PlayAction("run")
	}

	public SetRealPos(posx?, posy?, is_born?, ignore_floor?) {

		super.SetRealPos(posx, posy, is_born, ignore_floor)
		local_GlobalEventSystem.Fire(local_ObjectEventType.MONSTER_MOVE, posx, posy, this.id)
	}

	public InitAutoBrushMoster() {
		let cfgs = Config_PRELOAD_CLIENT_CONFIG.ConfigAutoBrush
		let next_level = window["AutoBrushModel"].GetInstance().GetLevel() + 1

		let cfg

		if (cfgs && cfgs.level_boss_cfg && cfgs.level_boss_cfg[next_level]) {
			cfg = cfgs.level_boss_cfg[next_level]
		}

		if (!cfg) {
			let index = next_level % 10
			if (cfgs && cfgs.turn_boss_cfg && cfgs.turn_boss_cfg[index]) {
				cfg = cfgs.turn_boss_cfg[index]
			}
		}

		if (cfg && this.vo) {
			this.vo.monster_res = cfg.res
			this.vo.name = cfg.name
			this.name = cfg.name
			this.vo.icon_scale = cfg.scene_scale
			// this.vo.level = next_level
		}
	}
}
window["Monster"] = Monster