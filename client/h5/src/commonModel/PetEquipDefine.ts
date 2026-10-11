import { RedKey } from "./../common/RedDotDefine"
import { ModuleType } from "../common/RedDotManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"

export enum PetEquipType {
	HORSE = 1,
	PARTNER = 2
}
export enum PetEquipWholeType {
	STREN = 12,
	STAR = 14,
	STAGE = 13
}
export const PetEquipDefine = {
	BAG_DEFAULT_COUNT: 21,	//背包默认格子数量
	HORSE_TYPE_ID: 46,		//坐骑物品type
	PARTNER_TYPE_ID: 48,	//精灵物品type
	EQUIP_POS_COUNT: 4,	//部位数量
	HORSE_OPEN_LV: 220,	//坐骑开启等级
	PARTNER_OPEN_LV: 220	//精灵开启等级
}
export const PetEquipEvent = {
	REQUEST_PROTO: "PetEquipEvent.REQUEST_PROTO",
	UPDATE_INFO: "PetEquipEvent.UPDATE_INFO",
	UPGRADE_SUCCESS: "PetEquipEvent.UPGRADE_SUCCESS",
	STAR_SUCCESS: "PetEquipEvent.STAR_SUCCESS",
	REQUEST_STREN: "PetEquipEvent.REQUEST_STREN",
	UPDATE_RED_STATUS: "PetEquipEvent.UPDATE_RED_STATUS",
	SELECT_STRENITEM: "PetEquipEvent.SELECT_STRENITEM",
	UPDATE_ITEM:"PetEquipEvent.UPDATE_ITEM",
}
export const PetEquipTypeList = [
	PetEquipType.HORSE,
	PetEquipType.PARTNER
]

export const PetEquipData = {
	1: { mType: UI_MODEL_TYPE.HORSE },
	2: { mType: UI_MODEL_TYPE.PARTNER }
}

export const PetHorseRedList = [
	ModuleType.PEH_EQUIP,
	ModuleType.PEH_STREN,
	ModuleType.PEH_STAR
]

export const PetPartnerRedList = [
	ModuleType.PEP_EQUIP,
	ModuleType.PEP_STREN,
	ModuleType.PEP_STAR
]
export const PetEquipTypeRedKeyMap = {
	[PetEquipType.HORSE]: RedKey.HORSE,
	[PetEquipType.PARTNER]: RedKey.PEP,
}
export const PetEquipRedKeyMap = {
	[ModuleType.PEH_EQUIP]: RedKey.PEH_EQUIP,
	[ModuleType.PEH_STREN]: RedKey.PEH_STREN,
	[ModuleType.PEH_STAR]: RedKey.PEH_STAR,
	[ModuleType.PEP_EQUIP]: RedKey.PEP_EQUIP,
	[ModuleType.PEP_STREN]: RedKey.PEP_STREN,
	[ModuleType.PEP_STAR]: RedKey.PEP_STAR
}

export const PetEquipStarMaxDic = {
	["1@1"]: { star: 200, stage: 200 },
	["1@2"]: { star: 200, stage: 200 },
	["1@3"]: { star: 200, stage: 200 },
	["1@4"]: { star: 200, stage: 200 },
	["2@1"]: { star: 200, stage: 200 },
	["2@2"]: { star: 200, stage: 200 },
	["2@3"]: { star: 200, stage: 200 },
	["2@4"]: { star: 200, stage: 200 }
}

window["PetEquipDefine"] = PetEquipDefine

window["PetEquipWholeType"] = PetEquipWholeType
window["PetEquipType"] = PetEquipType
window["PetEquipEvent"] = PetEquipEvent
window["PetEquipTypeList"] = PetEquipTypeList
window["PetEquipData"] = PetEquipData
window["PetHorseRedList"] = PetHorseRedList
window["PetPartnerRedList"] = PetPartnerRedList
window["PetEquipStarMaxDic"] = PetEquipStarMaxDic