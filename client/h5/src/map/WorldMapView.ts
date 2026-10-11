import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { MapModel } from "../commonModel/MapModel"
import { SceneManager } from "../scene/SceneManager"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDelta, GetSizeDeltaX, GetSizeDeltaY } from "../util/Util"
import { WorldMapItem } from "./WorldMapItem"

export class WorldMapView extends BaseItem1 {
InitEvents
LoadSuccess
Local_DeleteMe
Scrscroll
SetData
frame_bg
map
map_bg
map_cloud :Laya.Image
scene_con
scroll
scroll_group

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "map"
	this.layout_file = "WorldMapView"
	let model = MapModel.GetInstance()
	this.preload_client_config = {
		"ClientWorldMapConfig": false
	}
	let local_Number = Number
	let map_item_list_ = []
	this.load_callback = () => {
		
		this.LoadSuccess()
		this.InitEvents()
	}

	this.Local_DeleteMe = () => {
		for (let _tmpi in map_item_list_) {
			var item = map_item_list_[_tmpi]
			item.DeleteMe()
			item = null
		}
		map_item_list_ = []
	}
	
	this.LoadSuccess = () => {
		ResManager.GetInstance().SetOutsideImageSprite(this, this.map_bg, GameResPath.GetIconJpg("map","big_bg"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.map_cloud, GameResPath.GetIcon("map","cloud"))
		// ResManager.GetInstance().SetOutsideImageSprite(this, this.frame_bg, GameResPath.GetIcon("map","uidt_003"))
		this.map_cloud.sizeGrid="82,178,82,62"
		SetSizeDelta(this.map,1870,1005)
		SetSizeDelta(this.map_bg,1870,1005)
	}
	
	this.InitEvents = () => {
		this.SetData()
	}
	

	this.SetData = () => {
		if (this.is_loaded ) {
			let now_scene_id = SceneManager.GetInstance().GetSceneId()
			let initail_pos = null
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientWorldMapConfig", true)
			if (cfg && cfg.world_map ) {
				let item = null
				let vo = null
				for(let key in cfg.world_map){
					vo = cfg.world_map[key]
					item = map_item_list_[key]
					if (! item ) {
						item =  new WorldMapItem(this.scene_con)
						item.Load()
						map_item_list_[key] = item
					}
					item.SetData(vo)
					if (vo.scene_id == now_scene_id ) {
						initail_pos = vo.root_pos
					}
				}
			}
			if (initail_pos ) {
				let pos_x = local_Number(initail_pos[0])
				let pos_y = local_Number(initail_pos[1])
				Laya.timer.once(100,this,()=>{
					if (this.use_delete_method) return
					this.scroll.hScrollBar.value=initail_pos[0]-300
				})
				// if (pos_x > GetSizeDeltaX(this.scroll) / 2 ) {
				// 	let need = pos_x - GetSizeDeltaX(this.scroll) / 2
				// 	let gap = GetSizeDeltaX(this.map_bg) - GetSizeDeltaX(this.scroll)
					//if (gap <= need ) {
						//this.scroll_group.scrollH = gap
					//}else{
						//this.scroll_group.scrollH = need
					//}
				// }
				// let pos_y = local_Number(initail_pos[1])
				// if (pos_y > GetSizeDeltaY(this.scroll) / 2 ) {
				// 	let need2 = pos_y - GetSizeDeltaY(this.scroll) / 2
				// 	let gap2 = GetSizeDeltaX(this.map_bg) - GetSizeDeltaY(this.scroll)
				// 	//if (gap2 <= need2 ) {
				// 		//this.scroll_group.scrollV = gap2
				// 	//}else{
				// 		//this.scroll_group.scrollV = need2
				// 	//}
				// }
			}
		}
	}
	
	
}
public DeleteMe(){ 
	
	this.Local_DeleteMe()
	super.DeleteMe()
}


	public GetComponents() {
		[
			this.scroll,
			this.map,
			this.map_bg,
			this.map_cloud,
			this.scene_con,
			this.frame_bg,
		]
			= this.GetChildrenByNames([

				"scroll",
				"map",
				"map_bg",
				"map_cloud",
				"scene_con",
				"frame_bg",
			])
		this.scroll.hScrollBarSkin=""
	}
}

window["WorldMapView"]=WorldMapView