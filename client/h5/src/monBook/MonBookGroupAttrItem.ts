import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { MonBookModel } from "../commonModel/MonBookModel"
import { MonBookAttrItem } from "./MonBookAttrItem"

export class MonBookGroupAttrItem extends BaseItem1 {
	need_refresh_data
	model
	vo
	attr_list

	public constructor(parent) {
		super(parent)
		this.base_file = "monBook"
		this.layout_file = "MonBookGroupAttrItem"
		this.need_refresh_data = false
		this.model = MonBookModel.GetInstance()
		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public DeleteMe() {
		if (this.attr_list) {
			for (let vo of this.attr_list) {
				vo.DeleteMe()
			}
			this.attr_list = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {
		this._Scroller1.vScrollBar.visible = false
		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public InitEvent() {

	}


	public SetData(vo) {
		this.vo = vo
		if (this.is_loaded) {
			this.UpdateView()
		}
		else
			this.need_refresh_data = true
	}

	private UpdateView() {
		if (this.vo) {
			let curr_lv = this.model.GetBookGroupLevel(this.vo.type, this.vo.id)
			let max_lv = this.model.GetBookGroupMaxLevel(this.vo.id)

			let str = `全部图谱达到<font color='#0a953e'>Lv.${curr_lv + 1}</font>`
			if (curr_lv >= max_lv)
				str = "已达最大共鸣等级"
			this._lb_tips.innerHTML = str

			this.SetPropInfo()
		}
	}

	private SetPropInfo() {
		let data = this.vo
		let curr_lv = this.model.GetBookGroupLevel(data.type, data.id)
		let cfg
		let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_mon_pic_group", false)
		if (curr_lv == 0) {
			cfg = config[data.id + "@1"]
		}
		else {
			cfg = config[data.id + "@" + curr_lv]
		}
		if (!cfg)
			return
		let curr_value_list = []

		let str, value
		let list = JSON.parse(cfg.attr)
		if (list && list.length > 0) {
			for (let i in list) {
				let v = list[i]
				let data = {}
				if (!curr_value_list[i])

					if (curr_lv == 0) {
						data["now_value"] = 0
					}
					else {
						value = WordManager.ConvertToPercentValue(Number(v[0]), Number(v[1]))
						data["now_value"] = value
					}
				str = WordManager.GetProperties(v[0])
				data["name"] = str + "："
				curr_value_list.push(data)
			}
		}

		cfg = config[data.id + "@" + (curr_lv + 1)]

		if (cfg) {
			list = JSON.parse(cfg.attr)
			if (list && list.length > 0) {
				for (let i in list) {
					let data = curr_value_list[i]

					let v = list[i]
					value = WordManager.ConvertToPercentValue(Number(v[0]), Number(v[1]) - (data.value || 0))
					data["add_value"] = value
				}
			}
		}

		if (!this.attr_list)
			this.attr_list = []

		let len = curr_value_list.length
		for (let i = len; i < this.attr_list.length; i++)
			this.attr_list[i].visible = false
		for (let key in curr_value_list) {
			let item = this.attr_list[key]
			if (!item) {
				item = new MonBookAttrItem(this.Content)
				this.attr_list[key] = item
				item.Load()
			}
			item.SetData(curr_value_list[key])
			item.visible = true
		}
	}
	

	_Image1: Laya.Image
	_Image2: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.Box
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._lb_tips,
			this._Scroller1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_lb_tips",
				"_Scroller1",
				"Content",
			])
	}
}
window["MonBookGroupAttrItem"] = MonBookGroupAttrItem