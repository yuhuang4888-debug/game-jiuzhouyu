import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DailySupplyItem } from "./DailySupplyItem"

export class DailySupplyView extends BaseItem1 {
	_img_bg: Laya.Image
	_gp_time: Laya.Box
	dailyLb: Laya.HTMLDivElement
	tipsLabel: Laya.HTMLDivElement
	_Image1: Laya.Image
	_Scroller1: Laya.List
	_img_bg2:Laya.Image
	InitEvent
	InitView
	LoadSuccess
	Local_DeleteMe
	SetRewardData
	UpdateItems
	_group_item
	loop_mgr


	public constructor(parent?) {
		super(parent)


		let Arr_ = null
		let Info_ = null
		let reward_ = null
		let timer_ = null
		this.base_file = "activity"
		this.layout_file = "DailySupplyView"
		let model = CustomActivityModel.GetInstance()
		let local_caDefine_event = CustomActivityDefine.EVENT
		this.load_callback = () => {

			// let mask = this.GetChild("_Scroller1/_group_item").GetComponent("Image")
			// this.RegisterMask(mask)
			this.LoadSuccess()
		}

		this.SetRewardData = (info?) => {
			let act_data = model.GetActData(info.base_type, info.sub_type)
			if (act_data) {
				for (let _tmpi in act_data.reward_list) {
					var data = act_data.reward_list[_tmpi]
					data.base_type = info.base_type
					data.sub_type = info.sub_type
				}
				reward_ = act_data
			}
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_caDefine_event.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
				if (!Info_) {
					return
				}
				if (Info_.base_type == base_type && Info_.sub_type == sub_type) {
					this.SetRewardData(Info_)
					this.UpdateItems()
					let rewards = model.GetRewardsBySex(reward_data.reward)
					let view = new CongratulationObtainView(rewards, 10)
					view.Open()
				}
			}
			)
			let updata_view = (...new_args) => {
				if (!Info_) {
					return
				}
				let args = new_args
				if (args[0] == Info_.base_type && args[1] == Info_.sub_type) {
					this.SetRewardData(Info_)
					this.UpdateItems()
				}
			}

			this.BindEvent(model, local_caDefine_event.UPDATE_VIEW, updata_view)
			this.BindEvent(model, local_caDefine_event.UP_DAILY_SUPPLY, (liveness?) => {
				if (liveness != null) {
					this.dailyLb.innerHTML = Util.StrToHTML("今日新增活跃度:<font color='#fff882'>" + liveness + "</font>")
				}
			}
			)
			let dayChange = () => {
				model.Fire(local_caDefine_event.SCMD_REQUEST, 33209)
			}

			this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, dayChange, true)
		}

		this.LoadSuccess = () => {
			CustomActivityDefine.First_Show_Red[61]=false
			ResManager.GetInstance().SetTexture(this,this._img_bg2,GameResPath.GetIcon("activity","bg"))
			let info = model.GetActInfoByShowID(61, 0)
			Info_ = info
			this.SetRewardData(info)
			if (Info_) {
				model.Fire(local_caDefine_event.SCMD_REQUEST, 33104, Info_.base_type, Info_.sub_type)
			}
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIconJpg("activity", "uimrbj_003"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("common2", "uity_060"))
			this.InitView()
			this.InitEvent()
			this.tipsLabel.innerHTML = Util.StrToHTML("注：仅统计新增活跃度，若已完成日常，请待<font color='#a0ff67'>凌晨4点</font>日常刷新")
		}

		this.InitView = () => {

			this.UpdateItems()
			timer_ = model.LoadActTimer(this._gp_time, Info_.etime, 20, "#a0ff67", "hh-mm-ss2", "#ffffff", "活动剩余时间：")
		}

		this.UpdateItems = () => {
			if (!reward_) {
				return
			}
			let list = reward_.reward_list
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
			}
			)
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._Scroller1, DailySupplyItem, list, LoopScrCon.Vertical, 1)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}

		this.Local_DeleteMe = () => {
			if (timer_) {
				timer_.DeleteMe()
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}


	}



	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._gp_time,
			this.dailyLb,
			this.tipsLabel,
			this._Image1,
			this._Scroller1,
			this._img_bg2
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_time",
				"dailyLb",
				"tipsLabel",
				"_Image1",
				"_Scroller1",
				"_img_bg2"
			])
		this.tipsLabel.style.fontSize=20
		this.tipsLabel.style.color="#ffffff"
		this.tipsLabel.style.wordWrap=false
		this.dailyLb.style.fontSize=20
		this.dailyLb.style.color="#ffffff"
		this.dailyLb.style.wordWrap=false
		this._Scroller1.scrollBar.visible=false
	}
}
window["DailySupplyView"]=DailySupplyView