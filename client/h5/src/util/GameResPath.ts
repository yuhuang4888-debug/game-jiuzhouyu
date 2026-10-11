
import { SceneBaseType, ModelPartName, WeaponCountInfo, WeaponProvideType, AttachNode } from "../scene/SceneConfig";
let local_SceneBaseType = SceneBaseType
// TypeScript file
export class GameResPath {
	public static GetClientConfigPath(cfg: string) {
		let cfg_name = "config";
		// if(Config.NECESSARY_CLIENT_CONFIG.hasOwnProperty(cfg))
		// {
		//	 cfg_name = "necessary_config"
		// }
		// if(Util.IsDebug())
		// {
		return `resource/${cfg_name}/client/${cfg}.json`;
		// }else
		// {
		//	 return `${cfg_name}/client/${cfg}.json`
		// }
	}
	public static GetServerConfigPath(cfg: string) {
		let cfg_name = "config";
		// if(Config.NECESSARY_SERVER_CONFIG.hasOwnProperty(cfg))
		// {
		//	 cfg_name = "necessary_config"
		// }
		// if(Util.IsDebug())
		// {
		return `resource/${cfg_name}/server/${cfg}.json`;
		// }else
		// {
		//	 return `${cfg_name}/server/${cfg}.json`
		// }
	}
	public static GetScenePath() {
		return "resource/game/scene/";
	}
	public static GetSceneObjPath() {
		return "resource/game/scene/sceneobj/";
	}
	public static GetSceneWeaponPath() {
		return "resource/game/scene/weapon/";
	}
	public static GetSceneWingPath() {
		return "resource/game/scene/wing/";
	}
	public static GetSceneHorsePath() {
		return "resource/game/scene/horse/";
	}
	public static GetEffectPath(effect_type, res_name) {
		return `resource/effect/objs/${effect_type}/${res_name}.lh`;
	}
	public static GetUIEffectPath(res_name) {
		return `resource/effect/objs/ui_effect/${res_name}.lh`
	}
	public static GetFontPath(font: string) {
		return `resource/font/${font}.fnt`
	}
	public static GetGoodsIconPath(name: string) {
		return `resource/game/goodsIcon/${name}.png`
	}
	public static GetSkillIconPath(skill_id: string) {
		return `resource/game/skillIcon/${skill_id}.png`
	}
	public static GetMonsterHeadPath(res: string) {
		return `resource/game/monsterHead/${res}.png`
	}
	public static GetMonsterBigHeadPath(res: string) {
		return `resource/game/monsterBigHead/${res}.png`
	}
	public static GetDailyIconPath(res: string) {
		return `resource/game/dailyIcon/texture/${res}.png`
	}
	public static GetFuncOpenIconPath(res: string) {
		return `resource/game/functionOpen/texture/${res}.png`
	}
	public static GetMonBookImgPath(res: string) {
		return `resource/game/monBook/other/${res}.png`
	}

	public static GetBigBgPath(res: string) {
		return `resource/game/bigBg/${res}`
	}
	public static GetAreaMapImg(scene_id: number) {
		return `resource/game/map/area_map_img/${scene_id}.jpg`
	}
	public static GetHeadPath(res) {
		return `resource/game/head/texture/${res}.png`
	}
	public static GetIcon(module, resName) {
		return `resource/game/${module}/texture/${resName}.png`
	}

	public static GetIconOtherPath(module, resName) {
		return `resource/game/${module}/other/${resName}.png`
	}

	public static GetIconJpgOtherPath(module, resName) {
		return `resource/game/${module}/other/${resName}.jpg`
	}


	public static GetIconJpg(module, resName) {
		return `resource/game/${module}/texture/${resName}.jpg`
	}

	public static GetSkillIcon(resName) {
		return `resource/game/skillIcon/${resName}.png`
	}

	public static GetDesignImage(resName) {
		return `resource/game/dsgtIcon/${resName}.png`
	}

	public static GetFont(resName) {
		return `resource/font/${resName}.fnt`
	}

	public static GetPetPath(resName) {
		return `resource/game/pet/texture/${resName}.png`
	}
	public static GetTsPath(module, resName) {
		return `resource/game/tsCrack/${module}/${resName}.png`
	}
	
	public static GetFilePath(fileName: string, resName: string) {
		return `resource/game/${fileName}/${resName}.png`;

	}

	public static GetVideoPath(fileName: string) {
		return `resource/video/${fileName}.mp4`;

	}


	public static GetModelClotheRes(obj_type, obj_id) {
		if (!obj_id || Number(obj_id) == 0) {
			return ""
		}
		let abName
		obj_type = Number(obj_type)
		switch(obj_type)
		{
			case local_SceneBaseType.God:
				abName = ModelPartName[52] + obj_id
				break;
			case local_SceneBaseType.Horse://坐骑
				abName = ModelPartName[10] + obj_id
				break;
			case local_SceneBaseType.Sprite://精灵
				abName = ModelPartName[13] + obj_id
				break;
			case local_SceneBaseType.Shengqi://圣器
				abName = ModelPartName[12] + obj_id
				break;
			case local_SceneBaseType.Partner://伙伴
				abName = ModelPartName[14] + obj_id
				break;
			case local_SceneBaseType.Demon://使魔
				abName = ModelPartName[15] + obj_id
				break;
			case local_SceneBaseType.Guard://守护天使
				abName = ModelPartName[17] + obj_id
				break;
			case local_SceneBaseType.Baby://守护天使
				abName = ModelPartName[16] + obj_id
				break;
			default:
				abName = ModelPartName[1] + obj_id
				break;
		}
		return abName
	}

	public static GetTypePath(obj_type, res_name) {
		let mName = GameResPath.GetTypeModuleName(obj_type)
		return GameResPath.GetObjectPath(mName, res_name)
	}

	public static GetTypeModuleName(obj_type) {
		let mName
		obj_type = Number(obj_type)
		switch(obj_type)
		{
			case local_SceneBaseType.Role:
			case local_SceneBaseType.MainRole:
				mName = "role"
				break;
			case local_SceneBaseType.Monster:
				mName = "monster"
				break;
			case local_SceneBaseType.Horse:
				mName = "mount"
				break;
			case local_SceneBaseType.Sprite:
				mName = "spirit"
				break;
			case local_SceneBaseType.Partner:
				mName = "pet"
				break;
			case local_SceneBaseType.Demon:
				mName = "littlepet"
				break;
			case local_SceneBaseType.Npc:
				mName = "npc"
				break;
			case local_SceneBaseType.Shengqi:
				mName = "fabao"
				break;
			case local_SceneBaseType.Baby:
				mName = "child"
				break;
			case local_SceneBaseType.Drop:
				mName = "monster"
				break;
			case local_SceneBaseType.God:
				mName = "god"
				break;
			case local_SceneBaseType.Guard:
				mName = "fairy"
				break;
			default:
				return
		}
		return mName
	}

	public static GetUIModelClotheRes(ui_obj_type, obj_id, is_wing = false) {
		if (!obj_id || Number(obj_id) == 0) {
			return ""
		}
		let ui_type = window["UI_MODEL_TYPE"]
		if (!ui_type) {
			return ""
		}
		let abName
		if (is_wing) {
			abName = ModelPartName[7] + obj_id;
		} else{
			ui_obj_type = Number(ui_obj_type)
			switch(ui_obj_type)
			{
				case ui_type.HORSE://坐骑
					abName = ModelPartName[10] + obj_id
					break;
				case ui_type.WING://翅膀
					abName = ModelPartName[7] + obj_id
					break;
				case ui_type.WEAPON://武器
					abName = ModelPartName[3] + obj_id
					break;
				case ui_type.SPRITE://精灵
					abName = ModelPartName[13] + obj_id
					break;
				case ui_type.ARTIFACT://圣器
					abName = ModelPartName[12] + obj_id
					break;
				case ui_type.PARTNER://契灵/伙伴
					abName = ModelPartName[14] + obj_id
					break;
				case ui_type.DEMON://使魔
					abName = ModelPartName[15] + obj_id
					break;
				case ui_type.GOD://降神
					abName = ModelPartName[52] + obj_id
					break;
				case ui_type.BABY://宝宝
					abName = ModelPartName[16] + obj_id
					break;
				case ui_type.GUARD:	// 守护
					abName = ModelPartName[17] + obj_id
					break;
				case ui_type.GUBAO:	// 守护
					abName = ModelPartName[18] + obj_id
					break;
				case ui_type.BACKORNAMENT:	// 背饰
					abName = ModelPartName[20] + obj_id
					break;
				case ui_type.GHOST:	// 仙灵
					abName = ModelPartName[21] + obj_id
					break;
				default:
					abName = ModelPartName[1] + obj_id
					break;
			}
		}
		return abName
	}

	public static GetUITypePath(ui_model_type, res_name) {
		let mName = GameResPath.GetUITypeModuleName(ui_model_type)
		return GameResPath.GetObjectPath(mName, res_name)
	}

	public static GetUITypeModuleName(ui_model_type) {
		ui_model_type = Number(ui_model_type)
		let mName
		let ui_type = window["UI_MODEL_TYPE"]
		if (!ui_type) {
			return
		}
		switch(ui_model_type)
		{
			case ui_type.ROLE: 
			case ui_type.MAINROLE://角色
				mName = "role"
				break;
			case ui_type.MONSTER://怪物
				mName = "monster"
				break;
			case ui_type.HORSE://坐骑
				mName = "mount"
				break;
			case ui_type.SPRITE://精灵
				mName = "spirit"
				break;
			case ui_type.WING://翅膀
				mName = "wing"
				break;
			case ui_type.WEAPON://武器
				mName = "weapon"
				break;
			case ui_type.PARTNER://契灵/伙伴
				mName = "pet"
				break;
			case ui_type.DEMON://使魔
				mName = "littlepet"
				break;
			case ui_type.ARTIFACT://圣器
				mName = "fabao"
				break;
			case ui_type.GOD://降神
				mName = "god"
				break;
			case ui_type.BABY://宝宝
				mName = "child"
				break;
			case ui_type.NPC://宝宝
				mName = "npc"
				break;
			case ui_type.GUARD:
				mName = "fairy"
				break;
			case ui_type.GUBAO: // 古宝
				mName = "faqi"
				break;
			case ui_type.BACKORNAMENT://背饰
				mName = "back"
				break;
			case ui_type.GHOST://仙灵
				mName = "ghost"
				break;
			default:
				break;
		}
		return mName
	}

	public static GetObjectPath(mName, res_name) {
		return `resource/object/${mName}/objs/${res_name}.lh`
	}

	public static GetFashionPath(res_name) {
		return `resource/object/fashion/${res_name}.jpg`
	}

	public static GetHeadRes(obj_type, obj_id) {
		if ((Number(obj_id)) == 0) {
			return
		}
		return ModelPartName[6] + obj_id
	}

	public static GetWeaponRes(obj_type, weapon_id, career, is_ui?): [any[], any[]] {
		let weapon_type = null
		if (is_ui) {
			//UIModelClass3D的type使用的是UI_MODEL_TYPE
			//判断比较不用SceneBaseType，使用UI_MODEL_TYPE
			let ui_model_type = window["UI_MODEL_TYPE"]
			if (obj_type == ui_model_type.MONSTER) {
				weapon_type = WeaponCountInfo.monster[weapon_id]
			} else {
				weapon_type = WeaponCountInfo.role[career] || WeaponCountInfo.role[weapon_id]
			}
			weapon_type = WeaponCountInfo.role[career] || WeaponCountInfo.role[weapon_id]
		} else {
			if (obj_type == local_SceneBaseType.Partner || obj_type == local_SceneBaseType.Npc || obj_type == local_SceneBaseType.Baby) {
				weapon_type = WeaponCountInfo.partner[weapon_id]
			} else if (obj_type == local_SceneBaseType.Monster) {
				weapon_type = WeaponCountInfo.monster[weapon_id]
			} else {
				weapon_type = WeaponCountInfo.role[career] || WeaponCountInfo.role[weapon_id]
			}
		}

		let weapon_attach_list = []
		let weapon_res_list: any[] = []
		switch(weapon_type)
		{
			case WeaponProvideType.SingleLeftHand:
				weapon_attach_list.push(AttachNode.LHand)
				weapon_res_list.push(ModelPartName[2] + weapon_id)
				break
			case WeaponProvideType.SingleRightHand:
				weapon_attach_list.push(AttachNode.RHand)
				weapon_res_list.push(ModelPartName[3] + weapon_id)
				break
			case WeaponProvideType.BehindHand:
				weapon_attach_list.push(AttachNode.BHand)
				weapon_res_list.push(ModelPartName[4] + weapon_id)
				break
			case WeaponProvideType.BothHand:
				weapon_attach_list.push(AttachNode.LHand)
				weapon_attach_list.push(AttachNode.RHand)
				weapon_res_list.push(ModelPartName[2] + weapon_id)
				weapon_res_list.push(ModelPartName[3] + weapon_id)
				break
			case WeaponProvideType.ThirdHand:
				weapon_attach_list.push(AttachNode.LHand)
				weapon_attach_list.push(AttachNode.RHand)
				weapon_attach_list.push(AttachNode.BHand)
				weapon_res_list.push(ModelPartName[2] + weapon_id)
				weapon_res_list.push(ModelPartName[3] + weapon_id)
				weapon_res_list.push(ModelPartName[4] + weapon_id)
				break
			default:
				break
		}
		return [weapon_attach_list, weapon_res_list]
	}

	public static GetEffectRes(obj_type, obj_id) {
		if ((Number(obj_id)) == 0) {
			return
		}
		let abName = ModelPartName[6] + obj_id
		return [abName, abName]
	}

	public static GetSkillNamePath(skill_id) {
		return `resource/game/skillName/${skill_id}.png`
	}
}

window["GameResPath"] = GameResPath