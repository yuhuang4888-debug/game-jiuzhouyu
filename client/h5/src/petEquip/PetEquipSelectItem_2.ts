import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EquipmentItem } from "../common/EquipmentItem";
import { PetEquipEvent, PetEquipType } from "../commonModel/PetEquipDefine";
import { PetEquipModel } from "../commonModel/PetEquipModel";
import { Util } from "../util/Util";
//支持多选item，对baseitemrender修改
export class PetEquipSelectItem_2 extends BaseItem1 {
	_group_item: Laya.Box
	_img_down: Laya.Image
	_img_up: Laya.Image
	_img_select: Laya.Image
    _img_click : Laya.Image


	private _model: PetEquipModel;
	private _item: EquipmentItem;
	protected _type: PetEquipType;
	private _select = false;
    data
	public constructor(parent) {
		super(parent)
		// this.skinName = "resource/game/petEquip/exml/PetEquipSelectItemExml.exml"
		this.base_file = "petEquip"
		this.layout_file = "PetEquipSelectItem"
		this._model = PetEquipModel.GetInstance()

        this.load_callback=()=>{
            this.InitView()
            this.InitEvent()
        }
	}

	public createChildren() {
		super.createChildren()
		
	}

    public InitEvent(){
        Util.AddClickEvent(this._img_click,()=>{
            // if( this.data._is_select==true){
            //     this.data._is_select=false
            //     this.InitView()
            // }else{
            //     this.data._is_select=true
            //     this.InitView()
            // }
            this._model.Fire(PetEquipEvent.UPDATE_ITEM,this.data)
        },this)
    }
    
    public InitView(){
        if(this.is_loaded){
            if (!this._item) {
                this._item = new EquipmentItem(this._group_item)
				this._item.ChangeCountVisible(false)
                this._item.Load()
                this._item.SetItemSize(87, 87)
                this._item.SetShowTips(false)
            }
            if (this.data && this.data.type_id) {
                let goods_num = null// 不需要显示数量 (this.data.equip_type > 0 && (null) || (this.data.goods_num))
                this._item.SetData(this.data.type_id, goods_num, null, null, null, null, null, null, this.data.goods_id)
                this.SetSelectStatus(this.data._is_select)
            } else {
                this._item.SetData()
                this.SetSelectStatus(false)
            }
            this._img_select.visible = this.data._is_select//this._select
        }
    }
	public DeleteMe() {
		if (this._item) {
			this._item.DeleteMe()
			this._item = undefined
		}
		super.DeleteMe()
	}

	public SetData(data){
        this.data=data
        this.InitView()
    }

	public SetSelectStatus(visible?) {
		this._select = visible	
	}


	public GetComponents() {
		[
			this._group_item,
			this._img_down,
			this._img_up,
			this._img_select,
            this._img_click,
		]
			= this.GetChildrenByNames([

				"_group_item",
				"_img_down",
				"_img_up",
				"_img_select",
                "_img_click"
			])
	}
}
window["PetEquipSelectItem_2"] = PetEquipSelectItem_2