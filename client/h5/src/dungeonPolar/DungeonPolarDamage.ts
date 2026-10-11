import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"

export class DungeonPolarDamage extends BaseItem1 {

	// public WIDTH = 229
	// public HEIGT = 39
	is_need_fresh
	data
	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarDamage"
		this.is_need_fresh = false
		this.load_callback = () => {
			if(this.is_need_fresh){
				this.is_need_fresh=false
				this.dataChanged()
			}
		}

		this.Load()
	}

	public SetData(data){
		this.data=data
		if(!this.is_loaded){
			this.is_need_fresh=true
			return
		}
		this.dataChanged()
	}

	public dataChanged() {
		if(!this.data)return
		this._lb_name.text = this.data.player_name
		this._lb_hurt.text = this.data.modulus + "%"
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_lb_name: Laya.Label
	_lb_hurt: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._lb_name,
			this._lb_hurt,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_name",
				"_lb_hurt",
			])
	}
}
window["DungeonPolarDamage"] = DungeonPolarDamage