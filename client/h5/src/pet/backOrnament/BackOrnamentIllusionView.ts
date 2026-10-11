import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { enum_OutWardType } from "../../commonModel/OutWardBaseModel"
import { IllusionBaseView } from "../IllusionBaseView"

export class BackOrnamentIllusionView extends IllusionBaseView {
	public constructor(parent?) {
		super(parent)

		this._type = enum_OutWardType.BackOrnament
		this._model_type = UI_MODEL_TYPE.BACKORNAMENT
	}

}
window["BackOrnamentIllusionView"]=BackOrnamentIllusionView