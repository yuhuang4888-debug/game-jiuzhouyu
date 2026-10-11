import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopPkModel } from "../commonModel/TopPkModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { TopPkDailyRewardItem } from "./TopPkDailyRewardItem"

export class TopPkDailyRewardView extends BaseItem1 {
    Content: Laya.List
    _lb_tips: Laya.HTMLDivElement
    title_bg:Laya.Image
    Scr_Scroller1
    _list_item_con
    loop_mgr
    model

    public constructor(parent?) {
        super(parent)


        this.base_file = "topPk"
        this.layout_file = "TopPkDailyRewardView"
        this.model = TopPkModel.GetInstance()
        this.preload_server_config = {
            "config_top_pk_rank_reward": false
        }
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIcon("topPk", "ui_phb_12"))
            //this.RegisterMask(this._list_item_con)
            this.LoadSuccess()
        }

    }

    public LoadSuccess() {

        // if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
        //     this._lb_tips.size = 20
        // }
        this._lb_tips.style.fontSize = 18
        this._lb_tips.style.valign = "center"
        this._lb_tips.style.color = "#d15e00"
        this._lb_tips.width = 500

        this._lb_tips.innerHTML = Util.StrToHTML("每升一个段位,能提高每日奖励")
        this.UpdateView()
    }

    public UpdateView() {

        let list = []
        let daily_reward_data = this.model.daily_reward_data
        let level_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_rank_reward", false)
        let index = 0
        let find_index = false
        for (let key in level_cfgs) {

            // [ts2lua]level_cfgs下标访问可能不正确
            let level_cfg = level_cfgs[key]
            if (level_cfg) {
                table.insert(list, level_cfg)
                if (!find_index) {
                    if (level_cfg.rank_lv == daily_reward_data.yesterday_rank_lv) {
                        find_index = true
                    } else {
                        index = index + 1
                    }
                }
            }
        }
        table.sort(list, (a?, b?) => {
            return a.rank_lv < b.rank_lv
        })
        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr()
            this.loop_mgr.SetData(this.Content, TopPkDailyRewardItem, list, LoopScrCon.Vertical)
        } else {
            this.loop_mgr.replaceAll(list)
        }
        index = 0
        for (let i = 0; i < list.length; i++) {
            let data = list[i]
            let daily_reward_data = this.model.daily_reward_data
            if (daily_reward_data) {
                if (data.rank_lv == daily_reward_data.yesterday_rank_lv && daily_reward_data.honor_is_got == 1) {
                    index = i
                    break
                }
            }
        }
        this.loop_mgr.FirstOnChild(index)
        //let layout = this._list_item_con.layout
        //let height = this._list_item_con.contentHeight - this._list_item_con.numElements - 1 * layout.gap / this._list_item_con.numElements
        //this._list_item_con.scrollV = Clamp(0, this._list_item_con.contentHeight - this._list_item_con.height, height + layout.gap * Number(index))
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
window["TopPkDailyRewardView"] = TopPkDailyRewardView