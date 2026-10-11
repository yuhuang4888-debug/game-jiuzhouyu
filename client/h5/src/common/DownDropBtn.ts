
//require("game.common.DownDropList")
//require("game.common.DownDropItem")

import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util, SetAnchoredPosition, SetAnchoredPositionX, SetAnchoredPositionY, SetHtmlCenter } from "../util/Util"
import { BaseItem1 } from "./BaseItem1"
import { DownDropList } from "./DownDropList"
import { EventName } from "./EventName";

export class DownDropBtn extends BaseItem1 {
	public _group: Laya.Box;
	public _Image1: Laya.Image;
	public _img_arrow: Laya.Image;
	public _lb_content: Laya.HTMLDivElement;


	CallBack
	_list_class
	notTouchData
	Refuse

	callback
	data_list
	ani
	is_array
	default_content
	key
	UpdateItem
	_down_drop
	SetArrowAnchorPosition
	down
	SetTouchData
	uilayer
	SetSelectIndex
	Init

	show_count

	OpenDownDropList
	resType: any
	cache_index = -1

	//是否自定义标题
	is_custom_html = false
	CustomHtml
	html_width = 136
	html_height = 35
	CustomHtmlCenter
	UpdateHtmlPos

	public constructor(parent) {
		super(parent)
		this._list_class = DownDropList
		this.base_file = "common"
		this.layout_file = "DownDropBtn"

		this.load_callback = () => {
			// this.GetComponents()
			if (!this.is_custom_html) {
				this._lb_content.style.fontSize = 20
				this._lb_content.style.color = "#5A1C20"
				this._lb_content.style.align = "center"
				this._lb_content.style.wordWrap = false
			} else {
				this.CustomHtml()
			}

			// this._lb_content.style.valign = "middle"
			// this._lb_content.style.wordWrap = true
			// this._group = _group
			// this._img_arrow = this.GetChild("_group/_img_arrow").gameObject.GetComponent("Image")
			// this._lb_content = this.GetChild("_group/_lb_content").gameObject.GetComponent("Text")

			Util.AddClickEvent(this._group, () => {
				if (this.notTouchData && this.notTouchData.notTouch) {
					Message.show(this.notTouchData.alert_con)
					return
				}
				GlobalEventSystem.Fire(EventName.DROP_ITEM_CLICK, this.display_obj)
				this.OpenDownDropList()
			}, this)

			this.BindEvent(GlobalEventSystem, EventName.DROP_ITEM_BE_CLICK, () => {
				if (this._down_drop) {
					this._down_drop.DeleteMe()
					this._down_drop = null
				}
			})
			this.BindEvent(GlobalEventSystem, EventName.DROP_ITEM_CLICK, (obj) => {
				if (obj == this.display_obj) return
				if (this._down_drop) {
					this._down_drop.DeleteMe()
					this._down_drop = null
				}
			})
			this.UpdateItem()
			if (this.cache_index >= 0) {
				this.SetSelectIndex(this.cache_index)
				this.cache_index = -1
			}
		}

		this.Init = (data_list?, callback?, default_content?, key?, uilayer?, show_count?, down?, ani?, is_array?, notTouchData?) => {
			if (down == null) {
				down = true
			}
			if (ani == null) {
				ani = false
			}
			this.data_list = data_list
			this.callback = callback
			this.default_content = default_content
			this.key = key
			this.uilayer = uilayer
			this.show_count = show_count
			this.down = down
			this.ani = ani
			this.is_array = is_array
			this.notTouchData = notTouchData
		}

		this.UpdateItem = () => {
			if (this.default_content) {
				this._lb_content.innerHTML = Util.StrToHTML(this.default_content)
				this.UpdateHtmlPos()
			} else {
				for (let key in this.data_list) {
					this.CallBack(key, this.data_list[key])
					break
				}
			}
			if (!this.down) {
				this._img_arrow.rotation = -90// .transform.localRotation = Quaternion.Euler(0,0,180)
			}
		}

		this.SetArrowAnchorPosition = (pos_x?, pos_y?) => {
			if (pos_x && pos_y) {
				SetAnchoredPosition(this._img_arrow, pos_x, pos_y)
			} else {
				if (pos_x) {
					SetAnchoredPositionX(this._img_arrow, pos_x)
				} else {
					SetAnchoredPositionY(this._img_arrow, pos_y)
				}
			}
		}

		this.CallBack = (index?, data?) => {
			this._lb_content.innerHTML = Util.StrToHTML(this.key && data[this.key] || data)
			this.UpdateHtmlPos()
			this.callback(index, data)
		}

		this.OpenDownDropList = () => {
			let list_class = this._list_class
			this._down_drop = new list_class(this.display_obj)
			this._down_drop.Init(this.data_list, this.CallBack, this.display_obj, this.uilayer, this.show_count, this.key, this.down, this.ani, this.is_array)
			this._down_drop.SetRes(this.resType)
			this._down_drop.Load()
		}

		this.SetSelectIndex = (index?) => {
			if (!this.is_loaded) {
				this.cache_index = index
				return
			}
			let data = this.data_list[index]
			this._lb_content.innerHTML = Util.StrToHTML(this.key && data[this.key] || data)
			this.UpdateHtmlPos()
			this.callback(index, data)
		}

		this.Refuse = (index?) => {
			if (this.default_content && this.is_loaded) {
				this._lb_content.innerHTML = Util.StrToHTML(this.default_content)
				this.UpdateHtmlPos()
			}
		}

		this.SetTouchData = (data?) => {
			this.notTouchData = data
		}

		this.CustomHtml = () => { }
		this.CustomHtmlCenter = () => { }
		this.UpdateHtmlPos = () => {
			if (!this.is_custom_html) {
				//SetHtmlCenter(this._lb_content, { w: this.html_width }, { h: this.html_height })
			} else {
				this.CustomHtmlCenter()
			}

		}
	}

	public SetRes(base_file?, layout_file?) {
		this.base_file = base_file
		this.layout_file = layout_file
	}

	public SetSize(w, h) {
		if (w && h) {
			this.display_obj.width = w
			this.display_obj.height = h
		}
	}

	public DeleteMe() {
		if (this._down_drop) {
			this._down_drop.DeleteMe()
		}
		this._down_drop = null
		super.DeleteMe()
	}
	public GetComponents() {
		[
			this._group,
			this._Image1,
			this._img_arrow,
			this._lb_content,
		]
			= this.GetChildrenByNames([

				"_group",
				"_Image1",
				"_img_arrow",
				"_lb_content",
			])
	}
}
window["DownDropBtn"] = DownDropBtn