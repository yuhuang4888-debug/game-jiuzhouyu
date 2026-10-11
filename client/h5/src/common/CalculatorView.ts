import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Mathf } from "../util/Mathf"
import { Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { EventName } from "./EventName"
import { Enum_UILayer } from "./LayerManager"

export class CalculatorView extends BaseView1 {
	public click_bg: Laya.Box;
	public root_wnd: Laya.Box;
	public _Image1: Laya.Image;
	public key_1: Laya.Box;
	public _Image2: Laya.Image;
	public _Label1: Laya.Label;
	public key_2: Laya.Box;
	public _Image3: Laya.Image;
	public _Label2: Laya.Label;
	public key_3: Laya.Box;
	public _Image4: Laya.Image;
	public _Label3: Laya.Label;
	public key_4: Laya.Box;
	public _Image5: Laya.Image;
	public _Label4: Laya.Label;
	public key_5: Laya.Box;
	public _Image6: Laya.Image;
	public _Label5: Laya.Label;
	public key_6: Laya.Box;
	public _Image7: Laya.Image;
	public _Label6: Laya.Label;
	public key_9: Laya.Box;
	public _Image8: Laya.Image;
	public _Label7: Laya.Label;
	public key_8: Laya.Box;
	public _Image9: Laya.Image;
	public _Label8: Laya.Label;
	public key_7: Laya.Box;
	public _Image10: Laya.Image;
	public _Label9: Laya.Label;
	public key_10: Laya.Box;
	public _Image11: Laya.Image;
	public _Label10: Laya.Label;
	public key_11: Laya.Box;
	public _Image12: Laya.Image;
	public _Label11: Laya.Label;
	public key_12: Laya.Box;
	public _Image13: Laya.Image;
	public _Label12: Laya.Label;

	LoadSuccess
	InitEvent
	SetPos
	OpenCallback
	InputNumKey
	AutoSetMaxNum
	BackKey
	Local_Open
	temp

	public constructor() {
		super()
		let local_Message = Message
		let max_count = 0
		let call_back = null
		let final_num = 0
		let mult_num = 10
		let input_number_list = null
		let real_pos = null
		let need_close_call_back = true
		let tips_type = null
		this.base_file = "common"
		this.layout_file = "CalculatorView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.is_center = true
		this.use_background = false
		this.change_scene_close = true
		this.show_open_movie = false
		let use_zero = false
		
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.close_callback = () => {
			if (need_close_call_back) {
				if (final_num == 0 && !use_zero) {
					call_back(1, true)
				} else {
					call_back(final_num, true)
				}
			}
			call_back = null
			max_count = 0
			final_num = 0
			input_number_list = null
			need_close_call_back = true
			GlobalEventSystem.Fire(EventName.CLOSE_CALCULATOR_VIEW)
		}

		this.destroy_callback = () => { }

		this.LoadSuccess = () => {
			input_number_list = []
			//SetAnchoredPosition(this.root_wnd, )
			// this.root_wnd.anchorOffsetX = this.root_wnd.width / 2
			// this.root_wnd.anchorOffsetY = this.root_wnd.height / 2
			if (this.is_loaded) {
				this.SetPos()
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.key_1, () => {
				this.InputNumKey(1)
			}
				, this, true)
			Util.AddClickEvent(this.key_2, () => {
				this.InputNumKey(2)
			}
				, this, true)
			Util.AddClickEvent(this.key_3, () => {
				this.InputNumKey(3)
			}
				, this, true)
			Util.AddClickEvent(this.key_4, () => {
				this.InputNumKey(4)
			}
				, this, true)
			Util.AddClickEvent(this.key_5, () => {
				this.InputNumKey(5)
			}
				, this, true)
			Util.AddClickEvent(this.key_6, () => {
				this.InputNumKey(6)
			}
				, this, true)
			Util.AddClickEvent(this.key_7, () => {
				this.InputNumKey(7)
			}
				, this, true)
			Util.AddClickEvent(this.key_8, () => {
				this.InputNumKey(8)
			}
				, this, true)
			Util.AddClickEvent(this.key_9, () => {
				this.InputNumKey(9)
			}
				, this, true)
			Util.AddClickEvent(this.key_10, () => {
				this.InputNumKey(0)
			}
				, this, true)
			Util.AddClickEvent(this.key_11, () => {
				this.BackKey()
			}
				, this, true)
			Util.AddClickEvent(this.key_12, () => {
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.click_bg, () => {
				this.Close()
			}
				, this)
		}

		this.Local_Open = (...new_args) => {
			[max_count, call_back, real_pos, need_close_call_back, tips_type, use_zero] = new_args
			if (need_close_call_back == null) {
				need_close_call_back = true
			}
			if (this.is_loaded) {
				this.SetPos()
			}
		}

		this.SetPos = () => {
			// if (real_pos) {
			// 	// SetAnchoredPosition(this.root_wnd, real_pos[0], -real_pos[1])
			// 	this.root_wnd.x = real_pos[0]
			// 	this.root_wnd.y = real_pos[1]
			// }

			if (real_pos) {
				this.root_wnd.x =  Laya.stage.width / 2+real_pos[0]
				this.root_wnd.y = Laya.stage.height / 2+real_pos[1]
			} else {
				this.root_wnd.x = Laya.stage.width / 2
				this.root_wnd.y = Laya.stage.height / 2
			}
		}

		this.OpenCallback = () => {

		}

		this.InputNumKey = (num) => {
			let number = final_num * mult_num + num
			if (number > max_count) {
				if (max_count) {
					if (tips_type){
						if (tips_type == 1)
						{
							local_Message.show("当前最多可合成" + max_count + "个")
						}
					}else{
						local_Message.show("超过上限 " + max_count)
					}
				} else {
					local_Message.show("超过上限")
				}
				this.AutoSetMaxNum(max_count)
				return
			}
			input_number_list.push(num)
			final_num = number

			if (final_num == 0 && !use_zero) {
				call_back(1)
			} else {
				call_back(final_num)
			}
		}

		this.AutoSetMaxNum = (num) => {
			input_number_list = []
			let max_mult = 100000
			let max_num = num
			let start_insert = false
			for (let i = 1; i <= 6; i++) {
				let input_num = max_num / max_mult
				if (input_num >= 1 || input_num == 0 || start_insert) {
					input_num = Mathf.Floor(input_num)
					max_num = max_num - (input_num * max_mult)
					input_number_list.push(input_num)
					start_insert = true
				}
				max_mult = max_mult / 10
			}

			final_num = num
			if (final_num == 0 && !use_zero) {
				call_back(1)
			} else {
				call_back(final_num)
			}
		}

		this.BackKey = () => {
			let lastNum = input_number_list[input_number_list.length - 1]
			if (lastNum != undefined) {
				final_num = (final_num - lastNum) / mult_num
				input_number_list.splice(input_number_list.length - 1, 1)
			} else {
				final_num = 0
			}
			if (final_num == 0 && !use_zero) {
				call_back(1)
			} else {
				call_back(final_num)
			}
		}


	}
	public Open(...new_args) {
		this.Local_Open(...new_args)
		super.Open()
	}

	public GetComponents() {
		[
			this.click_bg,
			this.root_wnd,
			this._Image1,
			this.key_1,
			this._Image2,
			this._Label1,
			this.key_2,
			this._Image3,
			this._Label2,
			this.key_3,
			this._Image4,
			this._Label3,
			this.key_4,
			this._Image5,
			this._Label4,
			this.key_5,
			this._Image6,
			this._Label5,
			this.key_6,
			this._Image7,
			this._Label6,
			this.key_9,
			this._Image8,
			this._Label7,
			this.key_8,
			this._Image9,
			this._Label8,
			this.key_7,
			this._Image10,
			this._Label9,
			this.key_10,
			this._Image11,
			this._Label10,
			this.key_11,
			this._Image12,
			this._Label11,
			this.key_12,
			this._Image13,
			this._Label12,
		]
			= this.GetChildrenByNames([

				"click_bg",
				"root_wnd",
				"_Image1",
				"key_1",
				"_Image2",
				"_Label1",
				"key_2",
				"_Image3",
				"_Label2",
				"key_3",
				"_Image4",
				"_Label3",
				"key_4",
				"_Image5",
				"_Label4",
				"key_5",
				"_Image6",
				"_Label5",
				"key_6",
				"_Image7",
				"_Label6",
				"key_9",
				"_Image8",
				"_Label7",
				"key_8",
				"_Image9",
				"_Label8",
				"key_7",
				"_Image10",
				"_Label9",
				"key_10",
				"_Image11",
				"_Label10",
				"key_11",
				"_Image12",
				"_Label11",
				"key_12",
				"_Image13",
				"_Label12",
			])
	}
}
window["CalculatorView"] = CalculatorView