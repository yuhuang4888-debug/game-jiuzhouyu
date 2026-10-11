import { DownDropBtn } from "../common/DownDropBtn"
import { MarriageDropList } from "./MarriageDropList"

export class MarriageDropBtn extends DownDropBtn {
  public constructor(parent) {
    super(parent)
    this.base_file = "marriage"
    this.layout_file = "MarriageDropBtn"
    this._list_class = MarriageDropList
  }

  
  _group: Laya.Box
  _Image1: Laya.Image
  _img_arrow: Laya.Image
  _lb_content: Laya.HTMLDivElement
  public GetComponents() {
    [
      this._group,
      this._Image1,
      this._img_arrow,
      this._lb_content,
    ]
      = this.GetChildrenByNames([

        "_group",
        "_Image1",
        "_img_arrow",
        "_lb_content",
      ])
  }
}
window["MarriageDropBtn"] = MarriageDropBtn