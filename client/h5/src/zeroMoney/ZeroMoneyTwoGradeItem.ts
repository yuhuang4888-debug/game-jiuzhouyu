
////////////////////////////////////////////////////////////////////-

// u3d (C) CompanyName, All Rights Reserved

// Created by: AuthorName

// Date: 2020-07-04 14.24:14

////////////////////////////////////////////////////////////////////-



// To edit this template in: Data/Config/Template.lua

// To disable this template, check off menuitem: Options-Enable Template File



//-@class ZeroMoneyTwoGradeItem
import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Util } from "../util/Util"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { ResManager } from "../common/ResManager"
export class ZeroMoneyTwoGradeItem extends BaseItem1 {
	click: Laya.Box
	select: Laya.Image
	select1: Laya.Image
	icon: Laya.Image
	Image: Laya.Image
	desc: Laya.Label
	red: Laya.Image
	needRefresh
	base_type
	data

	model

	sub_type





	public constructor(parent) {
		super(parent)


		this.base_file = "zeroMoney"

		this.layout_file = "ZeroMoneyTwoGradeItem"

		this.model = CustomActivityModel.GetInstance()

		this.load_callback = () => {

			this.LoadSuccess()

		}

	}



	public LoadSuccess() {


		if (this.needRefresh) {
			this.InitView()
		}

		this.InitEvent()

	}



	public InitEvent() {




		Util.AddClickEvent(this.click, () => {

			if (!this.data || !this.base_type || !this.sub_type) { return }

			this.model.Fire(CustomActivityDefine.EVENT.UP_GRADE, this.base_type, this.sub_type, null, this.data.grade)

		}, this, true)



		//取消非选中状态

		this.BindEvent(this.model, CustomActivityDefine.EVENT.UP_GRADE, (base_type?, sub_type?, data?, grade?) => {

			if (!data && this.data && grade && grade != this.data.grade) {

				this.RefSelect(false)

			} else if (!data && this.data && grade && grade == this.data.grade) {

				this.RefSelect(true)

			}

		})



		this.BindEvent(this.model, CustomActivityDefine.EVENT.RECEIVE_SUCCESS, (base_type?, sub_type?, grade?) => {

			if (this.data && base_type == this.base_type && sub_type == this.sub_type && this.data.grade == grade) {

				this.red.visible = false

			}

		}

		)

	}



	public InitView() {


		if (!this.data) { return }

		this.desc.text = this.data.name

		this.model.CloseACTRed(this.base_type, this.sub_type, this.data.grade)

		let value = this.model.GetGradeRed(this.base_type, this.sub_type, this.data.grade)

		this.red.visible = value && value > 0

		let cond = this.model.GetActCondition(this.base_type, this.sub_type, "data", this.data.grade)

		if (cond && cond.grade_icon) {

			ResManager.GetInstance().SetImageSprite(this, this.icon, "zeroMoney_asset", cond.grade_icon)

		}

	}



	public RefSelect(bool?) {


		let url = bool && "ui0yhl_003a" || "ui0yhl_003"

		ResManager.GetInstance().SetImageSprite(this, this.select, "zeroMoney_asset", url)

		this.select1.visible = bool

	}



	public SetData(base_type?, sub_type?, data?) {


		this.base_type = base_type

		this.sub_type = sub_type

		this.data = data
		if (this.is_loaded) {

			this.InitView()
		}
		else {
			this.needRefresh = true
		}

	}




	public GetComponents() {
		[
			this.click,
			this.select,
			this.select1,
			this.icon,
			this.Image,
			this.desc,
			this.red,
		]
			= this.GetChildrenByNames([

				"click",
				"select",
				"select1",
				"icon",
				"Image",
				"desc",
				"red",
			])
	}
}
window["ZeroMoneyTwoGradeItem"] = ZeroMoneyTwoGradeItem