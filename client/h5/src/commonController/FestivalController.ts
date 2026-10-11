import { BaseController } from '../common/BaseController';
import { EventName } from '../common/EventName';
import { UserMsgAdapter } from '../common/UserMsgAdapter';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { EnumFestivalGetRewardType, EnumFestivalTypeName, FestivalModel, FestivalModelEvent, IS2CFestivalBasicInfo, IS2CFestivalTasks } from '../commonModel/FestivalModel';
import { ActivityIconManager } from '../commonModel/ActivityIconManager';
import { FestivalBaseView } from '../festival/FestivalBaseView';
import { FestivalGoToAscendingOrderView } from './../festival/FestivalGoToAscendingOrderView';
import { Message } from '../sysInfo/SysInfoController';
import { table } from '../common/table';
import "../festival/FestivalTaskView"
import "../festival/FestivalLevelAwardView"
import "../festival/FestivalCommodityView"
import "../festival/FestivalUpLevelView"
import "../festival/FestivalUpLevelTipsView"
import { Util } from '../util/Util';
import { RoleManager } from '../commonModel/RoleManager';
import { FestivalGetRewardView } from '../festival/FestivalGetRewardView';
import { PlatformManager } from '../PlatformManager';



export enum EnumFestivalProtocol {
	eModuleId = 194,
	eProtocol19400 = 19400,
	eProtocol19401,
	eProtocol19402,
	eProtocol19403,
	eProtocol19404,
	eProtocol19405,
}

export class FestivalController extends BaseController {
	private InitInfo: Function;
	private InitEvents: Function;
	private _viewDic = [];

	private _fesvalView: FestivalBaseView;
	private _FestivalGoToAscendingOrderView: FestivalGoToAscendingOrderView;

	private get FestivalModel() {
		return FestivalModel.GetInstance();
	}

	public constructor() {
		super();

		let UMSG = UserMsgAdapter.GetInstance();
		this.InitEvents = () => {
			// 协议发送
			this.FestivalModel.Bind(
				FestivalModelEvent.FESTIVAL_REQUEST_PROTO,
				(id: number, fmt: string, ...new_args) => {
					this.SendFmtToGame(id, fmt, ...new_args);
				}
			);

			this.FestivalModel.Bind(
				FestivalModelEvent.OPEN_FESTIVAL_VIEW,
				(view_name: string, ...newAgrs) => {
					if (this.FestivalModel.GetEntranceOpenState()) {
						if (!this.FestivalModel.GetFestivalFirstCheck()) {
							let view: FestivalGoToAscendingOrderView = new FestivalGoToAscendingOrderView();
							if (view) {
								this.FestivalModel.SetFestivalFirstCheck();
								view.Open();
							}
						} else {
							let view = this._viewDic[view_name];
							if (!view) {
								this._viewDic[view_name] = true;
								if (this._viewDic[view_name] == true) {
									let viewClass = window[view_name];
									view = new viewClass();
									this._viewDic[view_name] = view;
								}
							}
							if (view && view != true) {
								view.Open(...newAgrs);
							}
						}
					} else {
						if (RoleManager.GetInstance().GetMainRoleVo().level > 120) {
							Message.show('活动暂未开启');
						} else {
							Message.show('120级开启祭典');
						}
					}
				}
			);
			this.FestivalModel.Bind(
				FestivalModelEvent.CLOSE_FESTIVAL_VIEW,
				(viewName?) => {
					let view = this._viewDic[viewName];
					if (view && view != true && view.HasOpen()) {
						view.Close();
						this._viewDic[viewName] = null;
					}
				}
			);

			GlobalEventSystem.Bind(EventName.GAME_START, async () => {
				await this.FestivalModel.InitConfig();
				this.SendFmtToGame(EnumFestivalProtocol.eProtocol19401);
			});
			RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, () => {
				this.SendFmtToGame(EnumFestivalProtocol.eProtocol19401);
			});
		};

		this.InitInfo = () => {

			let On19400 = () => {
				let scmd = UMSG.GetSCMD(EnumFestivalProtocol.eProtocol19400)
				if (scmd.code == 1) {
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			// 祭典界面信息协议回调
			let On19401 = () => {
				if (PlatformManager.GetInstance().is_alpha) {
					return
				}
				let scmd: IS2CFestivalBasicInfo = UMSG.GetSCMD(
					EnumFestivalProtocol.eProtocol19401
				);
				this.FestivalModel.SetFestivalBasicInfo(scmd);
				// 获取icon配置
				let icon_info = ActivityIconManager.GetInstance().getIconInfo(
					FestivalModel.ICON_TYPE
				);
				if (this.FestivalModel.GetEntranceOpenState()) {
					ActivityIconManager.GetInstance().addIcon(
						FestivalModel.ICON_TYPE,
						0,
						icon_info
					);
					this.SendFmtToGame(EnumFestivalProtocol.eProtocol19403, 'c', 0);
				} else {
					ActivityIconManager.GetInstance().deleteIcon(FestivalModel.ICON_TYPE);
				}
			};

			// 领取祭典奖励协议回调
			let On19402 = () => {
				let scmd = UMSG.GetSCMD(
					EnumFestivalProtocol.eProtocol19402
				);
				let reward_list = scmd.reward_list
				let rewards = []
				for (let key in reward_list) {
					if (reward_list[key]) {
						let info = reward_list[key]
						table.insert(rewards, { "0": info.style, "1": info.typeId, "2": info.count })
					}
				}
				let view: FestivalGetRewardView = new FestivalGetRewardView();

				if (this.FestivalModel.GetFestivalIsBuy()) {
					view.Open({ type: EnumFestivalGetRewardType.eBought, rewars1: rewards });
				} else {
					view.Open({ type: EnumFestivalGetRewardType.eNotBuy, rewars1: rewards, rewars2: this.FestivalModel.GetFestivalOrderRewards(EnumFestivalTypeName.eLuxury) });
				}


			};

			// 祭典任务信息协议回调
			let On19403 = () => {
				let scmd: IS2CFestivalTasks = UMSG.GetSCMD(
					EnumFestivalProtocol.eProtocol19403
				);
				this.FestivalModel.SetTaskAll(scmd);
			};

			// 领取任务奖励协议回调
			let On19404 = () => {
				let scmd = UMSG.GetSCMD(
					EnumFestivalProtocol.eProtocol19404
				);
				if (scmd?.exp) {
					Message.show(`获得${scmd.exp}祭典经验`);
				}
			};

			// 购买高级祭典(钻石购买)
			let On19405 = () => {
				let scmd: IS2CFestivalTasks = UMSG.GetSCMD(
					EnumFestivalProtocol.eProtocol19405
				);
			}

			this.RegisterProtocal(EnumFestivalProtocol.eProtocol19400, On19400);
			this.RegisterProtocal(EnumFestivalProtocol.eProtocol19401, On19401);
			this.RegisterProtocal(EnumFestivalProtocol.eProtocol19402, On19402);
			this.RegisterProtocal(EnumFestivalProtocol.eProtocol19403, On19403);
			this.RegisterProtocal(EnumFestivalProtocol.eProtocol19404, On19404);
			this.RegisterProtocal(EnumFestivalProtocol.eProtocol19405, On19405);
		};

		this.InitInfo();
		this.InitEvents();
	}
}
window['FestivalController'] = FestivalController;
