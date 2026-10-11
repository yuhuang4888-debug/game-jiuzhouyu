import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { MarriageModel } from "../commonModel/MarriageModel";

export class MarriageTagSubItem extends BaseItemRenderer {
    // private _lb_tag: eui.Label;
    // private _img_bg: eui.Image;

    // private _model: MarriageModel;
    // private _min_width = 86;
    // private _offset_w = 86 - 60;

    // public constructor() {
    //     super()
    //     this.skinName = "resource/game/marriage/exml/MarriageTagSubItemExml.exml"
    //     this._model = MarriageModel.GetInstance()
    // }

    // public DeleteMe() {
    //     super.DeleteMe()
    // }

    // public createChildren() {
    //     super.createChildren()
    // }

    // protected dataChanged() {
    //     if (!super.dataChanged()) return
    //     let data = this.data
    //     this._lb_tag.text = data.tag_subid_name
    //     this._lb_tag.validateNow()
    //     this._img_bg.width = Math.max(this._offset_w + this._lb_tag.textWidth, this._min_width)

    //     let path = data.tag_mark ? "marriage_json.uijh_096_png" : "marriage_json.uijh_097_png"
    //     this._img_bg.source = path
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
window["MarriageTagSubItem"] = MarriageTagSubItem