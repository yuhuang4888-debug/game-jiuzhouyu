import { BaseView1 } from "../common/BaseView1"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { LuaSoundManager } from "../common/SoundManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { HTMonsterItem } from "./HTMonsterItem"

export class HolyTerritoryMapView extends BaseView1 {
	CloseFunc
	InitEvent
	InitView
	Local_Open
	SelectTerritory
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	show_open_movie
	use_background

	public constructor() {
		super()

		let model = HolyTerritoryModel.GetInstance()
		let selectId_ = null
		let monsterPos_ = [[299, 328], [311, 530], [40, 450], [483, 262], [74, 280], [342, 740], [463, 600], [146, 620], [491, 440], [200, 150]]
		let defaultSelect_ = null
		let monsterCfg_ = null
		let monsterItemList_ = null
		this.base_file = "holyTerritory"
		this.layout_file = "HolyTerritoryMapView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.preload_server_config = {
			"config_sanctuary_mon": false,
			"config_dsgt": false
		}
		this.load_callback = () => {

			this.InitView()
			this.SetRed()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.CloseFunc()
		}

		this.InitEvent = () => {
			let i = 1
			do {
				// [ts2lua]this下标访问可能不正确
				let temp_i = i
				Util.AddClickEvent(this["terGroup" + i], () => {
					this.SelectTerritory(temp_i)
				}
					, this, true)
				i = i + 1
			} while ((i <= 3))

			Util.AddClickEvent(this.shopBtn, () => {
				OpenFun.OpenFunHandler(83)
				this.Close()
			}
				, this, true)

			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			this.BindEvent(model, HTEvent.UPDATE_MONSTER_DATA, (scmd?) => {
				if (scmd && selectId_ == scmd.sanctuary_id) {
					this.scoreLabel.style.fontSize = 20
					this.scoreLabel.style.align = "left"
					this.scoreLabel.style.color = "#ffffff"
					this.scoreLabel.width = 500
					this.scoreLabel.style.stroke = 2
					this.scoreLabel.style.strokeColor = "#3b484f"
					let str = "当前异域积分:<font color='#ffd041'>" + scmd.point + "</font>"
					this.scoreLabel.innerHTML = Util.StrToHTML(str)
					// [ts2lua]lua中0和空字符串也是true，此处scmd.belong_name需要确认
					this.hasLabel.style.fontSize = 20
					this.hasLabel.style.align = "left"
					this.hasLabel.style.color = "#ffffff"
					this.hasLabel.width = 500
					this.hasLabel.style.stroke = 2
					this.hasLabel.style.strokeColor = "#3b484f"
					this.hasLabel.innerHTML = Util.StrToHTML("占领结社:" + (scmd.belong_name ? ("<font color='#ffd041'>" + scmd.belong_name + "</font>") : ("暂无")))
					this.SelectTerritory(scmd.sanctuary_id)
				}
			}
			)
			Util.AddClickEvent(this.tips, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 28301)
			}
				, this, true)
			this.BindEvent(model, HTEvent.UPDATE_RED, () => {
				this.SetRed()
			}
			)
		}

		this.InitView = () => {
			monsterCfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sanctuary_mon", false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this.mapBG, GameResPath.GetIcon("holyTerritory", "ui_holyland_15"))
			//ResManager.GetInstance().SetOutsideImageSprite(this, this.pathBG, GameResPath.GetIcon("holyTerritory", "uisy_045"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("holyTerritory", "bg_03"))
			if (monsterCfg_) {
				this.SelectTerritory(defaultSelect_ || 1)
			}
		}

		this.Local_Open = (parm?) => {
			if (parm) {
				defaultSelect_ = parm
				if (this.is_loaded) {
					this.SelectTerritory(defaultSelect_)
				}
			}
			super.Open()
		}

		this.SelectTerritory = (id?) => {
			let i0 = 1
			do {
				// [ts2lua]this下标访问可能不正确
				this["Select" + i0].visible = id == i0
				// [ts2lua]this下标访问可能不正确
				this["Unselect" + i0].visible = id != i0
				i0 = i0 + 1
			} while ((i0 <= 3))
			let data = model.GetTerData(id)
			// [ts2lua]lua中0和空字符串也是true，此处data需要确认
			let bossData = (data && (data.boss_info) || (null))
			// [ts2lua]lua中0和空字符串也是true，此处data需要确认
			this.scoreLabel.style.fontSize = 20
			this.scoreLabel.style.align = "left"
			this.scoreLabel.style.color = "#ffffff"
			this.scoreLabel.width = 500
			this.scoreLabel.style.stroke = 2
			this.scoreLabel.style.strokeColor = "#3b484f"
			this.scoreLabel.innerHTML = Util.StrToHTML("当前异域积分:<font color='#ffd041'>" + (data && (data.point) || (0)) + "</font>")
			// [ts2lua]lua中0和空字符串也是true，此处data && data.belong_name需要确认
			this.hasLabel.style.fontSize = 20
			this.hasLabel.style.align = "left"
			this.hasLabel.style.color = "#ffffff"
			this.hasLabel.width = 500
			this.hasLabel.style.stroke = 2
			this.hasLabel.style.strokeColor = "#3b484f"
			this.hasLabel.innerHTML = Util.StrToHTML("占领结社:" + (data && (data.belong_name && data.belong_name != '') && ("<font color='#ffd041'>" + data.belong_name + "</font>") || ("暂无")))
			if (!monsterItemList_) {
				monsterItemList_ = []
			}
			let i = 0
			do {
				let item = monsterItemList_[i]
				if (!item) {
					//let group = eui. new Group()
					//this:addChild(group)
					//if (monsterPos_[i] ) {
					//group.x = monsterPos_[i][0]
					//group.y = monsterPos_[i][1]
					//}
					//group.name = "monGroup" + i
					item = new HTMonsterItem(this.display_obj)
					item.Load()
					monsterItemList_[i] = item
				}
				//item:ExcuteCallback(() => {
				if (bossData && bossData[i]) {
					// [ts2lua]monsterCfg_下标访问可能不正确
					item.SetCfg(monsterCfg_[id + "@" + bossData[i].boss_id], i)
					item.SetData(bossData[i])
					item.SetPos(monsterPos_[i][0], monsterPos_[i][1])
				}
				//}
				//)
				i = i + 1
			} while ((i < 10))
			selectId_ = id
		}

		this.CloseFunc = () => {
			if (monsterItemList_) {
				for (let _tmpi in monsterItemList_) {
					var vo = monsterItemList_[_tmpi]
					if (vo) {
						vo.DeleteMe()
						vo = null
					}
				}
				monsterItemList_ = null
			}
		}


	}

	public Open(...new_args) {

		this.Local_Open(...new_args)
		super.Open()
	}

	public SetRed() {
		let ht_red_list = HolyTerritoryModel.GetInstance().ht_red_dir
		for (let id in ht_red_list) {
			this[`red${id}`].visible = ht_red_list[id] ? true : false
		}
	}



	_Image1: Laya.Image
	_Image2: Laya.Image
	mapBG: Laya.Image
	pathBG: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Group1: Laya.Box
	_Image5: Laya.Image
	_title_lb: Laya.Label
	_Image6: Laya.Image
	closeBtn: Laya.Image
	tips: Laya.Image
	shopBtn: Laya.Image
	scoreLabel: Laya.HTMLDivElement
	hasLabel: Laya.HTMLDivElement
	terGroup2: Laya.Box
	Select2: Laya.Image
	Unselect2: Laya.Image
	terGroup3: Laya.Box
	Select3: Laya.Image
	Unselect3: Laya.Image
	terGroup1: Laya.Box
	Select1: Laya.Image
	Unselect1: Laya.Image
	red2: Laya.Image
	red1: Laya.Image
	red3: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this.mapBG,
			this.pathBG,
			this._Image3,
			this._Image4,
			this._Group1,
			this._Image5,
			this._title_lb,
			this._Image6,
			this.closeBtn,
			this.tips,
			this.shopBtn,
			this.scoreLabel,
			this.hasLabel,
			this.terGroup2,
			this.Select2,
			this.Unselect2,
			this.terGroup3,
			this.Select3,
			this.Unselect3,
			this.terGroup1,
			this.Select1,
			this.Unselect1,
			this.red2,
			this.red1,
			this.red3
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"mapBG",
				"pathBG",
				"_Image3",
				"_Image4",
				"_Group1",
				"_Image5",
				"_title_lb",
				"_Image6",
				"closeBtn",
				"tips",
				"shopBtn",
				"scoreLabel",
				"hasLabel",
				"terGroup2",
				"Select2",
				"Unselect2",
				"terGroup3",
				"Select3",
				"Unselect3",
				"terGroup1",
				"Select1",
				"Unselect1",
				"red2",
				"red1",
				"red3"
			])
	}
}
window["HolyTerritoryMapView"] = HolyTerritoryMapView