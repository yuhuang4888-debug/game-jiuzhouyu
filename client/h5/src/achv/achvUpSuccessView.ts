import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { WordManager } from "../common/WordManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class achvUpSuccessView extends BaseView1{
LoadSuccess
OpenCallback
PropCfg
click_bg_toClose
destroy_callback
destroy_imm
fight_label
is_center
lv
lv_img
lv_name_label
not_show_attr_main_msg
preload_server_config
prop_label
prop_label0
rM
right_bg
right_group
use_background
total_group:Laya.Box
_Image1:Laya.Image
_Image2:Laya.Image
_Image3:Laya.Image
_Scroller1:Laya.Panel
Content:Laya.HBox
effect_group0:Laya.Box
_Group2:Laya.Box
effect_group:Laya.Box
_Image4:Laya.Image
_Label1:Laya.Label


public constructor(){
super() 
	
	this.base_file = "achv"
	this.layout_file = "achvUpSuccessView"
	this.layer_value = Enum_UILayer.Activity
	this.use_background = true
	this.click_bg_toClose = true
	this.not_show_attr_main_msg = true
	this.destroy_imm = true
	this.is_center = true
	
	let local_laya = Laya
	let sound_mgr = SoundManager.GetInstance()
	let local_Erlang = ErlangParser.GetInstance()
	let local_WordManager = WordManager
	this.load_callback = () => {
		
		this.LoadSuccess()
	}
	
	this.destroy_callback = () => {
		// if (this.right_group ) {
		// 	Laya.Tween.removeTweens(this.right_group)
		// }
		// if (this.effect_group ) {
		// 	this.ClearUIEffect(this.effect_group)
		// }
		// if (this.effect_group0 ) {
		// 	this.ClearUIEffect(this.effect_group0)
		// }
		this.PropCfg = null
	}
	
	 this.preload_server_config = {"config_achievement_star_reward":false}
	this.LoadSuccess = () => {
		this.PropCfg =ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement_star_rewards", false)
		// this.rM = local_laya. new Shape()
		// this.rM.graphics.beginFill("#ffffff", 1)
		// this.rM.graphics.drawRect(278, 25, 402, 300)
		// this.total_group.addChild(this.rM)
		// this.right_group.mask = this.rM
		// sound_mgr.PlaySoundEffect("1_jiesuan")
		if (this.PropCfg ) {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.right_bg, GameResPath.GetIcon("achv","uijs_068"))
			this.OpenCallback()
		}
	}
	
	
	this.OpenCallback = () => {
		if (this.lv && this.PropCfg ) {
			// [ts2lua]this.PropCfg下标访问可能不正确
			let cur_cfg = this.PropCfg[this.lv]
			// [ts2lua]this.PropCfg下标访问可能不正确
			let before_cfg = this.PropCfg[this.lv - 1]
			if (cur_cfg && before_cfg ) {
				this.lv_name_label.text = cur_cfg.name
				ResManager.GetInstance().SetImageSprite(this, this.lv_img, "achv","image_" + cur_cfg.pic )
				let propData = local_Erlang.Parse(cur_cfg.reward)
				let beforeData = local_Erlang.Parse(before_cfg.reward)
				let propStr = null
				let addStr = null
				if (propData && beforeData ) {
					let i = 0
					do {
						if (propData[i] ) {
							propStr = propStr + "<font color=0xffe65a>" + local_WordManager.GetProperties(propData[i][0]) + " " + propData[i][1] + "</font>"
							if (beforeData[i] ) {
								addStr = addStr + ("<font color=0xb3ff48> + ") + (propData[i][1] - beforeData[i][1]) + "</font>"
							}else{
								addStr = addStr + ("<font color=0xb3ff48> + ") + propData[i][1] + "</font>"
							}
							if (i < propData.length - 1 ) {
								propStr = propStr + "\n"
								addStr = addStr + "\n"
							}
						}
						i=i+1
					} while ((i < propData.length))
					this.fight_label.text = "z" + Util.CalAttrPower(propData, false)
				}
				this.prop_label.textFlow = Util.StrToHTML(propStr)
				this.prop_label0.textFlow = Util.StrToHTML(addStr)
			}
			// Laya.Tween.get(this.right_group):to({x=278}, 300).call(() => {
			// 		if (this.right_group ) {
			// 			Laya.Tween.removeTweens(this.right_group)
			// 		}
			// 	}
			// )
			let id = SYTweenLite.to(this, this.right_group, SYTweenLite.UiAnimationType.POSX, 278, 0.3)

			// this.AddUIEffect2("ui_badge_glow", this.effect_group, null, null, true)
			// this.AddUIEffect2("ui_badge_Scintillation", this.effect_group0, null, null, true)
		}
	}
}


public Open(lv?){
	this.lv = lv
	// super.Open()
	super.Open()
}

	public GetComponents() {
		[
			this.total_group,
			this.right_group,
			this.right_bg,
			this.fight_label,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Scroller1,
			this.Content,
			this.prop_label,
			this.prop_label0,
			this.effect_group0,
			this._Group2,
			this.effect_group,
			this.lv_img,
			this._Image4,
			this.lv_name_label,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"total_group",
				"right_group",
				"right_bg",
				"fight_label",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Scroller1",
				"Content",
				"prop_label",
				"prop_label0",
				"effect_group0",
				"_Group2",
				"effect_group",
				"lv_img",
				"_Image4",
				"lv_name_label",
				"_Label1",
			])
	}
}
window["achvUpSuccessView"] = achvUpSuccessView