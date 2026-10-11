import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MondaysAwardModel, MondaysAwardEvent } from "../commonModel/MondaysAwardModel"
import { AdModuleId, WelfareEvent, WelfareModel } from "../commonModel/WelfareModel"
import { PlatformManager } from "../PlatformManager"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, SetSizeDelta, SetSizeDeltaX, SetAnchoredPosition, Util } from "../util/Util"
import { MondaysAwardRecordItem } from "./MondaysAwardRecordItem"
import { MondaysAwardTaskItem } from "./MondaysAwardTaskItem"

export class MondaysAwardView extends BaseItem1 {
	InitEvent
	LoadSuccess
	Local_DeleteMe
	InitAd
	ShowAdIcon
	SwitchBtn
	changeView
	initItem
	initTaskItme
	initTime
	resetRotation
	showRotate
	tween_id
	updateRed



	public constructor(parent?) {
		super(parent)
		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardView"

		let _model:MondaysAwardModel = MondaysAwardModel.GetInstance()
		let local_TimeUtil = TimeUtil
		let local_MondaysAwardEvent = MondaysAwardEvent
		let goods_model = GoodsModel.GetInstance()
		let _running = false
		let _config_rewardId = null
		let _config_kv = null
		let _config_task = null
		let _config_reward = null
		let _item_list = []
		let _itemType = "kfrecord"
		let _skip = false
		let _clickTime = null
		let ad_cfg = null
		this.preload_server_config = {
			"config_monday_bonus": false,
			"config_monday_bonus_kv": false,
			"config_monday_bonus_task": false,
			"config_monday_pool": false
		}

		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
			this.InitAd()
		}

		this.InitAd = () => {
			if (!WelfareModel.GetInstance().GetAdOpenState()) {
				return
			}

			this.BindEvent(WelfareModel.GetInstance(), WelfareEvent.UPDATE_AD_STATE, () => {
				this.initTaskItme()
			})
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn, () => {
				if (_clickTime && local_TimeUtil.getServerTimeMs() - _clickTime < 500) {
					return
				}
				_clickTime = local_TimeUtil.getServerTimeMs()
				// if (!_model.open) {
				// 	Message.show("只能在周一12:00-24:00进行抽奖")
				// 	return
				// }
				if (_running) {
					return
				}
				_model.Fire(local_MondaysAwardEvent.REQUEST_PROTO, 17903)
			}
				, this, false)
			Util.AddClickEvent(this._img_change, () => {
				_model.Fire(local_MondaysAwardEvent.OPEN_VIEW, "MondaysAwardChnageView")
			}
				, this, true)

			Util.AddClickEvent(this._rbtn, () => {
				this._rbtn_check.visible = true
				this._rbtn1_check.visible = false
				if (this._rbtn_check.visible) {
					this._rbtn_label.color = "#9b572f"
				} else {
					this._rbtn_label.color = "#d7d9ed"
				}
				if (this._rbtn1_check.visible) {
					this._rbtn1_label.color = "#9b572f"
				} else {
					this._rbtn1_label.color = "#d7d9ed"
				}
				this.SwitchBtn("kfrecord")
			}, this, false)


			Util.AddClickEvent(this._rbtn1, () => {
				this._rbtn_check.visible = false
				this._rbtn1_check.visible = true
				if (this._rbtn_check.visible) {
					this._rbtn_label.color = "#9b572f"
				} else {
					this._rbtn_label.color = "#d7d9ed"
				}
				if (this._rbtn1_check.visible) {
					this._rbtn1_label.color = "#9b572f"
				} else {
					this._rbtn1_label.color = "#d7d9ed"
				}
				this.SwitchBtn("record")
			}, this, false)

			Util.AddClickEvent(this._Group7, () => {
				_skip = !_skip
				let check_visible = _skip && true || false
				this.check.visible = check_visible
				// ResManager.GetInstance().SetImageSprite(this, this._check_box, "common_asset", img_url)
			}, this, false)

			this.BindEvent(_model, local_MondaysAwardEvent.REWARD_RETURN, (index?) => {
				_running = true
				this.updateRed()
				this.showRotate(index)
				this.initTime()
			}
			)
			this.BindEvent(_model, local_MondaysAwardEvent.TASK_DATA_RETUEN, () => {
				this.initTaskItme()
			}
			)
			this.BindEvent(_model, local_MondaysAwardEvent.RECORD_RETUEN, () => {
				if (_itemType == 'record') {
					this.initItem()
				}
			}
			)
			this.BindEvent(_model, local_MondaysAwardEvent.KF_RECORD_RETUEN, () => {
				if (_itemType == 'kfrecord') {
					this.initItem()
				}
			}
			)

			this.BindEvent(_model, local_MondaysAwardEvent.CHANGE_POOL_REWARD, () => {
				this.changeView(true)
			}
			)

			let UpdateTicketNum = (goods_list?) => {
				if (this.use_delete_method) {
					return
				}
				for (let _tmpi in goods_list) {
					var good = goods_list[_tmpi]
					if (good.type_id == _model.goods_id) {
						this.updateRed()
						break
					}
				}
			}
			this.BindEvent(goods_model, GoodsModel.UPDATE_GOODS_NUM, UpdateTicketNum)

			this.BindEvent(_model, local_MondaysAwardEvent.ACTIVITY_OPEN, () => {
				this.updateRed()
			}
			)
		}

		this.Local_DeleteMe = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			if (_running) {
				_model.showReward()
			}
			_running = false
			_config_rewardId = null
			_config_kv = null
			_config_task = null
			_config_reward = null
			_model.cleanRecord()

			if (_item_list && _item_list.length > 0) {
				for (let i in _item_list) {
					var item = _item_list[i]
					if (item) {
						item.DeleteMe()
					}
				}
				_item_list = []
			}

			if (this._arrayColl) {
				this._arrayColl.DeleteMe()
				this._arrayColl = null
			}

			if (this._taskArrayColl) {
				this._taskArrayColl.DeleteMe()
				this._taskArrayColl = null
			}

		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetIcon("mondaysaward", "uizydj_008"), true)
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_lb, GameResPath.GetIcon("mondaysaward", "uizydj_005"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._bg_left, GameResPath.GetIcon("mondaysaward", "uidjtz_005"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._bg_right, GameResPath.GetIcon("mondaysaward", "uidjtz_005"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_lb2, GameResPath.GetIcon("mondaysaward", "uizydj_005b"))
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if (open_day <= 7) {
				this.group2_label.innerHTML = "开服大奖每天<font color='#55f230'>12:00-24:00</font>开放抽奖"
			} else {
				this.group2_label.innerHTML = "只有在每<font color='#55f230'>周一12:00-24:00</font>才可抽奖"
			}
			_config_rewardId = ResManager.GetInstance().GetGameConfigFromCache(this, "config_monday_bonus", false)
			_config_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_monday_bonus_kv", false)
			_config_task = ResManager.GetInstance().GetGameConfigFromCache(this, "config_monday_bonus_task", false)
			_config_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_monday_pool", false)

			_model.config_reward = _config_reward
			_model.config_reward_Id = _config_rewardId
			_model.config_task = _config_task

			_model.Fire(local_MondaysAwardEvent.REQUEST_PROTO, 17908)
			_model.Fire(local_MondaysAwardEvent.REQUEST_PROTO, 17905)
			_model.Fire(local_MondaysAwardEvent.REQUEST_PROTO, 17902)

			this.updateRed()
			this.initTime()
			this.initTaskItme()
		}

		this.changeView = (refresh?) => {
			let showList = _model.showList(refresh)
			if (showList.length <= 0) {
				return
			}
			let item = null
			let reward = null

			for (let i = 1; i <= 8; i++) {
				let gp = this["_gp_item" + i]
				item = _item_list[i]
				reward = showList[i - 1]
				if (!item) {
					item = new BaseAwardItem(gp)
					_item_list[i] = item
					item.Load()
					item.SetScale(0.75)
				}
				let [type_id, lock] = goods_model.GetMappingTypeId(reward[0], reward[1])
				item.SetData(type_id, reward[2])
			}

		}

		this.resetRotation = () => {
			// this._img_pointer.localRotation = Quaternion.Euler(0,0,0)
		}

		this.showRotate = (index?) => {
			let rotation2 = Util.getRotationLong(8, 0, 6, 10, index, 0)
			rotation2 = rotation2 - 45
			if (_skip) {
				_running = false
				// this._img_pointer.localRotation = Quaternion.Euler(0,0,rotation)
				_model.showReward()
			} else {
				// this.tween_id = SYTweenLite.to(this, this._img_pointer, SYTweenLite.UiAnimationType.ROTATION, 180, 1.3, () => {
				// 	_running = false
				// 	_model.showReward()
				// 	SYTweenLite.Stop(this.tween_id)
				// 	this.tween_id = null
				// }, SYTweenFunc.EASE_IN, false)
				let imgRotation = this._img_pointer.rotation
				this._img_pointer.rotation = imgRotation % 360
				Laya.Tween.to(this._img_pointer, { rotation: rotation2 }, 5000, Laya.Ease.circOut, Laya.Handler.create(this, () => {
					_running = false
					_model.showReward()
				}))
				// Laya.Tween()
			}
		}

		this.initItem = () => {
			let data = []
			if (_itemType == "record") {
				data = _model.getRecordData()
			} else {
				data = _model.getKfRecordData()
			}
			if (!this._arrayColl) {
				this._arrayColl = new LoopScrowViewMgr()
				this._arrayColl.SetData(this._list, MondaysAwardRecordItem, data, LoopScrCon.Vertical, 1)
			} else {
				this._arrayColl.replaceAll(data)
			}
			// this._arrayColl.RestToBeginning()
		}

		this.SwitchBtn = (key?) => {
			_itemType = key
			if (!this._list) {
				return
			}
			this.initItem()
		}

		this.initTaskItme = () => {
			let data = _model.taskList()
			if (!this._taskArrayColl) {
				this._taskArrayColl = new LoopScrowViewMgr()
				this._taskArrayColl.SetData(this._task_list, MondaysAwardTaskItem, data, LoopScrCon.Vertical, 1)
			} else {
				this._taskArrayColl.replaceAll(data)
			}
		}

		this.initTime = () => {
			let cut = Mathf.Floor(_model.draw_times / (_model.round_times + 1))
			let lastCut = Mathf.Floor((_model.draw_times - 1) / (_model.round_times + 1))
			let time = (_model.draw_times - cut) % _model.round_times
			if (_model.draw_times > 0 && time == 0 && cut == lastCut) {
				time = _model.round_times
			}
			time = _model.round_times - time
			let bool = time != 0
			this._img_lb.visible = bool
			this._bm.visible = bool
			this._img_lb2.visible = !bool
			if (bool) {
				if (time == 10) {
					this.tenBox.visible = true
					this._bm.visible = false
				} else {
					this.tenBox.visible = false
					this._bm.visible = true
					this._bm.skin = "resource/game/mondaysaward/texture/ui_luck_sz_" + time + ".png"
				}
			}
		}

		this.updateRed = () => {
			let num = goods_model.GetTypeGoodsNum(_model.goods_id)
			this._lb_num.text = num
			// LayoutRebuilder(this._Group3)
			this._btn_red.visible = num > 0 && _model.open
		}


	}

	public DeleteMe() {
		Laya.Tween.clearAll(this._img_pointer)
		this.Local_DeleteMe()
		super.DeleteMe()
	}



	_Group3
	_Group7
	_Image22
	_Label4
	_arrayColl
	_bg_left
	_bg_right
	_bm
	_btn
	_btn_red
	_check_box
	_gp_item1
	_gp_item2
	_gp_item3
	_gp_item4
	_gp_item5
	_gp_item6
	_gp_item7
	_gp_item8
	_img
	_img_change
	_img_lb
	_img_lb2
	_img_pointer
	_lb_num
	_list
	_rbtn
	_rbtn1
	_rbtn1_check
	_rbtn1_label
	_rbtn_check
	_rbtn_label
	_scroller
	_taskArrayColl
	_task_list
	_task_scroller
	_Group2: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_gp_reward: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_Image12: Laya.Image
	_Group5: Laya.Box
	_Group4: Laya.Box
	_rbtn_bg: Laya.Image
	_rbtn1_bg: Laya.Image
	_Image13: Laya.Image
	_Group6: Laya.Box
	_Image14: Laya.Image
	_Image15: Laya.Image
	_Image16: Laya.Image
	_Image17: Laya.Image
	_Image18: Laya.Image
	_Image19: Laya.Image
	_Image20: Laya.Image
	_Image21: Laya.Image
	check
	group2_label
	tenBox

	public GetComponents() {
		[
			this._img,
			this._Group2,
			this._Image1,
			this._Image2,
			this._Group1,
			this._Image1,
			this._img_lb,
			this._img_lb2,
			this._gp_reward,
			this._gp_item1,
			this._gp_item2,
			this._gp_item3,
			this._gp_item4,
			this._gp_item5,
			this._gp_item6,
			this._gp_item7,
			this._gp_item8,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Image10,
			this._img_pointer,
			this._btn,
			this._Image11,
			this._Image12,
			this._Group3,
			this._Label4,
			this._lb_num,
			this._btn_red,
			this._bg_left,
			this._Group5,
			this._Group4,
			this._rbtn,
			this._rbtn_bg,
			this._rbtn_check,
			this._rbtn_label,
			this._rbtn1,
			this._rbtn1_bg,
			this._rbtn1_check,
			this._rbtn1_label,
			this._Image13,
			this._scroller,
			this._list,
			this._bg_right,
			this._Group6,
			this._Image14,
			this._Image15,
			this._task_scroller,
			this._task_list,
			this._Image16,
			this._Image17,
			this._Image18,
			this._Image19,
			this._Image20,
			this._Image21,
			this._img_change,
			this._Group7,
			this._check_box,
			this._Image22,
			this._bm,
			this._Group1,
			this._Image1,
			this.check,
			this.group2_label,
			this.tenBox
		]
			= this.GetChildrenByNames([

				"_img",
				"_Group2",
				"_Image1",
				"_Image2",
				"_Group1",
				"_Image1",
				"_img_lb",
				"_img_lb2",
				"_gp_reward",
				"_gp_item1",
				"_gp_item2",
				"_gp_item3",
				"_gp_item4",
				"_gp_item5",
				"_gp_item6",
				"_gp_item7",
				"_gp_item8",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Image10",
				"_img_pointer",
				"_btn",
				"_Image11",
				"_Image12",
				"_Group3",
				"_Label4",
				"_lb_num",
				"_btn_red",
				"_bg_left",
				"_Group5",
				"_Group4",
				"_rbtn",
				"_rbtn_bg",
				"_rbtn_check",
				"_rbtn_label",
				"_rbtn1",
				"_rbtn1_bg",
				"_rbtn1_check",
				"_rbtn1_label",
				"_Image13",
				"_scroller",
				"_list",
				"_bg_right",
				"_Group6",
				"_Image14",
				"_Image15",
				"_task_scroller",
				"_task_list",
				"_Image16",
				"_Image17",
				"_Image18",
				"_Image19",
				"_Image20",
				"_Image21",
				"_img_change",
				"_Group7",
				"_check_box",
				"_Image22",
				"_bm",
				"_Group1",
				"_Image1",
				"check",
				"group2_label",
				"tenBox"
			])
		this.group2_label.style.fontSize = 18
		this.group2_label.style.color = "#FFFFFF"
		this.group2_label.width = 500
		// this._img_pointer.rotation=180
	}
}
window["MondaysAwardView"] = MondaysAwardView