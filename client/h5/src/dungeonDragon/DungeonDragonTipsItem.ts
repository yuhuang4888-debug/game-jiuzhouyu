import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonDragonRewardItem } from "./DungeonDragonRewardItem"
import { Config } from "../common/Config"
export class DungeonDragonTipsItem extends BaseItem1 {

array_reward
dun_cfg
dun_id


public constructor(parent?){
super(parent) 
	
	this.base_file = "dungeonDragon"
	this.layout_file = "DungeonDragonTipsItem"
	this.load_callback = () => {
		
		this.LoadSuccess()
	}
}

public LoadSuccess(){ 
	
	//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("achv","uilqts_001"), true)
	this.dun_cfg =  Config.ConfigHasDefaultValue.config_dungeon
	Util.AddClickEvent(this._btn_go,() => {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonDragonAchiView", this.dun_id)
			this.DeleteMe()
		}
		, this, true)
}

public SetData(dun_id?, data?){ 
	
	this.dun_id = dun_id
	let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, dun_id, false, this.dun_cfg)
	if (cfg ) {
		this._lb_desc0.text = cfg.name
	}
	this._lb_desc1.text = `首次通关${data.wave}波数`//"首次通关" + data.wave + "波数"
	let list = []
	for (let _tmpi in data.reward) {
		var vo = data.reward[_tmpi]
		table.insert(list, {size:77, vo:{style:vo[0], typeId:vo[1], count:vo[2]}})
	}

	if(!this.array_reward ){
		this.array_reward  = new LoopScrowViewMgr()
		this.array_reward .SetData(this.Content, DungeonDragonRewardItem, list, LoopScrCon.Horizontal)
	}else{
		this.array_reward .replaceAll(list)
	}
}

public DeleteMe(){ 
	
	this.dun_cfg = null
	if (this.array_reward ) {
		this.array_reward.DeleteMe()
		this.array_reward = null
	}
	super.DeleteMe()
}

_img_bg:Laya.Image
_lb_desc0:Laya.Label
_lb_desc1:Laya.Label
Content:Laya.List
_btn_go:Laya.Box
_Image1:Laya.Image
labelDisplay:Laya.Label
public GetComponents() {
[
this._img_bg,
this._lb_desc0,
this._lb_desc1,
this.Content,
this._btn_go,
this._Image1,
this.labelDisplay,
]
 = this.GetChildrenByNames([

"_img_bg",
"_lb_desc0",
"_lb_desc1",
"Content",
"_btn_go",
"_Image1",
"labelDisplay",
])
}
}
 window["DungeonDragonTipsItem"]= DungeonDragonTipsItem