import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { TeamBeInvitedRoleItem } from "./TeamBeInvitedRoleItem"

export class TeamBeInvitedView extends BaseView1 {
    _Image1: Laya.Image
    _Group1: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    _Image3: Laya.Image
    closeBtn: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Scroller1: Laya.List

    InitEvent
    LoadSuccess
    Scr_Scroller1
    SetData
    SetList
    click_bg_toClose

    destroy_callback
    destroy_imm
    is_center
    is_delay_callback
    open_callback
    scroll_group
    show_open_movie
    use_background

    public constructor() {
        super()

        this.base_file = "team"
        this.layout_file = "TeamBeInvitedView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.is_delay_callback = false
        let model = TeamModel.GetInstance()
        let local_TeamEvent = TeamEvent
        //let arrayCollection = null
        let invited_loop_mgr = null
        let invited_loop_list = null
        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.SetData()
        }

        this.destroy_callback = () => {
            if (invited_loop_mgr) {
                invited_loop_mgr.DeleteMe()
                invited_loop_mgr = null
            }
            invited_loop_list = null
            model.be_invited_list = null
            model.Fire(local_TeamEvent.TEAM_UPDATE_BE_INVITED_LIST)
            //arrayCollection = null
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this,this._Image1,GameResPath.GetIcon("team","ui_content_bg2"))
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_TERAM_INFO, close_fun)
            let update_fun = () => {
                this.SetData()
            }

            this.BindEvent(model, local_TeamEvent.TEAM_UPDATE_BE_INVITED_LIST, update_fun)
        }

        this.SetData = () => {
            if (model.be_invited_list) {
                if (model.be_invited_list.length <= 0) {
                    this.Close()
                    return
                }
                if (!invited_loop_mgr) {
                    this.SetList(model.be_invited_list)
                } else {
                    invited_loop_list = model.be_invited_list
                    invited_loop_mgr.replaceAll(invited_loop_list)
                }
            }
        }

        this.SetList = (be_invited_list?) => {
            invited_loop_list = be_invited_list
            invited_loop_mgr = new LoopScrowViewMgr()
            invited_loop_mgr.SetData(this._Scroller1, TeamBeInvitedRoleItem, invited_loop_list, LoopScrCon.Vertical, 1)
            invited_loop_list = be_invited_list
        }
    }


    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this._Image2,
            this._Label1,
            this._Image3,
            this.closeBtn,
            this._Image4,
            this._Image5,
            this._Scroller1,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Group1",
                "_Image2",
                "_Label1",
                "_Image3",
                "closeBtn",
                "_Image4",
                "_Image5",
                "_Scroller1",
            ])
    }
}
window["TeamBeInvitedView"]=TeamBeInvitedView