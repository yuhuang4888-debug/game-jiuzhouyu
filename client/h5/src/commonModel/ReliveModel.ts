import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventDispatcher } from "../util/EventDispatcher";
import { PoseState } from "../util/StateMachineManager";
import { TimeUtil } from "../util/TimeUtil";
import { BossModel } from "./BossModel";

export class ReliveModel extends EventDispatcher {
	static Instance: ReliveModel
	static RELIVE_TIME_UPDATE = "ReliveModel.RELIVE_TIME_UPDATE"

	static BossSpecialReliveType = {
		WorldBoss: 0,
		HolyBoss: 1, 
		HolyTerr: 2, 
		KfHolyArea: 3
	}

	isRelive
	scene_mgr: SceneManager
	relive_data_time_dic
	relive_time_has_return
	public constructor() {
		super()
		this.scene_mgr = SceneManager.GetInstance()
	}

	public IsServerControl() {
		return this.scene_mgr.IsExpDungeon()
			|| this.scene_mgr.IsEquipDungeon()
			|| this.scene_mgr.IsDragonDungeon()
			|| this.scene_mgr.IsSentientActDungeon()
		// || this.scene_mgr.SoulDungeon()

	}

	// 设置复活界面需要的数据
	// die_times:int16     //死亡次数
	// time:int32          //死亡等待结束时间（可以免费复活时间）
	// debuff_time:int32   //debuff持续时间
	// safe_time:int32     //玩家回安全区时间（把尸体挪回复活点时间）
	SetReliveTimeData(data, relive_type) {
		if (!this.relive_data_time_dic) {
			this.relive_data_time_dic = {}
		}
		this.relive_data_time_dic[relive_type] = data

		let relive_time_cfg ,relive_time_list, relive_time = 0
		switch (relive_type) {
			case ReliveModel.BossSpecialReliveType.WorldBoss:
				relive_time_cfg = BossModel.GetInstance().GetBossKeyValue(12, "reborn_time_after_die_time_limit", Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value)
				relive_time_list = JSON.parse(relive_time_cfg)
				for (let key in relive_time_list) {
					let time = relive_time_list[key]
					if (data.die_times <= Number(time[0])) {
						relive_time = Number(time[1])
						break
					}
				}
				data.relive_time = data.time + relive_time
				if (data.debuff_time <= TimeUtil.getServerTime()) {
					data.die_times = 0
				}
				break
			case ReliveModel.BossSpecialReliveType.HolyBoss:
				relive_time_cfg = BossModel.GetInstance().GetBossKeyValue(12, "reborn_time_after_die_time_limit", Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value)
				relive_time_list = JSON.parse(relive_time_cfg)
				for (let key in relive_time_list) {
					let time = relive_time_list[key]
					if (data.die_times <= Number(time[0])) {
						relive_time = Number(time[1])
						break
					}
				}
				data.relive_time = data.time + relive_time
				if (data.debuff_time <= TimeUtil.getServerTime()) {
					data.die_times = 0
				}
				break
			case ReliveModel.BossSpecialReliveType.HolyTerr:
				relive_time_cfg = BossModel.GetInstance().GetBossKeyValue(12, "reborn_time_after_die_time_limit", Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value)
				relive_time_list = JSON.parse(relive_time_cfg)
				for (let key in relive_time_list) {
					let time = relive_time_list[key]
					if (data.die_times <= Number(time[0])) {
						relive_time = Number(time[1])
						break
					}
				}
				data.relive_time = data.time + relive_time
				if (data.debuff_time <= TimeUtil.getServerTime()) {
					data.die_times = 0
				}
				break
			case ReliveModel.BossSpecialReliveType.KfHolyArea:
				relive_time_cfg = BossModel.GetInstance().GetBossKeyValue(12, "reborn_time_after_die_time_limit", Config.PRELOAD_SERVER_CONFIG.config_boss_type_key_value)
				relive_time_list = JSON.parse(relive_time_cfg)
				for (let key in relive_time_list) {
					let time = relive_time_list[key]
					if (data.die_times <= Number(time[0])) {
						relive_time = Number(time[1])
						break
					}
				}
				data.relive_time = data.time + relive_time
				if (data.debuff_time <= TimeUtil.getServerTime()) {
					data.die_times = 0
				}
				break
		}

		let is_in_boss_scene = (relive_type == ReliveModel.BossSpecialReliveType.HolyBoss && this.scene_mgr.IsHolyBossScene())
		|| (relive_type == ReliveModel.BossSpecialReliveType.WorldBoss && (this.scene_mgr.IsFieldSpecialBossScene() || this.scene_mgr.IsFieldBossScene()|| this.scene_mgr.IsFieldInfiniteBossScene()))
		|| (relive_type == ReliveModel.BossSpecialReliveType.HolyTerr && this.scene_mgr.IsHolyTerritory())
		|| (relive_type == ReliveModel.BossSpecialReliveType.KfHolyArea && this.scene_mgr.IsKfHolyAreaScene())

		if(is_in_boss_scene){
			if(data.relive_time > TimeUtil.getServerTime()){
				this.relive_time_has_return = true
			}else{
				let main_role = Scene.GetInstance().GetMainRole()
				if(main_role && main_role.IsInState(PoseState.DEAD)){
					if(relive_type == ReliveModel.BossSpecialReliveType.KfHolyArea){
						GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 22, true)
					}
					else{
						GlobalEventSystem.Fire(EventName.RELIVE_BY_TYPE, 3, true)
					}
				}
			}
		}

		this.Fire(ReliveModel.RELIVE_TIME_UPDATE, relive_type)
		GlobalEventSystem.Fire(EventName.UPDATE_MAINUI_BUFF_COUNT)
	}

	GetReliveTimeData(relive_type){
		return this.relive_data_time_dic && this.relive_data_time_dic[relive_type]
	}


	public static GetInstance() {
		if (!ReliveModel.Instance) {
			ReliveModel.Instance = new ReliveModel()
		}
		return ReliveModel.Instance
	}
}

window["ReliveModel"] = ReliveModel