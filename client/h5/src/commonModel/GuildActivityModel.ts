import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { MainUIController } from "../commonController/MainUIController"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "./RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { Config } from "../common/Config"
import { MainUIModel } from "./MainUIModel"
import { TimeUtil } from "../util/TimeUtil"
import { MiniGameModel } from "./MiniGameModel"

export let GuildActEvent =
{
	REQUEST_PROTO: "GuildActEvent.REQUEST_PROTO",
	UPDATE_EXP: "GuildActEvent.UPDATE_EXP",
	UPDATE_BOSS_DATA: "GuildActEvent.UPDATE_BOSS_DATA",
	UPDATE_AUTO: "GuildActEvent.UPDATE_AUTO",
	CALL_BOSS_SUCCESS: "GuildActEvent.CALL_BOSS_SUCCESS",
	UPDATE_FOOD_LIST: "GuildActEvent.UPDATE_FOOD_LIST",
	UPDATE_EXP_BUFF: "GuildActEvent.UPDATE_EXP_BUFF",
	UPDATE_QUESTION_STATUS: "GuildActEvent.UPDATE_QUESTION_STATUS",
	UPDATE_MY_RANK_INFO: "GuildActEvent.UPDATE_MY_RANK_INFO",
	UPDATE_MINI_GAME_STATUS:"GuildActEvent.UPDATE_MINI_GAME_STATUS",
	OPEN_CLOSE_SCORE_RANK_VIEW:"GuildActEvent.OPEN_SCORE_RANK_VIEW",//显示/关闭答题小游戏排行界面
	GAME_OVER_CLOSE:"GuildActEvent.GAME_OVER_CLOSE",  //小游戏结束关闭界面
}
export let GuildActCfgType = {
	GUILD_ACT: "ConfigGuildAct",
	EVENING_KV: "Gfeast",
	EVENING_QUIZ: "Guildreplytitle",
	EVENING_DRAGON: "Guildfeastdragon",
	EVENING_QUIZ_REWARD: "Guildpointrank"
}
export let GuildActDefine = {
	ANSWER_COUNT: 4,
	BOSS_ID: 2007001
}
window["GuildActEvent"] = GuildActEvent
window["GuildActCfgType"] = GuildActCfgType
window["GuildActDefine"] = GuildActDefine
export class GuildActivityModel extends EventDispatcher {
	CheckOpenView
	CloseBossIcon
	GetActInfo
	GetBossInfo
	GetClientCfg
	GetDragonGiftId
	GetDragonGiftList
	GetDragonInfo
	GetFireInfo
	GetGuildActCfg
	GetQuestInfo
	GetRankInfo
	GetResultInfo
	GetViewByActInfo
	OpenBossIcon
	Reset
	SetActInfo
	SetBossInfo
	SetDragonInfo
	SetFireInfo
	SetMainUIViewVisible
	SetQuestInfo
	SetRankInfo
	SetResultInfo
	_change_scene_mark
	act_info
	dragon_info
	fire_info
	question_info
	rank_info
	result_info
	config_guild_constant
	InitConfig
	my_rank_info
	MyRankInfo
	EveningGameType //公会晚宴小游戏类型  1答题 2消消乐 
	GetEveningGameName //公会晚宴小游戏名称
	evening_game_type = 999 //公会晚宴小游戏类型  1答题 2消消乐
	answer_select_index = -1
	cur_question_id //玩家在答题界面看到的题目id
	public constructor() {
		super()

		if (GuildActivityModel.Instance) {
			return
		}
		GuildActivityModel.Instance = this
		let local_Erlang = ErlangParser.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let activity_icon_mgr = ActivityIconManager.GetInstance()
		let _boss_info_ = null
		let local_Config = Config
		let ConfigHasDefaultValue = Config.ConfigHasDefaultValue

		this.InitConfig = () => {
			this.config_guild_constant = Config.PRELOAD_SERVER_CONFIG.config_gfeast
		// 	Gfeast_ = local_Config.PRELOAD_SETVER_CONFIG.Gfeast
		// 	Gfeast_ = Config.Gfeast

		// 	Gfeast_=Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gfeast.name, GoodsVo.type_id, false)
		}

		

		this.act_info = null
		this.Reset = () => {
			this.question_info = null
			this.rank_info = null
			this.act_info = null
			this.fire_info = null
			this.dragon_info = null
			this.result_info = null
			this.answer_select_index=-1
			this.cur_question_id=-1
			_boss_info_ = null
			this._change_scene_mark = null
		}

		this.GetGuildActCfg = () => {
			return this.config_guild_constant
		}

		this.GetClientCfg = (ConfigGuildAct?, key?) => {
			// [ts2lua]ConfigGuildAct下标访问可能不正确
			return ConfigGuildAct[key]
		}

		this.GetDragonGiftId = (_guild_feast_dragon_cfg?) => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			let dragon_cfg = _guild_feast_dragon_cfg
			if (!dragon_cfg) {
				return
			}
			let cfg = null
			for (let key in dragon_cfg) {

				// [ts2lua]dragon_cfg下标访问可能不正确
				cfg = dragon_cfg[key]
				if (open_day >= cfg.open_day_min && open_day <= cfg.open_day_max) {
					return cfg.gift_id
				}
			}
		}

		this.GetDragonGiftList = (_guild_feast_dragon_cfg?) => {
			let list = []
			let gift_id = this.GetDragonGiftId(_guild_feast_dragon_cfg)
			if (!gift_id) {
				return list
			}
			let gift_cfg = null
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let lv = role_vo.level
			let info = null
			for (let key in gift_cfg) {
				info = local_Config.GetConfigVo(ConfigHasDefaultValue.config_gift_reward.name, key, false, gift_cfg)
				if (gift_id != info.goods_id) {
					break
				}
				if (info.slv && lv < info.slv) {
					break
				}
				if (info.elv && lv > info.elv) {
					break
				}
				let rand_gifts = local_Erlang.Parse(info.rand_gifts)
				for (let _tmpi in rand_gifts) {
					var rand_gift = rand_gifts[_tmpi]
					table.insert(list, rand_gift[0])
				}
				let fixed_gifts = local_Erlang.Parse(info.fixed_gifts)
				return list.concat(fixed_gifts)//table.merge(list, fixed_gifts)
			}
			return list
		}

		this.SetActInfo = (info?) => {
			this.ChangeVar("act_info", info)
		}

		this.GetActInfo = () => {
			return this.act_info
		}

		this.GetViewByActInfo = () => {
			let act_info = this.GetActInfo()
			if (!act_info) {
				return
			}
			if (act_info.status == 0) {
				return
			}

			if (act_info.stage == 3) {
				return window["EveningAnswerWaitView"]
			} else if (act_info.stage == 4) {
				if(this.EveningGameType()==2){
					//消消乐界面
					return window["ElimMainViewItem"]
				}
				return window["EveningAnswerView"]
			} else if (act_info.stage == 5) {
				return window["EveningDragonWaitView"]
			} else if (act_info.stage == 6) {
				
				return window["EveningBossView"]
			}
		}

		this.SetQuestInfo = (info?) => {
			//未开启或者答题结束
			if (info.status == 0||info.no==0) {
				this.answer_select_index=-1
				this.cur_question_id=-1
			}
			//更换题目，移除上一次的状态
			if(info.no>0&&info.no!=this.cur_question_id){
				this.answer_select_index=-1
			}
			this.ChangeVar("question_info", info)
		}

		this.GetQuestInfo = () => {
			return this.question_info
		}

		this.SetRankInfo = (info?) => {
			this.ChangeVar("rank_info", info)
		}

		this.GetRankInfo = () => {
			return this.rank_info
		}

		this.SetFireInfo = (info?) => {
			this.ChangeVar("fire_info", info)
		}

		this.GetFireInfo = () => {
			return this.fire_info
		}

		this.SetDragonInfo = (info?) => {
			this.ChangeVar("dragon_info", info)
		}

		this.GetDragonInfo = () => {
			return this.dragon_info
		}

		this.SetResultInfo = (info?) => {
			this.ChangeVar("result_info", info)
		}

		this.GetResultInfo = () => {
			return this.result_info
		}

		this.SetBossInfo = (info?) => {
			_boss_info_ = info
			this.Fire(GuildActEvent.UPDATE_BOSS_DATA, info)
		}

		this.GetBossInfo = () => {
			return _boss_info_
		}

		this.MyRankInfo=()=>{
			return this.my_rank_info
		}
		this.CheckOpenView = () => {
			let ainfo = this.GetActInfo()
			if (!ainfo) {
				return
			}
			if (ainfo.stage != 0) {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "EveningBaseView")
			} else {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "EveningBossNormalView")
				local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EveningBaseView")
			}
			let bool = ainfo.stage == 0
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(0, bool)
			mainUI_controller.SetMainUIViewVisible(10, bool)
			MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, bool)
		}

		this.OpenBossIcon = () => {
			// activity_icon_mgr.addIcon(402)
			// if (!SceneManager.GetInstance().IsEveningScene()) {
			// 	local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "EveningBossTipsView")
			// }
		}

		this.CloseBossIcon = () => {
			// local_GlobalEventSystem.Fire(local_EventName.CLOSE_VIEW, "EveningBossTipsView")
			// activity_icon_mgr.deleteIcon(402)
		}

		this.SetMainUIViewVisible = (bool?) => {
			let mainUI_controller = MainUIController.GetInstance()
			mainUI_controller.SetMainUIViewVisible(1, bool)
			mainUI_controller.SetMainUIViewVisible(2, bool)
		}

		/**公会晚宴小游戏名称 */
		this.GetEveningGameName=()=>{
			let str1 =this.EveningGameType()== 2 ?"消消乐":"答题"
			return str1
		}

		/**公会晚宴小游戏类型  1答题 2消消乐 */
		this.EveningGameType = ()=>{
			//这里是秘籍测试用
			if(this.evening_game_type == 0){
				return 1
			}
			if(this.evening_game_type == 1){
				return 2
			}
			//读配置
			let type = 1
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_gfeast
			if(cfg&&cfg[66]&&cfg[66]["value"]){
				let data = JSON.parse(cfg[66]["value"])
				let date = new Date(TimeUtil.getServerTimeMs())
				let day = date.getDay() == 0 ? 7 : date.getDay();//星期几 1 - 7
				//答题的时间段
				let arr = JSON.parse(cfg[66]["value"])
				let quiz_time_arr:Array<number> = arr[1][1] ||[]
				type = quiz_time_arr.indexOf(day)!=-1?2:1
			}
			return type
		}
	}


	static Instance: GuildActivityModel;
	public static GetInstance() {

		if (!GuildActivityModel.Instance) {
			GuildActivityModel.Instance = new GuildActivityModel()
		}
		return GuildActivityModel.Instance
	}

}
window["GuildActivityModel"] = GuildActivityModel