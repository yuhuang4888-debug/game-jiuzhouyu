import { BaseItem1 } from "../common/BaseItem1"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { DailyModel, ActivityType } from "../commonModel/DailyModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutLineModel } from "../commonModel/OutLineModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DailyEvent } from "./DailyEvent"
import { DailyLivenessRewardItem } from "./DailyLivenessRewardItem"
import { kfStageModel } from "../commonModel/kfStageModel"
import { SettingModel } from "../commonModel/SettingModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { OpenFun } from "../common/OpenFun"
import { RoleManager } from "../commonModel/RoleManager"
import { OnHookModel } from "../commonModel/OnHookModel"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"

export class DailyBottomView extends BaseItem1 {
	ClickBox
	InitEvents
	LoadSuccess
	OutLineTimeAddFun
	SetData
	SetLivenessDot
	SetOutLineTime
	UpdateLivenessReward
	_config_activity_reward
	_item_list
	icon_group_list
	hide_normal
	public constructor(parent?) {
		super(parent)
		this.base_file = "daily"
		this.layout_file = "DailyBottomView"
		this.preload_server_config = {
			"config_num_by_vip": false,
			"config_activity_reward": false,
			"config_ac_kv": false
		}
		let local_DailyEvent = DailyEvent
		let outline_model = OnHookModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		let model = DailyModel.GetInstance()
		//let _data = null
		let _daily_task = null
		let _num_list = null
		this._config_activity_reward = null
		let _progress_width = null
		//let _arrayCollection = null
		this._item_list = []
		this.icon_group_list = []

		this.load_callback = () => {
			this.week_tip.visible = WeekCardModel.GetInstance().GetWeekCardData().is_activity == 0
			this.LoadSuccess()
			this.InitEvents()
			model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15703)
			this.SetData()
		}

		this.LoadSuccess = () => {
			this.icon_group_list = [this.icon_group0, this.icon_group1, this.icon_group2, this.icon_group3]
			this._config_activity_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_activity_reward", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bottom_bg, GameResPath.GetIconOtherPath("daily", "uirw_008"))
			_num_list = [this.num1, this.num2, this.num3, this.num4]
			//this.progress_front.mask = this.progress_bg_mask
			_progress_width = 519


			this.huoyuedu_value.fontSize = 57
			ResManager.GetInstance().LoadFont(this, "daily_liveness", this.huoyuedu_value, 57, true, () => {
				// this.huoyuedu_value.fontSize = 24
			})

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.progress_front, GameResPath.GetIcon("daily", "uirw_010"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.progress_bg, GameResPath.GetIcon("daily", "daily_proggressbg"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.progress_front, GameResPath.GetIcon("daily", "uirw_010"))


			var expMask_: Laya.Sprite;
			expMask_ = new Laya.Sprite();
			expMask_.graphics.drawRect(0, 0, 0, 22, "#ffffff");
			expMask_.pos(0, 0);
			this.progress_front.mask = expMask_
			// this.progress_front.mask.graphics.drawRect(0, 0, _progress_width, 22, "#ffffff");
			// this.progress_front.mask.graphics.drawRect(0, 0, 40, 22, "#ffffff");
		}

		this.InitEvents = () => {
			let update_fun = () => {
				this.SetData()
			}

			this.BindEvent(model, local_DailyEvent.UPDATE_DAILY_DATA, update_fun)
			this.BindEvent(model, local_DailyEvent.UPDATE_LIVENESS_REWARD, () => {
				this.UpdateLivenessReward()
			})
			Util.AddClickEvent(this.week_lab, () => {
				// OpenFun.OpenFunHandler(452)
				if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge())
					OpenFun.OpenFunHandler(191)
				else{
					Message.show("购买首充后开启")
				}
			}, this, false)
			Util.AddClickEvent(this.huoyuedu, () => {
				model.Fire(local_DailyEvent.OPEN_VIEW, "DailyLivenessMsgView")
			}, this, true)

			Util.AddClickEvent(this.addBtn, () => {
				this.OutLineTimeAddFun()
				//model.outline_red = false
				//this.offline_red.visible = model.outline_red
				model.ShowRedDot()
			}, this, true)

			Util.AddClickEvent(this.calendar, () => {
				model.Fire(local_DailyEvent.OPEN_VIEW, "DailyCalendarView")
			}, this, true)

			Util.AddClickEvent(this.kuafu, () => {
				kfStageModel.GetInstance().Fire(kfStageModel.OPEN_VIEW, "kfStageView")
			}, this, true)

			let livenss_dot_fun = () => {
				this.SetLivenessDot()
			}
			this.BindEvent(model, local_DailyEvent.UPDATE_LIVENESS_IMAGE_DATA, livenss_dot_fun)

			this.BindEvent(model, local_DailyEvent.UPDATE_OUTLINE_INFO, () => {
				this.SetOutLineTime()
			})

		}

		this.ClickBox = (index?) => {
			let reward = model.GetLivenessDataByIndex(index)
			if (reward) {
				if (reward[1] == 1) {
					model.Fire(local_DailyEvent.DAILY_REQUEST_PROTO, 15705, "i", reward[0])
				}
			}
		}

		this.SetData = () => {
			let list = model.daily_data[ActivityType.UnLimit]
			if (!list) {
				return
			}
			let act_list = model.GetToadyActivityList(list.ac_list)
			let config_num_by_vip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_num_by_vip", false);
			let config_ac_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_ac_kv", false);
			_daily_task = model.SortUnLimitActivity(act_list, config_num_by_vip, config_ac_kv)
			if (!_daily_task) {
				return
			}
			this.UpdateLivenessReward()
			this.SetLivenessDot()
			this.SetOutLineTime()
			if (this.hide_normal) {
				this.HideNormalGroupVisble()
				this.hide_normal = undefined
			}
		}

		this.UpdateLivenessReward = () => {
			if (model.liveness_reward && model.liveness_reward.reward_list) {
				let vo = null
				let cfg = null
				let max = 0
				let con = null
				let item = null
				let goods_list = null
				let basic = null
				let i = 0
				do {
					vo = model.liveness_reward.reward_list[i]
					con = this.icon_group_list[i]
					if (con) {
						item = this._item_list[i]
						if (!item) {
							item = new DailyLivenessRewardItem(con)
							item.Load()
							this._item_list[i] = item
						}
						item.SetData(vo)
						cfg = this._config_activity_reward[vo.id]
						if (cfg) {
							max = Number(cfg.live)
							_num_list[i].text = cfg.live
						}
					}
					i = i + 1
				} while ((i <= model.liveness_reward.reward_list.length))
				max = 160
				let now = model.liveness_reward.live
				if (now > 120) {
					now = now + 10
				}
				let width = now / max * _progress_width
				if (now >= max) {
					//width = _progress_width
					now = max
				}
				// this.progress_front.fillAmount = Number(now) / Number(max)
				this.progress_front.mask.graphics.clear()
				this.progress_front.mask.graphics.drawRect(0, 0, width, 22, "#ffffff");
				this.huoyuedu_value.text = String(model.liveness_reward.live)
			}
		}

		this.SetLivenessDot = () => {
			this.liveness_dot.visible = model.LivenessCanUpgrade()
		}

		this.SetOutLineTime = () => {
			let outline_time = model.outline_info || outline_model.GetOnhookTime()
			let hours = Math.floor(outline_time / 3600)
			this.offline_time.style.fontSize = 20
			this.offline_time.width = 280
			this.offline_time.style.color = "#ffffff"
			this.offline_time.innerHTML = Util.StrToHTML("离线挂机时间:<font color='#ffdd65'>" + hours + "小时</font>")
			this.offline_red.visible = model.GetOffLineRed()
		}

		this.OutLineTimeAddFun = () => {
			let goods_id = goods_model.GetOneGoodsByTypeId(model.cost_goods_type)
			if (goods_id > 0) {
				let goods_vo = goods_model.GetGoodsVoByGoodsId(goods_id)
				if (goods_vo) {
					let recommend_num = model.GetRecommendUseNum(goods_vo)
					let min_num = recommend_num <= 0 && 0 || 1
					recommend_num = recommend_num <= 0 && 1 || recommend_num
					BagModel.GetInstance().Fire(BagModel.OPEN_VIEW, "BatchUseView", goods_vo, min_num, recommend_num, goods_vo.goods_num)
				}
			} else {
				MaterialsTool.GetInstance().materialsTips(model.cost_goods_type)
			}
		}
	}

	public HideNormalGroupVisble() {
		if (this.is_loaded) {
			this.normal_group.visible = false
		} else {
			this.hide_normal = true
		}
	}

	public DeleteMe() {
		for (let _tmpi in this._item_list) {
			var item = this._item_list[_tmpi]
			item.DeleteMe()
			item = null
		}
		this._item_list = []
		this._config_activity_reward = null
		this.icon_group_list = []
		super.DeleteMe()
	}



	bottom_bg: Laya.Image
	normal_group: Laya.Box
	offline_conta: Laya.Box
	offline_time: Laya.HTMLDivElement
	addBtn: Laya.Image
	offline_red: Laya.Image
	huoyuedu: Laya.Image
	liveness_dot: Laya.Image
	calendar: Laya.Image
	kuafu: Laya.Image
	_Image9: Laya.Image
	_Label1: Laya.Label
	progress_bg: Laya.Image
	progress_front: Laya.Image
	huoyuedu_bg: Laya.Image
	icon_group0: Laya.Box
	icon_group1: Laya.Box
	icon_group2: Laya.Box
	icon_group3: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	huoyuedu_value: Laya.Label
	num1: Laya.Label
	num2: Laya.Label
	num3: Laya.Label
	num4: Laya.Label
	week_tip: Laya.Image
	week_lab: Laya.Label
	public GetComponents() {
		[
			this.bottom_bg,
			this.normal_group,
			this.offline_conta,
			this.offline_time,
			this.addBtn,
			this.offline_red,
			this.huoyuedu,
			this.liveness_dot,
			this.calendar,
			this.kuafu,
			this._Image9,
			this._Label1,
			this.progress_bg,
			this.progress_front,
			this.huoyuedu_bg,
			this.icon_group0,
			this.icon_group1,
			this.icon_group2,
			this.icon_group3,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this.huoyuedu_value,
			this.num1,
			this.num2,
			this.num3,
			this.num4,
			this.week_tip,
			this.week_lab
		]
			= this.GetChildrenByNames([

				"bottom_bg",
				"normal_group",
				"offline_conta",
				"offline_time",
				"addBtn",
				"offline_red",
				"huoyuedu",
				"liveness_dot",
				"calendar",
				"kuafu",
				"_Image9",
				"_Label1",
				"progress_bg",
				"progress_front",
				"huoyuedu_bg",
				"icon_group0",
				"icon_group1",
				"icon_group2",
				"icon_group3",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"huoyuedu_value",
				"num1",
				"num2",
				"num3",
				"num4",
				"week_tip",
				"week_lab"
			])
	}
}
window["DailyBottomView"] = DailyBottomView