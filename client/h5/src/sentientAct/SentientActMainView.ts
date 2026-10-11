import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { kfStageModel } from "../commonModel/kfStageModel"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import "../kfStart/kfStageStartView"
import { GuildModel, GuildEvent, GuildAssistType } from "../commonModel/GuildModel"
import { DungeonEquipEnterView } from "../dungeonEquip/DungeonEquipEnterView"
import { Message } from "../sysInfo/SysInfoController"
import { TeamModel } from "../commonModel/TeamModel"
import { SentientActTeamListView } from "./SentientActTeamListView"
import { PlatformManager } from "../PlatformManager"

export class SentientActMainView extends BaseItem1 {

    public static PARAM_TYPE_CREAT_TWAM = "PARAM_TYPE_CREAT_TWAM"//点击协助  打开队伍面板并创建队伍
    InitEvent
    InitView
    LoadSuccess
    UpdateCount
    guild_model
    item_list
    public constructor(parent?) {
        super(parent)


        this.base_file = "sentientAct"
        this.layout_file = "SentientActMainView"
        let model = SentientActModel.GetInstance()
        let team_model = TeamModel.GetInstance()
        this.guild_model = GuildModel.GetInstance()
        this.preload_server_config = {
            "config_beings_gate_kv": false
        }
        this.preload_client_config = {
            "ClientSentientAct": false
        }
        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIcon("sentientAct", "ui_zong_01"))
            this._html_kf_mode.style.color = "#663915"
            this._html_kf_mode.style.fontSize = 20
            this._html_kf_mode.style.wordWrap = false
            this.instr.style.color = "#ffffff"
            this.instr.style.fontSize = 18
            this.instr.style.wordWrap = false
            if(PlatformManager.IsEyouPlatform()){
                this.instr.style.wordWrap = true
                this.instr.style.width = 680
                this.instr.style.leading = 0.1
            }
            let info = SentientActModel.GetInstance().GetActData()
            if ((info && info.mod)) {
                this._html_kf_mode.innerHTML = `当前模式：<font color='#d15e00'>${(info.mod == 1 && "本" || info.mod)}服模式</font>`
            }

            this._btn_assist.visible = this.guild_model.IsCanOpenAssist()
            this.InitView()
            this.InitEvent()
        }

        this.InitEvent = () => {
            this.BindEvent(this.guild_model, GuildEvent.CHANGED_CONDS_ASSIST, () => {
                this._btn_assist.visible = this.guild_model.IsCanOpenAssist()
            })


            Util.AddClickEvent(
                this._btn_assist, () => {

                    let data = SentientActModel.GetInstance().GetActData()
                    if (data && data.state == 0) {
                        Message.show("当前非活动时间，无法发起协助")
                        return
                    }
                    let is_open = this.guild_model.IsOpenAssist(GuildAssistType.TYPE_SENTIENT)
                    if (!is_open) {
                        Message.show(`${this.guild_model.GetAssistOpenDesc(GuildAssistType.TYPE_SENTIENT)}`)
                        return
                    }

                    //未满员，请求协助
                    let have_team = team_model.team_info && team_model.team_info.activity_id == 9 //众生之门
                    if ((have_team && team_model.team_info.team_member_list.length < 3) || !have_team) {
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'SentientActTeamView', SentientActMainView.PARAM_TYPE_CREAT_TWAM);
                    } else {
                        GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'SentientActTeamView');
                    }


                },
                this,
                true
            )



            Util.AddClickEvent(this.teeam_btn, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'SentientActTeamView');
            }, this, true)
            Util.AddClickEvent(this._box_kf, () => {
                kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_241)

            }, this, true)
            Util.AddClickEvent(this.go_btn, () => {
                model.Fire(SentientActEvent.REQUEST_PROTO, 24104)
            }, this, true)
            this.BindEvent(
                model,
                SentientActEvent.UPDATE_COUNT, (assist_num, enter_num) => {
                    this.UpdateCount(assist_num, enter_num)

                }
            )
            model.Fire(SentientActEvent.REQUEST_PROTO, 24107)
        }

        this.InitView = () => {
            this.UpdateCount()
            this.InitReward()
        }
        this.UpdateCount = (assist_num, enter_num) => {
            let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_beings_gate_kv", false)
            if (!cfg) return
            let max_help_count = cfg["beings_gate_dungeon_assist"].value
            let max_into_count = cfg["beings_gate_scene_enter"].value
            //let dungeon_data = BaseDungeonModel.GetInstance().GetDungeonInfo(DUN_TYPE.SentientAct)
            // let into_count = 0
            // if (dungeon_data && Util.TableSize(dungeon_data)) {
            //     for (let key in dungeon_data) {
            //         let data = dungeon_data[key]
            //         into_count += data.daily_count
            //     }
            // }
            this.xiezhu_num.text = `${max_help_count - assist_num}/${max_help_count}`
            this.jinru_num.text = `${max_into_count - enter_num}/${max_into_count}`
        }
    }


    public DeleteMe() {
        if (this.item_list) {
            for (let _tmpi in this.item_list) {
                let obj = this.item_list[_tmpi]
                obj.DeleteMe()
            }
            this.item_list = null
        }
        super.DeleteMe()
    }
    private InitReward() {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientSentientAct", true)
        let des = cfg.des
        this.instr.innerHTML = des
        if(PlatformManager.IsEyouPlatform()){
            this.instr.style.width = 680
        }
        let show_reward = cfg.reward
        let length = show_reward.length

        let width = 100 * length
        this.reward_gp.width = width
        if (!this.item_list) {
            this.item_list = []
        }
        for (let key in show_reward) {
            let item = this.item_list[key]
            if (!item) {
                item = new BaseAwardItem(this.reward_gp)
                this.item_list[key] = item
                item.SetItemSize(100, 100)
                item.Load()
            }
            item.SetPosition(Number(key) * 110, 0)
            let vo = show_reward[key]

            item.SetData(vo)

        }
    }


    bg1: Laya.Image
    _box_kf: Laya.Box
    _img_kf: Laya.Image
    _lb_kf: Laya.Label
    _img_bg2: Laya.Image
    _html_kf_mode: Laya.HTMLDivElement
    xiezhu_num: Laya.Label
    jinru_num: Laya.Label
    instr: Laya.HTMLDivElement
    reward_gp: Laya.HBox
    go_btn: Laya.Box
    teeam_btn: Laya.Image
    _btn_assist: Laya.Image
    public GetComponents() {
        [
            this.bg1,
            this._box_kf,
            this._img_kf,
            this._lb_kf,
            this._img_bg2,
            this._html_kf_mode,
            this.xiezhu_num,
            this.jinru_num,
            this.instr,
            this.reward_gp,
            this.go_btn,
            this.teeam_btn,
            this._btn_assist,
        ]
            = this.GetChildrenByNames([

                "bg1",
                "_box_kf",
                "_img_kf",
                "_lb_kf",
                "_img_bg2",
                "_html_kf_mode",
                "xiezhu_num",
                "jinru_num",
                "instr",
                "reward_gp",
                "go_btn",
                "teeam_btn",
                "_btn_assist",
            ])
    }
}
window["SentientActMainView"] = SentientActMainView