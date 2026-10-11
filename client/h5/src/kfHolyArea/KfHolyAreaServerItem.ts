import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorType, ColorUtil } from "../util/ColorUtil"

export class KfHolyAreaServerItem extends BaseItem1 {
	_img_server: Laya.Image
	_lb_server_name: Laya.Label

	model
	need_refresh_data
	vo

	public constructor(parent?) {
		super(parent)

		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaServerItem"
		this.model = KfHolyAreaModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {


		this.InitEvent()
	}

	public InitEvent() {

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public SetData(vo?) {

		this.vo = vo
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {

		let server_list = this.vo
		if (server_list) {
			if (server_list.length == 0) {
				this._lb_server_name.visible = false
				ResManager.GetInstance().SetImageSprite(this, this._img_server, "kfHolyArea_asset", "uikfsy_020", true)
			} else {
				let server_data = server_list[0]
				this._lb_server_name.visible = true
				if (this.model.IsCampMode()) {
					let main_role_camp = this.model.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)
					let color = main_role_camp == server_data.camp && "#00fa64" || "#fe1a1a"
					this._lb_server_name.text = this.model.GetCampName(server_data.camp)
					this._lb_server_name.color = color
					ResManager.GetInstance().SetImageSprite(this, this._img_server, "kfHolyArea_asset", main_role_camp == server_data.camp && "uikfsy_021" || "uikfsy_022", true)
				} else {
					let main_role_camp = this.model.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)
					let color = main_role_camp == server_data.camp && "#00fa64" || "#fe1a1a"
					this._lb_server_name.text = "【" + server_data.server_num + "】" + server_data.server_name + " "
					this._lb_server_name.color = color
					ResManager.GetInstance().SetImageSprite(this, this._img_server, "kfHolyArea_asset", main_role_camp == server_data.camp && "uikfsy_021" || "uikfsy_022", true)
				}
			}
		}
	}


	public GetComponents() {
		[
			this._img_server,
			this._lb_server_name,
		]
			= this.GetChildrenByNames([

				"_img_server",
				"_lb_server_name",
			])
	}
}
window["KfHolyAreaServerItem"] = KfHolyAreaServerItem