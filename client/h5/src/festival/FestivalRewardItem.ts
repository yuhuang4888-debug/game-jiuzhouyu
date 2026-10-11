import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GoodsModel } from "../commonModel/GoodsModel"

export class FestivalRewardItem extends BaseItemRenderer {
	_item


	WIDTH = 80;
	HEIGT = 80;

	public constructor() {
		super();
		this._item = null;
		this.base_file = "festival";
		this.layout_file = "FestivalRewardItem";

		this.load_callback = () => {

			this.LoadSuccess();
		}
		this.Load();

	}

	private LoadSuccess() {
		if (!this._item) {
			this._item = new BaseAwardItem(this.iconBox);
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
			let data = this.data;
			if (!this._item) {
				this._item = new BaseAwardItem(this.iconBox);
			}
			this._item.Load();
			this._item.SetItemSize(80, 80);
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(data[0], data[1]);
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
			if (goods_vo) {
				let num = (data[2] == 1 && (null) || (data[2]));
				this._item.SetData(goods_vo.type_id, num, lock);
			}
		}
	}


	iconBox: Laya.Box
	public GetComponents() {
		[
			this.iconBox,
		]
			= this.GetChildrenByNames([
				"iconBox",
			])
	}
}
window["FestivalRewardItem"] = FestivalRewardItem