import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GuildFightModel, GuildFightEvent } from "../commonModel/GuildFightModel"
import { GuildModel } from "../commonModel/GuildModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SetHtmlCenter, Util } from "../util/Util"
import { GuildFightWiningRewardItem } from "./GuildFightWiningRewardItem"

export class GuildFightWiningRewardView extends BaseView1 {
    reward_loop_mgr:LoopScrowViewMgr
    LoadSuccess
    InitView
    InitEvent
    Dispose
    public constructor() {
        super()

        let model = GuildFightModel.GetInstance()
        let role_mgr = RoleManager.GetInstance()
        //let sourceArr_ = eui. new ArrayCollection()
        let wining_cfg_ = null
        let win_time_ = null
        let wining_list_ = []
        let local_Util = Util
        this.base_file = "guildFight"
        this.layout_file = "GuildFightWiningRewardView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.reward_loop_mgr = null
        this.destroy_imm=true

        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.preload_server_config = { "config_terri_war_streak_reward": false }
        this.LoadSuccess = () => {
            wining_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_terri_war_streak_reward", false)
            if (wining_cfg_) {
                this.InitView()
                this.InitEvent()
            }
        }

        this.InitView = () => {
            let win_data = model.GetWinData()
            if (GuildModel.IsHasGuild() && win_data && role_mgr.GetMainRoleVo().guild_id == win_data.winner) {
                win_time_ = win_data.win_num
            } else {
                win_time_ = 0
            }
            let world_lv = role_mgr.GetMainRoleVo().worldLv || 1
            let has_reward = win_data && win_data.reward_owner > 0
            let has_reward_list = []
            let un_reward_list = []
            for (let key in wining_cfg_) {

                if (wining_cfg_[key].min_wlv <= world_lv && world_lv <= wining_cfg_[key].max_wlv) {
                    let data = {}
                    if (win_time_ > wining_cfg_[key].streak_times) {
                        data = { win_reward: JSON.parse(wining_cfg_[key].win_reward), win_state: 2, time: wining_cfg_[key].streak_times }
                        table.insert(has_reward_list, data)
                    }
                    else if (win_time_ == wining_cfg_[key].streak_times) {
                        if (has_reward) {
                            data = { win_reward: JSON.parse(wining_cfg_[key].win_reward), win_state: 2, time: wining_cfg_[key].streak_times }
                            table.insert(has_reward_list, data)
                        } else {
                            data = { win_reward: JSON.parse(wining_cfg_[key].win_reward), win_state: 1, time: wining_cfg_[key].streak_times }
                            table.insert(un_reward_list, data)
                        }
                    }
                    else if (win_time_ < wining_cfg_[key].streak_times) {
                        data = { win_reward: JSON.parse(wining_cfg_[key].win_reward), win_state: 0, time: wining_cfg_[key].streak_times }
                        table.insert(un_reward_list, data)
                    }
                }
            }
            table.sort(has_reward_list, (a?, b?) => {
                if (a.time != b.time) {
                    return a.time < b.time
                }
                return false
            })

            table.sort(un_reward_list, (a?, b?) => {
                if (a.time != b.time) {
                    return a.time < b.time
                }
                return false
            })

            wining_list_ = un_reward_list.concat(has_reward_list)//table.merge(un_reward_list, has_reward_list)

            if (!this.reward_loop_mgr) {
                this.reward_loop_mgr = new LoopScrowViewMgr()
                this.reward_loop_mgr.SetData(this._list_items,GuildFightWiningRewardItem,wining_list_,LoopScrCon.Vertical)
            }else{
                this.reward_loop_mgr.replaceAll(wining_list_)
            }
           
            this.PreHtml()
            this.num_text.innerHTML = Util.StrToHTML("当前连胜次数:<font color='#00b11d'>" + win_time_ + "次</font>")
            SetHtmlCenter(this.num_text,{x:0,w:643})
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.CloseBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            this.BindEvent(
                model,
                GuildFightEvent.UPDATE_GUILD_FIGHT_VIEW, () => {
                    this.InitView()
                }
            )
        }

        this.destroy_callback=()=>{
            this.Dispose()
        }

        this.Dispose = () => {
            wining_cfg_ = null
            if(this.reward_loop_mgr){
                this.reward_loop_mgr.DeleteMe()
                this.reward_loop_mgr=null
            }
        }
    }

    public DeleteMe() {
        super.DeleteMe()
    }


    PreHtml() {
        this.num_text.style.color = "#70604a"
        this.num_text.style.fontSize = 22
        this.num_text.style.align = "center"
        this.num_text.width = 480
    }

    _Image1: Laya.Image
    CloseBtn: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    num_text: Laya.HTMLDivElement
    _list_items: Laya.List
    public GetComponents() {
        [
            this._Image1,
            this.CloseBtn,
            this._Image2,
            this._Image3,
            this._Image4,
            this.num_text,
            this._list_items,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "CloseBtn",
                "_Image2",
                "_Image3",
                "_Image4",
                "num_text",
                "_list_items",
            ])
    }
}
window["GuildFightWiningRewardView"] = GuildFightWiningRewardView