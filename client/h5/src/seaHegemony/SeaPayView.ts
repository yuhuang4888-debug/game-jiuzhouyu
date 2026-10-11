import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SeaPayItem } from "./SeaPayItem"

export class SeaPayView extends BaseView1 {

    InitView
    loop_mgr
    public constructor() {
        super()

        this.base_file = "seaHegemony"
        this.layout_file = "SeaPayView"
        this.layer_value = Enum_UILayer.Activity
        this.preload_server_config = { "config_seacraft_daily_reward": false }
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.load_callback = () => {

            this.InitView()
        }

        this.InitView = () => {
            let rewardCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_daily_reward", false)//Config.Seacraftdailyreward
            let dataList = []
            if (rewardCfg) {
                for (let key in rewardCfg) {

                    // [ts2lua]rewardCfg下标访问可能不正确
                    table.insert(dataList, { cfg : rewardCfg[key] })
                }
            }
            this.loop_mgr = new LoopScrowViewMgr()
            this.loop_mgr.SetData(this.Content, SeaPayItem, dataList, LoopScrCon.Vertical)

            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            this.tipsLb.text = Util.StrToHTML("<font color=0x639c12>每日4点</font>刷新职位信息奖励")
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common", "uisy_023"))
        }
    }

    public DeleteMe() {

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }
        super.DeleteMe()
    }

    bg: Laya.Image
    closeBtn: Laya.Image
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.VBox
    _Image3: Laya.Image
    tipsLb: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.closeBtn,
            this._Image1,
            this._Image2,
            this._Scroller1,
            this.Content,
            this._Image3,
            this.tipsLb,
        ]
            = this.GetChildrenByNames([

                "bg",
                "closeBtn",
                "_Image1",
                "_Image2",
                "_Scroller1",
                "Content",
                "_Image3",
                "tipsLb",
            ])
    }
}
window["SeaPayView"] = SeaPayView