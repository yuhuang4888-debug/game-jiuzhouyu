import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { MonsterModel } from "../commonModel/MonsterModel";
import { MonsterPropertyItem } from "./MonsterPropertyItem";

export class MonsterPropertyView extends BaseView1 {
  public static readonly _layout_file: string = 'MonsterPropertyView';
  private loop_mgr: LoopScrowViewMgr;

  private get monsterModel() {
    return MonsterModel.GetInstance();
  }

  public constructor() {
    super()

    this.base_file = "monster";
    this.layout_file = "MonsterPropertyView";
    this.layer_value = Enum_UILayer.Activity;
    this.destroy_imm = true;
    this.use_background = true;
    this.click_bg_toClose = true;
    this.is_center = true;
    this.back_login_toClose = true;

    this.load_callback = () => {
      this.LoadSuccess()
      this.InitEvent()
    }


  }

  private LoadSuccess() {
    this.RenderView();
  }

  private InitEvent() {

  }

  private RenderView() {
    let attrs = this.monsterModel.GetCurSoapAttrs();

    this.attrsList.visible = attrs.length > 0;
    this.none_conta.visible = attrs.length <= 0;

    if (!this.loop_mgr) {
      this.loop_mgr = new LoopScrowViewMgr();
      this.loop_mgr.SetData(
        this.attrsList,
        MonsterPropertyItem,
        attrs,
        LoopScrCon.Vertical,
      );
    } else {
      this.loop_mgr.replaceAll(attrs);
    }
  }

  public DeleteMe() {

    if (this.loop_mgr) {
      this.loop_mgr.DeleteMe();
      this.loop_mgr = null;
    }

    super.DeleteMe();
  }

  public Open(...new_args) {
    super.Open();
  }

  property_bg: Laya.Image
  property_title: Laya.Label
  _Image1: Laya.Image
  attrsList: Laya.List
  none_conta: Laya.Box
  tips: Laya.Label
  tips_icon: Laya.Image
  public GetComponents() {
    [
      this.property_bg,
      this.property_title,
      this._Image1,
      this.attrsList,
      this.none_conta,
      this.tips,
      this.tips_icon,
    ]
      = this.GetChildrenByNames([

        "property_bg",
        "property_title",
        "_Image1",
        "attrsList",
        "none_conta",
        "tips",
        "tips_icon",
      ])
  }
}
window["MonsterPropertyView"] = MonsterPropertyView