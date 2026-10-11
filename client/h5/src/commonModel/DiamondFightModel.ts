import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "./RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"

export class DiamondFightModel extends EventDispatcher {

	static OPEN_VIEW = "DiFiMl.OPEN_VIEW"
	static CLOSE_VIEW = "DiFiMl.CLOSE_VIEW"
	static REQUEST_SCMD = "DiFiMl.REQUEST_SCMD"

	static UPDATE_RECORD_RED_STATE = "DiFiMl.UPDATE_RECORD_RED_STATE"
	static UPDATE_RED_STATE = "DiFiMl.UPDATE_RED_STATE"
	static SUCCESS_SIGN_UP = "DiFiMl.SUCCESS_SIGN_UP"
	static UPDATE_LIFE = "DiFiMl.UPDATE_LIFE"
	static UPDATE_SKILL_CD = "DiFiMl.UPDATE_SKILL_CD"
	static UPDATE_HISTORY_LIST = "DiFiMl.UPDATE_HISTORY_LIST"

	static MAX_ROUNDS = 12
	static HAIXUAN_ROUNDS = 8
	static MODULE_ID = 137

	static OPEN_LEVEL
	static GAMBLE_LEVEL
	static TICKET_ID
	static SKILL_LIST
	static OPEN_DAY

	static Instance: DiamondFightModel

	champion_info
	fight_end_time
	fight_enemy_info
	fight_start_time
	gamble_data
	history_info_list
	lives_info
	record_info
	record_red_state
	skill_cd_list
	stage_info
	user_info
	wait_tip_info
	waiting_info
	zone
	fake_role_info

	//登录红点和报名道具红点
	login_red
	nor_red_state
	erlang_parser: ErlangParser
	public constructor() {
		super()

		this.erlang_parser = ErlangParser.GetInstance()
		this.history_info_list = false
		this.record_red_state = false
	}

	public InitConfig(config_drumwar_value) {
		DiamondFightModel.OPEN_LEVEL = this.GetValueByKey(1, config_drumwar_value)
		DiamondFightModel.GAMBLE_LEVEL = this.GetValueByKey(2, config_drumwar_value)
		DiamondFightModel.TICKET_ID = this.GetValueByKey(6, config_drumwar_value)
		DiamondFightModel.SKILL_LIST = JSON.parse(this.GetValueByKey(12, config_drumwar_value))[0]
		DiamondFightModel.OPEN_DAY = this.GetValueByKey(15, config_drumwar_value)
	}

	public ResetData() {

		this.history_info_list = false
		this.stage_info = false
		this.user_info = false
		this.champion_info = false
		this.record_info = false
		this.fight_start_time = false
		this.fight_end_time = false
		this.login_red = true
		this.nor_red_state = false
	}

	public ResetWaitingData() {

		this.waiting_info = false
		this.wait_tip_info = false
		this.gamble_data = false
	}

	public ResetFightData() {

		this.lives_info = false
		this.skill_cd_list = []
		this.fight_enemy_info = false
	}

	public SetStageInfo(scmd?) {

		this.ChangeVar("stage_info", scmd)
	}

	public SetUserInfo(scmd?) {

		this.ChangeVar("user_info", scmd, false, true)
		if ((scmd.is_sign == 1 && this.stage_info) && this.stage_info.war_state == 1) {
			let icon_mgr = ActivityIconManager.GetInstance()
			let icon_info = icon_mgr.getIconInfo(DiamondFightModel.MODULE_ID)
			if (icon_info) {
				icon_mgr.deleteIcon(DiamondFightModel.MODULE_ID)
			}
		}
		this.UpdateRedforDiamond()
	}

	public SetHistoryList(data?) {
		data.list.sort((v1?, v2?) => {
			return v1.rank - v2.rank
		}
		)
		if (!this.history_info_list) {
			this.history_info_list = []
		}
		this.history_info_list[data.war_no] = data
		this.Fire(DiamondFightModel.UPDATE_HISTORY_LIST, data.war_no)
	}

	public GetDistrictDesc(district, config_drumwar_lv_to_zone) {

		district = district || DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone)
		district = district == 0 && DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone) || district
		let str = ""
		if (1 == district) {
			str = "跨服250级及以上等级赛区"
		} else if ("default" == district) {
			str = "未报名"
		}
		return str
	}

	public GetDistrictName(district?) {

		let str = null
		if (1 == district) {
			str = "0~65级战区"
		} else if (2 == district) {
			str = "66~75级战区"
		} else if (3 == district) {
			str = "76~85级战区"
		} else if (4 == district) {
			str = "85级以上"
		} else if ("default" == district) {
			str = "未知战区"
		}
		return str
	}

	public GetSessionReward(district, session, result, config_drumwar_zone_reward, config_drumwar_lv_to_zone) {

		let num = 0
		if (session == 0) {
			return 0
		}
		district = district || DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone)
		let cfg = config_drumwar_zone_reward
		let config = cfg[district + "@" + session]
		if (config) {
			if (result) {
				num = num + JSON.parse(config.win_reward)[0][2]
			} else {
				num = num + JSON.parse(config.lose_reward)[0][2]
			}
		}
		return num
	}

	public GetTotalDiamond(zone, action_id, result, drumwar_zone_reward_cfg, config_drumwar_lv_to_zone) {

		let num = 0
		if (action_id == 0) {
			return 0
		}
		zone = zone || DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone)
		let cfg = drumwar_zone_reward_cfg
		let i = action_id - 1
		let data
		do {
			let config = cfg[zone + "@" + i]
			if (config) {
				data = JSON.parse(config.win_reward)
				num += data[0][2]
			}
			i = i - 1
		} while ((i > 0))

		let config = cfg[zone + "@" + action_id]
		if (config) {
			if (result) {
				data = JSON.parse(config.win_reward)
				num += data[0][2]
			} else {
				data = JSON.parse(config.lose_reward)
				num += data[0][2]
			}
		}
		return num
	}

	public SetGambleData(scmd?) {
		let gamble_data = { end_time: scmd.end_time, data: {} }
		for (let _tmpi in scmd.list) {
			var ses = scmd.list[_tmpi]
			gamble_data.data[ses.action_id] = ses.list3
		}
		this.ChangeVar("champion_info", gamble_data.data[13])
		this.ChangeVar("gamble_data", gamble_data)
	}

	public IsSupported(action_id?, supporter_id?) {

		let info = this.user_info
		if (info) {
			for (let _tmpi in info.action_list) {
				var v = info.action_list[_tmpi]
				if (v.id == action_id) {
					for (let _tmpi in v.supporter) {
						var roleVo = v.supporter[_tmpi]
						if (roleVo.supporter_id == supporter_id) {
							return true
						}
					}
				}
			}
		}
		return false
	}

	public GetNowAction() {

		return this.wait_tip_info && this.wait_tip_info.action
	}

	public GetValueByKey(key, config_drumwar_value) {
		return config_drumwar_value && config_drumwar_value[key] && config_drumwar_value[key].value
	}

	public SetZoneInfo(zone_info?) {

		this.zone = zone_info.zone || 0
	}

	public SetRecordInfo(record_info?) {

		let data = {}
		for (let _tmpi in record_info.list) {
			var vo = record_info.list[_tmpi]
			if (!data[vo.zone]) {
				data[vo.zone] = []
			}
			table.insert(data[vo.zone], vo)
		}
		this.ChangeVar("record_info", data)
	}

	public GetRecordRedState() {
		return this.record_red_state
	}

	public RefreshRecordRed(config_drumwar_lv_to_zone) {
		let zone = this.zone || DiamondFightModel.GetZoneByLv(null, config_drumwar_lv_to_zone)
		let record_info = this.record_info
		let bool = false
		if (zone && record_info) {
			let list = record_info[zone]
			if (list) {
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (vo.winner == vo.suprid && (vo.winner == vo.arid || vo.winner == vo.brid) && vo.reward_st == 0) {
						bool = true
						break
					}
				}
			}
		}
		if (bool != this.record_red_state) {
			this.record_red_state = bool
			this.Fire(DiamondFightModel.UPDATE_RECORD_RED_STATE)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820)
		}
		return bool
	}

	public IsInBetState() {

		return !this.champion_info && this.stage_info && this.wait_tip_info && this.stage_info.war_state == 4 && this.wait_tip_info.type == 2
	}

	public HasSignUp() {

		return this.user_info && this.user_info.is_sign == 1
	}

	public SetSkillCd(scmd?) {
		if (!this.skill_cd_list) {
			this.skill_cd_list = {}
		}
		this.skill_cd_list[scmd.skill_id] = scmd.cd_end_time
		this.Fire(DiamondFightModel.UPDATE_SKILL_CD, scmd.skill_id, scmd.cd_end_time)
	}


	public GetSkillCd(skill_id?) {

		return this.skill_cd_list && this.skill_cd_list[skill_id]
	}

	/**是否在报名的阶段*/
	public IsSignUpBefore() {
		return this.stage_info && this.stage_info.war_state != null && this.stage_info.war_state == 1
	}
	/**活动是否开启*/
	public IsDiamondOpening() {
		return this.stage_info && this.stage_info.war_state != null && this.stage_info.war_state >0 && this.stage_info.war_state<5
	}
	/**红点判断  登录红点和报名道具红点*/
	public UpdateRedforDiamond() {
		let state = false
		if (this.login_red) {
			state = this.IsDiamondOpening()
		}else{
			//报名后会消失
			if(this.IsSignUpBefore()){
				if (this.HasSignUp()) {
					state = false
				} else {
					let ticket_count = GoodsModel.GetInstance().GetTypeGoodsNum(DiamondFightModel.TICKET_ID)
					state = ticket_count > 0 ? true : false
				}
			}
		}
		if (state != this.nor_red_state) {
			this.nor_red_state = state
			this.Fire(DiamondFightModel.UPDATE_RED_STATE)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 2820)
			GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, DiamondFightModel.MODULE_ID)
		}
	}
	public GetRedforDiamond() {
		return this.nor_red_state
	}
	public static GetInstance() {

		if (!DiamondFightModel.Instance) {
			DiamondFightModel.Instance = new DiamondFightModel()
		}
		return DiamondFightModel.Instance
	}

	public static GetZoneByLv(level, config_drumwar_lv_to_zone) {
		level = level || RoleManager.GetInstance().GetMainRoleVo().level
		let cfg = config_drumwar_lv_to_zone
		for (let key in cfg) {
			let v = cfg[key]
			if (level >= v.min_lv && level <= v.max_lv) {
				return v.zid
			}
		}
		return 1
	}

	//测试用
	/*public GetGambleData() {
		return {
			["9"]: [
				{
					aname: "杰哥1",
					arid: 1,
					bname: "杰哥2",
					brid: 2,
					winner: 1,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥3",
					arid: 3,
					bname: "杰哥4",
					brid: 4,
					winner: 3,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥5",
					arid: 5,
					bname: "杰哥6",
					brid: 6,
					winner: 6,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥7",
					arid: 7,
					bname: "杰哥8",
					brid: 8,
					winner: 7,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥9",
					arid: 9,
					bname: "杰哥10",
					brid: 10,
					winner: 9,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥11",
					arid: 11,
					bname: "杰哥12",
					brid: 12,
					winner: 11,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥13",
					arid: 13,
					bname: "杰哥14",
					brid: 14,
					winner: 14,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥15",
					arid: 15,
					bname: "杰哥16",
					brid: 16,
					winner: 16,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				}],
			[10]: [
				{
					aname: "杰哥1",
					arid: 1,
					bname: "杰哥3",
					brid: 3,
					winner: 1,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥6",
					arid: 6,
					bname: "杰哥7",
					brid: 7,
					winner: 7,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥9",
					arid: 9,
					bname: "杰哥11",
					brid: 11,
					winner: 11,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				},
				{
					aname: "杰哥14",
					arid: 14,
					bname: "杰哥16",
					brid: 16,
					winner: 14,
					asnum: 1,
					acareer: 1,
					bsnum: 2,
					bcareer: 2,
					suprid: 0,
				}
			],
			[11]: [{
				aname: "杰哥1",
				arid: 1,
				bname: "杰哥7",
				brid: 7,
				winner: 7,
				asnum: 1,
				acareer: 1,
				bsnum: 2,
				bcareer: 2,
				suprid: 0,
			},
			{
				aname: "杰哥11",
				arid: 11,
				bname: "杰哥14",
				brid: 14,
				winner: 11,
				asnum: 1,
				acareer: 1,
				bsnum: 2,
				bcareer: 2,
				suprid: 0,
			}],
			[12]: [{
				aname: "杰哥7",
				arid: 7,
				bname: "杰哥11",
				brid: 11,
				winner: 11,
				asnum: 1,
				acareer: 1,
				bsnum: 2,
				bcareer: 2,
				suprid: 0,
			}],
			[13]: [{
				aname: "杰哥11",
				arid: 11,
				bname: "",
				brid: 0,
				asnum: 1,
				acareer: 1,
				bsnum: 2,
				bcareer: 2,
				suprid: 0,
			}]
		}


	}*/



}

window["DiamondFightModel"] = DiamondFightModel