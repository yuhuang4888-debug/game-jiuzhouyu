import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { TempleAwakenModel, TempleAwakenEvent } from "../commonModel/TempleAwakenModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TransformLevel, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { TempleAwakenItem } from "./TempleAwakenItem"
import { Config } from "../common/Config"
import { BabyTreasureTaskItem } from "../runeTreasure/BabyTreasureTaskItem"

export class TempleAwakenMainView extends BaseItem1 {

	loop_mgr
	LocalDeleteMe
	LoadSuccess
	InitEvent
	ReOpen_callback
	CreateModel
	UpdateView
	SetOpenCondition
	SetSelectState
	GetModelId
	curr_sorting_order

	SetTask
	UpdateChapterStage
	UpdateSubChapter
	SetWearStage
	SetGary
	SelectFunc

	circle_mask: Laya.Sprite
	DrawMask
	public constructor(parent?) {
		super(parent)
		this.base_file = "templeAwaken"
		this.layout_file = "TempleAwakenMainView"
		this.layer_value = Enum_UILayer.UI

		let model = TempleAwakenModel.GetInstance()
		let now_chapter = null
		let now_sub_chapter = null
		let unlock_sub_chapter = 1
		let chapter_list = []
		let last_chapter = 0
		let sub_chapter_img_fill = [
			0.08,
			0.54,
			1
		]

		this.load_callback = () => {
			//添加遮罩
			this.circle_mask = new Laya.Sprite()
			this.circle_mask.x = this.sub_chapter_img.x
			this.circle_mask.y = this.sub_chapter_img.y
			this.sub_chapter_img.mask = this.circle_mask

			//this.curr_sorting_order = Util.AddCurrLayerSortingOrder(this.layer_value)
			this.LoadSuccess()
			this.InitEvent()
		}
		this.ReOpen_callback = () => {
			this.CreateModel()
		}

		this.LocalDeleteMe = () => {
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			last_chapter = 0
		}

		this.LoadSuccess = () => {
			now_chapter = model.GetNowChapter()
			now_sub_chapter = model.GetNowSubChapter(now_chapter)
			unlock_sub_chapter = now_sub_chapter
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken", false)//Config.Templeawaken
			for (let _ in cfg) {
				var v = cfg[_]
				table.insert(chapter_list, v.chapter_id)
			}
			table.sort(chapter_list, (a?, b?) => {
				return a < b
			})
			this.UpdateView()
		}

		this.InitEvent = () => {
			this.BindEvent(model, TempleAwakenEvent.UPDATE_VIEW, () => {
				last_chapter = now_chapter
				now_chapter = model.GetNowChapter()
				now_sub_chapter = model.GetNowSubChapter(now_chapter, true)
				this.UpdateView()
			}
			)
			this.BindEvent(model, TempleAwakenEvent.UPDATE_WEAR_STAGE, () => {
				this.SetWearStage()
			}
			)
			Util.AddClickEvent(this.fashion_gp, () => {
				if (!this.fashion_select.visible) {
					this.SetSelectState(1)
					this.SelectFunc(1)
				}
			}
				, this, true)

			Util.AddClickEvent(this.artifact_gp, () => {
				if (!this.artiface_select.visible) {
					this.SetSelectState(4)
					this.SelectFunc(4)
				}
			}
				, this, true)

			Util.AddClickEvent(this.wing_gp, () => {
				if (!this.wing_select.visible) {
					this.SetSelectState(3)
					this.SelectFunc(3)

				}
			}
				, this, true)
			Util.AddClickEvent(this.hallow_gp, () => {
				if (!this.hallow_select.visible) {
					this.SetSelectState(2)
					this.SelectFunc(2)
				}
			}
				, this, true)
			Util.AddClickEvent(this.mount_gp, () => {
				if (!this.mount_select.visible) {
					this.SetSelectState(5)
					this.SelectFunc(5)

				}
			}
				, this, true)

			Util.AddClickEvent(this.check_gp, () => {
				let bool = !this.check_img.visible && 1 || 0
				model.Fire(TempleAwakenEvent.REQUEST_PROTO, 42908, "hc", now_chapter, bool)
			}
				, this, false)
			this.BindEvent(model, TempleAwakenEvent.UPDATE_TASK_ITEM, () => {
				this.SetTask()
			}
			)
			model.Fire(TempleAwakenEvent.REQUEST_PROTO, 42901)
		}

		this.SelectFunc = (index?) => {
			last_chapter = now_chapter
			now_chapter = chapter_list[index - 1]
			let main_chapter_info = model.GetMainChapterInfo()
			let info = main_chapter_info[now_chapter]
			now_sub_chapter = (info && info.status != 1) && 3 || model.GetNowSubChapter(now_chapter)

			let gray = (this.mount_gp.getChildAt(0) as Laya.Image).gray
			if (gray) {
				this.CreateModel()
				this.SetOpenCondition(true)
				this.SetWearStage()
			} else {
				this.UpdateView()
			}

		}


		this.UpdateView = () => {
			this.UpdateChapterStage()
			this.UpdateSubChapter()
			this.SetTask()
			this.SetOpenCondition()
			this.SetWearStage()
			this.CreateModel()
		}

		this.SetSelectState = (index?) => {

			for (let i = 0; i < this.chapter_gp.numChildren; i++) {
				let box: Laya.Box = this.chapter_gp.getChildAt(i) as Laya.Box
				if (box) {
					let img: Laya.Image = box.getChildAt(3) as Laya.Image
					if (img) img.visible = i == (index - 1)
				}
			}

			this.UpdateSubChapter()
			this.SetTask()
		}

		this.UpdateChapterStage = () => {
			let main_chapter_info = model.GetMainChapterInfo()
			let index = 1
			if (main_chapter_info && Util.TableSize(main_chapter_info) > 0) {
				index = Util.TableSize(main_chapter_info)
			}
			for (let i = 0; i < this.chapter_gp.numChildren; i++) {
				let obj = this.chapter_gp.getChildAt(i)
				//let gameobject = obj.gameObject
				if (i < index) {
					this.SetGary(obj, false)
				} else {
					this.SetGary(obj, true)
				}
			}
		}

		this.UpdateSubChapter = () => {
			//进行中
			let value = 0
			value = sub_chapter_img_fill[now_sub_chapter - 1]
			this.DrawMask(value)

		}

		this.DrawMask = (width) => {
			let w = width * 251
			this.circle_mask.graphics.clear();
			this.circle_mask.graphics.drawRect(-6, -6, w, 24, 0x000000, "#ffffff")
		}


		this.SetGary = (obj?, bool?) => {
			for (let i = 0; i <= obj.numChildren - 2; i++) {
				let img = obj.getChildAt(i) as Laya.Image
				img.gray = bool
			}
		}

		this.SetTask = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken_stage", false)//Config.Templeawakenstage
			let task_list = []
			let task_info = model.GetSubChapterTaskInfo()
			for (let _ in cfg) {
				var v = cfg[_]
				if (v.chapter_id == now_chapter && v.sub_chapter == now_sub_chapter) {
					let data = task_info[now_chapter] && task_info[now_chapter][now_sub_chapter] && task_info[now_chapter][now_sub_chapter][v.stage]
					table.insert(task_list, { chapter: v.chapter_id, sub_chapter: v.sub_chapter, info: v, is_receive: (data && data.status && data.status == 2) && 1 || 0, handing: (data && data.status && data.status == 1) && 1 || 0 })
				}
			}
			table.sort(task_list, (a?, b?) => {
				if (a.is_receive == b.is_receive) {
					if (a.handing == b.handing) {
						return a.info.stage < b.info.stage
					} else {
						return a.handing > b.handing
					}

				} else {
					return a.is_receive > b.is_receive
				}
			})
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, TempleAwakenItem, task_list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(task_list)
			}
		}

		this.SetOpenCondition = (preview?) => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken", false)//Config.Templeawaken
			let chapter_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken_stage", false)// Config.Templeawakenstage
			let condition = null
			let main_chapter_info = model.GetMainChapterInfo()
			let sub_info = model.GetSubChapterInfo()
			for (let _ in cfg) {
				var v = cfg[_]
				if (v.chapter_id == now_chapter) {
					condition = ErlangParser.GetInstance().Parse(v.condition)[0][1]
				}
			}
			let main_role_lv = RoleManager.GetInstance().GetMainRoleLevel()
			let now = (model.GetLastChapter() != now_chapter && model.ReceiveNowChapterAll(now_chapter)) && now_chapter + 1 || now_chapter
			let sub = (!model.ReceiveNowChapterAll(now_chapter) && model.ReceiveNowSubChapterAll(now_chapter, now_sub_chapter)) && now_sub_chapter + 1 || now_sub_chapter
			if (!chapter_cfg[now + "@" + sub + "@1"]) { return }

			//章节配置（章节开启等级条件）
			let open_condition = ErlangParser.GetInstance().Parse(cfg[now].condition)[0][1]


			let data = cfg[now_chapter]
			if (!data) return
			if (main_chapter_info[now_chapter]) {
				switch (main_chapter_info[now_chapter].status) {
					case 1:
						//进行中
						let info = TempleAwakenModel.GetInstance().GetNowTask(now_chapter)
						if (info && info.is_lock_task) {
							this.open_text.text = `${TransformLevel(info.open_lv)}级解锁新任务`
						} else {
							this.open_text.text = `${data.chapter_name}获取进度`
						}

						break;
					case 2:
						//未知
						break;
					case 3:
						//章节全部完成
						this.open_text.text = `${data.chapter_name}(已完成)`
						break;
				}
			} else {
				if (main_role_lv >= open_condition) {
					this.open_text.text = `${data.chapter_name}(完成上一章节内容开启)`
				} else {
					this.open_text.text = `${data.chapter_name}(${TransformLevel(open_condition)}级开启)`
				}

			}


			this._img_lv_bg.width = this.open_text.textField.textWidth + 20


		}

		this.SetWearStage = () => {
			let main_chapter_info = model.GetMainChapterInfo()
			let info = main_chapter_info[now_chapter]
			this.check_gp.visible = info && info.status == 3
			this.SetSelectState(now_chapter - 1000)
			if (now_chapter == 1001) {
				this.check_text.text = "穿戴"
			} else {
				this.check_text.text = "幻化"
			}
			if (this.check_gp.visible) {
				let wear = model.GetWearInfo(now_chapter)
				this.check_img.visible = wear == 1
				if (wear == 1) {
					this.check_text.text = "卸下"
				}
			}
		}
		this.GetModelId = () => {
			let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let career = mainVo.career
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_suit
			// ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken_suit", false)/// Config.Templeawakensuit
			let cfg_chapter = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken
			//ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken", false)//Config.Templeawaken
			let list = []
			let model_list = []
			for (let _ in cfg_chapter) {
				var v = cfg_chapter[_]
				table.insert(list, { chapter: v.chapter_id, model_id: cfg[v.chapter_id + "@" + career].figure_id })
			}
			table.sort(list, (a?, b?) => {
				return a.chapter < b.chapter
			})
			for (let i = 0; i < list.length; i++) {
				if (list[i].chapter > now_chapter) {
					break
				}
				table.insert(model_list, list[i])
			}
			return [model_list[0] && model_list[0].model_id, model_list[1] && model_list[1].model_id, model_list[2] && model_list[2].model_id, model_list[3] && model_list[3].model_id, model_list[4] && model_list[4].model_id]
		}

		this.CreateModel = () => {
			if (now_chapter == last_chapter) { return }

			ResManager.GetInstance().ClearRoleMode(this.hashCode)

			let mainVo = RoleManager.GetInstance().GetMainRoleVo()
			let awaken_fashion, awaken_hallow, awaken_wing, awaken_artiface, awaken_mount
			[awaken_fashion, awaken_hallow, awaken_wing, awaken_artiface, awaken_mount] = this.GetModelId()//null,null,null,null,null//
			let cfg_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken_kv", false)//Config.Templeawakenkv
			let head_model_id = Number(ErlangParser.GetInstance().Parse(cfg_kv[7].value)[mainVo.sex - 1][1])
			let type = UI_MODEL_TYPE.ROLE
			let rotate = null
			let _scale = 1.2//400
			let position = new Vector3(0, 0, 0)
			if (awaken_mount && awaken_mount > 0) {
				type = UI_MODEL_TYPE.Include_Horse
				rotate = 225
				_scale = 0.6//300
				position = new Vector3(0, 0, 0)
			}
			let data = {
				career: mainVo.career,
				sex: mainVo.sex,
				type: type,
				layer_value: Enum_UILayer.UI,
				clothe_res_id: awaken_fashion,
				head_wear_id: Number(head_model_id),
				weapon_res_id: awaken_artiface,
				weapon_clothe_id: 0,
				wing_id: awaken_wing,
				horse_id: awaken_mount,
				fashion_model_id: undefined,
				//hallows_id = awaken_hallow,
				position: position,
				scale: _scale,
				rotate: rotate,
				hair_id: 0,//1014+mainVo.sex*100  
				layout_file: "TempleAwakenMainView"
			}

			ResManager.GetInstance().SetRoleModel(this, this.model_gp, data)

			//let pos_cfg = client_pos_cfg_[model_res]
			if (awaken_hallow) {

				let data2 = {

					career: mainVo.career,
					sex: mainVo.sex,
					type: UI_MODEL_TYPE.ARTIFACT,
					layer_value: Enum_UILayer.UI,
					clothe_res_id: awaken_hallow,
					head_wear_id: 0,
					weapon_res_id: 0,
					weapon_clothe_id: 0,
					wing_id: 0,
					horse_id: 0,
					fashion_model_id: undefined,
					//hallows_id = awaken_hallow,
					position: new Vector3(0, 0, 0),//position,
					scale: 2,
					rotate: null,
					hair_id: 0,
					layout_file: "TempleAwakenMainView"
				}
				if (data2) {
					ResManager.GetInstance().SetRoleModel(this, this.hallow_model_gp, data2)
				}
			}
			// else {
			// 	ResManager.GetInstance().ClearRoleMode(this.hashCode)
			// }
		}


	}

	public DeleteMe() {

		this.LocalDeleteMe()
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
		super.DeleteMe()
	}


	model_gp: Laya.Box
	chapter_gp: Laya.Box
	fashion_gp: Laya.Box
	Image11111: Laya.Image
	Imag: Laya.Image
	img11: Laya.Image
	fashion_select: Laya.Image
	hallow_gp: Laya.Box
	Image111: Laya.Image
	Imag1111: Laya.Image
	img111: Laya.Image
	hallow_select: Laya.Image
	wing_gp: Laya.Box
	Image1111: Laya.Image
	Imag11: Laya.Image
	img1: Laya.Image
	wing_select: Laya.Image
	artifact_gp: Laya.Box
	Image1111111: Laya.Image
	Imag1: Laya.Image
	img: Laya.Image
	artiface_select: Laya.Image
	mount_gp: Laya.Box
	Image: Laya.Image
	Imag111: Laya.Image
	img1111: Laya.Image
	mount_select: Laya.Image
	hallow_model_gp: Laya.Box
	check_gp: Laya.Box
	Image11: Laya.Image
	check_img: Laya.Image
	check_text: Laya.Label
	Content: Laya.List
	open_gp: Laya.Box
	_img_lv_bg: Laya.Image
	open_text: Laya.Label
	Image1: Laya.Image
	_box_progress: Laya.Box
	sub_chapter_img: Laya.Image
	public GetComponents() {
		[
			this.model_gp,
			this.chapter_gp,
			this.fashion_gp,
			this.Image11111,
			this.Imag,
			this.img11,
			this.fashion_select,
			this.hallow_gp,
			this.Image111,
			this.Imag1111,
			this.img111,
			this.hallow_select,
			this.wing_gp,
			this.Image1111,
			this.Imag11,
			this.img1,
			this.wing_select,
			this.artifact_gp,
			this.Image1111111,
			this.Imag1,
			this.img,
			this.artiface_select,
			this.mount_gp,
			this.Image,
			this.Imag111,
			this.img1111,
			this.mount_select,
			this.hallow_model_gp,
			this.check_gp,
			this.Image11,
			this.check_img,
			this.check_text,
			this.Content,
			this.open_gp,
			this._img_lv_bg,
			this.open_text,
			this.Image1,
			this._box_progress,
			this.sub_chapter_img,
		]
			= this.GetChildrenByNames([

				"model_gp",
				"chapter_gp",
				"fashion_gp",
				"Image11111",
				"Imag",
				"img11",
				"fashion_select",
				"hallow_gp",
				"Image111",
				"Imag1111",
				"img111",
				"hallow_select",
				"wing_gp",
				"Image1111",
				"Imag11",
				"img1",
				"wing_select",
				"artifact_gp",
				"Image1111111",
				"Imag1",
				"img",
				"artiface_select",
				"mount_gp",
				"Image",
				"Imag111",
				"img1111",
				"mount_select",
				"hallow_model_gp",
				"check_gp",
				"Image11",
				"check_img",
				"check_text",
				"Content",
				"open_gp",
				"_img_lv_bg",
				"open_text",
				"Image1",
				"_box_progress",
				"sub_chapter_img",
			])
	}
}
window["TempleAwakenMainView"] = TempleAwakenMainView