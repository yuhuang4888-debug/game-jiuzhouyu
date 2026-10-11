import { UI_MODEL_TYPE } from "../../common/UIModelClass3D"
import { enum_OutWardType } from "../../commonModel/OutWardBaseModel"
import { IllusionBaseView } from "../IllusionBaseView"

export class ArtifactIllusionView extends IllusionBaseView {
	public constructor(parent?) {
		super(parent)

		this._type = enum_OutWardType.Artifact
		this._model_type = UI_MODEL_TYPE.ARTIFACT
	}
}
window["ArtifactIllusionView"]=ArtifactIllusionView
