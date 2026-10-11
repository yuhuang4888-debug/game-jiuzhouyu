import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType, EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { MapModel } from "../commonModel/MapModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { Config } from "../common/Config";
import { Util, SetAnchoredPosition, SetSizeDelta, GetSizeDeltaX, GetSizeDeltaY, SetLocalScale } from "../util/Util"
import { GameResPath } from "../util/GameResPath"
import { DressModel } from "../commonModel/DressModel"

export class WorldMapItem extends BaseItem1 {
anim_list
city_img
city_lv:Laya.HTMLDivElement
city_map_group
city_name
data
label_con
location
lv_bg
model
needRefresh
_Image1:Laya.Image
headIcon

totalMask

public constructor(parent?){
super(parent) 
	
	
	this.base_file = "map"
	this.layout_file = "WorldMapItem"
	this.anim_list = []
	this.model = MapModel.GetInstance()
	this.load_callback = () => {
		
		this.LoadSuccess()
		this.InitEvents()
		// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
		// 	this.city_lv.size  = 16
		// 	SetSizeDeltaX(this.lv_bg, 205)
		// }
	}
	
	
}

public RemoveAni(){ 
	
	if (this.anim_list && this.anim_list.length > 0 ) {
		for (let i = 0; i < this.anim_list.length; i++) {
			var v = this.anim_list[i]
			SYTweenLite.Stop(v)
		}
		this.anim_list = []
	}
}

public DeleteMe(){ 
	
	this.RemoveAni()
	super.DeleteMe()
}

public LoadSuccess(){ 
	
	
}
public InitEvents(){ 
	
	let click_fun = () => {
		if (this.data ) {
			let scene_mgr = SceneManager.GetInstance()
			if (this.data.open_state ) {
				if (scene_mgr.GetSceneId() != this.data.scene_id ) {
					if (scene_mgr.IsBossScene() ) {
						Message.show("在大妖中无法切换场景")
					} else if (scene_mgr.IsDungeonScene() ) {
						Message.show("在副本中无法切换场景")
					}else{
						if (this.data.scene_lv ) {
							if (RoleManager.GetInstance().mainRoleInfo.level >= Number(this.data.scene_lv[0]) ) {
								GlobalEventSystem.Fire(SceneEventType.REQUEST_CHANGE_SCENE, this.data.scene_id)
							}else{
								Message.show("等级不足，不能前往该场景")
								return
							}
						}
					}
				}
				GlobalEventSystem.Fire(EventName.CLOSE_MAP_VIEW, "MapEnterView")
			}else{
				Message.show("敬请期待~")
			}
		}
	}
	
	Util.AddClickEvent(this.city_map_group, click_fun, this, true)
	if (this.needRefresh ) {
		this.SetData(this.data)
	}
}

public SetData(data?){ 
	
	this.data = data
	if (this.is_loaded && this.data ) {
		if (this.data.root_pos ) {
			SetAnchoredPosition(this.display_obj,Number(this.data.root_pos[0]),Number(this.data.root_pos[1]))
		}
		let call_fun = () => {
			SetSizeDelta(this.city_img,GetSizeDeltaX(this.city_img) * 2,GetSizeDeltaY(this.city_img) * 2)
		}
		//lua_resM:SetOutsideImageSprite(this, this.city_img, GameResPath.GetIcon("dailySign","uiqd_006"), true)
		ResManager.GetInstance().SetOutsideImageSprite(this, this.city_img, "resource/game/map/world_map_img/" + this.data.img_source + ".png",true,call_fun)
		SetLocalScale(this.city_img,0.6)
		this.label_con.visible = this.data.open_state == true  
		if (this.data.open_state ) {
			this.city_name.text = this.data.scene_name
			if (this.data.scene_lv ) {
				this.city_lv.style.color = "#661c1c";
                this.city_lv.style.fontSize = 22;
				this.city_lv.style.strokeColor = "#FFFFFF";
				this.city_lv.style.stroke = 2;
				this.city_lv.style.bold=true
				// [ts2lua]lua中0和空字符串也是true，此处this.data.scene_lv[0] > 370 && this.data.scene_lv[0] < 999需要确
				let level = (this.data.scene_lv[0] > 370 && this.data.scene_lv[0] < 999) && "神创" + "<font color='#08a04c'>"+(this.data.scene_lv[0] - 370)+"</font>" || "Lv." +"<font color='#08a04c'>"+ this.data.scene_lv[0]+"</font>"
				// [ts2lua]lua中0和空字符串也是true，此处this.data.scene_lv[1] > 370 && this.data.scene_lv[1] < 999需要确认
				let lv = (this.data.scene_lv[1] > 370 && this.data.scene_lv[1] < 999) && "神创" +"<font color='#08a04c'>"+ (this.data.scene_lv[1] - 370)+"</font>" ||"<font color='#08a04c'>"+ this.data.scene_lv[1]+"</font>"
				this.city_lv.innerHTML = level + (" - ") + lv
				this.city_lv.width=500;
				this.city_lv.x=this.label_con.width/2-this.city_lv.contextWidth/2
			}
			this.location.visible = SceneManager.GetInstance( ).GetSceneId() == this.data.scene_id
			//设置头像
			if(this.location.visible){
				let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()

				//let pic_res = GameResPath.GetHeadPath(picture_cfg.resource)
				let picture_source =  DressModel.GetInstance().getHeadICon(main_role_vo.picture, main_role_vo.career)
				ResManager.GetInstance().SetImageSprite(this, this.headIcon,"head", picture_source)
				//ResManager.GetInstance().SetTexture(this, this.headIcon, pic_res)
				this.headIcon.x=-3;
				this.headIcon.y=-10;
				//设置遮罩
				this.totalMask = new Laya.Sprite()
				this.location.addChild(this.totalMask)
				this.totalMask.graphics.clear()
				let pie=this.totalMask.graphics.drawRect(10,15,60,70,"#FFFFFF")
				this.headIcon.mask = this.totalMask
				this.totalMask.visible=false;
				
			}
			if (this.location.visible && this.data.locate_pos ) {
				SetAnchoredPosition(this.location,Number(this.data.locate_pos[0]),Number(this.data.locate_pos[1]))
				this.PlayAnimation()
			}else{
				this.RemoveAni()
			}
			// if (this.data.label_con_pos ) {
			// 	SetAnchoredPosition(this.label_con,Number(this.data.label_con_pos[0]),Number(this.data.label_con_pos[1])) 
			// }
		}
	}else{
		this.needRefresh = true
	}
}

public PlayAnimation(){ 
	
	if (this.location ) {
		table.insert(this.anim_list,SYTweenLite.to(this, this.location, SYTweenLite.UiAnimationType.ANCHORED_POSY, this.location.y - 30,0.5,null, SYTweenFunc.PINGPONG,true))
	}
}

	public GetComponents() {
		[
			this.city_map_group,
			this.city_img,
			this.label_con,
			this.city_name,
			this._Image1,
			this.city_lv,
			this.location,
			this.headIcon
		]
			= this.GetChildrenByNames([

				"city_map_group",
				"city_img",
				"label_con",
				"city_name",
				"_Image1",
				"city_lv",
				"location",
				"headIcon"
			])
	}
}
window["WorldMapItem"] = WorldMapItem