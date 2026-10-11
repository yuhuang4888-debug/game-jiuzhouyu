import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util } from "../util/Util"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { SkillManager } from "../skill/SkillManager"
import { PlatformManager } from "../PlatformManager"
import { GodBefallModel } from "../commonModel/GodBefallModel"

export class GodBefallSkillItem extends BaseItemRenderer {
	WIDTH = 70
	HEIGT = 70

	_is_lock
	_model
	need_refresh = false

	public constructor() {
		super()
		this._is_lock = false
		this.base_file = "godBefall"
		this.layout_file = "GodBefallSkillItem"

		this._model = GodBefallModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			if(this.need_refresh){
				this.need_refresh = false
				this.dataChanged()
			}
		}
		this.Load()
	}

	public InitEvent() {
		Util.AddClickEvent(this._gp_click, () => {
			let sdata = (!this.data.is_skill) && { skill_id: this.data[0], skill_lv: this.data[2] } || { skill_id: this.data.skill_id, skill_lv: 1 }
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "SkillTipsView", sdata)
		}, this, true)
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public dataChanged() {
		if(!this.data){
			return
		}
		if(!this.is_loaded){
			this.need_refresh = true
			return
		}
		
		let type = typeof (this.data)
		if (type == "string" || this.data.is_skill) {
			// 技能
			let vo = this._model.GetGodVoInDic(this.data.god_id)
			let is_lock = !vo
			let skill_id = this.data.skill_id
			this._gp_lock.visible = false
			let skill_vo = SkillManager.GetInstance().getSkill(skill_id)
			if (skill_vo){
				let lv_data = skill_vo.getLevelVo(1)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(lv_data.icon))
			}
			Util.SetImageGray(this._img_icon, is_lock)
			/*
			if (!is_lock) {
				this._img_icon.material = null
			}
			*/
			this._skill_tag.visible = this.data.is_tag_skill == true
		}
		else if (type == "object") {
			// 天赋
			let data = this.data
			let vo = this._model.GetGodVoInDic(data.god_id)
			let is_lock = !vo || (vo && vo.grade < Number(data[1]))
			this._is_lock = is_lock
			this._gp_lock.visible = is_lock
			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_lock.text = (is_lock && (data[1] + "grade") || (""))
			} else if (PlatformManager.IsEyouThPlatform()) {
				this._lb_lock.text = (is_lock && ("ขั้น" + data[1] + "ปลด") || (""))
			} else {
				this._lb_lock.text = (is_lock && (data[1] + "阶解锁") || (""))
			}
			let skill_vo = SkillManager.GetInstance().getSkill(Number(data[0]))
			if (skill_vo) {
				let lv_data = skill_vo.getLevelVo(Number(data[2]))
				let key = (lv_data && lv_data.icon != "" && (lv_data.icon) || (data[0]))
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(key))
			} else {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(data[1]))
			}
			Util.SetImageGray(this._img_icon, is_lock)
			/*
			if (!is_lock) {
				this._img_icon.material = null
			}
			*/
			this._skill_tag.visible = false
		}
	}
	
	_gp_click: Laya.Box
	_Image1: Laya.Image
	_img_icon: Laya.Image
	_gp_lock: Laya.Box
	_lb_lock: Laya.Label
	_skill_tag: Laya.Image
	public GetComponents() {
		[
			this._gp_click,
			this._Image1,
			this._img_icon,
			this._gp_lock,
			this._lb_lock,
			this._skill_tag,
		]
			= this.GetChildrenByNames([
				"_gp_click",
				"_Image1",
				"_img_icon",
				"_gp_lock",
				"_lb_lock",
				"_skill_tag",
			])
	}
}
window["GodBefallSkillItem"] = GodBefallSkillItem