import { Message } from "../sysInfo/SysInfoController"
import { Util, SetLocalPositionX, GetLocalPositionX, SetSizeDeltaX, SetSizeDeltaY } from "../util/Util"
import { BaseItem1 } from "./BaseItem1"
import { ResManager } from "./ResManager"
import { CHSlider } from "../common/CHSlider"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

export class WithBtnHSlider extends BaseItem1 {
	public reduce_btn: Laya.Image;
	public increase_btn: Laya.Image;
	public slider_con: Laya.Box;
	protected slider: CHSlider
	protected value_text: Laya.Label
	protected value_bg: Laya.Image

	LoadSuccess
	InitEvent
	SetValue
	SetData
	GetValue
	HideNumBtnAndNumBg
	SetCustomWidth
	SetCustomHeight
	need_refresh
	InitSlider
	public constructor(parent, default_value?, step?, min?, max?, show_num = true, call_back?, num_in_center?, default_width?) {
		super(parent)
		this.base_file = "common"
		this.layout_file = "WithBtnHSlider"
		
		let local_Message = Message,
			local_Util = Util,
			_min = 1,
			_max,
			_step,
			_show_num,
			_default_value,
			_call_back,
			_num_in_center, //数字显示固定显示进度条中间位置
			_need_hide_btn,
			_progress_width,
			_progress_height,
			_default_width

		
		_default_value = default_value
		_step = step
		_min = min
		_max = max
		_show_num = show_num
		_call_back = call_back
		_num_in_center = num_in_center
		_default_width = default_width
		// this.horizontalCenter = 0
		// this.verticalCenter = 0
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
			// this.display_obj.x = 500
			// this.display_obj.y = 500
		}

		this.DeleteMe = () => {
			if (this.slider && this.slider_con) {
				this.slider.DeleteMe()
				this.slider = null
			}
			this.value_text = null
			this.value_bg = null
			super.DeleteMe()
		}

		this.LoadSuccess = () => {
			// [this.reduce_btn,this.increase_btn,this.slider_con]=
			// this.GetChildrenByNames(["reduce_btn","increase_btn","slider_con"])
			this.BindEvent(GlobalEventSystem, SliderEvent.LOAD_CONPLETE, this.InitSlider)
			this.BindEvent(GlobalEventSystem,SliderEvent.CHANGE_SLIDER_VALUE,this.SetValue)
			if (!this.slider) {
				this.slider = new CHSlider(this.slider_con)
				this.slider.Load()
			}
			//GlobalEventSystem.Bind(SliderEvent.LOAD_CONPLETE, this.InitSlider)
		}

		this.InitSlider = () => {
			this.slider.ExcuteCallback(()=>{
				if(!this.is_loaded) return
				if(_default_value == null) return
				this.slider.minimum = _min
				this.slider.maximum = _max
				this.slider.snapInterval = _step
				this.slider.value = _default_value
				this.slider.changeValue()
				// this.slider.SetDefaultWidth(_default_width)
				this.value_bg = <Laya.Image>this.slider.value_bg
				this.value_text = <Laya.Label>this.slider.value_text
				if (!_show_num) {
					this.value_text.visible = false
					this.value_bg.visible = false
				} else {
					this.value_text.text = _default_value
				}
				// this.reduce_btn.label = "-"
				// this.increase_btn.label = "+"
				if (_num_in_center) {
					this.value_text.x = this.value_text.x + this.slider.track.width / 2
					this.value_bg.x = this.value_bg.x + this.slider.track.width / 2
				}
				if (_need_hide_btn) {
					this.HideNumBtnAndNumBg()
					_need_hide_btn = false
				}
				if (_progress_width) {
					this.SetCustomWidth(_progress_width)
					_progress_width = false
				}
				if (_progress_height) {
					this.SetCustomHeight(_progress_height)
					_progress_height = false
				}	
				this.SetValue()
			})
		}

		this.InitEvent = () => {
			let OnReduceBtnClick = () => {
				if (this.slider.value > _min) {
					this.SetValue(this.slider.value - _step)
				} else {
					local_Message.show("已经是最小数量了")
				}
			}
			local_Util.AddClickEvent(this.reduce_btn, OnReduceBtnClick, this, true)

			let OnIncreaseBtnClick = () => {
				if (this.slider.value < _max) {
					this.SetValue(this.slider.value + _step)
				} else {
					local_Message.show("已经是最大数量了")
				}
			}
			local_Util.AddClickEvent(this.increase_btn, OnIncreaseBtnClick, this, true)
		}

		this.SetValue = (value?: number) => {
			if (value != null) {
				this.slider.value = value
				this.slider.changeValue()
			}
			if (_show_num) {
				// if (!_num_in_center) {
				//     this.value_text.x = this.slider.thumb.x
				//     this.value_bg.x = this.slider.thumb.x
				// }
				if(this.value_text){
					this.value_text.text = this.slider.value.toFixed(0)
				}
			}
			if (_call_back) {
				_call_back(this.slider.value)
			}
		}

		this.SetData = (default_value?, step?, min?, max?, show_num?, call_back?) => {
			_default_value = default_value
			_step = step
			_min = min
			_max = max
			_show_num = show_num
			_call_back = call_back
			if (this.is_loaded && this.slider && this.slider.is_loaded) {
				this.slider.minimum = min
				this.slider.maximum = max
				this.slider.snapInterval = step
				this.slider.value = default_value
				this.SetValue(default_value)
			} else {
				this.need_refresh = true
			}
		}

		this.GetValue = () => {
			if (this.slider) {
				return this.slider.value
			}
		}

		// private SetMaxSlider() {
		//     if (_max == _min && _default_value >= _max) {
		//         _min = 0
		//         this.slider.track.touchEnabled = false
		//     }
		// }

		this.HideNumBtnAndNumBg = () => {
			if (this.is_loaded) {
				this.reduce_btn.visible = false
				this.increase_btn.visible = false
				this.value_bg.visible = false
			} else {
				_need_hide_btn = true
			}
		}

		this.SetCustomWidth = (width) => {
			if (this.is_loaded) {
				this.slider.SetCustomWidth(width)
			} else {
				_progress_width = width
			}
		}
		this.SetCustomHeight = (height?) => {
			if (this.is_loaded) {
				SetSizeDeltaY(this.display_obj, height)
			} else {
				_progress_height = height
			}
		}
	}

	public GetComponents() {
		[
			this.reduce_btn,
			this.increase_btn,
			this.slider_con
		]
			= this.GetChildrenByNames([
				"reduce_btn",
				"increase_btn",
				"slider_con"
			])
	}
}

export class SliderEvent {
	static LOAD_CONPLETE = "LOAD_CONPLETE";
	static CHANGE_SLIDER_VALUE="CHANGE_SLIDER_VALUE";
}
window["WithBtnHSlider"] = WithBtnHSlider