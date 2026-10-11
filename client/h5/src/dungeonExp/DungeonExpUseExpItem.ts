import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { StoryModel } from "../commonModel/StoryModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { DungeonExpFightSceneItem } from "./DungeonExpFightSceneItem"
import { DungeonExpUseExpView } from "./DungeonExpUseExpView"

export class DungeonExpUseExpItem extends BaseItem1 {

	dungeon_model: BaseDungeonModel
	goods_model: GoodsModel
	story_model: StoryModel
	res_mgr: ResManager

	need_refresh_data
	type_id
	guide_state
	award_item: BaseAwardItem
	goods_count
	vo
	time_id

	public constructor(parent?) {
		super(parent)


		this.base_file = "dungeonExp"
		this.layout_file = "DungeonExpUseExpItem"

		this.dungeon_model = BaseDungeonModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.story_model = StoryModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			// if (PlatformManager.IsEyouIdnPlatform()) {
			// 	this._lb_exp_name.size = 20
			// }
		}

	}

	InitEvent() {

		Util.AddClickEvent(this._box_use, () => {
			//this.dungeon_model.Fire(BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, DungeonExpFightSceneItem.GUIDE_STATE.DONE)
			if (this.goods_count && this.goods_count > 0) {
				let use_exp = () => {
					let goods_id = this.goods_model.GetOneGoodsByTypeId(this.type_id)
					this.goods_model.Fire(GoodsModel.USE_BAG_GOODS, goods_id, 1)
					if (this.story_model.GetFinger(this, this._box_use)) {
						GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_use)
					}
				}

				let type_id = null
				for (let _tmpi in this.goods_model.goods_buff_list) {
					var v = this.goods_model.goods_buff_list[_tmpi]
					for (let _tmpi in DungeonExpUseExpView.goods_list) {
						var goods_id = DungeonExpUseExpView.goods_list[_tmpi]
						if (v.time > 0 && v.goods_id == goods_id) {
							type_id = v.goods_id
							break
						}
					}
				}
				if (type_id) {
					// if (type_id < this.type_id) {
					// 	Alert.Show("存在一个较弱的经验加成效果,是否覆盖?", Alert_Type.Two, use_exp)
					// } else if (type_id > this.type_id) {
					// 	Message.show("身上已存在更强的BUFF发挥着效果")
					// } else {
					// 	use_exp()
					// }
					let state = this.goods_model.HaveHightExpBuff(type_id, this.type_id)
					if (state == 2) {
						Alert.Show("当前已存在更高级的经验符,低级经验符将会在高级经验符持续时间过期再生效。<br>是否继续使用？", Alert_Type.Two, use_exp)
					} else if (state == 1){
						use_exp()
						Alert.Show("已使用更高效经验符。<br>低级经验符将会高级经验符持续时间过期再生效", Alert_Type.One)
					} else {
						use_exp()
					}
				} else {
					use_exp()
				}
			} else {
				if (this.type_id == 37020001) {
					//Message.show("商城暂未移植")
					ShopModel.GetInstance().Fire(ShopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: this.type_id })
				} else {
					MaterialsTool.GetInstance().materialsTips(this.type_id)
				}
			}
		}, this, true)

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			if (!this.vo) {
				return
			}
			for (let _tmpi in goods_list) {
				var info = goods_list[_tmpi]
				if (this.vo.type_id == info.type_id) {
					this.UpdateItem()
					break
				}
			}
		})

		this.BindEvent(this.dungeon_model, BaseDungeonModel.EXP_GUIDE_STATE_CHANGE, (state?) => {
			if (state == DungeonExpFightSceneItem.GUIDE_STATE.DONE && this.guide_state == DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP) {
				if (this.story_model.GetFinger(this, this._box_use)) {
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_use)
				}
				this.guide_state = false
			}
		})

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_BUFF_DATA, () => {
			this.UpdateGoodsType()
		})

	}

	LoadSuccess() {
		this.InitEvent()
		if (this.need_refresh_data) {
			this.UpdateItem()
		}
	}

	SetDate(type_id?, guide_state?) {
		this.type_id = type_id
		this.guide_state = guide_state
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	UpdateItem() {
		let goods_vo = this.goods_model.GetGoodsBasicByTypeId(this.type_id)
		this.tip.visible = this.type_id == 37020002
		if (goods_vo) {
			this.vo = goods_vo
			let goods_count = this.goods_model.GetTypeGoodsNum(this.type_id)
			this.goods_count = goods_count
			if (!this.award_item) {
				this.award_item = new BaseAwardItem(this._box_award)
				this.award_item.SetItemSize(85, 85)
				this.award_item.Load()

			}
			this.award_item.SetData(goods_vo.type_id, goods_count)
			this._lb_exp_name.text = goods_vo.goods_name
		}
		if (this.goods_count > 0) {
			this._box_use.visible = true
			this._lb_use.text = "使用"
			this._lb_use.strokeColor = "#c95b37"
			this.res_mgr.SetImageSprite(this, this._img_use, "common", "uian_010b")
			//this._lb_use.strokeColor = "#cc7652"
		} else {
			let bool = false
			for (let _tmpi in DungeonExpUseExpView.show_get_url_list) {
				var goods_id = DungeonExpUseExpView.show_get_url_list[_tmpi]
				if (goods_id == this.type_id) {
					bool = true
					break
				}
			}
			this._box_use.visible = bool
			if (bool) {
				// if (PlatformManager.IsEyouKrPlatform()) {
				// 	this._lb_use.text = "획득"
				// } else {
				this._lb_use.text = "获取"
				this._lb_use.strokeColor = "#3e9298"
				// }
				this.res_mgr.SetImageSprite(this, this._img_use, "common", "uian_0120b")
				//this._lb_use.strokeColor = "#6ca52d"
			}
		}
		this.UpdateGoodsType()
		if (this.guide_state == DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP) {
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._box_use, this.layer_value, false, false, false, true, { text: "来一张试试!", direction: 6, "effect_scaleX": 0.65, "effect_scaleY": 0.9.toExponential, "off_x": 30, "off_y": -8 }, true)
		}
		// let finger = this.story_model.GetFinger(this, this._box_use)
		// if (finger) {
		// 	finger.SetCoverMode()
		// }
	}

	UpdateGoodsType() {
		let data = null
		for (let _tmpi in this.goods_model.goods_buff_list) {
			var v = this.goods_model.goods_buff_list[_tmpi]
			for (let _tmpi in DungeonExpUseExpView.goods_list) {
				var buff_id = DungeonExpUseExpView.goods_list[_tmpi]
				if (v.time > 0 && buff_id == v.goods_id) {
					data = { type_id: v.goods_id, time: v.time }
					break
				}
			}
		}
		if (data) {
			if (data.type_id == this.type_id) {
				let end_time = data.time + TimeUtil.getServerTime()
				this.CancelTime()
				let OnTime = () => {
					let left_time = end_time - TimeUtil.getServerTime()
					if (left_time < 0) {
						this.CancelTime()
						this._lb_use_tips.visible = false
						this._lb_count_down.visible = false
					}
					let tips = TimeUtil.timeConvert(left_time, "hh:MM:ss") //left_time >= 60 * 60 && TimeUtil.timeConvert(left_time) ||
					this._lb_count_down.text = "持续时间：" + tips
					if(this.task_model.MainTaskIsExpDungeonTaskType()&&this.guide_state==DungeonExpFightSceneItem.GUIDE_STATE.USE_EXP){
						//指引完成
						GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "DungeonExpUseExpView")
					}
				}
				this.time_id = GlobalTimerQuest.AddPeriodQuest(OnTime, 1)
				OnTime()
			}
			this._lb_count_down.visible = data.type_id == this.type_id
			this._lb_use_tips.visible = data.type_id == this.type_id
		} else {
			this._lb_count_down.visible = false
			this._lb_use_tips.visible = false
			this.CancelTime()
		}
	}

	CancelTime() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
		}
	}

	public DeleteMe() {
		if (this.award_item) {
			this.award_item.DeleteMe()
		}
		GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._box_use)
		this.award_item = null
		this.CancelTime()
		super.DeleteMe()
	}
	_img_bg: Laya.Image
	_lb_exp_name: Laya.Label
	_lb_use_tips: Laya.Label
	_lb_count_down: Laya.Label
	_box_award: Laya.Box
	_box_use: Laya.Box
	_img_use: Laya.Image
	_lb_use: Laya.Label
	tip: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._lb_exp_name,
			this._lb_use_tips,
			this._lb_count_down,
			this._box_award,
			this._box_use,
			this._img_use,
			this._lb_use,
			this.tip
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_exp_name",
				"_lb_use_tips",
				"_lb_count_down",
				"_box_award",
				"_box_use",
				"_img_use",
				"_lb_use",
				"tip"
			])
	}
}
window["DungeonExpUseExpItem"] = DungeonExpUseExpItem