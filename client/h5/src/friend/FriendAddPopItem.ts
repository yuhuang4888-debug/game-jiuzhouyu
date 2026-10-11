import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Util } from "../util/Util"

export class FriendAddPopItem extends BaseItem1 {
	_head_main
	_model
	_vo
	head
	height
	need_refreshData
	story_obj_list
	width

	_vip_icon
	_lb_name
	_lb_level
	_lb_fight
	addBtn
	haveAdd
	touchGroup
	clickGroup: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image


	public constructor(parent?) {
		super(parent)


		this.need_refreshData = false;
		this.base_file = "friend"
		this.layout_file = "FriendAddPopItem"
		this.height = 123
		this.width = 597
		this._model = FriendModel.GetInstance()
		this.load_callback = () => {
			// this._vip_icon
			// = GetChildImages(this.form, {
			// 		"clickGroup/_vip_icon"
			// 	})

			// this._lb_name,
			// this._lb_level,
			// this._lb_fight
			// = GetChildTexts(this.form, {
			// 		"clickGroup/_lb_name",
			// 		"clickGroup/_lb_level",
			// 		"clickGroup/_lb_fight"
			// 	})

			// //this.addBtn,
			// this.haveAdd,
			// this.touchGroup
			// = GetChildGameObjects(this.form, {
			// 		"clickGroup/addBtn",
			// 		"clickGroup/haveAdd",
			// 		"clickGroup/touchGroup"
			// 	})

			// this.head = this.GetChild("clickGroup/head")

			//if ((this._model.recommend_cache && this._model.recommend_cache[0]) && this._vo.role_id == this._model.recommend_cache[0].role_id ) {
			//this.story_obj_list = this.story_obj_list || {}
			//// [ts2lua]this.story_obj_list下标访问可能不正确
			//this.story_obj_list[TaskTipType.AddFriend] = []
			//// [ts2lua]this.story_obj_list下标访问可能不正确
			//// [ts2lua]this.story_obj_list[TaskTipType.AddFriend]下标访问可能不正确
			//this.story_obj_list[TaskTipType.AddFriend][this._model.recommend_cache[0].role_id] = ["", this.addBtn]
			//}
			this.InitEvent()

		}


	}


	public InitEvent() {

		let addClick = () => {
			if (!this._vo || !this._vo.role_id) { return }
			if (this._vo.role_id == RoleManager.GetInstance().GetMainRoleVo().role_id) {
				Message.show("无法添加自己为好友")
				return
			}
			let role_id = this._vo.role_id
			if (this._vo.is_faker) {
				role_id = 0
				this.haveAdd.visible = true
				this.addBtn.visible = false
			}
			this._model.Fire(FriendEvent.ADD_FRIEND, role_id)
		}
		Util.AddClickEvent(this.addBtn, addClick, this, true)
		if (this.need_refreshData) {
			this.SetData(this._vo)
			this.need_refreshData = false
		}
	}

	public SetData(vo?) {


		this._vo = vo
		if (this.is_loaded && this._vo) {
			this._lb_name.text = this._vo.role_name
			// [ts2lua]lua中0和空字符串也是true，此处this._vo.lv > 370需要确认
			let lv = this._vo.lv > 370 && "神创" + (this._vo.lv - 370) || "LV." + this._vo.lv
			this._lb_level.text = lv
			this._lb_fight.text = this._vo.combat_power
			let vip_Lv = this._vo.vip
			this._vip_icon.visible = vip_Lv > 0
			let str = null
			if (this._vip_icon.visible) {
				if(this._vo.vip_hide > 0){
					str = "VIP-x"
					if (this._vo.is_supvip == 1) {
						str = "SVIP-x"
					}
				}
				else{
					str = "uivip_zjm_" + vip_Lv
					if (this._vo.is_supvip == 1) {
						str = "VIP_" + vip_Lv
					}
				}
				if (this._vip_icon) {
					ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str)
				}
			// if (this._vip_icon.visible) {
			// 	let str = "uivip_zjm_" + vip_Lv
			// 	if(this._vo.is_supvip==1){
			// 		str="VIP_"+vip_Lv
			// 	}
			// 	ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", str)
			}
			let frame_id = DressModel.GetInstance().GetDressByType(this._vo.dress_list, DressType.Photo)
			//this._playerHead.setData(null, this._vo.career, this._vo.picture, null, null, frame_id)

			if (this._head_main == null) {
				this._head_main = new CustomHeadItem(this.head)
				this._head_main.Load()
			}
			this._head_main.SetRoleVoData(this._vo)

			this.haveAdd.visible = this._vo.applyFriend
			this.addBtn.visible = !this.haveAdd.visible
		} else {
			this.need_refreshData = true
		}
	}

	public DeleteMe() {

		if (this._head_main) {
			this._head_main.DeleteMe()
			this._head_main = null
		}
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this.clickGroup,
			this._Image1,
			this._lb_name,
			this._lb_level,
			this._lb_fight,
			this._Image2,
			this.addBtn,
			this.haveAdd,
			this._vip_icon,
			this.touchGroup,
			this.head,
		]
			= this.GetChildrenByNames([

				"clickGroup",
				"_Image1",
				"_lb_name",
				"_lb_level",
				"_lb_fight",
				"_Image2",
				"addBtn",
				"haveAdd",
				"_vip_icon",
				"touchGroup",
				"head",
			])
	}
}

window["FriendAddPopItem"] = FriendAddPopItem