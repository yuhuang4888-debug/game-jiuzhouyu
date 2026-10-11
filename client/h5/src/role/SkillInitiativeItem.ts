import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { Mathf } from "../util/Mathf"
import { SetAnchoredPosition, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { RoleManager } from "../commonModel/RoleManager"

export class SkillInitiativeItem extends BaseItem1 {
	_Image1: Laya.Image
	_img_mask: Laya.Image
	_img_black: Laya.Image
	_lb_level: Laya.Label
	_reddot: Laya.Image
	_group_eff: Laya.Box
	_circleR
	_data
	_img_icon
	_img_lock
	_img_select
	_mask_mask
	_model
	_radian
	_scmd
	is_delay_callback
	x
	y

	public SetCircle(value_x?, value_y?) {
		this.x=260 + this._circleR * Mathf.Cos(value_x)
		this.y= 260 + this._circleR * Mathf.Sin(value_y)
		// SetAnchoredPosition(this.display_obj,260 + this._circleR * Mathf.Cos(value_x) , 260 + this._circleR * Mathf.Sin(value_y))
		// this.y=this.y+15
		// this.display_obj.x = this.display_obj.x - 30
		// if(this.display_obj){
			// SetAnchoredPosition(this,this.x,this.y)
			// this.x=this.x-30
		// }
	}

	public constructor(parent?) {
		super(parent)


		this._data = null
		this._scmd = null
		this._circleR = 192.5
		this._radian = -2 * (Mathf.PI * 2 / 9)
		this.base_file = "role"
		this.layout_file = "SkillInitiativeItem"
		this.is_delay_callback = false
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this._model = SkillUIModel.GetInstance()
	}

	public LoadSuccess() {
		// SetAnchoredPosition(this.display_obj,this.x,this.y)
		// this.display_obj.x=this.display_obj.x-30
		//this:SetMask()
		this.InitEvent()
	}

	public SetMask() {

		// Util.SetCircleMask(this._img_icon)
		this.SetPosition(0.5, 0)/* = new Vector2(0.5, 0.5)*/
	}

	public SetLockMask() {

		//if (this._img_mask.mask ) {
		//return
		//}
		//Util.SetCircleMask(this._img_mask)
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_icon, () => {
			if (!this._data || this._data.ignore) {
				Message.show("该技能暂未开放，敬请期待")
				return
			}
			this._model.Fire(SkillUIModel.SELECT_SKILL_ITEM, this._data, this._scmd)
		}, this)
		Util.AddClickEvent(this._img_lock, () => {
			if (!this._data || this._data.ignore) {
				Message.show("该技能暂未开放，敬请期待")
				return
			}
			this._model.Fire(SkillUIModel.SELECT_SKILL_ITEM, this._data, this._scmd)
		}, this)

		this.BindEvent(this._model, SkillUIModel.SELECT_SKILL_ITEM, (data?, scmd?) => {
			this.Select(this._data == data)
		}
		)

		this.BindEvent(RoleManager.GetInstance().GetMainRoleVo(), EventName.CHANGE_LEVEL, () => {
			this.SetData(this._data)
		}
		)
	}

	//function SkillInitiativeItem.SetProto(scmd)
	//this._scmd = scmd
	//if (! scmd ) {
	//return
	//}
	//}

	public SetData(data?) {

		this._data = data
		if (!data || data.ignore) {
			return
		}
		SetAnchoredPosition(this.display_obj,this.x,this.y)
		this.display_obj.x=this.display_obj.x-30
		let lock = true
		if (data.type == 1) {
			let lv = RoleManager.GetInstance().GetMainRoleVo().level
			lock = data.open_lv && lv < data.open_lv || false
			if( data.task_id){
				lock = !this._model.CheckTaskFinish(data.task_id)
			}
		} else if (data.type == 2) {
			lock = data.open_lock
		}
		this._img_lock.visible = lock
		if (lock) {
			return
		}
		let skill_lv = Mathf.Max(data.level, 1)
		let [description, name, power, icon] = SkillManager.GetInstance().GetSkillFromConfigByIdAndLevelAndPower(data.skill_id, skill_lv)
		let _url = "resource/game/skillIcon/" + icon + ".png"
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, _url,true)
	}

	public Select(visible?) {

		this._img_select.visible = visible
	}

	// public SetPos(x, y) {
	// 	this.x = x
	// 	this.y = y
	// }


	public GetComponents() {
		[
			this._Image1,
			this._img_mask,
			this._img_select,
			this._img_icon,
			this._img_black,
			this._img_lock,
			this._lb_level,
			this._reddot,
			this._group_eff,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_mask",
				"_img_select",
				"_img_icon",
				"_img_black",
				"_img_lock",
				"_lb_level",
				"_reddot",
				"_group_eff",
			])
	}
}
window["SkillInitiativeItem"] = SkillInitiativeItem