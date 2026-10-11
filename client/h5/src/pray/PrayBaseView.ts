import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { MainUIController } from "../commonController/MainUIController"
import { PrayModel } from "../commonModel/PrayModel"
import { MainUITopView } from "../mainUI/MainUITopView"
import { RoleManager } from "../commonModel/RoleManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Vector2 } from "../util/Vector2"
import  "./PrayMainView"
import { InstructionType } from "../common/InstructionType"

export class PrayBaseView extends BaseWindowComponent {
_Local_Close
destroy_imm
initEvent
money_list
tabStrList
titleStr
viewClassList
window_load_back

PrayMainView

public constructor(){
super() 
	
	this.tabStrList = [{label:"祈愿", icon_up_source:"pray_asset.uibqy_icon2", icon_down_source:"pray_asset.uibqy_icon1"}]
	this.viewClassList = ["PrayMainView"]
	this.titleStr = "pray.uiqy_001"
	//this.money_list = [2, 1, 0]
	this.destroy_imm = true
	let local_GlobalEventSystem = GlobalEventSystem
	let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
	let pray_model = PrayModel.GetInstance()
	let local_PrayModel = PrayModel
	let layer_mgr = LayerManager.GetInstance()
	let local_laya = Laya
	let _effect_list = []
	this.destroy_imm=true
	this.window_load_back = () => {
		this.initEvent()
		local_GlobalEventSystem.Fire(update_window_red_event, "PrayBaseView", 0, pray_model.IsShowRed())
	}
	this.instruction_list = [
		InstructionType.Pray
	]
	
	this.initEvent = () => {
		let event_callback = (bool?) => {
			local_GlobalEventSystem.Fire(update_window_red_event, "PrayBaseView", 0, bool)
		}
		
		this.BindEvent(pray_model, local_PrayModel.SHOW_RED, event_callback)
		this.BindEvent(pray_model, local_PrayModel.PLAY_ANIME,(...new_args) => {
			let args=new_args
			for (let i = 0; i < 4; i++) {
				let effect = new Laya.Box()
				effect.x = args[1].x + (i < 2 ? i == 0 ? -100 : 100 : 0)  //+ Math.abs(this.localToGlobal().x)
				effect.y = args[1].y + (i < 2 ? 0 : i == 2 ? -100 : 100)//+ Math.abs(this.localToGlobal().y)
				let top_layer = layer_mgr.GetUILayer(Enum_UILayer.Top)
				top_layer.addChild(effect)
				_effect_list.push(effect)
				let url = args[0] == 1 ? "ui_supplication_yellow" : "ui_supplication_green"
				this.AddUIEffect(url, effect, undefined, undefined, false, undefined, undefined, undefined, undefined, true)
				let roleInfo = RoleManager.GetInstance().mainRoleInfo
				let percent = roleInfo.exp < roleInfo.exp_lim ? roleInfo.exp / roleInfo.exp_lim : 1
				let main_ui_top_view_pos: any =MainUIController.GetInstance().main_ui_top_view.GetMoneyPos(0)
				let pos = args[0] == 1 ? new Vector2(main_ui_top_view_pos.x + 10, main_ui_top_view_pos.y + 10) : new Vector2(top_layer.width * percent, top_layer.height - 5)
				let time=args[0] == 1 ? 300 : 450
				Laya.Tween.to(effect,{ x: pos.x, y: pos.y }, time,Laya.Ease.circOut,Laya.Handler.create(this,()=>{
					if (!effect) return
					Laya.Tween.clearTween(effect)
					url = args[0] == 1 ? "ui_supplication_boomyellow" : "ui_experience_particle3"
					this.AddUIEffect(url, effect, undefined, undefined, undefined, undefined, () => {
						Laya.Tween.clearTween(effect)
					}, undefined, undefined, true)
				})

				)
			}
			}
		)
	}
	
	this._Local_Close = () => {
		if (_effect_list.length > 0 ) {
			for (let _tmpi in _effect_list) {
				var effect = _effect_list[_tmpi]
				//local_laya.Tween.removeTweens(effect)
				let top_layer = layer_mgr.GetUILayer(Enum_UILayer.Top)
				top_layer.removeChild(effect)
			}
			_effect_list = []
		}
	}
	
	
}

public Close(){ 
	
	//this:_Local_Close()
	super.Close()
}
}

window["PrayBaseView"]=PrayBaseView
