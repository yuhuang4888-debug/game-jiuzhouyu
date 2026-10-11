import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { DungeonDragonDefine } from "../dungeonDragon/DungeonDragonDefine"
import { GameResPath } from "../util/GameResPath"
import { SetHtmlStyle, Util } from "../util/Util"
import { DungeonPolarTeamHeadItem } from "./DungeonPolarTeamHeadItem"

export class DungeonPolarTeamItem extends BaseItemRenderer {

team_item_list
team_model

public WIDTH: number= 330
public HEIGT: number = 130
public constructor(parent){
super() 
	
	this.team_model = TeamModel.GetInstance()
	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarTeamItem"
	this.load_callback = () => {

		Util.AddClickEvent(this._gp_team,() => {
			if (this.data ) {
				if (! this.data.none ) {
					let vo = this.data.vo
					TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_PROTO, 24002, "lcc", vo.team_id, TeamModel.POLAR_DUN, this.data.sub_type)
				}else{
					let cfg = this.team_model.GetTaegetCfgById(TeamModel.POLAR_DUN, this.data.sub_type)
					if (cfg ) {
						this.team_model.Fire(TeamEvent.TEAM_REQUEST_PROTO, 24000, "ccihhi", TeamModel.POLAR_DUN, this.data.sub_type, 0, cfg.default_lv_min, cfg.default_lv_max, 0)
					}
				}
			}
		}
		, this, true)

	}
	this.Load()
}


public dataChanged(){ 
	if(!super.dataChanged())return
	let list = []
	let data = this.data
	if (! data.none ) {
		let room_data = data.vo
		let vo = null
		let i = 0
		if (i < DungeonDragonDefine.MaxNum ) {
			do {
				vo = room_data.members[i]
				if (vo ) {
					if (vo.team_position == 1 ) {
						this._lb_name.text =`S${vo.server_num}.${vo.name}的队伍`
					}
					table.insert(list, vo)
				}else{
					table.insert(list, {none:true})
				}
				i=i+1
			} while ((i < DungeonDragonDefine.MaxNum)
)
		}
		this._gp_join.visible = true 
		ResManager.GetInstance().SetImageSprite(this, this._img_join,"dungeonPolar_asset",this.team_model.joinImage(data.activity_id, data.vo.join_con_value))
	}else{
		this._lb_name.text = "点击创建队伍"
		list = [{none:true}, {none:true}, {none:true}]
		this._gp_join.visible = false 
	}
	if (! this.team_item_list ) {
		this.team_item_list = []
	}
	let item = null
	let vo = null
	for (let key in list) {
		
		item = this.team_item_list[key]
		vo = list[key]
		if (! item ) {
			item =  new DungeonPolarTeamHeadItem(this._gp_head_con)
			item.Load()
			this.team_item_list[key] = item
		}
		item.SetData(vo)
	}
}

public DeleteMe(){ 
	
	if (this.team_item_list ) {
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
_lb_name:Laya.Label
_gp_join:Laya.Box
_img_join:Laya.Image
_Label1:Laya.Label
_gp_head_con:Laya.HBox
public GetComponents() {
[
this._gp_team,
this._Image1,
this._Image2,
this._lb_name,
this._gp_join,
this._img_join,
this._Label1,
this._gp_head_con,
]
 = this.GetChildrenByNames([

"_gp_team",
"_Image1",
"_Image2",
"_lb_name",
"_gp_join",
"_img_join",
"_Label1",
"_gp_head_con",
])
}
}
 window["DungeonPolarTeamItem"]= DungeonPolarTeamItem