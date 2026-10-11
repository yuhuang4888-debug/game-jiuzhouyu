import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class TeamBeInvitedRoleItem extends BaseItemRenderer {
    _Image1: Laya.Image
    role_head: Laya.Box
    _img_role_head: Laya.Image
    _img_frame: Laya.Image
    name_bg: Laya.Image
    role_name: Laya.Label
    level: Laya.Label
    refuseBtn: Laya.Box
    _Image2: Laya.Image
    _Label1: Laya.Label
    agreeBtn: Laya.Box
    _Image3: Laya.Image
    _Label2: Laya.Label
    EmpagreeBtn
    EmprefuseBtn
    InitEvent
    is_delay_callback
    model
    head

    public static width = 535
    public static height = 100

    public constructor(parent) {
        super()

        this.base_file = "team"
        this.layout_file = "TeamBeInvitedRoleItem"
        // this.skinName="resource/game/team/exml/TeamBeInvitedRoleItemExml.exml"
        this.model = TeamModel.GetInstance()
        this.is_delay_callback = false
        this.WIDTH=588
        this.HEIGT=82
        this.Load()
    }

    public load_callback() {
        ResManager.GetInstance().SetTexture(this.base_item,this._Image1,GameResPath.GetIcon("team","ui_dw_zdyq006"))
        let agreeBtn_fun = () => {
            if (this.data) {
                this.model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24008, [[this.data.team_id, 1]])
            }
        }

        Util.AddClickEvent(this.agreeBtn, agreeBtn_fun, this, true)
        let refuseBtn_fun = () => {
            if (this.data) {
                this.model.Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24008, [[this.data.team_id, 0]])
                this.model.DeleteBeInvited(this.data)
            }
        }

        Util.AddClickEvent(this.refuseBtn, refuseBtn_fun, this, true)
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
        if (this.data && this.data.inviter_id) {
            //let head_res = this.data.career
            //if (this.data.picture ) { 
            //let picture_cfg = Config.Picture[Number(this.data.picture)]
            //if (picture_cfg ) {
            //head_res = picture_cfg.resource
            //}
            //}
            //lua_resM:SetOutsideImageSprite(this,this._img_role_head, GameResPath.GetIcon("head", head_res))

            //let frame_id = DressModel.GetInstance().GetDressByType(this.data.dress_list, DressType.Photo)
            let data = this.data
            if (!this.head) {
                this.head = new CustomHeadItem(this.role_head)
                this.head.Load()
            }
            this.head.SetData(data.inviter_id, data.career, data.sex, data.picture, data.picture_ver)

            this.role_name.text = this.data.name
            this.level.text = this.data.level + "级"


        }
    }


    public GetComponents() {
        [
            this._Image1,
            this.role_head,
            this._img_role_head,
            this._img_frame,
            this.name_bg,
            this.role_name,
            this.level,
            this.refuseBtn,
            this._Image2,
            this._Label1,
            this.agreeBtn,
            this._Image3,
            this._Label2,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "role_head",
                "_img_role_head",
                "_img_frame",
                "name_bg",
                "role_name",
                "level",
                "refuseBtn",
                "_Image2",
                "_Label1",
                "agreeBtn",
                "_Image3",
                "_Label2",
            ])
    }
}
window["TeamBeInvitedRoleItem"]=TeamBeInvitedRoleItem