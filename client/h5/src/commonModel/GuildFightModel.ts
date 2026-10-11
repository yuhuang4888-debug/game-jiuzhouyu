import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ModelPartPos } from "../sharedata/RoleVo"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventDispatcher } from "../util/EventDispatcher"
import { GuildModel } from "./GuildModel"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { BaseEnterDefine } from "../baseEnterView/BaseEnterDefine"

export let GuildFightEvent = {
	GUILDFIGHT_CHOSE_TARGET: "GUILDFIGHT_CHOSE_TARGET",
	GUILDFIGHT_REQUEST_PROTO: "GUILDFIGHT_REQUEST_PROTO",
	GUILDFIGHT_OPEN_VIEW: "GUILDFIGHT_OPEN_VIEW",
	UPDATE_GUILD_HOLD_DATA: "UPDATE_GUILD_HOLD_DATA",
	UPDATE_END_TIME: "UPDATE_END_TIME",
	UPDATE_NEAR_POS: "UPDATE_NEAR_POS",
	OPEN_GUILD_FIGHT_SCENE: "OPEN_GUILD_FIGHT_SCENE",
	UPDATE_GUILD_RANK_DATA: "UPDATE_GUILD_RANK_DATA",
	UPDATE_ROLE_RANK_DATA: "UPDATE_ROLE_RANK_DATA",
	UPDATE_GUILD_FIGHT_VIEW: "UPDATE_GUILD_FIGHT_VIEW",
	UPDATE_ROLE_SCORE: "UPDATE_ROLE_SCORE",
	UPDATE_STAGE_DATA: "UPDATE_STAGE_DATA",
	RECEIVED_PERSON_REWARD: "RECEIVED_PERSON_REWARD",
	SHOW_KILL_ITEM: "SHOW_KILL_ITEM",
	UPDATE_AC_STATE: "UPDATE_AC_STATE",
	UPDATE_SERVER_INFO: "GFE1",
	UPDATE_TER_INFO: "GFE2",
	UPDATE_ROUND: "GFE3",
	UPDATE_GUILD_INFO: "GFE4",
	UPDATE_TOWER_INFO: "GFE5",
	SELECT_TER: "GFE6",
	UPDATE_REQUEST_FIGURE: "GFE7",
	UPDATE_WAR_INFO: "GFE8",
	UPDATE_SELECT_STATE: "GFE9",
	REFRESH_PROTO: "GFE11",
	UPDATE_SELECT: "GFE10",
	UPDATE_REQUEST_FIGURE_2: "GFE12",
}
window["GuildFightEvent"] = GuildFightEvent
export class GuildFightModel extends EventDispatcher {
	CanAttackKing
	CanSelect
	GetMapList
	GetModInfo
	GetRoleClotheTextureId
	GetWeaponClotheId
	IsKFModel
	IsKingBoss
	IsShowRed
	ResConfig
	SetMyGuildData
	SetSelectState
	_can_attack_king
	_red_dot_data
	_role_rank_list
	_win_data
	buff_cfg
	call_time_list
	canSelectList
	day_red_dot
	dis_red_dot
	end_time
	guild_hold_data
	kingTowerId
	max_guild_rank_count
	max_role_rank_count
	my_role_score
	roundInfo
	selectInfo
	selectModel
	selectState

	select_red
	ac_state
	//宣战和进入战斗提示红点弄成上线红点 打开某个界面消失  每过一轮又出现
	select_red_login=true
	ac_state_login=true
	SetSelectRed
	SetAcRed
	SetAcState
	territory_id=0

	serInfo
	startRound
	stateInfo
	terInfo
	warInfo
	show_call_tips


	public static kingTerId = 1007;
	public constructor() {
		super()

		if (GuildFightModel.Instance) {
			return
		}
		GuildFightModel.Instance = this
		this.my_role_score = 0;
		this.end_time = 0;
		this.call_time_list = [];
		this.max_role_rank_count = 20;
		this.max_guild_rank_count = 10;
		this.stateInfo = [];
		this.warInfo = [];
		this.terInfo = [];
		this.serInfo = [];
		this.roundInfo = [];
		this.selectInfo = [];
		this.selectState = false;
		this.canSelectList = [];
		this.startRound = 1;
		this.kingTowerId = 8001005;
		this.selectModel = false;
		this.guild_hold_data = [];
		//let config_preload_server = Config.PRELOAD_SETVER_CONFIG
		let role_mgr = RoleManager.GetInstance()
		let _guild_rank_list_ = null
		let my_guild_score_ = null
		let my_guild_rank_ = null
		let king_id_ = []
		let own_config_ = null

		

		this.SetSelectRed = (boo) => {
			if (!boo && this.select_red&&this.select_red_login) {
				this.select_red_login = boo
				this.Fire(GuildFightEvent.UPDATE_AC_STATE)

				let red_state = this.IsShowRed()
				let BattleFieldIndex = BaseEnterDefine.BattleFieldIndex()
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BattleFieldIndex.GuildFight, red_state)
			} 
		}

		this.SetAcRed = (boo) => {
			if (!boo &&this.ac_state&& this.ac_state_login) {
				this.ac_state_login = boo
				this.Fire(GuildFightEvent.UPDATE_AC_STATE)

				let red_state = this.IsShowRed()
				let BattleFieldIndex = BaseEnterDefine.BattleFieldIndex()
				GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
				GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BattleFieldIndex.GuildFight, red_state)
			} 
		}

		this.SetAcState=(boo?)=>{
			this.ac_state=boo;
		}

		this.ResConfig = () => {
			// own_config_ = Config.Terrimon
			// this.buff_cfg = Config.Terriwarbuff
			own_config_ = Config.PRELOAD_SERVER_CONFIG.config_terri_mon
			this.buff_cfg = Config.PRELOAD_SERVER_CONFIG.config_terri_war_buff
		}


		this.GetModInfo = (mod_id?) => {

		}

		this.CanAttackKing = () => {
			return this._can_attack_king
		}

		this.SetMyGuildData = (data?) => {
			my_guild_rank_ = data.rank
			my_guild_score_ = data.score
		}

		this.GetRoleClotheTextureId = (obj?) => {
			let model_res_list = obj.fashion_model_list
			//@@@
			// if (obj && CheckIsTempleAwaken(obj.figure_list)) {
			// 	let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken_suit", false)
			// 	return Number(cfg["1001@" + obj.career].figure_id), 0
			// }
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == ModelPartPos.Clothe) {
						return v.fashion_model_id
					}
				}
			}
			model_res_list = obj.level_model_list
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == ModelPartPos.Clothe) {
						return v.level_model_id
					}
				}
			}
		}

		this.GetWeaponClotheId = (obj?) => {
			let model_res_list = obj.fashion_model_list
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == ModelPartPos.Weapon) {
						return v.fashion_model_id
					}
				}
			}
			model_res_list = obj.level_model_list
			if (model_res_list) {
				for (let _tmpi in model_res_list) {
					var v = model_res_list[_tmpi]
					if (v.part_pos == ModelPartPos.Weapon) {
						return v.level_model_id
					}
				}
			}
		}

		this.IsKingBoss = (id?) => {
			// [ts2lua]king_id_下标访问可能不正确
			return king_id_[id]
		}

		this.IsShowRed = () => {
			if ( this.day_red_dot || this.dis_red_dot || (this.ac_state && this.ac_state_login)|| (this.select_red && this.select_red_login)) {
				return true
			}
			return false
		}


		this.SetSelectState = () => {
			let roleVo = role_mgr.GetMainRoleVo()
			let newState = ((this.stateInfo.war_state == 1 && this.selectInfo.qualification == 1) && (!this.selectInfo.is_choose_terri_id || this.selectInfo.is_choose_terri_id == 0)) && roleVo.position == 1
			if (newState != this.select_red) {
				this.select_red = newState
				this.Fire(GuildFightEvent.UPDATE_SELECT_STATE)
			} else {
				this.select_red = newState
			}
		}

		this.CanSelect = (id?) => {

		}

		this.IsKFModel = () => {
			return (SceneManager.GetInstance().IsGuildFightScene() && this.serInfo.mode_num) && this.serInfo.mode_num != 1
		}

		this.GetMapList = (cfg?) => {
			let buildCfg = own_config_
			let newCfg = {}
			newCfg["scene_id"] = cfg.scene_id
			newCfg["point_list"] = []
			let terId = this.warInfo.territory_id
			for (let _tmpi in cfg.point_list) {
				for (let vo of cfg.point_list) {
					if (buildCfg[`${terId}@${vo.mon_id}`]) {
						table.insert(newCfg["point_list"], vo)
					}
				}
			}
			return newCfg
		}


	}



	static Instance:GuildFightModel
	public static GetInstance() {

		if (!GuildFightModel.Instance) {
			GuildFightModel.Instance = new GuildFightModel()
		}
		return GuildFightModel.Instance
	}

	public SetWinData(data?) {

		this._win_data = data
	}

	public GetWinData() {

		return this._win_data
	}

	public SetRedDotData(data?) {

		this._red_dot_data = data
		this.day_red_dot = data.type == 1
		let roVo = RoleManager.GetInstance().GetMainRoleVo()
		this.dis_red_dot = (((!data.reward_owner && GuildModel.IsHasGuild()) && roVo.guild_id == data.winner) && roVo.position == 1) && data.reward_key > 1
		let red_state = this.IsShowRed()
		GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 280)
		GlobalEventSystem.Fire(EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "BattleFieldEnterView", BaseEnterDefine.BattleFieldIndex().GuildFight, red_state)
	}

	public GetRedDotData() {

		return this._red_dot_data
	}

	public SetRoleRrankList(data?) {

		this._role_rank_list = data
		this.Fire(GuildFightEvent.UPDATE_ROLE_RANK_DATA)
	}

	public GetRoleRrankList() {

		return this._role_rank_list
	}

	public SetGuildOwnData(data?) {

		this.guild_hold_data = data
		this._can_attack_king = false
		for (let _tmpi in data) {
			var vo = data[_tmpi]
			if (vo.guild_id == RoleManager.GetInstance().GetMainRoleVo().guild_id) {
				this._can_attack_king = true
				break
			}
		}
	}

	public GetGuildOwnData() {

		return this.guild_hold_data
	}

}
window["GuildFightModel"] = GuildFightModel