import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { FunctionOpenModel, FunctionOpenEvent } from "../commonModel/FunctionOpenModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { PlatformManager } from "../PlatformManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, SetHtmlCenter, Util } from "../util/Util";
import { FunctionOpenListView } from "./FunctionOpenListView";
import { FunctionOpenTipView } from "./FunctionOpenTipView";

export class FunctionOpenListItem extends BaseItemRenderer {
	public WIDTH = 202
	public HEIGT = 400

	private model: FunctionOpenModel
	private item: BaseAwardItem

	public constructor() {
		super()
		this.base_file = "functionOpen"
		this.layout_file = "FunctionOpenListItem"
		this.model = FunctionOpenModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		if(PlatformManager.IsEyouEnPlatform()){
			this.name_txt.pos(31,25)
			this.name_txt.fontSize = 20
			this.name_txt.width = 138
			this.name_txt.height = 48
			this.name_txt.leading = 0.1
			this.name_txt.wordWrap = true
			this.label2.x = 35
			this.label2.y = 219
			this.reward_con.scale(0.8,0.8)
			this.reward_con.pos(63,315)
			this.red_dot.pos(119,303)
			this.goBtn.pos(49,331)
		}
		this.item = new BaseAwardItem(this.con)
		this.item.Load()
		this.item.SetItemSize(90, 90)
		this.item.SetVisible(false)

		let do_fun = () => {
			if (this.data) {
				this.model.Fire(FunctionOpenEvent.FUNCTIONOPEN_CLOSE_VIEW, "FunctionOpenListView")
				OpenFun.OpenFunHandler(this.data.jump_id)
			}
		}
		Util.AddClickEvent(this.goBtn, do_fun, this, true)

		let click_fun = () => {
			if (this.data) {
				this.model.Fire(FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, 13801, "hc", this.data.id, 2)
			}
		}
		Util.AddClickEvent(this.click_bg, click_fun, this)

		let icon_fun = () => {
			if (this.data) {
				this.model.Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenTipView", this.data)
			}
		}
		Util.AddClickEvent(this.icon, icon_fun, this)

		let update_fun = (id) => {
			if (this.data && this.data.id == id && !this.use_delete_method) {
				this.Refresh()
				let point = this.con.localToGlobal(new Laya.Point(this.con.width / 2, 0))
				let goods_list = JSON.parse(this.data.reward)
				if (goods_list && goods_list.length > 0) {
					GlobalEventSystem.Fire(EventName.REWARD_FLY, goods_list, point, undefined, undefined, 0, 0)
				}
			}
		}
		this.BindEvent(this.model, FunctionOpenEvent.FUNCTIONOPEN_GET_REWARD_SUCCESS, update_fun)
	}

	public createChildren(): void {
		super.createChildren();
	}

	public dataChanged(): void {
		if (super.dataChanged()) {
			this.Refresh()
		}
	}

	public Refresh() {
		if (this.data) {
			let reward = JSON.parse(this.data.reward)
			if (reward && reward[0]) {
				this.con.visible = true
				let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0][0], reward[0][1])
				this.item.SetVisible(true)
				this.item.SetData(goods_id, reward[0][2])
			} else {
				this.con.visible = false
				if (this.item) {
					this.item.SetVisible(false)
				}
			}
			// this.icon.visible = false
			// let call_fun = () => {
			// 	this.icon.visible = true
			// }
			ResManager.GetInstance().SetImageSprite(this.base_item, this.icon, "functionOpen", this.data.icon, false)
			this.icon.visible = true
			//ResManager.GetInstance().SetTexture(this.base_item, this.icon, GameResPath.GetFuncOpenIconPath(this.data.icon), call_fun)

			this.name_txt.text = this.data.name

			if(PlatformManager.IsEyouEnPlatform()){
				this.label2.style.fontSize = 18
				this.label2.style.color = "#663915"
				this.label2.width = 130
				this.label2.style.wordWrap = true
				this.label2.style.lineHeight = 0.1
				this.label2.style.leading = 0.1
				this.label2.style.align="center"
				this.label2.innerHTML = Util.StrToHTML(this.data.simple_desc)
				SetHtmlCenter(this.label2, { "x": 35, "w": 130 })
				this.label2.style.width = 130
				this.label1.style.fontSize = 14
				this.label1.style.bold = true
				this.label1.style.color = "#663915"
				this.label1.width = 130
				this.label1.style.lineHeight = 0.1
				this.label1.style.leading = 0.1
				this.label1.style.align="center"
				this.label1.style.wordWrap = true
				let str = Util.StrToHTML(this.data.simple_con)
				this.label1.innerHTML =str//str.replace("<br/>", "")
				SetHtmlCenter(this.label1, { "x": 35, "w": 130 })
				this.label1.style.width = 130
				this.label1.y =193 - (this.label1.contextHeight/2)
			}else{
				this.label2.style.fontSize = 18
				this.label2.style.color = "#663915"
				this.label2.width = 122
				this.label2.style.wordWrap = true
				this.label2.style.leading = 8
				this.label2.innerHTML = Util.StrToHTML(this.data.simple_desc)
				SetHtmlCenter(this.label2, { "x": 40, "w": 122 })
			this.label1.style.fontSize = 16
			this.label1.style.bold = true
			this.label1.style.color = "#663915"
			this.label1.width = 180
			this.label1.style.wordWrap = false
			this.label1.style.leading = 8
			let str = Util.StrToHTML(this.data.simple_con)
			this.label1.innerHTML = str.replace("<br/>", "")
			SetHtmlCenter(this.label1, { "x": 27, "w": 144 })
			}


			let now_show = this.model.NeedShowFunctionOpenIcon()
			this.base_item.ClearUIEffect(this.effect)
			if (now_show && this.data.id == now_show.id) {
				// this.bg.skin = AtlasUrl("functionOpen", "uignyg_011")
				Util.SetImageGray(this.bg,  false)
				this.click_bg.visible = false
				this.goBtn.visible = false
				this.red_dot.visible = false
				this.click_bg.visible = false
				this.item.SetVisible(true)
				this.label2.style.color = "#663915"
				// this.base_item.AddUIEffect("ui_advance_glow", this.effect, null, null, true)
			} else {
				let my_data = this.model.GetMyFinishFunc(this.data.id)
				// this.bg.skin = AtlasUrl("functionOpen", my_data ? "uignyg_010" : "uignyg_013")
				Util.SetImageGray(this.bg,  my_data ? false : true)
				// if (my_data) {
					// this.base_item.AddUIEffect("ui_advance_glow", this.effect, null, null, true)
				// }
				this.goBtn.visible = my_data && my_data.state == 2
				this.red_dot.visible = my_data && my_data.state != 2
				this.click_bg.visible = my_data && my_data.state != 2
				this.item.SetVisible((!my_data || my_data.state != 2))
				// this.label2.textColor = my_data ? 0xffffff : 0x9c9c9c
			}
			// if (this.data.id == 42){
			// 	this.goBtn.visible = false
			// }
		}
	}

	public DeleteMe() {
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		this.base_item.ClearUIEffect(this.effect)
		super.DeleteMe()
	}

	bg: Laya.Image
	img2: Laya.Image
	label1: Laya.HTMLDivElement
	label2: Laya.HTMLDivElement
	effect: Laya.Box
	icon_bg: Laya.Image
	icon: Laya.Image
	reward_con: Laya.Box
	con: Laya.Box
	click_bg: Laya.Box
	red_dot: Laya.Image
	goBtn: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	name_txt: Laya.Label
	public GetComponents() {
		[
			this.bg,
			this.img2,
			this.label1,
			this.label2,
			this.effect,
			this.icon_bg,
			this.icon,
			this.reward_con,
			this.con,
			this.click_bg,
			this.red_dot,
			this.goBtn,
			this._Image1,
			this._Label1,
			this.name_txt,
		]
			= this.GetChildrenByNames([

				"bg",
				"img2",
				"label1",
				"label2",
				"effect",
				"icon_bg",
				"icon",
				"reward_con",
				"con",
				"click_bg",
				"red_dot",
				"goBtn",
				"_Image1",
				"_Label1",
				"name_txt",
			])
	}
}
window["FunctionOpenListItem"] = FunctionOpenListItem