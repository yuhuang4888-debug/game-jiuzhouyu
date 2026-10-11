import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { Message } from "../sysInfo/SysInfoController"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { SuitActivityWindow } from "../suitActivity/SuitActivityWindow"
import { ResManager } from "../common/ResManager"

import "../suitActivity/SuitActivityWindow"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
//史诗套装
//require("game.suitActivity.SuitActivityModel")
//require("game.suitActivity.SuitActivityWindow")
//require("game.suitActivity.SuitActivityView")
//require("game.suitActivity.SuitActivityEquip")
//require("game.suitActivity.SuitActivityItem")
//require("game.suitActivity.suitActivityPanel")
//require("game.suitActivity.SuitActivityActiveView")

export class SuitActivityController extends BaseController {
	model
	sa_window_view
	view_dic
	user_mgr
	static instance: any

	public constructor() {
		super()
		SuitActivityController.instance = this
		this.view_dic = []
		this.model = SuitActivityModel.GetInstance()
		this.user_mgr = UserMsgAdapter.GetInstance()
		this.RegisterAllProtocals()
		this.InitEvent()
	}

	public RegisterAllProtocals() {
		let On15256 = () => {
			let vo = this.user_mgr.GetSCMD(15256)
			this.model.SetSuitData(vo.clt_list)
			this.model.useFashion = vo.suit_id
		}

		let On15257 = () => {
			let vo = this.user_mgr.GetSCMD(15257)
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
			if (!cfg) {
				return
			}
			if (vo.code == 1) {
				// Message.show("激活成功")
				if (vo.cur_stage == 8) {
					let show = true
					let list = this.model.suit_list
					let curFshion = cfg[vo.suit_id + "@" + 1]
					for (let _ in list) {
						let vo = list[_]
						if (vo.cur_stage == 8) {
							let sub_cfg = cfg[vo.suit_id + "@" + 1]
							if (curFshion.fashion_id == sub_cfg.fashion_id && curFshion.fashion_color == sub_cfg.fashion_color) {
								show = null
								break
							}
						}
					}
					if (show) {
						let use = !this.model.useFashion || this.model.useFashion != vo.suit_id
						let data = {
							_type: 152,
							id: vo.suit_id,
							isFirst: false,
							isUse: use,
						    cb: () => {
								let newStatus = use && 1 || 0
								this.model.Fire(SuitActivityModel.WEAR_FASHION, vo.suit_id, newStatus)
							} 
						}
						OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)

						// this.model.Fire(SuitActivityModel.OPEN_VIEW, "SuitActivityActiveView", vo.suit_id)
					}
				}
				this.model.AddSuitData(vo)
			} else {
				Util.ErrorCodeShow(vo.code)
			}
		}

		let On15258 = () => {
			let vo = this.user_mgr.GetSCMD(15258)
			this.model.AddActiveData(vo)
		}

		let On15259 = () => {
			let vo = this.user_mgr.GetSCMD(15259)
			if (vo.code == 1) {
				this.model.SetFashionData(vo)
				if (vo.suit_id != 0) {
					if (vo.is_wear == 1) {
						Message.show("穿戴成功")
					} else {
						Message.show("卸下成功")
					}
				}
				this.model.Fire(SuitActivityModel.UPDATE_WEAR_FASHION)
			} else {
				Util.ErrorCodeShow(vo.code)
			}
		}

		this.RegisterProtocal(15256, On15256)
		this.RegisterProtocal(15257, On15257)
		this.RegisterProtocal(15258, On15258)
		this.RegisterProtocal(15259, On15259)
	}

	public InitEvent() {
		let ActiveSuit = (suit_id, stage) => {
			this.SendFmtToGame(15257, "cc", suit_id, stage)
		}
		this.model.Bind(SuitActivityModel.ACTIVITY_SUIT, ActiveSuit)

		this.model.Bind(SuitActivityModel.WEAR_FASHION, (suit_id?, status?) => {
			this.SendFmtToGame(15259, "cc", suit_id, status)
		})

		let OpenSAView = () => {
			if (this.sa_window_view == null) {
				this.sa_window_view = new SuitActivityWindow()
			}
			if (this.sa_window_view.HasOpen()) {
				this.sa_window_view.Close()
			} else {
				this.sa_window_view.GetWindowSubData()
				this.sa_window_view.Open()
			}
		}
		this.model.Bind(SuitActivityModel.OPEN_SUIT_VIEW, OpenSAView)

		let CloseBagView = () => {
			if (this.sa_window_view && this.sa_window_view.HasOpen()) {
				this.sa_window_view.Close()
			}
		}
		this.model.Bind(SuitActivityModel.CLOSE_SUIT_VIEW, CloseBagView)

		let OpenView = (view_name: string, ...new_args) => {
			let view = this.view_dic[view_name]
			if (!view && view_name) {
				view = new window[view_name]()
				this.view_dic[view_name] = view
			}

			if (view) {
				if (view.HasOpen()) {
					view.Close()
				} else {
					view.Open(...new_args)
				}
			}
		}
		this.model.Bind(SuitActivityModel.OPEN_VIEW, OpenView)

		let role_vo = RoleManager.GetInstance().GetMainRoleVo()
		role_vo.Bind(EventName.CHANGE_LEVEL, (lv?) => {
			if (lv >= this.model.next_level) {
				this.model.UpdateReddot()
			}
		})

		role_vo.BindOne("turn", () => {
			this.model.UpdateReddot()
		})

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.model.InitData()
			this.SendFmtToGame(15256)
		})

		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_EQUIPLIST, () => {
			this.model.UpdateReddot()
		})
		
		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, (goods_list)=>{
			this.model.UpdateReddot()
		})
	}
}
window["SuitActivityController"] = SuitActivityController