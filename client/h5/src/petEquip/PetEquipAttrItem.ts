import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { WordManager } from "../common/WordManager";
import { PetEquipModel } from "../commonModel/PetEquipModel";

export class PetEquipAttrItem extends BaseItemRenderer {
    _Group1: Laya.HBox
    _lb_name: Laya.Label
    _lb_val: Laya.Label
    _gp_add: Laya.HBox
    _Image1: Laya.Image
    _lb_add: Laya.Label
    _gp_now: Laya.HBox


    private _model: PetEquipModel;

    public constructor() {
        super()
        this.WIDTH=300
        this.HEIGT=30
        // this.skinName = "resource/game/petEquip/exml/PetEquipAttrItemExml.exml"
        this.base_file = "petEquip"
        this.layout_file = "PetEquipAttrItem"
        this._model = PetEquipModel.GetInstance()
        this.Load()
    }

    public createChildren() {
        super.createChildren()
    }

    public dataChanged() {
        if (!super.dataChanged()) return

        let data = this.data
        let name = WordManager.GetProperties(data[0])
        let value = WordManager.ConvertToPercentValue(data[0], data[1])
        this._lb_name.text = `${name}：`
        this._lb_val.text = value
        this._gp_add.visible = !!data[2]
        this._lb_add.text = data[2] ? WordManager.ConvertToPercentValue(data[0], data[2]) : ""
        if(!!data[2]){
            this._gp_now.x=0
        }else{
            this._gp_now.x=80
        }

    }

    public GetComponents() {
        [
            this._Group1,
            this._lb_name,
            this._lb_val,
            this._gp_add,
            this._Image1,
            this._lb_add,
            this._gp_now
        ]
            = this.GetChildrenByNames([

                "_Group1",
                "_lb_name",
                "_lb_val",
                "_gp_add",
                "_Image1",
                "_lb_add",
                "_gp_now"
            ])
    }
}
window["PetEquipAttrItem"] = PetEquipAttrItem