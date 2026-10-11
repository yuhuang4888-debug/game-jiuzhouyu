import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BrightSeaEvent, BrightSeaModel, SortType } from "../commonModel/BrightSeaModel"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, Util } from "../util/Util"
import { BrightSeaPlunderLogItem } from "./BrightSeaPlunderLogItem"

export class BrightSeaPlunderLogView extends BaseView1 {
Emp_btn_plunder
Emp_obj_fight
Emp_obj_lv
Emp_obj_ship
InitEvent
LoadSuccess
Local_Open
Scr_Scroller1
SelectFunc
UpdateSortType
UpdateView
click_bg_toClose
close_callback
data_list
default_auto_id
destroy_imm
is_center
item_list
model
open_callback
use_background

//require("game.brightSea.BrightSeaPlunderLogItem")

public constructor(){
super() 
	
	
	this.base_file = "brightSea"
	this.layout_file = "BrightSeaPlunderLogView"
	this.destroy_imm = true
	this.layer_value = Enum_UILayer.Activity
	this.is_center = true
	this.use_background = true
	this.click_bg_toClose = true
	
	this.model = BrightSeaModel.GetInstance()
	this.item_list = null

	let sort_type = SortType.ShipId
	let add_order = true
	
	this.load_callback = () => {
		ResManager.GetInstance().SetOutsideImageSprite(this,this._Image5,GameResPath.GetIcon("brightSea","uitc_023"))
		ResManager.GetInstance().SetOutsideImageSprite(this,this._image_split,GameResPath.GetIcon("common2","com_line_5"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("brightSea","ui_bright_02"))
		ResManager.GetInstance().SetImageSpriteTrans(this, this._Image2, GameResPath.GetIcon("brightSea","uixhrz_005"))
		this.InitEvent()
		this.LoadSuccess()
	}
	
	this.Local_Open = ( parms?) => {
		if (parms ) {
			this.default_auto_id = parms
		}
		super.Open()
	}

	this.open_callback = () => {
		
	}
	
	this.close_callback = () => {
		sort_type = SortType.ShipId
		add_order = true

		if (this.item_list ) {
			this.item_list.DeleteMe()
			this.item_list = null
		}
	}
	
	this.LoadSuccess = () => {
		
		this.UpdateView()
	}

	this.InitEvent = () => {
		this.BindVar(this.model, "curise_log_list",() => {
			this.UpdateView()
		})

		this.BindEvent(
            this.model,
            BrightSeaEvent.UPDATE_SEND_LIST_ADD,() => {
                this.UpdateView()
            }
		)
		
		Util.AddClickEvent(this._img_close,() => {
				this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

		Util.AddClickEvent(this._obj_lv,() => {
			this.UpdateSortType(SortType.Level)
		}, this)

		Util.AddClickEvent(this._obj_ship,() => {
			this.UpdateSortType(SortType.ShipId)
		}, this)

		Util.AddClickEvent(this._obj_fight,() => {
			this.UpdateSortType(SortType.Fight)
		}, this)

		Util.AddClickEvent(this._btn_plunder,() => {
			if (! this.data_list || ! this.item_list ) {
				return 
			}

			let index = this._gp_item_con.selectedIndex
			if (! this.data_list[index] ) {
				return 
			}

			let ship_data = this.data_list[index]
			this.model.Fire(BrightSeaEvent.OPEN_VIEW, "BrightSeaPlunderDialog", ship_data)

		}, this, true)
	}
	
	this.UpdateSortType = ( new_sort_type?) => {
		if (sort_type != new_sort_type ) {
			sort_type = new_sort_type
		}else{
			add_order = ! add_order
		}
		this.UpdateView()
	}

	this.SelectFunc = ( item?) => {
		//console.log("_____selectFunc", item.gameObject.name)
	}

	this.UpdateView = () => {
		let list = this.model.GetShipSendList(sort_type, add_order) //or this.model.BrightTestData.send_list
		if (! list ) { 
			return 
		}

		this.data_list = list
		let len = list.length
		this._con_empty.visible = len < 1 
		if (len > 0 ) {
			if (! this.item_list ) {
				this.item_list =  new LoopScrowViewMgr()
				this.item_list.SetData(this._gp_item_con, BrightSeaPlunderLogItem, list, LoopScrCon.Vertical, 1,(index?) => {
					this.SelectFunc(index)
				})
			}else{
				this.item_list.replaceAll(list)
			}

			//console.log("______this.default_auto_id", this.default_auto_id)
			if (this.default_auto_id ) {
				let index = -1
				let data
				for (let i = 0; i < list.length; i++){
					data = list[i]
					if (data.auto_id == this.default_auto_id ) {
						index = i
						break	
					}
				}
				//console.log("____________index", index)
				if (index != -1 ) {
					this.item_list.SetSelectIndex(index)
				}
				this.default_auto_id = null
			}else{
				let index = this.model.GetPerfactEmemyShip(list)
				this.item_list.SetSelectIndex(index)
			}
		}

		let main_info = this.model.main_info
		if (main_info ) {
			this._plunder_num.text = (main_info.total_rob_times - main_info.rob_times) + "/" + main_info.total_rob_times
		}else{
			this._plunder_num.text = ""
		}
	}
}

public Open(...new_args){ 
	
	this.Local_Open(...new_args)
}


_Image1:Laya.Image
_img_close:Laya.Image
_image_split:Laya.Image
_Image2:Laya.Image
_Image4:Laya.Image
_Group1:Laya.Box
_Image5:Laya.Image
_Image6:Laya.Image
_Image81:Laya.Image
_Image9:Laya.Image
_Image10:Laya.Image
_Image11:Laya.Image
_Image12:Laya.Image
_Image13:Laya.Image
_Image14:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label41:Laya.Label
_Label5:Laya.Label
_obj_lv:Laya.Box
_obj_guild:Laya.Box
_obj_ship:Laya.Box
_obj_fight:Laya.Box
_gp_item_con:Laya.List
_lb_tips:Laya.Label
_btn_plunder:Laya.Box
_Image8:Laya.Image
_Label4:Laya.Label
_label2:Laya.Label
_plunder_num:Laya.Label
_con_empty:Laya.Box
label:Laya.Label
img:Laya.Image
public GetComponents() {
[
this._Image1,
this._img_close,
this._image_split,
this._Image2,
this._Image4,
this._Group1,
this._Image5,
this._Image6,
this._Image81,
this._Image9,
this._Image10,
this._Image11,
this._Image12,
this._Image13,
this._Image14,
this._Label1,
this._Label2,
this._Label3,
this._Label41,
this._Label5,
this._obj_lv,
this._obj_guild,
this._obj_ship,
this._obj_fight,
this._gp_item_con,
this._lb_tips,
this._btn_plunder,
this._Image8,
this._Label4,
this._label2,
this._plunder_num,
this._con_empty,
this.label,
this.img,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_close",
"_image_split",
"_Image2",
"_Image4",
"_Group1",
"_Image5",
"_Image6",
"_Image81",
"_Image9",
"_Image10",
"_Image11",
"_Image12",
"_Image13",
"_Image14",
"_Label1",
"_Label2",
"_Label3",
"_Label41",
"_Label5",
"_obj_lv",
"_obj_guild",
"_obj_ship",
"_obj_fight",
"_gp_item_con",
"_lb_tips",
"_btn_plunder",
"_Image8",
"_Label4",
"_label2",
"_plunder_num",
"_con_empty",
"label",
"img",
])
}
}
 window["BrightSeaPlunderLogView"]= BrightSeaPlunderLogView