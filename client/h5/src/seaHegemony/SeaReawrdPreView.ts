import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { SeaGuildRewardItem } from "./SeaGuildRewardItem"
import { SeaReawrdPreTab } from "./SeaReawrdPreTab"
import { SeaRewardRankItem } from "./SeaRewardRankItem"

export class SeaReawrdPreView extends BaseView1 {

    type
    tabList
    SelectView
    guild_reward_list
    sea_reward_list
    InitView
    Local_Open
    selectIndex
    rankData
    guildData
    public constructor() {
        super()

        this.type = 1
        this.base_file = "seaHegemony"
        this.layout_file = "SeaReawrdPreView"
        this.preload_server_config = { "config_seacraft_reward": false, "config_seacraft_rank_reward": false }
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.destroy_imm = true
        this.load_callback = () => {
            this.InitView()
            Util.AddClickEvent(this.closeBtn, () => {
                this.Close()
            }, this, true)
        }

        this.Local_Open = (...new_args) => {
            let parms = new_args
            if (parms && parms[0]) {
                this.type = parms[0]
                this.InitView()
            }
            super.Open()
        }

        this.InitView = () => {
            if (this.is_loaded && this.type) {
                
                let taList = (this.type == 1 && (["结社奖励", "排行奖励"]) || (["阵营奖励", "个人奖励"]))
                if (!this.tabList) {
                    this.tabList = new LoopScrowViewMgr()
                    this.tabList.SetData(this.Content, SeaReawrdPreTab, taList, LoopScrCon.Horizontal, 1, (index?) => {
                        this.SelectView(index)
                    })
                    this.Content.scrollBar.touchScrollEnable=false
                } else {
                    this.tabList.replaceAll(taList)
                }
                this.tabList.SetSelectIndex(0)
            }
        }

        this.SelectView = (index?) => {
            if (index != this.selectIndex) {
                if (index == 1) {
                    if (!this.guildData) {
                        this.guildData = []
                        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_reward", false)// Config.Seacraftreward
                        if (cfg) {
                            table.insert(this.guildData, { type: 1, reward: cfg[this.type].success_reward })
                            table.insert(this.guildData, { type: 0, reward: cfg[this.type].fail_reward })
                        }
                    }
                    this.Content3.visible = false
                    this.Content1.visible = true

                    if (!this.guild_reward_list) {
                        this.guild_reward_list = new LoopScrowViewMgr()
                        this.guild_reward_list.SetData(this.Content1, SeaGuildRewardItem, this.guildData, LoopScrCon.Vertical)
                    } else {
                        this.guild_reward_list.replaceAll(this.guildData)
                    }





                } else {
                    if (!this.rankData) {
                        this.rankData = []
                        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_rank_reward", false)//Config.Seacraftrankreward
                        if (cfg) {
                            for (let key in cfg) {

                                let vo = cfg[key]
                                if (vo.act_type == this.type) {
                                    table.insert(this.rankData, vo)
                                }
                            }
                            table.sort(this.rankData, (a?, b?) => {
                                if (a.min != b.min) {
                                    return a.min < b.min
                                }
                                return false
                            })
                        }
                    }
                    this.Content1.visible = false
                    this.Content3.visible = true

                    if (!this.sea_reward_list) {
                        this.sea_reward_list = new LoopScrowViewMgr(this.layer_value)
                        this.sea_reward_list.SetData(this.Content3, SeaRewardRankItem, this.rankData, LoopScrCon.Vertical)
                    } else {
                        this.sea_reward_list.replaceAll(this.rankData)
                    }


                }
                this.selectIndex = index
            }
        }

        this.destroy_callback = () => {
            if (this.tabList) {
                this.tabList.DeleteMe()
                this.tabList = null
            }
            if (this.guild_reward_list) {
                this.guild_reward_list.DeleteMe()
                this.guild_reward_list = null
            }
            if (this.sea_reward_list) {
                this.sea_reward_list.DeleteMe()
                this.sea_reward_list = null
            }

            this.selectIndex = null
            this.guildData = null
            this.rankData = null
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }


    bg: Laya.Image
    _Image2_title: Laya.Image
    _lb_win_name: Laya.Label
    _Image1: Laya.Image
    closeBtn: Laya.Image
    Content: Laya.List
    Content1: Laya.List
    Content3: Laya.List
    public GetComponents() {
        [
            this.bg,
            this._Image2_title,
            this._lb_win_name,
            this._Image1,
            this.closeBtn,
            this.Content,
            this.Content1,
            this.Content3,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_Image2_title",
                "_lb_win_name",
                "_Image1",
                "closeBtn",
                "Content",
                "Content1",
                "Content3",
            ])
    }
}
window["SeaReawrdPreView"] = SeaReawrdPreView