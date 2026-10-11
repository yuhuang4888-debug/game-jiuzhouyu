import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CookieWrapper } from "../common/CookieWrapper"
import { DownDropBtn } from "../common/DownDropBtn"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, LoadLuaConfigAB, PlayBigEffect, SetHtmlCenter } from "../util/Util"
import { SettingModel } from "../commonModel/SettingModel"
import { BagSmeltItemRender } from "./BagSmeltItemRender"
import { TaskTipType } from "../commonModel/TaskModel"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { PlatformManager } from "../PlatformManager"

export class BagSmeltView extends BaseView1 {


	ClickStage
	smelt_config
	model:BagModel
	destroy_imm
	stageBtn
	SetExp
	fight
	colorBtn
	SetSmletExp
	destroy_callback
	loop_mgr:LoopScrowViewMgr
	_Image8
	show_open_movie
	is_center
	SetOneStar
	img2
	SetAutoSmelt
	open_callback
	ClickColor
	InitEvnet
	click_bg_toClose
	UpdateView
	GetSmeltList
	selectList
	_Image6
	dropStage
	use_background
	InitView
	auto_time_

	public constructor() {
		super()


		this.model = BagModel.GetInstance()
		this.selectList = []
		this.dropStage = 99
		this.base_file = "bag"
		this.layout_file = "BagSmeltView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		let cookie_wrapper = CookieWrapper.GetInstance()
		let local_CookieWrapper = CookieWrapper
		let local_BagModel = BagModel
		let setting_model = SettingModel.GetInstance()
		let local_Util = Util
		let local_Erlang = ErlangParser.GetInstance()
		let local_GoodsModel = GoodsModel
		// let vip_model = VipModel.GetInstance()
		this.load_callback = () => {
			this.curLb.width = 720
			this.curLb.style.fontSize = 20
			this.curLb.style.color = "#7b5250"
			this.curLb.style.align = "center"

			LoadLuaConfigAB("Equipfusionattr", () => {
				this.InitView()
				let equip_fusion_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "pconfig_equip_fusion", false)
				this.model.CeateSmeltList(equip_fusion_cfgs)

				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this._Scroller1, BagSmeltItemRender, this.model.smelt_list, LoopScrCon.Vertical)
				}

				if (this.model.smelt_list.length == 0) {
					this.nothingLb.visible = true
				} else {
					this.nothingLb.visible = false
				}
				this.SetExp()
				this.SetOneStar(this.model.oneStar)
				//滚动到可熔炼的地方 要在SetOneStar方法后面
				let index =0
				for(let i = 0;i<this.model.smelt_list.length;i++){
					let data = this.model.smelt_list[i]
					if(this.model.smeltSelectList[data.goods_id]){
						index = i
						break;
					}
				}
				this.CallLater(()=>{
					this._Scroller1.scrollTo(index)
				})
			})
		}

		this.open_callback = () => {

		}

		this.destroy_callback = () => {
			if(this.auto_time_ ){
				clearTimeout(this.auto_time_ )
				this.auto_time_ =null
			}

			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			let obj = { "drop_color": this.model.dropColor, "drop_stage": this.model.dropStage, "oneStar": this.model.oneStar }
			if (this.colorBtn) {
				this.colorBtn.DeleteMe()
				this.colorBtn = null
			}
			if (this.stageBtn) {
				this.stageBtn.DeleteMe()
				this.stageBtn = null
			}
			if (this.fight) {
				this.fight.DeleteMe()
				this.fight = null
			}
			//cookie_wrapper:SaveCookie(local_CookieWrapper.BAG_SMELT_STATE, obj, true)
		}

		this.InitView = () => {
			this.model.Fire(local_BagModel.REQUEST_PROTO, 15024)
			this.smelt_config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_fusion_attr", false)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("common", "uisy_023"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.img2,GameResPath.GetIconJpg("bag","uirwv4_021"),true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image7,GameResPath.GetIcon("bag","uitips_004") )
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.expImg, GameResPath.GetIcon("bag","uitips_005"), false, () => {
			//     this.SetExp()
			// })
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image8, "client/assets/icon/bag/uirwv4_020.png", true)

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image6,GameResPath.GetIcon("common2","uity_016f"))

			this.colorBtn = new DownDropBtn(this.display_obj)
			// this.colorBtn.SetRes("bag", "BagDownDropSkinExml")


			this.stageBtn = new DownDropBtn(this.display_obj)
			// this.stageBtn.SetRes("bag", "BagDownDropSkinExml")

			this.fight = new FightingShowSmallItem(this.display_obj)
			this.fight.Load()
			this.fight.ExcuteCallback(() => {
				this.fight.display_obj.centerX = 0
				this.fight.display_obj.y = 105
			})


			let obj = cookie_wrapper.GetCookie(local_CookieWrapper.BAG_SMELT_STATE, true)
			if (obj) {
				let info = local_Erlang.Parse(obj)
				this.model.oneStar = info.oneStar || this.model.oneStar
				this.model.dropColor = info.drop_color || this.model.dropColor
				this.model.dropStage = info.drop_stage || this.model.dropStage
			}
			let setting_list = setting_model.GetSettingData(4)
			if (setting_list) {
				let vo = setting_list[1]
				if (vo) {
					this.model.autoSmelt = vo.is_open == 1
				}
			}
			this.SetExp()
			this.InitEvnet()

			let defaultText = "任意阶数"
			let stageList = this.model.GetStageDropData()
			for (let key in stageList) {
				let vo = stageList[key]
				if (vo.cond == this.model.dropStage) {
					defaultText = vo.content
				}
			}
			this.stageBtn.Init(stageList,
				this.ClickStage
				, defaultText, "content", this.layer_value, 7, false, false)
			this.stageBtn.Load()
			this.stageBtn.ExcuteCallback(() => {
				if(PlatformManager.IsEyouPlatform()){
					this.stageBtn.SetPosition(466,681)
				}else{
				this.stageBtn.SetPosition(106, 701)
				}
			})


			let colorList = this.model.GetColorDropData()
			defaultText = "橙色装备"
			for (let key in colorList) {
				let vo = colorList[key]
				if (vo.cond == this.model.dropColor) {
					defaultText = vo.content
				}
			}
			this.colorBtn.Init(colorList,
				this.ClickColor, defaultText, "content", this.layer_value, null, false, false)
			this.colorBtn.Load()
			this.colorBtn.ExcuteCallback(() => {
				if(PlatformManager.IsEyouPlatform()){
					this.colorBtn.SetPosition(279,681)
				}else{
				this.colorBtn.SetPosition(429, 701)
				}
			})

			this.curLb.visible = false

			this.GetSmeltList(this.model.dropStage, this.model.dropColor)

			this.SetSmletExp()

			this.select0.visible = this.model.autoSmelt
			this.Unselect0.visible = !this.model.autoSmelt
		}

		this.InitEvnet = () => {
			let gModel = GoodsModel.GetInstance()
			Util.AddClickEvent(this.closeBtn, () => {
				if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.FusionEquip)) {
					this.story_model.curr_view_story_step = 4 //防止关闭步数没增加
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
				}
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.propBtn, () => {
				let cfg = this.smelt_config
				let lv = this.model.smelt_level
				let c = cfg[lv]
				if (cfg && c) {
					let attr = JSON.parse(c.attr_list)
					this.model.Fire(local_BagModel.OPEN_VIEW, "SmeltPropView", attr)
				}
			}
				, this, true)

			Util.AddClickEvent(this.useBtn, () => {
				if (Util.IsTableEmpty(this.model.smeltSelectList)) {
					Message.show("当前没有选择可以吞噬的道具")
					return
				}
				gModel.Fire(local_GoodsModel.SMELTING_ARTIFACT)
			}
				, this, true)

			Util.AddClickEvent(this.autoGp, () => {
				this.SetAutoSmelt(!this.model.autoSmelt)
			}
				, this, false)

			Util.AddClickEvent(this.oneStarGp, () => {
				this.SetOneStar(!this.model.oneStar)
			}
				, this, false)

			let SmeltSuccess = () => {
				this.model.smeltSelectList = {}
				this.model.smeltNum = 0
				this.model.ChangeVar("CurExp", 0)
				this.UpdateView()
				PlayBigEffect("ui_tunshichenggong")
				this.GetSmeltList(this.model.dropStage, this.model.dropColor)
				if(this.auto_time_ ){
					clearTimeout(this.auto_time_ )
					this.auto_time_ =null
				}
				if(this.model.smeltSelectList&&!Util.IsTableEmpty(this.model.smeltSelectList)){
					this.auto_time_ = setTimeout(() => {
						gModel.Fire(local_GoodsModel.SMELTING_ARTIFACT)
					}, 800);
				}
			}

			this.BindEvent(this.model, local_BagModel.SMELTING_SUCCESS, SmeltSuccess)
			let OnExpChange = () => {
				this.SetExp()
			}
			this.BindEvent(gModel, local_GoodsModel.ON_SMELTING_EXP, OnExpChange)

			this.BindVar(this.model, "CurExp", () => {
				this.SetSmletExp()
			})

			let AutoSmeltSet = (scmd?) => {
				if (scmd.type == 4 && scmd.subtype == 1) {
					this.select0.visible = scmd.is_open == 1
					this.Unselect0.visible = scmd.is_open != 1
				}
			}
			this.BindEvent(setting_model, SettingModel.UPDATE_ONE_SETTING_INFO, AutoSmeltSet)

			this.BindEvent(gModel, local_GoodsModel.CHANGE_BAG_LIST, (list?) => {
				if (!list || this.use_delete_method) {
					return
				}
				let change = false
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					if (vo.goods_num == 0 && this.model.smeltSelectList[vo.goods_id]) {
						let equip_fusion_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_fusion", false)
						this.model.SelectSmeltGoods(vo.goods_id, vo.type_id, false, equip_fusion_cfgs)
						change = true
					}
				}
				if (change) {
					this.UpdateView()
				}
			}
			)
		}

		this.SetExp = () => {
			if (!this.smelt_config) { return }
			let c = this.smelt_config[this.model.smelt_level] // Config.GetConfigVo(Config.ConfigHasDefaultValue.cconfig_equip_fusionattr.name, this.model.smelt_level, false,this.smelt_config)
			if (c) {
				let cfg = c
				let max = cfg.exp_need
				this.expLb.text = this.model.smelt_exp + "/" + max
				this.lvLb.text = "Lv." + this.model.smelt_level

				this.expImg.width = Math.min(this.model.smelt_exp / max, 1) * 365
				if (this.fight) {
					if (this.model.smelt_level > 0) {
						this.fight.Updatefighting(Util.CalAttrPower(cfg.attr_list, true))
					} else {
						this.fight.Updatefighting(0)
					}
					if(this.fight.display_obj){
						this.fight.display_obj.centerX = 0
					}
				}
			}
		}

		this.SetSmletExp = () => {
			if (this.model.CurExp == 0) {
				this.curLb.visible = false
			} else {
				this.curLb.visible = true
				//vip模块 不要删
				// let vip_card = vip_model.GetNobleCardState()
				// let vip_flag = RoleManager.GetInstance().GetMainRoleVo().vip_flag
				let value = 0 // vip_model.GetVipPrivilegeValue(150, 3, vip_card, vip_flag)
				let up = 1 + value / 100
				let vipstr = ""
				if (up > 1) {
					vipstr = "<font color='#639c12'>(vip+" + value + "%)</font>"
				}
				this.curLb.innerHTML = Util.StrToHTML("本次吞噬经验:<font color='#00b11d'>" + Mathf.Round(this.model.CurExp * up) + "</font>" + vipstr)
				this.curLb.width = 720
				SetHtmlCenter(this.curLb,{x:0,w:720})
			}
		}

		this.UpdateView = () => {
			let equip_fusion_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_fusion", false)
			this.model.CeateSmeltList(equip_fusion_cfgs)
			this.loop_mgr.replaceAll(this.model.smelt_list)
			if (this.model.smelt_list.length == 0) {
				this.nothingLb.visible = true
			} else {
				this.nothingLb.visible = false
			}
		}

		this.ClickStage = (index?, data?) => {
			if (data && data.cond) {
				this.model.dropStage = data.cond
				this.GetSmeltList(this.model.dropStage, this.model.dropColor)
			} else {
				this.model.ClearSmletSelect()
			}
		}

		this.ClickColor = (index?, data?) => {
			if (data && data.cond) {
				this.model.dropColor = data.cond
				this.GetSmeltList(this.model.dropStage, this.model.dropColor)
			} else {
				this.model.ClearSmletSelect()
			}
		}

		this.SetAutoSmelt = (bool?) => {
			if (bool) {
				Alert.Show("勾选后将会自动吞噬橙色一星及以下、评分比身上装备评分低的装备", Alert_Type.Two, () => {
					//setting_model:Fire(SettingModel.SETTING_REQUEST_PROTO, 10203, "ccc", 4, 1,  1 )
					let setting_list = []
					table.insert(setting_list, setting_model.Package10203ItemData(1, 1, 4))
					setting_model.PackageAndSend10203(setting_list)
				}
				)
			} else {
				//setting_model:Fire(SettingModel.SETTING_REQUEST_PROTO, 10203, "ccc", 4, 1, 0)
				let setting_list = []
				table.insert(setting_list, setting_model.Package10203ItemData(1, 0, 4))
				setting_model.PackageAndSend10203(setting_list)
			}
		}

		this.SetOneStar = (bool?) => {
			this.model.oneStar = bool
			this.GetSmeltList(this.model.dropStage, this.model.dropColor)
			this.select1.visible = bool
			this.Unselect1.visible = !bool
		}

		this.GetSmeltList = (drop_stage?, drop_color?) => {
			this.model.GetSmeltList(drop_stage, drop_color, ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_attr", false), ResManager.GetInstance().GetGameConfigFromCache(this, "config_equip_fusion", false))
		}
	}

	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}
		this.story_obj_list = this.story_obj_list || {}
		this.story_obj_list[TaskTipType.FusionEquip] = [null,null,this.useBtn,this.closeBtn]
		super.createChildren()
	}


_img_bg:Laya.Image
closeBtn:Laya.Box
_img_close:Laya.Image
_Image4:Laya.Image
_Image5:Laya.Image
_Image7:Laya.Image
expImg:Laya.Image
_Scroller1:Laya.List
propBtn:Laya.Image
expLb:Laya.Label
curLb:Laya.HTMLDivElement
lvLb:Laya.Label
nothingLb:Laya.Label
autoGp:Laya.Box
select0:Laya.Image
Unselect0:Laya.Image
_Label1:Laya.Label
oneStarGp:Laya.Box
select1:Laya.Image
Unselect1:Laya.Image
_Label2:Laya.Label
effectGp:Laya.Box
useBtn:Laya.Box
public GetComponents() {
[
this._img_bg,
this.closeBtn,
this._img_close,
this._Image4,
this._Image5,
this._Image7,
this.expImg,
this._Scroller1,
this.propBtn,
this.expLb,
this.curLb,
this.lvLb,
this.nothingLb,
this.autoGp,
this.select0,
this.Unselect0,
this._Label1,
this.oneStarGp,
this.select1,
this.Unselect1,
this._Label2,
this.effectGp,
this.useBtn,
]
 = this.GetChildrenByNames([

"_img_bg",
"closeBtn",
"_img_close",
"_Image4",
"_Image5",
"_Image7",
"expImg",
"_Scroller1",
"propBtn",
"expLb",
"curLb",
"lvLb",
"nothingLb",
"autoGp",
"select0",
"Unselect0",
"_Label1",
"oneStarGp",
"select1",
"Unselect1",
"_Label2",
"effectGp",
"useBtn",
])
}
}
 window["BagSmeltView"]= BagSmeltView