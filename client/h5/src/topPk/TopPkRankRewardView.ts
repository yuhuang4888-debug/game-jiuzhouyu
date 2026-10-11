import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TopPkModel } from "../commonModel/TopPkModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { TopPkRankRewardItem } from "./TopPkRankRewardItem"

export class TopPkRankRewardView extends BaseItem1 {
    Content: Laya.List
    _lb_tips: Laya.HTMLDivElement
    title_bg:Laya.Image
    InitView
    LoadSuccess
    Scr_Scroller1
    _list_item_con
    loop_mgr

    public constructor(parent?) {
        super(parent)


        this.base_file = "topPk"
        this.layout_file = "TopPkRankRewardView"
        let model = TopPkModel.GetInstance()
        this.preload_server_config = {
            "config_top_pk_end_reward": false,
            "config_top_pk_end_reward_local": false
        }
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.title_bg, GameResPath.GetIcon("topPk", "ui_phb_12"))
            //this.RegisterMask(this._list_item_con)
            this.LoadSuccess()
        }

        this.LoadSuccess = () => {
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this._lb_tips.size  = 20
            // }
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
            // 	this._lb_tips.size  = 20
            // }
            this._lb_tips.style.fontSize = 18
            this._lb_tips.style.valign = "center"
            this._lb_tips.style.color = "#d15e00"
            this._lb_tips.width = 500
            this._lb_tips.innerHTML = Util.StrToHTML("排名根据玩家胜点,排名奖励在赛季结束后发放到邮箱")
            if (this.use_delete_method) {
                //lua_resM:DestroyAllReferenceRes(this.hashCode)
                return
            }
            this.InitView()
        }

        this.InitView = () => {
            let list = []
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
            let end_reward_cfg = open_day > 15 && ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_end_reward", false) || ResManager.GetInstance().GetGameConfigFromCache(this, "config_top_pk_end_reward_local", false)
            for (let key in end_reward_cfg) {

                // [ts2lua]end_reward_cfg下标访问可能不正确
                let cfg = end_reward_cfg[key]
                if (cfg) {
                    table.insert(list, cfg)
                }
            }
            table.sort(list, (a?, b?) => {
                return a.min_rank < b.min_rank
            })
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.Content, TopPkRankRewardItem, list, LoopScrCon.Vertical)
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
window["TopPkRankRewardView"] = TopPkRankRewardView