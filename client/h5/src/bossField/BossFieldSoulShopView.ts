import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel, ShopType } from "../commonModel/ShopModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class BossFieldSoulShopView extends BaseView1 {


	model:ShopModel
	loop_mgr
	timer_id
	public constructor() {
		super()

		this.base_file = "bossField"
		this.layout_file = "BossFieldSoulShopView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.not_show_item_use = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.model = ShopModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		this.CancelTimer()
	}

	public InitEvent() {

		let update_shop_data = () => {
			this.UpdateView()
		}
		this.BindEvent(this.model, ShopEvent.UPDATE_SHOP_ONE_DATA, update_shop_data)

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_SPECIAL_SCORE, (vo?) => {
			if (vo.currency_id == 36240001) {
				let money_num = vo.num
				this._lb_goods_num.text = String(money_num)
			}
		})

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._img_add, () => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BossFieldSoulShopAlert")
		}, this, true)

		Util.AddClickEvent(this._img_question, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.SoulOfWar)
		}, this, true)
		
		this.BindEvent(GlobalEventSystem, GoodsModel.USE_BAG_GOODS_SUCCESS, (type_id?) => {
			if (type_id != 37110001) {
				return
			}
			this.SetBuffTime()

		}
		)
	}
	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("bossField", "ui_chief_12"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg2, GameResPath.GetIcon("bossField", "ui_chief_16"))
		this.UpdateView()
		this.SetBuffTime()
	}
	public UpdateView() {
		let view_class = window["BossFieldSoulShopItem"]
		if(!view_class) return
		let shop_data = this.model.GetShopDataByType(ShopType.SoulOfWar)
		if (!shop_data || Util.TableSize(shop_data) <= 0) { return }
		for (let _ in shop_data) {
			var v = shop_data[_]
			v.can_buy = 1
			if (v.sold_out >= v.quota_num) {
				v.can_buy = 0
			}
		}
		table.sort(shop_data, (a?, b?) => {
			if (a.can_buy == b.can_buy) {
				return a.rank < b.rank
			} else {
				return a.can_buy > b.can_buy
			}
		})
		let info = []
		let sub_info = []
		let index
		for (let i = 0; i < shop_data.length; i++) {
			let data = shop_data[i]
			table.insert(sub_info, data)
			index = i + 1
			if ( ( index % 3 == 0) || index == shop_data.length) {
				table.insert(info, sub_info)
				sub_info = []
			}
		}
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
			this.loop_mgr.SetData(this._list_item, view_class, info, LoopScrCon.Vertical)
		} else {
			this.loop_mgr.replaceAll(info)
		}


		this._lb_goods_num.text = GoodsModel.GetInstance().GetSpecialScore(36240001)
	}

	public SetBuffTime() {

		let goods_buff_list = GoodsModel.GetInstance().goods_buff_list
		let buff_data = null
		for (let _ in goods_buff_list) {
			var v = goods_buff_list[_]
			if (v.goods_id == 37110001) {
				buff_data = v
			}
		}
		if (!buff_data) {
			this._lb_time.text = "无双倍时间"
			return
		}
		if (this.timer_id) {
			this.CancelTimer()
		}
		if (!this.timer_id) {
			buff_data.end_time = TimeUtil.getServerTime() + buff_data.time
			this.timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
				if (buff_data.end_time && buff_data.end_time >= TimeUtil.getServerTime()) {
					this._lb_time.text = (TimeUtil.convertTimeColor(buff_data.end_time - TimeUtil.getServerTime()))
				} else {
					this.CancelTimer()
					this._lb_time.text = "无双倍时间"
				}
			}, 0.5)
			this._lb_time.text = (TimeUtil.convertTimeColor(buff_data.end_time - TimeUtil.getServerTime()))
		}
	}

	public CancelTimer() {
		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
		}
		this.timer_id = null
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_close: Laya.Image
	_list_item: Laya.List
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_question: Laya.Image
	_img_icon: Laya.Image
	_lb_title: Laya.Label
	_lb_time: Laya.Label
	_lb_goods_num: Laya.Label
	_img_add: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_close,
			this._list_item,
			this._img_bg3,
			this._img_bg4,
			this._img_question,
			this._img_icon,
			this._lb_title,
			this._lb_time,
			this._lb_goods_num,
			this._img_add,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_close",
				"_list_item",
				"_img_bg3",
				"_img_bg4",
				"_img_question",
				"_img_icon",
				"_lb_title",
				"_lb_time",
				"_lb_goods_num",
				"_img_add",
			])
	}
}
window["BossFieldSoulShopView"] = BossFieldSoulShopView