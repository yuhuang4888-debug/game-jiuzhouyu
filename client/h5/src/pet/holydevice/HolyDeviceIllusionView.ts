import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { enum_OutWardType } from "../../commonModel/OutWardBaseModel"
import { IllusionBaseView } from "../IllusionBaseView"

export class HolyDeviceIllusionView extends IllusionBaseView {
	public constructor(parent?) {
		super(parent)

		this._type = enum_OutWardType.HolyDevice
		this._model_type = UI_MODEL_TYPE.WEAPON
	}

}
window["HolyDeviceIllusionView"]=HolyDeviceIllusionView