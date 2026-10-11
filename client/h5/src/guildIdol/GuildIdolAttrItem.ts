import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { WordManager } from "../common/WordManager"
import { GuildModel } from "../commonModel/GuildModel"
import { HtmlColorTxt, SetHtmlCenter } from "../util/Util"

export class GuildIdolAttrItem extends BaseItem1 {
	LoadSuccess
	setData
	type=0

	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolAttrItem"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let _data = null
		let _refresh = false
		let _showAdd = false
		let _color = "'#c8872a'"

		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			if (_refresh) {
				_refresh = false
				this.setData(_data, _showAdd, _color)
			}
		}

		this.setData = (data?, showAdd?, color?) => {
			if (color == null) {
				color = this.type==0?"'#d85d03'":"'#0a953e'"
			}
			_data = data
			_showAdd = showAdd
			_color = color
			if (!this.is_loaded) {
				_refresh = true
				return
			}
			this.PreHtml()
			this._lb_desc.innerHTML = WordManager.GetProperties(_data[0]) + (" + ") + HtmlColorTxt(WordManager.ConvertToPercentValue(_data[0], _data[1]), color)
			//SetHtmlCenter(this._lb_desc, { x: 0, w: 150 })
			this._img_add.visible = showAdd
		}


	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public SetType(type?){
		this.type=type?type:0
	}

	PreHtml() {
		this._lb_desc.style.fontSize = 20
		this._lb_desc.style.color = "#663915"
		this._lb_desc.width = 180
	}


	_lb_desc: Laya.HTMLDivElement
	_img_add: Laya.Image
	public GetComponents() {
		[
			this._lb_desc,
			this._img_add,
		]
			= this.GetChildrenByNames([

				"_lb_desc",
				"_img_add",
			])
	}
}
window["GuildIdolAttrItem"] = GuildIdolAttrItem