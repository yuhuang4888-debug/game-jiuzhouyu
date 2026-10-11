import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TaskModel } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { MainUIModel } from "../commonModel/MainUIModel"
import { Mathf } from "../util/Mathf"
import { ViewManager } from "../common/ViewManager"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { MainFuncIconItem } from "./MainFuncIconItem"
import { StoryModel } from "../commonModel/StoryModel"

export class MainUIDownView extends BaseView1 {

	public static Max_Type = 1

	mainUI_model:MainUIModel
	role_mgr:RoleManager
	view_mgr:ViewManager
	task_model:TaskModel

	icon_tween_list = null
	icon_item_list

	exp_ani_data_list = []
	time_interval = 0.5
	is_ani_exp = false
	delay_refresh_time_id

	need_refresh_time_interval = false
	tween_event_list = []
	max_len = 722
	local_level = 0
	max_cache_count = 20
	refresh_item_id
	icon_type_to_index
	has_set_exp_effect
	exp_time_id

	//当前指引对象
	is_need_switch = false

	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "MainUIDownView"
		this.layer_value = Enum_UILayer.Activity
		this.not_tooltips_jump_close = true
		this.is_delay_callback = false
		this.not_close_by_android_back_key = true

		this.mainUI_model = MainUIModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.task_model = TaskModel.GetInstance()
		this.view_mgr = ViewManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.open_callback = () => {
			this.RefreshExpWithoutLevelUp()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		
	}

	public Remove(){
		this.has_set_exp_effect = undefined
	}


	public LoadSuccess(){

		this.display_obj.centerX = 0
		this.display_obj.bottom = 0

		this.mainUI_model.SetMainuiLoadedFlag(this.layout_file, true, this)

		ResManager.GetInstance().SetTexture(this, this._img_bg, GameResPath.GetIcon("mainUI", "uizjmv3_001"), null, this, null, null, null, true)

		this.UpdateView()
		this.InitEvent()
		this.mainUI_model.RefreshTurnRed()
	}

	public UpdateView(){
		this.UpdateIconItem()
		this.UpdateTurnRed()
		this.UpdateTurnState()
	}
	
	public InitEvent(){
		this.BindEvent(
			GlobalEventSystem,
			EventName.GAME_START, () => {
				this.mainUI_model.show_type = 0
				this.RefreshExpWithoutLevelUp()
				this.UpdateView()
				this.mainUI_model.RefreshTurnRed()
			}
		)

		this.BindEvent(
			GlobalEventSystem,
			EventName.EXP_CHANGE_WITHOUT_ANIMATION, (var_type?, value?, old_value?) => {
				this.RefreshExpWithoutLevelUp()
			}
		)

		this.BindEvent(
			GlobalEventSystem,
			EventName.FLY_TO_ICON, (obj?) => {
				// let beginObj = obj.beginobj
				// let iconType = obj.icontype
				// let callBack = obj.call_back
				// let scalx = obj.scalx
				// let scaly = obj.scaly
				// let duration = obj.duration
				// let index = this.icon_type_to_index && this.icon_type_to_index[iconType]
				// let icon = this.icon_item_list && this.icon_item_list[index]
				// if (icon ) {
				// 	Util.flyTo(beginObj, icon, null, null, callBack, scalx, scaly, duration)
				// }else{
				// 	Util.flyTo(beginObj, this._gp_turn, null, null, callBack, scalx, scaly, duration)
				// }
			}
		)

		this.BindEvent(
			GlobalEventSystem,
			EventName.PLAY_DOWN_ICON_ANIMATION, (icontype?) => {
				if (!this.icon_tween_list) {
					this.icon_tween_list = []
				}
				if (!this.icon_tween_list[icontype]) {
					let index = this.icon_type_to_index && this.icon_type_to_index[icontype]
					let icon = this.icon_item_list && this.icon_item_list[index]
					if (icon) {
						SYTweenLite.to(this, icon.transform, SYTweenLite.UiAnimationType.POSY, -58, 0.2, () => {
							if (this.icon_tween_list) {
								this.icon_tween_list[icontype] = null
							}
						}, SYTweenFunc.PINGPONG)
						// Laya.Tween.get(icon):to({y=58}, 200):to({y=28}, 200):to({y=38}, 150).call(() => {
						this.icon_tween_list[icontype] = true
					}
				}
			}
		)

		this.BindEvent(
			this.role_mgr.GetMainRoleVo(),
			EventName.CHANGE_LEVEL, (level?) => {
				if (MainUIModel.Turn_Open_lv == level) {
					this.UpdateTurnState()
					this.UpdateTurnRed()
				}
			}
		)


		this.BindVar(
			this.mainUI_model,
			"turn_red_dot", () => {
				this.UpdateTurnRed()
			}
		)
		let push_view_fun = (is_out?) => {
			// this.visible = !is_out
		}
		this.BindEvent(this.view_mgr, ViewManager.PUSH_VIEWS_OUT_SCREEN, push_view_fun)

		let turn_btn_fun = (force_show_guide_icon_line?) => {
			if (force_show_guide_icon_line == null) {
				force_show_guide_icon_line = true
			}
			if (!this.mainUI_model.GetTurnState()) {
				return
			}
			this.mainUI_model.show_type = this.mainUI_model.show_type + 1
			if (this.mainUI_model.show_type > MainUIDownView.Max_Type) {
				this.mainUI_model.show_type = 0
			}
			this.UpdateTurnState()
			this.mainUI_model.RefreshTurnRed()
			// this.DeleteMainUIDownArrow()
			this.UpdateIconItem()
			// if (! force_show_guide_icon_line && ! StoryModel.GetInstance().HasFingerIsShowing() ) {
			// 	this.this.task_model.DoTask(null, false, false)
			// }
			GlobalEventSystem.Fire(EventName.CLOSE_ICON_BOX_VIEW)
		}

		/***原来是按下就回调，因为要在切换按钮上加一步引导，但引导会在mouseup事件中消失(相当于点击了一次引导)，现在改成false，看看有没有影响 */
		Util.AddClickEvent(
			this._gp_turn, () => {
				turn_btn_fun(false)
				if(this.is_need_switch){
					this.task_model.DoTask(null, false)
				}
			},
			this,
			true, null, null, false
		)

		this.BindEvent(GlobalEventSystem, EventName.SELECT_STORY_TARGET, (target_name?, is_add?, force_show_mainui_icon?,is_switch?) => {
			if (!this.mainUI_model.GetTurnState()) {
				return
			}
			this.is_need_switch = is_switch
			let need_guide_line = this.mainUI_model.FindIconInLineNo(target_name)
			if (is_add && need_guide_line != null) {
				if (this.mainUI_model.show_type != need_guide_line) {
					if (force_show_mainui_icon) {
						turn_btn_fun()
						this.task_model.DoTask(null, false)
					} else {
						GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, target_name, false)
					}
				}
			}

		})

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_NEWEST_TASK_ID_NOT_DELAY, (task_id?) => {
			this.TryRefreshItem()
		}
		)

		this.BindEvent(GlobalEventSystem, EventName.ALPHA_STATE_CHANGE, () => {
			this.TryRefreshItem()
		})
	}

	public DeleteMainUIDownArrow(){
		if (this.story_model.now_story_target_name) {
			GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, this.story_model.now_story_target_name, false)
		}
	}

	public UpdateIconItem(){
		if (!this.icon_item_list) {
			this.icon_item_list = []
		}
		let icons_list = MainUIModel.Main_Func_Icons[this.mainUI_model.show_type]
		let item = null
		this.icon_type_to_index = []
		let index = 1

		for (let i in icons_list) {
			var vo = icons_list[i]
			if (this.mainUI_model.GetMainFuncOpenCond(vo.func)) {
				this.icon_type_to_index[vo.func] = index
				item = this.icon_item_list[index]
				if (!item) {
					item = new MainFuncIconItem(this._gp_icon_con)
					item.SetData(vo)
					item.Load()
					this.icon_item_list[index] = item
					item.SetPosition((index - 1) * 105, 0)
				} else {
					item.SetData(vo)
				}
				item.SetVisible(true)
				index = index + 1
			}
		}
		for (let i = index; i < this.icon_item_list.length; i++) {
			this.icon_item_list[i].SetVisible(false)
		}
	}

	public UpdateTurnRed(){
		if (this.mainUI_model.GetTurnState()) {
			this._img_red.visible = this.mainUI_model.turn_red_dot
		} else {
			this._img_red.visible = false
		}
	}


	public UpdateTurnState(){
		if (this.mainUI_model.GetTurnState()) {
			this._img_turn.gray = false
			ResManager.GetInstance().SetImageSprite(
				this,
				this._img_turn,
				"mainUI",
				this.mainUI_model.show_type == 0 && "uizjmv3_015" || "uizjmv3_016"
			)
		} else {
			this._img_turn.gray = true
			ResManager.GetInstance().SetImageSprite(this, this._img_turn, "mainUI", "uizjmv3_015")
		}
	}

	public RefreshExpWithoutLevelUp(not_delay?){
		let main_role_vo = this.role_mgr.GetMainRoleVo()

		if (this.exp_ani_data_list.length > this.max_cache_count) {
			table.remove(this.exp_ani_data_list, 1)
		}

		// let gap = Mathf.Abs(main_role_vo.exp - last_exp_) / main_role_vo.exp_lim
		// let show_effect_run = null

		// if (main_role_vo.level > last_level_ || gap >= 0.1 ) {
		// 	show_effect_run = true
		// }

		// last_exp_ = main_role_vo.exp
		// last_level_ = main_role_vo.level

		let exp = main_role_vo.exp
		let exp_lim = main_role_vo.exp_lim
		if (exp > exp_lim) {
			exp = exp_lim
		}
		let persent
		if (exp_lim == 0) {
			persent = 0
		} else {
			let a = exp / exp_lim * 100
			persent = Math.floor(a) / 100
		}

		let data = {
			persent: persent,
			level: main_role_vo.level,
			exp: exp,
			exp_lim: main_role_vo.exp_lim,
			// show_effect_run : show_effect_run
		}
		table.insert(this.exp_ani_data_list,data	)

		if (this.is_ani_exp) {
			this.need_refresh_time_interval = true
			return
		} else {
			//0.5秒 捕获数据 
			if (this.delay_refresh_time_id) {
				return
			}

			this.delay_refresh_time_id = setTimeout(() => {
				this.delay_refresh_time_id = false
				this.RefreshTimeInterval()
				this.PlayExpAnim()
			}, 0.5)
		}
	}

	public RefreshTimeInterval(){
		let len = this.exp_ani_data_list.length
		this.time_interval = len > 0 && (0.5 / len) || 0
	}

	public PlayExpAnim(){
		if (this.need_refresh_time_interval) {
			this.RefreshTimeInterval()
			this.need_refresh_time_interval = false
		}

		let vo = table.remove(this.exp_ani_data_list, 0)[0]
		if (vo) {
			this.is_ani_exp = true
			this.PlayAnim(vo)
		} else {
			this.is_ani_exp = false
		}
	}

	public PlayAnim(tb?){

		let endValue = this.max_len * Number(tb.persent)

		if (endValue < 0) {
			endValue = 0
		} else if (endValue > this.max_len) {
			endValue = this.max_len
		}
		if(!this.has_set_exp_effect){
			this.has_set_exp_effect = true
			this.AddUIEffect("ui_expbar", this._box_exp_effect, null, 15, null)
		}
		this._box_exp_effect.visible = true
		if(this.exp_time_id){
			clearTimeout(this.exp_time_id)
			this.exp_time_id = null
		}

		let onComleted = () => {
			this._lb_exp.text = tb.exp + " / " + tb.exp_lim
			this.PlayExpAnim()
			if(this.exp_time_id){
				clearTimeout(this.exp_time_id)
				this.exp_time_id = null
			}
			this.exp_time_id = setTimeout(() => {
				this._box_exp_effect.visible = false
			}, 1000);
		}
		if (tb.level > this.local_level) {
			let onComleted2 = () => {
				this._img_exp.width = 0
				if (this._img_exp.width == endValue) {
					onComleted()
				} else {
					table.insert(
						this.tween_event_list,
						SYTweenLite.to(
							this,
							this._img_exp,
							SYTweenLite.UiAnimationType.WIDTH,
							endValue,
							this.time_interval,
							onComleted,
							SYTweenFunc.LINEAR
						)
					)
				}
			}
			if (this._img_exp.width == this.max_len) {
				onComleted2()
			} else {
				table.insert(
					this.tween_event_list,
					SYTweenLite.to(
						this,
						this._img_exp,
						SYTweenLite.UiAnimationType.WIDTH,
						this.max_len,
						this.time_interval,
						onComleted2,
						SYTweenFunc.LINEAR
					)
				)
			}
		} else {
			table.insert(
				this.tween_event_list,
				SYTweenLite.to(
					this,
					this._img_exp,
					SYTweenLite.UiAnimationType.WIDTH,
					endValue,
					this.time_interval,
					onComleted,
					SYTweenFunc.LINEAR
				)
			)
		}
		this.local_level = tb.level
	}

	public ClearTween(){
		if (this.tween_event_list) {
			for (let _ in this.tween_event_list) {
				var key = this.tween_event_list[_]
				SYTweenLite.Stop(key)
			}
			this.tween_event_list = []
		}
	}

	public GetIconPos(main_func?, centor_offset?){
		let index = this.icon_type_to_index && this.icon_type_to_index[main_func]
		let icon
		if (this.icon_item_list && this.icon_item_list[index]) {
			icon = this.icon_item_list[index]
		}
		if (!icon) {
			icon = this._gp_turn
		}
		if (icon) {
			let point
			if (centor_offset) {
				if(icon == this._gp_turn){
					point = icon.localToGlobal(new Laya.Point(centor_offset.x,centor_offset.y))
				}else{
					point = icon.localToGlobal(centor_offset.x,centor_offset.y)
				}
			} else {
				if(icon == this._gp_turn){
					point = icon.localToGlobal(new Laya.Point(0, 0))
				}else{
					point = icon.localToGlobal(0, 0)
				}
			}
			if (point){
				return { x: point.x, y: point.y }
			}
		}
		return false

		// let index = this.icon_type_to_index && this.icon_type_to_index[main_func]
		// let icon_trans = null
		// if (this.icon_item_list && this.icon_item_list[index]) {
		// 	icon_trans = this.icon_item_list[index]
		// }
		// if (!icon_trans) {
		// 	icon_trans = this._gp_turn
		// }
		// if (icon_trans) {
		// 	return { x: icon_trans.x, y: icon_trans.y } //UILocalToCanvasPoint(icon_trans, centor_offset, pivot_offset)
		// }
		// return false
	}


	public TryRefreshItem(){
		if (this.refresh_item_id) {
			return
		}

		this.refresh_item_id = setTimeout(() => {
			this.UpdateIconItem()
			this.mainUI_model.RefreshTurnRed()

			this.refresh_item_id = false

		}, 0.5)
	}

	createChildren() {
		if (this['GetComponents']) {
			this['GetComponents']();
			this.is_get = true;
		}
		this.story_target_name_dic = this.story_target_name_dic||{}
		this.story_target_name_dic[StoryModel.StoryTargetName.MainUISwitchBtn] =this._gp_turn;
		super.createChildren();
	}


	_img_bg: Laya.Image
	_gp_icon_con: Laya.Box
	_gp_turn: Laya.Box
	_img_turn: Laya.Image
	_img_red: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_img_exp: Laya.Image
	_box_exp_effect: Laya.Box
	_lb_exp: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._gp_icon_con,
			this._gp_turn,
			this._img_turn,
			this._img_red,
			this._Group1,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._img_exp,
			this._box_exp_effect,
			this._lb_exp,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_icon_con",
				"_gp_turn",
				"_img_turn",
				"_img_red",
				"_Group1",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_img_exp",
				"_box_exp_effect",
				"_lb_exp",
			])
			this._lb_exp.fontSize = 2 * this._lb_exp.fontSize
			this._lb_exp.scale(0.5, 0.5)
	}
}
window["MainUIDownView"] = MainUIDownView