import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopPkModel } from "../commonModel/TopPkModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { TopPkLevelRewardItem } from "./TopPkLevelRewardItem"

export class TopPkLevelRewardView extends BaseItem1 {
    
    Content: Laya.List
    _lb_tips: Laya.HTMLDivElement
    title_bg:Laya.Image
    InitEvent
    LoadSuccess
    Scr_Scroller1
    UpdateView
    _list_item_con
    loop_mgr

    public constructor(parent?) {
        super(parent)


        this.base_file = "topPk"
        this.layout_file = "TopPkLevelRewardView"
        let model = TopPkModel.GetInstance()
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIcon("topPk", "ui_phb_12"))
            this.LoadSuccess()
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 	this._lb_tips.size  = 24
            // }
        }

        this.LoadSuccess = () => {
            // let mask = this.GetChild("_Scroller1/_list_item_con").GetComponent("Image")
            // this.RegisterMask(mask)
            this._lb_tips.style.fontSize = 18
            //this._lb_tips.style.valign = "center"
            this._lb_tips.style.color = "#d15e00"
            this._lb_tips.width = 500
            this._lb_tips.innerHTML = Util.StrToHTML("每升一个段位,即可领取段位奖励")
            this.InitEvent()
            this.UpdateView()

        }

        this.InitEvent = () => {
            this.BindVar(model, "level_reward_data", () => {
                this.UpdateView()
            }
            )
        }

        this.UpdateView = () => {
            let list = []
            let level_reward_data = model.level_reward_data
            if (level_reward_data) {
                list = level_reward_data.got_list
            }
            table.sort(list, (a?, b?) => {
                if (a.state == b.state) {
                    return a.rank_lv < b.rank_lv
                } else {
                    return a.state > b.state
                }
            }
            )
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
                this.loop_mgr.SetData(this.Content, TopPkLevelRewardItem, list, LoopScrCon.Vertical)
            } else {
                this.loop_mgr.replaceAll(list)

            }
        }


    }



    public DeleteMe() {

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this.Content,
            this._lb_tips,
            this.title_bg
        ]
            = this.GetChildrenByNames([

                "Content",
                "_lb_tips",
                "title_bg"
            ])
    }
}
window["TopPkLevelRewardView"] = TopPkLevelRewardView