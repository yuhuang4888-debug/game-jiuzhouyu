import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { SkillManager } from "../skill/SkillManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class ReincarnationSkillItem extends BaseItem1 {
	InitEvent
	SetUpSkillData

	public constructor(parent?) {
		super(parent)
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationSkillItem"
		let reinModel = ReincarnationModel
		let local_reinModel = reinModel.GetInstance()
		let local_util = Util
		// let lcoal_resMgr = lua_resM
		let skill_data_ = null
		let data_type_ = null
		let need_refresh_ = false
		this.load_callback = () => {

			this.InitEvent()
			if (need_refresh_) {
				this.SetUpSkillData(skill_data_)
				need_refresh_ = false
			}
		}

		this.InitEvent = () => {
			let OnBeforeSkillClick = () => {
				if (skill_data_) {
					local_reinModel.Fire(reinModel.REBIRTH_OPEN_VIEW, "ReincarnationSkillTipsView", skill_data_, data_type_)
				}
			}
			Util.AddClickEvent(this.beforeSkill, OnBeforeSkillClick, this, false)

			let OnAfterSkillClick = () => {
				if (skill_data_) {
					local_reinModel.Fire(reinModel.REBIRTH_OPEN_VIEW, "ReincarnationSkillTipsView", skill_data_, data_type_)
				}
			}
			Util.AddClickEvent(this.afterSkill, OnAfterSkillClick, this, false)
		}

		this.SetUpSkillData = (skill_data?) => {
			skill_data_ = skill_data
			data_type_ = 2
			if (this.is_loaded) {
				let skillVo = SkillManager.GetInstance().getSkill(Number(skill_data[0]))
				if (skillVo) {
					let beforeSkillUrl = GameResPath.GetSkillIconPath(skillVo.GetIcon(Number(skill_data[1] - 1)))  //"resource/game/skillsicon/" + (skillVo.GetIcon(skill_data[1] - 1)) + ".png"
					ResManager.GetInstance().SetOutsideImageSprite(this, this.beforeSkill, beforeSkillUrl)
					let afterSkillUrl = GameResPath.GetSkillIconPath(skillVo.GetIcon(Number(skill_data[1]))) //"resource/game/skillsicon/" + skillVo.GetIcon(skill_data[1]) + ".png"
					ResManager.GetInstance().SetOutsideImageSprite(this, this.afterSkill, afterSkillUrl)
				}
			} else {
				need_refresh_ = true
			}
		}
	}

	skillGroup: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	mask1: Laya.Image
	beforeSkill: Laya.Image
	mask2: Laya.Image
	afterSkill: Laya.Image
	public GetComponents() {
		[
			this.skillGroup,
			this._Image1,
			this._Image2,
			this._Image3,
			this.mask1,
			this.beforeSkill,
			this.mask2,
			this.afterSkill,
		]
			= this.GetChildrenByNames([

				"skillGroup",
				"_Image1",
				"_Image2",
				"_Image3",
				"mask1",
				"beforeSkill",
				"mask2",
				"afterSkill",
			])
	}
}
window["ReincarnationSkillItem"] = ReincarnationSkillItem