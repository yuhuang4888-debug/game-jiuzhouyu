import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { SetSizeDeltaX, SetAnchoredPosition, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { TopVipSkillItem } from "./TopVipSkillItem"

export class TopVipSkillView extends BaseItem1 {
	_img_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	skill_introduce_img: Laya.Image
	point_gp_0: Laya.Box
	complete_img_0: Laya.Image
	nofire_img_0: Laya.Image
	boom_effect_gp_0: Laya.Box
	fire_effect_gp_0: Laya.Box
	point_gp_1: Laya.Box
	complete_img_1: Laya.Image
	nofire_img_1: Laya.Image
	boom_effect_gp_1: Laya.Box
	fire_effect_gp_1: Laya.Box
	point_gp_2: Laya.Box
	complete_img_2: Laya.Image
	nofire_img_2: Laya.Image
	boom_effect_gp_2: Laya.Box
	fire_effect_gp_2: Laya.Box
	point_gp_3: Laya.Box
	complete_img_3: Laya.Image
	nofire_img_3: Laya.Image
	boom_effect_gp_3: Laya.Box
	fire_effect_gp_3: Laya.Box
	point_gp_4: Laya.Box
	complete_img_4: Laya.Image
	nofire_img_4: Laya.Image
	boom_effect_gp_4: Laya.Box
	fire_effect_gp_4: Laya.Box
	point_gp_5: Laya.Box
	complete_img_5: Laya.Image
	nofire_img_5: Laya.Image
	boom_effect_gp_5: Laya.Box
	fire_effect_gp_5: Laya.Box
	point_gp_6: Laya.Box
	complete_img_6: Laya.Image
	nofire_img_6: Laya.Image
	boom_effect_gp_6: Laya.Box
	fire_effect_gp_6: Laya.Box
	point_gp_7: Laya.Box
	complete_img_7: Laya.Image
	nofire_img_7: Laya.Image
	boom_effect_gp_7: Laya.Box
	fire_effect_gp_7: Laya.Box
	_test_gp: Laya.Box
	_Group2: Laya.Box
	skill_img: Laya.Image
	lock_img: Laya.Image
	image: Laya.Image
	_Group4: Laya.Box
	unlock_left_img: Laya.Image
	unlock_right_img: Laya.Image
	_Group5: Laya.Box
	unlock_img: Laya.Image
	_Image2: Laya.Image
	skill_detail_img: Laya.Image
	_Group6: Laya.Box
	vip_stage_bg_img: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	complete_lb: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	lb_skill_desc:Laya.HTMLDivElement
	ChangeTaskFire
	InitEvent
	LoadSuccess
	LocalDeleteMe
	ReOpen_callback
	Scr_Scroller1
	SkillSort
	UpdateView
	task_item_gp

	public constructor(parent?) {
		super(parent)


		let model = TopVipModel.GetInstance()

		let local_Number = Number
		let local_TopVipEvent = TopVipEvent
		let item_list_ = null
		let skill_id_ = null
		let _stage_ = null
		let _sub_stage_ = null
		let is_up_// = false
		let fire_index = 0
		this.base_file = "topVip"
		this.layout_file = "TopVipSkillView"
		this.preload_client_config={
			"ClientTopVipActivationConfig":false
		}
		this.preload_server_config={
			"config_supreme_vip_skill_task":false
		}
		this.load_callback = () => {

			// this.RegisterMask(this.task_item_gp)
			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this.complete_lb.size = 18
			// 	this.complete_lb.lineSpacing = 0.8
			// 	let csf = this.complete_lb.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDeltaX(this.complete_lb, 720.5)
			// 	SetAnchoredPosition(this.complete_lb, 0, -17)
			// 	this.complete_lb.verticalAlign = "middle"
			// 	this.complete_lb.textAlign = "center"
			// 	this._Label1.size = 16
			// 	this._Label1.lineSpacing = 0.6
			// 	let csf = this._Label1.GetComponent("ContentSizeFitter")
			// 	csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			// 	SetSizeDeltaX(this._Label1, 268.2)
			// 	SetAnchoredPosition(this._Label1, 12.6, -3.1)
			// 	this._Label1.verticalAlign = "middle"
			// 	this._Label1.textAlign = "center"
			// }
		}
		this.ReOpen_callback = () => {
			this.UpdateView()
			//if (fire_index > 0 ) {
			//for (let i = 0; i < fire_index; i++){
			//this:AddUIEffect("UI_2011", "UI", this["transfire_effect_gp_" + i], null, null, true)
			//}
			//}
		}

		this.LoadSuccess = () => {
			//this.lock_img.touchEnabled = false
			ResManager.GetInstance().SetImageSprite(this, this.vip_stage_bg_img, "topVip_asset", "uizz_011a")
			this.complete_lb.innerHTML="完成任务获得<font color='#d15e00'>永久属性加成</font>，且技能<font color='#d15e00'>激活进度+1</font>"
			// this.complete_lb.x=360-this.complete_lb.contextWidth/2
		}

		this.UpdateView = () => {
			if (model.GetSkillTask() && model.GetSkillTask().stage!=undefined) {
				let stage = model.GetSkillTask().stage
				let sub_stage = model.GetSkillTask().sub_stage
				if (stage == 5 && sub_stage == 8) {
					this.lock_img.visible = false
				}
				_stage_ = stage
				_sub_stage_ = sub_stage
				//model:SetSkillEffectPosIndex(sub_stage)
				ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_img, "resource/game/skillIcon/430100" + (local_Number(stage) + 1) + ".png")
				// ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_detail_img, "resource/game/topVip/texture/uizz_003_" + stage + ".png", true)
				this.lb_skill_desc.innerHTML=this.preload_client_config["ClientTopVipActivationConfig"]["stage_"+Number(stage)].desc
				this.lb_skill_desc.x=324-this.lb_skill_desc.contextWidth/2
				this.lb_skill_desc.y=16-this.lb_skill_desc.contextHeight/2
				skill_id_ = local_Number("430100" + (local_Number(stage) + 1))
				ResManager.GetInstance().SetImageSprite(this, this.unlock_left_img, "topVip_asset", "sz_" + sub_stage)
				this.ChangeTaskFire(sub_stage)
				let skill_list = this.SkillSort(stage)
				if (item_list_) {
					if (item_list_ && item_list_.length > 0) {
						for (let _tmpi in item_list_) {
							var obj = item_list_[_tmpi]
							obj.DeleteMe()
						}
						item_list_ = null
					}
				}
				item_list_ = []
				let index = 0
				let i = 0
				do {
					let content = JSON.parse(skill_list[i].content)
					let reward = JSON.parse(skill_list[i].reward)
					let target = null
					let task_id = skill_list[i].task_id
					let task_name = skill_list[i].name
					let jump_id = skill_list[i].jump_id
					for (let _tmpi in content) {
						var N = content[_tmpi]
						if (Number(N[1]) == 27) {
							target = 1
							break
						}
						target = N[1]
					}
					// [ts2lua]item_list_下标访问可能不正确
					let item = item_list_[index]
					if (!item) {
						item = new TopVipSkillItem(this.Content)
						item.Load()
						table.insert(item_list_, item)
					}
					index = index + 1
					item.Setdata(task_name, task_id, target, jump_id, index, reward)
					i = i + 1
				} while ((i < skill_list.length))
			}
		}

		this.InitEvent = () => {
			model.Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45102)
			this.BindEvent(model, local_TopVipEvent.UPDATE_TOP_VIP_SKILL_VIEW, () => {
				this.UpdateView()
			}
			)
			this.BindEvent(model, local_TopVipEvent.ADD_SKILL_EFFECT, (is_up?) => {
				let index = model.GetSkillEffectPosIndex()
				is_up_ = is_up
				// [ts2lua]this下标访问可能不正确
				fire_index = index + 1
				// this["fire_effect_gp_" + index].y=-70
				this.AddUIEffect("UI_2011", this["fire_effect_gp_" + index], {x:0,y:-1}, 15, true,null, null,
					() => {
						if (is_up_ && is_up_ != 0) {

							ResManager.GetInstance().SetImageSprite(this, this.complete_img_7, "topVip_asset", "uizz_007", true)
							ResManager.GetInstance().SetImageSprite(this, this.unlock_left_img, "topVip_asset", "sz_8", true)
							this.AddUIEffect("UI_2011", this.fire_effect_gp_7, null, null, true)
							this.nofire_img_7.visible = false
							is_up_ = false
							model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipActivationSkillView", skill_id_, _stage_)
							//model:Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45102)
							// this.BindEvent(GlobalEventSystem, EventName.CONGRATULATION_VIEW_CLOSE, () => {
							// 	if (is_up_ && is_up_ != 0) {

							// 	}
							// }
							// )
						} else {
							this.UpdateView()
							//model:Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipActivationSkillView", skill_id_, _stage_)
							//model:Fire(local_TopVipEvent.TOP_VIP_REQUEST_PROTO, 45102)
							//this:UpdateView()
						}
					}
				)

			}
			)
			Util.AddClickEvent(this.skill_introduce_img, () => {
				model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipSkillDetailView")
			}
				, this, true)
			Util.AddClickEvent(this.skill_img, () => {
				model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipSkillIntroduceView", skill_id_)
			}
				, this, false)
			let i = 0
			do {
				// [ts2lua]this下标访问可能不正确
				Util.AddClickEvent(this["point_gp_" + i], (...new_args) => {
					// [ts2lua]this下标访问可能不正确
					let args = new_args
					let pos = new Vector2(args[0].currentTarget.x,args[0].currentTarget.y) 
					model.Fire(local_TopVipEvent.OPEN_TOP_VIP_View, "TopVipSkillPointView", _stage_, i, pos,null)
				}
					, this, false)
				i = i + 1
			} while ((i < 8))
		}

		this.ChangeTaskFire = (sub_stage?) => {
			let i = 0
			do {
				// [ts2lua]this下标访问可能不正确
				this.ClearUIEffect(this["fire_effect_gp_" + i])
				if (i < sub_stage) {
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetImageSprite(this, this["complete_img_" + i], "topVip_asset", "uizz_007", true)
					this.AddUIEffect("UI_2011", this["fire_effect_gp_" + i], {x:0,y:-1}, 15, true)
					// this["fire_effect_gp_"+i].y=-70
					// [ts2lua]this下标访问可能不正确
					this["nofire_img_" + i].visible = false
					fire_index = i + 1
				} else {
					// [ts2lua]this下标访问可能不正确
					ResManager.GetInstance().SetImageSprite(this, this["complete_img_" + i], "topVip_asset", "uizz_004", true)
					// [ts2lua]this下标访问可能不正确
					this["nofire_img_" + i].visible = true
				}
				i = i + 1
			} while ((i < 8))
		}

		this.SkillSort = (stage?) => {
			let config_supreme_vip_skill_task = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_skill_task", false)
			let task_list = model.GetSkillTask().task_list
			let finish_list = []
			let un_finish_list = []
			let receive_list = []
			for (let key in config_supreme_vip_skill_task) {

				// [ts2lua]config_supreme_vip_skill_task下标访问可能不正确
				let cfg = config_supreme_vip_skill_task[key]
				if (!(cfg.stage != stage)) {
					for (let _tmpi in task_list) {
						var task = task_list[_tmpi]
						if (cfg.task_id == task.task_id) {
							if (task.is_finish == 1 && task.is_commit != 1) {
								table.insert(receive_list, cfg)
							} else if (task.is_commit == 1) {
								table.insert(finish_list, cfg)
							} else {
								table.insert(un_finish_list, cfg)
							}
						}
					}
				}

			}
			let list = []
			// list = table.merge(receive_list, un_finish_list)
			// table.merge(list, finish_list)
			list=list.concat(receive_list)
			list=list.concat(un_finish_list)
			list=list.concat(finish_list)
			return list
		}

		this.LocalDeleteMe = () => {
			if (item_list_ && item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = null
			}
			for (let i = 1; i <= 7; i++) {
				this.ClearUIEffect(this["fire_effect_gp_" + i])
			}
			fire_index = 0
		}


	}


	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._Group1,
			this._Image1,
			this._Label1,
			this.skill_introduce_img,
			this.point_gp_0,
			this.complete_img_0,
			this.nofire_img_0,
			this.boom_effect_gp_0,
			this.fire_effect_gp_0,
			this.point_gp_1,
			this.complete_img_1,
			this.nofire_img_1,
			this.boom_effect_gp_1,
			this.fire_effect_gp_1,
			this.point_gp_2,
			this.complete_img_2,
			this.nofire_img_2,
			this.boom_effect_gp_2,
			this.fire_effect_gp_2,
			this.point_gp_3,
			this.complete_img_3,
			this.nofire_img_3,
			this.boom_effect_gp_3,
			this.fire_effect_gp_3,
			this.point_gp_4,
			this.complete_img_4,
			this.nofire_img_4,
			this.boom_effect_gp_4,
			this.fire_effect_gp_4,
			this.point_gp_5,
			this.complete_img_5,
			this.nofire_img_5,
			this.boom_effect_gp_5,
			this.fire_effect_gp_5,
			this.point_gp_6,
			this.complete_img_6,
			this.nofire_img_6,
			this.boom_effect_gp_6,
			this.fire_effect_gp_6,
			this.point_gp_7,
			this.complete_img_7,
			this.nofire_img_7,
			this.boom_effect_gp_7,
			this.fire_effect_gp_7,
			this._test_gp,
			this._Group2,
			this.skill_img,
			this.lock_img,
			this.image,
			this._Group4,
			this.unlock_left_img,
			this.unlock_right_img,
			this._Group5,
			this.unlock_img,
			this._Image2,
			this.skill_detail_img,
			this._Group6,
			this.vip_stage_bg_img,
			this._Image3,
			this._Image4,
			this.complete_lb,
			this._Scroller1,
			this.Content,
			this.lb_skill_desc
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Group1",
				"_Image1",
				"_Label1",
				"skill_introduce_img",
				"point_gp_0",
				"complete_img_0",
				"nofire_img_0",
				"boom_effect_gp_0",
				"fire_effect_gp_0",
				"point_gp_1",
				"complete_img_1",
				"nofire_img_1",
				"boom_effect_gp_1",
				"fire_effect_gp_1",
				"point_gp_2",
				"complete_img_2",
				"nofire_img_2",
				"boom_effect_gp_2",
				"fire_effect_gp_2",
				"point_gp_3",
				"complete_img_3",
				"nofire_img_3",
				"boom_effect_gp_3",
				"fire_effect_gp_3",
				"point_gp_4",
				"complete_img_4",
				"nofire_img_4",
				"boom_effect_gp_4",
				"fire_effect_gp_4",
				"point_gp_5",
				"complete_img_5",
				"nofire_img_5",
				"boom_effect_gp_5",
				"fire_effect_gp_5",
				"point_gp_6",
				"complete_img_6",
				"nofire_img_6",
				"boom_effect_gp_6",
				"fire_effect_gp_6",
				"point_gp_7",
				"complete_img_7",
				"nofire_img_7",
				"boom_effect_gp_7",
				"fire_effect_gp_7",
				"_test_gp",
				"_Group2",
				"skill_img",
				"lock_img",
				"image",
				"_Group4",
				"unlock_left_img",
				"unlock_right_img",
				"_Group5",
				"unlock_img",
				"_Image2",
				"skill_detail_img",
				"_Group6",
				"vip_stage_bg_img",
				"_Image3",
				"_Image4",
				"complete_lb",
				"_Scroller1",
				"Content",
				"lb_skill_desc"
			])
		this.complete_lb.style.fontSize=22
		this.complete_lb.style.color="#7a5144"
		this.complete_lb.style.wordWrap=false
		this.lb_skill_desc.style.fontSize=20
		this.lb_skill_desc.style.color="#ffffff"
		this.lb_skill_desc.style.wordWrap=false
		this.lb_skill_desc.style.bold=true
		this._Scroller1.vScrollBar.visible=false
	}
}
window["TopVipSkillView"]=TopVipSkillView