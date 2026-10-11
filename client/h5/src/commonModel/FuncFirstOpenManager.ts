import { Config } from "../common/Config";
import { EventName } from "../common/EventName";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { EventDispatcher } from "../util/EventDispatcher"
import { Util } from "../util/Util";
import { RoleManager } from "./RoleManager";

export const FuncFirstOpenKey = {
	/**
	 * 药水
	 */
	Potion : 1,
	/**
	 * 境界
	 */
	Medal : 2,
	/**
	 * 成就
	 */
	Achv :3,
	/**
	 * 装备寻宝
	 */
	EquipTreasure : 4,
	/**
	 * 符文寻宝
	 */
	RuneTreasure : 5

} as const;

export class FuncFirstOpenManager extends EventDispatcher {
	
	static Instance: FuncFirstOpenManager
	public static GetInstance() {
		if (!FuncFirstOpenManager.Instance) {
			FuncFirstOpenManager.Instance = new FuncFirstOpenManager()
		}
		return FuncFirstOpenManager.Instance
	}
	
	static MoudleId = 300
	static SubModuleId = 1

	role_mgr:RoleManager
	step = 0
	/**
	 * 测试状态 每次打开都引导
	 */
	test_state = false
	public constructor() {
		super()
		this.role_mgr = RoleManager.GetInstance()
		this.InitEvents()
	}

	InitEvents(){
		this.Bind(EventName.UPDATE_LIVELONG_COUNT, (module_id, sub_module, key)=>{
			if(module_id == FuncFirstOpenManager.MoudleId && sub_module == FuncFirstOpenManager.SubModuleId && key){
				this.UpdateStepState(key)
			}
		})
	}

	ResetData(){
		this.key_step_2_sprite_dic = undefined
		this.key_2_step_dic = undefined
	}

	CheckFuncFirstOpenState(key){
		if(this.test_state){
			return false
		}

		let cfgs = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncFirstOpenArrow
		if(!cfgs || !cfgs[key] || !cfgs[key].steps || cfgs[key].steps.length == 0){
			return false
		}
		let count = this.role_mgr.GetLivelongCount(FuncFirstOpenManager.MoudleId, FuncFirstOpenManager.SubModuleId, key)
		if(count){
			return true
		}
	}

	key_step_2_sprite_dic
	AddStepSprite(key, step, sprite){
		if(!this.key_step_2_sprite_dic){
			this.key_step_2_sprite_dic = {}
		}
		if(!this.key_step_2_sprite_dic[key]){
			this.key_step_2_sprite_dic[key] = {}
		}
		let old_sprite:Laya.Sprite = this.key_step_2_sprite_dic[key][step]
		if(old_sprite){
			if(old_sprite.destroyed){
				console.error(`------FuncFirstOpenManager@AddStepSprite@old_sprite: sprite has destroyed`)
			}
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, old_sprite);
		}
		this.key_step_2_sprite_dic[key][step] = sprite
	}

	ClearStepSprite(key, step){
		if(!this.key_step_2_sprite_dic){
			return
		}
		if(!this.key_step_2_sprite_dic[key]){
			return
		}
		delete this.key_step_2_sprite_dic[key][step]
	}

	GetStepSprite(key ,step){
		if(!this.key_step_2_sprite_dic){
			return
		}
		if(!this.key_step_2_sprite_dic[key]){
			return
		}
		return this.key_step_2_sprite_dic[key][step]
	}


	UpdateStepState(key){
		let step = this.GetStep(key)
		let sprite = this.GetStepSprite(key, step)
		if(sprite){
			let step_cfg = this.GetArrowCfg(key, step)
			if(step_cfg){
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, sprite, null, null, null, null, null, step_cfg, true);
			}
		}
	}

	key_2_step_dic
	GetStep(key){
		if(!this.key_2_step_dic){
			this.key_2_step_dic = {}
		}
		if(this.key_2_step_dic[key] == null){
			this.key_2_step_dic[key] = 1
		}
		return this.key_2_step_dic[key]
	}

	SetStep(key, step){
		if(!this.key_2_step_dic){
			this.key_2_step_dic = {}
		}
		let old_step = this.key_2_step_dic[key]
		if(old_step){
			let old_sprite:Laya.Sprite = this.GetStepSprite(key, old_step)
			if(old_sprite){
				if(old_sprite.destroyed){
					console.error(`------FuncFirstOpenManager@SetStep@old_sprite: sprite has destroyed`)
				}
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, old_sprite);
			}
		}
		this.key_2_step_dic[key] = step
		return this.CheckDone(key)
	}

	AddStep(key){
		let step = this.GetStep(key)
		step++
		return this.SetStep(key, step)
	}

	CheckDone(key){
		if(this.CheckFuncFirstOpenState(key)){
			return true
		}
		let cfgs = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncFirstOpenArrow
		if(cfgs[key]){
			let step = this.GetStep(key)
			if(step){
				let done = step > cfgs[key].steps.length
				if(done){
					this.ClearAllArrow(key)
					if(!this.test_state){
						this.role_mgr.SetLivelongCount(FuncFirstOpenManager.MoudleId, FuncFirstOpenManager.SubModuleId, key, 1)
						GlobalEventSystem.Fire(EventName.REQUEST_ROLE_PROTO, 13089, "hhh",FuncFirstOpenManager.MoudleId, FuncFirstOpenManager.SubModuleId, key)
					}
				}
				return done
			}
		}
	}

	ClearAllArrow(key){
		let dic = this.key_step_2_sprite_dic[key]
		if(dic){
			for(let step in dic){
				var sprite = dic[step]
				GlobalEventSystem.Fire(EventName.HIDE_FINGER, sprite);
			}
			delete this.key_step_2_sprite_dic[key]
		}
	}

	GetArrowCfg(key, step){
		let cfgs = Config.PRELOAD_CLIENT_CONFIG.ConfigFuncFirstOpenArrow
		return cfgs && cfgs[key] && cfgs[key].steps[step - 1]
	}
}


window["FuncFirstOpenManager"] = FuncFirstOpenManager