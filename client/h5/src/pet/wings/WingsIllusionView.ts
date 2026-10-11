import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { enum_OutWardType } from "../../commonModel/OutWardBaseModel"
import { IllusionBaseView } from "../IllusionBaseView"

export class WingsIllusionView extends IllusionBaseView {
	public constructor(parent?) {
		super(parent)

		this._type = enum_OutWardType.Wings
		this._model_type = UI_MODEL_TYPE.WING
	}

}
window["WingsIllusionView"]=WingsIllusionView