import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { table } from "../common/table"
import { kfSingleRankModel, kfSREvent, kfSingleRankDefine } from "../commonModel/kfSingleRankModel"
import { Util } from "../util/Util"
import { kfSRRankItem } from "./kfSRRankItem"

export class kfSRRankView extends BaseView1 {
Clear
InitEvent
LoadSuccess
Local_Open
Scr_Scroller1
UpdateItems
click_bg_toClose
destroy_callback
destroy_imm
is_center
loop_list
use_background

public constructor(){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRRankView"
	this.layer_value = Enum_UILayer.Activity
	this.destroy_imm = true
	this.use_background = true
	this.click_bg_toClose = true
	this.is_center = true
	let _model = kfSingleRankModel.GetInstance()
	let local_kfSREvent = kfSREvent
	let _ac_list_ = null
	let _area_id_ = 0
	this.load_callback = () => {
		
		this.LoadSuccess()
	}

	this.destroy_callback = () => {
		this.Clear()
	}

	this.Local_Open = ( parms?) => {
		_area_id_ = parms[0]
		super.Open()
	}

	this.Clear = () => {
		_area_id_ = 0
		_model.ClearAreaTopData()
		if (this.loop_list ) {
			this.loop_list.DeleteMe()
			this.loop_list = null
		}
	}

	this.InitEvent = () => {
		Util.AddClickEvent(this._btn_close,() => {
				this.Close()
			}
			, this, true)
		this.BindEvent(_model, local_kfSREvent.UPDATE_TOP,(scmd?) => {
				if (_area_id_ == scmd.area_id ) {
					this.UpdateItems(scmd)
				}
			}
		)
	}

	this.LoadSuccess = () => {

		this.InitEvent()
		let tdata = _model.GetAreaTopData(_area_id_)
		if (tdata ) {
			this.UpdateItems(tdata)
		} else if (_area_id_ ) {
			_model.Fire(local_kfSREvent.REQUEST_PROTO, 50703, "c", _area_id_)
		}
	}

	this.UpdateItems = ( scmd?) => {
		let list = scmd.challengers
		let count = kfSingleRankDefine.LAYER_COUNT
		let plist = []

		
		for (let i = count; i >= 1; i -= 1) {
			let level = (scmd.area_id - 1) * count + i
			let data = scmd.challenger_dic[level] || {level : level}
			table.insert(plist, data)
		}

		if(!this.loop_list){
			this.loop_list =  new LoopScrowViewMgr()
			this.loop_list.SetData(this.Content, kfSRRankItem, plist, LoopScrCon.Vertical)
		}else{
			this.loop_list.replaceAll(plist)
		}
	
		
	}
}

public Open(...new_args){ 
	
	let parms = new_args
	this.Local_Open(parms)
}

public DeleteMe(){
	super.DeleteMe()
}


_Image1:Laya.Image
_img_title:Laya.Image
_lb_t:Laya.Label
_Image2:Laya.Image
_btn_close:Laya.Image
_Group1:Laya.Box
_Image5:Laya.Image
_Label1:Laya.Label
_Label2:Laya.Label
_Label3:Laya.Label
_Label4:Laya.Label
Content:Laya.List
public GetComponents() {
[
this._Image1,
this._img_title,
this._lb_t,
this._Image2,
this._btn_close,
this._Group1,
this._Image5,
this._Label1,
this._Label2,
this._Label3,
this._Label4,
this.Content,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_title",
"_lb_t",
"_Image2",
"_btn_close",
"_Group1",
"_Image5",
"_Label1",
"_Label2",
"_Label3",
"_Label4",
"Content",
])
}
}
 window["kfSRRankView"]= kfSRRankView