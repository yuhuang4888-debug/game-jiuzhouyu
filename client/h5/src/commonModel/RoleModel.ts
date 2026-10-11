import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { EventDispatcher } from "../util/EventDispatcher"
import { EquipModel } from "./EquipModel"

export enum RoleViewIndex {
	Role = 0,
	Wings = 1,
	Artifact = 2,
	HolyDevice = 3,
	BackOrnament = 4,
	// LightRuling = 4,
	// MagicArr = 6
}
window["RoleViewIndex"] = RoleViewIndex

export class RoleModel extends EventDispatcher {
	outwardmodel
	role_view_is_show
	seleted_first_tab
	static Instance: RoleModel


	public static OPEN_CHOSE_ROLE_VIEW = "OPEN_CHOSE_ROLE_VIEW"
	public constructor() {
		super()

		this.seleted_first_tab = -1
		this.role_view_is_show = false
		//this.outwardmodel = OutWardBaseModel.GetInstance()
	}

	public static GetInstance() {

		if (!RoleModel.Instance) {
			RoleModel.Instance = new RoleModel()
		}
		return RoleModel.Instance
	}

	public GetTabBtnIconRes(index?, select?) {

		if (0 == index) {
			return select && 6 || 7
		} else if (1 == index) {
			return select && 8 || 9
		} else if (2 == index) {
			return select && 10 || 11
		} else if (3 == index) {
			return select && 12 || 13
		} else if ("default" == index) {
			return 6
		}
	}

	//无用
	// 获取人物界面红点状态
	public GetRedIndex() {

		// if (this.UpdateEquipViewRed() ) {
		// 	return 0
		// }
		// if (this.UpdateSkillsViewRed() ) {
		// 	return 1
		// } else if (this.CheckWingsRed() ) {
		// 	return 2
		// } else if (this.CheckHolyDeviceRed() ) {
		// 	return 3
		// } else if (this.CheckArtifactRed() ) {
		// 	return 4
		// } else if (this.CheckLightRulingRed() ) {
		// 	return 5
		// }
		return 0
	}

	//无用
	public UpdateEquipViewRed() {

		// let dot0 = FashionModel.GetInstance().IsShowRed() 
		// || EquipModel.GetInstance().GetAllRedStatusPower() 
		// || RedDotManager.GetInstance().CheckRedStatus(ModuleType.CONSTELLATION) 
		// || attributePotionModel.GetInstance().GetattributePotionRed()
		// || achvModel.GetInstance().ShowRed 
		// || DsgtModel.GetInstance().ShowRedIcon() 
		// || MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL, 1) 
		// || MedalModel.GetInstance().CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1) 
		// || starEquipModel.GetInstance().GetRedDot()

		// return dot0
	}

	//无用
	public UpdateSkillsViewRed() {

		// let dot1 = SkillUIModel.GetInstance().GetInnateRed() 
		// || SkillUIModel.GetInstance().GetSkillRedDot() 
		// || RedDotManager.GetInstance().CheckAnyRedStatus(ModuleType.SKILL_STREN)

		// return dot1
	}

	public CheckWingsRed() {

		// let wings_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.Wings) 
		// || this.outwardmodel.ShowIlluRed(enum_OutWardType.Wings)

		// return wings_red
	}

	//无用
	public CheckHolyDeviceRed() {

		// let holydevice_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.HolyDevice) 
		// || this.outwardmodel.ShowIlluRed(enum_OutWardType.HolyDevice)

		// return holydevice_red
	}

	//无用
	public CheckArtifactRed() {

		// let artifact_red = this.outwardmodel.ShowCultureRed(enum_OutWardType.Artifact) 
		// || this.outwardmodel.ShowIlluRed(enum_OutWardType.Artifact)

		// return artifact_red
	}

	//无用
	public CheckLightRulingRed() {

		// let red = LightRulingModel.GetInstance().CheckRedStatus()
		// return red
	}
}

window["RoleModel"] = RoleModel