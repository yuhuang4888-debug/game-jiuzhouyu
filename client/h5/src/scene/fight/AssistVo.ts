import { UserMsgAdapter } from "../../common/UserMsgAdapter";
import { FightVo } from "./FightVo";
import { Util } from "../../util/Util";
// TypeScript file
export class AssistVo {
	attack;
	defense_list = [];
	public constructor() {
		this.attack = {
			role_id: 0,
			attacker_type: 0,
			skill_id: 0,
			skill_level: 0,
		};
	}
	public ReadFromProtocal() {
		let attack = this.attack;
		let u_mgr = UserMsgAdapter.GetInstance();
		[attack.role_id,
			attack.attacker_type,
			attack.skill_id,
			attack.skill_level] = //int8  技能等级
			u_mgr.ReadFmt("lcic");
		let defense_num = u_mgr.ReadFmt("h");
		// print("defense_num = ",defense_num)
		let defense = null;
		for (let i = 0; i < defense_num; i++) {
			defense = {
				type_flag: u_mgr.ReadFmt("c"),
				role_id: u_mgr.ReadFmt("l"),
				hp: u_mgr.ReadFmt("l"),
				buff_list: {},
			};
			this.defense_list[i] = defense;
			//防守方buff列表
			let buff_num = u_mgr.ReadFmt("h");
			// print("= = = = =防守方 buff列表：", buff_num)
			let buff = null;
			for (let i = 0; i < buff_num; i++) {
				buff = FightVo.initBuff();
				[buff.iconType,
					buff.buff_effect_id,
					buff.id,
					buff.level,
					buff.diejia,
					buff.integer,
					buff.decimals,
					buff.period] = //int:64 到期unix时间戳, 客户端显示要用这个时间-服务端时间
					u_mgr.ReadFmt("hhiccIIl");
				buff.decimals = Util.UnsignToSigned(buff.decimals);
				if (defense.buff_list[buff.iconType] == null)
					defense.buff_list[buff.iconType] = {};
				defense.buff_list[buff.iconType][buff.id] = buff;
			}
		}
	}
}

window["AssistVo"] = AssistVo