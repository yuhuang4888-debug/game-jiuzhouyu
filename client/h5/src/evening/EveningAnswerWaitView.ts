import { BaseItem1 } from "../common/BaseItem1"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, SetHtmlCenter, Util } from "../util/Util"

export class EveningAnswerWaitView extends BaseItem1 {
	_act_info
	_timer_id
	model
	percentHeight
	percentWidth
	preload_server_config


	public constructor(parent?) {
		super(parent)

		this.model = GuildActivityModel.GetInstance();
		this.base_file = "evening"
		this.layout_file = "EveningAnswerWaitView"
		this.percentWidth = 100
		this.percentHeight = 100
		// this.preload_server_config = [Gfeast=false]
		this.load_callback = () => {

			this.LoadSuccess()
		}
	}

	public DeleteMe() {

		this.Clear()
		super.DeleteMe()
	}

	public Clear() {

		this.ClearTimer()
	}

	public LoadSuccess() {

		this.InitView()
		this.InitEvent()
	}

	public InitView() {

		this.model.SetMainUIViewVisible(false)
		let act_info = this.model.GetActInfo()
		if (!act_info || act_info.stage == 0) {
			return
		}
		if (act_info.stage != 3) {
			return
		}
		this._act_info = act_info
		this.SetTimer()
		MainUIModel.GetInstance().Fire(MainUIModel.CHANGE_ACTIVITY_STATE, false)
	}

	public InitEvent() {


	}

	public SetTimer() {

		this.ClearTimer()
		//this.SetTimeText(info.etime - TimeUtil.getServerTime())
		this._timer_id = GlobalTimerQuest.AddPeriodQuest(() => {
			this.UpdateTimer()
		}, 1, -1)
		this.UpdateTimer()
	}

	public UpdateTimer() {

		let rtime = this._act_info.etime - TimeUtil.getServerTime()
		if (rtime < 0) {
			this.ClearTimer()
		} else {
			this.SetTimeText(rtime)
		}
	}

	public SetTimeText(rtime?) {
		this.PerHtml_lb()
		let str = HtmlColorTxt(rtime, Enum_ColorUtil_Light.GREEN)
		let str1 = GuildActivityModel.GetInstance().GetEveningGameName()
		this._lb_tips.innerHTML = Util.StrToHTML(`${str}秒后进入【${str1}阶段】`)
		SetHtmlCenter(this._lb_tips,{x:0, w:409})
	}

	public ClearTimer() {

		if (this._timer_id) {
			GlobalTimerQuest.CancelQuest(this._timer_id)
			this._timer_id = null
		}
	}

	PerHtml_lb() {
		this._lb_tips.style.color = "#ffffff"
		this._lb_tips.style.fontSize = 22
		this._lb_tips.width = 409
	}




	_Group1: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_lb_tips: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this._Label1,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"_Label1",
				"_lb_tips",
			])
	}
}
window["EveningAnswerWaitView"]=EveningAnswerWaitView