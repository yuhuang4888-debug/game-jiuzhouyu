import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { MarketEvent, MarketModel } from "../commonModel/MarketModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class STreasureFortressView extends BaseView1 {
	blackline_effect_gp: Laya.Box
	bg_img: Laya.Image
	_Group1: Laya.Box
	_img_001l: Laya.Image
	_img_001r: Laya.Image
	tip_img: Laya.Image
	_Group2: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	worth_lb: Laya.HTMLDivElement
	_Image3: Laya.Image
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	exit_gp: Laya.Box
	_Image4: Laya.Image
	_Label1: Laya.Label
	look_gp: Laya.Box
	_Image5: Laya.Image
	_Label2: Laya.Label
	Scr_Scroller1
	bind_diamond_num
	data
	destroy_callback
	diamond_num
	item_gp
	item_list

	public constructor() {
		super()


		this.bind_diamond_num = 0;
		this.diamond_num = 0;
		this.base_file = "snatchTreasure"
		this.layout_file = "STreasureFortressView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.load_callback = () => {

			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (this.item_list && this.item_list.length > 0) {
				for (let _tmpi in this.item_list) {
					var obj = this.item_list[_tmpi]
					obj.DeleteMe()
				}
				this.item_list = null
			}
			this.bind_diamond_num = 0
			this.diamond_num = 0
		}


	}

	public Open(...new_args) {

		let parm = new_args
		if (parm) {
			this.data = parm
		}
		super.Open()
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_001l, GameResPath.GetIcon("snatchTreasure", "uisydl_001"), true)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_001r, GameResPath.GetIcon("snatchTreasure", "uisydl_001"), true)
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("kfHolyArea", "uikfsy_033"), true)
		ResManager.GetInstance().SetImageSpriteTrans(this, this.tip_img, GameResPath.GetIcon("snatchTreasure", "uisydl_002"), true)
		//this.AddUIEffect2("ui_aperture1", this.blackline_effect_gp, null, null, true)
		this.InitEvent()
		this.UpdateView()
	}

	public InitEvent() {

		Util.AddClickEvent(this.exit_gp, () => {
			this.Close()
		}
			, this, true)
		Util.AddClickEvent(this.look_gp, () => {
			MarketModel.GetInstance().Fire(MarketEvent.OPEN_VIEW, "MarketBaseView", 3)
			this.Close()
		}
			, this, true)
	}

	public UpdateView() {

		if (!this.item_list) {
			this.item_list = []
		}
		let index = 0
		let list = this.data.goods
		let join_num = null
		if (this.data.join_num) {
			join_num = this.data.join_num
		}
		//let layout = this.item_gp.layout
		//if (list.length <= 4 ) {
		//layout.horizontalAlign = Laya.HorizontalAlign.CENTER
		//}else{
		//layout.horizontalAlign = Laya.HorizontalAlign.LEFT
		//}
		let i = 0
		if (i < list.length) {
			do {
				// [ts2lua]this.item_list下标访问可能不正确
				let item = this.item_list[index]
				if (!item) {
					item = new EquipmentItem(this.item_gp)
					item.Load()
					table.insert(this.item_list, item)
					item.SetScale(0.75)
				}
				if (list[i]) {
					// [ts2lua]lua中0和空字符串也是true，此处list[i].num == 1需要确认
					let num = (list[i].num == 1 && (null) || (list[i].num))
					item.SetData(list[i].goods_id, num)
					if (list[i].gold_type == 2) {
						this.bind_diamond_num = this.bind_diamond_num + list[i].worth
					} else {
						this.diamond_num = this.diamond_num + list[i].worth
					}
				}
				index = index + 1
				i = i + 1
			} while ((i < list.length))
		}
		let worth_str = null
		if (this.diamond_num <= 0) {
			worth_str = "本次参与玩法的人数：<font color='#639c12'>" + join_num + "</font>人\n产出拍卖品起拍价值：<font color='#639c12'>" + this.bind_diamond_num + "</font>绑玉"
		} else {
			worth_str = "本次参与玩法的人数：<font color='#639c12'>" + join_num + "</font>人\n产出拍卖品起拍价值：<font color='#639c12'>" + this.diamond_num + "</font>勾玉,<font color='#639c12'>" + this.bind_diamond_num + "</font>绑玉"
		}
		this.worth_lb.style.fontSize = 22
		this.worth_lb.style.color = "#4a3a32"
		this.worth_lb.width = 500
		this.worth_lb.innerHTML = Util.StrToHTML(worth_str)
	}



	public GetComponents() {
		[
			this.blackline_effect_gp,
			this.bg_img,
			this._Group1,
			this._img_001l,
			this._img_001r,
			this.tip_img,
			this._Group2,
			this._Image1,
			this._Image2,
			this.worth_lb,
			this._Image3,
			this._Scroller1,
			this.Content,
			this.exit_gp,
			this._Image4,
			this._Label1,
			this.look_gp,
			this._Image5,
			this._Label2,
		]
			= this.GetChildrenByNames([

				"blackline_effect_gp",
				"bg_img",
				"_Group1",
				"_img_001l",
				"_img_001r",
				"tip_img",
				"_Group2",
				"_Image1",
				"_Image2",
				"worth_lb",
				"_Image3",
				"_Scroller1",
				"Content",
				"exit_gp",
				"_Image4",
				"_Label1",
				"look_gp",
				"_Image5",
				"_Label2",
			])
	}
}
window["STreasureFortressView"] = STreasureFortressView