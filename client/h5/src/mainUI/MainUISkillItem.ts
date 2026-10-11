
////////////////////////////////////////////////////////////////////-
import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { FightEvent } from "../scene/fight/FightEvent"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { CirCleCdView } from "../uiComponent/CirCleCdView"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
////////////////////////////////////////////////////////////////////-
//-@class MainUISkillItem
export class MainUISkillItem extends BaseItem1 {
	is_active
	is_partner
	skill_vo
	cd_mask:CirCleCdView
	skill_mgr
	need_refresh_data

	public constructor(parent) {
		super(parent)
		this.base_file = "mainUI"
		this.layout_file = "MainUISkillItem"
		this.skill_mgr = SkillManager.GetInstance()
		this.is_active = true
		this.load_callback = () => {
			this.LoadSuccess()
			if (this.need_refresh_data) {
				this.UpdateItem()
				this.need_refresh_data = null
			}
		}
	}
	public LoadSuccess() {
		this.InitEvent()
	}
	public InitEvent() {
		var onBtnClickHandler = () => {
			if(RoleManager.GetInstance().GetMainRoleDepositState()){
				Message.show("自动战斗中")
				return
			} 
			let skillVo = this.skill_vo
			if (skillVo && skillVo.CoolDown()) {
				GlobalEventSystem.Fire(FightEvent.SKILL_SHORTCUT_CLICK, skillVo.id, SkillManager.SKILL_ATTACK_TYPE.ONLY_FIRE_ATTACK)
			} else {
				Message.show("技能冷却")
			}
		}
		Util.AddClickEvent(this.con, onBtnClickHandler, this, true)

		this.BindEvent(SkillManager.GetInstance(), SkillManager.SHORT_CUT_SKILL_ACTIVE, (state?) => {
			let skill_id = this.skill_vo && this.skill_vo.id || 0
			if (!state && !this.skill_mgr.IsSkillShortcutGray(null, skill_id)) {
				return
			}
			this.SetSkillActive(state)
		})
	}
	public ActiveSkill() {
		// this.AddUIEffect("UI_1404", "Main", this, null, null, false)
	}
	public SetData(skill_vo?) {
		this.skill_vo = skill_vo
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}
	
	public UpdateItem() {
		if (!this.skill_vo) { return }

		//海域空值
		if(this.skill_vo&&this.skill_vo["is_lock"]){
			this.lock.visible = true
			if (this.cd_mask) {
				this.cd_mask.SetVisible(false)
			}
			return
		}

		if (this.skill_vo) {
			let skill_vo = this.skill_vo
			let show_icon = skill_vo.level == 0 && skill_vo.GetIcon(1) || skill_vo.GetIcon()
			ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetSkillIcon(show_icon))
			this.UpdateLockState()

			if(!this.cd_mask){
				this.cd_mask = new CirCleCdView(this.display_obj)
				this.cd_mask.SetPosition(3.5, 4.5)
				this.cd_mask.Load()
			}
			this.cd_mask.SetVisible(true)
			this.cd_mask.SetData(() => {}, false, skill_vo.id, 38, 21)
		} else {
			this.lock.visible = true
			if (this.cd_mask) {
				this.cd_mask.SetVisible(false)
			}
		}
	}

	public SetSkillActive(state?) {
		this.is_active = state
		this.UpdateLockState()
	}

	public UpdateLockState() {
		let lock = false
		if (this.skill_vo && this.skill_vo.level == 0) {
			lock = true
		}
		if (!lock) {
			lock = !this.is_active
		}
		this.lock.visible = lock
		this.con.mouseEnabled = !lock
	}

	//清除界面
	public DeleteMe() {
		if (this.cd_mask) {
			this.cd_mask.DeleteMe()
			this.cd_mask = undefined
		}
		super.DeleteMe()
	}

	con: Laya.Box
	bg: Laya.Image
	icon: Laya.Image
	lock: Laya.Image
	public GetComponents() {
		[
			this.con,
			this.bg,
			this.icon,
			this.lock,
		]
			= this.GetChildrenByNames([

				"con",
				"bg",
				"icon",
				"lock",
			])
	}
}
window["MainUISkillItem"] = MainUISkillItem