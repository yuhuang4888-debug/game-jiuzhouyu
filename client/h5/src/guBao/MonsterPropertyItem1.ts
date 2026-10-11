import { BaseItemRenderer } from '../common/BaseItemRenderer';
import { WordManager } from '../common/WordManager';

export class MonsterPropertyItem1 extends BaseItemRenderer {

  WIDTH = 191;
  HEIGT = 20;

  public constructor() {
    super();

    this.base_file = 'monster';
    this.layout_file = 'MonsterPropertyItem11';

    this.load_callback = () => {
      this.InitEvents();
    };

    this.Load();
  }

  private InitEvents() {

  }


  public dataChanged() {
    if (super.dataChanged()) {
      this.pro_name.text = WordManager.GetProperties(this.data[0]) + ":";
      this.value.text = WordManager.ConvertToPercentValue(this.data[0], this.data[1]);
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
window["MonsterPropertyItem1"] = MonsterPropertyItem1