import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { MapModel } from "../commonModel/MapModel"
import { PlatformManager } from "../PlatformManager"
import { SetLocalPositionX, SetLocalPositionY, Trim } from "../util/Util"

export class AreaMapPonitItem extends BaseItem1 {
data
desc
model
needRefresh
point

locationX
locationY

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "map"
	this.layout_file = "AreaMapPonitItem"
	this.model = MapModel.GetInstance()
	this.load_callback = () => {
		this.SetX(this.locationX)
		this.SetY(this.locationY)
		this.desc.lineSpacing = 1
		if (PlatformManager.IsEyouEnPlatform() ) {
			this.desc.lineSpacing = 0.7
		}
		this.LoadSuccess()
		this.InitEvents()
	}
	
	
}

public LoadSuccess(){ 
	 }
public InitEvents(){ 
	
	if (this.needRefresh ) {
		this.SetData(this.data)
	}
}

public SetX(x?){
	if(this.is_loaded){
		SetLocalPositionX(this.display_obj,x)
	}else{
		this.locationX=x
	}
}

public SetY(y?){
	if(this.is_loaded){
		SetLocalPositionY(this.display_obj,y)
	}else{
		this.locationY=y
	}
}

public SetData(data?){ 
	
	this.data = data
	if (this.is_loaded && this.data ) {
		if (this.data.is_npc ) {
			// [ts2lua]Config.PRELOAD_SETVER_CONFIG.config_npc下标访问可能不正确
			let npc_cfg = Config.PRELOAD_SERVER_CONFIG.config_npc[this.data.mon_id];
			// [ts2lua]lua中0和空字符串也是true，此处npc_cfg需要确认
			this.desc.text = (npc_cfg && ( npc_cfg.name ) || ( "" ) )
		}else{
			let cfg_data = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.mon_id, false)
			if (cfg_data ) {
				this.desc.text = Trim(cfg_data.name) 
			}
		}
	}else{
		this.needRefresh = true
	}
}




	Image: Laya.Image
	public GetComponents() {
		[
			this.Image,
			this.point,
			this.desc,
		]
			= this.GetChildrenByNames([

				"Image",
				"point",
				"desc",
			])
	}
}
window["AreaMapPonitItem"] = AreaMapPonitItem