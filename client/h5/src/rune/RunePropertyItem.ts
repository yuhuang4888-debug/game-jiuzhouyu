import { BaseItem1 } from "../common/BaseItem1"
import { WordManager } from "../common/WordManager";
import { RuneModel } from "../commonModel/RuneModel";

export class RunePropertyItem extends BaseItem1 {

  data
  model
  needRefresh

  LoadSuccess
  InitEvents
  public constructor(parent?) {
    super(parent)
    this.base_file = "rune"
    this.layout_file = "RunePropertyItem"
    this.model = RuneModel.GetInstance()
    this.load_callback = () => {
      this.LoadSuccess()
      this.InitEvents()
    }

    this.LoadSuccess = () => {


    }
    this.InitEvents = () => {

      if (this.needRefresh) {
        this.SetData(this.data)
        this.needRefresh = false
      }
    }
  }

  public SetData = (data?) => {
    this.data = data
    if (this.is_loaded) {
      this.pro_name.text = WordManager.GetProperties(this.data[0]) + ":"
      this.value.text = WordManager.ConvertToPercentValue(this.data[0], this.data[1])
    } else {
      this.needRefresh = true
    }
  }


  pro_name: Laya.Label
  value: Laya.Label
  public GetComponents() {
    [
      this.pro_name,
      this.value,
    ]
      = this.GetChildrenByNames([

        "pro_name",
        "value",
      ])
  }
}
window["RunePropertyItem"] = RunePropertyItem