import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util, SetSizeDeltaX, HtmlColorTxt, Color, Trim } from "../util/Util"
import { GuildIdolMainRuneItem } from "./GuildIdolMainRuneItem"
import { GuildIdolRuneShowAttr } from "./GuildIdolRuneShowAttr"
import { GuildIdolRuneShowAttr2 } from "./GuildIdolRuneShowAttr2"

export class GuildIdolMainRune extends BaseItem1 {
	// Can_gp_select
	// Can_gp_show
	// Emp_btn_down
	// Emp_gp_item
	// Emp_gp_replace
	// Emp_gp_up
	InitEvent
	LoadSuccess
	Local_DeleteMe
	Out_lb_up
	ReOpen_callback
	Scr_Scroller1
	Scr_Scroller2
	initAttr
	initView
	showView
	updateCombo
	updateCost
	updateSelect
	tween_list = []
	public constructor(parent?) {
		super(parent)

		this.base_file = "guildidol"
		this.layout_file = "GuildIdolMainRune"
		this.layer_value = Enum_UILayer.UI
		let _model = GuildModel.GetInstance()
		let local_GuildEvent = GuildEvent
		let goods_model = GoodsModel.GetInstance()
		let _refresh = null
		let god_id = null
		let selelct_rune = null
		let select_pos = null
		let select_data = null
		let select_item = null
		let attr_list = []
		let attr_list2 = []
		let cost_list = []
		let mask_max = 0
		let show_rune_list = []

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mid, GameResPath.GetIcon("guildidol","uigh_093"))
			this._Scroller1.vScrollBarSkin=""
			this._Scroller2.vScrollBarSkin=""
			this.InitEvent()
			this.LoadSuccess()
		}

		this.InitEvent = () => {

			Util.AddClickEvent(this._gp_item, () => {
				_model.RunePos = {god_id : god_id}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuildIdolRuneMasterView")
			}
				, this)

			Util.AddClickEvent(this._btn_down, () => {
				_model.Fire(local_GuildEvent.REQUEST_PROTO, 40507, "hc", god_id, select_pos)
			}
				, this, true)

			Util.AddClickEvent(this._gp_replace, () => {
				_model.RunePos = { pos: select_pos, god_id: god_id, type_id: select_data.goods_type_id }
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuildIdolRuneSelView")
			}
				, this, true)

			Util.AddClickEvent(this._gp_up, () => {
				_model.Fire(local_GuildEvent.REQUEST_PROTO, 40508, "hc", god_id, select_pos)
			}
				, this, true)

			Util.AddClickEvent(this._img_dec, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuildIdolRuneDecomposeView")
			}
				, this, true)

			Util.AddClickEvent(this._img_icon, () => {
				_model.RunePos = {god_id : god_id}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "GuildIdolRuneActView")
			}
				, this)

			Util.AddClickEvent(this._close_select, () => {
				select_pos = null
				select_data = null
				if (select_item) {
					select_item.setSelect(false)
					select_item = null
				}
				this.showView()
			}
				, this, true)

			this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_SELECT, (pos?, data?) => {
				if (pos == select_pos) {
					return
				}
				select_pos = pos
				select_data = data
				if (select_item) {
					select_item.setSelect(false)
				}
				select_item = show_rune_list[pos-1]
				this.showView()
			}
			)

			this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_RETURN, () => {
				let find = false
				if (select_data) {
					let godRuneDta = _model.getIdolRune(god_id)
					for (let key in godRuneDta.rune_list) {

						let data = godRuneDta.rune_list[key]
						if (data.pos == select_data.pos) {
							select_data = data
							find = true
							break
						}
					}
				}
				if (!find) {
					select_pos = null
					select_data = null
					if (select_item) {
						select_item.setSelect(false)
						select_item = null
					}
				}
				this.showView()
				this.updateCombo()
			}
			)

			this.BindEvent(goods_model, GoodsModel.CHANGE_BAG_LIST, () => {
				if (!this.use_delete_method) {
					this.showView()
				}
			}
			)

			this.BindEvent(goods_model, GoodsModel.CHANGE_GUILD_RUNE_LIST, () => {
				if (!this.use_delete_method) {
					this.showView()
				}
			}
			)

			// this.BindEvent(_model, local_GuildEvent.IDOL_RUNE_UP, () => {
			// 	this.AddUIEffect("UI_1102_shengjichenggong", this.layer_value, this._gp_effect)
			// }
			// )

			this.BindEvent(_model, local_GuildEvent.IDOL_CHANGE_COMBO_ID, () => {
				this.updateCombo()
			}
			)
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath("ui_Guild_bg2.jpg"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bottom, GameResPath.GetIcon("guildidol", "uigh_063"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bottom0, GameResPath.GetIcon("guildidol", "uigh_063"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_mid, GameResPath.GetIcon("guildidol", "uigh_093"), true)
			//this:AddUIEffect("ui_shenxiangmingwen_1", this.layer_value, this._gp_ef1, null, null, true)
			//this:AddUIEffect("ui_shenxiangmingwen_2", this.layer_value, this._gp_ef2, {x=220, y=0}, null, true)
			//this:AddUIEffect("ui_shenxiangmingwen_2", this.layer_value, this._gp_ef3, {x=-220, y=0}, {x=-1, y=1}, true)

			mask_max = 216
			if (_refresh) {
				this.updateSelect(god_id)
			}
		}

		this.ReOpen_callback = () => {
			//this:AddUIEffect("ui_shenxiangmingwen_1", this.layer_value, this._gp_ef1, null, null, true)
			//this:AddUIEffect("ui_shenxiangmingwen_2", this.layer_value, this._gp_ef2, {x=220, y=0}, null, true)
			//this:AddUIEffect("ui_shenxiangmingwen_2", this.layer_value, this._gp_ef3, {x=-220, y=0}, {x=-1, y=1}, true)
		}

		this.Local_DeleteMe = () => {
			this.ClearAnim()

			for (let key in show_rune_list) {

				let item = show_rune_list[key]
				item.DeleteMe()
			}
			show_rune_list = []

			for (let key in attr_list) {

				let item = attr_list[key]
				item.DeleteMe()
			}
			attr_list = []

			for (let key in attr_list2) {

				let item = attr_list2[key]
				item.DeleteMe()
			}
			attr_list2 = []

			for (let key in cost_list) {

				let item = cost_list[key]
				item.DeleteMe()
			}
			cost_list = []
		}

		this.updateSelect = (_god_id?) => {
			god_id = _god_id
			if (!this.is_loaded) {
				_refresh = true
				return
			}
			select_pos = null
			select_data = null
			if (select_item) {
				select_item.setSelect(false)
				select_item = null
			}
			this.showView()
			this.updateCombo()
		}

		this.initView = () => {
			let godRuneData = _model.getIdolRune(god_id)
			if (!godRuneData) {
				return
			}
			for (let i = 0; i < _model.rune_max; i++) {
				let item = show_rune_list[i]
				let item_pos=i+1;
				if (!item) {
					item = new GuildIdolMainRuneItem(this._gp_show_item.getChildAt(i))
					item.Load()
					item.setPos(item_pos)
					table.insert(show_rune_list, item)
				}
				let rune = null
				for (let key in godRuneData.rune_list) {

					let _rune = godRuneData.rune_list[key]
					if (_rune.pos == item_pos) {
						rune = _rune
						break
					}
				}
				// let img_index:number=item_pos
				// let line_source = (!rune && ("line_" + img_index) || ("line2_" + img_index))
				// ResManager.GetInstance().SetImageSprite(this, this._Group1.getChildAt(i), "guildidol_asset", line_source, true)
				item.setData(rune, god_id)
			}

			let rune_act_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_achievement
			this._red_show.visible = _model.runeActCanUp(god_id, rune_act_cfg)

			if (!select_pos) {
				let attr_data = []
				for (let key in rune_act_cfg) {

					let info = rune_act_cfg[key]
					if (info.god_id == god_id) {
						table.insert(attr_data, info)
					}
				}
				table.sort(attr_data, (a?, b?) => {
					return a.need_lv < b.need_lv
				})
				let need_lv, cfg, isMax, attr
				
				[need_lv, cfg, isMax, attr]= _model.runeActNeedLv(god_id, attr_data)
				this._lb_show_attr.text = `全身${need_lv}级`//"全身" + need_lv + "级"
				this._lb_show_lv.text = `组合属性+${attr}%`//"组合属性+" + attr + "%"
				let num = 0
				for (let key in godRuneData.rune_list) {

					let rune = godRuneData.rune_list[key]
					let str = String(rune.goods_type_id)
					let lv = Number(str.charAt(str.length - 1))//Number(string.sub(str, -1))
					lv = lv == 0 && 10 || lv
					if (lv >= need_lv) {
						num = num + 1
					}
				}
				let mask_width = mask_max * (num / _model.rune_max)
				SetSizeDeltaX(this._bar, mask_width)
			} else {
				if (!select_data) {
					return
				}
				let type_id = select_data.goods_type_id
				let name = GoodsModel.GetGoodsName(type_id)
				this._lb_name2.text = name
				ResManager.GetInstance().SetOutsideImageSprite(this, this._icon, GameResPath.GetGoodsIconPath(type_id),false)
			}
			this.initAttr()
		}

		this.initAttr = () => {
			if (!select_pos) {
				let godRuneDta = _model.getIdolRune(god_id)
				if (!godRuneDta) {
					return
				}
				let index = 0
				for (let key in godRuneDta.rune_list) {

					let rune = godRuneDta.rune_list[key]
					let item = attr_list[index]
					if (!item) {
						item = new GuildIdolRuneShowAttr(this._gp_show_attr)
						item.Load()
						table.insert(attr_list, item)
					}
					item.setData(rune.goods_type_id)
					index = index + 1
				}

				for (let i = index; i < _model.rune_max; i++) {
					let item = attr_list[i]
					if (!item) {
						item = new GuildIdolRuneShowAttr(this._gp_show_attr)
						item.Load()
						table.insert(attr_list, item)
					}
					item.setData(null)
				}
				//LayoutRebuilder(this._gp_show_attr)
			} else {
				if (!select_data) {
					return
				}
				let rune_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune
				let type_id = select_data.goods_type_id
				let next_type_id = null
				let cfg = rune_cfg[type_id]
				let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				let runeList = []
				for (let key in rune_cfg) {

					let rune = rune_cfg[key]
					let rune_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(rune.goods_id)
					if (vo.color == rune_vo.color) {
						table.insert(runeList, rune.goods_id)
					}
				}
				table.sort(runeList, (a?, b?) => {
					return a < b
				})
				let index = table.find(runeList, type_id)
				if (index != -1 && runeList.length != index) {
					next_type_id = runeList[index + 1]
				}
				let next_cfg = null
				if (next_type_id) {
					next_cfg = rune_cfg[next_type_id]
				}
				if (cfg) {
					let _attr_list = JSON.parse(cfg.attr)
					let next_attr_list = []
					if (next_cfg) {
						next_attr_list = JSON.parse(next_cfg.attr)
					}
					let index = 0


					for (let j = 0; j < attr_list2.length; j++) {
						let item = attr_list2[j]
						item.SetVisible(false)
					}



					for (let key in _attr_list) {
						let attr = _attr_list[key]
						let next_attr = null
						for (let key in next_attr_list) {

							let n_attr = next_attr_list[key]
							if (n_attr[0] == attr[0]) {
								next_attr = n_attr
								break
							}
						}
						let item = attr_list2[index]
						if (!item) {
							item = new GuildIdolRuneShowAttr2(this._gp_show_attr2)
							item.Load()
							table.insert(attr_list2, item)
						}
						item.setData(attr, next_attr)
						item.SetVisible(true)
						index = index + 1
					}

					
				}
				this.updateCost()
			}
		}

		this.updateCost = () => {
			if (select_pos) {
				let type_id = select_data.goods_type_id
				let rune_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune
				let cfg = rune_cfg[type_id]
				let index = 0
				let cost = JSON.parse(cfg.cost)
				let count = 0
				let cur
				if(cost_list){
					for (let j = 0; j < cost_list.length; j++) {
						let item = cost_list[j]
						item.SetVisible(false)
					}
	
				}
				


				for (let key in cost) {

					let costInfo = cost[key]
					let item = cost_list[index]
					if (!item) {
						item = new BaseAwardItem(this._gp_cost)
						item.Load()
						item.SetScale(0.7)
						table.insert(cost_list, item)
					}
					item.SetVisible(true)
					let type_id, lock 
					[type_id, lock ]= goods_model.GetMappingTypeId(costInfo[0], costInfo[1])
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						let num = Number(costInfo[2])
						item.SetData(goods_vo.type_id, num, lock)
						cur= goods_model.GetBagGoodsNum(goods_vo.type_id)
						let color = (cur >= num && (Enum_ColorUtil_Light.GREEN) || (Enum_ColorUtil_Light.RED))
						item.ForceSetNumberInFlow(HtmlColorTxt(cur + "/" + num, color))
						if (cur >= num) {
							count++
						}
					}
					index = index + 1
				}
			
				let can_up = cost?cost.length > 0:false

				this._red_up.visible = count >= index && can_up

				Util.SetImageGray(this._img_up, !can_up)
				//this.Out_lb_up.effectColor = !can_up && ColorUtilValue.GRAY || Color(211 / 255, 106 / 255, 36 / 255, 1)
				this._lb_up.text = can_up && "升级" || "已满级"
				this._btn_up.mouseEnabled=can_up
				//this.Emp_gp_up.raycastTarget = can_up

				let can_replace = _model.runeCanPutByPos(god_id, select_pos)
				this._red_replace.visible = can_replace

				this._gp_cost.x = index == 1 ? 540 : 489
			}
		}

		this.updateCombo = () => {
			let godRuneData = _model.getIdolRune(god_id)
			if (!godRuneData) {
				return
			}
			let combo_id = godRuneData.combo_id > 0 && godRuneData.combo_id || 1
			let combo_cfg = Config.PRELOAD_SERVER_CONFIG.config_guild_god_rune_combo
			let cfg = combo_cfg[god_id + "@" + combo_id]
			if (cfg) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img, GameResPath.GetSkillIconPath(cfg.icon), true)
				this._lb_name.text = Trim(cfg.name)
				Util.SetImageGray(this._img, godRuneData.combo_id == 0)
			}
			let red_item_bool = _model.runeMasterBetter(god_id, combo_cfg)
			this._red_item.visible = red_item_bool
		}

		this.showView = () => {
			this.ClearAnim()
			let lastShow = this._gp_select.visible
			let showSel = select_pos != null
			if (lastShow != showSel) {
				if (showSel) {
					this._gp_select.visible = showSel
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_select, SYTweenLite.UiAnimationType.ANCHORED_POSY, 573, 0.1))
					//table.insert(this.tween_list, SYTweenLite.to(this, this.Can_gp_select, SYTweenLite.UiAnimationType.ALPHA, 1, 0.1))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_select, SYTweenLite.UiAnimationType.ALPHA, 1, 0.1, () => {
						this._gp_show.visible = !showSel
						this.initView()
					}))
				} else {
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_select, SYTweenLite.UiAnimationType.ANCHORED_POSY, 900, 0.1))
					table.insert(this.tween_list, SYTweenLite.to(this, this._gp_select, SYTweenLite.UiAnimationType.ALPHA, 0, 0.1, () => {
						this._gp_select.visible = showSel
					}))
					//table.insert(this.tween_list, SYTweenLite.to(this, this.Can_gp_show, SYTweenLite.UiAnimationType.ALPHA, 1, 0.1))
					this._gp_show.visible = !showSel
					this.initView()
				}
			} else {
				this.initView()
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}


	ClearAnim(){
		if (this.tween_list && this.tween_list.length > 0) {
			for (let _ in this.tween_list) {
				var tween_id = this.tween_list[_]
				SYTweenLite.Stop(tween_id)
			}
			this.tween_list = []
		}
	}

_img_bg:Laya.Image
_img_mid:Laya.Image
_img_mid2:Laya.Image
_gp_ef1:Laya.Box
_gp_ef2:Laya.Box
_gp_ef3:Laya.Box
_Image1:Laya.Image
_lb_name:Laya.Label
_gp_show_item:Laya.Box
_gp_rune1:Laya.Box
_gp_rune2:Laya.Box
_gp_rune3:Laya.Box
_gp_rune4:Laya.Box
_gp_rune5:Laya.Box
_gp_rune6:Laya.Box
_gp_item:Laya.Box
_img_22:Laya.Image
_img:Laya.Image
_red_item:Laya.Image
_gp_show:Laya.Box
_img_bottom:Laya.Image
_img_icon_22:Laya.Image
_img_icon:Laya.Image
_Group3:Laya.Box
_Image4:Laya.Image
_bar:Laya.Image
_lb_show_attr:Laya.Label
_lb_show_lv:Laya.Label
_Group44:Laya.Box
_img_g44_title:Laya.Image
_lb_title_gp44_txt:Laya.Label
_Group4:Laya.Box
_img_g4_title:Laya.Image
_lb_title_txt:Laya.Label
_Scroller1:Laya.Panel
_gp_show_attr:Laya.VBox
_red_show:Laya.Image
_gp_select:Laya.Box
_img_bottom0:Laya.Image
_Group5:Laya.Box
_img_g5_title:Laya.Image
_lb_g5_txt:Laya.Label
_img_icon_222:Laya.Image
_gp_cost:Laya.HBox
_icon:Laya.Image
_lb_name2:Laya.Label
_btn_down:Laya.Box
_img_down:Laya.Image
_lb_down:Laya.Label
_Group6:Laya.Box
_img_g6_title:Laya.Image
_lb_g6_txt:Laya.Label
_Scroller2:Laya.Panel
_gp_show_attr2:Laya.VBox
_close_select:Laya.Image
_gp_up:Laya.Box
_btn_up:Laya.Box
_img_up:Laya.Image
_lb_up:Laya.Label
_red_up:Laya.Image
_gp_replace:Laya.Box
_btn_replace:Laya.Box
_img_replace:Laya.Image
_lb_replace:Laya.Label
_red_replace:Laya.Image
_img_split:Laya.Image
_img_dec:Laya.Image
_gp_effect:Laya.Box
public GetComponents() {
[
this._img_bg,
this._img_mid,
this._img_mid2,
this._gp_ef1,
this._gp_ef2,
this._gp_ef3,
this._Image1,
this._lb_name,
this._gp_show_item,
this._gp_rune1,
this._gp_rune2,
this._gp_rune3,
this._gp_rune4,
this._gp_rune5,
this._gp_rune6,
this._gp_item,
this._img_22,
this._img,
this._red_item,
this._gp_show,
this._img_bottom,
this._img_icon_22,
this._img_icon,
this._Group3,
this._Image4,
this._bar,
this._lb_show_attr,
this._lb_show_lv,
this._Group44,
this._img_g44_title,
this._lb_title_gp44_txt,
this._Group4,
this._img_g4_title,
this._lb_title_txt,
this._Scroller1,
this._gp_show_attr,
this._red_show,
this._gp_select,
this._img_bottom0,
this._Group5,
this._img_g5_title,
this._lb_g5_txt,
this._img_icon_222,
this._gp_cost,
this._icon,
this._lb_name2,
this._btn_down,
this._img_down,
this._lb_down,
this._Group6,
this._img_g6_title,
this._lb_g6_txt,
this._Scroller2,
this._gp_show_attr2,
this._close_select,
this._gp_up,
this._btn_up,
this._img_up,
this._lb_up,
this._red_up,
this._gp_replace,
this._btn_replace,
this._img_replace,
this._lb_replace,
this._red_replace,
this._img_split,
this._img_dec,
this._gp_effect,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_mid",
"_img_mid2",
"_gp_ef1",
"_gp_ef2",
"_gp_ef3",
"_Image1",
"_lb_name",
"_gp_show_item",
"_gp_rune1",
"_gp_rune2",
"_gp_rune3",
"_gp_rune4",
"_gp_rune5",
"_gp_rune6",
"_gp_item",
"_img_22",
"_img",
"_red_item",
"_gp_show",
"_img_bottom",
"_img_icon_22",
"_img_icon",
"_Group3",
"_Image4",
"_bar",
"_lb_show_attr",
"_lb_show_lv",
"_Group44",
"_img_g44_title",
"_lb_title_gp44_txt",
"_Group4",
"_img_g4_title",
"_lb_title_txt",
"_Scroller1",
"_gp_show_attr",
"_red_show",
"_gp_select",
"_img_bottom0",
"_Group5",
"_img_g5_title",
"_lb_g5_txt",
"_img_icon_222",
"_gp_cost",
"_icon",
"_lb_name2",
"_btn_down",
"_img_down",
"_lb_down",
"_Group6",
"_img_g6_title",
"_lb_g6_txt",
"_Scroller2",
"_gp_show_attr2",
"_close_select",
"_gp_up",
"_btn_up",
"_img_up",
"_lb_up",
"_red_up",
"_gp_replace",
"_btn_replace",
"_img_replace",
"_lb_replace",
"_red_replace",
"_img_split",
"_img_dec",
"_gp_effect",
])
}
}
 window["GuildIdolMainRune"]= GuildIdolMainRune