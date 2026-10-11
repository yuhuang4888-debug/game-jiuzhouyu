import { HashEventDispatcher } from "../common/HashEventDispatcher";
import { Vector2 } from "../util/Vector2";
import { LayerManager, Enum_UILayer } from "../common/LayerManager";
import { MapManager } from "./MapManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventName, SceneEventType } from "../common/EventName";
import { Set3DLocalPosition, Util } from "../util/Util";
import { ViewManager } from "../common/ViewManager";
import { SceneObj } from "./sceneobj/SceneObj";
import { SettingModel } from "../commonModel/SettingModel";
let local_Set3DLocalPosition = Set3DLocalPosition
let local_Vector2 = Vector2
export class CameraManager extends HashEventDispatcher {
	private static _instance: CameraManager;
	private _camera_pos: Vector2 = new local_Vector2(0, 0);
	private _scene_layer: Laya.Sprite = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Scene);
	private _half_stage_width = LayerManager.GetInstance().stageWidth * 0.5;
	private _half_stage_height = LayerManager.GetInstance().stageHeight * 0.5;
	public main_camera:Laya.Camera
	curr_size = 1;
	base_size = 1;
	private _shake_info_list = [];
	private _need_updating = false;
	//摄像头缓动参数
	private _max_speed_move = 1000;
	private _is_start_move = false;
	private _curr_move_pos_x = 0;
	private _curr_move_pos_y = 0;
	private _end_pos_x = 0;
	private _end_pos_y = 0;
	private _move_dir = new local_Vector2();
	private _total_dist = 0;
	private _update_average_time_queue = [];
	private _mainrole_move_average_time = 0;
	private _scene_layer_y_off = 100;
	private _main_role
	private _curr_shake_pos = new local_Vector2()
	//当前震屏的场景缩放值
	private _curr_shake_scene_scale = 1
	//当前帧的场景缩放值
	private _curr_base_scale = 1
	//当前需要更新的场景缩放值
	public new_base_scale = 1
	//缩放差值
	private _base_scale_max_change = 0
	//缩放速度
	private _change_scale_speed = 4.5 
	//坐骑上或者将神状态下的场景缩放值
	public static HORSE_OR_GOD_SCALE = 1.15
	//主角的跳跃高度与该缩放因子相乘得到最终的场景缩放值
	private _height_to_scale_factor = 0.000625
	//缓动橡胶效果的距离
	private _move_elastic_distance = 150
	//当前帧知否有修改缩放值
	private _curr_frame_scale_change = false

	//当前的单向震屏值 技能id作为key值，因为可能存在多个技能一起放单向技能
	private _curr_shake_one_way_scale = {}

	//第二段开始的时候第一段还没结束，就需要保存起来第二段，等第一段结束后再执行第二段  技能id作为key值，因为可能存在多个技能一起放单向技能
	private _waitfor_shake_one_way_vo = {}

	/**
	 * 当前帧知否有修改位置值的标识 1没改变，2有改变 3有改变并且已经更新完
	 * */
	private _curr_frame_pos_change_flag = 1

	// public static CHANGE_SCENE_SCALE_TYPE = {
	// 	HORSE: 0x001, 		//上下坐骑缩放场景
	// 	GOD: 0x002, 	//变身将神缩放场景
	// 	JUMP: 0x004 	//跳跃缩放场景
	// }
	public orthographicVerticalSize = 12.8

	main_camera_visible_type_dic
	/**判断隐藏的优先级，值越大先判断 */
    main_camera_visible_type_level = {
		"BanquetAniManager":10
    }
	need_update_main_camera_visible


	InitEvents;
	AddAverageTime;
	GetAverageTime;
	GetCameraRatio;
	StartMove;
	StopMove;
	SetCameraPos;
	Set3DCameraPos;
	Update;
	ShakeCamera;
	ShakeOnewayEnd;
	GetTotalOnewayScale
	ClearShakeScreen
	UpdateShake;
	UpdateCamera;
	CheckInScreen;
	CheckToStopUpdate;
	WorldToViewPortY;
	WorldToViewPortX;
	ViewPortYToWorld;
	ViewPortXToWorld;
	SetBaseScale;
	SetBaseScaleByHeight;
	base_scale_by_height = 1;
	UpdateScale;
	ResetSceneSize;
	SetOrthographicVerticalSize
	SetMainCameraVisible
	UpdateMainCameraVisible
	SetMainCamera
	public constructor() {
		super();
		let _map_mgr = MapManager.GetInstance(), local_GlobalEventSystem = GlobalEventSystem, local_EventName = EventName, local_Math = Math, local_SceneEventType = SceneEventType
		let curr_scene_width = 1000, 
		curr_scene_height = 1000;
		this.ResetSceneSize = () =>
		{
			curr_scene_width = _map_mgr.GetSceneWidth();
			curr_scene_height = _map_mgr.GetSceneHeight();
		}
		
		this.InitEvents = () => {
			Laya.CallLater.I.callLater(this, () => 
			{
				this._main_role = window["Scene"].GetInstance().main_role
			})
			let onStateSizeReset = (x, y) => {
				if(!this.main_camera)
				{
					window['ResManager'].GetInstance().Preload3DScene()
				}
				if(!this._main_role)
				{
					this._main_role = window["Scene"].GetInstance().main_role
				}
				this._half_stage_width = x * 0.5;
				this._half_stage_height = y * 0.5;
				this.UpdateCamera(this._main_role.real_pos.x, this._main_role.real_pos.y, true);
				this.orthographicVerticalSize = y * 0.01
				this.SetOrthographicVerticalSize()
			};
			local_GlobalEventSystem.Bind(local_EventName.STATE_RESET_SIZE, onStateSizeReset);
		};

		this.SetOrthographicVerticalSize = () =>
		{
			let real_scale
			// if(this._curr_base_scale != 1 && !this._main_role.vo.god_id) //坐骑缩放中的时候忽略震屏的缩放
			// {
			// 	real_scale = this._curr_base_scale
			// }else
			// {
				real_scale = this._curr_base_scale * this._curr_shake_scene_scale

			// }
			this.main_camera.orthographicVerticalSize = this.orthographicVerticalSize * real_scale; //bitmap放大了多少倍 摄像机投影的尺寸就要缩小多少倍，防止模型跟着bitmap一块变大
			real_scale = 1 / (real_scale)
			this._scene_layer.scale(real_scale, real_scale)
		}
		this.AddAverageTime = (elapse_time) => {
			if (elapse_time < 0.06) {
				if (this._update_average_time_queue.length > 60) {
					this._update_average_time_queue.shift();
				}
				this._update_average_time_queue.push(elapse_time);
			}
		};
		this.GetAverageTime = () => {
			let size = this._update_average_time_queue.length;
			if (size > 0) {
				let total_time = 0;
				for (let time of this._update_average_time_queue) {
					total_time += time;
				}
				this._mainrole_move_average_time = total_time / size;
			}
			return this._mainrole_move_average_time;
		};
		this.GetCameraRatio = () => {
			return this.curr_size / this.base_size;
		};
		this.StartMove = (speed?) => {
			this._is_start_move = true;
			if (speed) {
				this._max_speed_move = speed;
			}
			else {
				this._max_speed_move = this._main_role.GetMoveSpeed();
			}
			if (this._curr_move_pos_x == 0 && this._curr_move_pos_y == 0) {
				this._curr_move_pos_x = this._main_role.real_pos.x;
				this._curr_move_pos_y = this._main_role.real_pos.y;
			}
		};
		this.StopMove = () => {
			this._is_start_move = false;
		};
		this.SetCameraPos = (x, y, force_update: boolean = false) => {
			if (force_update) {
				this._is_start_move = false;
				this._total_dist = 0;
				this.CheckToStopUpdate();
				this.UpdateCamera(x, y, force_update);
			}
			else {
				this._end_pos_x = x;
				this._end_pos_y = y;
				this._move_dir.x = this._end_pos_x - this._curr_move_pos_x;
				this._move_dir.y = this._end_pos_y - this._curr_move_pos_y;
				this._total_dist = this._move_dir.normalise();
				if(this._total_dist >= (4 * this._move_elastic_distance)) //避免缓动的两个点距离过长
				{
					this._is_start_move = false;
					this._total_dist = 0;
					this.CheckToStopUpdate();
					this.UpdateCamera(x, y, true);
				}else
				{
					this._need_updating = true;
				}

			}
			this.Set3DCameraPos()
		};
		this.Set3DCameraPos = () =>
		{
			local_Set3DLocalPosition(this.main_camera.transform,  this._camera_pos.x * 0.01, (this._camera_pos.y - this._scene_layer_y_off) * 0.01, -10);
		}
		
		this.SetBaseScale = (scale:number) =>
		{
			if(scale == 1 && (this._main_role.vo.god_id > 0 || (this._main_role.IsRide() && this._main_role.RideHorseCond()) || this._main_role.jump_height > 0)) return
			// let real_scale = scale
			// if(real_scale == 1)
			// {
			// 	real_scale = this._curr_shake_scene_scale
			// }
			let scene2d_scale = 1 / (scale)
			//缩放超过边界的情况
			if(scene2d_scale < 1 && (this._scene_layer.width * scene2d_scale < this._half_stage_width * 2 || this._scene_layer.height * scene2d_scale < this._half_stage_height * 2))
			{
				scale = 1
			}

			this.new_base_scale = scale
			this._base_scale_max_change = this.new_base_scale - this._curr_base_scale
			if(this._base_scale_max_change != 0)
			{
				this._need_updating = true
			}else
			{
				this.CheckToStopUpdate()
			}
		}
		this.SetBaseScaleByHeight = (height:number) =>
		{
			let new_scale = 1 + height * this._height_to_scale_factor
			if(this.base_scale_by_height != new_scale)
			{
				this.base_scale_by_height = new_scale
				this._main_role.SetScale(new_scale)
				if((this._main_role.vo.god_id > 0 || (this._main_role.IsRide() && this._main_role.RideHorseCond())) && new_scale < CameraManager.HORSE_OR_GOD_SCALE)//跳跃的缩放不能小于坐骑和将神的缩放
				{
					return
				}
				CameraManager.GetInstance().SetBaseScale(new_scale)
			}
		}

		this.UpdateScale =(_, elapse_time) =>
		{
			if(this._base_scale_max_change != 0)
			{
				let curr_frame_change
				if(this._base_scale_max_change > 0)
				{
					curr_frame_change = local_Math.max(elapse_time * this._change_scale_speed * this._base_scale_max_change, 0.0001)
					if(this._base_scale_max_change > curr_frame_change)
					{
						this._base_scale_max_change -= curr_frame_change
					}else
					{
						curr_frame_change = this._base_scale_max_change
						this._base_scale_max_change = 0
					}
				}else
				{
					curr_frame_change = local_Math.min(elapse_time * this._change_scale_speed * this._base_scale_max_change, -0.0001)
					if(this._base_scale_max_change < curr_frame_change)
					{
						this._base_scale_max_change -= curr_frame_change
					}else
					{
						curr_frame_change = this._base_scale_max_change
						this._base_scale_max_change = 0
					}
				}
				this._curr_base_scale += curr_frame_change
				if(curr_frame_change != 0)
				{
					this._curr_frame_scale_change = true
					if(this._base_scale_max_change == 0)
					{
						this._curr_base_scale = this.new_base_scale
					}
				}
			}
		}

		this.Update = (now_time, elapse_time) => {
			if (!this._need_updating)
				return;
			this._curr_frame_pos_change_flag = 1
			this._curr_frame_scale_change = false
			this.UpdateShake(now_time, elapse_time);
			this.UpdateScale(now_time, elapse_time);
			if (this._is_start_move == false && this._total_dist == 0) {
				this.CheckToStopUpdate();
			}
			else {
				elapse_time = this._main_role.move_update_elipse_time || elapse_time;
				let curr_step_dist = elapse_time * this._max_speed_move * (1 - (this._move_elastic_distance - this._total_dist) / this._move_elastic_distance);
				let move_end = false;
				// console.log("--------------------------------this._total_dist  curr_step_dist", this._total_dist, curr_step_dist)
				if (this._total_dist > curr_step_dist && this._total_dist > 1) {
					this._total_dist -= curr_step_dist;
				}
				else {
					curr_step_dist = this._total_dist;
					this._total_dist = 0;
					move_end = true;
				}
				if (!move_end) {
					this._curr_move_pos_x += this._move_dir.x * curr_step_dist;
					this._curr_move_pos_y += this._move_dir.y * curr_step_dist;
					this.UpdateCamera(this._curr_move_pos_x, this._curr_move_pos_y, true);
					this.Set3DCameraPos()
					this._curr_frame_pos_change_flag = 3
				}
				else {
					if (this._is_start_move == false) {
						this.CheckToStopUpdate();
						this.UpdateCamera(this._end_pos_x, this._end_pos_y, true);
						this.Set3DCameraPos()
						this._curr_frame_pos_change_flag = 3
					}
				}
			}
			if(this._curr_frame_scale_change)//场景还在缩放过程中
			{
				this.SetOrthographicVerticalSize()
				if(this._curr_frame_pos_change_flag != 3)
				{
					this._curr_frame_pos_change_flag = 2
				}
			}
			if(this._curr_frame_pos_change_flag == 2)
			{
				this.UpdateCamera(this._main_role.real_pos.x, this._main_role.real_pos.y, true);
				this.Set3DCameraPos()
			}
		};
		this.CheckToStopUpdate = () => {
			if (this._is_start_move == false && this._total_dist == 0) {
				this._curr_move_pos_x = 0;
				this._curr_move_pos_y = 0;
				if (this._base_scale_max_change == 0 && this._shake_info_list.length == 0) {
					// this._layer_manager.SetFrameRate(30)
					this._need_updating = false;
					return true
				}
			}
			return false
		};
		
		/**
		"start_time": 0.3,//震动开始的时间 单位秒
		"max_range": 30,//最大振幅 如果是缩放大小的类型，大于0表示开始缩小的幅度，小于0表示开始放大的幅度,第二段单向缩放类型的时候填0
		"shake_time": 1,//震动时长 单位秒
		"shake_speed": 600,//震动的起始速度 单位像素
		"shake_deceleration": 150,//减速度 单位像素
		"shake_one_way":0,//是否单向震屏，暂时只支持缩放类型
		"shake_start_angle": 0,//震动的起始方向 0-360，其中-1为主角朝向。如果不配这个表示用缩放大小的类型。
		"shake_random_angle" : 0//震动角度随机偏移值
		"shake_min_speed" : 1//震动衰减的最小速度，如果不配或者为0的话就默认用起始速度的0.01倍
		 */
		this.ShakeCamera = (vo, camera_infos_id, attacker:SceneObj) => {
			if(vo.shake_type) //兼容旧的配置，避免报错
			{
				vo.shake_start_angle = 0
				vo.shake_time = 0.3
			}
			vo.camera_infos_id = camera_infos_id
			if(vo.shake_start_angle != null)//有震动起始方向的说明是位移型的震动
			{
				if(!vo.shake_start_dir)
				{
					if(vo.shake_start_angle == -1 && attacker)
					{
						vo.shake_start_dir = new local_Vector2(attacker.GetDirection())
					}else
					{
						let radian = vo.shake_start_angle * local_Math.PI / 180
						vo.shake_start_dir = new local_Vector2(local_Math.cos(radian), local_Math.sin(radian))
					}
				}
				vo.add_range_dir = 1 //1正向增加 -1方向相减
			}else //大小缩放型的震动
			{
				//基本缩放不等于1 说明坐骑将神跳跃有其一的过程中，这个时候不能有缩放场景的震屏
				if(this._curr_base_scale != 1 && 
					//执行第二段的时候发现第一段的缩放已经生效，就不能return，得执行不然没法重置
					!(vo.shake_one_way && !vo.max_range && this._curr_shake_one_way_scale[vo.camera_infos_id] != 0))
				{
					return
				}
				if(vo.shake_one_way)//单向缩放
				{
					if(this._curr_shake_one_way_scale[vo.camera_infos_id] == null)
					{
						this._curr_shake_one_way_scale[vo.camera_infos_id] = 0
					}
					if(!vo.max_range) //max_range为0或者直接不配置表示第二段单向缩放
					{
						vo.second_part_one_way_scale = true//第二段
						let one_way_scale = this._curr_shake_one_way_scale[vo.camera_infos_id]
						if(!one_way_scale)//如果第一段还没震完就先保存第一段的震屏数据，等待第一段震完再执行第二段
						{
							this._waitfor_shake_one_way_vo[vo.camera_infos_id] = vo
							return
						}else
						{
							vo.max_range = -one_way_scale
							vo.shake_deceleration = -1 * local_Math.abs(vo.shake_deceleration)
						}
					}
				}
			}
			if(!vo.max_range)
			{
				return //最大值等于0不起效
			}
			else if(vo.max_range > 0)
			{
				vo.add_range_dir = 1 //1正向增加 -1方向相减
			}else if(vo.max_range < 0)
			{
				vo.add_range_dir = -1 //1正向增加 -1方向相减
			}
			vo.shake_speed = vo.shake_speed || 1
			vo.change_dir_count = 0 //改变方向的次数，用于判断周期
			vo.curr_range = 0 
			vo.shake_deceleration = vo.shake_deceleration || 0
			vo.shake_min_speed = vo.shake_min_speed || vo.shake_speed * 0.01
			vo.use_shake_min_speed = false
			vo.ds_ratio = vo.shake_deceleration / vo.shake_speed
			this._shake_info_list.push(vo);
			this._need_updating = true;
		};

		this.GetTotalOnewayScale =() =>
		{
			let final_scale = 0
			for(let camera_infos_id in this._curr_shake_one_way_scale)
			{
				final_scale += this._curr_shake_one_way_scale[camera_infos_id]
			}
			return final_scale
		}

		this.ClearShakeScreen =() =>
		{
			this._curr_shake_scene_scale = 1
			this._curr_shake_pos.x = 0
			this._curr_shake_pos.y = 0
			this._shake_info_list.length = 0
			this._curr_shake_one_way_scale = {}
			this._waitfor_shake_one_way_vo = {}
			this.SetOrthographicVerticalSize()
		}

		//单向缩放结束
		this.ShakeOnewayEnd = (i, vo) =>
		{
			this._shake_info_list.splice(i, 1);
			this._curr_frame_scale_change = true
			this._curr_shake_one_way_scale[vo.camera_infos_id] += vo.curr_range
			if(!vo.second_part_one_way_scale)//第一段单向结束
			{
				if(this._waitfor_shake_one_way_vo[vo.camera_infos_id])
				{
					if(this._curr_shake_one_way_scale[vo.camera_infos_id] > 0)
					{
						this.ShakeCamera(this._waitfor_shake_one_way_vo[vo.camera_infos_id], vo.camera_infos_id)
					}else
					{
						delete this._curr_shake_one_way_scale[vo.camera_infos_id]
					}
					delete this._waitfor_shake_one_way_vo[vo.camera_infos_id]
				}
			}else
			{
				delete this._curr_shake_one_way_scale[vo.camera_infos_id]
			}
		}
		this.UpdateShake = (_, elapse_time) => {
			let size = this._shake_info_list.length;
			if (size > 0) {
				let info, scale = 0, elapse_range;
				this._curr_shake_pos.x = 0
				this._curr_shake_pos.y = 0
				let old_range = 0
				for (let i = size - 1; i >= 0; i--) {
					info = this._shake_info_list[i];
					info.shake_speed -= info.shake_deceleration * elapse_time
					if(!info.shake_one_way && info.shake_min_speed > info.shake_speed) //衰减速度不能小于最小速度 单向震屏除外
					{
						info.shake_speed = info.shake_min_speed
						if(!info.use_shake_min_speed)
						{
							info.use_shake_min_speed = true//速度不再衰减
							info.max_range = info.curr_range
							if(info.max_range > 0)//使用最小速度后，立马朝原点出发
							{
								if(info.add_range_dir != -1)//需要反转方向的时候，change_dir_count要递增，为了判断是否左右震动一圈
								{
									info.add_range_dir = -1
									info.change_dir_count ++
								}
							}else if(info.max_range < 0)
							{
								if(info.add_range_dir != 1)
								{
									info.add_range_dir = 1
									info.change_dir_count ++
								}
							}else //最小速度到达0的位置的时候结束震屏
							{
								this._shake_info_list.splice(i, 1);
								this._curr_frame_scale_change = true
								this._curr_frame_pos_change_flag = 2
								continue
							}
						}
					}else if(info.shake_one_way && info.shake_speed <= 0)
					{
						this.ShakeOnewayEnd(i, info)
						continue
					}
					elapse_range = elapse_time * info.shake_speed;
					old_range = info.curr_range 
					info.curr_range = info.curr_range + elapse_range * info.add_range_dir;
					//达到最大值边界的时候，需要反转方向和重设下一个边界的值
					if((info.max_range > 0 && info.curr_range >= info.max_range) || (info.max_range < 0 && info.curr_range <= info.max_range))
					{
						info.curr_range = info.max_range//不能超过最大值，以免当前帧卡顿的时候震屏范围过大。
						if(info.shake_one_way)
						{
							this.ShakeOnewayEnd(i, info)
							continue
						}
						info.add_range_dir *= -1
						if(!info.use_shake_min_speed)
						{
							info.max_range = local_Math.abs(info.max_range) * local_Math.max(0,  (1 - info.ds_ratio)) * info.add_range_dir
						}else//使用最小速度的时候
						{
							info.max_range = local_Math.abs(info.max_range) * info.add_range_dir
						}
						info.change_dir_count ++
					}else if(info.max_range == 0 && old_range * info.curr_range < 0)//边界等于0的时候 回到原点就结束震屏
					{
						this._shake_info_list.splice(i, 1);
						this._curr_frame_scale_change = true
						this._curr_frame_pos_change_flag = 2
						continue
					}

					info.shake_time -= elapse_time //配置的时间到期后不会立马结束，直到震动回原点才结束。单向缩放的除外
					if(info.shake_one_way && info.shake_time <= 0 && !info.second_part_one_way_scale)//只有第一段单向的震屏时间才生效，第二段的只能跑完max_range才能结束
					{
						this.ShakeOnewayEnd(i, info)
						continue
					}
					if(info.curr_range == 0 || (old_range * info.curr_range < 0)) //回到原点的处理
					{
						if(info.shake_time <= 0 || info.use_shake_min_speed)//回到原点的时候发现时间已过或者已到达最小速度就可以删除该条震动数据
						{
							this._shake_info_list.splice(i, 1);
							info.curr_range = 0
						}else if(info.change_dir_count % 2 == 0 && info.shake_start_angle != null && info.shake_random_angle)//info.change_dir_count是2的倍数说明震动一周，回到原点后就可以计算下一次震动的随机方向
						{
							let random_angle = (local_Math.random() * 2 - 1) * info.shake_random_angle + info.shake_start_angle 
							let radian = random_angle * local_Math.PI / 180
							info.shake_start_dir.x = local_Math.cos(radian)
							info.shake_start_dir.y = local_Math.sin(radian)
						}
					}
					if (info.shake_start_angle != null)//有震动起始方向的说明是位移型的震动
					{
						this._curr_shake_pos.x += info.shake_start_dir.x * info.curr_range
						this._curr_shake_pos.y += info.shake_start_dir.y * info.curr_range
						this._curr_frame_pos_change_flag = 2
					}else
					{
						scale += info.curr_range
						this._curr_frame_scale_change = true
					}
				}
				let final_shake_one_way_scale = this.GetTotalOnewayScale()
				if (this._shake_info_list.length == 0) {
					this._curr_shake_scene_scale = 1 + final_shake_one_way_scale
					this._curr_shake_pos.x = 0
					this._curr_shake_pos.y = 0
					this.CheckToStopUpdate();
				}else
				{
					let new_shake_scale = 1 + scale + final_shake_one_way_scale
					let real_scale = this._curr_base_scale
					if(real_scale == 1) //坐骑或者将神缩放中的时候忽略震屏的缩放
					{
						real_scale = new_shake_scale
					}
					let scene2d_scale = 1 / (real_scale)
					//缩放超过边界的情况
					if(scene2d_scale < 1 && (this._scene_layer.width * scene2d_scale < this._half_stage_width * 2 || this._scene_layer.height * scene2d_scale < this._half_stage_height * 2))
					{
						if(this._curr_shake_scene_scale == 1 + final_shake_one_way_scale)
						{
							this._curr_frame_scale_change = false
						}else
						{
							this._curr_shake_scene_scale = 1 + final_shake_one_way_scale
						}
						return
					}
					this._curr_shake_scene_scale = new_shake_scale
				}
			}
		};
		
		this.UpdateCamera = function (x, y, force_update: boolean = false) {
			x += this._curr_shake_pos.x
			y += this._curr_shake_pos.y
			let _camera_pos = this._camera_pos
			if (_camera_pos.x == x && _camera_pos.y == y && force_update == false && !this._curr_frame_scale_change) {
				return;
			}
			let _scene_layer = this._scene_layer
			let curr_scale = _scene_layer.scaleX || 1
			let pos_off, 
			y_off = this._scene_layer_y_off * curr_scale,
			h_w = this._half_stage_width, 
			h_h = this._half_stage_height
			_scene_layer.pivotX = 0
			_scene_layer.pivotY = 0
			if (curr_scene_width <= 2 * h_w) {
				_camera_pos.x = h_w / curr_scale;
			}
			else {
				pos_off = local_Math.floor(x * curr_scale - h_w + 0.5);
				if (pos_off > 0) {
					if (x > (curr_scene_width - h_w / curr_scale)) {
						_camera_pos.x = curr_scene_width - h_w / curr_scale;
					}
					else {
						_camera_pos.x = x;
					}
				}
				else {
					_camera_pos.x = h_w / curr_scale;
				}
			}
			_scene_layer.x = h_w - _camera_pos.x;

			let h_o = h_h + y_off
			if (curr_scene_height <= 2 * h_h) { //场景尺寸不足以全屏的时候,固定摄像机中心的高度为h_o
				_camera_pos.y = h_o / curr_scale;//场景坐标是基于场景缩放后的值，缩小后会比屏幕坐标密集一些
			}
			else {
				pos_off = local_Math.floor(y * curr_scale - h_o + 0.5);//y是基于场景缩放后的值，缩小后会比屏幕坐标密集一些，跟屏幕高度比较的时候需要转化回来对应单位
				if (pos_off > 0) {
					if (y >= (curr_scene_height - (h_h - y_off) / curr_scale)) {//主角在最后半屏的情况
						_camera_pos.y = curr_scene_height - (h_h - y_off) / curr_scale;
					}
					else { //2d场景和3d模型摄像机同时向下偏移固定值
						_camera_pos.y = y;
					}
				}
				else {
					_camera_pos.y = h_o / curr_scale;
				}
			}
			_scene_layer.y = h_o - _camera_pos.y;//虽然this._scene_layer缩放了，但是相对于父容器的坐标是不缩放的，为了确保摄像机中心的高度为h_o， 那么必须满足等式h_o = _camera_pos.y + _scene_layer.y


			_scene_layer.pivotX = _camera_pos.x
			_scene_layer.pivotY = _camera_pos.y
			_scene_layer.x = _scene_layer.x + _scene_layer.pivotX 
			_scene_layer.y = _scene_layer.y + _scene_layer.pivotY
			// console.log("_camera_pos.x, _camera_pos.y", _camera_pos.x, _camera_pos.y)
			local_GlobalEventSystem.Fire(local_SceneEventType.CAMERA_MOVE, _camera_pos.x, _camera_pos.y);
		};
		this.CheckInScreen = (x, y, half_w = 0, h = 0) => {
			if (x + half_w < this._camera_pos.x - this._half_stage_width || x - half_w > this._camera_pos.x + this._half_stage_width
				|| y < this._camera_pos.y - this._half_stage_height + 80 || y > this._camera_pos.y + this._half_stage_height + h - 150) {
				return false;
			}
			return true;
		};
		this.ViewPortXToWorld = (x: number) => {
			return x / this._scene_layer.scaleX + (this._scene_layer.pivotX - this._half_stage_width / this._scene_layer.scaleX);
		};
		this.ViewPortYToWorld = (y: number) => {
			return y / this._scene_layer.scaleY + (this._scene_layer.pivotY - (this._half_stage_height + this._scene_layer_y_off) / this._scene_layer.scaleY);
		};
		this.WorldToViewPortX = (x: number) => {
			return (x - (this._scene_layer.pivotX - this._half_stage_width / this._scene_layer.scaleX)) * this._scene_layer.scaleX;
		};
		this.WorldToViewPortY = (y: number) => {
			return (y - (this._scene_layer.pivotY - (this._half_stage_height + this._scene_layer_y_off) / this._scene_layer.scaleY)) * this._scene_layer.scaleY;
		};
		this.SetMainCameraVisible = (visible_type, visible, need_refresh = true) => {
			if(this.main_camera_visible_type_dic == null){
				this.main_camera_visible_type_dic = {}
			}
			let level = this.main_camera_visible_type_level[visible_type] || 0
			if(this.main_camera_visible_type_dic[level] == null){
				this.main_camera_visible_type_dic[level] = {}
			}
	
			if(visible == null){
				delete this.main_camera_visible_type_dic[level][visible_type]
			}
			else{
				this.main_camera_visible_type_dic[level][visible_type] = visible
			}
	
			if(need_refresh){
				if(this.main_camera){
					this.UpdateMainCameraVisible()
				}
				else{
					this.need_update_main_camera_visible = true
				}
			}
		}
		this.UpdateMainCameraVisible = () =>{
			let max_level = 0, visible_type_dic
			if(this.main_camera_visible_type_dic){
				for(let level in this.main_camera_visible_type_dic){
					if(!Util.IsTableEmpty(this.main_camera_visible_type_dic[level]) && Number(level) > max_level){
						max_level = Number(level)
					}   
				}
				if(max_level!=null){
					visible_type_dic = this.main_camera_visible_type_dic[max_level]
				}
			}

			if(visible_type_dic){
				let bool = true
				for(let visible_type in visible_type_dic){
					if(!visible_type_dic[visible_type]){
						bool = false
					}
				}
				this.main_camera.active = bool
				this.main_camera.enableRender = bool
			}
			else{
				this.main_camera.active = true
				this.main_camera.enableRender = true
			}
		}
		this.SetMainCamera = (main_camera:Laya.Camera) =>{
			this.main_camera = main_camera
			if(this.need_update_main_camera_visible){
				this.need_update_main_camera_visible = undefined
				this.UpdateMainCameraVisible()
			}
		}
		this.InitEvents();
	}

	public static GetInstance() {
		if (!CameraManager._instance) {
			CameraManager._instance = new CameraManager();
		}
		return CameraManager._instance;
	}
}

window["CameraManager"] = CameraManager