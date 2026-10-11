import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SetHtmlStyle, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class TeamHallItem extends BaseItemRenderer {
    _Image1: Laya.Image
    role_head: Laya.Box
    _img_role_head: Laya.Image
    _img_frame: Laya.Image
    head_click_group: Laya.Box
    name_bg: Laya.Image
    role_name: Laya.Label
    level: Laya.Label
    role_num: Laya.Label
    online_state: Laya.HTMLDivElement
    applyBtn: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    leader_tag: Laya.Image
    InitEvent
    is_delay_callback
    model
    head

    public static width = 540
    public static height = 105

    public constructor(parent) {
        super()

        this.base_file = "team"
        this.layout_file = "TeamHallItem"
        this.model = TeamModel.GetInstance()
        // this.skinName="resource/game/team/exml/TeamHallItemExml.exml"
        this.is_delay_callback = false
        this.WIDTH=580
        this.HEIGT=80
        // this.load_callback = () => {

        // }
        this.Load()
    }

    public load_callback(){
        SetHtmlStyle( this.online_state,{f:24,c:"#639c12",ww:false,w:200})
        ResManager.GetInstance().SetTexture(this.base_item,this._Image1,GameResPath.GetIcon("team","ui_dw_zdyq006"))
        let apply_fun = () => {
            if (this.data) {
                this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", this.data.team_id, this.model.activity_id, this.model.activity_sub_id)
            }
        }

        Util.AddClickEvent(this.applyBtn, apply_fun, this, true)
        let head_click_fun = (e?) => {
            if (this.data) {
                if (RoleManager.GetInstance().mainRoleInfo.role_id == this.data.id) {
                    return
                }
                if(e.stopPropagation)
                    e.stopPropagation()
                let tab_list = [0, 2]
                // let fdata = FriendModel.GetInstance().getFriendById(this.data.id)
                // if (! fdata)
                // {
                //     tab_list = [0, 2]
                // }else{
                //     tab_list = [0]
                // }
                CommonManager.GetInstance().ShowPlayerMenu(tab_list, this.head_click_group, this.data.id, this.data.server_id)
            }
        }

        Util.AddClickEvent(this.head_click_group, head_click_fun, this, true)
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
        if (this.data && this.data.team_id) {
            this.role_num.text = "人数：" + this.data.num + "/" + TeamModel.TEAMER_MAX

            let leader = this.GetTeamLeader(this.data.members)
            if (leader) {
                //let frame_id = DressModel.GetInstance().GetDressByType(leader.dress_list, DressType.Photo)
                //this.role_head.setData(null, leader.career, leader.picture, null, null, frame_id)
                // [ts2lua]lua中0和空字符串也是true，此处leader.level > 370需要确认

                //let head_res = leader.career || ""
                //if (leader.picture ) { 
                //let picture_cfg = Config.Picture[Number(leader.picture)]
                //if (picture_cfg ) {
                //head_res = picture_cfg.resource
                //}
                //}
                //lua_resM:SetOutsideImageSprite(this,this._img_role_head, GameResPath.GetIcon("head", head_res))
                //let data = this.data
                if (!this.head) {
                    this.head = new CustomHeadItem(this.role_head)
                    this.head.Load()
                }
                this.head.SetData(leader.id, leader.career, leader.sex, leader.picture, leader.picture_ver)

                let level = (leader.level > 370 && ("神创" + (leader.level - 370)) || (leader.level))
                this.level.text = level + "级"
                // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
                // 	this.level.text = "Lv." + level 
                // }
                this.role_name.text = leader.name
                this.online_state.innerHTML = Util.StrToHTML(this.model.GetOnlineStateStr(leader.online, leader.scene_id, leader.id))
                //this.role_head.SetHeadImgGray(leader.online == 0)
                //SetImageGray(this.name_bg, leader.online == 0)
                //SetImageGray(this._img_role_head, leader.online == 0)
                //SetImageGray(this._img_frame, leader.online == 0)
            }
        }
    }

    public GetTeamLeader(members?) {

        let leader = null
        if (members) {
            for (let _tmpi in members) {
                let vo = members[_tmpi]
                if (vo.team_position == 1) {
                    leader = vo
                    break
                }
            }
        }
        return leader
    }


    public GetComponents() {
        [
            this._Image1,
            this.role_head,
            this._img_role_head,
            this._img_frame,
            this.head_click_group,
            this.name_bg,
            this.role_name,
            this.level,
            this.role_num,
            this.online_state,
            this.applyBtn,
            this._Image2,
            this._Label1,
            this.leader_tag,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "role_head",
                "_img_role_head",
                "_img_frame",
                "head_click_group",
                "name_bg",
                "role_name",
                "level",
                "role_num",
                "online_state",
                "applyBtn",
                "_Image2",
                "_Label1",
                "leader_tag",
            ])
    }
}
window["TeamHallItem"]=TeamHallItem