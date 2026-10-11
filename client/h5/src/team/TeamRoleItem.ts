import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util, SetSizeDeltaX, SetHtmlStyle } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class TeamRoleItem extends BaseItemRenderer {
    _Image1: Laya.Image
    role_head: Laya.Box
    leader_tag: Laya.Image
    head_click_group: Laya.Box
    name_bg: Laya.Image
    role_name: Laya.Label
    _Group1: Laya.HBox
    destiny_img: Laya.Image
    level: Laya.Label
    online_state: Laya.HTMLDivElement
    quitBtn: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    pleaseLeaveBtn: Laya.Box
    _Image3: Laya.Image
    _Label2: Laya.Label
    Emphead_click_group
    EmppleaseLeaveBtn
    EmpquitBtn
    InitEvent
    is_delay_callback
    model
    head
    public static width = 540
    public static height = 105

    public constructor(parent) {
        super()

        this.base_file = "team"
        this.layout_file = "TeamRoleItem"
        this.WIDTH=586
        this.HEIGT=78
        // this.skinName="resource/game/team/exml/TeamRoleItemExml.exml"
        this.model = TeamModel.GetInstance()
        this.is_delay_callback = false

        // this.load_callback = () => {
        // }
        // this.InitEvent = () => {
        // }
        // this.InitEvent()
        this.Load()
    }

    public load_callback(){
        SetHtmlStyle( this.online_state,{f:24,c:"#639c12",ww:false,w:200})
        ResManager.GetInstance().SetTexture(this,this._Image1,GameResPath.GetIcon("team","ui_dw_zdyq006"))
        let quit_fun = () => {
            if (this.data) {
                this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
            }
        }

        Util.AddClickEvent(this.quitBtn, quit_fun, this, true)
        let please_leave_fun = () => {
            if (this.data) {
                this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24009, "l", this.data.id)
            }
        }

        Util.AddClickEvent(this.pleaseLeaveBtn, please_leave_fun, this, true)
        let head_click_fun = (e?) => {
            if (this.data) {
                if (RoleManager.GetInstance().mainRoleInfo.role_id == this.data.id || this.data.team_position == 3) {
                    return
                }
                let tab_list = [0, 2]
                // let fdata = FriendModel.GetInstance().getFriendById(this.data.id)
                let is_leader = this.model.IsLeaderInTeam(RoleManager.GetInstance().mainRoleInfo.role_id)
                // if (is_leader)
                // {
                //     if (! fdata)
                //     {
                //         tab_list = [0, 2, 7]
                //     }else{
                //         tab_list = [0, 7]
                //     }
                // }else{
                //     if (! fdata)
                //     {
                //         tab_list = [0, 2]
                //     }else{
                //         tab_list = [0]
                //     }
                // }
                CommonManager.GetInstance().ShowPlayerMenu(tab_list, this.head_click_group, this.data.id, this.data.server_id)
            }
        }

        //AddClickEvent(this.head_click_group, head_click_fun, this, true)
    }

    public DeleteMe() {

        if (this.head) {
            this.head.DeleteMe()
            this.head = null
        }
        super.DeleteMe()
    }

    public dataChanged() {
        if(!super.dataChanged()) return 
        if (this.data && this.data.id) {
            if (!this.head) {
                this.head = new CustomHeadItem(this.role_head)
                this.head.Load()
            }
            this.data.role_id = this.data.id
            let data = this.data
            this.head.SetData(data.role_id, data.career, data.sex, data.picture, data.picture_ver,undefined,undefined,undefined,undefined,true)
            this.role_name.text = this.data.name
            // [ts2lua]lua中0和空字符串也是true，此处this.data.level > 370需要确认
            let level = (this.data.level > 370 && (this.data.level - 370) || (this.data.level))
            this.level.text = level + "级"
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this.level.text = "Lv." + level
            // }
            // [ts2lua]lua中0和空字符串也是true，此处this.data.level > 370需要确认
            //this.destiny_img.width = (this.data.level > 370 && ( 33 ) || ( 0 ) )
            let width = (this.data.level > 370 && (33) || (0))
            SetSizeDeltaX(this.destiny_img, width)
            this.online_state.innerHTML = Util.StrToHTML(this.model.GetOnlineStateStr(this.data.online, this.data.scene_id, this.data.id))
            Util.SetImageGray(this.name_bg, this.data.online == 0)
            //SetImageGray(this._img_role_head, this.data.online == 0)
            this.head.SetHeadImgGray(this.data.online == 0)
            let is_leader = this.model.IsLeaderInTeam(RoleManager.GetInstance().mainRoleInfo.role_id)
            this.leader_tag.visible = this.data.team_position == 1
            if (is_leader) {
                if (this.data.id == RoleManager.GetInstance().mainRoleInfo.role_id) {
                    this.quitBtn.visible = true
                    this.pleaseLeaveBtn.visible = false
                } else {
                    this.quitBtn.visible = false
                    this.pleaseLeaveBtn.visible = true
                }
            } else {
                if (this.data.id == RoleManager.GetInstance().mainRoleInfo.role_id) {
                    this.quitBtn.visible = true
                    this.pleaseLeaveBtn.visible = false
                } else {
                    this.quitBtn.visible = false
                    this.pleaseLeaveBtn.visible = false
                }
            }
        }
    }


    public GetComponents() {
        [
            this._Image1,
            this.role_head,
            this.leader_tag,
            this.head_click_group,
            this.name_bg,
            this.role_name,
            this._Group1,
            this.destiny_img,
            this.level,
            this.online_state,
            this.quitBtn,
            this._Image2,
            this._Label1,
            this.pleaseLeaveBtn,
            this._Image3,
            this._Label2,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "role_head",
                "leader_tag",
                "head_click_group",
                "name_bg",
                "role_name",
                "_Group1",
                "destiny_img",
                "level",
                "online_state",
                "quitBtn",
                "_Image2",
                "_Label1",
                "pleaseLeaveBtn",
                "_Image3",
                "_Label2",
            ])
       
    }
}
window["TeamRoleItem"]=TeamRoleItem