import { RoleManager } from "../../commonModel/RoleManager";
import { UserMsgAdapter } from "../../common/UserMsgAdapter";
import { Util } from "../../util/Util";
import { SceneManager } from "../SceneManager";
import { TimeUtil } from "../../util/TimeUtil";
import { Status } from "../../util/Status";
// TypeScript file
let local_Util = Util
let local_SceneManager
let local_RoleManager = RoleManager
let local_UserMsgAdapter = UserMsgAdapter
export class FightVo {
	attack = FightVo.initAttack();
	attack_trigger_skill_list = [];
	defense_list = [];
	main_id;
	protocal_type
	public constructor() {
		local_SceneManager = SceneManager
		this.main_id = local_RoleManager.GetInstance().GetMainRoleId();
	}
	public resetData() {
		this.attack.is_mainRole_defender = false;
		this.attack.buff_list = {};
		this.defense_list.length = 0;
		this.attack_trigger_skill_list.length = 0
		this.protocal_type = null
	}
	public static initAttack() {
		return { attacker_type: 0,
			role_id: 0,
			move_anim: 0,
			hp: 0,
			anger: 0,
			skill_id: 0,
			skill_level: 0,
			pos_x: 0,
			pos_y: 0,
			attack_pos_x: 0,
			attack_pos_y: 0,
			attack_angle: 0,
			is_mainRole_defender: false,
			buff_list: {}
		};
	}
	public static initDefend() {
		return { type_flag: 0,
			role_id: 0,
			move_anim: 0,
			breaked_skill_id: 0,
			hp: 0,
			anger: 0,
			damage: 0,
			damage_flag: 0,
			pos_x: 0,
			pos_y: 0,
			c_id: 0,
			buff_list: {}
		};
	}
	public static initBuff() {
		return { iconType: 0,
			buff_effect_id: 0,
			id: 0,
			level: 0,
			diejia: 0,
			integer: 0,
			decimals: 0,
			period: 0,
			pos_x: 0,
			pos_y: 0 };
	}
	public ReadFromProtocal() {
		let self = this, fight_vo = local_FightVo, 
			attack = self.attack, 
			u_mgr = local_UserMsgAdapter.GetInstance();
		
		[
			attack.attacker_type,
			attack.role_id,
			attack.hp,
			attack.anger,
			attack.move_anim,
			attack.skill_id,
			attack.skill_level,
			attack.pos_x,
			attack.pos_y,
			attack.attack_pos_x,
			attack.attack_pos_y,
			attack.attack_angle] = //攻击朝向
			u_mgr.ReadFmt("cllicihhhhhh");
		//攻击方buff列表
		let attack_buff_num = u_mgr.ReadFmt("h"), buff = null;
		// console.log("= = = = =攻击方 buff列表：", attack.move_anim,attack_buff_num,attack.pos_x,attack.pos_y)
		for (let i = 0; i < attack_buff_num; i++) {
			buff = fight_vo.initBuff();
			[buff.iconType,
				buff.buff_effect_id,
				buff.id,
				buff.level,
				buff.diejia,
				buff.integer,
				buff.decimals,
				buff.period] = //int:64 到期unix时间戳, 客户端显示要用这个时间-服务端时间
				u_mgr.ReadFmt("hhiccIIl");
			buff.decimals = local_Util.UnsignToSigned(buff.decimals);
			if (attack.buff_list[buff.iconType] == null)
				attack.buff_list[buff.iconType] = {};
			attack.buff_list[buff.iconType][buff.id] = buff;
			buff.pos_x = attack.attack_pos_x;
			buff.pos_y = attack.attack_pos_y;
			// console.warn("攻击方buff", buff.iconType, buff.id, buff.buff_effect_id, buff.integer, buff.decimals, buff.period, TimeUtil.getClientTime())
		}

		let attack_trigger_skill_num = u_mgr.ReadFmt("h")
		for (let i = 0; i < attack_trigger_skill_num; i++) {
			this.attack_trigger_skill_list.push(u_mgr.ReadFmt("i"))
		}

		for (let i = 0; i < attack_buff_num; i++) {
			buff = fight_vo.initBuff();
		}

		//多个防守方伤害列表(群攻)
		let defense_num = u_mgr.ReadFmt("h"), defense, buff_num;
		// console.warn("= = = = =防守者数量：", defense_num)
		for (let i = 0; i < defense_num; i++) {
			defense = fight_vo.initDefend();
			self.defense_list.push(defense);
			[	
				defense.type_flag,
				defense.role_id,
				defense.hp,
				defense.anger,
				defense.damage,
				defense.damage_flag,
				defense.second_damage_flag,
				defense.pos_x,
				defense.pos_y,
				defense.move_anim,
				defense.breaked_skill_id
			] = u_mgr.ReadFmt("clliicchhci");
			// console.log("breaked_skill_id=",defense.breaked_skill_id)
			// console.log("= = = = =防守方坐标：", defense.pos_x, defense.pos_y)
			// console.warn("=防守者信息", defense.role_id,attack.skill_id, defense.hp, defense.damage, defense.damage_flag, Status.NowTime,defense.pos_x,defense.pos_y)
			// GlobalEventSystem.Fire(NineSkyModel.NINE_SKY_FIGHTING_MSG,attack.role_id,defense.role_id)
			if (defense.role_id == self.main_id) {
				// self.main_vo.mainRoleInfo.behit = self.main_vo.mainRoleInfo.behit + 1
				attack.is_mainRole_defender = defense.damage ? true : false;
				// local_SceneManager.Instance.SetLastAttackerInfo(attack.attacker_type, attack.role_id)
				if (defense.hp == 0)
					local_SceneManager.Instance.SetKillerInfo(attack.attacker_type, attack.role_id);
			}
			buff_num = u_mgr.ReadFmt("h");
			// console.log("= = = = =防守方 buff列表：", buff_num, defense.type_flag, defense.role_id)
			for (let i = 0; i < buff_num; i++) {
				buff = fight_vo.initBuff();
				[buff.iconType,
					buff.buff_effect_id,
					buff.id,
					buff.level,
					buff.diejia,
					buff.integer,
					buff.decimals,
					buff.period] = //int.64 到期unix时间戳, 客户端显示要用这个时间-服务端时间
					u_mgr.ReadFmt("hhiccIIl");
				buff.decimals = local_Util.UnsignToSigned(buff.decimals);
				if (defense.buff_list[buff.iconType] == null)
					defense.buff_list[buff.iconType] = {};
				defense.buff_list[buff.iconType][buff.id] = buff;
			}
		}
	}
}
var local_FightVo = FightVo
window["FightVo"] = FightVo