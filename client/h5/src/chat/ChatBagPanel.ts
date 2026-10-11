import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1, OpenMode } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { ChatModelEvent, ChatModel, CHAT_TOOL_TYPE } from "../commonModel/ChatModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SetSizeDeltaY, SetAnchoredPositionY, SetLocalPosition } from "../util/Util"
import { ChatParentTab } from "./ChatParentTab"
import { ChatToolBagItem } from "./ChatToolBagItem"
import { ChatToolBagItem2 } from "./ChatToolBagItem2"

export class ChatBagPanel extends BaseView1 {
	Content
	Content1
	Content11
	InitEvent
	_gp_title
	arrow_pos
	back_login_toClose
	background_alpha
	click_bg_toClose
	close_callback
	content_list
	content_list2
	destroy_imm
	initTab
	initView
	itemScroller
	itemScroller2
	item_arrayCollection
	item_arrayCollection2
	loop_scrol_tab
	on_item_touch
	open_callback
	open_mode
	preload_server_config
	setData
	setLocal
	tabScroller
	use_background
	use_local_view
	x
	y
	view_pos
	config_seal_kv
	SetArrowPos

	bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Label1: Laya.Label
	arrow: Laya.Image
	


	public constructor() {
		super()

		this.base_file = "chat"
		this.layout_file = "ChatBagPanel"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.click_bg_toClose = true
		this.use_background = true
		this.background_alpha = 0
		this.back_login_toClose = true
		// this.use_local_view = true
		let local_CHAT_TOOL_TYPE = CHAT_TOOL_TYPE
		let local_ChatModelEvent = ChatModelEvent
		// let local_eui = eui
		let local_laya = Laya
		let common_mgr = CommonManager.GetInstance()
		let _model = ChatModel.GetInstance()
		let _scroller = false
		let btnX = 0
		let btnY = 0
		let is_down = false
		// this.preload_server_config = [Goods=false]
		this.load_callback = () => {

			this.InitEvent()
			this.setLocal()
			this.SetArrowPos()
			// this.display_obj.x = 450
			// this.display_obj.y = 550
			ResManager.GetInstance().LoadGameConfig(ResManager.GetInstance(), "config_seal_kv", false, undefined, (cfgs) => {
				this.config_seal_kv = cfgs
			});
		}

		this.open_callback = () => {
			this.initTab()
			this.loop_scrol_tab.SetSelectIndex(local_CHAT_TOOL_TYPE.BAG-1)
			//this:initView(local_CHAT_TOOL_TYPE.BAG)
			_model.Fire(local_ChatModelEvent.CHAT_BAG_OPEN, true, _model.selectChannel)

			// this.RegisterMask(this.content_list)
			// this.RegisterMask(this.content_list2)
			//为了合批
			// SetLocalPositionZ(this.form, 0)
			// ChatToolBagItem.mat =  new Material(ShaderTools.GetShader("UI-Default_mask"))
			// ChatToolBagItem2.mat =  new Material(ShaderTools.GetShader("UI-Default_mask"))
			// this.x = 450
			// this.y = 550
		}

		this.close_callback = () => {
			if (this.item_arrayCollection) {
				this.item_arrayCollection.DeleteMe()
				this.item_arrayCollection = null
			}
			if (this.item_arrayCollection2) {
				this.item_arrayCollection2.DeleteMe()
				this.item_arrayCollection2 = null
			}
			if (this.loop_scrol_tab) {
				this.loop_scrol_tab.DeleteMe()
				this.loop_scrol_tab = null
			}
			_model.Fire(local_ChatModelEvent.CHAT_BAG_OPEN, false, _model.selectChannel)

			// ChatToolBagItem.mat = null
			// ChatToolBagItem2.mat = null
		}

		this.InitEvent = () => {

		}

		this.setData = (point?, down?) => {
			btnX = point.x
			btnY = point.y
			is_down = down
		}


		this.on_item_touch = (item?) => {
			if (this.item_arrayCollection) {
				this.item_arrayCollection.DeleteMe()
				this.item_arrayCollection = null
			}
			if(item){
				let type
				type=item+1
				this.loop_scrol_tab.SetSelectIndex(item)
				this.Content11.selectedIndex = item
				this.initView(type)
			}else{
				item=0
				let type
				type=1
				this.loop_scrol_tab.SetSelectIndex(item)
				this.Content11.selectedIndex = item
				this.initView(type)
			}
		}

		this.initTab = () => {
			let list = [{ label: "背包" }, { label: "装备" }]
			let level = RoleManager.GetInstance().GetMainRoleVo().level
			if (level >= HolySealModel.GetInstance().GetkeyValue(3, this.config_seal_kv)) {
				table.insert(list, { label: "影装" })
			}
			if (common_mgr.CheckFuncOpenState("GodBefallMainView", true)) {
				table.insert(list, { label: "神器" })
			}
			if (common_mgr.CheckFuncOpenState("RevelationEquipView", true)) {
				table.insert(list, { label: "天启" })
			}
			if (common_mgr.CheckFuncOpenState("GodCourtView", true)) {
				table.insert(list, { label: "神庭" })
			}
			if (common_mgr.CheckFuncOpenState("longlanguageView", true)) {
				table.insert(list, { label: "神祭" })
			}

			this.loop_scrol_tab = new LoopScrowViewMgr()
			this.loop_scrol_tab.SetData(this.Content11, ChatParentTab, list, LoopScrCon.Vertical, 1, this.on_item_touch)
			// this.Content11.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.on_item_touch, this)
		}

		this.initView = (type?) => {
			// BaseAwardItem.sharedMatDict = [] //每次切tab都清空缓存的共用材质
			let data = _model.chatToolBagData(type)
			this.itemScroller2.visible = false
			this._gp_title.visible = this.itemScroller2.visible
			let bagList = []
			if (type == local_CHAT_TOOL_TYPE.GOD) {
				bagList = _model.chatBagData()
			} else if (type == local_CHAT_TOOL_TYPE.SEAL) {
				bagList = _model.chatSealBagData()
			} else if (type == local_CHAT_TOOL_TYPE.GODBEFALL) {
				bagList = _model.chatGodBefallWearData()
			} else if (type == local_CHAT_TOOL_TYPE.REVELATION) {
				bagList = _model.chatRevelationBagData()
			} else if (type == local_CHAT_TOOL_TYPE.GODCOURT) {
				bagList = _model.chatGodCourtBagData()
			} else if (type == local_CHAT_TOOL_TYPE.LONGLANGUAGE) {
				bagList = _model.chatLongLanguageBagData()
			}
			this.itemScroller2.visible = bagList.length > 0
			this._gp_title.visible = this.itemScroller2.visible
			if (this.itemScroller2.visible) {
				SetSizeDeltaY(this.Content1, 196)
				SetSizeDeltaY(this.itemScroller, 196)
				SetAnchoredPositionY(this.itemScroller, 259)
				let data2 = bagList
				if (!this.item_arrayCollection2) {
					this.item_arrayCollection2 = new LoopScrowViewMgr()
					// this.item_arrayCollection2.SetData(this.Content, ChatToolBagItem2, data2, this.itemScroller2, 5, null, null, null, GetWorldCorners(this.content_list2))
					this.item_arrayCollection2.SetData(this.Content, ChatToolBagItem2, data2, LoopScrCon.Vertical, 5, null, null, null)

				} else {
					this.item_arrayCollection2.replaceAll(data2)
				}
			}else{
				SetSizeDeltaY(this.Content1, 447)
				SetSizeDeltaY(this.itemScroller, 447)
				SetAnchoredPositionY(this.itemScroller, 15)
			}
			if (!this.item_arrayCollection) {
				this.item_arrayCollection = new LoopScrowViewMgr()
				this.item_arrayCollection.SetData(this.Content1, ChatToolBagItem, data, LoopScrCon.Vertical, 5, null, null, null)
			} else {
				this.item_arrayCollection.replaceAll(data)
			}
		}

		this.SetArrowPos = () =>{
			let x = 30
			let y = 476
			SetLocalPosition(this.arrow, this.arrow_pos ? this.arrow_pos.x : x, this.arrow_pos ? this.arrow_pos.y : y)
		}

		this.setLocal = () => {
			this.display_obj.y = this.view_pos.y - this.display_obj.height//-20
		}
	}

	public Open(...new_args) {
		this.view_pos=new_args[0]
		 this.arrow_pos = new_args[1]
		super.Open()
	}

	public GetComponents() {
		[
			this.bg,
			this.arrow,
			this._Image1,
			this.itemScroller,
			this.Content1,
			this.itemScroller2,
			this.Content,
			this.tabScroller,
			this.Content11,
			this._gp_title,
			this._Image2,
			this._Image3,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"bg",
				"arrow",
				"_Image1",
				"itemScroller",
				"Content1",
				"itemScroller2",
				"Content",
				"tabScroller",
				"Content11",
				"_gp_title",
				"_Image2",
				"_Image3",
				"_Label1",
			])
	}
}

window["ChatBagPanel"] = ChatBagPanel