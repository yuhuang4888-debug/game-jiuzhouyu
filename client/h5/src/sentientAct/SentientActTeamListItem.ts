import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CommonManager } from "../common/CommonManager"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SetHtmlStyle, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"

export class SentientActTeamListItem extends BaseItemRenderer {
    role_head: Laya.Box
    role_name: Laya.Label
    level: Laya.Label
    role_num: Laya.Label
    applyBtn: Laya.Box
    apply_img: Laya.Image
    apply_lab: Laya.Label

    InitEvent
    model
    head

    WIDTH = 580
    HEIGT = 110
    
    protected teamActivityType = 9;
    protected teamSubType = 1;
    public constructor(parent) {
        super()

        this.base_file = "sentientAct"
        this.layout_file = "SentientActTeamListItem"
        this.model = TeamModel.GetInstance()

        // this.load_callback = () => {

        // }
        this.Load()
    }

    public load_callback() {

        let apply_fun = () => {
            let data = this.data && this.data.vo
            if (!data) return
            let is_mine = this.IsMineTeam(data.members)
            if (is_mine)
                this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24005)
            else
                this.model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", data.team_id, this.teamActivityType, this.teamSubType)
        }

        Util.AddClickEvent(this.applyBtn, apply_fun, this, true)

    }

    public DeleteMe() {

        if (this.head) {
            this.head.DeleteMe()
            this.head = null
        }
        super.DeleteMe()
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        let data = this.data && this.data.vo
        if (data && data.team_id) {
            this.role_num.text = "成员：" + data.num + "/" + TeamModel.TEAMER_MAX

            let leader = this.GetTeamLeader(data.members)
            if (leader) {
                this.level.text = leader.power
                this.role_name.text = leader.name
                if (!this.head) {
                    this.head = new CustomHeadItem(this.role_head)
                    this.head.SetActiveLevel(true)
                    this.head.Load()
                }
                this.head.SetData(leader.id, leader.career, leader.sex, leader.picture, leader.picture_ver, null, null, null, leader.level)


            }
            let is_mine = this.IsMineTeam(data.members)
            this.apply_lab.text = is_mine ? "离开队伍" : "申请加入"
            let source = is_mine ? "ui_button_rect11" : "ui_button_rect14"
            ResManager.GetInstance().SetImageSprite(this, this.apply_img, "common", source, false)
            let strock_color = is_mine ? "#dc393d" : "#3e9298"
            this.apply_lab.strokeColor = strock_color
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
    public IsMineTeam(members?) {

        let is_mine = false
        if (members) {
            for (let _tmpi in members) {
                let vo = members[_tmpi]
                if (vo.id == RoleManager.GetInstance().GetMainRoleId()) {
                    is_mine = true
                    break
                }
            }
        }
        return is_mine
    }





    public GetComponents() {
        [
            this.role_head,
            this.role_name,
            this.level,
            this.role_num,
            this.applyBtn,
            this.apply_img,
            this.apply_lab,
        ]
            = this.GetChildrenByNames([

                "role_head",
                "role_name",
                "level",
                "role_num",
                "applyBtn",
                "apply_img",
                "apply_lab",
            ])
    }
}
window["SentientActTeamListItem"] = SentientActTeamListItem