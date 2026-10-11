import { BaseItem1 } from "../common/BaseItem1";
import { BaseWindowComponent } from "../common/BaseWindowComponent";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { PartnerAwakeEvent } from "../commonModel/PartnerAwakeEvent";
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel";
import { TaskModel } from "../commonModel/TaskModel";
import { Message } from "../sysInfo/SysInfoController";
import { TaskVo } from "../sharedata/TaskVo";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";
import { Vector2 } from "../util/Vector2";
import { PartnerAwakeSkillItem } from "./PartnerAwakeSkillItem";
import { PartnerAwakeTaskItem } from "./PartnerAwakeTaskItem";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";

export class PartnerAwakeMainView extends BaseItem1 {


	awake_cfg
	clickTime
	curr_index
	delay_timer_id
	left_pos
	left_tween_id
	left_tween_id2
	model
	need_update_tab2
	need_update_task
	not_finish_num
	now_show_task_list
	proptity_view
	right_pos
	right_tween_id
	right_tween_id2
	skill_item_list
	swap_is_playing
	task_item_list
	tween_id1
	tween_id2
	tween_id_list
	fight_item
	pre_client_cfg = Config.PRELOAD_CLIENT_CONFIG

	public constructor(parent?) {
		super(parent)

		this.base_file = "partnerAwake"
		this.layout_file = "PartnerAwakeMainView"
		this.model = PartnerAwakeModel.GetInstance()
		this.awake_cfg = null
		this.layer_value = Enum_UILayer.UI
		this.skill_item_list = []
		this.curr_index = 0
		this.task_item_list = []
		this.clickTime = 0
		this.tween_id_list = []
		this.load_callback = () => {
			this.fight_item = new FightingShowSmallItem(this._gp_fight)
			this.fight_item.Load()
			this.fight_item.IsCenter(true, false)
			this.scroll.hScrollBar.visible = false
			this.LoadSuccess()
			this.InitEvents()
			this.SetData()
		}

		// this.ReOpen_callback = () => {
		// 	this.curr_index = 0
		// 	this.SetData()
		// }
	}

	public LoadSuccess() {
		this.left_pos = this.left_img.x
		this.right_pos = this.right_img.x

		// Util.SetImageGray(this.none_open_img, true)
		this.model.first_show = false
		this.model.RedDotFun()
	}

	public InitEvents() {
		this.scroll.on(Laya.Event.CHANGE, this, this.HideArrow)

		let pro_btn_fun = () => {
			this.model.Fire(PartnerAwakeEvent.AWAKE_OPEN_VIEW, "PartnerAwakeProView")
		}
		Util.AddClickEvent(this.pro_btn, pro_btn_fun, this, true)

		let tabBtn_fun1 = () => {
			this.SetTabBtnState(1)
		}
		Util.AddClickEvent(this.tab_1_con, tabBtn_fun1, this, true)

		let tabBtn_fun2 = () => {
			this.SetTabBtnState(2)
		}
		Util.AddClickEvent(this.tab_2_con, tabBtn_fun2, this, true)

		let tabBtn_fun3 = () => {
			Message.show("请先完成上一阶段的任务哦~")
		}
		Util.AddClickEvent(this.none_open_tab, tabBtn_fun3, this, true)

		let objleft_arrow_fun = () => {
			this.ArrowUpdateView(-1)
		}
		Util.AddClickEvent(this.left_arrow, objleft_arrow_fun, this, true)

		let objright_arrow_fun = () => {
			this.ArrowUpdateView(1)
		}
		Util.AddClickEvent(this.right_arrow, objright_arrow_fun, this, true)

		let task_success_fun = (task_id?) => {
			if (this.pre_client_cfg.ConfigPartnerAwake.TaskView.task_list.main_task_id == task_id) { //第一阶段完成了，则可点击第二阶段的选项卡
				Message.show("第二阶段的任务开放啦~")
				this.ShowTab2Visible()
				// this.SetBottomView(2)
			}
		}
		this.BindEvent(this.task_model, TaskModel.FINISH_TASK, task_success_fun)

		let play_animation_fun = (task_id?) => {
			this.PlaySwapItemListAnimation(task_id)
		}
		this.BindEvent(this.model, PartnerAwakeEvent.PLAY_SWAP_ANIMATION, play_animation_fun)

		let update_task_fun = () => {
			if (this.swap_is_playing || !this.AnimationIsEnd()) {
				this.need_update_task = true
			} else {
				this.SetBottomView()
				this.UpdateTask()
			}
		}
		this.BindEvent(this.task_model, TaskModel.UPDATE_ALL_TASK_FROM_30000, update_task_fun)

		let update_dot = () => {
			this.ShowTab2RedDot()
		}
		this.BindEvent(this.model, PartnerAwakeEvent.PARTNER_AWAKE_UPDATE_RED_DOT, update_dot)
	}

	public UpdateTask() {
		if (this.need_update_tab2) {
			this.SetBottomView()
		} else {
			if (this.curr_index) {
				this.SetTask(true)
			}
		}
	}

	public SetData() {
		this.awake_cfg = this.pre_client_cfg.ConfigPartnerAwake.TaskView
		if (!this.awake_cfg) {
			return
		}
		this.name_res.text = this.awake_cfg.partner_name
		if(this.fight_item)this.fight_item.Updatefighting(this.awake_cfg.fight||0)
		this.SetSkill()
		this.SetModel()
		this.SetBottomView()

		if (this.model.show_return_finger) {
			this.model.show_return_finger = false
			let step_cfg = { direction: 6, text: "为达成召唤目标而努力！继续主线吧！", effect_scaleX: 0.35, effect_scaleY: 1 }
			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return, "UI", null, null, false, null, step_cfg, true)
		}
	}

	//技能
	public SetSkill() {
		this.left_img.x = 0
		this.right_img.x = 0
		this.left_img.scaleX = this.left_img.scaleY = 0
		this.right_img.scaleX = this.right_img.scaleY = 0
		this.left_img.visible = true
		this.right_img.visible = true

		// Laya.Tween.get(this.left_img).to({ x: this.left_pos }, 1000, Laya.Ease.backOut)
		Laya.Tween.to(this.left_arrow, { x: this.left_pos }, 1000, Laya.Ease.backOut)
		// Laya.Tween.get(this.left_img).to({ scaleX: 1, scaleY: 1 }, 500)
		Laya.Tween.to(this.left_img, { scaleX: 1, scaleY: 1 }, 500)

		// Laya.Tween.get(this.right_img).to({ x: this.right_pos }, 1000, Laya.Ease.backOut)
		Laya.Tween.to(this.right_img, { x: this.right_pos }, 1000, Laya.Ease.backOut)
		// Laya.Tween.get(this.right_img).to({ scaleX: 1, scaleY: 1 }, 500)
		Laya.Tween.to(this.right_img, { scaleX: 1, scaleY: 1 }, 500)

		if (this.skill_item_list) {
			for (let i = 0; i < this.skill_item_list.length; i++) {
				let v = this.skill_item_list[i]
				v.visible = false
			}
		}

		let delay_fun = () => {
			if (this.use_delete_method) {
				return
			}
			if (this.awake_cfg.skill_list) {
				let item = null
				for (let i = 0; i < this.awake_cfg.skill_list.length; i++) {
					let v = this.awake_cfg.skill_list[i]
					item = this.skill_item_list[i]
					if (!item) {
						item = new PartnerAwakeSkillItem(this["skill_box" + (i + 1)])
						item.Load()
						this.skill_item_list[i] = item
					}
					item.SetVisible(true)
					item.SetData(v, i)
				}
			}
		}
		this.delay_timer_id = setTimeout(delay_fun, 300)
	}

	//模型
	public SetModel() {
		if (this.awake_cfg) {
			let data = {
				res_id: Number(this.awake_cfg.model_id),
				clothe_res_id: Number(this.awake_cfg.model_id),
				type: UI_MODEL_TYPE.PARTNER,
				layer_value: this.layer_value,
				rotate: 0,
				position: new Vector2(-1, -1),
				can_rotate: true,
				action_name_list: Util.DeepCopy(this.awake_cfg.action),
				scale: this.awake_cfg.scale,
			}
			ResManager.GetInstance().SetRoleModel(this, this.role_con, data)
		}
	}

	//设置任务显示
	public SetBottomView(index?) {

		let tab_index = this.GetShouldShowTab()
		if (index) tab_index = index
		this.tab_2_con.visible = tab_index == 2
		this.none_open_tab.visible = tab_index == 1
		this.SetTabBtnState(tab_index)
	}

	//当完成第一阶段主任务的时候，显示出第二个选项卡
	public ShowTab2Visible() {
		this.none_open_tab.visible = false
		this.tab_2_con.visible = true
		this.need_update_tab2 = true
	}

	//红点
	public ShowTab2RedDot() {
		//this.red_dot.visible = this.model.unlock_new_step 
	}

	//默认点击的选项卡
	public GetShouldShowTab() {
		let tab_index = 1
		let receive_task_list = this.task_model.GetHasReceiveTaskList()
		let first_task_id = this.awake_cfg.task_list.main_task_id
		let second_task_id = this.awake_cfg.task_list2.main_task_id

		if (receive_task_list) {
			for (let task_id in receive_task_list) {
				if (task_id == first_task_id) {
					tab_index = 1
					break
				} else if (task_id == second_task_id) {
					tab_index = 2
					break
				}
			}
		}
		return tab_index
	}

	//tab状态
	public SetTabBtnState(index?, force?, not_relpay_animation?) {

		if ((!this.awake_cfg || this.curr_index == index) && !force) {
			return
		}
		if (!this.AnimationIsEnd()) {
			return
		}
		this.curr_index = index

		this.now_show_task_list = Util.DeepCopy(this.awake_cfg.task_list.stone_task_list)
		if (index == 2) {
			this.now_show_task_list = Util.DeepCopy(this.awake_cfg.task_list2.stone_task_list)
			this.model.unlock_new_step = false
			this.model.RedDotFun()
			this.need_update_tab2 = false
		}
		let source1 = index == 1 && "ui_role_btn_1" || "ui_role_btn_2"
		let source2 = index == 1 && "ui_role_btn_2" || "ui_role_btn_1"
		let text_color = index == 1 && "#9b572f" || "#ffffff"
		let text_color2 = index == 1 && "#ffffff" || "#9b572f"
		this.tab_1_img.skin = GameResPath.GetIcon("partnerAwake", `${source1}`)// `partnerAwake_json.${source1}_png`
		this.tab_2_img.skin = GameResPath.GetIcon("partnerAwake", `${source2}`) //`partnerAwake_json.${source2}_png`
		this.tab_1_text.color = text_color
		this.tab_2_text.color = text_color2

		this.SetTask(not_relpay_animation)
	}

	//子任务排序
	public SortShowTaskList() {
		if (this.now_show_task_list) {
			for (let i = 0; i < this.now_show_task_list.length; i++) {
				let v = this.now_show_task_list[i]  //赋值index字段
				if (v.index == undefined || v.index == null) {
					v.index = i
				}
			}
			let receive_task_list = this.task_model.GetHasReceiveTaskList()
			this.not_finish_num = 0
			if (receive_task_list) {
				let task_vo
				for (let i = 0; i < this.now_show_task_list.length; i++) {
					let v = this.now_show_task_list[i]
					task_vo = receive_task_list[v.task_id]
					if (!task_vo) {
						v.index = v.index + 100
					} else {
						this.not_finish_num = this.not_finish_num + 1
					}
				}
			}

			this.now_show_task_list.sort((a, b) => {
				return a.index - b.index
			})
		}
	}

	//设置任务内容
	public SetTask(not_relpay_animation?) {
		if (this.now_show_task_list) {
			this.SortShowTaskList()
			let receive_task_list = this.task_model.GetHasReceiveTaskList()
			if (receive_task_list) {
				if (this.task_item_list) {
					for (let _tmpi in this.task_item_list) {
						let item = this.task_item_list[_tmpi]
						item.visible = false
					}
				}
				let task_vo = null
				let item = null
				let has_done_count = 0
				let task_id = null
				let need_close = null
				for (let i = 0; i < this.now_show_task_list.length; i++) {
					let v = this.now_show_task_list[i]
					task_id = v.task_id
					task_vo = receive_task_list[task_id]
					task_vo = task_vo && task_vo[0] || null
					item = this.task_item_list[i]
					if (!item) {
						item = new PartnerAwakeTaskItem(this.Content)
						item.Load()
						this.task_item_list[i] = item
					}
					if (not_relpay_animation) {
						item.SetPosition(i * PartnerAwakeTaskItem.ItemWidth + 10, 0)
					} else {
						item.SetPosition(i * PartnerAwakeTaskItem.ItemWidth + 10, PartnerAwakeTaskItem.ItemHeight)
					}
					item.visible = true
					if (!task_vo) {
						has_done_count = has_done_count + 1
						let task_cfg = this.task_model.GetTaskCfg(task_id)
						let msg = task_cfg && task_cfg.tips || ""
						task_vo = new TaskVo(task_id, 1, msg, 2, 1, v.show_num, v.show_num, 0)
					}
					item.SetData(v, task_vo, i)
				}
				if (has_done_count == this.now_show_task_list.length) {
					this.UpdataRootTaskState()
				}
				this.Content.width = this.now_show_task_list.length * 162
				item.ExcuteCallback(() => {
					if (!not_relpay_animation) {
						for (let i = 0; i < this.task_item_list.length; i++) {
							let v = this.task_item_list[i]
							v.PlayShowAnimation()
						}
					}
				})

			}
		}
		this.HideArrow()
	}

	public UpdataRootTaskState() {
		TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30000)
	}

	//动画是否全结束
	public AnimationIsEnd() {
		let is_end = true
		if (this.task_item_list) {
			for (let i = 0; i < this.task_item_list.length; i++) {
				let v = this.task_item_list[i]
				is_end = !v.GetIsPlaying()
				if (!is_end) {
					break
				}
			}
		}
		return is_end
	}

	//播放动画。 完成的任务item要移到最后
	public PlaySwapItemListAnimation(task_id?) {
		if (this.task_item_list && task_id > 0) {
			let index = undefined
			let real_pos_index = undefined
			for (let i = 0; i < this.task_item_list.length; i++) {
				let v = this.task_item_list[i]
				if (v.data && v.data.task_id == task_id) {
					index = i
					real_pos_index = v.real_pos_index
					break
				}
			}
			if (index != undefined && real_pos_index != undefined && this.not_finish_num != 1 && this.task_item_list[index] && real_pos_index != this.task_item_list.length - 1) {
				this.swap_is_playing = true
				this.ClearTweenList()
				for (let i = 0; i < this.now_show_task_list.length; i++) {
					let v = this.now_show_task_list[i]  //赋值index字段, 用于排序
					if (v.task_id == task_id) {
						v.index = v.index + 200
					}
				}
				this.task_item_list[index].SetHasFinishState()
				this.task_item_list[index].visible = false
				let move_num = this.task_item_list.length - (real_pos_index + 1)
				let now_num = 0
				let onCompleted = () => {
					if (this.use_delete_method) {
						return
					}
					now_num = now_num + 1
					console.log(`${move_num}_${now_num}`)
					if (move_num <= now_num) {   //运动完了
						this.task_item_list[index].x = (this.task_item_list.length - 1) * PartnerAwakeTaskItem.ItemWidth
						this.task_item_list[index].y = 0
						this.task_item_list[index].visible = true
						this.swap_is_playing = false
						// this.UpdateTask()
						for (let i = 0; i < this.task_item_list.length; i++) {
							let v = this.task_item_list[i]			//更新item的realpos
							if (v.real_pos_index > real_pos_index) {
								v.real_pos_index = v.real_pos_index - 1
							}
						}
						this.task_item_list[index].UpdateRealPos(this.task_item_list.length - 1)
					}
				}
				let target_pos_x = 0
				let item
				let old_pos
				for (let i = 0; i < this.task_item_list.length; i++) {
					let v = this.task_item_list[i]
					if (v.real_pos_index > real_pos_index) {
						// old_pos = v.GetPosition()
						target_pos_x = v.x - PartnerAwakeTaskItem.ItemWidth
						if (v) {
							// Laya.Tween.get(v).to({ x: target_pos_x }, 500).call(onCompleted)
							Laya.Tween.to(v, { x: target_pos_x }, 500, null, Laya.Handler.create(this, () => {
								onCompleted()
							}))
						}
					}
				}
			} else {
				this.UpdateTask()
			}
		}
	}

	public ClearTweenList() {
		for (let i = 0; i < this.task_item_list.length; i++) {
			let v = this.task_item_list[i]
			Laya.Tween.clearAll(v)
		}
	}

	//左右箭头
	public ArrowUpdateView(_dir?) {
		if (this.clickTime && TimeUtil.getServerTime() - this.clickTime <= 0.3 || !this.now_show_task_list) {
			return
		}
		for (let _index in this.now_show_task_list) {
			let _width = this.Content.width / this.now_show_task_list.length
			let _center_pos = Math.ceil(_width * Number(_index) + _width)
			let _next_center_pos = Math.ceil(_width * (Number(_index) + 1) + _width)
			let _view_center_pos = -this.Content.x + this.scroll.width / 2
			let move_x = null
			if (_dir == 1) {
				if (_center_pos <= _view_center_pos && _next_center_pos > _view_center_pos) {
					this.clickTime = TimeUtil.getServerTime()
					if (Math.abs(_center_pos - _view_center_pos) <= 5) {
						move_x = _next_center_pos - this.scroll.width / 2
					} else if (Math.abs(_next_center_pos - _view_center_pos) <= 5) {
						move_x = Math.ceil(_width * Number(_index) + 2 + _width) - this.scroll.width / 2
					} else {
						move_x = _next_center_pos - this.scroll.width / 2
					}
					if (move_x + this.scroll.width > this.Content.width) {
						move_x = this.Content.width - this.scroll.width
					}

					Laya.Tween.clearAll(this.Content)
					// Laya.Tween.to(this.Content,{ x: -move_x }, 300).call(() => {
					// 	this.HideArrow()
					// 	Laya.Tween.removeTweens(this.Content)s
					// })
					Laya.Tween.to(this.Content, { x: -move_x }, 300, null, Laya.Handler.create(this, () => {
						this.HideArrow()
						Laya.Tween.clearAll(this.Content)
					}))
					return
				}
			} else {
				if (_center_pos < _view_center_pos && _next_center_pos >= _view_center_pos) {
					this.clickTime = TimeUtil.getServerTime();
					if (Math.abs(_center_pos - _view_center_pos) <= 10) {
						move_x = Math.ceil(_width * Number(_index) - 1 + _width) - this.scroll.width / 2
					} else {
						move_x = _center_pos - this.scroll.width / 2
					}
					if (move_x < 0) {
						move_x = 0
					}

					Laya.Tween.clearAll(this.Content)
					// Laya.Tween.get(this.Content).to({ x: -move_x }, 300).call(() => {
					// 	this.HideArrow()
					// 	Laya.Tween.removeTweens(this.Content)
					// })
					Laya.Tween.to(this.Content, { x: -move_x }, 300, null, Laya.Handler.create(this, () => {
						this.HideArrow()
						Laya.Tween.clearAll(this.Content)
					}))
					return
				}
			}
		}
	}

	public HideArrow() {
		if (!this.now_show_task_list) {
			return
		}
		let _width = this.Content.width / this.now_show_task_list.length
		if (this.now_show_task_list.length >= 5 && Math.abs(this.Content.x) >= _width / 4) {
			this.left_arrow.visible = true
		} else {
			this.left_arrow.visible = false
		}
		if (this.now_show_task_list.length >= 5 && Math.abs(this.Content.x) + this.scroll.width <= this.Content.width - _width / 4) {
			this.right_arrow.visible = true
		} else {
			this.right_arrow.visible = false
		}
	}

	public DeleteMe() {
		if(this.fight_item){
			this.fight_item.DeleteMe()
			this.fight_item = null
		}
		for (let i = 0; i < this.skill_item_list.length; i++) {
			let v = this.skill_item_list[i]
			v.DeleteMe()
			v = null
		}
		this.skill_item_list = []

		for (let i = 0; i < this.task_item_list.length; i++) {
			let v = this.task_item_list[i]
			v.DeleteMe()
			v = null
		}
		this.task_item_list = []

		if (this.proptity_view) {
			this.proptity_view.DeleteMe()
			this.proptity_view = null
		}

		if (this.scroll) {
			this.scroll.off(Laya.Event.CHANGE, this, this.HideArrow)
		}

		Laya.Tween.clearAll(this.Content)

		Laya.Tween.clearAll(this.left_img)
		Laya.Tween.clearAll(this.right_img)

		this.ClearTweenList()
		if (this.delay_timer_id) {
			// Laya.timer.clear(this,delay_fun)
			clearTimeout(this.delay_timer_id)
			this.delay_timer_id = null
		}
		if(BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT && BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return){
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
		}
		super.DeleteMe()
	}


pro_btn:Laya.Image
scroll_bg_1:Laya.Image
scroll_bg_2:Laya.Image
_gp_fight:Laya.Box
name_conta:Laya.Box
image1:Laya.Image
name_res:Laya.Label
role_con:Laya.Box
tab_1_con:Laya.Box
tab_1_img:Laya.Image
tab_1_text:Laya.Label
tab_2_con:Laya.Box
tab_2_img:Laya.Image
tab_2_text:Laya.Label
red_dot:Laya.Image
none_open_tab:Laya.Box
none_open_img:Laya.Image
none_open_text:Laya.Label
lock:Laya.Image
scroll:Laya.Panel
Content:Laya.Box
skill_conta:Laya.Box
right_img:Laya.Image
left_img:Laya.Image
skill_box1:Laya.Box
skill_box2:Laya.Box
skill_box3:Laya.Box
skill_box4:Laya.Box
left_arrow:Laya.Image
right_arrow:Laya.Image
	public GetComponents() {
		[
			this.pro_btn,
this.scroll_bg_1,
this.scroll_bg_2,
this._gp_fight,
			this.name_conta,
			this.image1,
			this.name_res,
			this.role_con,
			this.tab_1_con,
			this.tab_1_img,
			this.tab_1_text,
			this.tab_2_con,
			this.tab_2_img,
			this.tab_2_text,
			this.red_dot,
			this.none_open_tab,
			this.none_open_img,
			this.none_open_text,
			this.lock,
			this.scroll,
			this.Content,
			this.skill_conta,
			this.right_img,
			this.left_img,
			this.skill_box1,
			this.skill_box2,
			this.skill_box3,
			this.skill_box4,
			this.left_arrow,
			this.right_arrow,
		]
			= this.GetChildrenByNames([

				"pro_btn",
"scroll_bg_1",
"scroll_bg_2",
"_gp_fight",
				"name_conta",
				"image1",
				"name_res",
				"role_con",
				"tab_1_con",
				"tab_1_img",
				"tab_1_text",
				"tab_2_con",
				"tab_2_img",
				"tab_2_text",
				"red_dot",
				"none_open_tab",
				"none_open_img",
				"none_open_text",
				"lock",
				"scroll",
				"Content",
				"skill_conta",
				"right_img",
				"left_img",
				"skill_box1",
				"skill_box2",
				"skill_box3",
				"skill_box4",
				"left_arrow",
				"right_arrow",
			])
	}
}
window["PartnerAwakeMainView"] = PartnerAwakeMainView