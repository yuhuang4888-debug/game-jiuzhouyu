import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class DungeonDragonSkillItem extends BaseItem1 {
	model
	need_refresh_data
	need_refresh_skill_data
	num
	skill_id


	public constructor(parent?) {
		super(parent)

		this.num = 0;
		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonSkillItem"
		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {

			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		this.InitEvent()
		if (this.need_refresh_skill_data) {
			this.InitSkill()
		}
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this._img_skill, () => {
			if (this.num && this.num > 0) {
				this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61056, this.skill_id)
			} else {
				Message.show("技能数量不足")
			}
		}
			, this, true)
	}

	public SetSkillId(skill_id?) {

		this.skill_id = skill_id
		if (this.is_loaded) {
			this.InitSkill()
		} else {
			this.need_refresh_skill_data = true
		}
	}

	public GetSkillId() {

		return this.skill_id
	}

	public SetNum(num?) {

		this.num = num
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public InitSkill() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill, GameResPath.GetSkillIconPath(this.skill_id))
	}

	public UpdateView() {

		this._lb_left_count.text = this.num + "次"
	}

	public DeleteMe() {

		super.DeleteMe()
	}

	_img_skill: Laya.Image
	_lb_left_count: Laya.Label
	public GetComponents() {
		[
			this._img_skill,
			this._lb_left_count,
		]
			= this.GetChildrenByNames([

				"_img_skill",
				"_lb_left_count",
			])
	}
}
window["DungeonDragonSkillItem"] = DungeonDragonSkillItem