import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { SentientActModel } from "../commonModel/SentientActModel"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { Util } from "../util/Util"
import { SentientActTeamApplyItem } from "./SentientActTeamApplyItem"

export class SentientActTeamApplyView extends BaseItem1 {
    group_list: Laya.List
    clear_btn: Laya.Box
    agree_btn: Laya.Box
    _gp_none: Laya.Box
    FireEvent
    InitEvent
    InitView
    LocalDeleteMe
    Scr_Scroller1
    SetData
    UpdateView
    _list_item
    loop_mgr

    public constructor(parent?) {
        super(parent)


        this.base_file = "sentientAct"
        this.layout_file = "SentientActTeamApplyView"
        let model = SentientActModel.GetInstance()
        let team_model = TeamModel.GetInstance()
        this.preload_server_config = {
        }
        this.load_callback = () => {
            this.FireEvent()
            this.InitView()
            this.InitEvent()

        }

        this.LocalDeleteMe = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
            super.DeleteMe()
        }

        this.InitView = () => {
        }

        this.FireEvent = () => {
            TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24047)
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this.clear_btn, () => {
                let list = []
                team_model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, list)
            }, this, true)
            Util.AddClickEvent(this.agree_btn, () => {
                team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24063)
            }, this, true)
            this.BindEvent(TeamModel.GetInstance(), TeamEvent.TEAM_UPDATE_APPLY_LIST, () => {
                this.UpdateView()
            })
        }

        this.UpdateView = () => {
            let list = []
            if (team_model.apply_list) {
                list = team_model.apply_list
            }
            this._gp_none.visible = list.length == 0
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.group_list, SentientActTeamApplyItem, list, LoopScrCon.Vertical)
            } else {
                this.loop_mgr.replaceAll(list)

            }
        }

        this.SetData = (...new_args) => {
            let parms = new_args

            this.FireEvent()
            //this.UpdateView()
        }



    }
    public DeleteMe() {

        this.LocalDeleteMe()
    }




    public GetComponents() {
        [
            this.group_list,
            this.clear_btn,
            this.agree_btn,
            this._gp_none,
        ]
            = this.GetChildrenByNames([

                "group_list",
                "clear_btn",
                "agree_btn",
                "_gp_none",
            ])
    }
}
window["SentientActTeamApplyView"] = SentientActTeamApplyView