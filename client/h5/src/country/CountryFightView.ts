import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, RefBoxChildsLayout } from "../util/Util"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { SeaFightView } from "../seaHegemony/SeaFightView"
import { GameResPath } from "../util/GameResPath"

export class CountryFightView extends BaseItem1 {
	CancelTimer
	Dispose
	InitEvent
	InitView
	SetTimer
	StartTimer
	TimerFunc
	endTime
	seafightItem
	timerId
	res_mgr
	font_isload
	cur_days
	public constructor(parent?) {
		super(parent)
		this.base_file = "country"
		this.layout_file = "CountryFightView"

		this.res_mgr = ResManager.GetInstance()
		let local_model = SeaHegemonyModel
		let local_modelIns = local_model.GetInstance()
		let local_timeUtil = TimeUtil
		//let initTab = false
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("country", "ui_shzb_034"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIconOtherPath("country", "ui_shzb_035"), true)
			ResManager.GetInstance().SetImageSprite(this,this._bg_lable,"country","ui_shzb_013")
			this.cur_days = null
			this.font_isload = false
			this.timeLb2.text = "0时0分0秒"
			ResManager.GetInstance().LoadFont(this, "sea_day", this.timeLb3, 32, false, () => {
				this.font_isload = true
				this.SetTimer()
			});


			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {
			if (!this.seafightItem) {
				this.seafightItem = new SeaFightView(this.StartGp)
				this.seafightItem.Load()
			}
			let isToday = local_modelIns.StartTime != 0
			if (isToday) {
				this.UnStartGp.visible = false
				this.StartGp.visible = true
			} else {
				this.UnStartGp.visible = true
				this.StartGp.visible = false
			}
			this.SetTimer()
		}

		this.InitEvent = () => {
			this.BindEvent(local_modelIns, local_model.START_DATA, () => {
				this.InitView()
			})

			this.BindEvent(local_modelIns, local_model.UPDATE_SEA_INFO, () => {
				this.InitView()
			})
		}

		this.SetTimer = () => {
			this.endTime = local_modelIns.StartInfo.start_time
			if (this.endTime == 0) {
				let vo = local_modelIns.activeStartTime[1]
				if (vo && vo.start_time && vo.start_time > TimeUtil.getServerTime()) {
					this.endTime = vo && vo.start_time || 0
				}
			}
			if (this.endTime > 0) {
				this.CancelTimer()
				this.StartTimer()
			}
		}

		this.StartTimer = () => {
			this.timerId = GlobalTimerQuest.AddPeriodQuest(() => {
				this.TimerFunc()
			},1)
			this.TimerFunc()
		}

		this.CancelTimer = () => {
			if (this.timerId) {
				GlobalTimerQuest.CancelQuest(this.timerId)
				this.timerId = null
			}
		}

		this.TimerFunc = () => {
			let time = this.endTime - TimeUtil.getServerTime()
			if (time > 0 && this.timeLb2) {
				let D = Math.floor(time / 60 / 60 / 24)
				let h = Math.floor(time / 60 / 60) % 24
				let m = Math.floor(time / 60) % 60
				let s = time % 60
				this.timeLb2.text = `${h}时${m}分${s}秒`

				if (this.font_isload && D != this.cur_days) {
					this.timeLb3.text = D + ""
					RefBoxChildsLayout(this._box_day, -5)
					this.cur_days = D
				}

				return true
			} else {
				this.UnStartGp.visible = false
				this.StartGp.visible = true
				this.CancelTimer()
			}
			return false
		}

		this.Dispose = () => {
			this.CancelTimer()
			if (this.seafightItem) {
				this.seafightItem.DeleteMe()
				this.seafightItem = null
			}
		}
	}

	public DeleteMe() {
		this.Dispose()
		super.DeleteMe()
	}

UnStartGp:Laya.Box
bg1:Laya.Image
_bg_lable:Laya.Image
_bg_lable2:Laya.Image
_start_tips:Laya.Image
_box_day:Laya.Box
timeLb3:Laya.Label
_img_day:Laya.Image
bg2:Laya.Image
_Image1:Laya.Image
_Label1:Laya.Label
timeLb2:Laya.Label
StartGp:Laya.Box
public GetComponents() {
[
this.UnStartGp,
this.bg1,
this._bg_lable,
this._bg_lable2,
this._start_tips,
this._box_day,
this.timeLb3,
this._img_day,
this.bg2,
this._Image1,
this._Label1,
this.timeLb2,
this.StartGp,
]
 = this.GetChildrenByNames([

"UnStartGp",
"bg1",
"_bg_lable",
"_bg_lable2",
"_start_tips",
"_box_day",
"timeLb3",
"_img_day",
"bg2",
"_Image1",
"_Label1",
"timeLb2",
"StartGp",
])
}
}
 window["CountryFightView"]= CountryFightView