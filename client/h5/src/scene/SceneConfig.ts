export enum MOVE_TYPE {
	NORMOL_MOVE = 0,
	JUMP = 1,
	ACCELERATE = 2,
	DOUBLE_JUMP = 3,
	RUSH = 4,
	BLINK = 5,
	GRAVITY_START_JUMP = 6,
	GRAVITY_JUMP = 7,
	DOOR_JUMP = 8,
	PICK_DROP = 9,
	JUMP_POINT = 10,
	FIGHT_START_JUMP = 11,
	START_JUMP = 12,
	JUMP_POINT_END = 13,
	TASK_JUMP = 14,
	TASK_JUMP_UPDATE_POS = 15
}

export enum MonsterType {
	NORMAL = 0,
	COLLECT = 1,
	TASK_COLLECT = 2,
	PICK = 4,
	PRICE = 5,
	TOWER = 7,
	NOT_DEAD_COLLECT = 8,
	HAVE_COUNT_NOT_DEAD_COLLECT = 9,
	INFINITE_COLLECT = 11 //无限采集怪
}
export enum SceneBaseType {
	Unknown = 0,
	Monster = 1,
	Role = 2,
	Other = 4,
	Fake_Role = 5,//假人
	Npc = 6,
	Pet = 7,
	MainRole = 8,
	Horse = 9,
	Drop = 10,
	JumpPoint = 11,
	WayPoint = 12,
	Door = 14,
	Baby = 15,
	Sprite = 16,
	Grave = 18,	//墓碑怪
	Guard = 19, // 守护天使
	Partner = 20, //伙伴
	Demon = 21,//使魔
	Include_Horse = 50,//显示形象的同时 显示其坐骑
	God = 52,//降神
	Shengqi = 53,//圣器
	All = 100,
}

//模型部件前缀名字
//[[
// 	1 衣服
// 	2 左手
// 	3 右手
// 	4 后手
// 	5 阴影
// 	6 头
// 	7 翅膀
// 	8 家具
// 	9 头饰
// 	10 
// 	11 使魔
// ]]
export var ModelPartName = {
	[1]: "model_clothe_",
	[2]: "model_weapon_l_",
	[3]: "model_weapon_r_",
	[4]: "model_weapon_b_",
	[5]: "model_shadow_",
	[6]: "model_head_",
	[7]: "model_wing_",
	[8]: "home_furniture_",
	[9]: "model_topknot_",
	[10]: "model_mount_",
	[11]: "model_clothe_",
	[12]: "model_fabao_",
	[13]: "model_spirit_",
	[14]: "model_pet_",
	[15]: "model_littlepet_",
	[16]: "model_child_",
	[17]: "model_fairy_",
	[18]: "model_faqi_",
	[20]: "model_back_",
	[21]: "model_ghost_",
	[52]: "model_god_"
}
export var SceneModelScale = 1


//模型挂接点
export var AttachNode =
{
	Head: "head",
	LSanp: "lsanp",
	RSanp: "rsanp",
	LHand: "lhand",
	RHand: "rhand",
	BHand: "bhand",
	Root: "root",
	LFoot: "lfoot",
	RFoot: "rfoot",
	Waist: "waist",
	Ride: "ride",
	SceneObj: "SceneObj",
	Gyro: "gyro",
	Ride_Root: "ride_root",
	Wing: "wing",
	Buff: "buff",
	Hair: "hair",
	ModelObj: "modelObj",
	BackOrnament: "wing",
}


//时装部件位置
export var FashionPartPos = {
	Clothe: 1,
	Weapon: 2,
	Head: 3,
	Footmark: 4,
	Hair: 5,
	// BACK : 6,
}


// 武器装备情况
// 1:左边武器
// 2:右边武器 
// 3:后边武器
// 4:左右两边武器
// 5:左后右三边武器

export var WeaponProvideType = {
	SingleLeftHand: 1,
	SingleRightHand: 2,
	BehindHand: 3,
	BothHand: 4,
	ThirdHand: 5,
}

//每个对象类型的武器装备情况
export var WeaponCountInfo = {
	role: {
		[1]: WeaponProvideType.SingleRightHand,
		[2]: WeaponProvideType.SingleRightHand,
		[3]: WeaponProvideType.SingleRightHand,
		[4]: WeaponProvideType.SingleRightHand,
		//降神
		[1600006]: WeaponProvideType.SingleRightHand,
		[1600007]: WeaponProvideType.SingleRightHand,
		[1600008]: WeaponProvideType.SingleRightHand,
		[1600009]: WeaponProvideType.BothHand,
		[1600010]: WeaponProvideType.SingleRightHand,
		[1600011]: WeaponProvideType.BothHand,
		// [1600002] : WeaponProvideType.SingleRightHand,
		// [1600003] : WeaponProvideType.SingleRightHand,
		// [1600004] : WeaponProvideType.SingleRightHand,
		// [1600005] : WeaponProvideType.SingleLeftHand,
		// [1600006] : WeaponProvideType.SingleRightHand,

	},
	monster: {
		[6010009]: WeaponProvideType.SingleRightHand,
		[601003]: WeaponProvideType.SingleRightHand,
		[101000]: WeaponProvideType.SingleRightHand,
		[102000]: WeaponProvideType.SingleRightHand,
		[103000]: WeaponProvideType.SingleRightHand,
		[104000]: WeaponProvideType.SingleRightHand,
		[203017]: WeaponProvideType.SingleRightHand,
		[203018]: WeaponProvideType.SingleRightHand,
		[203020]: WeaponProvideType.SingleRightHand,
		[203021]: WeaponProvideType.SingleRightHand,
		[203022]: WeaponProvideType.SingleLeftHand,
		[601001]: WeaponProvideType.BothHand,

	},
	partner: {
		[2020201400]: WeaponProvideType.SingleLeftHand,
		[2020300200]: WeaponProvideType.SingleRightHand,
		[2010200600]: WeaponProvideType.SingleRightHand,
		[2020400100]: WeaponProvideType.SingleRightHand,
		[2020200300]: WeaponProvideType.SingleRightHand,
		[2020401600]: WeaponProvideType.SingleRightHand,
		[2020520300]: WeaponProvideType.SingleRightHand,
		[2020200600]: WeaponProvideType.SingleRightHand,
		[2020200800]: WeaponProvideType.SingleRightHand,
		[2020420200]: WeaponProvideType.SingleRightHand,
		[2020200900]: WeaponProvideType.SingleRightHand,
		[2020301000]: WeaponProvideType.SingleRightHand,

		[2020443100]: WeaponProvideType.BothHand,
		[2020443200]: WeaponProvideType.SingleRightHand,
		[2020443300]: WeaponProvideType.BothHand,
		[2020443400]: WeaponProvideType.SingleRightHand,
		[2010301000]: WeaponProvideType.SingleRightHand,
		[2020201200]: WeaponProvideType.SingleRightHand,
		[2020420100]: WeaponProvideType.SingleLeftHand,

		[5010073]: WeaponProvideType.SingleRightHand,
		[5010076]: WeaponProvideType.SingleRightHand,
		[5010077]: WeaponProvideType.SingleRightHand,
		[5010078]: WeaponProvideType.SingleRightHand,
		[5010079]: WeaponProvideType.SingleRightHand,

		[102010100]: WeaponProvideType.SingleRightHand,
		[102020100]: WeaponProvideType.SingleRightHand,
		[102030100]: WeaponProvideType.SingleRightHand,
		[102040100]: WeaponProvideType.SingleRightHand,
		[102050100]: WeaponProvideType.SingleRightHand,
		[203021]: WeaponProvideType.SingleRightHand,

		[2040001]: WeaponProvideType.SingleRightHand,
		[203018]: WeaponProvideType.SingleRightHand,
	}
}

export var SceneRotateX = 38
export var SceneRotateY = 180



//同场景使用小飞鞋时超过多少距离才用飞，否则用跳跃
export var FlyShoeMinDistance = 1000

export var FLY_SHOE_DISTANCE =
{
	NormalMoveDistance: 1000,
	TwoJumoDistance: 1600,
	ThreeJumpDistance: 1800,
}


//特效挂接点 前面10个表示模型身上的挂点  11 12 13表示三个位置的武器挂点  14坐骑挂接点  15模型最顶级挂接点 脱离模型 不受模型旋转的影响
export var ParticleAttachNode =
{
	[1]: AttachNode.Head,
	[2]: AttachNode.LSanp,
	[3]: AttachNode.RSanp,
	[4]: AttachNode.LHand,
	[5]: AttachNode.RHand,
	[6]: AttachNode.BHand,
	[7]: AttachNode.Root,
	[8]: AttachNode.LFoot,
	[9]: AttachNode.RFoot,
	[10]: AttachNode.Waist,
	[11]: AttachNode.LHand,
	[12]: AttachNode.RHand,
	[13]: AttachNode.BHand,
	[14]: AttachNode.Ride,
	[15]: AttachNode.SceneObj,
	[16]: AttachNode.Ride_Root,
	[17]: AttachNode.Wing,
	[18]: AttachNode.ModelObj,
}

export var NoMainroleWingRemoveParticle = {


}

export var NoMainroleRemoveWeaponParticle = {

}



export var PrintParticleInfo = (obj) => {

}

export var EffectResType = {
	UI: "ui_effect",
	Skill: "skills_effect",
	ShengQi: "fabao_effect",
	God: "god_effect",
	Demon: "littlepet_effect",
	Monster: "monster_effect",
	Horse: "mount_effect",
	Pet: "pet_effect",
	Sprite: "spirit_effect",
	Weapon: "weapon_effect",
	Wing: "wing_effect",
	Other: "other_effect",
	Buff:"buff_effect",
	BackOrnament :"back_effect",
	Ghost: "ghost_effect",
	Role: "role_effect",
	XingHe: "xinghe_effect"
}


export var NoMainroleRemoveParticle =
{
	// "101000": { career: 1, bone: "Bip001 L Hand" },
	// "601003": { bone: "model_clothe_601003_trail,model_clothe_601003_wave" },//将神波塞冬
	// "203018": { bone: "Bip001 Spine" },//将神哈迪斯
}

////区域格子标识
export enum AreaDataIndex {
	BlockType = 1,
	WalkType = 2,
	SafeType = 4,
	ShieldType = 8,
	JumpType = 16,
	WaterType = 32,
	SWingType = 64
}



window["AreaDataIndex"] = AreaDataIndex
window["WeaponProvideType"] = WeaponProvideType
window["WeaponCountInfo"] = WeaponCountInfo
window["FashionPartPos"] = FashionPartPos
window["SceneModelScale"] = SceneModelScale
window["ModelPartName"] = ModelPartName;
window["MOVE_TYPE"] = MOVE_TYPE;
window["MonsterType"] = MonsterType;
window["SceneBaseType"] = SceneBaseType;
window["AttachNode"] = AttachNode
window["ParticleAttachNode"] = ParticleAttachNode
window["NoMainroleRemoveParticle"] = NoMainroleRemoveParticle