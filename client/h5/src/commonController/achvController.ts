
//require("game.proto.409.Require409")
//require("game.achv.AchvEnterView")
//require("game.achv.achvModel")
//require("game.achv.achvSubItem")
//require("game.achv.AchvTabBar")
//require("game.achv.AchvTabBtn")
//require("game.achv.AchvTabSubBtn")
//require("game.achv.AchvTipsItem")
//require("game.achv.AchvTotalItem")
//require("game.achv.achvUpSuccessView")
//require("game.achv.AchvPropItem")
//require("game.achv.AchvChildItem")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { achvModel } from "../commonModel/achvModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetAnchoredPosition, Util } from "../util/Util"
import  "../achv/AchvEnterView"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { MainFunc } from "../commonModel/MainUIModel"
import "../achv/AchvTipsItem"

//require("game.achv.achvView")
export class achvController extends BaseController {
InitInfo
view_dic
InitEvents

public constructor(){
super() 
	
	this.view_dic = {}
	let model = achvModel.GetInstance()
	let local_achvModel = achvModel
	let UMSG = UserMsgAdapter.GetInstance()
	let lay_mgr = LayerManager.GetInstance()
	let local_g_event = GlobalEventSystem
	let local_event = EventName
	let local_layer = Enum_UILayer
	this.InitInfo = () => {
		let On40901 = () => {
			let scmd = UMSG.GetSCMD(40901)
			model.curAcStage = scmd.new_cur_stage
			model.rewardList = scmd.reward_list
			model.CheckReddot(false)
			model.Fire(local_achvModel.U_AC_V)
		}
		
		let On40902 = () => {
			let scmd = UMSG.GetSCMD(40902)
			if (scmd.resoult == 1 ) {
				this.SendFmtToGame(40901)
				this.SendFmtToGame(40906)
				model.Fire(local_achvModel.U_AC_LV)
			}else{
				Util.ErrorCodeShow(scmd.errcode)
			}
		}
		
		let On40903 = () => {
			let scmd = UMSG.GetSCMD(40903)
			model.SetAchvDataList(scmd.list)
		}
		
		let On40904 = () => {
			let scmd = UMSG.GetSCMD(40904)
			// model.GetGameConfig("Achievement",(cfgs?) => {
			// 		model.UpdateDataList(scmd.list, cfgs)
			// 		model.DestoryGameConfig("Achievement", false)
			// 	}
			// )
			ResManager.GetInstance().LoadGameConfig(this, "config_achievement",false,undefined,(cfgs)=>{
				model.UpdateDataList(scmd.list, cfgs)
			});

		}
		
		let On40905 = () => {
			let scmd = UMSG.GetSCMD(40905)
			if (scmd.errcode == 1 ) {
				this.SendFmtToGame(40901)
			}else{
				Util.ErrorCodeShow(scmd.errcode)
			}
		}
		
		let On40906 = () => {
			let scmd = UMSG.GetSCMD(40906)
			model.curStarCount = scmd.star
			model.Fire(local_achvModel.U_STAR_COUNT)
		}
		
		let On40907 = () => {
			let scmd = UMSG.GetSCMD(40907)
			model.Fire(local_achvModel.U_AC_V)
		}
		
		let On40908 = () => {
			let scmd = UMSG.GetSCMD(40908)
			model.totalPointList = scmd.list
			model.Fire(local_achvModel.UPDATE_TOTAL_POINT)
		}
		
		let On40909 = () => {
			let scmd = UMSG.GetSCMD(40909)
			// [ts2lua]model.changeList下标访问可能不正确
			model.changeList[scmd.category] = false
			model.UpdateAchv(scmd)
		}
		
		this.RegisterProtocal(40901, On40901)
		this.RegisterProtocal(40902, On40902)
		this.RegisterProtocal(40903, On40903)
		this.RegisterProtocal(40904, On40904)
		this.RegisterProtocal(40905, On40905)
		this.RegisterProtocal(40906, On40906)
		this.RegisterProtocal(40907, On40907)
		this.RegisterProtocal(40908, On40908)
		this.RegisterProtocal(40909, On40909)
		// local_g_event.Bind(local_event.INIT_CONFIG,() => {
		// 		model.InitCfg()
		// 	}
		// )
		model.InitCfg()
		let RequestAchvData = () => {
			this.SendFmtToGame(40901)
			this.SendFmtToGame(40903)
			this.SendFmtToGame(40906)
			this.SendFmtToGame(40908)
		}

		
		model.Bind(local_achvModel.OP_AC_V, RequestAchvData)
		local_g_event.Bind(local_event.GAME_START,() => {
			RequestAchvData()
			model.Reset()
		})
		// let onRequestHandler = (id, fmt, ...new_args) => {
		// 	this.SendFmtToGame(id, fmt, ...new_args)
		// }
		
		//model.Bind(local_achvModel.REQUEST_PROTO, onRequestHandler)
		model.Bind(local_achvModel.REQUEST_PROTO,(id, fmt, ...new_args)=>{
			this.SendFmtToGame(id, fmt, ...new_args)
		})
		model.Bind(local_achvModel.OP_V,(view_name:string, ...new_args) => {
				// [ts2lua]this.view_dic下标访问可能不正确
				let view = this.view_dic[view_name]
				if (! view ) {
					// [ts2lua]this.view_dic下标访问可能不正确
					this.view_dic[view_name] = true
					// [ts2lua]window下标访问可能不正确
					if (! window[view_name] ) {
						// if (! ResManager.GetInstance().IsJsLoad("achv") ) {
							
						// }
					}
					// [ts2lua]this.view_dic下标访问可能不正确
					if (this.view_dic[view_name] == true ) {
						// [ts2lua]window下标访问可能不正确
						let view_class = window[view_name]
						view=new view_class()
						// [ts2lua]this.view_dic下标访问可能不正确
						this.view_dic[view_name] = view
					}
				}
				let parms=new_args
				if (view && view != true ) {
					if ((view.HasOpen() && view_name == "AchvEnterView") && parms ) {
						view.viewList[0].CustomMehod(0, {"0":parms[0], "1":parms[1]})
					}else{
						view.Open(...new_args)
					}
				}
			}
		)
		model.Bind(local_achvModel.SHOW_ITEM,(data?) => {
				if (! window["AchvTipsItem"] ) {

				}

				if (window["AchvTipsItem"] ) {
					let layer = lay_mgr.GetUILayer(local_layer.Activity)
					if (layer) {
						let itemclass = window["AchvTipsItem"]
						let item =  new itemclass(layer)
						item.Load()
						item.ExcuteCallback(() => {
								item.SetData(data)
								item.alpha = 0.25
								SetAnchoredPosition(item.display_obj, LayerManager.GetInstance().stageWidth/2-350,LayerManager.GetInstance().stageHeight-110 )
								let posY = LayerManager.GetInstance().stageHeight-300
								let runAni2, runAni3, deleteFunc
								deleteFunc =() => {
									if (item ) {
										item.DeleteMe()
										item = null
									}
								}
								runAni2 =() => {
									Laya.timer.once(1800,this,()=>{
										if (item ) {
											SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POSY, posY - 100, 0.25, deleteFunc)
										}
									})
								}
								
								SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POSY, posY, 0.35, runAni2)
							}
						)
					}
				}
			}
		)
	
		RoleManager.GetInstance().GetMainRoleVo().BindOne(EventName.CHANGE_LEVEL, (level) => {
			if (level==120) {
				RequestAchvData()
			}
		});
	}
	
	this.InitInfo()
}

}
window["achvController"] = achvController