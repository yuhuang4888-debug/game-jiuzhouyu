
import { BaseItemRenderer } from "../common/BaseItemRenderer";

export class FairyWishAttrItem extends BaseItemRenderer {
    WIDTH = 240
	HEIGT = 33



    _Group1: Laya.Box
    _lb_attr_name: Laya.Label
    _lb_attr_value: Laya.Label
    public constructor() {
        super();
        this.base_file = 'fairyWish';
        this.layout_file = 'FairyWishAttrItem';
        this.Load()
    }
    public createChildren() {
		super.createChildren()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_attr_name.text = this.data.attr + ":"
			this._lb_attr_value.text = this.data.value.toString()
		}
	}
    public GetComponents() {
        [
            this._Group1,
            this._lb_attr_name,
            this._lb_attr_value,
        ]
            = this.GetChildrenByNames([

                "_Group1",
                "_lb_attr_name",
                "_lb_attr_value",
            ])
    }
}
window["FairyWishAttrItem"] = FairyWishAttrItem