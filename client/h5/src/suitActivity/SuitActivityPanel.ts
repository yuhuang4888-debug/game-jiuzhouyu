import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { SetAnchoredPosition, SetAnchoredPositionY } from "../util/Util"
import { table } from "../common/table"
import { Vector2 } from "../util/Vector2"
import { Enum_UILayer } from "../common/LayerManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ResManager } from "../common/ResManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { ErlangParser } from "../util/ErlangParser"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { MainUIController } from "../commonController/MainUIController"
import { EquipmentItem } from "../common/EquipmentItem"

export class SuitActivityPanel extends BaseView1 {
	activeTweenList
	data
	equipItemList
	model
	moveItemList
	needRefresh
	showIndex
	tweenid
	tweenid2
	res_mgr
	cfg_suit_clt

	public constructor() {
		super()
		this.base_file = "suitActivity"
		this.layout_file = "SuitActivityPanel"
		this.layer_value = Enum_UILayer.Top
		//this.is_center = true
		//this.use_background = true
		this.destroy_imm = true
		//this.click_bg_toClose = true

		this.model = SuitActivityModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.cfg_suit_clt = Config.PRELOAD_SERVER_CONFIG.config_suit_clt
		this.showIndex = 0

		this.load_callback = () => {
			if (this.needRefresh) {
				this.AddEquip(this.data)
				this.needRefresh = null
			}
			this.display_obj.centerX = 0
			this.display_obj.anchorX = this.display_obj.anchorY = 0.5
			SetAnchoredPositionY(this.display_obj, 800)
		}

		this.open_callback = () => {
			this.ClearTween()
			//SetAnchoredPosition(this.display_obj, 0, -195)
			//SetLocalScale(this.display_obj, 1, 1, 1)
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public AddEquip(data?) {
		if (!this.is_loaded) {
			this.needRefresh = true
			this.data = data
			return
		}
		let showTypeId = null
		let showInex = 0
		let career = RoleManager.GetInstance().GetMainRoleCareer()
		if (!this.equipItemList) {
			this.equipItemList = []
		}

		let curCfg = this.cfg_suit_clt[data.suit_id + "@" + career]
		if (curCfg) {
			let equipList = ErlangParser.GetInstance().Parse(curCfg.show_equip)
			for (let _ in equipList) {
				let euqipInfo = equipList[_]
				let typeId = Number(euqipInfo[0])
				let index = Number(_)
				let equipItem = this.equipItemList[index]
				if (!equipItem) {
					equipItem = new EquipmentItem(this.itemGp, null, "Top")
					equipItem.Load()
					//equipItem.transform.pivot = new Vector2(0.5, 0.5)
					//equipItem.transform.anchorMax = new Vector2(0.5, 0.5)
					//equipItem.transform.anchorMin = new Vector2(0.5, 0.5)
					equipItem.SetItemSize(80, 80)
					//SetAnchoredPosition(equipItem.display_obj, (index - 1) * 72, -15)
					this.equipItemList[index] = equipItem
				}
				equipItem.SetData(euqipInfo[1])
				let gray = (!this.model.GetEquipActiveStatus(data.suit_id, typeId)) || typeId == data.equip_type
				equipItem.SetGary(gray)
				if (typeId == data.equip_type) {
					showTypeId = euqipInfo[1]
					showInex = index
				}
			}
		}

		if (!this.moveItemList) {
			this.moveItemList = []
		}
		this.showIndex = this.showIndex + 1
		let moveItem = new EquipmentItem(this.display_obj, null, "Top")
		moveItem.Load()
		moveItem.SetItemSize(80, 80)
		moveItem.SetData(showTypeId)
		table.insert(this.moveItemList, moveItem)
		moveItem.ExcuteCallback(() => {
			SetAnchoredPosition(moveItem.display_obj, 352, 215)
			let endPos = { x: 13 + showInex * 80, y: 47 }
			SYTweenLite.to(this, moveItem.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, endPos, 0.7, () => {
				if (moveItem) {
					moveItem.SetVisible(false)
					let activeItem = this.equipItemList[showInex]
					if (activeItem) {
						activeItem.SetGary(false)
						if (this.activeTweenList && this.activeTweenList[showInex]) {
							SYTweenLite.Stop(this.activeTweenList[showInex])
							activeItem.SetItemSize(80, 80)
						}
						let tweenId = SYTweenLite.to(this, activeItem.display_obj, SYTweenLite.UiAnimationType.SCALE, { x: 0.75, y: 0.75, z: 0.75 }, 0.6, null, SYTweenFunc.PINGPONG)
						if (!this.activeTweenList) {
							this.activeTweenList = []
						}
						this.activeTweenList[showInex] = tweenId
					}
				}

				setTimeout(() => {
					if (!this.use_delete_method) {
						//this.Close()
						this.showIndex = this.showIndex - 1
						if (this.showIndex == 0) {
							let iconPos = MainUIController.GetInstance().main_ui_secondary_view.GetIconPos("1525", { x: 42, y: 45 }) || { x: 720, y: 491.5 }
							this.tweenid = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.ANCHORED_POS, iconPos, 0.65, () => {
								this.Close()
							})
							this.tweenid2 = SYTweenLite.to(this, this.display_obj, SYTweenLite.UiAnimationType.SCALE, { x: 0.1, y: 0.1, z: 0.1 }, 0.65)
						}
					}
				}, 700)
			})
		})

	}

	public ClearTween() {
		if (this.tweenid) {
			SYTweenLite.Stop(this.tweenid)
			this.tweenid = null
		}
		if (this.tweenid2) {
			SYTweenLite.Stop(this.tweenid2)
			this.tweenid2 = null
		}
	}

	public Remove() {
		if (this.equipItemList) {
			for (let _ in this.equipItemList) {
				let item = this.equipItemList[_]
				item.DeleteMe()
			}
			this.equipItemList = null
		}
		if (this.moveItemList) {
			for (let _ in this.moveItemList) {
				let item = this.moveItemList[_]
				item.DeleteMe()
			}
			this.moveItemList = null
		}
		this.activeTweenList = null
		this.ClearTween()
	}

	bg: Laya.Image
	title: Laya.Image
	Image2: Laya.Image
	itemGp: Laya.HBox
	public GetComponents() {
		[
			this.bg,
			this.title,
			this.Image2,
			this.itemGp,
		]
			= this.GetChildrenByNames([
				"bg",
				"title",
				"Image2",
				"itemGp",
			])
	}
}
window["SuitActivityPanel"] = SuitActivityPanel