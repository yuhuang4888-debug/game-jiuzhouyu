import { BaseItem1 } from "../common/BaseItem1"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ClientConfig } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class ExchangeGiftView extends BaseItem1 {
	_bg1: Laya.Image
	_img_title: Laya.Image
	_lb_url: Laya.HTMLDivElement
	_lb_error: Laya.Label
	_btn_receive: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_ti_input: Laya.Image
	Placeholder: Laya.Label
	Text: Laya.Label
	_input_text:Laya.TextInput
	Emp_btn_receive
	InitEvent
	InitView
	Inp_ti_input
	LoadConfig
	Local_DeleteMe
	OutlabelDisplay
	_config
	preload_server_config

	public constructor(parent?) {
		super(parent)

		let id_list_ = []
		this.base_file = "exchange"
		this.layout_file = "ExchangeGiftView"
		this.is_load_res = false
		this._config = null
		this.preload_server_config = {
			"config_error_code":false
		}

		this.load_callback = () => {

			this.LoadConfig()
		}

		this.LoadConfig = () => {
			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_receive, () => {
				if (this._input_text.text != "") {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 15087, this._input_text.text)
				} else {
					Message.show("请输入兑换码")
				}
			}, this, true)

			this.BindEvent(GoodsModel.GetInstance(), EventName.EXCHANGEGIFT_ERROR, (vo?) => {
				if (vo.reward_list.length > 0) {
					let data = []
					for (let _tmpi in vo.reward_list) {
						var reward = vo.reward_list[_tmpi]
						let array = []
						array[0] = reward["style"]
						array[1] = reward["typeId"]
						array[2] = reward["count"]
						table.insert(data, array)
					}
					let view = new CongratulationObtainView(data, 10)
					view.Open()
					return
				}

				let cfgs = this.preload_server_config["config_error_code"] //Config.Errorcode
				if (cfgs) {
					let tmp = cfgs[Number(vo.res)]
					let str = "未知返回码 " + vo.res
					if (tmp) {
						str = tmp.about && tmp.about || tmp
					}
					this._lb_error.text = str
				}
				this._lb_error.visible = true

				let OnTimeOut = () => {
					if (!this.use_delete_method) {
						this._lb_error.visible = false
					}
				}
				let id = setTimeout(OnTimeOut, 2000)
				table.insert(id_list_, id)
			}
			)
		}

		this.InitView = () => {
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetIcon("exchange", "uifl_dhlb_003"), true)

			let name = ClientConfig.gift_wx_name
			let bool = name && name != ""
			if (bool) {
				this._lb_url.innerHTML = Util.StrToHTML("关注官方微信“<font color='#cf7000'>" + name + "</font>”(<font color='#cf7000'>微信号:" + ClientConfig.gift_wx_nmark + "</font>)了解最新消息和活动")
			}
			this._lb_url.visible = bool
			this._lb_url.x=360-this._lb_url.contextWidth/2
		}

		this.Local_DeleteMe = () => {
			if (id_list_.length > 0) {
				for (let _tmpi in id_list_) {
					var id = id_list_[_tmpi]
					clearTimeout(id)
				}
				id_list_ = []
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._bg1,
			this._img_title,
			this._lb_url,
			this._lb_error,
			this._btn_receive,
			this._Image1,
			this.labelDisplay,
			this._ti_input,
			this.Placeholder,
			this.Text,
			this._input_text,
		]
			= this.GetChildrenByNames([

				"_bg1",
				"_img_title",
				"_lb_url",
				"_lb_error",
				"_btn_receive",
				"_Image1",
				"labelDisplay",
				"_ti_input",
				"Placeholder",
				"Text",
				"_input_text",
			])
		this._lb_url.style.fontSize=22
		this._lb_url.style.color="#6a2717"
		this._lb_url.style.width=691
		this._lb_url.style.wordWrap=false
	}
}
window["ExchangeGiftView"]=ExchangeGiftView