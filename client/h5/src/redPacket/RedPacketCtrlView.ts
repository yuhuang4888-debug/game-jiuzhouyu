import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { RedPacketEvent, RedPacketModel } from "../commonModel/RedPacketModel"
import { SpecialCharKey } from "../common/SpecialCharKey"

export class RedPacketCtrlView extends BaseView1 {
	Clear
	InitEvent
	LoadSuccess
	Local_Open
	OpenCalculatorView
	OpenDiamondCalculatorView
	SetCount
	SetMoney
	UpdateView
	click_bg_toClose
	destroy_callback
	destroy_imm
	//input_et_bless
	is_center
	open_callback
	preload_server_config
	use_background
	InputChanged

	public constructor() {
		super()

		this.base_file = "redPacket"
		this.layout_file = "RedPacketCtrlView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		let _model = RedPacketModel.GetInstance()

		let common_mgr = CommonManager.GetInstance()
		let local_Util = Util
		let local_Message = Message
		let REQUEST_PROTO = RedPacketEvent.REQUEST_PROTO
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let _rp_data_ = null
		let _data_ = null
		let _cur_num_ = 1
		let _cur_money_ = 1
		let _max_ = 0
		let _min_ = 0
		let _bless_max_ = null
		let _money_max_ = null
		let _cal_type_ = null
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.destroy_callback = () => {
			this.Clear()
			this._et_bless.off(Laya.Event.INPUT, this, this.InputChanged)
		}

		this.preload_server_config = { "config_red_envelopes": false }
		this.Local_Open = (parms?) => {
			_rp_data_ = parms
			super.Open()
			//super.Open(this)
		}

		this.Clear = () => {

		}

		this.LoadSuccess = () => {

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_012, GameResPath.GetIcon("redPacket", "uighhb_012"), true)
			_bless_max_ = common_mgr.GetValue(3390005) || 8
			this._et_bless.maxChars = _bless_max_
			this.InitEvent()
		}

		this.InputChanged = () => {
			this.Text11.text=`(${this._et_bless.textField.text.length}/${_bless_max_})`
		}


		this.InitEvent = () => {
			this._et_bless.on(Laya.Event.INPUT, this, this.InputChanged)

			Util.AddClickEvent(this._btn_send, () => {
				if (!_rp_data_) {
					return
				}
				if (_cur_num_ <= 0) {
					local_Message.show("红包个数不能少于0")
					return
				}
				if (_cur_money_ < _cur_num_) {
					local_Message.show("红包金额不能少于红包个数")
					return
				}
				if (_rp_data_.type == 100) {
					let msg = this._et_bless.text
					if (msg == "") {
						// msg = this.input_et_bless.prompt
						msg = "恭喜发财，大吉大利"
					}
					_model.Fire(REQUEST_PROTO, 33906, "ihs", _cur_money_, _cur_num_, msg)
				} else {
					_model.Fire(REQUEST_PROTO, 33904, "lh", _rp_data_.id, _cur_num_)
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_sub, () => {
				let tar = _cur_num_ - 1
				if (tar < _min_) {
					local_Message.show("已达到最小个数")
					return
				}
				_cur_num_ = _cur_num_ - 1
				this._lb_count.text = _cur_num_ + ""
			}
				, this, true)
			Util.AddClickEvent(this._btn_add, () => {
				let tar = _cur_num_ + 1
				if (tar > _max_) {
					local_Message.show("已达到最大个数")
					return
				}
				_cur_num_ = _cur_num_ + 1
				this._lb_count.text = _cur_num_ + ""
			}
				, this, true)
			Util.AddClickEvent(this._lb_count, () => {
				this.OpenCalculatorView()
			}
				, this, true)
			Util.AddClickEvent(this._lb_diamond, () => {
				this.OpenDiamondCalculatorView()
			}
				, this, true)
			this.BindEvent(local_GlobalEventSystem, local_EventName.CLOSE_CALCULATOR_VIEW, () => {
				if (_cal_type_ == 1) {
					if (_cur_num_ < _min_) {
						local_Message.show("红包个数不能少于" + _min_ + "个")
						this.SetCount(_min_)
					} else if (_cur_num_ > _max_) {
						local_Message.show("红包个数不能多于结社人数上限")
						this.SetCount(_max_)
					} else if (_cur_money_ < _cur_num_) {
						local_Message.show("红包金额不能少于红包个数")
						this.SetCount(_cur_money_)
					}
				} else if (_cal_type_ == 2) {
					if (_money_max_ < _cur_money_) {
						local_Message.show("红包金额不可超过" + _money_max_ + "勾玉")
						this.SetMoney(_money_max_)
					} else if (_cur_money_ < _cur_num_) {
						local_Message.show("红包金额不能少于红包个数")
						this.SetMoney(_cur_num_)
					}
				}
			}
			)
		}

		this.UpdateView = () => {
			if (!_rp_data_) {
				return
			}
			if (_rp_data_.type == 100) {
				_max_ = _model.GetMaxCount()
				let bless: string = common_mgr.GetValue(3390009)
				let num = common_mgr.GetValue(3390007)
				_money_max_ = Number(common_mgr.GetValue(3390010))
				_min_ = Number(num)
				_cur_num_ = Number(num)
				this._lb_count.text = num
				_cur_money_ = num
				this._lb_diamond.text = num
				this._lb_money.text = num
				bless = bless.replace(SpecialCharKey.RedPacketCtrlView1, "")
				this._et_bless.text = bless
				ResManager.GetInstance().SetImageSprite(this, this._img_money, "common_asset", "com_diamond", true)
				this._gp_ctrl.visible = true
				this._lb_tips.text = ""
			} else {
				let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_red_envelopes", false)
				//let config = Config.Redenvelopes
				let data = _model.GetRedPacketData(_rp_data_.extra, config)
				if (!data) {
					return
				}
				_data_ = data
				_cur_num_ = data.min_num
				this._lb_count.text = data.min_num
				_min_ = data.min_num
				_max_ = _model.GetMaxCount()
				this._et_bless.text = data.greetings
				this._lb_money.text = data.money
				ResManager.GetInstance().SetImageSprite(this, this._img_money, "common_asset", "com_bind_diamond", true)
				this._gp_ctrl.visible = false
				this._lb_tips.text = "红包金额" + data.money + "绑玉"
				_cur_money_ = data.money
			}
			this.InputChanged()
		}

		this.OpenCalculatorView = () => {
			let pos = [0, -50]
			let change_func = (value?) => {
				this.SetCount(value)
			}

			local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, 9999, change_func, pos)
			_cal_type_ = 1
			this.SetCount(0)
		}

		this.OpenDiamondCalculatorView = () => {
			let pos = [0, -100]
			let change_func = (value?) => {
				this.SetMoney(value)
			}

			local_GlobalEventSystem.Fire(local_EventName.OPEN_CALCULATOR_VIEW, 9999, change_func, pos)
			_cal_type_ = 2
			this.SetMoney(0)
		}

		this.SetCount = (num?) => {
			// if (!IsNull(this.gameObject)) {
			// 	this._lb_count.text = num
			// 	_cur_num_ = num
			// }
			this._lb_count.text = num
			_cur_num_ = num
		}

		this.SetMoney = (money?) => {
			// if (!IsNull(this.gameObject)) {
			// 	_cur_money_ = money
			// 	this._lb_money.text = money
			// 	this._lb_diamond.text = money
			// 	LayoutRebuilder(this._Group1)
			// }
			_cur_money_ = money
			this._lb_money.text = money
			this._lb_diamond.text = money
		}


	}

	public Open(parms?) {

		this.Local_Open(parms)
	}



	_img_012: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_btn_sub: Laya.Image
	_btn_add: Laya.Image
	_btn_send: Laya.Image
	_lb_tips: Laya.Label
	_Label1: Laya.Label
	_lb_count: Laya.Label
	_et_bless: Laya.TextInput
	Text11: Laya.Label
	_Group1: Laya.HBox
	_lb_money: Laya.Label
	_img_money: Laya.Image
	_gp_ctrl: Laya.Box
	_Image4: Laya.Image
	_Label2: Laya.Label
	_lb_diamond: Laya.Label
	public GetComponents() {
		[
			this._img_012,
			this._Image1,
			this._Image2,
			this._Image3,
			this._btn_sub,
			this._btn_add,
			this._btn_send,
			this._lb_tips,
			this._Label1,
			this._lb_count,
			this._et_bless,
			this.Text11,
			this._Group1,
			this._lb_money,
			this._img_money,
			this._gp_ctrl,
			this._Image4,
			this._Label2,
			this._lb_diamond,
		]
			= this.GetChildrenByNames([

				"_img_012",
				"_Image1",
				"_Image2",
				"_Image3",
				"_btn_sub",
				"_btn_add",
				"_btn_send",
				"_lb_tips",
				"_Label1",
				"_lb_count",
				"_et_bless",
				"Text11",
				"_Group1",
				"_lb_money",
				"_img_money",
				"_gp_ctrl",
				"_Image4",
				"_Label2",
				"_lb_diamond",
			])
	}
}
window["RedPacketCtrlView"] = RedPacketCtrlView