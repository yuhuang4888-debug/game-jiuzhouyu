import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { kfSingleRankModel, kfSRTimer, kfSREvent, kfSingleRankDefine } from "../commonModel/kfSingleRankModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDelta } from "../util/Util"

export class kfSRVictoryView extends BaseView1 {
CheckTimer
Clear
GoToNexlDun
InitEvent
LoadSuccess
Local_Open
Scr_scroller
SendEnterDun
StartExitTimer
StartTimer
UpdateExitTimer
UpdateItems
UpdateTimer
UpdateView
close_callback
delay_delete_time
destroy_callback
is_center
not_show_main_msg
open_callback
preload_server_config
use_background

public constructor(){
super() 
	
	this.base_file = "kfSingleRank"
	this.layout_file = "kfSRVictoryView"
	this.layer_value = Enum_UILayer.Activity
	this.delay_delete_time = 2000
	this.is_center = true
	this.use_background = true
	this.not_show_main_msg = true
	let _model = kfSingleRankModel.GetInstance()
	let local_kfSRTimer = kfSRTimer
	let local_Util = Util
	let base_dungeon_model = BaseDungeonModel.GetInstance()
	let SCMD_REQUEST = BaseDungeonModel.SCMD_REQUEST
	let local_kfSREvent = kfSREvent
	this.preload_server_config={"config_rank_dungeon":false}
	let local_TimeUtil = TimeUtil
	let _item_list_ = []
	let _end_time_ = null
	let _data_ = null
	let voice
	this.load_callback = () => {
		
		this._scroller.vScrollBarSkin=""
		this.LoadSuccess()
	}

	this.open_callback = () => {
		this.UpdateView()
		// this.AddUIEffect("UI_2104", this.layer_value, this._gp_fly, null, null, false)
		// this.CoverEffect(this._Group1)
	}

	this.destroy_callback = () => {
		this.Clear()
	}

	this.close_callback = () => {
		this.Clear()
	}
	this.Local_Open = ( parms?) => {
		_data_ = parms
		super.Open()
	}

	this.Clear = () => {

		if (voice) {
			SoundManager.GetInstance().StopSoundEffect(voice)
			voice = null
		}
		_model.ClearTimer(local_kfSRTimer.KEEP_ON.key)
		for (let _tmpi in _item_list_) {
			var item = _item_list_[_tmpi]
			item.DeleteMe()
		}
		_item_list_ = []
	}

	this.InitEvent = () => {
		Util.AddClickEvent(this._btn_exit,() => {
				base_dungeon_model.Fire(SCMD_REQUEST, 61002)
				this.Close()
			}
			, this, true)
		Util.AddClickEvent(this._btn_go,() => {
				this.GoToNexlDun()
				this.Close()
			}
			, this, true)
		this.BindVar(_model, "_player_info",() => {
				this.CheckTimer()
			}
		)
		this.BindEvent(_model, local_kfSREvent.BLACK_CALL_BACK,(scmd?) => {
				this.SendEnterDun()
			}
		)
	}

	this.LoadSuccess = () => {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("dungeonCommon", "com_up_bg1"))
		// this.AddUIEffect("ui_challenge_glow", this._gp_fly, null, {x=1.25, y=1.25}, false, false, false, false, true)
		// this.AddUIEffect("ui_victory_glow1", this._gp_victory, null, {x=1.4, y=1.4}, true, false, false, false, false, true)
		this.InitEvent()
		
		_model.Fire(local_kfSREvent.REQUEST_PROTO, 50701)

		voice=CommonManager.GetInstance().PlayFightingVoice(2)
	}

	this.UpdateItems = ( list?) => {
		let i = 0
		do {
			let vo = list[i]
			let item = _item_list_[i]
			if (! item ) {
				item =  new EquipmentItem(this.Content)
				item.Load()
				item.SetItemSize(94, 94)
				_item_list_[i] = item
			}
			let type_id, is_lock
			[type_id, is_lock ] = GoodsModel.GetInstance().GetMappingTypeId(vo.stype, vo.typeId)
			item.SetData(type_id, vo.count, is_lock)
			i=i+1
		} while ((i < list.length))

		let allw=94*list.length+(list.length-1)*this.Content.space
		this.Content.x=(this._scroller.width-allw)/2
	}

	this.UpdateView = () => {
		let data = _data_
		if (data.become_challengers == 1 ) {
			this._img_tips.visible = true 
			// this._img_tips.scaleY = 3
			// this._img_tips.scaleX = this._img_tips.scaleY
			// Laya.Tween.get(this._img_tips).to({scaleX=1, scaleY=1}, 200)
		}
		let time = local_TimeUtil.timeConversionWithMillisecond(data.go_time, "mm:ss.ms")
		this._lb_time.text = "通关时间：" + time
		let list = data.reward_list
		let not_empty = list.length > 0
		this._scroller.visible = not_empty 
		this._lb_none.visible=!not_empty
		//this._lb_tips.text = (not_empty && ( "获得奖励" ) || ( "试炼通过" ) )
		if (not_empty ) {
			this.UpdateItems(list)
		}
	}

	this.CheckTimer = () => {
		let pinfo = _model.GetPlayerInfo()
		if (! pinfo ) {
			return
		}
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
		let len = Util.TableSize(cfg)
		let lv = _data_.level
		let max = pinfo.level_list.length >= kfSingleRankDefine.LAYER_COUNT * 2
		let cant_go = max && lv == _model.GetCurLevel() || lv == len
		this._btn_go.visible = ! cant_go 
		this._btn_exit.x=! cant_go ?179:289
		// this._btn_go.includeInLayout = ! cant_go
		if (cant_go ) {
			this.StartExitTimer()
		}else{
			this.StartTimer()
		}
	}

	this.StartTimer = () => {
		_end_time_ = local_TimeUtil.getServerTime() + 5
		_model.ClearTimer(local_kfSRTimer.KEEP_ON.key)
		_model.StartTimer(local_kfSRTimer.KEEP_ON.key, 1000,() => {
			this.UpdateTimer()
		})
		this.UpdateTimer()
	}

	this.StartExitTimer = () => {
		_end_time_ = local_TimeUtil.getServerTime() + 5
		_model.ClearTimer(local_kfSRTimer.KEEP_ON.key)
		_model.StartTimer(local_kfSRTimer.KEEP_ON.key, 1000,() => {
			this.UpdateExitTimer()
		})
		this.UpdateExitTimer()
	}

	this.UpdateTimer = () => {
		if (this.use_delete_method ) {
			return
		}
		let rtime = _end_time_ - local_TimeUtil.getServerTime()
		if (rtime > 0 ) {
			this._lb_go.text = "挑战下一关（" + rtime + "s）"
			this._lb_go.x=-11
			this._Image3.width=200
		}else{
			this._lb_go.text = "挑战下一关"
			this._lb_go.x=16
			this._Image3.width=142
			_model.ClearTimer(local_kfSRTimer.KEEP_ON.key)
			this.GoToNexlDun()
			this.Close()
		}
	}

	this.UpdateExitTimer = () => {
		if (this.use_delete_method ) {
			return
		}
		let rtime = _end_time_ - local_TimeUtil.getServerTime()
		if (rtime > 0 ) {
			this._lb_exit.text = "退出（" + rtime + "s）"
		}else{
			this._lb_exit.text = "退出"
			_model.ClearTimer(local_kfSRTimer.KEEP_ON.key)
			this.Close()
		}
	}

	this.GoToNexlDun = () => {
		let is_field = SceneManager.GetInstance().IsFieldScene()
		if (is_field ) {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
			let ddata = _model.GetDunData(cfg, _data_.level + 1)
			if (ddata ) {
				let data = {dun_id : ddata.dungeon_id}
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "kfSRSceneTipsView", data)
			}
		}else{
			this.SendEnterDun()
		}
	}

	this.SendEnterDun = () => {
		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
		let ddata = _model.GetDunData(cfg, _data_.level + 1)
		if (ddata ) {
			base_dungeon_model.Fire(SCMD_REQUEST, 61001, ddata.dungeon_id)
		}
	}
}

public Open(scmd?){ 
	
	this.Local_Open(scmd)
}

public DeleteMe(){
	super.DeleteMe()
}


_Group2:Laya.Box
_Image1:Laya.Image
_Image7:Laya.Image
_Image8:Laya.Image
_Image10:Laya.Image
_Label1:Laya.Label
_gp_victory:Laya.Box
_gp_fly:Laya.Box
_gp_data:Laya.Box
_scroller:Laya.Panel
Content:Laya.HBox
_lb_time:Laya.Label
_lb_none:Laya.Label
_btn_exit:Laya.Box
_Image2:Laya.Image
_lb_exit:Laya.Label
_btn_go:Laya.Box
_Image3:Laya.Image
_lb_go:Laya.Label
_img_tips:Laya.Image
public GetComponents() {
[
this._Group2,
this._Image1,
this._Image7,
this._Image8,
this._Image10,
this._Label1,
this._gp_victory,
this._gp_fly,
this._gp_data,
this._scroller,
this.Content,
this._lb_time,
this._lb_none,
this._btn_exit,
this._Image2,
this._lb_exit,
this._btn_go,
this._Image3,
this._lb_go,
this._img_tips,
]
 = this.GetChildrenByNames([

"_Group2",
"_Image1",
"_Image7",
"_Image8",
"_Image10",
"_Label1",
"_gp_victory",
"_gp_fly",
"_gp_data",
"_scroller",
"Content",
"_lb_time",
"_lb_none",
"_btn_exit",
"_Image2",
"_lb_exit",
"_btn_go",
"_Image3",
"_lb_go",
"_img_tips",
])
}
}
 window["kfSRVictoryView"]= kfSRVictoryView