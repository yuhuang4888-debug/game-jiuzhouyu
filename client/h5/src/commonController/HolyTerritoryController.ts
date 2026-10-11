
//require("game.holyTerritory.HolyTerritoryDsgtView")
//require("game.holyTerritory.HolyTerritoryGuildView")
//require("game.holyTerritory.holyTerritoryMainView")
//require("game.holyTerritory.HolyTerritoryMapView")
//require("game.holyTerritory.HolyTerritoryModel")
//require("game.holyTerritory.HolyTerritoryMonsterView")
//require("game.holyTerritory.HolyTerritoryTotalView")
//require("game.holyTerritory.holyTerritoryRecordRenderer")
//require("game.holyTerritory.HTGuildRankRenderer")
//require("game.holyTerritory.HTMonsterItem")
//require("game.holyTerritory.HTRoleRankRenderer")
//require("game.holyTerritory.HTTopItem")
//require("game.proto.283.Require283")

import { BaseController } from "../common/BaseController"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { RoleManager } from "../commonModel/RoleManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { SceneManager } from "../scene/SceneManager"
import { EventName } from "../common/EventName"
import { Alert, Alert_Type } from "../alert/Alert"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { table } from "../common/table"
import { TimeUtil } from "../util/TimeUtil"
import { ResManager } from "../common/ResManager"
import { MainUIModel } from "../commonModel/MainUIModel"
import { Config } from "../common/Config"
import "../holyTerritory/HTGuildRankRenderer"
import "../holyTerritory/HolyTerritoryDsgtView"
import "../holyTerritory/HolyTerritoryGuildView"
import "../holyTerritory/holyTerritoryMainView"
import "../holyTerritory/HolyTerritoryMapView"
import "../holyTerritory/HolyTerritoryMonsterView"
import "../holyTerritory/holyTerritoryRecordRenderer"
import "../holyTerritory/HolyTerritoryTotalView"
import "../holyTerritory/HTMonsterItem"
import "../holyTerritory/HTRoleRankRenderer"
import "../holyTerritory/HTTopItem"
import "../sacredShop/SacredShopItem"
import "../sacredShop/SacredShopView"
import "../holyTerritory/HolyTerritoryOpenView"
import { BossModel } from "../commonModel/BossModel"
import { ReliveModel } from "../commonModel/ReliveModel"
export class HolyTerritoryController extends BaseController {
	InitInfo

	public constructor() {
		super()


		let model = HolyTerritoryModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_BossBaseModel = BossModel
		let boss_base_model = local_BossBaseModel.GetInstance()
		let boss_type = local_BossBaseModel.BossType
		let local_HTEvent = HTEvent
		let scene_mgr = SceneManager.GetInstance()
		let local_EventName = EventName
		let local_Alert = Alert
		let local_Alert_Type = Alert_Type
		let sever_time_model = ServerTimeModel.GetInstance()
		let local_Message = Message
		let local_GlobalEventSystem = GlobalEventSystem

		//let function_open_model = FunctionOpenModel.GetInstance()
		let view_dic_ = []
		let reconnect_ = false
		this.InitInfo = () => {
			let roleVo = role_mgr.GetMainRoleVo()
			let On28300 = () => {
				let scmd = user_msg_adapter.GetSCMD(28300)
				if (scmd.code != 1012) {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let openFunc = () => {
				//if ((model.NeedShow && ! function_open_model.need_show_open_fun_data_cache) && sever_time_model.GetOpenServerDay() == model.minDay ) {
				//let cfg = CommonManager.GetInstance().GetFunctionIconCfg(283)
				//if (cfg ) {
				//let openDay = sever_time_model.GetOpenServerDay()
				//if (((roleVo.level < cfg.open_lv || openDay < cfg.open_day) || cfg.max_open_day && openDay > cfg.max_open_day) || cfg.open_task_id && TaskModel.GetInstance().newest_finish_task_id < cfg.open_task_id ) {
				//return
				//}
				//}
				//let info = [id=283, sort_no=0, name="圣域", condition="[[\"1\":\"lv\",\"2\":160]]", icon="3721", icon_text="<font color=0xb3ff48>圣域</font><font color=0xFFFF00>160级</font><font color=0xb3ff48>开启</font>", icon_open_text="参与击杀圣域BOSS\n镶嵌圣印提升战力", desc="参与击杀圣域BOSS\n镶嵌圣印提升战力", reward="[]", title="【圣域】系统开启啦~", content="【圣域】系统开启啦~\n参与击杀圣域BOSS\n镶嵌圣印提升战力", show_lv=1]
				//function_open_model:Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenAutoView", info)
				//model.showArrow = true
				//this:SendFmtToGame(28315)
				//}
			}

			let On28301 = () => {
				let scmd = user_msg_adapter.GetSCMD(28301)
				scmd["boss_type"] = boss_type.holyterritory
				table.sort(scmd.boss_info, (b?, a?) => {
					return a.boss_id < b.boss_id
				})
				model.monsterData[scmd.sanctuary_id] = scmd
				model.Fire(local_HTEvent.UPDATE_MONSTER_DATA, scmd)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_cfg
				model.SetBossInfo(scmd, cfg)
				model.RedFunc()
				if (scene_mgr.IsHolyTerritory() && reconnect_) {
					reconnect_ = false
					let info = boss_base_model.GetBossTypeInfo(boss_type.holyterritory)
					boss_base_model.Fire(local_EventName.OPEN_BOSS_SCENE_VIEW, true, boss_type.holyterritory)
					boss_base_model.TryToCreatGrave()
				}
			}

			let On28302 = () => {
				let scmd = user_msg_adapter.GetSCMD(28302)
				model.gRankData = scmd
				model.Fire(local_HTEvent.UPDATE_GUILD_RANk)
			}

			let On28303 = () => {
				let scmd = user_msg_adapter.GetSCMD(28303)
				if (scmd.code == 1) {
					model.Fire(local_HTEvent.GO_HT)
				}
			}

			let On28305 = () => {
				let scmd = user_msg_adapter.GetSCMD(28305)
				// [ts2lua]model.monsterData下标访问可能不正确
				if (model.monsterData[scmd.sanctuary_id]) {
					// [ts2lua]model.monsterData下标访问可能不正确
					for (let _tmpi in model.monsterData[scmd.sanctuary_id].boss_info) {
						var vo = model.monsterData[scmd.sanctuary_id].boss_info[_tmpi]
						if (vo.boss_id == scmd.boss_id) {
							vo.is_remind = scmd.remind
							break
						}
					}
					// [ts2lua]lua中0和空字符串也是true，此处scmd.remind需要确认
					local_Message.show(((scmd.remind && scmd.remind != 0) && ("关注成功") || ("取消关注")))
					model.Fire(local_HTEvent.UPDATE_FGOLLOW_INFO, scmd)
				}
			}

			let On28306 = () => {
				let scmd = user_msg_adapter.GetSCMD(28306)
				if (scene_mgr.IsHolyTerritory()) {
					let server_day = ServerTimeModel.GetInstance().GetOpenServerDay()
					let des = server_day == 4 ? "8:00-19:30" : "8:00-19:30\n                        21:30-2:00"
					if (scmd.end_time - TimeUtil.getServerTime() > 0) {
						local_Alert.Show(Util.StrToHTML(`<font color='#ff4f50'>异域活动将在5分钟后暂时关闭，请知悉！</font><br>异域开放时间:<font color='#639c12'>${des}</font>`), local_Alert_Type.One, null, null, "我知道了")
					} else {
						local_Alert.Show(Util.StrToHTML(`<font color='#ff4f50'>异域活动暂时关闭，请知悉！</font><br>异域开放时间:<font color='#639c12'>${des}</font>`), local_Alert_Type.One, null, null, "我知道了")
					}
				}
			}

			let On28307 = () => {
				let scmd = user_msg_adapter.GetSCMD(28307)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_cfg
				if (scene_mgr.IsFieldScene()) {
					let show = true
					let info = BossModel.GetInstance().GetBossTypeInfo(BossModel.BossType.holyterritory)
					if (info && info.tired >= info.all_tired) {
						let boss_info = cfg[scmd.boss_id]
						if (boss_info && boss_info.sign == 1) {
							show = false
						}
					}
					if (show && model.IsSelfHTById(scmd.sanctuary_id)) {
						scmd["boss_type"] = boss_type.holyterritory
						boss_base_model.Fire(local_BossBaseModel.OPEN_REBORN_TIPS_VIEW, scmd, 283)
					}
				}
			}

			let On28308 = () => {
				let scmd = user_msg_adapter.GetSCMD(28308)
				ReliveModel.GetInstance().SetReliveTimeData(scmd, ReliveModel.BossSpecialReliveType.HolyTerr)
			}

			let On28309 = () => {
				let scmd = user_msg_adapter.GetSCMD(28309)
				model.SetBossRebornTime(scmd.sanctuary_id, scmd.boss_id, scmd.reborn_time)
				boss_base_model.Fire(local_BossBaseModel.KILL_BOSS, scmd)
				model.RedFunc()
				boss_base_model.TryToCreatGrave()
			}

			let On28310 = () => {
				let scmd = user_msg_adapter.GetSCMD(28310)
				model.rRankData = scmd
				model.Fire(local_HTEvent.UPDATE_ROLE_RANK, scmd)
			}

			let On28311 = () => {
				let scmd = user_msg_adapter.GetSCMD(28311)
				// [ts2lua]model.killData下标访问可能不正确
				model.killData[scmd.sanctuary_id + "@" + scmd.boss_id] = scmd.kill_log
				model.Fire(local_HTEvent.KILL_DATA, scmd)
			}

			let On28312 = () => {
				let scmd = user_msg_adapter.GetSCMD(28312)
				// [ts2lua]model.dsgtData下标访问可能不正确
				model.dsgtData[scmd.sanctuary_id] = scmd.rank_list
				model.Fire(local_HTEvent.DSGT_DATA, scmd)
			}

			let On28313 = () => {
				let scmd = user_msg_adapter.GetSCMD(28313)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_boss_cfg
				if (scene_mgr.IsFieldScene()) {
					let bossInfo = cfg[scmd.boss_id]
					if ((bossInfo && bossInfo.sign) && model.IsSelfHT(scmd.sanctuary_id)) {
						return
					}
					scmd["boss_type"] = boss_type.holyterritory
					scmd["tips"] = "正在被攻击"
					boss_base_model.Fire(local_BossBaseModel.OPEN_REBORN_TIPS_VIEW, scmd, 283)
				}
			}

			let On28314 = () => {
				let scmd = user_msg_adapter.GetSCMD(28314)
				model.SettleInfo = scmd
				model.Fire(local_HTEvent.UPDATE_SETTLE, scmd)
			}

			let On28316 = () => {
				let scmd = user_msg_adapter.GetSCMD(28316)
				if (sever_time_model.GetOpenServerDay() == model.minDay && scmd.code == 0) {
					model.NeedShow = true
					openFunc()
				} else {
					model.NeedShow = false
				}
			}

			let On28317 = () => {
				let scmd = user_msg_adapter.GetSCMD(28317)
				local_Message.show("击杀成功，我方结社增加" + scmd.point + "异域积分")
			}

			let On28318 = () => {
				let scmd = user_msg_adapter.GetSCMD(28318)
				if (scene_mgr.IsHolyTerritory()) {

				}
				model.SetFatigue(scmd.fatigue)
			}

			let On28319 = () => {
				let scmd = user_msg_adapter.GetSCMD(28319)
				local_Message.show("击杀疲劳+" + scmd.fatigue + "(疲劳上限" + model.maxFatige + "）")
			}

			let reCon = () => {
				if (scene_mgr.IsHolyTerritory() && !scene_mgr.last_scene_id) {
					// [ts2lua]model.sceneIdtoIndex下标访问可能不正确
					this.SendFmtToGame(28301, "c", model.sceneIdtoIndex[scene_mgr.GetSceneId()])
					this.SendFmtToGame(28314)
					reconnect_ = true
				}
				let scene = scene_mgr.GetSceneId()
				// [ts2lua]model.sceneIdtoIndex下标访问可能不正确
				if ((model.SettleInfo && model.SettleInfo.sanctuary_id) && model.sceneIdtoIndex[scene] == model.SettleInfo.sanctuary_id) {
					model.SelfHT = true
				} else {
					model.SelfHT = false
				}
			}

			local_GlobalEventSystem.Bind(SceneManager.START, reCon)
			this.RegisterProtocal(28300, On28300)
			this.RegisterProtocal(28301, On28301)
			this.RegisterProtocal(28302, On28302)
			this.RegisterProtocal(28303, On28303)
			this.RegisterProtocal(28305, On28305)
			this.RegisterProtocal(28306, On28306)
			this.RegisterProtocal(28307, On28307)
			this.RegisterProtocal(28308, On28308)
			this.RegisterProtocal(28309, On28309)
			this.RegisterProtocal(28310, On28310)
			this.RegisterProtocal(28311, On28311)
			this.RegisterProtocal(28312, On28312)
			this.RegisterProtocal(28313, On28313)
			this.RegisterProtocal(28314, On28314)
			this.RegisterProtocal(28316, On28316)
			this.RegisterProtocal(28317, On28317)
			this.RegisterProtocal(28318, On28318)
			this.RegisterProtocal(28319, On28319)
			model.Bind(local_HTEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = view_dic_[view_name]
				if (!view) {
					let view_class = window[view_name]
					view = new view_class()
					view_dic_[view_name] = view
				}
				if (view && view != true) {
					// view.Open(...new_args)
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, view_name,...new_args)
				}

				
			}
			)
			model.Bind(local_HTEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				model.InitCfg()
				let delay_fun = () => {
					let i = 1
					do {
						this.SendFmtToGame(28301, "c", i)
						i = i + 1
					} while ((i <= 3))
					this.SendFmtToGame(28314)
					this.SendFmtToGame(28316)
					this.SendFmtToGame(28318)
				}
				setTimeout(delay_fun, 3)
			}
			)


			MainUIModel.GetInstance().BindOne("activity_state", (event_name?, value?) => {
				//if (value ) {
				//openFunc()
				//}
			}
			)
			roleVo.BindOne(local_EventName.CHANGE_LEVEL, () => {
				if (((!model.NeedShow && sever_time_model.GetOpenServerDay() == model.minDay) && roleVo.level == 95)) {
					this.SendFmtToGame(28316)
				}
			}
			)
			local_GlobalEventSystem.Bind(ServerTimeModel.HOUR_REFRESH, () => {
				if ((!model.NeedShow && sever_time_model.GetOpenServerDay() == model.minDay) && roleVo.level >= 95) {
					this.SendFmtToGame(28318)
				}
			}
			)
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, () => {
				if ((sever_time_model.GetOpenServerDay() == model.maxDay + 1)) {
					if (view_dic_["holyTerritoryMainView"] && view_dic_["holyTerritoryMainView"].HasOpen()) {
						view_dic_["holyTerritoryMainView"].Close()
					}
				}
			}
			)
			role_mgr.GetMainRoleVo().BindOne("guild_id", () => {
				this.SendFmtToGame(28314)
			}
			)
		}

		this.InitInfo()
	}

}
window["HolyTerritoryController"] = HolyTerritoryController