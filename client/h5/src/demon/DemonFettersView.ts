import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { DemonModel } from "../commonModel/DemonModel";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { DemonFettersItem } from "./DemonFettersItem";

export class DemonFettersView extends BaseView1 {
	demon_id
	demon_model
	item_ac:LoopScrowViewMgr
	res_mgr: ResManager

	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonFettersView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.demon_id = null

		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.preload_server_config = {
			"config_demons_fetters": false
		}
		this.load_callback = () => {
			this._Scroller1.scrollBar.visible=false
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if(this.item_ac){
				this.item_ac.DeleteMe()
				this.item_ac=null
			}
		}

	}

	public LoadSuccess() {
		let list = []
		let demons_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons", false)
		let demons_fetters_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_fetters", false)
		let fetters_list = demons_cfgs && demons_cfgs[this.demon_id] && JSON.parse(demons_cfgs[this.demon_id].fetters)
		if (fetters_list) {
			for (let _tmpi in fetters_list) {
				let fetter_id = fetters_list[_tmpi]
				list.push(demons_fetters_cfgs[Number(fetter_id)])
			}
		}
		if(!this.item_ac){
			this.item_ac=new LoopScrowViewMgr()
			this.item_ac.SetData(this._Scroller1,DemonFettersItem,list,LoopScrCon.Vertical)
		}else{
			this.item_ac.replaceAll(list)
		}
		this.InitEvent()
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)
	}


	public Open(...parms) {
		this.demon_id = parms[0]
		super.Open()
	}


_img_bg:Laya.Image
_img_close:Laya.Image
_Image1:Laya.Image
_Image4:Laya.Image
title:Laya.Label
_Scroller1:Laya.List
public GetComponents() {
[
this._img_bg,
this._img_close,
this._Image1,
this._Image4,
this.title,
this._Scroller1,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_close",
"_Image1",
"_Image4",
"title",
"_Scroller1",
])
}
}
 window["DemonFettersView"]= DemonFettersView