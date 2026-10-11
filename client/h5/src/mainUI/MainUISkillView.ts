import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1, CloseMode } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GodBefallModel } from "../commonModel/GodBefallModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { PartnerAwakeEvent } from "../commonModel/PartnerAwakeEvent"
import { PartnerAwakeModel } from "../commonModel/PartnerAwakeModel"
import { PartnerModel } from "../commonModel/PartnerModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { MainUISkillItem } from "./MainUISkillItem"

export class MainUISkillView extends BaseView1 {
	is_auto_fight
	part_skill: MainUISkillItem
	skill_item_list
	local_MainUIModel_Instance
	pos_list
	auto_fight_mgr: AutoFightManager


	static GOD_SKILL_MAX = 4
	public constructor() {
		super()
		this.base_file = "mainUI"
		this.layout_file = "MainUISkillView"
		this.layer_value = Enum_UILayer.Main
		// this.close_mode = CloseMode.CloseDestroy
		this.destroy_imm = false

		this.is_auto_fight = false
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.local_MainUIModel_Instance = MainUIModel.GetInstance()

		this.pos_list = [[-5, 32],
		[36, -6],
		[106, -6],
		[148, 32]
		]
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.destroy_callback = () => {
			this.Remove()
		}
	}
	public Remove() {
		if (this.skill_item_list) {
			for (let _ = 0; _ < this.skill_item_list.length; _++) {
				var obj = this.skill_item_list[_]
				obj.DeleteMe()
			}
			this.skill_item_list = false
		}
		if (this.part_skill) {
			this.part_skill.DeleteMe()
			this.part_skill = null
		}
	}
	public LoadSuccess() {
		this.local_MainUIModel_Instance.SetMainuiLoadedFlag(this.layout_file, true, this)
		// this.form.pivot = Vector2(0.5, 0)
		// this.form.anchorMax = Vector2(0.5, 0)
		// this.form.anchorMin = Vector2(0.5, 0)
		// this.form.anchoredPosition = Vector2(0, 245)
		this.display_obj.centerX = 0
		this.display_obj.bottom = 239
		this.display_obj.drawCallOptimize = true
		this.InitEvent()
		this.UpdateView()
		this.UpdateAutoFightState()
		this.InitPartnerSkill()
	}
	public InitEvent() {
		this.BindEvent(SkillManager.GetInstance(), SkillManager.UPDATE_SKILL_LIST, () => {
			this.UpdateView()
			this.InitPartnerSkill()
			SkillManager.Instance.setCurrentSkillId()
			SkillManager.Instance.ClearCachedSkill()
		})
		this.BindEvent(GlobalEventSystem, EventName.UPDATE_AUTO_FIGHT_STATE, () => {
			this.UpdateAutoFightState()
		})
		this.BindEvent(GlobalEventSystem, EventName.AUTO_FIGHT_TEMP_MODE, () => {
			this.UpdateAutoFightState()
		})
		let auto_fun = (show_msg?, not_save_cookies?) => {
			this.SetAutoFight(true, show_msg || false, not_save_cookies)
		}
		let stop_auto_fun = (show_msg?, not_save_cookies?) => {
			this.SetAutoFight(false, show_msg || false, not_save_cookies)
		}
		this.BindEvent(GlobalEventSystem, EventName.STARTAUTOFIGHT, auto_fun)
		this.BindEvent(GlobalEventSystem, EventName.STOPAUTOFIGHT, stop_auto_fun)
		this.BindEvent(this.local_MainUIModel_Instance, MainUIModel.ACTIVE_SKILL, (skill_id?) => {
			let skill_item = this.GetSkillItemById(skill_id)
			if (skill_item) {
				skill_item.ActiveSkill()
			}
		})
		Util.AddClickEvent(this._img_auto_fight, (target?, x?, y?) => {
			// 如果在经验副本不能拖动
			if (SceneManager.GetInstance().IsExpScene()) {
				return Message.show('副本自动战斗中')
			}
			this.ResponseAutoBtnClick()
		}, this, true)

		Util.AddClickEvent(this._img_partner_lock, () => {
			// PartnerAwakeModel.GetInstance().Fire(PartnerAwakeEvent.AWAKE_OPEN_VIEW, "PartnerAwakeShowView")
			ViewPopLevelModel.GetInstance().SetViewPop('PartnerAwakeShowView');
		}, this, true)

		this.BindEvent(PartnerModel.GetInstance(), PartnerModel.REF_PARTNERSKILL, () => {
			this.InitPartnerSkill()
		})
	}
	public UpdateAutoFightState() {
		this.is_auto_fight = this.auto_fight_mgr.GetAutoFightState()
		let source = !this.is_auto_fight && "uizjmgj_003a" || "uizjmgj_001b"
		if (this.is_auto_fight && this.auto_fight_mgr.GetTempMode()) {
			source = "uizjmgj_001a1"
		}
		ResManager.GetInstance().SetImageSprite(this, this._img_auto_fight, this.base_file + "_asset", source, true)
	}
	public GetSkillItemById(skill_id?) {
		if (this.skill_item_list) {
			for (let _ in this.skill_item_list) {
				var skill_item = this.skill_item_list[_]
				if (skill_item.skill_vo.id == skill_id) {
					return skill_item
				}
			}
		}
		return null
	}
	public GetSkillPosById(skill_id?) {
		if (this.skill_item_list) {
			for (let _ in this.skill_item_list) {
				var skill_item = this.skill_item_list[_]
				if (skill_item.skill_vo.id == skill_id && skill_item.is_loaded) {
					return skill_item.display_obj.localToGlobal(new Laya.Point())
				}
			}
		}
		return null
	}
	public UpdateView() {
		let skill_list = []
		let god_id = RoleManager.Instance.mainRoleInfo.god_id || 0
		if (SceneManager.Instance.IsSeaHegemonyScene()) {
			skill_list = SeaHegemonyModel.GetInstance().GetShipSkillList()
			if (skill_list.length < MainUISkillView.GOD_SKILL_MAX) {
				for (let i = skill_list.length; i < MainUISkillView.GOD_SKILL_MAX; i++) {
					table.insert(skill_list, { is_lock: true })
				}
			}
		}

		//用通用的技能
		// else if (SceneManager.GetInstance().IsPolarDungeon() || SceneManager.GetInstance().IsKFPolarDungeon()) {
		// 	skill_list = BaseDungeonModel.GetInstance().GetPolarSkillList()
		// 	if (skill_list.length < MainUISkillView.GOD_SKILL_MAX) {
		// 		for (let i = skill_list.length + 1; i <= MainUISkillView.GOD_SKILL_MAX; i++) {
		// 			table.insert(skill_list, {})
		// 		}
		// 	}

		// }
		else if (god_id > 0) {
			skill_list = GodBefallModel.GetInstance().CheckAndGetMainRoleGodAllSkill(SkillManager.GetInstance())
			if (skill_list.length < MainUISkillView.GOD_SKILL_MAX) {
				for (let i = skill_list.length; i < MainUISkillView.GOD_SKILL_MAX; i++) {
					table.insert(skill_list, {})
				}
			}
		} else {
			skill_list = SkillManager.GetInstance().shortcutList
		}
		if (!this.skill_item_list) {
			this.skill_item_list = []
		}
		let item, pos
		for (let index = 0; index < skill_list.length; index++) {
			var vo = skill_list[index]
			item = this.skill_item_list[index]
			if (item == null) {
				item = new MainUISkillItem(this._box_skill_con)
				item.Load()
				this.skill_item_list[index] = item
			}
			item.SetData(vo)
			item.SetVisible(true)
			pos = this.pos_list[index]
			item.SetPosition(pos[0], pos[1])
		}
		for (let i = skill_list.length; i < this.skill_item_list.length; i++) {
			this.skill_item_list[i].SetVisible(false)
		}
	}
	public SetAutoFight(bool?, show_msg?, not_save_cookies?) {
		if (this.is_auto_fight == bool && !this.auto_fight_mgr.GetTempMode()) { return }
		this.is_auto_fight = bool
		if (this.is_auto_fight) {
			this.auto_fight_mgr.CacheAutoFightPos()
			this.auto_fight_mgr.StartAutoFight(not_save_cookies)
			if (show_msg == null || show_msg) {
				Message.show("开启自动挂机")
			}
			//记录开始挂机的点
			let mainRole = Scene.Instance.GetMainRole()
			if (mainRole) {
				let x, y = mainRole.GetRealPos()
				this.auto_fight_mgr.SetBeginAutoPos(x, y)
				Scene.Instance.user_manul_time = 0 //置0，才会立即挂机
			}
			//点击挂机如果这时候选中是npc则取消目标
			let curr_target = Scene.Instance.GetClickTarget()
			if (curr_target && curr_target.obj_type == SceneBaseType.Npc) {
				Scene.Instance.CancelClickTarget()
			}
		} else {
			this.auto_fight_mgr.StopAutoFight(not_save_cookies)
			Scene.Instance.CancelClickTarget() //取消自动挂机的时候把目标清掉
			if (show_msg == null || show_msg) {
				Message.show("取消自动挂机")
			}
			this.auto_fight_mgr.SetBeginAutoPos(0, 0)
		}
	}
	public ResponseAutoBtnClick() {
		//清除主角的自挂机时间计数
		this.SetAutoFight(!this.is_auto_fight)
		if (this.is_auto_fight) {
			// Scene.Instance.UpdateAutoClickTarget()
			this.auto_fight_mgr.TrySetAutoFightPriority()
		}
	}
	public InitPartnerSkill() {
		if (CommonManager.GetInstance().CheckFuncOpenState("PartnerBaseView")) {
			let [skill_cfg] = PartnerModel.GetInstance().GetSkill()
			if (skill_cfg && skill_cfg.type != 2) {
				let skill_vo = SkillManager.GetInstance().getSkill(skill_cfg.id)
				if (skill_vo) {
					this._img_partner_lock.visible = false
					if (!this.part_skill) {
						this.part_skill = new MainUISkillItem(this._box_partner_skill)
						this.part_skill.Load()
						this.part_skill.ExcuteCallback(() => {
							// this._box_partner_skill.addChildAt(this._img_partner_lock, 1)
							ResManager.GetInstance().SetImageSprite(this.part_skill, this.part_skill.bg, "mainUI", "uiqlhx_018")
							this.part_skill.bg.width = 57
							this.part_skill.bg.height = 59
						})
					}
					this.part_skill.SetVisible(true)
					this.part_skill.ExcuteCallback(() => {
						this.part_skill.SetData(skill_vo)

					})
				}
			} else {
				if (this.part_skill) {
					this.part_skill.SetVisible(false)
				}
				if (PartnerAwakeModel.GetInstance().CanOpenPartnerAwakeView()) {
					this._img_partner_lock.visible = true
				}
			}
		} else {
			if (this.part_skill) {
				this.part_skill.SetVisible(false)
			}
			if (PartnerAwakeModel.GetInstance().CanOpenPartnerAwakeView()) {
				this._img_partner_lock.visible = true
			}
		}
		if (SceneManager.Instance.DisabledPartnerSkillScene()) {
			if (this.part_skill) {
				this.part_skill.SetVisible(false)
			}
		}
	}
	public Open() {
		super.Open()
	}
	_img_bg: Laya.Image
	_box_skill_con: Laya.Box
	_img_auto_fight: Laya.Image
	_box_partner_skill: Laya.Box
	_img_partner_lock: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._box_skill_con,
			this._img_auto_fight,
			this._box_partner_skill,
			this._img_partner_lock,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_skill_con",
				"_img_auto_fight",
				"_box_partner_skill",
				"_img_partner_lock",
			])
	}
}
window["MainUISkillView"] = MainUISkillView