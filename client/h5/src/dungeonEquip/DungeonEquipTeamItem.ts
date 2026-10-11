import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { table } from "../common/table"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { Util } from "../util/Util"
import { DungeonEquipDefine } from "./DungeonEquipDefine"
import { DungeonEquipTeamHeadItem } from "./DungeonEquipTeamHeadItem"

export class DungeonEquipTeamItem extends BaseItemRenderer {
    team_item_list
    team_model
    public WIDTH = 272
    public HEIGT = 119
    is_set = false
    public constructor(parent) {
        super()

        this.team_model = TeamModel.GetInstance()
        this.base_file = "dungeonEquip"
        this.layout_file = "DungeonEquipTeamItem"

        this.load_callback = () => {

            this.PreHtml()

            this.InitEvent()
            if (!this.is_set) {
                this.is_set = true
                this.SetData()
            }
        }
        this.Load()
    }

    public InitEvent() {

        Util.AddClickEvent(
            this._gp_team, () => {
                if (this.data) {
                    if (!this.data.none) {
                        let vo = this.data.vo
                        TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", vo.team_id, DungeonEquipDefine.TeamType, this.data.sub_type)
                    } else {
                        let cfg = this.team_model.GetTaegetCfgById(DungeonEquipDefine.TeamType, this.data.sub_type)
                        if (cfg) {
                            this.team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", DungeonEquipDefine.TeamType, this.data.sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
                        }
                    }
                }
            },
            this,
            true
        )
    }

    public dataChanged() {
        if (!super.dataChanged()) return
        if (this.is_loaded) {
            this.SetData()
            this.is_set = true
        } else {
            this.is_set = false
        }
    }


    PreHtml(){
        this._lb_name.style.fontSize=18
        this._lb_name.style.color="#d15e00"
        this._lb_name.width=250
        this._lb_name.style.wordWrap=false
    }

    SetData() {
        if (!this.data) return
        let list = []
        let data = this.data
        if (!data.none) {
            let room_data = data.vo
            let vo = null
            let i = 0
            do {
                vo = room_data.members[i]
                if (vo) {
                    if (vo.team_position == 1) {
                        this._lb_name.innerHTML = `S${vo.server_num}.${vo.name}的队伍`//"S" + vo.server_num + "." + vo.name + "的队伍"
                    }
                    table.insert(list, vo)
                } else {
                    table.insert(list, { none: true })
                }
                i = i + 1
            } while ((i < DungeonEquipDefine.MaxNum))
        } else {
            this._lb_name.innerHTML = "点击创建队伍"
            list = [{ none: true }, { none: true }, { none: true }]
        }

        this._lb_name.style.width=250
        if (!this.team_item_list) {
            this.team_item_list = []
        }
        let item = null
        let vo = null
        for (let key in list) {

            // [ts2lua]this.team_item_list下标访问可能不正确
            item = this.team_item_list[key]
            // [ts2lua]list下标访问可能不正确
            vo = list[key]
            if (!item) {
                item = new DungeonEquipTeamHeadItem(this._gp_head_con)
                item.Load()
                // [ts2lua]this.team_item_list下标访问可能不正确
                this.team_item_list[key] = item
            }
            item.SetData(vo)
        }
    }

    public DeleteMe() {

        if (this.team_item_list) {
            for (let _tmpi in this.team_item_list) {
                var obj = this.team_item_list[_tmpi]
                obj.DeleteMe()
            }
            this.team_item_list = null
        }
        super.DeleteMe()
    }

_gp_team:Laya.Box
_Image1:Laya.Image
_Image2:Laya.Image
_lb_name:Laya.HTMLDivElement
_gp_head_con:Laya.HBox
public GetComponents() {
[
this._gp_team,
this._Image1,
this._Image2,
this._lb_name,
this._gp_head_con,
]
 = this.GetChildrenByNames([

"_gp_team",
"_Image1",
"_Image2",
"_lb_name",
"_gp_head_con",
])
}
}
 window["DungeonEquipTeamItem"]= DungeonEquipTeamItem