
import { BaseAwardItem } from '../common/BaseAwardItem';
import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { GoodsModel } from '../commonModel/GoodsModel';
import { RoleManager } from '../commonModel/RoleManager';
import { GameResPath } from '../util/GameResPath';
export class CompetelistRankItem extends BaseItemRenderer {
	iconlist
	item_list


	WIDTH = 695
	HEIGT = 80

	public constructor() {
		super()


		this.item_list = []

		this.iconlist = ["a", "b", "c"]

		this.base_file = "competelist"

		this.layout_file = "CompetelistRankItem"


		this.load_callback = () => {

		}
		this.Load();

	}



	public DeleteMe() {
		for (let key in this.item_list) {
			let item = this.item_list[key]
			item.DeleteMe();
		}
		this.item_list = [];

		super.DeleteMe();

	}



	public dataChanged() {
		if (super.dataChanged()) {

			let data = this.data;

			let rankStr = data.rank;

			let nameStr = "虚位以待";

			this._lb_1.text = "需要";
			let scoreStr = data.conf.limit_val;

			let bool_three = data.rank <= 3;

			this._rank_icon.visible = bool_three;

			this._lb_rank.visible = !bool_three;

			if (bool_three) {
				ResManager.GetInstance().SetImageSpriteTrans(this, this._rank_icon, GameResPath.GetIcon('competelist', 'ui_phb_' + (10 + data.rank)));
			}

			if (this.data["data"]) {

				let dd = this.data["data"];

				let is_mask = dd.role_name == "蒙面人"

				let is_change = is_mask && dd.role_id == RoleManager.GetInstance().GetMainRoleId();

				let name = (is_change && ("蒙面人(自己)") || (dd.role_name))

				nameStr = (is_mask && (name) || ("S" + this.data["data"].server_id + "." + name))

				this._lb_1.text = "";
				scoreStr = `${this.data["data"].role_score}`;

			}

			this._lb_rank.text = rankStr;

			this._lb_name.text = nameStr;

			this._lb_integral.text = scoreStr;



			// let index = 0;

			let rewardList = this.data.rewardList
			if (rewardList && rewardList.length > 0) {
				for (let key in rewardList) {
					let reward = rewardList[key];
					let _item: BaseAwardItem = this.item_list[key];
					if (!_item) {
						_item = new BaseAwardItem(this._gp_reward);
						table.insert(this.item_list, _item);
					}
					_item.Load();
					_item.SetScale(0.5);
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
					_item.SetData(type_id, reward[2], lock);
					// if (!_item.GetVisible()) {
					// 	_item.SetVisible(true)
					// }
					// index = index + 1
				}

				// for (let i = rewardList.length + 1; i <= this.item_list.length; i++) {
				// 	let _item = this.item_list[i]
				// 	if (_item.GetVisible()) {
				// 		_item.SetVisible(false)
				// 	}
				// }
			}
		}
	}



	_Image1: Laya.Image
	_rank_icon: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_Scroller1: Laya.Panel
	_gp_reward: Laya.HBox
	_lb_1: Laya.Label
	_lb_integral: Laya.Label
	public GetComponents() {
		[
			this._Image1,
			this._rank_icon,
			this._lb_rank,
			this._lb_name,
			this._Scroller1,
			this._gp_reward,
			this._lb_1,
			this._lb_integral,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_rank_icon",
				"_lb_rank",
				"_lb_name",
				"_Scroller1",
				"_gp_reward",
				"_lb_1",
				"_lb_integral",
			])
		this._Scroller1.hScrollBar.visible = false;
	}
}
window["CompetelistRankItem"] = CompetelistRankItem