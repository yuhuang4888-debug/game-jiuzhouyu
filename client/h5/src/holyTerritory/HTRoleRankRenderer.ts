
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
export class HTRoleRankRenderer extends BaseItemRenderer {


	public static width = 660
	public static height = 42
	public WIDTH = 660
	public HEIGT = 42
	is_set = false
	public constructor(parent) {
		super()

		this.base_file = "holyTerritory"
		this.layout_file = "HTRoleRankRenderer"
		this.load_callback = () => {
			if (!this.is_set) {
				this.is_set = true
				this.SetData()
			}
		}
		this.Load()
	}

	SetData() {
		if (this.data) {
			this.rankLabel.text = this.data.rank
			this.nameLabel.text = this.data.role_name
			this.fightLabel.text = this.data.power
			let dsgt_cfg = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_dsgt", false)
			let dsgt = dsgt_cfg[this.data.desination]
			// [ts2lua]lua中0和空字符串也是true，此处dsgt && this.data.desination需要确认
			this.dsgtLabel.text = (dsgt && this.data.desination && (dsgt.name) || ("未获得称号"))
		}
	}

	public dataChanged() {
		if (super.dataChanged()) {
			if (this.is_loaded) {
				this.SetData()
				this.is_set = true
			} else {
				this.is_set = false
			}
		}
	}


	public DeleteMe() {
		super.DeleteMe()
	}

	_Group1: Laya.Box
	_Image1: Laya.Image
	rankLabel: Laya.Label
	nameLabel: Laya.Label
	fightLabel: Laya.Label
	dsgtLabel: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this._Image1,
			this.rankLabel,
			this.nameLabel,
			this.fightLabel,
			this.dsgtLabel,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_Image1",
				"rankLabel",
				"nameLabel",
				"fightLabel",
				"dsgtLabel",
			])
	}
}
window["HTRoleRankRenderer"] = HTRoleRankRenderer