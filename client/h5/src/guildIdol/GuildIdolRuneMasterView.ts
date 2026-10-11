import { BaseView1, OpenMode } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, Trim, SetHtmlCenter } from "../util/Util"
import { GuildIdolRuneMasterItem } from "./GuildIdolRuneMasterItem"
import { GuildIdolRuneSmallItem } from "./GuildIdolRuneSmallItem"

export class GuildIdolRuneMasterView extends BaseView1 {
	Emp_btn_act
	Emp_gp_btn
	InitEvent
	LoadSuccess
	Out_lb_act
	Scr_Scroller1
	click_bg_toClose
	destroy_callback
	destroy_imm
	initItem
	initNeedItem
	is_center
	itemTouch
	open_mode
	use_background
	_ac_list:LoopScrowViewMgr
	data
	public constructor() {
		super()

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolRuneMasterView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.is_center = true
		this.click_bg_toClose = true
		this.use_background = true
		let _model = GuildModel.GetInstance()
		let item_list = []
		let select_index = 1
		let select_data = null
		let local_GuildEvent = GuildEvent


		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)

			Util.AddClickEvent(this._gp_btn, () => {
				_model.Fire(local_GuildEvent.REQUEST_PROTO, 40506, "hc", _model.RunePos.god_id, select_data.combo_id)
			}
				, this, true)

			this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_RETURN, () => {
				this.initNeedItem()
			}
			)
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetBigBgPath("ui_Guild_bg3.jpg"))
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, GameResPath.GetIcon("guildidol", "uigh_104"), true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image12, GameResPath.GetIcon("guildidol", "uisgjs_025"), true)
			this.initItem()
		}

		this.destroy_callback = () => {
			if (this._ac_list) {
				this._ac_list.DeleteMe()
				this._ac_list = null
			}

			for (let key in item_list) {

				let item = item_list[key]
				item.DeleteMe()
			}
			item_list = []

			_model.RunePos = []
		}

		this.initItem = () => {
			let god_id = _model.RunePos.god_id
			let godRuneDta = _model.getIdolRune(god_id)
			let combo_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_combo
			let index = 1
			this.data=[]
			for (let key in combo_cfg) {

				let combo = combo_cfg[key]
				if (combo.god_id == god_id) {
					table.insert(this.data, combo)
					index = index + 1
				}
			}
			table.sort(this.data, (a?, b?) => {
				return a.combo_id < b.combo_id
			})
			for (let _i = 0; _i < this.data.length; _i++) {
				var _v = this.data[_i]
				if (godRuneDta && godRuneDta.combo_id == _v.combo_id) {
					select_index = _i
				}
			}
			if (!this._ac_list) {
				this._ac_list = new LoopScrowViewMgr()
				this._ac_list.SetData(this._list_items, GuildIdolRuneMasterItem, this.data,LoopScrCon.Horizontal,1,(item?) => {
					this.itemTouch(item)
				})
				this._ac_list.SetSelectIndex(select_index)
				select_data = this.data[select_index]
			} else {
				this._ac_list.replaceAll(this.data)
			}
			this.initNeedItem()
		}

		this.itemTouch = (e?) => {
			if (select_index == this._list_items.selectedIndex) {
				return
			}
			select_index = this._list_items.selectedIndex
			select_data = this.data[e]
			this.initNeedItem()
		}

		this.initNeedItem = () => {
			if (!select_data) {
				return
			}
			let needItem = () => {
				let condition_list = JSON.parse(select_data.condition)
				let index = 0
				for (let key in condition_list) {

					let condition = condition_list[key]
					let color = Number(condition[0])
					let num = Number(condition[1])
					let cfg = _model.IdolRune_Master_Goods[color]
					if (cfg) {
						let type_id = cfg.type_id
						for (let i = index; i < index + num; i++) {
							let item = item_list[i]
							if (!item) {
								item = new GuildIdolRuneSmallItem(this._gp_item)
								item.Load()
								table.insert(item_list, item)
							}
							item.setData(type_id, false)
						}
						index = num 
					}
				}
			}

			let attrStr = ""
			let attrStr1 = ""
			let attr_list = JSON.parse(select_data.attr_skill)
			for (let key in attr_list) {

				let _list = attr_list[key]
				if (_list[0] == "attr") {
					let index = 1
					for (let k in _list[1]) {

						let attr = _list[1][k]
						if(index%2!=0){
							attrStr = attrStr  + WordManager.GetProperties(attr[0]) + ":" +
							HtmlColorTxt(WordManager.ConvertToPercentValue(attr[0], attr[1]), "'#00fa64'") +"<br>"
						}else{
							attrStr1 = attrStr1  + WordManager.GetProperties(attr[0]) + ":" +
							HtmlColorTxt(WordManager.ConvertToPercentValue(attr[0], attr[1]), "'#00fa64'") +"<br>"
						}
						
						index = index + 1
					}
					break
				}
			}

			this.PreHtml()
			this._lb_attr.innerHTML = attrStr
			SetHtmlCenter(this._lb_attr,{x:116,w:225})
			this._lb_attr1.innerHTML = attrStr1
			SetHtmlCenter(this._lb_attr1,{x:301,w:225})

			this._lb_name.text = Trim(select_data.name)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetSkillIconPath(select_data.icon))
			let god_id = _model.RunePos.god_id
			let godRuneDta = _model.getIdolRune(god_id)
			if (!godRuneDta) { return }
			let act = godRuneDta.combo_id == select_data.combo_id

			let combo_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_combo
			let canAct = godRuneDta.rune_list.length >= _model.rune_max && _model.runeMasterBetterByComId(god_id, select_data.combo_id, combo_cfg)
			let not_reach = !act && !canAct
			this._gp_btn.visible = canAct
			//this._Image10.visible=!canAct||!act
			this._red.visible = canAct && godRuneDta.combo_id < select_data.combo_id
			this._gp_show.visible = not_reach
			this._gp_act.visible = act
			if (not_reach) {
				needItem()
			}
		}


	}

	PreHtml(){
		this._lb_attr.style.color="#ffffff"
		this._lb_attr.style.fontSize=20
		this._lb_attr.width=200
		this._lb_attr.style.lineHeight=30

		this._lb_attr1.style.color="#ffffff"
		this._lb_attr1.style.fontSize=20
		this._lb_attr1.width=200
		this._lb_attr1.style.lineHeight=30
	}

	public DeleteMe() {
		super.DeleteMe()
	}






_Image_bg_1:Laya.Image
_img_title_bg:Laya.Image
_lb_title:Laya.Label
_bg:Laya.Image
_Image1:Laya.Image
_lb_name:Laya.Label
_Image10:Laya.Image
_gp_show:Laya.Box
_Label1:Laya.Label
_gp_item:Laya.HBox
_gp_act:Laya.Box
_Image11:Laya.Image
_Label2:Laya.Label
_gp_btn:Laya.Box
_btn_act:Laya.Box
_img_act:Laya.Image
_lb_act:Laya.Label
_red:Laya.Image
_list_items:Laya.List
_close:Laya.Image
_img_22:Laya.Image
_img:Laya.Image
_lb_attr1:Laya.HTMLDivElement
_lb_attr:Laya.HTMLDivElement
_Group5:Laya.Box
_img_g5_title:Laya.Image
_lb_g5_txt:Laya.Label
public GetComponents() {
[
this._Image_bg_1,
this._img_title_bg,
this._lb_title,
this._bg,
this._Image1,
this._lb_name,
this._Image10,
this._gp_show,
this._Label1,
this._gp_item,
this._gp_act,
this._Image11,
this._Label2,
this._gp_btn,
this._btn_act,
this._img_act,
this._lb_act,
this._red,
this._list_items,
this._close,
this._img_22,
this._img,
this._lb_attr1,
this._lb_attr,
this._Group5,
this._img_g5_title,
this._lb_g5_txt,
]
 = this.GetChildrenByNames([

"_Image_bg_1",
"_img_title_bg",
"_lb_title",
"_bg",
"_Image1",
"_lb_name",
"_Image10",
"_gp_show",
"_Label1",
"_gp_item",
"_gp_act",
"_Image11",
"_Label2",
"_gp_btn",
"_btn_act",
"_img_act",
"_lb_act",
"_red",
"_list_items",
"_close",
"_img_22",
"_img",
"_lb_attr1",
"_lb_attr",
"_Group5",
"_img_g5_title",
"_lb_g5_txt",
])
}
}
 window["GuildIdolRuneMasterView"]= GuildIdolRuneMasterView