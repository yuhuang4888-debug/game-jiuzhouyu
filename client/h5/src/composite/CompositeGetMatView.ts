import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Config } from "../common/Config"
import { MaterialsItem } from "../common/MaterialsItem"
import { table } from "../common/table"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"

export class CompositeGetMatView extends BaseView1 {
	open_type
	loop_mgr
	item_list
	cur_com_id_
	public constructor() {
		super()
		this.base_file = "composite"
		this.layout_file = "CompositeGetMatView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.destroy_imm = true

		this.load_callback = () => {
			this.itemScroller.vScrollBarSkin = ""
			this.InitEvent()
			this.InitView()
		}

		this.close_callback = () => {
			for(let i in this.item_list){
				let item = this.item_list[i]
				item.DeleteMe()
			}
			this.item_list = null
		}
	}

	public Open(...new_args) {
		this.open_type = new_args[0]
		this.cur_com_id_ = new_args&&new_args[1]
		super.Open()
	}
	
	public InitEvent() {
		let close_fun = () => {
			this.Close()
		}
		Util.AddClickEvent(this.btnClose, close_fun, this, true)
		this.BindEvent(GlobalEventSystem, EventName.MATERIAL_VIEW_CLOSE, close_fun)
	}

	private InitView() {
		let openList = []

		//御魂合成 不显示vip
		if(this.open_type!="CompositeRuneView"){
			let main_role = RoleManager.GetInstance().GetMainRoleVo()
			let show_svip = main_role.vip_flag >= 4
			if (show_svip) {
				table.insert(openList, [226])
			} else {
				table.insert(openList, [8])
			}
		}


		let cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigCompositeSource[this.open_type]
		if (cfg && cfg.source) {
			for(let i in cfg.source) {
				let vo = cfg.source[i]
				table.insert(openList, [vo])
			}
		}

		this.item_list = []
		for (let i in openList) {
			let info = openList[i]
			let item = new MaterialsItem(this.item_con)
			item.SetData(info,this.cur_com_id_)
			item.Load()
			this.item_list[i] = item
		}
	}

	_bg1: Laya.Image
	_bg2: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Label
	btnClose: Laya.Image
	itemScroller: Laya.Panel
	item_con: Laya.VBox
	public GetComponents() {
		[
			this._bg1,
			this._bg2,
			this._Image2,
			this._Image3,
			this.btnClose,
			this.itemScroller,
			this.item_con,
		]
			= this.GetChildrenByNames([
				"_bg1",
				"_bg2",
				"_Image2",
				"_Image3",
				"btnClose",
				"itemScroller",
				"item_con",
			])
	}
}
window["CompositeGetMatView"] = CompositeGetMatView