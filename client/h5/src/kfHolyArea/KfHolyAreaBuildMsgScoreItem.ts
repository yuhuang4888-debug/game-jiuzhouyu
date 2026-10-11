import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Util, SetSizeDeltaX } from "../util/Util"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
export class KfHolyAreaBuildMsgScoreItem extends BaseItemRenderer {
	_lb_server_desc: Laya.Label
	_Group1: Laya.Box
	_Image1: Laya.Image
	_img_progress: Laya.Image
	_lb_score: Laya.Label
	model

	public static width = 550
	public static height = 30
	WIDTH = 550
	HEIGT = 30
	public static ProgressWidth = 300
	public constructor(parent) {
		super()

		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaBuildMsgScoreItem"
		this.model = KfHolyAreaModel.GetInstance()
		this.Load()
	}

	public load_callback() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath("kfHolyArea", "uikfsy_004"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_progress, GameResPath.GetIconOtherPath("kfHolyArea", "uikfsy_005"))

	}

	public dataChanged() {
		if (super.dataChanged()) {
			let data = this.data.vo
			if (this.model.IsCampMode()) {
				this._lb_server_desc.text = this.model.GetCampName(data.camp)
			} else {
				let server_list = this.model.GetCampServerList(data.camp)
				let server_data = server_list[0]
				if (server_data) {
					let main_role_camp = this.model.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)

					this._lb_server_desc.text = "S" + server_data.server_num + "." + server_data.server_name
					this._lb_server_desc.color = main_role_camp == server_data.camp ? "#0a953e" : "#fe1a1a"
				}
			}
			this._lb_score.text = data.score + "/" + this.data.total_score
			SetSizeDeltaX(this._img_progress, data.score / this.data.total_score * KfHolyAreaBuildMsgScoreItem.ProgressWidth)
		}

	}


	public GetComponents() {
		[
			this._lb_server_desc,
			this._Group1,
			this._Image1,
			this._img_progress,
			this._lb_score,
		]
			= this.GetChildrenByNames([

				"_lb_server_desc",
				"_Group1",
				"_Image1",
				"_img_progress",
				"_lb_score",
			])
	}
}
window["KfHolyAreaBuildMsgScoreItem"] = KfHolyAreaBuildMsgScoreItem