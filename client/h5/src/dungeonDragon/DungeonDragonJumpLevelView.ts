import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SceneManager } from "../scene/SceneManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt } from "../util/Util"
import { DungeonDragonRewardItem } from "./DungeonDragonRewardItem"
import { Config } from "../common/Config"

export class DungeonDragonJumpLevelView extends BaseView1 {
	LoadSuccess
	Local_Open
	array_reward_
	background_alpha
	change_scene_close
	click_bg_toClose
	destroy_callback
	is_center
	preload_server_config
	show_open_movie
	use_background


	public constructor() {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonJumpLevelView"
		this.layer_value = Enum_UILayer.Activity
		let base_model = BaseDungeonModel.GetInstance()
		let local_Util = Util
		let local_Config = Config
		let goods_model = GoodsModel.GetInstance()
		let local_ColorUtil = ColorUtil
		let local_ColorType = ColorType
		this.array_reward_ = null
		let data_ = null
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background = true
		this.background_alpha = 0
		this.click_bg_toClose = true
		this.is_center = true
		//this.preload_server_config = {"config_dungeon":false}
		this.load_callback = () => {

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)


			this.PreHtml()
			this.LoadSuccess()
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				data_ = parms[0]
			}
			super.Open()
		}

		this.LoadSuccess = () => {
			let data = data_
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonDragon", "uilxgj_001b"), true)
			// this.AddUIEffect("ui_aperture", this._gp_effect, null, null, true)
			// this.array_reward_ = eui. new ArrayCollection()
			// this._list_reward_con.dataProvider = this.array_reward_
			// this._list_reward_con.itemRenderer = DungeonDragonRewardItem
			this.array_reward_ = new LoopScrowViewMgr()
			this.array_reward_.SetData(this.Content, DungeonDragonRewardItem, [], LoopScrCon.Horizontal)


			Util.AddClickEvent(this._gp_get, () => {
				this.Close()
			}, this, true)


			
			let cur_dun_id = SceneManager.GetInstance().GetCurrDunId()
			// [ts2lua]this.preload_server_config下标访问可能不正确
			let cfg = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_dungeon.name, cur_dun_id, false, Config.ConfigHasDefaultValue.config_dungeon)
			let total_count = 0
			if (cfg) {
				total_count = cfg.wave_num - 1
			}
			let list = []
			if (data) {
				table.sort(data.reward_list, (a?, b?) => {
					let a_type_id, a_ = goods_model.GetMappingTypeId(a.style, a.typeId)
					let a_goods_vo = goods_model.GetGoodsBasicByTypeId(a_type_id)
					let b_type_id, b_ = goods_model.GetMappingTypeId(b.style, b.typeId)
					let b_goods_vo = goods_model.GetGoodsBasicByTypeId(b_type_id)
					if (a_goods_vo && b_goods_vo) {
						return b_goods_vo.color < a_goods_vo.color
					}
				}
				)
				for (let _tmpi in data.reward_list) {
					var vo = data.reward_list[_tmpi]
					table.insert(list, { size: 78, vo: vo })
				}
			}
			this.array_reward_.replaceAll(list)
			// let desc = "已达到跳关要求，将自动从"
			// desc = desc + HtmlColorTxt("第" + data.wave + "波", ColorUtil.GetColorDark(local_ColorType.GREEN))
			// desc = desc + "开始挑战"
			this._lb_tips.text = `已达到跳关要求，将自动从第${data.wave}波开始挑战`//Util.StrToHTML(desc)
			// let desc1 = "当前防守进度:"
			// desc1 = desc1 + 
			this._lb_tips0.innerHTML = Util.StrToHTML(`当前防守进度：${HtmlColorTxt(data.wave + "/" + total_count, "'#0a953e'")}`)
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	PreHtml(){
		this._lb_tips0.style.color="#663915"
		this._lb_tips0.style.fontSize=20
		this._lb_tips0.style.wordWrap=false
		this._lb_tips0.width=250
	}

	public Remove() {

		if (this.array_reward_) {
			this.array_reward_.DeleteMe()
			this.array_reward_ = null
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}

	public DeleteMe() {
		super.DeleteMe()
	}


_gp_effect:Laya.Box
_img_bg:Laya.Image
_img_bg2:Laya.Image
_Image_title:Laya.Image
titleLabel:Laya.Label
_lb_tips:Laya.Label
_lb_tips0:Laya.HTMLDivElement
_Label1:Laya.Label
_gp_get:Laya.Box
_Image4:Laya.Image
_Label2:Laya.Label
Content:Laya.List
_img_close:Laya.Image
public GetComponents() {
[
this._gp_effect,
this._img_bg,
this._img_bg2,
this._Image_title,
this.titleLabel,
this._lb_tips,
this._lb_tips0,
this._Label1,
this._gp_get,
this._Image4,
this._Label2,
this.Content,
this._img_close,
]
 = this.GetChildrenByNames([

"_gp_effect",
"_img_bg",
"_img_bg2",
"_Image_title",
"titleLabel",
"_lb_tips",
"_lb_tips0",
"_Label1",
"_gp_get",
"_Image4",
"_Label2",
"Content",
"_img_close",
])
}
}
 window["DungeonDragonJumpLevelView"]= DungeonDragonJumpLevelView