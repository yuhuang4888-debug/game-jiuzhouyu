import { FightFontAniType, FightFontLayerType, FightFontManager, FightFontType, IFightFontData } from "./FightFontManager";
import { Scene } from "../Scene";
import { SceneBaseType } from "../SceneConfig";
import { SceneManager } from "../SceneManager";
import { GameScriptModule } from "../../GameScriptModule";
import { BaseWindowComponent } from "../../common/BaseWindowComponent";
import { Util } from "../../util/Util";
import { Vector2 } from "../../util/Vector2";
import { GameResPath } from "../../util/GameResPath";
import { Config } from "../../common/Config";
import { ErlangParser } from "../../util/ErlangParser";
let local_Vector2 = Vector2
export enum FightDamageFlag {
	/**
	 * 普通伤害(服务端)
	 */
	Normal = 0,
	/**
	 * 闪避(服务端)
	 */
	ShanBi = 1,
	/**
	 * 暴击(服务端)
	 */
	BaoJi = 2,
	/**
	 * 免疫伤害(无敌)(服务端)
	 */
	MainYi = 3,
	/**
	 * 会心(服务端)
	 */
	HuiXin = 4,
	/**
	 * 护盾免伤(服务端)
	 */
	HuDunMianShang = 5,
	/**
	 * 格挡(服务端)
	 */
	GeDang = 6,
	/**
	 * 无伤害##不触发效果,比如被动技能(服务端)
	 */
	None = 7,
	/**
	 * 卓越一击(服务端)
	 */
	ZhuoYue = 8,
	/**
	 * 暴击会心(服务端)
	 */
	BaojiHuiXin = 9,
	/**
	 * 卓越会心(服务端)
	 */
	ZhuoYueHuiXin = 10,

	/**
	 * 吸血(客户端)
	 */
	XiXue = 1001,
	/**
	 * 反弹(客户端)
	 */
	FanTan = 1002,
	/**
	 * 流血(客户端)
	 */
	LiuXue = 1003,
}
window["FightDamageFlag"] = FightDamageFlag;

/**
 * 攻击方类型
 */
export enum FightDamageAttackType {
	MainRole,
	Partner
}

/**
 * 防守方类型
 */
export enum FightDamageDefenderType {
	MainRole = 20
}

let local_GameScriptModule = GameScriptModule
let local_Util = Util
let local_BaseWindowComponent = BaseWindowComponent
let local_SceneBaseType = SceneBaseType
let local_FightDamageAttackType = FightDamageAttackType
let local_FightDamageDefenderType = FightDamageDefenderType

export class FightDamageManager {

	static Instance: FightDamageManager
	public static GetInstance() {
		if (!FightDamageManager.Instance) {
			FightDamageManager.Instance = new FightDamageManager();
		}
		return FightDamageManager.Instance;
	}

	fight_font_data_dic: { [key: string]: IFightFontData }
	main_role_add_hp_font_data: IFightFontData
	main_role_skill_data: IFightFontData
	need_show_skill_id_list

	font_mgr = FightFontManager.GetInstance()
	scene_mgr: SceneManager = SceneManager.GetInstance()
	public constructor() {
		this.InitFightFontData()
	}

	InitFightFontData() {
		if (!this.fight_font_data_dic)
			this.fight_font_data_dic = {}


		//攻击方
		/**
		 * 主角攻击
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}`] = {
			ani_type: FightFontAniType.One,
			font_type: FightFontType.Attack,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				if(value == 0){
					//闪避只显示文字
					return "a"
				}
				else{
					return `${value}`
				}
			}
		}


		/**
		 * 伙伴攻击
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.Partner}`] = {
			ani_type: FightFontAniType.One,
			font_type: FightFontType.ShenWu,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `a${value}`
			}
		}

		/**
		 * 主角攻击暴击伤害
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.BaoJi}`] = {
			ani_type: FightFontAniType.Two,
			font_type: FightFontType.BaoJi,
			layer: FightFontLayerType.Four,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 主角攻击暴击会心
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.BaojiHuiXin}`] = {
			ani_type: FightFontAniType.Two,
			font_type: FightFontType.BaoJi,
			layer: FightFontLayerType.Four,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 主角攻击卓越
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.ZhuoYue}`] = {
			ani_type: FightFontAniType.Two,
			font_type: FightFontType.ZhuoYue,
			layer: FightFontLayerType.Three,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 主角攻击卓越会心
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.ZhuoYueHuiXin}`] = {
			ani_type: FightFontAniType.Two,
			font_type: FightFontType.ZhuoYue,
			layer: FightFontLayerType.Three,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 主角攻击会心
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.HuiXin}`] = {
			ani_type: FightFontAniType.Two,
			font_type: FightFontType.HuiXin,
			layer: FightFontLayerType.Two,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 主角攻击格挡
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.GeDang}`] = {
			ani_type: FightFontAniType.One,
			font_type: FightFontType.GeDang,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `a${value}`
			}
		}

		/**
		 * 主角攻击反弹
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.FanTan}`] = {
			ani_type: FightFontAniType.One,
			font_type: FightFontType.FanTan,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `a${value}`
			}
		}

		/**
		 * 主角攻击流血
		 */
		this.fight_font_data_dic[`${local_FightDamageAttackType.MainRole}@${FightDamageFlag.LiuXue}`] = {
			ani_type: FightFontAniType.One,
			font_type: FightFontType.LiuXue,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 被击
		 */

		/**
		 * 主角被击
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.BeAttack,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				if(value == 0){
					//闪避只显示文字
					return "a"
				}
				else{
					return `${value}`
				}
			}
		}


		/**
		 * 主角被击暴击伤害
		 */
		 this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.BaoJi}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.BaoJi,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}


		/**
		 * 主角被击暴击会心
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.BaojiHuiXin}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.BaoJi,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}

		/**
		 * 主角被击卓越
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.ZhuoYue}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.ZhuoYue,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}

		/**
		 * 主角被击卓越会心
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.ZhuoYueHuiXin}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.HuiXin,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}

		/**
		 * 主角被击会心
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.HuiXin}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.HuiXin,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}

		/**
		 * 主角被击格挡
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.GeDang}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.GeDang,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}

		/**
		 * 主角被击反弹
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.FanTan}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.FanTan,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}


		/**
		 * 主角被击流血
		 */
		this.fight_font_data_dic[`${local_FightDamageDefenderType.MainRole}@${FightDamageFlag.LiuXue}`] = {
			ani_type: FightFontAniType.Three,
			font_type: FightFontType.LiuXue,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `b${value}`
			}
		}

		/**
		 * 主角回血
		 */
		this.main_role_add_hp_font_data = {
			ani_type: FightFontAniType.Four,
			font_type: FightFontType.HuiFu,
			layer: FightFontLayerType.One,
			GetStr:(value)=>{
				return `a${value}`
			}
		}


		/**
		 * 主角技能飘字
		 */
		 this.main_role_skill_data = {
			ani_type: FightFontAniType.Five,
			layer: FightFontLayerType.Six,
		}
	}

	/**
	 * 显示伤害飘字
	 * @param flag 伤害标识
	 * @param value 值
	 * @param attacker 攻击方 
	 * @param defender 防守方
	 */
	ShowFont(flag: FightDamageFlag, value, attacker, defender) {

		//客户端缩小时不显示飘字
		if (local_GameScriptModule.GetInstance().game_run_state == "pause") return
		//大界面打开是不显示飘字
		if (!local_Util.IsTableEmpty(local_BaseWindowComponent.CURR_OPEN_VIEW)) return

		if (!attacker || !defender)
			return;

		if (flag == null || value == null) {
			return
		}

		//除了闪避类型 value = 0不显示飘字
		if (value == 0 && flag != FightDamageFlag.ShanBi) {
			return
		}
		

		//是否是攻击方(攻击方包括主角和主角的伙伴)
		let attacker_type = attacker.GetType();
		let is_main_role_attack = attacker_type == local_SceneBaseType.MainRole
		let is_main_role_partner_attack = attacker_type == local_SceneBaseType.Partner && attacker.owner && attacker.owner.GetType() == local_SceneBaseType.MainRole
		let is_attacker = is_main_role_attack || is_main_role_partner_attack

		//是否是防守方(防守方包括主角)
		let defender_type = defender.GetType();
		let is_main_role_defender = defender_type == local_SceneBaseType.MainRole
		let is_deferder = is_main_role_defender

		let can_show = is_attacker || is_deferder || this.scene_mgr.ShowAllDamageScene()
		if (!can_show) {
			return;
		}

		let key
		if (is_attacker) {
			//伙伴攻击
			if (is_main_role_partner_attack) {
				key = local_FightDamageAttackType.Partner
			}
			else {
				key = local_FightDamageAttackType.MainRole
			}
			
		}
		else {
			key = local_FightDamageDefenderType.MainRole
		}

		let font_data = this.fight_font_data_dic[`${key}@${flag}`]
		if(!font_data){
			font_data = this.fight_font_data_dic[`${key}`]
		}

		if(!font_data) return
		let value_str = font_data.GetStr(value)



		let attacker_pos = new local_Vector2()
		attacker_pos.x = attacker.real_pos.x;
		attacker_pos.y = attacker.real_pos.y;

		let defender_pos = new local_Vector2()
		defender_pos.x = defender.real_pos.x;
		defender_pos.y = defender.real_pos.y;

		this.font_mgr.ShowFont(font_data, value_str, attacker_pos, defender_pos, attacker.GetDirection(), defender.GetDirection(), attacker.GetBodyHeight(), defender.GetBodyHeight());
	};

	/**
	 * 主角血量增加
	 * @param value 值
	 * @param FightDamageFlag 伤害类型
	 */
	ShowAdd(value, damage_flag?, obj?) {
		//客户端缩小时不显示飘字
		if (local_GameScriptModule.GetInstance().game_run_state == "pause") return
		//大界面打开是不显示飘字
		if (!local_Util.IsTableEmpty(local_BaseWindowComponent.CURR_OPEN_VIEW)) return

		obj = obj || Scene.GetInstance().GetMainRole()
		if (value <= 0)  return
		let font_data 
		// if(damage_flag == FightDamageFlag.XiXue){
		// 	font_data = this.main_role_add_hp_font_data
		// }
		// else{
			font_data = this.main_role_add_hp_font_data
		// }

		let value_str = font_data.GetStr(value)

		let attacker_pos = new local_Vector2()
		attacker_pos.x = obj.real_pos.x;
		attacker_pos.y = obj.real_pos.y;

		let defender_pos = new local_Vector2()
		defender_pos.x = obj.real_pos.x;
		defender_pos.y = obj.real_pos.y;

		this.font_mgr.ShowFont(font_data, value_str, attacker_pos, defender_pos, obj.GetDirection(), obj.GetDirection(), obj.GetBodyHeight(), obj.GetBodyHeight())
	};

	/**
	 * 显示技能飘字
	 * @param skill_id 技能id
	 * @param obj 攻击方 
	 */
	 ShowSkillImg(skill_id, obj?, source?) {
		skill_id = Number(skill_id)
		//客户端缩小时不显示飘字
		if (local_GameScriptModule.GetInstance().game_run_state == "pause") return
		//大界面打开是不显示飘字
		if (!local_Util.IsTableEmpty(local_BaseWindowComponent.CURR_OPEN_VIEW)) return

		let config_key_value = Config.PRELOAD_SERVER_CONFIG.config_key_value
		if(!config_key_value || !config_key_value[20001]) return

		if(this.need_show_skill_id_list == null){
			this.need_show_skill_id_list = ErlangParser.GetInstance().Parse(config_key_value[20001].value)
		}

		if(this.need_show_skill_id_list.indexOf(String(skill_id)) < 0) return
 

		obj = obj || Scene.GetInstance().GetMainRole()
		let font_data 
			font_data = this.main_role_skill_data

		let attacker_pos = new local_Vector2()
		attacker_pos.x = obj.real_pos.x;
		attacker_pos.y = obj.real_pos.y;

		let defender_pos = new local_Vector2()
		defender_pos.x = obj.real_pos.x;
		defender_pos.y = obj.real_pos.y;

		let url = GameResPath.GetSkillNamePath(skill_id)
		this.font_mgr.ShowImg(font_data, url, attacker_pos, defender_pos, obj.GetDirection(), obj.GetDirection(), obj.GetBodyHeight(), obj.GetBodyHeight())
	};
}

window["FightDamageManager"] = FightDamageManager