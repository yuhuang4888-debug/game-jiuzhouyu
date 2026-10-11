import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { TaskTipType } from "../commonModel/TaskModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { ResManager } from "../common/ResManager"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { AccumRechargeItem } from "./AccumRechargeItem"
import { table } from "../common/table"
import { LoopScrCon } from "../common/LoopScrowViewMgr"
import { GameResPath } from "../util/GameResPath"
import { Enum_UILayer } from "../common/LayerManager"
import { Config } from "../common/Config"
import { HtmlColorTxt, SetHtmlStyle } from "../util/Util"

export class AccumRechargeView extends BaseItem1 {

	CustomMehod
	InitEvent
	InitView
	LoadSuccess
	Local_DeleteMe
	SetRewardData
	UpdateItems
	_Viewport1
	_ac_item
	_act_info
	_model
	_reward_data
	createChildren
	needRefresh
	parent_mask_corner
	story_obj_list
	time_title_color

	public constructor(parent?) {
		super(parent)

		this._act_info = null
		this._model = CustomActivityModel.GetInstance()

		this.base_file = "activity"
		this.layout_file = "AccumRechargeView"
		this.layer_value = Enum_UILayer.UI
		let local_Event = CustomActivityDefine.EVENT
		this._ac_item = null
		let timer = null
		this._reward_data = null
		this.preload_client_config = { "ConfigCustomActivityView": false }
		let local_TaskTipType = TaskTipType
		let CURR_BASE_WINDOW_COMPONENT = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT
		//let mask_item_mat =  new Material(ShaderTools.GetShader("UI-Default_mask"))

		this.load_callback = () => {
			SetHtmlStyle(this._lb_desc, { c: "#ffffff", f: 22, ww: false, w: 720 })
			this._group_item.scrollBar.visible = false
			if (this.needRefresh) {
				this.SetRewardData(this._act_info)
			}

			this.LoadSuccess()

		}

		//第一次添加到舞台的时候调用
		this.createChildren = () => {
			let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
			if (open_day < 8) {
				this.story_obj_list = this.story_obj_list || {}
				this.story_obj_list[local_TaskTipType.Award_lv_gift] = [CURR_BASE_WINDOW_COMPONENT._story_bar2]
				this.story_obj_list[local_TaskTipType.Award_eternal_valley] = [CURR_BASE_WINDOW_COMPONENT._story_bar2]
			}
			super.createChildren()
		}

		this.Local_DeleteMe = () => {
			if (timer) {
				timer.DeleteMe()
			}
			if (this._ac_item) {
				this._ac_item.DeleteMe()
				this._ac_item = null
			}
		}

		this.CustomMehod = (index?, info?) => {
			this._act_info = info
			if (this.is_loaded) {
				this.SetRewardData(info)
			} else {
				this.needRefresh = true
			}
		}

		this.SetRewardData = (info?) => {
			let act_data = this._model.GetActData(info.base_type, info.sub_type)
			if (act_data) {
				for (let _tmpi in act_data.reward_list) {
					var data = act_data.reward_list[_tmpi]
					data.base_type = info.base_type
					data.sub_type = info.sub_type
				}
			}
			this._reward_data = act_data
		}

		this.InitEvent = () => {
			let RefView = (base_type?, sub_type?) => {
				if (!this._act_info) {
					return
				}
				if (!this._reward_data) {
					return
				}
				if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
					this.SetRewardData(this._act_info)
					this.UpdateItems()
				}
			}
			this.BindEvent(this._model, local_Event.UPDATE_ACT_RECHANGE, RefView)

			this.BindEvent(this._model, local_Event.UPDATE_ACT_RECHANGE_DAY, () => {
				this.UpdateItems()
			})

			this.BindEvent(this._model, local_Event.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
				if (!this._act_info) {
					return
				}
				if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
					this.SetRewardData(this._act_info)
					this.UpdateItems()
					let rewards = this._model.GetActReward(reward_data.base_type, reward_data.sub_type, reward_data.form_type, reward_data.reward)
					new CongratulationObtainView(rewards, 10).Open()
				}
			}
			)


			//33104返回
			this.BindEvent(this._model, local_Event.UPDATE_VIEW, (base_type?, sub_type?) => {
				if (this._act_info.base_type == base_type) {
					this.SetRewardData(this._act_info)
					this.UpdateItems()
				}
			})


		}

		this.LoadSuccess = () => {

			this.InitView()
			this.InitEvent()
		}

		this.InitView = (item?) => {
			if (this._act_info) {
				this._model.Fire(local_Event.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
			}

			this._model.CloseACTRed(this._act_info.base_type, this._act_info.sub_type)

			let bg_url = null
			let title_url = null
			if (!this._act_info) {
				return
			}

			this.time_bg.visible = false
			this._gp_time.x = 10

			this._gp_time.y = 237
			let needStoke = false
			let font_size = 22
			if (this._lb_desc) this._lb_desc.visible = true


			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigCustomActivityView", true)
			switch (this._act_info.base_type) {
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.FTVRECHARGE: //14
					this.time_bg.visible = false
					this._lb_desc.visible = false
					// bg_url = "" 
					// title_url = ""
					// if (this._act_info.desc == "九州周末") {
					// 	this._gp_time.y = 262
					// 	bg_url = "uiljcz_001" //a
					// 	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("activity", bg_url), true)
					// } else if (this._act_info.desc == "九州周中") {
					// 	this._gp_time.y = 262
					// 	bg_url = "uiljcz_002" //a
					// 	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("activity", bg_url), true)
					// }
					if (cfg && this._act_info) {
						this._model.LoadCompontRes(this, cfg, "AccumRechargeView_14", this._act_info.show_id)
					}
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_LOOP://124
					//循环累充
					bg_url = ""
					title_url = ""
					if (cfg && this._act_info) {
						this._model.LoadCompontRes(this, cfg, "AccumRechargeView_124", this._act_info.show_id)
					}
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_SINGLE://125
					// bg_url = "act_title_125"
					// title_url = ""
					if (cfg && this._act_info) {
						this._model.LoadCompontRes(this, cfg, "AccumRechargeView_125", this._act_info.show_id)
					}
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.CON_RECHARGE: //109
					// bg_url = "act_title_125"
					// title_url = ""
					break;
				default:
					if (this._model.isCBPlatform()) {	//H5那边封测的
						bg_url = "uihd_ljcz_001_fc" //a
						title_url = "uihd_ljcz_002_fc.png"
					} else if (this._act_info.show_id == 2) {	//合服累充的
						bg_url = "uihflc_001" //a
						title_url = "uihflc_002"
						this.time_bg.visible = false
						this._gp_time.x = 25
						this._gp_time.y = 265
						font_size = 20
						this._lb_desc.visible = false
					} else {
						bg_url = "uihd_ljcz_001" //a
						title_url = ""
					}

					break;
			}


			if (bg_url) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpgOtherPath("activity", bg_url), true)
			}

			if (title_url && title_url != "") {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIconOtherPath("activity", title_url), true)
			}
			//lua_resM:SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common2","uity_060"))
			this._ac_item = new LoopScrowViewMgr()
			let item_ = item || AccumRechargeItem
			this._ac_item.SetData(this._group_item, item_, {}, LoopScrCon.Vertical, 1)

			this.UpdateItems()
			this.time_title_color = this.time_title_color ? this.time_title_color : "#ffffff"
			let time_desc = "活动剩余时间"
			let color1 = "#00fa64"
			let tip_2 = "活动期间充值勾玉数达到指定数额即可获得惊喜好礼"
			switch (this._act_info.base_type) {
				case 14:
				case 7:
					time_desc = "活动剩余时间："
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_SINGLE:
					time_desc = "活动剩余时间："
					color1 = "#bffd7d"
					tip_2 = `${HtmlColorTxt("充值页面", '"#bffd7d"')}单笔充值指定金额可领取奖励，多次充值金额不累加`
					break;
				case 109:
					time_desc = "活动倒计时："
					break;
				case Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.RANK_RECHARGE_LOOP:
					time_desc = "剩余时间："
					break;
				default:
					time_desc = "活动剩余时间"
					break;

			}

			if (this._lb_desc) this._lb_desc.innerHTML = tip_2
			timer = this._model.LoadActTimer(this._gp_time, this._act_info.etime, font_size, color1, null, this.time_title_color, time_desc, null, needStoke)
		}

		this.UpdateItems = () => {
			if (!this._reward_data) {
				return
			}

			let list = this._reward_data.reward_list
			table.sort(list, (a?, b?) => {
				if (a.status != b.status) {
					if (a.status == 1) {
						return true
					} else if (b.status == 1) {
						return false
					} else {
						return a.status < b.status
					}
				} else {
					return a.grade < b.grade
				}
			})
			this._ac_item.replaceAll(list)
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_title: Laya.Image
	_titleBg: Laya.Image
	bg: Laya.Image
	_gp_tips: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	time_bg: Laya.Image
	_gp_time: Laya.Box
	_group_item: Laya.List
	_lb_desc: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._titleBg,
			this.bg,
			this._gp_tips,
			this._Image1,
			this._Label1,
			this.time_bg,
			this._gp_time,
			this._group_item,
			this._lb_desc,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_titleBg",
				"bg",
				"_gp_tips",
				"_Image1",
				"_Label1",
				"time_bg",
				"_gp_time",
				"_group_item",
				"_lb_desc",
			])
	}
}
window["AccumRechargeView"] = AccumRechargeView