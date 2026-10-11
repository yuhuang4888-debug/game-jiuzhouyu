import { BaseController } from "../common/BaseController"
import { Util } from "../util/Util"
import { TimeUtil } from "../util/TimeUtil"
import { table } from "../common/table"
import { Message } from "../sysInfo/SysInfoController"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { MainFunc } from "../commonModel/MainUIModel"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"

import "../revelation/RevelationShowView"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"

export class RevelationController extends BaseController {
	model
	goods_model
	user_msg_adapter
	view_dic
	suit_active_dic

	public constructor() {
		super()
		this.model = RevelationModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()

		this.view_dic = []
		this.suit_active_dic = null

		this.InitEvent()
		this.InitInfo()
	}

	private InitEvent() {
		this.model.Bind(RevelationEvent.REQUEST_PROTO, (id, fmt, ...new_args) => {
			this.SendFmtToGame(id, fmt, ...new_args)
		})

		this.model.Bind(RevelationEvent.OPEN_VIEW, (view_name: string, ...new_args) => {
			let view = this.view_dic[view_name]
			if (!view) {
				this.view_dic[view_name] = true
				if (this.view_dic[view_name] == true) {
					let view_class = window[view_name]
					view = new view_class()
					this.view_dic[view_name] = view
				}
			}
			if ((view && view != true) && !view.HasOpen()) {
				view.Open(...new_args)
			}
		})

		this.model.Bind(RevelationEvent.DEVOUR_EQUIP, (posId?, selectList?) => {
			if (!posId || !selectList) {
				return
			}
			let count = 0
			for (let key in selectList) {

				if (selectList[key]) {
					count = count + 1
				}
			}
			if (count == 0) {
				Message.show("请选择要吞噬的物品")
				return
			}
			this.WriteBegin(28603)
			this.WriteFMT("c", posId)
			this.WriteFMT("h", count)
			for (let key in selectList) {
				if (selectList[key]) {
					this.WriteFMT("l", Number(key))
				}
			}
			this.SendToGame()
		})

		this.goods_model.Bind(GoodsModel.CHANGE_REVE_BAG_LIST, () => {
			this.model.CheckEquipRed()
			this.model.CheckDevourRed()
			this.model.CheckSkillRed()
			//this.model:Fire(RevelationEvent.UPDATE_ALL_RED)
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
		})

		this.goods_model.Bind(GoodsModel.CHANGE_REVE_EQUIP_LIST, () => {
			this.model.CheckEquipRed()
			this.model.CheckDevourRed()
			this.model.CheckSkillRed()
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
		})

		GlobalEventSystem.Bind(EventName.GAME_START, () => {
			this.model.equipData = []
			this.suit_active_dic = null
			this.SendFmtToGame(28606)
		})
	}

	private InitInfo() {
		let On28600 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28600)
			Util.ErrorCodeShow(scmd.res)
		}

		let On28601 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28601)
			if (scmd.res == 1) {
				this.SendFmtToGame(28606)
			} else {
				Util.ErrorCodeShow(scmd.res)
			}
		}

		let On28602 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28602)
			if (scmd.res == 1) {
				this.SendFmtToGame(28606)
			} else {
				Util.ErrorCodeShow(scmd.res)
			}
		}

		let On28603 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28603)
			if (this.model.equipData) {
				for (let _tmpi in this.model.equipData.gathering) {
					var vo = this.model.equipData.gathering[_tmpi]
					if (vo.pos == scmd.pos) {
						vo.lv = scmd.lv
						vo.exp = scmd.exp
					}
				}
			}
			Message.show("吞噬成功")
			this.model.CheckDevourRed()
			this.model.CheckSkillRed()
		}

		let On28604 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28604)
			if (this.model.equipData) {
				for (let _tmpi in this.model.equipData.gathering) {
					var vo = this.model.equipData.gathering[_tmpi]
					if (vo.pos == scmd.pos) {
						vo.lv = scmd.lv
						vo.exp = scmd.exp
					}
				}
			}
			this.SendFmtToGame(28606)
			this.model.Fire(RevelationEvent.EQUIP_LV_UP_SUCCESS, scmd)
		}

		let On28605 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28605)
			this.SendFmtToGame(28606)
			this.model.Fire(RevelationEvent.SKILL_LV_UP, scmd)
		}

		let On28606 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28606)
			let not_show_new
			if (this.model.equipData.max_figure_id != null && scmd.max_figure_id > this.model.equipData.max_figure_id) {
				not_show_new = true

				let data = {
					_type: 286,
					id: scmd.max_figure_id,
				/* 	cb: () => {
						babyModel.Fire(local_BabyEvent.REQUEST_PROTO, 18214, "ci", 1, scmd.baby_id)
					} */
				}
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)

				// this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationShowView", scmd.max_figure_id)
			}

			if (!this.suit_active_dic) {
				this.suit_active_dic = []
				for (let _tmpi in scmd.suit) {
					var vo = scmd.suit[_tmpi]
					this.suit_active_dic[vo.num] = { star: vo.star, num: vo.num, time: 0 }
				}
			} else {
				let oldSuit = this.model.equipData.suit
				let newList = []
				for (let _tmpi in scmd.suit) {
					var vo = scmd.suit[_tmpi]
					let find = false
					for (let _tmpi in oldSuit) {
						var oldVo = oldSuit[_tmpi]
						if (vo.num == oldVo.num) {
							if (vo.star > oldVo.star) {
								table.insert(newList, vo)
							}
							find = true
							break
						}
					}
					if (!find) {
						table.insert(newList, vo)
					}
				}
				table.sort(newList, (a?, b?) => {
					return b.star < a.star
				})
				let showView = false
				for (let _tmpi in newList) {
					var vo = newList[_tmpi]
					if (!showView && (!this.suit_active_dic[vo.num] || this.suit_active_dic[vo.num].time < TimeUtil.getServerTime())) {
						if (!not_show_new) {
							this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationActiveView", vo)
						}
						showView = true
						this.suit_active_dic[vo.num] = { star: vo.star, num: vo.num, time: TimeUtil.getServerTime() + 60 }
					} else {
						let oldVo = this.suit_active_dic[vo.num]
						this.suit_active_dic[vo.num] = { star: vo.star, num: vo.num, time: (oldVo && oldVo.time || 0) }
					}
				}
			}
			this.model.equipData = scmd
			let devourLv = 0
			for (let _tmpi in scmd.gathering) {
				var vo = scmd.gathering[_tmpi]
				if (!vo.flag) {
					devourLv = 0
					break
				} else if (!devourLv || vo.lv > devourLv) {
					devourLv = vo.lv
				}
			}
			this.model.equipData.devourLv = devourLv
			this.model.CheckEquipRed()
			this.model.CheckDevourRed()
			this.model.CheckSkillRed()
			GlobalEventSystem.Fire(EventName.REFRESH_FUNCTION_ICON_RED_DOT, MainFunc.Bag)
			this.model.Fire(RevelationEvent.UPDATE_EQUIP_DATA)
		}

		let On28607 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28607)
			if (this.model.equipData) {
				this.model.equipData.max_figure_id = scmd.max_figure_id
				this.model.equipData.current_figure_id = scmd.current_figure_id
				this.model.Fire(RevelationEvent.UPDATE_FIGURE_ID, scmd)
			}
		}

		let On28608 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28608)
			if (this.model.equipData) {
				this.model.equipData.suit = scmd.suit
				this.model.Fire(RevelationEvent.UPDATE_SUIT_DATA, scmd)
			}
		}

		let On28609 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(28609)
			if (this.model.equipData) {
				this.model.equipData.power = scmd.power
				this.model.Fire(RevelationEvent.UPDATE_POWER, scmd)
			}
		}

		this.RegisterProtocal(28600, On28600)
		this.RegisterProtocal(28601, On28601)
		this.RegisterProtocal(28602, On28602)
		this.RegisterProtocal(28603, On28603)
		this.RegisterProtocal(28604, On28604)
		this.RegisterProtocal(28605, On28605)
		this.RegisterProtocal(28606, On28606)
		this.RegisterProtocal(28607, On28607)
		this.RegisterProtocal(28608, On28608)
		this.RegisterProtocal(28609, On28609)
	}
}

window["RevelationController"] = RevelationController