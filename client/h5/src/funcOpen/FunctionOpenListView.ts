import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { Util } from "../util/Util"
import { FunctionOpenListItem } from "./FunctionOpenListItem"

export class FunctionOpenListView extends BaseView1 {

	LoadSuccess
	Local_Open
	InitEvent
	SetData
	SetContent
	loop_mgr:LoopScrowViewMgr
	public constructor() {
		super();
		let model = FunctionOpenModel.GetInstance(),
			data_,
			item_list_
			// arrayCollection_: eui.ArrayCollection

		this.base_file = "functionOpen";
		this.layout_file = "FunctionOpenListView";
		this.layer_value = Enum_UILayer.Activity;
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true


		
		this.use_background = true
		this.click_bg_toClose = true
		this.not_show_main_msg = true
		this.not_show_attr_main_msg = true
		this.load_callback = function () {
			this.LoadSuccess();
			this.InitEvent();
		}
		this.open_callback = function () {
			this.SetData()
		}
		this.close_callback = function () {

		}
		this.destroy_callback = function () {
			if (item_list_) {
				for (let obj of item_list_) {
					obj.DeleteMe()
				}
			}
			item_list_ = null
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}
		this.LoadSuccess = () => {
			item_list_ = []
			this.Content.scrollBar.visible = false
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, "resource/game/functionOpen/texture/ui_notice_01.png", true)

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image2, "resource/game/functionOpen/texture/uignyg_007.png", true)
		}

		this.Local_Open = (parms) => {
			[data_] = parms
			super.Open()
		}

		this.InitEvent = () => {
			let close_fun = () => {

				this.Close()
			}
			Util.AddClickEvent(this.close_btn, close_fun, this, true)
		}

		this.SetData = () => {
			this.SetContent()
		}

		this.SetContent = () => {
			if (model.real_show_open_list) {

				//排序
				if (model.real_show_open_list) model.real_show_open_list.sort(model.SortFuncOpen)

				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content, FunctionOpenListItem, model.real_show_open_list, LoopScrCon.Horizontal, undefined)
				} else {
					this.loop_mgr.replaceAll(model.real_show_open_list)
				}

				let index = 0
				let max_red_index = 0
				if (model.finish_fun_data) {
					let find = false
					for (let vo of model.real_show_open_list) {
						index++
						find = false
						for (let tmp of model.finish_fun_data) {
							if (vo.id == tmp.id) {
								if (tmp.state != 2) {
									find = true
									max_red_index = index
								}
								break
							}
						}
						if (find) {
							break
						}
					}
					if (!find){
						index = 0
						for (let vo of model.real_show_open_list) {
							index++
							find = false
							for (let tmp of model.finish_fun_data) {
								if (vo.id == tmp.id) {
									find = true
									break
								}
							}
							if (!find) {
								break
							}
						}
					}
					// if (!find && index == Util.TableSize(model.real_show_open_list)){
					// 	index = 0
					// }
				}
				if (index > 2) {
					if (max_red_index) {		//显示最大的可领取奖励的位置
						index = (max_red_index > 2) ? max_red_index : 2
					}
					index = index - 2
					this.Content.scrollTo(index)
					// let width = 173 + 15
					// let scroll_to = index * width
					// if (scroll_to > this.scroll_group.width - this.scroll.width) {
					// 	scroll_to = this.scroll_group.width - this.scroll.width
					// }
					// this.scroll_group.validateNow()
					// this.scroll_group.scrollH = scroll_to
				}
			}
		}
	}


	public Open(...parms) {
		this.Local_Open(parms)
	}
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	close_btn: Laya.Image
	Content: Laya.List
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this.close_btn,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"close_btn",
				"Content",
			])
	}
}
window["FunctionOpenListView"] = FunctionOpenListView