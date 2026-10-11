import { textChangeRangeIsUnchanged } from "../../node_modules/typescript/lib/typescript"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { GuildActivityModel } from "../commonModel/GuildActivityModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { EveningIntroItem } from "./EveningIntroItem"
import { EveningIntroTextItem } from "./EveningIntroTextItem"

export class EveningIntroView extends BaseView1 {
	_ac_btn: LoopScrowViewMgr
	_is_load_success
	back_login_toClose
	cfg_list
	click_bg_toClose
	default_index
	destroy_callback
	is_center
	item_list:Array<EveningIntroTextItem>
	model
	open_callback
	preload_client_config
	show_open_movie
	use_background


	public constructor() {
		super()

		this.model = GuildActivityModel.GetInstance();
		// this.default_index = 0
		this.default_index = 1
		this._is_load_success = false;
		this.base_file = "evening"
		this.layout_file = "EveningIntroView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.back_login_toClose = true
		this.destroy_imm = true
		this.item_list = []
		this.preload_client_config = { "ConfigGuildAct": false }
		this.load_callback = () => {
			this._Scroller1.vScrollBarSkin = ""
			this.LoadSuccess()
		}
		this.open_callback = () => {

		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.open_callback = () => {
		}
	}

	public Open(parms?) {

		this.default_index = parms
		super.Open()
	}

	// function EveningIntroView.Close()
	// 	super.Close()
	// }

	public Clear() {

		// this._list_btn.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, this.SelectItem, this)
		if (this._ac_btn) {
			this._ac_btn.DeleteMe()
			this._ac_btn = null
		}
		for (let i = 0; i < this.item_list.length; i++) {
			var item = this.item_list[i]
			item.DeleteMe()
		}
		this.item_list = []
	}

	public LoadSuccess() {

		this._is_load_success = true
		this.InitView()
		this.InitEvent()
		ResManager.GetInstance().SetOutsideImageSprite(this, this.img_line, GameResPath.GetIconOtherPath("evening", "uighgha_012ba"))
	}

	public InitView() {

		let GetClientCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigGuildAct", true)
		this.cfg_list = this.model.GetClientCfg(GetClientCfg, "evening_intro_cfg")
		this._ac_btn = new LoopScrowViewMgr()
		this._ac_btn.SetData(this._list_btn, EveningIntroItem, this.cfg_list, LoopScrCon.Vertical, 1, (item?, index?) => {
			this.SelectItem(item)
		}, this.default_index)
	}

	public InitEvent() {

		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}
			, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
	}


	public SelectItem(item?) {
		this.UpdateContent(this.cfg_list[item])
	}

	public UpdateContent(data?) {
		let str
		if (data.id == 2) {
			if (GuildActivityModel.GetInstance().EveningGameType() == 2) {
				str = data.content2 + ""
			} else {
				str = data.content + ""
			}
		} else {
			str = data.content + ""
		}

		//规则数据
		let str_list = str.split("\n")

		if(!this.item_list)this.item_list=[]
		for(let k=0;k<this.item_list.length;k++){
			this.item_list[k].SetVisible(false)
		}

		for (let i = 0; i < str_list.length; i++) {
			var v = str_list[i]

			let item: EveningIntroTextItem = this.item_list[i]
			if (!item) {
				item = new EveningIntroTextItem(this._group_data)
				item.Load()
				table.insert(this.item_list, item)
			}
			item.SetVisible(true)
			item.SetData(v)
		}

	}



	img_bg: Laya.Image
	_Group1: Laya.Box
	_Image4: Laya.Image
	img_title: Laya.Image
	_Image5: Laya.Image
	_Scroller1: Laya.Panel
	_group_data: Laya.VBox
	_btn_close: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_list_btn: Laya.List
	img_line: Laya.Image
	public GetComponents() {
		[
			this.img_bg,
			this._Group1,
			this._Image4,
			this.img_title,
			this._Image5,
			this._Scroller1,
			this._group_data,
			this._btn_close,
			this._Image1,
			this.labelDisplay,
			this._list_btn,
			this.img_line,
		]
			= this.GetChildrenByNames([

				"img_bg",
				"_Group1",
				"_Image4",
				"img_title",
				"_Image5",
				"_Scroller1",
				"_group_data",
				"_btn_close",
				"_Image1",
				"labelDisplay",
				"_list_btn",
				"img_line",
			])
	}
}
window["EveningIntroView"] = EveningIntroView