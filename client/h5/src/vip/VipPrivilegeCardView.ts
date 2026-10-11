import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest } from "../util/Util"
import { VipCardItem } from "./VipCardItem"

export class VipPrivilegeCardView extends BaseItem1 {
	_Group1: Laya.Box
	bg_di: Laya.Image
	card_scroller: Laya.Panel
	Content: Laya.VBox
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	tip_label: Laya.HTMLDivElement
	CancelOverTImer
	CheckVisible
	FindCardCfg
	InitCard
	InitEvent
	LoadSuccess
	OnTimer
	SetOverTime
	SetScrollerPos
	SetSelectIndex
	StartOverTimer
	card_group
	card_list_
	preload_client_config
	preload_server_config
	RefreshCardItem
	card_item


	public constructor(parent?, card_type?) {
		super(parent)

		this.base_file = "vip"
		this.layout_file = "VipPrivilegeCardView"
		this.card_list_ = []
		let card_config_ = null
		let client_vip_config_ = null
		let overTimerId_ = null
		let overTime_ = null
		let default_card_type_ = null
		default_card_type_ = card_type
		let vipM = VipModel
		let local_math = Math
		let vip_model = vipM.GetInstance()
		let local_util = Util
		let local_timeUtil = TimeUtil
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		// this.preload_server_config = [config_vip_card=false]
		// this.preload_client_config = [ClientVipPrivilege=false]
		this.LoadSuccess = () => {
			if(PlatformManager.IsEyouPlatform()){
				this.tip_label.style.wordWrap = true
				this.tip_label.width = 540
				this.tip_label.y = 765
			}
			ResManager.GetInstance().SetTexture(this,this.bg_di,GameResPath.GetIcon("vip","ui_content_bg11"))
			ResManager.GetInstance().LoadGameConfig(this, "config_vip_card", false, null, (cfg_vip) => {
				ResManager.GetInstance().LoadGameConfig(this, "ClientVipPrivilege", true, null, (cfg_vip_privilege) => {
					card_config_ = []
					for (let k in cfg_vip) {
						var v = cfg_vip[k]
						table.insert(card_config_, v)
					}
					table.sort(card_config_, (a?, b?) => {
						return a.vip_type < b.vip_type
					})
					client_vip_config_ = cfg_vip_privilege
					this.SetOverTime()
					if (card_config_ && client_vip_config_) {
						if (default_card_type_) {
							this.InitCard(default_card_type_)
						} else {
							if (vip_model.can_receve_card_list.length > 0) {
								let show_type = null
								for (let _tmpi in vip_model.can_receve_card_list) {
									var vo = vip_model.can_receve_card_list[_tmpi]
									if (vo.time == 1) {
										show_type = vo.use_card
										break
									}
								}
								this.InitCard(show_type)
							} else {
								this.InitCard()
							}
						}
					}
				})

			})

		}

		this.SetSelectIndex = (card_type?) => {
			default_card_type_ = card_type
		}

		this.InitCard = (card_type?) => {
			let default_key = card_config_.length - 1
			this.card_item = new VipCardItem(this.Content)
			this.card_item.Load()
			if (this.card_item) {
				this.card_item.ExcuteCallback(() => {
					this.card_item.SetData(client_vip_config_["card_" + card_config_[default_key].vip_type], card_config_[default_key], client_vip_config_[card_config_[default_key].vip_type], this.FindCardCfg(vip_model.active_card_type))
				})
			}

			// for (let key in card_config_) {
			// 	for (let key = card_config_.length-1; key >= 0; key -= 1) {
			// 		let card = this.card_list_[card_config_[key].vip_type]
			// 		if (!card) {
			// 			// card =  new VipCardItem(this.Content, card_config_[key].vip_type)
			// 			card = new VipCardItem(this.Content, null, null, card_config_[key].vip_type)
			// 			this.card_list_[card_config_[key].vip_type] = card
			// 			card.Load()
			// 		}
			// 		if (card) {
			// 			card.ExcuteCallback(() => {
			// 				// [ts2lua]card_config_下标访问可能不正确
			// 				// [ts2lua]client_vip_config_下标访问可能不正确
			// 				// [ts2lua]card_config_下标访问可能不正确
			// 				// [ts2lua]card_config_下标访问可能不正确
			// 				// [ts2lua]client_vip_config_下标访问可能不正确
			// 				// [ts2lua]card_config_下标访问可能不正确
			// 				card.SetData(client_vip_config_["card_" + card_config_[key].vip_type], card_config_[key], client_vip_config_[card_config_[key].vip_type], this.FindCardCfg(vip_model.active_card_type))
			// 			}
			// 			)
			// 		}
			// 		// this.card_group.setChildIndex(card, 0)
			// 	}
			// 	// if (card_type) {
			// 	// 	// this.card_scroller.validateNow()
			// 	// 	this.SetScrollerPos(card_type)
			// 	// }
			// }
		}

		this.RefreshCardItem = (index?) => {
			if(this.card_item){
				this.card_item.ExcuteCallback(() => {
					this.card_item.SetData(client_vip_config_["card_" + card_config_[index].vip_type], card_config_[index], client_vip_config_[card_config_[index].vip_type], this.FindCardCfg(vip_model.active_card_type))
				})
			}
		}

		this.InitEvent = () => {
			let updata_vipcard_item = (index) => {
				this.RefreshCardItem(index)
            }
            this.BindEvent(vip_model, vipM.UPDATA_VIPCARD_ITEM, updata_vipcard_item)

			let update_func = () => {
				this.CheckVisible()
			}

			// this.card_scroller.addEventListener(Laya.UIEvent.CHANGE, update_func, this)
			this.BindEvent(vip_model, vipM.UPDATE_NOBLE_STATE, () => {
				if (card_config_) {
					for (let key in card_config_) {

						let card = this.card_list_[card_config_[key].vip_type]
						if (card) {
							card.ExcuteCallback(() => {
								// [ts2lua]card_config_下标访问可能不正确
								// [ts2lua]client_vip_config_下标访问可能不正确
								// [ts2lua]card_config_下标访问可能不正确
								// [ts2lua]card_config_下标访问可能不正确
								// [ts2lua]client_vip_config_下标访问可能不正确
								// [ts2lua]card_config_下标访问可能不正确
								card.SetData(client_vip_config_["card_" + card_config_[key].vip_type], card_config_[key], client_vip_config_[card_config_[key].vip_type], this.FindCardCfg(vip_model.active_card_type))
							}
							)
						}
					}
				}
				this.SetOverTime()
			}
			)
			this.BindEvent(vip_model, vipM.UPDATE_VIP_DATA, () => {
				if (card_config_) {
					for (let key in card_config_) {

						let card = this.card_list_[card_config_[key].vip_type]
						if (card) {
							card.ExcuteCallback(() => {
								// [ts2lua]card_config_下标访问可能不正确
								// [ts2lua]client_vip_config_下标访问可能不正确
								// [ts2lua]card_config_下标访问可能不正确
								// [ts2lua]card_config_下标访问可能不正确
								// [ts2lua]client_vip_config_下标访问可能不正确
								// [ts2lua]card_config_下标访问可能不正确
								card.SetData(client_vip_config_["card_" + card_config_[key].vip_type], card_config_[key], client_vip_config_[card_config_[key].vip_type], this.FindCardCfg(vip_model.active_card_type))
							}
							)
						}
					}
				}
			}
			)
		}

		this.CheckVisible = () => {
			// if (this.card_scroller ) {
			// 	let top_y = this.card_scroller.viewport.scrollV
			// 	let bottom_y = this.card_scroller.viewport.scrollV + this.card_scroller.viewport.height
			// 	for (let key in this.card_list_) {

			// 		// [ts2lua]this.card_list_下标访问可能不正确
			// 		let item = this.card_list_[key]
			// 		if (item ) {
			// 			if (top_y > item.y + item.height || bottom_y < item.y ) {
			// 				item.visible = false
			// 			}else{
			// 				item.visible = true
			// 			}
			// 		}
			// 	}
			// }
		}

		this.SetOverTime = () => {
			if(!this.tip_label) return
			if (vip_model.noble_Card_info && vip_model.active_card_type) {
				// [ts2lua]vip_model.noble_Card_info下标访问可能不正确
				let data = vip_model.noble_Card_info[vip_model.active_card_type]
				if (data) {
					if (data.is_forever == 1) {
						this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:永久)</font>")
					} else {
						let vip_second = data.time - local_timeUtil.getServerTime()
						if (vip_second > 0) {
							let D = Math.floor(vip_second / 86400)
							if (D > 1) {
								this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:" + D + "天)</font>")
							} else {
								overTime_ = data.time
								this.StartOverTimer()
							}
						} else {
							this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:" + 0 + "天)</font>")
						}
					}
				}
			} else {
				this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:" + 0 + "天)</font>")
			if(PlatformManager.IsEyouPlatform()){
				this.tip_label.style.width = 540
			}
		}

		this.SetScrollerPos = (card_type?) => {
			let item = this.card_list_[card_type]
			// if (item ) {
			// 	if (this.card_scroller.viewport.contentHeight - this.card_scroller.viewport.height < item.y ) {
			// 		this.card_scroller.viewport.scrollV = this.card_scroller.viewport.contentHeight - this.card_scroller.viewport.height
			// 	}else{
			// 		this.card_scroller.viewport.scrollV = item.y
			// 	}
			// 	this.card_scroller.validateNow()
			// }
		}

		this.StartOverTimer = () => {
			this.CancelOverTImer()
			// overTimerId_ = Laya. new Timer(1000, 0)
			// overTimerId_.addEventListener(Laya.TimerEvent.TIMER, this.OnTimer, this)
			// overTimerId_.start()
			overTimerId_ = GlobalTimerQuest.AddPeriodQuest(() => {
				this.OnTimer()
			}, 1, 0)
			this.OnTimer()
		}

		this.CancelOverTImer = () => {
			if (overTimerId_) {
				// overTimerId_.stop()
				// overTimerId_.removeEventListener(Laya.TimerEvent.TIMER, this.OnTimer, this)
				// overTimerId_ = null
				GlobalTimerQuest.CancelQuest(overTimerId_)
				overTimerId_ = null
			}
		}

		this.OnTimer = () => {
			let time = overTime_ - local_timeUtil.getServerTime()
			if (!this.tip_label) {
				return
			}
			if (time > 0) {
				let h = Math.floor(time / 3600)
				if (h > 1) {
					this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:" + h + "小时)</font>")
				} else {
					let min = Math.floor(time / 60)
					let s = time % 60
					this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:" + min + "分" + s + "秒)</font>")
				}
			} else {
				this.CancelOverTImer()
				this.tip_label.innerHTML = Util.StrToHTML("特权卡有效期会自动叠加,过期自动失效<font color='#ffe222'>(当前有效期:" + 0 + "天)</font>")
			}
			if(PlatformManager.IsEyouPlatform()){
				this.tip_label.style.width = 540
			}
		}

		this.FindCardCfg = (active_card_type?) => {
			for (let i = 0; i < card_config_.length; i++) {
				var v = card_config_[i]
				if (active_card_type == v.vip_type) {
					return v
				}
			}
		}

	}
	}
	public DeleteMe() {

		for (let index in this.card_list_) {

			this.card_list_[index].DeleteMe()
			this.card_list_[index] = null
		}
		this.card_list_ = []

		if (this.card_item) {
			this.card_item.DeleteMe()
			this.card_item = null
		}

		this.CancelOverTImer()
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._Group1,
			this.bg_di,
			this.card_scroller,
			this.Content,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this.tip_label,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"bg_di",
				"card_scroller",
				"Content",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"tip_label",
			])
		this.tip_label.style.fontSize = 18
		// this.tip_label.style.color = "#663915"
		this.tip_label.style.color = "#ffffff"
		this.tip_label.style.wordWrap = false
		this.card_scroller.vScrollBar.visible = false

	}
}
window["VipPrivilegeCardView"] = VipPrivilegeCardView