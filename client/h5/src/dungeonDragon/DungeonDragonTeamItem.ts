import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { DungeonEquipTeamHeadItem } from "../dungeonEquip/DungeonEquipTeamHeadItem"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonDragonDefine } from "./DungeonDragonDefine"

export class DungeonDragonTeamItem extends BaseItemRenderer {
	team_item_list
	team_model

	public WIDTH = 272
	public HEIGT = 119

	public constructor(parent) {
		super()

		this.team_model = TeamModel.GetInstance()
		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonTeamItem"
		this.load_callback = () => {
			this.PreHtml()
			this.Init()
		}
		this.Load()
	}

	public Init() {


		// super.load_callback()
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("dungeonEquip", "uizbfb_025"), true)
		Util.AddClickEvent(this._gp_team, () => {
			if (this.data) {
				if (!this.data.none) {
					let vo = this.data.vo
					TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", vo.team_id, DungeonDragonDefine.TeamType, this.data.sub_type)
				} else {
					let cfg = this.team_model.GetTaegetCfgById(DungeonDragonDefine.TeamType, this.data.sub_type)
					if (cfg) {
						this.team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", DungeonDragonDefine.TeamType, this.data.sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
					}
				}
			}
		}
			, this, true)
	}

	PreHtml(){
        this._lb_name.style.fontSize=18
        this._lb_name.style.color="#d15e00"
		this._lb_name.style.wordWrap=false
        this._lb_name.width=250
    }


	public dataChanged() {
		if (!super.dataChanged()) return
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
			} while ((i < DungeonDragonDefine.MaxNum)
			)
		} else {
			this._lb_name.innerHTML = "点击创建队伍"
			list = [{ none: true }, { none: true }, { none: true }]
		}
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
 window["DungeonDragonTeamItem"]= DungeonDragonTeamItem