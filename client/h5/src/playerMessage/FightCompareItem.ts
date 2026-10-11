import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { FightComTabItem } from "./FightComTabItem"

export class FightCompareItem extends BaseItem1 {
	InitView
	OpenItem
	bg1
	itemList
	p1Head
	p2Data
	p2Head

	Content
	p1_head
	p2_head
	p1Name
	p2Name
	fight_num1
	fight_num2
	fightGp: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Group1: Laya.Box
	_Image3: Laya.Image
	Image: Laya.Image
	_Group2: Laya.Box
	_Image4: Laya.Image
	Image1: Laya.Image
	tabScroller: Laya.Panel
	_img_role_1:Laya.Image
	_img_role_2:Laya.Image


	public constructor(parent?) {
		super(parent)

		this.base_file = "playerMessage"
		this.layout_file = "FightCompareItem"
		this.load_callback = () => {
			this.InitView()
			this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_MESSAGE_TAB, () => {
				// UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(this.Content)
			})
		}


		this.itemList = [];
		this.InitView = () => {
			let model = FriendModel.GetInstance()
			this.BindEvent(model, FriendEvent.UPDATE_FIGHT_DATA, (info?) => {
				this.SetInfo(info)
			}
			)
			if (this.p2Data) {
				if (!this.p2Data.server_id || this.p2Data.server_id <= 0 || RoleManager.GetInstance().GetMainRoleVo().server_id == this.p2Data.server_id) {
					model.Fire(FriendEvent.REQUEST_PROTO, 15014, "l", this.p2Data.role_id)
				} else {
					model.Fire(FriendEvent.REQUEST_PROTO, 15015, "hl", this.p2Data.server_id, this.p2Data.role_id)
				}
				let frame_id = DressModel.GetInstance().GetDressByType(this.p2Data.dress_list, DressType.Photo)
				//this.p2Head.setData(null, this.p2Data.career, this.p2Data.picture, null, null, frame_id)
				// if (this.p2Head == null) {
				// 	this.p2Head = new CustomHeadItem(this.p2_head)
				// 	this.p2Head.Load()
				// }
				// this.p2Head.SetRoleVoData(this.p2Data)

				this.p2Name.text = this.p2Data.name
				//this.p2Fight.Updatefighting(this.p2Data.combat)
			}
			let P1Info = RoleManager.GetInstance().GetMainRoleVo()
			//let photo_frame_id = RoleManager.GetInstance().mainRoleInfo.GetDressByType(DressType.Photo)
			//this.p1Head.setData(null, P1Info.career, P1Info.picture, null, null, photo_frame_id)
			// if (this.p1Head == null) {
			// 	this.p1Head = new CustomHeadItem(this.p1_head)
			// 	this.p1Head.Load()
			// }
			let photo_frame_id = RoleManager.GetInstance().mainRoleInfo.GetDressByType(DressType.Photo)
			// this.p1Head.SetRoleVoData(RoleManager.GetInstance().mainRoleInfo)


			this.p1Name.text = P1Info.name
			this.fight_num1.text = P1Info.fighting
			this.fight_num2.text = this.p2Data.combat
			//this.p1Fight.Updatefighting(P1Info.fighting)
			// if(P1Info.career==2){
			// 	ResManager.GetInstance().SetImageSpriteTrans(this,this._img_role_1,GameResPath.GetIcon("friend","ui_role_"+P1Info.career))
			// }else{
				ResManager.GetInstance().SetOutsideImageSprite(this,this._img_role_1,GameResPath.GetIcon("friend","ui_role_"+P1Info.career))
			// }
			

			// if(this.p2Data.career==2){
			// 	ResManager.GetInstance().SetImageSpriteTrans(this,this._img_role_2,GameResPath.GetIcon("friend","ui_role_"+this.p2Data.career))
			// }else{
				ResManager.GetInstance().SetOutsideImageSprite(this,this._img_role_2,GameResPath.GetIcon("friend","ui_role_"+this.p2Data.career))
			// }
			
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("friend", "ui_phb_004"),true)
		}


	}

	public SetInfo(info?) {

		let CallBack = (item?) => {
			if (this.OpenItem && this.OpenItem != item) {
				this.OpenItem.SetState(false)
			}
			this.OpenItem = item
		}

		let i = 0
		do {
			let item = this.itemList[i]
			if (!item) {
				item = new FightComTabItem(this.Content)
				item.Load()
				this.itemList[i] = item
			}
			item.SetData(info[i], CallBack)
			i = i + 1
		} while ((i < info.length))
	}

	public InitData(data?) {

		this.p2Data = data
	}

	public DeleteMe() {

		if (this.itemList) {
			for (let key in this.itemList) {

				// [ts2lua]this.itemList下标访问可能不正确
				this.itemList[key].DeleteMe()
				// [ts2lua]this.itemList下标访问可能不正确
				this.itemList[key] = null
			}
			this.itemList = []
		}
		// this.p1Head.DeleteMe()
		// this.p1Head = null
		// this.p2Head.DeleteMe()
		// this.p2Head = null
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.fightGp,
			this._Image1,
			this._Image2,
			this.bg1,
			this._Group1,
			this._Image3,
			this.p1Name,
			this.Image,
			this.fight_num1,
			this._Group2,
			this._Image4,
			this.p2Name,
			this.Image1,
			this.fight_num2,
			this.tabScroller,
			this.Content,
			this.p1_head,
			this.p2_head,
			this._img_role_1,
			this._img_role_2,
		]
			= this.GetChildrenByNames([

				"fightGp",
				"_Image1",
				"_Image2",
				"bg1",
				"_Group1",
				"_Image3",
				"p1Name",
				"Image",
				"fight_num1",
				"_Group2",
				"_Image4",
				"p2Name",
				"Image1",
				"fight_num2",
				"tabScroller",
				"Content",
				"p1_head",
				"p2_head",
				"_img_role_1",
				"_img_role_2",
			])
			this.tabScroller.vScrollBarSkin=""
	}
}

window["FightCompareItem"] = FightCompareItem