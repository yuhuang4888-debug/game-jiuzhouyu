import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"

export class kfStageShowItem extends BaseItemRenderer {
	WIDTH = 295
	HEIGT = 23
	
	res_mgr
	cfg_icon

	public constructor() {
		super()
		this.base_file = "kfStart"
		this.layout_file = "kfStageShowItem"

		this.res_mgr = ResManager.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}
	
	public LoadSuccess() {
		this.cfg_icon = this.res_mgr.GetGameConfigFromCache(this, "ConfigKFuncIcon", true)
		
		this._lb_msg.style.fontSize = 20
		this._lb_msg.style.color = "#663915"
		this._lb_msg.style.wordWrap = false
	}

	protected dataChanged() {
		if (!super.dataChanged()) {
			return
		}
		let name = ""
		let mod = ""
		if(this.cfg_icon[this.data.module_id] && this.cfg_icon[this.data.module_id].name){
			name = this.cfg_icon[this.data.module_id].name
		}
		if(this.data.mod == 1){
			mod = "本"
		} else {
			mod = this.data.mod
		}
		this._lb_msg.innerHTML = "<font color ='#00a23d'>【" + name + "】</font>进入<font color ='#00a23d'>" + mod + "服</font>阶段"
		this.CallLater(()=>{
			this._lb_msg.event(Laya.Event.RESIZE)
		})
	}

	_img_bg: Laya.Image
	_gp_con: Laya.HBox
	_lb_msg: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._gp_con,
			this._lb_msg,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_gp_con",
				"_lb_msg",
			])
	}
}
window["kfStageShowItem"] = kfStageShowItem