import { BaseItemRenderer } from "../common/BaseItemRenderer";
// import { EquipmentItem } from "../common/EquipmentItem";
// import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel";
// import { Util } from "../util/Util";

export class GodBeastStrenSelectItem extends BaseItemRenderer {
    // private _item: EquipmentItem;
    // private _group_select: eui.Group;
    // private _model: GodBeastModel;
    // // private _select = false;
    // private _event_id;

    // public constructor() {
    //     super()
    //     this.skinName = "resource/game/godBeast/exml/GodBeastSelectItem.exml"
    //     this._model = GodBeastModel.GetInstance()
    //     this.once(egret.Event.REMOVED_FROM_STAGE, this.Clear, this)
    // }

    // protected Clear() {
    //     if (this._event_id) {
    //         this._model.UnBind(this._event_id)
    //         this._event_id = undefined
    //     }
    //     this._item.DeleteMe()
    // }

    // public createChildren() {
    //     super.createChildren()
    //     this.InitEvent()
    //     this._item.is_loaded = true
    //     this._item.load_callback()
    //     this._item.SetItemSize(95, 95)
    //     this._item.SetShowTips(false)
    // }

    // protected dataChanged() {
    //     if (!super.dataChanged()) return
    //     let data = this.data
    //     // if (!data.type_id) return
    //     this._item.SetData(data.type_id)
    //     this._item.SetStrengthen(data.stren)
    //     let select = this.data._select ? true : false
    //     // this._item.SetSelect(select)
    //     this._group_select.visible = select
    // }

    // protected InitEvent() {
    //     Util.AddClickEvent(this, () => {
    //         if (!this.data.type_id) return
    //         let select = this.data._select ? true : false
    //         this.data._select = !select
    //         this._group_select.visible = this.data._select
    //         // this._item.SetSelect(this.data._select)
    //         this._model.Fire(GodBeastEvent.SELECT_STREN_MTRL_ITEM, this.data, this.data._select)
    //     }, this)

    //     // this._event_id = this._model.Bind(GodBeastEvent.SELECT_STREN_ALL_ITEM, (select) => {
    //     //     if (!this.data.type_id) return
    //     //     this._select = select
    //     //     this._item.SetSelect(this._select)
    //     //     this._model.Fire(GodBeastEvent.SELECT_STREN_MTRL_ITEM, this.data, this._select)
    //     // })
    // }
}
window["GodBeastStrenSelectItem"] = GodBeastStrenSelectItem