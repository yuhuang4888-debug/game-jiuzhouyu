import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { ResManager } from "../common/ResManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";

export class RuneAwakenItem extends BaseItemRenderer {
	public static _WIDTH = 158
	public static _HEIGT = 185
	public WIDTH = 158
	public HEIGT = 185


	private _item: EquipmentItem;
	private isBag = false;

	_model:RuneModel
	res_mgr:ResManager
	goods_model:GoodsModel
	public constructor() {
		super();
		this.base_file = "rune"
		this.layout_file = `RuneAwakenItem`
		this._model = RuneModel.GetInstance();
		this.res_mgr = ResManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		
		this.Load()

	}

	public createChildren(){

		super.createChildren();
	}

	public load_callback(){
		this.BindEvent(this._model, RuneEvent.RUNE_AWAKEN_RETURN, (goods_id) => {
			if (this.data && this.data.goods_id == goods_id) {
				this._img_awaken.visible = true;
				this.setRedDot();
			}
		});
	}

	public DeleteMe(){
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		super.DeleteMe();
	}


	public dataChanged(){
		if (super.dataChanged() && this.data) {
			let info = this.data;
			this._img_wear.visible = !info.subtype;
			let lv = info.level ? info.level : info.lv;
			this.isBag = info.subtype != undefined;
			if (!this.isBag) {
				let goos_vo = this.goods_model.GetGoodsBasicByTypeId(info.goods_type_id);
				if (goos_vo)
					info = goos_vo;
			};
			this._lb_name.text = `${info.goods_name}`;
			if (!this._item){
				this._item = new EquipmentItem(this._group_item)
				this._item.SetItemSize(85, 85);
				this._item.Load()
			}
			this._item.SetShowTips(false)
			this._item.SetData(info.type_id);
			// this._item.SetStrengthen(lv);
			this.setAwakenImg();
			this.setRedDot();
			this.img1.visible = this.data.goods_id != this._model.awake_select_goods_id
			this.select_bg.visible = this.data.goods_id == this._model.awake_select_goods_id

		}
	}

	public setAwakenImg(){
		let awaken = false
		let awakenList = this.data.attr_list ? this.data.attr_list : this.data.awake_list;
		for (let key in awakenList) {
			let _info = awakenList[key];
			if (_info.awake_lv > 0) {
				awaken = true;
				break;
			}
		}
		this._img_awaken.visible = awaken;
	}

	public setRedDot(){
		let runeExpCfg = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_rune_wake_up_exp", false);
		let runeLvCfg = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_rune_wake_up_lv", false);
		let rune_attr_num_cfg = this.res_mgr.GetGameConfigFromCache(this.base_item, "config_rune_wake_up", false);
		let flag = !this.isBag && this._model.RuneCanAwake(this.data, rune_attr_num_cfg, runeExpCfg, runeLvCfg);
		this._red.visible = flag;
	}
	

	con: Laya.Box
	img1: Laya.Image
	select_bg: Laya.Image
	_group_item: Laya.Box
	_lb_name: Laya.Label
	_img_wear: Laya.Image
	_img_awaken: Laya.Image
	_red: Laya.Image
	public GetComponents() {
		[
			this.con,
			this.img1,
			this.select_bg,
			this._group_item,
			this._lb_name,
			this._img_wear,
			this._img_awaken,
			this._red,
		]
			= this.GetChildrenByNames([

				"con",
				"img1",
				"select_bg",
				"_group_item",
				"_lb_name",
				"_img_wear",
				"_img_awaken",
				"_red",
			])
	}
}
window["RuneAwakenItem"] = RuneAwakenItem