import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { SkillVo } from "../skill/SkillVo"
import { Mathf } from "../util/Mathf"
import { SetLocalPositionY, Util, Trim, SetSizeDeltaX, SetSizeDeltaY, SetHtmlCenter } from "../util/Util"

export class InnateInfoItem extends BaseItem1 {
	InitEvent
	InitLabel
	InitView
	_scr_dec: Laya.Panel
	SetContentSize
	SetData
	_gp_dec
	_gp_scr
	_img_arrow_right
	_img_icon
	_lb_lv: Laya.HTMLDivElement
	_lb_name
	label1: Laya.HTMLDivElement
	label2: Laya.HTMLDivElement
	label3: Laya.HTMLDivElement
	label4: Laya.HTMLDivElement
	public constructor(parent?) {
		super(parent)


		this.base_file = "innateSkill"
		this.layout_file = "InnateInfoItem"
		let model = SkillUIModel.GetInstance()
		let skill_id_ = null
		let skill_cfg_ = null
		let is_move_ = false
		let dec_height = 0
		let labels_ = [
			"<font color=\"#0a953e\">[当前效果]</font>",
			"<font color=\"#ff4f50\">[下级效果]</font>",
			"<font color=\"#ff4f50\">[满级效果]</font>"
		]

		this.load_callback = () => {
			this.InitEvent()
		}

		this.InitEvent = () => {
			//废弃
			//let btn_func = (dir?) => {
			//if (is_move_ ) {
			//return
			//}
			//let cur = this._gp_dec.getChildAt(dir)
			//if (cur ) {
			//is_move_ = true
			//Laya.Tween.get(this._scr_dec.viewport):to({scrollH=cur.width * dir}, 200).call(() => {
			//// [ts2lua]lua中0和空字符串也是true，此处dir > 0需要确认
			//this._img_arrow_left.visible = (dir > 0 && ( true ) || ( false ) )
			//// [ts2lua]lua中0和空字符串也是true，此处dir > 0需要确认
			//this._img_arrow_right.visible = (dir > 0 && ( false ) || ( true ) )
			//is_move_ = false
			//}
			//)
			//}
			//}

			this.BindEvent(model, SkillUIModel.SELECT_INNATE_ITEM, (skill_cfg?) => {
				if (skill_cfg) {
					skill_id_ = skill_cfg.id
					this.InitView()
				}
			}
			)
		}

		this.InitView = () => {
			dec_height = 0
			// for (let i = 0; i < this._gp_dec.numChildren; i++) {
			// destroy(this._gp_dec.GetChild(i).gameObject)
			// }

			let cfg = model.GetInnateAllInfoByID(skill_id_)
			if (!cfg) {
				return
			}
			SetLocalPositionY(this._gp_scr, 0)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, "resource/game/skillIcon/" + new SkillVo(cfg.id).GetIcon() + ".png")
			let lv_data = cfg.lv_data
			lv_data = JSON.parse(lv_data)
			//if (typeof(lv_data) == "string" ) {
			//lv_data = ErlangParser.GetInstance().parse(lv_data)
			//}
			if (!lv_data) {
				return
			}
			let lv = cfg.skill_lv && cfg.skill_lv || 0
			this._lb_name.text = cfg.name
			this._lb_lv.width = 150
			this._lb_lv.innerHTML = Util.StrToHTML("等级:<font color=\"#0a953e\">" + lv + "/" + lv_data.length + "</font>")
			let temp = lv - 1 >= 0 ? lv - 1 : lv_data.length - 1
			let cur_lv_info = lv_data[lv - 1 >= 0 ? lv - 1 : lv_data.length - 1]
			if (!cur_lv_info) {
				return
			}
			let title_desc = labels_[0]
			this._img_arrow_right.visible = false
			if (lv == 0) {
				title_desc = labels_[2]
			}
			this.label1 = this.InitLabel(title_desc, this._gp_dec, true, 1)
			let cur_lv_desc
			if(window["ChatModel"]){
				cur_lv_desc = window["ChatModel"].GetInstance().FormatColorTag(cur_lv_info.desc, false);
			}
			else{
				cur_lv_desc = cur_lv_info.desc
			}
			this.label2 = this.InitLabel(cur_lv_desc, this._gp_dec, true, 2)

			if (lv != 0 && lv != lv_data.length) {
				let next_lv_info = lv_data[lv]
				if (!next_lv_info) {
					return
				}
				this.label3 = this.InitLabel(labels_[1], this._gp_dec, true, 3)
				let next_lv_desc
				if(window["ChatModel"]){
					next_lv_desc = window["ChatModel"].GetInstance().FormatColorTag(next_lv_info.desc, false);
				}
				else{
					next_lv_desc = cur_lv_info.desc
				}
				this.label4 = this.InitLabel(next_lv_desc, this._gp_dec, true, 4)

			} else {
				if (this.label3) {
					this.label3.innerHTML = ""
					this.label4.innerHTML = ""
					this.label3.height = 0
					this.label4.height = 0
				}
			}
			if (this.label3) {
				this._gp_dec.height = this.label1.height + this.label2.height + this.label3.height + this.label4.height
			}
			else {
				this._gp_dec.height = this.label1.height + this.label2.height
			}
			// LayoutRebuilder(this._gp_dec)

			if (dec_height > 66) {
				// this._scr_dec.vertical = true
				this._img_arrow_right.visible = true
			} else {
				// this._scr_dec.vertical = false
			}

			let total_size = dec_height + Mathf.Abs(this._gp_dec.y) + 2
			this.SetContentSize(total_size)
			// this._scr_dec.viewport.scrollV = 0
			Laya.timer.frameOnce(1, this, () => {
				if (this.use_delete_method) return
				this._gp_dec.refresh()
				this.SetHtmlCenterX(this.label1, this._gp_dec.width)
				this.label2.x = 0
				if (this.label3) {
					this.SetHtmlCenterX(this.label3, this._gp_dec.width)
					this.label4.x = 0
				}

			})
			this._scr_dec.vScrollBar.value=0
			this._scr_dec.refresh()
		}

		this.InitLabel = (desc?, parent?, is_center?, index?) => {
			desc = Util.StrToHTML(desc)
			if (is_center == null) {
				is_center = false
			}

			let text_width = is_center && 292 || 310
			// let text_Align = UnityEngine.TextAnchor.MiddleLeft
			if (is_center) {
				// text_Align = UnityEngine.TextAnchor.MiddleCenter
			}
			let cur_desc: Laya.HTMLDivElement
			if (index == 1) {
				cur_desc = this.label1
			} else if (index == 2) {
				cur_desc = this.label2
			} else if (index == 3) {
				cur_desc = this.label3
			} else if (index == 4) {
				cur_desc = this.label4
			}
			if (!cur_desc) {
				cur_desc = new Laya.HTMLDivElement
				parent.addChild(cur_desc)
				// cur_desc.style.align = "center"
				// cur_desc.style.valign = "middle"
			}
			//UiFactory.CreateChild(parent,UIType.Label)
			// let desc_text = cur_desc.transform.GetComponent("Text")
			// let fitter = cur_desc.transform.GetComponent("ContentSizeFitter")
			cur_desc.style.color = "#663915"  //Color(74/255,58/255,50/255,1)
			cur_desc.style.leading=1
			cur_desc.style.fontSize = 20
			cur_desc.width = 280
			// cur_desc.style.align = "center"
			// if (PlatformMgr.GetInstance().IsEyouPlatform() ) {
			// 	desc_text.lineSpacing = 1
			// }else{
			// 	desc_text.lineSpacing = 0.7
			// }
			// cur_desc.style.leading = 7
			// SetSizeDeltaX(cur_desc, text_width)

			// fitter.verticalFit = UnityEngine.UI.ContentSizeFitter.FitMode.PreferredSize
			// fitter.horizontalFit = UnityEngine.UI.ContentSizeFitter.FitMode.Unconstrained

			dec_height = dec_height //+ cur_desc.text.preferredHeight 
			// cur_desc.y = 100
			cur_desc.innerHTML = desc
			cur_desc.height = cur_desc.contextHeight
			return cur_desc
		}

		this.SetContentSize = (size?) => {
			SetSizeDeltaY(this._gp_scr, size)
		}

		this.SetData = (skill_id?) => {
			if (!skill_id) {
				return
			}
			skill_id_ = skill_id
			this.InitView()
		}


	}

	public SetHtmlCenterX(html_obj?, w?) {
		if (!html_obj) {
			return
		}
		// html_obj.width = w
		html_obj.x = w / 2 - html_obj.contextWidth / 2
	}

	_Image1: Laya.Image
	_img_mask: Laya.Image
	_img_arrow_left: Laya.Image
	_lb_cur_info: Laya.Label
	_gp_mask: Laya.Box
	_lb_panel: Laya.Panel

	public GetComponents() {
		[
			this._scr_dec,
			this._gp_scr,
			this._Image1,
			this._img_mask,
			this._img_icon,
			this._lb_name,
			this._lb_lv,
			this._img_arrow_left,
			this._lb_cur_info,
			this._gp_mask,
			this._lb_panel,
			this._gp_dec,
			this._img_arrow_right,
		]
			= this.GetChildrenByNames([

				"_scr_dec",
				"_gp_scr",
				"_Image1",
				"_img_mask",
				"_img_icon",
				"_lb_name",
				"_lb_lv",
				"_img_arrow_left",
				"_lb_cur_info",
				"_gp_mask",
				"_lb_panel",
				"_gp_dec",
				"_img_arrow_right",
			])
		this._scr_dec.vScrollBar.visible = false
		this._lb_lv.style.fontSize = 20
		this._lb_lv.width = 150
		this._lb_lv.style.color = "#663915"
		this._lb_panel.vScrollBar.visible = false
	}
}
window["InnateInfoItem"] = InnateInfoItem