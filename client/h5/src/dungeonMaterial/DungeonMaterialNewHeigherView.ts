
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { Config } from "../common/Config"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { HtmlColorTxt, SetHtmlCenter, SetHtmlStyle, TransformLevel, Util } from "../util/Util"
import { VipModel } from "../commonModel/VipModel"
import { ColorUtil, Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { SceneManager } from "../scene/SceneManager"


export class DungeonMaterialNewHeigherView extends BaseView1 {

	InitEvent
	LoadSuccess
	SetStarNum
	
	AddImage

	dungeon_data_ = null
	dungeon_model: BaseDungeonModel
	resmgr: ResManager
	dun_data
	dun_cha_time
	reward_item_list_
	scroll_bar
	left_count_


	public constructor(parent?) {
		super()
		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonMaterialNewHeigherView"
		this.layer_value =  Enum_UILayer.UI
		this.use_background=true
		this.is_center=true
		this.change_scene_close=true
		this.dungeon_data_ = null
		this.dungeon_model = BaseDungeonModel.GetInstance()
		this.resmgr = ResManager.GetInstance()
		this.destroy_imm=true
		this.click_bg_toClose=true
		this.dun_data = null
		this.dun_cha_time=0
		this.load_callback = () => {
			SetHtmlStyle(this._text_challenge_num, { c: "#663915", f: 20, w: 254, ww: false })
			this.InitEvent()

			this.UpdateView()
		}


		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_one_key, ()=>{
				this.dungeon_model.RequestDungeonChallenge(1)
				this.Close()
			}, this, true)

			let challenge_func = () => {
				this.dungeon_model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, this.dun_data.dun_id)
			}
			Util.AddClickEvent(this._gp_challenge, ()=>{
				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}
				
				//先退出队伍
				if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(this.dun_data.dun_id)) return
				challenge_func()
			}, this, true)


			Util.AddClickEvent(this._img_close, ()=>{
				this.Close()
			}, this, true)
			this.BindEvent(this.dungeon_model, BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id)=>{
				if(this.dun_data&&this.dun_data.dun_id==dun_id){
					challenge_func()
				}
			})

		}



		this.SetStarNum = (num) => {
			for (let i = 1; i <= this._box_star.numChildren; i++) {
				if (i <= num) {
					this.resmgr.SetImageSprite(this, this["_img_star_" + i], "dungeonCommon", "star2")
				} else {
					this.resmgr.SetImageSprite(this, this["_img_star_" + i], "dungeonCommon", "star_empty")
				}
			}
		}




		this.AddImage = (i, item, dun_type) => {
			if (dun_type == 18 && i == 1)
				return
			if (item) {
				let img = new Laya.Image()
				ResManager.GetInstance().SetImageSprite(this, img, "dungeonMaterial", "uifnpj_012ew", true)
				item.display_obj.addChild(img)
				img.scaleX = img.scaleY = 1.3
				img.x = 0
				img.y = 0

			}
		}


		this.close_callback=()=>{

		}


	}

	// { dun_type: dun_type, index: material_type_dic_[dun_type] }
	public UpdateView() {
		if(!this.dun_data)return
		this.resmgr.SetTexture(this, this._img_title, GameResPath.GetIconOtherPath("dungeonMaterial", `ui_dungeon_type_${this.dun_data.type}`))
		this.resmgr.SetTexture(this, this._img_bg, GameResPath.GetIconOtherPath("dungeonMaterial", `ui_copy_zyfb_20`))

		let roleManager = RoleManager.GetInstance()


		//挑战次数
		this._text_challenge_num.innerHTML = `今日挑战次数：${HtmlColorTxt("1/1", '"#0a953e"')}`
		SetHtmlCenter(this._text_challenge_num, { x: 309, w: 254 })


		//推荐战力
		let dun_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon[this.dun_data.dun_id]
		let fighting = roleManager.GetMainRoleVo().fighting
		if (dun_cfg) {
			this._text_fight.text = dun_cfg.recommend_power + ""
			let color = fighting >= dun_cfg.recommend_power ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.RED
			this._text_fight.color = ColorUtil.GetReplaceChar(color)
		}


		//当前难度
		let dun_name: String = this.dun_data.name
		let name2 = dun_name.slice(dun_name.indexOf("(") + 1, dun_name.length - 1)
		this._text_3.text = name2 + "："
		this._text_3.color = this.dungeon_model.GetTextColor(this.dun_data.dun_id)

		//设置星星
		this.SetStarNum(this.dungeon_model.GetValByKey(2, this.dun_data.rec_data))

		//设置按钮
		this._gp_one_key.visible=this.dun_cha_time>0?true:false
		this._gp_challenge.x=this.dun_cha_time>0?368:235
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public Open(...new_args) {

		this.dun_data = new_args[0]
		this.dun_cha_time = new_args[1]
		super.Open()
	}


_bg:Laya.Image
_img_bg:Laya.Image
_img_close:Laya.Image
_img_title:Laya.Image
_text_desc:Laya.Text
_text_1:Laya.Text
_text_2:Laya.Text
_text_3:Laya.Text
_text_fight:Laya.Text
_text_challenge_num:Laya.HTMLDivElement
_box_star:Laya.Box
_img_star_1:Laya.Image
_img_star_2:Laya.Image
_img_star_3:Laya.Image
_gp_challenge:Laya.Box
_Image1:Laya.Image
_Label2:Laya.Label
_gp_one_key:Laya.Box
_Image2:Laya.Image
_Label3:Laya.Label
public GetComponents() {
[
this._bg,
this._img_bg,
this._img_close,
this._img_title,
this._text_desc,
this._text_1,
this._text_2,
this._text_3,
this._text_fight,
this._text_challenge_num,
this._box_star,
this._img_star_1,
this._img_star_2,
this._img_star_3,
this._gp_challenge,
this._Image1,
this._Label2,
this._gp_one_key,
this._Image2,
this._Label3,
]
 = this.GetChildrenByNames([

"_bg",
"_img_bg",
"_img_close",
"_img_title",
"_text_desc",
"_text_1",
"_text_2",
"_text_3",
"_text_fight",
"_text_challenge_num",
"_box_star",
"_img_star_1",
"_img_star_2",
"_img_star_3",
"_gp_challenge",
"_Image1",
"_Label2",
"_gp_one_key",
"_Image2",
"_Label3",
])
}
}
 window["DungeonMaterialNewHeigherView"]= DungeonMaterialNewHeigherView