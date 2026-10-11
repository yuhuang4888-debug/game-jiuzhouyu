import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { achvModel } from "../commonModel/achvModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { SetSizeDeltaX, SetAnchoredPosition } from "../util/Util"


export class AchvChildItem extends BaseItem1 {
ImgWith
SetInfo
SetSchedule
data
expMask
info
model
nameLb
scheduleImg
scheduleLb
typeImg
_Image1:Laya.Image
needRefresh
	
public constructor(parent?){
super(parent) 
	
	this.ImgWith = 174;
	this.model = achvModel.GetInstance();
	this.base_file = "achv"
	this.layout_file = "AchvChildItem"
	let local_laya = Laya
	this.needRefresh=false

	this.load_callback = () => { 
		
		if (PlatformManager.IsEyouEnPlatform() ) {
			this.nameLb.size  = 14
		}
		if (PlatformManager.IsEyouEnPlatform() ) {
			this.nameLb.size  = 12
			this.nameLb.lineSpacing = 0.8
			let csf = this.nameLb.GetComponent("ContentSizeFitter")
			//csf.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained
			SetSizeDeltaX(this.nameLb,89.74)
			SetAnchoredPosition(this.nameLb,43, -9)
		}
		if(this.needRefresh){
			this.SetSchedule(this.data)
		}
		// ResManager.GetInstance().SetTexture(this,this.scheduleImg,GameResPath.GetIcon("achv","ui_pro_bar_3"))
	}

	this.SetInfo = ( info?) => {
		if (info ) {
			this.info = info
			this.nameLb.text = this.info.desc
			// this.typeImg.source = "achv_asset.uicj_0" + (14 + info.id) + ""
			// ResManager.GetInstance().SetImageSprite(this, this.typeImg, "achv_asset", "uicj_0" + (14 + info.id))
			this.typeImg.skin=GameResPath.GetIcon("achv","uicj_0" + (14 + info.id))
		}
	}

	this.SetSchedule = ( data?) => {
		if (data ) {
			this.data = data
			if(this.is_loaded){
				this.scheduleLb.text = data.now_star + "/" + data.total_star
				let length=this.ImgWith * Math.min(data.now_star / data.total_star, 1)
				if(length<10){
					this.scheduleImg.x=133
				}else if(length>5 && length<100){
					this.scheduleImg.x=130
				}else{
					this.scheduleImg.x=126
				}
				if (length == 0 ) {
					SetSizeDeltaX(this.scheduleImg, 0)
				}else{
					SetSizeDeltaX(this.scheduleImg, length)
				}
				this.needRefresh=false
			}else{
				this.needRefresh=true
			}
		}
	}
}


	public DeleteMe(){
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.typeImg,
			this.nameLb,
			this._Image1,
			this.scheduleImg,
			this.scheduleLb,
		]
			= this.GetChildrenByNames([

				"typeImg",
				"nameLb",
				"_Image1",
				"scheduleImg",
				"scheduleLb",
			])
	}
}
window["AchvChildItem"] = AchvChildItem