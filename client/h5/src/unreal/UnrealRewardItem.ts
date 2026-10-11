import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { UnrealModel } from "../commonModel/UnrealModel"
import { GameResPath } from "../util/GameResPath"

export class UnrealRewardItem extends BaseItemRenderer {
	public WIDTH = 134
	public HEIGT = 38
	
	private model: UnrealModel

	public constructor() {
		super()
		this.base_file = "unreal"
		this.layout_file = "UnrealRewardItem"
		this.model = UnrealModel.GetInstance()
		this.Load()
	}

	public load_callback() {

	}

	protected dataChanged() {
		if (super.dataChanged() && this.data){
			ResManager.GetInstance().SetTexture(this.base_item, this._img_icon, GameResPath.GetGoodsIconPath(this.data.type_id))
			this._Label1.text = String(this.data.count)
		}
	}

	_Image1: Laya.Image
	_img_icon: Laya.Image
	_Label1: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._img_icon,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_icon",
				"_Label1",
			])
	}
}
window["UnrealRewardItem"] = UnrealRewardItem