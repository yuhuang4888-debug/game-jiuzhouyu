import { BaseItem1 } from "../common/BaseItem1";
import { CommonRewardItem } from "../common/CommonRewardItem";
import { Config } from "../common/Config";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { WordManager } from "../common/WordManager";
import { DemonData } from "../commonModel/DemonData";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { ColorUtil, ColorType } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { SetAnchoredPositionX, SetAnchoredPosition, SetLocalScaleX, Util, HtmlColorTxt, SetHtmlStyle, SetHtmlCenter } from "../util/Util";
import { Vector2 } from "../util/Vector2";

export class DemonPaintingView extends BaseItem1 {
	demon_model
	icon_dic
	now_painting_id
	array_reward
	res_mgr: ResManager
	list_loop_mgr
	public constructor(parent?) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonPaintingView"
		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.icon_dic = null
		this.now_painting_id = null
		this.preload_client_config = {
			"ConfigDemon": false
		}
		this.preload_server_config = {
			"config_demons_painting": false
		}
		this.load_callback = () => {
			SetHtmlStyle(this._lb_attr0,{f:22,c:"#663915",li:3,ww:false,w:150})
			SetHtmlStyle(this._lb_attr1,{f:22,c:"#663915",li:3,ww:false,w:150})
			SetHtmlStyle(this._lb_desc,{f:22,c:"#663915",li:3,ww:false,w:720})
			SetHtmlStyle(this._lb_tips,{f:18,c:"#663915",li:3,ww:false,w:720})
			
			this._Scroller1.vScrollBar.visible = false
			this._Scroller2.scrollBar.visible = false
			this._Scroller3.hScrollBarSkin=""
			this._Scroller3.hScrollBar.changeHandler = Laya.Handler.create(this, this.OnSlide, null, false)


			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._bg, GameResPath.GetIconJpg("demon", "painting_bg"))

		if (!this.icon_dic) {
			this.icon_dic = {}
		}

		let client_demons = this.res_mgr.GetGameConfigFromCache(this, "ConfigDemon", true)
		for (let _tmpi in client_demons.Painting) {
			let vo = client_demons.Painting[_tmpi]
			let img = new Laya.Image
			this.Content1.addChild(img)
			img.x = vo.x
			img.y = vo.y
			img.scaleX = vo.scaleX
			img.scaleY = vo.scaleX
			img.name = String(vo.demons_id)
			this.res_mgr.SetOutsideImageSprite(this, img, GameResPath.GetIcon("demon", `demon_icon_${vo.demons_id}`))
			this.icon_dic[vo.demons_id] = img
		}

		this.InitPainting(client_demons)
		this.InitEvent()
		this.UpdateView()
		this._lb_tips.innerHTML =`妖灵达到${HtmlColorTxt("3星", "'#d15e00'")}方可点亮对应绘卷`
		SetHtmlCenter(this._lb_tips,{x:0,w:730})
		this._Image2.x = this._lb_tips.x-25
	}

	public InitPainting(client_demons) {
		for (let _tmpi in client_demons.Painting) {
			let vo = client_demons.Painting[_tmpi]
			this.UpdateImg(vo.demons_id)
		}
	}

	public UpdateImg(demons_id?) {
		let img = this.icon_dic[demons_id]
		if (img) {
			let demon_data: DemonData = this.demon_model.GetDemonData(demons_id)
			let bool = demon_data && demon_data.star >= 3
			Util.SetImageGray(img, !bool)
		}
	}

	public UpdateView() {

		let data = this.demon_model.GetPaintingData()
		let demons_painting_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_painting", false)
		if (data && demons_painting_cfgs) {
			let count = this.demon_model.GetTotalStarCount()
			let get_dic = {}
			let show_data = null
			let reward_list = []
			let red_state = false
			let is_all_get = true
			for (let _tmpi in data.painting_get) {
				let vo = data.painting_get[_tmpi]
				get_dic[vo.painting_id] = true
			}

			for (let painting_id in demons_painting_cfgs) {
				show_data = demons_painting_cfgs[painting_id]
				if (!get_dic[painting_id]) {
					is_all_get = false
					break
				}
			}

			this.now_painting_id = show_data.painting_id

			let attr_dic = {}
			let attr_list = null

			if (show_data) {
				attr_list = JSON.parse(show_data.attr)
				for (let _tmpi in attr_list) {
					let vo = attr_list[_tmpi]
					if (attr_dic[vo[0]]) {
						attr_dic[vo[0]] = attr_dic[vo[0]] + vo[1]
					} else {
						attr_dic[vo[0]] = vo[1]
					}
				}
			}

			let index = 0
			let attr0 = ""
			let attr1 = ""
			let attr_value = null
			for (let attr_id in attr_dic) {
				attr_value = attr_dic[attr_id]
				if (index % 2 == 0) {
					attr0 = attr0 + WordManager.GetProperties(Number(attr_id)) + ":"
					attr0 = attr0 + HtmlColorTxt(WordManager.ConvertToPercentValue(Number(attr_id), attr_value), "'#0a953e'") + "<br/>"
				} else {
					attr1 = attr1 + WordManager.GetProperties(Number(attr_id)) + ":"
					attr1 = attr1 + HtmlColorTxt(WordManager.ConvertToPercentValue(Number(attr_id), attr_value), "'#0a953e'") + "<br/>"
				}
				index = index + 1
			}
			this._lb_attr0.width = 150
			this._lb_attr1.width = 150
			this._lb_attr0.innerHTML = Util.StrToHTML(attr0)
			this._lb_attr1.innerHTML = Util.StrToHTML(attr1)
			
			let color = count >= show_data.painting_num ? "'#0a953e'" : "'#d15e00'"
			let desc = `已点亮妖灵总星数${HtmlColorTxt("(" + count + "/" + show_data.painting_num + ")", color)}时激活`
			this._lb_desc.innerHTML = Util.StrToHTML(desc)
			SetHtmlCenter(this._lb_desc,{x:0,w:720})

			let rewarad_data = JSON.parse(show_data.reward)
			for (let _tmpi in rewarad_data) {
				let vo = rewarad_data[_tmpi]
				reward_list.push({
					size: 75,
					vo: {
						style: vo[0],
						typeId: vo[1],
						count: vo[2]
					}
				})
			}
			if (!is_all_get) {
				red_state = count >= show_data.painting_num
			}
			this._gp_get.visible = !is_all_get
			this._img_received.visible = is_all_get

			this._img_red.visible = red_state

			Util.SetImageGray(this._gp_get, !this._img_red.visible)

			if (!this.list_loop_mgr) {
				this.list_loop_mgr = new LoopScrowViewMgr()
				this.list_loop_mgr.SetData(this._Scroller2, CommonRewardItem, reward_list, LoopScrCon.Horizontal)
			} else {
				this.list_loop_mgr.replaceAll(reward_list)
			}

			// this.array_reward.source = reward_list
			// this.array_reward.refresh()
		}
	}

	public InitEvent() {
		this.BindEvent(this.demon_model, DemonEvent.UPDATE_DEMON_DATA, (demons_id?) => {
			this.UpdateImg(demons_id)
		})

		this.BindEvent(this.demon_model, DemonEvent.UPDATE_PAINTING_DATA, (demons_id?) => {
			this.UpdateView()
		})

		Util.AddClickEvent(this._gp_get, () => {
			if (this.now_painting_id) {
				this.demon_model.Fire(DemonEvent.REQUEST_PROTO, 18308, this.now_painting_id)
			}
		}, this, true)
	}

	public DeleteMe() {
		this.icon_dic = undefined
		
		if (this._Scroller3 && this._Scroller3.hScrollBar&&this._Scroller3.hScrollBar.changeHandler) {
			this._Scroller3.hScrollBar.changeHandler.recover()
			this._Scroller3.hScrollBar.changeHandler = null
		}
		super.DeleteMe()
	}


	/**滑动条 */
	public OnSlide(value) {
		let p = value / this._Scroller3.hScrollBar.max //百分比
		this._slide_roll.x = this._slide_bg.x+(this._slide_bg.width -this._slide_roll.width)*p
	}



_bg1:Laya.Image
line_1:Laya.Image
_Scroller3:Laya.Panel
Content1:Laya.Box
_bg:Laya.Image
_slide_bg:Laya.Image
_slide_roll:Laya.Image
_bg2:Laya.Image
_Image2:Laya.Image
_lb_tips:Laya.HTMLDivElement
_gp_get:Laya.Box
_Image4:Laya.Image
_Label1:Laya.Label
_img_red:Laya.Image
_Label2:Laya.Label
_Scroller1:Laya.Panel
Content:Laya.HBox
_lb_attr0:Laya.HTMLDivElement
_lb_attr1:Laya.HTMLDivElement
_lb_desc:Laya.HTMLDivElement
_Scroller2:Laya.List
_img_received:Laya.Image
public GetComponents() {
[
this._bg1,
this.line_1,
this._Scroller3,
this.Content1,
this._bg,
this._slide_bg,
this._slide_roll,
this._bg2,
this._Image2,
this._lb_tips,
this._gp_get,
this._Image4,
this._Label1,
this._img_red,
this._Label2,
this._Scroller1,
this.Content,
this._lb_attr0,
this._lb_attr1,
this._lb_desc,
this._Scroller2,
this._img_received,
]
 = this.GetChildrenByNames([

"_bg1",
"line_1",
"_Scroller3",
"Content1",
"_bg",
"_slide_bg",
"_slide_roll",
"_bg2",
"_Image2",
"_lb_tips",
"_gp_get",
"_Image4",
"_Label1",
"_img_red",
"_Label2",
"_Scroller1",
"Content",
"_lb_attr0",
"_lb_attr1",
"_lb_desc",
"_Scroller2",
"_img_received",
])
}
}
 window["DemonPaintingView"]= DemonPaintingView