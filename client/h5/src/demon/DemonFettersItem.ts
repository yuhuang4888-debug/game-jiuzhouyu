import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { DemonEvent } from "../commonModel/DemonEvent"
import { DemonModel } from "../commonModel/DemonModel"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, SetAnchoredPosition, HtmlColorTxt, Util, SetHtmlStyle, SetHtmlCenter } from "../util/Util"
import { DemonFettersHeadItem } from "./DemonFettersHeadItem"

export class DemonFettersItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_img_activation: Laya.Image
	_Image1: Laya.Image
	_lb_attr: Laya.HTMLDivElement
	_gp_head_con: Laya.HBox


	demon_model
	head_item_list
	res_mgr: ResManager


	public constructor() {
		super()
		// this.skinName = "resource/game/demon/exml/DemonFettersItemExml.exml"
		this.base_file="demon"
		this.layout_file="DemonFettersItem"
		this.WIDTH=485
		this.HEIGT=209
		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren()		
	}
	public load_callback(){
		SetHtmlStyle(this._lb_desc,{f:22,c:"#663915",ww:false,w:440})
		SetHtmlStyle(this._lb_attr,{f:20,c:"#663915",ww:false,w:440})

		this.BindEvent(this.demon_model, DemonEvent.UPDATE_FETTERS_DATA, () => {
			this.UpdateActivationState()
		})

		// this.res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIcon("demon", "uism_057"))
		//this.res_mgr.SetOutsideImageSprite(this,this._img_bg, GameResPath.GetIcon("demon", "uism_057"))
	}

	public dataChanged() {
		if (!super.dataChanged()) return

		this.UpdateActivationState()

		let desc = HtmlColorTxt("【" + this.data.fetters_name + "】", "'#fe6b25'")
		desc = desc + "激活"

		let demons_ids = JSON.parse(this.data.demons_ids)
		let len = demons_ids.length

		if (!this.head_item_list) {
			this.head_item_list = []
		}

		for (let i = len; i < this.head_item_list.length; i++) {
			this.head_item_list[i].visible = false
		}

		let item = null
		let demons_id = null
		let demons_cfg = null
		for (let key in demons_ids) {
			demons_id = Number(demons_ids[key])
			item = this.head_item_list[key]
			if (!item) {
				item = new DemonFettersHeadItem(this._gp_head_con)
				item.Load()
				this.head_item_list[key] = item
			}
			let demons_cfgs = this.res_mgr.GetGameConfigFromCache(this.res_mgr, "config_demons", false)
			demons_cfg = demons_cfgs && demons_cfgs[demons_id]
			desc = desc + HtmlColorTxt(demons_cfg.demons_name, ColorUtil.GetColorDark(demons_cfg.color))

			if (len - 1 > Number(key)) {
				desc = desc + "、"
			}
			item.SetData(demons_cfg)
			item.visible = true
		}
		this._lb_desc.width=450
		this._lb_desc.innerHTML = Util.StrToHTML(desc)

		let attr_desc = ""
		let attr_data = JSON.parse(this.data.attr)
		for (let _tmpi in attr_data) {
			let vo = attr_data[_tmpi]
			attr_desc = attr_desc + WordManager.GetProperties(vo[0])+": "
			attr_desc = attr_desc + HtmlColorTxt(  WordManager.ConvertToPercentValue(vo[0], vo[1]) , "'#0a953e'") +"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
		}
		this._lb_attr.innerHTML = attr_desc
		SetHtmlCenter(this._lb_attr,{x:0,w:475})
	}

	public UpdateActivationState() {
		let bool = false
		if (this.data) {
			bool = this.demon_model.GetFettersState(this.data.fetters_id)
		}
		this._img_activation.visible = bool
	}

	public DeleteMe() {
		if (this.head_item_list) {
			for (let _tmpi in this.head_item_list) {
				let obj = this.head_item_list[_tmpi]
				if (obj) {
					obj.DeleteMe()
				}
			}
			this.head_item_list = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_bg,
			this._lb_desc,
			this._img_activation,
			this._Image1,
			this._lb_attr,
			this._gp_head_con,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_desc",
				"_img_activation",
				"_Image1",
				"_lb_attr",
				"_gp_head_con",
			])
	}
}
window["DemonFettersItem"]=DemonFettersItem