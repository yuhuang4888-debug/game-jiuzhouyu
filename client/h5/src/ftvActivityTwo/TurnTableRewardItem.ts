
import { BaseAwardItem } from '../common/BaseAwardItem';
import { ResManager } from '../common/ResManager';
import { TurnTableModel, TurnTableModelEvent } from '../commonModel/TurnTableModel';
import { SetAnchoredPositionX } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
export class TurnTableRewardItem extends BaseItem1 {

	_goods_id
	_goods_num
	_model

	private _item: BaseAwardItem;

	public constructor(parent?) {
		super(parent)
		this.base_file = "turntable"
		this.layout_file = "TurnTableRewardItem"
		this._model = TurnTableModel.GetInstance()
		this.load_callback = () => {
			this.InitEvent();
			this.LoadSuccess();
		}
	}

	public InitEvent() {
		this.BindEvent(TurnTableModel.GetInstance(), TurnTableModelEvent.TURN_BIG_DOWN, (rotation?) => {
			this.setRotation(rotation);
		});
	}

	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe();
			this._item = null;
		}
		super.DeleteMe();
	}

	public setData(goods_id: number, goods_num: number) {
		this._goods_num = goods_num;
		this._goods_id = goods_id;
		if (this.is_loaded) {
			this.initView();
		}
	}

	public LoadSuccess() {
		if (this._goods_num && this._goods_id) {
			this.initView();
		}
	}

	public initView() {
		//this._lb_num.text = this._goods_num
		let x = Number(this._goods_num) > 98 && 8 || 20;
		ResManager.GetInstance().SetImageSprite(this, this.num_img, "turntable", this._goods_num, true);
		
		if (!this._item) {
			this._item = new BaseAwardItem(this._gp_show);
		}
		this._item.SetData(this._goods_id);
		this._item.SetItemSize(85, 85);
		this._item.Load();

		//let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this._goods_id)
		//if (goods_basic ) {
		//lua_resM:SetOutsideImageSprite(this, this._img, "client/assets/icon/goodsIcon/" + goods_basic.goods_icon + ".png")
		//}
	}

	public setRotation(rotation: number) {
		// if (this.is_loaded) {
			// this._gp_show.rotation = rotation;
			// this.num_img.rotation = rotation;
		// }
	}



	num_img: Laya.Image;
	_gp_show: Laya.Box;
	public GetComponents() {
		[
			this.num_img,
			this._gp_show,
		]
			= this.GetChildrenByNames([

				"num_img",
				"_gp_show",
			])
	}
}
window["TurnTableRewardItem"] = TurnTableRewardItem