import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { FashionModel } from "../commonModel/FashionModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

//-@class FashionColorItem
export class FashionColorItem extends BaseItem1 {
	
	info
	model:FashionModel

	public constructor(parent) {
		super(parent)

		this.base_file = "fashion"
		this.layout_file = "FashionColorItem"
		this.layer_value = Enum_UILayer.UI
		this.model = FashionModel.GetInstance()
		this.load_callback = () => {
			this.InitEvent()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.bg, () => {
			this.model.Fire(FashionModel.SELECTCOLOR, this.info.pos, this.info.color_id)
		}, this, false)

		this.BindEvent(this.model, FashionModel.SELECTCOLOR, (pos_id?, color_id?) => {
			if (pos_id && this.info && this.info.pos == pos_id) {
				if (this.info.color_id == color_id) {
					this.select.visible = true
				} else {
					this.select.visible = false
				}
			}
		})
	}

	public InitView() {
		if (!this.info) { return }
		this.select.visible = this.info.is_select
		
		this.lock.visible

		let career = RoleManager.GetInstance().GetMainRoleCareer()
		let sex = RoleManager.GetInstance().GetMainRoleSex()
		let key = `${this.info.pos}@${this.info.fashion_id}@${career}@${sex}@${this.info.color_id}`
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_model[key]
		this.bg.skin = GameResPath.GetIcon("fashion", `color_${cfg.show_color}`)

		let red, color_id = this.info.color_id

		let is_active = false
		if(this.info.fashion_info){
			for(let vo of this.info.fashion_info.color_list){
				if(vo.color_id == color_id && vo.fashion_star_lv > 0){
					is_active = true
				}
			}
		}
		this.lock.visible = !is_active

		if (color_id == 0) {
			red = this.model.GetBaseRed(this.info.pos, this.info.fashion_id)
		} else {
			red = this.model.GetColorRed(this.info.pos, this.info.fashion_id, this.info.color_id)
		}
		this.red.visible = red
	}

	public SetData(data?) {
		this.info = data
		this.InitView()
	}


	bg: Laya.Image
	select: Laya.Image
	red: Laya.Image
	lock: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.select,
			this.red,
			this.lock
		]
			= this.GetChildrenByNames([

				"bg",
				"select",
				"red",
				"lock"
			])
	}
}
window["FashionColorItem"] = FashionColorItem