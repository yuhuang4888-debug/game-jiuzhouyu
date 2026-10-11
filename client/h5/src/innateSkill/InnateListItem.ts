import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { RoleManager } from "../commonModel/RoleManager"
import { RoleVo } from "../sharedata/RoleVo"
import { InnateSkillItem } from "./InnateSkillItem"

export class InnateListItem extends BaseItem1 {
	_gp_item
	_gp_skill5
	_gp_skill6
	_gp_skill7
	_gp_skill8
	model
	select_id
	skill_item_list
	type

	public constructor(parent?) {
		super(parent)

		this.type = null
		this.select_id = null
		this.skill_item_list = []
		this.base_file = "innateSkill"
		this.layout_file = "InnateListItem"
		this.model = SkillUIModel.GetInstance()
		this.load_callback = () => {
		}
	}

	public InitView() {


		let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
		if (!skill_ui_cfg) {
			return
		}
		let num = RoleManager.GetInstance().GetMainRoleVo().career
		let ui_cfg = skill_ui_cfg["innateSkill"]
		let skill_list = ui_cfg[this.type]
		this._gp_skill5.visible = this.type == 5 && true || false
		this._gp_skill6.visible = this.type == 6 && true || false
		this._gp_skill7.visible = this.type == 7 && true || false
		this._gp_skill8.visible = this.type == 8 && true || false
		if (this.type == 7) {
			this.display_obj.height = 850
		} else if (this.type == 5 || this.type == 6) {
			this.display_obj.height = 637
		}
		if (this.skill_item_list.length > 0) {
			for (let _tmpi in this.skill_item_list) {
				var item = this.skill_item_list[_tmpi]
				item.SetVisible(false)
			}
		}

		let index = 0
		for (let i = 1; i <= 5; i++) {
			let vo = skill_list[i]
			let pos = skill_list["pos_" + i]
			if (vo) {
				for (let j in vo) {

					let item = this.skill_item_list[index]
					index = index + 1
					if (!item) {
						item = new InnateSkillItem(this._gp_item)
						item.Load()
						table.insert(this.skill_item_list, item)
					}
					let skill_id = this.model.GetInnateSkillIdByCfg(vo[j])
					item.ExcuteCallback(() => {
						item.SetPosition(pos[j].x, pos[j].y)
						item.SetVisible(true)
						item.SetData(skill_id, this.type, skill_id == this.select_id)
					}
					)
				}
			}
		}

	}

	public SetDate(type?, select_id?) {


		this.type = type
		this.select_id = select_id
		if (type) {
			this.InitView()
		}
	}

	public DeleteMe() {

		if (this.skill_item_list.length > 0) {
			for (let _tmpi in this.skill_item_list) {
				var item = this.skill_item_list[_tmpi]
				item.DeleteMe()
			}
			this.skill_item_list = []
		}
		super.DeleteMe()
	}

	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image41: Laya.Image
	_Image51: Laya.Image
	_Image61: Laya.Image
	_Image71: Laya.Image

	_Image81: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image111: Laya.Image
	_Image12: Laya.Image
	_Image13: Laya.Image
	_Image14: Laya.Image
	_Image35: Laya.Image
	_Image36: Laya.Image
	_Image37: Laya.Image
	_Image38: Laya.Image
	_Image39: Laya.Image
	_Image40: Laya.Image
	_Image411: Laya.Image
	_Image42: Laya.Image
	_Image43: Laya.Image

	_Image1: Laya.Image
	_Image21: Laya.Image
	_Image31: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image91: Laya.Image
	_Image44: Laya.Image

	public GetComponents() {
		[
			this._gp_skill5,
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image41,
			this._Image51,
			this._Image61,
			this._Image71,
			this._gp_skill6,
			this._Image81,
			this._Image9,
			this._Image10,
			this._Image111,
			this._Image12,
			this._Image13,
			this._Image14,
			this._gp_skill8,
			this._Image35,
			this._Image36,
			this._Image37,
			this._Image38,
			this._Image39,
			this._Image40,
			this._Image411,
			this._Image42,
			this._Image43,
			this._gp_skill7,
			this._Image1,
			this._Image21,
			this._Image31,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image91,
			this._Image44,
			this._gp_item,
		]
			= this.GetChildrenByNames([

				"_gp_skill5",
				"_Image11",
				"_Image2",
				"_Image3",
				"_Image41",
				"_Image51",
				"_Image61",
				"_Image71",
				"_gp_skill6",
				"_Image81",
				"_Image9",
				"_Image10",
				"_Image111",
				"_Image12",
				"_Image13",
				"_Image14",
				"_gp_skill8",
				"_Image35",
				"_Image36",
				"_Image37",
				"_Image38",
				"_Image39",
				"_Image40",
				"_Image411",
				"_Image42",
				"_Image43",
				"_gp_skill7",
				"_Image1",
				"_Image21",
				"_Image31",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image91",
				"_Image44",
				"_gp_item",
			])
	}
}
window["InnateListItem"] = InnateListItem