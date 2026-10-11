import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { DungeonPolarRwRenderItem } from "./DungeonPolarRwRenderItem"
import { DungeonPolarTab } from "./DungeonPolarTab"

export class DungeonPolarRankItem extends BaseItemRenderer {
_model
item_loop_mgr
public WIDTH = 610
public HEIGT = 105
public constructor(parent){
super() 
	
	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarRankItem"
	this._model = BaseDungeonModel.GetInstance()
	this.load_callback = () => {

	}
	this.Load()
}

public DeleteMe(){ 
	if(this.item_loop_mgr){
		this.item_loop_mgr.DeleteMe()
		this.item_loop_mgr=null
	}
	super.DeleteMe()
}

public dataChanged(){ 
	if (!super.dataChanged()) return
	this._lb_rank.text = `第${this.index+1}名`
	let haveData = ! this.data.is_null
	this._gp.visible = haveData 
	this._lb_null.visible = ! haveData
	if (haveData ) {
		let nameStr = ""
		let i = 0
		if (i < this.data.role_list.length ) {
			do {
				let roleInfo = this.data.role_list[i]
				nameStr = `${nameStr}S${roleInfo.server_num}.${roleInfo.role_name}`
				if (i < this.data.role_list.length-1 ) {
					nameStr = nameStr + "\n"
				}
				i=i+1
			} while ((i < this.data.role_list.length)
)
		}
		this._lb_name.text = Util.StrToHTML(nameStr)
		this._lb_time.text = Util.StrToHTML(TimeUtil.convertTime(this.data.pass_time))
	}


	let week_dungeon_rank_cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"config_week_dungeon_rank",false)//Config.Weekdungeonrank
	let cfg = this._model.polarRankCfg(week_dungeon_rank_cfg, this.data.team_dun_id, this.index+1)
	if (cfg ) {
		let reward_list = JSON.parse(cfg.rewards)
		if (!this.item_loop_mgr) {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this.Content, DungeonPolarRwRenderItem, reward_list, LoopScrCon.Horizontal)
		} else {
			this.item_loop_mgr.replaceAll(reward_list)
		}
	
		this.Content.scrollTo(0)
	}

	
}




_Image1:Laya.Image
_Image2:Laya.Image
_lb_rank:Laya.Label
_gp:Laya.Box
_lb_name:Laya.Label
_lb_time:Laya.Label
Content:Laya.List
_lb_null:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image2,
this._lb_rank,
this._gp,
this._lb_name,
this._lb_time,
this.Content,
this._lb_null,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"_lb_rank",
"_gp",
"_lb_name",
"_lb_time",
"Content",
"_lb_null",
])
}
}
 window["DungeonPolarRankItem"]= DungeonPolarRankItem