import { RedDotManager, ModuleType } from "../../common/RedDotManager"
import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { enum_OutWardType, OutWardBaseModel } from "../../commonModel/OutWardBaseModel"
import { GameResPath } from "../../util/GameResPath"
import { IllusionBaseView } from "../IllusionBaseView"

export class PartnerIllusionView extends IllusionBaseView {

	public constructor(parent?) {
		super(parent)

		this._type = enum_OutWardType.Partner
		this._model_type = UI_MODEL_TYPE.PARTNER
	}

	public LoadSuccess() {
		this.upstage_type = 1
		this.ui_type = 1
		super.LoadSuccess()

		let outwardmodel = OutWardBaseModel.GetInstance()
		let local_redMgr = RedDotManager.GetInstance()
		this.shadow_group.visible = false
		this.star_group.visible = false
		this.InitEvent = () => {
			this.BindEvent(outwardmodel, OutWardBaseModel.UPSTAR_SUCCESS, () => {
				this.resolve_red.visible = local_redMgr.CheckRedStatus(ModuleType.PAR_ILLU_STAR, this.select_index)
			})

			super.InitEvent()
		}

		this.SetUpStageData = () => {
			super.SetUpStageData()
			if (this.select_stage > 0) {
				this.resolve_red.visible = local_redMgr.CheckRedStatus(ModuleType.PAR_ILLU_STAR, this.select_index)
				let local_activeList = outwardmodel.active_illu_list
				if (local_activeList[enum_OutWardType.Partner] && local_activeList[enum_OutWardType.Partner][this.select_index]) {
					let starNum = local_activeList[enum_OutWardType.Partner][this.select_index].star
					// let starCfg = OutWardBaseModel.GetInstance().upStarCfg[enum_OutWardType.Horse + "@" + this.select_index + "@" + starNum]
					// let cost = starCfg && ErlangParser.GetInstance().Parse(starCfg.cost)
					// let is_max = !cost || cost.length == 0

					this.star_group.visible = true
					this.shadow_group.visible = true
					let star
					let star_shaow
					for (let i = 0; i < 5; i++) {
						star = this.star_group.getChildAt(i)
						star_shaow = this.shadow_group.getChildAt(i)
						let star_res
						let star_shaow_res
						let star_stage = Math.floor((starNum - 1) / 5)
						star_stage = star_stage < 0 ? 0 : star_stage
						let star_num = starNum - star_stage * 5
						if (star_stage == 1) {
							star_res = "pet_moon"
							star_shaow_res = "pet_moon_shaow"
						} else if (star_stage == 2) {
							star_res = "pet_son"
							star_shaow_res = "pet_son_shadow"
						} else {
							star_res = "pet_star"
							star_shaow_res = "pet_star_shadow"
						}
						star.visible = i < star_num

						star_shaow.skin = GameResPath.GetIcon("pet",`${star_shaow_res}`)// `pet_json.${star_shaow_res}_png`
						star.skin =  GameResPath.GetIcon("pet",`${star_res}`)//`pet_json.${star_res}_png`
					}
				}
			} else {
				this.resolve_red.visible = false
				this.shadow_group.visible = false
				this.star_group.visible = false
			}
		}
	}
}
window["PartnerIllusionView"]=PartnerIllusionView
