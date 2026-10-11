import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { WordManager } from "../common/WordManager";
import { MonBookModel } from "../commonModel/MonBookModel";
import { Message } from "../sysInfo/SysInfoController";
import { SetHtmlCenter, Util } from "../util/Util";
import { MonBookAttrItem } from "./MonBookAttrItem";
import { MonBookCardItem } from "./MonBookCardItem";
import { MonBookSubItem } from "./MonBookSubItem";

export class MonBookGroupItem extends BaseItemRenderer {

	WIDTH = 613
	HEIGT = 364

	model
	status
	show_attr
	book_item_list
	play_star_eff
	last_lv
	// attr_list
	att_loop:LoopScrowViewMgr
	public constructor(parent) {
		super()
		this.base_file = "monBook"
		this.layout_file = "MonBookGroupItem"
		this.model = MonBookModel.GetInstance()
		this.show_attr = false
		this.load_callback =()=> {
			this.LoadSuccess()
			this.InitEvent()
		}
		this.Load()
	}

	private LoadSuccess() {
		this.scroll1.hScrollBar.visible = false
		// this.scroll2.vScrollBar.visible = false
		// if (this.need_refresh_data) {
		// 	this.UpdateView()
		// 	this.need_refresh_data = false
		// }
	}

	private InitEvent() {
		let click_func = () => {
			if (this.status == 0)
				Message.show("当前组合图谱等级不足~")
			else if (this.status == 1)
				this.model.Fire(MonBookModel.SCMD_REQUEST, 44204, this.data.id)
			else
				Message.show("当前组合图谱已满级")
		}
		Util.AddClickEvent(this._gp_activation, click_func, this, true)

		this.BindEvent(this.model, MonBookModel.PLAY_STAR_EFFECT, (group_id) => {
			if (this.data && this.data.id == group_id)
				this.play_star_eff = true
		})

	}

	public dataChanged(){
		if (!super.dataChanged()) {
			return
		}
		this.UpdateView()
		
	}


	private UpdateView() {
		if (this.data) {
			let max_lv = this.model.GetBookGroupMaxLevel(this.data.id)
			let curr_lv = this.model.GetBookGroupLevel(this.data.type, this.data.id)
			this._lb_name.text = this.data.name.trim()
			this.SetStars(curr_lv)
			let str = `全部图谱达到<font color="#0a953e">Lv.${curr_lv + 1}</font>`
			if (curr_lv >= max_lv)
				str = "已达最大共鸣等级"
			this._lb_tips.style.color = "#663915"
			this._lb_tips.style.fontSize = 22
			this._lb_tips.style.bold = true
			this._lb_tips.innerHTML = Util.StrToHTML(str)
			SetHtmlCenter(this._lb_tips, { "x": 0, "w": 613 })
			this.SetPropInfo()

			if (this.model.IsGroupReachMaxLevel(this.data.type, this.data.id)) {
				this._img_red.visible = false
				this.status = 2
			}
			else {
				let config_mon_pic_group = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_group", false)
				if (this.model.IsShowSingleGroupDot(this.data.type, this.data.id, config_mon_pic_group)) {
					this._img_red.visible = true
					this.status = 1
				}
				else {
					this._img_red.visible = false
					this.status = 0
				}
			}

			if (curr_lv == 0)
				this._lb_activation.text = "激活"
			else
				this._lb_activation.text = "升级"

			this.SetMonBookItemList(this.data)
		}
	}

	public DeleteMe() {
		if (this.book_item_list) {
			for (let vo of this.book_item_list) {
				vo.DeleteMe()
			}
			this.book_item_list = null
		}
		if(this.att_loop){
			this.att_loop.DeleteMe()
			this.att_loop = null
		}

		if(this._gp_start_effect){
			this.base_item.ClearUIEffect(this._gp_start_effect)
		}

		if (this.scroll2&&this.scroll2.scrollBar) {
			this.scroll2.scrollBar.off(Laya.Event.START, this, this.onListStart)
		}

		super.DeleteMe()
	}
	private SetStars(value: number) {
		if (this.play_star_eff) {
			this.play_star_eff = false
			this.base_item.AddUIEffect("ui_star", this._gp_start_effect, { x: (14 + (value - 1) * 38), y: 14 }, 2, false)
		}

		for (let i = 0; i < this._gp_star.numChildren; i++) {
			let bool = false
			if (value > i)
				bool = true
			let star: Laya.Image = this._gp_star.getChildAt(i) as Laya.Image
			if (star)
				star.visible = bool
		}
	}

	private SetMonBookItemList(data) {
		let max_lv = this.model.GetBookGroupMaxLevel(data.id)
		let curr_lv = this.model.GetBookGroupLevel(data.type, data.id)

		let next_lv = curr_lv + 1
		if (next_lv >= max_lv)
			next_lv = max_lv

		let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_group", false)
		let cfg = config[data.id + "@" + next_lv]

		if (!cfg)
			return

		let book_list = []
		let list = JSON.parse(cfg.need_list)
		let id, need_lv
		let pic_cfg = this.model.GetMonPicCfg()
		if (list && list.length > 0) {
			for (let data of list) {
				id = Number(data[0])
				need_lv = Number(data[1])
				if (id && need_lv) {
					if (pic_cfg[id])
						book_list.push({ "0": pic_cfg[id], "1": need_lv })
				}
			}
		}
		
			
		if (this.book_item_list){
			let book_item 
			for (let i = 0; i < this.book_item_list.length; i++){
				book_item = this.book_item_list[i]
				book_item.DeleteMe()
				book_item = null
			}
			this.book_item_list = []
		}else{
			this.book_item_list = []
		}

		this._gp_card_item
		let item:MonBookCardItem
		for (let i in book_list) {
			item = this.book_item_list[i]
			if (!item) {
				item = new MonBookCardItem(this._gp_card_item)
				this.book_item_list[i] = item
				item.Load()
			}
			item.SetVisible(true)
			item.SetData(book_list[i])
		}

		// for (let i = len; i < this.book_item_list.length; i++)
		// 	this.book_item_list[i].SetVisible(false)
	}

	private SetPropInfo() {
		let data = this.data
		let curr_lv = this.model.GetBookGroupLevel(data.type, data.id)
		let cfg
		let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_group", false)
		if (curr_lv == 0) {
			cfg = config[data.id + "@1"]
		}
		else {
			cfg = config[data.id + "@" + curr_lv]
		}

		if (!cfg)
			return
		let curr_value_list = []

		let str, value
		let list = JSON.parse(cfg.attr)
		if (list && list.length > 0) {
			for (let i in list) {
				let v = list[i]
				let data = {}
				if (!curr_value_list[i])

					if (curr_lv == 0) {
						data["now_value"] = 0
					}
					else {
						value = WordManager.ConvertToPercentValue(Number(v[0]), Number(v[1]))
						data["now_value"] = value
					}
				str = WordManager.GetProperties(v[0])
				data["name"] = str + "："
				curr_value_list.push(data)
			}
		}

		cfg = config[data.id + "@" + (curr_lv + 1)]

		if (cfg) {
			list = JSON.parse(cfg.attr)
			if (list && list.length > 0) {
				for (let i in list) {
					let data = curr_value_list[i]

					let v = list[i]
					value = WordManager.ConvertToPercentValue(Number(v[0]), Number(v[1]) - (data.value || 0))
					data["add_value"] = value
				}
			}
		}

		// if (!this.attr_list)
		// 	this.attr_list = []

		// let len = curr_value_list.length
		// for (let i = 0; i < this.attr_list.length; i++){
		// 	this.attr_list[i].SetVisible(false)
		// }
		
		// let count = 1
		// for (let key in curr_value_list) {
		// 	let item:MonBookAttrItem = this.attr_list[key]
		// 	if (!item) {
		// 		item = new MonBookAttrItem(this._gp_attr_con)
		// 		this.attr_list[key] = item
		// 		item.Load()
		// 		item.SetPosition((count - 1) % 2 * 300, Math.floor((count - 1) / 2) * 40)
		// 	}
		// 	count = count + 1
		// 	item.SetData(curr_value_list[key])
		// 	item.SetVisible(true)
		// }

		if(!this.att_loop){
			this.att_loop = new LoopScrowViewMgr()
			this.att_loop.SetData(this.scroll2,MonBookAttrItem,curr_value_list,LoopScrCon.Vertical)
			this.scroll2.scrollBar.on(Laya.Event.START, this, this.onListStart)
		}else{
			this.att_loop.replaceAll(curr_value_list)
		}
	}

	private onListStart(){
		if (!this.parent || !this.parent) return
		let list:Laya.List = this.parent.parent as Laya.List
		if(list&&list.scrollBar){
			list.scrollBar.stopScroll()
		}
	}

	

bg_img:Laya.Image
group1:Laya.HBox
img2:Laya.Image
img3:Laya.Image
img4:Laya.Image
img5:Laya.Image
img6:Laya.Image
img7:Laya.Image
img8:Laya.Image
img9:Laya.Image
img10:Laya.Image
img11:Laya.Image
img12:Laya.Image
_gp_star:Laya.HBox
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_Image6:Laya.Image
_Image7:Laya.Image
_Image8:Laya.Image
_Image9:Laya.Image
_Image10:Laya.Image
_Image11:Laya.Image
_gp_start_effect:Laya.Box
_lb_name:Laya.Label
scroll1:Laya.Panel
_gp_card_item:Laya.HBox
_gp_activation:Laya.Box
_Image12:Laya.Image
_lb_activation:Laya.Label
_img_red:Laya.Image
scroll2:Laya.List
line1:Laya.Image
_lb_tips:Laya.HTMLDivElement
public GetComponents() {
[
this.bg_img,
this.group1,
this.img2,
this.img3,
this.img4,
this.img5,
this.img6,
this.img7,
this.img8,
this.img9,
this.img10,
this.img11,
this.img12,
this._gp_star,
this._Image1,
this._Image2,
this._Image3,
this._Image4,
this._Image5,
this._Image6,
this._Image7,
this._Image8,
this._Image9,
this._Image10,
this._Image11,
this._gp_start_effect,
this._lb_name,
this.scroll1,
this._gp_card_item,
this._gp_activation,
this._Image12,
this._lb_activation,
this._img_red,
this.scroll2,
this.line1,
this._lb_tips,
]
 = this.GetChildrenByNames([

"bg_img",
"group1",
"img2",
"img3",
"img4",
"img5",
"img6",
"img7",
"img8",
"img9",
"img10",
"img11",
"img12",
"_gp_star",
"_Image1",
"_Image2",
"_Image3",
"_Image4",
"_Image5",
"_Image6",
"_Image7",
"_Image8",
"_Image9",
"_Image10",
"_Image11",
"_gp_start_effect",
"_lb_name",
"scroll1",
"_gp_card_item",
"_gp_activation",
"_Image12",
"_lb_activation",
"_img_red",
"scroll2",
"line1",
"_lb_tips",
])
}
}
 window["MonBookGroupItem"]= MonBookGroupItem