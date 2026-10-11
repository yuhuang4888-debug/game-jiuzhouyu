import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { MaterialsTool } from "../common/MaterialsTool";
import { GoodsModel } from "../commonModel/GoodsModel";
import { PartnerAwakeEvent } from "../commonModel/PartnerAwakeEvent";
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel";
import { TaskTipType, TaskModel } from "../commonModel/TaskModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Status } from "../util/Status";
import { Util, Trim } from "../util/Util";

export class PartnerAwakeTaskItem extends BaseItem1 {
	bg: Laya.Image
	title_name: Laya.Label
	icon_conta: Laya.Box
	progress_conta: Laya.Box
	image: Laya.Image
	progress_front_bg: Laya.Image
	preogress_num: Laya.Label
	desc: Laya.HTMLDivElement
	ok_btn: Laya.Box
	image1: Laya.Image
	btn_text: Laya.Label
	red_dot: Laya.Image
	gray_bg: Laya.Image
	finish_tag: Laya.Image
	effect_con: Laya.Box

	award_item
	canvas_group
	data
	is_playing
	last_click_time
	model
	needRefresh
	pos_y_cache
	real_pos_index
	task_vo
	timer_id
	progress_max = 129
	public static ItemWidth = 162
	public static ItemHeight = 285
	public constructor(parent?) {
		super(parent)

		this.base_file = "partnerAwake"
		this.layout_file = "PartnerAwakeTaskItem"
		this.model = PartnerAwakeModel.GetInstance()
		this.needRefresh = false
		this.data = null
		this.task_vo = null
		this.real_pos_index = 0
		this.is_playing = false
		this.award_item = null
		this.pos_y_cache = 0
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
			this.SetData()
		}
	}

	public LoadSuccess() {
		// this.progress_front_bg.mask = new Laya.Rectangle(0, 0, this.progress_front_bg.width, this.progress_front_bg.height)

		this.pos_y_cache = this.effect_con.y
		if (!this.award_item) {
			this.award_item = new BaseAwardItem(this.icon_conta)
			this.award_item.Load()
		}
	}

	public InitEvents() {
		let ok_btn_fun = () => {
			if (this.task_vo) {
				if (!this.model.last_click_time || Status.NowTime - this.model.last_click_time >= 0.7) {
					if (this.task_vo.task_tips_type == TaskTipType.Coin) {
						let tong = RoleManager.GetInstance().GetMainRoleVo().tong
						let is_enough = tong >= this.task_vo.need_num
						if (!is_enough) {
							MaterialsTool.GetInstance().materialsTips(Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[3].goods_id)
							return
						}
					}
					// if (this.task_vo.task_tips_type == TaskTipType.Cost_goods) {
						// if (this.task_vo.has_finish == 1 && GoodsModel.GetInstance().GetBagGoodsNum(this.task_vo.id) >= this.task_vo.needNum) {
						// 	// if (this.task_vo.task_tips_type == TaskTipType.Cost_goods) {
						// 	// 	this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30006, this.task_vo.task_id, this.task_vo.id, this.task_vo.need_num)
						// 	// }
						// 	this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.task_vo.task_id)
						// }else{
						// 	this.task_model.DoTask(this.task_vo)
						// 	if (this.task_vo.task_tips_type == TaskTipType.Cost_goods) {
						// 		GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
						// 	}
						// }
					// }else
					if(this.task_vo.has_finish == 1){
						this.task_model.Fire(TaskModel.REQUEST_CCMD_EVENT, 30004, this.task_vo.task_id)
					}
					else {
						this.task_model.DoTask(this.task_vo)
						if (this.task_vo.task_tips_type == TaskTipType.Cost_goods) {
							GlobalEventSystem.Fire(EventName.CLOSE_MOUNTPET_VIEW)
						}
					}
					this.last_click_time = Status.NowTime
				}
			}
		}
		Util.AddClickEvent(this.ok_btn, ok_btn_fun, this, true)

		let update_fun = (task_id?, task_tips_list?) => {	//刷新任务
			if (this.task_vo && this.task_vo.task_id == task_id && task_tips_list && task_tips_list[0]) {
				this.task_vo = task_tips_list[0]
				this.SetState()
				this.SetProgress()
				this.red_dot.visible = this.model.TaskVoRedDot(this.task_vo)
			}
		}
		this.BindEvent(this.task_model, TaskModel.UPDATE_ONE_TASK, update_fun)

		let task_success_fun = (task_id?) => {
			if (this.task_vo && this.task_vo.task_id == task_id) {
				this.ShowFinishEffect()
			}
		}
		this.BindEvent(this.task_model, TaskModel.FINISH_TASK, task_success_fun)

		if (this.needRefresh) {
			this.SetData(this.data, this.task_vo, this.real_pos_index)
			this.needRefresh = false
		}
	}

	public SetData(data?, vo?, index?) {
		if (!data) return
		this.data = data
		this.task_vo = vo
		this.real_pos_index = index
		if (this.is_loaded && this.data && this.task_vo) {
			this.title_name.text = this.task_vo.task_name
			this.desc.innerHTML = Util.StrToHTML(this.task_vo.desc)
			this.desc.x = 150 / 2 - this.desc.contextWidth / 2
			this.SetState()
			this.SetProgress()
			if (this.award_item) {
				this.award_item.SetItemSize(85, 85)
				this.award_item.SetData(this.data.award_id)
			}
			this.red_dot.visible = this.model.TaskVoRedDot(this.task_vo)
		} else {
			this.needRefresh = true
		}
	}

	public UpdateRealPos(index?) {
		this.real_pos_index = index
	}

	public SetHasFinishState() {
		if (this.task_vo) {
			this.task_vo.has_finish = 2
			this.SetState()
		}
	}

	public SetState() {
		let coin_task_can_finish = false
		if (this.task_vo.task_tips_type == TaskTipType.Coin) {
			let tong = RoleManager.GetInstance().GetMainRoleVo().tong
			coin_task_can_finish = tong >= this.task_vo.need_num ? true : false
		}
		if (this.task_vo.has_finish == 1 || coin_task_can_finish) {
			this.ok_btn.visible = true
			this.btn_text.text = "完成"
			this.finish_tag.visible = false
			this.gray_bg.visible = false
		} else if (this.task_vo.has_finish == 2) {
			this.ok_btn.visible = false
			this.finish_tag.visible = true
			this.gray_bg.visible = true
		} else {
			this.ok_btn.visible = true
			this.btn_text.text = "立即前往"
			this.finish_tag.visible = false
			this.gray_bg.visible = false
		}
	}

	//设置进度显示
	public SetProgress() {
		if (this.task_vo) {
			let now_num = this.task_vo.now_num
			let max_num = this.task_vo.need_num
			//金币任务要特殊处理显示
			if (this.task_vo.task_tips_type == TaskTipType.Coin) {
				let tong = RoleManager.GetInstance().GetMainRoleVo().tong
				now_num = tong >= max_num ? max_num : tong
			}
			if (this.task_vo.has_finish == 1) {
				now_num = max_num //<= GoodsModel.GetInstance().GetBagGoodsNum(this.task_vo.id) ? max_num : GoodsModel.GetInstance().GetBagGoodsNum(this.task_vo.id)
			}
			this.preogress_num.text = now_num + "/" + max_num
			this.progress_front_bg.width = (now_num / max_num) * this.progress_max
		}
	}

	public PlayShowAnimation() {
		if (this.is_loaded) {
			if (!this.is_playing) {
				this.display_obj.alpha = 0
				this.display_obj.y = PartnerAwakeTaskItem.ItemHeight
				this.ClearTween()
				let time_fun = () => {
					let onCompleted = () => {
						this.is_playing = false
					}
					// Laya.Tween.get(this).to({ y: 0, alpha: 1 }, 500, Laya.Ease.bounceOut).call(onCompleted)
					Laya.Tween.to(this.display_obj, { y: 0, alpha: 1 }, 500, Laya.Ease.bounceOut, Laya.Handler.create(this, () => {
						onCompleted()
					}))
				}
				this.is_playing = true
				this.timer_id = setTimeout(time_fun, this.real_pos_index * 150)
			}
		}
	}

	public ClearTween() {
		Laya.Tween.clearAll(this)
		if (this.timer_id) {
			// Laya.clearTimeout(this.timer_id)
			clearTimeout(this.timer_id)
			this.timer_id = null
		}
	}

	public GetIsPlaying() {
		return this.is_playing
	}

	//完成任务特效 
	public ShowFinishEffect() {
		if (this.is_loaded) {
			// Laya.Tween.clearAll(this.effect_con)
			// this.effect_con.y = this.pos_y_cache
			// this.is_playing = true
			// let call_fun = () => {
			// 	if (this.use_delete_method) {
			// 		return
			// 	}
			// 	let onCompleted = () => {
			// 		if (this.use_delete_method) {
			// 			return
			// 		}
			// 		Laya.Tween.clearAll(this.effect_con)
			// 		this.ClearUIEffect(this.effect_con)
			// 		this.is_playing = false
			// 		this.model.Fire(PartnerAwakeEvent.PLAY_SWAP_ANIMATION, this.task_vo.task_id)
			// 	}
			// 	// Laya.Tween.get(this.effect_con).to({ y: this.pos_y_cache + 100 }, 700).call(onCompleted)
			// 	Laya.Tween.to(this.effect_con, { y: this.pos_y_cache + 100 }, 700, undefined, Laya.Handler.create(this, () => {
			// 		onCompleted()
			// 	}))
			// }
			// call_fun()
			/*this.AddUIEffect("UI_1121", this.effect_con, null, 1, false, null, null, call_fun)*/

			this.model.Fire(PartnerAwakeEvent.PLAY_SWAP_ANIMATION, this.task_vo.task_id)
		}
	}

	public DeleteMe() {
		this.ClearTween()
		this.is_playing = false
		if (this.award_item) {
			this.award_item.DeleteMe()
			this.award_item = null
		}
		Laya.Tween.clearAll(this.effect_con)
		this.ClearUIEffect(this.effect_con)
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this.bg,
			this.title_name,
			this.icon_conta,
			this.progress_conta,
			this.image,
			this.progress_front_bg,
			this.preogress_num,
			this.desc,
			this.ok_btn,
			this.image1,
			this.btn_text,
			this.red_dot,
			this.gray_bg,
			this.finish_tag,
			this.effect_con,
		]
			= this.GetChildrenByNames([

				"bg",
				"title_name",
				"icon_conta",
				"progress_conta",
				"image",
				"progress_front_bg",
				"preogress_num",
				"desc",
				"ok_btn",
				"image1",
				"btn_text",
				"red_dot",
				"gray_bg",
				"finish_tag",
				"effect_con",
			])
		this.desc.style.fontSize = 16
		this.desc.style.color = "#663915"
		this.desc.width = 140
	}
}
window["PartnerAwakeTaskItem"] = PartnerAwakeTaskItem