import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SkillVo } from "../skill/SkillVo"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class DiamondFightSkillItem extends BaseItem1 {

	model: DiamondFightModel
	res_mgr: ResManager
	need_refresh_data
	skill_id
	time_id

	public constructor(parent?) {
		super(parent)

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightSkillItem"
		this.model = DiamondFightModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		this._html_desc.style.fontSize = 18
		// this._html_desc.style.wordWrap = false
		this._html_desc.style.color = "#5a1c20"
		this._html_desc.style.leading  = 5


		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateView()
		}
		this.InitEvent()

	}

	public InitEvent() {


		this.BindEvent(this.model, DiamondFightModel.UPDATE_SKILL_CD, (skill_id?, end_time?) => {
			if (skill_id == this.skill_id) {
				this.UpdateState()
			}
		})

		Util.AddClickEvent(this._box_use, () => {
			let end_time = this.model.GetSkillCd(this.skill_id)
			if (!end_time || end_time == 0 || TimeUtil.getServerTime() >= end_time) {
				this.model.Fire(DiamondFightModel.REQUEST_SCMD, 13715, this.skill_id)
			} else {
				Message.show("技能冷却中~")
			}
		}, this, true)

		this.BindVar(RoleManager.GetInstance().GetMainRoleVo(), "jin", () => {
			this.UpdateCost()
		})

	}

	public SetData(skill_id?) {

		this.skill_id = Number(skill_id)
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {

		let skill_vo = new SkillVo(this.skill_id)
		this._html_desc.innerHTML = skill_vo.getDesc(1)
		this._html_desc.style.width = 110
		let config_drumwar_value = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_value", false)
		this._lb_count.text = this.model.GetValueByKey(14, config_drumwar_value)
		this.res_mgr.SetOutsideImageSprite(this, this._img_skill_icon, GameResPath.GetSkillIconPath(this.skill_id))
		this.UpdateState()
		this.UpdateCost()
	}

	public UpdateCost() {
		let config_drumwar_value = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_value", false)
		let cost = this.model.GetValueByKey(14, config_drumwar_value)
		let jin = RoleManager.GetInstance().GetMainRoleVo().jin
		this._lb_count.color = jin >= cost && "#19ae4a" || "#ff4f50"
	}

	public UpdateState() {

		let end_time = this.model.GetSkillCd(this.skill_id) || 0
		let left_time = end_time - TimeUtil.getServerTime()
		let bool = left_time > 0
		this["_box_state0"].visible = !bool
		this["_box_state1"].visible = bool
		this.CancelTime()
		if (left_time > 0) {
			this.StartTime(() => {
				let left_time = end_time - TimeUtil.getServerTime()
				if (left_time < 0) {
					this.CancelTime()
					this.UpdateState()
					return
				}
				this._lb_cd_time.text = "等待\n" + left_time + "s"

			}
			)
		}
	}

	public CancelTime() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public StartTime(func?) {

		this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
		func()
	}

	public DeleteMe() {

		this.CancelTime()
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_skill_icon: Laya.Image
	_html_desc: Laya.HTMLDivElement
	_box_state0: Laya.Box
	_box_use: Laya.Box
	_img_use: Laya.Image
	_lb_use: Laya.Label
	_box_con: Laya.HBox
	_lb_count: Laya.Label
	_img_diamond: Laya.Image
	_box_state1: Laya.Box
	_lb_cd_time: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_skill_icon,
			this._html_desc,
			this._box_state0,
			this._box_use,
			this._img_use,
			this._lb_use,
			this._box_con,
			this._lb_count,
			this._img_diamond,
			this._box_state1,
			this._lb_cd_time,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_skill_icon",
				"_html_desc",
				"_box_state0",
				"_box_use",
				"_img_use",
				"_lb_use",
				"_box_con",
				"_lb_count",
				"_img_diamond",
				"_box_state1",
				"_lb_cd_time",
			])
	}
}
window["DiamondFightSkillItem"] = DiamondFightSkillItem
