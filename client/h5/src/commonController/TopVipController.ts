
//require("game.topVip.TopVipActivationSkillView")
//require("game.topVip.TopVipActivityDetailItem")
//require("game.topVip.TopVipActivityDetailView")
//require("game.topVip.TopVipActivityPromotionItem")
//require("game.topVip.TopVipActivityPromotionView")
//require("game.topVip.TopVipBaseView")
//require("game.topVip.TopVipMainView")
//require("game.topVip.TopVipModel")
//require("game.topVip.TopVipRodItem")
//require("game.topVip.TopVipShopItem")
//require("game.topVip.TopVipShopView")
//require("game.topVip.TopVipSkillDetailItem")
//require("game.topVip.TopVipSkillDetailView")
//require("game.topVip.TopVipSkillIntroduceView")
//require("game.topVip.TopVipSkillItem")
//require("game.topVip.TopVipSkillPointView")
//require("game.topVip.TopVipSkillView")
//require("game.topVip.TopVipTaskItem")
//require("game.topVip.TopVipTaskView")

import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { BossModel } from "../commonModel/BossModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { TopVipEvent, TopVipModel } from "../commonModel/TopVipModel"
import "../topVip/TopVipBaseView"
import "../topVip/TopVipActivityDetailView"
import "../topVip/TopVipSkillIntroduceView"
import "../topVip/TopVipActivityPromotionView"
import "../topVip/TopVipSkillDetailView"
import "../topVip/TopVipSkillPointView"
import "../topVip/TopVipActivationSkillView"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"

//require("game.proto.451.Require451")
export class TopVipController extends BaseController {
	InitInfo
	ShowRankBreachReward

	public constructor() {
		super()


		this.InitInfo = () => {
			let model = TopVipModel.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let request_proto_event = TopVipEvent.TOP_VIP_REQUEST_PROTO
			let role_mgr = RoleManager.GetInstance()
			let local_Message = Message

			let activity_icon_mgr = ActivityIconManager.GetInstance()
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let local_TopVipEvent = TopVipEvent
			let local_Erlang = ErlangParser.GetInstance()
			let view_dic_ = []
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				let delay_fun = () => {
					model.Fire(request_proto_event, 45101)
					model.Fire(request_proto_event, 45102)
					model.Fire(request_proto_event, 45104)
				}
				setTimeout(delay_fun, 2.5)
			}
			)
			model.Bind(request_proto_event, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.OPEN_TOP_VIP_BASE_VIEW, (index?) => {
				let vip_level = role_mgr.GetMainRoleVo().vip_flag
				let lv = role_mgr.GetMainRoleVo().level
				if (vip_level < 4) {
					local_Message.show("需激活vip4才可购买至尊vip")
					return
				}
				// [ts2lua]view_dic_下标访问可能不正确
				let view = view_dic_["TopVipBaseView"]
				if (view && view != true) {
					view.DeleteMe()
					// [ts2lua]view_dic_下标访问可能不正确
					view_dic_["TopVipBaseView"] = null
					view = null
				}
				if (!view) {
					// [ts2lua]view_dic_下标访问可能不正确
					view_dic_["TopVipBaseView"] = true
					// [ts2lua]window下标访问可能不正确
					if (!window["TopVipBaseView"]) {
						if (!ResManager.GetInstance().IsJsLoad("topVip")) {

						}
					}
					// [ts2lua]view_dic_下标访问可能不正确
					if (view_dic_["TopVipBaseView"]) {
						// [ts2lua]window下标访问可能不正确
						let view_class = window["TopVipBaseView"]
						view = new view_class()
						// [ts2lua]view_dic_下标访问可能不正确
						view_dic_["TopVipBaseView"] = view
					}
				}
				if (view && view != true) {
					if (index) {
						view.SetDefaultIndex(index)
					}
					view.Open()
				}
			}
			)
			model.Bind(local_TopVipEvent.OPEN_TOP_VIP_View, (view_name: string, ...new_args) => {
				// [ts2lua]view_dic_下标访问可能不正确
				let view = view_dic_[view_name]
				if (!view) {
					// [ts2lua]view_dic_下标访问可能不正确
					view_dic_[view_name] = true
					// [ts2lua]window下标访问可能不正确
					// [ts2lua]view_dic_下标访问可能不正确
					if (view_dic_[view_name] == true) {
						// [ts2lua]window下标访问可能不正确
						let view_class = window[view_name]
						view = new view_class()
						// [ts2lua]view_dic_下标访问可能不正确
						view_dic_[view_name] = view
					}
				}
				if (view && view != true) {
					if (!view.HasOpen()) {
						view.Open(...new_args)
					}
				}
			}
			)
			GoodsModel.GetInstance().Bind(GoodsModel.CREATE_SPECIAL_SCORE_FINISH,()=>{
				model.CheckShopRed()
				model.CheckSupremeVipIconRed()
			})
			GoodsModel.GetInstance().Bind(GoodsModel.UPDATE_SPECIAL_SCORE,()=>{
				model.CheckShopRed()
				model.CheckSupremeVipIconRed()
			})
			// ShopModel.GetInstance().Bind(ShopEvent.BUY_GOODS_SUCCESS,()=>{
			// 	model.CheckShopRed()
			// 	model.CheckSupremeVipIconRed()
			// })
			// CustomActivityModel.GetInstance().Bind(CustomActivityDefine.EVENT.RECHARGE_SUCCESS,()=>{
			// 	model.CheckShopRed()
			// 	model.CheckSupremeVipIconRed()
			// })
			// model.Bind(local_TopVipEvent.UPDATE_SHOP_RED,()=>{
			// 	model.CheckShopRed()
			// 	model.CheckSupremeVipIconRed()
			// })
			let vip_flag = () => {
				let vip_flag = role_mgr.GetMainRoleVo().vip_flag
				let level = role_mgr.GetMainRoleVo().level
				let icon = activity_icon_mgr.getIconInfo(451)
				if ((!icon && vip_flag >= 4) && level >= 160) {
					activity_icon_mgr.addIcon(451)
				}
			}

			role_mgr.GetMainRoleVo().BindOne("vip_flag", vip_flag)
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, vip_flag)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, vip_flag)
			let Handle45101 = () => {
				let scmd = user_msg_adapter.GetSCMD(45101)
				model.SetMyTopVipVo(scmd)
				model.CheckDayRewardRed(scmd)
				model.CheckSupremeVipIconRed()
				model.Fire(local_TopVipEvent.UPDATE_TOP_VIP_MAIN_VIEW)
				model.Fire(local_TopVipEvent.UPDATE_TOP_VIP_PROMOTION_VIEW)
			}

			let Handle45102 = () => {
				let scmd = user_msg_adapter.GetSCMD(45102)
				model.SetSkillTask(scmd)
				model.Fire(local_TopVipEvent.UPDATE_TOP_VIP_SKILL_VIEW)
				model.CheckSkillRed(scmd.task_list)
				model.CheckSupremeVipIconRed()
			}

			let Handle45103 = () => {
				let scmd = user_msg_adapter.GetSCMD(45103)
				let task_id = scmd.task_id
				if (scmd.error_code == 1) {
					model.SetSkillTaskVo(task_id, scmd.is_up)
					model.SetReceiveTask(task_id)
					let task = model.GetSkillTask()
					let task_list = task.task_list
					model.CheckSkillRed(task_list)
					model.CheckSupremeVipIconRed()
					model.Fire(local_TopVipEvent.ADD_SKILL_EFFECT, scmd.is_up)
					model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45102)
					ResManager.GetInstance().LoadGameConfig(this, "config_supreme_vip_skill_task", false, null, (cfg) => {
						let config_supreme_vip_skill_task = cfg
						let list = null
						for (let key in config_supreme_vip_skill_task) {

							// [ts2lua]config_supreme_vip_skill_task下标访问可能不正确
							let cfg = config_supreme_vip_skill_task[key]
							if (cfg.task_id == task_id) {
								let reward = null
								reward = cfg.reward
								list = JSON.parse(reward)
								this.ShowRankBreachReward(list)
							}
						}
					})
				} else {
					//model:DeleteEffectPosIndex()
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handle45104 = () => {
				let scmd = user_msg_adapter.GetSCMD(45104)
				model.SetSupremeVipTaskVo(scmd)
				model.Fire(local_TopVipEvent.UPDATE_TOP_VIP_TASK_VIEW)
				model.CheckTaskRed(scmd.task_list)
				model.CheckSupremeVipIconRed()
			}

			let Handle45105 = () => {
				let scmd = user_msg_adapter.GetSCMD(45105)
				let task_id = scmd.task_id
				if (scmd.error_code == 1) {
					ResManager.GetInstance().LoadGameConfig(this,"config_supreme_vip_currency_task",false,null,(cfg)=>{
						let config_supreme_vip_currency_task = cfg
						let list = null
						for (let key in config_supreme_vip_currency_task) {
	
							if (key == task_id) {
								let reward = null
								// [ts2lua]config_supreme_vip_currency_task下标访问可能不正确
								reward = config_supreme_vip_currency_task[key].reward
								list = JSON.parse(reward)
								this.ShowRankBreachReward(list)
								model.Fire(request_proto_event, 45104)
							}
						}
						model.CheckShopRed()
						model.CheckSupremeVipIconRed()
					})
					
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handle45106 = () => {
				let scmd = user_msg_adapter.GetSCMD(45106)
				if (scmd.error_code == 1001) {
					local_Message.show("勾玉不足，请前往充值")
					VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, "RechargeView")
				} else if (scmd.error_code == 1) {
					model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipActivityDetailView", 0)
					model.Fire(request_proto_event, 45101)
					model.Fire(request_proto_event, 45104)
					model.Fire(request_proto_event, 45102)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handle45107 = () => {
				let scmd = user_msg_adapter.GetSCMD(45107)
				if (scmd.error_code == 1) {
					model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipActivityDetailView", 1)
					model.Fire(request_proto_event, 45101)
					model.Fire(request_proto_event, 45104)
					model.Fire(request_proto_event, 45102)
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handle45108 = () => {
				let scmd = user_msg_adapter.GetSCMD(45108)
				if (scmd.error_code == 0) {
					local_Message.show("升至永久至尊vip，立享丰厚每日礼包")
				} else if (scmd.right_type == 8 && scmd.error_code == 1) {
					ResManager.GetInstance().LoadGameConfig(this,"config_supreme_vip",false,null,(cfg)=>{
						let config_supreme_vip = cfg
						let list = null
						for (let key in config_supreme_vip) {
	
							if (key == "2@8") {
								let reward = null
								// [ts2lua]config_supreme_vip下标访问可能不正确
								reward = config_supreme_vip[key]
								list =JSON.parse(reward.args)
								this.ShowRankBreachReward(list)
								model.Fire(request_proto_event, 45101)
							}
						}
					})
			
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}

			let Handle45109 = () => {
				let scmd = user_msg_adapter.GetSCMD(45109)
				model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipActivityDetailView", 1)
				model.Fire(request_proto_event, 45101)
			}

			let Handle45110 = () => {
				let scmd = user_msg_adapter.GetSCMD(45110)
				let task_list = scmd.task_list
				model.CheckSkillRed(task_list)
				model.CheckSupremeVipIconRed()
				model.Fire(request_proto_event, 45102)
			}

			let Handle45111 = () => {
				let scmd = user_msg_adapter.GetSCMD(45111)
				let task_list = scmd.task_list
				model.CheckTaskRed(task_list)
				model.CheckSupremeVipIconRed()
				model.Fire(request_proto_event, 45104)
			}

			let Handle45112 = () => {
				let scmd = user_msg_adapter.GetSCMD(45112)
				BossModel.GetInstance().Fire(BossModel.UPDATE_WAR_FREE_VIEW)
			}

			this.RegisterProtocal(45101, Handle45101)
			this.RegisterProtocal(45102, Handle45102)
			this.RegisterProtocal(45103, Handle45103)
			this.RegisterProtocal(45104, Handle45104)
			this.RegisterProtocal(45105, Handle45105)
			this.RegisterProtocal(45106, Handle45106)
			this.RegisterProtocal(45107, Handle45107)
			this.RegisterProtocal(45108, Handle45108)
			this.RegisterProtocal(45109, Handle45109)
			this.RegisterProtocal(45110, Handle45110)
			this.RegisterProtocal(45111, Handle45111)
			this.RegisterProtocal(45112, Handle45112)
		}

		this.ShowRankBreachReward = (list?) => {
			let data = []
			for (let _tmpi in list) {
				var reward = list[_tmpi]
				let vo = []
				vo[0]=reward[0]
				table.insert(vo, reward[1])
				table.insert(vo, reward[2])
				table.insert(data, vo)
			}
			if (data.length > 0) {
				let view = new CongratulationObtainView(data, 10)
				view.Open()
			}
		}

		this.InitInfo()
	}
}
window["TopVipController"]=TopVipController