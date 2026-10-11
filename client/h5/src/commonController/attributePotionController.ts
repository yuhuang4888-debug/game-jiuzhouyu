
//require("game.attributePotion.attributePotionItem")
//require("game.common.attributePotionModel")
//require("game.attributePotion.attributePotionTab")
//require("game.attributePotion.attributePotionView")

import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoadLuaClassAB, Util } from "../util/Util"
import { attributePotionModel } from "../commonModel/attributePotionModel"
import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import "../attributePotion/attributePotionView"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc } from "../commonModel/MainUIModel"

//require("game.preload_proto.Require217")
export class attributePotionController extends BaseController {
InitInfo

public constructor(){
	super() 
		
		
		let _model = attributePotionModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_attributePotionModel = attributePotionModel
		let user_msg_adapter = UserMsgAdapter.GetInstance()
		
		let _view = null
		this.InitInfo = () => {
			let open_view = (index?) => {
				let  callback = ()=>{
					if (! _view ) {
						// [ts2lua]window下标访问可能不正确s
						let view_class = window["attributePotionView"]
						_view = new view_class()
					}
					index = (! index) && 1 || index
					_view.setDefaultTab(index)
					_view.Open()
					_model.Setview_Open(true)
				}
				LoadLuaClassAB("attributePotionView", callback)
			}
			
			local_GlobalEventSystem.Bind(local_EventName.OPEN_ATTRIBUTEPOTION_VIEW, open_view)
			
			local_GlobalEventSystem.Bind(local_EventName.GAME_START,() => {
					_model.InitConfig()
					this.SendFmtToGame(21703)
				}
			)
			let day_change = () => {
				_model.cleanTimeData()
				this.SendFmtToGame(21703)
			}
			
			local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, day_change)
			_model.Bind(local_attributePotionModel.REQUEST_TIME_DATA,(level?) => {
					this.SendFmtToGame(21701, "c", level)
				}
			)
			_model.Bind(local_attributePotionModel.REQUEST_USE,(good_id?, num?, lv?) => {
					this.SendFmtToGame(21702, "iic", good_id, num, lv)
				}
			)
			let On21700 = () => {
				let scmd = user_msg_adapter.GetSCMD(21700)
				Util.ErrorCodeShow(scmd.errcode)
			}
			
			this.RegisterProtocal(21700, On21700)
			let On21701 = () => {
				let scmd = user_msg_adapter.GetSCMD(21701)
				_model.setTimeData(scmd)
			}
			
			this.RegisterProtocal(21701, On21701)
			let On21703 = () => {
				let scmd = user_msg_adapter.GetSCMD(21703)
				_model.setAllTimeData(scmd)
			}
			
			this.RegisterProtocal(21703, On21703)
		}

		// let OnBagChange = () => {
		// 	_model.Fire(local_attributePotionModel.TIME_DATA_RETURN, "All")
		// 	local_GlobalEventSystem.Fire(local_EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Role)
		// }

		// GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, OnBagChange)
		
		this.InitInfo()
	}

}
window["attributePotionController"] = attributePotionController