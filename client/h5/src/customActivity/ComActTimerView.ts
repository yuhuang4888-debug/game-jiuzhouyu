import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class ComActTimerView extends BaseItem1 {
	public _time

	OnTimer2
	Local_DeleteMe
	InitView
	RefData
	time_id

	public constructor(parent) {
		super(parent)

		this.base_file = "customActivity"
		this.layout_file = "ComActTimerView"
		let _etime
		let _size
		let _color
		let _title_color
		let _style
		let _desc
		let _needStoke
		let _need_bk
		let _endTimeCb: Function;
		let _center // 父对象的width
		let _end_desc //时间为0时的描述

		let _timer

		let local_TimeUtil = TimeUtil

		this.load_callback = () => {
			this.InitView()
		}

		this.InitView = () => {
			// if (_center) {
			// 	//居中模式
			// 	SetSizeDeltaX(this.form, _center)
			// 	this._time.anchorMin = Vector2(0.5, 1)
			// 	this._time.anchorMax = Vector2(0.5, 1)
			// 	this._time.pivot = Vector2(0.5, 1)
			// }

			if (_etime != undefined) {
				// if (!this.time_id) {
				// 	this.time_id = GlobalTimerQuest.AddPeriodQuest(this.OnTimer2, 1, -1)
				// 	this.OnTimer2()
				// }
				Laya.timer.loop(1000, this, this.OnTimer2)
				this.OnTimer2()
			}
		}

		this.OnTimer2 = () => {
			if (this.use_delete_method) {
				return
			}
			let time = _etime - local_TimeUtil.getServerTime()
			this._time.style.fontSize = _size
			this._time.style.color = _color
			if (_needStoke) {
				this._time.style.stroke = 2
				this._time.style.strokeColor = "#ffffff"
			}
			if (time >= 0) {
				if (_need_bk) {
					this._time.innerHTML = Util.StrToHTML(`<font color = '${_title_color}'>（${_desc}</font><font color='${_color}'>
					${local_TimeUtil.timeConvert(time, _style)}</font>)<font color = '${_title_color}'>）</font>`)
				} else {
					this._time.innerHTML = Util.StrToHTML(`<font color = '${_title_color}'>${_desc}</font><font color='${_color}'>${local_TimeUtil.timeConvert(time, _style)}</font>`)
				}
			} else {
				this._time.innerHTML = Util.StrToHTML(`<font color='#EF3C3C'>${_end_desc}</font>`);
				if (_endTimeCb) {
					_endTimeCb();
				}
			}
			this._time.width = 500
			this._time.x = 0
		}

		this.RefData = (etime?, size?, color?, style?, title_color?, desc?, center?, needStoke?, need_bk?, endTimeCb?: Function, end_desc?) => {
			_etime = Number(etime)
			_size = size ? size : 18
			_color = color ? color : "#fe1a1a"
			_title_color = title_color ? title_color : "#663915"
			_style = style ? style : "hh-mm-ss"
			_desc = desc ? desc : ""
			_needStoke = needStoke ? true : false
			_need_bk = need_bk == null ? false : need_bk
			_endTimeCb = endTimeCb
			_center = center
			_end_desc = end_desc ? end_desc : "活动已关闭"
		}

	}

	public DeleteMe() {
		Laya.timer.clear(this, this.OnTimer2)
		// if (this.time_id) {
		// 	GlobalTimerQuest.CancelQuest(this.time_id)
		// 	this.time_id = null
		// }
		// CustomActivityModel.GetInstance().DeleteActTimer(this._parent)
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._time,
		]
			= this.GetChildrenByNames([

				"_time",
			])
	}
}
window["ComActTimerView"] = ComActTimerView