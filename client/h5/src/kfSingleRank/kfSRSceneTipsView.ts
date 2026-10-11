import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { kfSingleRankModel, kfSREvent } from "../commonModel/kfSingleRankModel"

export class kfSRSceneTipsView extends BaseView1 {
Clear
ClearTween
InitEvent
LoadSuccess
Local_Open
StartAction
UpdateDunData
change_scene_close
destroy_callback
destroy_imm
is_center
percentHeight
percentWidth
preload_server_config

public constructor(){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRSceneTipsView"
	this.layer_value = Enum_UILayer.Activity
	this.destroy_imm = true
	this.is_center = true
	this.change_scene_close = false
	this.percentWidth = 100
	this.percentHeight = 100
	let _model = kfSingleRankModel.GetInstance()
	let local_kfSREvent = kfSREvent
	let local_laya = Laya
	let _ddata_ = null
	let _first_ = true
	this.load_callback = () => {
		
		this.InitEvent()
		this.LoadSuccess()
	}

	this.destroy_callback = () => {
		this.Clear()
	}

	
	this.preload_server_config = {"config_rank_dungeon":false}
	this.Local_Open = ( parms?) => {
		_ddata_ = parms
		super.Open()
	}

	this.Clear = () => {
		this.ClearTween()
	}

	this.InitEvent = () => {
		this.BindEvent(_model, local_kfSREvent.UPDATE_DUN_DATA,(scmd?) => {
				if (! _ddata_ || scmd.dun_id != _ddata_.dun_id ) {
					this.UpdateDunData(scmd)
					this.StartAction()
				}
			}
		)
	}

	this.LoadSuccess = () => {
		this.UpdateDunData(_ddata_)
		this.StartAction()
	}

	this.UpdateDunData = ( scmd?) => {
		if (! scmd ) {
			return
		}
		let lv = scmd.dun_id % 35000
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
		let ddata = _model.GetDunData(cfg, lv)
		let pic = ddata.resource
		this.ClearUIEffect(this._gp_title)
		// this.AddUIEffect("gc_" + pic, this._gp_title, null, null, true)
	}

	this.StartAction = () => {
		this.ClearTween()
		this._gp_tips.visible = true 
		this._img_black.visible = true 
		this._gp_title.visible = true 
		// this._img_black.alpha = 0
		// this._gp_title.alpha = 0
		// let add_time = (_first_ && ( 500 ) || ( 0 ) )
		// let bt = local_laya.Tween.get(this._img_black).to({alpha=1}, 500)
		// if (_first_ ) {
		// 	_first_ = false
		// 	bt.call(() => {
		// 			_model.Fire(local_kfSREvent.BLACK_CALL_BACK)
		// 		}
		// 	)
		// }
		// bt.wait(2000 + add_time):to({alpha=0}, 500).call(() => {
		// 		this._img_black.visible = false
		// 	}
		// )

		// if (_first_ ) {
		// 	_first_ = false
		// 	_model.Fire(local_kfSREvent.BLACK_CALL_BACK)
		// }
		_model.Fire(local_kfSREvent.BLACK_CALL_BACK)
		this._img_black.visible = false 
		// local_laya.Tween.get(this._gp_title):wait(500):to({alpha=1}, 1000):wait(1000 + add_time):to({alpha=0}, 500).call(() => {
		// 		this._gp_tips.visible = false
		// 	}
		// )
		this._gp_tips.visible = false 
		this.Close()
	}

	this.ClearTween = () => {
		if (this.is_loaded ) {
			// local_laya.Tween.removeTweens(this._img_black)
			// local_laya.Tween.removeTweens(this._gp_title)
		}
	}
}

public Open(data?){ 
	
	let parms = data
	this.Local_Open(parms)
}
public DeleteMe(){
	super.DeleteMe()
}


_gp_tips:Laya.Box
_img_black:Laya.Image
_img_title:Laya.Image
_img_start:Laya.Image
_gp_title:Laya.Box
public GetComponents() {
[
this._gp_tips,
this._img_black,
this._img_title,
this._img_start,
this._gp_title,
]
 = this.GetChildrenByNames([

"_gp_tips",
"_img_black",
"_img_title",
"_img_start",
"_gp_title",
])
}
}
 window["kfSRSceneTipsView"]= kfSRSceneTipsView