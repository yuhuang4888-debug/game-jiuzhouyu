import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"

export class CompetelistRewaedItem extends BaseItemRenderer {
	_item


	WIDTH = 80;
	HEIGT = 80;

	public constructor() {
		super();
		this._item = null;
		this.base_file = "competelist";
		this.layout_file = "CompetelistRewaedItem";

		this.load_callback = () => {
			
			this.LoadSuccess();
		}
		this.Load();

	}

	private LoadSuccess() {
		if (!this._item) {
			this._item = new BaseAwardItem(this._gp_item);
			this._item.Load();
			this._item.SetItemSize(80, 80);
		}

	}


	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe();
			this._item = null;
		}
		super.DeleteMe();
	}



	public dataChanged() {
		if (super.dataChanged()) {
			let reward = JSON.parse(this.data.reward)[0];
			if (!this._item) {
				this._item = new BaseAwardItem(this._gp_item);
			}
			this._item.Load();
			this._item.SetItemSize(80, 80);
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1]);
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				let num = (reward[2] == 1 && (null) || (reward[2]));
				this._item.SetData(goods_vo.type_id, num, lock);
			}
		}
	}


	_gp_item: Laya.Box
	public GetComponents() {
		[
			this._gp_item,
		]
			= this.GetChildrenByNames([
				"_gp_item",
			])
	}
}
window["CompetelistRewaedItem"] = CompetelistRewaedItem