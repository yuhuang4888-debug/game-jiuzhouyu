import { BaseController } from "../common/BaseController"
import { GlobalTimerQuest, PlayBigEffect, Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { OutLineModel } from "../commonModel/OutLineModel"
import { DailyModel } from "../commonModel/DailyModel"
import { ViewManager } from "../common/ViewManager"
import { EnumViewOrder, ViewOrderModel, ViewOrderModelEvent } from "../commonModel/ViewOrderModel"
import "../outline/OutLineView"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import "../onHook/OnHookMainView"
import "../onHook/OnHookAdditionView"
import "../onHook/OnHookAdditionTips"
import { GoodsModel } from "../commonModel/GoodsModel"
import { table } from "../common/table"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Message } from "../sysInfo/SysInfoController"

export class OnHookController extends BaseController {
	InitInfo
	OpenOutlineView
	view_dic

	public constructor() {
		super()
		let onHookModel = OnHookModel.GetInstance()
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let daily_model = DailyModel.GetInstance()
		let local_OnHookModel = OnHookModel
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		this.view_dic = []
		let outline_view_ = null

		this.InitInfo = () => {
			let On13211 = () => {
				let scmd = user_msg_adapter.GetSCMD(13211)
				onHookModel.RequestItmer(scmd.next_time)
				if (scmd.error_code == 1) {
					if (scmd.had_afk_time) {
						onHookModel.onhook_total_time = scmd.had_afk_time
						onHookModel.Fire(OnHookModel.UPDATE_MAINUI_VIEW_RED)
					}
				} else {
					Util.ErrorCodeShow(scmd.error_code)
				}
			}
			let On13212 = () => {
				let scmd = user_msg_adapter.GetSCMD(13212)
				onHookModel.onhookTime = scmd.afk_time
				onHookModel.onhook_total_time = scmd.had_afk_time
				onHookModel.ol_award_dic = scmd
				onHookModel.exp_effect = scmd.exp_effect
				onHookModel.RequestItmer(scmd.next_time)
				if(scmd.had_afk_time && scmd.had_afk_time/3600 >=1 
					&&!ViewPopLevelModel.GetInstance().CheckViewIsPoping("OnHookMainView")){
					ViewPopLevelModel.GetInstance().SetSpacialView('OnHookMainView', true)
					// ViewPopLevelModel.GetInstance().SetView('OnHookMainView');
				}
				onHookModel.Fire(OnHookModel.REFRESH_EXP_EFFECT)
				onHookModel.Fire(OnHookModel.UPDATE_ONHOOK_VIEW)
				ViewPopLevelModel.GetInstance().SetSpacialView('OnHookMainView', false)
				if(!DailyModel.GetInstance().out_line_card_check_1){
					DailyModel.GetInstance().out_line_card_check_1 = true
					DailyModel.GetInstance().AutoUseOutLineTimeCard()
				}
			}
			let On13213 = () => {
				let scmd = user_msg_adapter.GetSCMD(13213)
				if (scmd.code == 1) {
					onHookModel.SetOutlineFindData(scmd)
					onHookModel.Fire(local_OnHookModel.UPDATE_REDEMPTION_INFO, scmd)
					Util.ShowCongratulationView([[5, 0, scmd.exp]])
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}
			let On13214 = () => {
				let scmd = user_msg_adapter.GetSCMD(13214)
				onHookModel.RequestItmer(scmd.next_time)
				onHookModel.onhookTime = scmd.afk_time
				daily_model.ShowRedDot()
			}
			let On13215 = () => {
				let scmd = user_msg_adapter.GetSCMD(13215)
				onHookModel.exp_effect = scmd.exp_effect
				console.log("13215 OutlineExp:" + scmd.exp_effect)
				onHookModel.Fire(OnHookModel.REFRESH_EXP_EFFECT)
			}
			let On13216 = () => {
				let scmd = user_msg_adapter.GetSCMD(13216)
				if (scmd["goods_list"]) {
					let goods_list = [];
					let gold = []
					let bin_gold = []
					for (let _tmpi in scmd["goods_list"]) {
						if (scmd["goods_list"][_tmpi].typeId == 0) {
							if (scmd["goods_list"][_tmpi].style == 3) {
								let vo = scmd["goods_list"][_tmpi]
								gold[0] = vo["style"];
								gold[1] = 31//vo["typeId"];
								gold[2] = vo["count"];
							}
							//continue
						}
						var vo = scmd["goods_list"][_tmpi];
						let info = [];
						info[0] = vo["style"];
						info[1] = vo["typeId"];
						info[2] = vo["count"];
						table.insert(goods_list, info);
					}
					let sort_fun = (a?, b?) => {
						let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(a.typeId);
						let basic2 = GoodsModel.GetInstance().GetGoodsBasicByTypeId(b.typeId);
						if (basic && basic2) {
							return basic2.color < basic.color;
						}
					}
					table.sort(goods_list, sort_fun);
					if (goods_list.length > 0) {
						if (!ViewPopLevelModel.GetInstance().IsLockView("CongratulationObtainView")) {
							let view = new CongratulationObtainView(goods_list, 10, null, null, null, null, null, null, null, null, { old_lv: scmd["old_lv"], old_lv_ratio: scmd["old_lv_ratio"] });
						view.Open();
						} else {
							ViewPopLevelModel.GetInstance().SetView("CongratulationObtainView", goods_list, 10, null, null, null, null, null, null, null, null, { old_lv: scmd["old_lv"], old_lv_ratio: scmd["old_lv_ratio"] })
						}
					}
					if (gold.length > 0) {
						onHookModel.Fire(OnHookModel.GETGOLDANI, gold, 1)
					}
					if (bin_gold.length > 0) {
						onHookModel.Fire(OnHookModel.GETGOLDANI, bin_gold, 2)
					}
				}
			}

			let On13217 = () => {
				let scmd = user_msg_adapter.GetSCMD(13217)
				onHookModel.Fire(OnHookModel.UPDATE_ADDITION_VIEW, scmd)
			}
			let On13218 = () => {
				let scmd = user_msg_adapter.GetSCMD(13218)
				let list = scmd.exp_list
				let exp = 0
				if (list && Util.TableSize(list) > 0) {
					for (let key in list) {
						let data = list[key]
						exp += data.add_exp
					}
				}
				onHookModel.auto_smelt_exp = exp
				// GlobalTimerQuest.AddDelayQuest(() => {
					
				// }, 2)

			}
			this.RegisterProtocal(13211, On13211)
			this.RegisterProtocal(13212, On13212)
			this.RegisterProtocal(13213, On13213)
			this.RegisterProtocal(13214, On13214)
			this.RegisterProtocal(13215, On13215)
			this.RegisterProtocal(13216, On13216)
			this.RegisterProtocal(13217, On13217)
			this.RegisterProtocal(13218, On13218)


			// 处理先后顺序问题
			ViewOrderModel.GetInstance().Bind(ViewOrderModelEvent.PROTO_OUT_LINE, () => {
				this.SendFmtToGame(13212)
			})

			onHookModel.Bind(local_OnHookModel.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)


			onHookModel.Bind(local_OnHookModel.OPEN_VIEW, (view_name, ...new_args) => {
				let view = this.view_dic[view_name];
				if (!view) {
					this.view_dic[view_name] = true;
					if (this.view_dic[view_name] == true) {
						let view_class: any = window[view_name];
						view = new view_class();
						this.view_dic[view_name] = view;
					}
				}
				if (view) {
					view.Open(...new_args);
				}
			})
			local_GlobalEventSystem.Bind(EventName.GAME_START, () => {
				OnHookModel.GetInstance().call_back_obj = null
			})
		}


		this.OpenOutlineView = () => {
			ViewPopLevelModel.GetInstance().SetView('OutLineView');
			daily_model.ShowRedDot()
		}

		this.InitInfo()
	}
}
window["OnHookController"] = OnHookController