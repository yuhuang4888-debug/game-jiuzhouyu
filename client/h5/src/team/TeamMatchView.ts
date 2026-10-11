import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LuaSoundManager } from "../common/SoundManager"
import { SentientActEvent, SentientActModel } from "../commonModel/SentientActModel"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { DungeonDragonDefine } from "../dungeonDragon/DungeonDragonDefine"
import { DungeonEquipDefine } from "../dungeonEquip/DungeonEquipDefine"
import { SceneManager } from "../scene/SceneManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"
import { Util, GlobalTimerQuest, HtmlColorTxt } from "../util/Util"

export class TeamMatchView extends BaseView1 {
    CancelTime
    InitEvent
    LoadSuccess
    Local_Open
    RefreshMatchTime
    RefreshTotalMatchTime
    Remove
    StartTime
    SentientActFunc

    destroy_callback
    destroy_imm
    hash_Code
    is_center
    show_open_movie

    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamMatchView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true
        let model = TeamModel.GetInstance()
        let local_Util = Util
        let local_TeamEvent = TeamEvent
        let local_DungeonEquipDefine = DungeonEquipDefine
        let local_TimeUtil = TimeUtil
        let data_ = null
        let _match_total_time_ = null
        let time_func_ = null
        let time_id_ = null
        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            this.Remove()
        }

        this.Remove = () => {
            this.CancelTime()
            model.RemoveMatchTryFunc(this.hash_Code)
        }

        this.Local_Open = (parms?) => {
            if (parms) {
                data_ = parms
            }
            super.Open()
        }

        this.LoadSuccess = () => {

            this.hash_Code = String(this)
            model.AddMatchTryFunc(this.hash_Code, this.RefreshMatchTime)
            this.InitEvent()
            this.RefreshTotalMatchTime()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this._img_close, () => {
                    model.SetCancelMatchText(null)
                    model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24048, "c", 0)
                },
                this,
                true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE
            )
            this.BindEvent(
                model,
                local_TeamEvent.TEAM_CHANGE_TARGET_SUCCESS, () => {
                    this.RefreshTotalMatchTime()
                }
            )
            this.BindEvent(
                model,
                local_TeamEvent.TEAM_UPDATE_TERAM_INFO, () => {
                    this.RefreshTotalMatchTime()
                    this.SentientActFunc()
                }
            )
        }

        this.SentientActFunc = () => {
            let team_info = model.team_info
            if (!team_info) return
            let list = []
            let i = 0
            if (team_info && team_info.activity_id == 9 && team_info.subtype == 1 && team_info.team_member_list && Util.TableSize(team_info.team_member_list) >= 3) {

                Alert.Show("众生之门队伍已满员，是否进入玩法场景？", Alert_Type.Two, () => {
                    if (SceneManager.GetInstance().IsSentientActScene()) {
                        SentientActModel.GetInstance().Fire(SentientActEvent.FIND_WAY)
                        GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "SentientActTeamView")
                    } else
                        SentientActModel.GetInstance().Fire(SentientActEvent.REQUEST_PROTO, 24108)
                }, null, "确定", "取消", null, null, null, null, null, null, null, null, null, null, false)
                model.Fire(TeamEvent.TEAM_CLOSE_VIEW, "TeamMatchView")
                model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24048, "c", 0)
            }
            if(!team_info){
                model.Fire(TeamEvent.TEAM_CLOSE_VIEW, "TeamMatchView")
                model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24048, "c", 0)
            }
        }

        this.RefreshTotalMatchTime = () => {
            if (model.activity_id == local_DungeonEquipDefine.TeamType) {
                _match_total_time_ = local_DungeonEquipDefine.MatchTotalTime
            } else {
                _match_total_time_ = DungeonDragonDefine.MatchTotalTime
            }
        }

        this.StartTime = (func?) => {
            this.CancelTime()
            time_id_ = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
            func()
        }

        this.RefreshMatchTime = (match_time?) => {
            let desc0 = null
            let left_times = null
            if (model.team_info) {
                left_times = _match_total_time_ - (local_TimeUtil.getServerTime() - model.team_info.match_st)
                desc0 = "预计匹配时间"
            }
            else if (model.match_st) {
                left_times = _match_total_time_ - local_TimeUtil.getServerTime() + model.match_st
                desc0 = "预计匹配时间:"
            }
            if (!left_times || left_times < 0) {
                this._lb_time.text = ""
                this._lb_desc.text = ""
                if (!model.team_info) {
                    model.Fire(local_TeamEvent.TEAM_REQUEST_PROTO, 24048, "c", 0)
                    this.CancelTime()
                    model.RemoveMatchTryFunc(this.hash_Code)
                    // this.Close()
                }
                else if (model.team_info) {
                    // this.display_obj.visible = false
                }
                this._lb_desc.text = "努力匹配中..."
                this._lb_time.visible = false
                this._lb_desc.y = 40
                return
            }
            this._lb_desc.y = 27
            this._lb_desc.text = desc0
            this._lb_time.visible = true
            this._lb_time.text = local_TimeUtil.timeConvert(left_times, "mm:ss")
            //left_times = _match_total_time_ - left_times
            // desc = desc + HtmlColorTxt(local_TimeUtil.timeConvert(left_times, "mm:ss"), ColorUtil.GetColorLight(ColorType.GREEN))

        }

        this.CancelTime = () => {
            if (time_id_) {
                GlobalTimerQuest.CancelQuest(time_id_)
                time_id_ = null
            }
        }
    }


    public Open(...new_args) {

        this.Local_Open(...new_args)
    }

    public DeleteMe() {
        super.DeleteMe()
    }



    _Image1: Laya.Image
    _img_close: Laya.Image
    _lb_desc: Laya.Label
    _lb_time: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._img_close,
            this._lb_desc,
            this._lb_time,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_img_close",
                "_lb_desc",
                "_lb_time",
            ])
    }
}
window["TeamMatchView"] = TeamMatchView