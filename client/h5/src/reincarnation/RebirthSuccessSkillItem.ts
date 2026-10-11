import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { SkillManager } from "../skill/SkillManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class RebirthSuccessSkillItem extends BaseItem1 {
	need_refresh
	is_skill
	skillVo
	public constructor(parent?) {
		super(parent)
		this.base_file = "reincarnation"
		this.layout_file = "RebirthSuccessSkillItem"
		this.load_callback = () => {

			if (this.need_refresh) {
				this.SetData(this.is_skill, this.skillVo)
			}
			this.InitEvent()
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this.skillGroup, () => {
			if (this.is_skill) {
				ReincarnationModel.GetInstance().Fire(ReincarnationModel.REBIRTH_OPEN_VIEW, "ReincarnationSkillTipsView", this.skillVo)
			}
		}, this, false)
	}

	public SetData(is_skill?, skillInfo?) {
		this.skillVo = skillInfo
		this.is_skill = is_skill
		if (this.is_loaded) {
			this.up_img.visible = is_skill
			let lcoal_resMgr = ResManager.GetInstance()
			if (is_skill) {
				let local_skillMgr = SkillManager.GetInstance()
				let beforeSkillCfg = local_skillMgr.getSkillFromConfig(skillInfo[0])
				let skillVo = local_skillMgr.getSkill(Number(skillInfo[0]))
				if (skillVo) {
					let skillUrl = GameResPath.GetSkillIconPath(skillVo.GetIcon(Number(skillInfo[1])))
					lcoal_resMgr.SetOutsideImageSprite(this, this.afterSkill, skillUrl)
				}
			} else {
				lcoal_resMgr.SetOutsideImageSprite(this, this.afterSkill, GameResPath.GetSkillIcon(skillInfo))
			}
			//SetCircleMask(this.afterSkill)
		} else {
			this.need_refresh = true
		}
	}


	skillGroup: Laya.Box
	_Image1: Laya.Image
	mask: Laya.Image
	afterSkill: Laya.Image
	up_img: Laya.Image
	public GetComponents() {
		[
			this.skillGroup,
			this._Image1,
			this.mask,
			this.afterSkill,
			this.up_img,
		]
			= this.GetChildrenByNames([

				"skillGroup",
				"_Image1",
				"mask",
				"afterSkill",
				"up_img",
			])
	}
}
window["RebirthSuccessSkillItem"] = RebirthSuccessSkillItem