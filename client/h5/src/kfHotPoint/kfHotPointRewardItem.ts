import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util, Color } from "../util/Util"
import { HotPointModel } from "./HotPointModel"

export class kfHotPointRewardItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_Image1: Laya.Image
	_lb_desc: Laya.Label
	_lb_desc1: Laya.Label
	_Scroller1: Laya.Panel
	_gp_reward: Laya.HBox
	_btn_draw: Laya.Box
	_img_draw: Laya.Image
	_lb_draw: Laya.Label
	_img_red: Laya.Image
	_img_had_get: Laya.Image
	Emp_btn_draw
	Out_lb_draw
	VHS_Scroller1
	_Viewport1
	item_list
	fly_list


	public static width = 696
	public static height = 164
	public constructor(parent) {
		super()
		this.item_list = []
		this.base_file = "kfHotPoint"
		this.layout_file = "kfHotPointRewardItem"
		this.WIDTH = 696
		this.HEIGT = 164
		// this.layer_value = Enum_UILayer.UI
		// this.load_callback = () => {
		// 	// this.RegisterMask(this._Viewport1, 2)
		// 	// this.VHS_Scroller1.parentScroll = this.parent_wnd.GetComponentInParent(typeof (UnityEngine.UI.ScrollRect))
		// 	this.LoadSuccess()
		// }
		this.Load()
	}

	public load_callback() {
		this.InitEvent()
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		this.InitView()
	}

	public InitEvent() {
		Util.AddClickEvent(this._btn_draw, () => {
			let data = this.data
			if (!data) {
				return
			}
			if (data.status == 1) {
				HotPointModel.GetInstance().Fire(HotPointModel.REQUEST_SCMD, 33304, data.base_type, data.sub_type, data.grade)
			} else if (data.status == 0) {
				Message.show("嗨点不足")
			} else if (data.status == 2) {
				Message.show("已领取")
			}
		}
			, this, true)



		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, (base_type?, sub_type?, result_data?) => {
			if (this.data && this.data.base_type == base_type && this.data.sub_type == sub_type && this.data.grade == result_data.grade) {
				//飘字特效
				CustomActivityModel.GetInstance().ShowActFlyReward(this.fly_list, this._btn_draw)
			}
		})
	}



	public InitView() {
		let info = this.data
		if (!info) {
			return
		}
		ResManager.GetInstance().SetImageSprite(this, this._img_bg, "kfHotPoint", "cjgh_002", true)
		this._img_bg.sizeGrid = "72,122,91,99"
		let str = info.desc.replace("可领取", "")
		this._lb_desc.text = str
		this._img_had_get.visible = info.status == 2
		this._btn_draw.visible = info.status != 2
		let red_bool = (info.status == 1 && (true) || (false))
		this._img_red.visible = red_bool
		if (info.status != 2) {
			let gray_bool = (info.status == 1 ? (false) : (true))
			Util.SetImageGray(this._img_draw, gray_bool)
			this._lb_draw.stroke = gray_bool ? 0 : 4
			// this.Out_lb_draw.effectColor = gray_bool && ColorUtilValue.GRAY || Color(211 / 255, 106 / 255, 36 / 255, 1)
		}
		if (this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
			}
			this.item_list = []
		}
		if (typeof (info.reward) == "string") {
			info.reward = ErlangParser.GetInstance().Parse(info.reward)
		}

		this.fly_list = CustomActivityModel.GetInstance().GetFlyRewardList(info.reward)

		for (let i = 0; i < info.reward.length; i++) {
			let item = this.item_list[i]
			if (!item) {
				item = new BaseAwardItem(this._gp_reward, null, "UI")
				// item.SetMaskId(2)
				// item.SetMaskRect(this.mask_corners)
				// item.SetMaskItemMaterial(this.mask_item_mat)
				item.Load()
				item.SetItemSize(84, 84)
				table.insert(this.item_list, item)
			}
			let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(info.reward[i][0], info.reward[i][1])
			item.SetData(type_id, info.reward[i][2])
			item.SetVisible(true)
		}
	}



	public DeleteMe() {
		if (this.item_list.length > 0) {
			for (let _tmpi in this.item_list) {
				var item = this.item_list[_tmpi]
				item.DeleteMe()
			}
			this.item_list = []
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this._img_bg,
			this._Image1,
			this._lb_desc,
			this._lb_desc1,
			this._Scroller1,
			this._gp_reward,
			this._btn_draw,
			this._img_draw,
			this._lb_draw,
			this._img_red,
			this._img_had_get,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_Image1",
				"_lb_desc",
				"_lb_desc1",
				"_Scroller1",
				"_gp_reward",
				"_btn_draw",
				"_img_draw",
				"_lb_draw",
				"_img_red",
				"_img_had_get",
			])
		this._Scroller1.hScrollBar.visible = false
	}
}
window["kfHotPointRewardItem"] = kfHotPointRewardItem