import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { EquipmentViewSecond_Menu_Type } from "../commonModel/EquipModel"
import { FashionModel, IFashionInfo } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import { MainFunc } from "../commonModel/MainUIModel"
import "../fashion/FashionBaseView"
import { Message } from "../sysInfo/SysInfoController"

let local_FashionModel = FashionModel
let local_GlobalEventSystem = GlobalEventSystem
let local_EventName = EventName
export class FashionController extends BaseController {
	fashion_model:FashionModel = FashionModel.GetInstance()
	user_msg_adapter:UserMsgAdapter = UserMsgAdapter.GetInstance()
	goods_model:GoodsModel = GoodsModel.GetInstance()
	role_mgr:RoleManager = RoleManager.GetInstance()


	view_dic = {}
	public constructor() {
		super()

		this.InitEvent()
		this.RegisterAllProtocals()
	}

	public InitEvent(){
		this.fashion_model.Bind(local_FashionModel.SCMD_REQUEST, (cmd, ...new_args) => {
			let args = new_args
			if (41300 == cmd || 41313 == cmd) {
				this.SendFmtToGame(cmd)
			} else if (41301 == cmd) {
				this.SendFmtToGame(cmd, "cicc", args[0], args[1], args[2], args[3])
			} else if (41307 == cmd) {
				this.SendFmtToGame(cmd)
			} else if (41311 == cmd) {
				this.SendFmtToGame(cmd)
			} else if (41302 == cmd) {
				this.SendFmtToGame(cmd, "cic", args[0], args[1], args[2])
			} else if (41303 == cmd) {
				this.SendFmtToGame(cmd, "ci", args[0], args[1])
			} else if (41304 == cmd) {
				this.SendFmtToGame(cmd, "ci", args[0], args[1])
			} else if (41306 == cmd || 41316 == cmd) {
				this.SendFmtToGame(cmd, "cic", args[0], args[1], args[2])
			} else if (41310 == cmd) {
				this.SendFmtToGame(cmd, "ci", args[0], args[1])
			} else if (41305 == cmd) {
				this.WriteBegin(cmd)
				this.WriteFMT("c", args[0])
				this.WriteFMT("h", args[1].length)
				for (let _tmpi in args[1]) {
					var good = args[1][_tmpi]
					this.WriteFMT("l", good[0])
					this.WriteFMT("h", good[1])
				}
				this.SendToGame()
			} else if (41312 == cmd) {
				this.SendFmtToGame(cmd, "ci", args[0], args[1])
			} else if (41314 == cmd) {
				this.SendFmtToGame(cmd, "cc", args[0], args[1])
			} else if (41315 == cmd) {
				this.SendFmtToGame(cmd, "c", args[0])
			}
		}
		)

		let JudgeGoodType = (goods_list?) => {
			// let need_update_red = true
			let need_update_red = false
			for(let goods_vo of goods_list){
				if(goods_vo.type == FashionModel.FashionGoodsType){
					need_update_red = true
					break
				}
			}
			
			if(need_update_red){
				this.fashion_model.TryRefreshFashionRed()
				this.fashion_model.TryRefreshSuitUpStageRed()
			}
		}
		this.goods_model.Bind(GoodsModel.CHANGE_BAG_LIST, JudgeGoodType)

		let CreateCurrentUserModelList = () => {
			this.fashion_model.UpdateCurrentUserModelList(this.role_mgr.GetMainRoleVo().career, this.role_mgr.GetMainRoleVo().sex)
			this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41300)
			this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41313)
		}
		this.goods_model.Bind(GoodsModel.CREATE_BAG_LIST_FINISH, CreateCurrentUserModelList)

		local_GlobalEventSystem.Bind(local_EventName.CHANGE_MAINROLE_CAREER, () => {
			this.fashion_model.UpdateCurrentUserModelList(this.role_mgr.GetMainRoleVo().career, this.role_mgr.GetMainRoleVo().sex)
		})

		let GetActivateFashionInfo = (list?) => {
			if (list) {
				this.fashion_model.CreateActiveList(list)
			}
		}
		this.fashion_model.Bind(local_FashionModel.GETACTIVATEFASHION, GetActivateFashionInfo)

		let OpenFashionView = (type_id?, parms?, backId?, backShowId?) => {
			if (type_id == EquipmentViewSecond_Menu_Type.Fashion) {
				let view = this.view_dic["FashionBaseView"]
				if (!view) {
					this.view_dic["FashionBaseView"] = true
					if (!window["FashionBaseView"]) {
						if (!ResManager.GetInstance().IsJsLoad("fashion")) {

						}
					}
					if (this.view_dic["FashionBaseView"] == true) {
						let view_class = window["FashionBaseView"]
						view = new view_class()
						this.view_dic["FashionBaseView"] = view
					}
				}
				if (view && view != true) {
					if (backId) {
						view.SetBackId(backId, backShowId)
						view.isbackId = true
					}
					if (parms) {
						let index = parms[0] != null ? parms[0] : 0
						let career = this.role_mgr.GetMainRoleVo().career
						view.SetDefaultIndex(index)
						view.Open(index, parms[1] && parms[1] || parms[0], parms[2])
					} else {
						view.Open()
					}
				}
			}
		}

		RoleManager.GetInstance().GetMainRoleVo().Bind(
			local_EventName.CHANGE_LEVEL, (level) => {
				let cond_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition["FashionBaseView"]
				if (cond_cfg && cond_cfg.open_lv == level) {
					this.fashion_model.Fire(local_FashionModel.UPDATEVIEW)
					local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
				}
			}
		)

		local_GlobalEventSystem.Bind(local_EventName.SWITCH_ROLE_SECOND_BUTTON, OpenFashionView)
		local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
			this.fashion_model.ResetData()
			this.fashion_model.InitConfig()
		}
		)
	}

	public RegisterAllProtocals(){
		let On41300 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41300)
			if (scmd.code == 1) {
				for (let _tmpi in scmd.pos_list) {
					var list = scmd.pos_list[_tmpi]
					this.fashion_model.Fire(local_FashionModel.GETACTIVATEFASHION, list)
				}
				this.fashion_model.TryRefreshFashionRed()
				this.fashion_model.TryRefreshSuitUpStageRed()
			}
		}
		let On41301 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41301)
			if (scmd.code == 1) {

				let fashion_pos_info = this.fashion_model.fashion_info_dic[scmd.pos_id];
				if(fashion_pos_info){
					fashion_pos_info.wear_fashion_id = scmd.fashion_id
				}


				let fashion_info:IFashionInfo = this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id]
				if(!fashion_info){
					fashion_info = {
						fashion_id:scmd.fashion_id,
						fashion_star_lv:1,
						now_color_id:scmd.color_id,
						color_list:[{ color_id: scmd.color_id, fashion_star_lv: 1 }]
					}
					this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id] = fashion_info
				}else{
					fashion_info.now_color_id = scmd.color_id
					fashion_info.fashion_star_lv = 1
					table.insert(fashion_info.color_list, { color_id: scmd.color_id, fashion_star_lv: 1 })
				}

				this.fashion_model.Fire(local_FashionModel.SUCCESSOPERATE, scmd.pos_id, 1)
				this.fashion_model.Fire(local_FashionModel.UPDATEVIEW, scmd.pos_id)
				this.fashion_model.RefreshColorRed(scmd.pos_id)

				let data = {
					_type: 413,
					sub_type: scmd.pos_id,
					id: scmd.fashion_id,
					color_id: scmd.color_id,
					type_id: 0,
					isFirst: true
				}
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		let On41302 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41302)
			if (scmd.code == 1) {
				if(this.fashion_model.fashion_info_dic){
					if (this.fashion_model.fashion_info_dic[scmd.pos_id]) {
						this.fashion_model.fashion_info_dic[scmd.pos_id].wear_fashion_id = scmd.fashion_id
						let list = this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id]
						list.now_color_id = scmd.color_id
						this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id] = list
						this.fashion_model.Fire(local_FashionModel.UPDATEVIEW, scmd.pos_id, 1)
					} else {
						this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41300)
					}
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On41303 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41303)
			if (scmd.code == 1) {
				if(this.fashion_model.fashion_info_dic){
					if (this.fashion_model.fashion_info_dic[scmd.pos_id]) {
						this.fashion_model.fashion_info_dic[scmd.pos_id].wear_fashion_id = 0
						this.fashion_model.Fire(local_FashionModel.UPDATEVIEW, scmd.pos_id, 2)
					} else {
						this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41300)
					}
				}
			}
		}

		let On41304 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41304)
			if (scmd.code == 1) {
				let fashion_pos_info = this.fashion_model.fashion_info_dic[scmd.pos_id];
				if(fashion_pos_info){
					fashion_pos_info.wear_fashion_id = scmd.fashion_id
				}

				let fashion_info:IFashionInfo = this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id]
				if(!fashion_info){
					fashion_info = {
						fashion_id:scmd.fashion_id,
						fashion_star_lv:1,
						now_color_id: 0,
						color_list:[{ color_id: 0, fashion_star_lv: 1 }]
					}
					this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id] = fashion_info
				}else{
					fashion_info.fashion_id = scmd.fashion_id
					fashion_info.fashion_star_lv = 1
					fashion_info.now_color_id = 0
					fashion_info.color_list.push({ color_id: 0, fashion_star_lv: 1 })

				}

				this.fashion_model.RefreshBaseRed(scmd.pos_id)
				this.fashion_model.Fire(local_FashionModel.SUCCESSOPERATE, scmd.pos_id, 1)
				this.fashion_model.Fire(local_FashionModel.UPDATEVIEW, scmd.pos_id)
				this.fashion_model.TryRefreshSuitUpStageRed()
				let data = {
					_type: 413,
					sub_type: scmd.pos_id,
					id: scmd.fashion_id,
					color_id: 0,
					type_id: 0,
					isFirst: true
				}
				this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41302, scmd.pos_id, scmd.fashion_id, 0)
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
			}
		}

		let On41305 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41305)
			if (scmd.code != 1) {
				Util.ErrorCodeShow(scmd.code)
				return
			}
			Message.show("成功")
			if (this.fashion_model.fashion_info_dic[scmd.pos_id]) {
				this.fashion_model.fashion_info_dic[scmd.pos_id].pos_lv = scmd.pos_lv
				this.fashion_model.fashion_info_dic[scmd.pos_id].pos_upgrade_num = scmd.pos_upgrade_num
				// this.fashion_model.Fire(local_FashionModel.SUCCESSOPERATE, scmd.pos_id, 2)
				this.fashion_model.TryRefreshFashionRed()
				this.fashion_model.Fire(local_FashionModel.UPDATELEVEL, scmd.pos_id)
			} else {
				this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41300)
			}
		}

		let On41306 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41306)
			if (scmd.code == 1) {
				if (this.fashion_model.fashion_active_dic[scmd.pos_id]) {
					let list = this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id]
					if (list.now_color_id == scmd.color_id) {
						list.fashion_star_lv = scmd.fashion_star_lv
					}
					for (let k in list.color_list) {
						var v = list.color_list[k]
						if (v.color_id == scmd.color_id) {
							v.fashion_star_lv = scmd.fashion_star_lv
						}
					}
					this.fashion_model.RefreshBaseRed(scmd.pos_id)
					this.fashion_model.Fire(local_FashionModel.SUCCESSOPERATE, scmd.pos_id, 1)
					this.fashion_model.Fire(local_FashionModel.UPDATEVIEW, scmd.pos_id)
					this.fashion_model.TryRefreshSuitUpStageRed()
				} else {
					this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41300)
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On41311 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41311)
			let role_vo = SceneManager.GetInstance().GetRoleVo(scmd.role_id)
			if (role_vo) {
				if(role_vo.fashion_model_list.length == scmd.fashion_equip.length &&  role_vo.fashion_model_list.length == 0) return
				role_vo.ChangeVar("fashion_model_list", scmd.fashion_equip)
			}
		}

		let On41312 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41312)
			this.fashion_model.Fire(local_FashionModel.UPDATE_FIGHT, scmd)
		}

		let On41313 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41313)
			this.fashion_model.SetSuitData(scmd)
			this.fashion_model.RefreshSuitActiveRed()
			this.fashion_model.Fire(local_FashionModel.UPDATE_SUIT_DATA)
		}

		let On41314 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41314)
			if(scmd.code == 1){
				Message.show("激活成功")
				let suit_data = this.fashion_model.GetSuitData(scmd.suit_id)
				suit_data.active_num = scmd.active_num
				suit_data.power = scmd.power
				suit_data.next_power = scmd.next_power
				if(suit_data.active_num >= local_FashionModel.SuitPerfectActiveCount){
					suit_data.lv = 1
					this.fashion_model.RefreshSuitUpStageRed()
				}
				this.fashion_model.RefreshSuitActiveRed()
				this.fashion_model.Fire(local_FashionModel.UPDATE_SUIT_DATA, scmd.suit_id)
			}
			else{
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On41315 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41315)
			if(scmd.code == 1){
				Message.show("进阶成功")
				let suit_data = this.fashion_model.GetSuitData(scmd.suit_id)
				suit_data.lv = scmd.lv
				suit_data.power = scmd.power
				suit_data.next_power = scmd.next_power
				this.fashion_model.RefreshSuitUpStageRed()
				this.fashion_model.Fire(local_FashionModel.UPDATE_SUIT_DATA, scmd.suit_id)
			}
			else{
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On41316 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(41316)
			if (scmd.code == 1) {
				if (this.fashion_model.fashion_active_dic[scmd.pos_id]) {
					let list = this.fashion_model.fashion_active_dic[scmd.pos_id][scmd.fashion_id]
					if (list.now_color_id == scmd.color_id) {
						list.fashion_star_lv = scmd.lv
					}
					for (let k in list.color_list) {
						var v = list.color_list[k]
						if (v.color_id == scmd.color_id) {
							v.fashion_star_lv = scmd.lv
						}
					}
					this.fashion_model.RefreshColorRed(scmd.pos_id)
					this.fashion_model.Fire(local_FashionModel.SUCCESSOPERATE, scmd.pos_id, 1)
					this.fashion_model.Fire(local_FashionModel.UPDATEVIEW, scmd.pos_id)
				} else {
					this.fashion_model.Fire(local_FashionModel.SCMD_REQUEST, 41300)
				}
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		this.RegisterProtocal(41300, On41300)
		this.RegisterProtocal(41301, On41301)
		this.RegisterProtocal(41302, On41302)
		this.RegisterProtocal(41303, On41303)
		this.RegisterProtocal(41304, On41304)
		this.RegisterProtocal(41305, On41305)
		this.RegisterProtocal(41306, On41306)
		this.RegisterProtocal(41311, On41311)
		this.RegisterProtocal(41312, On41312)
		this.RegisterProtocal(41313, On41313)
		this.RegisterProtocal(41314, On41314)
		this.RegisterProtocal(41315, On41315)
		this.RegisterProtocal(41316, On41316)
	}
}

window["FashionController"] = FashionController