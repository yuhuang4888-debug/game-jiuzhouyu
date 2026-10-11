import { BaseItem1 } from "../common/BaseItem1"
import { UnrealModel } from "../commonModel/UnrealModel"
import { Util } from "../util/Util"

export class UnrealNextAttrItem extends BaseItem1 {


	private model: UnrealModel
	data
	need_refresh_data
	public constructor(parent) {
		super(parent)
		this.base_file = "unreal"
		this.layout_file = "UnrealNextAttrItem"
		this.model = UnrealModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	private async LoadSuccess() {

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	private InitEvent() {

	}

	public SetData(data) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		}
		else {
			this.need_refresh_data = true
		}
	}

	private UpdateView() {
		if (this.data) {
			this._lb_attr.style.fontSize = 24
			this._lb_attr.width = 244
			let color_str = this.data.kind != 1 ? "#8400FF" : "#663915"
			this._lb_attr.style.color = color_str
			this._lb_attr.innerHTML = Util.StrToHTML(`${this.data.desc}:<font color='#d85d03'>${this.data.value}</font>`)
		}
	}

	private StartAction() {
		// this.AddUIEffect("ui_refresh_glow", this._gp_effect, { x: 100, y: 0 }, null, false, null, null, null, null, true)
		Laya.Tween.clearAll(this._lb_attr)
		Laya.Tween.to(this._lb_attr, { alpha: 0 }, 300, undefined, Laya.Handler.create(this, ()=>{
			Laya.Tween.to(this._lb_attr, { alpha: 1 }, 300, undefined)
		}))
	}

	public DeleteMe() {
		if (this._lb_attr)
		Laya.Tween.clearAll(this._lb_attr)
		this.ClearUIEffect(this._gp_effect)
		super.DeleteMe()
	}
	

	_lb_attr: Laya.HTMLDivElement
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this._lb_attr,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"_lb_attr",
				"_gp_effect",
			])
	}
}
window["UnrealNextAttrItem"] = UnrealNextAttrItem