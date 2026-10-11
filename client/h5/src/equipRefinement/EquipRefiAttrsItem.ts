import { BaseItem1 } from "../common/BaseItem1"
import { Util, SetSizeDeltaY, SetAnchoredPositionX } from "../util/Util"
import { EquipModel } from "../commonModel/EquipModel"
import { ResManager } from "../common/ResManager"
//import { EquipRefiAttrItem } from "./EquipRefiAttrItem"

export class EquipRefiAttrsItem extends BaseItem1 {
	InitEvent
	LocalDeleteMe
	SetData
	_Group1
	_Group2
	//_gp_instru
	//_img_instruction
	//_img_title
	cfg_refine

	public constructor(parent?) {
		super(parent)
		this.base_file = "equipRefinement"
		this.layout_file = "EquipRefiAttrsItem"

		//let attr_item_list = []

		this.load_callback = () => {
			this.cfg_refine = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_refinement", false)
			//this.InitEvent()
			this._lb_attrs.width = 170
			this._lb_attrs.style.fontSize = 20
			this._lb_attrs.style.color = "#1db641"
			this._lb_attrs.style.leading = 15
		}

		/*
		this.InitEvent = () => {
			Util.AddClickEvent(this._img_instruction, () => {
				EquipModel.GetInstance().Fire(EquipEvent.OPEN_REFI_INSTRUCTION)
			}, this, true)
		}
		*/

		this.SetData = (type?, equip?, lv?, not_show_instru?) => {
			let show_lv = lv || equip.refinement_lv
			let str = type == 1 ? "极品属性" : ("神炼+" + show_lv)
			this._lb_lv.text = str

			str = ""
			this._lb_attrs.style.color = type == 1 ? "#663915" : "#1db641"
			let attrs = equip.equip_extra_attr
			for (let i in attrs) {
				let vo = attrs[i]
				if (vo.color > 3) {
					if (type == 1) {
						str = str + Util.GetAttrStr([[vo.attr_id, vo.attr_val]], "'#d85d03'")
					} else {
						str = str + EquipModel.GetInstance().getRefineAttr(vo, show_lv, equip.equip_type, this.cfg_refine)
					}
					if (Number(i) < (attrs.length - 1)) {
						str += "<br/>"
					}
				}
			}
			this._lb_attrs.innerHTML = str
			this._lb_attrs.width = 170
			this.gp_attrs.callLater(()=>{
				if(this.use_delete_method) return
				this._lb_attrs.event(Laya.Event.RESIZE)
			})
			/*
			let bool = type == 1
			//this._gp_instru.visible = bool && !not_show_instru
			//this._img_title.visible = bool
			this._lb_lv.visible = !bool
			let attrs = equip.equip_extra_attr
			let num = 0
			for (let i in attrs) {
				var vo = attrs[i]
				if (vo.color > 3) {
					num = num + 1
					let item = attr_item_list[i]
					if (!item) {
						item = new EquipRefiAttrItem(this._gp_attrs)
						attr_item_list[i] = item
						item.Load()
					}
					item.SetVisible(true)
					item.ExcuteCallback(() => {
						item.SetData(type, attrs[i], lv || equip.refinement_lv, lv, equip, not_show_instru)
					}
					)
				}
			}

			for (let i = num + 1; i <= attr_item_list.length; i++) {
				attr_item_list[i].SetVisible(false)
			}

			if (bool && not_show_instru) {
				this._img_bg.visible = true
				//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("equipRefinement", "uijs_124"), true)
			} else if (not_show_instru) {
				this._img_bg.visible = false
			}
			if (bool) {
				SetAnchoredPositionX(this._Group1, 100)
			} else {
				SetAnchoredPositionX(this._Group1, 90)
				this._lb_lv.text = "神炼+" + (lv || equip.refinement_lv)
			}
			if (!not_show_instru) {
				SetSizeDeltaY(this._gp_attrs, 135)
			}
			*/
		}

		this.LocalDeleteMe = () => {
			/*
			if (attr_item_list.length > 0) {
				for (let _tmpi in attr_item_list) {
					var item = attr_item_list[_tmpi]
					item.DeleteMe()
				}
				attr_item_list = []
			}
			*/
		}
	}

	public DeleteMe() {
		this.LocalDeleteMe()
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_lb_lv: Laya.Label
	gp_attrs: Laya.VBox
	_lb_attrs: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._img_bg,
			this._lb_lv,
			this.gp_attrs,
			this._lb_attrs,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_lb_lv",
				"gp_attrs",
				"_lb_attrs",
			])
	}
}

window["EquipRefiAttrsItem"] = EquipRefiAttrsItem