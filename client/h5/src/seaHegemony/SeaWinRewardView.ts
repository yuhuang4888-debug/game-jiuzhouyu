import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class SeaWinRewardView extends BaseView1 {
  InitView
  dataGp
  data
  public constructor() {
    super()
    this.base_file = "seaHegemony"
    this.layout_file = "SeaWinRewardView"
    this.layer_value = Enum_UILayer.Activity
    this.use_background = true
    this.is_center = true
    this.click_bg_toClose = true
    this.preload_server_config = {"config_seacraft_win_reward":false}
    this.load_callback = () => {
      this.InitView()
    }

    this.InitView = () => {
      let dataList = []
      let winCount = 0
      let cfg = this.preload_server_config.config_seacraft_win_reward
      if (cfg) {
        for (let key in cfg) {

          // [ts2lua]cfg下标访问可能不正确
          table.insert(dataList, cfg[key])
        }
      }
      // let dataArr = eui.new ArrayCollection(dataList)
      // this.dataGp.itemRenderer = SeaWinRewardItem
      // this.dataGp.dataProvider = dataArr
      Util.AddClickEvent(this.closeBtn, () => {
        this.Close()
      }
        , this, true)
      let kingData = SeaHegemonyModel.GetInstance().seaKingData
      if (kingData) {
        this.timeLb.text = "当前连续夺得海域霸主次数：" + kingData.times
      }
      ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common", "uisy_023"))

      // Util.AddClickEvent(this.disBtn, () => {
      //   SeaHegemonyModel.GetInstance().Fire(SeaHegemonyModel.OPEN_VIEW, "SeaDistributionView")
      // }
      //   , this, true)
    }


  }


  public SetLbGetReward() {

    let kingData = SeaHegemonyModel.GetInstance().seaKingData
    let min = this.data.min
    if (kingData) {
     // this.unLb.visible = min > kingData.times
      let hasDis = null
      if (min <= kingData.times) {
        for (let _tmpi in kingData.win_reward_status) {
          var vo = kingData.win_reward_status[_tmpi]
          if (vo.times == min && vo.status == 2) {
            hasDis = true
          }
        }
      }
      // Util.SetImageGray(this.disBtn, hasDis)
      // // [ts2lua]lua中0和空字符串也是true，此处hasDis需要确认
      // this.disBtn.label = (hasDis && ("已分配") || ("可分配"))
      // this.disBtn.visible = min <= kingData.times
    }
    // [ts2lua]lua中0和空字符串也是true，此处min == this.data.max需要确认
    let str = (min == this.data.max && (min) || (min + "~" + this.data.max))
    this.timeLb.text = Util.StrToHTML("连续夺得海域霸主<font color=0x639c12>" + str + "</font>次")
    return ErlangParser.GetInstance().parse(this.data.reward)
  }

  bg: Laya.Image
  closeBtn: Laya.Image
  _Image1: Laya.Image
  _Image2: Laya.Image
  _Image3: Laya.Image
  _Scroller1: Laya.Panel
  Content: Laya.VBox
  timeLb: Laya.Label
  public GetComponents() {
    [
      this.bg,
      this.closeBtn,
      this._Image1,
      this._Image2,
      this._Image3,
      this._Scroller1,
      this.Content,
      this.timeLb,
    ]
      = this.GetChildrenByNames([

        "bg",
        "closeBtn",
        "_Image1",
        "_Image2",
        "_Image3",
        "_Scroller1",
        "Content",
        "timeLb",
      ])
  }
}
window["SeaWinRewardView"] = SeaWinRewardView