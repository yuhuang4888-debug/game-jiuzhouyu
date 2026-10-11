import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class HolySoulItem extends BaseItem1 {

	private model: HolySealModel
	data
	need_refresh_data
	type_id

	static progress_width = 266
	public constructor(parent) {
		super(parent)
		this.base_file = "holySeal"
		this.layout_file = "HolySoulItem"
		this.model = HolySealModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	LoadSuccess() {
		// ResManager.GetInstance().SetTexture(this, this._img_bg, "resource/game/holySeal/texture/uisy_022.png")
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	InitEvent() {
		Util.AddClickEvent(this._img_com_bg, () => {
			if (this.type_id) {
				UIToolTipMgr.GetInstance().AppendGoodsTips(this.type_id)
			}
		}, this, true)

		Util.AddClickEvent(this._gp_use, () => {
			if (this.type_id) {
				let count = GoodsModel.GetInstance().GetTypeGoodsNum(this.type_id)
				if (count > 0) {
					this.model.Fire(HolySealModel.REQUEST_CCMD_EVENT, 65406, this.type_id, count)
				}
				else {
					Message.show("物品不足")
				}
			}
		}, this, true)

		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
			if (this.use_delete_method) return
			for (let vo of goods_list) {
				if (this.type_id == vo.type_id) {
					this.UpdateGoodsCount()
				}
			}
		})
	}

	public SetData(data) {
		this.data = data
		if (this.is_loaded) {
			this.UpdateView()
		}
		else {
			this.need_refresh_data = true
		}
	}

	UpdateView() {
		let data = this.data
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(data.goods_id))
		
		let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(data.goods_id)
		
		ResManager.GetInstance().SetImageSprite(this, this._img_color_bg, "holySeal", this.GetBg(basic.color))

		ResManager.GetInstance().SetImageSprite(this, this._img_com_bg, "common_asset", `com_goods_plate_${basic.color}`)

		this.type_id = data.goods_id

		this.UpdateGoodsCount()

		this._lb_name.text = basic.goods_name

		let total_count = 0
		let level = RoleManager.GetInstance().GetMainRoleVo().level
		for (let vo of data.cond) {
			if (vo.lv_min <= level && vo.lv_max >= level) {
				total_count = vo.num
				break
			}
		}
		this._lb_progress.text = `${data.num}/${total_count}`
		this._img_progress.width = (data.num / total_count) * HolySoulItem.progress_width


		let str = ""
		for (let vo of data.add_attr) {
			str += `${WordManager.GetProperties(vo[0])}+${vo[1] * data.num}  `
		}
		this._lb_attr.text = str

		if (total_count == data.num) {
			this._lb_tips.visible = true
			this._gp_use.visible = false

			let count = total_count + 1
			let next_level = 0
			for (let vo of data.cond) {
				if (vo.num >= count) {
					next_level = vo.lv_min
					break
				}
			}
			if (next_level) {
				this._lb_tips.text = `人物达到\n${next_level}级`
			}
			else {
				this._lb_tips.text = `已满级`
			}
		}
		else {
			this._lb_tips.visible = false
			this._gp_use.visible = true
		}
	}

	UpdateGoodsCount() {
		let count = GoodsModel.GetInstance().GetTypeGoodsNum(this.type_id)
		this._lb_count.text = String(count)
		this._img_use_red.visible = count > 0
	}

	GetBg(color) {
		let source = ""
		switch (color) {
			case 2:
				source = "uisy_019d"
				break
			case 3:
				source = "uisy_019c"
				break
			case 4:
				source = "uisy_019b"
				break
			case 5:
				source = "uisy_019a"
				break
		}
		return source
	}

	_img_bg: Laya.Image
	_img_com_bg: Laya.Image
	_img_icon: Laya.Image
	_Label1: Laya.Label
	_lb_count: Laya.Label
	_Image2: Laya.Image
	_img_progress: Laya.Image
	_lb_progress: Laya.Label
	_img_color_bg: Laya.Image
	_lb_name: Laya.Label
	_lb_attr: Laya.Label
	_lb_tips: Laya.Label
	_gp_use: Laya.Box
	_Image3: Laya.Image
	_Label2: Laya.Label
	_img_use_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_com_bg,
			this._img_icon,
			this._Label1,
			this._lb_count,
			this._Image2,
			this._img_progress,
			this._lb_progress,
			this._img_color_bg,
			this._lb_name,
			this._lb_attr,
			this._lb_tips,
			this._gp_use,
			this._Image3,
			this._Label2,
			this._img_use_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_com_bg",
				"_img_icon",
				"_Label1",
				"_lb_count",
				"_Image2",
				"_img_progress",
				"_lb_progress",
				"_img_color_bg",
				"_lb_name",
				"_lb_attr",
				"_lb_tips",
				"_gp_use",
				"_Image3",
				"_Label2",
				"_img_use_red",
			])
	}
}
window["HolySoulItem"] = HolySoulItem