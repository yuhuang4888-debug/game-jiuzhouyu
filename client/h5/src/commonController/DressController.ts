
//require("game.common.DressModel")
//require("game.dress.DressItem")
//require("game.dress.DressProItem")
//require("game.dress.DressSkillItem")
//require("game.dress.DressSubView")
//require("game.dress.DressTab")
//require("game.dress.DressView")
//require("game.preload_proto.Require112")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { DressModel, DressEvent, DressType } from "../commonModel/DressModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Scene } from "../scene/Scene"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoadLuaClassAB, Util } from "../util/Util"
import "../dress/DressSubView"
import { RoleManager } from "../commonModel/RoleManager"
import { MainFunc } from "../commonModel/MainUIModel"
import { Config } from "../common/Config"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"

export class DressController extends BaseController {
	InitEvent
	InitInfo
	model: DressModel;
	view_dic

	public constructor() {
		super()


		this.model = DressModel.GetInstance();
		this.view_dic = [];
		let request_proto = DressEvent.DRESS_REQUEST_PROTO
		let local_DressEvent = DressEvent

		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		let local_Message = Message
		let head_pop_data;
		this.InitEvent = () => {
			this.model.Bind(request_proto, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			this.model.Bind(local_DressEvent.DRESS_OPEN_VIEW, (view_name: string, ...new_args) => {
				let parms_ = new_args
				var callback = () => {
					let view = this.view_dic[view_name]
					if (!view) {
						let view_class = window[view_name]
						view = new view_class()
						this.view_dic[view_name] = view
					}
					if (view.HasOpen()) {
						view.Close()
					} else {
						view.Open(parms_)
					}
				}
				LoadLuaClassAB(view_name, callback)
			}
			)

			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.model.InitConfig()
				this.model.InitUnActDressMap()
				this.model.Fire(request_proto, 11200, "c", DressType.Bubble)
				this.model.Fire(request_proto, 11200, "c", DressType.Photo)
				this.model.Fire(request_proto, 11200, "c", DressType.Foot)
				this.model.Fire(request_proto, 11200, "c", DressType.Head)
			}
			)
			let OnChangeBagList = () => {
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
				this.model.Fire(local_DressEvent.DRESS_UPDATE_RED_DOT)
			}
			GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, OnChangeBagList)

			RoleManager.GetInstance().GetMainRoleVo().Bind(
				local_EventName.CHANGE_LEVEL, (level) => {
					let cond_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition["FashionBaseView"]
					if (cond_cfg && cond_cfg.open_lv == level) {
						local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
						this.model.Fire(local_DressEvent.DRESS_UPDATE_RED_DOT)
					}
				}
			)

			let OnOPenOutwardChangedView = () => {
				if(head_pop_data){
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", head_pop_data);
					head_pop_data = null;
				}
			}
			DressModel.GetInstance().Bind(DressEvent.REINCARNATION_SUCCESS_VIEW_CLOSE, OnOPenOutwardChangedView)
		}

		this.InitInfo = () => {
			let Handler11200 = () => {
				let scmd = user_msg_adapter.GetSCMD(11200)
				this.model.SetDressData(scmd)
				this.model.Fire(local_DressEvent.DRESS_UPDATE_RED_DOT)
			}

			let Handler11201 = () => {
				let scmd = user_msg_adapter.GetSCMD(11201)
				head_pop_data = null;
				if (scmd.res == 1) {
					let is_new = false
					if (scmd.dress_lv == 1) {
						local_Message.show("激活成功")
						is_new = true
						let isFirst: boolean = !(this.model.GetDressByTypes(scmd.dress_type)?.enable_list?.length);
						let conf = this.model.GetDressCfgByTypeAndIdAndLv(scmd.dress_type, scmd.dress_id, scmd.dress_lv);
						if (conf) {
							let data = {
								_type: 112,
								id: scmd.dress_id,
								type_id: scmd.dress_type,
								isFirst: isFirst,
								cur_power: scmd.cur_power,
								next_power: scmd.next_power,
								conf: conf,
								cb: () => {
									if (!isFirst) {
										this.model.Fire(local_DressEvent.DRESS_REQUEST_PROTO, 11202, "ci", scmd.dress_type, scmd.dress_id);
									}
								}
							}

							if (isFirst) {
								this.model.Fire(local_DressEvent.DRESS_REQUEST_PROTO, 11202, "ci", scmd.dress_type, scmd.dress_id);
							}
							if(conf && conf.condition && conf.condition != "[]"){
								head_pop_data = data
							}else{
								OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
							}
							
						}
						// this.model.UpdateNowUseDress(scmd.dress_type, scmd.dress_id, true)
					} else {
						local_Message.show("升级成功")
					}
					this.model.UpdateDressData(scmd.dress_type, scmd.dress_id, scmd.dress_lv, 
						scmd.cur_power, scmd.next_power, is_new)
					this.model.Fire(local_DressEvent.DRESS_ACTIVE_SUCCESS, scmd.dress_id)
					this.model.Fire(local_DressEvent.DRESS_UPDATE_RED_DOT)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let Handler11202 = () => {
				let scmd = user_msg_adapter.GetSCMD(11202)
				if (scmd.res == 1) {
					local_Message.show("使用成功")
					this.model.UpdateNowUseDress(scmd.dress_type, scmd.dress_id, true)
					RoleManager.GetInstance().GetMainRoleVo().Fire("dress_list")
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let Handler11203 = () => {
				let scmd = user_msg_adapter.GetSCMD(11202)
				if (scmd.res == 1) {
					local_Message.show("卸下成功")
					this.model.UpdateNowUseDress(scmd.dress_type, scmd.dress_id, false)
				} else {
					Util.ErrorCodeShow(scmd.res)
				}
			}

			let Handler11204 = () => {
				let scmd = user_msg_adapter.GetSCMD(11204)
				if (scmd.role_id) {
					let role = Scene.GetInstance().GetRole(scmd.role_id)
					if (role) {
						let vo = role.GetVo()
						if (vo) {
							vo.SetDressList(scmd.dress_list)
						}
					}
				}
			}

			let Handler11205 = () => {
				let scmd = user_msg_adapter.GetSCMD(11205)
				this.model.SetUnActDressData(scmd.dress_type, scmd.dress_id, scmd.active_power);
				this.model.Fire(local_DressEvent.DRESS_ACTIVE_POWER_DATA)
			}

			this.RegisterProtocal(11200, Handler11200)
			this.RegisterProtocal(11201, Handler11201)
			this.RegisterProtocal(11202, Handler11202)
			this.RegisterProtocal(11203, Handler11203)
			this.RegisterProtocal(11204, Handler11204)
			this.RegisterProtocal(11205, Handler11205)
		}

		this.InitInfo()
		this.InitEvent()
	}

}
window["DressController"] = DressController