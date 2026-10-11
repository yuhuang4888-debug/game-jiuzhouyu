import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel } from "../commonModel/GuildModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Trim, HtmlColorTxt, SetSizeDeltaY, Util, SetHtmlCenter } from "../util/Util"

export class GuildIdolRuneShowAttr extends BaseItem1 {
	LoadSuccess
	setData
	is_set
	public constructor(parent?) {
		super(parent)
		this.is_set=false
		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneShowAttr"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let type_id = null
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("guildidol", "uigh_091"), true)
			if (!this.is_set) {
				this.is_set=true
				this.setData(type_id)
			}
		}



		this.setData = (_type_id?) => {
			
			type_id = _type_id
			if (!this.is_loaded) {
				this.is_set=false
				return
			}else{
				this.is_set=true
			}
			
			this.PreHtml()
			let ph = 32
			if (!type_id) {
				this._lb_name.innerHTML = "未镶嵌"
				this._lb_attr.innerHTML = ""
				this._lb_attr.visible = false
			} else {
				this._lb_attr.visible = true
				let rune_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune
				let cfg = rune_cfg[type_id]
				let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (goods_vo) {
					this._lb_name.innerHTML = Util.HtmlColorTxt(Trim(goods_vo.goods_name), ColorUtil.GetColorDark(goods_vo.color))

				}
				if (cfg) {
					let attr_list = JSON.parse(cfg.attr)
					//ph = ph + (attr_list.length * 22 + (attr_list.length - 1) * 11)
					let attr_str = ''
					let index = 0
					for (let key in attr_list) {
						let attr = attr_list[key]
						index += 1
						let n = index == attr_list.length ? "" : "<br>"
						attr_str = attr_str + WordManager.GetProperties(attr[0]) + ":" + HtmlColorTxt(WordManager.ConvertToPercentValue(attr[0], attr[1]), "'#d85d03'") + " " + n
						
					}
					this._lb_attr.innerHTML = attr_str
					SetHtmlCenter(this._lb_attr,{x:0,w:this.display_obj.width})

					ph+=this._lb_attr.contextHeight+2
				}
			}
			SetSizeDeltaY(this.display_obj, ph)
			SetHtmlCenter(this._lb_name,{x:0,w:this.display_obj.width})
		}
	}

	PreHtml() {
		this._lb_name.style.color = "#ff6519"
		this._lb_name.style.fontSize = 20
		this._lb_name.width = 390

		this._lb_attr.style.color = "#663915"
		this._lb_attr.style.fontSize = 20
		this._lb_attr.width = 390
		
	}

	public DeleteMe(){
		super.DeleteMe()
	}

	_Group1: Laya.Box
	_bg: Laya.Image
	_lb_name: Laya.HTMLDivElement
	_lb_attr: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Group1,
			this._bg,
			this._lb_name,
			this._lb_attr,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_bg",
				"_lb_name",
				"_lb_attr",
			])
	}
}
window["GuildIdolRuneShowAttr"] = GuildIdolRuneShowAttr