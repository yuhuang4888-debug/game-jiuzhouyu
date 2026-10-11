import { AutoFightManager } from "../autofight/AutoFightManager";
import { BaseItem1 } from "../common/BaseItem1";
import { EventName, ObjectEventType, SceneEventType } from "../common/EventName";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { MapModel } from "../commonModel/MapModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager";
import { MainRole } from "../scene/sceneobj/MainRole";
import { MainRoleVo } from "../sharedata/MainRoleVo";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem, LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { SetLocalPositionX, SetLocalPositionY, Util } from "../util/Util";
import { Vector2 } from "../util/Vector2";
import { AreaMapMonItem } from "./AreaMapMonItem";
import { AreaMapPonitItem } from "./AreaMapPonitItem";
import { AreaMapWayPonitItem } from "./AreaMapWayPonitItem";

export class AreaMapView extends BaseItem1 {
	public bg
	public map_scroll
	public scroll_group
	public map_img
	public item_con
	public way_point_con
	public main_role_point
	public way_con
	public mon_scroll
	public mon_scroll_group
	public _lb_title
	_Image1:Laya.Image
	_Image2:Laya.Image
	_Label1:Laya.Label
	role_name
	private data
	private needRefresh_ = false

	beginX
	beginX1
	beginY
	_tx
	_tx1
	_ty
	TabClick
	LoadSuccess
	InitEvents
	ClickPointFun
	SatrtFindWay
	DrawWayPoint
	CleayWayItemList
	CreateFullWayPoint
	GetDistance
	SetData
	SetAreaMap
	SetScroll
	SetMapScale
	SetMainRoleStartPos
	RefreshMainRolePos
	SetMapCharacterPoint
	SetSceneMon
	arrayCollection_: LoopScrowViewMgr

	maxX
	maxY
	minX
	minY

	clickMonList
	public constructor(parent) {
		super(parent)
		this.base_file = "map"
		this.layout_file = "AreaMapView"
		this.clickMonList=false
		let model = MapModel.GetInstance(),
			local_GlobalEventSystem = GlobalEventSystem,
			local_Util = Util,
			local_EventName = EventName,
			scene = Scene.GetInstance(),
			scene_mgr = SceneManager.GetInstance(),
			local_Vector2 = Vector2,
			scroll_pos_,
			scroll_size_,
			map_scale_,
			point_item_list_ = [],
			way_item_list_ = [],
			distance_ = 30

		this.load_callback = ()=> {
			this.LoadSuccess()
			this.InitEvents()
		}

		this.DeleteMe = () => {
			for (let item of point_item_list_) {
				item.DeleteMe()
				item = null
			}
			point_item_list_ = []
			for (let item of way_item_list_) {
				item.DeleteMe()
				item = null
			}
			way_item_list_ = []
			super.DeleteMe()
		}
		this.LoadSuccess = () => {
			this.maxX=0
			this.maxY=0
			this.minX=720-1292
			this.minY=-317
			// this.scroll_group.on(Laya.Event.MOUSE_DOWN, this,this.OnMouseDown);
			// this.mon_scroll_group.on(Laya.Event.MOUSE_DOWN, this,this.OnMouseDown1);
			scroll_pos_ = new local_Vector2()
			scroll_pos_.x = this.map_scroll.x
			scroll_pos_.y = this.map_scroll.y
			scroll_size_ = { "width": this.map_scroll.width, "height": this.map_scroll.height }
			map_scale_ = new local_Vector2()
		}

		this.InitEvents = () => {
			let mainRoleMove = (x, y) => {
				if (!this.use_delete_method) {
					this.RefreshMainRolePos(x, y)
				}
			}
			this.BindEvent(local_GlobalEventSystem, ObjectEventType.MAINROLE_MOVE_EVENT_IMME, mainRoleMove)

			let img_click_fun = (e) => {
				this.ClickPointFun(e.currentTarget.mouseX, e.currentTarget.mouseY)
			}
			local_Util.AddClickEvent(this.map_img, img_click_fun, this)

			let way_point = (_path, need_reverse?) => {
				this.CleayWayItemList()
				if (_path) {
					let path_list = _path
					if (need_reverse) {
						path_list = local_Util.DeepCopy(_path)
						path_list.reverse()
					}
					this.DrawWayPoint(path_list)
				}
			}
			this.BindEvent(local_GlobalEventSystem, local_EventName.BROADCAST_ROLE_WAY_POINT, way_point)

			this.SetData()
		}

		//点击地图上的某一点
		this.ClickPointFun = (x, y) => {
		    AutoFightManager.GetInstance().SetAutoFight(false);
			let real_x = x * map_scale_.x
			let real_y = y * map_scale_.y
			this.SatrtFindWay(new local_Vector2(real_x / LogicRealRatio_X, real_y / LogicRealRatio_Y))
		}

		this.SatrtFindWay = (findVo) => {
			let call_fun = () => {
				this.CleayWayItemList()
				// let move_end = () => {
				// 	let item
				// 	for (let i = 0; i<= way_item_list_.length - 1; i++) {
				// 		item = way_item_list_[i]
				// 		item.SetVisible(false)
				// 	}
	
				// }
				// move_end()
				// AutoFightManager.GetInstance().SetAutoFight(true)
			}
			let logic_pos = scene.main_role.GetLogicPos()
			let end_pos = { "x": findVo.x, "y": findVo.y }
			let path_info = scene.FindWay(logic_pos.x, logic_pos.y, findVo.x, findVo.y, 0)
			if (path_info) {
				path_info.reverse()
				let total_point = path_info.length
				if (total_point >= 1) {
					let game_end_pos = path_info[total_point - 1]
					end_pos.x = game_end_pos.x
					end_pos.y = game_end_pos.y
				}
			}
			//如果是直线要做一下转换
			if (scene.IsStraightLine(new local_Vector2(logic_pos.x, logic_pos.y), new local_Vector2(end_pos.x, end_pos.y))) {
				let path_list = []
				path_list.push(new local_Vector2(logic_pos.x, logic_pos.y))
				path_list.push(new local_Vector2(end_pos.x, end_pos.y))
				local_GlobalEventSystem.Fire(local_EventName.BROADCAST_ROLE_WAY_POINT, path_list)
				scene.MainRoleMove(findVo, 0, call_fun)
				return
			}
			let is_endPos_block = scene_mgr.IsBlockXY(findVo.x, findVo.y)
			if (is_endPos_block) {
				let dir = new local_Vector2(findVo.x - logic_pos.x, findVo.y - logic_pos.y)
				let dist = dir.normalise()
				let r = scene.DetectLastUnblockPoint(new local_Vector2(logic_pos.x, logic_pos.y), new local_Vector2(dir.x, dir.y), dist)
				if (r.z == 1) {
					let block_path_list = []
					block_path_list.push(new local_Vector2(logic_pos.x, logic_pos.y))
					block_path_list.push(new local_Vector2(r.x, r.y))
					local_GlobalEventSystem.Fire(local_EventName.BROADCAST_ROLE_WAY_POINT, block_path_list)
					scene.MainRoleMove(findVo, 0, call_fun)
					return
				}
			}
			local_GlobalEventSystem.Fire(local_EventName.BROADCAST_ROLE_WAY_POINT, path_info)
			scene.MainRoleMove(findVo, 1, call_fun)
		}

		this.DrawWayPoint = (path_list) => {
			// let path_list = local_Util.DeepCopy(_path)
			let path_info = this.CreateFullWayPoint(path_list)
			if (path_info && path_info.length > 0) {
				let len = path_info.length
				let item
				if (way_item_list_.length < len) {
					let old_length = way_item_list_.length
					let add_amount = len - way_item_list_.length
					for (let i = 0; i < add_amount; i++) {
						item = new AreaMapWayPonitItem(this.way_point_con)
						item.Load()
						way_item_list_[old_length + i] = item
					}
				} else if (way_item_list_.length > len) {
					let reduce_amount = way_item_list_.length - len
					for (let i = way_item_list_.length - reduce_amount; i >= way_item_list_.length - 1; i--) {
						item = way_item_list_[i]
						item.SetVisible(false)
					}
				}
				if (len > 0) {
					let vo
					for (let i = 0; i < len; i++) {
						vo = path_info[i]
						if(vo)
						{
							way_item_list_[i].SetVisible(true)
							way_item_list_[i].SetX(vo.x)
							way_item_list_[i].SetY(vo.y)
							way_item_list_[i].SetData(vo)
						}
					}
					way_item_list_[len - 1].SetDestPoint()
				}
			}
		}

		this.CleayWayItemList = () => {
			let item
			for (let i = 0; i<= way_item_list_.length - 1; i++) {
				item = way_item_list_[i]
				item.SetVisible(false)
			}
		}

		this.CreateFullWayPoint = (path_info) => {
			let point_list = []
			if (path_info) {
				let len = path_info.length
				for (let i = 0; i < len; i++) {
					path_info[i].x = path_info[i].x * LogicRealRatio_X / map_scale_.x - 8
					path_info[i].y = path_info[i].y * LogicRealRatio_Y / map_scale_.y - 34
				}
				point_list.push(path_info[0])
				let cur_point = point_list[0]
				let next_point
				let point
				let x
				let y
				let distance = distance_
				let sin
				let cos
				for (let i = 0; i < len - 1; i++) {
					next_point = path_info[i + 1]
					sin = Math.abs(cur_point.x - next_point.x) / Math.sqrt(this.GetDistance(cur_point, next_point))
					cos = Math.abs(cur_point.y - next_point.y) / Math.sqrt(this.GetDistance(cur_point, next_point))

					while (this.GetDistance(cur_point, next_point) > distance * distance) {
						x = cur_point.x >= next_point.x ? (cur_point.x - distance * sin) : (cur_point.x + distance * sin)
						y = cur_point.y >= next_point.y ? (cur_point.y - distance * cos) : (cur_point.y + distance * cos)
						point = new local_Vector2(x, y)
						point_list.push(point)
						cur_point = point_list[point_list.length - 1]
					}
					//距离大于10 或者是最后一个点
					if (this.GetDistance(cur_point, next_point) > 10 * 10 || i == (len - 1 - 1)) {
						point_list.push(next_point)
					}
					cur_point = point_list[point_list.length - 1]
				}

				if (point_list.length > 2) {
					if (this.GetDistance(point_list[point_list.length - 2], point_list[point_list.length - 1]) < 10 * 10) {
						point_list.splice(point_list.length - 2)
					}
				}
			}
			return point_list
		}

		this.GetDistance = (v1, v2) => {
			let x = v1.x - v2.x
			let y = v1.y - v2.y
			return x * x + y * y
		}
		this.SetData = () => {
			if (this.is_loaded) {
				this.SetAreaMap()
				this.SetSceneMon()
			}
		}

		//设置地图背景
		this.SetAreaMap = () => {
			let call_fun = () => {
				this.map_img.width = 1292
				this.map_img.height = 1138
				this.SetScroll()
				this.SetMapScale()
				this.SetMainRoleStartPos()
				this.SetMapCharacterPoint()
			}
			ResManager.GetInstance().SetTexture(this, this.map_img, GameResPath.GetAreaMapImg(scene_mgr.GetSceneId()), call_fun, this, true)
		}

		//设置滚动显示区域
		this.SetScroll = () => {
			let width_gap = scroll_size_.width - this.map_img.width
			let height_gap = scroll_size_.height - this.map_img.height
			this.map_scroll.x = width_gap > 0 ? (scroll_pos_.x + width_gap / 2) : scroll_pos_.x
			this.map_scroll.y = height_gap > 0 ? (scroll_pos_.y + height_gap / 2) : scroll_pos_.y
			// this.map_scroll.width = width_gap > 0 ? this.map_img.width : scroll_size_.width
			// this.map_scroll.height = height_gap > 0 ? this.map_img.height : scroll_size_.height
		}

		//设置地图缩放比例
		this.SetMapScale = () => {
			let scene_info = scene_mgr.GetSceneInfo(scene_mgr.GetSceneId())
			if (scene_info) {
				map_scale_.x = scene_info.width / this.map_img.width
				map_scale_.y = scene_info.height / this.map_img.height
				// egret.log("缩放比例++++++++++：", map_scale_.x, map_scale_.y)
			}
		}

		//设置主角当前位置
		this.SetMainRoleStartPos = () => {
			if (scene.GetMainRole()) {
				let logic_pos = scene.GetMainRole().GetLogicPos()
				let pos_x = logic_pos.x * LogicRealRatio_X / map_scale_.x
				let pos_y = logic_pos.y * LogicRealRatio_Y / map_scale_.y
				this.main_role_point.x = pos_x
				this.main_role_point.y = pos_y
				Laya.timer.once(10,this,()=>{
					if (this.use_delete_method) return
					this.map_scroll.hScrollBar.value=pos_x-360
					this.map_scroll.vScrollBar.value=pos_y-425
				})
				// this.scroll_group.x-=(pos_x-360)
				// if (this.scroll_group.x > this.maxX){
				// 	this.scroll_group.x = this.maxX
				// }else if (this.scroll_group.x <= this.minX){
				// 	this.scroll_group.x  = this.minX;
				// }
				// this.scroll_group.y-=(pos_y-360)
				// if (this.scroll_group.y > this.maxY){
				// 	this.scroll_group.y = this.maxY
				// }else if (this.scroll_group.y <= this.minY){
				// 	this.scroll_group.y  = this.minY;
				// }
				// if (pos_x > this.map_img.width / 2) {
				// 	let need = pos_x - this.map_scroll.width / 2
				// 	let gap = this.map_img.width - this.map_scroll.width
				// 	if (gap <= need) {
				// 		this.scroll_group.x = gap
				// 	} else {
				// 		this.scroll_group.x = need
				// 	}
				// }
				// if (pos_y > this.map_img.height / 2) {
				// 	let need = pos_y - this.map_scroll.height / 2
				// 	let gap = this.map_img.height - this.map_scroll.height
				// 	if (gap <= need) {
				// 		this.scroll_group.y = gap
				// 	} else {
				// 		this.scroll_group.y = need
				// 	}
				// }
			}
		}

		this.RefreshMainRolePos = (x, y) => {
			if (scene.GetMainRole()) {
				let pos_x = x / map_scale_.x
				let pos_y = y / map_scale_.y
				this.main_role_point.x = pos_x
				this.main_role_point.y = pos_y
			}
		}

		//设置地图的特殊点显示
		this.SetMapCharacterPoint = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientMapConfig", true)
			let map_cfg = model.GetSceneMonBySceneId(scene_mgr.GetSceneId(),cfg)
			if (map_cfg && map_cfg.point_list) {
				let item: AreaMapPonitItem
				let vo
				for (let i = 0; i < map_cfg.point_list.length; i++) {
					item = point_item_list_[i]
					if (!item) {
						item = new AreaMapPonitItem(this.item_con)
						item.Load()
						point_item_list_[i] = item
					}
					vo = map_cfg.point_list[i]
					if (vo) {
						item.SetData(vo)
						// item.x = vo.x / map_scale_.x - 41
						item.SetX(vo.x / map_scale_.x -42 )
						item.SetY(vo.y / map_scale_.y -63 )
						// item.y = vo.y / map_scale_.y - 19
					}
				}
			}
		}

		//设置场景怪物列表
		this.SetSceneMon = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientMapConfig", true)
			let map_cfg = model.GetSceneMonBySceneId(scene_mgr.GetSceneId(),cfg)
			if (map_cfg && map_cfg.point_list) {
				if (!this.arrayCollection_) {
					this.arrayCollection_ = new LoopScrowViewMgr()
					this.arrayCollection_.SetData(this.mon_scroll_group, AreaMapMonItem, map_cfg.point_list, LoopScrCon.Horizontal, 1, (index) => {
						this.TabClick(index)
					},-1)
					// Util.AddClickEvent(this.mon_scroll_group, this.TabClick, this);
				} else {
					this.arrayCollection_.replaceAll(map_cfg.point_list)
				}
			}
		}
		
		
		this.TabClick = (index) => {
            // AutoFightManager.GetInstance().SetAutoFight(false);
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientMapConfig", true)
				let scene_id = scene_mgr.GetSceneId()
				let map_cfg = model.GetSceneMonBySceneId(scene_id,cfg)
				if (map_cfg) {
				let data = map_cfg.point_list[index];
					if (data) {
						let call_fun = () => {
							// if (model.CheckOpenAutoFight()) {
							//     AutoFightManager.GetInstance().SetAutoFight(true);
							// }
						};
						// Scene.GetInstance().MainRoleMove(new Vector2(data.x / LogicRealRatio_X, data.y / LogicRealRatio_Y), 3, call_fun);
						//加的值是图标的x，y值
						let realposx=data.x//+(22)*map_scale_.x// +19
						let realposy=data.y//+(46.5)*map_scale_.y//+19
						let is_endPos_block1 = scene_mgr.IsBlockXY(realposx/LogicRealRatio_X, realposy / LogicRealRatio_Y)
						if(is_endPos_block1){
							Message.show("怪物坐标不可达")
						}else{
							Scene.GetInstance().MainRoleMove(new Vector2(realposx/ LogicRealRatio_X, realposy / LogicRealRatio_Y), 0, call_fun);
						}
					}
					model.Fire(MapModel.CLOSEMAPENTVIEW)
				}
		}
	}
	

	// public OnMouseDown(){
	// 	Laya.Tween.clearAll(this.scroll_group)
	// 	this.beginX=this.scroll_group.x
	// 	this.beginY=this.scroll_group.y
	// 	this._tx = Laya.stage.mouseX;
	// 	this._ty = Laya.stage.mouseY;
	// 	Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
	// 	Laya.stage.once(Laya.Event.MOUSE_UP, this, this.mouseUp);
	// 	Laya.stage.once(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	// 	// this.value_text.text=this.value.toString()
	// }
	
	// private mouseMove(e: Event): void {
	// 	let stage = Laya.stage;
	// 	this.scroll_group.x +=stage.mouseX - this._tx
	// 	this.scroll_group.y +=stage.mouseY - this._ty
	// 	if (this.scroll_group.x > this.maxX){
	// 		this.scroll_group.x = this.maxX
	// 	}else if (this.scroll_group.x <= this.minX){
	// 		this.scroll_group.x  = this.minX;
	// 	}
	// 	if (this.scroll_group.y > this.maxY){
	// 		this.scroll_group.y = this.maxY
	// 	}else if (this.scroll_group.y <= this.minY){
	// 		this.scroll_group.y  = this.minY;
	// 	}
	// 	this._tx = stage.mouseX;
	// 	this._ty = stage.mouseY;
	// }
	
	
	// private mouseUp(e: Event): void {
	// 	let stage = Laya.stage;
	// 	stage.off(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
	// 	stage.off(Laya.Event.MOUSE_UP, this, this.mouseUp);
	// 	stage.off(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	// }



	public GetComponents() {
		[
			this.bg,
			this.map_scroll,
			this.scroll_group,
			this.map_img,
			this.item_con,
			this.way_point_con,
			this.main_role_point,
			this._Image1,
			this._Image2,
			this._lb_title,
			this._Label1,
			this.way_con,
			this.mon_scroll,
			this.mon_scroll_group,
			this.role_name
		]
			= this.GetChildrenByNames([

				"bg",
				"map_scroll",
				"scroll_group",
				"map_img",
				"item_con",
				"way_point_con",
				"main_role_point",
				"_Image1",
				"_Image2",
				"_lb_title",
				"_Label1",
				"way_con",
				"mon_scroll",
				"mon_scroll_group",
				"role_name"
			])
			this.mon_scroll_group.hScrollBarSkin=""
			this.map_scroll.vScrollBarSkin = "";
			this.map_scroll.hScrollBarSkin="";
			let role=RoleManager.GetInstance().GetMainRoleVo()
			this.role_name.text=role.name

	}
}

window["AreaMapView"]=AreaMapView