import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { SceneManager } from "../scene/SceneManager"
import { SetSizeDeltaY } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { DungeonPolarChatItem } from "./DungeonPolarChatItem"

export class DungeonPolarChatView extends BaseView1 {
LoadSuccess
_localPoint
_model
background_alpha
click_bg_toClose
initView
item_list
open_mode
use_background



public constructor(){
super() 
	

	this.base_file = "dungeonPolar"
	this.layout_file = "DungeonPolarChatView"
	this.layer_value = Enum_UILayer.Activity
	this.open_mode = OpenMode.OpenToggle
	this._model = BaseDungeonModel.GetInstance()
	this.use_background = true
	this.click_bg_toClose = true
	this.background_alpha = 0
	this.item_list = []
	this.preload_client_config={"ClientDunWeekendMsg":false}
	let _scene_mgr = SceneManager.GetInstance()
	this.load_callback = () => {
		this.LoadSuccess()
	}

	this.LoadSuccess = () => {
		this.initView()
	}

	this.initView = () => {
		let cell_height=50
		let total_height=0

		let cfg = ResManager.GetInstance().GetGameConfigFromCache(this,"ClientDunWeekendMsg",true)//Config.ClientDunPolarMsg
		let msg_list_cfg = cfg["CHAT_MSG"]
		let dun_id = _scene_mgr.GetCurrDunId()
		let msg_list = msg_list_cfg[dun_id]||msg_list_cfg["default"]
		if (msg_list ) {
			let index = 0

			

			for (let key in msg_list) {
				let msg = msg_list[key]
				let item = this.item_list[index]
				if (! item ) {
					item =  new DungeonPolarChatItem(this._gp_content)
					item.Load()
					table.insert(this.item_list, item)
				}
				item.setData(msg)
				index=index+1
			}	
			
			total_height=cell_height*index+(index-1)*this._gp_content.space

			SetSizeDeltaY(this._img_bg ,total_height + 25 )
		}

		SetSizeDeltaY(this.display_obj ,total_height + 20 )
		this._Image1.y=total_height+20
		this.display_obj.pos(this._localPoint.x-20,this._localPoint.y-total_height-70)
	}

}





public DeleteMe(){ 
	for (let key in this.item_list) {
		let item = this.item_list[key]
		item.DeleteMe()
	}
	this.item_list = []
	super.DeleteMe()
}

public Open(...new_args){ 
	let parms = new_args
	this._localPoint = parms[0]
	if (this.is_loaded ) {
		this.initView()
	}
	super.Open()
}

_img_bg:Laya.Image
_gp_content:Laya.VBox
_Image1:Laya.Image
public GetComponents() {
[
this._img_bg,
this._gp_content,
this._Image1,
]
 = this.GetChildrenByNames([

"_img_bg",
"_gp_content",
"_Image1",
])
}
}
 window["DungeonPolarChatView"]= DungeonPolarChatView