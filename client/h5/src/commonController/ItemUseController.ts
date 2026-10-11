import { BaseController } from "../common/BaseController"
import { EventName, SceneEventType } from "../common/EventName"
import { ItemUseView } from "../common/ItemUseView"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ItemUseModel } from "../commonModel/ItemUseModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import { OutLineModel } from "../commonModel/OutLineModel"
import { RoleManager } from "../commonModel/RoleManager"
import { ViewPopLevelModel, ViewPopLevelModelEvent } from "../commonModel/ViewPopLevelModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import "../common/ItemUseView"

export class ItemUseController extends BaseController {

	public static _instance

	CanShowItemUseScene
	InitEvent
	TryShowItemUseCheckView
	TryShowItemUse
	ChangeScene

	public constructor() {
		super()

		let refresh_time_id
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let goods_model = GoodsModel.GetInstance()
		let local_GoodsModel = GoodsModel
		let model: ItemUseModel = ItemUseModel.GetInstance()
		this.InitEvent = () => {
			local_GlobalEventSystem.Bind(local_EventName.GAME_START, () => {
				ViewPopLevelModel.GetInstance().ClearSpacialData(true)
				model.ClearData()
				model.ClearEquipList()
				model.ClearEquipRecord()
				if (refresh_time_id) {
					clearTimeout(refresh_time_id)
				}
				refresh_time_id = setTimeout(() => {
					model.is_wait_time = false
					ViewPopLevelModel.GetInstance().Fire(ViewPopLevelModelEvent.POP_OVER)
				}, ViewPopLevelModel.VIEW_WAIT_TIME_2)
			}
			)
			let OpenItemUseView = (vo?) => {
				let view_model = ViewPopLevelModel.GetInstance()
				if (model.is_wait_time) {
					if (model.CheckShowList(vo)) {
						return
					}
					model.SaveShowList(vo)
					return
				}
				if (view_model.GetView("ItemUseView") != null || view_model.CheckViewIsPoping("ItemUseView")) {
					if (model.CheckCacheList(vo)) {
						return
				}
					model.SaveCacheList(vo)
					return
				}
				view_model.SetView("ItemUseView", vo)
			}

			local_GlobalEventSystem.Bind(local_EventName.OPEN_ITEM_USE_VIEW, OpenItemUseView)
			let baggoodsListfinish = () => {
				let bag_dic = goods_model.GetBagGoodsDic()
				for (let key in bag_dic) {
					if (bag_dic[key]) {
						model.UpdateBagGoodsDic(bag_dic[key], null, true)
					}
				}
				this.TryShowItemUse()
			}

			goods_model.Bind(local_GoodsModel.CREATE_BAG_LIST_FINISH, baggoodsListfinish)

			let OnChangeBagGoodsList = () => {
				this.TryShowItemUseCheckView()
			}
			goods_model.Bind(local_GoodsModel.TRY_SHOW_ITEM_USE_VIEW, OnChangeBagGoodsList)

			local_GlobalEventSystem.Bind(SceneEventType.SCENE_CHANGED, () => {
				this.ChangeScene()
			}
			)
			RoleManager.GetInstance().GetMainRoleVo().BindOne("turn", () => {
				let goodsList = goods_model.GetEquipList()
				for (let k in goodsList) {
					var v = goodsList[k]
					model.UpdateBagGoodsDic(v, false)
				}
				this.TryShowItemUseCheckView()
			}
			)
			local_GlobalEventSystem.Bind(local_EventName.CHECK_ITEM_USE, () => {
				this.TryShowItemUseCheckView()
			}
			)
			ViewPopLevelModel.GetInstance().Bind(ViewPopLevelModelEvent.POP_OVER, () => {
				model.is_wait_time = false
				if (model.delay_show_list && model.delay_show_list.length > 0) {
					for (let i = 0; i < model.delay_show_list.length; i++) {
						let vo = model.delay_show_list[i]
						if (!model.CheckItemUseVoExist(vo)) continue
						OpenItemUseView(vo)
					}
					model.delay_show_list = []
				}
			})
		}

		this.CanShowItemUseScene = (scene_id?) => {
			// return true
			let scene_mgr = SceneManager.GetInstance()
			return scene_mgr.IsFieldScene() || scene_mgr.IsBossScene() || scene_mgr.IsWeddingScene() || scene_mgr.IsNoonPartyScene() || scene_mgr.IsDragonDungeon() || scene_mgr.IsEveningScene() || scene_mgr.IsEquipDungeon()
		}

		this.TryShowItemUseCheckView = () => {
			this.TryShowItemUse()
		}

		this.TryShowItemUse = () => {
			if (this.CanShowItemUseScene()) {
				model.ForceTryShowItemUse()
			} else {
				GlobalEventSystem.Fire(EventName.CLOSE_VIEW, "ItemUseView")
				ViewPopLevelModel.GetInstance().RemoveOneView("ItemUseView")
			}
		}

		this.ChangeScene = () => {
			this.TryShowItemUse()
		}

		this.InitEvent()
	}

	public static GetInstance() {

		if (!ItemUseController._instance) {
			ItemUseController._instance = new ItemUseController()
		}
		return ItemUseController._instance
	}

}

window["ItemUseController"] = ItemUseController