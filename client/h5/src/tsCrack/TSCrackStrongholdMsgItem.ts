import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GameResPath } from "../util/GameResPath"

export class TSCrackStrongholdMsgItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_lb_value: Laya.Label
	_lb_tips: Laya.Label

	public static width = 613
	public static height = 67
	WIDTH = 538
    HEIGT = 41
	public constructor(parent) {
		super()

		this.base_file = "tsCrack"
		this.layout_file = "TSCrackStrongholdMsgItem"
		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_111"))
		}
		this.Load()
	}

	

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_rank.text = "" + this.data.rank + ""
			if (this.data.server_name) {
				this._lb_name.text = "s" + this.data.server_num + "." + this.data.server_name
				this._lb_value.text = this.data.value
				this._lb_tips.text = "[归属]"
				this._lb_tips.visible = (this.data.server_num == RoleManager.GetInstance().GetMainRoleVo().server_id && TSCrackModel.GetInstance().select_season_id && TSCrackModel.GetInstance().HasOwnership(TSCrackModel.GetInstance().select_season_id))
			} else {
				this._lb_name.text = "s" + this.data.server_num2 + "." + this.data.role_name
				this._lb_value.text = this.data.value2
				this._lb_tips.text = "[当前]"
				this._lb_tips.visible = this.data.is_occupy == 1
			}
		}

	}



	public GetComponents() {
		[
			this._img_bg,
			this._lb_rank,
			this._lb_name,
			this._lb_value,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_rank",
				"_lb_name",
				"_lb_value",
				"_lb_tips",
			])
	}
}
window["TSCrackStrongholdMsgItem"] = TSCrackStrongholdMsgItem