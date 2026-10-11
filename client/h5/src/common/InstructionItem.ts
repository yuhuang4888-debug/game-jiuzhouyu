import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";
import { BaseItem1 } from "./BaseItem1";
import { BaseItemRenderer } from "./BaseItemRenderer";
import { InstructionSmallItem } from "./InstructionSmallItem";
import { ResManager } from "./ResManager";

export class InstructionItem extends BaseItem1 {
	private item_list = []
	data
	parent

	need_refresh_data = false
	constructor(parent) {
		super(parent);
		this.parent = parent
		this.base_file = "common"
		this.layout_file = "InstructionItem"

		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess(){
		this._html_title.style.fontSize = 20
		this._html_title.style.color = "#763320"
		this._html_title.style.stroke = 2
		this._html_title.style.strokeColor = "#dfd1cd"
		this._html_title.style.bold = true
		this._html_title.style.wordWrap = false

		if(this.need_refresh_data){
			this.need_refresh_data = false
			this.UpdateItem()
		}
	}

	public UpdateItem(): void {

		let list = this.data
		let show_title = list.item_title != undefined

		this._box_title.visible = show_title
		if(show_title){
			this._vbox_con.y = 43
			this._html_title.innerHTML = list.item_title
		}
		else{
			this._vbox_con.y = 0
		}


		let len = list.item_content.length, item: InstructionSmallItem, info

		let load_count = 0 
		let call_back = () =>{
			load_count ++
			if(load_count == len){
				this._vbox_con.callLater(()=>{
					if(this.use_delete_method) return
					this._vbox_con.event(Laya.Event.RESIZE);
					this.display_obj.callLater(()=>{
						if(this.use_delete_method) return
						this.display_obj.height = this._vbox_con.y + this._vbox_con.height
					})
				})
			}
		}


		for (let i: number = 0; i < len; i++) {
			item = this.item_list[i]
			info = list.item_content[i]
			if (!item) {
				item = new InstructionSmallItem(this._vbox_con)
				item.Load()
				this.item_list.push(item)
			}
			item.SetVisible(true)
			item.SetData(info)
			item.ExcuteCallback(call_back)
		}

		if(this.item_list.length > len){
			for (let i: number = len; i < this.item_list.length; i++) {
				item = this.item_list[i];
				item.SetVisible(false)
			}
		}

	}

	public SetData(info?) {
		this.data = info
		if(this.is_loaded){
			this.UpdateItem()
		}
		else{
			this.need_refresh_data = true
		}
	}

	public DeleteMe(): void {

		let item: InstructionSmallItem
		for (let key in this.item_list) {
			item = this.item_list[key];
			item.DeleteMe()
		}
		this.item_list.length = 0
		super.DeleteMe()
	}


	_box_title: Laya.Box
	_img_bg: Laya.Image
	_html_title: Laya.HTMLDivElement
	_vbox_con: Laya.VBox
	public GetComponents() {
		[
			this._box_title,
			this._img_bg,
			this._html_title,
			this._vbox_con,
		]
			= this.GetChildrenByNames([

				"_box_title",
				"_img_bg",
				"_html_title",
				"_vbox_con",
			])
	}
}
window["InstructionItem"] = InstructionItem