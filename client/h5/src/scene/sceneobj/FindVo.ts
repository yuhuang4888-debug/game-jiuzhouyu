import { EventDispatcher } from "../../util/EventDispatcher"
import { Vector2 } from "../../util/Vector2"

/*
findvo寻路信息结构体
*/
export class FindVo extends EventDispatcher {
	public static SCENE = 0
	public static NPC = 1
	public static MONSTER = 2
	public static PLAYER = 3
	public static POINT = 4
	public static Figure = 5
	public static Thinking = 6
	public static DOOR = 7
	public static Fishing = 8


	public static CallType = {
		FiledGuaJi: 1,					//野外挂机
	}
	
	type: number
	sceneId: number
	id: number
	x: number
	y: number
	call_type: number
	range: number
	call_back:any
	is_task_find_way
	public constructor() {
		super()

		this.type = 0  //0场景，1,npc，2，怪物,3,其他玩家
		this.sceneId = 0  //
		this.id = 0  //
		this.x = -1  //
		this.y = -1  //
		this.call_type = 0   //回调参数（客户端用）
		this.range = 0   	 //距目标点范围
	}

	public getPoint() {

		return new Vector2(this.x, this.y)
	}
}

window["FindVo"] = FindVo