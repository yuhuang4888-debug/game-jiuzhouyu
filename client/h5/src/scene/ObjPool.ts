import { GameError } from "../util/GameError";
import { GetQualifiedClassName } from "../util/Util";

// TypeScript file
export enum ObjMaxCache {
	Monster = 15,
	OtherRole = 10,
	Partner = 5,
	Other = 5,
	NPC = 5,
	Sprite = 5,
	Shengqi = 5,
	Demon = 5,
	Guard = 5,
	Drop = 10,
	PS_effect = 5,
	Artifact = 30,
	Goddess = 30,
	Grave = 10,
	Envoy = 10,
	Door = 10
}
window["ObjMaxCache"] = ObjMaxCache;
export class ObjPool {
	max_create = 0;
	free_list = [];
	public constructor(max_create) {
		this.max_create = max_create;
	}
	public DeleteMe() {
		let self = this, count = self.free_list.length, obj;
		for (let index = 0; index < count; index++) {
			obj = self.free_list.shift();
			obj.DeleteMe();
		}
		self.free_list = null;
	}
	public GetObjFreeList() {
		let obj = this.free_list.shift();
		if (obj && !obj.use_delete_method) {
			obj.ResetObj();
			return obj;
		}
	}
	public ReleaseObj(obj) {
		let self = this;
		if(self.free_list.indexOf(obj) >= 0 ){
			// GameError.Instance.SendErrorToPHP("ReleaseObj Same Obj to Pool" + GetQualifiedClassName(obj))
			console.warn("ReleaseObj Same Obj to Pool" + GetQualifiedClassName(obj))
			return
		}
		if (self.free_list.length < self.max_create) {
			obj.ReleaseObj();
			self.free_list.push(obj);
		}
		else {
			obj.DeleteMe();
		}
	}
	public GetObjCount() {
		return this.free_list.length;
	}
	public ReleaseAll() {
		let self = this, count = self.free_list.length, obj;
		for (let index = 0; index < count; index++) {
			obj = self.free_list.shift();
			obj.DeleteMe();
		}
	}
}

window["ObjPool"] = ObjPool