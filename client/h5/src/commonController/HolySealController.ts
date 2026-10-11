import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Message } from "../sysInfo/SysInfoController"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { LoadLuaClassAB, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { Config } from "../common/Config"

// import { CompositeModel } from "../commonModel/CompositeModel"
export class HolySealController extends BaseController {
	composite_model
	goods_model
	holy_seal_model
	user_msg_adapter


	public constructor() {
		super()


		this.holy_seal_model = HolySealModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		// this.composite_model = CompositeModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()

		this.InitEvent()
		this.RegisterAllProtocals()
	}

	public InitEvent() {


		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.holy_seal_model.InitSealSoul()
			this.holy_seal_model.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65401)
			this.holy_seal_model.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65405)
		}
		)

		this.holy_seal_model.Bind(HolySealModel.REQUEST_CCMD_EVENT, (cmd, ...new_args) => {
			let args = new_args
			switch (cmd) {
				case 65402:
					this.SendFmtToGame(cmd, "cc", args[0], args[1])
					break
				case 65403:
					this.SendFmtToGame(cmd, "cl", args[0], args[1])
					break
				case 65404:
					this.SendFmtToGame(cmd, "c", args[0])
					break
				case 65406:
					this.SendFmtToGame(cmd, "ih", args[0], args[1])
					break
				case 65408:
					this.SendFmtToGame(cmd, "i", args[0])
					break
				default:
					this.SendFmtToGame(cmd)
					break
			}
		})

		this.goods_model.Bind(GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			for (let _tmpi in goods_list) {
				var vo = goods_list[_tmpi]
				if (this.holy_seal_model.soul_data && this.holy_seal_model.soul_data[vo.type_id]) {
					this.holy_seal_model.RefreshSoulRed()
				}
			}
		}
		)

		this.goods_model.Bind(GoodsModel.CREATE_BAG_LIST_FINISH, (goods_list?) => {
			this.holy_seal_model.RefreshSoulRed()
		}
		)

		this.goods_model.Bind(GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST, () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_seal_equip
			this.holy_seal_model.RefreshStrongRed(cfg)
			this.holy_seal_model.RefreshDecomposeRed()
			// this.composite_model.RefreshHolySealRedDot()
		}
		)

		this.goods_model.Bind(GoodsModel.CHANGE_HOLY_SEAL_LIST, () => {
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_seal_equip
			this.holy_seal_model.RefreshStrongRed(cfg)
			// this.composite_model.RefreshHolySealRedDot()
			// this.holy_seal_model.TryRefreshStrenRed()
		})

		this.goods_model.Bind(GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
			if (vo.currency_id == HolySealModel.MONEY_TYPE) {
				this.holy_seal_model.TryRefreshStrenRed()
			}
		})

		this.goods_model.Bind(GoodsModel.CREATE_SPECIAL_SCORE_FINISH, () => {
			this.holy_seal_model.TryRefreshStrenRed()
		})
	}

	public RegisterAllProtocals() {


		//通用错误返回
		let On65400 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65400)
			Util.ErrorCodeShow(scmd.error_code, scmd.error_code_args)
		}
		this.RegisterProtocal(65400, On65400)//通用错误返回

		//界面
		let On65401 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65401)
			let dic = {}
			for (let _tmpi in scmd.equip_list) {
				var value = scmd.equip_list[_tmpi]
				dic[value.pos] = value
			}
			let equip_dic = {}
			let i = 1
			do {
				let stren_lv = 0
				if (dic[i]) {
					stren_lv = dic[i].stren
				}
				equip_dic[i] = stren_lv
				i = i + 1
			} while ((i <= HolySealModel.EQUIP_COUNT))
			this.holy_seal_model.ChangeVar("stren_data", equip_dic)
			this.holy_seal_model.TryRefreshStrenRed()
		}
		this.RegisterProtocal(65401, On65401)//界面

		//强化
		let On65402 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65402)
			let stren_data = this.holy_seal_model.stren_data
			if (stren_data) {
				stren_data[scmd.pos_id] = scmd.stren_lv
			}
			this.holy_seal_model.Fire(HolySealModel.STREN_SUCCESS, scmd.pos_id)
			this.holy_seal_model.TryRefreshStrenRed()
		}
		this.RegisterProtocal(65402, On65402)//强化

		//穿装备
		let On65403 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65403)
		}
		this.RegisterProtocal(65403, On65403)//穿装备

		//脱装备
		let On65404 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65404)
		}
		this.RegisterProtocal(65404, On65404)//脱装备

		//圣魂丹界面协议
		let On65405 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65405)
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_seal_pill
			let soul_data = this.holy_seal_model.soul_data
			for (let _tmpi in scmd.seal_pill) {
				var vo = scmd.seal_pill[_tmpi]
				let data = soul_data[vo.goods_type_id]
				if (data) {
					data["num"] = vo.num
				}
			}
			this.holy_seal_model.ChangeVar("soul_data", soul_data, false, true)
			this.holy_seal_model.RefreshSoulRed()
		}

		this.RegisterProtocal(65405, On65405)//圣魂丹界面协议
		//使用圣魂丹
		let On65406 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65406)
			if (scmd.code == 0) {
				let soul_data = this.holy_seal_model.soul_data
				let data = soul_data[scmd.goods_type_id]
				if (data) {
					data["num"] = data["num"] + scmd.num
				}
				this.holy_seal_model.ChangeVar("soul_data", soul_data, false, true)
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}
		this.RegisterProtocal(65406, On65406)//使用圣魂丹

		//获取总评分
		let On65407 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65407)
			this.holy_seal_model.ChangeVar("total_rating", scmd.rating)
		}
		this.RegisterProtocal(65407, On65407)//获取总评分

		//套装预览
		let On65408 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65408)
			this.holy_seal_model.Fire(HolySealModel.UPDATE_SUIT_DATA, scmd)
		}
		this.RegisterProtocal(65408, On65408)//套装预览

		//套装
		let On65409 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(65409)
			this.holy_seal_model.Fire(HolySealModel.UPDATE_ALL_SUIT_DATA, scmd)
		}
		this.RegisterProtocal(65409, On65409)//套装

	}
}

window["HolySealController"] = HolySealController