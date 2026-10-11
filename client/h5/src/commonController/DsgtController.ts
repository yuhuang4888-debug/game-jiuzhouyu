
//require("game.dsgt.DsgtDetailsItem")
//require("game.dsgt.DsgtItemRenderer")
//require("game.common.DsgtModel")
//require("game.dsgt.DsgtView")
//require("game.dsgt.DsgtWindowView")
//require("game.dsgt.GetDsgtView")

import { BaseController } from "../common/BaseController";
import { BaseViewInterface } from "../common/BaseView1";
import { UserMsgAdapter } from "../common/UserMsgAdapter";
import { DsgtModel } from "../commonModel/DsgtModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { SceneManager } from "../scene/SceneManager";
import { LoadLuaClassAB, Util } from "../util/Util";

//require("game.preload_proto.Require411")
import "../dsgt/GetDsgtView";
import "../dsgt/DsgtWindowView";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName } from "../common/EventName";
import { RoleManager } from "../commonModel/RoleManager";
import { Alert, Alert_Type } from "../alert/Alert";
import { Config } from "../common/Config";
import { MainFunc } from "../commonModel/MainUIModel";
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";

export class DsgtController extends BaseController {
	InitEvent
	InitInfo
	dsgt_view

	public constructor() {
		super()


		this.dsgt_view = []
		let dsgt_model = DsgtModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let local_DsgtModel = DsgtModel
		let local_GoodsModel = GoodsModel

		let user_msg_adapter = UserMsgAdapter.GetInstance()

		dsgt_model.LoadConfig()
		this.InitEvent = () => {

			let GetGoodsNumForBag = () => {
				dsgt_model.Fire(local_DsgtModel.DSGT_INSTANCE_LIST)
			}

			goods_model.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, GetGoodsNumForBag)
			let JudgeGoodType = (goods_list?) => {
				dsgt_model.RefreshGoodsNum(goods_list)
			}

			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, JudgeGoodType)
			dsgt_model.Bind(local_DsgtModel.SCMD_REQUEST, (cmd, ...new_args) => {
				let args = new_args
				if (41101 == cmd) {
					this.SendFmtToGame(41101)
				} else if (41102 == cmd) {
					this.SendFmtToGame(cmd, "i", args)
				} else if (41103 == cmd) {
					this.SendFmtToGame(cmd, "i", args)
				} else if (41106 == cmd) {
					this.SendFmtToGame(cmd, "i", args)
				} else if (41107 == cmd) {
					this.SendFmtToGame(cmd, "i", args)
				} else if (41109 == cmd) {
					this.SendFmtToGame(cmd, "i", args)
				}
			}
			)
			let InstanceDsgtList = () => {
				dsgt_model.Fire(local_DsgtModel.SCMD_REQUEST, 41101)
			}

			dsgt_model.Bind(local_DsgtModel.DSGT_INSTANCE_LIST, InstanceDsgtList)
			let open_callback = (view_class: string, ...new_args) => {
				let parms_ = new_args
				let view_name = view_class
				let view = this.dsgt_view[view_name]
				let viewClass = window[view_name]
				if (!view) {
					view = new viewClass()
					this.dsgt_view[view_name] = view
				}
				view.Open(...new_args)
			}
			dsgt_model.Bind(local_DsgtModel.DSGT_OPEN_VIEW, open_callback)

			// let open_callback = (view_name, ...new_args) => {
			// 	let parms_ = new_args
			// 	var callback =()=> {
			// 		let view = this.dsgt_view[view_name]
			// 		if (! view ) {
			// 			let view_class = window[view_name]
			// 			view =  new view_class()
			// 			this.dsgt_view[view_name] = view
			// 		}
			// 		view.Open(...parms_)
			// 	}
			// 	LoadLuaClassAB(view_name,callback)
			// }

			// dsgt_model.Bind(local_DsgtModel.DSGT_OPEN_VIEW, open_callback)

			GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (task_id) => {
				let cond_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition["DsgtWindowView"]
				if (cond_cfg && cond_cfg.open_task == task_id) {
					GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
					dsgt_model.Fire(local_DsgtModel.DSGT_RED)
				}
			}
			)
		}

		this.InitInfo = () => {
			let On41101 = () => {
				let scmd = user_msg_adapter.GetSCMD(41101)
				dsgt_model.SetDsgtInfo(scmd)
				dsgt_model.GetGoodInfo()
			}

			let On41102 = () => {
				let scmd = user_msg_adapter.GetSCMD(41102)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				dsgt_model.SetAdronDsgtID(scmd.id)
				dsgt_model.Fire(local_DsgtModel.DSGT_ADORN_BUT)
			}

			let On41103 = () => {
				let scmd = user_msg_adapter.GetSCMD(41103)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				dsgt_model.SetAdronDsgtID(0)
				dsgt_model.Fire(local_DsgtModel.DSGT_ADORN_BUT)
			}

			let On41104 = () => {
				let scmd = user_msg_adapter.GetSCMD(41104)
				if (scmd.code != 1) {
					Util.ErrorCodeShow(scmd.code)
					return
				}
				let list: any[] = dsgt_model.GetDsgtList();
				let isFirst: boolean = !(list?.filter((data) => {
					return data.status == 2; // 已激活
				})?.length);

				let data = {
					_type: 411,
					id: scmd.id,
					isFirst: isFirst,
					cb: () => {
						if (!isFirst) {
							dsgt_model.Fire(local_DsgtModel.SCMD_REQUEST, 41102, scmd.id)
						}
					}
				}

				if (isFirst) {
					dsgt_model.Fire(local_DsgtModel.SCMD_REQUEST, 41102, scmd.id)
				}

				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
				dsgt_model.GetActivateUpdate(scmd.id, 2, 1, scmd.end_time, true)
				MarriageModel.GetInstance().Fire(MarriageEvent.UPDATE_DSGT)

				// var callback = () => {
				// 	// let _getDsgtView = new window["GetDsgtView"]()
				// 	// _getDsgtView.Open(scmd.id)
				// 	// dsgt_model.GetActivateUpdate(scmd.id, 2, 1, scmd.end_time, true)
				// 	// MarriageModel.GetInstance().Fire(MarriageEvent.UPDATE_DSGT)
				// }
				// LoadLuaClassAB("GetDsgtView", callback)
			}

			let On41105 = () => {
				let scmd = user_msg_adapter.GetSCMD(41105)
				let role_vo = SceneManager.GetInstance().GetRoleVo(scmd.player_id)
				if (role_vo) {
					role_vo.ChangeVar("dsgt_id", scmd.id)
				}
			}

			let On41106 = () => {
				let scmd = user_msg_adapter.GetSCMD(41106)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				dsgt_model.GetActivateUpdate(scmd.dsgtid, 2, scmd.order, null, false)
				dsgt_model.Fire(local_DsgtModel.DSGT_ORDER, scmd.order)
				dsgt_model.SetAdronDsgtID(scmd.currentused)
				dsgt_model.Fire(local_DsgtModel.DSGT_ADORN_BUT)
			}

			let On41107 = () => {
				let scmd = user_msg_adapter.GetSCMD(41107)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}
				dsgt_model.Fire(local_DsgtModel.DSGT_UPDATE_POWER, scmd.power)
			}

			let On41108 = () => {
				let scmd = user_msg_adapter.GetSCMD(41108)
				dsgt_model.GetActivateUpdate(scmd.dsgtid, 0, 0, null, false)
			}

			let On41109 = () => {
				let scmd = user_msg_adapter.GetSCMD(41109)
				if (scmd.errcode != 1) {
					Util.ErrorCodeShow(scmd.errcode)
					return
				}

				dsgt_model.GetActivateUpdate(scmd.dsgtid, 2, 1, null, true)
				// dsgt_model.Fire(local_DsgtModel.DSGT_ORDER, 1)

				// dsgt_model.SetAdronDsgtID(scmd.currentused)
				// dsgt_model.Fire(local_DsgtModel.DSGT_ADORN_BUT)
			}



			this.RegisterProtocal(41101, On41101)
			this.RegisterProtocal(41102, On41102)
			this.RegisterProtocal(41103, On41103)
			this.RegisterProtocal(41104, On41104)
			this.RegisterProtocal(41105, On41105)
			this.RegisterProtocal(41106, On41106)
			this.RegisterProtocal(41107, On41107)
			this.RegisterProtocal(41108, On41108)
			this.RegisterProtocal(41109, On41109)
		}

		this.InitInfo()
		this.InitEvent()
	}

}
window["DsgtController"] = DsgtController