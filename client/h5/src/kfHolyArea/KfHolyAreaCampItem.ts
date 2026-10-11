import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util,SetSizeDelta,SetLocalPositionX } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { RoleManager } from "../commonModel/RoleManager"
export class KfHolyAreaCampItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_lb_camp_name: Laya.Label
	_gp_con: Laya.Box
	model
	server_list



	public constructor(parent) {
		super()


		this.base_file = "kfHolyArea"

		this.layout_file = "KfHolyAreaCampItem"

		this.model = KfHolyAreaModel.GetInstance()

	}



	public load_callback() {




		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("kfHolyArea", "uitc_028"))

	}



	public dataChanged() {

		if (super.dataChanged()) {
			this._lb_camp_name.text = this.model.GetCampName(this.data.camp)

			if (!this.server_list) {

				this.server_list = []

			}



			for (let _tmpi in this.server_list) {
				var obj = this.server_list[_tmpi]

				if (obj && obj.visible) {

					obj.visible = false

				}

			}



			let group, img, label, vo, label_obj

			for (let index in this.data.list) {


				group = this.server_list[index]

				if (!group) {

					group = []
					group.obj = new Laya.Box();
					this._gp_con.addChild(group.obj)

					SetSizeDelta(group.obj, 194, 30)


					img = new Laya.Image
					group.obj.addChild(img)
					ResManager.GetInstance().SetImageSprite(this, img.transform.GetComponent("Image"), "kfHolyArea_asset", "uizfz_004", true)





					label_obj = new Laya.Label

					

					label_obj.size = 24

					label_obj.color = ColorUtil.TryParseHtmlString("#675041")

					SetLocalPositionX(label, 30)



					group._lb_server_name = label



					this.server_list[index] = group

				}

				// [ts2lua]this.data.list下标访问可能不正确

				vo = this.data.list[index]

				group._lb_server_name.text = "S" + vo.server_num + "." + vo.server_name

				group.obj.visible = true

				if (vo.server_id == RoleManager.GetInstance().GetMainRoleVo().server_unique_id) {

					group._lb_server_name.color = ColorUtil.TryParseHtmlString("#6ca72d")

				} else {
					group._lb_server_name.color = ColorUtil.TryParseHtmlString("#675041")

				}

			}
		}

	}



	public DeleteMe() {


		this.server_list = null
		super.DeleteMe()
	}






	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._lb_camp_name,
			this._gp_con
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_lb_camp_name",
				"_gp_con"
			])
	}
}
window["KfHolyAreaCampItem"] = KfHolyAreaCampItem