// console.warn("BaseClass@ResManager")
// import { ResManager } from "./ResManager";
// console.warn("BaseClass")
// TypeScript file
export class HashObject
{
    private static HASH_COUNT = 0
    public constructor() {
        this.$hashCode = local_HashObject.CreateHashcode();
    }

    /**
     * 创建并返回唯一id
     * @returns 
     */
    public static CreateHashcode()
    {
        return ++local_HashObject.HASH_COUNT
    }

    /**
     * @private
     */
    $hashCode: number;
    /**
     * a unique identification number assigned to this instance.
     * @version Egret 2.4
     * @platform Web,Native
     * @language en_US
     */
    /**
     * 返回此对象唯一的哈希值,用于唯一确定一个对象。hashCode为大于等于1的整数。
     * @version Egret 2.4
     * @platform Web,Native
     * @language zh_CN
     */
    public get hashCode(): number {
        return this.$hashCode;
    }
}
var local_HashObject = HashObject
export interface IBaseClass extends HashObject{
    use_delete_method?: Boolean;
}
export class BaseClass extends HashObject implements IBaseClass {
    use_delete_method: Boolean = false;
    public constructor() {
        super();
        // console.warn("---------BaseClass--constructor----------------", this["constructor"].name)
    }
    public DeleteMe() {
        this.use_delete_method = true;
        let res_mgr:any = window["ResManager"]
        res_mgr.GetInstance().DestroyAllReferenceRes(this.hashCode);
    }
}

window["BaseClass"] = BaseClass