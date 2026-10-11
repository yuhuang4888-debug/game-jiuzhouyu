import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { MarriageModel, MarriageEvent } from "../commonModel/MarriageModel";
import { Util } from "../util/Util";

export class MarriageTagShowItem extends BaseItemRenderer {
    // private _lb_tag: eui.Label;

    // private _model: MarriageModel;

    // public constructor() {
    //     super()
    //     this.skinName = "resource/game/marriage/exml/MarriageTagShowItemExml.exml"
    //     this._model = MarriageModel.GetInstance()
    // }

    // public DeleteMe() {
    //     super.DeleteMe()
    // }

    // public createChildren() {
    //     super.createChildren()

    //     Util.AddClickEvent(this, () => {
    //         this._model.Fire(MarriageEvent.SUB_TAG, this.data)
    //     }, this, true)
    // }

    // protected dataChanged() {
    //     if (!super.dataChanged()) return
    //     let data = this.data
    //     this._lb_tag.text = data.tag_subid_name
    // }


    // _Image1: Laya.Image
    // _lb_tag: Laya.Label
    // public GetComponents() {
    //     [
    //         this._Image1,
    //         this._lb_tag,
    //     ]
    //         = this.GetChildrenByNames([

    //             "_Image1",
    //             "_lb_tag",
    //         ])
    // }
}
window["MarriageTagShowItem"] = MarriageTagShowItem