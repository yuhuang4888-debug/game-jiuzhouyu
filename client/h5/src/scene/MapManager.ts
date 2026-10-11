import { BaseClass } from "../common/BaseClass";
import { AstarManager } from "./AstarManager";
import { Vector2 } from "../util/Vector2";
import { GlobalTimerQuest, Util } from "../util/Util";
import { LogicRealRatio_X, LogicRealRatio_Y, GlobalEventSystem } from "../util/DeclareGlobalVar";
import { Vector3 } from "../util/Vector3";
import { HashEventDispatcher } from "../common/HashEventDispatcher";
import { MapTile } from "./MapTile";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { SceneEventType } from "../common/EventName";
import { Config } from "../common/Config";
import { ResManager } from "../common/ResManager";
import { LOAD_QUEUE } from "../util/DeclareGlobalVar";
import { SapManager } from "./SapManager";
import { SceneEffect } from "./sceneobj/SceneEffect";
import { SceneManager } from "./SceneManager";

// TypeScript file
export class GridInfo {
	public y: number;
	public x: number;
}
export class AreaInfo {
	public id: number;
	public type: number;
	public data: {
		[key: string]: Boolean;
	} = {};
}
export class MapElement extends BaseClass {
	public tileSize;
	public mapHeight = 1;
	public mapWidth = 1;
	public tileCount = 1;
	public resId;
	public gridRow = 1;
	public gridCollumn = 1;
	public Grid: Array<Array<any>>;
	public findWayObj: AstarManager;
	private areaData: {
		[key: number]: AreaInfo;
	} = {};
	public tileDataSize;
	public maskDataSize;
	public tileList: Array<any>;
	block_pos = new Vector2();
	end_point_tmp = new Vector2();
	se_dir = new Vector2();
	detectLastUnblock_last_pt: Vector2 = new Vector2();
	detectLastUnblock_now_pt: Vector2 = new Vector2();
	LoadData;
	ExistTile;
	SetDynamicArea;
	FindWay;
	IsStraightLine;
	DetectLastUnblockPoint;
	DetectLastUnblockPoint2;
	DetectFirstUnblockPoint;
	FindWay2;
	findStraightEnd;
	GetAreaType;
	IsBlock;
	IsBlockXY;
	DynamicBlock;
	public constructor() {
		super();
		let local_Math = Math, Grid_Info = GridInfo, local_Vector2 = Vector2;
		this.findWayObj = new AstarManager(this);
		this.LoadData = (buff: ArrayBuffer) => {
			if (!this.tileList) {
				this.tileList = [];
			}
			let br = new Laya.Byte(buff);
			this.tileSize = br.readInt32();//>> 8;
			console.log("mapdata load tileSize", this.tileSize);
			this.mapHeight = br.readInt32();// >> 8;
			this.mapWidth = br.readInt32();// >> 8;
			this.tileCount = br.readInt32();// >> 24;
			MapManager.GetInstance().total_tile_max_count_x = local_Math.ceil(this.mapWidth / this.tileSize);
			MapManager.GetInstance().total_tile_max_count_y = local_Math.ceil(this.mapHeight / this.tileSize);
			//已不用，为兼容版本，先不去掉
			let readUnsignedInt = br.readUint32;
			this.tileDataSize = readUnsignedInt.call(br);
			this.maskDataSize = readUnsignedInt.call(br);
			//-----------------
			// console.log("mapdata load",this.tileSize, MapManager.GetInstance().total_tile_max_count_x , MapManager.GetInstance().total_tile_max_count_y, this.mapHeight, this.mapWidth, this.tileCount, this.tileDataSize, this.maskDataSize)
			let grid;
			for (let i = 0; i < this.tileCount; i++) {
				grid = this.tileList[i];
				if (!grid) {
					grid = new Grid_Info();
					this.tileList[i] = grid;
				}
				grid.x = readUnsignedInt.call(br);
				grid.y = readUnsignedInt.call(br);
			}
			this.tileList.length = this.tileCount;
			this.gridCollumn = local_Math.floor((this.mapWidth + LogicRealRatio_X - 1) / LogicRealRatio_X);
			this.gridRow = local_Math.floor((this.mapHeight + LogicRealRatio_Y - 1) / LogicRealRatio_Y);
			this.findWayObj.Init(br, this.gridCollumn, this.gridRow);
			//-----兼容新老版本，新加的属性都放后面-----
			//地图资源id  用于做场景资源复用
			this.resId = readUnsignedInt.call(br);
			console.log("this.resId =", this.resId);
			//动态区域数据解析
			//区域数量
			let area_count = readUnsignedInt.call(br), area, pos_count, x, y, pos, id, Area_Info = AreaInfo;
			this.areaData = {};
			for (let i = 0; i < area_count; i++) {
				id = readUnsignedInt.call(br);
				// area = this.areaData[id] || new AreaInfo();
				// if(!area)
				// {
				area = new Area_Info();
				this.areaData[id] = area;
				// }
				area.id = id;
				area.type = readUnsignedInt.call(br);
				area.data = area.data || {};
				pos_count = readUnsignedInt.call(br);
				for (let j = 0; j < pos_count; j++) {
					x = readUnsignedInt.call(br);
					y = readUnsignedInt.call(br);
					pos = `{${x}},{${y}}`;
					area.data[pos] = true;
				}
			}
			br.clear();
		};
		//判断地块是否存在，处理镂空场景情况
		this.ExistTile = (x, y) => {
			for (let i = 0; i < this.tileList.length; i++) {
				let grid = this.tileList[i];
				if (x == grid.x && y == grid.y)
					return true;
			}
			return false;
		};
		this.SetDynamicArea = (area_id, area_type) => {
			let area = this.areaData[area_id];
			if (area) {
				area.type = area_type;
			}
		};
		this.FindWay = (start, end, inflex_vec, range: number) => {
			let find_way_rlt = this.findWayObj.FindWay(start, end);
			if (find_way_rlt) {
				this.findWayObj.GenerateInflexPoint(inflex_vec, range);
			}
			return find_way_rlt;
		};
		this.IsStraightLine = (start_point: Vector2, end_pos: Vector2) => {
			// let end_point_tmp = new Vector2();
			let start_pos = new local_Vector2(start_point.x, start_point.y),
				// let end_pos = new Vector2(end_point.x, end_point.y);
				se_dir = end_pos.getDir(start_pos, this.se_dir), dis = se_dir.normalise();
			this.end_point_tmp.x = this.end_point_tmp.y = 0;
			if (this.DetectLastUnblockPoint2(start_pos, se_dir, dis, this.end_point_tmp)) {
				if (local_Math.floor(this.end_point_tmp.x) == local_Math.floor(end_pos.x) && local_Math.floor(this.end_point_tmp.y) == local_Math.floor(end_pos.y)) {
					return true;
				}
			}
			return false;
		};
		// this.handleStraightLine = (start_point:Vector2, dir:Vector2, max_distance:number, last_valid_point:Vector2) =>
		// {
		//	 let cur_dis = 0;
		//	 let dir_normal = dir;
		//	 dir_normal.normalise();
		//	 let last_step = new Vector2(start_point.x, start_point.y);
		//	 let next_step = new Vector2(start_point.x, start_point.y);
		//	 while (cur_dis < max_distance)
		//	 {
		//		 last_step = next_step;
		//		 cur_dis += 0.1;
		//		 if (cur_dis >= max_distance) cur_dis = max_distance;
		//		 next_step = Vector2.mul(dir_normal, cur_dis);
		//		 next_step = Vector2.add(start_point,next_step);
		//		 if (this.IsBlock(next_step))
		//		 {
		//			 last_valid_point.x = last_step.x;
		//			 last_valid_point.y = last_step.y;
		//			 return false;
		//		 }
		//		 // 如果是对角线，那么检查相邻方格是否都是障碍
		//		 let x_d = last_step.x - next_step.x;
		//		 let y_d = last_step.y - next_step.y;
		//		 if (x_d < 0)
		//		 {
		//			 x_d = -x_d;
		//		 }
		//		 if (y_d < 0)
		//		 {
		//			 y_d = -y_d;
		//		 }
		//		 let is_slash = ((x_d + y_d) == 2);
		//		 if (is_slash)
		//		 {
		//			 let p1 = new Vector2(last_step.x, next_step.y);
		//			 let p2 = new Vector2(next_step.x, last_step.y);
		//			 if (this.IsBlock(p1) || this.IsBlock(p2))
		//			 {
		//				 last_valid_point.x = last_step.x;
		//				 last_valid_point.y = last_step.y;
		//				 return false;
		//			 }
		//		 }
		//	 }
		//	 last_valid_point.x = last_step.x;
		//	 last_valid_point.y = last_step.y;
		//	 return true;
		// }
		let local_Vector3 = Vector3;
		this.DetectLastUnblockPoint = (start_point, dir, max_distance) => {
			let last_valid_point = new local_Vector2(0, 0);
			let ret = this.DetectLastUnblockPoint2(start_point, dir, max_distance, last_valid_point);
			if (ret) {
				if (this.IsBlock(last_valid_point)) {
					last_valid_point.x = 0;
					last_valid_point.y = 0;
					ret = this.DetectLastUnblockPoint2(start_point, dir, max_distance, last_valid_point);
				}
			}
			let real_ret = 0;
			if (ret)
				real_ret = 1;
			let result = new local_Vector3(last_valid_point.x, last_valid_point.y, real_ret);
			return result;
		};
		this.DetectLastUnblockPoint2 = (start_point: Vector2, dir_normal: Vector2, max_distance, last_valid_point) => {
			let cur_dis = 0.0,
				// step_x = 999.9,
				// step_y = 999.9,
				step = 999.9,
				// dx,
				// dy,
				detectLastUnblock_last_pt = this.detectLastUnblock_last_pt, detectLastUnblock_now_pt = this.detectLastUnblock_now_pt;
			// this.findWayObj.normalise(dir_normal);
			// dir_normal.normalise()
			start_point.x = local_Math.floor(start_point.x);
			start_point.y = local_Math.floor(start_point.y);
			detectLastUnblock_last_pt.x = start_point.x;
			detectLastUnblock_last_pt.y = start_point.y;
			detectLastUnblock_now_pt.x = start_point.x;
			detectLastUnblock_now_pt.y = start_point.y;
			if (dir_normal.x == 0 && dir_normal.y == 0) {
				last_valid_point.x = detectLastUnblock_last_pt.x;
				last_valid_point.y = detectLastUnblock_last_pt.y;
				return !this.IsBlock(detectLastUnblock_last_pt);
			}
			while (cur_dis < max_distance) {
				//计算步长，在当前格子内，最大能移动多少距离，保留0.5的安全距离
				// if (dir_normal.x != 0.0)
				// {
				//	 dx = 0;
				//	 if (dir_normal.x > 0)
				//	 {
				//		 dx = 0.95;
				//	 }
				//	 else
				//	 {
				//		 dx = -0.05;
				//	 }
				//	 step_x = dx / dir_normal.x;
				// }
				// if (dir_normal.y != 0.0)
				// {
				//	 dy = 0;
				//	 if (dir_normal.y > 0)
				//	 {
				//		 dy = 0.95;
				//	 }
				//	 else
				//	 {
				//		 dy = -0.05;
				//	 }
				//	 step_y = dy / dir_normal.y;
				// }
				// //如果有小于0的，说明靠近边缘0.5了，要缩短步长
				// if (step_x < 1e-3 || step_y < 1e-3)
				// {
				//	 step = 0.08;
				// }
				// else
				// {
				//	 step = local_Math.min(step_x, step_y);
				// }
				cur_dis += 0.5;
				if (cur_dis > max_distance)
					cur_dis = max_distance;
				detectLastUnblock_now_pt.x = local_Math.floor(start_point.x + dir_normal.x * cur_dis);
				detectLastUnblock_now_pt.y = local_Math.floor(start_point.y + dir_normal.y * cur_dis);
				// 如果新点是障碍即跳出
				if (this.IsBlock(detectLastUnblock_now_pt)) {
					break;
				}
				// 如果是对角线，那么检查相邻方格是否都是障碍
				let is_slash = (detectLastUnblock_last_pt.x != detectLastUnblock_now_pt.x && (detectLastUnblock_last_pt.y != detectLastUnblock_now_pt.y));
				if (is_slash) {
					// let p1 = new Vector2(detectLastUnblock_last_pt.x, detectLastUnblock_now_pt.y);
					// let p2 = new Vector2(detectLastUnblock_now_pt.x, detectLastUnblock_last_pt.y);
					if (this.IsBlockXY(detectLastUnblock_last_pt.x, detectLastUnblock_now_pt.y) && this.IsBlockXY(detectLastUnblock_now_pt.x, detectLastUnblock_last_pt.y)) {
						break;
					}
				}
				// 运行到这里的detectLastUnblock_now_pt肯定是有效点，而且也不会漏掉cur_dis == max_distance时的临界值
				detectLastUnblock_last_pt.x = detectLastUnblock_now_pt.x;
				detectLastUnblock_last_pt.y = detectLastUnblock_now_pt.y;
			}
			last_valid_point.x = detectLastUnblock_last_pt.x;
			last_valid_point.y = detectLastUnblock_last_pt.y;
			return true;
		};
		this.DetectFirstUnblockPoint = (start_point, dir_normal, max_distance) => {
			let cur_dis = 0.0, now_pt = start_point, valid_point = new local_Vector2(),
				// step_x = 999.9,
				// step_y = 999.9,
				// step = 999.9,
				// dx,
				// dy ,
				tmp;
			// this.findWayObj.normalise(dir_normal);
			if (dir_normal.x == 0 && dir_normal.y == 0) {
				valid_point = now_pt;
				let ret = 0;
				if (!this.IsBlock(now_pt))
					ret = 1;
				return new local_Vector3(valid_point.x, valid_point.y, ret);
			}
			while (true) {
				if (!this.IsBlock(now_pt)) {
					valid_point = now_pt;
					return new local_Vector3(valid_point.x, valid_point.y, 1);
				}
				//计算步长，在当前格子内，最大能移动多少距离，保留0.5的安全距离
				// step_x = 999.9;
				// step_y = 999.9;
				// step = 999.9;
				// if (dir_normal.x != 0.0)
				// {
				//	 dx;
				//	 if (dir_normal.x > 0)
				//	 {
				//		 dx = 0.95;
				//	 }
				//	 else
				//	 {
				//		 dx = -0.05;
				//	 }
				//	 step_x = dx / dir_normal.x;
				// }
				// if (dir_normal.y != 0.0)
				// {
				//	 dy = 0;
				//	 if (dir_normal.y > 0)
				//	 {
				//		 dy = 0.95
				//	 }
				//	 else
				//	 {
				//		 dy = -0.05;
				//	 }
				//	 step_y = dy / dir_normal.y;
				// }
				// //如果有小于0的，说明靠近边缘0.5了，要缩短步长
				// if (step_x < 1e-3 || step_y < 1e-3)
				// {
				//	 step = 0.08;
				// }
				// else
				// {
				//	 step = local_Math.min(step_x, step_y);
				// }
				cur_dis += 0.5;
				if (cur_dis >= max_distance) {
					break;
				}
				now_pt.x = local_Math.floor(start_point.x + dir_normal.x * cur_dis);
				now_pt.y = local_Math.floor(start_point.y + dir_normal.y * cur_dis);
			}
			tmp.x = start_point.x;
			tmp.y = start_point.y;
			if (!this.IsBlock(tmp)) {
				valid_point = now_pt;
				return new local_Vector3(valid_point.x, valid_point.y, 1);
			}
			return new local_Vector3(valid_point.x, valid_point.y, 0);
		};
		this.FindWay2 = (start_point, end_point, range) => {
			// let start_point = new Vector2(local_Math.floor(start.x), local_Math.floor(start.y));
			// let end_point = new Vector2(local_Math.floor(end.x), local_Math.floor(end.y));
			// start_point.x = local_Math.floor(start_point.x)
			// start_point.y = local_Math.floor(start_point.y)
			end_point.x = local_Math.floor(end_point.x);
			end_point.y = local_Math.floor(end_point.y);
			if (start_point.x == end_point.x && start_point.y == end_point.y) {
				let findWayVec: Array<Vector2>;
				findWayVec = new Array(2);
				findWayVec[0] = start_point; //new Vector2(start_point.x, start_point.y);
				findWayVec[1] = end_point; //new Vector2(end_point.x, end_point.y);
				return findWayVec;
			}
			let inflex_vec = [];
			let find_way_rlt = this.FindWay(start_point, end_point, inflex_vec, range);
			// if (find_way_rlt)
			// {
			// return inflex_vec
			// findWayVec = [];
			// for (let i = inflex_vec.length - 1; i >= 0; i--)
			// {
			//	 findWayVec[inflex_vec.length - i - 1] = inflex_vec[i];
			// }
			//	 inflex_vec.reverse()
			//	 return inflex_vec;
			// }
			return inflex_vec;
		};
		this.findStraightEnd = (player_logic_pos, dir, max_distance) => {
			if (dir.x == 0.0 && dir.y == 0.0) {
				return player_logic_pos;
			}
			let end_point = new local_Vector2();
			this.DetectLastUnblockPoint2(player_logic_pos, dir, max_distance, end_point);
			return end_point;
		};
		this.GetAreaType = (x, y) => {
			let result = this.findWayObj.GetZoneInfo(x, y);
			if ((result & 1) == 0) { //1 this.findWayObj.ZONE_TYPE_BLOCK
				//可行走区域，再检测动态区域
				let temp = `{${x}},{${y}}`;
				for (let i in this.areaData) {
					if (this.areaData[i].data[temp]) {
						return this.areaData[i].type;
					}
				}
			}
			return result;
		};
		this.IsBlock = (pos) => {
			let result = this.findWayObj.GetZoneInfo(pos.x, pos.y);
			let ret = false;
			if ((result & 1) != 0) { //1 this.findWayObj.ZONE_TYPE_BLOCK
				ret = true;
			}
			if (!ret) {
				return this.DynamicBlock(pos.x, pos.y);
			}
			return ret;
		};
		this.IsBlockXY = (x, y) => {
			this.block_pos.x = x;
			this.block_pos.y = y;
			return this.IsBlock(this.block_pos);
		};
		this.DynamicBlock = (x, y) => {
			let temp = `{${local_Math.round(x)}},{${local_Math.round(y)}}`;
			for (let i in this.areaData) {
				if (this.areaData[i].type == 1) { //1 this.findWayObj.ZONE_TYPE_BLOCK
					if (this.areaData[i].data[temp]) {
						return true;
					}
				}
			}
			return false;
		};
	}
}
export class MapManager extends HashEventDispatcher {
	private static _instance: MapManager;
	public curMapData: MapElement = new MapElement();
	//场景资源id
	public curResId: number = 0;
	//场景id 
	public curMapId: number = 0;

	//是否相同的场景资源id
	public is_same_res_id = false
	find_way_vector1: Vector2 = new Vector2();
	find_way_vector2: Vector2 = new Vector2();
	last_load_tile_start_x = -10;
	last_load_tile_start_y = -10;
	cache_tile_max_count_x = 4; //x方向上需要加载的tile最大数量
	cache_tile_max_count_y = 6; //y方向上需要加载的tile最大数量
	curr_loaded_tile_count = 0; //当前场景加载完的titl数量
	loaded_all_tile_callback; //加载完一屏格子的时候回调
	tile_list: Array<MapTile> = [];
	tile_list_len = 0;
	map_date_loaded = false;
	total_tile_max_count_x = 0; //当前地图x方向上最大的tile数量
	total_tile_max_count_y = 0; //当前地图y方向上最大的tile数量
	scene_effect_container
	public map_parent: Laya.Sprite;
	private _backgroup_img: Laya.Image;
	private _middle_img1: Laya.Image;
	private _middle_img2: Laya.Image;
	private _bg_img_move_id;
	private _res_hashcode_target: BaseClass = new BaseClass();
	private _mini_res_hashcode_target: BaseClass = new BaseClass();
	private _need_update_map_visible
	public mini_scene_bg: Laya.Image = new Laya.Image();
	effect_list = {}
	map_visible_type_dic
	/**判断隐藏的优先级，值越大先判断 */
    map_visible_type_level = {
		"BanquetAniManager":10
    }


	// public map_texture: Laya.RenderTexture = new Laya.RenderTexture();
	InitData;
	ClearData;
	UpdateTiles;
	LoadSingleTileComplete;
	Load;
	ReloadFirstSceneMiniRes;
	MultiSceneHandler;
	GetSceneRandomPos;
	GetSceneWidth;
	GetSceneHeight;
	DetectFirstUnblockPoint;
	DetectLastUnblockPoint;
	FindWay;
	IsStraightLine;
	IsBlockXY;
	GetTileSize;
	GetResID;
	IsAreaType;
	SetDynamicArea;
	UnRegiestEffectList
	RegiestEffectList
	CreateEffect
	DeleteEffect
	SetMapVisible
	UpdateMapVisible
	public constructor() {
		super();
		this.InitData = () => {
			if (!this.map_parent) {
				this.map_parent = new Laya.Sprite();
				this.map_parent.name = "map_parent";
				LayerManager.GetInstance().GetUILayer(Enum_UILayer.Scene).addChildAt(this.map_parent, 0);
				this.map_parent.mouseEnabled = false;
				this.mini_scene_bg.mouseEnabled = false;
				LayerManager.GetInstance().GetUILayer(Enum_UILayer.Scene).addChildAt(this.mini_scene_bg, 0);
				if (Laya.Browser.onPC) {
					this.cache_tile_max_count_x = 12;
				}
				else {
					this.cache_tile_max_count_x = Math.floor(LayerManager.GetInstance().stage.width / 256) + 2;
				}
				this.cache_tile_max_count_y = Math.floor(LayerManager.GetInstance().stage.height / 256) + 1;
				this.tile_list_len = this.cache_tile_max_count_x * this.cache_tile_max_count_y;
				for (let i = 0; i < this.tile_list_len; i++) {
					this.tile_list.push(new MapTile(this.map_parent));
				}
				let onCameraMove = (x, y) => {
					this.UpdateTiles(x, y);
				};
				GlobalEventSystem.Bind(SceneEventType.CAMERA_MOVE, onCameraMove);

				if(this._need_update_map_visible){
					this._need_update_map_visible = undefined
					this.UpdateMapVisible()
				}
			}
		};
		this.ClearData = () => {
			this.map_date_loaded = false;
			for (let tile of this.tile_list) {
				tile.Clear();
			}
			this.last_load_tile_start_x = -10;
			this.last_load_tile_start_y = -10;
			if (this._bg_img_move_id) {
				GlobalTimerQuest.CancelQuest(this._bg_img_move_id);
				this._bg_img_move_id = null;
			}
		};

		let local_Math = Math;
		this.UpdateTiles = (camera_x, camera_y) => {
			// if (!scene.IsSceneLoaded())
			// 	return;
			let tile_size = this.GetTileSize();
			if (tile_size <= 0) return
			let x = local_Math.ceil(camera_x / tile_size);
			let y = local_Math.ceil(camera_y / tile_size);
			let start_x = local_Math.ceil(this.cache_tile_max_count_x * 0.5) - 1;
			let start_y = local_Math.ceil(this.cache_tile_max_count_y * 0.5) - 0;
			if (camera_x % tile_size < 0.5 * tile_size) {
				start_x++;
			}
			if (camera_y % tile_size < 0.5 * tile_size) {
				start_y++;
			}
			start_x = x - start_x;
			start_y = y - start_y;
			if (this.last_load_tile_start_x == start_x && this.last_load_tile_start_y == start_y) {
				return;
			}
			let x_len = start_x + this.cache_tile_max_count_x - 1;
			let y_len = start_y + this.cache_tile_max_count_y - 1;
			let cache_index = 0;
			let tile;
			let last_x_len = this.last_load_tile_start_x + this.cache_tile_max_count_x - 1;
			let last_y_len = this.last_load_tile_start_y + this.cache_tile_max_count_y - 1;
			let tile_list = this.tile_list;
			let tile_list_len = this.tile_list_len;
			let LoadSingleTileComplete = this.LoadSingleTileComplete;
			for (let i = start_y; i <= y_len; i++) {
				for (let j = start_x; j <= x_len; j++) {
					if (i < this.last_load_tile_start_y || i > last_y_len || j < this.last_load_tile_start_x || j > last_x_len) {
						for (let index = cache_index; index < tile_list_len; index++) {
							tile = tile_list[index];
							cache_index++;
							if (tile.row < start_y || tile.row > y_len || tile.col < start_x || tile.col > x_len) {
								tile.Load(i, j, LoadSingleTileComplete);
								// console.log("load tile = ", i, j)
								break;
							}
						}
					}
				}
			}
			// scene.UpdateSceneEffect();
			this.last_load_tile_start_x = start_x;
			this.last_load_tile_start_y = start_y;
		};
		this.LoadSingleTileComplete = () => {
			if (this.loaded_all_tile_callback) {
				++this.curr_loaded_tile_count;
				if (this.curr_loaded_tile_count >= this.tile_list_len) {
					this.loaded_all_tile_callback(this.curr_loaded_tile_count, this.tile_list_len);
					this.loaded_all_tile_callback = null;
				}
			}
		};
		let res_mrg = ResManager.GetInstance();
		this.Load = (mapId, load_map_func?, load_map_default_res?, load_tile_func?) => {
			console.log("mapmanager load")
			this.map_date_loaded = false;
			this.curMapId = mapId;
			this.loaded_all_tile_callback = load_tile_func;
			let callback = (ab: ArrayBuffer) => {
				if (this.curMapId != mapId)
					return;
				// SceneManager.GetInstance().has_bytes_map_load = true;
				console.log("load = ", mapId, ab);
				this.curMapData.LoadData(ab);
				this.is_same_res_id = true;
				let old_res_id = this.curResId;
				if (this.curMapData.resId == this.curResId) {
					// this.last_load_tile_start_x = 0
					// this.last_load_tile_start_y = 0
				}
				else {
					this.curResId = this.curMapData.resId;
					this.is_same_res_id = false;
				}
				this.curr_loaded_tile_count = 0;


				if (this.scene_effect_container == null) {
					let sprite = new Laya.Sprite3D()
					sprite.name = "effect_container"
					this.scene_effect_container = sprite
					LayerManager.GetInstance().Scene3D.addChildAt(sprite, 0)
				}

				if (1) //Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.load_mini_map[this.curResId])
				{
					if (this.is_same_res_id) {
						// SceneManager.GetInstance().has_min_map_load = true;
						this.map_date_loaded = true;
						if (load_map_func) {
							load_map_func();
						}
						this.RegiestEffectList()
					}
					else {
						let prefix = "jpg";
						let res_id = this.curResId;
						let is_same_res_id = this.is_same_res_id;
						if (Util.use_ktx && Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.ktx_scene[this.curResId]) {
							prefix = "ktx"
						}

						let url = `resource/game/scene/map/${this.curResId}/tile/${this.curResId}.${prefix}`
						console.warn(url);
						res_mrg.GetResByUrl(this._mini_res_hashcode_target.hashCode, url, (data) => {
							console.log("load mini map completed11111")
							if (!is_same_res_id) {
								// res_mrg.DestroyAllReferenceRes(this._mini_res_hashcode_target.hashCode)
								if (old_res_id) {
									res_mrg.ReduceReferenceCount(this._mini_res_hashcode_target.hashCode, `resource/game/scene/map/${old_res_id}/tile/${old_res_id}.${prefix}`);
								}
							}
							if (res_id == this.curResId) {
								console.log("1111111111load mini map completed22222", this.curResId)
								this.ClearData();
								this.map_date_loaded = true;
								if (!is_same_res_id) {
									if (!this.mini_scene_bg.visible) {
										this.mini_scene_bg.visible = true;
									}
									this.mini_scene_bg.width = this.mini_scene_bg.height = 10;
									this.mini_scene_bg.source = data;
									this.mini_scene_bg.width = this.curMapData.mapWidth;
									this.mini_scene_bg.height = this.curMapData.mapHeight;
									console.log("1111111111111112222load mini map completed not same res id ", this.curResId, this.curMapData.mapWidth, this.curMapData.mapHeight)
								}
								console.log("load mini map completed333333")
								// SceneManager.GetInstance().has_min_map_load = true;
								if (load_map_func) {
									load_map_func();
								}
								this.MultiSceneHandler();
							}
							this.RegiestEffectList()
						}, this, Laya.Loader.IMAGE, LOAD_QUEUE.HIGHT, null, this);
					}
				}
				else {
					this.mini_scene_bg.visible = false;
					if (!this.is_same_res_id) {
						this.ClearData();
						res_mrg.DestroyAllReferenceRes(this._mini_res_hashcode_target.hashCode);
					}
					this.map_date_loaded = true;
					if (load_map_func) {
						load_map_func();
					}
					this.MultiSceneHandler();
				}
			};
			// SceneManager.GetInstance().send_load_map = true;

			res_mrg.GetResByUrl(this._res_hashcode_target.hashCode, "resource/game/scene/map/" + mapId + "/" + mapId + ".bytes", callback, this, Laya.Loader.BUFFER, LOAD_QUEUE.HIGHT);
		};
		//首次进入游戏先预加载小地图 避免看见黑一片的场景效果
		this.ReloadFirstSceneMiniRes = async () => {
			let resolve_func;
			let promise: Promise<any> = new Promise<any>((resolve, reject) => { resolve_func = resolve; });
			let mapId = 0//RoleManager.GetInstance().GetMainRoleVo().lastSceneId;
			let set_timeout_id;
			let callback = (ab: ArrayBuffer) => {
				this.curMapData.LoadData(ab);
				// if (Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.multi_scene[this.curMapData.resId]) {
				// 	if (resolve_func) {
				// 		resolve_func();
				// 		resolve_func = null;
				// 	}
				// 	return;
				// }
				this.curResId = this.curMapData.resId;
				if (1) //Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.load_mini_map[this.curResId] && !Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.multi_scene[this.curResId])
				{
					res_mrg.GetResByUrl(this._res_hashcode_target.hashCode, `resource/game/scene/map/${this.curResId}/tile/${this.curResId}.jpg`, (data) => {
						this.mini_scene_bg.visible = true;
						this.mini_scene_bg.texture = data;
						this.mini_scene_bg.width = this.curMapData.mapWidth;
						this.mini_scene_bg.height = this.curMapData.mapHeight;
						if (resolve_func) {
							resolve_func();
							resolve_func = null;
						}
						if (set_timeout_id) {
							GlobalTimerQuest.CancelQuest(set_timeout_id);
							set_timeout_id = null;
						}
					}, this, Laya.Loader.IMAGE, LOAD_QUEUE.HIGHT);
				}
				else {
					this.mini_scene_bg.visible = false;
					if (resolve_func) {
						resolve_func();
						resolve_func = null;
					}
					if (set_timeout_id) {
						GlobalTimerQuest.CancelQuest(set_timeout_id);
						set_timeout_id = null;
					}
				}
			};
			res_mrg.GetResByUrl(this.hashCode, "resource/game/scene/map/" + mapId + "/" + mapId + ".bytes", callback, this, Laya.Loader.BUFFER, LOAD_QUEUE.HIGHT);
			set_timeout_id = GlobalTimerQuest.AddDelayQuest(() => {
				if (resolve_func) {
					resolve_func();
					resolve_func = null;
				}
				if (set_timeout_id) {
					GlobalTimerQuest.CancelQuest(set_timeout_id);
					set_timeout_id = null;
				}
			}, 3000);
			await promise;
		};
		//多层地图处理
		this.MultiSceneHandler = () => {
			let curr_res_id = MapManager.GetInstance().GetResID();
			let multi_scene_cfg //= Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.multi_scene[curr_res_id];
			if (this._bg_img_move_id) {
				GlobalTimerQuest.CancelQuest(this._bg_img_move_id);
				this._bg_img_move_id = null;
			}
			if (multi_scene_cfg) {
				if (multi_scene_cfg.scene_count == 3) {
					if (this._middle_img1 == null) {
						this._middle_img1 = new Laya.Image();
						LayerManager.GetInstance().GetUILayer(Enum_UILayer.Scene).addChildAt(this._middle_img1, 1);
						this._middle_img1.x = this._middle_img1.y = 0;
						// this._middle_img1.cacheAsBitmap = true
					}
					else {
						if (this._middle_img1.visible == false) {
							this._middle_img1.visible = true;
						}
					}
					if (this._middle_img2 == null) {
						this._middle_img2 = new Laya.Image();
						LayerManager.GetInstance().GetUILayer(Enum_UILayer.Scene).addChildAt(this._middle_img2, 1);
						this._middle_img2.x = this._middle_img2.y = 0;
						// this._middle_img2.cacheAsBitmap = true
					}
					else {
						if (this._middle_img2.visible == false) {
							this._middle_img2.visible = true;
						}
					}
					if (this._backgroup_img == null) {
						this._backgroup_img = new Laya.Image();
						LayerManager.GetInstance().GetUILayer(Enum_UILayer.Scene).addChildAt(this._backgroup_img, 1);
						this._backgroup_img.x = this._backgroup_img.y = 0;
						// this._backgroup_img.cacheAsBitmap = true
					}
					else {
						if (this._backgroup_img.visible == false) {
							this._backgroup_img.visible = true;
						}
					}
					let loadBgCompleted = (texture: Laya.Texture) => {
						if (curr_res_id == MapManager.GetInstance().GetResID()) {
							this._backgroup_img.texture = texture;
						}
					};
					let middle_img_has_loaded = false;
					let loadMidCompleted = (texture: Laya.Texture) => {
						if (curr_res_id == MapManager.GetInstance().GetResID()) {
							middle_img_has_loaded = true;
							this._middle_img1.texture = texture;
							this._middle_img2.texture = texture;
							this._middle_img1.y = -this._middle_img1.height;
							this._middle_img2.y = 0;
						}
					};
					res_mrg.GetResByUrl(this._res_hashcode_target.hashCode, `resource/game/scene/map/${curr_res_id}/tile/bg_img.jxr`, loadBgCompleted, this, Laya.Loader.IMAGE, LOAD_QUEUE.LOW);
					res_mrg.GetResByUrl(this._res_hashcode_target.hashCode, `resource/game/scene/map/${curr_res_id}/tile/middle_img.jxr`, loadMidCompleted, this, Laya.Loader.IMAGE, LOAD_QUEUE.LOW);
					let last_time = Laya.timer.currTimer * 0.001;
					let UpdateMiddleImg = () => {
						if (middle_img_has_loaded) {
							// let h_off = this._middle_img1.height - LayerManager.GetInstance().stageHeight
							// if(h_off > 0)
							// {
							let now_time = Laya.timer.currTimer * 0.001;
							let elapse_time = (now_time - last_time);
							if (this._middle_img1.y < 0) {
								this._middle_img1.y = this._middle_img1.y + elapse_time * multi_scene_cfg.move_speed;
								this._middle_img2.y = this._middle_img2.y + elapse_time * multi_scene_cfg.move_speed;
							}
							else {
								this._middle_img2.y = this._middle_img1.y;
								this._middle_img1.y = -this._middle_img1.height + this._middle_img1.y;
							}
							last_time = now_time;
							// }else
							// {   
							//	 this._middle_img1.y = 0
							//	 this._middle_img2.y = this._middle_img1.height
							//	  if(this._bg_img_move_id)
							//	 {
							//		 GlobalTimerQuest.CancelQuest(this._bg_img_move_id)
							//		 this._bg_img_move_id = null
							//	 }
							// }
						}
					};
					UpdateMiddleImg();
					this._bg_img_move_id = GlobalTimerQuest.AddPeriodQuest(UpdateMiddleImg, 10);
				}
			}
			else {
				if (this._backgroup_img && this._backgroup_img.parent) {
					this._backgroup_img.parent.removeChild(this._backgroup_img);
					this._backgroup_img = null;
				}
				if (this._middle_img1 && this._middle_img1.parent) {
					this._middle_img1.parent.removeChild(this._middle_img1);
					this._middle_img1 = null;
				}
				if (this._middle_img2 && this._middle_img2.parent) {
					this._middle_img2.parent.removeChild(this._middle_img2);
					this._middle_img2 = null;
				}
			}
		};
		//后去场景随机坐标
		//index = 0 左边  = 1右边
		this.GetSceneRandomPos = (index) => {
			let scene_random_pos = new Vector2(0, 0);
			if (index == 0) {
				scene_random_pos.x = -300;
			}
			else {
				scene_random_pos.x = this.GetSceneWidth() + 300;
			}
			scene_random_pos.y = this.GetSceneHeight() * local_Math.random();
			return scene_random_pos;
		};
		this.GetSceneWidth = () => {
			return this.curMapData.mapWidth;
		};
		this.GetSceneHeight = () => {
			return this.curMapData.mapHeight;
		};
		this.DetectFirstUnblockPoint = (pos, dir, max_dist) => {
			let p = this.curMapData.DetectFirstUnblockPoint(pos, dir, max_dist);
			return p;
		};
		this.DetectLastUnblockPoint = (pos, dir, dist) => {
			let point = null;
			point = this.curMapData.DetectLastUnblockPoint(pos, dir, dist);
			return point;
		};
		this.FindWay = (pos1_x, pos1_y, pos2_x, pos2_y, range) => {
			this.find_way_vector1.x = pos1_x;
			this.find_way_vector1.y = pos1_y;
			this.find_way_vector2.x = pos2_x;
			this.find_way_vector2.y = pos2_y;
			let objs = this.curMapData.FindWay2(this.find_way_vector1, this.find_way_vector2, range);
			return objs;
		};
		this.IsStraightLine = (pos1, pos2) => {
			return this.curMapData.IsStraightLine(pos1, pos2);
		};
		this.IsBlockXY = (x, y) => {
			return this.curMapData.IsBlockXY(x, y);
		};
		this.GetTileSize = () => {
			return this.curMapData.tileSize;
		};
		this.GetResID = (is_minimap?) => {
			// if (is_minimap)
			// {
			// return Config.ConfigMiniMap[tonumber(this.curMapId)] or this.curResId
			// }
			return this.curResId;
		};
		this.IsAreaType = (x, y, area_type) => {
			let cur_type = this.curMapData.GetAreaType(x, y);
			if ((cur_type & area_type) != 0) {
				return true;
			}
			return false;
		};
		this.SetDynamicArea = (area_id, area_type) => {
			this.curMapData.SetDynamicArea(area_id, area_type);
			return false;
		};
		this.RegiestEffectList = () => {
			let scene_effect = Config.PRELOAD_CLIENT_CONFIG.ConfigSceneEffect[Number(this.curMapId)]
			if (scene_effect) {
				for (let key in scene_effect) {
					var effect = scene_effect[key]
					effect.id = Number(key) + 1
					let obj =
					{
						id: effect.id,
						type: SapManager.ObjType.Effect,
						pos: new Vector2(effect.x, effect.y),
						size: new Vector2(effect.size_x * effect.effectScale_x, effect.size_y * effect.effectScale_y),
						data: effect
					}
					SapManager.GetInstance().RegisterObj(obj)
				}
			}
		}
		this.UnRegiestEffectList = (scene_id) => {
			scene_id = scene_id || SceneManager.GetInstance().GetLastSceneId()
			let scene_effect = Config.PRELOAD_CLIENT_CONFIG.ConfigSceneEffect && Config.PRELOAD_CLIENT_CONFIG.ConfigSceneEffect[Number(scene_id)]
			if (scene_effect) {
				for (let id in scene_effect) {
					SapManager.GetInstance().UnRegisterObj(SapManager.ObjType.Effect, Number(id) + 1)
				}
			}
		}

		this.CreateEffect = (data) => {
			if (this.scene_effect_container) {
				this.effect_list[data.id] = new SceneEffect(data, this.scene_effect_container, Number(this.curMapId))
			}
		}

		this.DeleteEffect = (data) => {
			let effect = this.effect_list[data.id]
			if (effect) {
				effect.DeleteMe()
				delete this.effect_list[data.id]
			}
		}

		this.SetMapVisible = (visible_type, visible, need_refresh = true) =>{
			if(this.map_visible_type_dic == null){
				this.map_visible_type_dic = {}
			}
			let level = this.map_visible_type_level[visible_type] || 0
			if(this.map_visible_type_dic[level] == null){
				this.map_visible_type_dic[level] = {}
			}
	
			if(visible == null){
				delete this.map_visible_type_dic[level][visible_type]
			}
			else{
				this.map_visible_type_dic[level][visible_type] = visible
			}
	
			if(need_refresh){
				if(this.map_parent){
					this.UpdateMapVisible()
				}
				else{
					this._need_update_map_visible = true
				}
			}
		}

		this.UpdateMapVisible = () =>{
			let max_level = 0, visible_type_dic
			if(this.map_visible_type_dic){
				for(let level in this.map_visible_type_dic){
					if(!Util.IsTableEmpty(this.map_visible_type_dic[level]) && Number(level) > max_level){
						max_level = Number(level)
					}   
				}
				if(max_level != null){
					visible_type_dic = this.map_visible_type_dic[max_level]
				}
			}

			if(visible_type_dic){
				let bool = true
				for(let visible_type in visible_type_dic){
					if(!visible_type_dic[visible_type]){
						bool = false
					}
				}

				this.map_parent.visible = this.mini_scene_bg.visible = bool
				if(this._backgroup_img){
					this._backgroup_img.visible = bool
				}
				if(this._middle_img1){
					this._middle_img1.visible = bool
				}
				if(this._middle_img2){
					this._middle_img2.visible = bool
				}
			}
			else{
				this.map_parent.visible = this.mini_scene_bg.visible = true
				if(this._backgroup_img){
					this._backgroup_img.visible = true
				}
				if(this._middle_img1){
					this._middle_img1.visible = true
				}
				if(this._middle_img2){
					this._middle_img2.visible = true
				}
			}
		}
	}

	public static GetInstance() {
		if (!MapManager._instance) {
			MapManager._instance = new MapManager();
		}
		return MapManager._instance;
	}
}
window["GridInfo"] = GridInfo;
window["AreaInfo"] = AreaInfo;
window["MapElement"] = MapElement;

window["MapManager"] = MapManager