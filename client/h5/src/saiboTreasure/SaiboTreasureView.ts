import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GameResPath } from "../util/GameResPath"
import { SetLocalPosition, SetLocalScale } from "../util/Util"
import "../saiboTreasure/SaiboMainView"

export class SaiboTreasureView extends BaseWindowComponent {

	public constructor() {
		super()


		this.viewClassList = ["SaiboMainView"]
		this.tabStrList = [{ label: "赛博夺宝" }]
		this.money_list = [2, 1, 0]
		this.dependent_res = ['saiboTreasure'];
		this.titleStr = "saiboTreasure.uisbdb_002";
		// this.window_load_back = () => {
		// }
		// this.LoadSuccess();

		// 页签对应的背景图
		// this.bg_list = ['uisbdb_001.jpg'];
		this.is_show_tab = false;

	}


	public LoadSuccess() {
		ResManager.GetInstance().SetImageSpriteTrans(this, this._img_return0, GameResPath.GetIcon('saiboTreasure', 'uisbdb_011'))
		SetLocalScale(this._img_return0, 0.9, 0.9);
		SetLocalPosition(this._img_return0, -10, 15);
	}


	public SetActInfo(info, ...new_args) {
		if (info) {

			let id = CustomActivityModel.GetInstance().getActInstructionId(info.base_type, info.show_id)
			if (id) {
				this.instruction_list = [id]
			}
			this.SetDefaultIndex(0);
			this.SetIndexParameter(0, info);
			// this.LocalSetSelectIndex(0);
		}
	}
}

window['SaiboTreasureView'] = SaiboTreasureView;
