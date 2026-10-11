import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"

export class BossHelpItem extends BaseItemRenderer {

	public WIDTH = 170
	public HEIGT = 37
	is_set=false
	public constructor(parent) {
		super()


		this.base_file = "suitboss"
		this.layout_file = "BossHelpItem"
		this.load_callback = () => {
			if(!this.is_set){
				this.is_set=true
				this.SetData()
			}
		}
		this.Load()
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public dataChanged() {
		if(!super.dataChanged())return

		if(this.is_loaded){
			this.SetData()
			this.is_set=true
		}else{
			this.is_set=false
		}

	}

	SetData(){
		if (this.data) {
			this._lb_name.text = this.data.player_name
			this._lb_ratio.text = this.data.modulus + "%"
		}
	}


	_lb_name: Laya.Label
	_lb_ratio: Laya.Label
	public GetComponents() {
		[
			this._lb_name,
			this._lb_ratio,
		]
			= this.GetChildrenByNames([

				"_lb_name",
				"_lb_ratio",
			])
	}
}
window["BossHelpItem"] = BossHelpItem