import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { MarriageModel } from "../commonModel/MarriageModel";

export class MarriageTagItem extends BaseItemRenderer {
    // private _lb_tag: eui.Label;

    // private _model: MarriageModel;
    // private _min_width = 86;
    // private _offset_w = 86 - 50;

    // public constructor() {
    //     super()
    //     this.skinName = "resource/game/marriage/exml/MarriageTagItemExml.exml"
    //     this._model = MarriageModel.GetInstance()
    // }

    // // public DeleteMe() {
    // //     super.DeleteMe()
    // // }

    // public createChildren() {
    //     super.createChildren()
    //     this.skin.currentState = null
    // }

    // protected dataChanged() {
    //     // if (!super.dataChanged()) return
    //     let data = this.data
    //     this._lb_tag.text = data.tag_id_name

    //     let old_state = this.skin.currentState
    //     this.skin.currentState = (data.tag_mark && old_state != "down") ? "upAndLight" : "up"
    // }


    // _img_bg: Laya.Image
    // _lb_tag: Laya.Label
    // public GetComponents() {
    //     [
    //         this._img_bg,
    //         this._lb_tag,
    //     ]
    //         = this.GetChildrenByNames([

    //             "_img_bg",
    //             "_lb_tag",
    //         ])
    // }
}
window["MarriageTagItem"] = MarriageTagItem