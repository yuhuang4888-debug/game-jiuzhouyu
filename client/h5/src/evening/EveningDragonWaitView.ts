import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { EveningAnswerItem } from "./EveningAnswerItem"

export class EveningDragonWaitView extends BaseItem1 {
	_etime
	_timer_id
	model
	percentHeight
	percentWidth
	_ac_rank

	public constructor(parent?) {
		super(parent)

		this.model = GuildActivityModel.GetInstance();
		this.base_file = "evening"
		this.layout_file = "EveningDragonWaitView"
		this.percentWidth = 100
		this.percentHeight = 100
		this.load_callback = () => {
			SetHtmlStyle(this._lb_open_time, { c: "#ffffff", f: 22, w: 409, ww: false })
			this.LoadSuccess()
		}
	}

	public DeleteMe() {
		if (this._ac_rank) {
			this._ac_rank.DeleteMe()
			this._ac_rank = null
		}
		this.Clear()
		super.DeleteMe()
	}

	public Clear() {

		this.ClearTimer()
		this._timer_id = null
	}

	public LoadSuccess() {

		this.InitView()
		this.InitEvent()
	}

	public InitView() {

		this.SetTimer()
	}

	public InitEvent() {

		this.BindVar(this.model, "act_info", (event_name?, value?, old_value?) => {
			this.SetTimer(value)
		}
		)

	}

	public SetTimer(info?) {

		this.ClearTimer()
		let act_info = info || this.model.GetActInfo()
		if (!act_info || act_info.stage == 0) {
			return
		}
		this._etime = act_info.etime
		this.SetTimeText(this._etime - TimeUtil.getServerTime())
		// this._timer_id = Laya. new Timer(1000, 0)
		// this._timer_id.addEventListener(Laya.TimerEvent.TIMER, this.UpdateTimer, this)
		// this._timer_id.start()

		this._timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
			this.UpdateTimer()
		}, 1, -1)
		this.UpdateTimer()
	}

	public UpdateTimer() {

		let rtime = this._etime - TimeUtil.getServerTime()
		if (rtime < 0) {
			this.ClearTimer()
		} else {
			this.SetTimeText(rtime)
		}
	}

	public SetTimeText(rtime?) {
		let str = HtmlColorTxt(rtime, Enum_ColorUtil_Light.GREEN)
		this._lb_open_time.innerHTML = `${str}秒后开启BOSS召唤`
		SetHtmlCenter(this._lb_open_time, { x: 0, w: 500 })
	}




	public ClearTimer() {
		if (this._timer_id) {
			GlobalTimerQuest.CancelQuest(this._timer_id)
			this._timer_id = null
		}
	}


_group_open:Laya.Box
_Image1:Laya.Image
_Label1_1:Laya.Label
_lb_open_time:Laya.HTMLDivElement
public GetComponents() {
[
this._group_open,
this._Image1,
this._Label1_1,
this._lb_open_time,
]
 = this.GetChildrenByNames([

"_group_open",
"_Image1",
"_Label1_1",
"_lb_open_time",
])
}
}
 window["EveningDragonWaitView"]= EveningDragonWaitView