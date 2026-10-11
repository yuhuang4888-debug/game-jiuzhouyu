import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { FunctionOpenModel } from "../commonModel/FunctionOpenModel";
import { GameResPath } from "../util/GameResPath";
import { SetHtmlCenter, Util } from "../util/Util";

export class FunctionOpenTipView extends BaseView1 {

	LoadSuccess
	Local_Open
	InitEvent
	SetFuncIcon
	public constructor() {
		super();
		this.base_file = "functionOpen";
		this.layout_file = "FunctionOpenTipView";
		this.layer_value = Enum_UILayer.Activity;
		let model = FunctionOpenModel.GetInstance(),
			local_Util = Util,
			data_,
			item_list_
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.not_show_main_msg = true
		this.destroy_imm = true
		this.load_callback = function () {
			this.LoadSuccess();
			this.InitEvent();
		}
		this.open_callback = function () {
			this.SetFuncIcon()
		}
		this.destroy_callback = function () {
			for (let obj of item_list_) {
				obj.DeleteMe()
			}
			item_list_ = null
		}
		this.LoadSuccess = () => {
			this._Scroller1.vScrollBar.visible = false
			item_list_ = []
		}

		this.Local_Open = (parms) => {
			[data_] = parms
			super.Open()
		}

		this.InitEvent = () => {
			local_Util.AddClickEvent(this.close_btn, () => {
				this.Close();
			}, this, true);
		}

		this.SetFuncIcon = () => {
			if (data_) {
				ResManager.GetInstance().SetImageSprite(this,this.icon,"functionOpen",data_.icon)
				//ResManager.GetInstance().SetTexture(this, this.icon, GameResPath.GetFuncOpenIconPath(data_.icon))
				this.tips.style.fontSize = 20
				this.tips.style.color = "#663915"
				this.tips.width = 279
				this.tips.style.wordWrap = true
				this.tips.style.leading = 8

				this.tips.innerHTML = local_Util.StrToHTML(data_.desc)
				this.tips.height = this.tips.contextHeight + 10
				SetHtmlCenter(this.tips, { "x": 11, "w": 279 })


				let txt = local_Util.DeleteColorTag(String(data_.simple_con).replace("<br/>", ""))
				this.condition.style.fontSize = 20
				this.condition.style.color = "#6c80e9"
				this.condition.width = 300
				this.condition.style.wordWrap = true
				this.condition.style.leading = 8
				this.condition.innerHTML = local_Util.StrToHTML(txt)
				SetHtmlCenter(this.condition, { "x": 13, "w": 300 })
			}
		}
	}


	public Open(...parms) {
		this.Local_Open(parms)
	}
	

	bg: Laya.Image
	close_btn: Laya.Image
	iconbg: Laya.Image
	icon: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.Box
	tips: Laya.HTMLDivElement
	_Image1: Laya.Image
	_Image2: Laya.Image
	condition: Laya.HTMLDivElement
	line: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.close_btn,
			this.iconbg,
			this.icon,
			this._Scroller1,
			this.Content,
			this.tips,
			this._Image1,
			this._Image2,
			this.condition,
			this.line,
		]
			= this.GetChildrenByNames([

				"bg",
				"close_btn",
				"iconbg",
				"icon",
				"_Scroller1",
				"Content",
				"tips",
				"_Image1",
				"_Image2",
				"condition",
				"line",
			])
	}
}
window["FunctionOpenTipView"] = FunctionOpenTipView