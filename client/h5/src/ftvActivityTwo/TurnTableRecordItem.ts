import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"

export class TurnTableRecordItem extends BaseItemRenderer {

	WIDTH = 570
	HEIGT = 22
	public constructor() {
		super()
		this.base_file = "turntable"
		this.layout_file = "TurnTableRecordItem"
		this.load_callback = () => {

		}
		this.Load();
	}

	public DeleteMe() {
		super.DeleteMe();
	}

	public dataChanged() {
		if (super.dataChanged()) {
			let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.goods_id)
			if (goods_basic) {
				this._lb.style.fontSize = 18;
				this._lb.style.color = '#774239';
				this._lb.style.letterSpacing = 2;
				this._lb.style.width = 522;
				let is_mask = this.data.role_name == "蒙面人" && this.data.role_id == RoleManager.GetInstance().GetMainRoleId();
				let name = is_mask && "蒙面人(自己)" || this.data.role_name;
				this._lb.innerHTML = Util.StrToHTML("欧气爆发，恭喜" + "<font color='#00B22A'>" + name + "</font>获得了<font color='#FF6600'>" + this.data.n_times + "倍</font>绑玉返利");
			}
		}
	}

	_lb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._lb,
		]
			= this.GetChildrenByNames([

				"_lb",
			])
	}
}
window["TurnTableRecordItem"] = TurnTableRecordItem