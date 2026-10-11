import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { SkillVo } from "../skill/SkillVo"
import { ErlangParser } from "../util/ErlangParser"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetLocalScale, Util, SetAnchoredPosition } from "../util/Util"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TaskTipType } from "../commonModel/TaskModel"
import { StoryModel } from "../commonModel/StoryModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { FightingUpItem } from "../common/FightingUpItem"

export class PetRoundItem extends BaseItem1 {


	public effect_group
	public tween_id
	public is_lock

	AddEffect
	SetCanUseCount
	SetNumber
	SetLock
	SetRedDot
	SetClickCallBack
	SetGary
	LoadSuccess
	InitEvent
	SetData
	Local_DeleteMe
	SetSkillLv
	skill_tween_id
	UpdateTaskStep
	fight_item_up: FightingUpItem
	public constructor(parent?) {
		super(parent)

		this.base_file = "pet"
		this.layout_file = "PetRoundItem"

		let need_refresh_ = false,
			call_back_,
			lock_stage_,
			source_str_,
			goods_num_,
			show_red_,
			max_count_,
			show_number_,
			red_type_,
			canUseCount_,
			skill_lv_,
			skill_id_,
			is_can_lv_up_
		this.preload_server_config = {
			"config_skill_lv_data": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.SetData = (source_str?, click_callback?, is_lock?, lock_stage?, goods_num?, max_count?, show_red?, show_number?, red_type?, canUseCount?, skill_lv?, skill_id?, is_can_lv_up?) => {
			source_str_ = source_str
			call_back_ = click_callback
			this.is_lock = is_lock
			goods_num_ = goods_num
			max_count_ = max_count
			show_red_ = show_red
			lock_stage_ = lock_stage
			show_number_ = show_number
			red_type_ = red_type
			canUseCount_ = canUseCount
			skill_lv_ = skill_lv
			skill_id_ = skill_id
			is_can_lv_up_ = is_can_lv_up
			if (this.is_loaded) {
				need_refresh_ = false
				this.up_arrow1.visible = false
				ResManager.GetInstance().SetTexture(this, this.icon, source_str)
				this.SetLock(this.is_lock)
				this.SetNumber()
				this.SetRedDot(show_red_)
				this.SetCanUseCount()
				this.SetSkillLv()
				if (red_type == 2) {
					this.icon.scaleX = this.icon.scaleY = 1.2
				}
				if (is_can_lv_up_) {
					this.up_arrow1.visible = true
					this.up_arrow1.y = -10
					this.skill_tween_id = SYTweenLite.to(this, this.up_arrow1, SYTweenLite.UiAnimationType.POSY, 9.5, 1.4, null, SYTweenFunc.PINGPONG, true)
					this.UpdateTaskStep()
				}
			} else {
				need_refresh_ = true
			}
		}
		this.UpdateTaskStep = () => {
			let list = [1402001, 2901001, 1501001, 1601001, 1701001]
			let task_vo = this.task_model.GetMainLineTaskVo()
			if (!task_vo) return
			let task_id = task_vo.id
			// 1402001 坐骑 1
			// 2901001 侍魂 2
			// 1501001 羽翼 3
			// 1601001 御守 4
			// 1701001 神兵 5
			if (skill_lv_ == 0 && list[Number(task_id) - 1] == Number(skill_id_)) {
				let step = this.story_model.GetTaskStep(TaskTipType.MountLevel)
				if (step == 0) {
					if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.MountLevel)) {
						GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
						this.story_model.RegisterTaskStep(TaskTipType.MountLevel)
						step = this.story_model.GetTaskStep(TaskTipType.MountLevel)
					}
				}
				if (step != 1){
					this.story_model.Fire(StoryModel.EventName.UPDATE_TASK_STEP_SPE,false)
					return
				}
				//可以激活状态
				this.story_model.Fire(StoryModel.EventName.UPDATE_TASK_STEP_SPE,true)
				// let step1 = {
				// 	"direction": 2,
				// 	"text": "可以激活<font color='#0a9f42'>新技能</font>了",
				// 	"effect_scaleX": 0.55,
				// 	"effect_scaleY": 0.9,
				// 	"front_parent": "true"
				// }
				// this.story_model.CreateFinger( this, this.click_group,"UI",0,0,false,false,step1,true)
				// GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.click_group, "UI", null, null, null, null, step1, true)
			}
		}

		this.LoadSuccess = () => {
			if (need_refresh_) {
				this.SetData(source_str_, call_back_, this.is_lock, lock_stage_, goods_num_, max_count_, show_red_, show_number_, red_type_, canUseCount_, skill_lv_, skill_id_, is_can_lv_up_)
			}

		}

		this.InitEvent = () => {
			let OnClick = () => {
				if (call_back_) {
					call_back_()
				}
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.click_group)
			}
			Util.AddClickEvent(this.click_group, OnClick, this, true)

			let update_fun = (skill_id?, type_id?, skill_lv?) => {
				if (skill_id == skill_id_) {
					let is_can_lv_up
					let lv_system_info = OutWardBaseModel.GetInstance().GetLvSystemInfo(type_id)
					let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_skill_lv_data",false)
                    let next_skill_vo = Config.GetConfigVo (Config.ConfigHasDefaultValue.config_skill_lv_data.name,skill_id + "@" +(skill_lv+1),false,cfg)// cfg[skill_id + "@" + (skill_lv+1)]
					if(next_skill_vo){
						let conditions = ErlangParser.GetInstance().Parse(next_skill_vo.condition)
						for (let key in conditions) {
							if (conditions[key][0] == "mount_upgrade_lv") {
								is_can_lv_up = conditions[key][1] <= lv_system_info.level ? true : false
							}
						}
					}

					this.SetData(source_str_, call_back_, this.is_lock, lock_stage_, goods_num_, max_count_, show_red_, show_number_, red_type_, canUseCount_, skill_lv, skill_id_, is_can_lv_up)
				}
			}
			this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_LVSYSTEM_SKILL_VIEW, update_fun)

			this.BindEvent(OutWardBaseModel.GetInstance(), OutWardBaseModel.UPDATE_LV_UP_SYSTEM_VIEW, (scmd?) => {
				for (let key in scmd.skill_list) {
					if (scmd.skill_list[key].skill_id == skill_id_) {
						let is_can_lv_up
						let lv_system_info = OutWardBaseModel.GetInstance().GetLvSystemInfo(scmd.type_id)
						let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_skill_lv_data",false)
						let next_skill_vo = Config.GetConfigVo (Config.ConfigHasDefaultValue.config_skill_lv_data.name,skill_id_ + "@" +(scmd.skill_list[key].skill_level+1),false,cfg)// cfg[skill_id_ + "@" + (scmd.skill_list[key].skill_level+1)]
						if(next_skill_vo){
							let conditions = ErlangParser.GetInstance().Parse(next_skill_vo.condition)
							for (let key in conditions) {
								if (conditions[key][0] == "mount_upgrade_lv") {
									is_can_lv_up = conditions[key][1] <= lv_system_info.level ? true : false
								}
							}
						}
						this.SetData(source_str_, call_back_, this.is_lock, lock_stage_, goods_num_, max_count_, show_red_, show_number_, red_type_, canUseCount_, scmd.skill_list[key].skill_level, skill_id_, is_can_lv_up)
						return
					}
				}
			})
			this.BindEvent(this.story_model, StoryModel.EventName.UPDATE_TASK_STEP, () => {
				this.UpdateTaskStep()
			})
		}

		this.SetGary = (gary?) => {
			Util.SetImageGray(this.icon, gary)
		}

		this.SetClickCallBack = (callback?) => {
			call_back_ = callback
		}

		this.SetRedDot = (reddot?) => {
			if (red_type_ == 2) {
				if (this.tween_id) {
					SYTweenLite.Stop(this.tween_id)
				}
				// Laya.Tween.removeTweens(this.num_group)

				if (reddot) {
					this.num_group.y = -10
					this.tween_id = SYTweenLite.to(this, this.num_group, SYTweenLite.UiAnimationType.POSY, 9.5, 1.4, null, SYTweenFunc.PINGPONG, true)
					// Laya.Tween.get(this.num_group, { loop: true }).to({ y: -3 }, 700).to({ y: 9.5 }, 700)
					this.num_group.visible = true
				} else {
					this.num_group.visible = false
				}

				this.red_dot.visible = false
			} else {
				if (reddot) {
					this.red_dot.visible = true
				} else {
					this.red_dot.visible = false
				}
				this.num_group.visible = false
			}
		}

		this.SetLock = (is_lock?) => {
			if (is_lock) {
				this.SetGary(true)
			} else {
				this.SetGary(false)
			}
			this.is_lock = is_lock
		}

		this.SetNumber = () => {
			if (show_number_) {
				this.bottom_text.text = `${goods_num_}`
			} else {
				this.bottom_text.text = ""
			}
		}

		this.SetCanUseCount = () => {
			if (!this.fight_item_up) {
				this.fight_item_up = new FightingUpItem(this.num_group)
				this.fight_item_up.IsCenter(true, false)
				// this.fight_item_up.SetArrowStype(2)
				this.fight_item_up.Load()
			}
			if (canUseCount_) {
				this.fight_item_up.Updatefighting(canUseCount_)
				this.fight_item_up.SetCenter()
			} else {
				this.fight_item_up.Updatefighting(0)
			}
		}

		this.AddEffect = (effect_str?, layer_value?) => {
			this.ClearUIEffect(this.effBox);
			this.effBox.visible = true;
			// if (!this.effect_group) {
			// 	this.effect_group = new Laya.Box()
			// 	this.effect_group.verticalCenter = 0
			// 	this.effect_group.horizontalCenter = 0
			// 	// this.addChild(this.effect_group)
			// }
			this.AddUIEffect(effect_str, this.effBox, { x: 0, y: 0 }, 10, false, 0.5, () => {
				this.effBox.visible = false;
			});
		}

		this.SetSkillLv = () => {
			if (skill_lv_ != null) {
				this.skill_info_gp.visible = true
				this.skill_lv.text = skill_lv_.toString()
			} else {
				this.skill_info_gp.visible = false
			}
		}

		this.Local_DeleteMe = () => {
			if (this.tween_id) {
				SYTweenLite.Stop(this.tween_id)
			}
			if (this.skill_tween_id) {
				SYTweenLite.Stop(this.skill_tween_id)
			}
			if (this.num_group) {
				// Laya.Tween.removeTweens(this.num_group)
			}
			if (this.effect_group) {
				this.ClearUIEffect(this.effect_group)
			}
			if(this.fight_item_up){
				this.fight_item_up.DeleteMe()
				this.fight_item_up = null
			}
		}
	}

	public DeleteMe() {
		this.Local_DeleteMe()
		super.DeleteMe()
	}


click_group:Laya.Box
icon_bg:Laya.Image
icon_bg_mask:Laya.Image
icon:Laya.Image
bottom_text:Laya.Label
red_dot:Laya.Image
skill_info_gp:Laya.Box
skill_lv:Laya.Label
up_arrow1:Laya.Image
num_group:Laya.Box
effBox:Laya.Box
	public GetComponents() {
		[
			this.click_group,
			this.icon_bg,
			this.icon_bg_mask,
			this.icon,
			this.bottom_text,
			this.red_dot,
			this.skill_info_gp,
			this.skill_lv,
			this.up_arrow1,
this.num_group,
this.effBox,
		]
			= this.GetChildrenByNames([

				"click_group",
				"icon_bg",
				"icon_bg_mask",
				"icon",
				"bottom_text",
				"red_dot",
				"skill_info_gp",
				"skill_lv",
				"up_arrow1",
"num_group",
"effBox",
			])
	}
}
window["PetRoundItem"] = PetRoundItem