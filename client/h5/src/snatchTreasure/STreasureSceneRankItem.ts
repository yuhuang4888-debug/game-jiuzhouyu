
////////////////////////////////////////////////////////////////////-
// u3d (C) CompanyName, All Rights Reserved
// Created by: WangXiang
// Date: 2020-04-22 16.54:43
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { SnatchTreasureModel } from "../commonModel/SnatchTreasureModel"

// To edit this template in: Data/Config/Template.lua
// To disable this template, check off menuitem: Options-Enable Template File

//-@class STreasureSceneRankItem
export class STreasureSceneRankItem extends BaseItemRenderer {
	_Image1: Laya.Image
	_lb_rank: Laya.Label
	_lb_name: Laya.Label
	_lb_hurt: Laya.Label
	_model

	public static width = 235
	public static height = 25
	WIDTH = 235
	HEIGT = 25
	public constructor(parent) {
		super()


		this.base_file = "snatchTreasure"
		this.layout_file = "STreasureSceneRankItem"
		this._model = SnatchTreasureModel.GetInstance()
		this.load_callback = () => {

		}
		this.Load()
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_rank.text = String(this.index + 1)
			if (this.data.damage) {
				this._lb_name.text = this.data.role_name
				this._lb_hurt.text = this._model.SetValue(this.data.damage)
			} else {
				this._lb_name.text = "虚以待位"
				this._lb_hurt.text = ""
			}
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._lb_rank,
			this._lb_name,
			this._lb_hurt,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_lb_rank",
				"_lb_name",
				"_lb_hurt",
			])
	}
}
window["STreasureSceneRankItem"] = STreasureSceneRankItem