import { BaseController } from "../common/BaseController"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { longlangModel } from "../commonModel/longlangModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { CompositeModel } from "../commonModel/CompositeModel"
import { Util } from "../util/Util"
import { MainFunc } from "../commonModel/MainUIModel"
import { OpenFun } from "../common/OpenFun"
import { Alert, Alert_Type } from "../alert/Alert"

import "../longlanguage/longQuickFuncView"

export class longlangController extends BaseController {
	initInfo

	public constructor() {
		super()

		this.initInfo = () => {
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let model = longlangModel.GetInstance()
			let gmodel = GoodsModel.GetInstance()

			let local_longlangModel = longlangModel
			let local_GoodsModel = GoodsModel
			let local_GlobalEventSystem = GlobalEventSystem
			let local_EventName = EventName
			let composite_model = CompositeModel.GetInstance()
			let view_dic_ = []
			model.Bind(local_longlangModel.OPEN_VIEW, (view_name: string, ...new_args) => {
				let view = view_dic_[view_name]
				if (!view) {
					view_dic_[view_name] = true
					if (view_dic_[view_name] == true) {
						let view_class = window[view_name]
						view = new view_class()
						view_dic_[view_name] = view
					}
				}
				if (view && view != true) {
					view.Open(...new_args)
				}
			}
			)
			model.Bind(local_longlangModel.SEND_PROTO, (id, fmt, ...new_args) => {
				this.SendFmtToGame(id, fmt, ...new_args)
			}
			)
			gmodel.Bind(local_GoodsModel.CREATE_SPECIAL_SCORE_FINISH, () => {
				model.RefreshStrRed()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
			})
			gmodel.Bind(local_GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				if (vo.currency_id == local_longlangModel.MONEY_TYPE) {
					model.RefreshStrRed()
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
				}
			}
			)
			gmodel.Bind(local_GoodsModel.CHANGE_LONGLANG_BAG, (add?) => {
				composite_model.RefreshLonglangRedDot()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
				if (!add) {
					return
				}
				let longlang_list = GoodsModel.GetInstance().longlang_bag_list
				if (!longlang_list || longlang_list.length <= 0) {
					return
				}
				let num = longlang_list.length
				if (num >= 800) {
					Alert.Show("神祭背包空间不足,请尽快前往整理背包.", Alert_Type.One, () => {
						OpenFun.OpenFunHandler(164)
						model.Fire(local_longlangModel.OPEN_VIEW, "longlangSBaseView")
					}
						, null, "前往分解")
				}
			}
			)
			gmodel.Bind(local_GoodsModel.CHANGE_LONGLANG_EQUIP, () => {
				model.RefreshStrRed()
				composite_model.RefreshLonglangRedDot()
				local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
			}
			)
			let On62200 = () => {
				let scmd = user_msg_adapter.GetSCMD(62200)
				if (scmd) {
					Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
					model.Fire("error")
				}
			}

			let On62201 = () => {
				let scmd = user_msg_adapter.GetSCMD(62201)
				if (scmd) {
					let dic = []
					for (let _tmpi in scmd.equip_list) {
						let vo = scmd.equip_list[_tmpi]
						dic[vo.pos] = vo.stren
					}
					let i = 1
					do {
						model.equipInfo[i] = dic[i] || 0
						i = i + 1
					} while ((i <= local_longlangModel.EQUIP_COUNT))
					model.RefreshStrRed()
					model.Fire(local_longlangModel.EQUIP_STR_INFO)
				}
			}

			let On62202 = () => {
				let scmd = user_msg_adapter.GetSCMD(62202)
				if (scmd) {
					model.equipInfo[scmd.pos_id] = scmd.stren_lv
					model.RefreshStrRed()
					model.Fire(local_longlangModel.EQUIP_STR_INFO, scmd.pos_id)
				}
			}

			let On62207 = () => {
				let scmd = user_msg_adapter.GetSCMD(62207)
				if (scmd) {
					model.ChangeVar("rating", scmd.rating)
				}
			}

			let On62208 = () => {
				let scmd = user_msg_adapter.GetSCMD(62208)
				if (scmd && scmd.code == 1) {
					model.Fire(local_longlangModel.PREVIEW_SUIT, scmd)
				}
			}

			let On62209 = () => {
				let scmd = user_msg_adapter.GetSCMD(62209)
				if (scmd) {
					model.Fire(local_longlangModel.SUIT_INOF, scmd)
				}
			}

			this.RegisterProtocal(62200, On62200)
			this.RegisterProtocal(62201, On62201)
			this.RegisterProtocal(62202, On62202)
			this.RegisterProtocal(62207, On62207)
			this.RegisterProtocal(62208, On62208)
			this.RegisterProtocal(62209, On62209)
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				this.SendFmtToGame(62201)
			}
			)
		}

		this.initInfo()
	}
}
window["longlangController"] = longlangController