import { BaseClass } from "../common/BaseClass";
import { Util, DEVICE_OS } from "../util/Util";
import { ResManager } from "../common/ResManager";
export class DropManager extends BaseClass {
	_pool_ab_count
	_pool_container
	_pool_list
	is_load_effect
	ref_count_list

	// let Array_New = Array.New
	static Instance
	public constructor(){
		super() 
		
		DropManager.Instance = this

		//assetbundle包资源引用列表
		this.ref_count_list = []
		//资源对象池
		this._pool_list = []

		//对象池总ab包对象数量
		this._pool_ab_count = 0

		this.is_load_effect = false
	}

	public static GetInstance(){ 
		
		if (DropManager.Instance == null ) {
			DropManager.Instance =  new DropManager()
		}
		return DropManager.Instance
	}


	public CreateDropEffectToPool(){ 
		

		if (this.is_load_effect ) {
			return
		}

		this.is_load_effect = true
		
		/*
		
			401420——2112_2 粉色
			401419——2112_3 红色
			401418——2112_1 橙色
		
		*/

		let effect_res_list = ["function_common_getobj01","function_common_getobj02","function_common_getobj03"]


		let load_effect_count = effect_res_list.length
		let cur_effect_index = 1

		let load_effect_func =()=> {
			if (cur_effect_index <= load_effect_count ) {
				let res = effect_res_list[cur_effect_index]
				cur_effect_index = cur_effect_index + 1
				let load_call_back =(obj)=> {
					if (obj) {
						let effect_go = obj
						this.AddObjToPool(this, res, res, effect_go)
					}
					setTimeout(load_effect_func,0.1)
				}
				let ignore_pool = true
				// ResManager.GetInstance().LoadPrefab(this, res, res, load_call_back, ignore_pool)
			}
		}
		load_effect_func()
	}

	//添加游戏对象进入缓存池 通过loadPrefab加载的资源对象
	public AddObjToPool(ref_tar?, abName?, resName?, gameObject?, alpha?, is_default_color?){ 
		
		if (gameObject ) {
			//非静态缓存对象
			if (abName ) { 
				this.CreateABObjPool(abName)
				let res_list = this._pool_list[abName]["res_name_list"][resName]
				if (res_list == null ) {
					res_list = []
					this._pool_list[abName]["res_name_list"][resName] = res_list
				}

				if (! Util.IsNull(gameObject) ) {
					//放入缓存后减少引用计数
					gameObject.transform.SetParent(this._pool_list[abName].container)
					res_list.PushBack(gameObject)
				}
			}
		}
	}

	//添加缓存对象时初始化缓存信息
	public CreateABObjPool(abName?){ 
		
		if (! this._pool_container ) {
			this._pool_container = null
			//UiFactory.CreateChild(panelMgr.GetParent("SceneObjContainer"), UIType.EmptyObject, "obj_drop_pool_container").transform
			this._pool_container.visible = false 
		}
		
		
		if (this._pool_list[abName] == null ) {
			this._pool_ab_count = this._pool_ab_count + 1
			this._pool_list[abName] = {
				res_name_list : [], 
				container : null//UiFactory.CreateChild(this._pool_container, UIType.EmptyObject, abName + "_container").transform
			}
		}
	}

	//从缓存池中获取游戏对象
	public GetObjFormPool(ref_tar?, abName?, resName?){ 
		if (this._pool_list[abName] && this._pool_list[abName]["res_name_list"][resName] ) {
			let gameObject = this._pool_list[abName]["res_name_list"][resName].PopBack()
			if (gameObject ) {
				return gameObject
			}
		}
	}

	//清除所有缓存池游戏对象，切换场景时调用
	public ClearAllObjPool(){ 
		
		if (! this._pool_container ) {
			return
		}

		this._pool_container.gameObject.destroy()
		this._pool_container = null

		this._pool_list = []
		this._pool_ab_count = 0
		this.is_load_effect = false
	}

}
window["DropManager"] = DropManager