import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class RankTabButton extends BaseItemRenderer {
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	redDisplay: Laya.Image


	public static width = 122
	public static height = 55
	public constructor(parent) {
		super()

		this.base_file = "rank"
		this.layout_file = "RankTabButton"
		this.WIDTH = 112
		this.HEIGT = 41
		// this.load_callback = () => {

		// 	if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 		this.labelDisplay.size  = 18
		// 	}
		// 	this.dataChanged()
		// }	
		this.Load()
	}

	public load_callback() {
		if (PlatformManager.IsEyouEnPlatform()) {
			this.labelDisplay.centerX =1
			this.labelDisplay.centerY = -1
			this.labelDisplay.width = 106
			this.labelDisplay.height = 36
			this.labelDisplay.wordWrap = true
			this.labelDisplay.leading = 0.1
			this.labelDisplay.fontSize = 18
		}
	}

	public dataChanged() {
		if(!super.dataChanged()) return 
		this.labelDisplay.text = this.data.rank_name
		// this.labelDisplay.fontSize = this.data.rank_name >= 5 && 22 || 24 // utf8len(this.data.rank_name) >= 5 && 22 || 24 
		// let url = this.selected && "uilt_008" || "uiphb_011b"
		// ResManager.GetInstance().SetImageSprite(this, this._Image1, "rank_asset", url, true)
		if(this.selected){
			this._Image1.skin=GameResPath.GetIcon("rank","com_rect_btn1")
			this.labelDisplay.strokeColor="#c95b37"
		}else{
			this._Image1.skin=GameResPath.GetIcon("rank","ui_button_mid_1")
			this.labelDisplay.strokeColor="#787878"
		}
	}

	public DeleteMe(){
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._Image1,
			this.labelDisplay,
			this.redDisplay,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"labelDisplay",
				"redDisplay",
			])
	}
}
window["RankTabButton"]=RankTabButton