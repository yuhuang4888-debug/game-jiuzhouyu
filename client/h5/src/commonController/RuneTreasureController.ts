import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureModel, RuneTreasureEvent } from "../commonModel/RuneTreasureModel"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskModel } from "../commonModel/TaskModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import { RoleManager } from "../commonModel/RoleManager"
import "../runeTreasure/EquipTreaseRewardView"
import "../runeTreasure/EquipTreasureBagView"
import "../runeTreasure/EquipTreasureShopView"
import "../runeTreasure/RuneTreasureBaseView"
import "../runeTreasure/RuneTreasureGetRewardView"
import "../runeTreasure/RuneTreasureResultView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

// 符文夺宝
export class RuneTreasureController extends BaseController {
	// private model = RuneTreasureModel.GetInstance()
	private reward_cfg

	InitInfo
	public constructor() {
		super()
		this.InitInfo = () => {
			let treasureModel = RuneTreasureModel.GetInstance(),
				goodsmodel = GoodsModel.GetInstance(),
				user_msg_adapter = UserMsgAdapter.GetInstance(),
				local_Util = Util,
				local_RuneTreasureModel = RuneTreasureModel,
				local_Message = Message,
				res_mgr = ResManager.GetInstance(),
				request_proto_event = RuneTreasureEvent.RUNE_TREASURE_REQUEST_PROTO,
				local_RuneTreasureEvent = RuneTreasureEvent,
				local_GlobalEventSystem = GlobalEventSystem,
				local_EventName = EventName,
				role_mgr = RoleManager.GetInstance(),
				local_GoodsModel = GoodsModel,
				view_dic_ = {},
				getward_view_,
				rune_result_view
			treasureModel.InitConfig()
			//错误码展示
			let Handler41600 = () => {
				let scmd = user_msg_adapter.GetSCMD(41600)
				local_Util.ErrorCodeShow(scmd.errcode)
			}

			//寻宝界面
			let Handler41601 = () => {
				let scmd = user_msg_adapter.GetSCMD(41601)
				treasureModel.SetRuneTreasureData(scmd)
			}

			//寻宝
			let Handler41604 = async () => {
				let scmd = user_msg_adapter.GetSCMD(41604)
				if (scmd.res == 1) {
					// local_Message.show("夺宝成功")
					if (getward_view_) {
						if (getward_view_.HasOpen()) {
							getward_view_.Close()
						}
						getward_view_ = null
					}
					if (rune_result_view) {
						if (rune_result_view.HasOpen()) {
							rune_result_view.Close()
						}
						rune_result_view = null
					}
					let show_reward_list = []
					for (let vo of scmd.reward_list) {
						show_reward_list.push([0, vo.gtyp_id, vo.goods_num, vo.is_rare, 0, 0, 0, vo.is_tv])
					}
					let sort_fun = (a, b) => {
						let basic = goodsmodel.GetGoodsBasicByTypeId(a.gtyp_id)
						let basic2 = goodsmodel.GetGoodsBasicByTypeId(b.gtyp_id)
						if (basic && basic2) {
							return basic2.color - basic.color
						}
					}
					show_reward_list.sort(sort_fun)
					scmd.reward_list = show_reward_list

					if (scmd.type == local_RuneTreasureModel.RUNE_TREASURE_TYPE) {
						if (!rune_result_view) {
							let view = window["RuneTreasureResultView"]
							if (!view) {
								if (!res_mgr.IsJsLoad("runeTreasure")) {
									await res_mgr.LoadJs("runeTreasure")
								}
								view = window["RuneTreasureResultView"]
							}
							if (view) {
								rune_result_view = new view(scmd)
							}
						}
						if (rune_result_view) {
							rune_result_view.Open()
						}
					} else {
						if (!getward_view_) {
							let view = window["RuneTreasureGetRewardView"]
							if (!view) {
								if (!res_mgr.IsJsLoad("runeTreasure")) {
									await res_mgr.LoadJs("runeTreasure")
								}
								view = window["RuneTreasureGetRewardView"]
							}
							if (view) {
								getward_view_ = new view(scmd)
							}
						}
						if (getward_view_)
							getward_view_.Open()
					}

				} else {
					local_Util.ErrorCodeShow(scmd.res)
				}
				if (scmd.type == local_RuneTreasureModel.RUNE_TREASURE_TYPE) {
					treasureModel.Fire(request_proto_event, 41601, "c", local_RuneTreasureModel.RUNE_TREASURE_TYPE)
				} else {
					treasureModel.Fire(request_proto_event, 41608, "cc", scmd.type, 2)
				}
			}

			//符文寻宝阶段奖励
			let Handler41607 = () => {
				let scmd = user_msg_adapter.GetSCMD(41607)
				treasureModel.Fire(request_proto_event, 41601, "c", local_RuneTreasureModel.RUNE_TREASURE_TYPE)
			}

			// let Handler41603 = () => {
			//     let scmd = UserMsgAdapter.GetInstance().GetSCMD(41603)
			//     treasureModel.AddRecordData(scmd)
			// }

			let Handler41605 = () => {
				let scmd = user_msg_adapter.GetSCMD(41605)
				if (scmd.errcode == 1) {
					treasureModel.Fire(local_RuneTreasureEvent.GET_ONE_REWARD, scmd)
					treasureModel.ShowEquipRed()
				} else {
					local_Util.ErrorCodeShow(scmd.errcode)
				}
			}

			let Handler41606 = () => {
				let errcode = this.ReadFmt("i");
				if (errcode != 1) {
					local_Util.ErrorCodeShow(errcode)
				}
				let len4 = this.ReadFmt("h");
				let good_ids = [];
				let vo4;
				let hase_gold
				for (let i: number = 1; i <= len4; i++) {
					let goods_num = this.ReadFmt("i");
					let gtyp_id = this.ReadFmt("i");
					vo4 = []
					if (gtyp_id == 32010095) {
						if (!hase_gold) {
							good_ids.push([3, 0, 200])
							hase_gold = true
						}
					} else {
						good_ids.push([0, gtyp_id, 1]);
					}
				}
				treasureModel.ShowEquipRed()
				treasureModel.Fire(local_RuneTreasureEvent.GET_REWARD_TO_BAG, good_ids)
			}

			let Handler41608 = () => {
				let scmd = user_msg_adapter.GetSCMD(41608)
				if (treasureModel.drawWeaponlist[scmd.htype] == undefined || treasureModel.drawWeaponlist[scmd.htype] != scmd.draw_weapon) {
					this.SendFmtToGame(41613, "c", scmd.htype)
				}
				treasureModel.SetRecordData(scmd)
			}

			let Handler41609 = () => {
				let scmd = user_msg_adapter.GetSCMD(41609)
				if (scmd.code == 1) {
					local_Message.show("兑换成功")
					treasureModel.equip_treasure_socre = scmd.score
					treasureModel.Fire(local_RuneTreasureEvent.UPDATE_EQUIP_SCORE, scmd.score)
				} else {
					local_Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler41610 = () => {
				let scmd = user_msg_adapter.GetSCMD(41610)
				treasureModel.luckey[`${scmd.htype}`] = scmd
				treasureModel.Fire(local_RuneTreasureEvent.UPDATE_LUCKEY, scmd)
				let max = 0
				for (let key in treasureModel.luckey) {
					if (treasureModel.luckey[key].luckey_value > max) {
						max = treasureModel.luckey[key].luckey_value
					}
				}
				if (max < 500 && max >= 400) {
					ActivityIconManager.GetInstance().addIcon(416, undefined, undefined, undefined, `416_1`)
					// local_GlobalEventSystem.Fire(local_EventName.SET_TREASURE_ICON_EFFECT, 416, "ui_probability", true, { x: 43, y: 40 }, 0.82, true);
				} else if (max >= 500) {
					ActivityIconManager.GetInstance().addIcon(416, undefined, undefined, undefined, `416_2`)
					// local_GlobalEventSystem.Fire(local_EventName.SET_TREASURE_ICON_EFFECT, 416, "ui_probability_max", true, { x: 43, y: 40 }, 0.82, true);
				} else {
					ActivityIconManager.GetInstance().addIcon(416, undefined, undefined, undefined, null)
					// local_GlobalEventSystem.Fire(local_EventName.SET_TREASURE_ICON_EFFECT, 416, undefined, false);
				}
				let [status, index, resName] = treasureModel.GetImageStatus(scmd.htype)
				local_GlobalEventSystem.Fire(local_EventName.UPDATE_BASE_WINFOWS_COMPONENT_IMAGE_STATE, "RuneTreasureBaseView", index, status, resName)
			}

			let Handler41611 = () => {
				let scmd = user_msg_adapter.GetSCMD(41611)
				if (scmd.code) {
					// treasureModel.first = true
					// treasureModel.Fire(local_RuneTreasureEvent.FIRST, true)
					// this.Fire(local_RuneTreasureEvent.UPDATE_EQUIP_RECORD_DATA)
				}
			}

			let Handler41612 = () => {
				let scmd = user_msg_adapter.GetSCMD(41612)
				if (treasureModel.record_data_list[`${scmd.htype}@1`]) {
					treasureModel.record_data_list[`${scmd.htype}@1`].list = scmd.list
				}
				treasureModel.Fire(local_RuneTreasureEvent.UPDATE_EQUIP_RECORD_DATA)
			}

			let Handler41613 = () => {
				let scmd = user_msg_adapter.GetSCMD(41613)
				if (treasureModel.drawRedList[scmd.htype] == undefined || treasureModel.drawRedList[scmd.htype] != !scmd.open) {
					treasureModel.drawRedList[scmd.htype] = !scmd.open
					treasureModel.Fire(local_RuneTreasureEvent.UPDATE_REWARD_TYPE, scmd)
					treasureModel.ShowEquipRed()
				} else {
					treasureModel.drawRedList[scmd.htype] = !scmd.open
				}
			}

			let Handler41615 = () => {
				let scmd = user_msg_adapter.GetSCMD(41615)
				treasureModel.drawWeaponlist[scmd.htype] = true
				this.SendFmtToGame(41613, "c", scmd.htype)
			}

			let Handler41620 = () => {
				let scmd = user_msg_adapter.GetSCMD(41620)
				treasureModel.taskList[scmd.htype] = scmd.task_list
				treasureModel.Fire(local_RuneTreasureEvent.TASK_UPDATE, scmd)
				checkTaskRed()
			}

			let Handler41621 = () => {
				let scmd = user_msg_adapter.GetSCMD(41621)
				let list = treasureModel.taskList[scmd.htype]
				if (list) {
					for (let taskVo of list) {
						for (let changeVo of scmd.task_list) {
							if (taskVo.task_id == changeVo.task_id) {
								taskVo.num = changeVo.num
								taskVo.state = changeVo.state
							}
						}
					}
				}
				treasureModel.Fire(local_RuneTreasureEvent.TASK_UPDATE, scmd)
				checkTaskRed()
			}
			let Handler41622 = () => {
				let scmd = user_msg_adapter.GetSCMD(41622)
				if (scmd.code == 1) {
					this.SendFmtToGame(41620, "c", scmd.htype)
				} else {
					local_Util.ErrorCodeShow(scmd.code)
				}
			}

			let Handler41603 = () => {
				let scmd = user_msg_adapter.GetSCMD(41603)
				if (scmd.rtype == 1 && scmd.list.length > 0) {
					this.SendFmtToGame(41608, "cc", scmd.list[0].type, scmd.rtype)
				}
			}


			this.RegisterProtocal(41600, Handler41600)         //错误码展示
			this.RegisterProtocal(41601, Handler41601)         //寻宝界面
			this.RegisterProtocal(41604, Handler41604)         //寻宝
			this.RegisterProtocal(41607, Handler41607)         //符文寻宝阶段奖励

			this.RegisterProtocal(41603, Handler41603)         //新增寻宝记录
			this.RegisterProtocal(41605, Handler41605)         //取出装备寻宝道具
			this.RegisterProtocal(41606, Handler41606)         //一键取出寻宝道具背包
			this.RegisterProtocal(41608, Handler41608)         //寻宝界面
			this.RegisterProtocal(41609, Handler41609)
			this.RegisterProtocal(41610, Handler41610)
			this.RegisterProtocal(41611, Handler41611)
			this.RegisterProtocal(41612, Handler41612)
			this.RegisterProtocal(41613, Handler41613)
			this.RegisterProtocal(41615, Handler41615)
			this.RegisterProtocal(41620, Handler41620)
			this.RegisterProtocal(41621, Handler41621)
			this.RegisterProtocal(41622, Handler41622)

			treasureModel.Bind(request_proto_event, (id: number, fmt?: string, ...parms) => {
				this.SendFmtToGame(id, fmt, ...parms)
			})

			let OpenFunc = async (view_name: string, ...parms) => {
				let view = view_dic_[view_name]
				if (view_name == "RuneTreasureBaseView") {
					if (view && view != true) {
						view.Close()
						view = null
						delete view_dic_[view_name]
						local_GlobalEventSystem.Fire(local_EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.RuneTreasureBtn, false)
					}
				}
				if (!view) {
					view_dic_[view_name] = true
					if (!window[view_name]) {
						if (!res_mgr.IsJsLoad("runeTreasure")) {
							await res_mgr.LoadJs("runeTreasure")
						}
					}
					if (window[view_name] && view_dic_[view_name] == true) {
						// egret.log(`winType--------------${window[view_name]}-----------${view_name}`)
						let view_class = window[view_name]
						view = new view_class()
						view_dic_[view_name] = view
					}
				}
				if (view && view != true) {
					let res = view.HasOpen() ? view.Close() : view.Open(...parms)
				}
			}

			treasureModel.Bind(local_RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, OpenFunc)

			local_GlobalEventSystem.Bind(local_EventName.INIT_CONFIG, () => {
				treasureModel.InitConfig()
			})

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				treasureModel.Fire(request_proto_event, 41601, "c", local_RuneTreasureModel.RUNE_TREASURE_TYPE)
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EQUIP_TREASURE_TYPE, 1)
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.PEAK_TREASURE_TYPE, 1)
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EXTREME_TREASURE_TYPE, 1)
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EQUIP_TREASURE_TYPE, 2)
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.PEAK_TREASURE_TYPE, 2)
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EXTREME_TREASURE_TYPE, 2)
				// treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EXTREME_TREASURE_TYPE, 1)
				treasureModel.Fire(request_proto_event, 41610, "c", local_RuneTreasureModel.EQUIP_TREASURE_TYPE)
				treasureModel.Fire(request_proto_event, 41610, "c", local_RuneTreasureModel.PEAK_TREASURE_TYPE)
				treasureModel.Fire(request_proto_event, 41610, "c", local_RuneTreasureModel.EXTREME_TREASURE_TYPE)
				if (ServerTimeModel.GetInstance().GetOpenServerDay() >= 8) {
					treasureModel.Fire(request_proto_event, 41612, "c", local_RuneTreasureModel.EQUIP_TREASURE_TYPE)
					treasureModel.Fire(request_proto_event, 41612, "c", local_RuneTreasureModel.PEAK_TREASURE_TYPE)
					treasureModel.Fire(request_proto_event, 41612, "c", local_RuneTreasureModel.EXTREME_TREASURE_TYPE)
				}
				treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.BABY_TREASURE_TYPE, 1)
				treasureModel.Fire(request_proto_event, 41613, "c", local_RuneTreasureModel.EQUIP_TREASURE_TYPE)
				treasureModel.Fire(request_proto_event, 41613, "c", local_RuneTreasureModel.PEAK_TREASURE_TYPE)
				treasureModel.Fire(request_proto_event, 41613, "c", local_RuneTreasureModel.EXTREME_TREASURE_TYPE)
				treasureModel.Fire(request_proto_event, 41620, "c", local_RuneTreasureModel.BABY_TREASURE_TYPE)

			})

			let update_dot = () => {
				if (role_mgr.mainRoleInfo.level >= local_RuneTreasureModel.RUNE_TREASURE_OPEN_LV) {
					treasureModel.ShowRedDot()
				}
				if (role_mgr.mainRoleInfo.level >= local_RuneTreasureModel.EQUIP_TREASURE_OPEN_LV) {
					treasureModel.ShowEquipRed()
				}
			}
			goodsmodel.Bind(local_GoodsModel.CHANGE_BAG_LIST, update_dot)
			goodsmodel.Bind(local_GoodsModel.CHANGE_TREASURE_BAG_LIST, update_dot)


			let lvChange = () => {
				if (role_mgr.GetMainRoleVo().level == local_RuneTreasureModel.EQUIP_TREASURE_OPEN_LV) {
					treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EQUIP_TREASURE_TYPE, 1)
				} else if (role_mgr.GetMainRoleVo().level == local_RuneTreasureModel.PEAK_TREASURE_OPEN_LV) {
					treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.PEAK_TREASURE_TYPE, 1)
				} else if (role_mgr.GetMainRoleVo().level == local_RuneTreasureModel.EXTREME_TREASURE_OPEN_LV) {
					treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EXTREME_TREASURE_TYPE, 1)
				}
			}
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, lvChange)

			TaskModel.GetInstance().Bind(TaskModel.FINISH_TASK, (taskId) => {
				if (taskId == 100400) {
					treasureModel.Fire(request_proto_event, 41608, "cc", local_RuneTreasureModel.EQUIP_TREASURE_TYPE, 1)
				} else if (taskId == 100980) {
					treasureModel.Fire(request_proto_event, 41601, "c", local_RuneTreasureModel.RUNE_TREASURE_TYPE)
				}
			})

			let checkTaskRed = () => {
				let red = false
				if (!CommonManager.GetInstance().CheckFuncOpenState("BabyTreasureView", true) || !treasureModel.taskList[local_RuneTreasureModel.BABY_TREASURE_TYPE]) {
					return false
				}
				for (let vo of treasureModel.taskList[local_RuneTreasureModel.BABY_TREASURE_TYPE]) {
					if (vo.state == 1) {
						red = true
						break
					}
				}
				treasureModel.ChangeVar("babyTreasureRed", red)
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 182)
			}
		}
		this.InitInfo()
	}



}
window["RuneTreasureController"] = RuneTreasureController