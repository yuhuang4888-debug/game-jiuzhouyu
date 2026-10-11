import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { achvModel } from "../commonModel/achvModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"

export class AchvTotalItem extends BaseItemRenderer {
cfg
desLb
model
receiveBtn
receivedImg
reddot
reward
rewardGp
titleLb
unfinishLb
_Image1:Laya.Image
_Image2:Laya.Image
_Image11:Laya.Image
labelDisplay:Laya.Label
_Image3:Laya.Image


public static width = 680
public static height = 140

public WIDTH=680
public HEIGT=140

public constructor(parent){
super() 
	
	this.model = achvModel.GetInstance();
	this.base_file = "achv"
	this.layout_file = "AchvTotalItem"
	this.Load()

	
}

public load_callback(){
	let g_modle = GoodsModel.GetInstance()
	let AM = achvModel
	let local_BaseAwardItem = BaseAwardItem
	let e_model = ErlangParser.GetInstance()
	
	if (PlatformManager.IsEyouEnPlatform ) {
		this.unfinishLb.size  = 18
	}
	if (! this.reward ) {
		this.reward =  new local_BaseAwardItem(this.rewardGp)
		//this.reward.SetMaskId(1)
		this.reward.Load()
		this.reward.SetScale(0.7)
	}
	Util.AddClickEvent(this.receiveBtn,() => {
			if (! g_modle.CheckEquipNum(5, 5) ) {
				return
			}
			if (this.data ) {
				this.model.Fire(AM.REQUEST_PROTO, 40905, "i", this.data.id)
				if (this.cfg ) {
					this.model.Fire(AM.REQUEST_PROTO, 40909, "h", this.cfg.category)
					//GlobalEventSystem.Fire(EventName.REWARD_FLY, e_model.Parse(this.cfg.reward), UILocalToCanvasPoint(this.rewardGp, co.TableXY(0, 1), co.TableXY(0, 1)))
					GlobalEventSystem.Fire(EventName.REWARD_FLY, e_model.Parse(this.cfg.reward),this.rewardGp.localToGlobal(new Laya.Point(0,0)))
				}
			}
		}
		, this, true)
}

public dataChanged(){
	if(!super.dataChanged())return
	this.desLb.style.color="#5a1c20"
	this.desLb.style.fontSize = 24;
	if(!this.reward){
		this.reward =  new BaseAwardItem(this.rewardGp)
		//this.reward.SetMaskId(1)
		this.reward.Load()
		this.reward.SetScale(0.7)
	}
	let g_modle = GoodsModel.GetInstance()
	let e_model = ErlangParser.GetInstance()
	let local_Config = Config
	if (super.dataChanged() ) {
		ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "config_achievement",false,undefined,(cfgs)=>{
			let achievement_cfg =cfgs
			this.cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_achievement.name, this.data.id, false, achievement_cfg)
			console.log("achvtotalItem: "+this.cfg)
			if (this.cfg ) {
				
				this.desLb.innerHTML = this.cfg.desc
				if(PlatformManager.IsEyouPlatform()){
					this.desLb.style.wordWrap = true
					this.desLb.style.leading = 0.1
					this.desLb.style.width=320
				}else{
				this.desLb.style.width=1200;
				}
				let diamondReward = e_model.Parse(this.cfg.reward)
				if (diamondReward && diamondReward[0] ) {
					// let goodsInfo = g_modle.GetMappingTypeId(diamondReward[0][0], diamondReward[0][1])
					let goods_id = g_modle.GetMappingTypeId(diamondReward[0][0], diamondReward[0][1])
					let goodsbasic = g_modle.GetGoodsBasicByTypeId(goods_id[0])
					this.reward.SetData(goodsbasic.type_id, diamondReward[0][2])
				}
			}
			if (this.model.clientCfg ) {
				// [ts2lua]this.model.clientCfg下标访问可能不正确
				this.titleLb.text = this.model.clientCfg[this.data.id]
			}
			if (this.data ) {
				let status = this.data.status
				this.unfinishLb.visible = status == 0 
				this.receiveBtn.visible = status == 1 
				this.reddot.visible = this.receiveBtn.visible 
				this.receivedImg.visible = status == 2 
				if (this.cfg ) {
					let condition = e_model.Parse(this.cfg.condition)
					if (condition && condition[0] ) {
						let color = "#0a953e"
						if (status == 0 ) {
							color = "#ff4f50"
						}
						if(PlatformManager.IsEyouPlatform()){
							this.desLb.innerHTML = Util.StrToHTML(this.cfg.desc+"<br>" + "(<font color='" + color + "'>" + this.data.progress + "</font><font color='#0a953e'>/" + condition[0][1] + ")</font>")
							this.desLb.style.wordWrap = true
							this.desLb.style.leading = 0.1
							this.desLb.style.width=320
						}else{
							this.desLb.innerHTML = Util.StrToHTML(this.cfg.desc + "(<font color='" + color + "'>" + this.data.progress + "</font><font color='#0a953e'>/" + condition[0][1] + ")</font>")
							this.desLb.style.width=1200;
						}
					}
				}
			}

		});
	 }
}


public DeleteMe(){ 
	
	if (this.reward ) {
		this.reward.DeleteMe()
		this.reward = null
	}
	super.DeleteMe()
}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.receivedImg,
			this.rewardGp,
			this.titleLb,
			this.desLb,
			this.receiveBtn,
			this._Image11,
			this.labelDisplay,
			this.unfinishLb,
			this._Image3,
			this.reddot,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"receivedImg",
				"rewardGp",
				"titleLb",
				"desLb",
				"receiveBtn",
				"_Image11",
				"labelDisplay",
				"unfinishLb",
				"_Image3",
				"reddot",
			])
	}
}
window["AchvTotalItem"] = AchvTotalItem