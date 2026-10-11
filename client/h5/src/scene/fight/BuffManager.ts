import { EventDispatcher } from "../../util/EventDispatcher";
import { BuffListVo } from "./BuffListVo";
import { SceneBaseType } from "../SceneConfig";
import { Util } from "../../util/Util";
import { TimeUtil } from "../../util/TimeUtil";
import { FightManager } from "./FightManager";
import { Status } from "../../util/Status";
import { GlobalEventSystem, LOAD_QUEUE } from "../../util/DeclareGlobalVar";
import { EventName } from "../../common/EventName";
import { PoseState } from "../../util/StateMachineManager";
import { ResManager } from "../../common/ResManager";
// TypeScript file
export enum SkillBuffType {
	FEAR = 15, //恐惧
    ATT_SPEED = 30, //攻速加成
    UN_DIE = 38,//不死
	SPEED_ADD = 18,//加速
	HUNLUAN = 130,//混乱 // 等于服务端的恐惧
	
	
	//下面是用到的
    YUN = 101,//眩晕
    CHENMO = 102,//沉默
    DINGSHEN = 103,//定身
    SHIELD = 104, //护盾
    SHIELD_TIMES = 105, //护盾次数
    UNBEATABLE = 106,//无敌
    NODAMAGE = 107, //免伤
    NOEFFECT = 108,//霸体
    RESIST_SPEED = 109, //减速免疫
    RESIST_YUN = 110, //晕眩免疫
    RESIST_BLOOD = 111, //流血免疫
    SUCK_BLOOD = 114, //吸血
    REVERT_DAMAGE = 115, //反弹伤害
    CHANGE_HP_AC_LIM = 116, //回血治疗
    BLEEDING = 117,//流血
    CLEAR_NEGATIVE_BUFF = 118, //清除负面buff
    SPEED_DEL = 121,//移动速度
	TIANFU_BLOOD = 133,//移动速度
    
    
	
	COMBO_SKILL = 200,//副技能

    //-下面是老BUFF

    CHAOFENG = 996,//嘲讽
    FANTAN = 995,//反弹
    LOCK_CD = 994,//锁cd
    TUIDING = 993,//推顶
    CLEAR_CD = 992, //清cd 整形是技能id
    HIT_HEIGHT = 991,//浮空
    HIT_HEIGHT_AGAIN = 990,//继续悬空
    CHANGE_DIR_WHEN_ATTACK = 989,//攻击僵直时间内可以改变方向
    ATTACK_TIMES = 987, //同一副技能攻击次数
    FORM = 985,//形态
    CHANRAO = 998,//缠绕
    MABI = 999,//麻痹
    ASSIST_SKILL = 300,//辅助技能
}
window["SkillBuffType"] = SkillBuffType;
let local_SceneBaseType = SceneBaseType
let local_TimeUtil = TimeUtil
let local_FightManager = FightManager
let local_BuffListVo = BuffListVo
let local_PoseState = PoseState
let local_Status = Status
export class BuffManager extends EventDispatcher {
	character;
	update_buff_icon_time;
	buffDic: {
		[key: number]: BuffListVo;
	} = {};
	skill_buff_type = SkillBuffType;
	public constructor(character) {
		super();
		this.character = character;
	}
	public IsMainRole() {
		if (this.character && (this.character.GetType() == local_SceneBaseType.MainRole))
			return true;
	}
	public DeleteMe() {
		this.character = null;
		this.buffDic = null;
	}
	// public hasLockCDBuff() {
	//	 return (this.buffDic[this.skill_buff_type.LOCK_CD])
	// }
	// public hasForbitJumpBuff() {
	//	 return (this.buffDic[this.skill_buff_type.FORBIT_JUMP] != null)
	// }
	// public hasClearCDBuff() {
	//	 return (this.buffDic[this.skill_buff_type.CLEAR_CD])
	// }
	// public hasChangeDirWhenAttackBuff() {
	//	 return (this.buffDic[this.skill_buff_type.CHANGE_DIR_WHEN_ATTACK])
	// }
	// //反弹buff
	// public hasFantanBuff() {
	//	 return (this.buffDic[this.skill_buff_type.FANTAN])
	// }
	//形态buff
	// public hasFormBuff() {
	//	 return (this.buffDic[this.skill_buff_type.FORM])
	// }
	public hasNoEffectBuff() {
		return (this.buffDic[this.skill_buff_type.NOEFFECT]);
	}
	public hasSpeedBuff() {
		return (this.buffDic[this.skill_buff_type.SPEED_DEL] || this.buffDic[this.skill_buff_type.SPEED_ADD])
	}
	// public hasHitHeightBuff() //是否有悬空buff
	// {
	//	 return (this.buffDic[this.skill_buff_type.HIT_HEIGHT])
	// }
	// public hasHitHeightAgainBuff() //是否有继续悬空buff
	// {
	//	 return (this.buffDic[this.skill_buff_type.HIT_HEIGHT_AGAIN])
	// }
	// //得到悬空的持续时间
	// public GetHitHeightLastTime() {
	//	 let last_time = 0
	//	 let buff_vo_list = this.buffDic[this.skill_buff_type.HIT_HEIGHT]
	//	 if (buff_vo_list)
	//		 last_time = buff_vo_list.GetMaxLastTime()
	//	 buff_vo_list = this.buffDic[this.skill_buff_type.HIT_HEIGHT_AGAIN]
	//	 if (buff_vo_list)
	//		 last_time = Math.max(last_time, buff_vo_list.GetMaxLastTime())
	//	 return last_time
	// }
	public hasUnbeatableBuff() {
		return (this.buffDic[this.skill_buff_type.UNBEATABLE]);
	}
	// public getBuffSpeed() //有速度buff的时候求出速度值
	// {
	//	 let buff_vo_list = this.buffDic[this.skill_buff_type.SPEED]
	//	 if (buff_vo_list)
	//		 return buff_vo_list.GetValue(this.character.vo.move_speed)
	//	 return this.character.vo.move_speed ? this.character.vo.move_speed : 0
	// }
	// public hasAttSpeedBuff() //是否有攻速加成buff
	// {
	//	 return (this.buffDic[this.skill_buff_type.ATT_SPEED])
	// }
	// public getAttSpeed() //求出攻速
	// {
	//	 let buff_vo_list = this.buffDic[this.skill_buff_type.ATT_SPEED]
	//	 if (buff_vo_list)
	//		 return buff_vo_list.GetValue(this.character.vo.att_speed)
	//	 return this.character.vo.att_speed ? this.character.vo.att_speed : 0
	// }
	public hasYunBuff() {
		return (this.buffDic[this.skill_buff_type.YUN]);
	}
	// public hasMabiBuff() //是否有麻痹buff
	// {
	//	 return (this.buffDic[this.skill_buff_type.MABI])
	// }
	public hasDingshenBuff() {
		return (this.buffDic[this.skill_buff_type.DINGSHEN]);
	}
	// public hasHunluanBuff() //是否有混乱buff
	// {
	//	 return (this.buffDic[this.skill_buff_type.HUNLUAN])
	// }
	// public hasChaofengBuff() {
	//	 return (this.buffDic[this.skill_buff_type.CHAOFENG])
	// }
	// public hasChanraoBuff() {
	//	 return (this.buffDic[this.skill_buff_type.CHANRAO])
	// }
	// public hasTuidingBuff() {
	//	 return (this.buffDic[this.skill_buff_type.TUIDING])
	// }
	public getBuffDic(iconType) {
		return this.buffDic[iconType];
	}
	public addRoleBuffList(buff_list, breaked_skill_id) {
		if (Util.IsTableEmpty(buff_list))
			return;
		//注意：如果服务端发来的列表里已经有些buff没有了，就要和本地的列表比较，以便进行StopTrigger
		let self = this, del_list: {
			[key: number]: BuffListVo;
		} = {}, del_list_vo = null, 
		//是否只是增加buff 没有减少buff  有减少的话就不要调用buffchange update的时候自然会调用
		only_add_buff = false, buff_vo_list = null, list, vo;
		for (let iconType in self.buffDic) {
			del_list_vo = del_list[iconType];
			if (del_list_vo == null) {
				del_list_vo = {};
				del_list[iconType] = del_list_vo;
			}
			for (let id in self.buffDic[iconType].buff_list)
				del_list_vo[id] = self.buffDic[iconType].buff_list[id];
		}
		//新触发的技能id列表
		let trigger_skill_dic
		for (let iconType in buff_list) {
			list = buff_list[iconType];
			for (let skill_id in list) {
				vo = list[skill_id];
				buff_vo_list = self.buffDic[iconType];
				if (vo.period - local_TimeUtil.getServerTimeMs() > 0) {
					if (del_list && del_list[iconType])
						delete del_list[iconType][skill_id];
					if (buff_vo_list == null) {
						only_add_buff = true;
						buff_vo_list = local_FightManager.GetInstance().buffVo_list_pool.shift() || new local_BuffListVo();
						buff_vo_list.initData(self, self.character);
						self.buffDic[iconType] = buff_vo_list;
					}
					if(buff_vo_list.AddBuffVo(vo)){
						if(!trigger_skill_dic){
							trigger_skill_dic = {}
						}
						trigger_skill_dic[vo.id] = true
					}
				}
			}
		}
		if(trigger_skill_dic && this.IsMainRole()){
			// for(let skill_id in trigger_skill_dic){
				// if(window["FightDamageManager"]){
				// 	window["FightDamageManager"].GetInstance().ShowSkillImg(skill_id, null, 2);
				// }
			// }

		}
		//删除原来有用，现在被服务器排除掉的buff
		if (del_list) {
			for (let iconType in del_list) {
				list = del_list[iconType];
				if (!self.IsMainRole() || Number(iconType) != self.skill_buff_type.COMBO_SKILL || (breaked_skill_id && breaked_skill_id > 0)) {
					buff_vo_list = self.buffDic[iconType];
					if (buff_vo_list) {
						for (let skill_id in list) {
							vo = list[skill_id];
							buff_vo_list.DeleteBuffVo(vo);
							only_add_buff = false;
						}
					}
				}
			}
		}
		if (only_add_buff)
			self.BuffChange();
	}
	//删除全部buff
	public removeAllSkillBuff() {
		let buff_vo_list = null;
		let vo;
		for (let iconType in this.buffDic) {
			buff_vo_list = this.buffDic[iconType];
			for (let id in buff_vo_list.buff_list) {
				buff_vo_list.DeleteBuffVo(buff_vo_list.buff_list[id]);
			}
		}
	}
	public RemoveBuff(buff_type, skill_id) {
		let buff_vo_list = this.buffDic[buff_type];
		if (buff_vo_list)
			buff_vo_list.DeleteBuffBySkillId(skill_id);
	}
	public Update(total_time, elapse_time) {
		let delList: Array<any>;
		let buff_vo_list = null;
		let vo;
		let self = this;
		for (let iconType in self.buffDic) {
			buff_vo_list = self.buffDic[iconType];
			if (buff_vo_list.Update(total_time, elapse_time) == false) {
				if (delList == null)
					delList = [];
				delList.push(iconType);
			}
		}
		if (delList)
			self.DeleteBuffList(delList);
		if (self.character && self.character.obj_type == local_SceneBaseType.MainRole && self.update_buff_icon_time && local_Status.NowTime - self.update_buff_icon_time > 0.5) {
			self.update_buff_icon_time = false;
			GlobalEventSystem.Fire(EventName.UPDATE_BUFF_VIEW);
		}
	}
	public DeleteBuffList(delList) {
		//删除已经到期的buff
		let has_delete = false;
		for (let iconType of delList) {
			let buff_vo_list = this.buffDic[iconType];
			if (buff_vo_list) {
				has_delete = true;
				delete this.buffDic[iconType];
				local_FightManager.GetInstance().pushBuffVoList(buff_vo_list);
			}
		}
		if (has_delete)
			this.BuffChange();
	}
	//buff有变动的时候 调用 
	public BuffChange() {
		let self = this;
		if (!self.CheckBuffControl() && (self.character.IsInState(local_PoseState.DIZZY)))
			self.character.DoStand();
		if (self.character.GetType() == local_SceneBaseType.Role || self.character.GetType() == local_SceneBaseType.MainRole) {
			// self.character.name_board.SetBuffList(self.buffDic, self.character.id)
			if (self.character.GetType() == local_SceneBaseType.MainRole) {
				self.update_buff_icon_time = Status.NowTime;
			}
		}
	}
	//检查并且设置buff的控制
	public CheckBuffControl(ignore_hited?) {
		let self = this;
		if (self.character.IsVoValid()) {
			if (ignore_hited || (!self.character.IsInState(local_PoseState.HITED)))
			{
				if (self.hasYunBuff()) {
					self.character.DoDizzy()
					return true;
				}
				else if (self.hasDingshenBuff()) {
					// self.character.DoPause()
					return true;
				}
				// else if (self.hasHunluanBuff()) {
				//	 // if (self.IsMainRole())
				//	 // self.character.DoHunluan(99999)
				//	 // else
				//	 self.character.DoStand()
				//	 return true
				// }
				// else if (self.hasChaofengBuff()) {
				//	 //self.character.DoStand()
				//	 return true
				// }
				// else if (self.hasChanraoBuff() || self.hasTuidingBuff()) {
				//	 // self.character.DoPause()
				//	 return true
				// }
			}
		}
		return false;
	}
	//buff叠加
	private showTimeDic = {};
	public checkBuffShowTime(vo) {
		ResManager.GetInstance().LoadGameConfig(this, "ClientBuffShowTime", true, LOAD_QUEUE.HIGHT, (buff_cfg) => {
			let isShowBuff = buff_cfg[vo.id];
			let dic_vo = this.showTimeDic[vo.id];
			if (isShowBuff && (!dic_vo || vo.diejia > dic_vo.diejia || vo.period > dic_vo.period)) {
				this.showTimeDic[vo.id] = vo;
				this.character.name_board.SetBuffTime(vo.diejia);
			}
			ResManager.GetInstance().DestoryGameConfig(this, "ClientBuffShowTime", true);
		});
	}
	public delBuffShowTime(vo) {
		let buffVo = vo.vo;
		let dic_vo = this.showTimeDic[buffVo.id];
		if (dic_vo != undefined && dic_vo.iconType == buffVo.iconType && dic_vo.period == buffVo.period) {
			delete this.showTimeDic[buffVo.id];
			this.character.name_board.ClearBuffTime();
		}
	}
}

window["BuffManager"] = BuffManager