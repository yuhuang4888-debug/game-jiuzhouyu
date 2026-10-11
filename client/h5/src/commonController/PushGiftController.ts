
//require("game.proto.191.Require191")
//require("game.pushGift.PushGiftModel")
//require("game.pushGift.PushGiftTips")
//require("game.pushGift.PushGiftEntView")
//require("game.pushGift.PushGiftView")
//require("game.pushGift.PushGiftItem")

import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { PushGiftModel } from "../commonModel/PushGiftModel"
import { ActivityIconManager } from "../commonModel/ActivityIconManager"
import "../pushGift/PushGiftEntView"
import "../pushGift/PushGiftTips"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { ViewGiftPopModel, ViewGiftPopModelEvent } from "../commonModel/ViewGiftPopModel"

export class PushGiftController extends BaseController {
	model: PushGiftModel;
	view_dic


	public constructor() {
		super()

		this.model = PushGiftModel.GetInstance()
		this.view_dic = []
		this.InitEvent()
	}

public InitEvent(){ 
	
	let local_GlobalEventSystem = GlobalEventSystem
	let local_EventName = EventName
	let local_PushGiftModel = PushGiftModel
	let user_msg_adapter = UserMsgAdapter.GetInstance()
	let activity_icon_mgr = ActivityIconManager.GetInstance()

		local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
			ViewGiftPopModel.GetInstance().ClearGifts();
			this.SendFmtToGame(19104)
			this.SendFmtToGame(19101)
		}
	)

	local_GlobalEventSystem.Bind(local_EventName.CHANGE_ROLE,() => {
			this.model.ReSetModel()	//切换角色
		})

	local_GlobalEventSystem.Bind(local_EventName.CHANGE_ACCOUNT,() => {
			this.model.ReSetModel()	//切换账号
		})

	this.model.Bind(local_PushGiftModel.SCMD_REQUEST,(cmd, ...new_args) => {
			let args = new_args
			if (cmd == 19101 ) {
				this.SendFmtToGame(cmd)
			} else if (cmd == 19102 ) {
				this.SendFmtToGame(cmd, "hh", args[0], args[1])
			} else if (cmd == 19103 ) {
				this.SendFmtToGame(cmd, "hhh", args[0], args[1], args[2])
			}
		})

	this.model.Bind(local_PushGiftModel.OPEN_VIEW,(view_name:string, ...new_args) => {
			let parms = new_args
			let view = this.view_dic[view_name]
			if (view == null && window[view_name] ) {
				let view_class=window[view_name]
				view = new view_class()
				this.view_dic[view_name] = view
			}
			if (view ) {
				if (! view.HasOpen() ) {
					if (view_name == "PushGiftEntView" ) {
						view.SetActInfo(parms[0], parms[1])
					} else if (view_name == "PushGiftTips" ) {
						view.SetData(parms[0], parms[1])
					}
					view.Open()
				}
			}

		})
		ViewGiftPopModel.GetInstance().Bind(ViewGiftPopModelEvent.NEXT_OPEN_TIPS, () => {
			ViewGiftPopModel.GetInstance().NextPop();
		});

	let On19101 = () => {
		let scmd = user_msg_adapter.GetSCMD(19101)
		let icon = activity_icon_mgr.getIconInfo(191)

		if (! scmd.gift_list || scmd.gift_list.length == 0 ) {
			if(this.model.IsGiftListEmpty()){//判断当前礼包是否为空
				return 
			}
			if (icon ) {
				activity_icon_mgr.deleteIcon(191)
			}
			return
		}

			//添加礼包数据（里面包含剔除超时礼包逻辑
			this.model.SetGiftList(scmd.gift_list)
			//还有礼包可购买，加图标
			let list = this.model.GetGiftList()
			this.model.Fire(local_PushGiftModel.UPDATE_ICON);
			if (!Util.IsTableEmpty(list)) {
				//开启 检测礼包结束 倒计时
				this.model.StartGiftTime()
				//if (! icon ) {
				//activity_icon_mgr:addIcon(191, this.model.next_end_time)
				//}

				if (scmd.type == 1) {
					//当前全部礼包
					ViewGiftPopModel.GetInstance().SetGifts(scmd.gift_list);
				} else if (scmd.type == 2) {
					//新加的礼包
					let new_gift_id = null
					let new_sub_id = null
					ViewGiftPopModel.GetInstance().SetGifts(scmd.gift_list);
					/* for (let i = 0; i < scmd.gift_list.length; i++) {
						var vo = scmd.gift_list[i]
						this.model.Fire(PushGiftModel.SCMD_REQUEST, 19102, vo.gift_id, vo.sub_id)

						let cond = vo.infos
						if (typeof (cond) == "string") {
							cond = ErlangParser.GetInstance().Parse(cond)
						}
						////这里cond的下标修改了
						if (cond[0][0] == "trigger") {
							if (local_PushGiftModel.Special_Trigger[cond[0][1]]) {
								this.model.SetDelayTips(vo.gift_id, vo.sub_id)
							} else {
								new_gift_id = vo.gift_id
								new_sub_id = vo.sub_id
							}
						}
					}

					if (new_gift_id && new_sub_id) {
						let time_out_id0 = setTimeout(() => {
							clearTimeout(time_out_id0)
							// this.model.Fire(local_PushGiftModel.OPEN_VIEW, "PushGiftTips", new_gift_id, new_sub_id)
							ViewPopLevelModel.GetInstance().SetView('PushGiftTips', new_gift_id, new_sub_id);
						}, 0.5)
					} */

				} else if (scmd.type == 3) {
					//离线过期的(服务端登陆后推送)
					/* 	for (let i = 0; i < scmd.gift_list.length; i++) {
							var vo = scmd.gift_list[i]
							this.model.Fire(PushGiftModel.SCMD_REQUEST, 19102, vo.gift_id, vo.sub_id)
							this.model.logout_gift.gift_id = vo.gift_id
							this.model.logout_gift.sub_id = vo.sub_id
							if (!Util.IsTableEmpty(this.model.logout_gift)) {
								let logout_gift = this.model.logout_gift
								// this.model.Fire(local_PushGiftModel.OPEN_VIEW, "PushGiftTips", logout_gift.gift_id, logout_gift.sub_id)
								ViewPopLevelModel.GetInstance().SetView('PushGiftTips', logout_gift.gift_id, logout_gift.sub_id);
							}
							break
						} */
					ViewGiftPopModel.GetInstance().SetGifts(scmd.gift_list);
				} else if (scmd.type == 4) {
					//立即清理的
					for (let i = 0; i < scmd.gift_list.length; i++) {
						var vo = scmd.gift_list[i]
						this.model.DeleteGiftList(vo.gift_id, vo.sub_id)
						this.model.FindGiftTime()
						this.model.Fire(local_PushGiftModel.UPDATE_VIEW, vo.gift_id, vo.sub_id)
					}

			}
		}

	}

	let On19102 = () => {
		let scmd = user_msg_adapter.GetSCMD(19102)
		this.model.SetGiftData(scmd)
		this.model.Fire(local_PushGiftModel.UPDATE_VIEW, scmd.gift_id, scmd.sub_id)
	}

	let On19103 = () => {
		let scmd = user_msg_adapter.GetSCMD(19103)
		if (scmd.code != 1 ) {
			Util.ErrorCodeShow(scmd.code)
			return
		}

		let result_reward = null
		let is_del_gift = true
		let gift_data = this.model.GetGiftData(scmd.gift_id, scmd.sub_id)
		for (let i in gift_data.reward_list) {
			var v = gift_data.reward_list[i]
			if (v.grade_id == scmd.grade_id ) {
				v.buy_time = 1
				v.buy_cnt = scmd.buy_cnt
				result_reward = v.rewards
			}

			let limit_count = 1
			let cond = v.rewards_conditions
			if (typeof(cond) == "string" ) {
				cond = ErlangParser.GetInstance().Parse(cond)
			}
			for (let _tmpi in cond) {
				var sub_cond = cond[_tmpi]
				if (sub_cond[0] == "buy_cnt" ) {
					limit_count = Number(sub_cond[1])
				}
			}

			//还有档次礼包没有买
			if (v.buy_cnt < limit_count ) {
				is_del_gift = false
			}
		}
		this.model.Fire(local_PushGiftModel.BUY_SUCCESS, scmd.gift_id, scmd.sub_id, result_reward)

		if (is_del_gift ) {
			this.model.will_del_gift[scmd.gift_id]= this.model.will_del_gift[scmd.gift_id] ||{}
			this.model.will_del_gift[scmd.gift_id][scmd.sub_id]= this.model.will_del_gift[scmd.gift_id][scmd.sub_id] ||{}
			this.model.will_del_gift[scmd.gift_id][scmd.sub_id]=1
			// this.model.DeleteGiftList(scmd.gift_id, scmd.sub_id)
			this.model.FindGiftTime()
		}
	}

	this.RegisterProtocal(19101, On19101)	//激活的礼包列表(简略信息，登陆请求，红点处理)
	this.RegisterProtocal(19102, On19102)	//激活的礼包列表(详细信息)
	this.RegisterProtocal(19103, On19103)	//购买礼包
}
}

window["PushGiftController"] = PushGiftController