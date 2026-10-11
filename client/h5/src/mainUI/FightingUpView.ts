import { BaseView1 } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WingsComponentView } from "../pet/wings/WingsComponentView"
import { GameResPath } from "../util/GameResPath"
import { Runner } from "../util/Runner"
import { GetQualifiedClassName } from "../util/Util"

export class FightingUpView extends BaseView1 {

	/**
	 * 界面靠下的位置
	 */
	bottom = 400
	/**
	 * 每次更新战斗力后特效多少帧出现
	 */
	play_effect_frame = 0
	/**
	 * 战力增量多少帧开始移动
	 */
	fight_add_font_start_move_frame = 5
	/**
	 * 战力增量移动多少帧
	 */
	fight_add_font_move_frame = 5
	/**
	 * 战力增量移动多少距离(像素)
	 */
	fight_add_font_move_distance = 30



	/**
	 * 战力数字多少帧开始变化
	 */
	fight_font_change_start_frame = 5

	/**
	 * 战力数字变化帧数
	 */
	fight_font_change_frame = 10

	/**
	 * 战力增量数字变化帧数(战力增量数值值不做变化效果)
	 */
	 fight_add_font_change_frame = 5


	/**
	 * 整体动画结束后停留多少秒后关闭
	 */
	wait_time = 1.8

	real_fight_value = 0
	local_fight_value = 0
	fight_change_value = 0
	
	real_fight_add_value = 0
	local_fight_add_value = 0
	fight_add_change_value = 0

	is_playing = false
	update_id = null
	cache_old_fight = null
	cache_new_fight = null

	
	sound_play_interval = 8
	has_set_effect = false
	has_set_fight_add_font_pos = false
	is_first_open = true
	can_replay_fight_effect = false
	fight_add_font_change_end_frame
	fight_font_change_end_frame
	real_play_effect_frame

	now_frame = 0
	time_id = null


	fighting_effect
	timer_id_list = []
	cache_add_y
	end_add_y
	cache_fight_x
	update_fight_effect_time_id

	need_offset_base_window_dic = {
		"MountPetView":{
			"HorseComponentView":200,
			"PartnerComponentView":200,
			"PartnerBaseView":200
		},
		"RoleView":{
			"WingsComponentView":200,
			"ArtifactComponentView":200,
			"HolyDeviceComponentView":200,
			"BackOrnamentComponentView":200
		}
	}


	runner: Runner
	res_mgr: ResManager
	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "FightingUpView"
		this.layer_value = Enum_UILayer.FightingUp
		this.delay_delete_time = 1000 * 60
		
		this.runner = Runner.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			let bottom = this.bottom
			let base_window = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT
			if(base_window){
				let base_class_name = GetQualifiedClassName(base_window)
				if(this.need_offset_base_window_dic[base_class_name] && base_window.viewList){
					//@ts-ignore
					let sub_class = base_window.viewList[base_window.cur_index]
					if(sub_class){
						let sub_class_name = GetQualifiedClassName(sub_class)
						if(this.need_offset_base_window_dic[base_class_name][sub_class_name]){
							bottom += this.need_offset_base_window_dic[base_class_name][sub_class_name]
						}
					}
				}
			}

			this.display_obj.bottom = bottom

			this._lb_add_fight.visible = false
			this._lb_add_fight.y = this.cache_add_y
			this._box_effect.width = LayerManager.GetInstance().stageWidth
			this._box_effect.height = LayerManager.GetInstance().stageHeight
			this.SetAnimation(this.cache_old_fight, this.cache_new_fight)
		}

		this.close_callback = () =>{
			this.Remove()
		}

		this.destroy_callback = () => {
			// this.Remove()
		}
	}

	Remove() {
		this.runner.RemoveRunObj(this.hashCode)
		this.update_id = false
		this.now_frame = 0
		this.local_fight_value = 0
		this.real_fight_value = 0
		this.local_fight_add_value = 0
		this.real_fight_add_value = 0
		this.has_set_effect = false
		this.has_set_fight_add_font_pos = false
		this.is_first_open = true
		this.can_replay_fight_effect = false
		if(this.update_fight_effect_time_id){
			clearTimeout(this.update_fight_effect_time_id)
		}
		this.update_fight_effect_time_id = undefined
		this.CancelTime()
	}

	InitEvent() {

	}

	LoadSuccess() {

		this.display_obj.centerX = 0

		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("mainUI", "manui_ui_fighting_bg"))

		this.cache_add_y = this._lb_add_fight.y
		this.end_add_y = this._lb_add_fight.y - this.fight_add_font_move_distance
		this._lb_add_fight.y = this.cache_add_y

		this.cache_fight_x = this._lb_fight.x

		this._lb_fight.fontSize = 50
		ResManager.GetInstance().LoadFont(this, "fight_up", this._lb_fight, 50)

		this._lb_add_fight.fontSize = 50
		ResManager.GetInstance().LoadFont(this, "fight_up2", this._lb_add_fight, 50)

		this.InitEvent()

		this._box_effect.centerX = -125
		this._box_effect.centerY = 0
	}

	SetAnimation(old_fight?, new_fight?) {
		if (!old_fight || new_fight <= old_fight) {
			return
		}

		this.CancelTime()

		if(!this.local_fight_value){
			this.local_fight_value = old_fight
		}
		this.real_fight_value = new_fight
		this.fight_change_value = this.real_fight_value - this.local_fight_value

		let add = new_fight - old_fight
		if(!this.local_fight_add_value){
			this.local_fight_add_value = add
		}
		this.real_fight_add_value+=add
		this.fight_add_change_value = this.real_fight_add_value - this.local_fight_add_value
		if(this.is_first_open){
			this.is_first_open = false
			this._lb_fight.text = String(this.local_fight_value)
			//提升战力数值右对齐
			let add_str = "+" + this.local_fight_add_value
			let add_len = this.GetFontWidth(add_str, "fight_up2")
			let fight_len = this.GetFontWidth(this.real_fight_value, "fight_up")

			this._lb_add_fight.x = this.cache_fight_x + fight_len - add_len
			this._lb_add_fight.text = add_str
			this.fight_font_change_end_frame = this.fight_font_change_frame + this.fight_font_change_start_frame
			this.fight_add_font_change_end_frame = 0
			this.now_frame = 0
		}
		else{
			this.fight_font_change_end_frame = Math.max(this.now_frame + this.fight_font_change_frame, this.fight_font_change_frame + this.fight_font_change_start_frame)
			this.fight_add_font_change_end_frame = this.now_frame + this.fight_add_font_change_frame
		}


		if(this.can_replay_fight_effect){
			this.can_replay_fight_effect = false
			this.has_set_effect = false
			this.real_play_effect_frame = this.now_frame + this.play_effect_frame
		}
		
		this.is_playing = true
		if (!this.update_id) {
			this.update_id = true
			this.runner.AddRunObj(this)
		}
	}

	Update(now_time?, elapse_time?) {
		if (this.is_playing) {
			++this.now_frame
			if(this.now_frame >= this.play_effect_frame && !this.has_set_effect)
			{
				this.AddUIEffect("ui_zhanli", this._box_effect, null, 1, null, 3, () =>
				{
					if (this._box_effect) {
						this.ClearUIEffect(this._box_effect)
                    }
				}, null, null, null, null, null, false)
				this.has_set_effect = true
				if(this.update_fight_effect_time_id){
					clearTimeout(this.update_fight_effect_time_id)
				}
				this.update_fight_effect_time_id = setTimeout(() => {
					this.can_replay_fight_effect = true
				}, 1300);
			}

			if(!this.has_set_fight_add_font_pos && this.now_frame >= this.fight_add_font_start_move_frame){
				// if(!this._lb_add_fight.visible){
				this._lb_add_fight.visible = true
				// }
				if(this.now_frame < this.fight_add_font_start_move_frame + this.fight_add_font_move_frame){
					let count = this.now_frame - this.fight_add_font_start_move_frame
					this._lb_add_fight.y = count / this.fight_add_font_move_frame * (this.end_add_y - this.cache_add_y) + this.cache_add_y
				}
				else{
					this._lb_add_fight.y = this.end_add_y
					this.has_set_fight_add_font_pos = true
				}
			}

			if (this.now_frame >= this.fight_font_change_start_frame && this.now_frame <= this.fight_font_change_end_frame) {
				if (this.now_frame < this.fight_font_change_end_frame) {
					let value = this.real_fight_value - Math.floor(this.fight_change_value * (this.fight_font_change_end_frame - this.now_frame) / this.fight_font_change_frame)
					this.local_fight_value = value
					this._lb_fight.text = String(value)
				} else if (this.now_frame >= this.fight_font_change_end_frame) {
					this._lb_fight.text = String(this.real_fight_value)
				}
			}

			if (this.fight_add_font_change_end_frame && this.now_frame <= this.fight_add_font_change_end_frame) {
				if (this.now_frame < this.fight_add_font_change_end_frame) {
					let value = this.real_fight_add_value - Math.floor(this.fight_add_change_value * (this.fight_add_font_change_end_frame - this.now_frame) / this.fight_add_font_change_frame)
					this.local_fight_add_value = value
					this._lb_add_fight.text = "+" + value
				} else if (this.now_frame >= this.fight_add_font_change_end_frame) {
					this._lb_add_fight.text = "+" + this.real_fight_add_value
				}
			}

			let fight_add_bool = !this.fight_add_font_change_end_frame || this.now_frame > this.fight_add_font_change_end_frame
			let fight_bool = this.now_frame > this.fight_font_change_end_frame
			if (fight_add_bool && fight_bool) {
				this.is_playing = false
				this.StartTime()
			}
		}
	}

	GetFontWidth(str, font_name){

		str = String(str)
		let len = 0
		let str_len = str.length
		let cfgs = {
			"fight_up":{
				default: 32,
				"0": 33,
				"7": 33,
				"8": 33,
				"1": 20,
			},
			"fight_up2":{
				default: 32,
				"4": 33,
				"9": 33,
				"1": 20,
			},

		}

		let cfg = cfgs[font_name]
		if(!cfg) return 0 

		let temp_l
		let s
		for(let i = 0;i < str_len; i++){
			s = str[i]
			temp_l = cfg[s]
			if(!temp_l){
				len += cfg.default
			}
			else{
				len += temp_l
			}
			
		}
		return len
	}

	// PlayFightingUpEffect( ){
	// 	if(!this.fighting_effect)
	// 	{
	// 		this.fighting_effect = true
	// 		this.AddUIEffect("ui_zhanli",this._box_effect, null, 1, false, -1)
	// 	}
		
	// 	if(this._box_effect && this._box_effect.visible == false){
	// 		this._box_effect.visible = true
	// 	}
	// } 

	// ResetFightingUpEffect( ){
	// 	if(this._box_effect && this._box_effect.visible == true){
	// 		this._box_effect.visible = false
	// 	}
	// }

	StartTime() {
		if (!this.time_id) {
			this.time_id = setTimeout(() => {
				this.Close()
			}, this.wait_time * 1000)
		}
	}

	CancelTime() {
		if (this.time_id) {
			clearTimeout(this.time_id)
			this.time_id = false
		}
	}

	SetData(old_fight?, new_fight?) {
		this.cache_old_fight = old_fight
		this.cache_new_fight = new_fight
	}


	_img_bg: Laya.Image
	_lb_fight: Laya.Label
	_lb_add_fight: Laya.Label
	_box_effect: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._lb_fight,
			this._lb_add_fight,
			this._box_effect,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_fight",
				"_lb_add_fight",
				"_box_effect",
			])
	}
}
window["FightingUpView"] = FightingUpView