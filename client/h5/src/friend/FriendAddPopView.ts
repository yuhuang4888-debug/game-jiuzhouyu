import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { FriendAddPopItem } from "./FriendAddPopItem"

export class FriendAddPopView extends BaseView1 {
	InitEvent
	LoadSuccess
	_input
	back_login_toClose
	click_bg_toClose
	destroy_callback
	destroy_imm
	initData
	is_center
	itemList
	show_open_movie
	use_background


	////
	btnClose
	searchBtn
	changeBtn
	btnCloseSearch
	nullGroup
	player_name_text
	Text
	_Label3
	_Label2
	//this.labelDisplay	
	scroll_group
	Content
	_Image1
	text_input
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Group1: Laya.Box
	_Image5: Laya.Image
	_Label1: Laya.Label
	Image: Laya.Image
	_Image6: Laya.Image
	itemScroller: Laya.Panel
	_Image7: Laya.Image
	Placeholder: Laya.TextInput

	public constructor() {
		super()


		this.itemList = [];
		this.base_file = "friend"
		this.layout_file = "FriendAddPopView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.back_login_toClose = true
		let _model = FriendModel.GetInstance()
		let _search = false
		let textLabel = "输入玩家名称"
		let arrayCollection = null
		let item_list = null
		//let local_latformManager = PlatformManager.GetInstance()
		let local_FriendEvent = FriendEvent
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label3.size  = 20
			// 	this._Label2.size  = 18
			// 	this.labelDisplay.size  = 16
			// 	this.labelDisplay.lineSpacing = 0.6
			// }
		}

		//if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.AddFriend) ) {
		//this.destroy_imm = true
		//}
		this.destroy_callback = () => {
			for (let _tmpi in item_list) {
				var v = item_list[_tmpi]
				v.DeleteMe()
			}
			item_list = null
			_model.recommend_cache = null
		}
		this.InitEvent = () => {
			let closeClick = () => {
				this.Close()
			}

			Util.AddClickEvent(this.btnClose, closeClick, this, null, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			let closeSearch = () => {
				this.Placeholder.text = ""
				_search = false
				this.btnCloseSearch.visible = false
				_model.Fire(local_FriendEvent.REQUEST_RECOMMEND_DATA, 0)
			}

			Util.AddClickEvent(this.btnCloseSearch, closeSearch, this)
			let searchClick = () => {
				let seaechStr = this.Placeholder.text
				if (seaechStr == "") {
					Message.show(textLabel)
					return
				}

				_search = true
				this.btnCloseSearch.visible = true
				_model.Fire(local_FriendEvent.CHECK_PLAYER, seaechStr)
			}

			Util.AddClickEvent(this.searchBtn, searchClick, this, true)
			let changeClick = () => {
				_model.Fire(local_FriendEvent.REQUEST_RECOMMEND_DATA, 1)
			}

			Util.AddClickEvent(this.changeBtn, changeClick, this, true)
			let update = () => {
				this.initData()
			}

			this.BindEvent(_model, local_FriendEvent.RECOMMEND_DATA_UPDATE, update)
			this.initData()
		}

		this.LoadSuccess = () => {

			// //this.btnClose,
			// this.searchBtn,
			// this.changeBtn,
			// //this.btnCloseSearch,
			// this.nullGroup
			// = GetChildGameObjects(this.form, {
			// 		"btnClose",
			// 		"searchBtn",
			// 		"changeBtn",
			// 		"btnCloseSearch",
			// 		"nullGroup"
			// 	})
			this.player_name_text = this.Text,
				// this._Label3,
				// this._Label2,
				// //this.labelDisplay
				// = GetChildTexts(this.form, {
				// 		"text_input/Text",
				// 		"nullGroup/_Label3",
				// 		"_Label2",
				// 		"changeBtn/labelDisplay"
				// 	})

				this.scroll_group = this.Content
			// = GetChildTransforms(this.form, {
			// 		"itemScroller/Viewport/Content"
			// 	})
			// this._Image1
			// = this.GetChildImages({
			// 		"_Image1"
			// 	})

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("common", "uity_080"))
			this._input = this.text_input
			item_list = []
		}

		this.initData = () => {
			if (this.is_loaded) {
				// this.nullGroup.visible = _model.GetrecommendList.length <= 0 && _search
				if (_model.GetrecommendList()) {
					_model.recommend_cache = _model.GetrecommendList()
					if (item_list && item_list.length > 0) {
						for (let i = 0; i < item_list.length; i++) {
							item_list[i].SetVisible(false)
						}
					}
					let list = _model.GetrecommendList()
					if(list.length<=0 && _search){
						this.nullGroup.visible=true
					}else{
						this.nullGroup.visible=false
					}
					for (let i = 0; i < list.length; i++) {
						let item = item_list[i]
						if (!item) {
							item = new FriendAddPopItem(this.scroll_group)
							item_list[i] = item
							item.Load()
						}
						item.SetData(list[i])
						item.SetVisible(true)
					}

				}
			}
		}
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this.searchBtn,
			this.changeBtn,
			this._Image4,
			this._Group1,
			this._Image5,
			this._Label1,
			this.Image,
			this._Image6,
			this.btnClose,
			this._Label2,
			this.itemScroller,
			this.Content,
			this.nullGroup,
			this._Image7,
			this._Label3,
			this.Placeholder,
			this.Text,
			this.btnCloseSearch,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"searchBtn",
				"changeBtn",
				"_Image4",
				"_Group1",
				"_Image5",
				"_Label1",
				"Image",
				"_Image6",
				"btnClose",
				"_Label2",
				"itemScroller",
				"Content",
				"nullGroup",
				"_Image7",
				"_Label3",
				"Placeholder",
				"Text",
				"btnCloseSearch",
			])
			this.itemScroller.vScrollBarSkin=""

	}
}

window["FriendAddPopView"] = FriendAddPopView