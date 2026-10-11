import { BaseItem1 } from "../common/BaseItem1"
import { InstructionView } from "../common/InstructionView"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class TestActRecharge extends BaseItem1 {
	tltle: Laya.Image
	effect: Laya.Box
	recharge_des: Laya.Box
	_lb_recharge: Laya.HTMLDivElement
	go_btn: Laya.Box
	_lb_desc: Laya.HTMLDivElement
	des_bg: Laya.Image
	_lb_return: Laya.HTMLDivElement
	_btn_ques: Laya.Image
	_img_good: Laya.Image
	_lb_desc2: Laya.HTMLDivElement
	_lb_desc3: Laya.HTMLDivElement

	LoadSuccess
	InitView
	InitEvent
	RefreshNum
	tween_id
	cfg_finish
	SetData
	info

	public constructor(parent) {
		super(parent)

		let _instruction_view
		let _util = Util,
			model = CustomActivityModel.GetInstance()

		this.base_file = "testAct"
		this.layout_file = "TestActRecharge"
		this.cfg_finish = false

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.InitView()
			this.InitEvent()
		}

		this.InitView = () => {

			//展示 
			// ResManager.GetInstance().SetTexture(this, this._img_good, "resource/game/testAct/texture/uifcxl_018b.png")
			this._lb_desc.innerHTML = "公测使用同账号创建角色登录，"
			this._lb_desc2.innerHTML = "返利通过邮件自动发送至对应角色"
			this._lb_desc3.innerHTML = _util.StrToHTML(`${_util.HtmlColorTxt("（仅首个角色享受返还）", Enum_ColorUtil_Dark.GREEN)}`)
			this.tween_id = SYTweenLite.to(this, this._img_good, SYTweenLite.UiAnimationType.POSY, this._img_good.y - 10, 1.5, null, SYTweenFunc.PINGPONG, true)
		}

		this.InitEvent = () => {

			_util.AddClickEvent(this._btn_ques, () => {
				//说明
				if (!_instruction_view)
					_instruction_view = new InstructionView()
				_instruction_view.Open(33177)
			}, this, false)

			_util.AddClickEvent(this.go_btn, () => {
				OpenFun.OpenFunHandler(21)
			}, this, true)

			this.BindEvent(model, CustomActivityDefine.EVENT.UP_BETA_RECHARGE, (scmd) => {
				if (scmd) {
					this.RefreshNum(scmd)
				}
			})

			this.BindEvent(model, CustomActivityDefine.EVENT.RECHARGE_SUCCESS, () => {
				model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33216)
			})
			model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33216)
		}

		this.SetData = (info?) => {
            this.info = info
        }

		this.RefreshNum = (scmd) => {

			let gold = scmd.gold
			this._lb_recharge.innerHTML = _util.StrToHTML(`已经充值<font color = '#19ae4a'>${gold}</font>勾玉`)
			this._lb_recharge.x = 261 / 2 - this._lb_recharge.contextWidth / 2 +10
			this._lb_recharge.y = 66 / 2 - this._lb_recharge.contextHeight / 2 - 8
			let str
			if (gold > 0) {
				if(this.info){
					str = _util.StrToHTML(`可返还：<font color = '#00fa64'>${gold * this.info}</font>勾玉+<font color = "#00fa64">${gold * this.info}</font>绑玉`)
				}else{
					str = _util.StrToHTML(`可返还：<font color = '#00fa64'>${gold}</font>勾玉+<font color = "#00fa64">${gold}</font>绑玉`)
				}
				this._lb_return.innerHTML = str
			} else {
				str = `暂未充值勾玉`
				this._lb_return.innerHTML = str
			}
			this._lb_return.x = 345 / 2 - this._lb_return.contextWidth / 2
			this._lb_return.y = 34 / 2 - this._lb_return.contextHeight / 2
		}

		this.DeleteMe = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
				this.tween_id = null
			}
			if (_instruction_view)
				_instruction_view = null
			super.DeleteMe()
		}
	}

	public GetComponents() {
		[
			this.tltle,
			this.effect,
			this.recharge_des,
			this._lb_recharge,
			this.go_btn,
			this._lb_desc,
			this.des_bg,
			this._lb_return,
			this._btn_ques,
			this._img_good,
			this._lb_desc2,
			this._lb_desc3
		]
			= this.GetChildrenByNames([

				"tltle",
				"effect",
				"recharge_des",
				"_lb_recharge",
				"go_btn",
				"_lb_desc",
				"des_bg",
				"_lb_return",
				"_btn_ques",
				"_img_good",
				"_lb_desc2",
				"_lb_desc3",
			])
		this._lb_recharge.style.fontSize = 22
		this._lb_recharge.style.color = "#9E3838"
		this._lb_recharge.style.wordWrap = false
		this._lb_return.style.fontSize = 22
		this._lb_return.style.color = "#ffffff"
		this._lb_return.style.wordWrap = false
		this._lb_desc.style.fontSize = 22
		this._lb_desc.style.color = "#6D603C"
		this._lb_desc.style.wordWrap = false
		this._lb_desc2.style.fontSize = 22
		this._lb_desc2.style.color = "#7f623c"
		this._lb_desc2.style.wordWrap = false
		this._lb_desc3.style.fontSize = 22
		this._lb_desc3.style.color = "#7f623c"
		this._lb_desc3.style.wordWrap = false
	}
}
window["TestActRecharge"] = TestActRecharge