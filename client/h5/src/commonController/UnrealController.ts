import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { PlayBigEffect, Util } from "../util/Util"


export class UnrealController extends BaseController {

	Init
	public constructor() {
		super()
		this.Init = () => {
			let _model = UnrealModel.GetInstance(),
				_global_eveny_system = GlobalEventSystem,
				local_UnrealModel = UnrealModel,
				goods_model = GoodsModel.GetInstance(),
				local_GoodsModel = GoodsModel,
				user_msg_adapter = UserMsgAdapter.GetInstance(),
				local_Util = Util

			_global_eveny_system.Bind(EventName.GAME_START, () => {
				for (let i = 1; i <= local_UnrealModel.equip_count; i++) {
					_model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14904, i)
				}
                _model.Fire(UnrealModel.REQUEST_CCMD_EVENT, 14908)
				// _model.RefreshIconRed()
			})

			let onRequestHandler = (cmd, ...args) => {
				switch (cmd) {
					case 14901:
					case 14902:
					case 14903:
					case 14906:
					case 14907:
						this.SendFmtToGame(cmd, "l", args[0])
						break
					case 14904:
						this.SendFmtToGame(cmd, "c", args[0])
						break
					case 14905:
						this.SendFmtToGame(cmd, "cc", args[0], args[1])
						break
					default:
						this.SendFmtToGame(cmd)
				}
			}
			_model.Bind(local_UnrealModel.REQUEST_CCMD_EVENT, onRequestHandler)

			goods_model.Bind(local_GoodsModel.CHANGE_UNREAL_BAG_LIST, () => {
				_model.RefreshDecomposeRed()
				_model.RefreshUnrealWearRed()
				_model.RefreshDismantleRed()

			})

			goods_model.Bind(local_GoodsModel.CHANGE_UNREAL_LIST, () => {
				_model.RefreshStrenRed()
				_model.RefreshUnrealWearRed()
			})

			goods_model.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, () => {
				_model.RefreshStrenRed()
				_model.RefreshUnrealWearRed()
			})


			goods_model.Bind(local_GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
				for (let vo of goods_list) {
					if (_model.bind_cost_goods[vo.type_id]) {
						_model.RefreshStrenRed()
						break
					}
				}
			})


			let On14900 = () => {
				let scmd = user_msg_adapter.GetSCMD(14900)
				local_Util.ErrorCodeShow(scmd.code_int, scmd.code_msg)
			}

			let On14901 = () => {
				let scmd = user_msg_adapter.GetSCMD(14901)
				_model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14904, scmd.cell_pos)
				local_Util.ErrorCodeShow(scmd.res)
                goods_model.Fire(GoodsModel.CHANGE_UNREAL_LIST)
			}

			let On14902 = () => {
				let scmd = user_msg_adapter.GetSCMD(14902)
				local_Util.ErrorCodeShow(scmd.res)
                scmd.goods_num = 0
                goods_model.UpdateUnrealEquipGoods(scmd)
                goods_model.Fire(GoodsModel.CHANGE_UNREAL_LIST)
			}

			let On14903 = () => {
				let scmd = user_msg_adapter.GetSCMD(14903)
				if (scmd.res == 1) {
					PlayBigEffect("ui_ZiTi_ShengJie",null,1.8)
                    // Message.show("进阶成功")
					_model.Fire(local_UnrealModel.STAGE_SUCCESS, scmd.cell)
					_model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14904, scmd.cell)
					_model.RefreshStrenRed()
				}
				else
					local_Util.ErrorCodeShow(scmd.res)
			}

			let On14904 = () => {
				let scmd = user_msg_adapter.GetSCMD(14904)
				_model.SetStrenData(scmd)
				_model.RefreshStrenRed()
				_model.Fire(local_UnrealModel.UPDATE_EQUIP_STREN_DATA, scmd.cell)
			}

			let On14905 = () => {
				let scmd = user_msg_adapter.GetSCMD(14905)
				if (scmd.res == 1) {
					PlayBigEffect("ui_qianghuachenggong",null,1.2)
                    // Message.show("强化成功")
					for (let vo of scmd.level_info) {
						_model.SetStrenData(vo)
						_model.Fire(local_UnrealModel.UPDATE_EQUIP_STREN_DATA, vo.cell)
						_model.Fire(local_UnrealModel.STREN_SUCCESS, vo.cell)
					}
					_model.RefreshStrenRed()
				}
			}

			let On14906 = () => {
				let scmd = user_msg_adapter.GetSCMD(14906)
				_model.SetStagePreviewData(scmd)
			}

			let On14907 = () => {
				let scmd = user_msg_adapter.GetSCMD(14907)
				_model.SetDecomposePreviewData(scmd)
			}

            //返回已解锁部位
            let On14908 = () => {
                let scmd =  user_msg_adapter.GetSCMD(14908)
                _model.SetUnLockCellList(scmd)
            }

			this.RegisterProtocal(14900, On14900)
			this.RegisterProtocal(14901, On14901)
			this.RegisterProtocal(14902, On14902)
			this.RegisterProtocal(14903, On14903)
			this.RegisterProtocal(14904, On14904)
			this.RegisterProtocal(14905, On14905)
			this.RegisterProtocal(14906, On14906)
			this.RegisterProtocal(14907, On14907)
			this.RegisterProtocal(14908, On14908)

		}

		this.Init()
	}


}
window["UnrealController"] = UnrealController