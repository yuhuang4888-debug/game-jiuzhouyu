
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-21 10.39:06
////////////////////////////////////////////////////////////////////-

import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { HolyTerritoryModel } from "../commonModel/HolyTerritoryModel"
import { ResManager } from "../common/ResManager"
import { Util, SetLocalScale } from "../util/Util"
import { GameResPath } from "../util/GameResPath"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class HTTopItem

export class HTTopItem extends BaseItem1 {
	_head
	SetData
	data
	index
	need_refresh

	public constructor(parent?) {
		super(parent)


		this.base_file = "holyTerritory"
		this.layout_file = "HTTopItem"
		this.load_callback = () => {
			ResManager.GetInstance().LoadFont(this, "holy_battle_fight", this.fight, null, false)
			if (this.need_refresh) {
				this.SetData(this.data)
				this.need_refresh = null
			}
		}

		this.SetData = (data?) => {
			this.data = data
			if (data) {
				if (this.is_loaded) {
					if (this._head == null) {
						this._head = new CustomHeadItem(this.head)
						this._head.Load()
					}
					this._head.SetRoleVoData(data)
					this._head.SetActiveBg2(false)

					this.nameLabel.text = data.role_name
					this.fight.text = "战力：" + data.power
					let dsgt_id = 0
					let dsgt
					let id = HolyTerritoryModel.GetInstance().SettleInfo ? HolyTerritoryModel.GetInstance().SettleInfo.sanctuary_id : 1
					let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sanctuary_designation", false)
					let dsgt_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
					if (this.index == 0) {

						let cfg = _cfg[id + "@1@1"]
						if (cfg) {
							dsgt_id = cfg.designation_id
						}
					} else {
						let cfg = _cfg[id + "@2@4"]
						if (cfg) {
							dsgt_id = cfg.designation_id
						}
					}

					//dsgt_id = 801006
					dsgt = dsgt_cfg[dsgt_id]
					this._img_title.visible=false
					this.dsgt.visible=false
					if (dsgt) {

						if (dsgt.type == 1) {
							this.dsgt.visible=true
							this.dsgt.width = 720
							this.dsgt.height = 1280
							this.dsgt.mouseThrough = true
							this.dsgt.mouseEnabled = false
							this.ClearUIEffect(this.dsgt)
							this.AddUIEffect(dsgt.resource_id, this.dsgt)
							// [ts2lua]this下标访问可能不正确
							//this.AddUIEffect2(dsgt.resource_id, this["transdsgt"], null, { x=1.3, y=1.3 }, true)
						} else {
							this._img_title.visible=true
							ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title, GameResPath.GetDesignImage(dsgt.resource_id), true)
						}
					}
				} else {
					this.need_refresh = true
				}
			}
		}
	}


	public SetIndex(index?) {

		this.index = index
	}

	public DeleteMe() {
		this.ClearUIEffect(this.dsgt)
		if (this._head) {
			this._head.DeleteMe()
			this._head = null
		}
		super.DeleteMe()
	}



	_Group1: Laya.Box
	dsgt: Laya.Box
	_img_title: Laya.Image
	head: Laya.Box
	_Image1: Laya.Image
	nameLabel: Laya.Label
	fight: Laya.Label
	public GetComponents() {
		[
			this._Group1,
			this.dsgt,
			this._img_title,
			this.head,
			this._Image1,
			this.nameLabel,
			this.fight,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"dsgt",
				"_img_title",
				"head",
				"_Image1",
				"nameLabel",
				"fight",
			])
	}
}
window["HTTopItem"] = HTTopItem