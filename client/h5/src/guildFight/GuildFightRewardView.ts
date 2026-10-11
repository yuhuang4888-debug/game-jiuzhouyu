import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GuildFightModel } from "../commonModel/GuildFightModel"
import { Util } from "../util/Util"
import { GuildFightRewardItem } from "./GuildFightRewardItem"

export class GuildFightRewardView extends BaseView1 {
    DesFunc
    InitItem
    InitView
    Open
    Scr_Scroller1
    click_bg_toClose
    destroy_callback
    destroy_imm
    is_center
    preload_server_config
    use_background

    public constructor() {
        super()

        let rewardList_ = null
        let key_ = null
        this.base_file = "guildFight"
        this.layout_file = "GuildFightRewardView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.is_center = true
        this.click_bg_toClose = true
        this.load_callback = () => {

            this.InitView()
        }

        this.preload_server_config = {"config_terri_war_battle_reward" : false}
        this.destroy_callback = () => {
            this.DesFunc()
        }

        this.Open = (id?) => {
            if (id) {
                let mode_num = GuildFightModel.GetInstance().serInfo && GuildFightModel.GetInstance().serInfo.mode_num || 1
                key_ = id + "@" + mode_num
                this.InitItem()
            }
            super.Open()
        }

        this.InitView = () => {
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            this.InitItem()
        }

        this.InitItem = () => {
            if (!this.is_loaded || !key_) {
                return
            }
            if (!rewardList_) {
                rewardList_ = []
            }
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_terri_war_battle_reward",false)//Config.Terriwarbattlereward
            // [ts2lua]cfg下标访问可能不正确
            if (cfg && cfg[key_]) {
                // [ts2lua]cfg下标访问可能不正确
                let rewarCfg = cfg[key_]
                if (rewarCfg) {
                    let i = 0
                    do {
                        let item = rewardList_[i]
                        if (!item) {
                            // [ts2lua]lua中0和空字符串也是true，此处i == 0需要确认
                            item = new GuildFightRewardItem(this.Content)
                            item.SetCfg(i, (i == 0 && (rewarCfg.win_reward) || (rewarCfg.fail_reward)))
                            item.Load()
                            rewardList_[i] = item
                        }
                        i = i + 1
                    } while ((i < 2)
                    )
                }
            }
        }

        this.DesFunc = () => {
            if (rewardList_) {
                for (let _tmpi in rewardList_) {
                    var vo = rewardList_[_tmpi]
                    vo.DeleteMe()
                }
                rewardList_ = null
            }
            key_ = null
        }
    }


    public DeleteMe(){
        super.DeleteMe()
    }


_Image1:Laya.Image
_Image2_title:Laya.Image
_lb_win_name:Laya.Label
closeBtn:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.VBox
public GetComponents() {
[
this._Image1,
this._Image2_title,
this._lb_win_name,
this.closeBtn,
this._Scroller1,
this.Content,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2_title",
"_lb_win_name",
"closeBtn",
"_Scroller1",
"Content",
])
}
}
 window["GuildFightRewardView"]= GuildFightRewardView