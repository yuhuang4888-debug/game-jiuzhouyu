// import { StageShowView } from "../customActivity/StageShowView"
import { GuildModel, GuildEvent } from "../commonModel/GuildModel"
import { SetHtmlCenter, Util } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { Config } from "./Config"
import { InstructionItem } from "./InstructionItem"
import { InstructionType } from "./InstructionType"
import { Enum_UILayer } from "./LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "./LoopScrowViewMgr"
import { ResManager } from "./ResManager"

export class InstructionView extends BaseView1 {
	//privates
	public instruction_id: number
	// list_loop_mgr

	Local_UpdateView
	Local_Open
	LoadSuccess
	item_List = []
	public constructor() {
		super()
		this.base_file = "common";
		this.layout_file = "InstructionView";
		this.layer_value = Enum_UILayer.Activity;
		this.is_center = true;
		this.destroy_imm = true
		this.use_background = true;
		this.click_bg_toClose = true;
		this.show_open_movie = true;
		this.load_callback =()=> {
			this.LoadSuccess()
		}
		this.open_callback =()=> {
			this.UpdateView()
		}
		this.destroy_callback =()=> {
			let item: InstructionItem
			for (let key in this.item_List) {
				item = this.item_List[key];
				item.DeleteMe()
			}
			this.item_List = [];
			// if (this.list_loop_mgr) {
			// 	this.list_loop_mgr.DeleteMe()
			// 	this.list_loop_mgr = null
			// }
		}

		this.preload_client_config = {
			"ConfigInstruction": false
		}
		this.Local_Open = (parms) => {
			if (parms) {
				this.instruction_id = parms[0]
			}
			super.Open()
		}

		this.Local_UpdateView = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigInstruction", true)
			if (this.instruction_id && cfg && this.instruction_id && cfg[this.instruction_id]) {
				let list = cfg[this.instruction_id][0]
				//this._title_lb.width = 150
				this._lb_title.text = list.view_title

				// this._list_con.dataSource = new Array(list.content.item_List)
				// this._list_con.itemRender = InstructionItem
				//SetHtmlCenter(this._title_lb, this.title_con.width, this.title_con.height)

				// if (!this.list_loop_mgr) {
				// 	this.list_loop_mgr = new LoopScrowViewMgr()
				// 	this.list_loop_mgr.SetData(this._list_con, InstructionItem, list.content.item_List, LoopScrCon.Vertical)
				// }
				// else
				// 	this.list_loop_mgr.replaceAll(list.content.item_List)
				for (let i = 0; i < list.content.item_List.length; i++) {
					let item = new InstructionItem(this._vbox_con)
					item.SetData(list.content.item_List[i])
					item.Load()
					this.item_List.push(item)
				}
			}
		}


		this.LoadSuccess = () => {

			this._panel_item.vScrollBarSkin = ""

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)


			this.BindEvent(
				GuildModel.GetInstance(),
				GuildEvent.UPDATE_ASSIST_COUNT, (scmd?) => {
					if (this.instruction_id == InstructionType.InstructionGuildHelp) {
						let limit = GuildModel.GetInstance().GetGuildKVCfg(24)
						this._lb_ins.text = "奖励领取次数：" + scmd.assist_count + "/" + limit
						this._lb_ins.visible = true
					}
				}
			)

			this._lb_ins.visible = false
			if (this.instruction_id == InstructionType.InstructionGuildHelp) {
				GuildModel.GetInstance().Fire(GuildEvent.REQUEST_PROTO, 40404)
			}
		}
	}
	public UpdateView() {
		this.Local_UpdateView()
	}
	public Open(...parms) {
		this.Local_Open(parms)
	}


	public DeleteMe() {
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_close: Laya.Image
	_panel_item: Laya.Panel
	_vbox_con: Laya.VBox
	_lb_title: Laya.Label
	_lb_ins: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_close,
			this._panel_item,
			this._vbox_con,
			this._lb_title,
			this._lb_ins,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_close",
				"_panel_item",
				"_vbox_con",
				"_lb_title",
				"_lb_ins",
			])
	}
}
window["InstructionView"] = InstructionView