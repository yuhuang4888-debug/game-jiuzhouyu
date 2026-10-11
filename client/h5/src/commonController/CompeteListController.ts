import { BaseController } from "../common/BaseController"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { CompeteListEvent, CompeteListModel } from "../commonModel/CompeteListModel"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompetelistEnterView } from "../competelist/CompetelistEnterView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../competelist/CompetelistRewardView"
import { CommonManager } from "../common/CommonManager"
import { RoleManager } from './../commonModel/RoleManager';
import { Message } from "../sysInfo/SysInfoController"

export class CompeteListController extends BaseController {
	InitInfo
	enterviewDic
	view_dic

	public constructor() {
		super()


		this.view_dic = {}
		this.enterviewDic = {}

		this.InitInfo = () => {
			let model = CompeteListModel.GetInstance()
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let local_CompeteListEvent = CompeteListEvent
			let goods_model = GoodsModel.GetInstance()
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName

			let On33800 = () => {
				let scmd = user_msg_adapter.GetSCMD(33800);
				model.SetActList(scmd.act_list);
				model.SetOpenActive(scmd.act_list);
			}

			let On33801 = () => {
				let scmd = user_msg_adapter.GetSCMD(33801);
				model.CompeteViewData[scmd.type + "@" + scmd.subtype] = scmd;
				CustomActivityModel.GetInstance().RefreshIconRed(scmd.type, scmd.subtype, 338);
				if (model.confRaceActInfo) {
					let cfg = model.confRaceActInfo[scmd.type + "@" + scmd.subtype]
					model.RefreshIconRedDot(scmd.type, scmd.subtype, cfg.show_id);
					model.Fire(local_CompeteListEvent.UPDATE_VIEW_DATA, scmd);
					model.Fire(local_CompeteListEvent.UPDATE_ENTER_VIEW_RED, scmd.type, scmd.subtype)
				}
			}

			let On33802 = () => {
				let scmd = user_msg_adapter.GetSCMD(33802);
				model.CompeteRankData[scmd.type + "@" + scmd.subtype] = scmd;
				model.Fire(local_CompeteListEvent.UPDATE_RANK_DATA, scmd);
			}

			let On33803 = () => {
				let scmd = user_msg_adapter.GetSCMD(33803);
				if (scmd.error_code == 1) {
					this.SendFmtToGame(33801, "hh", scmd.type, scmd.subtype);
					this.SendFmtToGame(33802, "hh", scmd.type, scmd.subtype);
					let goods_list = [];
					for (let _tmpi in scmd.reward_list) {
						var vo = scmd.reward_list[_tmpi];
						if (vo.reward && vo.reward.length > 0) {
							for (let _tmpi in vo.reward) {
								var goodsVo = vo.reward[_tmpi];
								let info = [];
								info[0] = goodsVo["style"];
								info[1] = goodsVo["typeId"];
								info[2] = goodsVo["count"];
								table.insert(goods_list, info);
							}
						}
					}

					let sort_fun = (a?, b?) => {
						let basic = goods_model.GetGoodsBasicByTypeId(a.typeId);
						let basic2 = goods_model.GetGoodsBasicByTypeId(b.typeId);
						if (basic && basic2) {
							return basic2.color < basic.color;
						}
					}
					table.sort(goods_list, sort_fun);

					let view = new CongratulationObtainView(goods_list, 10);
					view.Open();
					model.Fire(local_CompeteListEvent.UPDATE_LOTTERY_DATA, scmd);
				} else {
					Util.ErrorCodeShow(scmd.error_code);
				}
			}

			let On33804 = () => {
				let scmd = user_msg_adapter.GetSCMD(33804);
				if (scmd.error_code == 1) {
					model.getStageReward(scmd);
				} else {
					Util.ErrorCodeShow(scmd.error_code);
				}
			}

			let On33807 = () => {
				let scmd = user_msg_adapter.GetSCMD(33807);
				model.Fire(local_CompeteListEvent.UPDATE_KEY_DATA, scmd);
			}

			this.RegisterProtocal(33800, On33800)	//请求正在开启的活动信息
			this.RegisterProtocal(33801, On33801)	//请求界面信息
			this.RegisterProtocal(33802, On33802)	//请求榜单信息
			this.RegisterProtocal(33803, On33803)	//抽奖
			this.RegisterProtocal(33804, On33804)	//领取阶段奖励
			this.RegisterProtocal(33807, On33807)	//神秘钥匙数量



			goods_model.Bind(GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
				let actList = model.actList;
				if (!actList) {
					return false;
				}

				for (const iterator of actList) {
					let viewData = model.CompeteViewData[iterator.type + "@" + iterator.subtype];
					if (viewData) {
						let cost = viewData.cost[0];
						let ten_cost = viewData.ten_cost[0];
						let type_id = cost.typeId
						for (let _tmpi in goods_list) {
							let goods = goods_list[_tmpi]
							if (goods.type_id == type_id) {
								let num = goods_model.GetTypeGoodsNum(type_id)
								if (num >= cost.count) {
									let cfg = model.confRaceActInfo[iterator.type + "@" + iterator.subtype];
									model.RefreshIconRedDot(iterator.type, iterator.subtype, cfg.show_id);

								}
							}
						}

					}
				}
			});

			model.Bind(local_CompeteListEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args);
			});

			model.Bind(local_CompeteListEvent.OPEN_VIEW, (view_name, ...new_args) => {
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
			}
			)

			let open_compete_enter_view = (type_id?, sub_type?) => {
				let iconType: string = `338@${type_id}@${sub_type}`;
				let conf = CommonManager.GetInstance().GetFunctionIconCfg(iconType);
				let roleLv: number = RoleManager.GetInstance().GetMainRoleVo().level;
				if (conf?.open_lv && roleLv >= conf.open_lv) {
					let enterview = this.enterviewDic[type_id + "@" + sub_type]
					if (!enterview) {
						enterview = new CompetelistEnterView();
						this.enterviewDic[type_id + "@" + sub_type] = enterview;
					}
					let key = type_id + "@" + sub_type;
					let config = model.confRaceActInfo[key];
					enterview.setData([{ label: config.name }], [key]);
					enterview.Open(0, { base_type: type_id, sub_type: sub_type, show_id: config.show_id });
				} else {
					if (conf?.open_lv) {
						return Message.show(`${conf.open_lv}级开启`);
					} else {
						return Message.show(`活动未开启`);
					}
				}

			}

			local_GlobalEventSystem.Bind(local_EventName.OPEN_COMPETELIST_ENTER_VIEW, open_compete_enter_view)

			let game_star = async () => {
				model.actList = [];
				model.CompeteOpenActive = {}
				model.CompeteViewData = {}	//活动界面信息
				model.CompeteRankData = {}	//排行数据
				model.CompeteKeyData = {}	//键值
				await model.InitConfig();
				this.SendFmtToGame(33800);
			}
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, game_star);
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, game_star);
			local_GlobalEventSystem.Bind(local_EventName.CHANGE_LEVEL, game_star);

			let change_fun = () => {
				game_star();
			}
			local_GlobalEventSystem.Bind(local_EventName.ALPHA_STATE_CHANGE, change_fun);
		}

		this.InitInfo();
	}
}
