import { BaseClass } from "../common/BaseClass";
import { MapManager } from "./MapManager";
import { ResManager } from "../common/ResManager";
import { LOAD_QUEUE } from "../util/DeclareGlobalVar";
import { Config } from "../common/Config";
import { Util } from "../util/Util";
// TypeScript file
let local_Util = Util
let local_Laya = Laya
let local_LOAD_QUEUE = LOAD_QUEUE
export class MapTile extends BaseClass {
	tile: Laya.Sprite;
	row = -10; //行
	col = -10; //列
	parent;
	LoadTextureComplete;
	Load;
	public Clear: Function;
	public constructor(parent) {
		super();
		let _map_mgr = MapManager.GetInstance();
		let _res_mgr = ResManager.GetInstance();
		this.tile = new Laya.Sprite();
		// this.tile.touchEnabled = false;
		this.parent = parent;
		this.tile.width = 256;
		this.tile.height = 256;
		let onPC = Laya.Browser.onPC
		// this.tile.cacheAsBitmap = true
		this.parent.addChild(this.tile);
		// let cache_texture_pool = window["cache_texture_pool"]
		// let cache_texture2d_pool = window["cache_texture2d_pool"]
		let ktx_scene = Config.PRELOAD_CLIENT_CONFIG.ConfigClientScene.ktx_scene
		this.LoadTextureComplete = (texture, url: string, call_back, curr_scene_id, curr_row, curr_col) => {
			if (curr_scene_id == _map_mgr.GetResID() && curr_row == this.row && curr_col == this.col) {
				this.tile.texture = texture// Laya.loader.getRes(url);
				if (call_back) {
					call_back();
				}
			}
		};
		this.Load = (row: number, col: number, call_back?: Function) => {
			if (this.row == row && this.col == col)
				return;
			this.row = row;
			this.col = col;
			if (row <= 0 || col <= 0 || row > _map_mgr.total_tile_max_count_y || col > _map_mgr.total_tile_max_count_x) {
				this.Clear(false);
				this.tile.x = -_map_mgr.GetTileSize();
				this.tile.y = -_map_mgr.GetTileSize();
				return;
			}
			if (this.tile.texture) {
				// _res_mgr.DestroyAllReferenceRes(this.hashCode, true);
				// this.tile.texture.destroy(true)
				// cache_texture_pool.push(this.tile.texture)
				// if(this.tile.texture.bitmap)
				// {
				// 	this.tile.texture.bitmap.destroy()
				// 	this.tile.texture.bitmap = null
				// 	// cache_texture2d_pool.push(this.tile.texture.bitmap)
				// }
				this.tile.texture = null
				// 	_res_mgr.DestroyAllReferenceRes(this.hashCode);
			}
			this.tile.x = (col - 1) * _map_mgr.GetTileSize();
			this.tile.y = (row - 1) * _map_mgr.GetTileSize();
			
			// this.tile.name = col+"_"+row
			let curr_scene_id = _map_mgr.GetResID(), row_str = row < 10 ? "0" + row : row, col_str = col < 10 ? "0" + col : col, res_name = `${row_str}${col_str}`;
			let url
			if(local_Util.use_ktx && ktx_scene[curr_scene_id])
			{
				url = `resource/game/scene/map/${curr_scene_id}/tile/${res_name}.ktx`
			}else
			{
				url = `resource/game/scene/map/${curr_scene_id}/tile/${res_name}.jxr`
			}
			// console.log("----------------load maptile----------------", url)
			_res_mgr.GetResByUrl(this.hashCode, url , this.LoadTextureComplete, this, local_Laya.Loader.IMAGE, local_LOAD_QUEUE.LOW, false, this, false, url, call_back, curr_scene_id, row, col);
		};
		this.Clear = (clear_res = true) => {
			this.tile.texture = null;
			if (clear_res) {
				_res_mgr.DestroyAllReferenceRes(this.hashCode);
			}
			this.row = -10;
			this.col = -10;
		};
	}
}

window["MapTile"] = MapTile