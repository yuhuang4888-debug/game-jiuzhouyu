
////////////////////////////////////////////////////////////////////-

import { BaseItemRenderer } from "../common/BaseItemRenderer"

// u3d (C) CompanyName, All Rights Reserved

// Created by: AuthorName

// Date: 2020-04-15 15.52:18

////////////////////////////////////////////////////////////////////-



// To edit this template in: Data/Config/Template.lua

// To disable this template, check off menuitem: Options-Enable Template File



//-@class InvitedRenderer

export class InvitedRenderer extends BaseItemRenderer {

	public WIDTH = 167
	public HEIGT = 30
	public constructor(parent) {
		super()
		this.base_file = "marriage2"
		this.layout_file = "InvitedRenderer"
		this.load_callback = () => {
		}
		this.Load();
	}



	public dataChanged() {
		if (!super.dataChanged()) return;
		this.nameLabel.text = this.data.name
	}

	
	nameLabel: Laya.Label
	_Image1: Laya.Image
	public GetComponents() {
		[
			this.nameLabel,
			this._Image1,
		]
			= this.GetChildrenByNames([

				"nameLabel",
				"_Image1",
			])
	}
}
window["InvitedRenderer"] = InvitedRenderer