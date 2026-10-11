import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Util } from "../util/Util";
import { EveningChatItem } from "./EveningChatItem";

export class EveningDragonItem extends EveningChatItem {

	public constructor(parent?) {
		super(parent)
	
		this.base_file = "evening"
		this.layout_file = "EveningChatItem"
		this.load_callback=()=>{
			// Util.AddClickEvent(this,() => {
			// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "EveningIntroView", 2)
			// }
			// , this)
		}
	}
	

	
	public SetData(data?){ 
		
		// [ts2lua]lua_resM:GetGameConfigFromCache(this, "Gfeast", false)下标访问可能不正确
		// [ts2lua]lua_resM:GetGameConfigFromCache(this, "Gfeast", false)[29]下标访问可能不正确
		let max = ResManager.GetInstance().GetGameConfigFromCache(this, "Gfeast", false)[29]["value"]
		//this._lb_count.textFlow = Util.StrToHTML(data.dragon_spirit + "/" + max)
		let awake = data.dragon_spirit >= max
		// [ts2lua]lua中0和空字符串也是true，此处awake需要确认
		// this._img_tips.source = (awake && ( "uighyh_010b" ) || ( "uighyh_010" ) )
	//	ResManager.GetInstance().SetImageSprite(this, this._img_tips, "evening_asset", (awake && ( "uighyh_010b" ) || ( "uighyh_010" ) ))
		// [ts2lua]lua中0和空字符串也是true，此处awake需要确认
		//this._lb_tips.text = (awake && ( "苏醒" ) || ( "沉睡" ) )
	}

}






window["EveningDragonItem"] = EveningDragonItem