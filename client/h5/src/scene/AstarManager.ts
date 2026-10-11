import { MapElement } from "./MapManager";
import { OpenItemHeap, OpenItem } from "./OpenItemHeap";
import { Vector2 } from "../util/Vector2";
import { GameMath } from "../util/GameMath";
// TypeScript file
export enum ASTART_DIR {
	DIR_S = 0,
	Dir_LU,
	Dir_U,
	Dir_RU,
	Dir_L,
	Dir_RESERVED,
	Dir_R,
	Dir_LD,
	Dir_D,
	Dir_RD,
	Dir_Count
}
window["ASTART_DIR"] = ASTART_DIR;
export class PointInfo {
	public x = 0;
	public y = 0;
	public block; // 当前点已经找过了，关闭列表标示
	public g; // 当前点与起始点的实际距离
	public h; // 当前点与终点的估算距离，由CalH计算
	public parant: PointInfo;
	public dir; // 当前点与parant的方向
	public Reset() {
		this.x = 0;
		this.y = 0;
		this.block = false;
		this.g = 0;
		this.h = 0;
		this.dir = 0;
		this.parant = null;
	}
}
export class Point {
	public x;
	public y;
	public constructor(x: number | Point = 0, y: number = 0) {
		if (typeof x != "number") {
			this.x = x.x;
			this.y = x.y;
		}
		else {
			this.x = x;
			this.y = y;
		}
	}
}
window["ASTART_DIR"] = ASTART_DIR;
window["PointInfo"] = PointInfo;
window["Point"] = Point;
export class AstarManager {
	public ZONE_TYPE_NONE = 0;
	public ZONE_TYPE_BLOCK = 1;
	public ZONE_TYPE_WAY = 2;
	public ZONE_TYPE_SAFE = 4;
	public ZONE_TYPE_SHIELD = 8;
	public ZONE_TYPE_JUMP = 16;
	public ZONE_TYPE_WATER = 32;
	public ZONE_TYPE_SWING = 64;
	public m_map_obj: MapElement = null;
	private m_mask_width;
	private m_mask_height;
	private m_v: Array<Array<number>>;
	private m_map: Array<Array<PointInfo>>;
	private m_open_list: OpenItemHeap = new OpenItemHeap();
	// private List<Point> m_path = new List<Point>();
	private m_start_point = new Vector2();
	private m_end_point = new Vector2();
	private m_is_init;
	private m_is_last_straight;
	private POINT_DIR = [[ASTART_DIR.Dir_LU, ASTART_DIR.Dir_U, ASTART_DIR.Dir_RU], [ASTART_DIR.Dir_L, ASTART_DIR.DIR_S, ASTART_DIR.Dir_R], [ASTART_DIR.Dir_LD, ASTART_DIR.Dir_D, ASTART_DIR.Dir_RD]];
	Dispose;
	Init;
	Clear;
	GetZoneInfo;
	NoWalk;
	FindWay;
	Reset;
	CalcWeight;
	normalise;
	GenerateInflexPoint;
	CalH;
	public constructor(m_map_obj: MapElement) {
		let self = this;
		self.m_mask_width = 0;
		self.m_mask_height = 0;
		self.m_map = null;
		self.m_v = null;
		self.m_is_init = false;
		self.m_is_last_straight = false;
		self.Dispose = function () {
			m_map_obj = null;
			self.Clear();
		};
		let Point_Info = PointInfo;
		let local_math = Math;
		let local_Vector2 = Vector2;
		let local_OpenItem = OpenItem;
		self.Init = (br: Laya.Byte, mask_width, mask_height) => {
			self.Clear();
			self.m_mask_width = mask_width;
			self.m_mask_height = mask_height;
			self.m_v = [];
			self.m_map = [];
			for (let i = 0; i < mask_width; i++) {
				self.m_v[i] = [];
				self.m_map[i] = [];
			}
			for (let x = 0; x < mask_width; x++) {
				for (let y = 0; y < mask_height; y++) {
					self.m_map[x][y] = new Point_Info();
					self.m_v[x][y] = br.readByte();
				}
			}
			self.m_is_init = true;
			return true;
		};
		self.GetZoneInfo = (logic_pos_x, logic_pos_y) => {
			logic_pos_x = local_math.floor(logic_pos_x);
			logic_pos_y = local_math.floor(logic_pos_y);
			if (logic_pos_x < 0 || logic_pos_x >= self.m_mask_width || logic_pos_y < 0 || logic_pos_y >= self.m_mask_height) {
				return self.ZONE_TYPE_BLOCK;
			}
			if (self.m_is_init && self.m_v[logic_pos_x]) {
				return self.m_v[logic_pos_x][logic_pos_y];
			}
			else {
				return self.ZONE_TYPE_BLOCK;
			}
		};
		self.NoWalk = (x, y) => {
			//是障碍点，并且不是跳跃点，在寻路线中则判断为不可行走
			x = local_math.floor(x);
			y = local_math.floor(y);
			if ((self.m_v[x] && self.m_v[x][y] & self.ZONE_TYPE_BLOCK) != 0)
				return true;
			if (m_map_obj != null && m_map_obj.DynamicBlock(x, y))
				return true;
			return false;
		};
		self.FindWay = (start_point, end_point) => {
			if (!self.m_is_init) {
				return false;
			}
			self.m_is_last_straight = false;
			// 有效性检查
			if (start_point.x < 0 || start_point.x >= self.m_mask_width || start_point.y < 0 || start_point.y >= self.m_mask_height)
				return false;
			if (end_point.x < 0 || end_point.x >= self.m_mask_width || end_point.y < 0 || end_point.y >= self.m_mask_height)
				return false;
			// self.m_path.Clear();
			self.Reset();
			self.m_start_point = start_point;
			self.m_end_point = end_point;
			if (self.NoWalk(start_point.x, start_point.y)) {
				self.m_end_point = start_point;
				return false;
			}
			if (self.NoWalk(end_point.x, end_point.y)) {
				return false;
			}
			// 起点 终点 相同，直接返回
			if (start_point.x == end_point.x && start_point.y == end_point.y) {
				return false;
			}
			let get_to_end = false;
			let cur_point = new local_Vector2(start_point);
			for (;;) {
				// 将当前点置为已经检查过
				if(!self.m_map[cur_point.x][cur_point.y])
				{
					console.warn("寻路时主角起点有问题：", cur_point.x, cur_point.y, self.m_mask_width, self.m_mask_height)
				}
				self.m_map[cur_point.x][cur_point.y].block = true;
				self.m_map[cur_point.x][cur_point.y].x = cur_point.x;
				self.m_map[cur_point.x][cur_point.y].y = cur_point.y;
				let x_begin = cur_point.x - 1;
				if (x_begin < 0)
					x_begin = 0;
				let x_end = cur_point.x + 2;
				if (x_end > self.m_mask_width)
					x_end = self.m_mask_width;
				let y_begin = cur_point.y - 1;
				if (y_begin < 0)
					y_begin = 0;
				let y_end = cur_point.y + 2;
				if (y_end > self.m_mask_height)
					y_end = self.m_mask_height;
				for (let i = x_begin; i < x_end; ++i) {
					for (let j = y_begin; j < y_end; ++j) {
						// 计算与当前点相邻的有效点，
						if (!self.m_map[i][j].block && !self.NoWalk(i, j)) {
							// 达到目的地
							if (i == end_point.x && j == end_point.y) {
								// 如果目的点和当前点不在直线上，并且斜线上有障碍
								let slash_blocked = false;
								if (i != cur_point.x && j != cur_point.y && (self.NoWalk(i, cur_point.y) && self.NoWalk(cur_point.x, j))) {
									slash_blocked = true;
								}
								if (!slash_blocked) {
									self.m_map[i][j].parant = self.m_map[cur_point.x][cur_point.y];
									self.m_map[i][j].x = i;
									self.m_map[i][j].y = j;
									get_to_end = true;
									break;
								}
								else {
									return false;
								}
							}
							let x_d = i - cur_point.x;
							let y_d = j - cur_point.y;
							let next_dir = self.POINT_DIR[x_d + 1][y_d + 1];
							if (x_d < 0)
								x_d = -x_d;
							if (y_d < 0)
								y_d = -y_d;
							let is_slash = ((x_d + y_d) == 2);
							// 计算该点的权值并将有效的压到最小堆中
							self.CalcWeight(i, j, cur_point, is_slash, next_dir);
						}
					}
				}
				if (get_to_end)
					break;
				let cant_find = true;
				let next_open = self.m_open_list.Front();
				while (next_open) {
					self.m_open_list.PopFront();
					// 找到下一个F值最小的点
					if (!self.m_map[next_open.x][next_open.y].block) {
						cur_point.x = next_open.x;
						cur_point.y = next_open.y;
						cant_find = false;
						break;
					}
					next_open = self.m_open_list.Front();
				}
				// 说明开放列表为空，那么就没有找到路径
				if (cant_find) {
					self.m_end_point = cur_point;
					return false;
				}
			}
			return true;
		};
		self.normalise = (pos) => {
			let fLength = pos.normalise();
			if (fLength > 0.0) {
				let fInvLength = 1.0 / fLength;
				pos.x *= fInvLength;
				pos.y *= fInvLength;
			}
			return fLength;
		};
		self.GenerateInflexPoint = (inflex_points: Array<Vector2>, range: number = 0) => {
			// PointInfo start_p = self.m_map[self.m_start_point.x][self.m_start_point.y];
			let cur_p = self.m_map[self.m_end_point.x][self.m_end_point.y];
			if (cur_p == null) {
				inflex_points.push(self.m_start_point);
				inflex_points.push(self.m_start_point);
				console.log("AStarFindPath.GenerateInflexPoint get error pos " + self.m_end_point.x + ":" + self.m_end_point.y);
				return;
			}
			if (range > 0.001) {
				let dir = new local_Vector2(self.m_start_point.x, self.m_start_point.y);
				// let end_pos = new Vector2(self.m_end_point.x, self.m_end_point.y);
				dir.x = self.m_end_point.x - dir.x; //Vector2.sub(self.m_end_point, dir)
				dir.y = self.m_end_point.y - dir.y; //Vector2.sub(self.m_end_point, dir)
				if (dir.normalise() <= range) {
					inflex_points.push(self.m_start_point);
					inflex_points.push(self.m_start_point);
					return;
				}
				if (self.m_is_last_straight) {
					let real_range = range;
					let cur_end_pos = new local_Vector2();
					cur_end_pos.x = self.m_end_point.x;
					cur_end_pos.y = self.m_end_point.y;
					do {
						dir.x = dir.x * real_range;
						dir.y = dir.y * real_range;
						cur_end_pos.x = local_math.floor(self.m_end_point.x - dir.x);
						cur_end_pos.y = local_math.floor(self.m_end_point.y - dir.y);
						if (GameMath.GetDistance(cur_end_pos.x, cur_end_pos.y, self.m_end_point.x, self.m_end_point.y, false) <= range * range) {
							break;
						}
						real_range -= 0.3;
						if (real_range < 0) {
							cur_end_pos.x = self.m_end_point.y;
							cur_end_pos.y = self.m_end_point.y;
							break;
						}
					} while (true);
					inflex_points.push(cur_end_pos);
					inflex_points.push(self.m_start_point);
					return;
				}
				// 曲线路径
				let last_p = cur_p;
				while (cur_p != null) {
					let tmp_x = (cur_p.x + 0.5 - self.m_end_point.x), tmp_y = (cur_p.y + 0.5 - self.m_end_point.y);
					if (range * range < tmp_x * tmp_x + tmp_y * tmp_y) {
						break;
					}
					last_p = cur_p;
					cur_p = cur_p.parant;
				}
				cur_p = last_p;
			}
			let cur_dir = -1;
			while (cur_p != null) {
				if (cur_p.dir != cur_dir || (cur_p.x == self.m_start_point.x && cur_p.y == self.m_start_point.y)) {
					inflex_points.push(new local_Vector2(cur_p.x + 0.5, cur_p.y + 0.5));
					cur_dir = cur_p.dir;
				}
				cur_p = cur_p.parant;
			}
		};
		self.Clear = () => {
			self.m_mask_width = 0;
			self.m_mask_height = 0;
			//self.m_map 
			//self.m_v
		};
		// 计算该点的权值并将有效的压到最小堆中
		self.CalcWeight = (next_x, next_y, cur_point, is_slash, next_dir) => {
			let next_p = self.m_map[next_x][next_y];
			let cur_p = self.m_map[cur_point.x][cur_point.y];
			let g = cur_p.g + (is_slash ? 14142 : 10000);
			////////////////////////////////////////////////////////////////////////////////////
			// 方向改变的时候加权，可以让寻出来的路径尽量走直线
			if (cur_p.dir != next_dir) {
				g += 8200; // 该权值越大，则在贴墙走的情况下拐点会越少
			}
			////////////////////////////////////////////////////////////////////////////////////
			//g += 4000 * CalaNearBlock(next_x, next_y);
			if (is_slash) {
				// 处理拐角(墙角)不能直接穿过的问题
				if (self.NoWalk(next_x, cur_point.y) && self.NoWalk(cur_point.x, next_y)) {
					return; // 直接return的话就是无论如何不走拐角
					//g += 99999; // 如果加上一个大的数，则是不优先走拐角，但在其他地方没有路径的时候还是会走拐角
					// 这个数字的大小可以控制是否绕路的距离
				}
			}
			if (next_p.g == 0 || next_p.g > g) {
				self.m_map[next_x][next_y].g = g;
				self.m_map[next_x][next_y].parant = cur_p;
				self.m_map[next_x][next_y].dir = next_dir; // 记录当前与parant的dir
				if (next_p.h == 0) {
					self.m_map[next_x][next_y].h = 10000 * self.CalH(next_x, next_y);
				}
				let f = self.m_map[next_x][next_y].h + self.m_map[next_x][next_y].g;
				self.m_open_list.Push(new local_OpenItem(next_x, next_y, f));
			}
		};
		// 每次寻路之前需要重置一些变量
		self.Reset = () => {
			for (let i = 0; i < self.m_mask_width; ++i) {
				for (let j = 0; j < self.m_mask_height; ++j) {
					self.m_map[i][j].Reset();
				}
			}
			self.m_open_list.Clear();
		};
		self.CalH = (pos_x, pos_y) => {
			let x_dis = pos_x - self.m_end_point.x;
			let y_dis = pos_y - self.m_end_point.y;
			// 如果用这个的话搜索结果为最短路径，但拐点可能会比较多，并且耗时较长
			//return sqrt(float(x_dis * x_dis + y_dis * y_dis));
			// 用这个的话拐点比较少，并且速度快
			if (x_dis < 0)
				x_dis = -x_dis;
			if (y_dis < 0)
				y_dis = -y_dis;
			return x_dis + y_dis;
		};
	}
}

window["AstarManager"] = AstarManager