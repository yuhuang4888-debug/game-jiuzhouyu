import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { GameResPath } from "../util/GameResPath"
import { SetAnchoredPositionX, SetAnchoredPositionY, Util } from "../util/Util"

export class ChoseBanquetView extends BaseView1 {
	// BG1
	// BG2
	InitView
	Local_Open
	Select
	// _Image3
	// _Label1
	// cancelBtn
	// change_scene_close
	// closeBtn
	day_id
	// destroy_imm
	// enterBtn
	// expGroup
	// expLabel
	// expSelect
	// is_center
	model: BanquetModel
	// nomGroup
	// nomLabel
	// nomSelect
	nowSelect
	// show_open_movie
	// simpleGroup
	// simpleLabel
	// simpleSelect
	time_id
	// use_background

	public constructor() {
		super()
		this.model = BanquetModel.GetInstance();
		this.base_file = "marriage2"
		this.layout_file = "ChoseBanquetView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background = true

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.BG2, GameResPath.GetIcon("marriage2", "uijh_124"))
			this.InitView()
		}

		this.InitView = () => {
			this.nomLabel.style.color = "#ffffff";
			this.nomLabel.style.fontSize = 18;
			this.nomLabel.style.wordWrap = false;

			this.expLabel.style.color = "#ffffff";
			this.expLabel.style.fontSize = 18;
			this.expLabel.style.wordWrap = false;

			this.simpleLabel.style.color = "#ffffff";
			this.simpleLabel.style.fontSize = 18;
			this.simpleLabel.style.wordWrap = false;

			this.nomLabel.style.width = this.expLabel.style.width = this.simpleLabel.style.width = 77;
			this.nomLabel.style.align = this.expLabel.style.align = this.simpleLabel.style.align = `center`;

			// ResManager.GetInstance().SetOutsideImageSprite(this, this.BG1, GameResPath.GetIcon("marriage", "uijh_133"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.BG2, GameResPath.GetIcon("marriage2", "uijh_124"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("marriage", "uijh_077"), true)
			ResManager.GetInstance().SetTexture(this, this._Image2, GameResPath.GetIcon("marriage2", "uijh_118"));

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this.nomGroup, () => {
				this.Select(1)
			}
				, this, true)
			Util.AddClickEvent(this.expGroup, () => {
				this.Select(2)
			}
				, this, true)
			Util.AddClickEvent(this.simpleGroup, () => {
				this.Select(3)
			}
				, this, true)
			Util.AddClickEvent(this.enterBtn, () => {
				this.model.Fire(BanqEvent.REQUET_PROTO, 17251, "ccc", this.day_id + 1, this.time_id, this.nowSelect)
				this.Close()
			}
				, this, true)
			Util.AddClickEvent(this.cancelBtn, () => {
				this.Close()
			}
				, this, true)
			let select = 1
			let info = this.model.ApplyViewData
			this.nomLabel.innerHTML = `剩余:${Util.HtmlColorTxt(0, "'#ff4f50'")}`;
			this.expLabel.innerHTML = `剩余:${Util.HtmlColorTxt(0, "'#ff4f50'")}`;
			this.simpleLabel.innerHTML = `剩余:${Util.HtmlColorTxt(0, "'#ff4f50'")}`;
			if (info) {
				for (let _tmpi in info.my_wedding_times) {
					var vo = info.my_wedding_times[_tmpi]
					let surplus: number = vo.max_times - vo.use_times
					let str = `剩余:${Util.HtmlColorTxt(surplus, surplus > 0 ? "'#96ff00'" : "'#ff4f50'")}`;
					if (1 == vo.wedding_type) {
						this.nomLabel.innerHTML = str
					} else if (2 == vo.wedding_type) {
						this.expLabel.innerHTML = str
					} else if (3 == vo.wedding_type) {
						this.simpleLabel.innerHTML = str
					}
					if (vo.max_times - vo.use_times > 0) {
						select = vo.wedding_type
					}
				}
			}
			this.nomLabel.x = 77 - this.nomLabel.width >> 1;
			this.expLabel.x = 77 - this.expLabel.width >> 1;
			this.simpleLabel.x = 77 - this.simpleLabel.width >> 1;
			this.Select(select)
		}

		this.Select = (type?) => {
			// ResManager.GetInstance().SetImageSprite(this, this.nomSelect, "marriage2_asset", type == 1 && "uijh_167" || "uijh_164")
			// ResManager.GetInstance().SetImageSprite(this, this.expSelect, "marriage2_asset", type == 2 && "uijh_167" || "uijh_164")
			// ResManager.GetInstance().SetImageSprite(this, this.simpleSelect, "marriage2_asset", type == 3 && "uijh_167" || "uijh_164")

			this.nomSelect2.visible = type == 1;
			this.expSelect2.visible = type == 2;
			this.simpleSelect2.visible = type == 3;
			this.nowSelect = type
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				this.day_id = parms[0]
				this.time_id = parms[1]
			}
			super.Open()
		}


	}

	public Open(...new_args) {
		this.Local_Open(new_args)
	}



	_Image1111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	closeBtn: Laya.Image
	_Label1: Laya.Label
	BG2: Laya.Image
	cancelBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	enterBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	simpleGroup: Laya.Box
	simpleSelect: Laya.Image
	simpleSelect2: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	simpleLabel: Laya.HTMLDivElement
	nomGroup: Laya.Box
	nomSelect: Laya.Image
	nomSelect2: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	nomLabel: Laya.HTMLDivElement
	expGroup: Laya.Box
	expSelect: Laya.Image
	expSelect2: Laya.Image
	_Image111: Laya.Image
	_Image12: Laya.Image
	_Image13: Laya.Image
	expLabel: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._Image1111,
			this._Image2,
			this._Image3,
			this._Image4,
			this.closeBtn,
			this._Label1,
			this.BG2,
			this.cancelBtn,
			this._Image1,
			this.labelDisplay1,
			this.enterBtn,
			this._Image11,
			this.labelDisplay,
			this.simpleGroup,
			this.simpleSelect,
			this.simpleSelect2,
			this._Image5,
			this._Image6,
			this._Image7,
			this.simpleLabel,
			this.nomGroup,
			this.nomSelect,
			this.nomSelect2,
			this._Image8,
			this._Image9,
			this._Image10,
			this.nomLabel,
			this.expGroup,
			this.expSelect,
			this.expSelect2,
			this._Image111,
			this._Image12,
			this._Image13,
			this.expLabel,
		]
			= this.GetChildrenByNames([

				"_Image1111",
				"_Image2",
				"_Image3",
				"_Image4",
				"closeBtn",
				"_Label1",
				"BG2",
				"cancelBtn",
				"_Image1",
				"labelDisplay1",
				"enterBtn",
				"_Image11",
				"labelDisplay",
				"simpleGroup",
				"simpleSelect",
				"simpleSelect2",
				"_Image5",
				"_Image6",
				"_Image7",
				"simpleLabel",
				"nomGroup",
				"nomSelect",
				"nomSelect2",
				"_Image8",
				"_Image9",
				"_Image10",
				"nomLabel",
				"expGroup",
				"expSelect",
				"expSelect2",
				"_Image111",
				"_Image12",
				"_Image13",
				"expLabel",
			])
	}
}
window["ChoseBanquetView"] = ChoseBanquetView