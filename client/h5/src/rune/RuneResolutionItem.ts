import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { RuneModel } from "../commonModel/RuneModel";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { HtmlColorTxt, SetHtmlCenter, Util } from "../util/Util";


export class RuneResolutionItem extends BaseItemRenderer {
	public WIDTH = 198
	public HEIGT = 274

	private _model: RuneModel;

	public constructor() {
		super()
		this.base_file = "rune"
		this.layout_file = "RuneResolutionItem"
		this._model = RuneModel.GetInstance()
		this.Load()
	}

	public createChildren() {
		super.createChildren()

	}

	public load_callback() {
		this.InitEvent()
	}


	private InitEvent() {
		Util.AddClickEvent(this._img_click, () => {
			let bool = !this._group_select.visible
			if (bool) {
				if (this._model.disSelectNum >= RuneModel.MaxDecNum) {
					Message.show(`每次最多可拆解${RuneModel.MaxDecNum}个御魂`)
					return
				} else {
					this._model.disSelectNum++
				}
			} else {
				this._model.disSelectNum--
			}
			this.setSelect(bool);
		}, this);
	}

	DeleteMe() {
		super.DeleteMe()
	}

	protected dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data
		this._lb_name.text = `${data.goods_name}`
		let color = (data.subtype == 26 || data.subtype == 27) && data.color == 5? 6: data.color
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/runeCard/" + data.type_id + ".png")
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_kuang, "resource/game/runeCard/icon_kp_0" + color + ".png")
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_iconbg, "resource/game/runeCard/icon_kpbg_0" +color + ".png")
		ResManager.GetInstance().SetImageSprite(this, this._img_color, "rune", "color_" + color)

		let awake_lv = 0;
		for (let key in data.awake_list) {
			let info = data.awake_list[key];
			if (info.awake_lv > awake_lv) {
				awake_lv = info.awake_lv;
			}
		}
		this._img_awaken.visible = awake_lv > 0;

		this._lb_attr0.style.fontSize = 20
		this._lb_attr1.style.fontSize = 20
		this._lb_attr1.style.color = "#663915"
		this._lb_attr0.style.color = "#663915"
		this._lb_attr1.width = 160
		this._lb_attr0.width = 160
		if (data.subtype == 99) {
			this._lb_attr0.visible = true
			this._lb_attr1.visible = false
			this._lb_attr0.innerHTML = Util.StrToHTML(data.soul_intro)
			this._img_lv_bg.visible = false;
		}
		else {
			this._img_lv_bg.visible = true
			ResManager.GetInstance().SetImageSprite(this, this._img_lv_bg, "rune", "rune_lv_bg_00" + color)
			// let rune_awake_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_wake_up", false)
			let rune_awake_cfg = this._model.GetWakeUpCfg()
			let attr_list = this._model.GetRuneAttr(data.subtype, data.level, data.color)
			let awakeList = {}
			for (let vo of data.awake_list) {
				let cfg = rune_awake_cfg[`${data.color}@${vo.attr_type}@${vo.awake_lv}`]
				if (cfg) {
					let add = JSON.parse(cfg.attr)
					if (add[0]) {
						add = add[0]
						awakeList[add[0]] = add[1]
					}
				}
			}
			for (let i = 0; i < 2; i++) {
				let attr = attr_list[i]
				this[`_lb_attr${i}`].visible = !!attr
				if (attr) {
					let value = WordManager.ConvertToPercentValue(attr[0], attr[1] + (awakeList[attr[0]] || 0))
					let str = Util.HtmlColorTxt(value, "'#d15e00'")
					let name = WordManager.GetProperties(attr[0])
					this[`_lb_attr${i}`].innerHTML = Util.StrToHTML(`${name}：${str}`)
				}
			}
		}
		SetHtmlCenter(this._lb_attr0, {x:0, w:176})
		SetHtmlCenter(this._lb_attr1, {x:0, w:176})

		this._lb_lv.text = data.subtype == 99? "": `Lv.${data.level}`
		let txtColor = color == 6? 7: color
		let color_str = ColorUtil.GetColorDark(txtColor, false)
		this._lb_lv.strokeColor = this._lb_name.strokeColor = color_str;

		this.setSelect(this._model._resolutionDic[this.index] != undefined);
	}

	private setSelect(bool) {
		this._group_select.visible = bool;
		if (bool)
			this._model.addResolutionDic(this.data, this.index);
		else
			this._model.delResolutionDic(this.index);
	}
	_Image1: Laya.Image
	_img_iconbg: Laya.Image
	_img_icon: Laya.Image
	_img_kuang: Laya.Image
	_lb_name: Laya.Label
	_lb_lv: Laya.Label
	_lb_attr1: Laya.HTMLDivElement
	_lb_attr0: Laya.HTMLDivElement
	_img_awaken: Laya.Image
	_group_select: Laya.Box
	_Image3: Laya.Image
	_Image4: Laya.Image
	_img_click: Laya.Image
	_img_color: Laya.Image
	_img_lv_bg:Laya.Image

	public GetComponents() {
		[
			this._Image1,
			this._img_iconbg,
			this._img_icon,
			this._img_kuang,
			this._lb_name,
			this._lb_lv,
			this._lb_attr1,
			this._lb_attr0,
			this._img_awaken,
			this._group_select,
			this._Image3,
			this._Image4,
			this._img_click,
			this._img_color,
			this._img_lv_bg
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_iconbg",
				"_img_icon",
				"_img_kuang",
				"_lb_name",
				"_lb_lv",
				"_lb_attr1",
				"_lb_attr0",
				"_img_awaken",
				"_group_select",
				"_Image3",
				"_Image4",
				"_img_click",
				"_img_color",
				"_img_lv_bg"
			])
	}
}
 window["RuneResolutionItem"]= RuneResolutionItem