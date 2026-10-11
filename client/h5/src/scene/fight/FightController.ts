import { BaseController } from "../../common/BaseController"
import { BaseClass } from "../../common/BaseClass"
import { Scene } from "../Scene"
import { MonsterType, SceneBaseType } from "../SceneConfig"
import { GlobalEventSystem, LOAD_QUEUE } from "../../util/DeclareGlobalVar"
import { EventName, SceneEventType, ObjectEventType } from "../../common/EventName"
import { FightVo } from "./FightVo"
import { RoleManager } from "../../commonModel/RoleManager"
import { FightMovieInfo } from "./FightMovieInfo"
import { FightEvent } from "./FightEvent"
import { BulletObj } from "./BulletObj"
import { Vector2 } from "../../util/Vector2"
import { TimeUtil } from "../../util/TimeUtil"
import { SceneManager } from "../SceneManager"
import { FightDamageManager } from "./FightDamageManager"
import { FightManager } from "./FightManager"
import { SkillManager } from "../../skill/SkillManager"
import { GameError } from "../../util/GameError"
import { SceneController } from "../SceneController"
import { AssistVo } from "./AssistVo"
import { Message } from "../../sysInfo/SysInfoController"
import { Util } from "../../util/Util"
import { SoundManager } from "../../common/SoundManager"
import { PoseState } from "../../util/StateMachineManager"
import { Config } from "../../common/Config"
import { Status } from "../../util/Status"
import { SkillVo } from "../../skill/SkillVo"
import { SourceOperateMove } from "../../operation/SourceOperateMove"
import { AutoFightManager } from "../../autofight/AutoFightManager"
import { SceneObj } from "../sceneobj/SceneObj"
import { GameMath } from "../../util/GameMath"
import { SkillBuffType } from "./BuffManager"
import { Runner } from "../../util/Runner"
import { FRAME_TYPE } from "../../util/DeclareGlobalVar"
import { Character } from "../sceneobj/Character"
import { ResManager } from "../../common/ResManager"
import { StoryModel } from "../../commonModel/StoryModel"
import { ViewManager } from "../../common/ViewManager"
import { BossModel } from "../../commonModel/BossModel"
import { MainUIModel } from "../../commonModel/MainUIModel"
import { SkillUIModel } from "../../commonModel/SkillUIModel"
import { AutoBrushModel } from "../../commonModel/AutoBrushModel"
import { LayerManager } from "../../common/LayerManager"
import { CameraManager } from "../CameraManager"
// TypeScript file
export class FightController extends BaseController {
	static Instance: FightController
	static SHOW_HP_BOSS_TYPE = 2
	fight_info_list = [] //计算了伤害信息的技能信息，不能被打断了
	fightHandler_delay_list = [] //服务端广播的延迟战斗处理列表 只针对服务端战斗
	main_skill_pos = {} //主技能攻击点坐标
	main_skill_dir = {} //主技能攻击者朝向
	bullet_list = [] //弹道列表
	bullet_timer_id = 0
	bullet_timer_list = {} //定时创建弹道的定时器
	final_fight_time
	joy_stick_dir = false
	frame_index = 0
	update_elapse_time = 0
	request_fight_mon_list = []
	private _hash_target = new BaseClass()
	Update
	AddDelayFightHandler
	MergeFightDelayList
	ExecuteFightHandler
	RegisterAllProtocals
	AddAllEvents
	ClientFightServer
	AttackRequest
	ClientPrePlayFightMovie
	ClientVirtualRolePlayFightMovie
	GetAttackerFromVo
	GetDefenderListFromVo
	RefreshObjVo
	playFightMovie
	CreateBullet
	GetFightSkill
	SendAssistSkill
	BeforeRequestToFightHandler
	cacheLoseMonsterVo
	force_update_in_next_frame
	public static GetInstance() {
		if (!FightController.Instance) {
			FightController.Instance = new FightController()
		}
		return FightController.Instance
	}
	public constructor() {
		super()
		let local_SceneBaseType = SceneBaseType,
			g_event = GlobalEventSystem,
			event_name = EventName,
			Self_FightVo = FightVo,
			mainrole_vo = RoleManager.GetInstance().GetMainRoleVo(),
			local_FightMovieInfo = FightMovieInfo,
			fight_event = FightEvent,
			FIND_TARGET_TYPE_monster = Scene.FIND_TARGET_TYPE.monster,
			FIND_TARGET_TYPE_role = Scene.FIND_TARGET_TYPE.role,
			FIND_TARGET_TYPE_all = Scene.FIND_TARGET_TYPE.all,
			local_BulletObj = BulletObj,
			local_Vector2 = Vector2,
			local_Math = Math,
			local_TimeUtil = TimeUtil,
			scene_mgr = SceneManager.GetInstance(),
			fight_damage_mgr:FightDamageManager = FightDamageManager.GetInstance(),
			fight_manager = FightManager.GetInstance(),
			scene = Scene.GetInstance(),
			skillMgr = SkillManager.GetInstance(),
			local_ViewManager = ViewManager,
			layer_mgr = LayerManager.GetInstance()

		let cache_elapse_time = 0
		this.Update = (now_time, elapsed_time) => {
			// this.update_elapse_time = this.update_elapse_time + elapsed_time
			// fight_damage_mgr.Update(now_time, elapsed_time)

			if(!this.force_update_in_next_frame && !layer_mgr.CheckFrameTimeValid())
			{
				this.force_update_in_next_frame = true
				return
			}else
			{
				this.force_update_in_next_frame = false
			}
			this.frame_index = this.frame_index + 1
			cache_elapse_time += elapsed_time
			if (this.frame_index % local_ViewManager.OPENBIGVIEWFRAME != 0) return

			let n, fight_info
			// //刷新弹道
			n = this.bullet_list.length
			if (n > 0) {
				let empty_i = null
				for (let i = n - 1; i >= 0; i--) {
					let bullet = this.bullet_list[i]
					if (bullet) {
						if (!bullet.Update(now_time, cache_elapse_time)) {
							fight_manager.pushBullet(bullet)
							this.bullet_list.splice(i, 1)
						}
					}
				}
			}
			cache_elapse_time = 0
			if (this.frame_index % (local_ViewManager.OPENBIGVIEWFRAME * 5) != 0)
				return
			fight_manager.playHiterAnimantion()
			//播放受击动作n = this.fight_info_list.length,
			//刷新三连斩的时间，过一定时间没攻击就要重置三连斩
			// skillMgr.Update(now_time, this.update_elapse_time)
			//
			//刷新技能过程，关键点：刷新过程中可能继续insert槽位
			n = this.fight_info_list.length
			if (n > 0) {
				for (let i = n - 1; i >= 0; i--) {
					fight_info = this.fight_info_list[i]
					if (fight_info) {
						fight_info.Update(now_time)
						if (fight_info.IsFinished()) {
							this.fight_info_list.splice(i, 1)
							fight_manager.pushFightMovie(fight_info)
						}
					}
				}
			}
			// console.log("n", n)
			// if (n > 0) {
			//	 let empty_i = null
			//	 for (let i = 0 i < n i++) {
			//		 let fight_info = this.fight_info_list[i]
			//		 if (fight_info) {
			//			 fight_info.Update(now_time)
			//			 if (empty_i == null && fight_info.IsFinished())	 //注意，刷新过程中可能会继续insert槽位，所以不能直接在这里置null
			//				 empty_i = i
			//		 }
			//	 }
			//把已经结束的槽位去掉，并把后续槽位前移
			// if (empty_i != null) {
			//	 let n = this.fight_info_list.length
			//	 for (let i = empty_i i < n i++) {
			//		 let info = this.fight_info_list[i]
			//		 if (info) {
			//			 // console.log("检查移槽：", i, info)
			//			 if (!info.IsFinished()) {
			//				 // console.log(string.format("把第%d格的info移到第%d格", i, empty_i))
			//				 this.fight_info_list[empty_i] = info
			//				 empty_i = empty_i + 1
			//				 this.fight_info_list.splice(i, 1)
			//			 }
			//			 else {
			//				 fight_manager.pushFightMovie(info)
			//				 this.fight_info_list.splice(i, 1)
			//			 }
			//		 }
			//	 }
			// }
			// }

			//最后一次攻击超过3秒钟要清除战斗中心点数据
			if(this.final_fight_time && now_time - this.final_fight_time >= 3){
				this.final_fight_time = null
				this.main_skill_pos = {}
				this.main_skill_dir = {}
			}
			this.AddDelayFightHandler() //战斗延迟处理  只针对服务端战斗
			// this.update_elapse_time = 0
		}
		this.AddDelayFightHandler = () => {
			let delay_list_size = this.fightHandler_delay_list.length
			if (delay_list_size >= 5)
				this.MergeFightDelayList()
			else if (delay_list_size > 0) {
				let fightVo = this.fightHandler_delay_list.shift()
				this.ExecuteFightHandler(fightVo)
			}
		}
		//-合并战斗延迟列表
		this.MergeFightDelayList = () => {
			let delay_list_size = this.fightHandler_delay_list.length
			if (delay_list_size <= 0)
				return
			let fightVo = null, attack_fight_list = {}, defend_fight_list = {}, role_id = 0
			for (let i = 0; i < delay_list_size; i++) {
				fightVo = this.fightHandler_delay_list.shift()
				role_id = fightVo.attack.role_id
				attack_fight_list[role_id] = fightVo //保存每一个攻击者信息
				if (defend_fight_list[role_id]) {
					if (defend_fight_list[role_id].hp == 0) {
						console.log("残影原因3$$$$$$$$$$$$$$$$$$$$$$$$$没有执行死亡流程 被后面非死亡的受击覆盖了")
					}
					delete defend_fight_list[role_id] //删除之前保存在受击列表的攻击者信息  因为此时的攻击者信息比之前的受击者信息新
				}
				for (let j = 0; j < fightVo.defense_list.length; j++) {
					role_id = fightVo.defense_list[j].role_id
					defend_fight_list[role_id] = fightVo.defense_list[j] //保存每一个受击者的信息
					if (attack_fight_list[role_id]) {
						if (attack_fight_list[role_id].hp == 0) {
							console.log("残影原因4$$$$$$$$$$$$$$$$$$$$$$$$$没有执行死亡流程 被后面非死亡的受击覆盖了")
						}
						delete attack_fight_list[role_id] //删除之前保存在攻击者列表的受击者信息 因为此时的受击者信息比之前的攻击者信息新
					}
				}
			}
			for (let role_id in attack_fight_list) //处理有攻击者的情况
			{
				fightVo = attack_fight_list[role_id]
				for (let j = 0; j < fightVo.defense_list.length; j++) {
					if (defend_fight_list[role_id]) //如果存在总的受击列表中 就从总的受击列表中移除 在这个攻击数据中播放受击对象
					{
						if (defend_fight_list[role_id].hp == 0) {
							console.log("残影原因5$$$$$$$$$$$$$$$$$$$$$$$$$没有执行死亡流程 被后面非死亡的受击覆盖了")
						}
						delete defend_fight_list[role_id]
					}
					else //如果不存在总的受击列表中  不用播放受击对象
						fightVo.defense_list.splice(j, 1)
				}
				this.ExecuteFightHandler(fightVo)
			}
			let defend_vo
			for (let role_id in defend_fight_list) //剩下没有攻击者的受击列表  统一播放
			{
				defend_vo = defend_fight_list[role_id]
				let defense_obj = null
				if (defend_vo.type_flag == local_SceneBaseType.Monster) //   	int.8 1怪 2人
					defense_obj = scene.GetMonster(defend_vo.role_id)
				else if (defend_vo.type_flag == local_SceneBaseType.Role || defend_vo.type_flag == local_SceneBaseType.Fake_Role)
					defense_obj = scene.GetRole(defend_vo.role_id)
				if (defense_obj != null && !defense_obj.IsDead()) {
					let obj_vo = defense_obj.GetVo()
					if (obj_vo) {
						if (defend_vo.hp)
							obj_vo.ChangeVar("hp", defend_vo.hp)
						defense_obj.SetBuffList(defend_vo.buff_list, defend_vo.breaked_skill_id)
						if (defend_vo.hp == 0) {
							if (defend_vo.pos_x && defend_vo.pos_y && (defend_vo.pos_x != 0 || defend_vo.pos_y != 0))
								defense_obj.SetRealPos(defend_vo.pos_x, defend_vo.pos_y)
							defense_obj.ForceDoDead()
						}
						else
							defense_obj.DoBeAttacked(null, defend_vo.new_pos)
					}
				}
			}
		}
		this.ExecuteFightHandler = (fightVo) => {
			if (fightVo) {
				if (fightVo.protocal_type == 20001)
					this.playFightMovie(fightVo)
				else if (fightVo.protocal_type == 20003)
					this.playFightMovie(fightVo)
				// GlobalEventSystem.Fire(EventName.MONSTER_ATTACK_MAIN_ROLE)
			}
		}
		this.RegisterAllProtocals = () => {
			let handler20001 = () => {
				let fightVo = fight_manager.fightVo_pool.shift() || new Self_FightVo()
				fightVo.protocal_type = 20001
				fightVo.ReadFromProtocal()
				if (!scene_mgr.can_receive_scene_protocal)
					return
				if (fightVo.attack.role_id == mainrole_vo.role_id || fightVo.attack.is_mainRole_defender) {

					let auto_release_partner_skill = false
					if (AutoFightManager.GetInstance().GetAutoFightState() && fightVo.attack.role_id == mainrole_vo.role_id) {
						let skill_vo = skillMgr.getSkill(fightVo.attack.skill_id)
						if (skill_vo && !skill_vo.IsComboSkill()) {
							auto_release_partner_skill = true
						}
					}

					MainUIModel.GetInstance().DelAllSkillBuff()//清空bufflist
					if(fightVo.attack.role_id == mainrole_vo.role_id){
						MainUIModel.GetInstance().SetSkillBuff(fightVo.attack.buff_list)
						for(let skill_id of fightVo.attack_trigger_skill_list){
							if(window["FightDamageManager"]){
								window["FightDamageManager"].GetInstance().ShowSkillImg(skill_id, null, 1);
							}
						}
					}else{
						let defense_list = fightVo.defense_list
						if(defense_list&&defense_list.length>0){
							for(let i = 0;i<defense_list.length;i++){
								let defense = defense_list[i]
								if(defense&&defense.role_id == mainrole_vo.role_id){
									MainUIModel.GetInstance().SetSkillBuff(defense.buff_list)
									break;
								}
							}		
						}
					}
				
					//托管状态下 主角收到攻击协议 默认第一个被击对象为 选中对象
					if (RoleManager.GetInstance().GetMainRoleDepositState() && fightVo.attack.role_id == mainrole_vo.role_id) {
						let defense_list = fightVo.defense_list
						let defense = defense_list[0]
						if (defense) {
							let defense_obj
							if (defense.type_flag == local_SceneBaseType.Monster) //   	int.8 1怪 2人
								defense_obj = scene.GetMonster(defense.role_id)
							else if (defense.type_flag == local_SceneBaseType.Role || defense.type_flag == local_SceneBaseType.Fake_Role)
								defense_obj = scene.GetRole(defense.role_id)

							if (defense_obj) {
								scene.SetClickTarget(defense_obj)
							}
						}
					}

					
					this.MergeFightDelayList()
					this.playFightMovie(fightVo)
					//只显示主角的伙伴特效
					if(fightVo.attack.role_id == mainrole_vo.role_id){
						SkillUIModel.GetInstance().ReleasePartnerSkillTip(fightVo.attack.skill_id || null)
					}
					if (auto_release_partner_skill) {
						scene.PartnerUpdateFight()
					}

				}
				else
					this.fightHandler_delay_list.push(fightVo)
			}
			let handler20003 = () => {
				let fightVo = fight_manager.fightVo_pool.shift() || new Self_FightVo()
				fightVo.protocal_type = 20003
				fightVo.ReadFromProtocal()
				if (fightVo.attack.is_mainRole_defender) {
					this.MergeFightDelayList()
					this.playFightMovie(fightVo)
				}
				else
					this.fightHandler_delay_list.push(fightVo)
			}
			let handler20005 = () => {
				let [
					error_flag, // int.8	错误码 1 对方没血 2 出手太快 3 自己没血 4 距离太远 5 技能cd未到
					attack_type, // int.8	类型1怪 2人
					attack_role_id, // int.64   攻方id
					attack_plat_name,
					attack_server_id,
					attack_hp, // int.64   攻方hp
					attack_pos_x, // int.16   攻方x
					attack_pos_y, // int.16   攻方y
					defense_type, // int.8	类型1怪 2人
					defense_role_id, // int.64   防方id
					defense_plat_name,
					defense_server_id,
					defense_hp, // int.64   防方hp
					defense_pos_x, // int.16   守方x
					defense_pos_y
				] = // int.16   守方y
					this.ReadFmt("ccishlhhcishlhh")

				let code = Config.PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.FightErrorCodes[error_flag]
				console.warn("错误码错误码错误码错误码", error_flag, attack_type, code)
				// if error_flag == 41 then //该错误返回需要移除的怪物id列表 （客户端攻击已经死亡的怪物时 服务端从这里返回 通知客户端移除怪物）
				//	 let len = this.ReadFmt("h")
				//	 let mon_id = 0
				//	 let monster = 0
				//	 for i = 1, len do
				//		 mon_id = this.ReadFmt("i")
				//		 monster = scene.GetMonster(mon_id)
				//		 if monster != null then
				//			 monster.GetVo().ChangeVar("hp", 0)
				//			 monster.ForceDoDead()
				//		 end
				//	 end
				// end
				//	 let role = null
				//	 if attack_type == 2 then //如果攻击方是人
				//		 role = scene.GetRole(attack_role_id)
				//		 if role != null and role.GetType() == local_SceneBaseType.MainRole then
				//			 if error_flag == 3 then
				//				 role.GetVo().ChangeVar("hp", attack_hp)
				//				 if attack_hp == 0 then
				//					 role.DoDead()
				//				 end
				//			 elseif error_flag == 4 then
				//				 scene.RoleMove(role.id, attack_pos_x, attack_pos_y, 1)
				//			 elseif error_flag == 10 then //怒气不足
				//				 RoleManager.Instance.mainRoleInfo.ChangeVar("anger", attack_anger, null, true)
				//			 end
				//			 skillMgr.setCurrentSkillId()
				//		 end
				//	 end
				//	 if defense_type == 2 then //如果受击方是人
				//		 role = scene.GetRole(defense_plat_name,defense_server_id,defense_role_id)
				//		 if role != null then
				//			 if error_flag == 1 then
				//				 role.GetVo().ChangeVar("hp", defense_hp)
				//				 if defense_hp == 0 then
				//					 role.DoDead()
				//				 end
				//			 elseif error_flag == 4 then
				//				 scene.RoleMove(role.id, attack_pos_x, attack_pos_y, 1)
				//			 end
				//		 end
				//	 else   //如果受击方是怪
				//		 let monster = scene.GetMonster(defense_role_id)
				//		 if monster != null then
				//			 monster.GetVo().ChangeVar("hp", defense_hp)
				//			 if defense_hp == 0 then
				//				 monster.ForceDoDead()
				//			 end
				//			 if error_flag == 4 then
				//				 scene.MonsterMove(monster.id, defense_pos_x, defense_pos_y, 1)
				//			 elseif error_flag == 1 then
				//				 scene_mgr.DeleteMonsterVo(monster.id, SceneManager.DELETE_MONSTER_FIGHT_ERROR)
				//			 end
				//		 end
				//	 end
				//	 if error_flag == 30 then
				//		 skillMgr.ResetThreeAttackIndex()
				//	 end
				// end
			}
			let handler20006 = () => {
				let assistVo = new AssistVo()
				assistVo.ReadFromProtocal()
				let attacker = this.GetAttackerFromVo(assistVo), 
					skillId = assistVo.attack.skill_id, 
					defender_list = [], 
					defender_info_list = []

				this.GetDefenderListFromVo(assistVo, defender_list, defender_info_list)
				if (!attacker) {
					console.log("触发辅助技能，但是攻击目标已经不存在了", skillId)
					this.RefreshObjVo(defender_list, defender_info_list, attacker, assistVo.attack)
					return
				}
				if (skillMgr.GetFightSkillMovie(skillId)) {
					let fight_info = fight_manager.fightMovie_pool.shift() || new local_FightMovieInfo()
					fight_info.InitData(skillId, attacker, assistVo.attack, defender_list, defender_info_list)
					fight_info.PlayActions()
					this.fight_info_list.push(fight_info)
					return
				}
			}
			let handler20007 = () => {
				let type_flag = this.ReadFmt("c")
				let role_id = this.ReadFmt("l")
				let delete_buff_list = []
				let len = this.ReadFmt("h")
				let obj
				for (let i = 0; i < len; i++) {
					obj = {}
					obj.buff_type = this.ReadFmt("h")
					obj.buff_skill_id = this.ReadFmt("i")
					delete_buff_list.push(obj)
				}
				let scene_obj
				if (type_flag == local_SceneBaseType.Monster)
					scene_obj = scene.GetMonster(role_id)
				else if (type_flag == local_SceneBaseType.Role || type_flag == local_SceneBaseType.Fake_Role)
					scene_obj = scene.GetRole(role_id)
				if (scene_obj) {
					for (let vo of delete_buff_list) {
						scene_obj.buff_manager.RemoveBuff(vo.buff_type, vo.buff_skill_id)
					}
				}
			}
			let handler20013 = () => {
				scene_mgr.killerType = this.ReadFmt("c") //类型（1.被怪杀死 2.被玩家杀死）
				scene_mgr.killerName = this.ReadFmt("s") //攻击方名字
				let [a, b, c, d] = this.ReadFmt("hchc")
				scene_mgr.killerId = this.ReadFmt("l") //攻击方id
				// int: 8 类型（1.被怪杀死 2.被玩家杀死）
				// string 攻击方名字
				// int:16 现在的罪恶值
				// int:8  扣除的元宝
				// int:16 玩家等级
				// int:8  几转
				// int:64 攻击方id
				g_event.Fire(event_name.SHOWRELIVEWINDOW, 0) //0打开复活界面 1关闭复活界面
			}
			let handler20020 = () => {
				let error_code = this.ReadFmt("i")
				let mon_instance_id = this.ReadFmt("i")
				if (error_code == 1) {
					Message.show("抢夺成功")
					g_event.Fire(event_name.UPDATE_BOSS_OWNER_MSG, mon_instance_id, mainrole_vo.role_id)
				}
				else
					Util.ErrorCodeShow(error_code)
			}
			let handler20021 = () => {
				let [boss_id, first_attack_role_id] = this.ReadFmt("il")
				g_event.Fire(event_name.UPDATE_BOSS_OWNER_MSG, boss_id, first_attack_role_id)
			}
			let handler20022 = () => {
				let killer_id = this.ReadFmt("l"), died_id = this.ReadFmt("l"), hp = this.ReadFmt("l"), hp_lim = this.ReadFmt("l"), objVo = scene_mgr.GetRoleVo(died_id)
				if (objVo) {
					objVo.ChangeVar("hp", hp)
					objVo.ChangeVar("maxHp", hp_lim)
				}
				if (died_id == mainrole_vo.role_id) {
					scene_mgr.SetKillerInfo(local_SceneBaseType.Role, killer_id)
				}
				let obj = scene.GetSceneObj(died_id)
				if (obj)
					obj.DoDead()
				g_event.Fire(event_name.SIMULATE_FIGHT_RESULT, killer_id, died_id)
			}
			let handler20023 = () => {
				let energy = this.ReadFmt("h")
				g_event.Fire(event_name.UPDATE_FIGHT_ENEERGY, energy)
			}
			let handler20024 = () => {
				let state = this.ReadFmt("c")
				if (state == 1) {
					RoleManager.GetInstance().GetMainRoleVo().is_fighting_state = true
				}
				else {
					RoleManager.GetInstance().GetMainRoleVo().is_fighting_state = false
				}
			}
			let handler20008 = () => {
				let flag = this.ReadFmt("c")
				//console.warn("------handler20008------", flag)
				if (flag == 1) {
					g_event.Fire(event_name.START_TO_COLLECT)
					scene.MainRoleDoCollect()
				}
				else if (flag == 2) {
					g_event.Fire(event_name.COMPLETE_TO_COLLECT, fight_manager.collect_monster_type_id, fight_manager.collect_monster_ins_id)
					scene.MainRoleQuitCollect()
					let collect_vo = scene_mgr.GetMonsterVo(fight_manager.collect_monster_ins_id)
					if (collect_vo && collect_vo.type != MonsterType.NOT_DEAD_COLLECT) {
						scene_mgr.DeleteMonsterVo(fight_manager.collect_monster_ins_id)
					}
				}
				else if (flag == 3)
					Message.show("距离采集物太远")
				else if (flag == 4)
					Message.show("采集失败")
				else if (flag == 5)
					Message.show("采集时间不足")
				else if (flag == 6)
					Message.show("采集怪不属于本结社")
				else if (flag == 7)
					Message.show("采集次数已满")
				else if (flag == 8)
					Message.show("采集怪配置id不对应")
				else if (flag == 9)
					Message.show("采集生命果实次数已满")
				else if (flag == 10)
					Message.show("分组相同不能采集")
				else if (flag == 11)
					Message.show("每轮喜糖最多只能采集3个")
				else if (flag == 12)
					Message.show("不能掠夺本服矿物")
				else if (flag == 13) {
					if (scene_mgr.IsSeaHegemonyScene()) {
						Message.show("正在被他人修复")
					} else {
						Message.show("正在被他人采集")
					}
				}
				else if (flag == 15)
					Message.show("背包空间不足")
				else if (flag == 16)
					Message.show(`食用普通喜糖次数已满`)
				else if (flag == 17)
					Message.show(`食用豪华喜糖次数已满`)
				else if (flag == 22)
					Message.show("每轮只能采集一个火苗！")
				else if (flag == 23)
					Message.show("普通宝箱已达采集上限")
				else if (flag == 24)
					Message.show("稀有宝箱已达采集上限")
				else if (flag == 25)
					Message.show("需要先修复前一据点")
				else if (flag == 26)
					Message.show("不是同一阵营")
				else if (flag == 27)
					Message.show("复活冷却中")
				if (flag > 2) {
					g_event.Fire(event_name.SERVER_CANCEL_TO_COLLECT, flag, fight_manager.collect_monster_type_id, fight_manager.collect_monster_ins_id)
				}
				if (flag >= 2) {
					g_event.Fire(event_name.BROADCAST_COLLECT_RESULT, flag, fight_manager.collect_monster_type_id, fight_manager.collect_monster_ins_id)
					fight_manager.collect_monster_type_id = null
					fight_manager.collect_monster_ins_id = null
				}
				// 1 => 开始成功
				// 2 => 结束成功
				// 3 => 距离采集物太远
				// 4 => 采集失败
				// 5 => 同一阵营，不能采集
				// 6 => 需占领一个帮派战旗且击杀5个神兽后才能占领神针
				// 7 => 需先击杀相应的神兽才能占领
				// 8 => 运送神石中不能占领
				// 9 => 攻城战中，现在的状态不能采集
			}
			let handler20010 = () => {
				let len = this.ReadFmt("h")
				for (let i = 0; i < len; i++) {
					let error_code = this.ReadFmt("c")
					let mon_id = this.ReadFmt("i")
					if (error_code == 1) {
						Message.show("拾取成功")
					}
					else {
						// if (error_code == 2)
						// 	 Message.show("拾取失败")
						// else if (error_code == 3)
						// 	 Message.show("距离拾取物太远")
						// else if (error_code == 4)
						// 	 Message.show("不是拾取物")
					}

					if (error_code != 1) {
						BossModel.GetInstance().RemovePickupMonState(mon_id)
					}
				}
			}
			let handler20027 = () => {	
				let skill_list = []
				skill_list.push({
					skill_id: this.ReadFmt("i"),
					cd_time: this.ReadFmt("l"),
				})
				skillMgr.Fire(SkillManager.REFRESH_CD, skill_list)
			}

			let handler20028 = () => {
				let skill_num = this.ReadFmt("h")
				let trigger_skill_list = []
				for (let i = 0; i < skill_num; i++) {
					trigger_skill_list.push(this.ReadFmt("i"))
				}
				for(let skill_id of trigger_skill_list){
					if(window["FightDamageManager"]){
						window["FightDamageManager"].GetInstance().ShowSkillImg(skill_id, null, 2);
					}
				}
			}
			this.RegisterProtocal(20001, handler20001) //侦听玩家攻击
			this.RegisterProtocal(20003, handler20003) //侦听怪打玩家
			this.RegisterProtocal(20005, handler20005) //攻击失败返回
			this.RegisterProtocal(20006, handler20006) //玩家发动辅助技能
			this.RegisterProtocal(20007, handler20007) //buff技能清理
			this.RegisterProtocal(20008, handler20008) //采集
			this.RegisterProtocal(20010, handler20010) //拾取怪物
			this.RegisterProtocal(20013, handler20013) // 被杀信息
			this.RegisterProtocal(20020, handler20020)
			this.RegisterProtocal(20021, handler20021)
			this.RegisterProtocal(20022, handler20022)
			this.RegisterProtocal(20023, handler20023)
			this.RegisterProtocal(20024, handler20024)
			this.RegisterProtocal(20027, handler20027)
			this.RegisterProtocal(20028, handler20028)
		}
		this.AddAllEvents = () => {
			let scene_changed_func = () => {
				for (let fight_info of this.fight_info_list){
					fight_manager.pushFightMovie(fight_info)
				}
				this.fight_info_list.length = 0
				
				for (let fight_vo of this.fightHandler_delay_list){
					fight_manager.pushFightVo(fight_vo)
				}
				this.fightHandler_delay_list.length = 0

				fight_manager.clear()
				CameraManager.GetInstance().ClearShakeScreen()
				// for _, fight_info in pairs(this.bullet_list) do
				// 	 fight_info.DeleteMe()
				// end
				// this.bullet_list = {}
				// for _, fight_info in pairs(this.sectorAttack_list) do
				// 	fight_info:DeleteMe()
				// end
				// this.sectorAttack_list = {}
				// for _, timer in pairs(this.bullet_timer_list) do
				//	 TimerQuest.CancelQuest(GlobalTimerQuest, timer)
				// end
				// this.bullet_timer_list = {}
				// if (scene_mgr.IsFieldScene()) {
				// if (!LoginModel.GetInstance().is_new_career || PlatformManager.GetInstance().is_alpha || PlatformManager.GetInstance().need_alpha_open_charge) {
				// SoundManager.GetInstance().PlaySceneSound(2001, 1, 0)
				// }
				// } else {
				SoundManager.GetInstance().PlaySceneSound()
				// }
			}
			g_event.Bind(SceneEventType.SCENE_CHANGED, scene_changed_func)
			let onReleaseMainSkill = (attacker, skill_id, target_compress_id) => {
				this.AttackRequest(attacker, skill_id, target_compress_id)
			}
			g_event.Bind(fight_event.RELEASE_MAIN_SKILL, onReleaseMainSkill)
			let onReleaseAssistSkill = (role_id, skill_id) => {
				this.SendAssistSkill(role_id, skill_id)
			}
			g_event.Bind(fight_event.RELEASE_ASSIST_SKILL, onReleaseAssistSkill)
			let joy_stick_dragging = (stick_dir) => {
				this.joy_stick_dir = stick_dir
			}
			let joy_stick_release_func = () => {
				this.joy_stick_dir = false
			}
			// g_event.Bind(UIJoyStick.EVENT_DRAGGING, joy_stick_dragging)
			// g_event.Bind(UIJoyStick.EVENT_TOUCH_END, joy_stick_release_func)
			let mergeFightDelayList = () => {
				this.MergeFightDelayList()
			}
			g_event.Bind(event_name.EXECUTE_DELEY_FIGHT_INFO, mergeFightDelayList)

			let onVirtualRoleFightHandler = (skill_id, attacker) => {
				this.ClientVirtualRolePlayFightMovie(skill_id, attacker)
			}
			this.Bind(fight_event.VIRTUAL_ROLE_FIGHT, onVirtualRoleFightHandler)

			let WriteFMT = this.WriteFMT
			let onRoleRequestToFightHandler = (fight_msg) => {
				if (fight_msg == null || !scene_mgr.IsSceneStart())
					return
				let mon = null, mon_id = 0, request_fight_mon_count = 0, mon_vo = null
				for (let i = 0; i < fight_msg.monster_list.length; i++) {
					mon_id = fight_msg.monster_list[i]
					mon = scene.GetSceneObj(mon_id)
					if (mon) {
						mon_vo = mon.GetVo()
						if (mon_vo && mon_vo.hp > 0 && !mon.IsDead()) {
							this.request_fight_mon_list[request_fight_mon_count] = mon_id
							request_fight_mon_count = request_fight_mon_count + 1
						}
						else if (!mon.IsInState(PoseState.HITED))
							mon.ForceDoDead()
					}
				}
				// console.warn("FightController@onRoleRequestToFightHandler",fight_msg.skill_id, fight_msg.attack_x, fight_msg.attack_y, fight_msg.attack_angle)
				this.WriteBegin(20001)
				//怪物列表
				WriteFMT.call(this, "h", request_fight_mon_count)
				for (let i = 0; i < request_fight_mon_count; i++) {
					// console.log("request_fight_mon_count=", request_fight_mon_count, i, this.request_fight_mon_list[i])
					WriteFMT.call(this, "i", this.request_fight_mon_list[i])
				}
				WriteFMT.call(this, "h", fight_msg.role_list.length)
				for (let i = 0; i < fight_msg.role_list.length; i++)
					WriteFMT.call(this, "l", fight_msg.role_list[i])
				fight_msg.attack_x = fight_msg.attack_x < 0 ? 0 : fight_msg.attack_x
				fight_msg.attack_y = fight_msg.attack_y < 0 ? 0 : fight_msg.attack_y
				fight_msg.attack_angle = fight_msg.attack_angle < 0 ? 0 : fight_msg.attack_angle
				WriteFMT.call(this, "ihhh", fight_msg.skill_id, local_Math.floor(fight_msg.attack_x), local_Math.floor(fight_msg.attack_y), local_Math.floor(fight_msg.attack_angle))
				this.SendToGame()
				skillMgr.AddReleaseMainSkill(fight_msg.skill_id)
				if (skillMgr.getSkill(fight_msg.skill_id).IsComboSkill()) {
					// fight_manager.pushFightInfoList(fight_msg)
				}
				else {
					scene_mgr.SetLastFightMsg(fight_msg.attacker_type, fight_msg)
				}
			}
			g_event.Bind(fight_event.ROLE_REQUEST_TOFIGHT, onRoleRequestToFightHandler)
			let onRolePrePlayFightHandler = (skill_id, monster_list, role_list, msg_info, attacker) => {
				this.ClientPrePlayFightMovie(skill_id, monster_list, role_list, msg_info, attacker)
			}
			g_event.Bind(fight_event.ROLE_REQUEST_TOPREPLAYFIGHT, onRolePrePlayFightHandler)
			let hp_change_form_scene = (obj, delta, damage_flag?, attacker_obj?) => {
				damage_flag = damage_flag || 0
				if (obj && delta) {
					if (obj.GetType() == local_SceneBaseType.MainRole) {
						if (delta > 0) {
							fight_damage_mgr.ShowAdd(delta, damage_flag, obj)
						}
						else if (delta < 0) {
							fight_damage_mgr.ShowFont(damage_flag, local_Math.abs(delta), attacker_obj, obj)
						}
					}
					else {
						//如果是其他人血量变化只显示和主角相关的
						if(attacker_obj && attacker_obj.GetType() == local_SceneBaseType.MainRole){
							if (delta > 0) {
								fight_damage_mgr.ShowAdd(delta, damage_flag, obj)
							}
							else if (delta < 0) {
								fight_damage_mgr.ShowFont(damage_flag, local_Math.abs(delta), attacker_obj, obj)
							}
						}
					}
				}
			}
			g_event.Bind(event_name.HP_CHANGE_FROM_SCENE, hp_change_form_scene)
			// let function onExpChangeHandler(var, value, old_value)
			//	 if scene_mgr.CheckDisplayAddExpAvailable() and old_value then
			//		 let delta = value - old_value 
			//		 if delta > 0 then
			//			 fight_damage_mgr.ShowAddExp(delta)
			//		 end
			//	 end
			// end
			// RoleManager.Instance.mainRoleInfo.BindOne("exp",onExpChangeHandler)
			let onPickMonsterRequest = (collect_monster_ins_id, type_id, flag) => {
				// console.warn("//-20008采集//-：", type_id, flag)
				fight_manager.collect_monster_type_id = type_id
				fight_manager.collect_monster_ins_id = collect_monster_ins_id
				//console.warn("------onPickMonsterRequest------", collect_monster_ins_id, type_id, flag)
				this.SendFmtToGame(20008, "iic", collect_monster_ins_id, type_id, flag)
			}
			g_event.Bind(event_name.REQUEST_TO_COLLECT, onPickMonsterRequest)
			let onGameStartHandler = () => {
				this.SendFmtToGame(20009)
			}
			g_event.Bind(event_name.GAME_START, onGameStartHandler)
			//抢夺归属
			let onSnatchingOwnerShip = (instance_id) => {
				this.SendFmtToGame(20020, "i", instance_id)
			}
			g_event.Bind(event_name.SNATCHING_OWNERSHIP, onSnatchingOwnerShip)
			//查看归属
			let onCheckOwnerShip = (instance_id) => {
				this.SendFmtToGame(20021, "i", instance_id)
			}
			g_event.Bind(event_name.CHECK_OWNERSHIP, onCheckOwnerShip)
			let scene_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.fighting_state_invalidate
			let onChangeFightingState = (state) => {
				if (state == true && scene_cfg[scene_mgr.GetSceneId()])
					return
				if (state) {
					this.SendFmtToGame(20024, "c", 1)
				}
				else {
					this.SendFmtToGame(20024, "c", 2)
				}
			}
			g_event.Bind(event_name.CHANGE_FIGHTING_STATE, onChangeFightingState)
			let onCollideMonsterHandler = (list) => {
				this.WriteBegin(20010)
				this.WriteFMT("h", list.length)
				for (let v of list) {
					this.WriteFMT("i", v)
				}
				this.SendToGame()
			}
			g_event.Bind(ObjectEventType.MAIN_ROLE_COLLIDE_MONSTER, onCollideMonsterHandler)
			// let function onReducePlayerBlood( num )
			//	 this.SendFmtToGame(20012,"i", num)
			// end
			// g_event.Bind(event_name.REDUCE_PLAYER_BLOOD, onReducePlayerBlood)
		}
		//客户端战斗服务器逻辑
		this.ClientFightServer = (fight_msg) => {
			//  if (fight_msg.skill_id != 802001)return  //测试伙伴技能用
			let main_vo = RoleManager.Instance.mainRoleInfo, attacker_type = fight_msg.attacker_type, local_SceneBaseType = SceneBaseType, fight_vo = fight_manager.fightVo_pool.shift() || new Self_FightVo()
			attacker_type = attacker_type == local_SceneBaseType.MainRole ? local_SceneBaseType.Role : attacker_type
			fight_vo.attack.attacker_type = attacker_type //	int:8 攻击类型
			fight_vo.attack.role_id = main_vo.role_id //int:64 攻击方ID
			fight_vo.attack.hp = main_vo.hp //   	  int:64 hp
			fight_vo.attack.anger = main_vo.anger //		  int:32 anger
			fight_vo.attack.move_anim = 0 //-		  int:8技能发生位移时，播放的动画
			fight_vo.attack.skill_id = fight_msg.skill_id //  int:32 技能
			fight_vo.attack.skill_level = 1 //  int:16  技能等级
			fight_vo.attack.pos_x = main_vo.pos_x //	  int:16 x 攻击方当前x坐标
			fight_vo.attack.pos_y = main_vo.pos_y //	  int:16 y 攻击方当前y坐标
			fight_vo.attack.attack_pos_x = fight_msg.attack_x //技能的方向x
			fight_vo.attack.attack_pos_y = fight_msg.attack_y //技能的方向y
			fight_vo.attack.attack_angle = null //攻击朝向
			fight_vo.attack.buff_list = {}
			if (attacker_type == local_SceneBaseType.Partner) {
				fight_vo.attack.pos_x = fight_msg.pos_x //	  int:16 x 攻击方当前x坐标
				fight_vo.attack.pos_y = fight_msg.pos_y //	  int:16 y 攻击方当前y坐标
				let partner = scene.GetPartner(main_vo.role_id)
				if (partner && partner.vo) {
					main_vo = partner.vo
				}
			}
			if (attacker_type == local_SceneBaseType.Sprite) {
				fight_vo.attack.pos_x = fight_msg.pos_x //	  int:16 x 攻击方当前x坐标
				fight_vo.attack.pos_y = fight_msg.pos_y //	  int:16 y 攻击方当前y坐标
				let sprite = scene.GetSprite(main_vo.role_id)
				if (sprite && sprite.vo) {
					main_vo = sprite.vo
				}
			}
			if (!main_vo) {
				return
			}
			let skill_vo = skillMgr.getSkill(fight_msg.skill_id), skill_base_hurt_ratio = skill_vo ? skill_vo.getHurtRatio() : 0,
				// skill_stren_hurt = skillMgr.GetSkillStrenHurt(fight_msg.skill_id),
				//多个防守方伤害列表(群攻)
				defense, base_hurt, final_hurt, huixin_ratio, wreck_ratio, base_hunr_ratio, sum_ratio, ramdon_num
			skill_base_hurt_ratio = +skill_base_hurt_ratio * 0.0001
			for (let i = 0; i < fight_msg.monster_list.length; i++) {
				defense = FightVo.initDefend()
				fight_vo.defense_list.push(defense)
				defense.type_flag = local_SceneBaseType.Monster //  	int:8 1怪 2人
				defense.role_id = fight_msg.monster_list[i] //	   	int:64 防守ID
				let mon_vo = scene_mgr.GetMonsterVo(defense.role_id)
				if (mon_vo) {
					base_hurt = 0
					final_hurt = 0
					if (main_vo.wreck >= mon_vo.defend) {
						//（（攻击+破甲-对方防御）+元素攻击）*（基础技能伤害+技能伤害加深）*(rand()*0.1+0.95)
						base_hurt = (main_vo.att + main_vo.wreck - mon_vo.defend + main_vo.abs_att) * (skill_base_hurt_ratio + main_vo.skill_hurt_add_ratio) * (0.95 + local_Math.random() * 0.1)
					}
					else {
						//（（攻击*（0.5+0.5*max(破甲,1)/max(对方防御,1)））+元素攻击）*（基础技能伤害+技能伤害加深）*(rand()*0.1+0.95)
						base_hurt = ((main_vo.att * (0.5 + 0.5 * local_Math.max(main_vo.wreck, 1) / local_Math.max(mon_vo.defend, 1))) + main_vo.abs_att) * (skill_base_hurt_ratio + main_vo.skill_hurt_add_ratio) * (0.95 + local_Math.random() * 0.1)
					}
					//会心几率，如果触发会心，造成max（150%+会心伤害，120%）的伤害
					huixin_ratio = main_vo.hurt_float_ratio
					//暴击率=（暴击/（暴击+15000））*0.3+暴击几率，如果触发暴击，造成（200%+暴伤加深）的伤害
					wreck_ratio = (main_vo.wreck / (main_vo.wreck + 15000)) * 0.3 + main_vo.crit_ratio
					sum_ratio = huixin_ratio + wreck_ratio
					if (sum_ratio >= 1) {
						huixin_ratio = huixin_ratio / sum_ratio
						wreck_ratio = wreck_ratio / sum_ratio
						let ramdon_num = local_Math.random()
						if (ramdon_num >= huixin_ratio) {
							final_hurt = local_Math.max(1.5 + main_vo.HearHurtAddRatio, 1.2) * base_hurt
						}
						else {
							final_hurt = (2 + main_vo.crit_hurt_add_ratio) * base_hurt
						}
					}
					else {
						base_hunr_ratio = 1 - sum_ratio
						ramdon_num = local_Math.random()
						if (ramdon_num <= huixin_ratio) {
							final_hurt = local_Math.max(1.5 + main_vo.HearHurtAddRatio, 1.2) * base_hurt
						}
						else if (ramdon_num <= sum_ratio) {
							final_hurt = (2 + main_vo.crit_hurt_add_ratio) * base_hurt
						}
						else {
							final_hurt = base_hurt
						}
					}
					// final_hurt += skill_stren_hurt
					final_hurt = local_Math.floor(final_hurt)
					defense.hp = local_Math.max(0, mon_vo.hp - final_hurt) //	   	int:64 hp
					defense.damage = final_hurt //   	int:32 伤害
					defense.damage_flag = 0 //	int:8  状态(0正常减血，1躲避，2暴击，3免疫，4会心，5护盾免伤
				}
				else {
					fight_vo.defense_list.pop()
					continue
				}
				defense.anger = 0 // 	int:32 anger
				defense.pos_x = 0 //		int:16 x 防守方当前x坐标
				defense.pos_y = 0 //		int:16 y 防守方当前y坐标
				defense.move_anim = 1
				defense.breaked_skill_id = 0
				defense.buff_list = {}
			}
			fight_vo.protocal_type = 20001
			this.MergeFightDelayList()
			this.playFightMovie(fight_vo)
		}

		//主角攻击请求处理
		this.AttackRequest = (attacker: Character, skill_id, target_compress_id) => {
			if (attacker && typeof attacker == "number")
				attacker = null
			let main_role = scene.GetMainRole(),
				is_main_role_attack = (attacker == null || attacker == main_role)

			attacker = attacker ? attacker : main_role
			if (attacker == null)
				return

			skill_id = skill_id ? skill_id : this.GetFightSkill()
			if (!skill_id) {
				console.log("取不到技能ID")
				return
			}

			let skill_vo = skillMgr.getSkill(skill_id)
			if (!skill_vo) {
				console.log("技能vo为null：", skill_id, Status.NowTime)
				return
			}

			let skill_type = skill_vo.GetSkillType(), SkillType = SkillVo.SkillType
			if (skill_type == SkillType.Assist) {
				this.SendAssistSkill(attacker.id, skill_id)
				return
			}
			else if (is_main_role_attack && skill_type == SkillType.Initiative && !skill_vo.IsComboSkill()) // ) 
			{
				//每次释放主技能之前 先把受击者的被主角攻击的次数清掉
				scene_mgr.ResetMainRoleAttackerAttackCount()
				if (!this.BeforeRequestToFightHandler(skill_id))
					return
			}

			let movie_cfg = skillMgr.GetFightSkillMovie(skill_id),
				main_skill_id = null, //该技能的主技能  如果为null表示本身就是主技能  否则为副技能,
				mx = attacker.real_pos.x,
				my = attacker.real_pos.y,
				center_pos = { x: mx, y: my },
				px,
				py,
				att_dir = null,
				area = skill_vo.GetArea(),
				distance = skill_vo.GetDistance(),
				select_type = skill_vo.GetSelectType(),
				aoe_mode = skill_vo.GetAoeMode(),
				is_aoe_mode = skill_vo.IsAoeMode(),
				att_obj = skill_vo.GetSkillAttObj(),
				find_radian = null,
				find_distance = null,
				find_area = area,
				att_num = is_aoe_mode ? skill_vo.GetAttackNum() : [1, 1],
				rush_dist = movie_cfg.rush_dist ? movie_cfg.rush_dist : 0,
				joy_stick_dir = this.joy_stick_dir,
				//max_area是用来锁定需要选定目标的怪
				max_area = distance,
				pre_tar = null,
				//到场景里搜索可攻击对象 //
				monster_list: Array<any> = null, 
				role_list: Array<any> = null,
				//尝试取怪物
				left_mon_num = att_num[1] == 0 ? 99 : att_num[1],
				left_role_num = att_num[0] == 0 ? 99 : att_num[0],
				target_hiter

			if (skill_vo.IsComboSkill()) {
				main_skill_id = skillMgr.PackageMainSkillId(skill_id)
			}

			if (!is_main_role_attack || (skill_vo.IsComboSkill() && !movie_cfg.combo_independence)) {
				joy_stick_dir = null
			}

			// 兼容下目标类型
			if (joy_stick_dir == null && select_type != 1 && select_type != 3) {
				select_type = 2
			}

			// 用不到的先屏蔽
			// /***********找一个预攻击的的目标******/
			// if (joy_stick_dir && is_aoe_mode && aoe_mode == 1) {
			// 	//如果当前有用遥感且是一个圆形AOE技能的话,需要找一个预攻击的的目标
			// 	let [monster_list, role_list] = scene.FindTargets(FIND_TARGET_TYPE_all, 1, find_distance, find_area, att_dir, find_radian, center_pos, attacker, movie_cfg, select_type)[0]
			// 	if (monster_list && monster_list.length > 0)
			// 		pre_tar = monster_list[0]
			// 	else if (role_list && role_list.length > 0)
			// 		pre_tar = role_list[0]
			// }
			// if (!pre_tar) {
				if ((select_type == 2 || select_type == 3) && (!skill_vo.IsComboSkill() || movie_cfg.combo_independence)){
					pre_tar = scene.GetObjByCompressedId(target_compress_id) 
					if(!pre_tar){
						let [monster_list, role_list] = scene.FindTargets(FIND_TARGET_TYPE_all, 1, find_distance, find_area, att_dir, find_radian, center_pos, attacker, movie_cfg, select_type)
						if (monster_list && monster_list.length > 0)
							pre_tar = monster_list[0]
						else if (role_list && role_list.length > 0)
							pre_tar = role_list[0]
						// scene.FindTargetDir(max_area, attacker, select_type, movie_cfg.hiter_pos_type)
					}
				}
				else if(select_type == 1){
					pre_tar = Scene.GetInstance().GetMainRole()
				}
			// }
			/**************************************/

			//设置人物朝向
			if (movie_cfg.attacker_turn_back) {
				attacker.SetReverseDirection()
			}
			else if (pre_tar && pre_tar != attacker) {
				let t_pos = pre_tar.GetRealPos()
				let tx = t_pos.x, ty = t_pos.y
				let my_tem = my
				if (movie_cfg.hiter_pos_type == 1) { // 腰部
					ty = ty + pre_tar.GetBodyHeight() * 0.5
					my_tem = my_tem + attacker.GetBodyHeight() * 0.5
				}
				else if (movie_cfg.hiter_pos_type == 2) {
					ty = ty + pre_tar.GetBodyHeight()
					my_tem = my_tem + attacker.GetBodyHeight()
				}
				attacker.SetDirection(new local_Vector2(tx - mx, ty - my_tem), null, null, true)
			}
			else if (joy_stick_dir) {
				attacker.SetDirection(joy_stick_dir, null, null, true)
			}

			
			if (main_skill_id && !movie_cfg.combo_independence){
				//如果是副技能就用放主技能的时候玩家的朝向
				if (this.main_skill_dir[attacker.compress_id]) {
					//处理副技能的攻击方向 
					att_dir = this.main_skill_dir[attacker.compress_id][main_skill_id]
				}
				
				if (this.main_skill_pos[attacker.compress_id]) { 
					//如果是副技能就用放主技能的攻击点坐标位置
					let cache_pos = this.main_skill_pos[attacker.compress_id][main_skill_id]
					if (cache_pos) {
						center_pos.x = cache_pos.x
						center_pos.y = cache_pos.y
					}
				}
			}

			target_hiter = pre_tar

			att_dir = att_dir ? att_dir : attacker.GetDirection()
			if(is_aoe_mode){
				switch (aoe_mode) {
					case 1:
						if (pre_tar == null || att_obj == 1) {
							let dist = distance
							dist = GameMath.ChangeEllipseValue(att_dir, dist)
							if (movie_cfg.needCheckBlock) {
								[center_pos.x, center_pos.y] = SourceOperateMove.FindNearestPos(new local_Vector2(center_pos.x, center_pos.y), new local_Vector2(center_pos.x + att_dir.x * dist, center_pos.y + att_dir.y * dist))
							}
							else {
								center_pos.x = center_pos.x + att_dir.x * dist
								center_pos.y = center_pos.y + att_dir.y * dist //椭圆处理
							}
						}
						else //有目标怪
						{
							center_pos.x = pre_tar.x
							center_pos.y = pre_tar.y
						}
						break;
					case 2:
						find_distance = distance
						break;
					case 3:
						find_distance = distance
						find_radian = area * local_Math.PI / 180
						break;
					default:
						break;
				}
				if (left_mon_num > 0) {
					monster_list = scene.FindTargets(FIND_TARGET_TYPE_monster, left_mon_num, find_distance, find_area, att_dir, find_radian, center_pos, attacker, movie_cfg, select_type)[0]
				}
				if (left_role_num > 0) {
					role_list = scene.FindTargets(FIND_TARGET_TYPE_role, left_role_num, find_distance, find_area, att_dir, find_radian, center_pos, attacker, movie_cfg, select_type)[0]
				}
			}
			else{
				if(pre_tar){
					center_pos.x = pre_tar.x
					center_pos.y = pre_tar.y
				}
			}
			

			// if (rush_dist != 0) {
			// 	let newX = mx + att_dir.x * rush_dist
			// 	let newY = my + att_dir.y * rush_dist //椭圆处理
			// 	let [mx1, my1] = SourceOperateMove.FindNearestPos(new local_Vector2(mx, my), new local_Vector2(newX, newY))
			// 	mx = mx1
			// 	my = my1
			// 	px = mx
			// 	py = my
			// 	console.log("冲刺坐标点=", px, py, mx, my)
			// }

			let msg_info = fight_manager.request_fight_info_pool.shift()
			if (msg_info) {
				msg_info.attacker_type = attacker.GetType()
				msg_info.attacker_id = attacker.id
				msg_info.monster_list.length = 0
				msg_info.role_list.length = 0
				msg_info.skill_id = skill_id
				msg_info.pos_x = px ? px : mx
				msg_info.pos_y = py ? py : my
				msg_info.attack_x = px ? px : center_pos.x
				msg_info.attack_y = py ? py : center_pos.y
				msg_info.attack_angle = 0
				msg_info.move_anim = rush_dist != 0 ? 1 : 0
			}
			else
			{
				msg_info = {
					attacker_type: attacker.GetType(),
					attacker_id: attacker.id,
					monster_list: [],
					role_list: [],
					skill_id: skill_id,
					pos_x: px ? px : mx,
					pos_y: py ? py : my,
					attack_x: px ? px : center_pos.x,
					attack_y: py ? py : center_pos.y,
					attack_angle: 0,
					move_anim: rush_dist != 0 ? 1 : 0,
				}
			}


			let show_mainui_blood_hiter = target_hiter, monster
			if (show_mainui_blood_hiter == null)
				show_mainui_blood_hiter = pre_tar

			let has_target_hiter = false
			if (monster_list) {
				let target_hiter_index
				for (let i = 0; i < monster_list.length; i++) {
					monster = monster_list[i]
					if (target_hiter && target_hiter == monster) {
						target_hiter_index = i
						has_target_hiter = true
						msg_info.monster_list.unshift(monster.id)
					}
					else {
						if (!show_mainui_blood_hiter) {
							show_mainui_blood_hiter = monster
						}
						msg_info.monster_list.push(monster.id)
					}
				}
				if(target_hiter_index != null){
					monster_list.splice(target_hiter_index, 1)
					monster_list.unshift(target_hiter)
				}
			}

			//玩家列表
			if (role_list) {
				let target_hiter_index
				for (let i = 0; i < role_list.length; i++) {
					let role = role_list[i]
					if (target_hiter && target_hiter == role) {
						target_hiter_index = i
						has_target_hiter = true

						if (role.GetVo().is_fake_role)
							msg_info.monster_list.unshift(role.id)
						else
							msg_info.role_list.unshift(role.id)
						
					}
					else {
						if (!show_mainui_blood_hiter) {
							show_mainui_blood_hiter = role
						}

						if (role.GetVo().is_fake_role)
							msg_info.monster_list.push(role.id)
						else
							msg_info.role_list.push(role.id)
					}
				}
				if(target_hiter_index != null){
					role_list.splice(target_hiter_index, 1)

					if (target_hiter.GetVo().is_fake_role){
						monster_list = monster_list || []
						monster_list.unshift(target_hiter)
					}
					else{
						role_list.unshift(target_hiter)
					}
				}
			}

			if (show_mainui_blood_hiter) {
				let target = scene.GetClickTarget()
				if (!target || target == show_mainui_blood_hiter) {
					if (show_mainui_blood_hiter.GetType() == local_SceneBaseType.Monster) {
						let mon_vo = show_mainui_blood_hiter.GetVo()
						if (mon_vo.type_id == AutoBrushModel.AutoBrushMonsterId) {
							GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, mon_vo, AutoBrushModel.AutoBrushMonsterHpNum)
						}
						else {
							let config = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mon_vo.type_id, false) //Config.PRELOAD_SERVER_CONFIG.config_mon[mon_vo.type_id]
							if (config && config.boss >= FightController.SHOW_HP_BOSS_TYPE)
								GlobalEventSystem.Fire(EventName.SHOW_HITER_BIG_BLOOD_VIEW, true, mon_vo, config.hp_num)
						}
					}
					else if (show_mainui_blood_hiter.GetType() == local_SceneBaseType.Role) {
						if (scene_mgr.IsSafePos(show_mainui_blood_hiter.x, show_mainui_blood_hiter.y) && scene.GetClickTarget()) {
							scene.SetClickTarget(null)
							AutoFightManager.GetInstance().SetAutoFight(false)
							GlobalEventSystem.Fire(SceneEventType.CANCEL_TARGET)
							Message.show("对方正处于安全区内")
							return
						}
					}
				}
			}

			if (target_hiter && has_target_hiter == false) {
				if (target_hiter.GetType() != local_SceneBaseType.Role) {
					monster_list = monster_list || []
					monster_list.unshift(target_hiter)
					msg_info.monster_list.unshift(target_hiter.id)
				}
				else {
					if (target_hiter.GetVo().is_fake_role) {
						monster_list = monster_list || []
						monster_list.unshift(target_hiter)
						msg_info.monster_list.unshift(target_hiter.id)
					}
					else {
						role_list = role_list || []
						role_list.unshift(target_hiter)
						msg_info.role_list.unshift(target_hiter.id)
					}
				}
			}

			// 对于三连斩，每次放完技能，要递增一下三连斩的序号
			if (is_main_role_attack) {
				if (skillMgr.IsThreeAttackSkill(skill_id))
					skillMgr.IncreaseThreeAttackIndex(skill_id)
				else if (main_skill_id == null) // 主技能才要重置三连击
					skillMgr.ResetThreeAttackIndex()
			}

			if (main_skill_id == null) //如果该技能没有主技能id  说明该技能就是主技能  加入到主技能的攻击点列表
			{
				if (this.main_skill_pos[attacker.compress_id] == null)
					this.main_skill_pos[attacker.compress_id] = {}

				if (this.main_skill_pos[attacker.compress_id][skill_id]) {
					this.main_skill_pos[attacker.compress_id][skill_id].x = center_pos.x
					this.main_skill_pos[attacker.compress_id][skill_id].y = center_pos.y
				}
				else
					this.main_skill_pos[attacker.compress_id][skill_id] = new local_Vector2(center_pos.x, center_pos.y)


				if (this.main_skill_dir[attacker.compress_id] == null)
					this.main_skill_dir[attacker.compress_id] = {}

				let dir = attacker.GetDirection()
				if (this.main_skill_dir[attacker.compress_id][skill_id]) {
					this.main_skill_dir[attacker.compress_id][skill_id].x = dir.x
					this.main_skill_dir[attacker.compress_id][skill_id].y = dir.y
				}
				else
					this.main_skill_dir[attacker.compress_id][skill_id] = new local_Vector2(dir.x, dir.y)
			}

			//客户端预播技能
			monster_list = monster_list || []
			this.ClientPrePlayFightMovie(skill_id, monster_list, role_list, msg_info, attacker)
			this.final_fight_time = Status.NowTime
		}

		this.ClientPrePlayFightMovie = (skill_id, monster_list, role_list, msg_info, attacker) => {
			let cfg = skillMgr.GetFightSkillMovie(skill_id)
			if (cfg == null)
				return

			let attacker_info = {
				pos_x: msg_info.pos_x,
				pos_y: msg_info.pos_y,
				attack_pos_x: msg_info.attack_x,
				attack_pos_y: msg_info.attack_y,
				move_anim: msg_info.move_anim,
			}

			let defender_info_list = []
			let is_attack_role = false

			if (!monster_list) {
				monster_list = role_list
			}
			else {
				if (role_list) {
					for (let i = 0; i < role_list.length; i++) {
						monster_list.push(role_list[i])
						is_attack_role = true
					}
				}
			}
			if (cfg.need_hited_to_release && (!monster_list || monster_list.length == 0))
				return

			let fight_info: FightMovieInfo = fight_manager.fightMovie_pool.shift() || new local_FightMovieInfo()
			fight_info.InitData(skill_id, attacker, attacker_info, monster_list, defender_info_list, true, msg_info)

			if (fight_info.PlayActions() && attacker.GetType() == local_SceneBaseType.MainRole) {
				// if (is_attack_role) {
				// 	attacker.EnterFightingState(6)
				// }
				// else {
				attacker.EnterFightingState(6)
				// }
			}
			this.fight_info_list.push(fight_info)

			//如果配置填了弹道，就创建子弹对象
			if (cfg.BulletInfo && !cfg.BulletInfo.start_by_server_back && fight_info.show_particle) {
				// fight_info.SendMsg()
				this.CreateBullet(cfg.BulletInfo, attacker, monster_list, msg_info.ignore_damage_time, skill_id)
			}

			// //扇形攻击信息
			// if(cfg.SectorAttackInfo && fight_info.show_particle){
			// 	this.CreateSectorObj(skillId, attacker)
			// }
		}
		//客户端假人战斗
		this.ClientVirtualRolePlayFightMovie = (skill_id, attacker) => {
			let fight_info: FightMovieInfo = fight_manager.fightMovie_pool.shift() || new local_FightMovieInfo()
			let attacker_info = {
				pos_x: attacker.x,
				pos_y: attacker.x,
				attack_pos_x: attacker.x,
				attack_pos_y: attacker.y,
				move_anim: 0,
			}
			fight_info.InitData(skill_id, attacker, attacker_info, null, null, false, null)
			fight_info.PlayActions()
			this.fight_info_list.push(fight_info)
			let cfg = skillMgr.GetFightSkillMovie(skill_id)
			//如果配置填了弹道，就创建子弹对象
			if (cfg.BulletInfo && !cfg.BulletInfo.start_by_server_back && fight_info.show_particle)
				this.CreateBullet(cfg.BulletInfo, attacker, null)
			// //扇形攻击信息
			// if cfg.SectorAttackInfo and fight_info.show_particle then
			//	 this.CreateSectorObj(skillId, attacker)
			// end
		}
		this.GetAttackerFromVo = (fightVo) => {
			let role
			switch (fightVo.attack.attacker_type) {
				case local_SceneBaseType.Monster:
					return scene.GetMonster(fightVo.attack.role_id)
				case local_SceneBaseType.Role:
				case local_SceneBaseType.Fake_Role:
					return scene.GetRole(fightVo.attack.role_id)
				case local_SceneBaseType.Partner:
					role = scene.GetRole(fightVo.attack.role_id)
					return role && role.partner
				case local_SceneBaseType.Sprite:
					role = scene.GetRole(fightVo.attack.role_id)
					return role && role.sprite
				case local_SceneBaseType.Demon:
					role = scene.GetRole(fightVo.attack.role_id)
					return role && role.demon
				default:
					return;
			}
		}
		this.GetDefenderListFromVo = (fightVo, defender_list, info_list, attacker?) => {
			// defender_list = [],
			// info_list = []
			for (let i = 0; i < fightVo.defense_list.length; i++) {
				let defense = fightVo.defense_list[i], defense_obj = null
				if (defense.type_flag == local_SceneBaseType.Monster) //   	int.8 1怪 2人
					defense_obj = scene.GetMonster(defense.role_id)
				else if (defense.type_flag == local_SceneBaseType.Role || defense.type_flag == local_SceneBaseType.Fake_Role)
					defense_obj = scene.GetRole(defense.role_id)
				if (attacker && defense.type_flag == local_SceneBaseType.Role && defense.hp == 0 && defense.id == RoleManager.Instance.GetMainRoleId() && RoleManager.Instance.mainRoleInfo.hp > 0) {
					let killerId = fightVo.attack.role_id
					scene_mgr.SetKillerInfo(attacker.GetType(), killerId)
				}
				if (defense_obj != null) {
					defender_list.push(defense_obj)
					info_list.push(defense)
				}
			}
			// return [defender_list, info_list]
		}
		this.RefreshObjVo = (defender_list, defender_info_list, attacker, attacker_vo) => {
			if (attacker) {
				let obj_vo = attacker.GetVo()
				if (attacker_vo.hp)
					obj_vo.ChangeVar("hp", attacker_vo.hp)
				if (attacker_vo.pos_x && attacker_vo.pos_y && (attacker_vo.pos_x != 0 || attacker_vo.pos_y != 0))
					attacker.SetRealPos(attacker_vo.pos_x, attacker_vo.pos_y)
				if (attacker_vo.hp == 0)
					attacker.ForceDoDead()
			}
			for (let i = 0; i < defender_list.length; i++) {
				let defender = defender_list[i], defender_info = defender_info_list[i]
				if (defender != null && !defender.IsDead()) {
					let obj_vo = defender.GetVo()
					if (defender_info.hp)
						obj_vo.ChangeVar("hp", defender_info.hp)
					if (defender_info.pos_x && defender_info.pos_y && (defender_info.pos_x != 0 || defender_info.pos_y != 0) &&
						defender_info.move_anim && defender_info.move_anim > 0)
						defender.SetRealPos(defender_info.pos_x, defender_info.pos_y)
					if (defender_info.hp == 0)
						defender.ForceDoDead()
				}
			}
		}
		this.playFightMovie = (fightVo) => {

			// console.trace()
			let defender_list = [], defender_info_list = [], attacker: SceneObj = this.GetAttackerFromVo(fightVo), skill_id = fightVo.attack.skill_id, skill_vo = skillMgr.getSkill(skill_id), recreate_attacker = false, cfg = skillMgr.GetFightSkillMovie(skill_id), is_mainRole_defender = fightVo.attack.is_mainRole_defender
			this.GetDefenderListFromVo(fightVo, defender_list, defender_info_list, attacker)
			if (skill_vo == null) {
				console.log("!!!!!!!!!!!!!!!!!!!!找不到后台技能id" + skill_id)
				return
			}
			if (!attacker) {
				if (fightVo.attack.attacker_type == local_SceneBaseType.Role || fightVo.attack.attacker_type == local_SceneBaseType.Fake_Role) {
					scene_mgr.ImmeAddRoleVo(fightVo.attack.role_id)
					attacker = scene.GetRole(fightVo.attack.role_id)
					recreate_attacker = true
				}
				if (!attacker) {
					this.RefreshObjVo(defender_list, defender_info_list, attacker, fightVo.attack)
					return
				}
			}
			if (is_mainRole_defender) {
			}
			if (attacker.GetType() == local_SceneBaseType.Role && is_mainRole_defender) {
				scene_mgr.AddMainRoleDefender(attacker.id)
				if (recreate_attacker)
					GlobalEventSystem.Fire(SceneEventType.UPDATE_ROLE_LIMIT)
			}
			else if (attacker.GetType() == local_SceneBaseType.MainRole) {
				if (scene_mgr.IsPKScene()) {
					for (let obj of defender_list) {
						scene_mgr.AddMainRoleAttacker(obj.id, skill_id)
					}
				}
				if (scene_mgr.IsExpDungeon()) {
					for (let obj of defender_info_list) {
						if (obj.hp <= 0)
							scene_mgr.AddMainRoleKillCount(obj.type_flag)
					}
				}
			}
			let fight_info = fight_manager.fightMovie_pool.shift() || new local_FightMovieInfo()
			fight_info.InitData(skill_id, attacker, fightVo.attack, defender_list, defender_info_list)
			fight_info.PlayActions()
			this.fight_info_list.push(fight_info)
			if (fight_info.show_particle && attacker.GetType() != local_SceneBaseType.MainRole) {
				if (cfg.BulletInfo)
					this.CreateBullet(cfg.BulletInfo, attacker, defender_list)
				// elseif cfg.SectorAttackInfo then
				//	 this.CreateSectorObj(skill_id, attacker)
				// end
			}
			if (attacker.GetType() == local_SceneBaseType.MainRole && cfg.BulletInfo && cfg.BulletInfo.start_by_server_back)
				this.CreateBullet(cfg.BulletInfo, attacker, defender_list)
			fight_manager.pushFightVo(fightVo)
		}
		this.CreateBullet = (binfo, attacker: SceneObj, defender_list: Array<any>, ignore_damage_time = false, main_skill_id = 0) => {
			let self = this
			let timer_id = self.bullet_timer_id
			let create_num = binfo.create_bullet_num || 1
			self.bullet_timer_id = self.bullet_timer_id + 1
			let pre_tar
			if (!defender_list || defender_list.length <= 0) {
				let [monster_list, role_list] = scene.FindTargets(FIND_TARGET_TYPE_all, 1, 0, 1500, null, null, null, attacker)
				if (monster_list && monster_list.length) {
					pre_tar = monster_list[0]
				}
				else if (role_list && role_list.length) {
					pre_tar = role_list[0]
				}
				else {
					return
				}
			}
			else {
				pre_tar = defender_list[0]
			}
			let move_dir = new local_Vector2(pre_tar.x - attacker.real_pos.x, pre_tar.y - attacker.real_pos.y)
			if (move_dir.x == 0 && move_dir.y == 0) {
				move_dir.x = 0
				move_dir.y = -1
			}
			move_dir.normalise()
			let is_first_bullet = true
			//创建弹道的方法
			let create_bullet_func = (curr_move_dir, start_time) => {
				let bullet: BulletObj = fight_manager.bullet_pool.shift() || new local_BulletObj()
				bullet.SetData(attacker.compress_id, binfo.skill_id, binfo.live_time, binfo.move_speed, curr_move_dir, binfo.delta_time, start_time, binfo.offset_dist, binfo.attach_type, binfo.dir_3d_start_angle, is_first_bullet, binfo.damage_offset_dist, ignore_damage_time, main_skill_id)
				bullet.SetParticleRes(binfo.particles_res)
				self.bullet_list.push(bullet)
				create_num = create_num - 1
				// if (create_num <= 0)
				//	 let timer = self.bullet_timer_list[timer_id]
				//	 if (timer)
				//	 {
				//	 }
				//		 TimerQuest.CancelQuest(GlobalTimerQuest, timer)
				//		 self.bullet_timer_list[timer_id] = nil
				//	 end
				// end
			}
			if (create_num > 1) {
				let is_random_time = binfo.create_bullet_time || 0
				if (is_random_time) {
					let circle_num = local_Math.floor(create_num / 3)
					let source_angle = GameMath.VectorToAngle(move_dir)
					let curr_angle
					let start_time
					if (ignore_damage_time) {
						start_time = -is_random_time
					}
					else {
						start_time = binfo.start_time - is_random_time
					}
					for (let i = 0; i < circle_num; i++) {
						start_time += is_random_time
						create_bullet_func(move_dir, start_time)
						is_first_bullet = false
						if (create_num <= 0)
							return
						start_time += is_random_time
						curr_angle = source_angle + binfo.create_bullet_angle
						create_bullet_func(GameMath.AngleToVector(curr_angle), start_time)
						if (create_num <= 0)
							return
						start_time += is_random_time
						curr_angle = source_angle - binfo.create_bullet_angle
						create_bullet_func(GameMath.AngleToVector(curr_angle), start_time)
						if (create_num <= 0)
							return
					}
				}
				else {
					let circle_num = local_Math.floor(create_num / 2)
					let is_even = create_num % 2 == 1 //是否基数
					let step = 0.5
					let start_time = binfo.start_time
					if (ignore_damage_time) {
						start_time = 0
					}
					if (is_even) {
						step = 1
						create_bullet_func(move_dir, start_time)
						is_first_bullet = false
					}
					let source_angle = GameMath.VectorToAngle(move_dir)
					let curr_angle
					for (let i = 0; i < circle_num; i++) {
						curr_angle = source_angle + binfo.create_bullet_angle * (i + step)
						create_bullet_func(GameMath.AngleToVector(curr_angle), start_time)
						is_first_bullet = false
						curr_angle = source_angle - binfo.create_bullet_angle * (i + step)
						create_bullet_func(GameMath.AngleToVector(curr_angle), start_time)
					}
				}
			}
			else {
				create_bullet_func(move_dir, binfo.start_time)
			}
			// if (binfo.move_type == BulletObj.BulletMoveType.Direction)
			// {
			// if create_num > 0 then
			//	 let create_delta = binfo.create_bullet_delta
			//	 let timer = TimerQuest.AddPeriodQuest(GlobalTimerQuest, create_bullet_func, create_delta, binfo.create_bullet_num * create_delta)
			//	 self.bullet_timer_list[timer_id] = timer
			// end
			// }
		}
		this.GetFightSkill = () => {
			let roleBaseInfo = RoleManager.Instance.mainRoleInfo, skillId = null, skillVo = skillMgr.getCurrentSkill()
			if (skillVo && skillMgr.IsThreeAttackSkill(skillVo.id))
				skillVo = skillMgr.getSkill(skillMgr.GetBaseSkill()) //获取下一个基本技能id
			if (!skillVo)
				skillId = skillMgr.GetBaseSkill()
			else
				skillId = skillVo.id
			if (!skillMgr.IsThreeAttackSkill(skillId))
				if (skillId == 0) {
					console.log("你还没有学习任何技能，不能发起战斗")
					return null
				}
			return skillId
		}
		this.SendAssistSkill = (role_id, skill_id) => {
			let attacker = scene.GetRole(role_id)
			if (attacker.GetType() == local_SceneBaseType.MainRole)
				if (!this.BeforeRequestToFightHandler(skill_id))
					return
			let attacker_info = {
				pos_x: attacker.real_pos.x,
				pos_y: attacker.real_pos.y,
				attack_pos_x: attacker.real_pos.x,
				attack_pos_y: attacker.real_pos.y
			}
			let fight_info = fight_manager.fightMovie_pool.shift() || new local_FightMovieInfo()
			fight_info.InitData(skill_id, attacker, attacker_info, null, null, true, null)
			fight_info.PlayActions()
			this.fight_info_list.push(fight_info)
			this.SendFmtToGame(20006, "li", role_id, skill_id)
			skillMgr.AddReleaseMainSkill(skill_id)
			console.log("发送辅助技能skill_id=", skill_id)
		}
		//请求战斗之前的操作
		this.BeforeRequestToFightHandler = (skill_id) => {
			scene.main_role.buff_manager.RemoveBuff(SkillBuffType.COMBO_SKILL, skill_id)
			return true
		}
		this.RegisterAllProtocals()
		this.AddAllEvents()
		Runner.GetInstance().AddRunObjByHashCode(this._hash_target.hashCode, this, 1, FRAME_TYPE.total)
	}
}

window["FightController"] = FightController