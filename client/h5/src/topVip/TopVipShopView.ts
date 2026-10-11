import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TopVipModel, TopVipEvent, TopVipShopType, TopVipMoneyId } from "../commonModel/TopVipModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, SetAnchoredPositionX, Util } from "../util/Util"
import { TopVipRodItem } from "./TopVipRodItem"

export class TopVipShopView extends BaseItem1 {
	_img_bg: Laya.Image
	_Group1: Laya.Box
	target_img: Laya.Image
	target_lb: Laya.HTMLDivElement
	_Group2: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Group3: Laya.Box
	_Image2: Laya.Image
	_Label2: Laya.Label
	_Scroller1: Laya.List
	_Group4: Laya.HBox
	_Image3: Laya.Image
	_Image4: Laya.Image
	money_num_lb: Laya.Label
	_lb_timer: Laya.Label
	CleanCreateItemVo
	DeleteFlyGroup
	IconFly
	InitEvent
	LoadSuccess
	LocalDeleteMe
	Scr_Scroller1
	UpdateView
	item_gp
	loop_mgr
	SetTime
	time_id_
	time_func_


	public constructor(parent?) {
		super(parent)


		let model = TopVipModel.GetInstance()
		let local_Math = Math
		let local_TopVipEvent = TopVipEvent
		let item_list_ = null
		let icon_fly_group_ = []
		this.base_file = "topVip"
		this.layout_file = "TopVipShopView"
		this.layer_value = Enum_UILayer.UI
		this.load_callback = () => {

			// this.RegisterMask(this.item_gp)
			this.LoadSuccess()
			this.InitEvent()
			this.SetTime()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this.target_lb.size  = 16
			// 	SetAnchoredPositionX(this.target_lb,266)
			// }
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this, this.target_img, "resource/game/topVip/texture/uizzsd_003.png", null, this, true)
			this.target_lb.innerHTML = Util.StrToHTML("每日<font color='#c6ff00'>0点</font>重置特权任务、至尊币和商店商品购买次数")
		}

		this.UpdateView = () => {
			this.CleanCreateItemVo()
			let goods_list = model.GetSupremeVipShopGoodsList()
			let item_ac = []
			let goods_list_length = goods_list.length + 1
			let rod_num = local_Math.ceil(goods_list_length / 3)
			let last_item_num = null
			let rot_num_down = local_Math.floor(goods_list_length / 3)
			let item_list = []
			if (rot_num_down == rod_num) {
				let index = 1
				let pos = goods_list.length - 1
				let i = 0
				do {
					let item_arr = []
					let j = 0
					do {
						// [ts2lua]goods_list下标访问可能不正确
						let goods_vo = goods_list[pos] && goods_list[pos] || 0
						table.insert(item_arr, goods_vo)
						index = index + 1
						pos = pos - 1
						j = j + 1
					} while ((j < 3))
					table.insert(item_ac, item_arr)
					i = i + 1
				} while ((i < rod_num))
			} else {
				last_item_num = goods_list_length - rot_num_down * 3
				let item_num = null
				let index = 1
				let pos = goods_list.length - 1
				let i = 0
				do {
					let item_arr = []
					if (index <= rot_num_down * 3 && rot_num_down != 0) {
						item_num = 3
					} else {
						item_num = last_item_num
					}
					let j = 0
					do {
						// [ts2lua]goods_list下标访问可能不正确
						// [ts2lua]lua中0和空字符串也是true，此处pos - 1 >= 0需要确认
						let goods_vo = pos >= 0 && goods_list[pos] || 0
						table.insert(item_arr, goods_vo)
						index = index + 1
						pos = pos - 1
						j = j + 1
					} while ((j < item_num))
					table.insert(item_ac, item_arr)
					i = i + 1
				} while ((i < rod_num))
			}
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller1, TopVipRodItem, item_ac, LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(item_ac)
			}
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_TopVipEvent.UPDATE_TOP_VIP_SHOP_VIEW, () => {
				this.UpdateView()
			}
			)
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
				if (vo.currency_id == TopVipMoneyId) {
					let money_num = vo.num
					if(money_num == 0){
						this._lb_timer.visible = false
					}
					this.money_num_lb.text = String(money_num) + "  "
				}
			}
			)
			this.BindEvent(model, local_TopVipEvent.BUY_SUCCESS, (local_pos?, goods_id?) => {
				if (goods_id && local_pos) {
					this.IconFly(goods_id, local_pos)
					model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 15301, "c", TopVipShopType)
				}
			}
			)
			model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 15301, "c", TopVipShopType)
		}

		this.IconFly = (type_id?, pos?) => {
			if (type_id && pos) {
				// let list = [[ 0, type_id, 1]]
				// GlobalEventSystem.Fire(EventName.REWARD_FLY, list, pos, null, null, -40, 300, 700)

				//let group = eui. new Group()
				//// [ts2lua]icon_fly_group_下标访问可能不正确
				//icon_fly_group_[group.hashCode] = group
				//this:addChild(group)
				//group.height = 119
				//group.width = group.height
				//group.touchEnabled = false
				//let local_star = this.globalToLocal(pos.x, pos.y)
				//group.x = local_star.x
				//group.y = local_star.y
				//let award =  new BaseAwardItem(group)
				//award:Load()
				//award:SetData(type_id, null, null, null, null, true)
				//award:SetShowTips(false)
				//award:SetItemSize(119, 119)
				//award:SetItembgVisible(false)
				//let delayFunc = () => {
				//if (award ) {
				//award:DeleteMe()
				//award = null
				//}
				//this:removeChild(group)
				//// [ts2lua]icon_fly_group_下标访问可能不正确
				//icon_fly_group_[group.hashCode] = null
				//}

				//Laya.Tween.get(group):to({alpha=0.5}):to({y=group.y - 40, alpha=1}, 300):to({x=120, y=LayerManager:GetInstance().stageHeight - 69, scaleX=0.8, scaleY=0.8, alpha=0.8}, 700, Laya.Ease.cubicIn).call(delayFunc)
			}
		}

		this.DeleteFlyGroup = () => {
			//let group = null
			//let item = null
			//for (let key in icon_fly_group_) {

			//// [ts2lua]icon_fly_group_下标访问可能不正确
			//group = icon_fly_group_[key]
			//if (group && group.parent ) {
			//item = group.getChildAt(0)
			//if (item ) {
			//item:DeleteMe()
			//item = null
			//}
			//this:removeChild(group)
			//Laya.Tween.removeTweens(group)
			//// [ts2lua]icon_fly_group_下标访问可能不正确
			//icon_fly_group_[key] = null
			//}
			//}
		}

		this.SetTime = () => {
			this.StartCountTime(() => {
				let time = 3600 * 24 - TimeUtil.timeHMS(TimeUtil.getServerTime() * 1000)
				if (time < 0) {
					this.CancelCountTime()
					return
				}
				this._lb_timer.text = "(有效时间：" + TimeUtil.timeConvert(time, "hh-mm-ss2") + ")"
			}
				, 1)
		}

		this.StartCountTime = (func?, time?) => {
			this.CancelCountTime()
			this.time_func_ = func
			this.time_id_ = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}
		this.CancelCountTime = () => {
			if (this.time_id_) {
				GlobalTimerQuest.CancelQuest(this.time_id_)
				this.time_func_ = null
				this.time_id_ = null
			}
		}

		this.LocalDeleteMe = () => {
			this.CleanCreateItemVo()
			this.DeleteFlyGroup()
			this.CancelCountTime()
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.CleanCreateItemVo = () => {
			model.CleanSupremeVipCreateShopItemNum()
			model.CleanShopItemGoodsIdByKeyList()
		}


	}
	StartCountTime(arg0: () => void, arg1: number) {
		throw new Error("Method not implemented.")
	}
	CancelCountTime() {
		throw new Error("Method not implemented.")
	}


	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._Group1,
			this.target_img,
			this.target_lb,
			this._Group2,
			this._Image1,
			this._Label1,
			this._Group3,
			this._Image2,
			this._Label2,
			this._Scroller1,
			this._Group4,
			this._Image3,
			this._Image4,
			this.money_num_lb,
			this._lb_timer
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Group1",
				"target_img",
				"target_lb",
				"_Group2",
				"_Image1",
				"_Label1",
				"_Group3",
				"_Image2",
				"_Label2",
				"_Scroller1",
				"_Group4",
				"_Image3",
				"_Image4",
				"money_num_lb",
				"_lb_timer"
			])
		this.target_lb.style.fontSize = 18
		this.target_lb.style.color = "#fffff8"
		this.target_lb.style.wordWrap = false
		this.target_lb.style.bold = true
		this._Scroller1.scrollBar.visible = false
	}
}
window["TopVipShopView"] = TopVipShopView