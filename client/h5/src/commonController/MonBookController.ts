import { RedKey } from "./../common/RedDotDefine"
import { RedDotController } from "./../common/RedDotController"
import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { MonBookModel } from "../commonModel/MonBookModel"
import { TaskModel } from "../commonModel/TaskModel"
import { MonBookMainView } from "../monBook/MonBookMainView"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"

import "../monBook/MonBookDecomposeView";
import "../monBook/MonBookGroupView";
import { SecretTreasureMainViewIndex } from "../commonModel/LungModel"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"

export class MonBookController extends BaseController {
	Init
	public constructor() {
		super()


		this.Init = () => {
			let _model = MonBookModel.GetInstance()
			let _global_event_system = GlobalEventSystem
			let local_EventName = EventName
			let local_MonBookModel = MonBookModel
			let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncOpenCondition
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let local_Message = Message
			let task_model = TaskModel.GetInstance()
			let role_mgr = RoleManager.GetInstance()
			_global_event_system.Bind(local_EventName.INIT_CONFIG, () => {

			}
			)
			_global_event_system.Bind(local_EventName.GAME_START, async () => {
				await _model.InitConfig()
				_model.LoadMaxLevelConfig()
				_model.SendMsgWhenGameStart()
			}
			)
			_model.Bind(local_MonBookModel.SCMD_REQUEST, (cmd, ...new_args) => {
				// let args = new_args
				if (44203 == cmd) {
					this.SendFmtToGame(cmd, "i", new_args[0])
				} else if (44204 == cmd) {
					this.SendFmtToGame(cmd, "i", new_args[0])
				} else if (44202 == cmd) {
					this.SendFmtToGame(cmd, "i", new_args[0])
				} else if (44201 == cmd) {
					this.SendFmtToGame(cmd, "h", new_args[0])
				} else if (44205 == cmd) {
					this.SendFmtToGame(cmd)
				} else if (44207 == cmd) {
					this.SendFmtToGame(cmd, "i", new_args[0])
				}
			}
			)

			let goods_change_fun = (_type) => {
				if (_type && _type == MainFunc.Treasure) {
					RefPageRed()
				}
			}
			GlobalEventSystem.Bind(EventName.REFRESH_FUNCTION_ICON_RED_DOT, goods_change_fun)


			GlobalEventSystem.Bind(EventName.UPDATE_NEWEST_TASK_ID, (value?) => {
				let newest_finish_task_id = value
				let mon_book_cfg = cfg["MonBookMainView"]
				if (mon_book_cfg && mon_book_cfg.open_task == newest_finish_task_id) {
					_model.UpdateTabDot()
				}
			}
			)
			GoodsModel.GetInstance().Bind(GoodsModel.CREATE_BAG_LIST_FINISH, () => {
				_model.Fire(local_MonBookModel.SCMD_REQUEST, 44205)
				_model.UpdateTabDot()
			})
			role_mgr.GetMainRoleVo().Bind(local_EventName.CHANGE_LEVEL, (level?) => {
				let mon_book_cfg = cfg["MonBookMainView"]
				if (mon_book_cfg && mon_book_cfg.open_lv == level) {
					_model.UpdateTabDot()
				}
			}
			)
			let On44201 = () => {
				let scmd = user_msg_adapter.GetSCMD(44201)
				if (scmd) {
					_model.SetBookDataList(scmd)
				}
			}

			let On44202 = () => {
				let scmd = user_msg_adapter.GetSCMD(44202)
				if (scmd) {
					if (scmd.errcode == 1) {
						scmd["lv"] = 1
						_model.UpdateBookDataList(scmd)

						_model.Fire(local_MonBookModel.PLAY_EFFECT, scmd.pic_id, 0)
						_model.Fire(local_MonBookModel.SCMD_REQUEST, 44205)
						local_Message.show("激活成功")
					} else {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			}

			let On44203 = () => {
				let scmd = user_msg_adapter.GetSCMD(44203)
				if (scmd) {
					if (scmd.errcode == 1) {
						_model.UpdateBookDataList(scmd)

						_model.Fire(local_MonBookModel.PLAY_EFFECT, scmd.pic_id, 1)
						local_Message.show("升级成功")
					} else {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			}

			let On44204 = () => {
				let scmd = user_msg_adapter.GetSCMD(44204)
				if (scmd) {
					if (scmd.errcode == 1) {
						Message.show("操作成功")
						let config_mon_pic_group = Config.PRELOAD_SERVER_CONFIG.config_mon_pic_group
						_model.UpdateGroupDataList(scmd, config_mon_pic_group)
						_model.Fire(local_MonBookModel.PLAY_STAR_EFFECT, scmd.group_id)
						// if (scmd.lv == 0) {
						// 	_model.Fire(local_MonBookModel.PLAY_EFFECT, 0)
						// } else {
						// 	_model.Fire(local_MonBookModel.PLAY_EFFECT, 1)
						// }
					} else {
						Util.ErrorCodeShow(scmd.errcode)
					}
				}
			}

			let On44205 = () => {
				let scmd = user_msg_adapter.GetSCMD(44205)
				if (scmd) {
					_model.ClearColorList()
					_model.SetMonBookActivatedList(scmd.pic_list)
					_model.UpdateDecomposeItemList()
					_model.Fire(local_MonBookModel.UPDATE_DECOMPOSE_VIEW)
					RefPageRed()
				}
			}

			let On44207 = () => {
				let scmd = user_msg_adapter.GetSCMD(44207)
				if (scmd) {
					_model.SetActBookPower(scmd.pic_id, scmd.next_power)
					_model.Fire(local_MonBookModel.REFRESH_NEXT_POWER, scmd.pic_id)	
				}
			}

			//刷新页面的红点
			let RefPageRed = () => {
				let is_show = _model.IsShowIconDot()
				_global_event_system.Fire(local_EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "SecretTreasureMainView", SecretTreasureMainViewIndex.MonBook, is_show)
			}

			this.RegisterProtocal(44201, On44201)
			this.RegisterProtocal(44202, On44202)
			this.RegisterProtocal(44203, On44203)
			this.RegisterProtocal(44204, On44204)
			this.RegisterProtocal(44205, On44205)
			this.RegisterProtocal(44207, On44207)
		}


		this.Init()
	}

}


window["MonBookController"] = MonBookController