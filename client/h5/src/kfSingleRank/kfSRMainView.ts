import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { kfSingleRankModel, kfSREvent, kfSingleRankDefine } from "../commonModel/kfSingleRankModel"
import { ShopIndex } from "../commonModel/ShopModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { SetAnchoredPositionX, SetSizeDelta, SetAnchoredPositionY, Util, RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { kfSRAwardItemC } from "./kfSRAwardItemC"
import { kfSRDropBtn } from "./kfSRDropBtn"
import { kfSRMainItem } from "./kfSRMainItem"
import { kfSRMainRankItem } from "./kfSRMainRankItem"

export class kfSRMainView extends BaseItem1 {
	ClickItemHandle
	ClickLookHandle
	ClickWinner
	CreateDropBtn
	InitEvent
	LoadSuccess
	Scr_Scroller1
	Scr_Scroller2
	Scr_scroll_tower
	SelectCanGoItem
	SelectData
	SendEnterDun
	UpdateLevelData
	UpdateRankItems
	UpdateTowerItems
	UpdateView
	UpdateViewByClick
	loop_rank
	loop_reward
	loop_tower: LoopScrowViewMgr
	model
	select_ani_id

	OnPanelChange
	_dd_winner:kfSRDropBtn
	is_frist_open
	left_count
	GetCurArerId
	UpdateClipNum

	public constructor(parent?) {
		super(parent)
		
		this.base_file = "kfSingleRank"
		this.layout_file = "kfSRMainView"
		this.model = kfSingleRankModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_Message = Message
		this.preload_server_config = { "config_rank_dungeon": false }
		let local_kfSREvent = kfSREvent
		let local_laya = Laya
		let local_kfSingleRankDefine = kfSingleRankDefine
		let _cur_data_ = null
		let _cur_level_ = null
		let _cur_wdata_ = null
		let _cur_area_id_ = 0
		let _show_area_id_ = 0
		let _data_dic_ = []
		let _max_layer_ = 0
		this.select_ani_id = null
		this.is_frist_open=true
		this.load_callback = () => {
			ResManager.GetInstance().LoadFont(this, "scene_boss", this._lb_stage, null, false)
			ResManager.GetInstance().LoadFont(this, "scene_boss", this._lb_top, null, false)
			this._scroll_tower.vScrollBarSkin = ""
			this._scroll_tower.vScrollBar.mouseWheelEnable=false
			this.LoadSuccess()
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("kfSingleRank", "uikfdr_002"))
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._img_link, () => {
				OpenFun.OpenFunHandler(162)
			}
				, this, true)
			Util.AddClickEvent(this._btn_shop, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.SingleRank, false, 160)
			}
				, this, true)
			Util.AddClickEvent(this._btn_help, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_INSTRUCTION_VIEW, local_kfSingleRankDefine.INSTRUCTION)
			}
				, this, true)
			Util.AddClickEvent(this._btn_go, () => {
				if (!_cur_data_) {
					return
				}

				if(this.left_count<=0){
					Message.show("挑战次数不足！")
					return
				}

				let data = this.model.GetPlayerInfo()
				if (_cur_data_.level > _cur_level_ + 1) {
					Message.show("请先通关前置副本")
					this.SelectCanGoItem()
				} else {
					let bool, str 
					[bool, str]= this.model.CheckEnterDun(_cur_data_.level)
					if (bool) {
						let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
						let ddata = this.model.GetDunData(cfg, _cur_data_.level)
						let data = { dun_id: ddata.dungeon_id }
						local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "kfSRSceneTipsView", data)
					} else {
						Message.show(str)
					}
				}
			}
				, this, true)
			Util.AddClickEvent(this._btn_reward, () => {
				this.model.Fire(local_kfSREvent.REQUEST_PROTO, 50704)
			}
				, this, true)
			Util.AddClickEvent(this._btn_rank, () => {
				local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "kfSRRankView", _show_area_id_)
			}
				, this, true)
			Util.AddClickEvent(this._btn_area_up, () => {
				let id = _show_area_id_ - 1
				if (id < _cur_area_id_ - 1) {
					return
				}
				_show_area_id_ = id
				this._btn_area_up.visible = false
				this._btn_area_down.visible = true
				let adata = this.model.GetAreaTowerData(id)
				this.UpdateViewByClick(adata)
				this.UpdateClipNum(_show_area_id_)
			}
				, this, true)
			Util.AddClickEvent(this._btn_area_down, () => {
				let id = _show_area_id_ + 1
				if (id > _cur_area_id_) {
					return
				}
				_show_area_id_ = id
				this._btn_area_up.visible = true
				this._btn_area_down.visible = false
				let adata = this.model.GetAreaTowerData(id)
				this.UpdateViewByClick(adata)
				this.UpdateClipNum(_show_area_id_)
			}
				, this, true)
			Util.AddClickEvent(this._btn_up, () => {
				this._scroll_tower.scrollTo(0, this._scroll_tower.vScrollBar.value - kfSRMainItem.height)
			}
				, this, true)
			Util.AddClickEvent(this._btn_down, () => {
				this._scroll_tower.scrollTo(0, this._scroll_tower.vScrollBar.value + kfSRMainItem.height)
			}
				, this, true)

			Util.AddClickEvent(this._lb_look, () => {
				this.ClickLookHandle()
			}, this, true)

			// AddUnderLine(this, this._lb_look)
			// this["_add_under_line"][this._lb_look].raycastTarget = false

			this.BindVar(this.model, "_player_info", () => {
				this.UpdateLevelData()
			}
			)
			this.BindEvent(this.model, local_kfSREvent.UPDATE_TOWER, (scmd?) => {
				if (_cur_area_id_ != scmd.area_id) {
					return
				}
				this.UpdateView(scmd)
			}
			)
			this.BindEvent(this.model, local_kfSREvent.UPDATE_TOP, (scmd?) => {
				if (_cur_wdata_ && _cur_wdata_.area_id == scmd.area_id) {
					this.UpdateRankItems(scmd)
				}
			}
			)
			this.BindEvent(this.model, local_kfSREvent.UPDATE_RW_STATE, (scmd?) => {
				this._btn_reward.visible = false
				this._btn_go.visible = true
			}
			)
			this.BindEvent(this.model, local_kfSREvent.BLACK_CALL_BACK, (scmd?) => {
				this.SendEnterDun()
			}
			)

			this._scroll_tower.vScrollBar.changeHandler = Laya.Handler.create(this, this.OnPanelChange, null, false)
			//this._scroll_tower.on(Laya.Event.on, this, this.OnPanelChange)
		}

		this.OnPanelChange = (value?) => {

			if (value >= this._scroll_tower.vScrollBar.max - 50) {
				this._btn_up.visible = true
				this._btn_down.visible = false
			} else if (value <= 0) {
				this._btn_up.visible = false
				this._btn_down.visible = true
			} else {
				this._btn_up.visible = true
				this._btn_down.visible = true
			}
		}

		this.LoadSuccess = () => {
			this.InitEvent()
			ResManager.GetInstance().SetImageSprite(this, this._img_004, "kfSingleRank", "uikfdr_004")
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
			_max_layer_ = Util.TableSize(cfg)
			this.model.Fire(local_kfSREvent.REQUEST_PROTO, 50701)
			
		}

		this.CreateDropBtn = () => {
			this._dd_winner = new kfSRDropBtn(this.display_obj)
			this._dd_winner.SetPosition(38, 136)
			let area_count = _max_layer_ / local_kfSingleRankDefine.LAYER_COUNT
			let list = []
			for (let i = 1; i <= area_count; i++) {
				let num = WordManager.NumConvertStage(i)
				table.insert(list, { area_id: i, content: `${num}阶试炼擂主` })
			}

			this._dd_winner.Init(list, this.ClickWinner, "", "content", this.layer_value, 10)
			this._dd_winner.Load()
		}

		this.UpdateTowerItems = (scmd?) => {
			let list = scmd.challengers
			let count = local_kfSingleRankDefine.LAYER_COUNT
			let plist = []

			for (let i = count; i >= 1; i -= 1) {
				let lv = (scmd.area_id - 1) * count + i
				let data = scmd.challenger_dic[lv] || { level: lv }
				table.insert(plist, data)
				_data_dic_[lv] = data
			}


			if (!this.loop_tower) {
				this.loop_tower = new LoopScrowViewMgr()
				this.loop_tower.SetData(this._list_tower, kfSRMainItem, plist, LoopScrCon.Vertical, 1, (index?) => {

					let data = this.loop_tower.data_list[index]
					_cur_data_ = data
					this.ClickItemHandle(index)
					this.SelectData(_cur_data_)
					//this.SetSelectAni(index)
				})
				this._list_tower.scrollBar.touchScrollEnable=false//禁用滑动
				this._list_tower.scrollBar.mouseWheelEnable=false//禁用滚轮
			} else {
				this.loop_tower.replaceAll(plist)
			}


			if(this.is_frist_open){
				this.is_frist_open=false
				this.SelectCanGoItem(false)
			}

		}

		this.UpdateRankItems = (scmd?) => {
			let list = scmd.challengers
			let count = local_kfSingleRankDefine.LAYER_COUNT
			let plist = []


			for (let i = count; i >= 1; i -= 1) {
				let level = (scmd.area_id - 1) * count + i
				let data = scmd.challenger_dic[level] || { level: level }
				table.insert(plist, data)
			}

			if (!this.loop_rank) {
				this.loop_rank = new LoopScrowViewMgr()
				this.loop_rank.SetData(this.Content2, kfSRMainRankItem, plist, LoopScrCon.Vertical)
			} else {
				this.loop_rank.replaceAll(plist)
			}


		}

		this.UpdateLevelData = () => {
			let pinfo = this.model.GetPlayerInfo()
			if (!pinfo) {
				return
			}
			let lv = this.model.GetCurLevel()
			let ldata = this.model.GetCurLevelData()




			lv = (ldata && (lv) || (lv - 1))
			_cur_level_ = lv
			let can_reward = pinfo.rw_state == 0 && pinfo.start_level > 1
			this._btn_reward.visible = can_reward
			this._btn_go.visible = !can_reward

			let not_max = lv < _max_layer_
			let area_id = Math.floor(lv / local_kfSingleRankDefine.LAYER_COUNT)
			area_id = not_max ? area_id + 1 : area_id
			//let stage = area_id == 10 ? 0 : area_id

			this.UpdateClipNum(area_id)

			this._lb_top.text = lv
			this.left_count = local_kfSingleRankDefine.LAYER_COUNT * 2 - pinfo.level_list.length
			this._lb_count.text = this.left_count  + ""

			let is_top = ((ldata && lv != 0) && not_max) && lv % local_kfSingleRankDefine.LAYER_COUNT == 0

			this.model.Fire(local_kfSREvent.REQUEST_PROTO, 50702, "c", area_id)
			if (is_top && area_id - 1 > 0) {
				this.model.Fire(local_kfSREvent.REQUEST_PROTO, 50702, "c", area_id - 1)
			}

			this._btn_area_up.visible = is_top
			this._btn_area_down.visible = false
			_show_area_id_ = area_id
			_cur_area_id_ = area_id

			if (!this._dd_winner) {
				this.CreateDropBtn()
			}
			this._dd_winner.SetSelectIndex(area_id-1)

		}

		this.UpdateView = (scmd?) => {
			this.UpdateTowerItems(scmd)
			if (!_cur_data_) {
				let lv = _cur_level_
				lv = (lv < _max_layer_ && (lv + 1) || (lv))
				// [ts2lua]_data_dic_下标访问可能不正确
				let data = _data_dic_[lv]
				// this._list_tower.selectedItem = data
				// this._list_tower.validateNow()
				// let idx = this._list_tower.selectedIndex
				// let th = this._scroll_tower.height
				// let sh = Math.max(0, _item_gap_ * idx + _item_height_ - th)
				// this._gp_tower.scrollV = Math.min(_max_height_, sh + _lt_gap_)
				// [ts2lua]lua中0和空字符串也是true，此处lv < _max_layer_需要确认
				let index = _cur_area_id_ * local_kfSingleRankDefine.LAYER_COUNT - lv + 1
				// this.ClickItemHandle(this.loop_tower.data_list[index])
				this.ClickItemHandle(index)
				
				//滑动到指定item
				this.ScrollToItem(index)
			}
		}

		this.UpdateViewByClick = (scmd?) => {
			this.UpdateTowerItems(scmd)
			let aid=this.GetCurArerId()
			let historyid=scmd.area_id||1
			if(aid<historyid){
				this.ClickItemHandle(0)
				this.ScrollToItem(1)
			}else{
				this.ClickItemHandle(9)
				this.ScrollToItem(10)
			}

		}

		this.GetCurArerId=()=>{
			let lv = this.model.GetCurLevel()
			let not_max = lv < _max_layer_
			let area_id = Math.floor(lv / local_kfSingleRankDefine.LAYER_COUNT)
			area_id = not_max ? area_id + 1 : area_id
			return area_id
		}

		this.ClickWinner = (index?, data?) => {
			_cur_wdata_ = data
			let tdata = this.model.GetAreaTopData(data.area_id)
			if (tdata) {
				this.UpdateRankItems(tdata)
			} else {
				this.model.Fire(local_kfSREvent.REQUEST_PROTO, 50703, "c", data.area_id)
			}
		}

		this.ClickLookHandle = () => {
			if (!_cur_wdata_) {
				return
			}
			local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "kfSRRewardView", _cur_wdata_.area_id)
		}

		this.ClickItemHandle = (index?,isShowAnim:boolean=true) => {
			this.loop_tower.SetSelectIndex(index)
			let data = this.loop_tower.data_list[index]
			_cur_data_ = data
			this.SelectData(_cur_data_)
			this.SetSelectAni(index,isShowAnim)
		}

		this.SelectData = (data?) => {
			if (!data) {
				return
			}
			let ldata = this.model.GetPlayerLevelData(data.level)
			this._lb_time.text = (ldata && (TimeUtil.timeConversionWithMillisecond(ldata.go_time, "mm:ss.ms")) || ("尚未通关"))
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
			let ddata = this.model.GetDunData(cfg, data.level)
			//let pinfo = this.model.GetPlayerInfo()
			let list = JSON.parse(ddata.reward)
			let lv = this.model.GetCurLevel()
			let cldata = this.model.GetCurLevelData()


			//lv = (lv == 1 && !cldata && (1) || (lv + 1))
			lv = lv == 1 && !cldata ? 1 : lv + 1
			for (let _tmpi in list) {
				let vo = list[_tmpi]
				vo.rw_state = data.level < lv ? (cldata ? 1 : data.rw_state) : 0
				//vo.rw_state = (data.level < lv && ((cldata && { 1 ) || (data.rw_state))} || { 0})[1]



			}

			if (!this.loop_reward) {
				this.loop_reward = new LoopScrowViewMgr()
				this.loop_reward.SetData(this.Content1, kfSRAwardItemC, list, LoopScrCon.Horizontal)
			} else {
				this.loop_reward.replaceAll(list)
			}


		}

		this.SelectCanGoItem = (isShowAnim:boolean=true) => {
			let lv = _cur_level_+1
			let index = _cur_area_id_ * local_kfSingleRankDefine.LAYER_COUNT - lv + 1
			this.ClickItemHandle(index-1,isShowAnim)//0-9
			this.ScrollToItem(index,isShowAnim)//1-10
		}

		this.SendEnterDun = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rank_dungeon", false)
			let ddata = this.model.GetDunData(cfg, _cur_data_.level)
			BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61001, ddata.dungeon_id)
		}

		this.UpdateClipNum=(area_id?)=>{
			this._lb_stage.text = `${area_id}`
			this._lb_stage.x=area_id==10?127:138
			this._image_sl.x=area_id==10?173:163
		}
	}

	//scrollview滚到指定item位置
	public ScrollToItem(index1?,isShowAnim:boolean=true) {
		//index1  1-10   
		let index=index1-1
		let item_pos_y = index * kfSRMainItem.height + this._list_tower.y+((index-1)*this._list_tower.spaceY)
		if(!isShowAnim)item_pos_y=item_pos_y-kfSRMainItem.height /2
		this._scroll_tower.scrollTo(0,item_pos_y)
	}

	//选中item时奖励的移动动画
	public SetSelectAni(index?,isShowAnim:boolean=true) {

		let item_pos_y = index * kfSRMainItem.height + this._list_tower.y+((index-1)*this._list_tower.spaceY)+60
		if (this.select_ani_id) {
			SYTweenLite.Stop(this.select_ani_id)
		}

		if(isShowAnim){
			this.select_ani_id = SYTweenLite.to(this, this._gp_show, SYTweenLite.UiAnimationType.POSY, item_pos_y, 0.5, null, SYTweenFunc.EASE_IN_OUT)
		}else{
			this._gp_show.y=item_pos_y
		}
		
	}

	public DeleteMe() {

		if (this.loop_tower) {
			this.loop_tower.DeleteMe()
			this.loop_tower = null
		}
		if (this.loop_rank) {
			this.loop_rank.DeleteMe()
			this.loop_rank = null
		}
		if (this.loop_reward) {
			this.loop_reward.DeleteMe()
			this.loop_reward = null
		}
		if (this.select_ani_id) {
			SYTweenLite.Stop(this.select_ani_id)
			this.select_ani_id = null
		}
		this.model.ClearAreaTowerData()
		this.model.ClearAreaTopData()

		if(this._scroll_tower&&this._scroll_tower.vScrollBar){
			this._scroll_tower.vScrollBar.changeHandler = null
		}
		


		super.DeleteMe()
	}

_scroll_tower:Laya.Panel
tower_top:Laya.Box
_Image1:Laya.Image
_Group1:Laya.Box
_image_sl:Laya.Image
_lb_stage:Laya.Label
_list_tower:Laya.List
_gp_show:Laya.Box
_Group3:Laya.Box
_Image3:Laya.Image
_lb_brst:Laya.Label
Content1:Laya.List
_Group4:Laya.Box
_Image5:Laya.Image
_lb_brst2:Laya.Label
_lb_time:Laya.Label
_btn_rank:Laya.Box
_Image7:Laya.Image
_Label1:Laya.Label
_img_004:Laya.Image
_Image8:Laya.Image
_Image111:Laya.Image
_Image9:Laya.Image
_btn_up:Laya.Box
_img_up:Laya.Image
_btn_down:Laya.Box
_img_dowm:Laya.Image
_img_link:Laya.Image
_btn_help:Laya.Image
_btn_shop:Laya.Image
_btn_area_up:Laya.Image
_btn_area_down:Laya.Image
_btn_go:Laya.Box
_Img_btn_go:Laya.Image
_lb_btn_go:Laya.Label
_btn_reward:Laya.Box
_Image11:Laya.Image
_Label3:Laya.Label
_red_reward:Laya.Image
_Group5:Laya.Box
_Label4:Laya.Label
_lb_count:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
_Label7:Laya.Label
_Label8:Laya.Label
_lb_look:Laya.Label
Content2:Laya.List
_select_bar_box:Laya.Box
_lb_top:Laya.Label
public GetComponents() {
[
this._scroll_tower,
this.tower_top,
this._Image1,
this._Group1,
this._image_sl,
this._lb_stage,
this._list_tower,
this._gp_show,
this._Group3,
this._Image3,
this._lb_brst,
this.Content1,
this._Group4,
this._Image5,
this._lb_brst2,
this._lb_time,
this._btn_rank,
this._Image7,
this._Label1,
this._img_004,
this._Image8,
this._Image111,
this._Image9,
this._btn_up,
this._img_up,
this._btn_down,
this._img_dowm,
this._img_link,
this._btn_help,
this._btn_shop,
this._btn_area_up,
this._btn_area_down,
this._btn_go,
this._Img_btn_go,
this._lb_btn_go,
this._btn_reward,
this._Image11,
this._Label3,
this._red_reward,
this._Group5,
this._Label4,
this._lb_count,
this._Label5,
this._Label6,
this._Label7,
this._Label8,
this._lb_look,
this.Content2,
this._select_bar_box,
this._lb_top,
]
 = this.GetChildrenByNames([

"_scroll_tower",
"tower_top",
"_Image1",
"_Group1",
"_image_sl",
"_lb_stage",
"_list_tower",
"_gp_show",
"_Group3",
"_Image3",
"_lb_brst",
"Content1",
"_Group4",
"_Image5",
"_lb_brst2",
"_lb_time",
"_btn_rank",
"_Image7",
"_Label1",
"_img_004",
"_Image8",
"_Image111",
"_Image9",
"_btn_up",
"_img_up",
"_btn_down",
"_img_dowm",
"_img_link",
"_btn_help",
"_btn_shop",
"_btn_area_up",
"_btn_area_down",
"_btn_go",
"_Img_btn_go",
"_lb_btn_go",
"_btn_reward",
"_Image11",
"_Label3",
"_red_reward",
"_Group5",
"_Label4",
"_lb_count",
"_Label5",
"_Label6",
"_Label7",
"_Label8",
"_lb_look",
"Content2",
"_select_bar_box",
"_lb_top",
])
}
}
 window["kfSRMainView"]= kfSRMainView