import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GetSizeDeltaX, GetSizeDeltaY, SetAnchoredPosition, SetLocalScale, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class FlowerEffectView extends BaseView1 {
	Clear
	ClearRPREffect
	ClearTimer
	CreateRPREffect
	GetDataByType
	InitEvent
	LoadSuccess
	ShowFlowerEffect
	// _gp_rpr
	// _group_eff
	_rpr_list
	destroy_callback
	is_center
	is_delay_callback
	need_loading_view
	not_close_by_android_back_key
	open_callback
	percentHeight
	percentWidth
	preload_client_config
	CheckToClose
	// touchEnabled
	flower_effect_playing = false
	RPR_effect_playing = false
	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "FlowerEffectView"
		this.layer_value = Enum_UILayer.Top
		this.is_delay_callback = false
		// this.is_center = true
		this.need_loading_view = false
		this.not_close_by_android_back_key = true
		this.not_tooltips_jump_close = true
		// this.percentWidth = 100
		// this.percentHeight = 100
		// this.touchEnabled = false
		let _model = MarriageModel.GetInstance()
		let _effect_playing_ = false
		let _flower_cfg_ = null
		let _timer_id_ = null
		let _timer_list_ = []
		let _ratio_width_ = 0
		let _ratio_height_ = 0
		let local_MarriageEvent = MarriageEvent
		let local_laya = Laya


		this.load_callback = () => {
			this.display_obj.left = 0;
			this.display_obj.right = 0;
			this.LoadSuccess()
			this.InitEvent()
		}
		this.open_callback = () => {

		}

		this.destroy_callback = () => {
			this.Clear()
		}

		// this.preload_client_config = { "ConfigFlowerEffect": false }
		this.Clear = () => {
			//this:ClearUIEffect(this._group_eff)
			this.ClearRPREffect()
			this.ClearTimer()
			_flower_cfg_ = null
		}

		this.CheckToClose = () => {
			if (this.flower_effect_playing == false && this.RPR_effect_playing == false) {
				this.Close()
			}
		}

		this.InitEvent = () => {
			this.BindEvent(_model, local_MarriageEvent.STOP_FLOWER_EFFECT, () => {
				this.ClearUIEffect(this._group_eff)
				this.ClearTimer()
			}
			)
		}

		this.LoadSuccess = () => {
			_ratio_width_ = LayerManager.GetInstance().stageWidth / GetSizeDeltaX(this.display_obj)
			_ratio_height_ = LayerManager.GetInstance().stageHeight / GetSizeDeltaY(this.display_obj)
			this.ShowFlowerEffect()
		}

		this.ShowFlowerEffect = () => {
			if (_effect_playing_) {
				return
			}
			let list = _model.GetFlowerEffectList()
			let vo = table.shift(list)
			if (!vo) {
				return
			}
			_effect_playing_ = true
			let eff_name = vo.effect
			this.flower_effect_playing = true
			let data = {
				call_back_func: () => {
					_effect_playing_ = false
					if (_model.GetFlowerEffectList() > 0) {
						this.ShowFlowerEffect()
					} else {
						this.flower_effect_playing = false
						this.CheckToClose()
					}
				}
			}
			// console.log("测试++" + eff_name)
			this.AddUIEffect(eff_name, this.display_obj, null, null, true, 3, data.call_back_func, null, null, null, null, LOAD_QUEUE.LOW, false);//, null, null, null, 5, data.call_back_func)


			//let prop_cfg = _flower_cfg_["com_prop"][eff_name]
			//if (prop_cfg ) {
			//_effect_playing_ = true
			//let scale = prop_cfg && prop_cfg.scale
			//this:AddUIEffect2(eff_name, this._group_eff, null, scale, null, null,() => {
			//_effect_playing_ = false
			//if (_model.length.GetFlowerEffectList() > 0 ) {
			//this:ShowFlowerEffect()
			//}
			//}
			//)
			//}else{
			//let data = _flower_cfg_["show_data"][eff_name]
			//if (data ) {
			//let rtable = this.GetDataByType(data.show_type)
			//if (! _timer_list_ ) {
			//_timer_list_ = []
			//}
			//_effect_playing_ = true
			//this:ClearTimer()
			////this:ClearUIEffect(this._group_eff)
			//_timer_id_ = setTimeout(() => {
			//_effect_playing_ = false
			//if (_model.length.GetFlowerEffectList() > 0 ) {
			//this:ClearTimer()
			////this:ClearUIEffect(this._group_eff)
			//this:ShowFlowerEffect()
			//}
			//}
			//,  data.keep_time)
			//for (let _tmpi in data.effects) {
			// var subData = data.effects[_tmpi]
			//let timer_id = setTimeout(() => {
			//let pos = [x=subData.pos.x * rtable.x, y=subData.pos.y * rtable.y]
			//let scale = [x=subData.scale.x * rtable.x, y=subData.scale.y * rtable.y]
			////this:AddUIEffect2(eff_name, this._group_eff, pos, scale, subData.loop, null, null, null, null, true)
			//}
			//, subData.time)
			//table.insert(_timer_list_, timer_id)
			//}
			//}
			//}
		}

		this.ClearTimer = () => {
			if (!_timer_id_) {
				return
			}
			clearTimeout(_timer_id_)
			_timer_id_ = null
			if (_timer_list_) {
				for (let _tmpi in _timer_list_) {
					var id = _timer_list_[_tmpi]
					clearTimeout(id)
				}
				_timer_list_ = []
			}
		}

		this.GetDataByType = (show_type?) => {
			let rtable = { x: 1, y: 1 }
			if (1 == show_type) {
				rtable.x = _ratio_width_
				rtable.y = _ratio_height_
			} else if (2 == show_type) {
				rtable.x = _ratio_width_
				rtable.y = _ratio_width_
			} else if (3 == show_type) {
				rtable.x = _ratio_height_
				rtable.y = _ratio_height_
			}
			return rtable
		}

		this.ClearRPREffect = () => {
			if (!this._rpr_list) {
				return
			}
			let count = this._gp_rpr.numChildren
			let i = 0
			do {
				let img = this._rpr_list[i]
				img.visible = false
				if (this["tween" + i]) {
					SYTweenLite.Stop(this["tween" + i])
					this["tween" + i] = null
				}
				i = i + 1
			} while ((i < count)
			)
		}

		this.CreateRPREffect = () => {
			if (!this.is_loaded) return
			if (!this._rpr_list) {
				this._rpr_list = []
			}
			let func = () => {
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.WAVE_RED_PACKET, false)
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "RPRShowView")
			}
			this.RPR_effect_playing = true
			// let width = 720 - 81
			// let height = this.display_obj.height - 119
			// let cow = 0
			// let col = 0
			// let cowR = 0
			// let colR = 0
			let count = this._gp_rpr.numChildren
			this._gp_rpr.mouseEnabled = true
			let i = 0
			let tween_num = 0
			if (i < count) {
				do {
					let img = this._rpr_list[i]
					let parent: Laya.Box = <Laya.Box>this._gp_rpr.getChildAt(i)
					if (!img) {
						img = new Laya.Image(GameResPath.GetIcon("mainUI", "uihby_015"));// NewImage(this, this.display_obj.parent, new Vector2(81, 119), Enum_UILayer.Top, false, true, func, "mainUI_asset", "uihby_015") //Laya.Image.New("mainUI_asset.uihby_015")
						parent.addChild(img)
						parent.mouseEnabled = true
						this._rpr_list[i] = img
						Util.AddClickEvent(img, func, this)
					}
					let scale = Util.RandomRange(0.7, 1)
					SetLocalScale(img, scale, scale, scale)
					let x = Util.RandomRange(-15, 15)
					let y = Util.RandomRange(-15, 15)
					y = y - this.display_obj.height - 100
					SetAnchoredPosition(img, x, y)
					if (this["tween" + i]) {
						SYTweenLite.Stop(this["tween" + i])
						this["tween" + i] = null
					}
					Laya.Tween.clearTween(img)
					let time = Util.RandomRange(10, 12)
					y = GetSizeDeltaY(this.display_obj) + 100
					this["tween" + i] = SYTweenLite.to(this, img, SYTweenLite.UiAnimationType.POSY, y, time, () => {
						SYTweenLite.Stop(this["tween" + i])
						this["tween" + i] = null
						tween_num++
						// if (tween_num == count)
						// 	this._gp_rpr.mouseThrough = true
						//CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.WAVE_RED_PACKET, false)
					}, SYTweenFunc.LINEAR)
					//Laya.Tween.get(img).to({y=this.height + 100}, time)
					i = i + 1
				} while ((i < count)
				)
			}
		}
	}

	public Open(...new_args) {
		super.Open()
	}



	_group_eff: Laya.Box
	_gp_rpr: Laya.Box
	_Group1: Laya.Box
	_Group2: Laya.Box
	_Group3: Laya.Box
	_Group4: Laya.Box
	_Group5: Laya.Box
	_Group6: Laya.Box
	_Group7: Laya.Box
	_Group8: Laya.Box
	_Group9: Laya.Box
	_Group10: Laya.Box
	_Group11: Laya.Box
	_Group12: Laya.Box
	_Group13: Laya.Box
	_Group14: Laya.Box
	public GetComponents() {
		[
			this._group_eff,
			this._gp_rpr,
			this._Group1,
			this._Group2,
			this._Group3,
			this._Group4,
			this._Group5,
			this._Group6,
			this._Group7,
			this._Group8,
			this._Group9,
			this._Group10,
			this._Group11,
			this._Group12,
			this._Group13,
			this._Group14,
		]
			= this.GetChildrenByNames([

				"_group_eff",
				"_gp_rpr",
				"_Group1",
				"_Group2",
				"_Group3",
				"_Group4",
				"_Group5",
				"_Group6",
				"_Group7",
				"_Group8",
				"_Group9",
				"_Group10",
				"_Group11",
				"_Group12",
				"_Group13",
				"_Group14",
			])
	}
}
window["FlowerEffectView"] = FlowerEffectView