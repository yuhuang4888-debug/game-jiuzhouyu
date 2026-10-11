import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BossModel } from "../commonModel/BossModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { EudaemonTaskTabItem } from "./EudaemonTaskTabItem"


import "./EudaemonRankView"
import "./EudaemonShopView"

export class EudaemonTaskView extends BaseView1 {
	tab_item_list
	item_iist
	tab_info
	select_index

	boss_model: BossModel
	public constructor() {
		super()
		this.base_file = "eudaemon"
		this.layout_file = "EudaemonTaskView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		this.boss_model = BossModel.GetInstance()

		this.tab_info = [
			{ name: "商城", class: "EudaemonShopView" }, 
			{ name: "榜单", class: "EudaemonRankView" }
		]

		this.preload_client_config  ={
			"ClientStarEquip":false
		}

		this.preload_server_config = {
			"config_eudemons_boss_rank_reward":false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public LoadSuccess = () => {
		this.boss_model.Fire(BossModel.SCMD_REQUEST, 47021)

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)


		Util.AddClickEvent(this._img_tips, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.EudaemonTask)
		}, this, true)

		this.tab_item_list = []
		for (let i = 0; i < this.tab_info.length; i++) {
			let item = new EudaemonTaskTabItem(this._box_tab)
			item.SetData(this.tab_info[i], i)
			item.SetClickCall(this.ShowItem)
			item.SetPosition(Number(i) * 132, 0)
			item.Load()
			this.tab_item_list[i] = item
		}
		
		this.item_iist = []
		this.ShowItem(0)

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("eudaemon", "ui_kf_dgxs005"))
	}

	public ShowItem = (index?) => {
		if (this.select_index == index) {
			return
		}

		let tab_item = this.tab_item_list[this.select_index]
		if (tab_item) {
			tab_item.SetSelect(false)
		}

		tab_item = this.tab_item_list[index]
		if (tab_item) {
			tab_item.SetSelect(true)
		}

		
		let item = this.item_iist[index]
		if (!item) {
			let class_name: any = window[this.tab_info[index].class]
			item = new class_name(this._box_item)
			item.Load()
			this.item_iist[index] = item
		}


		item = this.item_iist[this.select_index]
		if (item) {
			item.SetVisible(false)
		}

		item = this.item_iist[index]
		if (item) {
			item.SetVisible(true)
		}

		this.select_index = index
	}

	public Remove = () => {
		if (this.item_iist) {
			for (let _tmpi in this.item_iist) {
				var vo = this.item_iist[_tmpi]
				vo.DeleteMe()
			}
			this.item_iist = null
		}
		if (this.tab_item_list) {
			for (let _ in this.tab_item_list) {
				var v = this.tab_item_list[_]
				v.DeleteMe()
			}
			this.tab_item_list = null
		}
		this.select_index = null
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_close: Laya.Image
	_img_tips: Laya.Image
	_box_item: Laya.Box
	_box_tab: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_close,
			this._img_tips,
			this._box_item,
			this._box_tab,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_close",
				"_img_tips",
				"_box_item",
				"_box_tab",
			])
	}
}
window["EudaemonTaskView"] = EudaemonTaskView