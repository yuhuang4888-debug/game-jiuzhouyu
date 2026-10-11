import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { SettingModel } from "../commonModel/SettingModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { GetMaterialTexture, Util } from "../util/Util"

export class SettingHeadItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_img_take_photo: Laya.Image
	role_head: Laya.Box
	_img_role_head: Laya.Image
	_img_frame: Laya.Image
	_Group1: Laya.Box
	_Image2: Laya.Image
	_lb_name: Laya.HTMLDivElement
	_img_select: Laya.Image
	use_tag: Laya.Image
	is_take_photo
	manager
	model
	select_event_id
	public static width = 150
	public static height = 170

	public constructor(parent) {
		super()

		this.base_file = "setting"
		this.layout_file = "SettingHeadItem"
		this.WIDTH=143
		this.HEIGT=163
		this.manager = RoleManager.GetInstance()
		this.model = SettingModel.GetInstance()
		// this.skinName="resource/game/setting/exml/SettingHeadItemExml.exml"
		// this.load_callback = () => { 

		// 	// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	// 	this._lb_name.size  = 14
		// 	// }
		// this.InitEvent()
		// }
		this.Load()
	}

	public load_callback() {

		//super.createChildren()
		this.select_event_id = this.model.Bind(SettingModel.SELECT_HEAD_IMG_ITEM, (id?) => {
			if (this.data && this.data.id == id) {
				this.model.select_head_id = id
				this.SetSelect(true)
			} else {
				this.SetSelect(false)
			}
		}
		)
		Util.AddClickEvent(this.role_head, () => {
			if (this.data) {
				if (this.is_take_photo) {
					this.manager.Fire(EventName.REQUEST_ROLE_PROTO, 13082)
				} else {
					this.model.Fire(SettingModel.SELECT_HEAD_IMG_ITEM, this.data.id)
				}
			}
		}
			, this)
		Util.AddClickEvent(this._Image1, () => {
			if (this.data) {
				if (this.is_take_photo) {
					this.manager.Fire(EventName.REQUEST_ROLE_PROTO, 13082)
				} else {
					this.model.Fire(SettingModel.SELECT_HEAD_IMG_ITEM, this.data.id)
				}
			}
		}
			, this)
		Util.AddClickEvent(this._img_select, () => {
			if (this.data) {
				if (this.is_take_photo) {
					this.manager.Fire(EventName.REQUEST_ROLE_PROTO, 13082)
				} else {
					this.model.Fire(SettingModel.SELECT_HEAD_IMG_ITEM, this.data.id)
				}
			}
		}
			, this)
	}

	public dataChanged() {
		if(!super.dataChanged()) return
		if (!this.data) {return }
		if(this.data.id==-1){
			this._img_frame.visible=false
			this._Image2.visible=false
			ResManager.GetInstance().SetImageSpriteTrans(this,this._img_role_head,GameResPath.GetIcon("setting","uightx_001"))
			// this.role_head.centerX=0
			// this.role_head.centerY=0
			this._lb_name.innerHTML="上传头像"
			this._lb_name.x=125/2-this._lb_name.contextWidth/2
			return
		}
		// if (! (next(this.data)) ) {
		// 拍照
		// this.is_take_photo = true
		// this._lb_name.textFlow = Util.StrToHTML("<font color=0x4A3A32>上传头像</font>")
		// this._img_take_photo.visible = true 
		// this.role_head.visible = false 
		// return
		// }
		this._lb_name.width=125
		this._lb_name.innerHTML = Util.StrToHTML("<font color='#4A3A32'>" + this.data.desc + "</font>")
		//this._lb_name.textColor = "#4A3A32"
		let activite = this.manager.HaveActiviteThisHead(this.data.id)
		if (activite) {
			// [ts2lua]this.manager.mainRoleInfo下标访问可能不正确
			// [ts2lua]this.manager.mainRoleInfo下标访问可能不正确
			if (this.data.id == Number(this.manager.mainRoleInfo["picture"]) || this.manager.mainRoleInfo["picture"] == "" && this.data.id == this.manager.mainRoleInfo.career) {
				this.use_tag.visible = true
				ResManager.GetInstance().SetImageSprite(this, this.use_tag, "setting_asset", "uixt_013", true)
				if (!this.model.select_head_id) {
					this.model.select_head_id = this.data.id
					this.SetSelect(true)
				}
			} else {
				this.use_tag.visible = false
			}
		} else {
			this.use_tag.visible = true
			ResManager.GetInstance().SetImageSprite(this, this.use_tag, "setting_asset", "uixt_012", true)
			let cost = JSON.parse(this.data.cost)
			if (cost) {
				if (cost[0] && cost[0][0] == "turn") {
					//this._lb_name.textColor = "#ff4f50"
					this._lb_name.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + cost[0][1] + "转获得</font>")
				}
			}
		}
		//to) { dxj this.role_head.setData(null, null, this.data.id)
		this._lb_name.x=125/2-this._lb_name.contextWidth/2
		ResManager.GetInstance().SetImageSprite(this, this._img_role_head,"head", this.data.resource)
		//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_role_head, GameResPath.GetHeadPath(this.data.resource))
	}

	public SetSelect(isSelect?) {

		this._img_select.visible = isSelect
	}

	public DeleteMe() {

		this.is_take_photo = null
		if (this.select_event_id) {
			this.model.UnBind(this.select_event_id)
			this.select_event_id = null
		}
		super.DeleteMe()
		//to) { dxj this.role_head.DeleteMe()
	}


	public GetComponents() {
		[
			this._Image1,
			this._img_take_photo,
			this.role_head,
			this._img_role_head,
			this._img_frame,
			this._Group1,
			this._Image2,
			this._lb_name,
			this._img_select,
			this.use_tag,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_take_photo",
				"role_head",
				"_img_role_head",
				"_img_frame",
				"_Group1",
				"_Image2",
				"_lb_name",
				"_img_select",
				"use_tag",
			])
		this._lb_name.style.fontSize=20
		this._lb_name.style.color="#4a3a32"
		this._lb_name.style.wordWrap = false

	}
}
window["SettingHeadItem"] = SettingHeadItem