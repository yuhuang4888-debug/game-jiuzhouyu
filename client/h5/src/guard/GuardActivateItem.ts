import { BaseItem1 } from "../common/BaseItem1"
import { Vector2 } from "../util/Vector2"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export class GuardActivateItem extends BaseItem1 {
	guard_model
	guard_type
	cfg_kv

	public constructor(parent?) {
		super(parent)
		this.base_file = "guard"
		this.layout_file = "GuardActivateItem"
		this.preload_server_config = {
			"config_magic_circle_key_value": false
		}

		this.load_callback = () => {
			this.cfg_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_magic_circle_key_value", false)
		}
	}

	public InitView() {
		this.lb_desc.text = (this.guard_type == 1 && ("恶灵退治，挂机必备") || ("战力成吨提升!打架必备守护!"))
		let source = (this.guard_type == 1 && ("uimfz_027") || ("uimfz_025"))
		ResManager.GetInstance().SetImageSprite(this, this.img_attrName, "guard", source, true)
		source = (this.guard_type == 1 && ("uimfz_50") || ("uimfz_15"))
		ResManager.GetInstance().SetImageSprite(this, this.img_num, "guard", source, true)
		this.ShowModel()
	}

	public ShowModel() {
		this.ClearModel()
		let cfg_kv = this.cfg_kv
		let scale_value = 1
		let y = 1
		if(this.guard_type == 1){
			scale_value = 2.5
		} else if (this.guard_type == 2){
			scale_value = 2
		} else if (this.guard_type == 3){
			scale_value = 2
		} else if (this.guard_type == 4){
			scale_value = 2
		}
		if (cfg_kv) {
			let id = (this.guard_type == 1 && (cfg_kv.high_magic_circle_id.value) || (cfg_kv.low_magic_circle_id.value))
			//let y = (this.guard_type == 1 && (-233) || (-130))
			let data = {
				res_id: id,
				clothe_res_id: id,
				type: UI_MODEL_TYPE.GUARD,
				can_rotate: true,
				layer_value: Enum_UILayer.Activity,
				scale : scale_value,
				position: new Vector2(0, y),
				//rotate = pos_cfg.rotate,
				texture_size: new Vector2(160, 147),
				//action_name_list = action_list,
			}
			ResManager.GetInstance().SetRoleModel(this, this.gp_model, data)
		}
	}

	public ClearModel() {
		if (this.guard_model) {
			this.guard_model.DeleteMe()
			this.guard_model = null
		}
	}

	public SetData(type?) {
		this.guard_type = type
		this.InitView()
	}

	public DeleteMe() {
		this.ClearModel()
		super.DeleteMe()
	}

	lb_desc: Laya.Label
	img_attrName: Laya.Image
	img_num: Laya.Image
	gp_model: Laya.Box
	img_arr: Laya.Image
	public GetComponents() {
		[
			this.lb_desc,
			this.img_attrName,
			this.img_num,
			this.gp_model,
			this.img_arr,
		]
			= this.GetChildrenByNames([
				"lb_desc",
				"img_attrName",
				"img_num",
				"gp_model",
				"img_arr",
			])
	}
}
window["GuardActivateItem"] = GuardActivateItem