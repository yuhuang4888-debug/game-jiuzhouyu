// console.warn("HashEventDispatcher@EventDispatcher")
import { EventDispatcher } from "../util/EventDispatcher";
// console.warn("HashEventDispatcher@IBaseClass")
import { HashObject, IBaseClass } from "./BaseClass";
// TypeScript file
// console.warn("HashEventDispatcher")
export class HashEventDispatcher extends EventDispatcher implements IBaseClass {
    $hashCode: number;
    public constructor() {
        super();
        this.$hashCode = new HashObject().hashCode;
    }
    public get hashCode(): number {
        return this.$hashCode;
    }
}

window["HashEventDispatcher"] = HashEventDispatcher