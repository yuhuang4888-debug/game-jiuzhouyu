import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MedalModel } from "../commonModel/MedalModel"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, PlayBigEffect, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { TitleAttrItem } from "./TitleAttrItem"
import { TitleItem } from "./TitleItem"

export class TitleMainView extends BaseItem1 {

	is_illision
	is_open
	item_list
	model
	up_need_item
	title_list
	show_id
	title_id
	fight_num
	cur_eff
	public constructor(parent?) {
		super(parent)

		this.fight_num = null
		this.is_open = true;
		this.model = MedalModel.GetInstance();
		this.base_file = "title"
		this.layout_file = "TitleMainView"
		this.preload_server_config = { "config_title_cfg": false }
		this.load_callback = () => {
			this.cur_eff = 0
			SetHtmlStyle(this.num_lb, { x: 0, w: 69, f: 18, ww: false, c: "#ffffff" })
			this.LoadSuccess()
			this.InitEvent()
		}

	}

	public DeleteMe() {
		this.ClearUIEffect(this.title_effect_gp)
		if (this.fight_num) {
			this.fight_num.DeleteMe()
			this.fight_num = null
		}

		if (this.up_need_item) {
			this.up_need_item.DeleteMe()
			this.up_need_item = null
		}
		if (this.item_list && this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var obj = this.item_list[_tmpi]
				obj.DeleteMe()
			}
			this.item_list = null
		}
		if (this.title_list) {
			this.title_list.DeleteMe()
			this.title_list = null
		}
		this.is_open = true
		this.show_id = null
		super.DeleteMe()
	}

	public LoadSuccess() {
		this.UpdateView()
	}

	public InitEvent() {

		Util.AddClickEvent(this.illsion_gp, () => {
			if (this.is_illision) {
				this.model.Fire(MedalModel.MEDAL_REQUEST_PROTO, 13406)
			} else {
				this.model.Fire(MedalModel.MEDAL_REQUEST_PROTO, 13404, this.title_id)
			}
		}, this, true)

		Util.AddClickEvent(this.up_level_gp, () => {
			this.model.Fire(MedalModel.MEDAL_REQUEST_PROTO, 13403, this.title_id)
		}
			, this, true)
		this.BindEvent(this.model, MedalModel.CLICK_TITLE_ITEM, (title_id?) => {
			if (title_id != this.title_id) {
				this.title_id = title_id
				this.UpdateView()
			}
		}
		)
		this.BindEvent(this.model, MedalModel.UPDATE_TITLE_MAIN_VIEW, () => {
			this.UpdateView()
		}
		)
		this.BindEvent(this.model, MedalModel.SUCCCESS_UP_LEVEL, (type?) => {
			if (type == 1) {
				PlayBigEffect("ui_ZiTi_Jihuo")
				//this.AddUIEffect("UI_1102_jihuochenggong", this.success_effect_gp)
			} else {
				PlayBigEffect("ui_shengxingchengong")
				//this.AddUIEffect("UI_1102_shengxingchenggong", this.success_effect_gp)
			}
		}
		)
		//this.model.Fire(MedalModel.MEDAL_REQUEST_PROTO, 13405)
	}

	public UpdateView() {

		let title_info = this.model.GetTitleInfo()
		if (!title_info || Util.IsTableEmpty(title_info)) {
			return
		}
		if (!this.title_list) {
			this.title_list = new LoopScrowViewMgr()
			let func = (item?) => {
				if (item.title_id != this.title_id) {
					this.title_id = item.title_id
					this.SetTitleMessage(title_info)
				}
			}
			this.title_list.SetData(this.Content, TitleItem, title_info, LoopScrCon.Horizontal, 1, func)
		} else {
			this.title_list.replaceAll(title_info)
		}

		if (this.is_open) {
			let index = this.SetSelectIndex(title_info)
			this.is_open = false
			this.title_list.CenterOnChild(index)
			this.title_list.SetSelectIndex(index)
			this.Content.scrollTo(index)
		}
		if (this.title_id) {
			this.SetTitleMessage(title_info)
		}
	}

	public SetSelectIndex(title_info?) {

		let index = 0
		if (this.model.title_red_list && Util.TableSize(this.model.title_red_list) > 0) {
			let title_red_list = this.model.title_red_list
			let red_id = null
			for (let key in title_red_list) {

				red_id = key
				break
			}
			let i = 0
			do {
				if (red_id && title_info[i].id == red_id) {
					index = i
					break
				}
				i = i + 1
			} while ((i < title_info.length))
		} else {
			let list = Util.DeepCopy(title_info)
			let title_id = null
			list = table.reverse(list)
			let i = 0
			do {
				if (list[i].is_equip != 0) {
					title_id = list[i].id
					break
				}
				i = i + 1
			} while ((i < list.length))
			if (title_id) {
				let i = 0
				do {
					if (title_info[i].id == title_id) {
						index = i
						break
					}
					i = i + 1
				} while ((i < title_info.length))
			}
		}
		return index
	}

	public SetScrollH(index?, max_index?) {

		if (index <= 3) {
			return
		}
		//this.item_scroll.viewport.validateNow()
		//if (index < max_index - 2 ) {
		//this.item_scroll.viewport.scrollH = 151 * index - 4 + 119
		//}else{
		//this.item_scroll.viewport.scrollH = this.title_gp.contentWidth - this.item_scroll.width + 8 * max_index + 1
		//}
	}

	public SetTitleMessage(title_info?) {

		this.SetRed()
		let i = 0
		do {
			if (title_info[i].id == this.title_id) {

				if (!this.fight_num) {
					this.fight_num = new FightingShowSmallItem(this._gp_fight)
					this.fight_num.Load()
				}

				this.fight_num.Updatefighting(String(title_info[i].power))
				this.fight_num.IsCenter(true, false)
				//ResManager.GetInstance().SetImageSprite(this, this.illsion_checkbox, "common_asset", title_info[i].is_equip == 2 && "uity_045c" || "uity_045d")
				this.is_illision = (title_info[i].is_equip == 2 && (true) || (false))
				this.UpdateMessage(title_info[i].is_equip, title_info[i].level)
				this.select_illsion.visible = this.is_illision
			}
			i = i + 1
		} while ((i < title_info.length))
	}

	public ShowTitleEffect(show_id?) {

		if (this.cur_eff != show_id) {
			this.show_id = show_id
			let scale = 3.5
			let res = this.model.GetTitleEffetName(show_id)
			this.AddUIEffect(res, this.title_effect_gp, null, scale, true)
			this.cur_eff = show_id
		}


	}

	public UpdateMessage(is_active?, level?) {

		let config_title_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_title_cfg", false)
		let now_attr_list = null
		let next_attr_list = null
		let active_goods_vo = null
		let is_max = true
		let cfg = config_title_cfg[this.title_id + "@" + level]
		this.show_id = 0
		if (cfg && cfg.show_id && cfg.show_id != 0) {
			this.ShowTitleEffect(cfg.show_id)
			if (is_active == 0) {
				this.max_img.visible = false
				this.up_level_gp.visible = true
				this.num_lb.visible = true
				this.up_level_lb.text = "激活"
				if (cfg.id == this.title_id && cfg.star == 0) {
					this.name_lb.text = cfg.name
					this.detail_lb.text = cfg.desc
					let attr_list = JSON.parse(cfg.attr)
					let goods_vo = JSON.parse(cfg.cost)
					this.UpdateNeedGoods(false, goods_vo)
					this.UpdateAttr(is_active, attr_list, attr_list, false)
				}
			} else {
				let next_cfg = config_title_cfg[this.title_id + ("@" + (level + 1))]
				if (next_cfg) {
					is_max = false
					next_attr_list = JSON.parse(next_cfg.attr)
					active_goods_vo = JSON.parse(next_cfg.cost)
				} else {
					is_max = true
					next_cfg = config_title_cfg[this.title_id + ("@" + level)]
					next_attr_list = JSON.parse(next_cfg.attr)
					active_goods_vo = JSON.parse(next_cfg.cost)
				}
				this.name_lb.text = cfg.name
				this.detail_lb.text = cfg.desc
				this.up_level_gp.visible = !is_max ? true : false
				this.num_lb.visible = !is_max ? true : false
				this.max_img.visible = is_max ? true : false
				if (this.up_level_gp.visible == true) {
					this.up_level_lb.text = "升星"
				}

				this.UpdateNeedGoods(is_max, active_goods_vo)
				now_attr_list = JSON.parse(cfg.attr)
				this.UpdateAttr(is_active, now_attr_list, next_attr_list, is_max)
			}
		}
	}

	public UpdateNeedGoods(is_max?, goods_vo?) {

		let goods_id = null
		let goods_num = null
		if (goods_vo) {
			for (let _tmpi in goods_vo) {
				var vo = goods_vo[_tmpi]
				goods_id = Number(vo[1])
				goods_num = Number(vo[2])
			}
			if (!this.up_need_item) {
				this.up_need_item = new BaseAwardItem(this.item_gp)
				this.up_need_item.Load()
				this.up_need_item.set
				this.up_need_item.SetItemSize(69, 69)
			}
			this.up_need_item.SetData(goods_id)
			let have_num = GoodsModel.GetInstance().GetBagGoodsNum(goods_id)
			let color = have_num >= goods_num ? "'#b3ff48'" : "'#ff4f50'"
			let str = `${HtmlColorTxt(have_num + "", color)}/${goods_num}`
			this.num_lb.innerHTML = Util.StrToHTML(str)
			SetHtmlCenter(this.num_lb, { x: 0, w: 69 })
		}
	}

	public UpdateAttr(is_active?, now_attr_list?, next_attr_list?, is_max?) {

		let attr_dir = []
		if (is_active == 0) {
			let index = 0
			for (let _tmpi in now_attr_list) {
				var vo = now_attr_list[_tmpi]
				attr_dir[index] = { attr_id: vo[0], now_attr: 0, next_attr: vo[1] }
				index = index + 1
			}
		} else {
			let index = 0
			for (let _tmpi in now_attr_list) {
				var vo = now_attr_list[_tmpi]
				attr_dir[index] = { attr_id: vo[0], now_attr: vo[1], next_attr: 0 }
				index = index + 1
			}
			if (!is_max) {
				let i = 0
				for (let _tmpi in next_attr_list) {
					var attr_vo = next_attr_list[_tmpi]
					attr_dir[i].next_attr = attr_vo[1]
					i = i + 1
				}
			}
		}
		if (!this.item_list) {
			this.item_list = []
		}
		for (let k in attr_dir) {
			var attr = attr_dir[k]
			let attr_vo = attr
			let item = this.item_list[k]
			if (!item) {
				item = new TitleAttrItem(this.Content1)
				item.Load()
				//table.insert(this.item_list, item)
				this.item_list[k] = item
			}
			item.Setdata({ attr_id: attr_vo.attr_id, attr_val: attr_vo.now_attr }, { attr_id: attr_vo.attr_id, attr_val: attr_vo.next_attr })
		}
	}

	public SetRed() {

		let red_list = this.model.title_red_list
		this.red_img.visible = (red_list[this.title_id] && (true || (false)))
	}


	_Group2: Laya.Box
	_Image1: Laya.Image
	name_lb: Laya.Label
	detail_lb: Laya.Label
	illsion_gp: Laya.Box
	illsion_checkbox: Laya.Image
	_Label1: Laya.Label
	select_illsion: Laya.Image
	_Image2: Laya.Image
	attr_bg_img: Laya.Image
	_Group5: Laya.Box
	_Group3: Laya.Box
	_Image3: Laya.Image
	_Group4: Laya.Box
	item_gp: Laya.Box
	num_lb: Laya.HTMLDivElement
	up_level_gp: Laya.Box
	_Image5: Laya.Image
	up_level_lb: Laya.Label
	red_img: Laya.Image
	max_img: Laya.Image
	_Group6: Laya.Box
	item_bg_img: Laya.Image
	Content: Laya.List
	title_effect_gp: Laya.Box
	_Scroller1: Laya.Panel
	Content1: Laya.VBox
	success_effect_gp: Laya.Box
	_gp_fight: Laya.VBox
	public GetComponents() {
		[
			this._Group2,
			this._Image1,
			this.name_lb,
			this.detail_lb,
			this.illsion_gp,
			this.illsion_checkbox,
			this._Label1,
			this.select_illsion,
			this._Image2,
			this.attr_bg_img,
			this._Group5,
			this._Group3,
			this._Image3,
			this._Group4,
			this.item_gp,
			this.num_lb,
			this.up_level_gp,
			this._Image5,
			this.up_level_lb,
			this.red_img,
			this.max_img,
			this._Group6,
			this.item_bg_img,
			this.Content,
			this.title_effect_gp,
			this._Scroller1,
			this.Content1,
			this.success_effect_gp,
			this._gp_fight,
		]
			= this.GetChildrenByNames([

				"_Group2",
				"_Image1",
				"name_lb",
				"detail_lb",
				"illsion_gp",
				"illsion_checkbox",
				"_Label1",
				"select_illsion",
				"_Image2",
				"attr_bg_img",
				"_Group5",
				"_Group3",
				"_Image3",
				"_Group4",
				"item_gp",
				"num_lb",
				"up_level_gp",
				"_Image5",
				"up_level_lb",
				"red_img",
				"max_img",
				"_Group6",
				"item_bg_img",
				"Content",
				"title_effect_gp",
				"_Scroller1",
				"Content1",
				"success_effect_gp",
				"_gp_fight",
			])
	}
}
window["TitleMainView"] = TitleMainView