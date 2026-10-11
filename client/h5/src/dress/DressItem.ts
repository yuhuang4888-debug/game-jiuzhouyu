import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { DressModel, DressEvent, DressType } from "../commonModel/DressModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DressItem extends BaseItemRenderer {
	bg_2: Laya.Image
	bg: Laya.Image
	gray_bg: Laya.Image
	select_bg: Laya.Image
	red_dot: Laya.Image
	con: Laya.Box
	use_tag: Laya.Image
	head: Laya.Image
	dress_name: Laya.Label
	click_bg: Laya.Box
	fight: Laya.Label
	_lb_fight:Laya.Label
	item
	model


	public static  	width = 215
	public static height = 236
	public constructor(parent) {
		super()

		this.HEIGT=205
		this.WIDTH=170
		this.base_file = "dress"
		this.layout_file = "DressItem"
		this.model = DressModel.GetInstance()
		// this.skinName = "resource/game/dress/exml/DressItemExml.exml"
		// this.load_callback = () => {
		this.Load()
		// this.LoadSuccess()
		// }
	}

	public load_callback() {

		Util.AddClickEvent(this.click_bg, () => {
			if (this.data) {
				if (this.gray_bg.visible == true) {
					Message.show("即将开放，敬请期待")
					return
				}
				this.model.Fire(DressEvent.DRESS_CLICK_DRESS_ITEM, this.data.id)
			}
		}
			, this)
		let click_fun = (id?) => {
			if(this.data){
				this.SetSelect(this.data.id == id)
			}
		}

		this.BindEvent(this.model, DressEvent.DRESS_CLICK_DRESS_ITEM, click_fun)
		let update_fun = () => {
			this.SetRedDot()
		}

		this.BindEvent(this.model, DressEvent.DRESS_UPDATE_RED_DOT, update_fun)
		let refresh_fun = (id?) => {
			this.RefreshUseTag()
		}
		//this.BindEvent(this.model, DressEvent.DRESS_UPDATE_DRESS_DATA, refresh_fun)

		this.item = new BaseAwardItem(this.con)
		this.item.Load()
		this.item.SetItemSize(93, 91)
		this.item.SetItembgVisible(false)
		this._lb_fight.visible=false
	}

	public dataChanged() {
		if(super.dataChanged()){
			this.Refresh()
		}
	}

	public Refresh() {

		if (this.data) {
			this.dress_name.text = this.data.name
			let dress_data = DressModel.GetInstance().GetMyDressDataByTypeAndId(this.data.type, this.data.id)
			let cfg = null
			if (dress_data) {
				cfg = DressModel.GetInstance().GetDressCfgByTypeAndIdAndLv(this.data.type, this.data.id, dress_data.dress_lv)
			}
			
			let condition = JSON.parse(this.data.condition);
			if(this.data.type == DressType.Head && condition.length > 0){
				let condition = JSON.parse(this.data.condition);
				this.fight.text = dress_data? "Lv." + cfg.level: `${condition[0][1]}转可激活`
				this.fight.color = dress_data? "#0a953e" : "#fe1a1a"
			}else{
				if (cfg) {
					this.fight.text = "Lv." +cfg.level//  Util.CalAttrPower(cfg.attr, true).toString()
					this.fight.color = "#0a953e"
				} else {
					this.fight.text = "未激活"//Util.CalAttrPower(this.data.attr, true).toString()
					this.fight.color = "#fe1a1a"
				}
			}
			this.head.visible = false
			if (this.data.id != 0) {
				this.item.SetItembgVisible(false)
				if(this.data.type == DressType.Head){
					let headStr: string = DressModel.GetInstance().getHeadICon(this.data.id)
					this.item.SetVisible(false)
					this.head.visible = true
					ResManager.GetInstance().SetImageSprite(this, this.head, "head", headStr)
				}else{
					let cost_list = JSON.parse(this.data.cost)
					if (cost_list && cost_list[0]) {
						let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost_list[0][0], cost_list[0][1])
						this.item.SetVisible(true)
						this.item.SetData(goods_id)
					}
				}
				
			} else {
				this.item.transform.visible = false
			}
			this.SetBgState()
			this.SetSelect(this.data.id == this.model.now_select_id)
			this.RefreshUseTag()
			this.SetRedDot()
		}
	}

	public SetBgState() {

		if (this.data) {
			this.bg.visible = this.data.id != 0
			this.gray_bg.visible = this.data.id == 0
		}
	}

	public RefreshUseTag() {

		if (this.data && this.data.id != 0) {
			this.use_tag.visible = this.data.id == this.model.GetNowUseId(this.data.type)// && this.data.id != 0)
			this.fight.visible  = !this.use_tag.visible
		}
	}

	public SetSelect(bool?) {

		this.select_bg.visible = bool
	}

	public SetRedDot() {

		if (this.data) {
			this.red_dot.visible = this.data.id != 0 && (this.model.DressCanActive(this.data.type, this.data.id) || this.model.DressCanUplevel(this.data.type, this.data.id))
		}
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this.bg_2,
			this.bg,
			this.gray_bg,
			this.select_bg,
			this.red_dot,
			this.con,
			this.use_tag,
			this.dress_name,
			this.click_bg,
			this.fight,
			this._lb_fight,
			this.head
		]
			= this.GetChildrenByNames([

				"bg_2",
				"bg",
				"gray_bg",
				"select_bg",
				"red_dot",
				"con",
				"use_tag",
				"dress_name",
				"click_bg",
				"fight",
				"_lb_fight",
				"head"
			])
	}
}
window["DressItem"] = DressItem