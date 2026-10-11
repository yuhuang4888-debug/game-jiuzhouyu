
//require("game.dailyAct.pray.PrayModel")
//require("game.dailyAct.pray.PrayBaseView")
//require("game.dailyAct.pray.PrayItemView")
//require("game.dailyAct.pray.PrayMainView")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { PrayModel } from "../commonModel/PrayModel"
import { VipModel } from "../commonModel/VipModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import  "../pray/PrayBaseView"
import { RoleManager } from "../commonModel/RoleManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

//require("game.proto.415.Require415")
export class PrayController extends BaseController {
InitEvent
InitInfo
_pray_view

public constructor(){
super() 
	
	
	let model = PrayModel.GetInstance()
	let local_PrayModel = PrayModel
	let local_GlobalEventSystem = GlobalEventSystem
	
	let local_EventName = EventName
	let activity_icon_mgr = ActivityIconManager.GetInstance()
	let role_mgr = RoleManager.GetInstance()
	let user_msg_adapter = UserMsgAdapter.GetInstance()
	this.InitEvent = () => {
		model.Bind(local_PrayModel.SCMD_REQUEST,(cmd, ...new_args) => {
				if (cmd == 41501 ) {
					this.SendFmtToGame(cmd)
				} else if (cmd == 41502 ) {
					this.SendFmtToGame(cmd, "c", ...new_args)
				}
			}
		)
		let HOUR_REFRESH = (time?) => {
			if (time == 4 ) {
				model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
			}
		}
		
		local_GlobalEventSystem.Bind(ServerTimeModel.HOUR_REFRESH, HOUR_REFRESH)
		let OpenPrayView = () => {
			if (! this._pray_view ) {
				// [ts2lua]window下标访问可能不正确
				if (! window["PrayBaseView"] ) {
					if (! ResManager.GetInstance().IsJsLoad("dailyAct") ) {
						
					}
				}
				// [ts2lua]window下标访问可能不正确
				let view_class = window["PrayBaseView"]
				this._pray_view =  new view_class()
			}
			model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
			this._pray_view.Open()
		}
		
		local_GlobalEventSystem.Bind(local_EventName.OPEN_PRAY_VIEW, OpenPrayView)
		let LevelChange = (_lv?) => {
			if (_lv >= model.open_level ) {
				activity_icon_mgr.addIcon("415")
				model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
			}
		}
		
		role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, LevelChange)
		
		local_GlobalEventSystem.Bind(local_EventName.GAME_START,() => {
				model.LoadConfig()
				let role_lv = role_mgr.GetMainRoleVo().level
				if (role_lv >= model.open_level ) {
					activity_icon_mgr.addIcon("415")
					model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
				}else{
					activity_icon_mgr.deleteIcon("415")
				}
			}
		)
		role_mgr.GetMainRoleVo().Bind("vip_flag",(vip_flag?) => {
				model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
			}
		)
		VipModel.GetInstance().Bind(VipModel.UPDATE_NOBLE_STATE,() => {
				model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
			}
		)
	}
	
	this.InitInfo = () => {
		let On41500 = () => {
			let scmd = user_msg_adapter.GetSCMD(41500)
			if (scmd.errcode != 1 ) {
				Util.ErrorCodeShow(scmd.errcode)
			}
		}
		
		let On41501 = () => {
			let scmd = user_msg_adapter.GetSCMD(41501)
			model.pray_info_list = scmd.list
			// [ts2lua]scmd.list[0]下标访问可能不正确
			if (scmd.list[0]["free_times"] == 0 ) {
				// [ts2lua]scmd.list[0]下标访问可能不正确
				model.time = scmd.list[0]["endtime"] - TimeUtil.getServerTime()
				if (model.time > 0 ) {
					model.InitEvent()
				}
				model.SetShowRed(false)
				model.Fire(local_PrayModel.SHOW_RED, false)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "415", false)
			}else{
				model.SetShowRed(true)
				model.Fire(local_PrayModel.SHOW_RED, true)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, "415", true)
			}
			model.Fire(local_PrayModel.GET_PRAY_INFO)
		}
		
		let On41502 = () => {
			let scmd = user_msg_adapter.GetSCMD(41502)
			// [ts2lua]model.pray_reward_dic下标访问可能不正确
			model.pray_reward_dic["type"] = scmd.type
			// [ts2lua]model.pray_reward_dic下标访问可能不正确
			model.pray_reward_dic["crit"] = scmd.crit
			// [ts2lua]model.pray_reward_dic下标访问可能不正确
			model.pray_reward_dic["reward"] = scmd.reward
			model.Fire(local_PrayModel.SCMD_REQUEST, 41501)
			model.Fire(local_PrayModel.GET_PRAY_REWARD)
		}
		
		this.RegisterProtocal(41500, On41500)
		this.RegisterProtocal(41501, On41501)
		this.RegisterProtocal(41502, On41502)
	}
	
	this.InitInfo()
	this.InitEvent()
}

}
window["PrayController"] = PrayController