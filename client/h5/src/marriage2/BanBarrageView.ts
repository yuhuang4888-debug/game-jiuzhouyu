import { Enum_UILayer } from "../common/LayerManager"
import { BaseView1 } from "../common/BaseView1"
import { Message } from "../sysInfo/SysInfoController"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { Trim, Util } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { GameResPath } from "../util/GameResPath"
import { ResManager } from "../common/ResManager"

export class BanBarrageView extends BaseView1 {
	InitInfo
	// textDisplay
	OverCharLimit
	Founce
	Founce2
	_char_limit
	background_alpha
	change_scene_close
	click_bg_toClose
	horizontalCenter
	send
	show_open_movie
	use_background
	verticalCenter

	public constructor() {
		super()


		this._char_limit = 25;
		this.base_file = "marriage2"
		this.layout_file = "BanBarrageView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.is_center = true

		this.background_alpha = 0
		this.click_bg_toClose = true
		this.destroy_imm = true
		// this.horizontalCenter = 0
		// this.verticalCenter = 200
		// this.show_open_movie = true
		this.change_scene_close = true
		let local_Message = Message
		let local_BanqEvent = BanqEvent
		this.load_callback = () => {

			this.InitInfo()
			// 		if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 			let csf = this.labelDisplay.GetComponent("ContentSizeFitter")
			// 			csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 			SetSizeDeltaX(this.labelDisplay,130)
			// 			this.labelDisplay.verticalAlign = "top"
			// this.labelDisplay.textAlign = "center"
			// 			this.labelDisplay.lineSpacing = 0.6
			// 		}
		}

		this.InitInfo = () => {
			let banModel = BanquetModel.GetInstance()
			ResManager.GetInstance().SetTexture(this, this._Image2, GameResPath.GetIcon("marriage2", "uijh_118"))

			this.textDisplay.on(Laya.Event.INPUT, this, this.OverCharLimit);
			this.textDisplay.on(Laya.Event.FOCUS, this, this.Founce);
			this.textDisplay.on(Laya.Event.BLUR, this, this.Founce2);

			// this.textDisplay.onValueChanged.AddListener(() => {
			// 	this.OverCharLimit()
			// })
			//this.textDisplay.characterLimit = this._char_limit 
			let func = () => {
				let inputStr = this.textDisplay.text
				if (inputStr && Trim(inputStr) != "") {
					let len = this.textDisplay.text.length;//Language.GetStringLength(inputStr, 1)
					if (len > this._char_limit) {
						local_Message.show("长度不能超过25个字")
					} else {
						banModel.Fire(local_BanqEvent.REQUET_PROTO, 17270, "si", inputStr, 0)
					}
				} else {
					local_Message.show("内容不能为空")
				}
			}

			Util.AddClickEvent(this.sendBtn, () => {
				func()
			}
				, this, true)
			Util.AddClickEvent(this.radomBtn, () => {
				let cfg = banModel.ClientCfg
				if (cfg) {
					let list = cfg.bless
					if (list) {
						let i = Math.floor(Math.random() * list.length)
						this.textDisplay.text = list[i]
						this._inputTip.visible=false
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			this.BindEvent(banModel, local_BanqEvent.BARRIAGE_SUCCESS, () => {
				this.textDisplay.text = ''
			}
			)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.BG1, GameResPath.GetIcon("marriage", "uijh_133"))
		}

		this.OverCharLimit = () => {
			let inputStr = this.textDisplay.text
			this._inputTip.visible=true
			if (inputStr && Trim(inputStr) != "") {
				this._inputTip.visible=false
				let len = this.textDisplay.text.length;//Language.GetStringLength(inputStr, 1)
				if (len > this._char_limit) {
					local_Message.show("弹幕不能超过" + this._char_limit + "个字")
				}
			}
		}


		this.Founce=()=>{
			this._inputTip.alpha=0.3
		}

		this.Founce2=()=>{
			this._inputTip.alpha=1
		}


		this.destroy_callback=()=>{
			this.textDisplay.off(Laya.Event.INPUT, this, this.OverCharLimit);
			this.textDisplay.off(Laya.Event.FOCUS, this, this.Founce);
			this.textDisplay.off(Laya.Event.BLUR, this, this.Founce2);
		}
	}

	public Open(...new_args) {
		super.Open()
		// this.Local_Open(new_args)
	}



_Image2:Laya.Image
_Image3:Laya.Image
radomBtn:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
sendBtn:Laya.Box
_Image1111:Laya.Image
labelDisplay1:Laya.Label
input:Laya.Box
textDisplay:Laya.TextInput
_inputTip:Laya.Label
closeBtn:Laya.Image
public GetComponents() {
[
this._Image2,
this._Image3,
this.radomBtn,
this._Image1,
this.labelDisplay,
this.sendBtn,
this._Image1111,
this.labelDisplay1,
this.input,
this.textDisplay,
this._inputTip,
this.closeBtn,
]
 = this.GetChildrenByNames([

"_Image2",
"_Image3",
"radomBtn",
"_Image1",
"labelDisplay",
"sendBtn",
"_Image1111",
"labelDisplay1",
"input",
"textDisplay",
"_inputTip",
"closeBtn",
])
}
}
 window["BanBarrageView"]= BanBarrageView